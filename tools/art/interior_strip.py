#!/usr/bin/env python3
"""Interior-wall stripper: keep-outer-shell reduction of a generator mesh.

PROVENANCE: ported from the gate-lab P1 instrument v2 "roof rule" (MC 12320; the
strip function is the same algorithm with the same constants — artifact
.audits/20261109-1115-gate-lab/out/P1-evidence-tool-p1_strip2.py). The brief's two
named arms were tried in gate-lab and RECORDED dead on this stack, so do not
re-litigate them here:
  (a) named boolean union of exterior components: raw TRELLIS.2 outputs have ZERO
      watertight components (M1=0 on both real meshes, MC 12319/12320) — there are
      no "exterior components" to union, and self-union keeps nested shells.
  (b) voxel flood fill (the literal community claim): needs a solid partition;
      trimesh voxelized().fill() outcome recorded (row VOXELFLOOD, P1).

STACK TRUTHS (carried; same list as interior_probe.py header): operator booleans
are broken on trimesh 5.x (TypeError), vm100 venv3d has NO manifold3d, hence the
parametric cup_fixture() control (no booleans anywhere in this file's controls).

Method (the calibrated dual of the M2 probe, thresholds from interior_probe):
a WALL PAIR is (g,f) with axial distance d = |(c_f - c_g).n| in
[0.35*med_edge, DELTA_FRAC*diag], discovered by marching from c_g along BOTH
+-n_g, laterally aligned (<= 1.2*med_edge) and near-parallel (|n_f . n_g| >=
DOT_MIN). Covers co-normal duplicate skins (+1) and anti-normal welded slab walls
(-1). Asymmetry: the LOWER-support face of every pair is deleted (support
s = (c - bbox_center).n; keep-outer-shell: the outermost surface of a wall stack
wins). KNOWN LIMITATION (declared in gate-lab): legitimate facing walls closer
than 3% of the bbox diagonal are also stripped — the same class the probe scores
as interior hits.

Controls contract (--controls, exit 0 == PASS x3):
  RED nested shells     -> stripped, probe flips INTERIOR->CLEAN
  RED cup (welded slab) -> stripped, probe flips INTERIOR->CLEAN
  BAD solid sphere      -> ~unchanged (<2% tri/vol delta) and CLEAN
Usage:
  interior_strip.py --controls
  interior_strip.py <in.glb> <out.glb>
"""
import os
import sys
import time
import argparse
from collections import defaultdict

import numpy as np
import trimesh

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from interior_probe import (DELTA_FRAC, DOT_MIN, cup_fixture, load_merged,
                            probe)


def strip_roof(m, verbose=True):
    """Return (stripped_mesh, marked_count). Importable seam: the bake wrapper
    (trellis_bake_wrap.py) calls THIS, not the CLI."""
    V, F = m.vertices, m.faces
    C = m.triangles_center
    N = m.face_normals
    diag = float(np.linalg.norm(np.ptp(m.bounds, axis=0)))
    center = (m.bounds[0] + m.bounds[1]) / 2.0
    e = np.stack([np.linalg.norm(V[F[:, i]] - V[F[:, (i + 1) % 3]], axis=1)
                  for i in range(3)], axis=1)
    med_e = float(np.median(e.min(axis=1)))
    d_lo, d_hi = 0.35 * med_e, DELTA_FRAC * diag   # probe-consistent upper bound
    lat_max = 1.2 * med_e
    support = np.einsum("ij,ij->i", C - center, N)
    lo = m.bounds[0]
    cell = max(d_hi / 10.0, med_e)
    K = np.floor((C - lo) / cell).astype(np.int64)
    grid = defaultdict(list)
    for i in range(len(F)):
        grid[(int(K[i, 0]), int(K[i, 1]), int(K[i, 2]))].append(i)
    if verbose:
        print(f"strip_roof: tris={len(F)} diag={diag:.4f} med_e={med_e:.5f} "
              f"d=[{d_lo:.5f},{d_hi:.5f}] lat<={lat_max:.5f} cell={cell:.5f}",
              flush=True)
    steps = int(np.ceil((d_hi - d_lo) / cell))
    loser = np.zeros(len(F), dtype=bool)
    t0 = time.time()
    for g in range(len(F)):
        ng = N[g]
        cg = C[g]
        for sgn in (1.0, -1.0):                     # march BOTH sides
            for s in range(steps + 1):
                p = cg + ng * sgn * min(d_lo + s * cell, d_hi)
                qx, qy, qz = np.floor((p - lo) / cell).astype(np.int64)
                hit = False
                for dx in (-1, 0, 1):
                    for dy in (-1, 0, 1):
                        for dz in (-1, 0, 1):
                            for f in grid.get((int(qx + dx), int(qy + dy),
                                               int(qz + dz)), ()):
                                if f == g:
                                    continue
                                v = C[f] - cg
                                d = float(v @ ng) * sgn
                                if d < d_lo or d > d_hi:
                                    continue
                                if float(np.linalg.norm(v - (d * sgn) * ng)) \
                                        > lat_max:
                                    continue
                                if abs(float(N[f] @ ng)) >= DOT_MIN:
                                    hit = True
                                    if support[g] < support[f]:
                                        loser[g] = True
                                    else:
                                        loser[f] = True
                                    break
                            if hit:
                                break
                        if hit:
                            break
                    if hit:
                        break
                if hit:
                    break                           # first pair on this side only
            if loser[g]:
                break                               # g already deleted
        if verbose and (g + 1) % 250000 == 0:
            print(f"  face {g+1}, marked {int(loser.sum())}, "
                  f"{time.time()-t0:.0f}s", flush=True)
    if verbose:
        print(f"strip_roof: marked {int(loser.sum())}/{len(F)} "
              f"({int(loser.sum())/len(F):.3f}) in {time.time()-t0:.0f}s",
              flush=True)
    keep = ~loser
    subV, subInv = np.unique(F[keep].reshape(-1), return_inverse=True)
    out = trimesh.Trimesh(vertices=V[subV],
                          faces=subInv.reshape(F[keep].shape), process=False)
    return out, int(loser.sum())


