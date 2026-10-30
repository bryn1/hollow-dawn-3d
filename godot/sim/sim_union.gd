# Union legs for M2-SPEC rev-2 §D (MC 11240, T-M2u). Same headless funnel
# reason: >400 lines — 488 measured at MC 11398 §1 (deferred carry-over): the
#   truth table + FULL legs ARE the one unions dump contract (seed 11240,
#   byte-pinned fixture). NON-ADOPTION declared (MC 11398 §2's copy-vs-couple
#   law): this driver keeps its pre-C3 runner shape (_run/_gate/_emit + own
#   _out/_rows) — C2 (MC 11401) converted ONLY the §2.1 verbatim fresh_run
#   body site at _leg_fire to SimFunnel.fresh_run; the rest is not a copy.
# as sim_evolve (the REUSED pattern, not a second harness): the REAL
# Main.tscn, screens stubbed, the run started through the real
# _start_game, chests PLACED through the real drop funnel (synthetic
# boss-flagged kill, the pinned 1.0 chance) and OPENED by the real
# world.collect_pickups touch funnel — which since M6 T-M6p (MC 11697,
# M6-SPEC §3.1/§4.4 R5) holds the UNION-ONLY chest arm: the evolution
# trigger MOVED to the level-up pick seam, so the rows below drive it via
# SimFunnel.take_trigger_card where the M2-era legs used the second chest.
# Loadouts ride the DECLARED-PIN channel
# (sim_boss/sim_evolve verbatim); the FULL legs acquire EVERY part
# through the real offer funnel (real make_offer cards + real _pick, no
# id pinned) before the real chest performs the union.
# ROWS (truth table + the §D ACCEPT seams):
#   uni_after_<uid>        both bases MAX + passive + t>=600 -> UNION
#                          in-slot (earlier base index), both bases gone,
#                          size -1, level 1, cd 0, reward card granted
#   uni_undermax_<uid>     one base at MAX-1 -> does NOT unite (RED side)
#   uni_no_passive         bases MAX, passive 0 -> does NOT unite
#   uni_wrong_passive      bases MAX, carried NON-partner -> does NOT
#   uni_before_gate        same but t < 600 -> does NOT (RED side)
#   uni_precedence         state eligible for BOTH union and evolution ->
#                          the chest performs the UNION (D-U3); the still-
#                          eligible base then evolves at its NEXT trigger
#                          PICK (T-M6p: the second-chest evolution is
#                          retired with the chest arm — player's choice
#                          still reads honestly: union OR its evolution,
#                          never silently both)
#   uni_reserve_keeps      D-U5 + M6 §3.4: rot-water MAX + loadstone,
#                          partner censer-of-hours carried NOT max -> the
#                          chest does NOT evolve it (nothing evolves at a
#                          chest now) AND the new trigger does NOT either
#                          (dirge-eternal stays reachable); maxing the
#                          partner + one more chest -> the UNION lands
#   uni_reserve_lifted     partner GONE -> reserve lifts: the chest still
#                          evolves NOTHING (the direct arm is dead), the
#                          next trigger PICK evolves the-sluice (the rule
#                          never blocks an unreachable union)
#   uni_full_<uid>         FULL end-to-end: both bases + the partner
#                          acquired by real _picks, real chest opens the
#                          union IN-SLOT, then a capped real-tick watch accrues the first kill
#   uni_fire_<uid>         kill-attribution legs (sim_combat.run_leg
#                          pattern, hp pinned every tick — declared S6
#                          precedent): the union alone in the build,
#                          kills >= 1, and BOTH composed FX branches
#                          observed live (halos+bursts / halos+rings)
# Seed-pinned (HD3D_SEED, default 11240) — the dump is byte-stable; the
# committed copy tests/fixtures/unions-m2u.jsonl gates tests/test_unions.py
# (RE-MINTED at T-M6p — the precedence/reserve legs moved with the trigger,
# M6-SPEC §9 row 5, union side REMINT by this card).
extends SceneTree

const UNION_SEED := 11240
const GATE_OK_T := 601.0 # strictly past EvolutionSystem.GATE_T
const GATE_EDGE_T := 599.0 # its RED side
const FIRE_TICKS := 3600 # 60 sim-s per attribution leg (sim_combat shape)

