# Boss legs for sim_headless.gd (MC 11107 T-S6, DOD-ACCEPTANCE A5). Every leg
# runs through the REAL _start_game funnel and the REAL main.gd _step loop.
# Deviations are declared per leg — the sim code itself is never touched.
# (1) SPAWN LEG — one deviation, the CLOCK WARP (the same reading the S3 WIN
#     row carries: "warps the CLOCK (the single stated deviation)"): a fresh
#     sparse run is warped to 539.0 s and ticked in, so world.gd's own gate
#     `if not boss_spawned and game.time >= BOSS_AT` fires in real play. Rows:
#     boss_spawn (t ~540.0, exactly once, base hp 3000 = world.gd:24 scaled by
#     the v1-verbatim time ramp world.gd:67 — the boss is NOT special-cased)
#     and boss_viz: the warden MultiMesh instance count 1 + the class's scale
#     channels + freq off the ONE horde gait mechanism (DESIGN-3D §c) and the
#     HUD boss bar with the A5-pinned name (hud_3d.gd, render.gd:194-207
#     port). Scale channels are read through HordeViz.gait_probe() — the same
#     evidence mechanism the S3/S4 gait rows use (MultiMesh transform writes
#     do not read back under the headless renderer; instance_count does).
# (2) KILL LEG — declared deviations: the clock warp, a pinned all-six-L8
#     build (the SimCombat pinning pattern) and hp pinned to max each tick,
#     because no scripted driver survives the 12/s endgame wall (the S3
#     journey died at t = 467.1). The Warden walks in and dies to REAL weapon
#     damage through weapons.gd _hit -> world.kill_enemy. boss_lunge names
#     the §c attack pulses attributed to the boss (horde_viz boss_pulses: the
#     SAME e.hit_cd rising edge as the horde; ward L8 is the ticked source,
#     F-2) together with the scale channels at that tick — the squash band
#     0.85<->1.15 sits OUTSIDE the walk band 1.00<->1.24. boss_kill carries the
#     in-game gold delta over the kill tick (>= 50: the boss bonus plus any
#     same-tick coin pickup). A window past the kill proves exactly-once: no
#     second Warden spawns.
# (3) FUNNEL LEG — the drop rule read EXACTLY, with no collect step in the
#     way: the boss is spawned by the real gate, then world.kill_enemy — the
#     single death funnel every weapon already routes through (weapons.gd:99
#     is its only caller) — is called directly. gold +50 verbatim (world.gd:
#     132), exactly one Dawnlight appended AT THE BOSS POSITION (world.gd:137
#     `if enemy.boss or randf() < HEAL_DROP_CHANCE` — the boss branch
#     short-circuits the roll, which IS the guarantee), zero gems (boss xp 0).
#     v1 has no "already taken" rule for the Dawnlight: read at 562e0a1, the
#     boss drop is unconditional and world.gd stays verbatim here. Under real
#     play the boss dies at the survivor's feet and the same tick's
#     collect_pickups consumes the heal instantly (world.gd:158, consumed even
#     at full hp), which is why the rule needs this direct read.
# (4) CHEST ROLL LEG (T-M1d, roadmap M1 feature 4 "kill-leg roll rows",
#     DA c1 B-3): the same declared deviations as the funnel leg (clock warp,
#     direct kill_enemy). The Warden is killed once through the funnel:
#     CHEST_CHANCE_BOSS = 1.0 short-circuits the roll — exactly ONE chest.
#     The miniboss row kills synthetic hollow-knight-shaped dicts (real
#     flag shape, xp 0) under the pinned seed; the drop count is a ROLL ROW
#     (evidence), the pin lives in the consts + the pytest suite.
class_name SimBoss
extends RefCounted

const DT := 1.0 / 60.0
const WARP_T := 539.0 # clock warp: BOSS_AT is 540.0 (declared deviation)
const SPAWN_STEPS := 240 # 4 s — the gate fires within 60 steps of the warp
const KILL_STEPS := 3000 # 50 s; the kill lands well below t = WIN_TIME
const AFTER_KILL_STEPS := 240 # exactly-once re-check window past the kill
const POS_EPS := 0.001 # drop-position match: kill_enemy stores the exact pos


