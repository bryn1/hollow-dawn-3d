#!/usr/bin/env python3
"""MC 11138 (T-S2r) — retarget CMU clips onto a rigged GLB, bpy headless.

Rewrites a UniRig-rigged GLB (vm100 working copy) with NAMED glTF
animations (walk / attack), keeping skin + materials + textures intact.
Mechanism — extends 03's keyframe transfer with the 05 position map, as a
pose-space parent-relative rotation-delta retarget:

  per mapped pair (cmu joint j -> bone b), per sampled frame f:
    Rs(j,f) = rot(W_s(parent,j,f)^-1 @ W_s(j,f))      (source bone rotation
                relative to its parent joint, world axes)
    D(f)    = Rs(f) @ Rs(stance)^-1                    (motion delta only)
    W_t(b,f) = W_t(parent,f) @ [ T(rel_t) @ rot(D @ rel_r) ]
               where rel = W_t(parent,rest)^-1 @ W_t(b,rest) (target rest
               bone transform in the parent's rest frame; its translation
               keeps the bone vector, its rotation carries the delta).
  Rest-anchored: stance frame (D=I) reproduces the target rest EXACTLY —
  asserted per bone (basis rotation < 5e-3 rad, translation < 2 cm).
  Root (Hips) adds scaled translation re-centred at the target root joint:
    W_t(root,f) = T(c + k*dt(f)) @ D @ T(-c) @ W_t(root,rest),
    c = target root rest world pos, dt = source hips world displacement,
    k = target/source rest-height ratio (source is metres: BVH import
    applies CMU_TO_M).
  Solved world goals become matrix_basis through the empirically probed
  FK law (arm space): M_b = P_pose @ matrix_local(parent)^-1 @ matrix_local
  @ matrix_basis — matrix_local already contains the parent REST transform;
  after each bone is posed the script RE-READS pb.matrix and asserts it
  matches the goal (self-verifying solve).
  Keys: rotation_quaternion every frame + location every frame on the
  root; every 4th BVH frame (120 -> 30 fps density, timing preserved)
  exactly as 03-build-retarget.py (MC 11108).
  Known limitation (stated in the capture): the delta rides shared world
  axes — per-bone local-axis twist differences between rigs are not
  corrected; fine for humanoid->humanoid pose clips at this gate.

Usage: 06-retarget-rig.py <target.glb> <map.json> <label=path.bvh> [...] <out.glb>
Run with /opt/imagegen/venvrig/bin/python on vm100 (CPU only — no GPU window).
"""
import json
import math
import os
import sys

import bpy
from mathutils import Matrix

CMU_TO_M = 0.056444
STRIDE = 4  # every 4th BVH keyframe (120 -> 30 fps), as in 03
TOL_A = 5e-3   # rad — stance-identity / solve-match tolerance
TOL_P = 0.02   # m

TARGET = sys.argv[1]
MAPFILE = sys.argv[2]
CLIPS = [tuple(a.split("=", 1)) for a in sys.argv[3:-1]]
OUT = sys.argv[-1]
IDENT = Matrix.Identity(4)


def reset():
    bpy.ops.wm.read_factory_settings(use_empty=True)


def import_obj(path, bvh=False):
    before = {o.name for o in bpy.data.objects}
    if bvh:
        bpy.ops.import_anim.bvh(filepath=path, update_scene_fps=True,
                                global_scale=CMU_TO_M)
    else:
        bpy.ops.import_scene.gltf(filepath=path)
    new = [o for o in bpy.data.objects if o.name not in before and o.type == "ARMATURE"]
    assert len(new) == 1, f"expected 1 armature, got {[o.name for o in new]}"
    return new[0]


def rest_height(arm_obj):
    zs = [(arm_obj.matrix_world @ b.head_local).z for b in arm_obj.data.bones]
    return max(zs) - min(zs)


def rot_of(m):
    return m.to_quaternion().to_matrix().to_4x4()


def ang_err(a, b):
    """angle between two rotations; accepts Matrix or Quaternion."""
    qa = a.to_quaternion() if hasattr(a, "to_quaternion") else a
    qb = b.to_quaternion() if hasattr(b, "to_quaternion") else b
    q = qa @ qb.inverted()
    return 2.0 * math.acos(min(1.0, abs(q.w)))


def depth_of(bones, name):
    d = 0
    while bones[name].parent:
        name = bones[name].parent.name
        d += 1
    return d


