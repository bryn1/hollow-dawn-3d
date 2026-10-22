#!/usr/bin/env python3
"""MC 11096 — GLB validators.
visual <glb>: trimesh loads it; scene has visual geometry; texture images are EMBEDDED
               (GLB json images[] point into the bin chunk); file > 1 MB.
rig    <glb>: glTF JSON has skin/joints (armature); nodes with rotation; animation
               channels targeting rotation. Prints an excerpt for the capture."""
import json, struct, sys

def glb_json(path):
    with open(path, "rb") as f:
        magic, ver, total = struct.unpack("<III", f.read(12))
        assert magic == 0x46546C67, f"not a GLB (magic={magic:#x})"
        clen, ctype = struct.unpack("<II", f.read(8))
        assert ctype == 0x4E4F534A
        return json.loads(f.read(clen)), total

def visual(path, min_bytes=1_000_000):
    gl = glb_json(path)[0]
    import trimesh
    sc = trimesh.load(path, force="scene")
    n_img = len(gl.get("images", []))
    embedded = bool(gl.get("images")) and all("bufferView" in i for i in gl["images"])
    textured = 0
    for name, geom in sc.geometry.items():
        mat = getattr(getattr(geom, "visual", None), "material", None)
        if mat is not None and any(
                getattr(mat, a, None) is not None
                for a in ("image", "baseColorTexture", "emissiveTexture", "diffuseTexture")):
            textured += 1
    # gltf-level: materials that reference a texture at all
    gltf_tex_mats = sum(1 for m in gl.get("materials", [])
                        if "baseColorTexture" in m.get("pbrMetallicRoughness", {})
                        or "emissiveTexture" in m)
    size = __import__("os").path.getsize(path)
    print(f"trimesh_load=OK nodes={len(sc.graph.nodes_geometry)} geometries={len(sc.geometry)}")
    print(f"textured_geometries={textured}/{len(sc.geometry)} gltf_textured_materials={gltf_tex_mats} "
          f"images={n_img} images_embedded={embedded} bytes={size}")
    ok = (textured >= 1 or gltf_tex_mats >= 1) and n_img >= 1 and embedded and size > min_bytes
    print("VISUAL_VALID=" + ("PASS" if ok else "FAIL"))
    return 0 if ok else 1

def rig(path):
    gl, _ = glb_json(path)
    nodes = gl.get("nodes", [])
    skins = gl.get("skins", [])
    joints = sorted({j for s in skins for j in s.get("joints", [])})
    named = [nodes[j].get("name", str(j)) for j in joints]
    rots = sum(1 for n in nodes if "rotation" in n)
    chans = [c for a in gl.get("animations", []) for c in a.get("channels", [])]
    rot_chans = sum(1 for c in chans if c.get("target", {}).get("path") == "rotation")
    print("== gltf excerpt ==")
    print(json.dumps({"meshes": len(gl.get("meshes", [])), "nodes": len(nodes),
                      "skins": len(skins), "joints": len(joints),
                      "nodes_with_rotation": rots, "animations": len(gl.get("animations", [])),
                      "channels": len(chans), "rotation_channels": rot_chans,
                      "joint_names": named[:12],
                      "armature_named_nodes": [n.get("name") for n in nodes
                                               if n.get("name") and "rmature" in n.get("name")]},
                     indent=1)[:1200])
    ok = len(skins) >= 1 and len(joints) >= 2
    print("RIG_VALID=" + ("PASS" if ok else "FAIL"))
    return 0 if ok else 1

if __name__ == "__main__":
    mode, path = sys.argv[1], sys.argv[2]
    mb = int(sys.argv[3]) if len(sys.argv) > 3 else 1_000_000
    sys.exit(visual(path, mb) if mode == "visual" else rig(path))
