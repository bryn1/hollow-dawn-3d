"""Boss numbers — the Hollow Warden (MC 11107 T-S6, DOD-ACCEPTANCE A5 + §b
rows N1/N4/N18/N29/N31/N42). Same source-text style as the v1 suite: the
client is Godot WASM, so the gate is source-truth. Readings stated where the
brief left them open:

* "spawn t >= 540 exactly once": v1's boolean latch FALSIFIED under M3
  (T-M3s, M3-SPEC §1.3 P1-1 — one latch for one question): the boss +
  miniboss latches folded into the unified per-stage schedule latch
  `schedule_spawned`, read from the ONE stage row. The two pins below were
  REPLACED (not deleted, LEDGER T-M3s): they now judge the seeded
  stages-m3.jsonl dump legs (first-seen times, spawn-once, run-2 re-arm
  through world.reset()) plus the single-spawn-site source count.
  BOSS_AT / MINIBOSS_AT const pins stand untouched.
* "hp 3000" (A5) is the PINNED BASE stat (world.gd:24). The spawn-time hp rides
  the v1-verbatim time ramp `1 + 0.22 * (time / 60)` (world.gd:67) that every
  enemy takes — the boss is deliberately NOT special-cased; the sim dump names
  both numbers (boss_spawn.hp_base 3000.0, boss_spawn.hp the scaled value).
* "if Dawnlight already taken" — read at v1 562e0a1 there is NO such rule: the
  boss drop is unconditional (`if enemy.boss or randf() < HEAL_DROP_CHANCE`,
  world.gd:137) and world.gd is byte-identical here. The tests below pin the
  unconditional rule AND the absence of any taken-guard, so inventing one
  later goes red.
* tri budget (restated by T-S2i/MC 11133): the boss mesh is its batch glb
  (boss-warden, 14849/15000 tris per the PERMANENCE bpy dump — the <= 15000
  gate lives in the S1a art chain, proven there, not here). The former
  CapsuleMesh-placeholder wording was stale after the art swap; the live
  5.33 m height is now gated by the committed probe dump
  (test_art_integration.py), alongside the 5.33 m build-size const here.
"""

import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")


def read(name):
    """Script source with comment text removed — every structural count below
    is a CODE count (v1's suite greps raw text; here the counts would count
    prose, so comments are cut on the way in)."""
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return "".join(line.split("#")[0] + "\n" for line in fh.read().splitlines())


WORLD = read("world.gd")
MAIN = read("main.gd")
RENDER = read("render.gd")
HUD = read("hud_3d.gd")
VIZ = read("horde_viz.gd")
RIG = read("camera_rig.gd")


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


def block(source, start_marker, end_marker):
    start = source.index(start_marker)
    rest = source[start:]
    return rest[: rest.index(end_marker)] if end_marker in rest else rest


# ---- spawn: t >= 540, exactly once -------------------------------------------

def test_boss_spawns_exactly_once_at_540():
    # N1/N4 + A5 "exactly once" — REPLACED pin (T-M3s, see header): the
    # `boss_spawned` boolean folded into the unified schedule latch. The
    # claim moved from source-regex to the seeded dump legs, and the
    # source side now pins the SINGLE parameterized spawn site instead.
    assert const("BOSS_AT", WORLD) == 540.0
    leg = conftest.stages_row("stage1_schedule")
    assert leg["checks"]["warden_first_seen_540"], "warden walks the field at 540.017"
    assert leg["checks"]["warden_spawns_once"], "exactly one warden appearance, whole run"
    assert leg["checks"]["schedule_latch_3"], "latch-first: 3 schedule spawns to t=782"
    rearm = conftest.stages_row("schedule_rearm")
    assert rearm["checks"]["reset_clears_latch"] and \
        rearm["checks"]["second_pass_fires_once"], \
        "world.reset() re-arms the schedule: the NEXT run gets its one Warden"
    assert WORLD.count("_spawn_enemy(b[1], game, view)") == 1, \
        "the schedule loop is the one boss spawn site"
    assert '_spawn_enemy("warden"' not in WORLD, \
        "no literal warden spawn survives beside the schedule (replace-not-add)"


