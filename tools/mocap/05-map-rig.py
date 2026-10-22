#!/usr/bin/env python3
"""MC 11138 (T-S2r) — position-based CMU→rig transfer map, bpy headless.

Reads rest-pose joint WORLD positions of (a) a rigged target GLB (UniRig
bone_N joints) and (b) the CMU conversion skeleton (a reference BVH clip),
both in ONE Blender world, and maps CMU joints -> target bone_N by the
documented rules below. Finger/thumb joints are deliberately left unmapped
(counts land in the output JSON).

RULES (one rule set for every target rig — no per-asset special cases):
  R1 up-axis   : world axis with the largest joint-position spread.
  R2 hips/root : tree root joint (the only bone with no armature parent).
  R3 head      : leaf joint highest along the up-axis.
  R4 spine     : hips->head ancestor path, roles from the two ends inward:
                 idx0=Hips, 1=LowerBack (len>=4), 2=Spine (len>=5),
                 3=Spine1 (len>=6); last=Head, last-1=Neck (len>=5),
                 last-2=Neck1 (len>=7). Middle joints beyond idx3 stay
                 unmapped. (The two shipped rigs carry len=6: Neck1 is
                 unmapped on both — stated in the capture.)
  R5 arm chain : a child of a spine-path joint (excluding the top two) that
                 is not on the spine path; follow single-child descent to
                 the branching point; descent roles = Shoulder, Arm,
                 ForeArm, Hand; children of the branch (and below) are
                 fingers -> unmapped.
  R6 leg chain : a child of hips that is not the spine child; follow
                 single-child descent to the foot. Length 5: HipJoint,
                 UpLeg, Leg, Foot, ToeBase; length 4: TAIL-ALIGNED
                 UpLeg..ToeBase (HipJoint unmapped); other lengths keep
                 the last 4 roles, the extra proximal joints unmapped.
  R7 side      : each rig's own side-axis = the horizontal axis with the
                 largest spread over the shoulder/UpLeg rest positions.
                 A target chain is 'Left' iff the sign of its anchor
                 position along the TARGET side-axis equals the sign of
                 the CMU Left* anchor along the CMU side-axis (both rigs
                 share one Blender world, so this is a pure position test).

Usage: 05-map-rig.py <target.glb> <ref.bvh> <out-map.json>
Run with /opt/imagegen/venvrig/bin/python on vm100 (CPU only).
"""
import json
import math
import os
import sys

import bpy

CMU_TO_M = 0.056444
ARM_ROLES = ["Shoulder", "Arm", "ForeArm", "Hand"]
LEG_ROLES_TAIL = ["UpLeg", "Leg", "Foot", "ToeBase"]  # len>=4 tail-align
HIP_JOINT = {"Left": "LHipJoint", "Right": "RHipJoint"}  # CMU len-5 name

TARGET = sys.argv[-3]
REF_BVH = sys.argv[-2]
OUT = sys.argv[-1]


def reset():
    bpy.ops.wm.read_factory_settings(use_empty=True)


def import_obj(path, bvh=False):
    before = {o.name for o in bpy.data.objects}
    if bvh:
        bpy.ops.import_anim.bvh(filepath=path, update_scene_fps=False,
                                global_scale=CMU_TO_M)
    else:
        bpy.ops.import_scene.gltf(filepath=path)
    new = [o for o in bpy.data.objects if o.name not in before and o.type == "ARMATURE"]
    assert len(new) == 1, f"expected 1 armature, got {[o.name for o in new]}"
    return new[0]


def joint_tree(arm_obj):
    """({bone: [children]}, {bone: world Vector}, root_name) over all bones."""
    kids = {b.name: [c.name for c in b.children] for b in arm_obj.data.bones}
    pos = {b.name: arm_obj.matrix_world @ b.head_local for b in arm_obj.data.bones}
    roots = [b.name for b in arm_obj.data.bones if b.parent is None]
    assert len(roots) == 1, f"root bones: {roots}"
    return kids, pos, roots[0]


def axis_spread(pos, idx):
    return max(p[idx] for p in pos.values()) - min(p[idx] for p in pos.values())


def up_axis(pos):
    return max(range(3), key=lambda i: axis_spread(pos, i))


def side_axis(pos, names, up):
    hz = [i for i in range(3) if i != up]
    pts = [pos[n] for n in names]
    sp = [max(p[i] for p in pts) - min(p[i] for p in pts) for i in hz]
    return hz[max(range(2), key=lambda i: sp[i])]


def follow_chain(kids, start):
    """Single-child descent (inclusive) to the first branch point or leaf."""
    chain = [start]
    while len(kids[chain[-1]]) == 1:
        chain.append(kids[chain[-1]][0])
    return chain


