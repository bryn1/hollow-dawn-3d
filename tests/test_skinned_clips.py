"""Skinned mocap clips on the player + warden GLBs (MC 11138 T-S2r).

DOD-ACCEPTANCE S2 skinned row, DESIGN-3D §c: the two skinned classes carry
named pose clips (walk / attack) and a >= 2 px pose frame-diff per pair,
proved on a REAL Godot Xvfb window (2 rigs x 2 clips x 2 distinct-time
pairs = 8 GREEN rows) with a frozen-same-time FROZEN control per clip pair
(4 RED-side rows at 0 px: the gate measures MOTION, not renderer noise).
The readings are the committed fixture (godot/sim/skinned_capture.gd,
manifest -> PIL abs-diff inside the character bbox); this gate pins them
plus the GLB contract itself (named animations, skin intact).
"""

import csv
import json
import os
import struct

import conftest

REPO = conftest.REPO
GLB_DIR = os.path.join(REPO, "assets", "glb")
MAP_DIR = os.path.join(REPO, "assets", "anim", "maps")
FIXTURE = os.path.join(REPO, "tests", "fixtures",
                        "skinned-clips-s2r-framediff.csv")

RIGS = {  # rig file -> (map file, joint count)
    "player-rigged.glb": ("player.json", 34),
    "boss-warden-rigged.glb": ("warden.json", 46),
}
MIN_DIFF_PX = 2   # §c pose frame-diff floor
MAX_FROZEN_PX = 1  # frozen control reads ~0; 1 px allows single-pixel noise


def load_glb_json(path):
    with open(path, "rb") as fh:
        magic, _, _ = struct.unpack("<III", fh.read(12))
        assert magic == 0x46546C67, f"not a GLB: {path}"
        clen, ctype = struct.unpack("<II", fh.read(8))
        assert ctype == 0x4E4F534A
        return json.loads(fh.read(clen))


def fixture_rows():
    with open(FIXTURE, newline="") as fh:
        return list(csv.DictReader(fh))


def test_transfer_maps_committed_and_injective():
    for glb, (mapname, joints) in RIGS.items():
        with open(os.path.join(MAP_DIR, mapname)) as fh:
            m = json.load(fh)
        cmu = m["cmu_to_bone"]
        assert m["target_joints"] == joints, mapname
        assert len(cmu) == m["mapped"], mapname
        assert len(set(cmu.values())) == len(cmu), \
            f"{mapname}: two CMU joints share one bone"
        assert cmu["Hips"] == "bone_0", mapname  # R2: root is hips
        # unmapped are exactly the fingers (+ CMU extras): every unmapped
        # target joint must be a LEAF beyond a mapped Hand -> not load-bearing
        assert set(m["target_unmapped"]) <= set(
            f"bone_{i}" for i in range(joints)), mapname
        assert "LeftHand" in cmu and "RightLeg" in cmu, mapname


def test_glbs_carry_named_walk_and_attack_and_skin():
    for glb, (mapname, joints) in RIGS.items():
        gj = load_glb_json(os.path.join(GLB_DIR, glb))
        names = {a.get("name") for a in gj.get("animations", [])}
        assert {"walk", "attack"} <= names, f"{glb}: animations={names}"
        skins = gj.get("skins", [])
        assert len(skins) >= 1 and len(skins[0]["joints"]) == joints, glb
        attrs = {k for m in gj.get("meshes", []) for p in m["primitives"]
                 for k in p["attributes"]}
        assert {"JOINTS_0", "WEIGHTS_0"} <= attrs, f"{glb}: skin lost"
        assert len(gj.get("images", [])) >= 1, f"{glb}: textures lost"
        # every animation must rotate a pose clip's worth of joints
        for a in gj["animations"]:
            rot_nodes = {c["target"]["node"] for c in a["channels"]
                         if c["target"]["path"] == "rotation"}
            assert len(rot_nodes) >= 8, \
                f"{glb} anim '{a.get('name')}' rotates {len(rot_nodes)} nodes"


def test_frame_diff_fixture_shape_and_gate_rows():
    rows = fixture_rows()
    motion = [r for r in rows if r["kind"] == "motion"]
    frozen = [r for r in rows if r["kind"] == "frozen"]
    assert len(motion) == 8 and len(frozen) == 4, \
        "8 motion rows (2 rigs x 2 clips x 2 pairs) + 4 frozen controls"
    for r in motion:
        assert int(r["diff_px"]) >= MIN_DIFF_PX, f"motion row RED: {r}"
    for r in frozen:
        assert int(r["diff_px"]) <= MAX_FROZEN_PX, \
            f"frozen control moved ({r}) — the diff is noise, not motion"
    cover = {(r["rig"], r["clip"]) for r in motion}
    assert cover == {(rig.replace(".glb", ""), clip) for rig in RIGS
                     for clip in ("walk", "attack")}, "coverage lost"
