"""ACHIEVEMENTS + THE COUNTER STORE (M5-SPEC §1, T-M5p, MC 11421).

ACCEPT rows P-E1..P-E7 (spec §1.3) — the row-per-test map below names the
ONE seam each reads (plus the planted reds, which are fired on the FINAL
tree in the card capture, .tmp/m5p-ach.txt, and cp+cmp byte-restored):

  P-E1 counters law BOTH sides   achv_probe legs `sumadd` (Σ-add exact +
       max-rule exact) + `worse_run` (never-decreases) + the REV-2/P2-3
       zero-DIFF leg `zero_diff` (only Σ-add rows move, by exact deltas;
       no new flag, no max-rule move; the always-write law is stated in
       the spec row — runs_total moves every end, the funnel writes).
  P-E2 flag law                   legs `sumadd`/`roundtrip` (SET once,
       read back OFF THE DISK) + `worse_run` flags_kept (a later worse
       run never unsets; the stage-chain both-side shape) + int-valued.
  P-E3 funnel law, REAL           source pins: the landing position inside
       _end_run (below the best_cycle write, ABOVE the gold line — the
       forced P2-1 landing) + the named NEW whole-godot/scripts/ grep pin
       (zero `.save(` sites outside save.gd and main._meta_changed's own
       body, `main.gd:421` the one legal outside site at base) + the
       shipped `_meta_changed(` occurrence set (7 at base, re-counted).
       The shipped instruments — test_save's MAIN-scoped save-count and
       test_stages' end_run-scoped funnel count — stay green UNTOUCHED
       (they run in the same suite; this file adds ZERO to both).
  P-E4 save shape                 the disk key-set pin moved with it — the
       R1 re-pin lives IN test_save.py (third honest move, replace-not-
       delete, same commit); this file carries the migration-default and
       no-bump source rows; the {} default BEHAVES in the probe's
       `migrate` leg.
  P-E5 achievements page          source pins below (seventh overlay in the
       ONE style, rows from the ONE table); the PIXEL row is
       tools/dawnwell_pixel_gate.py's `achievements_shot` (capture, R3
       additive row, floor 200 — same hidden-UI baseline).
  P-E6 table law                  pytest table pin (the LIMIT_CARDS shape:
       source-truth over the rows) + the probe's `table` leg (the
       progress rows).
  P-E7 byte corpus                the capture's fresh dumps vs this tree
       (the §7.1 re-run pattern lives in the capture, not pytest — the
       T-C3 gate idiom; the standing journey leak instrument).
"""

import functools
import os
import re
import subprocess
import tempfile

import pytest

import conftest

REPO = conftest.REPO
GODOT = conftest.GODOT
PROBE = "res://sim/achv_probe.gd"

pytestmark = pytest.mark.skipif(
    not os.path.exists(GODOT), reason="Godot binary not installed")

read = conftest.read_script
read_code = functools.partial(conftest.read_script, code_only=True)
block = conftest.block

ACHV = read("achievements.gd")
MAIN = read("main.gd")
SAVE = read("save.gd")
SCREENS = read("screens.gd")


# ---- the probe: throwaway user://, fresh run, rows judged here --------------

@pytest.fixture(scope="module")
def probe():
    conftest.ensure_class_cache()
    scratch = tempfile.mkdtemp(prefix="hd3d-achv-probe-")
    env = dict(os.environ, XDG_DATA_HOME=scratch)
    r = subprocess.run([GODOT, "--headless",
                        "--path", os.path.join(REPO, "godot"), "-s", PROBE],
                       capture_output=True, text=True, env=env, timeout=900)
    lines = r.stdout.splitlines()
    assert "PROBE_DONE" in lines, "achv probe did not finish:\n" + r.stdout
    verdict = [ln for ln in lines if ln.startswith("VERDICT")]
    assert verdict == ["VERDICT rows=6 ok=true"], verdict
    rows = {}
    for ln in lines:
        if ln.startswith("LEG "):
            parts = ln.split()
            rows[parts[1]] = dict(kv.split("=") for kv in parts[2:])
    assert len(rows) == 6, rows.keys()
    return rows


