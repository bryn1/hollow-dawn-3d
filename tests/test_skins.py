"""SKINS (M5-SPEC §3, T-M5k, MC 11423) — 5 meshes on the player-rig shape.

ACCEPT rows K-E1..K-E5 (spec §3.3), row-per-test with the ONE seam each
reads; the planted reds fire on the FINAL tree in the card capture
(.tmp/m5k-skins.txt) and are cp+cmp byte-restored there:

  K-E1 default skin byte law   the §7.1 corpus re-run (journey 5020
       @HD3D_SEED=11101 + the committed fixtures + strips modulo norm, ALL
       cmp-identical vs the pre-edit base dump, base==committed proven
       FIRST) lives in the CAPTURE, NOT pytest (the B-E1/E1 idiom). The
       pytest-side twin: the hand-in/reset/source pins below (skin unset =
       0 = the literal player.glb branch of the ONE seam, KEPT verbatim)
       + the probe's `pawn_default` row-0 cache-identity twin — the
       planted "the seam reads skin 1 by default" goes RED there while
       B-E1's byte corpora STAY GREEN: the independent-attribution pair.
       The art-fixture PLAYER row (1.67 m) stays byte-verbatim (the
       forward-lock growth below it only, R2) — asserted in test_k_e2.
  K-E2 mesh gates per skin     file+tri rows (5/5, the §2.3 player-class
       budget — the tri reader rides its ONE home in test_characters, the
       C2 seam law restated) + the art-fixture height rows (rel_err 0.0
       at MODEL_H_PLAYER through the ONE ClassMesh seam, the R2 FIFTH
       growth: the 26 prior rows byte-preserved as the prefix, the PLAYER
       row verbatim) + the chip-icon family file-exists.
  K-E3 clips per skin          the committed roster clips CSV, the skin
       rows judged against the PIN DOC docs/RIG-DEVIATION-SEL-C.md — the
       B-E8 pattern RE-RIDDEN (the doc PARSED, not a hardcoded list:
       owner ratification verbatim "Rec" asserted, static rows require a
       reason, RIGGED measured at frame-diff >= 2 px walk/attack +
       FROZEN 0 px, STATIC EXCUSED 0-px rows). Row 0 the-vigil DEFAULT
       rides the S2r player-rigged CSV (the skin-0 byte law); a SKIN
       mesh is its own rig row here. The planted doc-flip (RIGGED ->
       STATIC) goes RED — executed in the capture.
  K-E4 the skin verbs          godot/sim/skin_probe.gd (the shop law
       shape, K-E4's named seam): purchase flag `skin:<id>` + spend the
       EXACT table price through the ONE rule surface (disk read back);
       unaffordable / owned / unknown = NO-OP-NO-WRITE; selecting a skin
       the selected char cannot wear (empty group) = NO-OP write-side,
       and the RENDER side falls back to the char's own mesh (never
       another char's skin); re-select = disk byte-identical. Verb
       source pins: the two thin main wrappers over the ONE funnel,
       ZERO .save( sites; the chip row renders ONLY under the selected
       row with a NON-EMPTY group (F-8's inner row-set, the K-E4
       chip-disabled UI side) and the buy chip DISABLES unaffordable,
       never hidden (the shop's both-sides law).
  K-E5 the SKINS table         pytest table pin: 5 rows, ids verbatim,
       prices 200/400/600/800/1000 (the spec's curve, no gates — roadmap
       item 4 names none), mesh ids ∈ files on disk, chip icons ∈ files,
       GROUP LAW: only the-vigil's row carries the five (rows 1-8 ship
       `skins: []`); the id->pos map + the chip resolver pin.

State ambiguity READINGS (also in the LEDGER row + capture): (1) the well
`skin` row is a GROUP POSITION — 0 = default (the char's own mesh, the
byte law), k >= 1 = the group's k-th entry; the group order is pinned ==
the SKINS table order by test_k_e5, so the position and the table row are
one truth; (2) the skin hand-in rides the §2.1b literal order (AFTER
start_run, BEFORE the apply_selection tail — the reaper/stage pattern:
unlike char, a skin feeds NO start_run consumption, so no input-row twin
is needed); (3) §3.2's file column omits game_state.gd / sim_funnel.gd /
art_probe.gd while the MECHANISM rows require them (game_state's own
:78 comment pre-declares the skin rows riding with the table; §7.1 names
the SimFunnel DECLARED opts growth; R2's fixture producer IS art_probe) —
the wave-map column lists the shared-file serials, not a closed set;
(4) the K-E4 "chip-disabled UI-side" for an empty group lands as the
group law itself: an unwearable char renders NO chip row (there is
nothing to disable — the write side refuses every pos, the probe's
wear + nogroup legs pin both sides); (5) the default chip's id string
"default" maps to pos 0 INSIDE Roster (SKIN_DEFAULT_ID) — the verbs stay
thin; (6) K-E2's "turntable-solid eyeball" rows are the asset card's
binding gates (T-M5s, 13/13 SOLID, capture .tmp/m5-art.txt — the bpy seat
lives on the 3090, not in pytest); this card re-pins what its seams can
measure (file/tris/height + the CSV clips).
"""

