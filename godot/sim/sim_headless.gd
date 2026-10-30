# reason: >400 lines — 402 measured at MC 11398 §1.5 (a row MC 11316's
#   "measured clean" claim MISSED, re-measured at the v2.0.0 tag): ONE
#   harness-runner contract — the scripted journey, the leg gates and the
#   TQ-01 exit law the 5020-row byte corpus rides; splitting the runner
#   would fork the exit contract the corpus depends on.
# Headless core-loop sim (DOD S3 row: "a full sim run (headless, seeded)
# reaches win/gameover"). Instantiates the REAL Main.tscn, starts a run via
# the real _start_game funnel, and drives main.gd's real _step loop manually
# at the fixed 1/60 delta — the fast-forward is call-rate, never dt: every
# v1 time constant stays verbatim, unscaled (reading stated in the card).
# Dumps one JSON line per event: band index at the 149.9/150.1/299.9/300.1/
# 449.9/450.1 samples + every band flip, GATES openings and first spawns per
# type id, scripted WASD input with position samples, the camera rig params
# (A8 row), a gait probe, the gameover row, and the WIN row at t >= WIN_TIME
# (900 s since T-M1d) with the score cross-checked against the formula.
# Stubbed: only the screens
# layer (its cards build Control trees this stage does not carry).
# T-S4 adds the combat rows (MC 11102): per-sample FX-cap rows for t < 300
# (RENDERED live counts vs the §i formulas — per-sample rows, not averages),
# the scene draw-count row (planned 40 / hard 60, §b + M1 re-tally T-M1g), XP/gold progression
# rows, the RUN-CONDITIONED pick rows (own ward or halo by t <= 120 with the
# owning level recorded, A3/D§c F-2), the §c attack pulse counter, and the
# single-weapon kill-attribution legs (SimCombat) proving >= 1 kill per
# weapon class. The journey itself is UNTOUCHED — same seed, same rows.
# T-S6 adds the boss rows (MC 11107): boss_leg / boss_spawn (t ~540.0, base hp
# 3000 on the v1 time ramp, exactly once) / boss_viz (5.33 m instance on the
# ONE gait mechanism + the HUD bar with the pinned name) / boss_lunge /
# boss_kill (in-game gold delta over the kill tick) / boss_once, then
# boss_drops — the +50 gold and the guaranteed Dawnlight read exactly at the
# kill funnel. All from SimBoss legs appended after every S3/S4 row
# (regression rows unchanged).
extends SceneTree

const DT := 1.0 / 60.0
const TOTAL_STEPS := 37200 # 620 sim-seconds journey window; since T-M1d the
	# win sits at WIN_TIME 900 s — out of this window by design: the journey
	# ends gameover and the WIN row comes from the declared-warp leg below
	# plus the real-clock s8 harness (the 620 s window stays byte-identical).
const POLICY_EVERY := 3 # input policy every 0.05 s — 0.5 s quantised
	# reversals are how a 140 px/s survivor gets eaten by a 105 px/s scarab
const POS_EVERY := 600 # 10 s position/stat samples
const FX_EVERY := 30 # 0.5 s FX-cap sample rows while t < FX_WINDOW
const PROG_EVERY := 1800 # 30 s XP/gold progression rows while t < FX_WINDOW
const FX_WINDOW := 300.0 # brief: the dump window proving the caps is t < 300
const DRAWS_PLANNED := 40 # §b planned worst case (M1 re-tally T-M1g)
const DRAWS_HARD := 60 # §b hard cap
const BAND_STEPS := {
	8994: 149.9, 9006: 150.1, 17994: 299.9, 18006: 300.1,
	26994: 449.9, 27006: 450.1,
}
const GAIT_STEPS := [9006, 27006]
const CLASS_COUNT := 9 # non-boss 8 + warden (first_spawn watch closes early)

