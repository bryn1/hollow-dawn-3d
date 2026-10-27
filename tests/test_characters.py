"""CHARACTER ROSTER (M5-SPEC §2, T-M5c, MC 11422) — SEL-C = 9 rows.

ACCEPT rows B-E1..B-E9 (spec §2.3), row-per-test with the ONE seam each
reads (the planted reds fire on the FINAL tree in the card capture,
.tmp/m5c-char.txt, and are cp+cmp byte-restored there):

  B-E1 byte corpus            the strict class: journey 5020 @HD3D_SEED=
       11101 + the 12 committed fixture channels + strips (modulo norm)
       ALL cmp-identical vs the pre-edit base dump (base==committed proven
       FIRST) — the §7.1 re-run pattern lives in the capture, NOT pytest
       (the T-C3/P-E7 idiom). Row 0's IEEE-identity law is what makes them
       stand; its DATA twin is the row0 equality below.
  B-E2 start-weapon rows      sim_chars legs `start_rows` (all nine t=0
       truths: ONE slot, table id, level 1, cd 0.0, gold/max_hp rows; row
       0 == the re-copied SHIPPED talon literal by VALUE — the M2-B3
       equality shape, re-pointed at the ROSTER seam) + `alias_guard`
       (the §2.2 duplicate() law's SAME-PROCESS MULTI-RUN twin: run 1
       mutates its weapon dict, a fresh same-process run sees level 1
       again — the leak a const-row/shallow-duplicate hand-out plants).
       The planted-red rides the mutable-shape future (const->var +
       duplicate() stripped): the alias leg goes RED, executed, not grep.
  B-E3 rule terms             sim_chars leg `rule_rows` — per char the
       four formula seams + gold + max_hp + xp-mult MEASURED off a real
       fresh run vs INDEPENDENT literals (row 0 == the shipped numbers
       exactly: speed 140.0, dmg 1.0, intake 50.0/0.5-clamp, hp 100.0,
       gold 0, xp 1.0 — the F-2 identity row).
  B-E4 selection not snapshot sim_chars leg `start_reset` (12-field
       snapshot frozen — no char/char_id field; bare start_run resets
       char_id to the input row 0) + the source regex pins below: main's
       HAND-IN of char_sel BEFORE start_run (the §2.1b tail placement is
       declared-and-rejected for this row — start_run CONSUMES it), the
       start_run reset read `char_id = char_sel` (the M4 B-E1 planted red
       "a default from a global" fires here), and the pawn re-skin at the
       F-7 hand-in tail AFTER seed_stage_props.
  B-E5 select persistence    source pins (the buy/select verbs call the
       Roster rule + the ONE funnel, contain ZERO .save( sites, and the
       select re-checks the rule + the != guard — the no-op-no-write
       pair); disk-observability + the funnel occurrence re-count ride
       test_achievements.py's P-E3 pin (7 -> 9, same commit) and the
       capture's disk legs (the shop_probe shape).
  B-E6 the select surface     source pins (sixth overlay in the ONE
       style, rows from the ONE table, locked rows DISABLED never hidden,
       the lock line names the achievement, the §j assert-before-load on
       the portrait family) + sim_chars leg `states` (the four-state law
       through Roster.state, icon-free) + tools/dawnwell_pixel_gate.py's
       ADDITIVE `char_select_shot` row (capture, floor 200, same
       hidden-UI baseline).
  B-E7 new meshes live        sim_chars legs `pawns` (per char the pawn
       mesh IS the ONE ClassMesh loader's cached object for the row GLB
       at 1.67 m, and the material_override is a FRESH duplicate, alpha-
       transparency + UNSHADED + PLAYER_TINT) + this file's file-exists
       + tris <= 8000 rows (the m5-art manifest eyeball row rides the
       capture after the asset rebase; no stub GLB ever).
  B-E8 clips move pixels      tools/... + the committed roster clip CSV
       (walk/attack >= 2 px per mesh, FROZEN same-time control == 0 px;
       generated TWICE cmp-identical — a forward-lock, never a byte
       anchor of this card).
  B-E9 the table itself       pytest table pin (ids/meshes/portraits/
       start-weapon ids/gates/costs — the ports of the SEL-C ruling),
       portraits resolve + assert-exists; gates are PILLAR A achievement
       ids (the cross-pillar clause: the gate flags all exist in
       achievements.gd at this base — no ghost flags).

State ambiguity READINGS (also in the LEDGER row + capture): (1) the
§2.1b hand-in placement reading (char_sel rides BEFORE start_run — the
literal tail placement cannot feed start_run's consumption, F-5); (2) the
F-5 additive xp arm ships (the limit-row precedent), so B-E3's expected
xp row reads 1 + 0.01*xp_pct at the wiped-well Σmeta = 0 the legs run
(the spec's (1+a)(1+b) prose row coincides with it there); (3) the `skin`
save row + SKINS table ride T-M5k (the serial pair's end-state; §2.4
prose names both), this card ships `char` ONLY; (4) the Enter guard gains
chars_visible() — the stages parity (A-E8), test_stages' pin re-pointed
same commit, equal-or-stronger; (5) sim_budget's budget_chars leg belongs
to NO §6 T-M5c file-set row — it rides the T-M5z re-run.
"""

