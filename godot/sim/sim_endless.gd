# ENDLESS legs for M2 pillar A (MC 11237, T-M2e; M2-SPEC rev-2 §A.4 ACCEPT
# rows A-E1..A-E8). Same headless funnel as sim_evolve/sim_budget: the REAL
# Main.tscn, screens stubbed (SimStubScreens), every run started through the
# real _start_game. Construction channel: the DECLARED-PIN pattern
# (sim_boss/sim_budget precedent — flag row + clock/cycle pins; the hp-pin
# survival deviation is the s8 HD3D_HP_PIN / sim_boss kill-leg precedent,
# named per row, never hidden). Seed-pinned (HD3D_SEED, default 11237) so
# the dump is byte-stable; the committed copy
# tests/fixtures/endless-m2.jsonl gates tests/test_endless.py. Per-leg dump
# env HD3D_ENDLESS_DUMP (rev-2 P4-3: HD3D_OUT stays sim_s8's own name — no
# shared name, no new capture mechanism). DawnWell save wiped at start
# (save.gd's own reset verb) + pytest/capture run under a throwaway
# XDG_DATA_HOME (save_probe isolation), so best_cycle rows read a clean well.
# ROWS (row-id -> the ACCEPT row it pins):
#   endless_reach2 + cycle_clear x2   A-E1 + A-E8: endless hand-in ON, hp
#       PINNED per tick (declared, the s8 win-leg deviation verbatim — the
#       s8 header records seeds dying at t 375..467 under the 12/s wall;
#       this is a SCRIPTED-DRIVER SURVIVAL ARTIFACT, not a balance claim,
#       §A.1 rev-2 P2-3), offers declined (sim_budget pattern) -> the real
#       _step crosses t=900 and t=1800, the latched branch cycle-CLEARS
#       (dump cycle_clear rows, phase never win/gameover), best_cycle=2
#       lands on DISK through the one _meta_changed funnel.
#   endless_bestcycle                 A-E5: DECLARED cycle pin 3 -> real
#       gameover -> disk 3; then pin 1 -> gameover -> disk STAYS 3 (never
#       decreases). Older-save -> 0 is save_probe's migrate leg.
#   endless_cycle_clear_reward        A-E4: real _step over the boundary
#       (clock warp to WIN_TIME - dt, the stated sim_headless win-gate
#       reading): pending_levels +1 AND the clear's drop rides the single
#       drop array with tier == CHEST_TIER_BY_SOURCE["endless-cycle"]
#       (dawn / III — the SAME map row B-T1 asserts, rev-2 P1).
#   endless_caps_cycle5               A-E3: DECLARED-PIN scaling-EVAL (NOT a
#       survival leg): cycle counter + clock pinned at cycle 5, m_c 13.0 —
#       the binding point (HP_CYC(5)=4.75 x (1+0.22*13) = 18.335 > 18). The
#       HP clamp binds on a real _spawn_enemy (observed hp == def.hp*18,
#       raw product above it); the CONTACT clamp binds on the boss class in
#       main.gd's own pipeline (warden 12 x DMG_CYC(5)=2.0 = 24 -> observed
#       hp delta 20 == MAX_CONTACT_DMG). Drop either clamp -> RED.
#   endless_scaling x3 + clamp_eval   A-E2: k=1,2,3 at m_c 15.0 (cycle-end
#       worst product): hp-mult/qty-mult/dmg-mult read at the ONE seams
#       (world statics are what the spawn/contact lines call; hp row comes
#       from a real _spawn_enemy, no new RNG); clamp_eval shows the 18x
#       bound NOT falsely firing at cycle 4 (max 17.2 < 18, rev-2 P2-2) —
#       the clamp-binding RED is the planted low cap (HP_EFFECTIVE_MULT_CAP
#       := 6): the k=3 row then observes 6x45 != 13.975x45 -> ok false.
#   endless_off_win                   A-E1 red leg + A-E6: flag OFF, warp to
#       WIN_TIME - dt, real _step -> the t>=WIN_TIME path ends kind "win"
#       (RED if an endless branch leaked into the flag-off path).
#   snapshot_keys                     A-E6: the Contract B snapshot is the
#       exact frozen 12-field shape — cycle/endless ABSENT (F-3).
extends SceneTree

const DT := 1.0 / 60.0
const SEED_DEFAULT := 11237
const STEPS_MAX := 126000 # ~2100 sim-s: two cycle boundaries + settle buffer
const M_C_END := 15.0 # cycle-end minute (900 s / 60) — the worst per-cycle
	# product the spec's own bound arithmetic uses (1+0.22*15 = 4.3)