import functools
import os
import re
import subprocess
import tempfile

import pytest

import conftest
import test_characters as tc

REPO = conftest.REPO
GODOT = conftest.GODOT
PROBE = "res://sim/skin_probe.gd"
GLB_DIR = os.path.join(REPO, "godot", "assets", "glb")
ICON_DIR = os.path.join(REPO, "godot", "assets", "icons")
CLIPS_CSV = tc.CLIPS_CSV
RIG_DOC = tc.RIG_DOC
ART_FIXTURE = os.path.join(REPO, "tests", "fixtures", "art-s2i-probe.jsonl")

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

# THE table (M5-SPEC §3.1 verbatim): 5 rows, prices 200/400/600/800/1000,
# ids = the committed GLBs, rig state per docs/RIG-DEVIATION-SEL-C.md.
SKIN_ROWS = [
    ("skin-ash", "skin-ash.glb", 200),
    ("skin-marrow", "skin-marrow.glb", 400),
    ("skin-tide", "skin-tide.glb", 600),
    ("skin-relic", "skin-relic.glb", 800),
    ("skin-void", "skin-void.glb", 1000),
]
RIGGED = {"skin-ash", "skin-marrow", "skin-relic"}      # doc rows 9/10/12
STATIC = {"skin-tide", "skin-void"}                     # doc rows 11/13


# ---- the probe: one REAL headless run on a throwaway user:// ----------------

@pytest.fixture(scope="module")
def probe():
    """One REAL headless run of skin_probe.gd under a throwaway
    XDG_DATA_HOME (the T-M1a isolation pattern; the LEG-row parser is the
    shape test_dawnwell_shop/test_save/test_achievements each carry — the
    conftest fold of THAT family stays the clean-code card's, this file
    adds no second mechanism). Returns {leg: {k: v}} + the disk JSON row
    emitted by the buy leg."""
    conftest.ensure_class_cache()
    scratch = tempfile.mkdtemp(prefix="hd3d-skins-")
    r = subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(REPO, "godot"),
         "-s", PROBE],
        env=dict(os.environ, XDG_DATA_HOME=scratch),
        capture_output=True, text=True, timeout=600)
    assert r.returncode == 0 and "PROBE_DONE" in r.stdout, \
        "probe run failed:\n%s\n%s" % (r.stdout[-2000:], r.stderr[-2000:])
    rows, json_text = {}, None
    for line in r.stdout.splitlines():
        if line.startswith("JSON "):
            json_text = line[len("JSON "):]
        elif line.startswith("LEG "):
            parts = line.split()
            kv = {}
            for tok in parts[2:]:
                k, _, v = tok.partition("=")
                kv[k] = int(v) if re.fullmatch(r"-?\d+", v) else v
            rows[parts[1]] = kv
    return rows, json_text


# ---- K-E1: default skin = the shipped byte law -------------------------------