import functools
import json
import os
import re
import subprocess
import tempfile

import pytest

import conftest

REPO = conftest.REPO
GODOT = conftest.GODOT
PROBE = "res://sim/sim_chars.gd"
FIXTURE = os.path.join(os.path.dirname(__file__), "fixtures",
                       "chars-m5.jsonl")
GLB_DIR = os.path.join(REPO, "godot", "assets", "glb")
ICON_DIR = os.path.join(REPO, "godot", "assets", "icons")

pytestmark = pytest.mark.skipif(
    not os.path.exists(GODOT), reason="Godot binary not installed")

read = conftest.read_script
read_code = functools.partial(conftest.read_script, code_only=True)
block = conftest.block

ROSTER = read("roster.gd")
MAIN = read("main.gd")
GAME = read("game_state.gd")
GAME_CODE = read_code("game_state.gd")
HERO = read("hero_pawn.gd")
SCREENS = read("screens.gd")
SAVE = read("save.gd")

# SEL-C (owner ruling "C" over the §2.5 SEL table, M5-SPEC RULING line):
# the 9-row roster truth, spelled ONCE here. ids / meshes / start weapons
# / gates / costs / rules — gates are achievement ids (the flags ride the
# achv: prefix); costs continue the F-6 flat curve 1800/2100/2400.
ROWS = [
    ("the-vigil", "player.glb", "talon", "", 0, {}),
    ("emberwright", "char-emberwright.glb", "ember", "", 300,
     {"dmg_pct": 8}),
    ("grave-ward", "char-grave-ward.glb", "ward", "", 600, {"armor_add": 1}),
    ("coinhound", "char-coinhound.glb", "talon", "", 900, {"gold_add": 40}),
    ("duskrunner", "char-duskrunner.glb", "dart-loop", "achv:kills-50k",
     1200, {"spd_pct": 6}),
    ("tallow-seer", "char-tallow-seer.glb", "censer-of-hours",
     "achv:cycle-1", 1500, {"xp_pct": 10}),
    ("shroud-saint", "char-shroud-saint.glb", "ward", "achv:level-25",
     1800, {"armor_add": 1}),
    ("iron-penitent", "char-iron-penitent.glb", "pilgrim-cross",
     "achv:runs-150", 2100, {"hp_add": 20, "dmg_pct": -4}),
    ("hoard-wretch", "char-hoard-wretch.glb", "bone-whip",
     "achv:gold-10000", 2400, {"gold_add": 80, "spd_pct": -3}),
]
RULE_FIELDS = ["hp_add", "dmg_pct", "spd_pct", "xp_pct", "gold_add",
               "armor_add"]
# display names (the roster table column; row 0 keeps "THE VIGIL" — the
# shipped survivor without a re-brand).
EXPECT_NAMES = {"the-vigil": "THE VIGIL", "emberwright": "THE EMBERWRIGHT",
                "grave-ward": "THE GRAVE-WARD", "coinhound": "THE COINHOUND",
                "duskrunner": "THE DUSKRUNNER",
                "tallow-seer": "THE TALLOW-SEER",
                "shroud-saint": "THE SHROUD-SAINT",
                "iron-penitent": "THE IRON-PENITENT",
                "hoard-wretch": "THE HOARD-WRETCH"}
GOLDEN_ROW0 = {"id": "talon", "level": 1, "cd": 0.0}


