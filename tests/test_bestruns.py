"""BEST-RUNS BOARD (T-M7C, MC 11628) — the LOCAL per-hero top-5 board.

The honest local thing the retired global-leaderboard doc claim was
replaced by (MC 11401 lineage): runs recorded at the run end META-side,
persisted on the Dawn Well save, shown as the NINTH overlay in the ONE
panel style, menu-navigable MOUSE-only (the owner plays desktop).

ACCEPT rows (capture .tmp/m7c.txt):

  L-E1 score formula           the SHIPPED formula stays the ONE home
                               (main._score, pinned by
                               test_biome_numbers::test_score_formula);
                               the record line FEEDS the row from it —
                               no second formula exists repo-wide (the
                               one-home walk).
  L-E2 save row                best_runs joins as a field-by-field
                               ADDED row, VERSION unchanged (the
                               best_cycle/stage/counters/char/skin/
                               settings proof; the R1 disk exact-set
                               re-pins live in test_save.py +
                               test_dawnwell_shop.py, same commit).
  L-E3 ninth overlay           the ONE _overlay idiom, the builder moved
                               OUT (bestruns_page.gd, MC 11573 split
                               law), the menu seam, Back lands on
                               show_menu, rows rebuild per open.
  L-E4 wiring + funnel         the two connects; the recording line
                               lands INSIDE _end_run below the
                               achievements block and above the gold
                               cash-out; it adds NO funnel and NO save
                               call — the P-E3 occurrence count HOLDS
                               at 12 (the honest zero-move serial row);
                               the Enter guard grows bestruns_visible
                               (A-E8 same-commit re-pin in test_stages).
  L-E5 rank laws               bestruns_probe.gd rank mode: truncation
                               to TOP, score desc, survived desc on a
                               score tie, insertion order on a FULL tie,
                               per-hero isolation, the save-side shape
                               sanitize (R1 default + law-not-blob).
  L-E6 two boots               TWO real godot processes on ONE throwaway
                               user:// (the DoD's quit+relaunch): the
                               write boot drives runs through the SHIPPED
                               game-over path (real survived/kills/score)
                               and the real click route opens the board;
                               the read boot reads the board BACK with
                               IDENTICAL rows and the page paints
                               exactly the persisted set.
"""
import os
import re
import subprocess
import tempfile

import pytest

import conftest

REPO = conftest.REPO
GODOT = conftest.GODOT
PROBE = "res://sim/bestruns_probe.gd"
SAVE = conftest.read_script("save.gd")
MAIN = conftest.read_script("main.gd")
SCREENS = conftest.read_script("screens.gd")
PAGE = conftest.read_script("bestruns_page.gd")
STUB = conftest.read_text(os.path.join(REPO, "godot", "sim",
                                       "stub_screens.gd"))

# The pinned formula body (the SAME string test_score_formula pins — the
# one-home walk counts files containing it, not a re-spec of the math).
FORMULA = "stats.time * 10.0 + stats.kills * 5.0 + stats.level * 25.0 + stats.gold"


def _run_probe(scratch, mode):
    env = dict(os.environ, XDG_DATA_HOME=scratch, HD3D_BESTRUNS_MODE=mode)
    r = subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(REPO, "godot"),
         "-s", PROBE],
        env=env, capture_output=True, text=True, timeout=900)
    assert r.returncode == 0 and "PROBE_DONE" in r.stdout, \
        "probe (%s) failed:\n%s\n%s" % (mode, r.stdout[-2000:], r.stderr[-2000:])
    return conftest.parse_legs(r.stdout)


@pytest.fixture(scope="module")
def rank_legs():
    # the rule legs write their own scratch wells (the sanitize cases
    # plant on-disk blobs) — a private dir keeps the two-boot well clean.
    conftest.ensure_class_cache()
    return _run_probe(tempfile.mkdtemp(prefix="hd3d-bestruns-rank-"), "rank")


@pytest.fixture(scope="module")
def probe_two_boots():
    """TWO real godot processes on ONE throwaway user:// (the quit+
    relaunch round-trip): the write boot drives the SHIPPED game-over
    path and persists through the ONE funnel; the read boot re-reads the
    board at boot exactly like the shipped _ready path."""
    conftest.ensure_class_cache()
    scratch = tempfile.mkdtemp(prefix="hd3d-bestruns-")
    written = _run_probe(scratch, "write")
    relaunched = _run_probe(scratch, "read")
    return written, relaunched


# ---- L-E1: the SHIPPED score formula is the ONE home --------------------------

