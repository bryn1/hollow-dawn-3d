"""Dawn Well shop + refunds (MC 11210 T-M1f): PARITY-ROADMAP rev3 M1 feature 2.
Two legs per the repo's suite convention (test_save.py is the closest shape):

1. SOURCE TRUTH: the OUR table, REFUND_FEE_PCT, the cost curve, the floor
   division, the start_run() consumption seam, main.gd's wiring, the ONE
   panel style and the persistence NOT being re-authored — regex-pinned, the
   roadmap demanding the table "governed by the same pytest regex-pin as the
   table, not prose".
2. BEHAVIOR: godot/sim/shop_probe.gd runs every rule for real on a throwaway
   user:// (XDG_DATA_HOME env isolation, the test_save pattern) — buy / fee /
   floor / refund-all / corrupt-into-shop / rank-effects / sealed / cash-out
   rows, plus the roadmap's named dawnwell.<id>.rank dump rows. The corrupt
   leg RIDES the T-M1a quarantine observables (asserted here, never
   re-authored): the SAVE_LOAD_FAIL marker is save.gd's own.

The fee leg and the floor leg are the planted-red pairs of this card: break
the fee (refund pays full) and this file goes RED on its own fee row; drop
the rank-0 guard and the floor row goes RED (rank lands below 0).
"""

import json
import os
import re
import subprocess
import tempfile

import pytest

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
GODOT = os.environ.get(
    "HD3D_GODOT",
    "/home/claudecode/Games/.tools/godot/Godot_v4.7.2-stable_linux.x86_64")
PROBE = "res://sim/shop_probe.gd"
SHOT = os.path.join(conftest.REPO, "assets", "screens", "m1-dawnwell.png")

pytestmark = pytest.mark.skipif(
    not os.path.exists(GODOT), reason="Godot binary not installed")

CLASS_CACHE = os.path.join(conftest.REPO, "godot", ".godot",
                           "global_script_class_cache.cfg")

# OUR table, exactly (id, stat family, scope) — the roadmap "our names/ranks/
# prices; effect stats ours" row; order is the TABLE order (shop display).
OUR_TABLE = [
    ("vitality", "maxhp", "m1"), ("bulwark", "maxhp", "m1"),
    ("ironbones", "maxhp", "m1"), ("deep-roots", "maxhp", "m1"),
    ("sage-thirst", "xp", "m1"), ("dusk-ledger", "xp", "m1"),
    ("grave-scholar", "xp", "m1"), ("pale-wisdom", "xp", "m1"),
    ("grave-greed", "gold", "m1"), ("coin-cup", "gold", "m1"),
    ("bone-market", "gold", "m1"), ("tithe-bell", "gold", "m1"),
    ("swift-shroud", "speed", "m2"), ("ghost-foot", "speed", "m2"),
    ("wide-reap", "area", "m2"), ("crescent-arc", "area", "m2"),
    ("quick-hands", "cooldown", "m2"), ("toll-tempo", "cooldown", "m2"),
    ("raven-feather", "luck", "m2"), ("egg-of-dawn", "luck", "m2"),
    ("split-silhouette", "projectile", "m2"), ("echo-vessel", "projectile", "m2"),
    ("magnet-bone", "pickup", "m2"), ("moss-mail", "armor", "m2"),
]


def ensure_class_cache():
    # T-M1a cycle-2 lesson, verbatim mechanism: the gitignored godot/.godot
    # class cache is what lets the DawnWell/PowerUps self-references compile;
    # gate is the cache FILE (the --import shutdown-abort quirk), never rc.
    if os.path.exists(CLASS_CACHE):
        return
    subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(conftest.REPO, "godot"),
         "--import"],
        capture_output=True, text=True, timeout=600)
    assert os.path.exists(CLASS_CACHE), \
        "godot --import produced no global class cache"


def read(name, code_only=False):
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        src = fh.read()
    if code_only:  # the test_chests_evolve idiom: regex pins on code, not prose
        src = "".join(line.split("#")[0] + "\n" for line in src.splitlines())
    return src


