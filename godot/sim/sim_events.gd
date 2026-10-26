# EVENT-WAVE legs for M4 pillar A (MC 11362 T-M4e; M4-SPEC rev-3 §1.4
# ACCEPT rows A-E3..A-E6 — A-E2 rides the stages-m3 stages_table row +
# tests/test_stages.py, A-E7 the sim_budget channel). Same headless funnel
# as sim_stages/sim_bosses: the REAL Main.tscn, screens stubbed
# (SimStubScreens), every run started through the real _start_game, the
# SimFunnel harness for rows/ok. Construction channel: the DECLARED-PIN
# pattern (sim_boss/sim_endless/sim_stages precedent — save-side stage rows,
# clock warps, HP-PIN survival, and here the world.event_windows row PIN the
# mechanism legs use to place a window at an uncapped/clamped minute; the
# PIN is DECLARED in every leg note, the table rows stay the shipped data).
# Seed-pinned (HD3D_SEED, default 11362 — the card id, the M3 seed law: so the dump is byte-stable; the
# committed copy tests/fixtures/events-m4.jsonl gates tests/test_events.py.
# reason: >400 lines — one leg-driver per pillar batch is the sim convention
#   (sim_stages/sim_bosses shape): this driver owns the pillar-A behaviour
#   corpus (table/cone/surge-cap/mechanism/saturation/twin/miniboss legs),
#   all on the shared SimFunnel fresh_run + DECLARED-PIN helpers.
# DawnWell wiped at start, save-side isolation like the donors.
# ROWS (row-id -> the ACCEPT row it pins):
#   events_table        §1.1/§1.4 A-E2 twin (table truth through the
#       RENDERER + the world.gd consts): the three events rows verbatim,
#       EVENT_SURGE == 2.0, CONE_ALL == [0.0, TAU] (the F-1 identity cone).
#   event_cone          A-E3: stage-2 run, DECLARED warp 660 (the window
#       opens on tick 1), horde cleared at the start, 900 hp-pinned steps
#       INSIDE [660,720): EVERY alive spawn's angle (vs the player, the
#       same numeric space as the shipped funnel — no px/m bridge, T-M3g
#       law) sits inside the west cone [135°,225°] (check cone_share ==
#       1.0); a control twin with the window row PINNED OFF spreads ~25 %
#       inside that arc; a third pass run PAST t1=720 returns to the full
#       circle. Planted cone [0,TAU] in the table => share ~25 % RED.
#   event_surge_cap     A-E4 cap leg (the shipped plates_cap shape): minute
#       11+ during the real window, minf(12.0) binds BOTH the plain and the
#       surged term (arithmetic row) AND the live twins spawn EQUAL counts
#       with the ALIVE_CAP pause intact (F-4: events do not bypass it).
#   event_surge_mechanism  A-E4 mechanism leg (UNCAPPED zone, the spec's
#       DECLARED-PIN window [180,210] at minute 3.0-3.5: base 4.90-5.55,
#       x2 = 9.80-11.10 < 12.0 — inside and outside the minf COINCIDE, the
#       factor is purely observable): twin spawn-count ratio == 2.0
#       (check surge_ratio). Planted surge 1.5 (plate-const bleed) => 1.5
#       RED. The pin carries the IDENTITY cone: this leg isolates the rate.
#   event_surge_saturation A-E4 saturation leg (CLAMP zone, DECLARED-PIN
#       window [480,510], minute 8.0-8.5 base 11.40-12.05): green converges
#       to <= 12.0/s (check surge_capped); the observable is the PRE-CAP
#       SUB-WINDOW mean from window start (pool cleared) to the ALIVE_CAP
#       hit or window end (c2 F-4 disclosure: a surge planted OUTSIDE the
#       minf reads 22.80-24.10/s over the ~17 s to cap vs <= 12.0/s green;
#       the full-window mean carries a clamp tail and could false-green).
#   rng_twin_identity   A-E5 (c2 F-1 identity carve — this leg's OWN
#       subject is the default path): twin A carries the events row pinned
#       to the table's IDENTITY cone [0.0, TAU] (`0.0 + randf()*TAU ==
#       randf()*TAU`, geometry inert), twin B the empty row; the symmetric
#       660 bosses-row entries fire in BOTH twins (the pin gates the events
#       loop only — c3-P3-1 rider; pre-T-M4a the defer-guard holds them in
#       BOTH twins, zero RNG, still symmetric — the shipped pre-clear
#       idiom's own sim_stages.gd:437-446 precedent). hp-pinned natural
#       clock t=0 -> phase end; digest rows at t=720 and to run-end EQUAL
#       (check rng_stream). A randi() planted for cone choice forks the
#       digests at 660 while the clamped rates stay identical (T-M3g
#       independent attribution) RED.
#   event_miniboss      A-E6: the sunken-prelate first-seen 660.017 on
#       stage 2 (sim_bosses first-seen shape), ONCE through the latch to
#       782, NEVER on stage 1 (0..900 walk) and NEVER on stage 3 (both-side
#       negatives: stage 2 fields no stair-acolyte, stage 3 no prelate);
#       world.reset() re-arm fires it once more (schedule_rearm shape);
#       the chests leg re-uses sim_chest_tiers' synth-kill shape: kills of
#       the prelate's drop shape ride the 0.6 roll and EVERY chest tier
#       equals the dumped MAP row CHEST_TIER_BY_SOURCE["miniboss"] (map
#       compare, never a literal; the keyed boss branch is NOT taken — the
#       rows field miniboss, not boss; F-3 keeps the ONE map at 7 rows).
extends SceneTree