const M_C_BIND := 13.0 # cycle-5 binding point (spec §A.1: m_c >= 12.7)
const BASE_ID := "pale-wight" # hardest normal row (hp 45, dmg 9)
const BOSS_ID := "warden" # max base contact dmg 12 (world.gd)

var _rows: Array = []
var _started := false
var _frames := 0
var _ok := true


func _out_path() -> String:
	var d: String = OS.get_environment("HD3D_ENDLESS_DUMP")
	return d if d != "" else "/tmp/hd3d-endless-m2.jsonl"


func _process(_delta: float) -> bool:
	_frames += 1
	if not _started:
		_started = true
		print("ENDLESS_START")
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else SEED_DEFAULT)
		DawnWell.new().reset() # clean well (save.gd's own reset verb)
		_run_legs()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		assert(f != null)
		for r in _rows:
			f.store_line(JSON.stringify(r))
		f.close()
		print("ENDLESS_OK rows=%d ok=%s" % [_rows.size(), str(_ok)])
		quit(0 if _ok else 3)
	return false


# --- channel helpers (sim_budget/sim_evolve patterns verbatim) ---------------

func _fresh_run(flag_on: bool) -> Node:
	var run: Node = load("res://Main.tscn").instantiate()
	root.add_child(run)
	var stub := SimStubScreens.new()
	run.add_child(stub)
	run._screens = stub
	stub.start_pressed.connect(run._start_game)
	stub.card_picked.connect(run._pick)
	if flag_on: # DECLARED: the endless hand-in rides the ONE seam — the
		# save flag main._start_game consumes (meta_ranks pattern), pinned.
		run._dawnwell.flags["endless"] = 1
	run._start_game()
	return run


func _decline(run: Node) -> void:
	if run.game.phase == "levelup":
		run.game.pending_levels = 0
		run.game.set_phase("playing") # keep the leg deterministic (budget)


func _disk_best_cycle() -> int:
	var f := FileAccess.open("user://dawnwell.json", FileAccess.READ)
	if f == null:
		return -1
	var data: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(data) != TYPE_DICTIONARY:
		return -1
	return int(data.get("best_cycle", -1))


func _check(leg: String, checks: Dictionary, extra: Dictionary) -> void:
	var leg_ok := true
	for k in checks:
		if not checks[k]:
			leg_ok = false
	_ok = _ok and leg_ok
	var row := {"ev": leg, "checks": checks, "ok": leg_ok}
	for k in extra:
		row[k] = extra[k]
	_rows.append(row)


func _r3(v: float) -> float:
	return roundi(v * 1000.0) / 1000.0


# --- legs ---------------------------------------------------------------------

# A-E1 + A-E8: HP-pinned scripted survival to cycle 2 through the REAL loop.
func _leg_reach2() -> void:
	var run := _fresh_run(true)
	var game = run.game
	var clears := 0
	var last_cycle := 0
	var ended_bad := false
	for n in STEPS_MAX:
		_decline(run)
		if game.phase not in ["playing"]:
			if game.phase in ["gameover", "win"]:
				ended_bad = true
			break
		game.hp = game.max_hp # DECLARED hp-pin (s8 HD3D_HP_PIN / S6 precedent)
		run._step(DT)
		if game.cycle > last_cycle:
			last_cycle = game.cycle
			clears += 1
			_rows.append({"ev": "cycle_clear", "cycle": game.cycle,
				"t": _r3(game.time), "phase": game.phase,
				"hp_pinned": true,
				"ended": game.phase in ["gameover", "win"]})
		if game.cycle >= 2:
			for s in 60: # settle past the boundary, then read the well
				_decline(run)
				game.hp = game.max_hp
				run._step(DT)
			break
	var disk := _disk_best_cycle()
	_check("endless_reach2", {
		"cycle2": game.cycle >= 2, # A-E8: < 2 here IS the roadmap RED leg
		"clears2": clears == 2,
		"clear_rows_at_boundaries": clears == 2 and game.time >= 1800.0,
		"never_ended": not ended_bad,
		"best_cycle": game.cycle >= 2 and _fresh_well_read(run) == 2,
		"disk_best_cycle": disk == 2,
		"hp_pinned": true,
	}, {"cycle": game.cycle, "clears": clears, "t": _r3(game.time),
		"best_cycle_mem": run._dawnwell.best_cycle, "disk_best_cycle": disk,
		"declared": "hp pinned every tick (s8 win-leg deviation verbatim); " +
			"scripted driver, offers declined; cycle clears fired by main.gd " +
			"own latched branch at the real WIN_TIME crossings"})


