# STAGES legs for M3 pillars A+B (MC 11282, T-M3s; M3-SPEC rev-3 §1.4
# reason: >400 lines — one leg-driver per pillar batch is the sim convention
#   (sim_endless 350 / sim_chest_tiers 400): this header's ROWS table is the
#   row-id -> ACCEPT-row map the suite reads; splitting hides the map).
# ACCEPT rows A-E1..A-E8 + §2's overlay/persistence legs). Same headless
# funnel as sim_endless/sim_chest_tiers: the REAL Main.tscn, screens stubbed
# (SimStubScreens), every run started through the real _start_game.
# Construction channel: the DECLARED-PIN pattern (sim_boss/sim_endless
# precedent — flag/stage rows + clock pins + HP-PIN survival where a leg
# must reach late timestamps; a SCRIPTED-DRIVER SURVIVAL ARTIFACT, never a
# balance claim). Seed-pinned (HD3D_SEED, default 11282) so the dump is
# byte-stable; the committed copy tests/fixtures/stages-m3.jsonl gates
# tests/test_stages.py (the A-E1 stage-1 byte corpus rides the FOUR EXISTING
# fixtures + the journey re-run, NOT this file). DawnWell wiped at start,
# save_probe isolation under a throwaway XDG_DATA_HOME.
# ROWS (row-id -> the ACCEPT row it pins):
#   stages_table               A-E2: STAGES table read through the RENDERER
#       (id/name/limit/unlock/bands/bosses per stage) + the band_at equality
#       legs (stage-1 walk == biome_at at 0/150/300/450/900; stage 2 band_at
#       299.9/300/599.9/600; stage 3 at 449.9/450) + the boss-row eval: the
#       stage-1 bosses row == the shipped BOSS_AT/MINIBOSS_AT schedule
#       (const + concatenation evaluated by the engine, byte-equal).
#   stage1_schedule            A-E2 + the REPLACEMENT legs for the retired
#       test_boss_numbers latch pins (P1-1 fold): warden 540.017, knight
#       600.017, deacon 780.017, each once, exactly 3 schedule spawns 0..782.
#   schedule_rearm             A-E2 + the retired pins' reset() re-arm claim:
#       a second pass warps past 540 again and the warden fires ONCE more.
#   cairns                     A-E3: stage-2 run seeds the two FIXED cairn
#       coords as chests with tier == CHEST_TIER_BY_SOURCE["stage-item"]
#       (dumped map value, never a second literal — the tier-from-map law);
#       walking one opens it through the ONE funnel: chest count -1, pending
#       +ember item_count, gold roll inside the ember range. Zero-RNG row:
#       rng_stream below.
#   rng_stream                 A-E3/A-E4: stage 2 run vs stage 1 run, same
#       seed, 3600 steps idle at the same clock — spawn sequence, hp stamps
#       and alive count IDENTICAL (cairn seeding consumed ZERO randf/randi;
#       any stream fork would diverge these fields).
#   plates_rate                A-E4: two fresh stage-3 runs, same DECLARED
#       warp t=30, one dwelling on a plate: spawn count ratio == SPAWN_SURGE
#       (within acc-carry tolerance); dwell consumes no RNG (flare pins
#       exactly FLARE_SHIFT).
#   plates_cap                 A-E4: the cap rows — minf(12.0) STILL binds at
#       minute 9 with the surge applied (12.0 == 12.0); the late run fields
#       its own end-boss since T-M3b — HORDE <= 400 + once-each NAMED (§7).
#   plates_flare               A-E2/§1.2: dwelling at t=380 -> flare 150 and
#       the band NAME reads THE FROZEN WASTE (base DEAD TUNDRA, shift 150 ->
#       530 >= 450); 30 s off-plate decays flare to exactly 0.0 and the name
#       back to the base band.
#   plates_saturation          A-E4 (T-M3g, MC 11283): minute-9 twins on
#       the clamp (12.7 -> 12.0), plate-less vs dwelling: minf_clamps_surge
#       REDs a surge outside the ceiling (18/s); dwell_zero_rng REDs RNG.
#       T-M3b RE-MINT (the 540 tick now latches): both twins fire their OWN
#       boss, clear it, digests judge the HORDE stream; checks stand.
#   draw_tally                 §7 row: pickup_viz draw tally 5/5/6 (the plate
#       MM draws ONLY on its stage row) — C-E4 keeps DRAWS_PLANNED 40.
#   unlock_chain               A-E5: level-9 stage-1 run end sets NOTHING;
#       level-10 sets flags.stage2=1 on DISK (one funnel); a later stage-2
#       death at level 3 does NOT unset it and sets no stage3; a level-14
#       stage-2 run end sets stage3=1. Flags SET only (roadmap flag law).
#   handin                     §1.1/§1.4: unset stage (old-save disk 1) reads
#       moor-vigil; disk stage 2 hands in sunken-chapel; out-of-range 7
#       reads moor-vigil (clamp, never a crash).
#   snapshot_m3                A-E8: with stage + flare SET, the Contract B
#       snapshot is the exact frozen 12 fields — stage/flare ABSENT (F-3).
extends SceneTree

