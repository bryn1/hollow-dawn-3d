"""Biome/signature numbers the v1 suite never covered (DESIGN-3D §d: band +
signature pins land here, same source-text regex style as v1
test_game_numbers.py). Covers DOD-ACCEPTANCE §b rows N14-N45 plus the S3
extra pins: band t_starts, BIOME_FLASH, score formula, §a model sizes in
metres and the §c gait constants. Source-truth: the client is Godot WASM —
constants must be exactly the pinned values in godot/scripts/. MC 11101.
"""

import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")


def read(name):
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return fh.read()


WORLD = read("world.gd")
GAME_STATE = read("game_state.gd")
MAIN = read("main.gd")
RENDER = read("render.gd")
WEAPONS = read("weapons.gd")
LEVELUP = read("levelup.gd")
HUD3D = read("hud_3d.gd")
VIZ = read("horde_viz.gd")
PROJECT = read(os.path.join("..", "project.godot"))


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


# ---- bands (N21 / A6 row) -----------------------------------------------------

def test_band_t_starts_names_and_rosters():
    # band switch at t 0/150/300/450 exactly, one signature creature per band.
    block = RENDER[RENDER.index("const BIOMES"):]
    block = block[:block.index("static func biome_at")]
    starts = [float(x) for x in re.findall(r"\"t_start\":\s*([\d.]+)", block)]
    assert starts == [0.0, 150.0, 300.0, 450.0]
    names = re.findall(r"\"name\":\s*\"([^\"]+)\"", block)
    assert names == ["MOORLAND", "BURNING DUNES", "THE FROZEN WASTE", "DEAD TUNDRA"]
    rosters = re.findall(r"\"enemies\":\s*\[([^\]]*)\]", block)
    assert [re.findall(r"\"([^\"]+)\"", r) for r in rosters] == [
        ["wraith", "moor-brute"], ["wraith", "dune-scarab"],
        ["wraith", "rime-ghoul"], ["wraith", "pale-wight"],
    ]


def test_biome_flash_3s_on_the_band_banner():
    # N22: banner text = BIOMES name, alpha-up 3.0 s, via the ONE biome_at.
    assert const("BIOME_FLASH", HUD3D) == 3.0
    assert re.search(r"GameRenderer\.biome_at\(game\.time\)", HUD3D), \
        "the banner must read bands through GameRenderer.biome_at"


# ---- run numbers (N23 / N24 / N25 / N26 / N2) ----------------------------------

def test_win_time_900():
    # The 600-era pin (test_win_time_600) was RETIRED AND REPLACED here per
    # PARITY-ROADMAP rev3 M1 feature 7 row 2: M1 runs 900.0 s. Band t_starts
    # stay 0/150/300/450 — no roadmap row re-bands them for the longer run.
    assert const("WIN_TIME", GAME_STATE) == 900.0
    assert re.search(r"time\s*>=\s*GameState\.WIN_TIME", MAIN), \
        "main.gd must gate the win on the shared WIN_TIME constant"


def test_score_formula():
    # N23 (main.gd:193-194): score = time*10 + kills*5 + level*25 + gold.
    assert re.search(
        r"stats\.time \* 10\.0 \+ stats\.kills \* 5\.0 \+ stats\.level \* 25\.0 \+ stats\.gold",
        MAIN), "score formula must stay time*10 + kills*5 + level*25 + gold"


def test_max_hp_speed_iframes():
    assert const("MAX_HP", GAME_STATE) == 100.0
    assert const("BASE_SPEED", GAME_STATE) == 140.0
    assert const("IFRAMES", GAME_STATE) == 0.5


# ---- sizes: v1 px truth + the §a metre build targets ---------------------------

def test_draw_sizes_px_unchanged():
    # N42 (render.gd:10): player 40 / enemy 34 / boss 128 / coin+gem 14 px.
    m = re.search(r"const SIZES := \{([^\}]*)\}", RENDER)
    assert m, "SIZES table missing"
    row = dict((k, float(v)) for k, v in re.findall(r"\"(\w+)\":\s*([\d.]+)", m.group(1)))
    assert row == {"player": 40.0, "enemy": 34.0, "boss": 128.0,
                   "coin": 14.0, "gem": 14.0}


def test_model_heights_metres_and_ground_scale():
    # §a: metres = size_px / S, S = 720 px / ortho 30 m = 24 px/m.
    assert const("PX_PER_M", read("camera_rig.gd")) == 24.0
    sizes = {"player": 40.0, "enemy": 34.0, "boss": 128.0}
    models = {"player": const("MODEL_H_PLAYER", VIZ),
              "enemy": const("MODEL_H_ENEMY", VIZ),
              "boss": const("MODEL_H_BOSS", VIZ)}
    assert models == {"player": 1.67, "enemy": 1.42, "boss": 5.33}
    for key, metres in models.items():
        assert abs(sizes[key] / 24.0 - metres) <= 0.005, \
            "%s: %.3f m is off the size_px/S build target" % (key, metres)


