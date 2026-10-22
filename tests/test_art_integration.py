"""Art integration gates (MC 11133 T-S2i): the batch GLBs are the live horde.

Same source-text style as the v1 suite (the client is Godot WASM; the gate
is source-truth) plus ONE runtime artifact: tests/fixtures/art-s2i-probe.jsonl
— the committed dump of sim/art_probe.gd, which measured the REAL scene
(headless Main.tscn, real _start_game + _spawn_enemy funnels).

Readings stated where the brief left them open:
* "GLB per class": every non-player ENEMY_TYPES key maps to exactly one
  committed glb under godot/assets/glb/ (DESIGN-3D §f project-tree row);
  boss-warden-rigged.glb is deliberately NOT wired (mocap is a later card)
  and player-alt is NOT the player (MC 11132 owns player.glb).
* Height table: the fixture rows are MEASURED live heights — the aabb of
  the very ArrayMesh each class MultiMesh renders (vertical scale channel
  is 1.0 in the gait, §c) — each within 10 % of the §a row (1.42 enemy,
  5.33 boss).
* Player placeholder: hero_pawn keeps the §a capsule and the future GLB
  swap lives in the ONE function _player_mesh(); the marker constant below
  pins that state (red when someone wires a real player mesh without
  retiring the marker).
* Draw budget: the fixture's draws row (400 alive) must total <= 60 hard
  cap with the §b planned-33 note kept.
"""

import json
import os
import re

import conftest

REPO = conftest.REPO
SCRIPTS = os.path.join(REPO, "godot", "scripts")
GLB_DIR = os.path.join(REPO, "godot", "assets", "glb")
FIXTURE = os.path.join(REPO, "tests", "fixtures", "art-s2i-probe.jsonl")

# §a rows: non-boss 34 px / S, boss 128 px / S (render.gd:10 stays px truth)
SPEC_H_ENEMY = 1.42
SPEC_H_BOSS = 5.33
HEIGHT_TOL = 0.10  # brief §4: within 10 %
DRAWS_HARD = 60  # §b hard cap
DRAWS_PLANNED = 33  # §b planned worst case (note kept, not a gate)
ALIVE_TARGET = 400  # brief §5: dump at a 400-enemy sim
CLASS_KEYS = ["wraith", "hound", "crawler", "cultist", "moor-brute",
              "dune-scarab", "rime-ghoul", "pale-wight"]  # 8 swarm + warden
PLAYER_MARKER = "PLAYER_GLB_PLACEHOLDER-MC11132-pending"


def read(name):
    """Script source with comment text removed (structural counts are CODE
    counts, same helper policy as test_boss_numbers.py)."""
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return "".join(line.split("#")[0] + "\n" for line in fh.read().splitlines())


VIZ = read("horde_viz.gd")
HERO = read("hero_pawn.gd")


def fixture_rows():
    assert os.path.isfile(FIXTURE), (
        "committed probe dump missing — regenerate tests/fixtures/"
        "art-s2i-probe.jsonl with sim/art_probe.gd (see its header)")
    with open(FIXTURE, encoding="utf-8") as fh:
        return [json.loads(line) for line in fh if line.strip()]


def glb_files_map():
    """GLB_FILES := { ... } read out of horde_viz.gd as a class -> glb map."""
    block = re.search(r"const GLB_FILES\s*:=\s*\{(.*?)\}", VIZ, re.S)
    assert block, "GLB_FILES map missing from horde_viz.gd"
    return dict(re.findall(r'"([^"]+)"\s*:\s*"([^"]+)"', block.group(1)))


# ---- 1. one committed GLB per class, wired into the horde -------------------

def test_glb_per_class_exists_and_wired():
    mapping = glb_files_map()
    assert sorted(mapping) == sorted(CLASS_KEYS + ["warden"]), (
        "GLB_FILES must cover exactly the 8 swarm classes + the warden")
    for key, fname in mapping.items():
        assert os.path.isfile(os.path.join(GLB_DIR, fname)), (
            "class %s has no committed glb at godot/assets/glb/%s" % (key, fname))
    # the horde path renders through ClassMesh (height-normalised ArrayMesh),
    # not the S3 capsule, and the boss rides the SAME per-class swap.
    assert "ClassMesh.mesh_for" in VIZ, "horde classes not routed through ClassMesh"
    assert "CapsuleMesh" not in VIZ, "capsule placeholder still in horde_viz"


# ---- 2. live height table within 10 % of the §a rows ------------------------

def test_height_table_within_spec():
    rows = [r for r in fixture_rows() if r["ev"] == "height"]
    by_class = {r["class"]: r for r in rows}
    assert sorted(by_class) == sorted(CLASS_KEYS + ["warden"])
    for key, row in by_class.items():
        spec = SPEC_H_BOSS if key == "warden" else SPEC_H_ENEMY
        assert row["mesh"] == "ArrayMesh", (
            "%s: horde class must render an imported ArrayMesh" % key)
        assert abs(row["measured_m"] - spec) / spec <= HEIGHT_TOL, (
            "%s: live height %.3f m off the §a row %.2f m by more than %d%%"
            % (key, row["measured_m"], spec, HEIGHT_TOL * 100))


# ---- 3. player stays placeholder behind ONE seam ----------------------------

def test_player_placeholder_marker_and_single_swap():
    assert PLAYER_MARKER in HERO, (
        "player placeholder marker missing — if player.glb (MC 11132) has "
        "landed, retire the marker in hero_pawn.gd and this test together")
    seam = re.search(r"func _player_mesh\(\).*?\n(?=func |\Z)", HERO, re.S)
    assert seam, "the ONE swap function _player_mesh() is missing"
    assert "CapsuleMesh.new()" in seam.group(0), (
        "_player_mesh() no longer returns the placeholder while the marker "
        "is live — swap AND marker must land in the same change")
    assert "ClassMesh" not in HERO, (
        "player GLB wired into hero_pawn before MC 11132 — placeholder rule")


# ---- 4. draw budget from the committed 400-enemy dump -----------------------

def test_draw_budget_from_committed_dump():
    rows = [r for r in fixture_rows() if r["ev"] == "draws"]
    assert len(rows) == 1
    row = rows[0]
    assert row["alive"] >= ALIVE_TARGET, (
        "dump must run at a 400-enemy sim (alive %s)" % row["alive"])
    assert row["planned"] == DRAWS_PLANNED, "§b planned-33 note must stay kept"
    assert row["hard_cap"] == DRAWS_HARD
    assert row["total"] <= row["hard_cap"], (
        "draws %d over the §b hard cap of %d" % (row["total"], row["hard_cap"]))