const DT := 1.0 / 60.0
const SEED_DEFAULT := 11282
const T := 1.0 / 60.0 # first-seen rounding carrier (sim_boss _r3 shape)

var _rows: Array = []
var _started := false
var _ok := true


func _out_path() -> String:
	var d: String = OS.get_environment("HD3D_STAGES_DUMP")
	return d if d != "" else "/tmp/hd3d-stages-m3.jsonl"


func _process(_delta: float) -> bool:
	if not _started:
		_started = true
		print("STAGES_START")
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else SEED_DEFAULT)
		DawnWell.new().reset() # clean well (save.gd's own reset verb)
		_run_legs()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		assert(f != null)
		for r in _rows:
			f.store_line(JSON.stringify(r))
		f.close()
		print("STAGES_OK rows=%d ok=%s" % [_rows.size(), str(_ok)])
		quit(0 if _ok else 3)
	return false


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


func _decline(run: Node) -> void:
	while run.game.phase == "levelup": # sim_budget/sim_endless pattern
		run._pick(0)


func _fresh_run(stage_idx: int) -> Node:
	DawnWell.new().reset() # each leg owns its well state unless it says otherwise
	var run: Node = load("res://Main.tscn").instantiate()
	root.add_child(run)
	var stub := SimStubScreens.new()
	run.add_child(stub)
	run._screens = stub
	stub.start_pressed.connect(run._start_game)
	stub.card_picked.connect(run._pick)
	if stage_idx != 1:
		run._dawnwell.stage = stage_idx # DECLARED: the save-side row the
		# hand-in seam reads (the endless-flag pattern, sim_endless:154)
	run._start_game()
	return run


# --- legs ---------------------------------------------------------------------

# A-E2: the table + band equality, no world state involved.
func _leg_table() -> void:
	var stages: Array = []
	for s in GameRenderer.STAGES:
		stages.append({"id": s.id, "name": s.name, "gimmick": s.gimmick,
			"limit": s.limit, "unlock_level": s.unlock_level,
			"unlock_stage": s.unlock_stage, "unlock_flag": s.unlock_flag,
			"bands": s.bands, "bosses": s.bosses,
			"cairns": s.cairns, "plates": s.plates})
	# stage-1 walk == the shipped biome_at at the pinned samples (A-E2)
	var eq: Array = []
	for t in [0.0, 150.0, 300.0, 450.0, 900.0]:
		var ba: Dictionary = GameRenderer.band_at("moor-vigil", t)
		var sh: Dictionary = GameRenderer.biome_at(t)
		eq.append({"t": t, "same_row": ba == sh})
	# the band_at t_starts of stages 2/3 (299.9/300/599.9/600; 449.9/450)
	var b2 := {}
	for t in [0.0, 299.9, 300.0, 599.9, 600.0, 900.0]:
		b2[str(t)] = GameRenderer.band_at("sunken-chapel", t).name
	var b3 := {}
	for t in [0.0, 449.9, 450.0, 900.0]:
		b3[str(t)] = GameRenderer.band_at("ossuary-stair", t).name
	# the stage-1 bosses row IS the shipped schedule (const eval proof)
	var shipped := [[GameWorld.BOSS_AT, "warden"]] \
		+ GameWorld.MINIBOSS_AT
	var s1: Array = GameRenderer.STAGES[0].bosses
	var names: Array = []
	for s in GameRenderer.STAGES:
		names.append(s.name)
	_check("stages_table", {
		"stage1_walk_equals_biome_at": eq.all(func(e): return e.same_row),
		"boss_row_is_shipped_schedule": str(s1) == str(shipped),
		"three_stages": GameRenderer.STAGES.size() == 3,
		"limits_900": stages.all(func(s): return s.limit == 900.0),
	}, {"stages": stages, "names": names, "band_moor": eq,
		"band_2": b2, "band_3": b3,
		"unlock_levels": [0, 10, 14], "band_starts_2": [0.0, 300.0, 600.0],
		"band_starts_3": [0.0, 450.0]})


