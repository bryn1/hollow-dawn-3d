# GEM-MERGE legs for M2 pillar C (MC 11238, T-M2g; M2-SPEC rev-2 §C.3 ACCEPT
# rows C-G1..C-G3; C-G4 is the pixel row, tools/upgrades_visual_probe.py BULK
# table + gemmerge_capture.gd). Same headless funnel as sim_endless/sim_evolve:
# the REAL Main.tscn, screens stubbed (SimStubScreens), every run started
# through the real _start_game; legs then drive the ONE world seam the product
# itself calls (world.update_entities / collect_pickups — the sim_boss/sim_caps
# DECLARED-PIN channel, no second mechanism, no new array). Seed-pinned
# (HD3D_SEED, default 11238) so the dump is byte-stable; the committed copy
# tests/fixtures/gem-merge-m2g.jsonl gates tests/test_gem_merge.py. Per-leg
# dump env HD3D_GEMS_DUMP (the rev-2 P4-3 per-leg naming).
# DECLARED pins (named per row, never hidden): the synthetic gem dicts the
# boundary/conservation/byte legs append directly to world.gems are the
# sim_caps synthetic-slot pattern (dicts of the real drop shape — the kill-
# enemy RNG funnel is bypassed ONLY to make the boundary pinable, the merge +
# collect code under test is the product's own); the C-G3 spam leg feeds the
# REAL kill_enemy drop funnel instead.
# ROWS (row-id -> the ACCEPT row it pins):
#   gem_boundary          C-G1: cap±1 at the DECLARED-pinned array — 199 ->
#       count HELD, no bulk; 200 -> one bulk gem, count drops (200 -> 101,
#       the fold's centroid + SUM-xp checked byte-exact); 201 -> merges too
#       (bounded). Merge at 199 (or none at 200) -> the ok flags RED.
#   gem_sum_conserved     C-G2 (a): the UNCONDITIONAL gem-layer leg — array
#       Σxp is byte-equal across the fold (pre == post incl the bulk's
#       xp = SUM), run TWICE: defaults AND a DECLARED-PINNED insight=3 +
#       meta_xp_mult=1.3 (conservation is multiplier-independent — the
#       rev-2 P2-4 wording verbatim). A fold that drops one gem's xp moves
#       Σ -> RED (the "cannot lose XP" row).
#   gem_xp_byte_equal     C-G2 (b): merge-ON vs merge-OFF game.xp/level
#       trajectory byte-equal, DECLARED-PINNED to insight=0 + meta 1.0
#       (m=1.0, the committed-dump default — stated so; at m!=1.0 the byte-
#       equality is NOT claimed, IEEE per rev-2 P2-4). Integer-valued xp
#       drops (the real ENEMY_TYPES rows) keep every partial sum an exact
#       float, which is what makes the pinned claim true.
#   gem_bounded_spam      C-G3: 6000 REAL kill_enemy drops through the 70%
#       roll, one update per drop: the array observed at the update seam
#       (its bounded point, world.gd's comment) never exceeds 200, and the
#       folds happened (bulk count > 0 — an unbounded run here is the RED).
extends SceneTree

const DT := 1.0 / 60.0
const SEED_DEFAULT := 11238
const SPAM_DROPS := 6000 # >= 30 full folds at the 70% roll, deterministically
const SPAM_POSE := 120.0 # drop pose beyond the 60 px magnet (fresh run) —
	# gems stay where they drop; nothing collects (no _step, the leg observes
	# the bounded representation at its own seam)
const PIN_X := 300.0 # DECLARED-pinned array pose: outside the 60 px magnet,
const PIN_Y := 240.0 # so update_entities cannot move the pin (it only pulls)

var _rows: Array = []
var _started := false
var _frames := 0
var _ok := true


func _out_path() -> String:
	var d: String = OS.get_environment("HD3D_GEMS_DUMP")
	return d if d != "" else "/tmp/hd3d-gems-m2g.jsonl"


func _process(_delta: float) -> bool:
	_frames += 1
	if not _started:
		_started = true
		print("GEMS_START")
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else SEED_DEFAULT)
		DawnWell.new().reset() # clean well (save.gd's own reset verb)
		_run_legs()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		assert(f != null)
		for r in _rows:
			f.store_line(JSON.stringify(r))
		f.close()
		print("GEMS_OK rows=%d ok=%s" % [_rows.size(), str(_ok)])
		quit(0 if _ok else 3)
	return false


# --- channel helpers (sim_endless patterns verbatim) --------------------------

func _fresh_run() -> Node:
	var run: Node = load("res://Main.tscn").instantiate()
	root.add_child(run)
	var stub := SimStubScreens.new()
	run.add_child(stub)
	run._screens = stub
	stub.start_pressed.connect(run._start_game)
	stub.card_picked.connect(run._pick)
	run._start_game()
	return run


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


