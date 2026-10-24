"""ENDLESS (MC 11237 T-M2e): M2-SPEC rev-2 §A ACCEPT rows A-E1..A-E8.

Suite convention (test_game_numbers/test_chests_evolve header): source-truth
pins over the .gd text + behaviour rows judged from the committed, seed-
pinned dump (godot/sim/sim_endless.gd, seed 11237, byte-stable; the re-run
byte-identity itself is the capture's job, the sim_evolve precedent).

Row map (spec row -> evidence here / in the dump):
  A-E1 endless reaches cycle 2   endless_reach2 + cycle_clear rows; RED leg
       flag off -> endless_off_win kind "win" (RED if it keeps running).
  A-E2 per-cycle scaling k=1..3  endless_scaling rows (hp-mult read from a
       REAL _spawn_enemy; qty/dmg-mult from the ONE statics) + clamp_eval
       (rev-2 P2-2); the clamp-binding RED is the planted low cap, capture.
  A-E3 clamps bind at cycle 5    endless_caps_cycle5 (DECLARED-PIN eval: HP
       clamp on def.hp*18, contact clamp 20 on the boss class; planted RED
       = drop either clamp, capture).
  A-E4 cycle-clear chest tier    endless_cycle_clear_reward (tier dawn ==
       CHEST_TIER_BY_SOURCE["endless-cycle"], the SAME map B-T1 asserts) +
       reward card pending +1; the map itself pinned from world.gd source.
  A-E5 best_cycle persistence    source pins below + sim endless_bestcycle
       (run at cycle 3 -> 3; never decreases); save side (older save -> 0,
       roundtrip) rides tests/test_save.py + save_probe legs.
  A-E6 flag-off byte-stability   endless_off_win + snapshot_keys (exact
       frozen 12 fields, cycle/endless ABSENT; the 12-field pin below is
       the "add a snapshot field -> RED" instrument, F-3); byte-identity
       vs this committed fixture + the M1 sim_headless journey is capture.
  A-E7 cycle HUD text            source pin (endless-gated row) + the
       CYCLE-HUD pixel row in tools/s8_acceptance.py (crop >= 200 vs the
       same-state hidden-cycle baseline; planted RED baseline-vs-itself).
  A-E8 HP-pin reaches cycle 2    endless_reach2 (best_cycle 2 in memory AND
       on disk through the one _meta_changed funnel; cycle < 2 here IS the
       roadmap RED leg — the ok flags are the assertion).
"""

import json
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures", "endless-m2.jsonl")


def read(name):
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return "".join(line.split("#")[0] + "\n" for line in fh.read().splitlines())


def read_raw(name):  # comment-bearing source, for text-absence claims only
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return fh.read()


GAME_STATE = read("game_state.gd")
WORLD = read("world.gd")
MAIN = read("main.gd")
SAVE = read("save.gd")
HUD = read("hud_3d.gd")

SNAPSHOT_KEYS = ["enemies", "gold", "hp", "kills", "level", "maxHp",
                 "phase", "runId", "time", "weapons", "xp", "xpNext"]


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


def rows_of(ev):
    out = []
    with open(FIXTURE, encoding="utf-8") as fh:
        for line in fh:
            if line.strip():
                r = json.loads(line)
                if r.get("ev") == ev:
                    out.append(r)
    return out


def verdict():
    return rows_of("endless_verdict")[0]


# ---- §A.1 the capped scalars, in the ONE seams (source truth) ----------------

def test_hp_effective_mult_cap_18():
    assert const("HP_EFFECTIVE_MULT_CAP", WORLD) == 18.0
    # the single clamp at the spawn site (rev-2 P2-2: THE deep-cycle bound)
    assert re.search(r"hp\s*=\s*minf\(hp,\s*def\.hp \* HP_EFFECTIVE_MULT_CAP\)",
                     WORLD)


def test_cycle_scalar_caps_and_formulas():
    assert re.search(r"static func hp_cyc\(cycle: int\) -> float:\s*\n"
                     r"\treturn minf\(1\.0 \+ 0\.75 \* cycle, 6\.0\)", WORLD)
    assert re.search(r"static func qty_cyc\(cycle: int\) -> float:\s*\n"
                     r"\treturn minf\(1\.0 \+ 0\.25 \* cycle, 2\.0\)", WORLD)
    assert re.search(r"static func dmg_cyc\(cycle: int\) -> float:\s*\n"
                     r"\treturn minf\(1\.0 \+ 0\.20 \* cycle, 2\.5\)", WORLD)


def test_cycle_minute_is_the_single_ramp_term():
    assert re.search(r"static func cycle_minute\(game: GameState\) -> float:"
                     r"\s*\n\treturn \(game\.time - game\.cycle \* "
                     r"GameState\.WIN_TIME\) / 60\.0", WORLD)
    # read by BOTH ramp sites (spawn hp + spawn rate) — one formula, no copy
    assert len(re.findall(r"cycle_minute\(game\)", WORLD)) == 2
    # the untouched ceilings (rev-2 P2-3): rate 12/s + ALIVE_CAP stay in place
    assert re.search(r"minf\(12\.0,\s*\(1\.0 \+ 1\.3 \* minute\) \* "
                     r"qty_cyc\(game\.cycle\)\)", WORLD)
    assert const("ALIVE_CAP", WORLD) == 400.0