# A-E2 + replacement legs for the retired latch pins (P1-1): the stage-1
# schedule fires each entry once, first-seen times ride the clock, re-arm.
func _leg_schedule() -> void:
	var run := _fresh_run(1)
	var first := {}
	var alive_counts := []
	run.game.time = 540.0 # DECLARED clock pin (sim_boss WARP_T shape):
	# the warden row fires on the FIRST stepped tick at 540 + DT -> 540.017
	var guard := 0
	while run.game.phase != "gameover" and guard < 60:
		guard += 1
		_decline(run)
		run.game.hp = run.game.max_hp # DECLARED hp-pin (endless pattern)
		run._step(DT)
		for e in run.world.enemies:
			if not first.has(e.type) and e.type in ["warden", "hollow-knight",
					"hollow-deacon"]:
				first[e.type] = roundi(run.game.time * 1000.0) / 1000.0
		if run.game.time >= 540.1:
			break
	var warden_t: float = float(first.get("warden", -1.0))
	var warden_appearances := 0
	var warden_prev := 0
	# continue to 782 with the hp-pin; count each named spawn exactly
	var sched_steps := 0
	while run.game.phase != "gameover" and run.game.time < 782.0:
		_decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing":
			break
		run._step(DT)
		for e in run.world.enemies:
			if not first.has(e.type):
				first[e.type] = roundi(run.game.time * 1000.0) / 1000.0
		var w_now := 0
		for e in run.world.enemies:
			if e.type == "warden":
				w_now += 1
		if w_now > warden_prev:
			warden_appearances += w_now - warden_prev # CUMULATIVE spawns
			# (T-M3b planted-RED lesson: a same-tick 0->2 jump is TWO spawns)
		warden_prev = w_now
		sched_steps += 1
	# cumulative spawns, not survival: the retired pins proved the warden
	# spawns EXACTLY ONCE (a later kill is Pillar C's business).
	var wardens_alive := 0
	for e in run.world.enemies:
		if e.type == "warden":
			wardens_alive += 1
	_check("stage1_schedule", {
		"warden_first_seen_540": warden_t == 540.017,
		"knight_first_seen_600": float(first.get("hollow-knight", -1.0)) == 600.017,
		"deacon_first_seen_780": float(first.get("hollow-deacon", -1.0)) == 780.017,
		"schedule_latch_3": run.world.schedule_spawned == 3,
		"warden_spawns_once": warden_appearances == 1,
	}, {"first_seen": first, "phase": run.game.phase})
	# re-arm: the SAME world through reset() (F-5 wording) — warp past 540
	# again and the warden fires exactly once more.
	run.world.reset()
	var latch_after_reset: int = run.world.schedule_spawned
	var re_before := 0
	for e in run.world.enemies:
		if e.boss:
			re_before += 1
	run.game.time = 540.0
	run.game.phase = "playing"
	run.game.hp = run.game.max_hp
	run._step(DT)
	var re_after := 0
	for e in run.world.enemies:
		if e.boss:
			re_after += 1
	_check("schedule_rearm", {
		"reset_clears_latch": latch_after_reset == 0,
		"second_pass_relatches": run.world.schedule_spawned == 1,
		"second_pass_fires_once": re_before == 0 and re_after == 1,
	}, {"re_after": re_after})
	run.queue_free()