# ---- gait (S3 dump acceptance rows, DESIGN-3D §c) --------------------------------

def test_gait_constants():
    assert const("GAIT_FREQ_MAX", VIZ) == 2.2, "gait freq is capped at 2.2 Hz"
    assert const("GAIT_STRIDE_M", VIZ) == 1.2
    lo, hi = const("SCISSOR_MIN", VIZ), const("SCISSOR_MAX", VIZ)
    assert (lo, hi) == (1.00, 1.24), "scissor FULL RANGE is 1.00<->1.24"
    assert round(hi - lo, 4) <= 0.24, "dump acceptance row: scale range <= 0.24"


# ---- band signature stats (N14-N17) ---------------------------------------------

def test_band_signature_stats_per_plan():
    # moor-brute 26/32/4/2, dune-scarab 5/105/2/1, rime-ghoul 18/60/5/3,
    # pale-wight 45/52/9/4 (world.gd:20-23).
    expected = {
        "moor-brute": (26.0, 32.0, 4.0, 2.0),
        "dune-scarab": (5.0, 105.0, 2.0, 1.0),
        "rime-ghoul": (18.0, 60.0, 5.0, 3.0),
        "pale-wight": (45.0, 52.0, 9.0, 4.0),
    }
    block = WORLD[WORLD.index("const ENEMY_TYPES"):]
    for key, (hp, spd, dmg, xp) in expected.items():
        row = re.search(
            r"\"%s\":\s*\{\"hp\":\s*([\d.]+),\s*\"spd\":\s*([\d.]+),\s*\"dmg\":\s*([\d.]+),\s*\"xp\":\s*([\d.]+)" % re.escape(key),
            block)
        assert row, "ENEMY_TYPES entry for %s missing/wrong shape" % key
        assert (float(row.group(1)), float(row.group(2)),
                float(row.group(3)), float(row.group(4))) == (hp, spd, dmg, xp)


# ---- pickups + contact (N27 / N28 / N43) ----------------------------------------

def test_pickup_radius_16px():
    # world.gd: every pickup kind consumes inside 16 px. RETIRED+REPLACED
    # by T-M1e (MC 11209, roadmap feature 7 replace-row discipline): the
    # 3-kind count predates the CHEST open funnel — chests ride the SAME
    # 16 px touch funnel, so the honest row is now 4 sites.
    assert WORLD.count("< 16.0") == 4, \
        "gems + coins + heals + chests each test 16.0"


def test_contact_radii():
    # N28 (main.gd:122,125): er 17/boss 55 + player 16. N43: the same er row
    # inside the weapon _hit entry (weapons.gd:82).
    er = r"var er: float = 55\.0 if e\.boss else 17\.0"
    assert re.search(er, MAIN) and re.search(r"\(er \+ 16\.0\)", MAIN)
    assert re.search(er, WEAPONS) and re.search(r"area\.r \+ er", WEAPONS)


# ---- world drops (N29-N33) -------------------------------------------------------

def test_boss_dawnlight_guaranteed():
    # world.gd:137: boss death drops Dawnlight unconditionally (>=1).
    assert re.search(r"if enemy\.boss or randf\(\) < HEAL_DROP_CHANCE:", WORLD)


def test_gem_coin_drop_rates():
    assert re.search(r"randf\(\) < 0\.7", WORLD)
    assert re.search(r"randf\(\) < 0\.06", WORLD)
    assert re.search(r"gold\":\s*1 \+ randi\(\) % 3", WORLD)


def test_boss_death_gold():
    assert re.search(r"game\.gold \+= 50", WORLD)


def test_enemy_hp_scaling():
    # REPLACED at T-M2e (MC 11237, M2-SPEC §A.1; falsified-by-design, LEDGER
    # row): the inline `1.0 + 0.22 * (game.time / 60.0)` term is now the
    # cycle-local ramp read at the SAME seam — `cycle_minute(game)` IS
    # game.time/60.0 while cycle 0 (every non-endless run), times HP_CYC(0) =
    # 1.0 exact, then ONE clamp at def.hp * HP_EFFECTIVE_MULT_CAP (18). The
    # 0.22/minute growth itself is UNTOUCHED (spec: "not a second ramp").
    assert re.search(r"1\.0 \+ 0\.22 \* cycle_minute\(game\)\) \* "
                     r"hp_cyc\(game\.cycle\)", WORLD)
    assert re.search(r"minf\(hp, def\.hp \* HP_EFFECTIVE_MULT_CAP\)", WORLD)


def test_magnet_base_growth_and_pull():
    assert re.search(r"60\.0 \* \(1\.0 \+ 0\.25 \* game\.passives\.grip\)", WORLD)
    assert re.search(r"220\.0 \* dt", WORLD)


# ---- weapons (N34-N39 / N44 / N45) -----------------------------------------------

def test_projectile_speeds():
    assert const("BOLT_SPEED", WEAPONS) == 300.0
    assert const("THROW_SPEED", WEAPONS) == 260.0