var _main: Node
var _pol := SimPolicy.new()
var _combat := SimCombat.new()
var _band := ""
var _open_seen := {}
var _spawn_seen := {}
var _boss_dumped := false
var _done := false
var _fail := false
var _ended := false
var _started := false
var _frames := 0
var _out: FileAccess
var _fx_bad := 0 # §i cap violations across every t<300 sample (must stay 0)
var _fx_samples := 0
var _hard_fail := false # S4 gate rows (draws/fx caps/legs) — forces rc != 0
var _journey_failed := false # TQ-01 (MC 11252): the seeded journey never
	# reached its terminal row (timeout) — the win-gate leg's _done must NOT
	# mask it; forces rc != 0 alongside _hard_fail below.
var _rc := {} # RUN-CONDITIONED state (own/level/t once, check at t>120)


# SceneTree-script quit contract: returning true from _process ends the run
# (a bare quit() during _initialize leaves the engine idling at exit-request).
func _process(_delta: float) -> bool:
	_frames += 1
	if not _started:
		_started = true
	# per-leg dump path (S8 scan convention, same shape as HD3D_SEED); the
		# default keeps the S3 dump byte-identical.
		var out := OS.get_environment("HD3D_OUT")
		_out = FileAccess.open(out if out != "" else "/tmp/hd3d-sim-dump.jsonl",
				FileAccess.WRITE)
		if _out == null:
			push_error("sim dump file could not open")
			return true
		_run_sim()
	if _frames > 3 and not (_done or _fail):
		_emit({"ev": "harness_abort", "note": "run did not finish in one frame"})
		_fail = true
	if _done or _fail:
		quit(0 if _done else 3)
		return true
	return false


func _run_sim() -> void:
	# seeded run (DOD S3); HD3D_SEED overrides the default leg per the
	# S2h/S2i per-leg seed convention (T-S8 win-leg seed search).
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else 11101)
	var packed: PackedScene = load("res://Main.tscn")
	_main = packed.instantiate()
	root.add_child(_main) # _ready wires the real 3D scene + bridge
	var old: CanvasLayer = _main._screens
	_main.remove_child(old)
	old.queue_free()
	var stub := SimStubScreens.new()
	_main.add_child(stub)
	_main._screens = stub
	stub.start_pressed.connect(_main._start_game)
	stub.card_picked.connect(_main._pick)
	_main._start_game()
	_pol.main = _main
	var game = _main.game
	game.paused = true # the tree's own tick idles; _step is driven manually
	_dump_camera()
	_dump_draws()
	_emit({"ev": "start", "t": 0.0, "phase": game.phase, "band": 0,
		"name": GameRenderer.biome_at(0.0).name})
	_observe(0)
	for n in range(1, TOTAL_STEPS + 1):
		var game2 = _main.game
		if game2.phase == "levelup":
			_pick_ward()
			continue
		if game2.phase != "playing":
			break
		if n % POLICY_EVERY == 1:
			_hold_combo(_pol.combo())
		_main._handle_presses()
		_main._step(DT)
		_observe(n)
		if _main.game.phase in ["gameover", "win"]:
			_emit_end()
			break
		if _fail:
			break
	if not _done and not _ended:
		_emit({"ev": "timeout", "t": _main.game.time})
		_fail = true
		_journey_failed = true
	_emit({"ev": "fx_caps", "samples": _fx_samples, "violations": _fx_bad})
	_run_win_gate()
	_run_attribution()
	_run_boss()
	_run_sigil()
	_run_boosts()
	if _fx_bad > 0 or _hard_fail or _journey_failed:
		_done = false


# M6 (MC 11675): the Riven Sigil + coin-magnet ACCEPT legs (SD-E2 / SD-E3 /
# MG-E1) run HERE — appended AFTER every S3/S4/S6 + boss row (the forward-lock
# law: no pre-existing row shifts its bytes; the journey rows above move only
# by the declared docs/BYTE-DEVIATION-M6.md §9 rows). The legs live in
# SimCombat (T-M6d-owned; the sim_boss CHEST ROLL LEG pattern per the spec's
# named shape); their ok flags gate rc != 0 exactly like the boss legs.
func _run_sigil() -> void:
	for row in [_combat.sigil_drops_leg(root), _combat.sigil_tapfree_leg(root),
			_combat.sigil_clear_leg(root), _combat.magnet_coins_leg(root)]:
		_emit(row)
		if row.get("ok", false) == false:
			_hard_fail = true