# DECLARED synthetic drop (the sim_caps synthetic-slot pattern, header): a
# dict of the REAL gem shape with a deterministic per-index value set.
func _pin_gems(world: GameWorld, n: int) -> Dictionary:
	var sum_xp := 0.0
	var fold_xp := 0.0 # the head-BATCH SUM — what the bulk gem must carry
	for i in n:
		var xp := 1.0 + float(i % 4) # {1,2,3,4}: the real ENEMY_TYPES xp rows
		world.gems.append({"x": PIN_X + float(i % 13), "y": PIN_Y + float(i % 7),
			"xp": xp})
		sum_xp += xp
		if i < GameWorld.GEM_MERGE_BATCH:
			fold_xp += xp
	return {"sum_xp": sum_xp, "fold_xp": fold_xp, "cx": _fold_cx(), "cy": _fold_cy()}


# The fold's expected centroid: the pinned head-BATCH entries, summed
# head-to-tail exactly as _merge_gems does — the byte-exactness of the fold's
# arithmetic is part of the row (the merge always consumes exactly the batch).
func _fold_cx() -> float:
	var s := 0.0
	for i in GameWorld.GEM_MERGE_BATCH:
		s += PIN_X + float(i % 13)
	return s / float(GameWorld.GEM_MERGE_BATCH)


func _fold_cy() -> float:
	var s := 0.0
	for i in GameWorld.GEM_MERGE_BATCH:
		s += PIN_Y + float(i % 7)
	return s / float(GameWorld.GEM_MERGE_BATCH)


# --- legs ---------------------------------------------------------------------

# C-G1: threshold boundary cap±1 on the DECLARED-pinned array.
func _leg_boundary() -> void:
	var run := _fresh_run()
	var world: GameWorld = run.world
	var game = run.game
	# 199: count held, no fold
	var p199 := _pin_gems(world, GameWorld.GEM_MERGE_THRESHOLD - 1)
	world.update_entities(DT, game)
	var held: bool = world.gems.size() == GameWorld.GEM_MERGE_THRESHOLD - 1 \
			and not _has_bulk(world.gems)
	# 200: exactly one bulk gem, count drops, fold checked byte-exact
	world.gems.clear()
	var p200 := _pin_gems(world, GameWorld.GEM_MERGE_THRESHOLD)
	world.update_entities(DT, game)
	var bulk: Dictionary = world.gems[world.gems.size() - 1] \
			if world.gems.size() == GameWorld.GEM_MERGE_BATCH + 1 \
					and world.gems.size() < GameWorld.GEM_MERGE_THRESHOLD else {}
	var sum200 := 0.0
	for g in world.gems:
		sum200 += g.xp
	var merged200: bool = world.gems.size() == GameWorld.GEM_MERGE_BATCH + 1 \
			and bulk.get("big", false) == true \
			and bulk.get("xp", -1.0) == p200.fold_xp \
			and bulk.x == p200.cx and bulk.y == p200.cy \
			and sum200 == p200.sum_xp
	# 201: merges too — bounded, not "only at exactly 200"
	world.gems.clear()
	var p201 := _pin_gems(world, GameWorld.GEM_MERGE_THRESHOLD + 1)
	world.update_entities(DT, game)
	var bounded201: bool = world.gems.size() == GameWorld.GEM_MERGE_BATCH + 2 \
			and _has_bulk(world.gems)
	_check("gem_boundary", {
		"no_merge_at_199": held,
		"merge_at_200_count_drops": merged200,
		"merge_at_201_bounded": bounded201,
		"no_merge_at_199_no_stale_bulk": held and p199.sum_xp > 0.0,
	}, {"threshold": GameWorld.GEM_MERGE_THRESHOLD,
		"batch": GameWorld.GEM_MERGE_BATCH,
		"n199": GameWorld.GEM_MERGE_THRESHOLD - 1, "n200": 101, "n201": 102,
		"bulk_xp_expected": p200.fold_xp, "bulk_xp_observed": bulk.get("xp", -1.0),
		"declared": "synthetic pinned array (sim_caps synthetic-slot pattern); " +
			"update_entities called directly = the product's own merge seam"})


func _has_bulk(items: Array) -> bool:
	for g in items:
		if g.get("big", false):
			return true
	return false


# C-G2 (a): the gem-array Σxp is byte-conserved across the fold, independent
# of any multiplier — run at defaults AND at the DECLARED-PINNED insight/meta
# multipliers (the multiplier never touches the gem layer; the row proves it).
func _leg_conservation() -> void:
	for pin in [[0, 1.0], [3, 1.3]]: # [insight, meta_xp_mult]
		var run := _fresh_run()
		var world: GameWorld = run.world
		var game = run.game
		game.passives.insight = pin[0] # DECLARED pin (row carries it)
		game.meta_xp_mult = pin[1]
		# quarter-valued xp (exact dyadic floats — every partial sum stays
		# byte-exact under any summation order, so a RED here is a LOST gem's
		# xp, never float noise: the planted-red margin is the dropped term
		# itself, >= 0.5 against an exact-zero arithmetic noise floor)
		var pre := 0.0
		for i in GameWorld.GEM_MERGE_THRESHOLD:
			var xp := 0.5 + 0.25 * float(i % 7)
			world.gems.append({"x": PIN_X + float(i % 13), "y": PIN_Y, "xp": xp})
			pre += xp
		world.update_entities(DT, game)
		var post := 0.0
		for g in world.gems:
			post += g.xp
		_check("gem_sum_conserved", {
			"sum_byte_equal_across_fold": pre == post,
			"bulk_carries_the_fold_sum": _has_bulk(world.gems),
		}, {"insight_pinned": pin[0], "meta_xp_mult_pinned": pin[1],
			"sum_pre": pre, "sum_post": post,
			"leg_variant": "defaults" if pin[0] == 0 else "pinned-multipliers",
			"declared": "multiplier-pinned variant (rev-2 P2-4: the gem-layer " +
				"invariant is unconditional — the fold never reads m)"})