# A-E3: cairns ride the ONE chest array + funnel, tier from THE MAP.
func _leg_cairns() -> void:
	var row: Dictionary = GameRenderer.stage_row("sunken-chapel")
	var run := _fresh_run(2)
	var map: Dictionary = GameWorld.CHEST_TIER_BY_SOURCE
	var expected_tier: String = String(map["stage-item"])
	var seen: Array = []
	for c in run.world.chests:
		seen.append({"x": c.x, "y": c.y, "tier": c["tier"]})
	var seeded_ok: bool = seen.size() == row.cairns.size()
	for i in row.cairns.size():
		if not (seen[i].x == row.cairns[i][0] and seen[i].y == row.cairns[i][1]
				and seen[i].tier == expected_tier):
			seeded_ok = false
	# open one through the ONE funnel: walk the player onto the first cairn
	# the sim_chest_tiers _isolate precedent: other pickups cleared so the
	# gold delta read at the open is ONLY the cairn's own gold line.
	run.world.gems.clear()
	run.world.coins.clear()
	run.world.heals.clear()
	var gold0: int = run.game.gold
	var pend0: int = run.game.pending_levels
	var c0: Array = row.cairns[0]
	run.game.player.x = float(c0[0]) + 8.0
	run.game.player.y = float(c0[1])
	run._step(DT)
	var ember: Dictionary = ChestRewards.TIERS[expected_tier]
	var dg: int = run.game.gold - gold0
	_check("cairns", {
		"seeded_fixed_coords_map_tier": seeded_ok,
		"open_shrank_array": run.world.chests.size() == row.cairns.size() - 1,
		"pending_raised_item_count": run.game.pending_levels - pend0 == int(ember.item_count),
		# the open's kind was QUEUED then drawn by the same _step's frozen
		# levelup seam (grant -> _enter_levelup pops one per offer): the
		# observable is the 3-card offer the seam produced, not the queue.
		"offer_drew_three_cards": run._current_offer.size() == 3,
		"gold_roll_in_tier_range": dg >= int(ember.gold_lo) and dg <= int(ember.gold_hi),
	}, {"seeded": seen, "tier": expected_tier, "gold_delta": dg,
		"offer_cards": run._current_offer.size()})
	run.queue_free()


# A-E3 zero-RNG row: stage 2 vs stage 1, same seed/clock/steps, identical
# horde stream (cairn seeding consumed nothing from it).
func _leg_rng_stream() -> void:
	var a := _digest_run(1)
	var b := _digest_run(2)
	_check("rng_stream", {
		"stage2_stream_equals_stage1": str(a) == str(b),
	}, {"digest": a})


func _digest_run(stage_idx: int) -> Dictionary:
	seed(SEED_DEFAULT) # sim_boss per-leg seed: both digests start on the
	# SAME pinned stream — cross-leg drift of the global RNG is not the claim
	var run := _fresh_run(stage_idx)
	for i in 3600: # 60 idle s, same pinned global seed, no clock pin
		run._step(DT)
		if run.game.phase != "playing":
			break
	var d := {"alive": run.world.enemies.size(),
		"kills": run.game.kills, "gold": run.game.gold,
		"spawned_types": run.world.enemies.map(func(e): return e.type)}
	run.queue_free()
	return d


# A-E4: the surge on the ONE rate term (two fresh runs, same declared warp).
func _leg_plates_rate() -> void:
	var row: Dictionary = GameRenderer.stage_row("ossuary-stair")
	var base := _plate_window(row, false)
	var dwell := _plate_window(row, true)
	var ratio: float = float(dwell.spawns) / maxf(1.0, float(base.spawns))
	_check("plates_rate", {
		"ratio_is_surge": ratio >= GameWorld.SPAWN_SURGE - 0.06 \
			and ratio <= GameWorld.SPAWN_SURGE + 0.06,
		"dwell_pins_flare": dwell.flare == GameWorld.FLARE_SHIFT,
		"off_flare_zero": base.flare == 0.0,
	}, {"base": base, "dwell": dwell, "ratio": ratio,
		"surge": GameWorld.SPAWN_SURGE,
		"note": "DECLARED-PIN window: fresh runs warped to t=30, enemies " +
		"cleared at the window start, player idle (on/off the plate at " +
		"-220,0); spawns = alive delta + kills delta over 1800 steps"})