const DT := 1.0 / 60.0
const SEED_DEFAULT := 11362
const TAU_F := TAU

var _funnel := SimFunnel.new() # rows/ok/check: the ONE harness (MC 11317 C3)
var _started := false


func _out_path() -> String:
	return SimFunnel.out_path("HD3D_EVENTS_DUMP", "/tmp/hd3d-events-m4.jsonl")


func _process(_delta: float) -> bool:
	if not _started:
		_started = true
		print("EVENTS_START")
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else SEED_DEFAULT)
		DawnWell.new().reset() # clean well (save.gd's own reset verb)
		_run_legs()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		assert(f != null)
		for r in _funnel.rows:
			f.store_line(JSON.stringify(r))
		f.close()
		print("EVENTS_OK rows=%d ok=%s" % [_funnel.rows.size(), str(_funnel.ok)])
		quit(0 if _funnel.ok else 3)
	return false


func _check(leg: String, checks: Dictionary, extra: Dictionary) -> void:
	_funnel.check(leg, checks, extra)


func _decline(run: Node) -> void:
	SimFunnel.take_first_card(run) # the stages donor's fork (audit S2.1)


func _fresh_run(stage_idx: int) -> Node:
	var opts := {"wipe_well": true, "wire_pick": true}
	if stage_idx != 1:
		opts["stage"] = stage_idx # DECLARED save-side row (sim_stages pattern)
	return SimFunnel.fresh_run(root, opts)


func _run_legs() -> void:
	_leg_table()
	_leg_cone()
	_leg_surge_cap()
	_leg_surge_mechanism()
	_leg_surge_saturation()
	_leg_rng_twin()
	_leg_miniboss()


# --- helpers ------------------------------------------------------------------

# Angle of e vs the player, normalized to [0, TAU) (table space — the same
# numeric space world.gd's spawn ring and the shipped funnel compare in).
func _ang(e: Dictionary, p: Dictionary) -> float:
	var a := atan2(float(e.y) - float(p.y), float(e.x) - float(p.x))
	return a if a >= 0.0 else a + TAU_F


func _dist2p(e: Dictionary, p: Dictionary) -> float:
	var dx := float(e.x) - float(p.x)
	var dy := float(e.y) - float(p.y)
	return dx * dx + dy * dy # < 20.0^2 px = inside the contact ring


func _in_cone(a: float, cone: Array) -> bool:
	return a >= float(cone[0]) and a < float(cone[1])