POWERUPS = read("powerups.gd")
GAME_STATE = read("game_state.gd")
GAME_STATE_CODE = read("game_state.gd", code_only=True)
MAIN = read("main.gd")
SCREENS = read("screens.gd")
WORLD = read("world.gd")
SAVE = read("save.gd")


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


# ---- 1. source-truth pins ----------------------------------------------------

def test_refund_fee_pct_pinned_as_table_row():
    # roadmap verbatim: OUR fee pinned as a table row, REFUND_FEE_PCT := 5
    assert const("REFUND_FEE_PCT", POWERUPS) == 5.0


def test_table_is_24_our_rows():
    rows = re.findall(
        r'\{"id": "([a-z-]+)", .*?"stat": "([a-z]+)", .*?'
        r'"scope": "(m[12])"\}', POWERUPS)
    assert rows == OUR_TABLE, "TABLE must be the OUR table, this order"
    assert len(rows) == 24


def test_m1_scope_is_snapshot_exposed_stats_only():
    # DA c1 B-5 proof split: M1 effects ONLY on maxHp / xp / gold-rate rows;
    # speed/area/cooldown/luck-class rows are scope m2 (M2 dump-probe card).
    scopes = {}
    for _id, stat, scope in OUR_TABLE:
        scopes.setdefault(scope, []).append(stat)
    assert set(scopes["m1"]) == {"maxhp", "xp", "gold"}
    assert len(scopes["m1"]) == 12 and len(scopes["m2"]) == 12
    assert not set(scopes["m2"]) & {"maxhp", "xp", "gold"}


def test_maxhp_rows_per_10():
    # roadmap snapshot formula: maxHp == 100 + Σ maxHp-ranks*10
    per = dict((r_id, float(re.search(
        r'"id": "%s", .*?"per": ([\d.]+)' % r_id, POWERUPS).group(1)))
        for r_id, stat, _s in OUR_TABLE)
    assert all(per[r_id] == 10.0 for r_id, stat, _s in OUR_TABLE
               if stat == "maxhp")


def test_our_cost_curve_and_floor_division():
    assert re.search(r"return int\(r\.cost\) \* \(current_rank \+ 1\)", POWERUPS), \
        "OUR cost curve row: base * (rank + 1)"
    assert re.search(r"int\(r\.cost\) \* rank \* \(100 - REFUND_FEE_PCT\) / 100",
                     POWERUPS), "refund must be the floor-division formula"
    # refund-all is the SUM of the per-rank floors (doc: Σ spent floor ...)
    assert re.search(r"for k in range\(rank, 0, -1\):\s*\n\s*total \+= "
                     r"refund_for\(r\.id, k\)", POWERUPS)


def test_consumption_seam_is_start_run():
    start = GAME_STATE[GAME_STATE.index("func start_run"):
                       GAME_STATE.index("func set_phase")]
    assert "max_hp = MAX_HP + PowerUps.max_hp_bonus(meta_ranks)" in start
    assert "meta_xp_mult = 1.0 + PowerUps.xp_bonus(meta_ranks)" in start
    assert "meta_gold_mult = 1.0 + PowerUps.gold_bonus(meta_ranks)" in start
    assert re.search(r"xp \+= amount \* \(1\.0 \+ 0\.15 \* passives\.insight\) "
                     r"\* meta_xp_mult", GAME_STATE)
    # gold-rate rides the ONE pickup funnel's return
    assert re.search(r"return game\.credit_gold\(gold\)", WORLD)
    # run gold only ever whole-coins: credit_gold floors the carry
    assert re.search(r"var whole := int\(floor\(gold_frac\)\)", GAME_STATE)
    # direction: GameState never touches persistence (code-only: the file's
    # own comment NAMES the seam it does not touch)
    assert "DawnWell" not in GAME_STATE_CODE