func _fresh_well_read(run: Node) -> int: # in-memory meta after the funnel
	return int(run._dawnwell.best_cycle)


# A-E5: run ending at cycle 3 -> 3; never decreases (older-save -> 0 rides
# save_probe's migrate leg + test_save roundtrip).
func _leg_bestcycle3() -> void:
	var run := _fresh_run(false)
	run.game.cycle = 3 # DECLARED cycle-pin, then the real gameover path
	run.game.hp = -1.0
	run._step(DT) # the real hp<=0 -> _end_run("gameover") line
	var after := _disk_best_cycle()
	var run2 := _fresh_run(false)
	run2.game.cycle = 1 # a SHALLOWER death must not lower the record
	run2.game.hp = -1.0
	run2._step(DT)
	var lower := _disk_best_cycle()
	_check("endless_bestcycle", {
		"run_at_cycle3_lands_3": run.game.phase == "gameover" and after == 3,
		"never_decreases": lower == 3,
	}, {"pin_cycle": 3, "disk_after": after, "disk_after_shallower": lower})


# A-E4: the boundary crossed by the real _step: reward card + dawn-tier drop.
func _leg_cycle_clear_reward() -> void:
	var run := _fresh_run(true)
	var game = run.game
	var pending0: int = game.pending_levels
	game.time = GameState.WIN_TIME - DT # stated win-gate warp reading
	run._step(DT)
	var chest: Dictionary = run.world.chests[0] if run.world.chests.size() == 1 \
			else {}
	var expected_tier: String = GameWorld.CHEST_TIER_BY_SOURCE["endless-cycle"]
	_check("endless_cycle_clear_reward", {
		"reward_card_pending_plus1": game.pending_levels == pending0 + 1,
		"one_drop": run.world.chests.size() == 1,
		"tier_dawn": chest.get("tier", "") == "dawn",
		"tier_is_map_row": chest.get("tier", "") == expected_tier,
		"run_continues": game.phase not in ["gameover", "win"],
		"cycle1": game.cycle == 1,
	}, {"t": _r3(game.time), "phase": game.phase,
		"pending_before": pending0, "pending_after": game.pending_levels,
		"tier": chest.get("tier", ""),
		"map_row": "endless-cycle -> %s" % expected_tier})


# A-E3: DECLARED-PIN scaling eval AT the cycle-5 binding point — both clamps
# bind there; dropping either clamp flips its check (the planted reds).
func _leg_caps_cycle5() -> void:
	var run := _fresh_run(true) # flag ON so the t=5280 clock does not win-end
	var game = run.game
	game.cycle = 5 # DECLARED pins: cycle counter + clock (spec A-E3)
	game.time = 5 * GameState.WIN_TIME + M_C_BIND * 60.0
	var base: float = GameWorld.ENEMY_TYPES[BASE_ID].hp
	run.world._spawn_enemy(BASE_ID, game, GameRenderer.VIEW)
	var spawned: Dictionary = run.world.enemies[0]
	var raw_prod: float = base * (1.0 + 0.22 * M_C_BIND) * GameWorld.hp_cyc(5)
	var cap_hp: float = base * GameWorld.HP_EFFECTIVE_MULT_CAP
	# contact side: the REAL main.gd pipeline — warden teleported onto the
	# pawn (DECLARED position pin, kill-leg precedent), one real _step tick,
	# the hp delta IS the clamped contact read (ward 0 on a fresh run).
	run.world.enemies.clear()
	run.world._spawn_enemy(BOSS_ID, game, GameRenderer.VIEW)
	var boss: Dictionary = run.world.enemies[0]
	boss.x = game.player.x # DECLARED position pin (contact is the observable)
	boss.y = game.player.y
	game.hp = game.max_hp
	game.player.iframes = 0.0
	run._step(DT)
	var delta: float = game.max_hp - game.hp
	var raw_contact: float = boss.dmg * GameWorld.dmg_cyc(5)
	_check("endless_caps_cycle5", {
		"hp_clamp_binds": spawned.hp == cap_hp and raw_prod > cap_hp,
		"contact_clamp_binds": delta == 20.0 and raw_contact > 20.0,
	}, {"cycle": 5, "m_c": M_C_BIND, "hp_raw_product": _r3(raw_prod),
		"hp_clamped_to": cap_hp, "hp_observed": spawned.hp,
		"contact_raw": _r3(raw_contact), "contact_observed_delta": _r3(delta),
		"max_contact_dmg": run.MAX_CONTACT_DMG})