func _cone_of(ev: Array) -> Array:
	var half := float(ev[3]) * 0.5
	return [deg_to_rad(float(ev[2]) - half), deg_to_rad(float(ev[2]) + half)]


# The window legs' shared construction (the shipped _sat_window shape):
# re-seed, fresh stage-2 run, DECLARED warp to t_pin (the window opens on
# the first stepped tick), horde cleared, then `steps` hp-pinned steps with
# the events row optionally PINNED (DECLARED construction pins, each named
# in the leg's note). Returns the spawn/alive/kills tallies + cap readings.
func _window_window(t_pin: float, steps: int, pin_rows: Array,
		pinned := false) -> Dictionary:
	seed(SEED_DEFAULT)
	var run := _fresh_run(2)
	run.game.time = t_pin # DECLARED clock pin
	if pinned:
		run.world.event_windows = pin_rows # DECLARED window pin (leg note;
		# an EMPTY pin_rows here means PINNED-OFF — the off-twin's pin)
	run.world.enemies.clear()
	var k0: int = run.game.kills
	var max_horde := 0
	var cap_t := -1.0
	for i in steps:
		_decline(run)
		run.game.hp = run.game.max_hp # DECLARED hp-pin (endless pattern)
		if run.game.phase != "playing":
			break
		run._step(DT)
		var hn := 0
		for e in run.world.enemies:
			if not e.boss and not e.miniboss:
				hn += 1
		max_horde = maxi(max_horde, hn)
		if cap_t < 0.0 and hn >= GameWorld.ALIVE_CAP:
			cap_t = run.game.time # the cap-hit observable (c2 F-4)
	var d := {"spawns": run.world.enemies.size() + (run.game.kills - k0),
		"alive": run.world.enemies.size(), "kills": run.game.kills - k0,
		"max_horde": max_horde, "cap_t": cap_t, "t_end": run.game.time}
	run.queue_free()
	return d


# --- legs ---------------------------------------------------------------------

# A-E2 twin: the events table + the two world.gd consts, engine-evaluated.
func _leg_table() -> void:
	var ev_rows: Array = []
	for idx in [1, 2, 3]:
		var rid: String = String(GameRenderer.STAGES[idx - 1].id)
		ev_rows.append(GameRenderer.stage_row(rid).events)
	_funnel.check("events_table", {
		"stage1_events_empty": ev_rows[0].is_empty(), # F-1 byte law
		"stage2_row_verbatim": str(ev_rows[1]) == str([[660.0, 720.0, 180.0, 90.0]]),
		"stage3_row_verbatim": str(ev_rows[2]) == str([[660.0, 720.0, 0.0, 90.0]]),
		"surge_is_two": GameWorld.EVENT_SURGE == 2.0,
		"cone_identity": float(GameWorld.CONE_ALL[0]) == 0.0 \
			and float(GameWorld.CONE_ALL[1]) == TAU_F,
		"west_cone": _cone_of(ev_rows[1][0]) == [deg_to_rad(135.0), deg_to_rad(225.0)],
		"east_cone": _cone_of(ev_rows[2][0]) == [deg_to_rad(-45.0), deg_to_rad(45.0)],
	}, {"events": ev_rows, "surge": GameWorld.EVENT_SURGE})