def _green(rows, leg, *checks):
    assert leg in rows, "leg %r missing" % leg
    bad = [c for c in checks if rows[leg].get(c) != "1"]
    assert not bad, "%s checks RED: %s" % (leg, bad)


# ---- P-E1: counters law, BOTH sides -------------------------------------------

def test_p_e1_sigma_add_and_max_rules_exact(probe):
    _green(probe, "sumadd", "kills_exact", "gold_exact", "runs_one",
           "win_one", "minutes_floor_2", "max_level_13", "evo_one",
           "union_one", "best_cycle_not_rehomed")
    _green(probe, "worse_run", "kills_add_exact", "gold_add_exact",
           "runs_two", "wins_unchanged", "minutes_add_zero",
           "max_level_never_decreases", "evo_never_decreases")


def test_p_e1_zero_diff_leg(probe):
    # REV-2/P2-3 (fold F-4): the corrected leg — Σ-add rows move by EXACT
    # deltas, no new flag, no max-rule move; nothing else moves either.
    _green(probe, "zero_diff", "kills_delta_exact", "gold_delta_exact",
           "runs_delta_exact", "minutes_delta_exact", "max_level_unmoved",
           "evo_unmoved", "union_unmoved", "no_new_flags",
           "best_cycle_unmoved")


# ---- P-E2: flag law -----------------------------------------------------------

def test_p_e2_flags_set_once_and_survive_the_disk(probe):
    _green(probe, "sumadd", "flags_set", "flags_absent")
    _green(probe, "roundtrip", "flags_reload", "disk_has_counters",
           "disk_flag_one", "version_still_1", "counters_reload")
    _green(probe, "worse_run", "flags_kept", "flags_int_one")


# ---- P-E3: funnel law with the REAL instruments -------------------------------

def test_p_e3_block_lands_forced_between_best_cycle_and_gold():
    end_run = block(MAIN, "func _end_run", "\nfunc ")
    i_best = end_run.index("if game.cycle > _dawnwell.best_cycle:")
    i_upd = end_run.index("Achievements.update(_dawnwell, game, world)")
    i_gold = end_run.index("_dawnwell.gold += game.stats.gold")
    i_fun = end_run.index("_meta_changed()", i_gold)
    assert i_best < i_upd < i_gold, \
        "the block lands BELOW the best_cycle max-rule write and ABOVE the " \
        "gold cash-out (the P2-1 forced landing)"
    assert i_gold < i_fun, "the gold line still precedes the ONE funnel"
    assert end_run.count("_meta_changed()") == 1, \
        "the block adds NO funnel call (PIN-HOLD clause; test_stages:296 " \
        "stays green UNTOUCHED — same count, this pin names it too)"
    assert ".save(" not in end_run, \
        "the block adds NO save call either — persistence is the funnel's"


def test_p_e3_whole_scripts_save_pin():
    # the named NEW grep pin (REV-2/P2-4): scope NAMED — ALL of
    # godot/scripts/ — zero `.save(` call sites outside save.gd and
    # main._meta_changed's OWN body (measured at base: exactly one outside
    # site exists, the funnel itself). No cross-file blind spot.
    for fn in sorted(os.listdir(conftest.SCRIPTS)):
        if not fn.endswith(".gd") or fn == "save.gd":
            continue
        src = read(fn)
        if fn == "main.gd":
            funnel = block(MAIN, "func _meta_changed", "\nfunc ")
            assert src.count(".save(") == 1 and funnel.count(".save(") == 1, \
                "main.gd's only .save( call must BE the funnel body"
        else:
            assert ".save(" not in src, \
                "%s writes to disk itself — the one-funnel law is broken" % fn
    # the shipped occurrence set: 6 call sites + the definition == 7
    # (measured at base 9b1d067 by the DA gate; re-counted at this card —
    # the block adds ZERO to both instruments). RE-COUNTED AGAIN by
    # T-M5c (MC 11422): the roster buy + select verbs are two NEW funnel
    # call SITES (the shop's _shop_buy pattern, spec §2.2 — every roster
    # mutation persists through this ONE funnel), 8 sites + the definition
    # == 9. RE-COUNTED AGAIN by T-M5k (MC 11423): the skin buy + select
    # verbs are two MORE funnel call SITES (the roster verbs' own pattern,
    # M5-SPEC §3.1 — every skin mutation persists through this ONE
    # funnel), 10 sites + the definition == 11; the MAIN-scoped `.save(`
    # count stays 1 (the funnel body — the loop above re-proves it every
    # run, this card included).
    assert MAIN.count("_meta_changed(") == 11, \
        "the funnel occurrence set moved without a retire row"


