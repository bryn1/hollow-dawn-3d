"""S4 combat + weapon-effects number pins (MC 11102 T-S4), same source-text
regex style as the v1 suite: damage per weapon, fire-rate bases + formula,
xp curve rows, gold rows, contact damage, drop probabilities from the N-table
(DOD-ACCEPTANCE §b), and the S4 visual-layer contracts — §i live-FX cap
formulas, the §c attack lunge/squash constants, the §b blob-shadow row, the
billboarded HP bar, and v1's CONSTANT iframe alpha 0.55 (render.gd:134-138
semantics — no pulse). Source-truth: the client is Godot WASM — constants
must be exactly the pinned values in godot/scripts/.
"""

import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")


read = conftest.read_script  # MC 11317 C2 seam (raw script text)


WORLD = read("world.gd")
GAME_STATE = read("game_state.gd")
MAIN = read("main.gd")
WEAPONS = read("weapons.gd")
LEVELUP = read("levelup.gd")
VIZ = read("horde_viz.gd")
FX = read("viz_fx.gd")
PAWN = read("hero_pawn.gd")
RIG = read("camera_rig.gd")


const = conftest.const  # MC 11317 C2 seam (impl in conftest.py)


# ---- damage per weapon (N36-N39 row family) ------------------------------------

def test_damage_per_weapon():
    assert re.search(r"\(6\.0 \+ 3\.0 \* l\) \* mul\)", WEAPONS), "talon dmg 6+3L"
    assert re.search(r"\(9\.0 \+ 4\.0 \* l\) \* mul", WEAPONS), "ember dmg 9+4L"
    assert re.search(r"\(15\.0 \+ 6\.0 \* l\) \* mul", WEAPONS), "cleaver dmg 15+6L"
    assert re.search(r"\(4\.0 \+ 2\.0 \* l\) \* mul, true\)", WEAPONS), "ward dmg 4+2L (ticked)"
    assert re.search(r"\(18\.0 \+ 7\.0 \* l\) \* mul\)", WEAPONS), "spike dmg 18+7L"
    assert re.search(r"\(6\.0 \+ 2\.0 \* w\.level\) \* mul", WEAPONS), "halo dmg 6+2L"


# ---- fire rate (N35 + per-weapon cooldown bases) ------------------------------

def test_fire_rate_formula_and_bases():
    assert re.search(r"return base \* pow\(0\.96, level - 1\)", WEAPONS)
    assert re.search(r"w\.cd = rate\(l, 0\.55\)", WEAPONS), "talon cd base 0.55"
    assert re.search(r"w\.cd = rate\(l, 0\.85\)", WEAPONS), "ember cd base 0.85"
    assert re.search(r"w\.cd = rate\(l, 1\.15\)", WEAPONS), "cleaver cd base 1.15"
    assert re.search(r"w\.cd = 0\.45", WEAPONS), "ward cd 0.45 (fixed)"
    assert re.search(r"w\.cd = rate\(l, 2\.6\)", WEAPONS), "spike cd base 2.6"
    assert const("MAX_LEVEL", WEAPONS) == 8.0


# ---- xp curve rows (N19) -------------------------------------------------------

def test_xp_curve_rows():
    assert re.search(r"return\s+5\s*\+\s*4\s*\*\s*level\s*\+\s*level\s*\*\s*level",
                     GAME_STATE), "xp_need must be 5 + 4*level + level*level"
    # rows the sim dump cross-checks: L1..L8 need 10/17/26/37/50/65/82/101
    assert [5 + 4 * l + l * l for l in range(1, 9)] == [10, 17, 26, 37, 50, 65, 82, 101]


# ---- gold (N30/N31 + Coin Cache N40) -------------------------------------------

def test_gold_rows():
    assert re.search(r"game\.gold \+= 50", WORLD), "boss death +50 gold (N31)"
    assert re.search(r"coins\.append\(\{\"x\": enemy\.x, \"y\": enemy\.y, \"gold\": 1 \+ randi\(\) % 3\}\)",
                     WORLD), "coin drop 1-3 g (N30)"
    assert re.search(r"game\.gold \+= 25", LEVELUP), "Coin Cache +25 gold (N40)"