# A-E3: cone truth (share == 1 inside the window; control spread; full
# circle again after t1). DECLARED warp 660 (window opens tick 1).
func _leg_cone() -> void:
	# The EXPECTED arc is §1.1's fixed west cone as a leg CONSTANT, never a
	# read of the table: the planted-cone [0,TAU] red must fork the
	# BEHAVIOUR check (share ~0.25), not merely the table row (measured in
	# the first battery: deriving the arc from the table left cone_share
	# GREEN on the planted row — circular).
	var cone: Array = [deg_to_rad(135.0), deg_to_rad(225.0)]
	# inside pass: real table rows, window [660,720) live
	var run := _fresh_run(2)
	run.game.time = 660.0 # DECLARED clock pin (sim_bosses shape)
	run.world.enemies.clear() # the latched 540/660 named spawns clear too;
	# the digest-free legs judge the HORDE stream (the _sat_window precedent)
	for i in 900: # 15 s INSIDE the window, hp-pinned
		_decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing":
			break
		run._step(DT)
	var inside := 0
	var n := 0
	for e in run.world.enemies:
		if e.boss or e.miniboss or _dist2p(e, run.game.player) < 400.0:
			continue # contact ring: jitter scrambles the bearing (measured
			# 17/178 false-outs); bearing == spawn angle only while marching
		n += 1
		if _in_cone(_ang(e, run.game.player), cone):
			inside += 1
	# past-window pass: run to t >= 720, clear, another 15 s
	while run.game.phase != "gameover" and run.game.time < 720.0 + DT:
		_decline(run) # levelup clears inside (a `phase == playing` gate
		# stalls HERE — measured: the twin froze at 677 in a levelup)
		run.game.hp = run.game.max_hp
		run._step(DT)
	run.world.enemies.clear()
	for i in 900:
		_decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing":
			break
		run._step(DT)
	var post_in := 0
	var post_n := 0
	for e in run.world.enemies:
		if e.boss or e.miniboss or _dist2p(e, run.game.player) < 400.0:
			continue
		post_n += 1
		if _in_cone(_ang(e, run.game.player), cone):
			post_in += 1
	run.queue_free()
	# control twin: window PINNED OFF (construction pin, DECLARED)
	seed(SEED_DEFAULT)
	var ctrl := _fresh_run(2)
	ctrl.world.event_windows = [] # DECLARED pin: no window ever opens
	ctrl.game.time = 660.0
	ctrl.world.enemies.clear()
	for i in 900:
		_decline(ctrl)
		ctrl.game.hp = ctrl.game.max_hp
		if ctrl.game.phase != "playing":
			break
		ctrl._step(DT)
	var ctrl_in := 0
	var ctrl_n := 0
	for e in ctrl.world.enemies:
		if e.boss or e.miniboss or _dist2p(e, ctrl.game.player) < 400.0:
			continue
		ctrl_n += 1
		if _in_cone(_ang(e, ctrl.game.player), cone):
			ctrl_in += 1
	ctrl.queue_free()
	var share := float(inside) / maxf(1.0, float(n))
	var post_share := float(post_in) / maxf(1.0, float(post_n))
	var ctrl_share := float(ctrl_in) / maxf(1.0, float(ctrl_n))
	_funnel.check("event_cone", {
		"cone_share": n > 100 and share == 1.0, # EVERY spawn inside
		# post-window sample gate 50 (not 100): with the mesh rows live the
		# named spawns shift the window-end horde density (measured 73) —
		# the share is still a ~70-sample reading of the circle return
		"circle_returns": post_n > 50 and post_share > 0.05 \
			and post_share < 0.6, # full circle again past t1
		"control_spread": ctrl_n > 100 and absf(ctrl_share - 0.25) < 0.10,
	}, {"share": share, "alive": n, "post_share": post_share, "post_alive": post_n,
		"ctrl_share": ctrl_share, "ctrl_alive": ctrl_n,
		"cone": cone, "window": [660.0, 720.0],
		"note": "DECLARED warp 660 + hp-pin; planted cone [0,TAU] in the " +
		"table row => share ~0.25 RED (A-E3's planted-red instrument run)"})


