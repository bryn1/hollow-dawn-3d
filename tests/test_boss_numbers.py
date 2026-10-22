"""Boss numbers — the Hollow Warden (MC 11107 T-S6, DOD-ACCEPTANCE A5 + §b
rows N1/N4/N18/N29/N31/N42). Same source-text style as the v1 suite: the
client is Godot WASM, so the gate is source-truth. Readings stated where the
brief left them open:

* "spawn t >= 540 exactly once": v1's mechanism is the `boss_spawned` latch in
  GameWorld.update_spawns (world.gd:84-86); this file pins the latch, the
  comparison and the reset, so a re-armed run still spawns one Warden.
* "hp 3000" (A5) is the PINNED BASE stat (world.gd:24). The spawn-time hp rides
  the v1-verbatim time ramp `1 + 0.22 * (time / 60)` (world.gd:67) that every
  enemy takes — the boss is deliberately NOT special-cased; the sim dump names
  both numbers (boss_spawn.hp_base 3000.0, boss_spawn.hp the scaled value).
* "if Dawnlight already taken" — read at v1 562e0a1 there is NO such rule: the
  boss drop is unconditional (`if enemy.boss or randf() < HEAL_DROP_CHANCE`,
  world.gd:137) and world.gd is byte-identical here. The tests below pin the
  unconditional rule AND the absence of any taken-guard, so inventing one
  later goes red.
* tri budget: the boss placeholder is the same CapsuleMesh the whole horde
  uses (no GLB yet); the <= 15000-tri gate (DOD-ACCEPTANCE c row boss-warden)
  belongs to the S1/S2 art chain and is proven by the bpy dump, not here —
  this file pins the 5.33 m build size that placeholder already honours.
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
    # N1/N4 + the A5 "exactly once": the clock comparison rides BOSS_AT and
    # the boss_spawned latch, and nothing else may append a warden.
    assert const("BOSS_AT", WORLD) == 540.0
    assert re.search(r"var boss_spawned := false", WORLD), "latch must exist"
    gate = block(WORLD, "func update_spawns", "func update_entities")
    assert re.search(r"if not boss_spawned and game\.time >= BOSS_AT:", gate), \
        "boss gate must be the v1 latch: not boss_spawned and time >= BOSS_AT"
    assert re.search(r"boss_spawned = true\s*\n\s*_spawn_enemy\(\"warden\", game, view\)", gate), \
        "the latch must be set before the single warden spawn, verbatim v1 order"
    assert gate.count("_spawn_enemy(\"warden\"") == 1, "one spawn site only"
    assert WORLD.count("_spawn_enemy(\"warden\"") == 1, "no other warden spawn anywhere"
    assert re.search(r"boss_spawned = false", block(WORLD, "func reset", "func _types_open")), \
        "reset() re-arms the latch so the NEXT run gets its one Warden"


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
    # mechanism — same CapsuleMesh placeholder as every class, own freq off
    # its own spd, same e.hit_cd lunge edge. A second boss gait (or a boss
    # branch in the gait math) is the defect this row forbids.
    ready = block(VIZ, "func _ready", "func _process")
    assert re.search(r"MODEL_H_BOSS if def\.get\(\"boss\", false\) else MODEL_H_ENEMY", ready)
    assert re.search(r"_freqs\[key\] = minf\(def\.spd / CameraRig\.PX_PER_M / GAIT_STRIDE_M, GAIT_FREQ_MAX\)", ready), \
        "the boss freq must come from the same spd formula as the horde"
    assert "CapsuleMesh" in block(VIZ, "func _make_class", "func _make_bar"), \
        "placeholder capsule is shared by every class, boss included"
    assert VIZ.count("e.boss") == 2, \
        "the boss may appear in the horde viz ONLY as (1) the bar exclusion and " \
        "(2) the lunge-edge attribution — never as a gait branch"
    # tri-budget placeholder note: no GLB, so no tri claim here; the <= 15000
    # gate is the S1/S2 bpy dump (DOD-ACCEPTANCE c, boss-warden row).
    assert "assets/glb" not in VIZ, "no GLB path yet: this stage is placeholder by design"