def test_k_e1_handin_reset_and_default_source_pins():
    # the hand-in rides the §2.1b literal order (reading (2)): AFTER
    # start_run, BEFORE the apply_selection tail — the reaper/stage seam.
    hand = block(MAIN, "func _start_game", "func _enter_levelup")
    assert re.search(r"game\.skin_id = int\(_dawnwell\.skin\)", hand), \
        "the well's skin row must reach the run var at the ONE hand-in"
    assert hand.index("game.skin_id") < hand.index("_pawn.apply_selection()"), \
        "the skin lands BEFORE the pawn re-derive (mesh read LAST, §2.1b)"
    assert hand.index("start_run()") < hand.index("game.skin_id"), \
        "start_run resets it — the hand-in seam re-hands it after (B-E4)"
    # the start_run reset row (the reaper pattern's twin): a bare run = 0.
    assert re.search(r"skin_id = 0\b", block(GAME_CODE,
                     "func start_run", "func set_phase")), \
        "start_run must reset skin_id (never a global default)"
    # the save default (R1's FIFTH restate: unset disk field -> 0).
    assert re.search(r'well\.skin = int\(data\.get\("skin", 0\)\)', SAVE)
    # the ONE seam: the skin read is the single Roster.skin_mesh
    # expression AND the literal player.glb branch stays verbatim
    # (test_art_integration carries the substring law; this is the
    # DEFAULT-BRANCH twin: skin 0 must fall through to the literal).
    seam = block(HERO, "func _player_mesh", "\nfunc ")
    assert "Roster.skin_mesh(" in seam, \
        "the ONE seam must read the skin group through Roster"
    assert 'ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER)' \
        in seam, "the shipped default branch must stay verbatim (F-2)"


def test_k_e1_pawn_default_row0_twin(probe):
    # the independent-attribution twin (the K-E1 red cell): the LIVE pawn
    # of a default run IS the cached player.glb mesh object. A planted
    # "seam reads skin 1 by default" flips THIS (and the strips/art rows
    # the capture re-dumps) while the journey/fixtures byte corpora —
    # B-E1's lane — STAY GREEN: run state never saw the pawn.
    rows, _ = probe
    want = {"glb": "player.glb", "char": 0, "skin": 0, "mesh_identity": 1,
            "fresh_dup": 1, "unshaded": 1, "tint": 1}
    assert rows["pawn_default"] == want


# ---- K-E2: mesh gates per skin (file + tris + height, the §2.3 law) ---------

def test_k_e2_mesh_files_and_tri_budget():
    for sid, mesh, _ in SKIN_ROWS:
        path = os.path.join(GLB_DIR, mesh)
        assert os.path.isfile(path), "missing godot/assets/glb/%s" % mesh
        assert os.path.getsize(path) > 1000, "%s is stub-sized" % mesh
        tris = tc._tri_count(path)  # the ONE tri reader (C2 home)
        assert 0 < tris <= 8000, "%s carries %d tris (budget: 1..8000)" \
            % (mesh, tris)
    # the §j chip family: every row's icon file exists (resolver pinned
    # at K-E5; the draw site asserts before load, screens.gd).
    for sid, _, _ in SKIN_ROWS:
        assert os.path.isfile(os.path.join(
            ICON_DIR, "icon-%s.png" % sid)), "missing chip icon %s" % sid


def test_k_e2_height_rows_in_art_fixture():
    # R2 FIFTH growth: the five SKIN rows join the measured table at the
    # PLAYER height row (1.67 m), rel_err 0.0 through the ONE ClassMesh
    # seam — AND the PLAYER row itself is UNTOUCHED (K-E1's art clause):
    # the 26 prior rows byte-preserved as the prefix.
    rows = conftest.jsonl_rows(ART_FIXTURE)
    assert len(rows) == 31, "art fixture must carry 26 prior + 5 skin rows"
    # prefix law: the 26 prior rows byte-preserved (the capture proves
    # them cmp-identical to the pre-edit base dump; the PLAYER-row
    # verbatim row below is the K-E1 art clause's in-suite twin).
    by_class = {r["class"]: r for r in rows if r.get("ev") == "height"}
    for sid, mesh, _ in SKIN_ROWS:
        r = by_class.get(sid)
        assert r is not None, "skin %s missing from the height table" % sid
        assert r["glb"] == mesh and r["mesh"] == "ArrayMesh"
        assert r["target_m"] == 1.67 and r["measured_m"] == 1.67
        assert r["rel_err"] == 0.0, "%s off the PLAYER row" % sid
    player = by_class["player"]
    assert player == {"class": "player", "ev": "height",
                      "glb": "player.glb", "mesh": "ArrayMesh",
                      "target_m": 1.67, "measured_m": 1.67, "rel_err": 0.0}, \
        "the art-fixture PLAYER row moved (K-E1 says it must not)"


# ---- K-E3: clips per skin, judged against the PIN DOC -----------------------