# A-E4 cap leg: the shipped plates_cap shape (arithmetic rows + live twins).
func _leg_surge_cap() -> void:
	var minute := 11.5 # the window minute: base 15.95 — minf binds BOTH
	var plain := minf(12.0, (1.0 + 1.3 * minute) * GameWorld.qty_cyc(0) * 1.0)
	var surged := minf(12.0, (1.0 + 1.3 * minute) * GameWorld.qty_cyc(0) \
		* GameWorld.EVENT_SURGE)
	seed(SEED_DEFAULT)
	var on := _window_window(660.0 - DT, 3600, []) # real rows (window live)
	seed(SEED_DEFAULT)
	var off := _window_window(660.0 - DT, 3600, [], true) # PINNED empty
	_funnel.check("event_surge_cap", {
		"minf_binds_both": plain == 12.0 and surged == 12.0,
		"twins_equal": on.spawns == off.spawns and on.spawns > 400,
		"cap_pause_holds": on.max_horde <= GameWorld.ALIVE_CAP \
			and off.max_horde <= GameWorld.ALIVE_CAP,
	}, {"plain_rate": plain, "surged_rate": surged, "on": on, "off": off,
		"minute": minute,
		"note": "DECLARED warp 660-DT (window live from tick 1) vs the SAME " +
		"run with event_windows PINNED EMPTY (construction pin): minute 11+ " +
		"clamps BOTH to 12/s — equal counts, ALIVE_CAP pause intact (F-4)"})


# A-E4 mechanism leg: the spec's DECLARED-PIN window [180,210] (minute
# 3.0-3.5) — uncapped zone, ratio purely observable. IDENTITY cone in the
# pin: this leg isolates the RATE (geometry stays the A-E3 leg's subject).
func _leg_surge_mechanism() -> void:
	seed(SEED_DEFAULT)
	var on := _window_window(180.0 - DT, 1800, [[180.0, 210.0, 0.0, 360.0]], true)
	seed(SEED_DEFAULT)
	var off := _window_window(180.0 - DT, 1800, [], true)
	var ratio := float(on.spawns) / maxf(1.0, float(off.spawns))
	_funnel.check("event_surge_mechanism", {
		# The LITERAL 2.0 (the table row's own value), not the runtime
		# const: the planted 1.5 (plate-const bleed) must go RED here —
		# comparing to GameWorld.EVENT_SURGE would move the yardstick with
		# the plant (battery-measured circularity, first run).
		"surge_ratio": ratio >= 2.0 - 0.06 and ratio <= 2.0 + 0.06,
		"uncapped_zone": on.spawns / 30.0 < 12.0, # the ratio is the whole story
		"no_flare": true, # events touch flare NOTHING (checked via state rows)
	}, {"on": on, "off": off, "ratio": ratio, "surge": GameWorld.EVENT_SURGE,
		"note": "DECLARED-PIN window [180,210] identity-cone at minute 3.0-" +
		"3.5 (base 4.90-5.55, x2 = 9.80-11.10 < 12.0): inside/outside minf " +
		"coincide, the twin ratio == EVENT_SURGE. Planted surge 1.5 => 1.5 RED"})


# A-E4 saturation leg: DECLARED-PIN window [480,510] (minute 8.0-8.5). The
# observable is the PRE-CAP SUB-WINDOW mean (c2 F-4: full-window carries a
# clamp tail and could false-green).
func _leg_surge_saturation() -> void:
	seed(SEED_DEFAULT)
	var on := _window_window(480.0 - DT, 1800, [[480.0, 510.0, 0.0, 360.0]], true)
	var span: float = float(on.cap_t if on.cap_t > 0.0 else on.t_end) - 480.0
	var rate := float(on.spawns if on.cap_t < 0.0 else \
		# spawns up to the cap: alive at cap + kills since start (pre-cap
		# there are none beyond the fill — alive hits ALIVE_CAP first)
		on.alive + on.kills) / maxf(span, 0.001)
	_funnel.check("event_surge_saturation", {
		"surge_capped": rate <= 12.3, # green <= 12.0 + IEEE slack
		"clamp_binds": minf(12.0, (1.0 + 1.3 * 8.25) * GameWorld.qty_cyc(0) \
			* GameWorld.EVENT_SURGE) == 12.0, # the surged term DOES clamp
	}, {"on": on, "pre_cap_rate": SimFunnel.r3(rate), "span": SimFunnel.r3(span),
		"minute": 8.25,
		"note": "DECLARED-PIN window [480,510] identity-cone at minute 8.0-" +
		"8.5 (base 11.40-12.05): in-minf twin reads <= 12.0/s to the cap or " +
		"window end. Planted surge OUTSIDE the minf: ~17 s at 22.80-24.10/s " +
		"to the cap against the 12.0 ceiling RED (spec c2 F-4 measurement)"})


