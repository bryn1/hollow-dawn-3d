# THE REAPER legs for M4 pillar B (MC 11364, T-M4r; M4-SPEC rev-3 §2.3
# ACCEPT rows B-E1..B-E6). Same headless funnel as sim_endless/sim_events:
# the REAL Main.tscn, screens stubbed, every run started through the real
# _start_game; the night flag rides the ONE well-flag seam (fresh_run opts
# "flags" — the endless pattern). Construction channel: the DECLARED-PIN
# pattern (hp-pin survival = the s8 HD3D_HP_PIN / sim_endless reach2
# precedent, named per row — a scripted-driver survival artifact, not a
# balance claim). Seed-pinned (HD3D_SEED, default 11334 = the card id,
# §2.2) so the dump is byte-stable; the committed copy
# tests/fixtures/reaper-m4.jsonl gates tests/test_reaper.py. Per-leg dump
# env HD3D_REAPER_DUMP. DawnWell save wiped per leg ownership (F-4); the
# whole channel runs under a throwaway XDG_DATA_HOME (save isolation).
# ROWS (row-id -> the ACCEPT row it pins):
#   reaper_off_win                   B-E1: flag OFF, warp to WIN_TIME - dt,
#       real _step -> kind "win", the-reaper NEVER seen (RED if the night
#       arm leaks into the flag-off path — the planted "default the flag
#       true" instrument, capture-proven red).
#   reaper_limit                     B-E2: flag ON, hp-pinned stationary
#       policy; the clock crosses the limit INSIDE the run: kind != "win"
#       at 900.017 (the run CONTINUES hunted), first arrival at 900.017,
#       the boss bar reads THE REAPER (readout through hud.boss_bar_state,
#       the C-E3 seam, after declared funnel kills of the earlier bosses —
#       the first-boss bar law), contact ENDS the run: kind "gameover",
#       stats.time in (900, 930), and the end lines carry the prepended
#       "The Reaper took you at ..." row.
#   reaper_latch                     B-E3: DECLARED reaper-speed pin 1.0
#       (declared: 200 px/s would END this leg's own run before the second
#       arrival — the leg measures the LATCH, the limit leg measured the
#       walk) -> arrivals [900.017, 960.017], count 2, one per PERIOD
#       (planted once-only latch -> the 960 row missing -> RED).
#   reaper_endless                   B-E4: BOTH flags ON — the cycle clear
#       still fires at 900.017 and 1800.017 (endless-first precedence,
#       the R9 source-pinned arm order), ZERO the-reaper spawns, the run
#       never ends gameover-by-reaper (planted reaper-first fork -> the
#       clears stop -> RED).
#   reaper_death                     B-E6: THE ZERO-DROP-ARRAY-DELTA leg —
#       real funnel spawn of the-reaper, hp pinned 0 (the sim_bosses pin
#       idiom), the REAL kill_enemy funnel: kills +1, alive -1, and the
#       FOUR drop arrays (chests/gems/coins/heals) plus gold move by
#       EXACTLY ZERO — the death guard's map-bypass law (F-3: the keyed
#       read of an absent "the-reaper" row would append a null-tier chest
#       through Godot's soft-error null — value-compare against the
#       DUMPED 7-row map, never a literal; planted guard removal ->
#       phantom chest + the 50-gold bounty -> RED).
#   reaper_snapshot                  B-E5 (snapshot half): with the night
#       flag handed in the Contract B snapshot is STILL the frozen exact-
#       12 — "reaper" ABSENT (a 13th field reddens this row AND the
#       test_endless source pins). The budget half rides sim_budget.gd's
#       budget_reaper leg (the A-E7 convention: budget rows gate the
#       driver's exit code, no pytest twin).
extends SceneTree

const DT := 1.0 / 60.0
const SEED_DEFAULT := 11334 # the card id (M4-SPEC §2.2 seed law)
const STEPS_MAX := 60 * 940 # the limit leg's walk bound (end ~904, cap 930+)
const LATCH_STEPS := 60 * 965 # past the SECOND arrival (960.017) + settle
const REAPER_ID := "the-reaper"

var _funnel := SimFunnel.new() # rows/ok/check: the ONE harness (MC 11317 C3)
var _started := false


# End-line probe: records what _end_run hands show_end (the stub's own
# surface, zero visual side effects — the END SCREEN row is the observable,
# §2.1's "no new surface" claim read at its ONE seam).
class EndProbe extends SimStubScreens:
	var end_win := false
	var end_lines: Array = []

	func show_end(win: bool, lines: Array) -> void:
		end_win = win
		end_lines = lines