def metrics(m, tag):
    try:
        vol = float(m.volume)
    except Exception:
        vol = float("nan")
    print(f"METRICS {tag}: tris={len(m.faces)} verts={len(m.vertices)} "
          f"is_watertight={m.is_watertight} "
          f"winding_consistent={m.is_winding_consistent} volume={vol:.6e}",
          flush=True)


def controls():
    """RED->GREEN + BAD controls; exit 0 == all three PASS (mirrors gate-lab
    p1_strip2 --controls; RED2 rebuilt parametric — stack truth in the header)."""
    ok = True
    for name, mesh, expect_int in (
            ("RED-nested", trimesh.util.concatenate([
                trimesh.creation.icosphere(3),
                trimesh.creation.icosphere(3, radius=0.95)]), True),
            ("RED-cup", cup_fixture(), True),
            ("BAD-solid-sphere", trimesh.creation.icosphere(4), False)):
        print(f"== CONTROL {name} ==", flush=True)
        was = probe(mesh, f"{name}-BEFORE")
        s, marked = strip_roof(mesh, verbose=False)
        now = probe(s, f"{name}-AFTER")
        if expect_int:
            good = was and not now
            print(f"CONTROL {name}: before={'INTERIOR' if was else 'CLEAN'} "
                  f"after={'INTERIOR' if now else 'CLEAN'} marked={marked} "
                  f"-> {'PASS' if good else 'FAIL'}", flush=True)
        else:
            dt = abs(len(s.faces) - len(mesh.faces)) / len(mesh.faces)
            dv = abs(s.volume - mesh.volume) / mesh.volume
            good = (not now) and dt < 0.02 and dv < 0.02
            print(f"CONTROL {name}: tris {len(mesh.faces)}->{len(s.faces)} "
                  f"(d={dt:.4f}) vol d={dv:.4f} marked={marked} "
                  f"after={'INTERIOR' if now else 'CLEAN'} "
                  f"-> {'PASS' if good else 'FAIL'}", flush=True)
        if not good:
            ok = False
    print(f"STRIP-CONTROLS: {'PASS' if ok else 'FAIL'}", flush=True)
    return 0 if ok else 2


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="*")
    ap.add_argument("--controls", action="store_true")
    a = ap.parse_args()
    if a.controls:
        sys.exit(controls())
    m = load_merged(a.files[0])
    metrics(m, f"{a.files[0]} BEFORE")
    s, marked = strip_roof(m)
    metrics(s, f"{a.files[1]} AFTER")
    s.export(a.files[1])
    print(f"EXPORTED {a.files[1]} bytes={os.path.getsize(a.files[1])} "
          f"marked={marked}", flush=True)
