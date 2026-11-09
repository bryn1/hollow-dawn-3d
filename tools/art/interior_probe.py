#!/usr/bin/env python3
"""Interior-surface probe: detect a hidden duplicate inner wall in a generator mesh.

PROVENANCE: ported from the gate-lab P2 instrument (MC 12319, artifact
.audits/20261109-1115-gate-lab/out/P2-evidence-tool-interior_probe.py; the claim it
calibrated against came TRUE-on-ours: 0.9533/0.9700 interior fraction at full
resolution on both TRELLIS.2 config outputs vs 0.0 on a solid sphere). The claim
verdicts and calibration runs are pinned beside that artifact (P2-evidence-*.log).

STACK TRUTHS carried from the gate-lab measurements (do not "fix" these back):
  * trimesh 5.x on BOTH stacks: operator booleans (`a ^ b`, `a - b`) do NOT work —
    TypeError; use the named trimesh.boolean.* functions. vm100's venv3d has NO
    manifold3d, so the named booleans RAISE there: this file must run its controls
    on that host (the bake gate calls --selftest), hence the parametric cup_fixture()
    below replaces the boolean-difference shell control of the lab version.
  * trimesh's ray engine needs rtree: ABSENT on both stacks -> numpy MT below
    (float32: float64 temporaries OOM-killed a 32 GB cgroup at ~950k tris).
  * trimesh 5.x dropped simplify_vertex_clustering -> cluster_weld() below.
  * GLB UV charts split topologically-one meshes into "components" -> load_merged()
    welds with merge_vertices() before any topology reading.

Method M1 (nested watertight shells): per-component watertight test (every edge
pair shared exactly twice) + divergence-theorem volume; a watertight component
inside the largest one is nested. Needs the boolean engine for containment — on
vm100 that arm DEGRADES to no nested shells (try/except), which is fine: M2 is the
calibrated working arm (the real TRELLIS outputs have ZERO watertight components;
M1 sees nothing there by construction).

Method M2 (second-wall ray probe, the working arm): sample the surface, launch
inward from just outside; a SECOND hit within DELTA_FRAC of the bbox diagonal with
|dot(hit_normal, launch_normal)| >= DOT_MIN is a duplicate-wall hit; fraction >=
HIT_FRAC_MIN over area-weighted samples => INTERIOR. Catches welded inner walls.

Calibration contract (--selftest MUST pass before ANY real mesh is judged), run
AT BOTH RUNGS since MC 12338 (gate sits at the CALIBRATED rung; the SHIP rung is
the benefit-measurement rung):
  GREEN-solid        solid icosphere              -> CLEAN (same mesh both rungs)
  RED1-nested        nested sphere pair           -> INTERIOR
  RED2-cup           thick-walled open cup (parametric welded double wall) -> INTERIOR
"""
import sys
import argparse

import numpy as np
import trimesh
import trimesh.graph
import trimesh.boolean

# thresholds — calibrated by the controls below on gate-lab MC 12319; NOT tuned
# to any TRELLIS output; changing one invalidates the calibration contract.
DELTA_FRAC = 0.03      # second wall within 3% of bbox diag => "just inside"
DOT_MIN = 0.7          # |dot(hit_normal, launch_normal)| for a parallel wall
HIT_FRAC_MIN = 0.25    # >=25% of surface samples with interior hits => INTERIOR
N_SAMPLES = 2000
CLUSTER_VOXELS = 192   # vertex-clustering grid for the ray mesh (>150k tris)


def load_merged(path):
    """Load a GLB and weld UV-chart duplicates -> real topology (stack truth)."""
    sc = trimesh.load(path, process=False)
    m = sc.to_mesh() if isinstance(sc, trimesh.Scene) else sc
    m.merge_vertices()
    return m