func _out_path() -> String:
	return SimFunnel.out_path("HD3D_REAPER_DUMP", "/tmp/hd3d-reaper-m4.jsonl")


func _process(_delta: float) -> bool:
	if not _started:
		_started = true
		print("REAPER_START")
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else SEED_DEFAULT)
		DawnWell.new().reset() # clean well (save.gd's own reset verb)
		_run_legs()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		assert(f != null)
		for r in _funnel.rows:
			f.store_line(JSON.stringify(r))
		f.close()
		print("REAPER_OK rows=%d ok=%s" % [_funnel.rows.size(), str(_funnel.ok)])
		quit(0 if _funnel.ok else 3)
	return false


# --- channel helpers ----------------------------------------------------------

func _night_run() -> Node:
	# DECLARED: the night flag rides the ONE seam — the save flag
	# main._start_game consumes (the endless fresh_run pattern verbatim).
	return SimFunnel.fresh_run(root, {"wire_pick": true, "wipe_well": true,
			"flags": {"reaper": 1}})


func _reaper_count(run: Node) -> int:
	var n := 0
	for e in run.world.enemies:
		if e.get("reaper", false):
			n += 1
	return n


func _r3(v: float) -> float:
	return SimFunnel.r3(v) # the arrival-time carrier


# --- legs ---------------------------------------------------------------------

# B-E1: flag OFF — the limit path stays the M1 win byte-for-byte and the
# the-reaper row is NEVER constructed (its only construction site is the
# flag-gated arrival latch). The planted "default the flag true" instrument
# turns this leg's win into a hunted night -> RED (capture).
func _leg_flag_off_win() -> void:
	var run := SimFunnel.fresh_run(root, {"wire_pick": true, "wipe_well": true,
			"flags": {}})
	var game = run.game
	var seen := 0
	game.time = GameState.WIN_TIME - DT # stated win-gate warp reading
	for i in 120:
		if game.phase == "playing":
			run._step(DT)
			seen += _reaper_count(run)
			if game.phase in ["gameover", "win"]:
				break
	_funnel.check("reaper_off_win", {
		"win_at_limit": game.phase == "win", # RED when the night arm leaks
		"kind_is_win": game.phase == "win",
		"reaper_never": seen == 0,
	}, {"t": _r3(game.time), "kind": game.phase, "reaper_ticks": seen,
		"note": "flag OFF byte-path; committed byte-identity vs " +
				"tests/fixtures/*-m*.jsonl + journey 5020 is the byte corpus " +
				"(re-dump cmp, capture)"})


# B-E2: flag ON — the limit no longer ends the run; the walk-in ends it.
# DECLARED pins: hp every tick (s8 win-leg deviation verbatim — the row
# under test is the END LAW, not survival); the player stays stationary
# (no input is the shipped headless state — "stationary-policy contact").
func _leg_limit() -> void:
	var run := _night_run()
	var probe := EndProbe.new()
	run.add_child(probe)
	run._screens = probe # DECLARED: end-line capture at the ONE seam
	var game = run.game
	var first_seen := -1.0
	var phase_at_seen := ""
	var bar_name := ""
	var bar_visible := false
	var ended := false
	for n in STEPS_MAX:
		SimFunnel.decline(run)
		game.hp = game.max_hp # DECLARED hp-pin (survival to the limit)
		run._step(DT)
		if first_seen < 0.0 and _reaper_count(run) > 0:
			first_seen = game.time
			phase_at_seen = game.phase
			# the C-E3 readout seam: drive the live HUD update (the real
			# _process call site), then read the bar state — DECLARED
			# funnel kills of the EARLIER bosses first: the shipped bar
			# law is the FIRST boss in the live list, and the schedule
			# bosses (540/600/780) are still walking this hp-pinned run.
			# The kills ride the real kill_enemy funnel (sim_chest_tiers
			# synth-kill precedent); their drops are artifacts of the pin,
			# not claims of this leg (reaper drops belong to B-E6).
			for e in run.world.enemies.duplicate():
				if e.boss and not e.get("reaper", false):
					run.world.kill_enemy(game, e)
			run._hud.update(0.0)
			var bar: Dictionary = run._hud.boss_bar_state()
			bar_name = String(bar.get("name", ""))
			bar_visible = bool(bar.get("visible", false))
		if game.phase in ["gameover", "win"]:
			ended = true
			break
	var t_end: float = float(game.stats.get("time", -1.0)) # a run that
	# never ends (planted end-law removal) reads -1 and reddens the window,
	# it must not crash the channel (RED is the instrument's success case).
	var line0 := String(probe.end_lines[0]) if probe.end_lines.size() > 0 else ""
	_funnel.check("reaper_limit", {
		"not_win_at_limit": phase_at_seen != "win", # the run CONTINUES
		"first_seen_900": first_seen > 0.0 \
				and _r3(first_seen) == _r3(GameState.WIN_TIME + DT),
		"bar_reads_reaper": bar_visible and bar_name == "THE REAPER",
		"ends_by_contact": ended and game.phase == "gameover", # not win
		"end_time_window": t_end > 900.0 and t_end < 930.0,
		"end_line_present": line0.begins_with("The Reaper took you at "),
		"five_rows_kept": probe.end_lines.size() == 6, # 1 + the 5 shipped
	}, {"first_seen": _r3(first_seen), "phase_at_seen": phase_at_seen,
		"bar_name": bar_name, "bar_visible": bar_visible,
		"kind": game.phase, "end_time": _r3(t_end), "end_line": line0,
		"hp_pinned": true, "stationary": true,
		"declared": "hp pinned every tick (s8 win-leg deviation); earlier " +
				"schedule bosses funnel-killed for the first-boss bar read"})