# ---- contact damage (N28/N26 + ENEMY_TYPES dmg column) -------------------------

def test_contact_damage():
    # REPLACED at T-M2e (MC 11237, M2-SPEC §A.1; falsified-by-design, LEDGER
    # row): e.dmg now enters the SAME single damage_taken seam through the
    # one clamped cycle read — minf(e.dmg * DMG_CYC(cycle), MAX_CONTACT_DMG
    # 20) — which at cycle 0 IS e.dmg (DMG_CYC(0)=1.0, every base dmg below
    # the cap), so the v1 damage column below is untouched and byte-stable.
    assert re.search(r"var raw: float = minf\(e\.dmg \* GameWorld\.dmg_cyc"
                     r"\(game\.cycle\), MAX_CONTACT_DMG\)\s*\n"
                     r"\t*game\.hp -= game\.damage_taken\(raw\)", MAIN)
    assert re.search(r"p\.iframes = GameState\.IFRAMES", MAIN)
    assert const("IFRAMES", GAME_STATE) == 0.5
    assert const("MAX_CONTACT_DMG", MAIN) == 20.0
    dmg = [float(x) for x in re.findall(r"\"dmg\": ([\d.]+)", WORLD[:WORLD.index("const GATES")])]
    # Column RE-PINNED by T-M1d (M1 feature 4): the two miniboss rows append
    # 10/11 after the warden's 12; the nine v1 rows N10-N18 are unchanged.
    # Column RE-PINNED AGAIN by T-M3b (MC 11284, rev-3 §3.1; falsified-by-
    # design, LEDGER row): the two end-boss rows append 13/14. The cycle-0
    # byte-stability claim of the clamp (rev-3 P3-1, the VACUOUS row) rides
    # exactly this: EVERY entry stays below MAX_CONTACT_DMG 20, so the raw
    # read at cycle 0 is still the verbatim column (the sim_bosses
    # boss_contact_clamp leg re-derives where the clamp BINDS: cycle 4 for
    # base 12, cycle 3 for 13/14 — C-E5, observed 22.4 -> clamped 20.0).
    assert dmg == [2.0, 3.0, 5.0, 6.0, 4.0, 2.0, 5.0, 9.0, 12.0, 10.0, 11.0,
                   13.0, 14.0], \
        "contact dmg column must stay 2/3/5/6/4/2/5/9/12 + 10/11 + 13/14"
    assert all(d < const("MAX_CONTACT_DMG", MAIN) for d in dmg), \
        "the clamp stays VACUOUS at cycle 0 for every base (rev-3 P3-1)"


# ---- drop probabilities from the N-table (N5/N6/N29/N30) -----------------------

def test_drop_probabilities():
    assert re.search(r"randf\(\) < 0\.7", WORLD), "gem drop 70% (N30)"
    assert re.search(r"randf\(\) < 0\.06", WORLD), "coin drop 6% (N30)"
    assert const("HEAL_DROP_CHANCE", WORLD) == 0.015, "Dawnlight roll 1.5% (N5)"
    assert const("HEAL_AMOUNT", WORLD) == 8.0, "heal amount 8 (N6)"
    assert re.search(r"if enemy\.boss or randf\(\) < HEAL_DROP_CHANCE:", WORLD), \
        "boss Dawnlight guaranteed (N29)"


# ---- §i live-FX caps (A4 row: formulas in BOTH count sites) --------------------