def test_main_wiring():
    assert re.search(r"game\.meta_ranks = _dawnwell\.ranks\.duplicate\(\)\s*\n"
                     r"\t*game\.start_run\(\)", MAIN)
    assert re.search(r"_dawnwell\.gold \+= game\.stats\.gold\s*\n\s*"
                     r"_meta_changed\(\)", MAIN), \
        "run gold -> meta gold 1:1 at every run end, through the funnel"
    for sig in ("shop_requested.connect(_open_shop)",
                "shop_buy.connect(_shop_buy)",
                "shop_refund.connect(_shop_refund)",
                "shop_refund_all.connect(_shop_refund_all)"):
        assert sig in MAIN, sig
    for verb in ("PowerUps.buy(_dawnwell, id)", "PowerUps.refund(_dawnwell, id)",
                 "PowerUps.refund_all(_dawnwell)"):
        assert verb in MAIN, verb
    assert re.search(r"game\.phase == \"menu\" and bridge\.is_enter\(code\) "
                     r"and not _screens\.shop_visible\(\)", MAIN), \
        "menu Enter stays inert while the shop panel is open"


def test_shop_ui_is_the_one_panel_style():
    assert re.search(r"_shop = _overlay\(\)", SCREENS), "fourth overlay, same idiom"
    assert re.search(r'for row in PowerUps\.TABLE', SCREENS), "rows from the ONE table"
    assert re.search(r"buy\.disabled = rank >= PowerUps\.MAX_RANK or "
                     r"_well\.gold < price", SCREENS), \
        "disable-when-maxed (S7 ~610): disabled, never hidden"
    assert re.search(r"back\.disabled = rank <= 0", SCREENS), "rank-0 refund floor"
    assert re.search(r'box\.offset_left = -380', SCREENS) and \
        re.search(r"_center_box\(_shop\)", SCREENS), "the §j wider-column precedent"
    hide_all = SCREENS[SCREENS.index("func hide_all"):
                       SCREENS.index("func show_levelup")]
    assert "_shop.visible = false" in hide_all, "hide_all owns the shop too"


def test_persistence_not_reauthored():
    # T-M1a owns save.gd VERBATIM: the shop must not have crept in there.
    assert "PowerUps" not in SAVE
    assert not re.search(r"func (buy|refund|refund_all)\b", SAVE)
    for fn in ("static func load_save", "func save", "func reset",
               "static func quarantine"):
        assert SAVE.count(fn) == 1, fn


# ---- 2. behavior legs: the real rules on a real throwaway user:// ------------

@pytest.fixture(scope="module")
def probe():
    """One REAL headless run of shop_probe.gd on a throwaway XDG_DATA_HOME
    (user:// lands in /tmp — the T-M1a isolation pattern). Returns
    (rows, dump_ranks, json_text, stderr)."""
    ensure_class_cache()
    scratch = tempfile.mkdtemp(prefix="hd3d-shop-")
    r = subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(conftest.REPO, "godot"),
         "-s", PROBE],
        env=dict(os.environ, XDG_DATA_HOME=scratch),
        capture_output=True, text=True, timeout=300)
    assert r.returncode == 0 and "PROBE_DONE" in r.stdout, \
        "probe run failed:\n%s\n%s" % (r.stdout[-2000:], r.stderr[-2000:])
    rows, dump_ranks, json_text = {}, {}, None
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
        elif line.startswith("dawnwell."):
            k, _, v = line.partition("=")
            dump_ranks[k] = int(v)
    return rows, dump_ranks, json_text, r.stderr


def test_curve_row(probe):
    rows, *_ = probe
    assert rows["curve"] == {"linear": 1, "rows": 24, "max": 5, "fee": 5}


def test_buy_and_save_roundtrip(probe):
    rows, _, json_text, _ = probe
    assert rows["buy"] == {"ok": 1, "rank": 1, "gold": 960,
                           "reloaded_rank": 1, "reloaded_gold": 960}
    disk = json.loads(json_text)
    assert disk == {"version": 1, "gold": 960,
                    "ranks": {"vitality": 1}, "flags": {}}