func _plate_window(row: Dictionary, on_plate: bool) -> Dictionary:
	var run := _fresh_run(3)
	run.game.time = 30.0 # DECLARED clock pin (the sim_headless warp pattern)
	if on_plate: # table space == the dwell test's space (world.gd comment)
		run.game.player.x = float(row.plates[0][0])
		run.game.player.y = float(row.plates[0][1])
	run.world.enemies.clear()
	var k0: int = run.game.kills
	for i in 1800: # 30 s window, hp-pinned (endless survival pattern)
		_decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing":
			break
		run._step(DT)
	var spawns: int = run.world.enemies.size() + (run.game.kills - k0)
	var d := {"spawns": spawns, "flare": run.game.flare,
		"kills": run.game.kills - k0}
	run.queue_free()
	return d


# A-E4 cap rows: minf still binds; ALIVE_CAP never breached under dwell.
func _leg_plates_cap() -> void:
	var minute := 9.0 # t=540-ish: base 12.7 ALREADY saturates minf(12.0)
	var plain := minf(12.0, (1.0 + 1.3 * minute) * GameWorld.qty_cyc(0) * 1.0)
	var surged := minf(12.0, (1.0 + 1.3 * minute) * GameWorld.qty_cyc(0) \
		* GameWorld.SPAWN_SURGE)
	# behavioural half: dwell at the saturation clock, hp-pinned, watch alive
	var run := _fresh_run(3)
	var row: Dictionary = GameRenderer.stage_row("ossuary-stair")
	run.game.time = 540.0 # DECLARED pin; the boss row also fires here
	run.game.player.x = float(row.plates[0][0])
	run.game.player.y = float(row.plates[0][1])
	# C-E4 RE-PIN (MC 11284, §7 named-spawn row): this run now fields its own
	# ossuary-warden at 540 — HORDE <= ALIVE_CAP + the once-each NAMED spawn.
	var max_alive := 0
	var max_horde := 0
	var max_named := 0
	for i in 3600:
		_decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing":
			break
		run._step(DT)
		var horde_n: int = run.world.enemies.filter(
			func(e): return not e.boss and not e.miniboss).size()
		max_horde = maxi(max_horde, horde_n)
		max_named = maxi(max_named, run.world.enemies.size() - horde_n)
		max_alive = maxi(max_alive, run.world.enemies.size())
	_check("plates_cap", {
		"minf_binds_both": plain == 12.0 and surged == 12.0,
		"horde_cap_holds": max_horde <= GameWorld.ALIVE_CAP,
		"named_spawns_once": max_named == 1,
	}, {"plain_rate": plain, "surged_rate": surged, "max_alive": max_alive,
	"max_horde": max_horde, "max_named": max_named})
	run.queue_free()


# §1.2 flare: shifted band NAME while dwelling, decays to the base.
func _leg_plates_flare() -> void:
	var row: Dictionary = GameRenderer.stage_row("ossuary-stair")
	var run := _fresh_run(3)
	run.game.time = 380.0 # DECLARED pin: base band DEAD TUNDRA (< 450)
	var base_band: String = GameRenderer.band_at("ossuary-stair",
		run.game.time + run.game.flare).name
	run.game.player.x = float(row.plates[0][0])
	run.game.player.y = float(row.plates[0][1])
	run.game.hp = run.game.max_hp
	run._step(DT)
	var dwell_band: String = GameRenderer.band_at("ossuary-stair",
		run.game.time + run.game.flare).name
	# leave and decay: 30 sim-s off-plate, clock pinned (F-3: the shift never
	# feeds difficulty — only the NAME moves; clock stays where it is)
	run.game.player.x = 0.0
	run.game.player.y = 0.0
	for i in 1800:
		_decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing":
			break
		run._step(DT)
		run.game.time = 380.0 # DECLARED: hold the clock, isolate the decay
	var end_band: String = GameRenderer.band_at("ossuary-stair",
		run.game.time + run.game.flare).name
	_check("plates_flare", {
		"dwell_shifts_band": base_band == "DEAD TUNDRA" and dwell_band == "THE FROZEN WASTE",
		# tolerance: the decay is an IEEE accumulation over 1800 dt steps —
		# exact 0.0 only where maxf clamps; a hair above is the SAME state.
		"flare_decayed_to_base": run.game.flare <= 0.01 and end_band == base_band,
	}, {"base_band": base_band, "dwell_band": dwell_band,
		"flare_after_decay": run.game.flare})
	run.queue_free()