def test_ember_cleaver_halo_live_caps():
    # weapons.gd count formulas...
    assert re.search(r"_nearest\(game, 1 \+ int\(\(l - 1\) / 3\)\)", WEAPONS), "ember 1+floor((L-1)/3)"
    assert re.search(r"_nearest\(game, 1 \+ int\(\(l - 1\) / 4\)\)", WEAPONS), "cleaver 1+floor((L-1)/4)"
    assert re.search(r"1 \+ int\(ceil\(w\.level / 3\.0\)\)", WEAPONS), "halo 1+ceil(L/3)"
    # ...and the FX render layer that caps its instances by the same formulas
    assert re.search(r"1 \+ int\(\(_level\(\"ember\"\) - 1\) / 3\)", FX)
    assert re.search(r"1 \+ int\(\(_level\(\"cleaver\"\) - 1\) / 4\)", FX)
    assert const("SPARKS", FX) <= 20.0, "spike ground-burst shards <= 20"
    assert const("FX_DRAWS_MAX", FX) <= 7.0, "total FX draws <= 7 (D§b FX batch)"


def test_ember_is_straight_flight_aim_at_fire():
    # §i P4-1: aimed at the nearest foes AT fire time, then flies straight
    # (vx,vy fixed at append; _step_projectiles integrates straight, no re-aim).
    assert re.search(r"\"vx\": \(t\.x - p\.x\) / d \* BOLT_SPEED", WEAPONS)
    assert re.search(r"b\.x \+= b\.vx \* dt", WEAPONS)
    assert not re.search(r"re-?aim|homing", WEAPONS, re.IGNORECASE), "no homing invented"


# ---- §c attack trigger constants (horde side) ----------------------------------

def test_attack_lunge_squash_constants():
    assert const("ATK_TIME", VIZ) == 0.2, "lunge+squash over 0.2 s"
    assert const("LUNGE_M", VIZ) == 0.24, "engagement lunge 0.24 m"
    lo, hi = const("SQUASH_LO", VIZ), const("SQUASH_HI", VIZ)
    assert (lo, hi) == (0.85, 1.15), "velocity-axis squash FULL RANGE 0.85<->1.15"
    assert round(hi - lo, 4) == 0.30, "attack scale RANGE 0.30 under the ONE convention"
    assert re.search(r"e\.hit_cd > 0\.0 and not e\.get\(\"atk_armed\", false\)", VIZ), \
        "trigger is the RISING EDGE of e.hit_cd (ticked ward/halo only, F-2)"


# ---- §b/§d visible-layer rows shipped with S4 ----------------------------------

def test_iframes_constant_alpha_no_pulse():
    # render.gd:134-138: CONSTANT alpha 0.55 while iframes > 0 — cycle-3
    # wording: it is a constant modulate, no pulse fiction allowed.
    assert re.search(r"_mat\.albedo_color\.a = 0\.55 if p\.iframes > 0\.0 else 1\.0", PAWN)
    assert not re.search(r"sin\(|cos\(", PAWN), "constant alpha — no pulse math"


def test_blob_shadow_one_multimesh_row():
    assert const("BLOB_Y", VIZ) == 0.02, "blob quads at y = 0.02 (D§b)"
    assert re.search(r"func _make_blob\(\)", VIZ)
    assert "_blob_mmim = _make_blob()" in VIZ
    assert "SHADOW_CASTING_SETTING_OFF" in VIZ or "cast_shadow" in VIZ, "no real-time shadows"


def test_hp_bar_billboards_to_the_camera_pitch():
    assert const("BAR_BILLBOARD_DEG", VIZ) == const("PITCH_DEG", RIG), \
        "bar quad normal must match the camera view direction (§a)"
    assert re.search(r"clampf\(e\.hp / e\.max_hp, 0\.0, 1\.0\)", VIZ), "same fill rule"


def test_fx_layer_reads_sim_readonly():
    # the sim stays v1-verbatim: viz_fx only READS the WeaponSystem arrays.
    assert re.search(r"var sim: WeaponSystem", FX)
    assert re.search(r"sim\.bolts|sim\.throws|sim\.arcs", FX)
    assert "world.enemies" not in FX, "FX layer never reads/writes enemy sim state"
    assert re.search(r"SHADOW_CASTING_SETTING_OFF", FX), "all FX cast_shadow OFF (§i)"
