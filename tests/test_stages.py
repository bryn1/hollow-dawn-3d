"""STAGES — M3 pillars A+B (MC 11282, T-M3s; M3-SPEC REV-3 @ 212a526, the
DA SHIP law). Rows A-E1..A-E8, as written:

* A-E1 (byte anchors): the FOUR existing fixtures + the journey re-run ride
  their own files — endless / gems / unions compared byte-identical, and the
  chests-tiers fixture judged ONLY on its stage-1 OBSERVABLE rows: its one
  embedded `map` row is the DECLARED §3.1 map re-pin (the test-side growth
  is the ledger'd replace-not-delete in test_chests_tiers.SPEC_MAP; verified
  field-by-field in .tmp/m3s-stages.txt), never an anchor flip. This file
  re-pins the observable half explicitly (test_a_e1_carve_below).
* A-E2..A-E8: table truth, placement law, gimmick rows (cairns/plates/flare),
  the unlock chain, the fifth overlay and the frozen snapshot — source-truth
  regex pins (this repo's idiom) + behaviour verdicts read through the ONE
  loader of the seeded stages-m3.jsonl dump (seed 11282, generated twice,
  cmp-identical — sim_stages pattern).
* T-M3g (MC 11283) adds the two A-E4 RED columns the T-M3s legs could not
  reach (saturation surge + dwell zero-RNG, leg plates_saturation) — a
  REPLACE-NOTHING addition: no existing row was edited or deleted.

Honest-count note (capture .tmp/m3s-stages.txt): the brief expected "NONE
expected beyond placement notes" for falsified pins; the actual replaced-pin
count is 8 test rows + 1 docstring + 1 probe row across 6 files, each with a
FALSIFIED-AND-REPLACED note at its site.
"""

import json
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
SIM = os.path.join(conftest.REPO, "godot", "sim")
FIXTURES = os.path.join(conftest.REPO, "tests", "fixtures")


def read(path):
    with open(path, encoding="utf-8") as fh:
        return "".join(line.split("#")[0] + "\n" for line in fh.read().splitlines())


RENDER = read(os.path.join(SCRIPTS, "render.gd"))
WORLD = read(os.path.join(SCRIPTS, "world.gd"))
MAIN = read(os.path.join(SCRIPTS, "main.gd"))
SCREENS = read(os.path.join(SCRIPTS, "screens.gd"))
SAVE = read(os.path.join(SCRIPTS, "save.gd"))
GROUND = read(os.path.join(SCRIPTS, "ground.gd"))
HUD = read(os.path.join(SCRIPTS, "hud_3d.gd"))
VIZ = read(os.path.join(SCRIPTS, "pickup_viz.gd"))


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


def block(source, start_marker, end_marker):
    start = source.index(start_marker)
    rest = source[start:]
    return rest[: rest.index(end_marker)] if end_marker in rest else rest


def leg(ev):
    row = conftest.stages_row(ev)
    assert row["ok"], "%s leg red: %s" % (ev, row["checks"])
    return row


# ---- A-E2: the table, verbatim, read through the engine -----------------------