# ---- P-E4: save shape (the R1 re-pin lives in test_save.py) --------------------

def test_p_e4_counters_field_additive_no_bump():
    # field-by-field ADDED row, VERSION unchanged: the loader defaults the
    # missing field to {} through the shipped _int_dict migration seam.
    assert re.search(r"well\.counters = _int_dict\(data\.get\(\"counters\","
                     r" \{\}\)\)", SAVE), "the §1.1 field-by-field default"
    assert re.search(r"var counters: Dictionary = \{\}", SAVE)
    # VERSION stays 1: the no-bump instrument is test_version_is_int_one
    # (test_save.py, untouched) — greening here by construction.
    assert "\"counters\": counters" in read_code("save.gd").split("func as_data")[1]


# ---- P-E5: the seventh overlay in the ONE style (source half) ------------------

def test_p_e5_achievements_is_the_seventh_overlay():
    assert re.search(r"_achv = _overlay\(\)", SCREENS), "seventh overlay, same idiom"
    assert SCREENS.count("_achv.visible = false") >= 2, \
        "show_menu AND hide_all own the new overlay (no-blank law, §j)"
    assert re.search(r"func achievements_visible\(\) -> bool", SCREENS)
    assert re.search(r"for row in Achievements\.TABLE", SCREENS), \
        "rows rebuild from the ONE table, per open (shop law)"
    assert re.search(r"Achievements\.progress\(_well, row\)", SCREENS), \
        "the progress term reads the ONE progress seam, min(count, target)"
    assert re.search(r'_button\("Achievements", _on_achievements\)', SCREENS), \
        "menu gains the button, same idiom"
    assert re.search(r"achievements_requested\.emit\(\)", SCREENS) and \
        re.search(r"achievements_closed\.emit\(\)", SCREENS)
    assert "achievements_requested.connect(_open_achievements)" in MAIN and \
        "achievements_closed.connect(_close_achievements)" in MAIN
    verbs = block(MAIN, "func _open_achievements", "\nfunc ") + \
        block(MAIN, "func _close_achievements", "\nfunc ")
    assert "_meta_changed" not in verbs and ".save(" not in verbs, \
        "display-only law: no verb writes here (spec §1.1)"


# ---- P-E6: table law, pytest source pin (the LIMIT_CARDS shape) ----------------

def _table_rows():
    tbl = block(ACHV, "const TABLE := [", "\n]")
    rows = re.findall(
        r'\{"id": "([^"]+)", "name": "([^"]*)", "counter": "([^"]+)",'
        r' "target": (\d+)\}', tbl)
    assert len(rows) == 20, "TABLE must carry EXACTLY 20 rows, got %d" % len(rows)
    return rows


def test_p_e6_table_rows_are_unique_and_counters_named():
    rows = _table_rows()
    ids = [r[0] for r in rows]
    assert len(set(ids)) == 20, "achievement ids are unique"
    counters = re.search(r"const COUNTERS := \[([^\]]+)\]", ACHV)
    assert counters, "the named counter set const is missing"
    named = set(re.findall(r'"([a-z_]+)"', counters.group(1)))
    orphans = sorted({r[2] for r in rows} - named)
    assert not orphans, "orphan counters (no producer in §1.1): %s" % orphans


def test_p_e6_prefix_is_one_named_const():
    assert len(re.findall(r"const\s+ACHV_PREFIX\s*:=", ACHV)) == 1
    m = re.search(r'const\s+ACHV_PREFIX\s*:=\s*"([^"]+)"', ACHV)
    assert m and m.group(1) == "achv:"


def test_p_e6_probe_progress_rows(probe):
    # the probe's table leg: 20 rows, unique ids, set membership, every id
    # resolves a name + an in-range progress line (no-blank law).
    _green(probe, "table", "rows_20", "ids_unique", "counter_set",
           "names_nonempty", "progress_in_range", "prefix_const")