# B-E3: one MORE reaper every REAPER_PERIOD. DECLARED speed pin 1.0 for
# every arrival the moment it lands: at the shipped 200 px/s the FIRST
# arrival ends this run (~4 s) before the second gate can fire — the leg
# measures the LATCH; reaper_speed is dumped so the pin is on the record.
func _leg_latch() -> void:
	var run := _night_run()
	var game = run.game
	var arrivals: Array = []
	var prev := 0
	for n in LATCH_STEPS:
		SimFunnel.decline(run)
		game.hp = game.max_hp # DECLARED hp-pin (horde survival to 960+)
		run._step(DT)
		for e in run.world.enemies:
			if e.get("reaper", false) and e.spd > 1.0:
				e.spd = 1.0 # DECLARED pin: measure the latch, not the walk
		var now := _reaper_count(run)
		if now > prev:
			arrivals.append(_r3(game.time))
		prev = now
		if game.phase in ["gameover", "win"]:
			break
	_funnel.check("reaper_latch", {
		"two_arrivals": arrivals.size() == 2,
		"arrival_times": arrivals == [_r3(GameState.WIN_TIME + DT),
				_r3(GameState.WIN_TIME + GameWorld.REAPER_PERIOD + DT)],
		"still_hunted": prev == 2 and game.phase == "playing",
	}, {"arrivals": arrivals, "reapers_alive": prev, "reaper_speed": 1.0,
		"period": GameWorld.REAPER_PERIOD, "t_end": _r3(game.time),
		"declared": "reaper spd pinned 1.0 on arrival (B-E3 runs the latch, " +
				"reaper_limit runs the walk); hp pinned every tick"})


# B-E4: Endless precedence — flags endless+reaper ON: the shipped cycle
# clear keeps firing at EVERY boundary and the night NEVER arrives (the
# world gate is not-endless AND the cap fork is endless-first, both named
# at source; the planted reaper-first fork stops the clears -> RED).
func _leg_endless() -> void:
	var run := SimFunnel.fresh_run(root, {"wire_pick": true,
			"wipe_well": true, "flags": {"endless": 1, "reaper": 1}})
	var game = run.game
	var reaper_ticks := 0
	var clear_cycles: Array = []
	game.time = GameState.WIN_TIME - DT # stated boundary warp (sim_endless)
	for i in 120:
		SimFunnel.decline(run)
		game.hp = game.max_hp # DECLARED hp-pin (both-cycle survival)
		run._step(DT)
		reaper_ticks += _reaper_count(run)
		if game.cycle == 1 and clear_cycles.size() == 0:
			clear_cycles.append(_r3(game.time))
	if game.phase not in ["gameover", "win"]:
		game.time = 2.0 * GameState.WIN_TIME - DT
		for i in 120:
			SimFunnel.decline(run)
			game.hp = game.max_hp
			run._step(DT)
			reaper_ticks += _reaper_count(run)
			if game.cycle == 2 and clear_cycles.size() == 1:
				clear_cycles.append(_r3(game.time))
	_funnel.check("reaper_endless", {
		# The warp method (sim_endless cycle-clear-reward idiom) crosses the
		# boundary at the exact float sum (WIN_TIME - DT) + DT == WIN_TIME,
		# so the clears land at 900.0 / 1800.0 — pinned exactly (the walk
		# method's 900.017 is reaper_limit/reaper_latch's carrier).
		"clear_fires_at_900": clear_cycles.size() > 0 \
				and clear_cycles[0] == _r3(GameState.WIN_TIME),
		"clear_fires_at_1800": clear_cycles.size() > 1 \
				and clear_cycles[1] == _r3(2.0 * GameState.WIN_TIME),
		"zero_reaper_spawns": reaper_ticks == 0,
		"never_ended_by_reaper": game.phase == "playing",
	}, {"cycles": game.cycle, "clears": clear_cycles,
		"reaper_ticks": reaper_ticks, "kind": game.phase,
		"declared": "clock warps to just-before each boundary (sim_endless " +
				"reach2/cycle_clear idiom); hp pinned every tick"})