def retarget_clip(tgt, cmap, label, bvh_path, k_h):
    src = import_obj(bvh_path, bvh=True)
    scene = bpy.context.scene
    frames = list(range(scene.frame_start, scene.frame_end + 1, STRIDE))
    act = bpy.data.actions.new(name=label)
    if tgt.animation_data is None:
        tgt.animation_data_create()
    tgt.animation_data.action = act

    # Map consistency gate (R4-R6 maps must satisfy): every bone's DIRECT
    # source parent, or that parent's parent (the BVH importer merges
    # zero-length CMU bones — Spine1/Neck1 — into their child), must be the
    # mapped source joint of the bone's mapped target parent.
    inv = {b: n for n, b in cmap.items()}
    for n, b in cmap.items():
        tp = tgt.data.bones[b].parent
        if tp is None:
            assert src.data.bones[n].parent is None, f"root mismatch at {n}"
            continue
        want = inv[tp.name]
        sp = src.data.bones[n].parent
        assert sp.name == want or (sp.parent is not None and
                                   sp.parent.name == want), \
            f"parent mismatch: target {tp.name}->{b} wants cmu {want}, " \
            f"source parent chain {sp.name} <- " \
            f"{sp.parent.name if sp.parent else 'None'}"
    order = sorted(cmap.items(), key=lambda kv: depth_of(tgt.data.bones, kv[1]))

    # target rest, unposed
    for b in cmap.values():
        tgt.pose.bones[b].matrix_basis.identity()
    bpy.context.view_layer.update()
    W_rest = {n: tgt.matrix_world @ tgt.pose.bones[b].matrix for n, b in cmap.items()}
    # parents keyed in CMU domain (the map's parentage gate ran above:
    # every non-root bone's target parent maps to a MAPPED cmu joint, or
    # the source merges zero-length joints into this one — in that case
    # the target parent is this bone's nearest mapped source ancestor)
    inv = {b: n for n, b in cmap.items()}
    par = {}
    for n, b in cmap.items():
        tp = tgt.data.bones[b].parent
        par[n] = "__world__" if tp is None else inv[tp.name]
    rel = {n: (W_rest[p] if p in W_rest else IDENT).inverted() @ W_rest[n]
           for n, p in par.items()}

    root_names = [n for n, p in par.items() if p == "__world__"]
    assert len(root_names) == 1, f"target roots in map: {root_names}"
    root = root_names[0]

    for fi, f in enumerate(frames):
        scene.frame_set(f)
        bpy.context.view_layer.update()
        Ws = {bn: src.matrix_world @ pb.matrix for bn, pb in src.pose.bones.items()}
        Ws["__world__"] = IDENT
        par_s = {n: (src.data.bones[n].parent.name if src.data.bones[n].parent
                     else "__world__") for n in cmap}
        Rs = {n: rot_of(Ws[par_s[n]].inverted() @ Ws[n]) for n in cmap}
        if fi == 0:
            Rs0, root_stance = dict(Rs), Ws[root].translation
        for n, bname in order:
            D = rot_of(Rs[n] @ Rs0[n].inverted())
            pb = tgt.pose.bones[bname]
            Wpar = (tgt.matrix_world @ pb.parent.matrix if pb.parent
                    else tgt.matrix_world)
            if n == root:
                c = W_rest[n].translation
                dt = k_h * (Ws[n].translation - root_stance)
                W_goal = (Matrix.Translation(c + dt) @ D @
                          Matrix.Translation(-c) @ W_rest[n])
            else:
                W_goal = Wpar @ (Matrix.Translation(rel[n].translation)
                                 @ rot_of(D @ rel[n]))
            X_arm = tgt.matrix_world.inverted() @ W_goal
            Mpar = pb.parent.matrix if pb.parent else IDENT
            # empirical FK law (probed on this bpy 4.2 + these rigs):
            # M_b = P_pose @ L_parent^-1 @ matrix_local @ basis  (arm space;
            # matrix_local already contains the parent's REST transform)
            Lpar = pb.parent.bone.matrix_local if pb.parent else IDENT
            basis = (tgt.data.bones[bname].matrix_local.inverted() @ Lpar
                     @ Mpar.inverted() @ X_arm)
            loc, quat, scl = basis.decompose()
            assert max(abs(s - 1.0) for s in scl) < 0.05, f"{bname} scale drift"
            if fi == 0:
                assert ang_err(quat, IDENT) < TOL_A and loc.length < TOL_P, \
                    f"stance frame moved {bname} off rest (rot {quat}, loc {loc})"
            pb.rotation_mode = "QUATERNION"
            pb.rotation_quaternion = quat
            pb.location = loc
            pb.keyframe_insert("rotation_quaternion", frame=fi)
            if n == root:
                pb.keyframe_insert("location", frame=fi)
            bpy.context.view_layer.update()
            got = tgt.matrix_world @ pb.matrix
            assert ang_err(got, W_goal) < TOL_A, \
                f"solve mismatch on {bname}: {ang_err(got, W_goal):.4f} rad"
    scene.render.fps = 30  # stride keys land at 30 fps -> timing preserved
    bpy.data.objects.remove(src, do_unlink=True)
    for a in list(bpy.data.actions):
        if a.name not in {lbl for lbl, _ in CLIPS}:
            bpy.data.actions.remove(a)
    print(f"clip={label} frames={len(frames)} "
          f"range={tuple(round(v, 2) for v in act.frame_range)}")


def main():
    reset()
    cmap = json.load(open(MAPFILE))["cmu_to_bone"]
    tgt = import_obj(TARGET)
    tmp = import_obj(CLIPS[0][1], bvh=True)
    k_h = rest_height(tgt) / rest_height(tmp)
    bpy.data.objects.remove(tmp, do_unlink=True)
    for a in list(bpy.data.actions):
        bpy.data.actions.remove(a)
    print(f"k_height={k_h:.3f} mapped={len(cmap)}")
    for label, path in CLIPS:
        retarget_clip(tgt, cmap, label, path, k_h)
    tgt.animation_data.action = bpy.data.actions["walk"]
    scene = bpy.context.scene
    scene.render.fps = 30
    bpy.ops.object.select_all(action="DESELECT")
    tgt.select_set(True)
    for o in bpy.data.objects:
        if o.type == "MESH" and o.find_armature() is tgt:
            o.select_set(True)
    bpy.context.view_layer.objects.active = tgt
    bpy.ops.export_scene.gltf(
        filepath=OUT, export_format="GLB", use_selection=True,
        export_animations=True, export_animation_mode="ACTIONS",
        export_skins=True, export_yup=True, export_apply=False,
    )
    print(f"exported {OUT} clips={[l for l, _ in CLIPS]}")
    sys.stdout.flush()
    os._exit(0)  # bpy 4.2 teardown segfault idiom (MC 11108)


main()