# (1) Spawn + visible-layer identity of the boss.
func run_spawn_leg(root: Window) -> Array:
	seed(41107)
	var run := _fresh_run(root)
	run.game.time = WARP_T
	var rows: Array = [{"ev": "boss_leg", "leg": "spawn", "warp_to": WARP_T,
		"note": "clock-warp leg — the single stated deviation (S3 WIN-row reading)"}]
	var boss := _spawn_boss(run, SPAWN_STEPS, rows)
	if boss.is_empty():
		run.queue_free()
		return rows
	run._viz.refresh() # one forced visible-layer write (S3/S4 pattern)
	run._hud.update(DT) # one HUD tick: the tree's own _process idles here
	var probe: Dictionary = run._viz.gait_probe().warden
	rows.append({"ev": "boss_spawn", "t": _r3(run.game.time), "type": boss.type,
		"hp": boss.hp, "max_hp": boss.max_hp,
		"hp_base": GameWorld.ENEMY_TYPES.warden.hp,
		"hp_scale_formula": "1 + 0.22 * (time / 60) — world.gd:67, v1 verbatim",
		"spd": boss.spd, "dmg": boss.dmg, "xp": boss.xp, "boss": boss.boss,
		"bosses_alive": _count_wardens(run),
		"spawned_flag": run.world.boss_spawned})
	rows.append({"ev": "boss_viz", "t": _r3(run.game.time),
		"instances": run._viz._mms.warden.multimesh.instance_count,
		"model_h_m": HordeViz.MODEL_H_BOSS, "size_px": GameRenderer.SIZES.boss,
		"gait_freq_hz": probe.freq, "gait_range": probe.range,
		"scale_last": probe.last, "bar": run._hud.boss_bar_state()})
	run.queue_free()
	return rows


# (2) Real-damage kill + the boss's §c lunge edges + the exactly-once window.
func run_kill_leg(root: Window) -> Array:
	seed(41108)
	var run := _fresh_run(root)
	run.game.time = WARP_T
	_pin_full_build(run)
	var rows: Array = [{"ev": "boss_leg", "leg": "kill", "warp_to": WARP_T,
		"build": "all six weapons at L8 (pinned, SimCombat pattern)",
		"hp_pinned_to_max": true,
		"note": "no driver survives the 12/s wall (S3 journey died t=467.1)"}]
	var pulses_done := false
	var kill_row: Dictionary = {}
	for n in KILL_STEPS:
		_decline(run)
		if run.game.phase != "playing":
			break
		var boss: Dictionary = _boss(run)
		var alive_before := not boss.is_empty()
		var gold0: int = run.game.gold
		run.game.hp = run.game.max_hp # DECLARED: the leg outlives the wall
		if alive_before and not pulses_done:
			run._viz.refresh() # drive the §c edge mechanism while it matters
			if run._viz.boss_pulses > 0:
				pulses_done = true
				var p: Dictionary = run._viz.gait_probe().warden
				rows.append({"ev": "boss_lunge", "t": _r3(run.game.time),
					"boss_pulses": run._viz.boss_pulses,
					"attack_pulses": run._viz.attack_pulses,
					"trigger": "e.hit_cd rising edge — ward L8 ticked hits (F-2)",
					"lunge_m": HordeViz.LUNGE_M, "atk_time_s": HordeViz.ATK_TIME,
					"squash_band": [HordeViz.SQUASH_LO, HordeViz.SQUASH_HI],
					"walk_band": p.range, "scale_at_edge": p.last,
					"outside_walk_band": not _in_band(p.last, p.range)})
		run._step(DT)
		if alive_before and _boss(run).is_empty():
			kill_row = {"ev": "boss_kill", "t": _r3(run.game.time),
				"gold_delta": run.game.gold - gold0, "gold_bonus_min": 50,
				"bosses_after": _count_wardens(run),
				"kills": run.game.kills, "level": run.game.level,
				"boss_pulses_observed": run._viz.boss_pulses,
				"pulse_watch": "refresh stops after the first boss edge: the counter freezes at the evidence, it is not a rate",
				"ok": run.game.gold - gold0 >= 50 and _count_wardens(run) == 0}
			break
	if kill_row.is_empty():
		rows.append({"ev": "boss_kill_missing", "t": _r3(run.game.time),
			"ok": false})
		run.queue_free()
		return rows
	rows.append(kill_row)
	var max_after := 0
	for n in AFTER_KILL_STEPS:
		_decline(run)
		if run.game.phase != "playing":
			break
		run.game.hp = run.game.max_hp
		run._step(DT)
		max_after = maxi(max_after, _count_wardens(run))
	rows.append({"ev": "boss_once", "t": _r3(run.game.time),
		"boss_spawned_flag": run.world.boss_spawned,
		"wardens_alive_after_kill": max_after, "hp": run.game.hp,
		"ok": max_after == 0 and run.world.boss_spawned})
	run.queue_free()
	return rows