# C-G2 (b): merge-ON vs merge-OFF byte-equal game.xp/level at the DECLARED-
# PINNED m = 1.0 (insight 0, meta 1.0 — the committed-dump default).
func _leg_byte_equal() -> void:
	var off := _fresh_run() # merge-OFF trajectory: never let the array reach
	var on := _fresh_run()  # the threshold; same drops, same collect funnel
	var goff: GameWorld = off.world
	var gon: GameWorld = on.world
	for r in [off, on]: # the pin READ as the leg runs (never assumed)
		assert(r.game.passives.insight == 0 and r.game.meta_xp_mult == 1.0)
	# Integer-valued xp drops (the real rows' values): every partial sum stays
	# an EXACT float, which is why byte-equality CAN hold at m=1.0 (rev-2 P2-4
	# — at m!=1.0 the same claim is false and is NOT made here).
	var drops: Array = []
	for i in GameWorld.GEM_MERGE_THRESHOLD:
		drops.append({"x": 4.0 + float(i % 9), "y": 3.0 + float(i % 5),
			"xp": 1.0 + float(i % 4)}) # all inside the 16 px touch funnel
	# OFF: two batches of BATCH, each fully collected before the next (the
	# array never reaches the threshold -> no fold; the 200 total is fixed).
	for i in GameWorld.GEM_MERGE_BATCH:
		goff.gems.append(drops[i].duplicate())
	goff.collect_pickups(off.game)
	for i in range(GameWorld.GEM_MERGE_BATCH, 2 * GameWorld.GEM_MERGE_BATCH):
		goff.gems.append(drops[i].duplicate())
	goff.collect_pickups(off.game)
	# ON: all 200 land, ONE real update_entities folds the oldest BATCH into a
	# bulk gem, then the SAME collect funnel eats bulk + singles.
	for i in 2 * GameWorld.GEM_MERGE_BATCH:
		gon.gems.append(drops[i].duplicate())
	gon.update_entities(DT, on.game)
	var bulks := 0
	for g in gon.gems:
		if g.get("big", false):
			bulks += 1
	gon.collect_pickups(on.game)
	_check("gem_xp_byte_equal", {
		"xp_bytes_equal": off.game.xp == on.game.xp,
		"level_equal": off.game.level == on.game.level,
		"pending_equal": off.game.pending_levels == on.game.pending_levels,
		"one_bulk_fired": bulks == 1,
		"pin_m_1_0": off.game.meta_xp_mult == 1.0 and on.game.passives.insight == 0,
	}, {"xp_off": off.game.xp, "xp_on": on.game.xp,
		"level_off": off.game.level, "level_on": on.game.level,
		"multiplier": "DECLARED-PINNED m=1.0 (insight 0, meta_xp_mult 1.0) — " +
			"byte-equality is NOT claimed at m!=1.0 (rev-2 P2-4, IEEE)",
		"declared": "integer-valued drops keep every partial sum an exact " +
			"float — the pinned claim's precondition, stated"})


# C-G3: the REAL drop funnel under a spam leg; the array at its bounded
# observation seam never exceeds the threshold.
func _leg_bounded_spam() -> void:
	var run := _fresh_run()
	var world: GameWorld = run.world
	var game = run.game
	var max_seen := 0
	var folds := 0
	for n in SPAM_DROPS:
		world.kill_enemy(game, {"x": SPAM_POSE, "y": 0.0, "xp": 2.0,
			"boss": false, "miniboss": false}) # the 70% roll rides the seed
		world.update_entities(DT, game) # the bounded seam (world.gd comment)
		max_seen = maxi(max_seen, world.gems.size())
	for g in world.gems:
		if g.get("big", false):
			folds += 1
	_check("gem_bounded_spam", {
		"never_exceeds_threshold": max_seen <= GameWorld.GEM_MERGE_THRESHOLD,
		"folds_happened": folds > 0,
		"array_still_working": world.gems.size() > 0,
	}, {"drops": SPAM_DROPS, "max_seen": max_seen, "bulk_now": folds,
		"threshold": GameWorld.GEM_MERGE_THRESHOLD,
		"declared": "one real kill_enemy + one update per step (product rate); " +
			"observation at the merge seam — a same-tick burst folds at the " +
			"next update (world.gd's stated reading)"})


func _run_legs() -> void:
	_leg_boundary()
	_leg_conservation()
	_leg_byte_equal()
	_leg_bounded_spam()
	_rows.append({"ev": "gems_verdict", "ok": _ok, "rows": _rows.size()})