def test_a_e2_stage_rows_are_the_spec_table():
    # The stages_table leg dumps the ONE STAGES array AS THE ENGINE EVALUATES
    # IT; the ids/names/band t_starts/boss rows/limits/unlock levels below
    # are M3-SPEC §1.1's table verbatim (OUR numbers — the doc's own).
    stages = leg("stages_table")["stages"]
    assert [s["id"] for s in stages] == ["moor-vigil", "sunken-chapel",
                                         "ossuary-stair"]
    assert [s["name"] for s in stages] == ["MOOR VIGIL", "SUNKEN CHAPEL",
                                           "OSSUARY STAIR"]
    assert [s["gimmick"] for s in stages] == ["none", "drowned-cairns",
                                              "pressure-stair"]
    assert [row[1] for row in stages[0]["bands"]] == [0.0, 150.0, 300.0, 450.0]
    assert [row[1] for row in stages[1]["bands"]] == [0.0, 300.0, 600.0]
    assert [row[1] for row in stages[2]["bands"]] == [0.0, 450.0]
    assert stages[0]["bosses"] == [[540.0, "warden"], [600.0, "hollow-knight"],
                                   [780.0, "hollow-deacon"]]
    assert stages[1]["bosses"] == [[540.0, "cathedral-choir"]]
    assert stages[2]["bosses"] == [[540.0, "ossuary-warden"]]
    assert [s["limit"] for s in stages] == [900.0, 900.0, 900.0]
    assert [s["unlock_level"] for s in stages] == [0, 10, 14]
    assert stages[1]["unlock_stage"] == "moor-vigil" and \
        stages[2]["unlock_stage"] == "sunken-chapel"
    assert [s["unlock_flag"] for s in stages] == ["", "stage2", "stage3"]
    # the gimmick coord rows verbatim (§1.2's "(±260, ±150) px" / "±220 px")
    # — "px" is the SAME numeric space world.gd's shipped 16 px collect
    # funnel already compares in (world.gd:355), so the table rows seed raw,
    # no second unit convention (measured before shipping: a /PX_PER_M
    # "bridge" forked the stage-2 horde stream RED — the space is ONE).
    assert stages[0]["cairns"] == [] and stages[0]["plates"] == []
    assert stages[1]["cairns"] == [[260.0, 150.0], [-260.0, -150.0]]
    assert stages[1]["plates"] == []
    assert stages[2]["plates"] == [[-220.0, 0.0], [220.0, 0.0]]
    assert stages[2]["cairns"] == []
    # the stage-1 bosses row IS the shipped schedule (engine const eval):
    # the concatenation `[[BOSS_AT,"warden"]] + MINIBOSS_AT` evaluated at 4.7.2
    assert leg("stages_table")["checks"]["boss_row_is_shipped_schedule"]


def test_a_e2_band_at_walks_each_stage():
    # stage-1 band walk == the shipped biome_at at 0/150/300/450/900; the
    # stage-2/3 t_starts of §1.1's table, sampled at the exact edges.
    rows = {e["t"]: e["same_row"] for e in leg("stages_table")["band_moor"]}
    assert rows == {0.0: True, 150.0: True, 300.0: True, 450.0: True,
                    900.0: True}
    b2 = leg("stages_table")["band_2"]
    assert [b2["0.0"], b2["299.9"], b2["300.0"], b2["599.9"], b2["600.0"],
            b2["900.0"]] == ["MOORLAND", "MOORLAND", "THE FROZEN WASTE",
                             "THE FROZEN WASTE", "DEAD TUNDRA", "DEAD TUNDRA"]
    b3 = leg("stages_table")["band_3"]
    assert [b3["0.0"], b3["449.9"], b3["450.0"], b3["900.0"]] == [
        "DEAD TUNDRA", "DEAD TUNDRA", "THE FROZEN WASTE", "THE FROZEN WASTE"]


def test_a_e2_placement_law_stages_below_biome_at():
    # P3-3 slice law: the test_band_t_starts slice runs "const BIOMES" ->
    # "static func biome_at" — the STAGES table must sit BELOW biome_at so
    # that slice keeps reading the shipped BIOMES table exactly.
    assert RENDER.index("const BIOMES") < RENDER.index("static func biome_at")
    assert RENDER.index("const STAGES") > RENDER.index("static func biome_at")
    assert RENDER.index("static func band_at") > RENDER.index(
        "static func biome_at")
    # biome_at survives as the stage-1 wrapper (the shipped walk, one funnel)
    body = block(RENDER, "static func biome_at", "static func stage_row")
    assert re.search(r"return band_at\(\"moor-vigil\", t\)", body)
    # band names in the STAGES rows resolve to the shipped BIOMES identities
    assert "_biome_named" in RENDER
    # stage-1 default: the shipped roster path is untouched
    assert "GameRenderer.band_at(game.stage" in GROUND or \
        "band_at(game.stage" in GROUND


def test_a_e2_flare_is_visual_only():
    # §1.2 law: the flare shifts band NAMES only — difficulty reads the clock
    # (cycle_minute -> game.time), and the snapshot never carries the shift.
    m = re.search(r"static func cycle_minute\(game: GameState\) -> float:"
                  r"\s*\n\s*return \(game\.time - game\.cycle \* "
                  r"GameState\.WIN_TIME\) / 60\.0", WORLD)
    assert m, "the minute term must read the CLOCK (game.time), never the flare"
    # the hp ramp and the rate term read minute/time, never flare
    rate = block(WORLD, "func update_spawns", "func update_entities")
    ramp_terms = [ln for ln in rate.splitlines() if "1.3 * minute" in ln
                  or "0.22 *" in ln]
    assert ramp_terms and all("flare" not in ln for ln in ramp_terms), \
        "no difficulty term may read the flare"
    assert leg("snapshot_m3")["checks"]["stage_flare_absent"]