# M6 T-M6p (MC 11697, M6-SPEC §3.6 PS-E2): the boost-MATH formula twins +
# the effect()-identity row, the SAME tail-merge pattern as _run_sigil (the
# lines live in SimCombat — the channel PS-E2 names). Appended after every
# pre-existing row: the forward-lock law holds (only this card's declared
# §9 rows move above; these ten lines are the dump's T-M6p growth).
func _run_boosts() -> void:
	for row in _combat.boost_legs(root):
		_emit(row)
		if row.get("ok", false) == false:
			_hard_fail = true


# T-S6 boss rows (MC 11107, A5): SimBoss legs run AFTER the journey + the S4
# attribution legs, so every S3/S4 determinism row stays byte-identical; the
# legs' declared deviations are documented in sim_boss.gd's header.
func _run_boss() -> void:
	var legs := SimBoss.new()
	for leg in [legs.run_spawn_leg(root), legs.run_kill_leg(root),
			legs.run_funnel_leg(root), legs.run_chest_leg(root),
			legs.run_miniboss_leg(root)]:
		for row in leg:
			_emit(row)
			if row.get("ok", true) == false:
				_hard_fail = true


# WIN-gate leg: no scripted driver survives the 12/s endgame wall, and v1
# itself never lived past 600 s under any driver (its win-screen proof was a
# scratch 45 s export — LEDGER DA F1). This leg restarts through the real
# _start_game funnel, warps the CLOCK (the single stated deviation) to ONE
# SECOND SHORT OF GameState.WIN_TIME (constant-relative since T-M1d: the leg
# never re-encodes the run length) of a fresh sparse world, and ticks the
# real _step loop in: main.gd's own `time >= WIN_TIME` branch fires
# _end_run("win") + score as in a played run.
func _run_win_gate() -> void:
	var packed: PackedScene = load("res://Main.tscn")
	var run2: Node = packed.instantiate()
	root.add_child(run2)
	var stub := SimStubScreens.new()
	run2.add_child(stub)
	run2._screens = stub
	stub.start_pressed.connect(run2._start_game)
	run2._start_game()
	run2.game.time = GameState.WIN_TIME - 1.0
	_main = run2
	for i in range(120):
		if run2.game.phase == "playing":
			run2._step(DT)
			if run2.game.phase == "win":
				_emit_end()
				break
	if not _done:
		_emit({"ev": "win_gate_missed", "t": run2.game.time})
		_fail = true


# Per-weapon kill attribution (brief item 5): one seeded single-weapon leg
# per class; the row names kills + the leg's own t (all legs end < 300 s).
func _run_attribution() -> void:
	var all_ok := true
	var i := 0
	for spec in SimCombat.SPECS:
		seed(41102 + i)
		i += 1
		var row: Dictionary = _combat.run_leg(root, spec[0], spec[1])
		row["ok"] = row.kills >= 1
		if row.kills < 1:
			all_ok = false
		_emit(row)
	_emit({"ev": "all_weapons_killed", "ok": all_ok, "legs": SimCombat.SPECS.size()})
	if not all_ok:
		_hard_fail = true


# §b scene draw tally: ground 1 + horde node (class MMs + bar + blob) +
# pawn 1 + FX worst case (§i 7) + pickups 6 (T-S18 MC 11201: §b's planned
# gems/coins/dawnlight/dawn-glow rows + the M1 chest MM + the M6 F6 RIVEN
# SIGIL MM — docs/BYTE-DEVIATION-M6.md §9 draw row, the §10 re-tally
# pickup 5→6, total 27→28). The renderer issues FEWER calls when a
# class is empty — fx_live rides the FX rows.
func _dump_draws() -> void:
	var horde: int = _main._viz.draw_count()
	var fxw: int = _main._fxv.draw_count()
	var pickups: int = _main._pvz.draw_count()
	var total := 1 + horde + 1 + fxw + pickups
	_emit({"ev": "draws", "ground": 1, "horde": horde, "pawn": 1,
		"fx_worst": fxw, "pickups": pickups, "total": total,
		"planned": DRAWS_PLANNED,
		"hard_cap": DRAWS_HARD, "ok": total <= DRAWS_HARD})
	if total > DRAWS_HARD:
		_hard_fail = true


var _last_combo := ""