def test_max_contact_dmg_20_at_the_contact_site_before_reduction():
    assert const("MAX_CONTACT_DMG", MAIN) == 20.0
    # §A.1: clamped read BEFORE damage_taken (ward/rotten-plate stay downstream)
    m = re.search(r"var raw: float = minf\(e\.dmg \* GameWorld\.dmg_cyc"
                  r"\(game\.cycle\), MAX_CONTACT_DMG\)\s*\n"
                  r"\t*game\.hp -= game\.damage_taken\(raw\)", MAIN)
    assert m, "contact damage must be the one clamped read into damage_taken"


# ---- §A.1/A.2 the flag, the latch, the clear ----------------------------------

def test_run_mode_vars_reset_in_start_run():
    assert re.search(r"var endless := false", GAME_STATE)
    assert re.search(r"var cycle := 0", GAME_STATE)
    body = GAME_STATE.split("func start_run()")[1].split("func set_phase")[0]
    assert re.search(r"endless = false", body) and re.search(r"cycle = 0", body)


def test_endless_handin_is_the_one_meta_seam():
    # F-4: consumed at the start through the _dawnwell -> start seam, AFTER
    # start_run (which resets); never a start_run default.
    assert re.search(r"game\.start_run\(\)\s*\n(?:\t*(?://[^\n]*\n)*)*"
                     r"\t*game\.endless = int\(_dawnwell\.flags\.get"
                     r"\(\"endless\", 0\)\) == 1", MAIN)


def test_win_branch_latched_cycle_clear_flag_off_wins():
    m = re.search(r"if game\.time >= GameState\.WIN_TIME:\s*\n"
                  r"(?:\t*//[^\n]*\n)*"
                  r"\t*if game\.endless:\s*\n"
                  r"\t*var next_cycle := int\(game\.time / GameState\.WIN_TIME\)\s*\n"
                  r"\t*if next_cycle > game\.cycle:\s*\n"
                  r"\t*game\.cycle = next_cycle\s*\n"
                  r"\t*_cycle_clear\(\)\s*\n"
                  r"\t*else:\s*\n"
                  r"\t*_end_run\(\"win\"\)\s*\n\t*return", MAIN)
    assert m, "the win branch is the latched crossing; flag OFF keeps _end_run"


def test_cycle_clear_funnel_lines():
    body = MAIN.split("func _cycle_clear()")[1].split("func ")[0]
    assert re.search(r"game\.pending_levels \+= 1", body)  # A-E4 reward card
    assert re.search(r"world\.cycle_clear\(game\)", body)  # single drop funnel
    assert re.search(r"if game\.cycle > _dawnwell\.best_cycle:\s*\n"
                     r"\t*_dawnwell\.best_cycle = game\.cycle", body)
    assert re.search(r"_meta_changed\(\)", body)  # §A.3 the ONE funnel
    # best_cycle updates at exactly TWO sites (clear + run end), never more
    assert len(re.findall(r"> _dawnwell\.best_cycle", MAIN)) == 2
    end_body = MAIN.split("func _end_run")[1].split("func ")[0]
    assert re.search(r"if game\.cycle > _dawnwell\.best_cycle", end_body)


def test_world_cycle_clear_rides_the_single_drop_array():
    body = WORLD.split("func cycle_clear")[1].split("func ")[0]
    assert re.search(r"chests\.append\(\{\"x\": game\.player\.x, \"y\": "
                     r"game\.player\.y,\s*\n?\t*\"tier\": CHEST_TIER_BY_SOURCE"
                     r"\[\"endless-cycle\"\]\}\)", body)


# ---- §B.1 the source->tier map (A-E4 == B-T1 single source, rev-2 P1) --------

def test_chest_tier_by_source_map_rows():
    m = re.search(r"const CHEST_TIER_BY_SOURCE := \{\"miniboss\": \"ember\", "
                  r"\"warden\": \"warden\",\s*\n?\t*\"endless-cycle\": \"dawn\", "
                  r"\"event\": \"dawn\"\}", WORLD)
    assert m, "CHEST_TIER_BY_SOURCE must be the §B.1 map (cycle-clear -> dawn)"


# ---- §A.3 persistence (save side detail rows ride test_save.py) --------------

def test_best_cycle_field_no_version_bump():
    assert re.search(r"var best_cycle := 0", SAVE)
    assert re.search(r"well\.best_cycle = int\(data\.get\(\"best_cycle\", 0\)\)",
                     SAVE)  # older save -> 0, field-by-field
    assert const("VERSION", SAVE) == 1.0  # §A.3: NO version bump


# ---- §A.2 the cycle HUD row is endless-gated (A-E7 source side) --------------