# ---- A-E2/A-E1 replacement legs: the unified schedule -------------------------

def test_a_e2_schedule_is_the_single_latched_walk():
    assert re.search(r"GameRenderer\.stage_bosses\(game\.stage\)", WORLD), \
        "the schedule must read the stage's row from the ONE table"
    gate = block(WORLD, "func update_spawns", "func update_entities")
    assert re.search(r"schedule_spawned \+= 1\s*\n\s*#.*\n\s*"
                     r"if not ENEMY_TYPES\.has\(String\(b\[1\]\)\):\s*\n"
                     r"\t*break\s*\n\s*_spawn_enemy\(b\[1\], game, view\)",
                     gate) or \
        re.search(r"if not ENEMY_TYPES\.has\(String\(b\[1\]\)\):\s*\n"
                  r"\t*break\s*\n\s*schedule_spawned \+= 1\s*\n"
                  r"\s*_spawn_enemy\(b\[1\], game, view\)", gate), \
        "latch-first with the §3.1 defer guard, then the one spawn site"
    assert re.search(r"var schedule_spawned := 0", WORLD)
    reset = block(WORLD, "func reset", "func _types_open")
    assert re.search(r"schedule_spawned = 0", reset), \
        "the ONE latch re-arms for the next run"
    # the mid-spine defer leg: a stage-2 run past 540 before T-M3b's enemy
    # rows land must not crash and must not latch
    leg("defer_guard")


# ---- A-E3: drowned cairns ------------------------------------------------------

def test_a_e3_cairns_seed_from_the_map_not_a_literal():
    seed = block(WORLD, "func seed_stage_props", "func _types_open")
    assert re.search(r"CHEST_TIER_BY_SOURCE\[\"stage-item\"\]", seed), \
        "the cairn tier must come from THE MAP (§3.1), never a second literal"
    assert "\"ember\"" not in seed, "no tier literal may sit beside the map read"
    assert re.search(r"\"tier\":", seed) and "chests.append" in seed
    assert re.search(r"seed_stage_props\(game\)", MAIN), \
        "_start_game must seed the stage's props at run start"
    verdict = leg("cairns")
    assert verdict["checks"]["seeded_fixed_coords_map_tier"], \
        "fixed coords, tier == the map's stage-item row"
    # the FIXED position rows observable (A-E3's "position rows" column):
    # the seeded chests sit exactly on the table coords, no RNG moved them
    assert verdict["seeded"][0]["x"] == 260.0 and \
        verdict["seeded"][1]["y"] == -150.0
    assert verdict["checks"]["open_shrank_array"] and \
        verdict["checks"]["pending_raised_item_count"] and \
        verdict["checks"]["gold_roll_in_tier_range"] and \
        verdict["checks"]["offer_drew_three_cards"], \
        "one walk-through the ONE collect funnel: chest -1, pending +item_count"
    # zero-RNG row: stage 2 vs stage 1 same-seed streams are IDENTICAL
    leg("rng_stream")


# ---- A-E4: pressure plates + flare ---------------------------------------------

def test_a_e4_plate_numbers_are_the_spec_rows():
    assert const("SPAWN_SURGE", WORLD) == 1.5
    assert const("PLATE_RADIUS", WORLD) == 120.0
    assert const("FLARE_SHIFT", WORLD) == 150.0
    assert const("FLARE_DECAY", WORLD) == 30.0


def test_a_e4_surge_dwell_cap_and_flare_legs():
    rate = leg("plates_rate")
    assert rate["checks"]["ratio_is_surge"], "dwelling multiplies the ONE term by 1.5"
    assert rate["checks"]["dwell_pins_flare"] and rate["checks"]["off_flare_zero"]
    cap = leg("plates_cap")
    assert cap["checks"]["minf_binds_both"], "the 12/s ceiling binds WITH the surge"
    assert cap["checks"]["alive_cap_holds"] and cap["max_alive"] <= 400
    flare = leg("plates_flare")
    assert flare["checks"]["dwell_shifts_band"], \
        "t 380 + flare 150 crosses the stage-3 450 row: the NAME moves"
    assert flare["checks"]["flare_decayed_to_base"]
    # the plate block sits BEFORE the ALIVE_CAP early return (flares still
    # set under the cap — the surge never bypasses the untouched return)
    gate = block(WORLD, "func update_spawns", "func update_entities")
    assert gate.index("PLATE_RADIUS") < gate.index("ALIVE_CAP")
    assert re.search(r"game\.flare = maxf\(0\.0, game\.flare - FLARE_SHIFT / "
                     r"FLARE_DECAY \* dt\)", gate), "decay row 150/30 = 5 per s"