def test_weapon_level_cap_and_fire_rate():
    assert const("MAX_LEVEL", WEAPONS) == 8.0
    assert re.search(r"return base \* pow\(0\.96, level - 1\)", WEAPONS)


def test_talon_numbers():
    assert re.search(r"w\.cd = rate\(l, 0\.55\)", WEAPONS)
    assert re.search(r"var half := 0\.62", WEAPONS)
    assert re.search(r"var range_px := 90\.0 \+ 4\.0 \* l", WEAPONS)
    assert re.search(r"\(6\.0 \+ 3\.0 \* l\)", WEAPONS)


def test_ward_numbers():
    assert re.search(r"w\.cd = 0\.45", WEAPONS)
    assert re.search(r"\{\"x\": p\.x, \"y\": p\.y, \"r\": 80\.0\}", WEAPONS)
    assert re.search(r"\(4\.0 \+ 2\.0 \* l\)", WEAPONS)
    assert re.search(r"rings\.append\(\{\"r\": 80\.0, \"life\": 0\.12, \"max\": 0\.12\}\)", WEAPONS)


def test_spike_numbers():
    assert re.search(r"var burst_r := 56\.0", WEAPONS)
    assert re.search(r"w\.cd = rate\(l, 2\.6\)", WEAPONS)
    assert re.search(r"\(18\.0 \+ 7\.0 \* l\)", WEAPONS)
    assert re.search(r"\"life\": 0\.25, \"max\": 0\.25", WEAPONS)


def test_halo_numbers():
    assert re.search(r"var count := 1 \+ int\(ceil\(w\.level / 3\.0\)\)", WEAPONS)
    assert re.search(r"var radius: float = 52\.0 \+ 3\.0 \* w\.level", WEAPONS)
    assert re.search(r"\{\"x\": ox, \"y\": oy, \"r\": 17\.0\}", WEAPONS)


def test_hit_cd_immunity():
    # N44 (weapons.gd:95): lingering damage sources tick at most every 0.3 s.
    assert re.search(r"e\.hit_cd = 0\.3", WEAPONS)


def test_sixteen_weapon_ids_and_meta():
    # The six-weapon pin was RETIRED AND REPLACED here per PARITY-ROADMAP
    # rev3 M1 feature 7 row 3 (T-M1h, MC 11220): IDS + META are the 16-
    # weapon roster, verbatim order (the six originals first — the v1
    # card/HUD order — then the ten feature-6 weapons in table order).
    ids = re.search(r"const IDS := \[((?:[^\]]|\n)*?)\]", WEAPONS).group(1)
    assert [s.strip().strip('"') for s in ids.split(",")] == [
        "talon", "ember", "cleaver", "halo", "ward", "spike",
        "bone-whip", "dart-loop", "hewn-axe", "pilgrim-cross",
        "censer-of-hours", "rot-water", "spectral-disc", "storm-peal",
        "fire-lash", "doom-sigil"]
    meta = WEAPONS[WEAPONS.index("const META"):]
    meta = meta[:meta.index("\n\n")]
    assert re.findall(r"\"name\":\s*\"([^\"]+)\"", meta) == [
        "Talon Lash", "Ember Bolt", "Bone Cleaver", "Cinder Halo",
        "Warding Aura", "Grave Spike",
        "Bone Whip", "Dart Loop", "Hewn Axe", "Pilgrim Cross",
        "Censer of Hours", "Rot Water", "Spectral Disc", "Storm Peal",
        "Fire Lash", "Doom Sigil"]


# ---- levelup (N40) ---------------------------------------------------------------

def test_passive_cap_and_coin_cache():
    assert const("MAX_PASSIVE_STACKS", LEVELUP) == 5.0
    assert re.search(r"game\.gold \+= 25", LEVELUP)
    assert re.search(r"minf\(game\.max_hp, game\.hp \+ 10\.0\)", LEVELUP)


# ---- view (N41) -------------------------------------------------------------------

def test_view_1280x720():
    assert re.search(r"const VIEW := Vector2\(1280, 720\)", MAIN)
    assert "window/size/viewport_width=1280" in PROJECT
    assert "window/size/viewport_height=720" in PROJECT


# ---- §f data-module decision + the ported HP-bar rule ------------------------------

def test_render_gd_is_data_only_no_ghost_renderer():
    # §f: BIOMES/tint_of survive; every Node2D drawing body is DELETED.
    assert "extends Node2D" not in RENDER
    assert "func _draw" not in RENDER
    assert "HaloPass" not in RENDER
    assert "static func biome_at" in RENDER, "world.gd:52 calls through this"


def test_hp_bar_only_when_damaged_ported_to_viz():
    # §d (render.gd:185-191 rule -> horde_viz bar MM): instances exist only
    # for damaged non-boss units; per-instance scale.x = hp/max_hp.
    assert re.search(r"if not e\.boss and e\.hp < e\.max_hp:", VIZ)
    assert re.search(r"clampf\(e\.hp / e\.max_hp, 0\.0, 1\.0\)", VIZ)