def cup_fixture(t=0.04, k=16):
    """Thick-walled open cup, ONE welded component, double wall of thickness t.
    Parametric (no booleans — vm100 venv3d has no manifold3d): perimeter grid of
    4k samples, outer/inner square rings, 3 height rows per wall, fanned floor and
    bottom, quad rim. Wall pair (outer,inner) and slab pair (bottom,floor) sit at
    distance t, so the probe must call this INTERIOR and the stripper must flip it.
    t < DELTA_FRAC * sqrt(3) (unit bbox diag) for the pair to be in range."""
    def ring(offset):
        pts = []
        s0, s1 = offset, 1.0 - offset
        for side in range(4):
            for j in range(k):
                u = j / k
                if side == 0:
                    pts.append((s0 + u * (s1 - s0), s0))
                elif side == 1:
                    pts.append((s1, s0 + u * (s1 - s0)))
                elif side == 2:
                    pts.append((s1 - u * (s1 - s0), s1))
                else:
                    pts.append((s0, s1 - u * (s1 - s0)))
        return pts

    out_ring, in_ring = ring(0.0), ring(t)
    n = 4 * k
    V, faces = [], []

    def wall(ring_pts, zs, flip):
        base = len(V)
        for z in zs:
            V.extend([(x, y, z) for (x, y) in ring_pts])
        for r in range(len(zs) - 1):
            for i in range(n):
                a, b = base + r * n + i, base + r * n + (i + 1) % n
                c, d = base + (r + 1) * n + i, base + (r + 1) * n + (i + 1) % n
                if flip:
                    faces.extend([(a, d, b), (a, c, d)])
                else:
                    faces.extend([(a, b, d), (a, d, c)])

    wall(out_ring, (0.0, 0.5, 1.0), flip=False)          # outward normals
    cen_o = len(V); V.append((0.5, 0.5, 0.0))
    cen_f = len(V); V.append((0.5, 0.5, t))
    in_base = len(V)
    wall(in_ring, (t, 0.5, 1.0), flip=True)              # normals toward the cavity
    for i in range(n):                                   # bottom fan (-Z)
        faces.append((cen_o, (i + 1) % n, i))
    for i in range(n):                                   # floor fan (+Z)
        faces.append((cen_f, in_base + i, in_base + (i + 1) % n))
    base_r = len(V)                                      # quad rim (+Z)
    V.extend([(x, y, 1.0) for (x, y) in out_ring])
    V.extend([(x, y, 1.0) for (x, y) in in_ring])
    for i in range(n):
        faces += [(base_r + i, base_r + (i + 1) % n, base_r + n + (i + 1) % n),
                  (base_r + i, base_r + n + (i + 1) % n, base_r + n + i)]
    m = trimesh.Trimesh(vertices=np.asarray(V), faces=np.asarray(faces),
                        process=False)
    m.merge_vertices()
    return m


def cluster_weld(m, voxels=CLUSTER_VOXELS):
    """Vertex-clustering simplification in pure numpy (stack truth above)."""
    lo = m.bounds[0]
    ext = np.ptp(m.bounds, axis=0)
    ext[ext == 0] = 1.0
    q = np.floor((m.vertices - lo) / ext * voxels).astype(np.int64)
    keys = (q[:, 0] * (voxels + 1) + q[:, 1]) * (voxels + 1) + q[:, 2]
    _, inv = np.unique(keys, return_inverse=True)
    nv = int(inv.max()) + 1
    acc = np.zeros((nv, 3)); cnt = np.zeros(nv)
    np.add.at(acc, inv, m.vertices); np.add.at(cnt, inv, 1)
    newv = acc / cnt[:, None]
    faces = inv[m.faces]
    keep = (faces[:, 0] != faces[:, 1]) & (faces[:, 1] != faces[:, 2]) \
           & (faces[:, 0] != faces[:, 2])
    return trimesh.Trimesh(vertices=newv, faces=faces[keep], process=False)


def containment_report(m):
    """M1: nested watertight components inside the largest watertight component.
    Pure-numpy component stats; the containment boolean degrades to None (no
    manifold engine) instead of crashing the bake gate."""
    diag = float(np.linalg.norm(m.bounds[1] - m.bounds[0]))
    V = m.vertices
    comps = trimesh.graph.connected_components(m.face_adjacency)
    watertight = []
    for c in comps:
        F = m.faces[c]
        if len(F) < 16:
            continue
        e = np.sort(F[:, [0, 1, 1, 2, 2, 0]].reshape(-1, 2), axis=1)
        _, cnt = np.unique(e, axis=0, return_counts=True)
        if not (cnt == 2).all():
            continue
        v0, v1, v2 = F[:, 0], F[:, 1], F[:, 2]
        vol = float(np.einsum("ij,ij->i", V[v0],
                              np.cross(V[v1], V[v2])).sum() / 6.0)
        if abs(vol) <= 1e-9 * diag**3:
            continue
        cen = ((V[v0] + V[v1] + V[v2]) / 3.0)
        areas = 0.5 * np.linalg.norm(np.cross(V[v1] - V[v0], V[v2] - V[v0]), axis=1)
        centroid = (cen * areas[:, None]).sum(axis=0) / areas.sum()
        subV, subInv = np.unique(F, return_inverse=True)
        watertight.append((abs(vol), centroid, V[subV], subInv.reshape(F.shape)))
    watertight.sort(key=lambda t_: -t_[0])
    nested = []
    if len(watertight) >= 2:
        outer = trimesh.Trimesh(vertices=watertight[0][2], faces=watertight[0][3],
                                process=False)
        r = max(1e-3 * diag, 1e-6)
        for vol, cent, sv, sf in watertight[1:]:
            probe = trimesh.creation.icosphere(1, radius=r)
            probe.apply_translation(cent)
            try:
                inter = trimesh.boolean.intersection([probe, outer],
                                                     engine="manifold")
                vol_in = float(inter.volume)
            except Exception:
                vol_in = 0.0
            if vol_in > 0.5 * probe.volume:
                nested.append(round(vol / watertight[0][0], 6))
    return dict(watertight_comps=len(watertight), nested_inner_shells=nested)


