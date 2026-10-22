#!/usr/bin/env python3
"""MC 11108 (T-S1b) — GLB animation validator, stdlib only.

Checks against a GLB file:
  * skins >= 1, mesh has JOINTS_0/WEIGHTS_0 (real skin, not static mesh)
  * animations >= 2, each NAMED
  * every channel targets a node; print bone names targeted (rotation path)
  * every sampler input accessor is strictly monotonic increasing
  * rotation outputs are unit-ish quaternions
  * motion sanity: Hips translation path p2p range, walk/run must exceed
    1.5 m of horizontal travel (proves real baked motion, not constant keys)

Usage: 04-validate-glb.py <glb> [expect_walk_run]   -> exit 0 = PASS
"""
import json
import math
import struct
import sys

COMP_F32 = 5126
TYPE_N = {"SCALAR": 1, "VEC2": 2, "VEC3": 3, "VEC4": 4}


def load_glb(path):
    with open(path, "rb") as f:
        magic, ver, total = struct.unpack("<III", f.read(12))
        assert magic == 0x46546C67, f"not a GLB (magic={magic:#x})"
        clen, ctype = struct.unpack("<II", f.read(8))
        assert ctype == 0x4E4F534A, "first chunk must be JSON"
        gj = json.loads(f.read(clen))
        blen, btype = struct.unpack("<II", f.read(8))
        assert btype == 0x004E4942, "second chunk must be BIN"
        return gj, f.read(blen)


def accessor(gj, blob, idx):
    a = gj["accessors"][idx]
    bv = gj["bufferViews"][a["bufferView"]]
    off = bv.get("byteOffset", 0) + a.get("byteOffset", 0)
    n = TYPE_N[a["type"]]
    assert a["componentType"] == COMP_F32, f"accessor {idx} not f32"
    fmt = "<" + "f" * n * a["count"]
    vals = struct.unpack(fmt, blob[off:off + struct.calcsize(fmt)])
    return [vals[i:i + n] for i in range(0, len(vals), n)]


def main():
    path = sys.argv[1]
    strict = len(sys.argv) > 2
    gj, blob = load_glb(path)
    nodes = gj.get("nodes", [])
    fails = []

    skins = gj.get("skins", [])
    print(f"skins={len(skins)} joints={[len(s['joints']) for s in skins]}")
    if len(skins) < 1:
        fails.append("no skin")

    prims = [p for m in gj.get("meshes", []) for p in m.get("primitives", [])]
    attrs = {k for p in prims for k in p["attributes"]}
    print(f"mesh_attributes={sorted(attrs)}")
    if not {"JOINTS_0", "WEIGHTS_0"} <= attrs:
        fails.append("mesh not skinned (JOINTS_0/WEIGHTS_0 missing)")

    anims = gj.get("animations", [])
    print(f"animations={len(anims)} names={[a.get('name') for a in anims]}")
    if len(anims) < 2:
        fails.append(f"need >=2 animations, got {len(anims)}")

    rot_bones, hips_horiz = set(), {}
    for a in anims:
        name = a.get("name")
        if not name:
            fails.append("animation without name")
        for ch in a.get("channels", []):
            node = nodes[ch["target"]["node"]]
            if ch["target"]["path"] == "rotation" and node.get("name"):
                rot_bones.add(node["name"])
        for sidx, s in enumerate(a.get("samplers", [])):
            times = [v[0] if isinstance(v, list) else v for v in accessor(gj, blob, s["input"])]
            if any(b <= x for x, b in zip(times, times[1:])):
                fails.append(f"animation '{name}' sampler #{sidx} input not strictly monotonic")
            if s.get("output") is not None:
                chans = [c for c in a["channels"] if c.get("sampler") == sidx]
                for c in chans:
                    nname = nodes[c["target"]["node"]].get("name", "?")
                    if c["target"]["path"] == "rotation":
                        q = accessor(gj, blob, s["output"])
                        for vec in q[:: max(1, len(q) // 8)]:
                            nn = math.sqrt(sum(v * v for v in vec))
                            if not (0.9 < nn < 1.1):
                                fails.append(f"non-unit quaternion in '{name}' ({nname})")
                                break
                    elif c["target"]["path"] == "translation" and nname == "Hips":
                        trs = accessor(gj, blob, s["output"])
                        xs = [v[0] for v in trs]
                        zs = [v[2] for v in trs]  # glTF Y-up: horizontal = x/z
                        rng = max(math.sqrt((max(xs)-min(xs))**2 + (max(zs)-min(zs))**2),
                                  0.0)
                        hips_horiz[name] = round(rng, 2)
    print(f"rotation_targeted_bones={len(rot_bones)} excerpt={sorted(rot_bones)[:8]}")
    print(f"h_d_root_travel_m={hips_horiz}")
    if strict:
        for k in ("walk", "run"):
            if hips_horiz.get(k, 0.0) < 1.5:
                fails.append(f"motion sanity: '{k}' travel {hips_horiz.get(k)} < 1.5 m")
    for want in ("Hips", "LeftArm", "RightLeg", "Head"):
        if want not in rot_bones:
            fails.append(f"expected rotation channel on {want}")

    if fails:
        print("GLB_VALID=FAIL")
        for f in fails:
            print("  -", f)
        return 1
    print("GLB_VALID=PASS")
    return 0


sys.exit(main())