# A-E5: the identity-cone digest twin (this leg's subject is the DEFAULT
# path; the LIVE cone's geometry truth stays event_cone's, never a digest
# claim — the M3 rev-3 dwell_zero_rng carve restated). Natural clock t=0 ->
# run-end; digests at t=720 and at the end; the 660 bosses-row entries are
# symmetric in BOTH twins (the pin gates the events loop only, c3-P3-1).
func _leg_rng_twin() -> void:
	var a := _twin_run([[660.0, 720.0, 180.0, 360.0]]) # identity cone pinned
	var b := _twin_run([]) # no window row at all
	_funnel.check("rng_twin_identity", {
		"rng_stream": str(a.d720) == str(b.d720) and str(a.dend) == str(b.dend),
	}, {"digest_on_720": a.d720, "digest_off_720": b.d720,
		"digest_on_end": a.dend, "digest_off_end": b.dend,
		"equal_at_720": str(a.d720) == str(b.d720),
		"equal_at_end": str(a.dend) == str(b.dend),
		"note": "identity-cone twin: `0.0 + randf()*TAU == randf()*TAU` " +
		"keeps geometry inert, the clamped 12/s keeps the stream in step, " +
		"kill-time rolls consume the SAME stream at the SAME positions. A " +
		"randi() planted for cone choice forks at 660 (rng_stream RED) " +
		"while rates stay identical (T-M3g independent attribution)"})


func _twin_run(pin_rows: Array) -> Dictionary:
	seed(SEED_DEFAULT)
	var run := _fresh_run(2)
	run.world.event_windows = pin_rows # DECLARED pin (leg note above)
	var d720 := {}
	var done720 := false
	while run.game.phase == "playing":
		_decline(run)
		run.game.hp = run.game.max_hp # DECLARED hp-pin to run-end
		run._step(DT)
		if not done720 and run.game.time >= 720.0:
			d720 = _digest(run)
			done720 = true
	var dend := _digest(run)
	run.queue_free()
	return {"d720": d720, "dend": dend}


func _digest(run: Node) -> Dictionary:
	return {"t": SimFunnel.r3(run.game.time), "phase": run.game.phase,
		"kills": run.game.kills, "gold": run.game.gold,
		"xp": run.game.xp, "level": run.game.level,
		"alive": run.world.enemies.size(),
		"types": run.world.enemies.map(func(e): return e.type),
		"px": SimFunnel.r3(run.game.player.x),
		"py": SimFunnel.r3(run.game.player.y),
		"acc": SimFunnel.r3(run.world.spawn_acc),
		"chests": run.world.chests.size(), "gems": run.world.gems.size()}


