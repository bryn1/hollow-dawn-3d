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
  the very ArrayMesh each unit renders (vertical scale channel is 1.0 in
  the gait, §c) — each within 10 % of the §a row (1.42 enemy, 5.33 boss,
  1.67 player).
* Player GLB (T-S2p, MC 11135): the placeholder era is RETIRED — the pawn
  renders player.glb through the ONE function _player_mesh(); the swap is
  pinned structurally there and by the player's own live-height table row
  (red when the live mesh off-specs the §a row by more than 10 %).
* Draw budget: the fixture's draws row (400 alive) must total <= 60 hard
  cap with the §b planned-40 note kept (M1 budget re-tally, T-M1g).
"""

import functools
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
SPEC_H_PLAYER = 1.67  # §a row: v1 player 40 px / S (live row since T-S2p)
HEIGHT_TOL = 0.10  # brief §4: within 10 %
DRAWS_HARD = 60  # §b hard cap
DRAWS_PLANNED = 40  # §b planned worst case, M1 re-tally 33 -> 40 (T-M1g;
# RETIRE-AND-REPLACE per roadmap §2 — the note, not a gate)
ALIVE_TARGET = 400  # brief §5: dump at a 400-enemy sim
CLASS_KEYS = ["wraith", "hound", "crawler", "cultist", "moor-brute",
              "dune-scarab", "rime-ghoul", "pale-wight"]  # 8 swarm + warden


read = functools.partial(conftest.read_script,
                       code_only=True)  # MC 11317 C2 seam


VIZ = read("horde_viz.gd")
HERO = read("hero_pawn.gd")


def fixture_rows():
    assert os.path.isfile(FIXTURE), (
        "committed probe dump missing — regenerate tests/fixtures/"
        "art-s2i-probe.jsonl with sim/art_probe.gd (see its header)")
    return conftest.jsonl_rows(FIXTURE)  # MC 11317 C2 seam


def glb_files_map():
    """GLB_FILES := { ... } read out of horde_viz.gd as a class -> glb map."""
    block = re.search(r"const GLB_FILES\s*:=\s*\{(.*?)\}", VIZ, re.S)
    assert block, "GLB_FILES map missing from horde_viz.gd"
    return dict(re.findall(r'"([^"]+)"\s*:\s*"([^"]+)"', block.group(1)))


# ---- 1. one committed GLB per class, wired into the horde -------------------

def test_glb_per_class_exists_and_wired():
    mapping = glb_files_map()
    # Coverage row RE-PINNED by T-M1d (M1 feature 4): the two miniboss
    # classes joined the map deliberately riding boss-warden.glb (height-
    # normalised mini-bosses) until the M1 asset batch lands their meshes —
    # the file-exists loop below still requires a real committed glb.
    # Coverage row RE-PINNED AGAIN by T-M3b (MC 11284, spec §3.1; the T-M3a
    # TRELLIS asset rows, MC 11285): the two end-boss classes joined at
    # their OWN committed meshes (cathedral-choir.glb / ossuary-warden.glb)
    # — the file-exists loop covers them like every class before them.
    assert sorted(mapping) == sorted(
        CLASS_KEYS + ["warden", "hollow-knight", "hollow-deacon",
                      "cathedral-choir", "ossuary-warden"]), (
        "GLB_FILES must cover exactly the 8 swarm classes + the warden + the "
        "2 miniboss classes + the 2 end-boss classes")
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
    # Coverage RETIRE-AND-REPLACE (T-M1g, MC 11211, roadmap M1 asset row):
    # the two miniboss classes joined the measured table when T-M1c2's real
    # meshes swapped in at the named horde_viz seam — both measure 1.42 m at
    # the §a enemy row (rel_err 0.0), gate unchanged at 10 %.
    # Coverage row EXTENDED by T-M3b (MC 11284): the two end-boss classes
    # joined the measured table at the BOSS height row (5.33 m, the same
    # MODEL_H_BOSS law the warden rides), rel_err 0.0 — gate unchanged.
    assert sorted(by_class) == sorted(CLASS_KEYS + ["warden", "player",
                                                    "hollow-knight",
                                                    "hollow-deacon",
                                                    "cathedral-choir",
                                                    "ossuary-warden"])
    for key, row in by_class.items():
        spec = {"warden": SPEC_H_BOSS,
                "cathedral-choir": SPEC_H_BOSS,
                "ossuary-warden": SPEC_H_BOSS,
                "player": SPEC_H_PLAYER}.get(key, SPEC_H_ENEMY)
        assert row["mesh"] == "ArrayMesh", (
            "%s: live unit must render an imported ArrayMesh" % key)
        assert abs(row["measured_m"] - spec) / spec <= HEIGHT_TOL, (
            "%s: live height %.3f m off the §a row %.2f m by more than %d%%"
            % (key, row["measured_m"], spec, HEIGHT_TOL * 100))


# ---- 3. player GLB swapped at the ONE seam; live height pinned -------------

def test_player_glb_swap_and_live_height():
    # T-S2p retired the placeholder-marker test WITH this swap: the pawn
    # renders player.glb through the ONE seam, and the fixture's player
    # row — MEASURED off the live pawn mesh — carries the height gate.
    seam = re.search(r"func _player_mesh\(\).*?\n(?=func |\Z)", HERO, re.S)
    assert seam, "the ONE swap function _player_mesh() is missing"
    assert 'ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER)' \
        in seam.group(0), (
        "_player_mesh() must return the height-normalised player GLB "
        "through ClassMesh — the ONE seam, no second loader")
    assert "CapsuleMesh" not in HERO, (
        "capsule placeholder still in hero_pawn — placeholder era retired "
        "by MC 11135")
    assert "PLAYER_GLB_PLACEHOLDER" not in HERO, (
        "placeholder marker still live in hero_pawn — retired with the swap")
    assert os.path.isfile(os.path.join(GLB_DIR, "player.glb")), (
        "no committed player glb at godot/assets/glb/player.glb")
    row = {r["class"]: r for r in fixture_rows() if r["ev"] == "height"}\
        .get("player")
    assert row is not None, "player live-height row missing from the dump"
    assert row["mesh"] == "ArrayMesh", (
        "player must render the ClassMesh-imported ArrayMesh, not a "
        "placeholder")
    assert abs(row["measured_m"] - SPEC_H_PLAYER) / SPEC_H_PLAYER \
        <= HEIGHT_TOL, (
        "player: live height %.3f m off the §a row %.2f m by more than %d%%"
        % (row["measured_m"], SPEC_H_PLAYER, HEIGHT_TOL * 100))


# ---- 4. draw budget from the committed 400-enemy dump -----------------------

def test_draw_budget_from_committed_dump():
    rows = [r for r in fixture_rows() if r["ev"] == "draws"]
    assert len(rows) == 1
    row = rows[0]
    assert row["alive"] >= ALIVE_TARGET, (
        "dump must run at a 400-enemy sim (alive %s)" % row["alive"])
    assert row["planned"] == DRAWS_PLANNED, "§b planned-40 note must stay kept"
    assert row["hard_cap"] == DRAWS_HARD
    assert row["total"] <= row["hard_cap"], (
        "draws %d over the §b hard cap of %d" % (row["total"], row["hard_cap"]))