# ---- hp 3000 + the boss flag --------------------------------------------------

def test_boss_hp_3000_and_boss_flag():
    # N18: warden 3000/45/12/0 boss. 3000 is the pinned base hp (see header:
    # the spawn-time hp rides the verbatim time ramp, the boss is not special).
    entry = re.search(
        r"\"warden\":\s*\{\"hp\":\s*([\d.]+),\s*\"spd\":\s*([\d.]+),\s*\"dmg\":\s*([\d.]+),"
        r"\s*\"xp\":\s*([\d.]+).*?\"boss\":\s*(true|false)", WORLD)
    assert entry, "warden ENEMY_TYPES entry missing/wrong shape"
    assert (float(entry.group(1)), float(entry.group(2)), float(entry.group(3)),
            float(entry.group(4)), entry.group(5)) == (3000.0, 45.0, 12.0, 0.0, "true")
    # the spawn dict must carry the flag through, or no boss rule can fire
    assert re.search(r"\"boss\":\s*def\.get\(\"boss\", false\)", WORLD)


# ---- name bar: the A5 literal, EXACT -----------------------------------------

def test_boss_name_bar_text_is_exact():
    assert HUD.count('"THE HOLLOW WARDEN"') == 1, \
        "the pinned A5 name (v1 render.gd:206) must appear exactly once"
    assert re.search(r"const BOSS_NAME := \"THE HOLLOW WARDEN\"", HUD)
    assert re.search(r"\.text = BOSS_NAME", HUD), "the name must be on a live label"


def test_boss_bar_geometry_and_fill_rule_ported():
    # render.gd:194-207 ported: 420x10 frame at y 12 centred on VIEW, INK
    # under EMBER, fill = w * clampf(hp / max_hp, 0, 1), and NO bar at all
    # while no boss exists (v1: boss.is_empty() -> return).
    assert const("BOSS_BAR_W", HUD) == 420.0
    assert const("BOSS_BAR_H", HUD) == 10.0
    assert const("BOSS_BAR_Y", HUD) == 12.0
    bar = block(HUD, "func _update_boss_bar", "func boss_bar_state")
    assert re.search(r"BOSS_BAR_W \* clampf\(boss\.hp / boss\.max_hp, 0\.0, 1\.0\)", bar), \
        "fill must ride v1's clampf(hp/max_hp) rule"
    assert re.search(r"for e in world\.enemies", bar) and re.search(r"if e\.boss", bar), \
        "boss scan must be the v1 loop over world.enemies"
    assert re.search(r"_boss_root\.visible = not boss\.is_empty\(\)", bar), \
        "no boss -> no bar (v1 draw-nothing rule)"
    assert "GameRenderer.INK" in HUD and "GameRenderer.EMBER" in HUD, \
        "bar colours come from the ported v1 palette"
    assert re.search(r"_hud\.world = world", MAIN), "main.gd must wire the boss scan source"


def test_boss_has_exactly_one_hp_readout():
    # v1 render.gd:185-186 excludes the boss from the per-enemy bar; the 3D
    # build mirrors it, so the HUD bar above is the boss's only HP readout.
    assert re.search(r"if not e\.boss and e\.hp < e\.max_hp:", VIZ), \
        "the horde HP-bar MM must skip the boss, mirroring render.gd:185-186"


# ---- drops: guaranteed Dawnlight + 50 gold ------------------------------------

def test_boss_death_gold_50():
    # N31: boss death +50 gold (world.gd:132), inside the single death funnel.
    kill = block(WORLD, "func kill_enemy", "func collect_pickups")
    assert re.search(r"if enemy\.boss:\s*\n\s*game\.gold \+= 50\b", kill), \
        "kill_enemy must add exactly 50 gold for a boss"


