#!/usr/bin/env python3
"""MC 11118 — per-asset gate: headless bpy tri-count dump vs budget + 1 concept render.
Runs in venvrig (bpy 4.2, pip module, py311) with Cycles on CPU ONLY — touches no GPU,
runs outside the gpu-window. Usage (under a plain python3 with bpy importable):
    python dump_render.py <glb> <png-out> <budget>
Prints machine-readable rows: TRIS= BUDGET= PASS|FAIL DIMS_M= BYTES= PNG="""
import os, sys
import bpy

glb, png_out, budget = sys.argv[1], sys.argv[2], int(sys.argv[3])

bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.gltf(filepath=glb)

meshes = [o for o in bpy.context.scene.objects if o.type == "MESH"]
tris = 0
for o in meshes:
    o.data.calc_loop_triangles()
    tris += len(o.data.loop_triangles)

# World-space bbox across all meshes (imported unit-scale; game scale is S3's job).
xs = []; ys = []; zs = []
for o in meshes:
    for corner in o.bound_box:
        w = o.matrix_world @ __import__("mathutils").Vector(corner)
        xs.append(w.x); ys.append(w.y); zs.append(w.z)
dims = (max(xs) - min(xs), max(ys) - min(ys), max(zs) - min(zs)) if xs else (0, 0, 0)
center = __import__("mathutils").Vector(
    ((max(xs)+min(xs))/2, (max(ys)+min(ys))/2, (max(zs)+min(zs))/2)) if xs else __import__("mathutils").Vector()

# Camera: three-quarter hero shot framed on the bbox.
size = max(dims) or 1.0
from mathutils import Vector
cam_data = bpy.data.cameras.new("cam"); cam = bpy.data.objects.new("cam", cam_data)
bpy.context.collection.objects.link(cam)
cam.location = center + Vector((1.6, -1.6, 1.1)).normalized() * size * 2.6
cam_data.lens = 50
d = center - cam.location
cam.rotation_euler = d.to_track_quat("-Z", "Y").to_euler()

sun = bpy.data.lights.new("sun", "SUN"); sun.energy = 4.0
sun_o = bpy.data.objects.new("sun", sun); bpy.context.collection.objects.link(sun_o)
sun_o.rotation_euler = Vector((0.8, -0.3, 0.5)).to_track_quat("Z", "Y").to_euler()
world = bpy.data.worlds.new("w"); bpy.context.scene.world = world
world.use_nodes = True
world.node_tree.nodes["Background"].inputs[0].default_value = (0.02, 0.02, 0.03, 1.0)

sc = bpy.context.scene
sc.render.engine = "CYCLES"; sc.cycles.device = "CPU"
sc.cycles.samples = 24; sc.render.resolution_x = 720; sc.render.resolution_y = 720
sc.camera = cam; sc.render.filepath = png_out
bpy.ops.render.render(write_still=True)

ok = tris <= budget and os.path.getsize(png_out) > 0
print(f"TRIS={tris} BUDGET={budget} " + ("PASS" if tris <= budget else "FAIL") +
      f" DIMS_M={dims[0]:.3f},{dims[1]:.3f},{dims[2]:.3f} BYTES={os.path.getsize(glb)}"
      f" PNG={png_out} PNG_BYTES={os.path.getsize(png_out)}")
sys.exit(0 if ok else 1)