def test_l_e1_score_formula_one_home_and_record_feeds_from_it():
    hits = []
    for root, dirs, files in os.walk(os.path.join(REPO, "godot")):
        dirs[:] = [d for d in dirs if d not in (".godot", ".tmp", "assets")]
        for fn in files:
            if fn.endswith(".gd") and FORMULA in conftest.read_text(
                    os.path.join(root, fn)):
                hits.append(fn)
    assert hits == ["main.gd"], \
        "the formula must exist ONLY in main.gd's _score, got %s" % hits
    end_run = conftest.block(MAIN, "func _end_run", "\nfunc ")
    assert "BestRuns.record(_dawnwell, game.char_id," in end_run, \
        "the recording line rides the run's OWN char + stats"
    assert end_run.count("BestRuns.record(") == 1, \
        "ONE run-end recording site"
    assert "_score(game.stats))" in end_run.split("BestRuns.record(")[1], \
        "the row's score rides the shipped _score — no second formula"


# ---- L-E2: the save row (field-by-field, no version bump) --------------------

def test_l_e2_save_row_added_not_bumped():
    assert re.search(r"well\.best_runs = _runs_map\(data\.get\(\"best_runs\","
                     r" \{\}\)\)", SAVE), \
        "best_runs loads through the field-by-field migration (R1 law)"
    assert '"best_runs": best_runs' in \
        SAVE.split("func as_data")[1], "best_runs must serialize"
    assert re.search(r"^\tbest_runs = \{\}$", SAVE.split("func reset")[1]
                     .split("var dir")[0], re.M), "reset clears the board"
    assert "var best_runs: Dictionary = {}" in SAVE, \
        "the default is the shipped no-runs-yet board"
    assert conftest.const("VERSION", SAVE) == 1.0, \
        "VERSION unchanged — the migration law, not a bump (R1 lineage)"
    assert "func _runs_map(src: Variant) -> Dictionary" in SAVE, \
        "the shape law lives at the loader (the _int_dict twin home)"


# ---- L-E3: the ninth overlay in the ONE style ----------------------------------

def test_l_e3_ninth_overlay_one_idiom():
    assert re.search(r"_bestruns = _overlay\(\)", SCREENS), \
        "ninth overlay, same idiom"
    assert SCREENS.count("_bestruns.visible = false") >= 2, \
        "show_menu AND hide_all own it (no-blank law)"
    assert re.search(r"func bestruns_visible\(\) -> bool", SCREENS)
    assert re.search(r'func show_bestruns\(well: DawnWell\)', SCREENS)
    assert re.search(r'_button\("Best Runs", _on_bestruns\)', SCREENS), \
        "menu gains the button, same idiom"
    assert re.search(r"bestruns_requested\.emit\(\)", SCREENS)
    assert "BestRunsPage.build(self)" in SCREENS, \
        "builder moved OUT (the MC 11573 split law)"
    assert re.search(r"static func build\(s\) -> void", PAGE) and \
        re.search(r"s\._center_box\(s\._bestruns\)", PAGE), \
        "the builder rides the passed-in ONE panel idiom"
    assert re.search(r"s\.bestruns_closed\.emit\(\)", PAGE)
    close = conftest.block(SCREENS, "func close_bestruns", "\nfunc ")
    assert "show_menu()" in close, "the Back lands on show_menu (family law)"
    assert "for child in s._bestruns_rows.get_children()" in PAGE and \
        "Roster.CHARACTERS" in PAGE and "BestRuns.rows(s._well, i)" in PAGE, \
        "rows rebuild per open from the ONE roster table + the ONE read"


# ---- L-E4: main wiring, the recording position, the funnel serial ------------

def test_l_e4_wiring_and_recording_position_and_funnel_holds():
    assert "bestruns_requested.connect(_open_bestruns)" in MAIN
    assert "bestruns_closed.connect(_close_bestruns)" in MAIN
    end_run = conftest.block(MAIN, "func _end_run", "\nfunc ")
    i_upd = end_run.index("Achievements.update(_dawnwell, game, world)")
    i_rec = end_run.index("BestRuns.record(")
    i_gold = end_run.index("_dawnwell.gold += game.stats.gold")
    assert i_upd < i_rec < i_gold, \
        "the recording lands BELOW the achievements block and ABOVE the " \
        "gold cash-out (the META-side run-end position, not the sim step)"
    assert end_run.count("_meta_changed()") == 1, \
        "the block adds NO funnel call — persistence is the funnel's (P-E3)"
    assert ".save(" not in end_run, "the block adds NO save call either"
    # The serial's honest zero-move row: the settings verb was the 12th
    # occurrence and THIS card adds NO funnel site (display-only board +
    # recording rides the shipped call), so the count STAYS 12.
    assert MAIN.count("_meta_changed(") == 12, \
        "the funnel occurrence set moved without a card that adds a site"
    for fn in ("func _open_bestruns", "func _close_bestruns"):
        verbs = conftest.block(MAIN, fn, "\nfunc ")
        assert "_meta_changed" not in verbs and ".save(" not in verbs, \
            "display-only law: no verb writes here (%s)" % fn