def test_a_e4_surge_saturates_and_dwell_draws_no_rng():
    # The A-E4 RED columns AS WRITTEN (T-M3g, MC 11283): "surge that
    # bypasses minf (13/s) => RED; a dwell that draws RNG => RNG-stream
    # RED". At minute 9 the BASE rate (1 + 1.3*9 = 12.7) already saturates
    # minf(12.0), so the stage-2 twin at the SAME position (plate-less row:
    # surge the exact 1.0 identity) and the stage-3 dweller (1.5) sit on
    # the same clamped 12.0/s over the same re-seeded stream. A surge
    # outside the ceiling runs the dweller ~1.5x (spawn counts diverge); a
    # randf/randi inside the dwell branch reorders the type picks. (The
    # same-position twin is the fair comparison — an off-position twin
    # forks KILLS legitimately; the sim note carries the measurement.)
    row = leg("plates_saturation")
    assert row["checks"]["minf_clamps_surge"], \
        "the surge multiplies INSIDE minf(12.0): at the saturating clock " \
        "the dweller spawns at the plate-less twin's rate, not 1.5x"
    assert row["checks"]["dwell_zero_rng"], \
        "the dwell is a pure position test — zero randf/randi"
    # the source-side twin of the zero-RNG row (the repo's source-truth
    # idiom): the plate block between the flare decay and the untouched
    # ALIVE_CAP early-return reads no RNG at all
    gate = block(WORLD, "func update_spawns", "func update_entities")
    plate_blk = gate[gate.index("game.flare = maxf"):
                     gate.index("if enemies.size() >= ALIVE_CAP")]
    assert "randf" not in plate_blk and "randi" not in plate_blk


# ---- A-E5: the unlock chain ----------------------------------------------------

def test_a_e5_unlock_is_set_only_through_the_one_funnel():
    end_run = block(MAIN, "func _end_run", "\nfunc ")
    assert re.search(r"GameRenderer\.stage_unlock_after\(game\.stage\)", end_run)
    assert re.search(r"game\.level >= int\(next_stage\.unlock_level\)", end_run)
    assert re.search(r"_dawnwell\.flags\[String\(next_stage\.unlock_flag\)\] = 1",
                     end_run), "SET-only flag write, the roadmap flag law"
    assert "erase" not in end_run and "pop_at" not in end_run
    assert end_run.count("_meta_changed()") == 1 and \
        MAIN.count("func _meta_changed") == 1, \
        "the ONE funnel: _end_run persists through exactly one call"
    chain = leg("unlock_chain")
    assert chain["checks"]["level9_sets_nothing"] and \
        chain["checks"]["level10_sets_stage2"], "level 10 in stage 1 -> stage2"
    assert chain["checks"]["stage3_needs_stage2_run"], \
        "a stage-2 death never UNSETS stage2 and sets no stage3 at level 3"
    assert chain["checks"]["level14_stage2_sets_stage3"]


def test_a_e5_stage_choice_persists_and_hands_in():
    assert re.search(r"var stage := 1", SAVE) and \
        re.search(r"well\.stage = int\(data\.get\(\"stage\", 1\)\)", SAVE), \
        "old saves read stage 1 field-by-field, VERSION stays 1 (§1.4)"
    assert const("VERSION", SAVE) == 1.0
    hand = block(MAIN, "func _start_game", "func _end_run")
    hi = hand.index("game.stage = GameRenderer.stage_id_for_index("
                    "_dawnwell.stage)")
    el = hand.index("game.endless = int(")
    assert el < hi, "the stage hand-in rides AFTER the endless hand-in (the " \
        "_start_game handoff pin's shape, test_endless:137)"
    assert re.search(r"seed_stage_props\(game\)", hand[hi:])
    h = leg("handin")
    assert h["checks"]["unset_reads_moor_vigil"] and \
        h["checks"]["stage2_hands_in"] and h["checks"]["out_of_range_clamps"]


# ---- A-E8: the fifth overlay owns its surface ----------------------------------