def roles_generic(kids, pos, root, up):
    """Anonymous humanoid tree -> (roles, arm_chains, leg_chains, unmapped)."""
    leaf_highest = max((n for n in pos if not kids[n]), key=lambda n: pos[n][up])
    path = [leaf_highest]
    while path[0] != root:
        parents = [p for p in kids if path[0] in kids[p]]
        assert parents, f"orphan {path[0]} off root {root}"
        path.insert(0, parents[0])
    L = len(path)
    roles, unmapped = {}, []
    for i, role in [(0, "Hips"), (1, "LowerBack"), (2, "Spine"), (3, "Spine1")]:
        if i < L and i < L - 2:
            roles[role] = path[i]
    used = set(roles.values())
    roles["Head"] = path[L - 1]
    if L >= 5 and path[L - 2] not in used:  # Neck needs a free bone
        roles["Neck"] = path[L - 2]
    if L >= 7:  # a dedicated Neck1 bone exists only on 7-joint chains
        roles["Neck1"] = path[L - 3]
    spine_set = set(path)
    arms = []
    for j in path[1:-2]:  # R5: attachments from LowerBack up — never the hips
        for c in kids[j]:
            if c not in spine_set:
                chain = follow_chain(kids, c)[:4]
                for extra in kids[chain[-1]]:  # children of the branch = fingers
                    unmapped.extend(follow_chain(kids, extra))
                arms.append(chain)
    legs = []
    for c in kids[root]:
        if c in spine_set:
            continue
        chain = follow_chain(kids, c)
        if len(chain) >= 5:
            names = ["HipJoint"] + LEG_ROLES_TAIL
            unmapped.extend(chain[5:])
            legs.append(list(zip(names, chain[:5])))
        else:
            unmapped.extend(chain[:max(0, len(chain) - 4)])
            legs.append(list(zip(LEG_ROLES_TAIL[-len(chain):], chain)))
    return roles, arms, legs, unmapped


def main():
    reset()
    tgt_obj = import_obj(TARGET)
    t_kids, t_pos, t_root = joint_tree(tgt_obj)
    t_up = up_axis(t_pos)
    t_roles, t_arms, t_legs, t_unmapped = roles_generic(t_kids, t_pos, t_root, t_up)
    anchors = [ch[0] for ch in t_arms] + [pr[0][1] for pr in t_legs]
    t_side = side_axis(t_pos, anchors, t_up)

    reset()
    src_obj = import_obj(REF_BVH, bvh=True)
    s_kids, s_pos, s_root = joint_tree(src_obj)
    s_up = up_axis(s_pos)
    s_side = side_axis(s_pos, ["LeftShoulder", "LeftUpLeg",
                              "RightShoulder", "RightUpLeg"], s_up)
    s_sign = {k: math.copysign(1.0, s_pos[k][s_side])
              for k in ("LeftShoulder", "LeftUpLeg")}

    mapping, evidence = {}, {}

    def put(cmu, bone):
        assert bone not in mapping.values(), f"bone {bone} double-mapped"
        assert cmu not in mapping, f"cmu {cmu} double-mapped"
        mapping[cmu] = bone
        evidence[cmu] = {"cmu_world": [round(v, 4) for v in s_pos[cmu]],
                        "bone_world": [round(v, 4) for v in t_pos[bone]]}

    def side_of(bone):
        s = math.copysign(1.0, t_pos[bone][t_side])
        return "Left" if s == s_sign["LeftShoulder"] else "Right"

    for role, bone in sorted(t_roles.items()):
        if role in s_pos:  # Neck1 has no counterpart on len-6 spine paths
            put(role, bone)
    for chain in t_arms:
        pref = side_of(chain[0])
        for role, bone in zip(ARM_ROLES, chain):
            put(f"{pref}{role}", bone)
    for pairs in t_legs:
        pref = side_of(pairs[0][1])
        for base, bone in pairs:
            cmu = HIP_JOINT[pref] if base == "HipJoint" else f"{pref}{base}"
            put(cmu, bone)

    cmu_unmapped = sorted(set(s_pos) - set(mapping))
    out = {
        "rig": TARGET.split("/")[-1],
        "rules": "R1..R7 as documented in tools/mocap/05-map-rig.py (MC 11138)",
        "up_axis": "XYZ"[t_up], "side_axis": "XYZ"[t_side],
        "cmu_to_bone": mapping,
        "target_joints": len(t_pos), "mapped": len(mapping),
        "target_unmapped": sorted(set(t_unmapped)),
        "cmu_unmapped": cmu_unmapped,
        "evidence": evidence,
    }
    with open(OUT, "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print(f"MAP rig={out['rig']} mapped={out['mapped']} "
          f"target_unmapped={len(out['target_unmapped'])} "
          f"cmu_unmapped={len(cmu_unmapped)}")
    sys.stdout.flush()
    os._exit(0)  # bpy 4.2 headless teardown segfault idiom (MC 11108)


main()