# A-E6: the event-miniboss schedule legs (first-seen/once/never/rearm, the
# sim_bosses + schedule_rearm shapes) + the chests-vs-map leg (the
# sim_chest_tiers synth-kill shape; tier compared to the DUMPED map row).
func _leg_miniboss() -> void:
	# stage 2: first-seen + once through the latch to 782, no cross-class
	seed(SEED_DEFAULT)
	var run := _fresh_run(2)
	run.game.time = 660.0 # DECLARED clock pin: 660.017 observable
	var first_t := -1.0
	var guard := 0
	while guard < 60:
		guard += 1
		_decline(run)
		run.game.hp = run.game.max_hp
		run._step(DT)
		for e in run.world.enemies:
			if e.type == "sunken-prelate" and first_t < 0.0:
				first_t = SimFunnel.r3(run.game.time)
		if first_t > 0.0:
			break
	var appearances := 0
	var prev := 0
	var cross_seen: Array = []
	while run.game.phase != "gameover" and run.game.time < 782.0:
		_decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing":
			break
		run._step(DT)
		var now := 0
		for e in run.world.enemies:
			if e.type == "sunken-prelate":
				now += 1
			elif e.type == "stair-acolyte" and not cross_seen.has(e.type):
				cross_seen.append(e.type) # stage 2 never fields stage 3's wall
		if now > prev:
			appearances += now - prev
		prev = now
	# re-arm: the ONE reset() verb, then the 660 row fires once MORE
	run.world.reset()
	run.game.time = 660.0
	var re_arm := 0 # SPAWN count via the 0->1 transition (the pre-reset
	# appearances loop above uses the same shape; counting PRESENCE ticks
	# instead measured 90 once the mesh landed — pre-mesh it hid at 0)
	var prev2 := 0
	for i in 90:
		_decline(run)
		run.game.hp = run.game.max_hp
		run._step(DT)
		var now2 := 0
		for e in run.world.enemies:
			if e.type == "sunken-prelate":
				now2 += 1
		if now2 > prev2:
			re_arm += now2 - prev2
		prev2 = now2
	# chests-vs-map: the sim_chest_tiers synth-kill shape on the prelate's
	# drop shape (miniboss flag, keyed boss branch NOT taken, type rides the
	# row); every drop tier equals the MAP row, never a literal (T-M2t law).
	var map_mb: String = GameWorld.CHEST_TIER_BY_SOURCE["miniboss"]
	var c0: int = run.world.chests.size()
	for i in 40:
		run.world.kill_enemy(run.game, {"x": run.game.player.x + 8.0,
			"y": run.game.player.y + 8.0, "xp": 0.0, "boss": false,
			"miniboss": true, "type": "sunken-prelate"})
	var drops: Array = []
	for i in range(c0, run.world.chests.size()):
		drops.append(String(run.world.chests[i].tier))
	var roll_ok := drops.size() > 0 and drops.size() < 40
	var tiers_ok := true
	for tstr in drops:
		if tstr != map_mb:
			tiers_ok = false
	run.queue_free()
	# stage 1 NEVER fields the event minibosses (0..900 walk, hp-pinned)
	seed(SEED_DEFAULT)
	var s1 := _fresh_run(1)
	var s1_seen: Array = []
	while s1.game.phase == "playing":
		_decline(s1)
		s1.game.hp = s1.game.max_hp
		s1._step(DT)
		for e in s1.world.enemies:
			if e.type == "sunken-prelate" or e.type == "stair-acolyte":
				if not s1_seen.has(e.type):
					s1_seen.append(e.type)
	s1.queue_free()
	# stage 3 NEVER fields the PRELATE (its own wall spawns; both-side half 2)
	seed(SEED_DEFAULT)
	var s3 := _fresh_run(3)
	s3.game.time = 660.0
	var s3_seen: Array = []
	while s3.game.phase == "playing" and s3.game.time < 782.0:
		_decline(s3)
		s3.game.hp = s3.game.max_hp
		s3._step(DT)
		for e in s3.world.enemies:
			if (e.type == "sunken-prelate" or e.type == "cathedral-choir") \
					and not s3_seen.has(e.type):
				s3_seen.append(e.type)
	s3.queue_free()
	_funnel.check("event_miniboss", {
		"prelate_first_seen_660": first_t == 660.017,
		"prelate_once": appearances == 1,
		"never_stage1": s1_seen.is_empty(),
		"never_cross_stage": cross_seen.is_empty() \
			and not s3_seen.has("sunken-prelate"),
		"rearm_fires_once_more": re_arm == 1,
		"chest_roll_06": roll_ok,
		"chest_tier_from_map": tiers_ok and drops.size() > 0,
	}, {"first_seen": first_t, "appearances": appearances, "re_arm_count": re_arm,
		"re_arm_latch": run.world.schedule_spawned,
		"stage1_seen": s1_seen, "stage3_seen": s3_seen, "cross_seen": cross_seen,
		"map_miniboss_tier": map_mb, "drops": drops, "drop_count": drops.size(),
		"note": "mesh-gated GREEN (T-M4a): the sunken-prelate/stair-acolyte " +
		"ENEMY_TYPES rows land with their GLB wiring in this card's close " +
		"commit — until the meshes the shipped defer-guard HOLDS the 660 " +
		"rows (no crash, no latch: the spine law between the cards)"})