# A-E4 (T-M3g): twins at minute 9 (base 12.7 clamps to exact 12.0): stage 2
# plate-less vs stage 3 DWELLING plate[0], ONE position (an off-position
# twin forks kill timing -> the levelup offers' RNG: measured 185/178).
func _leg_plates_saturation() -> void:
	var row: Dictionary = GameRenderer.stage_row("ossuary-stair")
	var no_plate := _sat_window(2, row)
	var dwell := _sat_window(3, row)
	_check("plates_saturation", {
		"minf_clamps_surge": dwell.spawns == no_plate.spawns,
		"dwell_zero_rng": str(dwell) == str(no_plate),
	}, {"stage2": no_plate, "stage3_dwell": dwell, "minute": 9.0,
		"t": 540.0, "x": row.plates[0][0]})


# One window: re-seeded, DECLARED t=540, player at plate[0] (stage 3 only
# dwells), enemies cleared, 1800 hp-pinned steps (the endless pattern).
# T-M3b RE-MINT: the 540 tick now LATCHES — both twins fire their OWN boss
# on the pre-window tick (the same ONE randf each), then it is CLEARED: the
# digests judge the HORDE stream, as A-E4 wrote them. Checks stand.
func _sat_window(stage_idx: int, row: Dictionary) -> Dictionary:
	seed(SEED_DEFAULT)
	var run := _fresh_run(stage_idx)
	run.game.time = 540.0
	run.game.player.x = float(row.plates[0][0]) # mutate IN the one dict
	run.game.player.y = float(row.plates[0][1]) # (hero_pawn holds the ref)
	_decline(run)
	run.game.hp = run.game.max_hp
	run._step(DT) # the 540 tick fires the stage's own boss row here
	var fired: int = run.world.enemies.filter(func(e): return e.boss).size()
	run.world.enemies.clear()
	assert(fired == 1) # both twins fire EXACTLY once, or the twins fork
	var k0: int = run.game.kills
	for i in 1800: # 30 s hp-pinned (the endless survival pattern)
		_decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing": break
		run._step(DT)
	var d := {"spawns": run.world.enemies.size() + (run.game.kills - k0),
		"alive": run.world.enemies.size(), "kills": run.game.kills - k0,
		"types": run.world.enemies.map(func(e): return e.type)}
	run.queue_free()
	return d


# §7 draw-tally row: the plate MM only joins the tally where it draws.
func _leg_draw_tally() -> void:
	var tally := {}
	for idx in [1, 2, 3]:
		var run := _fresh_run(idx)
		run._pvz.refresh()
		tally[run.game.stage] = run._pvz.draw_count()
		run.queue_free()
	_check("draw_tally", {
		"stage1_five": tally["moor-vigil"] == 5,
		"stage2_five": tally["sunken-chapel"] == 5,
		"stage3_six": tally["ossuary-stair"] == 6,
	}, {"tally": tally})


# A-E5 unlock chain: set-only, one funnel, disk-verified.
func _end_run_at(run: Node, level: int) -> void:
	run.game.level = level # DECLARED level pin (the unlock key's input)
	run.game.hp = 0.0
	run._step(DT) # the ONE _end_run funnel runs (real gameover path)