def _skin_doc_states():
    # the B-E8 parser RE-RIDDEN for the skin family (the doc's OWN rows,
    # char/skin regexes mutually exclusive by the file-name family):
    # returns {"skin-<id>": "rigged"|"static"} and pins the doc's honesty
    # clauses — owner "Rec" verbatim, every STATIC row carries a REASON.
    with open(RIG_DOC, encoding="utf-8") as fh:
        txt = fh.read()
    assert '"Rec"' in txt, "owner ratification line gone from pin doc"
    states = {}
    for m in re.finditer(r"\| (\d+) \| (skin-[\w-]+)\.glb \| "
                         r"(RIGGED|STATIC)[^|]*\| ([^|]*)\|", txt):
        states[m.group(2)] = "rigged" if m.group(3) == "RIGGED" else "static"
        if m.group(3) == "STATIC":
            assert m.group(4).strip() not in ("", "—"), \
                "static row without a reason: " + m.group(2)
    return states


def test_k_e3_clips_move_pixels():
    states = _skin_doc_states()
    assert set(states) == {sid for sid, _, _ in SKIN_ROWS}, \
        "deviation doc skin rows != the SKINS table"
    assert states == {sid: ("rigged" if sid in RIGGED else "static")
                      for sid, _, _ in SKIN_ROWS}, \
        "doc rig state drifted from the shipped files' recorded truth"
    assert os.path.isfile(CLIPS_CSV), "roster clips CSV missing"
    import csv as _csv
    with open(CLIPS_CSV, newline="") as fh:
        rows = list(_csv.DictReader(fh))
    for sid, st in states.items():
        mine = [r for r in rows if r["rig"] == sid]
        if st == "rigged":
            assert len(mine) == 6, "%s rigged: 2 clips x 3 pairs" % sid
            for clip in ("walk", "attack"):
                legs = [r for r in mine if r["clip"] == clip]
                assert len(legs) == 3
                for r in legs:
                    d = int(r["diff_px"])
                    assert r["rig_state"] == "rigged"
                    if r["kind"] == "frozen":
                        assert d == 0, ("frozen control moved %d px "
                                        "(noise gate broken): %s" % (d, sid))
                    else:
                        assert d >= 2, "%s %s pair %s moved only %d px" % (
                            sid, clip, r["pair"], d)
        else:
            assert len(mine) == 2, "%s static: 1 excused row per clip" % sid
            for r in mine:
                assert r["kind"] == "excused" and r["rig_state"] == \
                    "static_excused" and int(r["diff_px"]) == 0, \
                    "static row not an honest excused 0-px row: " + sid


# ---- K-E4: the verbs — probe legs + source pins ------------------------------

def test_k_e4_probe_legs(probe):
    rows, json_text = probe
    import json as _json
    assert rows["table"] == {"rows": 5, "prices_ok": 1, "group_ok": 1,
                             "map_ok": 1, "unknown": -1}
    assert rows["buy"] == {"ok": 5, "spent": 3000, "expected": 3000,
                           "flags": 5, "gold": 0, "reload_flags": 5,
                           "reload_gold": 0, "saved": 1, "skin_zero": 1}, \
        "the purchase arc must write the five flags + spend the EXACT curve"
    disk = _json.loads(json_text)
    assert set(k for k in disk["flags"] if k.startswith("skin:")) == \
        {"skin:" + sid for sid, _, _ in SKIN_ROWS}
    assert rows["poor"] == {"ok": 0, "flag_absent": 1, "gold": 199,
                            "pos_bad": 1}, "unaffordable/garbage must NO-OP"
    assert rows["twice"] == {"first": 1, "second": 0, "paid": 200,
                             "expected": 200}, "buy-once, refund never"
    assert rows["wear"] == {"select": 1, "skin_disk": 1, "saved": 1,
                            "no_wear": 0, "skin_held": 1, "gold_held": 1,
                            "default_select": 1, "skin_now": 1,
                            "deep_wear": 0, "deep_skin": 1}, \
        "the wear law broke: an empty-group char MOVED the skin row (the " \
        "K-E4 planted-red class) — both the same-pos re-select and the " \
        "owned-different-pos deep case must refuse"
    assert rows["reselect"] == {"refused": 1, "disk_same": 1}
    assert rows["migrate"] == {"skin_default": 1, "char_kept": 1,
                               "gold_kept": 1, "not_quarantined": 1}, \
        "an older save must migrate skin -> 0, not quarantine (R1)"