# A-E2: per-cycle scaling rows read at the ONE seams + the clamp eval that
# must NOT fire at cycle 4 (planted low-cap 6 turns k=3 RED — capture).
func _leg_scaling() -> void:
	var base: float = GameWorld.ENEMY_TYPES[BASE_ID].hp
	for k in [1, 2, 3]:
		var run := _fresh_run(true)
		var game = run.game
		game.cycle = k # DECLARED pins (clock + counter), eval leg
		game.time = k * GameState.WIN_TIME + M_C_END * 60.0
		run.world._spawn_enemy(BASE_ID, game, GameRenderer.VIEW)
		var e: Dictionary = run.world.enemies[0]
		var expected := roundf(base * (1.0 + 0.22 * M_C_END)
				* GameWorld.hp_cyc(k))
		var cap_hp := base * GameWorld.HP_EFFECTIVE_MULT_CAP
		var clamped: bool = e.hp == cap_hp and expected > cap_hp
		_check("endless_scaling", {
			"hp_matches_formula": e.hp == minf(expected, cap_hp),
			"not_clamped_k_le_3": not clamped,
			"qty_mult_row": GameWorld.qty_cyc(k) == minf(1.0 + 0.25 * k, 2.0),
			"dmg_mult_row": GameWorld.dmg_cyc(k) == minf(1.0 + 0.20 * k, 2.5),
		}, {"cycle": k, "m_c": M_C_END, "hp_mult": GameWorld.hp_cyc(k),
			"qty_mult": GameWorld.qty_cyc(k), "dmg_mult": GameWorld.dmg_cyc(k),
			"hp_expected": expected, "hp_observed": e.hp,
			"clamped": clamped, "rate_ceil_kept": 12.0,
			"alive_cap_kept": GameWorld.ALIVE_CAP})
	# rev-2 P2-2: the 18x bound is the DEEP-cycle guard — cycle 4's worst
	# product must sit BELOW it (first binds at cycle 5, caps leg above).
	var prod4: float = (1.0 + 0.22 * M_C_END) * GameWorld.hp_cyc(4)
	_check("endless_clamp_eval", {
		"cycle4_never_clamps": prod4 < GameWorld.HP_EFFECTIVE_MULT_CAP,
	}, {"cycle": 4, "worst_product": _r3(prod4),
		"cap": GameWorld.HP_EFFECTIVE_MULT_CAP,
		"binds_first_at": "cycle 5 near cycle-end (endless_caps_cycle5)"})


# A-E1 red leg + A-E6: flag OFF -> the limit path stays the M1 win, kind win.
# DECLARED leg-local well wipe: the endless flag is a SAVE ROW (F-4) and the
# reach2 clears persisted it to disk through the funnel (correct product
# behaviour — a later run from that well IS endless), so this leg's "flag
# off" means a well WITHOUT the row: wipe, then the fresh-defaults load.
func _leg_flag_off_win() -> void:
	DawnWell.new().reset()
	var run := _fresh_run(false)
	var game = run.game
	game.time = GameState.WIN_TIME - DT # stated win-gate warp reading
	for i in 120:
		if game.phase == "playing":
			run._step(DT)
			if game.phase in ["gameover", "win"]:
				break
	_check("endless_off_win", {
		"win_at_limit": game.phase == "win", # RED if it keeps running
		"kind_is_win": game.phase == "win",
	}, {"t": _r3(game.time), "kind": game.phase,
		"note": "flag OFF byte-path; committed byte-identity vs " +
				"tests/fixtures/endless-m2.jsonl is test_endless/A-E6"})


# A-E6: Contract B stays the frozen exact-12 shape, cycle/endless absent.
func _leg_snapshot() -> void:
	var game := GameState.new()
	game.start_run()
	var snap: Dictionary = JSON.parse_string(game.snapshot_json(0))
	var keys: Array = snap.keys()
	keys.sort()
	var expected: Array = ["enemies", "gold", "hp", "kills", "level", "maxHp",
		"phase", "runId", "time", "weapons", "xp", "xpNext"]
	expected.sort()
	_check("snapshot_keys", {
		"exact_12": keys == expected,
		"cycle_endless_absent": not keys.has("cycle") and not keys.has("endless"),
	}, {"keys": keys, "count": keys.size()})


func _run_legs() -> void:
	_leg_reach2() # needs the wiped clean well first -> ordered first
	_leg_bestcycle3()
	_leg_cycle_clear_reward()
	_leg_caps_cycle5()
	_leg_scaling()
	_leg_flag_off_win()
	_leg_snapshot()
	_rows.append({"ev": "endless_verdict", "ok": _ok,
		"rows": _rows.size()})