# (3) The drop rule, read at the single death funnel with no collect step in
# between: +50 gold and exactly one guaranteed Dawnlight at the boss pos.
func run_funnel_leg(root: Window) -> Array:
	seed(41109)
	var run := _fresh_run(root)
	run.game.time = WARP_T
	var rows: Array = [{"ev": "boss_leg", "leg": "funnel", "warp_to": WARP_T,
		"note": "world.kill_enemy called directly — the funnel weapons.gd:99 uses"}]
	var boss := _spawn_boss(run, SPAWN_STEPS, rows)
	if boss.is_empty():
		run.queue_free()
		return rows
	var gold0: int = run.game.gold
	var heals0: int = run.world.heals.size()
	var gems0: int = run.world.gems.size()
	run.world.kill_enemy(run.game, boss)
	var heal_at_boss := 0
	for h in run.world.heals:
		if absf(h.x - boss.x) < POS_EPS and absf(h.y - boss.y) < POS_EPS:
			heal_at_boss += 1
	var gold_delta: int = run.game.gold - gold0
	var heal_delta: int = run.world.heals.size() - heals0
	var gem_delta: int = run.world.gems.size() - gems0
	rows.append({"ev": "boss_drops", "t": _r3(run.game.time),
		"gold_delta": gold_delta, "gold_bonus": 50, "dawnlight_drops": heal_delta,
		"dawnlight_at_boss": heal_at_boss, "gem_drops": gem_delta,
		"coins_dropped": run.world.coins.size(),
		"bosses_after": _count_wardens(run),
		"rule": "world.gd:132 gold+=50; world.gd:137 if enemy.boss or roll -> Dawnlight",
		"ok": gold_delta == 50 and heal_delta == 1 and heal_at_boss == 1
			and gem_delta == 0 and _count_wardens(run) == 0})
	run.queue_free()
	return rows


# (4) CHEST ROLL LEG — see header. Deviations: clock warp + direct kill_enemy.
func run_chest_leg(root: Window) -> Array:
	seed(41110)
	var run := _fresh_run(root)
	run.game.time = WARP_T
	var rows: Array = [{"ev": "boss_leg", "leg": "chest", "warp_to": WARP_T,
		"note": "roll counts are evidence under the pinned seed; the consts are the pin"}]
	var boss := _spawn_boss(run, SPAWN_STEPS, rows)
	if boss.is_empty():
		run.queue_free()
		return rows
	run.world.kill_enemy(run.game, boss)
	var boss_chests: int = run.world.chests.size()
	var mb_kills := 200
	for i in mb_kills: # synthetic hollow-knight-shaped kills (world.gd flag shape)
		run.world.kill_enemy(run.game, {
			"x": 0.0, "y": 0.0, "xp": 0.0, "boss": false, "miniboss": true})
	var mb_chests: int = run.world.chests.size() - boss_chests
	rows.append({"ev": "chest_drops", "t": _r3(run.game.time), "seed": 41110,
		"boss_chance": GameWorld.CHEST_CHANCE_BOSS, "boss_kills": 1,
		"boss_chests": boss_chests,
		"miniboss_chance": GameWorld.CHEST_CHANCE_MINIBOSS,
		"miniboss_kills": mb_kills, "miniboss_chests": mb_chests,
		"ok": boss_chests == 1 and mb_chests > 0 and mb_chests < mb_kills})
	run.queue_free()
	return rows


