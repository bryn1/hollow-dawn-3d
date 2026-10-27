"""THE REAPER (MC 11364 T-M4r): M4-SPEC rev-3 §2.3 ACCEPT rows B-E1..B-E6.

Source-truth pins over the .gd text + behaviour rows judged from the
committed, seed-pinned dump (godot/sim/sim_reaper.gd, seed 11334 = card id,
byte-stable; re-run byte-identity is the capture's job — the sim_endless/
sim_events precedent). The budget half of B-E5 rides sim_budget.gd's
budget_reaper leg (A-E7 convention: budget rows gate the driver's exit
code, no pytest twin); the pixel half of B-E2 rides the REAPER-BAR row of
tools/s8_acceptance.py (planted RED baseline-vs-itself, capture record).

Row map (spec row -> evidence here / in the dump):
  B-E1 flag-off byte law      reaper_off_win (kind "win", reaper never) +
       the STAY pins named by the spec: test_endless :114-118/:130-135
       source twins + the :244 runtime win row stay green (they live in
       test_endless.py — one home per claim); planted "default the flag
       true" turns reaper_off_win RED (capture instrument).
  B-E2 limit behavior         reaper_limit: kind != win at 900.017, first
       arrival 900.017, bar reads THE REAPER (runtime twin of the pixel
       row), contact ENDS the run: kind gameover, stats.time in (900,930),
       the end line prepended. Planted REDs: spawn at 840 (first-seen),
       contact dealing 20 instead of ending (ends_by_contact).
  B-E3 one more every 60 s    reaper_latch (spd-pinned 1.0, declared):
       arrivals [900.017, 960.017]; planted once-only latch -> RED.
  B-E4 endless precedence     reaper_endless: clears fire at 900/1800,
       ZERO reaper spawns; planted reaper-first cap fork -> clears stop
       -> RED (AND the R9 order regex in test_endless.py reddens).
  B-E5 budget + snapshot      reaper_snapshot (exact-12, "reaper" ABSENT —
       the 13th-field instrument) + sim_budget budget_reaper (driver rc).
  B-E6 death guard            reaper_death: THE ZERO-DROP-ARRAY-DELTA
       leg (kills +1, alive -1, chests/gems/coins/heals/gold ZERO delta,
       map value-compared at 7 rows); planted guard removal -> phantom
       chest + bounty -> RED. First EXECUTED evidence of the map-bypass
       law at the keyed drop site.
"""

import functools
import os
import re

import conftest

REPO = conftest.REPO
FIXTURE = os.path.join(REPO, "tests", "fixtures", "reaper-m4.jsonl")
read = functools.partial(conftest.read_script, code_only=True)
WORLD = read("world.gd")
MAIN = read("main.gd")
GAME_STATE = read("game_state.gd")


def leg(ev):
    rows = conftest.rows_by_ev(FIXTURE, ev) # the ONE filter (MC 11398 §2.3)
    assert len(rows) == 1, "reaper-m4 fixture must carry exactly one %r" % ev
    row = rows[0]
    assert row["ok"], "%s leg red: %s" % (ev, row["checks"])
    return row


const = conftest.const # the ONE seam (MC 11398 §2.2: this file had re-copied
# the donor verbatim; the conftest body is byte-identical to it — capture)


# ---- B-E1: flag OFF stays byte-territory ---------------------------------------

def test_b_e1_flag_off_wins_and_the_row_never_constructs():
    row = leg("reaper_off_win")
    assert row["checks"]["win_at_limit"], \
        "flag OFF keeps the M1 win at the limit — the night arm leaked"
    assert row["checks"]["reaper_never"], \
        "the the-reaper row's ONLY construction site is the flag-gated " \
        "arrival latch (spec §2.1) — it fired without the flag"
    # The hand-in is the ONE seam, the endless pattern verbatim (source):
    assert re.search(r"game\.endless = int\(_dawnwell\.flags\.get\("
                     r"\"endless\", 0\)\) == 1\s*"
                     r"game\.reaper = int\(_dawnwell\.flags"
                     r"\.get\(\"reaper\", 0\)\) == 1", MAIN), \
        "the reaper hand-in must ride the SAME _dawnwell -> start seam"
    # start_run resets it (fresh-run law; never a default-true — that is
    # the planted RED of this row, capture-proven).
    assert re.search(r"reaper = false", GAME_STATE), \
        "start_run() must reset reaper (the endless reset pattern)"


