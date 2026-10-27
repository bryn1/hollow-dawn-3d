"""EVENT WAVES — M4 pillar A (MC 11362, T-M4e; M4-SPEC REV-3 @ a0c1413, the
DA SHIP law). Rows A-E2..A-E7 as written:

* A-E2 rides tests/test_stages.py (the re-pinned stages-m3 stages_table
  row: bosses WITH the 660 entries + the events field pins, F-1 STAY rows).
* A-E3..A-E6: this file — source-truth regex pins (the repo idiom) over
  world.gd (the ONE loop the events mechanism touches) + behaviour verdicts
  read through the ONE loader of the seeded events-m4.jsonl dump (seed
  11362, generated twice, cmp-identical — sim_events pattern; the dump
  re-mints with the T-M4a mesh rows in this card's close commit).
* A-E7 rides sim_budget's budget_stage4/budget_stage3 rows (§9's 2/402
  readings; the budget channel has no pytest fixture twin — its ok flags
  gate the driver exit code, the shipped convention).

Honest-count note (capture .tmp/m4e-events.txt): T-M4e falsifies ZERO test
rows OUTSIDE the re-pins named in the §7.2 ledger (R1 test_stages bosses/
events; R2 the moved stages-m3 schedule rows' readers here and in
test_boss_numbers.py — schedule_latch_1 -> schedule_latch_2 WITH the
event-miniboss checks, equal-or-stronger, replace-not-delete; R4 the art
coverage row, T-M4a half; R5 the budget reading, driver-side). Everything
this file adds is NEW rows on a NEW fixture.
"""

import functools
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures",
                       "events-m4.jsonl")

read = functools.partial(conftest.read_text, code_only=True)
WORLD = read(os.path.join(SCRIPTS, "world.gd"))
RENDER = read(os.path.join(SCRIPTS, "render.gd"))

const = conftest.const


def leg(ev):
    rows = conftest.rows_by_ev(FIXTURE, ev) # the ONE filter (MC 11398 §2.3)
    assert len(rows) == 1, "events-m4 fixture must carry exactly one %r" % ev
    row = rows[0]
    assert row["ok"], "%s leg red: %s" % (ev, row["checks"])
    return row


# ---- A-E2 twin (table truth + consts) -----------------------------------------

def test_a_e2_events_table_and_consts():
    row = leg("events_table")["checks"]
    assert row["stage1_events_empty"], "F-1 byte law: stage 1 fields NO events"
    assert row["stage2_row_verbatim"], "sunken-tide row == [660,720,180,90]"
    assert row["stage3_row_verbatim"], "stair-wall row == [660,720,0,90]"
    assert row["surge_is_two"] and const("EVENT_SURGE", WORLD) == 2.0
    assert row["cone_identity"], "CONE_ALL == [0.0, TAU] (the F-1 identity)"
    assert row["west_cone"], "[135 deg, 225 deg] == center 180 width 90"
    assert row["east_cone"], "[315 deg, 45 deg] == center 0 width 90"


# ---- A-E3 cone truth -----------------------------------------------------------

def test_a_e3_cone_legs():
    row = leg("event_cone")
    assert row["checks"]["cone_share"], \
        "EVERY in-window spawn sits inside the fixed cone (share == 1)"
    assert row["checks"]["circle_returns"], \
        "past t1 the horde returns to the full circle"
    assert row["checks"]["control_spread"], \
        "a window-off twin spreads ~25 % inside the same arc (the cone " \
        "narrows nothing else) — the both-side negatives"


def test_a_e3_source_pins_the_window_block_is_rng_free():
    # The cone/window selection is a CLOCK COMPARISON: the events block of
    # update_spawns consumes ZERO randf/randi (A-E5's law, pinned at source
    # so a silent randi in the selection goes RED even where the digest
    # twin's window does not cover it).
    m = re.search(r"var cone: Array = CONE_ALL\n(.*?)if enemies\.size\(\) "
                  r">= ALIVE_CAP", WORLD, re.S)
    assert m, "the events-window block (cone read ... cap return) missing"
    assert "randf" not in m.group(1) and "randi" not in m.group(1), \
        "the events window selection consumed RNG — A-E5 zero-RNG law"


def test_a_e3_cone_default_is_the_shipped_read():
    # F-1: the DEFAULT cone read is the shipped `randf() * TAU` verbatim —
    # identity [0.0, TAU], IEEE-exact (0.0 + x*TAU == x*TAU, TAU-0.0 == TAU)
    # so every committed dump runs the SAME angle stream (the byte corpus).
    assert "cone: Array = CONE_ALL" in WORLD, \
        "_spawn_enemy's cone argument must default to the identity cone"
    assert re.search(r"var angle: float = float\(cone\[0\]\) \+ randf\(\) \*"
                     r" \(float\(cone\[1\]\) - float\(cone\[0\]\)\)", WORLD), \
        "the cone read must stay the single-randf form (no second draw)"
    assert "randf() * TAU" not in WORLD.split("func _spawn_enemy")[1][:600], \
        "the retired bare read stays retired (replace-not-delete)"