def test_poor_buy_declines(probe):
    rows, *_ = probe
    assert rows["poor"] == {"ok": 0, "rank_absent": 1, "gold": 10}


def test_disable_when_maxed_rule_side(probe):
    rows, *_ = probe
    assert rows["max"] == {"buys_ok": 5, "rank": 5, "cap": 5,
                           "paid": 600, "expected": 600}


def test_refund_fee_leg(probe):
    # planted-red pair 1: remove the fee and give pays 40, this row REDs.
    rows, *_ = probe
    assert rows["fee"] == {"give": 38, "paid": 40, "fee_pct": 5, "rank": 0}


def test_rank_floor_leg(probe):
    # planted-red pair 2: drop the guard and rank goes -1, this row REDs.
    rows, *_ = probe
    assert rows["floor"] == {"give": 0, "rank": -9, "gold": 500}


def test_refund_all_sums_the_per_rank_floors(probe):
    # roadmap verbatim: gold returned == Σ spent floor × (1 - FEE/100)
    # vitality 2 ranks (40+80 -> 38+76) + grave-greed 1 (100 -> 95) = 209.
    rows, *_ = probe
    assert rows["refund_all"] == {"before": 780, "after": 989, "gave": 209,
                                  "expected": 209, "ranks_left": 0}


def test_corrupt_save_into_shop_rides_t_m1a_observables(probe):
    rows, _, _, stderr = probe
    assert rows["corrupt_shop"] == {"quarantined": 1, "defaults": 1,
                                    "declined": 1, "bought": 1, "ok": 1,
                                    "file_back": 1, "reloaded_rank": 1}
    markers = [ln for ln in stderr.splitlines()
               if ln.startswith("SAVE_LOAD_FAIL path=user://dawnwell.json")]
    assert len(markers) == 1 and "reason=undecodable" in markers[0], \
        "the quarantine marker is save.gd's own observable — asserted, not re-authored"


def test_effect_snapshot_and_dump_rows(probe):
    rows, dump_ranks, _, _ = probe
    # roadmap named rows: dawnwell.<id>.rank per bought power-up ...
    assert dump_ranks == {"dawnwell.vitality.rank": 2,
                          "dawnwell.bulwark.rank": 1,
                          "dawnwell.sage-thirst.rank": 1,
                          "dawnwell.grave-greed.rank": 2}
    # ... and the pinned snapshot arithmetic (float tokens compare as float)
    eff = rows["effects"]
    assert float(eff["maxhp"]) == 130.0 and float(eff["expect"]) == 130.0
    assert float(eff["hp"]) == 130.0
    assert eff["xpnext"] == 10 and eff["expect_xpnext"] == 10


def test_xp_rate_effect_leg(probe):
    rows, *_ = probe
    assert rows["xprate"] == {"base_level": 1, "boosted_level": 2,
                              "xpnext_is_formula": 1}


def test_gold_rate_effect_leg(probe):
    # 10x1g through the REAL collect funnel: identity 10, ranks 13 = floor(13)
    rows, *_ = probe
    assert rows["goldrate"] == {"base_gold": 10, "expect_base": 10,
                                "boosted_gold": 13, "expect": 13}


def test_sealed_m2_rows_change_nothing(probe):
    # DA c1 B-5: sealed (scope-m2) ranks are purchasable but run-effectless;
    # the M2 card replaces this row with its own dump-probe legs.
    rows, *_ = probe
    assert rows["sealed"] == {"same_maxhp": 1, "same_xpnext": 1,
                              "same_speed": 1, "same_hp": 1}


def test_run_gold_cashes_out_through_main_funnel(probe):
    rows, *_ = probe
    # ranks=empty is the probe's non-int token (fresh convert leg: the run
    # cashes GOLD only, ranks untouched by a run).
    assert rows["convert"] == {"well_gold": 77, "on_disk": 77, "file": 1,
                               "ranks": "empty"}


def test_shot_asset_exists():
    assert os.path.isfile(SHOT), \
        "assets/screens/m1-dawnwell.png must be committed (gate: dawnwell_pixel_gate)"