def test_l_e4b_enter_guard_and_stub_parity():
    presses = conftest.block(MAIN, "func _handle_presses", "func _step")
    assert "not _screens.bestruns_visible()" in presses, \
        "a board-open menu cannot Enter-start a run (A-E8 parity, the " \
        "T-M7A settings-guard precedent — DECLARED READING, capture)"
    assert re.search(r"func bestruns_visible\(\) -> bool:\s*\n\s*return false",
                     STUB), "the sim stub carries the surface (parity law)"


# ---- L-E5: the rank laws (probe rank mode, LEG rows) ---------------------------

def test_l_e5_truncation_to_top_five(rank_legs):
    assert rank_legs["trunc"] == {"n": 5, "top": 100, "fifth": 60,
                                  "has50": 0, "has40": 0}, \
        "seven rows -> the board keeps the top 5; the weakest never enter"


def test_l_e5_rank_order_score_then_survived_then_insertion(rank_legs):
    # witnesses: (100,5)k1, (100,7)k2, (999,7)k3, then the FULL twin
    # (999,7)k4 -> k3 stays ABOVE k4 (a new row never displaces its equal),
    # k2 outranks k1 (survived desc), (999,*) head the board.
    assert rank_legs["rank"]["head"] == 999 and \
        rank_legs["rank"]["head_k"] == 3, "score desc puts (999,7)k3 first"
    assert rank_legs["rank"]["order"] == "4,2,1", \
        "the full tie keeps k3 above k4, then (100,7)k2 over (100,5)k1"


def test_l_e5_per_hero_boards_are_isolated(rank_legs):
    assert rank_legs["per_hero"] == {"h0": 1, "h1": 1, "h0score": 100,
                                     "h1score": 50, "h2": 0}, \
        "hero 1 never sees hero 0's rows; an unused hero reads empty"


def test_l_e5_disk_shape_is_sanitized_not_trusted(rank_legs):
    assert rank_legs["san_garbage_top"] == {"defaulted": 1, "corrupt": 0}, \
        "field-shape garbage DEFAULTS the field (the _int_dict lineage: " \
        "only an undecodable WHOLE FILE quarantines)"
    assert rank_legs["san_mixed"] == {"hero0": 1, "score": 50, "survived": 12,
                                      "lone_hero": 1}, \
        "only law-shaped rows survive; int() lands the JSON-float row; " \
        "unknown-hero buckets drop"
    assert rank_legs["san_old"] == {"defaulted": 1, "corrupt": 0}, \
        "an older save without the field reads {} (R1 migration)"
    assert rank_legs["san_cap"] == {"n": 5, "top": 99}, \
        "a past-TOP disk bucket reads the LAW, not the blob"


# ---- L-E6: the two real boots (quit + relaunch) ---------------------------------

def test_l_e6_board_opens_through_the_real_click_route(probe_two_boots):
    w, _ = probe_two_boots
    assert w["nav"] == {"clickable": 1, "opens": 1, "menu_hidden": 1,
                        "back_backs": 1, "back_menu": 1, "board_closed": 1}, \
        "the REAL Best Runs click opens the ninth overlay over the menu " \
        "and Back lands on the menu (mouse route, the shipped verb chain)"


def test_l_e6_runs_end_through_the_shipped_path_and_record(probe_two_boots):
    w, _ = probe_two_boots
    assert w["ends"] == {"runs": 3, "ended": 3, "recorded": 1}, \
        "three drives, three ENDS through the shipped game-over arm, " \
        "rows persisted by the ONE funnel (probe-side save() count: zero)"
    assert w["disk0"]["n"] == 2 and w["disk1"]["n"] == 1, \
        "per-hero boards: hero 0 twice, hero 1 once (the disk, read back " \
        "through the shipped loader)"
    assert w["disk0"]["s0"] > w["disk0"]["s1"], \
        "the recorded hero-0 rows sit in rank ORDER on disk (real values)"


def test_l_e6_relaunch_reads_the_board_back_identical(probe_two_boots):
    w, r = probe_two_boots
    assert w["disk0"]["n"] > 0 and w["disk1"]["n"] > 0, \
        "the board is NON-EMPTY before anything is compared (the vacuity \
guard — an empty==empty identity proves nothing)"
    assert r["relaunch0"] == w["disk0"] and r["relaunch1"] == w["disk1"], \
        "the SECOND real boot reads the board back with IDENTICAL rows — " \
        "the DoD's quit+relaunch persistence proof"


def test_l_e6_page_paints_exactly_the_persisted_rows(probe_two_boots):
    _, r = probe_two_boots
    assert r["page"]["opens"] == 1, "the second boot opens the page for real"
    assert r["page"]["match"] == 1 and r["page"]["painted"] == r["page"]["expect"], \
        "the painted Labels are one per hero header + one per recorded " \
        "run (+ one empty-line per hero with no runs), exactly"