# ---- the sim run: throwaway user://, real runs, rows judged here ------------

@pytest.fixture(scope="module")
def dump():
    conftest.ensure_class_cache()
    scratch = tempfile.mkdtemp(prefix="hd3d-chars-")
    env = dict(os.environ, XDG_DATA_HOME=scratch,
               HD3D_CHARS_DUMP=os.path.join(scratch, "chars.jsonl"))
    r = subprocess.run([GODOT, "--headless",
                        "--path", os.path.join(REPO, "godot"), "-s", PROBE],
                       capture_output=True, text=True, env=env, timeout=900)
    assert "CHARS_OK" in r.stdout, "sim_chars did not finish:\n" \
        + r.stdout[-2000:] + r.stderr[-2000:]
    with open(env["HD3D_CHARS_DUMP"], encoding="utf-8") as fh:
        rows = [json.loads(line) for line in fh if line.strip()]
    return rows


def _rows_by(rows, ev):
    return [r for r in rows if r.get("ev") == ev]


def _all_ok(rows, ev):
    sel = _rows_by(rows, ev)
    assert sel, "the %s leg emitted no rows" % ev
    bad = [r for r in sel if not r["ok"]]
    assert not bad, "%s leg RED rows: %s" % (ev, json.dumps(bad)[:800])
    return sel


# ---- B-E2: start rows + the duplicate() law twin -----------------------------

def test_b_e2_start_rows(dump):
    sel = _all_ok(dump, "start_row")
    assert len(sel) == 9, "SEL-C = 9 rows (the owner ruling)"
    for i, row in enumerate(sel):
        assert row["char"] == i and row["id"] == ROWS[i][0]
        assert row["weapon"] == {"id": ROWS[i][2], "level": 1, "cd": 0.0}, \
            "t=0 weapon == the table row, the ONE slot"
    assert sel[0]["weapon"] == GOLDEN_ROW0, \
        "row 0 IS the shipped literal, by VALUE (F-2)"
    assert sel[0]["gold"] == 0 and sel[0]["max_hp"] == 100.0
    assert sel[3]["gold"] == 40 and sel[8]["gold"] == 80
    assert sel[7]["max_hp"] == 120.0


def test_b_e2_alias_guard(dump):
    # THE executed duplicate() law (B-E2 twin): run 1 mutated its weapon
    # dict in-process; the fresh run on the SAME char starts clean.
    row = _all_ok(dump, "alias_guard")[0]
    assert row["before"] == 1 and row["mutated"] == 2 and \
        row["run2_level"] == 1, \
        "a run mutated the shared table row — the duplicate() law is gone"
    # the hand-out seam is the ONLY place the row leaves the table, deep:
    assert re.search(r"return row\(char\)\.start_weapons\.duplicate\(true\)",
                     ROSTER), "start_weapons must hand a DEEP duplicate"
    assert re.search(r"return row\(char\)\.start_passives\.duplicate\(true\)",
                     ROSTER)


def test_b_e2_start_ids_are_shipped_weapons():
    # the §2.2 rider: start weapons are shipped ids (weapons.gd IDS) —
    # zero new weapon code, and a planted non-table id fires this pin.
    m = re.search(r"const IDS\s*:=\s*\[(.*?)\]", read("weapons.gd"), re.S)
    assert m
    shipped = set(re.findall(r'"([\w-]+)"', m.group(1)))
    for _, _, start, _, _, _ in ROWS:
        assert start in shipped, "%s is not a shipped weapons.gd id" % start


# ---- B-E3: the rule terms on the live seams ----------------------------------