# (5) MINIBOSS SCHEDULE LEG (T-M1d, roadmap M1 feature 4 "2 minibosses @
# t=600, 780"): the REAL gates fire. Declared deviations: clock warp to just
# before the first gate + game.hp pinned each tick (the S6 kill-leg precedent
# — no scripted driver survives a 12/s wall at 3x hp; the CLOCK is never
# touched beyond the warp). Rows: first-seen sim-time per schedule id +
# alive counts in a window past the second gate. Exactly-once is pinned in
# the suite (latch order + single spawn site); these rows prove the schedule
# fires on the declared clock.
func run_miniboss_leg(root: Window) -> Array:
	seed(41111)
	var run := _fresh_run(root)
	run.game.time = 599.0
	var rows: Array = [{"ev": "boss_leg", "leg": "miniboss", "warp_to": 599.0,
		"note": "hp pinned each tick (S6 precedent); real MINIBOSS_AT gates fire"}]
	var first := {}
	for n in 12000:
		_decline(run)
		if run.game.phase != "playing":
			break
		run.game.hp = run.game.max_hp # DECLARED deviation, S6 kill-leg precedent
		run._step(DT)
		for e in run.world.enemies:
			if e.miniboss and not first.has(e.type):
				first[e.type] = _r3(run.game.time)
		if run.game.time >= 785.0:
			break
	var alive := {"hollow-knight": 0, "hollow-deacon": 0}
	for e in run.world.enemies:
		if alive.has(e.type):
			alive[e.type] += 1
	rows.append({"ev": "miniboss_spawn", "t": _r3(run.game.time),
		"first_hollow_knight": first.get("hollow-knight", -1.0),
		"first_hollow_deacon": first.get("hollow-deacon", -1.0),
		"alive_knight": alive["hollow-knight"], "alive_deacon": alive["hollow-deacon"],
		"ok": first.get("hollow-knight", 0.0) >= 600.0
			and first.get("hollow-knight", 10000.0) < 602.0
			and first.get("hollow-deacon", 0.0) >= 780.0
			and first.get("hollow-deacon", 10000.0) < 782.0})
	run.queue_free()
	return rows


# --- shared helpers -----------------------------------------------------------

# Tick the real _step loop until the gate's boss shows up; rows stay empty
# unless the gate never fires (the harness hard-fails on that).
func _spawn_boss(run: Node, steps: int, rows: Array) -> Dictionary:
	var boss: Dictionary = {}
	for n in steps:
		_decline(run)
		if run.game.phase != "playing":
			break
		run._step(DT)
		boss = _boss(run)
		if not boss.is_empty():
			return boss
	rows.append({"ev": "boss_spawn_missing", "t": _r3(run.game.time),
		"ok": false})
	return {}


func _fresh_run(root: Window) -> Node:
	var run: Node = load("res://Main.tscn").instantiate()
	root.add_child(run)
	var stub := SimStubScreens.new()
	run.add_child(stub)
	run._screens = stub
	stub.start_pressed.connect(run._start_game)
	run._start_game()
	return run


func _pin_full_build(run: Node) -> void:
	var build: Array = []
	for id in WeaponSystem.IDS:
		build.append({"id": id, "level": 8, "cd": 0.0})
	run.game.weapons = build # DECLARED pin (SimCombat pattern): kill 3000 hp


func _decline(run: Node) -> void:
	if run.game.phase == "levelup":
		run.game.pending_levels = 0
		run.game.set_phase("playing") # decline: keep the pinned build pure


func _boss(run: Node) -> Dictionary:
	for e in run.world.enemies:
		if e.boss:
			return e
	return {}


func _count_wardens(run: Node) -> int:
	var n := 0
	for e in run.world.enemies:
		if e.type == "warden":
			n += 1
	return n


func _in_band(last: Dictionary, band: Array) -> bool:
	return last.s >= band[0] - POS_EPS and last.s <= band[1] + POS_EPS \
		and last.d >= band[0] - POS_EPS and last.d <= band[1] + POS_EPS


func _r3(v: float) -> float:
	return roundi(v * 1000.0) / 1000.0