# ---- B-E2: the limit CONTINUES, the walk-in ends --------------------------------

def test_b_e2_limit_leg_reads_as_written():
    row = leg("reaper_limit")
    c = row["checks"]
    assert c["not_win_at_limit"], "at 900.017 the kind must NOT be win"
    assert c["first_seen_900"], "the first arrival is stamped 900.017"
    assert c["bar_reads_reaper"], "the live bar reads THE REAPER (runtime " \
        "twin of the s8 REAPER-BAR pixel row)"
    assert c["ends_by_contact"], "contact ENDS the run (F-6), kind gameover"
    assert c["end_time_window"], "stats.time lands in the (900, 930) window"
    assert c["end_line_present"] and c["five_rows_kept"], \
        "the panel PREPENDS the reaper line over the five shipped rows"
    assert 900.0 < row["end_time"] < 930.0
    assert row["end_line"].startswith("The Reaper took you at ")


def test_b_e2_end_law_source_pin():
    # The END LAW reads the dict flag FIRST inside the boss-radius test and
    # is NOT behind the iframes gate (the stationary-surrounded reading,
    # spec B-E2 as written); flag off it is a pure fallthrough (B-E1).
    m = re.search(r"if dx \* dx \+ dy \* dy < \(er \+ 16\.0\)"
                  r" \* \(er \+ 16\.0\):\s*\n"
                  r"(?:\t*(?://[^\n]*)?\n)*"
                  r"\t*if e\.get\(\"reaper\", false\):\s*\n"
                  r"\t*_end_run\(\"gameover\"\)\s*\n"
                  r"\t*return\s*\n"
                  r"(?:\t*(?://[^\n]*)?\n)*"
                  r"\t*if p\.iframes <= 0\.0:", MAIN)
    assert m, "the reaper end law must precede the iframes gate inside " \
              "the shipped radius test (no damage, no clamp, F-6)"
    # The end line rides the ONE show_end call with a prepended row.
    assert re.search(r"end_lines\.push_front\(\"The Reaper took you at %s\"",
                     MAIN), "the end screen gains the reaper line through " \
                     "the ONE _screens.show_end seam, prepended"


def test_b_e2_enemy_row_verbatim():
    m = re.search(r"\"the-reaper\": \{\"hp\": 50000\.0, \"spd\": 200\.0, "
                  r"\"dmg\": 30\.0, \"xp\": 0\.0, \"sprite\": \"boss-warden"
                  r"\", \"boss\": true, \"reaper\": true, \"name\": "
                  r"\"THE REAPER\"\}", WORLD)
    assert m, "§2.1's row verbatim (spd 200 > the shipped 196 cap; dmg 30 " \
              "is never read — the end law beats the clamp, F-6)"
    assert re.search(r"\"reaper\": def\.get\(\"reaper\", false\)", WORLD), \
        "the spawn dict fields the end-law flag beside boss/miniboss"


# ---- B-E3: the latch walks one more per period ----------------------------------