def test_b_e3_rule_rows(dump):
    sel = _all_ok(dump, "rule_row")
    assert len(sel) == 9
    for i, row in enumerate(sel):
        rule = dict(zip(RULE_FIELDS, [0] * 6))
        rule.update(ROWS[i][5])
        # floats ride JSON shortest-repr round-trip: judge with an
        # absolute epsilon (the sim's own rule_row checks apply the
        # is_equal_approx law at the LIVE side; the literals here are
        # INDEPENDENT re-spells, not the same expression).
        _close(row["speed"], 140.0 * (1.0 + 0.01 * rule["spd_pct"]))
        _close(row["dmg"], 1.0 + 0.01 * rule["dmg_pct"])
        _close(row["intake_50"], _maxf(50.0 - rule["armor_add"]))
        _close(row["hp"], 100.0 + rule["hp_add"])
        assert row["gold"] == rule["gold_add"]
        _close(row["xp"], 1.0 + 0.01 * rule["xp_pct"])
    # the F-2 identity row, spelled (B-E1's data twin):
    r0 = sel[0]
    assert (r0["speed"], r0["dmg"], r0["intake_50"], r0["hp"], r0["gold"],
            r0["xp"]) == (140.0, 1.0, 50.0, 100.0, 0, 1.0)  # exact zero-identity
    # armor can never heal: intake stays clamped >= 0 (the leg's own
    # intake_clamp check carried it; the row spells the armor rows):
    assert sel[2]["checks"]["intake_clamp"] and sel[6]["checks"]["intake_clamp"]


def _maxf(v):
    return max(0.0, v)


def _close(a, b):
    assert abs(a - b) < 1e-9, "%r != %r" % (a, b)


# ---- B-E4: the selection resets, the snapshot stays 12 ----------------------

def test_b_e4_start_reset_leg(dump):
    row = _all_ok(dump, "start_reset")[0]
    assert row["char_id"] == 0, "bare start_run must reset char_id to 0"
    assert row["snap_n"] == 12, "the Contract B snapshot stays the frozen 12"
    assert "char" not in row["snap_keys"] and "char_id" not in row["snap_keys"]


def test_b_e4_handin_and_reset_source_pins():
    # start_run: the reset READS THE INPUT (the planted red "char_id =
    # <default from a global>" fires this regex leg — capture §planted).
    start = GAME[GAME.index("func start_run"):GAME.index("func set_phase")]
    assert re.search(r"char_id = char_sel", start), \
        "the reset must read the hand-in input, never a global default"
    # main: char_sel hands in BEFORE start_run (the reading: start_run
    # CONSUMES it; the §2.1b tail placement cannot — declared reading).
    assert re.search(r"game\.char_sel = int\(_dawnwell\.char\)\s*\n"
                     r"\t*game\.meta_ranks = _dawnwell\.ranks\.duplicate\(\)"
                     r"\s*\n\t*game\.start_run\(\)", MAIN), \
        "char_sel rides the meta_ranks INPUT pattern before start_run"
    # the pawn re-skin at the F-7 hand-in tail, after seed_stage_props.
    # WINDOW EXTENDED by T-M5k (MC 11423, replace-not-delete): M5 §3.1
    # orders the skin hand-in INSIDE this window (props seed, skin row,
    # pawn re-derive — the §2.1b literal order, spec AS WRITTEN); the
    # tail position of apply_selection is the pinned law and stands.
    assert re.search(r"world\.seed_stage_props\(game\)\s*\n"
                     r"(?:\t*(?:#[^\n]*|game\.skin_id = "
                     r"int\(_dawnwell\.skin\))\s*\n)*"
                     r"\t*_pawn\.apply_selection\(\)", MAIN), \
        "apply_selection rides the hand-in tail after the props seed"
    # hero_pawn: _ready is apply_selection verbatim (boot-once invariant).
    ready = block(HERO, "func _ready", "\nfunc ")
    assert re.search(r"func _ready\(\) -> void:\s*\n\t+apply_selection\(\)\s*\n",
                     ready), \
        "_ready must call apply_selection unchanged (the §2.1b move)"


# ---- B-E5: the verbs ride the rules + the ONE funnel ------------------------

def test_b_e5_verb_source_pins():
    assert re.search(r"char_bought\.connect\(_char_buy\)", MAIN) and \
        re.search(r"char_selected\.connect\(_char_select\)", MAIN) and \
        re.search(r"characters_requested\.connect\(_open_characters\)", MAIN)
    buy = block(MAIN, "func _char_buy", "\nfunc ")
    sel = block(MAIN, "func _char_select", "\nfunc ")
    assert "Roster.buy(_dawnwell" in buy and "_meta_changed()" in buy
    assert "Roster.is_owned(_dawnwell" in sel and "_meta_changed()" in sel
    # the NO-OP-NO-WRITE law: the select keeps the != guard (re-selecting
    # the chosen row writes nothing) — the M4 stage-chosen shape.
    assert re.search(r"_dawnwell\.char != idx", sel)
    for verb in (buy, sel):
        assert ".save(" not in verb, "only the ONE funnel persists"