var _main: Node
var _out: FileAccess
var _rows: Array = []
var _started := false
var _frames := 0
var _ok := true


func _process(_delta: float) -> bool:
	_frames += 1
	if not _started:
		_started = true
		var d: String = OS.get_environment("HD3D_UNION_DUMP")
		_out = FileAccess.open(d if d != "" else "/tmp/hd3d-union-dump.jsonl",
				FileAccess.WRITE)
		assert(_out != null)
		print("UNION_START")
		_run()
	if _frames > 3:
		push_error("union sim did not finish in one frame")
		quit(3)
		return true
	return false


func _run() -> void:
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else UNION_SEED)
	var packed: PackedScene = load("res://Main.tscn")
	_main = packed.instantiate()
	root.add_child(_main)
	var old: CanvasLayer = _main._screens
	_main.remove_child(old)
	old.queue_free()
	var stub := SimStubScreens.new()
	_main.add_child(stub)
	_main._screens = stub
	stub.start_pressed.connect(_main._start_game)
	stub.card_picked.connect(_main._pick)
	_main._start_game()
	# Positive + negative truth-table rows, both TABLE rows (§D.1).
	for uid in UnionSystem.TABLE:
		var row: Dictionary = UnionSystem.TABLE[uid]
		_leg_union(uid, WeaponSystem.MAX_LEVEL, WeaponSystem.MAX_LEVEL, 1,
			GATE_OK_T, "uni_after_" + uid, true)
		_leg_union(uid, WeaponSystem.MAX_LEVEL - 1, WeaponSystem.MAX_LEVEL, 1,
			GATE_OK_T, "uni_undermax_" + uid, false)
		_leg_union(uid, WeaponSystem.MAX_LEVEL, WeaponSystem.MAX_LEVEL, 1,
			GATE_EDGE_T, "uni_before_gate", false)
	_leg_passives()
	_leg_precedence()
	_leg_reserve()
	_run_union_legs()
	_emit({"ev": "union_verdict", "ok": _ok})
	for r in _rows:
		_out.store_line(JSON.stringify(r))
	_out.close()
	print("UNION_OK rows=%d ok=%s" % [_rows.size(), str(_ok)])
	quit(0 if _ok else 3)


func _run_union_legs() -> void:
	for uid in UnionSystem.TABLE:
		_leg_full(uid)
		_leg_fire(uid)


# --- loadout helpers (sim_evolve patterns REUSED, adapted to 2 bases) ------

func _fresh_pair(uid: String, la: int, lb: int, rank: int,
		t: float) -> Dictionary:
	var row: Dictionary = UnionSystem.TABLE[uid]
	var game = _main.game
	game.start_run()
	_main.world.reset()
	game.weapons.append({"id": row.a, "level": la, "cd": 5.0})
	game.weapons.append({"id": row.b, "level": lb, "cd": 5.0})
	game.passives[row.passive] = rank
	game.time = t
	var p: Dictionary = game.player
	_main.world.kill_enemy(game, {"x": p.x + 8.0, "y": p.y + 8.0,
		"xp": 0.0, "boss": true, "miniboss": false,
		# T-M3b keyed drop (strict map law): a synth boss kill fields its
		# TYPE — the warden's map row is what this synth class means.
		"type": "warden"})
	assert(_main.world.chests.size() == 1)
	return {"before": _line(game), "pending0": game.pending_levels}


func _open() -> String:
	var game = _main.game
	var p: Dictionary = game.player
	var c: Dictionary = _main.world.chests[0]
	p.x = c.x
	p.y = c.y
	_main.world.collect_pickups(game)
	assert(_main.world.chests.size() == 0)
	return _line(game)


func _drop_chest(game) -> void:
	var p: Dictionary = game.player
	_main.world.kill_enemy(game, {"x": p.x + 8.0, "y": p.y + 8.0,
		"xp": 0.0, "boss": true, "miniboss": false,
		# T-M3b keyed drop (strict map law): a synth boss kill fields its
		# TYPE — the warden's map row is what this synth class means.
		"type": "warden"})


func _line(game) -> String:
	var parts: Array = []
	for w in game.weapons:
		parts.append("%s-%d-%s" % [w.id, w.level, str(int(w.cd * 1000.0))])
	return " ".join(parts)