# B-E6: THE ZERO-DROP-ARRAY-DELTA instrument. Real funnel spawn, hp pinned
# 0, the REAL kill_enemy funnel. Every drop array + gold must move by ZERO;
# the kill itself must COUNT. Value-compare rides the DUMPED map row (F-3:
# the 7-row map never gains a reaper key — a keyed read of the absent row
# is the soft-null that would append a phantom null-tier chest; the 144-158
# drop-guard instrument shape from test_chests_tiers, arrays not literals).
func _leg_death() -> void:
	var run := _night_run() # the flag ON keeps the kill path on-scene
	var game = run.game
	var map: Dictionary = GameWorld.CHEST_TIER_BY_SOURCE
	run.world._spawn_enemy(REAPER_ID, game, GameRenderer.VIEW) # DECLARED:
	# the same ONE funnel the arrival latch drives (sim_bosses BASE_ID idiom)
	var reaper: Dictionary = run.world.enemies[run.world.enemies.size() - 1]
	assert(reaper.get("reaper", false))
	var n_e0: int = run.world.enemies.size()
	var kills0: int = game.kills
	var gold0: int = game.gold
	var chests0: int = run.world.chests.size()
	var gems0: int = run.world.gems.size()
	var coins0: int = run.world.coins.size()
	var heals0: int = run.world.heals.size()
	reaper.hp = 0.0 # DECLARED mutation (the sim_bosses kill-leg pin idiom)
	run.world.kill_enemy(game, reaper) # the ONE kill funnel, real call
	_funnel.check("reaper_death", {
		"kill_counts": game.kills == kills0 + 1,
		"removed": run.world.enemies.size() == n_e0 - 1,
		"chests_zero_delta": run.world.chests.size() == chests0,
		"gems_zero_delta": run.world.gems.size() == gems0,
		"coins_zero_delta": run.world.coins.size() == coins0,
		"heals_zero_delta": run.world.heals.size() == heals0,
		"bounty_zero": game.gold == gold0, # no boss +50 (guard, §2.1 P2-1)
		"map_untouched": map.size() == 7 and not map.has(REAPER_ID),
	}, {"kills_delta": game.kills - kills0, "gold_delta": game.gold - gold0,
		"chests_delta": run.world.chests.size() - chests0,
		"gems_delta": run.world.gems.size() - gems0,
		"coins_delta": run.world.coins.size() - coins0,
		"heals_delta": run.world.heals.size() - heals0,
		"map_rows": map.size(), "first_seen_t": _r3(game.time),
		"declared": "flag-gated funnel spawn, hp pinned 0, real kill_enemy " +
				"— the FIRST executed evidence of the map-bypass law at " +
				"the keyed drop site (B-E6 green-by-first-execution)"})


# B-E5 (snapshot half): with the night handed in, Contract B stays the
# frozen exact-12; "reaper" NEVER appears (F-3 — the var lives outside
# snapshot_json; a 13th field reddens this AND test_endless's source pins).
func _leg_snapshot() -> void:
	var game := GameState.new()
	game.start_run()
	game.reaper = true # the handed-in run-mode state
	var snap: Dictionary = JSON.parse_string(game.snapshot_json(0))
	var keys: Array = snap.keys()
	keys.sort()
	var expected: Array = ["enemies", "gold", "hp", "kills", "level", "maxHp",
		"phase", "runId", "time", "weapons", "xp", "xpNext"]
	expected.sort()
	_funnel.check("reaper_snapshot", {
		"exact_12": keys == expected,
		"reaper_absent": not keys.has("reaper"),
	}, {"keys": keys, "count": keys.size()})


func _run_legs() -> void:
	_leg_flag_off_win()
	_leg_limit() # the slow walk-leg first: full 0 -> ~904 clock
	_leg_latch()
	_leg_endless()
	_leg_death()
	_leg_snapshot()
	_funnel.rows.append({"ev": "reaper_verdict", "ok": _funnel.ok,
		"rows": _funnel.rows.size()})