# ---- B-E6: the select surface -----------------------------------------------

def test_b_e6_states_leg(dump):
    sel = _all_ok(dump, "state")
    assert len(sel) == 9
    assert sel[0]["fresh"] == "selected"          # owns by default (roadmap)
    for i in (1, 2, 3):
        assert sel[i]["fresh"] == "buy"
    for i in (4, 5, 6, 7, 8):
        assert sel[i]["fresh"] == "locked"          # gates NOT set on a fresh well
        assert sel[i]["funded"] == "buy"            # achievement opens the row
    for i in range(9):
        assert sel[i]["owned"] == "selected"


def test_b_e6_overlay_source_pins():
    assert re.search(r"func show_characters\(well: DawnWell\) -> void",
                     SCREENS)
    assert re.search(r"_chars = _overlay\(\)", SCREENS), \
        "the sixth overlay rides the ONE _overlay idiom"
    assert re.search(r"for i in Roster\.CHARACTERS\.size\(\)", SCREENS), \
        "rows rebuild from the ONE table (shop law)"
    assert re.search(r"for child in _chars_rows\.get_children\(\):\s*\n"
                     r"\t*child\.queue_free\(\)", SCREENS)
    assert re.search(r'act\.text = "Locked — %s" % Roster\.gate_name\(i\)\s*\n'
                     r"\t*act\.disabled = true", SCREENS), \
        "locked rows are DISABLED with the achievement NAME, never hidden"
    assert re.search(r'_button\("Characters", _on_characters\)', SCREENS), \
        "the menu seam sits next to the Well (the _button idiom)"
    assert SCREENS.count("_chars.visible = false") >= 2, \
        "hide_all + show_menu hide the sixth overlay too"
    # the §j no-blank law for the new family: unconditional TextureRect +
    # assert-before-load (the same shape as _card's icon).
    assert re.search(r"assert\(ResourceLoader\.exists\(path\)\)\s*\n"
                     r"\t*portrait\.texture = load\(path\)", SCREENS)
    # the Enter guard extension (the stages A-E8 parity; test_stages pin
    # re-pointed same commit, equal-or-stronger).
    assert re.search(r"stages_visible\(\) and not _screens\.chars_visible"
                     r"\(\):", MAIN)


# ---- B-E7: the new meshes live on the pawn ----------------------------------

def test_b_e7_pawn_legs(dump):
    sel = _all_ok(dump, "pawn")
    assert len(sel) == 9, "one pawn row per roster row"
    for i, row in enumerate(sel):
        assert row["mesh"] == ROWS[i][1]
        assert row["fresh_dup"], "the pawn must never mutate the cached import"
    assert re.search(r"mesh = _player_mesh\(\)",
                     block(HERO, "func apply_selection", "\nfunc ")), \
        "apply_selection carries the shipped _ready body (mesh first)"


def test_b_e7_mesh_files_and_budget():
    # the REAL asset rows (post the T-M5s asset commit — this test IS the
    # gate: no stub glb ever passed here, files must EXIST + parse).
    for _, mesh, _, _, _, _ in ROWS:
        path = os.path.join(GLB_DIR, mesh)
        assert os.path.isfile(path), "missing godot/assets/glb/%s" % mesh
        size = os.path.getsize(path) if mesh.endswith(".glb") else 0
        if mesh.endswith(".glb") and mesh != "player.glb":
            assert size > 1000, "%s is a stub-sized file (%d B)" % (mesh, size)
    # turntable-solid eyeball + tri budget: the committed m5-art manifest
    # carries a row per mesh (the asset card's own eyeball); the tris
    # budget row reads the GLB JSON accessor table (the S2r idiom).
    for _, mesh, _, _, _, _ in ROWS[1:]:
        tris = _tri_count(os.path.join(GLB_DIR, mesh))
        assert 0 < tris <= 8000, "%s carries %d tris (budget: 1..8000)" \
            % (mesh, tris)


def _glb_json(path):
    import struct
    with open(path, "rb") as fh:
        magic = fh.read(12)
        assert magic[:4] == b"glTF", "%s is not a glTF binary" % path
        chunk_len, chunk_type = struct.unpack("<I4s", fh.read(8))
        assert chunk_type == b"JSON"
        return json.loads(fh.read(chunk_len).decode("utf-8"))