def test_a_e8_stages_is_the_fifth_overlay_in_the_one_style():
    assert re.search(r"_stages = _overlay\(\)", SCREENS)
    assert SCREENS.count("_stages.visible = false") >= 2, \
        "show_menu AND hide_all own the new overlay (no-blank law, §j)"
    assert re.search(r"func stages_visible\(\) -> bool", SCREENS)
    assert re.search(r"func refresh_stages", SCREENS) and \
        re.search(r"for row in GameRenderer\.STAGES", SCREENS), \
        "rows rebuild from the ONE table, per open/refresh (shop law)"
    assert re.search(r"GameWorld\.ENEMY_TYPES\.get\(boss_id", SCREENS) or \
        re.search(r"ENEMY_TYPES\.get\(boss_id", SCREENS), \
        "the boss name reads the future §3.1 name row with a declared fallback"
    assert re.search(r"select\.disabled = true", SCREENS), \
        "locked rows are DISABLED, never hidden (S7 ~610 precedent)"
    assert re.search(r"stages_requested\.emit\(\)", SCREENS) and \
        re.search(r"stage_selected\.emit\(sid\)", SCREENS)
    assert re.search(r"stages_requested\.connect\(_open_stages\)", MAIN) and \
        re.search(r"stage_selected\.connect\(_stage_chosen\)", MAIN)


def test_a_e8_enter_guard_and_choice_recheck():
    # the Enter routing must not start a run through the open select panel
    with open(os.path.join(SCRIPTS, "main.gd"), encoding="utf-8") as fh:
        raw = fh.read()
    assert re.search(r"and not _screens\.shop_visible\(\) \\\s*\n"
                     r"\t*and not _screens\.stages_visible\(\):", raw), \
        "Enter is gated by the stage panel too"
    choose = block(MAIN, "func _stage_chosen", "\nfunc ")
    assert re.search(r"_dawnwell\.flags\.get\(String\(row\.unlock_flag\), 0\)",
                     choose) or "unlock_flag" in choose, \
        "the verb RE-CHECKS the unlock flag — a stale panel cannot select a \
sealed stage"
    assert re.search(r"stage_id_for_index|stage_index_for", choose) and \
        re.search(r"_meta_changed\(\)", choose)


def test_a_e8_snapshot_is_the_frozen_twelve_with_stage_set():
    row = leg("snapshot_m3")
    assert row["checks"]["exact_12"] and row["count"] == 12, \
        "Contract B stays the exact 12 fields even with stage + flare SET (F-3)"
    assert row["checks"]["start_run_resets"]


# ---- §7 draw tally: the one new MM, only where its stage draws ----------------

def test_s7_plate_mm_draws_only_on_its_stage():
    # 40 px, MEASURED at the readability gate: the first 96 px build drove
    # the block-knee to 96 (RED on both stage-3 windows — the metric calls a
    # flat decal painted ground), so the row sits under the 48 px block law
    # (capture .tmp/m3s-stages.txt carries both runs).
    assert const("PLATE_PX", VIZ) == 40.0
    tally = leg("draw_tally")["tally"]
    assert tally == {"moor-vigil": 5, "sunken-chapel": 5, "ossuary-stair": 6}, \
        "stage 1 keeps the shipped 5 draws; the plate joins only ossuary-stair"
    body = block(VIZ, "func draw_count", "\nfunc ")
    assert "DRAWS" in body and "_plate" in body


# ---- A-E1: the declared carve, re-pinned explicitly ----------------------------

def test_a_e1_chests_fixture_carve_is_the_map_row_only():
    # The A-E1 law for chests-tiers-m2.jsonl: judged ONLY on stage-1
    # OBSERVABLE rows. The committed fixture re-minted exactly ONE field —
    # the embedded `map` row (§3.1 growth, declared). This row re-pins the
    # observable half so a future observable drift can never hide behind
    # the map carve: same boss/mb/cycle tiers, same four checks.
    path = os.path.join(FIXTURES, "chests-tiers-m2.jsonl")
    with open(path, encoding="utf-8") as fh:
        rows = [json.loads(line) for line in fh if line.strip()]
    drop = [r for r in rows if r["ev"] == "chest_tier_drop"][0]
    assert drop["boss_tier"] == "warden" and drop["cycle_tier"] == "dawn"
    assert drop["checks"] == {"boss_ok": True, "cycle_ok": True,
                              "mb_ok": True, "unified_ok": True}
    assert drop["map"]["stage-item"] == "ember", \
        "the ONE embedded map row carries the declared §3.1 growth"
    assert len(rows) == 15 and any(r["ev"] == "chest_tiers_verdict" for r in rows)