func _has_id(game, id: String) -> bool:
	for w in game.weapons:
		if w.id == id:
			return true
	return false


func _entry_at(game, id: String, idx: int, level: int) -> bool:
	for i in game.weapons.size():
		if game.weapons[i].id == id:
			if i != idx:
				return false
			return game.weapons[i].level == level \
					and float(game.weapons[i].cd) == 0.0
	return false


# --- truth-table legs --------------------------------------------------------

# One scripted chest against a two-base loadout; expect_union decides the
# checks (the D-U2 RED side is the same leg at MAX-1 / rank 0 / t 599).
func _leg_union(uid: String, la: int, lb: int, rank: int, t: float,
		leg_name: String, expect_union: bool) -> void:
	var row: Dictionary = UnionSystem.TABLE[uid]
	_rows.append({"ev": "union_leg", "leg": leg_name, "uid": uid,
		"a": row.a, "la": la, "b": row.b, "lb": lb, "passive": row.passive,
		"rank": rank, "t": t, "gate": EvolutionSystem.GATE_T})
	var game = _main.game
	var before: Dictionary = _fresh_pair(uid, la, lb, rank, t)
	var after := _open()
	var checks := {
		"unioned": _has_id(game, uid) == expect_union,
		# the maxed base is gone too when the union landed; when it did
		# not, BOTH bases stand (nothing else may eat them: halo/spike
		# are NOT evolution bases, the D-U2 claim).
		"bases_gone": (not _has_id(game, row.a) and not _has_id(game, row.b)) \
				if expect_union else (_has_id(game, row.a) and _has_id(game, row.b)),
		# slot math (D-U2): talon + the pair = 3 before; a union lands at
		# NET -1 (2 kept); a refusal keeps all three (never a 7th, ever).
		"slot_count": game.weapons.size() == (2 if expect_union else 3),
		# one chest = one card grant (T-M2t row: the warden chest pays
		# its tier's item_count through the ONE frozen seam)
		"reward_card": game.pending_levels == int(before["pending0"]) \
				+ ChestRewards.TIERS["warden"].item_count,
	}
	if expect_union:
		checks["in_slot"] = _entry_at(game, uid, 1, 1) # earlier base's slot
	_gate(leg_name, before, after, t, checks,
			"scripted chest, real open funnel (§D.1 in-slot rule)")


# D-U4 both sides: bases MAX, passive ABSENT vs carried-but-wrong.
func _leg_passives() -> void:
	var game = _main.game
	for case in [[0, "uni_no_passive"], [3, "uni_wrong_passive"]]:
		var rank: int = case[0]
		var uid: String = "requiem-toll"
		var row: Dictionary = UnionSystem.TABLE[uid]
		_rows.append({"ev": "union_leg", "leg": case[1], "uid": uid,
			"a": row.a, "la": WeaponSystem.MAX_LEVEL, "b": row.b,
			"lb": WeaponSystem.MAX_LEVEL, "passive": "ward", "rank": rank,
			"t": GATE_OK_T, "gate": EvolutionSystem.GATE_T})
		game.start_run()
		_main.world.reset()
		game.weapons.append({"id": row.a, "level": WeaponSystem.MAX_LEVEL,
			"cd": 5.0})
		game.weapons.append({"id": row.b, "level": WeaponSystem.MAX_LEVEL,
			"cd": 5.0})
		if rank > 0:
			game.passives["ward"] = rank # carried, NOT the recipe passive
		game.time = GATE_OK_T
		var before := _line(game)
		_drop_chest(game)
		var after := _open()
		_gate(case[1], {"before": before}, after, GATE_OK_T, {
			"no_union": not _has_id(game, uid),
			"bases_kept": _has_id(game, row.a) and _has_id(game, row.b),
			"recipe_passive_untouched": int(game.passives[row.passive]) == 0,
		}, "carried rule = the RECIPE passive (evolutions carried-rule shape)")