def test_dawnlight_guaranteed_on_boss_death_unconditionally():
    # N29: world.gd:137 — the boss branch SHORT-CIRCUITS the 1.5% roll, which
    # IS the guarantee; a normal death still rolls HEAL_DROP_CHANCE.
    kill = block(WORLD, "func kill_enemy", "func collect_pickups")
    assert re.search(r"if enemy\.boss or randf\(\) < HEAL_DROP_CHANCE:\s*\n"
                     r"\s*heals\.append\(\{\"x\": enemy\.x, \"y\": enemy\.y\}\)", kill), \
        "boss death must append a Dawnlight via the verbatim `or` rule"
    assert const("HEAL_DROP_CHANCE", WORLD) == 0.015


def test_no_dawnlight_taken_guard_invents_itself():
    # Stated reading (header): v1 has no "already taken" rule. Any guard that
    # makes the boss drop conditional goes red here.
    kill = block(WORLD, "func kill_enemy", "func collect_pickups")
    for banned in ("heals.size()", "heals.is_empty", "dawnlight_taken", "taken"):
        assert banned not in kill, "boss Dawnlight must stay unconditional: found %r" % banned
    assert kill.count("heals.append") == 1, "one heal-drop site only (the or-rule)"


# ---- size + placeholder + the ONE gait mechanism ------------------------------

def test_boss_build_size_5_33_m():
    # N42 + D§a: boss 128 px over the ground scale S = PX_PER_M = 720/30 =
    # 24 px/m => 5.33 m; the placeholder honours that size already.
    assert const("MODEL_H_BOSS", VIZ) == 5.33
    m = re.search(r"\"boss\":\s*([\d.]+)", block(RENDER, "const SIZES", "\n"))
    assert m and float(m.group(1)) == 128.0
    px_per_m = const("PX_PER_M", RIG)
    assert px_per_m == 24.0
    assert abs(128.0 / px_per_m - const("MODEL_H_BOSS", VIZ)) < 0.01


def test_boss_rides_the_one_gait_mechanism_placeholder_note():
    # D§c/§b: the Warden is ONE per-class MultiMesh instance of the horde
    # mechanism — same mesh path as every class, own freq off its own spd,
    # same e.hit_cd lunge edge. A second boss gait (or a boss branch in the
    # gait math) is the defect this row forbids. T-S2i (MC 11133) retired
    # the two placeholder-era claims below: the S3 CapsuleMesh became the
    # per-class GLB swap (ClassMesh), boss included — the SAME-ness the row
    # pins is untouched, so it now pins THAT instead.
    ready = block(VIZ, "func _ready", "func _process")
    assert re.search(r"MODEL_H_BOSS if def\.get\(\"boss\", false\) else MODEL_H_ENEMY", ready)
    assert re.search(r"_freqs\[key\] = minf\(def\.spd / CameraRig\.PX_PER_M / GAIT_STRIDE_M, GAIT_FREQ_MAX\)", ready), \
        "the boss freq must come from the same spd formula as the horde"
    assert "ClassMesh.mesh_for" in block(VIZ, "func _make_class", "func _make_bar"), \
        "the GLB swap is shared by every class, boss included"
    assert "CapsuleMesh" not in VIZ, "placeholder era retired by MC 11133"
    assert VIZ.count("e.boss") == 2, \
        "the boss may appear in the horde viz ONLY as (1) the bar exclusion and " \
        "(2) the lunge-edge attribution — never as a gait branch"
    # tri-budget note restated by T-S2i: the boss mesh is its batch glb
    # (14849/15000 tris, PERMANENCE bpy dump); the live 5.33 m height gate
    # is the committed probe dump (test_art_integration.py).
    assert "GLB_FILES" in VIZ and "\"warden\": \"boss-warden.glb\"" in VIZ, \
        "the warden class must ride the boss-warden glb"


# ---- T-M1d miniboss schedule + chest drop pins (M1 feature 4) --------------
# The warden pair above STAYS GREEN BY DESIGN (roadmap feature 7 stay-green
# row: BOSS_AT unchanged at 540); these rows pin what the run-length change
# ADDS — never a re-pin of the boss itself.