def test_b_e3_latch_arrivals_and_const():
    row = leg("reaper_latch")
    assert row["checks"]["two_arrivals"] and row["checks"]["arrival_times"], \
        "arrivals [900.017, 960.017] — one more per REAPER_PERIOD"
    assert row["arrivals"] == [900.017, 960.017]
    assert row["checks"]["still_hunted"]
    assert row["reaper_speed"] == 1.0, \
        "this leg PINS the reaper speed (declared): it measures the latch"
    assert const("REAPER_PERIOD", WORLD) == 60.0
    # World-side latch: BESIDE the schedule latch and ABOVE the cap early-
    # return BY POSITION (index order at source), gated reaper and not
    # endless (the VS-FEATURES:423 precedence mirrored at both seams).
    gate = re.search(r"while game\.reaper and not game\.endless\s*\\?\s*\n"
                     r"\t*and game\.time >= GameState\.WIN_TIME \+ "
                     r"REAPER_PERIOD \* reaper_spawned:", WORLD)
    assert gate, "the n-th arrival gate is the pinned clock comparison"
    cap = WORLD.index("if enemies.size() >= ALIVE_CAP:")
    assert gate.start() < cap, \
        "the arrival latch sits ABOVE the cap early-return by position"
    assert re.search(r"reaper_spawned \+= 1\s*\n\s*"
                     r"_spawn_enemy\(\"the-reaper\", game, view\)", WORLD), \
        "latch first, then the ONE _spawn_enemy funnel (full circle)"
    assert re.search(r"var reaper_spawned := 0", WORLD) and \
            re.search(r"reaper_spawned = 0", WORLD), \
        "the latch counter lives on the world and resets in world.reset()"


# ---- B-E4: Endless precedence ----------------------------------------------------

def test_b_e4_endless_precedence():
    row = leg("reaper_endless")
    c = row["checks"]
    assert c["clear_fires_at_900"] and c["clear_fires_at_1800"], \
        "both flags ON: the shipped cycle clear keeps firing at every " \
        "boundary (endless-first, R9-pinned order at source)"
    assert c["zero_reaper_spawns"], "the night never arrives under Endless"
    assert c["never_ended_by_reaper"] and row["kind"] == "playing"


# ---- B-E5: Contract B stays the frozen twelve -------------------------------------

def test_b_e5_snapshot_exact_12_reaper_absent():
    row = leg("reaper_snapshot")
    assert row["checks"]["exact_12"], "Contract B is the frozen 12 (F-3)"
    assert row["checks"]["reaper_absent"], \
        "a 13th snapshot field named reaper IS the planted RED (F-3); the " \
        "run-mode var lives OUTSIDE snapshot_json"


# ---- B-E6: the death guard — zero drop arrays ---------------------------------------

def test_b_e6_death_guard_zero_drop_delta():
    row = leg("reaper_death")
    c = row["checks"]
    assert c["kill_counts"] and c["removed"], "the kill COUNTS (+1/-1)"
    for k in ("chests_zero_delta", "gems_zero_delta", "coins_zero_delta",
              "heals_zero_delta", "bounty_zero"):
        assert c[k], "%s — a reaper death drops NOTHING (§2.1 P2-1)" % k
    # The value-compare red shape (test_chests_tiers:144-158 instrument):
    # the DUMPED map row, never a second literal — the keyed read of an
    # absent "the-reaper" is the soft-null that would append a phantom
    # null-tier chest. Godot's missing-key behaviour is a SOFT error +
    # null (no crash claim): the guard is the declared route.
    assert c["map_untouched"], "the ONE CHEST_TIER_BY_SOURCE stays 7 rows " \
        "(F-3) and never gains a reaper key"
    assert row["chests_delta"] == 0 and row["coins_delta"] == 0 \
        and row["gems_delta"] == 0 and row["heals_delta"] == 0 \
        and row["gold_delta"] == 0
    # The guard sits after remove_at + kills, BEFORE the boss drop block.
    m = re.search(r"game\.kills \+= 1\s*\n\s*"
                  r"if enemy\.get\(\"reaper\", false\):\s*\n\s*return\s*\n"
                  r"\s*if enemy\.boss:", WORLD)
    assert m, "the guard is the ONE named site between kills and drops"


# ---- verdict row -------------------------------------------------------------------

def test_fixture_verdict_green():
    rows = conftest.jsonl_rows(FIXTURE)
    v = [r for r in rows if r["ev"] == "reaper_verdict"]
    assert len(v) == 1 and v[0]["ok"], "the channel verdict row must be ok"
    assert v[0]["rows"] == len(rows) - 1 == 6