# D-U3 + M6 T-M6p (MC 11697): eligible for union AND evolution at once ->
# the chest takes the UNION and NOTHING else (the direct evolve arm is
# retired, §4.4 R5); the other base evolves at its NEXT trigger PICK — the
# player's choice still reads honestly: union OR its evolution, never
# silently both.
func _leg_precedence() -> void:
	var game = _main.game
	game.start_run()
	_main.world.reset()
	game.weapons.append({"id": "halo", "level": WeaponSystem.MAX_LEVEL,
		"cd": 5.0})
	game.weapons.append({"id": "spike", "level": WeaponSystem.MAX_LEVEL,
		"cd": 5.0})
	game.weapons.append({"id": "bone-whip", "level": WeaponSystem.MAX_LEVEL,
		"cd": 5.0})
	game.passives["insight"] = 1
	game.passives["cracked-heart"] = 1
	game.time = GATE_OK_T
	_rows.append({"ev": "union_leg", "leg": "uni_precedence",
		"uid": "requiem-toll", "a": "halo", "b": "spike",
		"passive": "insight", "evo_base": "bone-whip",
		"t": GATE_OK_T, "gate": EvolutionSystem.GATE_T})
	var before := _line(game)
	_drop_chest(game)
	var after1 := _open()
	var one_ok: bool = _has_id(game, "requiem-toll") \
			and not _has_id(game, "red-wail") \
			and _has_id(game, "bone-whip")
	# M6 T-M6p: the second chest is replaced by ONE trigger-eligible pick
	# through the real funnel (SimFunnel.take_trigger_card — PASSIVE card,
	# zero id pinned): the evolution now rides the pick seam.
	var pick_applied := SimFunnel.take_trigger_card(_main, [])
	var after2 := _line(game)
	_gate("uni_precedence", {"before": before}, [after1, after2],
		GATE_OK_T, {
			"first_chest_union": one_ok,
			"pick_evolution": pick_applied and _has_id(game, "red-wail") \
					and _has_id(game, "requiem-toll"),
			"one_transform_per_seam": after1.split(" ").size() == 3 \
					and after2.split(" ").size() == 3, # slot math: 4 entries
			# -> 3 after the UNION (net -1) -> 3 after the EVOLUTION
			# (in-slot replace keeps the count)
		}, "union precedence > evolution (spec §Reuse; chest arm union-only " \
				+ "since T-M6p); the eligible base evolves at its next pick")


# D-U5: the rev-2 P3-6 reserve rule, BOTH sides.
func _leg_reserve() -> void:
	var game = _main.game
	game.start_run()
	_main.world.reset()
	game.weapons.append({"id": "censer-of-hours", "level": WeaponSystem.MAX_LEVEL - 1,
		"cd": 5.0})
	game.weapons.append({"id": "rot-water", "level": WeaponSystem.MAX_LEVEL,
		"cd": 5.0})
	game.passives["loadstone"] = 1
	game.time = GATE_OK_T
	_rows.append({"ev": "union_leg", "leg": "uni_reserve_keeps",
		"uid": "dirge-eternal", "a": "censer-of-hours", "b": "rot-water",
		"passive": "loadstone", "t": GATE_OK_T,
		"gate": EvolutionSystem.GATE_T})
	var before := _line(game)
	_drop_chest(game)
	var after1 := _open()
	var kept_ok: bool = _has_id(game, "rot-water") \
			and not _has_id(game, "the-sluice") \
			and not _has_id(game, "dirge-eternal")
	# M6 T-M6p (MC 11697, §3.4): the REAL reserve test at the NEW trigger —
	# one trigger-eligible pick must NOT evolve the reserved base while the
	# partner is below MAX (the chest arm no longer evolves anything, so the
	# kept-check above alone would be vacuous; this pick makes the row bite
	# again — planted red: reserve skipped ⇒ the-sluice appears here).
	var pick_applied := SimFunnel.take_trigger_card(_main, ["loadstone"])
	var after_pick := _line(game)
	# partner MAXED (in-slot, declared pin write — the sim's own channel)
	# + one more chest -> dirge-eternal is still REACHABLE and lands.
	for w in game.weapons:
		if w.id == "censer-of-hours":
			w.level = WeaponSystem.MAX_LEVEL
	_drop_chest(game)
	var after2 := _open()
	_gate("uni_reserve_keeps", {"before": before}, [after1, after_pick, after2],
		GATE_OK_T, {
			"reserved_base_not_evolved": kept_ok,
			"trigger_pick_keeps": pick_applied \
					and not _has_id(game, "the-sluice"),
			"union_still_reachable": _has_id(game, "dirge-eternal"),
		}, "rev-2 P3-6 + M6 §3.4: neither the chest nor the new trigger may " \
				+ "foreclose a reachable union; maxing the partner then " \
				+ "chesting -> the union fires")
	# The LIFT side: partner GONE (never carried here) -> the reserve lifts.
	# M6 T-M6p re-home: the chest evolves NOTHING (direct arm retired,
	# PS-E3) — the next trigger PICK carries the evolution.
	game.start_run()
	_main.world.reset()
	game.weapons.append({"id": "rot-water", "level": WeaponSystem.MAX_LEVEL,
		"cd": 5.0})
	game.passives["loadstone"] = 1
	game.time = GATE_OK_T
	_rows.append({"ev": "union_leg", "leg": "uni_reserve_lifted",
		"uid": "dirge-eternal", "b": "rot-water", "passive": "loadstone",
		"t": GATE_OK_T, "gate": EvolutionSystem.GATE_T})
	var before2 := _line(game)
	_drop_chest(game)
	var after_chest := _open()
	# snapshot BEFORE the pick: the base must survive the chest (the direct
	# arm dead) — evaluated after the pick it would read the evolved state.
	var chest_inert: bool = not _has_id(game, "the-sluice") \
			and _has_id(game, "rot-water")
	var pick2 := SimFunnel.take_trigger_card(_main, [])
	var after3 := _line(game)
	_gate("uni_reserve_lifted", {"before": before2}, [after_chest, after3],
		GATE_OK_T, {
			"chest_inert_direct_arm": chest_inert,
			"evolution_proceeds": pick2 and _has_id(game, "the-sluice") \
					and not _has_id(game, "rot-water"),
		}, "partner gone = union unreachable = reserve lifts at the NEW " \
				+ "trigger; the chest arm stays inert (PS-E3 direct twin)")