def test_miniboss_schedule_600_780_exactly_once_each():
    # Roadmap M1 feature 4 verbatim "2 minibosses @ t=600, 780", each once —
    # REPLACED pin (T-M3s): the second latch folded into the SAME unified
    # schedule (P1-1). MINIBOSS_AT stays the doc schedule (const pin reads
    # the source directly); the once-each claim rides the dump legs, which
    # saw knight at 600.017 and deacon at 780.017 inside one latch walk.
    pairs = re.findall(r"\[([\d.]+),\s*\"([\w-]+)\"\]",
                       WORLD[WORLD.index("const MINIBOSS_AT"):
                             WORLD.index("const HEAL_DROP_CHANCE")])
    assert [(float(t), k) for t, k in pairs] == [
        (600.0, "hollow-knight"), (780.0, "hollow-deacon")], \
        "MINIBOSS_AT must be the doc schedule, in order"
    leg = conftest.stages_row("stage1_schedule")
    assert leg["checks"]["knight_first_seen_600"], "knight walks at 600.017"
    assert leg["checks"]["deacon_first_seen_780"], "deacon walks at 780.017"
    assert leg["checks"]["schedule_latch_3"], \
        "one latch, one spawn per row — boss and minibosses share the walk"
    assert "minibosses_spawned" not in WORLD and "boss_spawned" not in WORLD, \
        "the two v1 latches are retired, not kept beside the unified one"


def test_miniboss_enemy_rows():
    # OUR stat rows (the doc names the schedule, not the values) — pinned so
    # any later silent retune goes RED like every other number in this suite.
    types_block = WORLD[WORLD.index("const ENEMY_TYPES"):]
    for key, stats in {"hollow-knight": (900.0, 50.0, 10.0, 0.0),
                       "hollow-deacon": (1400.0, 40.0, 11.0, 0.0)}.items():
        row = re.search(r"\"%s\":\s*\{\"hp\":\s*([\d.]+),\s*\"spd\":\s*([\d.]+),"
                        r"\s*\"dmg\":\s*([\d.]+),\s*\"xp\":\s*([\d.]+)" % key, types_block)
        assert row, "ENEMY_TYPES miniboss row %s missing/wrong shape" % key
        assert (float(row.group(1)), float(row.group(2)),
                float(row.group(3)), float(row.group(4))) == stats
        tail = types_block[row.start(): row.end() + 120]
        assert '"miniboss": true' in tail and '"boss": true' not in tail, \
            "minibosses must field the miniboss flag, NOT the boss flag"


def test_miniboss_flag_wired_into_spawned_enemies():
    spawn = block(WORLD, "func _spawn_enemy", "func update_spawns")
    assert re.search(r"\"miniboss\": def\.get\(\"miniboss\", false\)", spawn), \
        "every spawned enemy dict must carry the miniboss flag (kill funnel reads it)"


def test_chest_drop_chances_pinned_and_wired():
    # M1 feature 4 (DA c1 B-3): named consts in the HEAL_DROP_CHANCE pattern;
    # the boss branch short-circuits its 1.0 roll — the guarantee IS the roll.
    assert const("CHEST_CHANCE_BOSS", WORLD) == 1.0
    assert const("CHEST_CHANCE_MINIBOSS", WORLD) == 0.6
    assert re.search(r"var chests: Array = \[\]", WORLD), "chests array must exist"
    reset = block(WORLD, "func reset", "func _types_open")
    assert re.search(r"chests\.clear\(\)", reset), "chests must reset per run"
    funnel = block(WORLD, "func kill_enemy", "func collect_pickups")
    assert re.search(r"if enemy\.boss and randf\(\) < CHEST_CHANCE_BOSS:\s*\n"
                     r"\s*chests\.append", funnel)
    assert re.search(r"elif enemy\.miniboss and randf\(\) < CHEST_CHANCE_MINIBOSS:\s*\n"
                     r"\s*chests\.append", funnel)
    assert funnel.count("chests.append") == 2, "exactly the two chest drop sites"