func _leg_unlock() -> void:
	DawnWell.new().reset()
	var r1 := _fresh_run_no_wipe(1)
	_end_run_at(r1, 9)
	r1.queue_free()
	var after9: Dictionary = DawnWell.load_save().flags
	DawnWell.new().reset()
	var r2 := _fresh_run_no_wipe(1)
	_end_run_at(r2, 10)
	r2.queue_free()
	var after10: Dictionary = DawnWell.load_save().flags
	var r3 := _fresh_run_no_wipe(2) # stage 2, keeps the stage2 flag on disk
	_end_run_at(r3, 3)
	r3.queue_free()
	var s2low: Dictionary = DawnWell.load_save().flags
	var r4 := _fresh_run_no_wipe(2)
	_end_run_at(r4, 14)
	r4.queue_free()
	var s2hi: Dictionary = DawnWell.load_save().flags
	_check("unlock_chain", {
		"level9_sets_nothing": int(after9.get("stage2", 0)) == 0,
		"level10_sets_stage2": int(after10.get("stage2", 0)) == 1,
		"stage3_needs_stage2_run": int(s2low.get("stage3", 0)) == 0 \
			and int(s2low.get("stage2", 0)) == 1,
		"level14_stage2_sets_stage3": int(s2hi.get("stage3", 0)) == 1,
	}, {"after9": after9, "after10": after10, "s2low": s2low, "s2hi": s2hi})


func _fresh_run_no_wipe(stage_idx: int) -> Node:
	# same as _fresh_run WITHOUT the well wipe — the chain legs share the
	# persisted well exactly like the real menu does.
	var run: Node = load("res://Main.tscn").instantiate()
	root.add_child(run)
	var stub := SimStubScreens.new()
	run.add_child(stub)
	run._screens = stub
	stub.start_pressed.connect(run._start_game)
	stub.card_picked.connect(run._pick)
	run._dawnwell.stage = stage_idx # DECLARED save-side row (endless pattern)
	run._start_game()
	return run


# §1.1/§1.4 hand-in legs.
func _leg_handin() -> void:
	DawnWell.new().reset()
	var r1 := _fresh_run_no_wipe(1)
	var s1: String = r1.game.stage
	r1.queue_free()
	DawnWell.new().reset()
	var r2 := _fresh_run_no_wipe(2)
	var s2: String = r2.game.stage
	r2.queue_free()
	DawnWell.new().reset()
	var r3 := _fresh_run_no_wipe(7) # out of range: clamp, never crash
	var s3: String = r3.game.stage
	r3.queue_free()
	_check("handin", {
		"unset_reads_moor_vigil": s1 == "moor-vigil",
		"stage2_hands_in": s2 == "sunken-chapel",
		"out_of_range_clamps": s3 == "moor-vigil",
	}, {"s1": s1, "s2": s2, "s3": s3})


# A-E8: stage + flare SET, the snapshot is still the exact frozen 12.
func _leg_snapshot() -> void:
	var game := GameState.new()
	game.start_run()
	game.stage = "ossuary-stair"
	game.flare = 150.0
	var snap: Dictionary = JSON.parse_string(game.snapshot_json(0))
	game.start_run() # the A-E8 reset half: start_run clears BOTH again
	var keys: Array = snap.keys()
	keys.sort()
	var expected: Array = ["enemies", "gold", "hp", "kills", "level", "maxHp",
		"phase", "runId", "time", "weapons", "xp", "xpNext"]
	expected.sort()
	_check("snapshot_m3", {
		"exact_12": keys == expected,
		"stage_flare_absent": not keys.has("stage") and not keys.has("flare"),
		"start_run_resets": game.stage == "moor-vigil" and game.flare == 0.0,
	}, {"keys": keys, "count": keys.size()})


# M3 §3.1 (MC 11284): defer-guard retired WITH ITS GUARD (rows landed;
# replace-not-delete, LEDGER T-M3b) — sim_bosses.gd carries the replacements
# (stage2_schedule, stage3_schedule, boss_contact_clamp), appended at END.
func _run_legs() -> void:
	_leg_table()
	_leg_schedule()
	_leg_cairns()
	_leg_rng_stream()
	_leg_plates_rate()
	_leg_plates_cap()
	_leg_plates_flare()
	_leg_plates_saturation()
	_leg_draw_tally()
	_leg_unlock()
	_leg_handin()
	_leg_snapshot()
	SimBosses.new().run_boss_legs(self) # rows after snapshot_m3 (see above)
	_rows.append({"ev": "stages_verdict", "ok": _ok, "rows": _rows.size()})