# FULL legs: every part ACQUIRED through the real offer funnel (no id
# pinned), the real chest lands the union IN-SLOT, then 60 real ticks
# accrue kills (the union + talon are the build — accrual, not pure
# attribution; the pure rows are uni_fire_*).
func _leg_full(uid: String) -> void:
	var row: Dictionary = UnionSystem.TABLE[uid]
	_rows.append({"ev": "union_leg", "leg": "uni_full_" + uid, "uid": uid,
		"a": row.a, "b": row.b, "passive": row.passive,
		"t": GATE_OK_T, "gate": EvolutionSystem.GATE_T})
	var game = _main.game
	game.start_run()
	_main.world.reset()
	var acquired_rank := 0
	var slot_a := -1
	var slot_b := -1
	for i in 1600: # seed-pinned RNG: terminates on this seed; else leg REDs
		var la := _level_of(game, row.a)
		var lb := _level_of(game, row.b)
		acquired_rank = int(game.passives[row.passive])
		if la >= WeaponSystem.MAX_LEVEL and lb >= WeaponSystem.MAX_LEVEL \
				and acquired_rank >= 1:
			for j in game.weapons.size():
				if game.weapons[j].id == row.a:
					slot_a = j
				elif game.weapons[j].id == row.b:
					slot_b = j
			break
		game.pending_levels = 1
		_main._enter_levelup()
		var pick := -1
		for c in _main._current_offer.size():
			var card: Dictionary = _main._current_offer[c]
			var k: String = card.kind
			if (k == "weapon" and (card.id == row.a or card.id == row.b)) \
					or (k == "passive" and card.key == row.passive) \
					or (k == "upgrade" and (card.id == row.a or card.id == row.b)):
				pick = c
				break
		if pick < 0:
			game.pending_levels = 0
			game.set_phase("playing") # decline (sim_boss._decline pattern)
		else:
			_main._pick(pick)
	var acquired := _line(game)
	game.time = GATE_OK_T
	_drop_chest(game)
	var after := _open()
	var slot := mini(slot_a, slot_b)
	# in-slot claim checked NOW (before any tick runs): the union's own
	# orbit branch decrements cd from the very first _step — the in-slot
	# row is about the WRITTEN entry (level 1, cd 0), not a later frame.
	var in_slot := _entry_at(game, uid, slot, 1)
	var bases_gone := not _has_id(game, row.a) and not _has_id(game, row.b)
	var kills0: int = game.kills
	for s in 600: # real ticks, capped watch for the union's first kill
		if game.phase == "levelup":
			game.pending_levels = 0
			game.set_phase("playing") # DECLINED: keep the union build pure
		if game.phase != "playing":
			break
		game.hp = game.max_hp # DECLARED pin (S6/sim_boss kill-leg precedent)
		_main._step(1.0 / 60.0)
		if game.kills > kills0:
			break # accrual proven; determinism is the seed + fixed cap
	_gate("uni_full_" + uid,
		{"before": "canonical run", "acquired": acquired},
		after, GATE_OK_T, {
			"a_acquired_by_pick": _level_of_line(acquired, row.a) \
					>= WeaponSystem.MAX_LEVEL,
			"b_acquired_by_pick": _level_of_line(acquired, row.b) \
					>= WeaponSystem.MAX_LEVEL,
			"passive_acquired_by_pick": acquired_rank >= 1,
			"union_in_slot": in_slot,
			"bases_gone": bases_gone,
			"kills_accrued": game.kills > kills0,
		}, "FULL: every entry acquired by real _pick (no id pinned); " \
				+ "off-target offers DECLINED; kills ACCRUE (talon rides " \
				+ "the build — pure attribution is uni_fire_*)")


