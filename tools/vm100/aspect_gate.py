#!/usr/bin/env python3
"""MC 11134 — the width/height gate for loader-normalized sprites.

WHY (MC 11133 T-S2i finding): ClassMesh normalizes every batch glb UNIFORMLY
so its aabb height == the §a model height (1.42 m non-boss). A squat raw mesh
therefore inflates its horizontal extent by target_h/raw_h — dune-scarab and
enemy-hound measured 4.15/4.01x (the "4.0-4.2x" finding), ~3.9 m wide at
1.42 m tall in game. This tool measures that from the GLB's POSITION
accessor min/max (stdlib only, no GPU): the same mesh-local frame the loader
reads (VERIFIED: extents reproduced 4.0-4.2 on the old assets; the s2i live
probe measured the same axis as height 1.420).

Metrics (h = ext.y = glTF up = ClassMesh aabb.size.y):
  INFLATION = target_h/h            — how many times the 1.42 m normalization
                                      inflates horizontal extent (the finding's row)
  ASPECT    = max(ext.x,ext.z)/h    — post-normalization width/height (scale-invariant)
  NORM_W_M  = max(ext.x,ext.z) * INFLATION — real in-game width (m)
GATE (both must hold): INFLATION <= 2.0 AND ASPECT <= 2.0. Both printed per
row; neither short-circuits. (On a unit-cube TRELLIS export the inflation
leg is the binding one whenever raw_h < target_h/2.)
Usage: aspect_gate.py [--target 1.42] <glb> [<glb>...]  -> one row per glb;
exit 0 only if every row PASSes."""
import json
import struct
import sys


def glb_json(path):
    with open(path, "rb") as f:
        magic, _ver, _total = struct.unpack("<III", f.read(12))
        assert magic == 0x46546C67, f"not a GLB (magic={magic:#x})"
        clen, ctype = struct.unpack("<II", f.read(8))
        assert ctype == 0x4E4F534A
        return json.loads(f.read(clen))


def extents(path):
    """Mesh-local world extents (x,y,z) across every POSITION accessor —
    min/max are stored per accessor by the o_voxel exporter; refuse to guess
    if a file omits them (validators here measure, never interpolate)."""
    gl = glb_json(path)
    exts = []
    for mesh in gl.get("meshes", []):
        for prim in mesh["primitives"]:
            acc = gl["accessors"][prim["attributes"]["POSITION"]]
            if "min" not in acc or "max" not in acc:
                sys.exit(f"EXT-MINMAX-MISSING in {path} — cannot gate")
            exts.append((acc["min"], acc["max"]))
    if not exts:
        sys.exit(f"NO-MESH in {path}")
    return [max(mx[i] for _mn, mx in exts) - min(mn[i] for mn, _mx in exts)
            for i in range(3)]


def gate(path, target):
    x, y, z = extents(path)
    w = max(x, z)
    infl, aspect = target / y, w / y
    ok = infl <= 2.0 and aspect <= 2.0
    print(f"ASPECT {path}: EXT_M={x:.3f},{y:.3f},{z:.3f} "
          f"INFLATION={infl:.2f} ASPECT_W_H={aspect:.2f} "
          f"NORM_W_M={w * infl:.3f} NORM_H_M={target:.2f} "
          f"GATE={'PASS' if ok else 'FAIL'} (limit 2.0)")
    return ok


if __name__ == "__main__":
    args = sys.argv[1:]
    target = 1.42
    if args[:1] == ["--target"]:
        target = float(args[1])
        args = args[2:]
    # every row printed before the verdict — a gate never short-circuits (a
    # red row must not hide the row after it)
    oks = [gate(p, target) for p in args]
    sys.exit(0 if args and all(oks) else 1)