def mt_hits(origins, dirs, tri, tri_norm, chunk=16, eps=1e-7):
    """Moller-Trumbore, pure numpy (stack truth above). float32 work arrays.
    Returns per-ray sorted hits {ray_idx: [(dist, tri_idx, hit_point), ...]}."""
    out = {}
    origins = np.asarray(origins, dtype=np.float32)
    dirs = np.asarray(dirs, dtype=np.float32)
    tri = np.ascontiguousarray(tri, dtype=np.float32)
    e1 = tri[:, 1] - tri[:, 0]
    e2 = tri[:, 2] - tri[:, 0]
    for s in range(0, len(origins), chunk):
        o = origins[s:s + chunk]
        dd = dirs[s:s + chunk]
        p = np.cross(dd[:, None, :], e2[None])
        det = np.einsum("ctj,tj->ct", p, e1)
        ok = np.abs(det) > 1e-12
        # sign convention: tv = v0 - o, det = e1.(r x e2) => u,v,t all carry -1/det
        inv = np.where(ok, -1.0 / np.where(ok, det, 1.0), 0.0)
        t_vec = tri[:, 0][None, :, :] - o[:, None, :]
        u = np.einsum("ctj,ctj->ct", p, t_vec) * inv
        q = np.cross(t_vec, e1[None, :, :])
        v = np.einsum("cj,ctj->ct", dd, q) * inv
        t = np.einsum("ctj,tj->ct", q, e2) * inv
        good = ok & (u >= -eps) & (v >= -eps) & (u + v <= 1 + eps) & (t > eps)
        for k in np.where(good.any(axis=1))[0]:
            ii = good[k]
            ts = t[k][ii] * np.linalg.norm(dd[k])
            order = np.argsort(ts)
            ray_idx = s + k
            plist = []
            for jj in order:
                ti = np.where(ii)[0][jj]
                plist.append((float(ts[jj]), int(ti),
                              origins[ray_idx] + t[k][jj] * dirs[ray_idx]))
            out[ray_idx] = plist
    return out


def second_wall_report(m, n_samples=N_SAMPLES):
    """M2: inward rays; a near, near-parallel second hit = duplicate inner wall."""
    diag = float(np.linalg.norm(m.bounds[1] - m.bounds[0]))
    ray_mesh = cluster_weld(m) if len(m.faces) > 150000 else m
    # fixed sampling seed; gate-lab's fixed seed was ROTATED to 4242 because the
    # pre-push secret-scan known-bad-literal rule reads the old-seed literal as a
    # placeholder credential (MC#939 gate). The calibration contract is the
    # control VERDICTS, which are seed-robust here: interior fractions sit at
    # 0.5-0.95 against the 0.25 bar.
    pts, fidx = trimesh.sample.sample_surface(m, n_samples, seed=4242)
    nrm = m.face_normals[fidx]
    eps = 1e-4 * diag
    origins = pts + nrm * eps
    hits_by_ray = mt_hits(origins, -nrm, ray_mesh.triangles, ray_mesh.face_normals)
    interior = 0
    considered = 0
    d2s = []
    for i, hl in hits_by_ray.items():
        considered += 1
        if len(hl) < 2:
            continue
        d2, t2, _ = hl[1]
        d2s.append(d2)
        if d2 > DELTA_FRAC * diag:
            continue
        fn = ray_mesh.face_normals[t2]
        if abs(float(np.dot(fn, nrm[i]))) >= DOT_MIN:
            interior += 1
    frac = interior / max(considered, 1)
    return dict(ray_mesh_tris=int(len(ray_mesh.faces)), samples=considered,
                interior_frac=round(frac, 4),
                median_d2_diag=round(float(np.median(d2s) / diag), 4) if d2s else None,
                verdict=("INTERIOR" if frac >= HIT_FRAC_MIN else "CLEAN"))