func _hold_combo(combo: String) -> void:
	if combo == _last_combo:
		return
	_last_combo = combo
	_main.bridge.on_key("KeyW", combo.contains("W"))
	_main.bridge.on_key("KeyA", combo.contains("A"))
	_main.bridge.on_key("KeyS", combo.contains("S"))
	_main.bridge.on_key("KeyD", combo.contains("D"))
	_emit({"ev": "input", "t": roundi(_main.game.time * 1000.0) / 1000.0,
		"hold": combo})


# Scripted level-up picks: the ranking lives in SimPolicy.pick_index
# (T-S8: shared with the real-clock sim_s8.gd legs), the row stays here.
func _pick_ward() -> void:
	var idx: int = _pol.pick_index(_main)
	_emit({"ev": "pick", "t": roundi(_main.game.time * 1000.0) / 1000.0,
		"card": _main._current_offer[idx].name,
		"level": _main.game.level})
	_main._pick(idx)


func _observe(n: int) -> void:
	var game = _main.game
	var t: float = game.time
	var band_name: String = GameRenderer.biome_at(t).name
	var band := 0
	for i in GameRenderer.BIOMES.size():
		if GameRenderer.BIOMES[i].name == band_name:
			band = i
	if band_name != _band:
		_emit({"ev": "band_flip", "t": roundi(t * 1000.0) / 1000.0,
			"from": _band, "to": band_name, "band": band})
		_band = band_name
	if BAND_STEPS.has(n):
		_emit({"ev": "band_sample", "t": BAND_STEPS[n], "t_sim": t,
			"band": band, "name": band_name})
	if n in GAIT_STEPS:
		_main._viz.refresh()
		_emit({"ev": "gait", "t": roundi(t * 1000.0) / 1000.0,
			"probe": _main._viz.gait_probe()})
	for key in _main.world._types_open(game.stage, t): # M3 T-M3s: stage-keyed
		# band read (journey runs stage 1 — the shipped walk, rows unchanged)
		if not _open_seen.has(key):
			_open_seen[key] = true
			_emit({"ev": "type_open", "t": roundi(t * 1000.0) / 1000.0,
				"type": key, "source": "gate" if _is_gate(key) else "band"})
	if _spawn_seen.size() < CLASS_COUNT:
		for e in _main.world.enemies:
			if not _spawn_seen.has(e.type):
				_spawn_seen[e.type] = true
				_emit({"ev": "first_spawn", "t": roundi(t * 1000.0) / 1000.0,
					"type": e.type, "enemies": _main.world.enemies.size()})
	if n % POS_EVERY == 0:
		var p: Dictionary = game.player
		_emit({"ev": "pos", "t": roundi(t * 100.0) / 100.0,
			"x": roundi(p.x * 10.0) / 10.0, "y": roundi(p.y * 10.0) / 10.0,
			"hp": roundi(game.hp * 10.0) / 10.0, "lvl": game.level,
			"xp": roundi(game.xp * 10.0) / 10.0,
			"wpns": _build_line(game),
			"kills": game.kills, "gold": game.gold,
			"enemies": _main.world.enemies.size()})
	# M3 T-M3s: the warden IS the stage-1 schedule's first row — the latch
	# index >= 1 replaces the retired boss_spawned bool (rows unchanged).
	if _main.world.schedule_spawned >= 1 and not _boss_dumped:
		_boss_dumped = true
		for e in _main.world.enemies:
			if e.boss:
				_emit({"ev": "boss", "t": roundi(t * 1000.0) / 1000.0,
					"hp": e.hp, "spd": e.spd, "dmg": e.dmg})
	_observe_combat(n)