# ---- A-E4 surge truth (three legs) ----------------------------------------------

def test_a_e4_surge_cap_leg():
    row = leg("event_surge_cap")
    assert row["checks"]["minf_binds_both"], "12.0 binds plain AND surged"
    assert row["checks"]["twins_equal"], \
        "at minute 11+ the window twin and the window-off twin spawn EQUAL " \
        "counts (the ceiling, not the event, is the binding term)"
    assert row["checks"]["cap_pause_holds"], \
        "F-4: the ALIVE_CAP pause stays INTACT under the event surge"


def test_a_e4_surge_mechanism_leg():
    row = leg("event_surge_mechanism")
    assert row["checks"]["surge_ratio"], \
        "uncapped zone: the twin ratio == EVENT_SURGE == 2.0"
    assert row["checks"]["uncapped_zone"], "the ratio leg ran uncapped"


def test_a_e4_surge_saturation_leg():
    row = leg("event_surge_saturation")
    assert row["checks"]["surge_capped"], \
        "pre-cap sub-window mean <= 12.0/s (planted-outside-minf reads " \
        "22.8-24.1/s RED — spec c2 F-4 measurement)"
    assert row["checks"]["clamp_binds"], "the surged term DOES clamp"


def test_a_e4_surge_rides_inside_the_minf_below_the_cap():
    # Source pins (spec §1.4): the surge multiplies the EXISTING rate term
    # INSIDE the untouched minf(12.0) ceiling, and the events block sits
    # BELOW the untouched ALIVE_CAP early-return (F-4).
    assert re.search(r"minf\(12\.0, \(1\.0 \+ 1\.3 \* minute\) \* qty_cyc"
                     r"\(game\.cycle\) \* surge\)", WORLD), \
        "the rate term must stay the shipped product with surge INSIDE the " \
        "minf ceiling"
    cap_at = WORLD.index("if enemies.size() >= ALIVE_CAP")
    minf_at = WORLD.index("minf(12.0, (1.0 + 1.3 * minute)")
    ev_at = WORLD.index("var cone: Array = CONE_ALL")
    assert ev_at < cap_at < minf_at, \
        "events block BELOW the cap early-return, rate ceiling untouched"


# ---- A-E5 the zero-RNG digest twin ------------------------------------------------

def test_a_e5_identity_twin_digests_equal():
    row = leg("rng_twin_identity")
    assert row["checks"]["rng_stream"], \
        "identity-cone twin digests equal through t=720 AND to run-end " \
        "(the A-E5 carve: geometry pinned out, kill-time rolls consume the " \
        "same stream at the same positions)"
    assert row["equal_at_720"] and row["equal_at_end"]


# ---- A-E6 the event-miniboss family ------------------------------------------------

def test_a_e6_event_miniboss_leg():
    row = leg("event_miniboss")
    assert row["checks"]["prelate_first_seen_660"], \
        "sunken-prelate walks the field at 660.017 (stage 2)"
    assert row["checks"]["prelate_once"], "latched ONCE (the ONE schedule)"
    assert row["checks"]["never_stage1"], \
        "the vigil is never an event stage (0..900 walk, both ids)"
    assert row["checks"]["never_cross_stage"], \
        "stage 2 fields no stair-acolyte; stage 3 fields no sunken-prelate"
    assert row["checks"]["rearm_fires_once_more"], "reset() re-arms (run-2)"


def test_a_e6_chest_leg_rides_the_map_not_a_literal():
    row = leg("event_miniboss")
    assert row["map_miniboss_tier"] == "ember", \
        "the MAP row dumped (value-compare, never a tier literal)"
    assert row["checks"]["chest_roll_06"], \
        "40 prelate-shape kills: 0 < drops < 40 (the 0.6 roll, neither " \
        "1.0 boss chance nor 0)"
    assert row["checks"]["chest_tier_from_map"], \
        "EVERY drop tier == the map's miniboss row (F-3: the ONE map, " \
        "7 rows, untouched; the §B.1 event key stays reserved)"


# ---- table rows verbatim at source (the STAY-pair to test_stages) ---------------

def test_events_rows_are_the_spec_table_in_render_gd():
    # §1.1's rows verbatim IN THE MODULE (the dump twin pins the engine
    # read; this pins the source), stage 1's EMPTY row included (F-1).
    assert '"events": []' in RENDER, "stage 1 events row stays EMPTY"
    assert '"events": [[660.0, 720.0, 180.0, 90.0]]' in RENDER
    assert '"events": [[660.0, 720.0, 0.0, 90.0]]' in RENDER
    # the bosses rows carry the 660 entries through the ONE latch
    assert '[660.0, "sunken-prelate"]' in RENDER
    assert '[660.0, "stair-acolyte"]' in RENDER