def _tri_count(path):
    # glTF json: primitives reference ACCESSOR INDICES, not inline arrays
    # — the tri count rides accessors[..].count (TRIANGLES = mode 4).
    g = _glb_json(path)
    total = 0
    for m in g.get("meshes", []):
        for pr in m.get("primitives", []):
            if pr.get("mode", 4) != 4:
                continue
            if "indices" in pr:
                total += g["accessors"][pr["indices"]]["count"] // 3
            else:
                total += g["accessors"][
                    pr["attributes"]["position"]]["count"] // 3
    return total


CLIPS_CSV = os.path.join(os.path.dirname(__file__), "fixtures",
                         "roster-clips-m5-framediff.csv")


RIG_DOC = os.path.join(os.path.dirname(__file__), os.pardir,
                       "docs", "RIG-DEVIATION-SEL-C.md")


def _rig_states():
    # the PIN ARTIFACT is the table, not a hardcoded list: docs/
    # RIG-DEVIATION-SEL-C.md (MC 11440, owner ratification verbatim
    # "Rec" to OPTION A static-shipping). Returns {char_id: "rigged"|"
    # static"} parsed from the "| char-<id>.glb | RIGGED/STATIC |" rows.
    txt = open(os.path.join(os.path.dirname(__file__), os.pardir, "docs",
                            "RIG-DEVIATION-SEL-C.md")).read()
    assert '\"Rec\"' in txt, "owner ratification line gone from pin doc"
    states = {}
    for m in re.finditer(r"\| (\d+) \| char-([\w-]+)\.glb \| "
                         r"(RIGGED|STATIC)[^|]*\| ([^|]*)\|", txt):
        states[m.group(2)] = ("rigged" if m.group(3) == "RIGGED"
                              else "static")
        if m.group(3) == "STATIC":
            assert m.group(4).strip() not in ("", "—"), \
                "static row without a reason: " + m.group(2)
    return states


def test_b_e8_clips_move_pixels():
    # the committed frame-diff CSV, judged against the deviation table:
    # a RIGGED char — walk AND attack, >= 2 px changed between distinct
    # times, and the FROZEN same-time control == 0 px (a gate that never
    # fails on frozen slides measures noise, not motion — the S2r
    # control law, verbatim). A STATIC char — an EXCUSED row per clip
    # that MUST keep diff_px 0 (EXCUSED-not-removed: the row is present
    # and pinned; a static mesh silently GAINING motion changes shape
    # without a doc row goes RED on the state check below). The state
    # set here is measured from docs/RIG-DEVIATION-SEL-C.md — every
    # roster mesh must appear in the table (no ghost rigs, no deleted
    # statics). Row 0 the-vigil rides the S2r player-rigged CSV.
    states = _rig_states()
    assert set(states) == {r[0] for r in ROWS[1:]}, \
        "deviation doc rows != roster rows 1-8"
    assert os.path.isfile(CLIPS_CSV), "roster clips CSV missing"
    import csv as _csv
    with open(CLIPS_CSV, newline="") as fh:
        rows = list(_csv.DictReader(fh))
    for cid, st in states.items():
        mine = [r for r in rows if r["rig"] == cid]
        if st == "rigged":
            assert len(mine) == 6, "%s rigged: 2 clips x 3 pairs" % cid
            for clip in ("walk", "attack"):
                legs = [r for r in mine if r["clip"] == clip]
                assert len(legs) == 3
                for r in legs:
                    d = int(r["diff_px"])
                    assert r["rig_state"] == "rigged"
                    if r["kind"] == "frozen":
                        assert d == 0, ("frozen control moved %d px "
                                        "(noise gate broken): %s" % (d, cid))
                    else:
                        assert d >= 2, "%s %s pair %s moved only %d px" % (
                            cid, clip, r["pair"], d)
        else:
            assert len(mine) == 2, "%s static: 1 excused row per clip" % cid
            for r in mine:
                assert r["kind"] == "excused" and r["rig_state"] == \
                    "static_excused" and int(r["diff_px"]) == 0, \
                    "static row not an honest excused 0-px row: " + cid


# ---- B-E9: the table itself --------------------------------------------------

