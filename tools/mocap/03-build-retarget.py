#!/usr/bin/env python3
"""MC 11108 (T-S1b) — mocap retarget proof, bpy headless (CPU only).

Build a minimal rigged humanoid GLB whose skeleton IS the CMU clip skeleton
(BVH hierarchy = Hips/spine chain/arms/legs — a real humanoid), bind a simple
cylinder body to it, apply 3 CMU clips as NAMED actions (walk / run / attack),
and export one GLB with one glTF animation per action (io_scene_gltf2,
export_animation_mode='ACTIONS').

Retarget mechanism: all three CMU clips share one conversion skeleton, so the
retarget is a bone-name keyframe transfer onto the single humanoid armature
(name-matched pose-channel copy, keyframes decimated every 4th frame,
120 -> 30 fps sampling density, timing preserved).

Usage: 03-build-retarget.py <data_dir> <out.glb>
Run with /opt/imagegen/venvrig/bin/python on vm100.
"""
import math
import os
import sys

import bpy
from mathutils import Vector

DATA = sys.argv[-2]
OUT = sys.argv[-1]

CMU_TO_M = 0.056444  # verbatim from mocap.cs.cmu.edu/faqs.php
FPS = 120.0
STRIDE = 4           # keep every 4th BVH keyframe (frames 1,5,9,...)

# segment radii (m) for the cylinder body; zero-length bones yield no cylinder
RADII = {
    "LHipJoint": 0.07, "RHipJoint": 0.07,
    "LeftUpLeg": 0.075, "RightUpLeg": 0.075,
    "LeftLeg": 0.06, "RightLeg": 0.06,
    "LeftFoot": 0.045, "RightFoot": 0.045,
    "LeftToeBase": 0.035, "RightToeBase": 0.035,
    "LowerBack": 0.09, "Spine": 0.09,
    "Neck": 0.045, "Neck1": 0.045, "Head": 0.095,
    "LeftShoulder": 0.05, "RightShoulder": 0.05,
    "LeftArm": 0.05, "RightArm": 0.05,
    "LeftForeArm": 0.045, "RightForeArm": 0.045,
}
SKIP = {"LeftFingerBase", "RightFingerBase", "LeftHandIndex1",
        "RightHandIndex1", "LThumb", "RThumb"}

CLIPS = [("walk", f"{DATA}/07_01.bvh"), ("run", f"{DATA}/09_01.bvh"),
         ("attack", f"{DATA}/02_05.bvh")]


def import_clip(path):
    before = {o.name for o in bpy.data.objects}
    bpy.ops.import_anim.bvh(filepath=path, update_scene_fps=True,
                            global_scale=CMU_TO_M)
    new = [o for o in bpy.data.objects
           if o.name not in before and o.type == "ARMATURE"]
    assert len(new) == 1, f"expected 1 new armature, got {[o.name for o in new]}"
    obj = new[0]
    act = [a for a in bpy.data.actions if a.name not in {"walk", "run", "attack"}][-1]
    return obj, act


def build_body(arm_obj):
    """Cylinder per named bone (rest head->tail), one mesh, vgroups = bone names."""
    arm = arm_obj.data
    parts = []
    for bone in arm.bones:
        if bone.name in SKIP:
            continue
        r = RADII.get(bone.name)
        if r is None:
            continue
        head, tail = bone.head_local, bone.tail_local
        d = tail - head
        if d.length < 1e-4:
            continue
        mid = (head + tail) / 2
        bpy.ops.mesh.primitive_cylinder_add(radius=r, depth=d.length,
                                            location=mid)
        ob = bpy.context.active_object
        ob.rotation_mode = "QUATERNION"
        ob.rotation_quaternion = d.to_track_quat("Z", "Y")
        vg = ob.vertex_groups.new(name=bone.name)
        vg.add(list(range(len(ob.data.vertices))), 1.0, "REPLACE")
        parts.append(ob)
    bpy.ops.object.select_all(action="DESELECT")
    for ob in parts:
        ob.select_set(True)
    bpy.context.view_layer.objects.active = parts[0]
    bpy.ops.object.join()
    body = bpy.context.active_object
    body.name = "HD3D_Body"
    # skin to the armature (rest space == world: armature obj is identity)
    body.parent = arm_obj
    body.matrix_parent_inverse.identity()
    mod = body.modifiers.new("Armature", "ARMATURE")
    mod.object = arm_obj
    return body


def transfer_action(src_act, name, arm_obj):
    """Name-matched retarget: copy pose channels (decimated) into a named action."""
    act = bpy.data.actions.new(name=name)
    for fc in src_act.fcurves:
        tf = act.fcurves.new(data_path=fc.data_path, index=fc.array_index)
        for kp in fc.keyframe_points:
            if int(round(kp.co.x)) % STRIDE != 1 % STRIDE:
                continue
            nk = tf.keyframe_points.insert(kp.co.x, kp.co.y)
            nk.interpolation = "LINEAR"
    if arm_obj.animation_data is None:
        arm_obj.animation_data_create()
    arm_obj.animation_data.action = act
    return act


def main():
    bpy.ops.wm.read_factory_settings(use_empty=True)

    # clip 1 defines the humanoid skeleton + its 'walk' action
    walk_obj, walk_act = import_clip(CLIPS[0][1])
    walk_obj.name = "HD3D_Humanoid"
    walk_obj.data.name = "HD3D_Humanoid"
    n_bones = len(walk_obj.data.bones)

    body = build_body(walk_obj)

    actions = [transfer_action(walk_act, "walk", walk_obj)]

    # clips 2+3: import to a temp armature, transfer keys onto the humanoid
    for label, path in CLIPS[1:]:
        tmp_obj, tmp_act = import_clip(path)
        arm_obj = bpy.data.objects["HD3D_Humanoid"]  # re-look-up: never hold refs across ops
        assert {b.name for b in tmp_obj.data.bones} == {b.name for b in arm_obj.data.bones}, \
            f"bone sets differ for {label}: clips must share one conversion skeleton"
        actions.append(transfer_action(tmp_act, label, arm_obj))
        bpy.data.objects.remove(tmp_obj, do_unlink=True)
        for a in list(bpy.data.actions):
            if a not in actions:
                bpy.data.actions.remove(a)

    # walk as the open/active action
    arm_obj = bpy.data.objects["HD3D_Humanoid"]
    for a in bpy.data.actions:
        if a.name == "walk":
            arm_obj.animation_data.action = a

    bpy.ops.object.select_all(action="DESELECT")
    arm_obj.select_set(True)
    body.select_set(True)
    bpy.context.view_layer.objects.active = arm_obj
    bpy.ops.export_scene.gltf(
        filepath=OUT, export_format="GLB", use_selection=True,
        export_animations=True, export_animation_mode="ACTIONS",
        export_skins=True, export_yup=True, export_apply=False,
    )
    print(f"built bones={n_bones} actions={[a.name for a in actions]}")
    print(f"exported {OUT}")
    # bpy 4.2 headless segfaults in interpreter teardown AFTER a successful
    # export (observed MC 11108); flush and leave before cleanup runs.
    sys.stdout.flush()
    os._exit(0)


main()