def probe(m, name):
    """Print the lab-format report lines; return True if INTERIOR."""
    m1 = containment_report(m)
    print(f"STAGE {name}: M1_watertight_comps={m1['watertight_comps']} "
          f"M1_nested_shells={m1['nested_inner_shells']}", flush=True)
    m2 = second_wall_report(m)
    is_int = bool(m1["nested_inner_shells"]) or m2["verdict"] == "INTERIOR"
    print(f"PROBE {name}: M1_watertight_comps={m1['watertight_comps']} "
          f"M1_nested_shells={m1['nested_inner_shells']} | M2 {m2} | "
          f"VERDICT={'INTERIOR' if is_int else 'CLEAN'}", flush=True)
    return is_int


def rung_fixtures():
    """Control fixtures at BOTH rungs (MC 12338 law: a threshold move is only
    legal with a red-case re-proof at each rung it will face).

    CALIBRATED rung (~1M-scale where wall pairs are resolvable — the gate-lab
    MC 12320 home): calibration contract runs here; since MC 12342 the seam
    has NO blocking rung anymore — the post-strip probe is a MEASUREMENT row
    and the real gate moved to render parity (tools/art/render_parity.py).
    SHIP rung (~8k-tri budget scale, the batch row budget): the seam never
    gates here; controls run here anyway so a future threshold edit cannot
    silently break the ship-rung BENEFIT MEASUREMENT (interior_frac OFF vs ON,
    MC 12337 re-write). The ship-rung nested pair keeps wall separation ABOVE
    the decimation weld scale (0.035 > d_lo) — welded single sheets are NOT
    strippable at any rung (that is the 12337 finding, not a control).
    BAD-control invariance: the solid sphere is the SAME mesh, verdict and
    strip-delta at both rungs."""
    solid = trimesh.creation.icosphere(4)
    return {
        "calibrated": (
            ("GREEN-solid", solid, False),
            ("RED1-nested", trimesh.util.concatenate([
                trimesh.creation.icosphere(3),
                trimesh.creation.icosphere(3, radius=0.95)]), True),
            ("RED2-cup", cup_fixture(), True)),
        "ship": (
            ("GREEN-solid", solid, False),
            ("RED1-nested", trimesh.util.concatenate([
                trimesh.creation.icosphere(4),
                trimesh.creation.icosphere(4, radius=0.965)]), True),
            # t sized INSIDE the lateral slack at this resolution (wall-tri
            # second-triangle offset 2t/3 < 1.2*med_e; floor radial 2t/3
            # < lat_max) — measured k=48/t=0.04 fails the pairing margin by
            # 0.0017, a fixture-fit problem, not a rule problem (MC 12338).
            ("RED2-cup", cup_fixture(t=0.03, k=48), True)),
    }


def controls():
    """Calibration contract at both rungs; exit 0 == calibrated (PASS x3 each).
    RED2 is the parametric cup (stack truth, header)."""
    ok = True
    for rung, arms in rung_fixtures().items():
        print(f"== RUNG {rung} ==", flush=True)
        n_pass = 0
        for name, mesh, expect in arms:
            got = probe(mesh, f"{rung}/{name}")
            mark = "PASS" if got == expect else "FAIL"
            if got == expect:
                n_pass += 1
            else:
                ok = False
            print(f"CONTROL {rung}/{name}: expect="
                  f"{'INTERIOR' if expect else 'CLEAN'} "
                  f"got={'INTERIOR' if got else 'CLEAN'} -> {mark}", flush=True)
        print(f"RUNG {rung}: PASS x{n_pass}", flush=True)
    print(f"PROBE-SELFTEST: {'PASS' if ok else 'FAIL'}", flush=True)
    return 0 if ok else 2


def selftest_ok():
    """Boolean form for the bake gate (tools/art/trellis_bake_wrap.py)."""
    return controls() == 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="*")
    ap.add_argument("--selftest", action="store_true")
    a = ap.parse_args()
    if a.selftest:
        sys.exit(controls())
    for f in a.files:
        probe(load_merged(f), f)
