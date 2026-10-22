"""Build synthetic GLBs to prove validate_glb.py can go green AND red."""
import trimesh, PIL.Image

img = PIL.Image.new("RGB", (256, 256), (10, 120, 200))
mat = trimesh.visual.material.PBRMaterial(baseColorTexture=img)
box = trimesh.creation.box()
uv = box.vertices[:, :2] * 0.5 + 0.5
tex = trimesh.Trimesh(vertices=box.vertices, faces=box.faces,
                     visual=trimesh.visual.TextureVisuals(uv=uv, material=mat))
tex.export("synth-textured.glb")
trimesh.creation.box().export("synth-plain.glb")
print("built synth-textured.glb synth-plain.glb")