def test_b_e9_table_source_truth():
    # SCENE-WIDENED by T-M5k (MC 11423): the SKINS table (M5 §3.1) joins
    # roster.gd with its OWN "id"+"name" rows — the SEL-C id scan reads
    # the CHARACTERS block, the block K-E5 already proves its own rows
    # against (test_skins.py); same id list, same law, honest scope.
    ids = re.findall(r'"id": "([\w-]+)", "name"',
                     block(ROSTER, "const CHARACTERS := [", "\n]"))
    assert ids == [r[0] for r in ROWS], "SEL-C ids, in order (owner ruling C)"
    blocks = re.split(r"\n\t\{\"id\":",
                      block(ROSTER, "const CHARACTERS := [", "\n]"))[1:]
    assert len(blocks) == 9
    for blk, (cid, mesh, start, gate, cost, rule) in zip(blocks, ROWS):
        assert '"mesh": "%s"' % mesh in blk
        assert '"cost": %d' % cost in blk
        assert '"gate": "%s"' % gate in blk
        assert '"id": "%s", "level": 1, "cd": 0.0' % start in blk
        for field in RULE_FIELDS:
            # the §2.2 rule-field law: DEFAULTS on every row, never
            # missing keys (read-through without .get).
            assert '"%s": ' % field in blk, "%s lacks rule field %s" % (cid,
                                                                        field)
            want = rule.get(field, 0)
            assert re.search(r'"%s": %s[,}]' % (field, re.escape(str(want))),
                             blk), "%s rule %s != %d" % (cid, field, want)
        assert '"name": "%s"' % EXPECT_NAMES[cid] in blk
        assert '"start_passives": {}' in blk


def test_b_e9_gates_are_pillar_a_achievement_ids():
    achv = read("achievements.gd")
    ids = set(re.findall(r'\{"id": "([\w-]+)"', achv))
    for _, _, _, gate, _, _ in ROWS:
        if gate:
            assert gate.startswith("achv:") and gate[5:] in ids, \
                "gate %s names no achievements.gd row (cross-pillar law)" \
                % gate


def test_b_e9_portraits_resolve_and_exist():
    # the §j total resolver for the new family + the committed files.
    assert re.search(r'return "res://assets/icons/%s\.png" % String'
                     r'\(row\(char\)\.portrait\)', ROSTER)
    m = re.findall(r'"portrait": "([\w-]+)"', ROSTER)
    assert m == ["icon-portrait-" + r[0] for r in ROWS]
    for p in m:
        assert os.path.isfile(os.path.join(ICON_DIR, p + ".png")), \
            "missing godot/assets/icons/%s.png (T-M5s asset row)" % p


def test_b_e9_save_rows_ship_char_then_skin_end_state():
    # FALSIFIED-BY-DESIGN AND REPLACED at T-M5k (MC 11423, replace-not-
    # delete, this note is the history): the T-M5c original asserted the
    # save row ships `char` NOT `skin` — the serial pair's promise (the
    # `skin` row rides T-M5k, reading (3)). T-M5k LANDED, so the promise
    # pin is replaced by the END-STATE it promised: BOTH rows ship, each
    # field-by-field added, VERSION unchanged (the R1 in-series law — the
    # disk exact-set readers in test_save.py/test_dawnwell_shop.py carry
    # the grown set same-commit).
    assert re.search(r"var char := 0", SAVE)
    assert re.search(r'well\.char = int\(data\.get\("char", 0\)\)', SAVE)
    assert re.search(r"var skin := 0", SAVE)
    assert re.search(r'well\.skin = int\(data\.get\("skin", 0\)\)', SAVE)
    assert re.search(r'"char": char, "skin": skin\}', SAVE)
    assert re.search(r"const VERSION := 1", SAVE), \
        "the serial pair ships WITHOUT a version bump (the migration law)"


# ---- the forward-lock: the committed fixture stands the same judge ----------

def test_chars_fixture_forward_lock():
    assert os.path.isfile(FIXTURE), "tests/fixtures/chars-m5.jsonl missing"
    with open(FIXTURE, encoding="utf-8") as fh:
        rows = [json.loads(line) for line in fh if line.strip()]
    for ev in ("start_row", "rule_row", "pawn", "state"):
        _all_ok(rows, ev)
    _all_ok(rows, "alias_guard")
    _all_ok(rows, "start_reset")