# T-S4 combat rows (all inside the t < 300 dump window unless named): the
# per-sample FX-cap rows, XP/gold progression, and the RUN-CONDITIONED
# pick rows (own ward or halo by t <= 120 with the owning level recorded).
func _observe_combat(n: int) -> void:
	var game = _main.game
	var t: float = game.time
	if t < FX_WINDOW and n % FX_EVERY == 0:
		# force one visible-layer write, then compare the RENDERED live
		# counts against the §i caps — every sample, per-sample rows.
		_main._viz.refresh()
		_main._fxv.refresh()
		var c: Dictionary = _main._fxv.fx_counts()
		var v := SimCombat.cap_violations(game, c)
		_fx_samples += 1
		_emit({"ev": "fx", "t": roundi(t * 1000.0) / 1000.0, "c": c,
			"caps": SimCombat.caps(game), "halo_cap": SimCombat.HALO_MAX,
			"shards_cap": SimCombat.SHARDS_MAX,
			"pulses": _main._viz.attack_pulses,
			"live_draws": _main._fxv.live_draws(), "violations": v.size()})
		if not v.is_empty():
			_fx_bad += v.size()
			_emit({"ev": "fx_violation", "t": roundi(t * 1000.0) / 1000.0,
				"detail": v})
	if t < FX_WINDOW and n % PROG_EVERY == 0:
		_emit({"ev": "progress", "t": roundi(t * 100.0) / 100.0,
			"xp": roundi(game.xp * 10.0) / 10.0,
			"xp_next": GameState.xp_need(game.level), "lvl": game.level,
			"gold": game.gold, "kills": game.kills,
			"hp": roundi(game.hp * 10.0) / 10.0,
			"wpns": _build_line(game)})
	if not _rc.has("own") and t <= 120.0:
		# RUN-CONDITIONED precondition (A3/D§c F-2): scripted picks must
		# own Ward or Halo by t <= 120 — record the OWNING LEVEL here.
		for w in game.weapons:
			if w.id == "ward" or w.id == "halo":
				_rc = {"own": w.id, "level": w.level,
					"t": roundi(t * 1000.0) / 1000.0}
				_emit({"ev": "run_conditioned", "own": w.id, "level": w.level,
					"t": _rc.t, "pulses": _main._viz.attack_pulses})
				break
	if not _rc.has("check") and t > 120.0:
		_rc["check"] = true
		var lvl := 0
		for w in game.weapons:
			if w.id == _rc.get("own", ""):
				lvl = w.level
		_emit({"ev": "run_conditioned_check", "t": roundi(t * 1000.0) / 1000.0,
			"own": _rc.get("own", ""), "level": lvl, "t_owned": _rc.get("t", -1.0),
			"edges_to_120": _main._viz.attack_pulses,
			"ok": _rc.has("own") and float(_rc.get("t", 1e9)) <= 120.0})


func _build_line(game) -> String:
	var parts: Array = [] # "talon-2 ember-1 ward-3 ..." build snapshot
	for w in game.weapons:
		parts.append(str(w.id) + "-" + str(w.level))
	for k in game.passives:
		if game.passives[k] > 0:
			parts.append(str(k) + "-" + str(game.passives[k]))
	return " ".join(parts)


func _is_gate(key: String) -> bool:
	for gate in GameWorld.GATES:
		if gate[1] == key:
			return true
	return false


func _emit_end() -> void:
	var game = _main.game
	var row := {"ev": game.phase, "t": roundi(game.time * 1000.0) / 1000.0,
		"phase": game.phase, "time": game.stats.time, "kills": game.stats.kills,
		"level": game.stats.level, "gold": game.stats.gold,
		"score": _main._score(game.stats)}
	if game.phase == "win":
		var expected: int = roundi(game.stats.time * 10.0 + game.stats.kills * 5.0
			+ game.stats.level * 25.0 + game.stats.gold)
		row["score_formula_check"] = expected == _main._score(game.stats)
		_done = true
	else:
		_fail = true
	_ended = true
	_emit(row)


func _dump_camera() -> void:
	var cam: Camera3D = _main._rig.get_child(0)
	_emit({"ev": "camera",
		"projection": "PROJECTION_ORTHOGONAL" if cam.projection == Camera3D.PROJECTION_ORTHOGONAL else str(cam.projection),
		"size": cam.size, "near": cam.near, "far": cam.far,
		"offset": [cam.position.x, cam.position.y, cam.position.z],
		"pitch_deg_off_straight_down": roundf((-cam.rotation_degrees.x - 90.0) * 10.0) / 10.0})


func _emit(row: Dictionary) -> void:
	_out.store_line(JSON.stringify(row))
	_out.flush() # live progress readable while the engine runs