def test_hud_cycle_row_endless_gated():
    assert re.search(r"_cycle\.visible = game\.endless", HUD)
    assert re.search(r"\"Cycle %d\" % game\.cycle", HUD)
    assert re.search(r"_cycle = _label\(\"Cycle 0\"\)\s*\n\t*_cycle\.visible "
                     r"= false", HUD)  # hidden pre-endless: M1 HUD unchanged


# ---- F-3 the frozen snapshot stays exact-12, cycle/endless absent -----------

def test_snapshot_source_stays_exact_twelve_fields():
    src = read_raw("game_state.gd")
    body = src.split("func snapshot_json")[1].split("_random_hex")[0]
    # the JSON.stringify block IS the Contract B shape (weapon_rows builds a
    # nested row list above it; its inner keys belong to the weapons field)
    shape = body.split("JSON.stringify({")[1].split("\n\t})")[0]
    keys = re.findall(r"\"(\w+)\":", shape)
    assert sorted(keys) == SNAPSHOT_KEYS, \
        "the Contract B snapshot is the frozen exact-12 shape (F-3): adding a " \
        "cycle/endless field here must go RED (A-E6 red column)"
    low = " ".join(keys).lower()
    assert "cycle" not in low and "endless" not in low


# ---- behaviour rows: the committed seed-pinned dump (sim_endless.gd) ---------

def test_dump_verdict_green():
    v = verdict()
    assert v["ok"] is True and v["rows"] == 12


def test_ae1_e8_reach_cycle2_with_clears_and_persisted_best():
    clears = rows_of("cycle_clear")
    assert [r["cycle"] for r in clears] == [1, 2]
    assert [r["t"] for r in clears] == [900.017, 1800.017]
    assert all(not r["ended"] for r in clears)  # run continues, phase never ends
    r = rows_of("endless_reach2")[0]
    assert r["ok"] is True and r["cycle"] == 2 and r["clears"] == 2
    assert r["checks"]["hp_pinned"] is True  # DECLARED s8 win-leg deviation,
    # named per row in the dump (the endless_reach2 "declared" field carries
    # the full statement; cycle_clear rows carry hp_pinned too)
    assert all(c["hp_pinned"] for c in clears)
    assert r["best_cycle_mem"] == 2 and r["disk_best_cycle"] == 2  # A-E5/E8


def test_ae1_red_flag_off_still_wins_at_the_limit():
    r = rows_of("endless_off_win")[0]
    assert r["ok"] is True and r["kind"] == "win"
    # (RED column: if an endless branch leaked flag-off, kind would not be
    # "win" — planted in the capture: bypass the flag guard -> RED -> revert)


def test_ae5_best_cycle_run_at_3_and_never_decreases():
    r = rows_of("endless_bestcycle")[0]
    assert r["ok"] is True
    assert r["disk_after"] == 3  # run ending at cycle 3 -> 3 (A-E5)
    assert r["disk_after_shallower"] == 3  # never decreases


def test_ae4_cycle_clear_reward_and_dawn_tier():
    r = rows_of("endless_cycle_clear_reward")[0]
    assert r["ok"] is True
    assert r["pending_before"] == 0 and r["pending_after"] == 1  # reward card
    assert r["tier"] == "dawn" == r["map_row"].split(" -> ")[1]
    assert r["phase"] not in ("gameover", "win")  # the run continues (A-E1)


def test_ae3_both_clamps_bind_at_cycle5():
    r = rows_of("endless_caps_cycle5")[0]
    assert r["ok"] is True and r["cycle"] == 5 and r["m_c"] == 13.0
    # HP side: raw product ABOVE the 18x bound, observed hp AT it (def 45)
    assert r["hp_raw_product"] > r["hp_clamped_to"] == r["hp_observed"] == 810.0
    # contact side: warden 12 x DMG_CYC(5)=2.0 = 24 raw, clamped to 20 observed
    assert r["contact_raw"] == 24.0 and r["contact_observed_delta"] == 20.0
    assert r["max_contact_dmg"] == 20.0


def test_ae2_scaling_rows_k1_3_and_clamp_eval():
    rows = rows_of("endless_scaling")
    assert [r["cycle"] for r in rows] == [1, 2, 3]
    assert [r["hp_mult"] for r in rows] == [1.75, 2.5, 3.25]
    assert [r["qty_mult"] for r in rows] == [1.25, 1.5, 1.75]
    assert [r["dmg_mult"] for r in rows] == [1.2, 1.4, 1.6]
    for r in rows:
        assert r["ok"] is True
        assert r["hp_observed"] == r["hp_expected"]  # real _spawn_enemy read
        assert r["clamped"] is False  # k<=3 never clamp (rev-2 P2-2)
        assert r["rate_ceil_kept"] == 12.0 and r["alive_cap_kept"] == 400
    e = rows_of("endless_clamp_eval")[0]
    assert e["ok"] is True and e["worst_product"] < e["cap"]  # 17.2 < 18


def test_ae6_snapshot_row_exact_12():
    r = rows_of("snapshot_keys")[0]
    assert r["ok"] is True and r["count"] == 12
    assert r["keys"] == SNAPSHOT_KEYS