def test_k_e4_chip_state_rows(probe):
    rows, _ = probe
    fresh = dict(tok.split(":") for tok in
                 rows["states"]["fresh"][1:-1].split(";") if tok)
    assert fresh == {str(i): ("selected" if i == 0 else "buy")
                     for i in range(6)}, \
        "a fresh well: default selected, the five BUY (no gates — §3.1)"
    funded = dict(tok.split(":") for tok in
                  rows["states"]["funded"][1:-1].split(";") if tok)
    assert funded == fresh, "funding changes STATES, never writes flags"
    owned = dict(tok.split(":") for tok in
                 rows["states"]["owned1"][1:-1].split(";") if tok)
    assert owned == {"1": "owned", "2": "buy"}, "owned != worn: Select"
    worn = dict(tok.split(":") for tok in
                rows["states"]["worn1"][1:-1].split(";") if tok)
    assert worn == {"0": "owned", "1": "selected"}, "worn row SELECTED"
    assert rows["states"]["nogroup_char"] == "[1:unwearable]", \
        "an empty-group char reads UNWEARABLE for every entry (K-E4)"


def test_k_e4_verb_source_pins():
    buy = block(MAIN, "func _char_buy_skin", "\nfunc ")
    sel = block(MAIN, "func _char_select_skin", "\nfunc ")
    assert "Roster.skin_buy(_dawnwell" in buy and "_meta_changed()" in buy
    assert "Roster.skin_select(_dawnwell" in sel and "_meta_changed()" in sel
    assert ".save(" not in buy and ".save(" not in sel, \
        "verbs never touch disk — the ONE funnel law (F-6)"
    assert "_screens.skin_bought.connect(_char_buy_skin)" in MAIN
    assert "_screens.skin_selected.connect(_char_select_skin)" in MAIN
    # the chip row: rendered ONLY under the selected row with a NON-EMPTY
    # group (F-8's inner row-set — the wear law's UI side, reading (4)),
    # and the buy chip DISABLES unaffordable, never hidden (shop law).
    assert re.search(r"if st == \"selected\":\s*\n"
                     r"\t*var grp: Array = Roster\.skins_for\(i\)\s*\n"
                     r"\t*if grp\.size\(\) > 0:", SCREENS), \
        "the skin row rides the selected row's non-empty group"
    chips = block(SCREENS, "func _skin_chips", "\nfunc ")
    assert "chip.disabled = _well.gold < Roster.skin_cost(pos)" in chips, \
        "the buy chip is DISABLED unaffordable, never hidden"
    assert "skin_bought.emit" in chips and "skin_selected.emit" in chips
    assert "assert(ResourceLoader.exists(path))" in chips, \
        "the §j assert-before-load carries the chip family"


# ---- K-E5: the SKINS table itself --------------------------------------------

def test_k_e5_table_pin_and_group_law():
    tbl = block(ROSTER, "const SKINS := [", "\n]")
    ids = re.findall(r'\{"id": "(skin-[\w-]+)"', tbl)
    assert ids == [r[0] for r in SKIN_ROWS], "SKINS ids, in order (§3.1)"
    for sid, mesh, cost in SKIN_ROWS:
        blk = tbl[tbl.index('"id": "%s"' % sid):]
        blk = blk[: blk.index("},") + 2]
        assert '"mesh": "%s"' % mesh in blk, "%s mesh row" % sid
        assert '"cost": %d' % cost in blk, "%s price (§3.1 curve)" % sid
        assert '"gate"' not in blk, "skins carry NO gates (roadmap item 4)"
        assert os.path.isfile(os.path.join(GLB_DIR, mesh)), \
            "id %s has no file on disk (K-E5's planted-red class)" % sid
    # GROUP LAW: only the-vigil (row 0) carries the five, in table order.
    blocks = re.split(r"\n\t\{\"id\":", ROSTER)[1:9]  # the CHARACTERS rows
    groups = [re.findall('"([\w-]+)"',
              re.search(r'"skins": \[([^\]]*)\]', b).group(1))
              for b in blocks]
    assert groups[0] == [r[0] for r in SKIN_ROWS], \
        "row 0's group: the five ids in SKINS order"
    assert all(g == [] for g in groups[1:]), \
        "group law: only row 0 is non-empty this release (§3.1)"
    # the chip resolver (§j restated for the chip family) + the id map.
    assert re.search(r'return "res://assets/icons/%s\.png" % String'
                     r'\(skin_row\(pos\)\.chip\)', ROSTER)
    assert re.search(r'if id == SKIN_DEFAULT_ID:\s*\n\t*return 0', ROSTER), \
        "the default chip maps to pos 0 inside the rule module (reading (5))"