# Kill-attribution legs (sim_combat.run_leg pattern REUSED): the union
# ALONE in the build (DECLARED pin), hp pinned every tick (declared), the
# real _step loop spawns the horde. kills >= 1 can only be the union's.
func _leg_fire(uid: String) -> void:
	# MC 11401 C2: the 6-line fresh_run body copy converted to the ONE seam
	# (audit MC 11398 §2.1). The in-loop levelup-decline below stays the
	# donor's verbatim body — named at the header, not a second helper.
	var run: Node = SimFunnel.fresh_run(root)
	run.game.weapons = [{"id": uid, "level": WeaponSystem.MAX_LEVEL,
		"cd": 0.0}] # DECLARED pin: the union alone (sim_combat channel)
	var max_halos := 0
	var max_bursts := 0
	var max_rings := 0
	for s in FIRE_TICKS:
		if run.game.phase == "levelup":
			run.game.pending_levels = 0
			run.game.set_phase("playing") # keep one weapon only
		if run.game.phase != "playing":
			break
		run.game.hp = run.game.max_hp # DECLARED pin (S6 precedent row)
		run._step(1.0 / 60.0)
		var sim = run.fx # the ONE WeaponSystem instance (main.gd:22)
		max_halos = maxi(max_halos, sim.halos.size())
		max_bursts = maxi(max_bursts, sim.bursts.size())
		max_rings = maxi(max_rings, sim.rings.size())
	var fx_branches := {"halos_observed": max_halos,
		"bursts_observed": max_bursts, "rings_observed": max_rings}
	var branches_ok: bool = max_halos >= 1 \
			and (max_bursts >= 1 if uid == "requiem-toll" else max_rings >= 1)
	_gate("uni_fire_" + uid, {"before": uid + " alone @ MAX"},
		{"kills": run.game.kills, "t": snappedf(run.game.time, 0.001)},
		run.game.time, {
			"kills_attributed": run.game.kills >= 1, # the union is the ONLY weapon
			"composed_branches_live": branches_ok, # §D rows: halos+bursts / +rings
		}, "sim_combat.run_leg channel (DECLARED: hp pinned every tick, S6 " \
				+ "kill-leg precedent); no other weapon can claim a kill")
	run.queue_free()


func _level_of(game, id: String) -> int:
	for w in game.weapons:
		if w.id == id:
			return w.level
	return -1


func _level_of_line(line: String, id: String) -> int:
	for part in line.split(" "):
		if part.begins_with(id + "-"):
			return int(part.split("-")[id.split("-").size()])
	return -1


func _gate(leg_name: String, before, after, t: float, checks: Dictionary,
		note: String) -> void:
	var leg_ok := true
	for k in checks:
		if not checks[k]:
			leg_ok = false
	_ok = _ok and leg_ok
	_emit({"ev": "union_gate", "leg": leg_name, "before": before,
		"after": after, "t": t, "checks": checks, "note": note,
		"ok": leg_ok})


func _emit(row: Dictionary) -> void:
	_rows.append(row)
