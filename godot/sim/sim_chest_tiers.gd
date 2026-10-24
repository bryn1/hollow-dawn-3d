# CHEST-TIER legs for M2 pillar B (MC 11239, T-M2t; M2-SPEC rev-2 §B.3
# ACCEPT rows B-T1..B-T5 — B-T5 is the pixel row, tools/chest_pixel_gate.py).
# Same headless funnel as sim_endless/sim_evolve: the REAL Main.tscn, screens
# stubbed (SimStubScreens), every run started through the real _start_game.
# Construction channel: the DECLARED-PIN pattern (sim_boss/sim_evolve precedent
# — flag row + clock pins, never hidden). Seed-pinned (HD3D_SEED, default
# 11239) so the dump is byte-stable; the committed copy
# tests/fixtures/chests-tiers-m2.jsonl gates tests/test_chests_tiers.py.
# ROWS (row-id -> the ACCEPT row it pins):
#   chest_tier_drop            B-T1: REAL kill_enemy drop funnel — boss kill ->
#       tier == CHEST_TIER_BY_SOURCE["warden"], 200 synthetic miniboss kills ->
#       EVERY dropped chest == map["miniboss"] with 0 < count < kills (the
#       pinned 0.6 roll shape, the sim_boss chest-roll leg), and the real
#       world.cycle_clear drop == map["endless-cycle"] == "dawn" — the SAME
#       map row + tier A-E4 asserts (rev-2 P1 / the DA-P1 law, the unified row
#       is byte-dumped for the pytest cross-fixture leg). The map-bypass
#       planted-red (a drop site hardcoding a tier) reddens boss_ok: the check
#       compares the DUMPED map value, never a second literal.
#   chest_grant x3             B-T2: real collect_pickups open per tier —
#       pending_levels +item_count EXACTLY, offer drain through the real
#       _enter_levelup/_pick seam == item_count offers of 3 cards each, the
#       per-offer cards flavoured by the queued pick kind (weapon offers never
#       draw passives; a gold offer is the untouched bonus_card fill), the gold
#       line credited in the tier range through the ONE credit_gold funnel,
#       queue drained, phase back to playing.
#   chest_pick_weights x3      B-T3: 240 weighted picks per tier under the
#       pinned seed — byte-dumped pick sequence + counts (fixture byte-identity
#       is the determinism leg; every kind with weight > 0 appears).
#   chest_weight_zero          planted-red instrument: a copy row with one kind
#       weighted 0 is picked 200x — the zero kind is NEVER returned (a boundary
#       leak in the walk, the planted `r <= 0`, returns it -> RED).
#   chest_precedence           B-T4: eligible transform + one warden chest at
#       t=601 — EXACTLY ONE weapon transforms (two eligibles, one chest — the
#       "two transforms in one chest" RED instrument), then the FULL tier
#       cards ride (the transform consumes none of them) + gold in range;
#       in-slot/level-kept/cd-reset per the M1e rule. (Union precedence: the
#       try_union-else-try_evolve slot at the ONE open funnel is reserved in
#       world.gd for T-M2u; nothing fires it before that card.)
extends SceneTree

const SEED_DEFAULT := 11239
const DT := 1.0 / 60.0
const GATE_OK_T := 601.0 # strictly past the 600 evolution gate (sim_evolve)
const MB_KILLS := 200 # the pinned-0.6 miniboss roll sample (chest-roll shape)

var _rows: Array = []
var _started := false
var _frames := 0
var _ok := true


func _out_path() -> String:
	var d: String = OS.get_environment("HD3D_CHEST_TIERS_DUMP")
	return d if d != "" else "/tmp/hd3d-chests-tiers-m2.jsonl"


func _process(_delta: float) -> bool:
	_frames += 1
	if not _started:
		_started = true
		print("CHEST_TIERS_START")
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else SEED_DEFAULT)
		DawnWell.new().reset() # clean well (save.gd's own reset verb)
		_run_legs()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		assert(f != null)
		for r in _rows:
			f.store_line(JSON.stringify(r))
		f.close()
		print("CHEST_TIERS_OK rows=%d ok=%s" % [_rows.size(), str(_ok)])
		quit(0 if _ok else 3)
	return false


# --- channel helpers (sim_endless/sim_evolve patterns verbatim) ---------------

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


func _synth_kill(run: Node, boss: bool, mb: bool) -> void:
	# the sim_boss chest-roll-leg shape: xp 0, real flag shape, next to pawn
	var p: Dictionary = run.game.player
	run.world.kill_enemy(run.game, {"x": p.x + 8.0, "y": p.y + 8.0,
		"xp": 0.0, "boss": boss, "miniboss": mb})


func _isolate(run: Node) -> void:
	# DECLARED (the sim_evolve._open precedent): other pickups cleared so the
	# gold delta read at the open is ONLY the chest's own gold line.
	run.world.gems.clear()
	run.world.coins.clear()
	run.world.heals.clear()


# --- legs ---------------------------------------------------------------------

# B-T1 + the unified (DA-P1) row: tiers stamped from the MAP at every drop.
func _leg_drop_map() -> void:
	var run := _fresh_run()
	var game = run.game
	var map: Dictionary = GameWorld.CHEST_TIER_BY_SOURCE
	_synth_kill(run, true, false)
	assert(run.world.chests.size() == 1)
	var boss_tier: String = String(run.world.chests[0]["tier"])
	run.world.reset()
	var mb_tiers := {}
	var mb_chests := 0
	for i in MB_KILLS:
		_synth_kill(run, false, true)
	for c in run.world.chests:
		mb_tiers[String(c["tier"])] = true
	mb_chests = run.world.chests.size()
	run.world.reset()
	run.world.cycle_clear(game) # the real cycle-clear drop funnel (T-M2e)
	var cycle_tier: String = String(run.world.chests[0]["tier"])
	var map_row: String = String(map["endless-cycle"])
	_check("chest_tier_drop", {
		# the checks compare the DUMPED map value — a drop site bypassing the
		# map (the planted-red) flips boss_ok without touching any literal here
		"boss_ok": boss_tier == String(map["warden"]),
		"mb_ok": mb_tiers.keys() == [String(map["miniboss"])] \
				and mb_chests > 0 and mb_chests < MB_KILLS,
		"cycle_ok": cycle_tier == map_row and cycle_tier == "dawn",
		# A-E4/B-T1 same-tier-same-row (rev-2 P1): the byte "dawn" A-E4
		# asserts IS this map row — one row, one tier, both legs.
		"unified_ok": map_row == "dawn" and cycle_tier == "dawn",
	}, {"map": map, "boss_tier": boss_tier, "mb_tiers": mb_tiers.keys(),
		"mb_chests": mb_chests, "mb_kills": MB_KILLS, "cycle_tier": cycle_tier})
	run.queue_free()


# B-T2: the open through the REAL collect funnel + the frozen card seam.
func _leg_grant(tier: String) -> void:
	var run := _fresh_run()
	var game = run.game
	if tier == "ember": # the 0.6 miniboss roll: loop kills until it drops
		var tries := 0
		while run.world.chests.is_empty() and tries < MB_KILLS:
			_synth_kill(run, false, true)
			tries += 1
		assert(not run.world.chests.is_empty() and tries < MB_KILLS)
	elif tier == "warden":
		_synth_kill(run, true, false)
		assert(run.world.chests.size() == 1)
	else:
		run.world.cycle_clear(game)
		assert(run.world.chests.size() == 1)
	var chest: Dictionary = run.world.chests[0]
	assert(String(chest["tier"]) == tier)
	_isolate(run)
	var pending0: int = game.pending_levels
	var gold0: int = game.gold
	game.player.x = chest.x # real touch: the pawn is ON the chest
	var gold_ret: int = run.world.collect_pickups(game)
	game.gold += gold_ret # main.gd's own line (the ONE credit funnel)
	var gold_open: int = game.gold - gold0 # the gold LINE read AT the open —
	# before the drain, whose applied cards may include gold picks (+25 each)
	var row: Dictionary = ChestRewards.TIERS[tier]
	var kinds: Array = game.reward_kinds.duplicate()
	var pending_open: int = game.pending_levels
	# drain through the frozen seam: the FIRST _enter_levelup opens the pause;
	# every further offer is _pick's OWN refill (re-entering the seam would
	# pop the kinds queue twice — the drain reads _current_offer, never
	# re-opens). This is the seam exactly as the shipped game drives it.
	var offers: Array = []
	while game.pending_levels > 0:
		if game.phase != "levelup":
			run._enter_levelup()
		var offer: Array = run._current_offer
		var card_kinds: Array = []
		for c in offer:
			card_kinds.append(String(c["kind"]))
		offers.append(card_kinds)
		run._pick(0)
	var lo: int = int(row["gold_lo"])
	var hi: int = int(row["gold_hi"])
	var flavoured: bool = offers.size() == kinds.size()
	for i in offers.size():
		var kinds_allowed: Array = ["bonus"]
		match String(kinds[i]):
			"weapon":
				kinds_allowed = ["weapon", "upgrade", "bonus"]
			"passive":
				kinds_allowed = ["passive", "bonus"]
		for ck in offers[i]:
			if not kinds_allowed.has(ck):
				flavoured = false
	_check("chest_grant", {
		"pending_exactly_item_count": pending_open == pending0 \
				+ int(row["item_count"]),
		"offers_3_cards": offers.size() == int(row["item_count"]) \
				and offers.all(func(o): return o.size() == 3),
		"offers_flavoured": flavoured,
		"gold_in_range": gold_open >= lo and gold_open <= hi,
		"queue_drained": game.reward_kinds.is_empty() \
				and game.pending_levels == pending0 and game.phase == "playing",
	}, {"tier": tier, "kinds": kinds, "offers": offers,
		"pending_open": pending_open, "pending0": pending0,
		"gold_delta": gold_open, "gold_lo": lo, "gold_hi": hi,
		"item_count": int(row["item_count"])})
	run.queue_free()


# B-T3: the weighted sequence under the pinned seed (fixture = determinism).
func _leg_pick_weights(tier: String) -> void:
	var row: Dictionary = ChestRewards.TIERS[tier]
	var counts := {"weapon": 0, "passive": 0, "gold": 0}
	var seq: Array = []
	for i in 240:
		var k: String = ChestRewards.pick(row)
		counts[k] += 1
		if i < 16:
			seq.append(k)
	var alive_ok: bool = true
	for k in ["weapon", "passive", "gold"]:
		if int(row[k]) > 0 and counts[k] == 0:
			alive_ok = false
	_check("chest_pick_weights", {
		"sum_240": counts["weapon"] + counts["passive"] + counts["gold"] == 240,
		"every_weighted_kind_appears": alive_ok,
	}, {"tier": tier, "counts": counts, "seq": seq})


# planted-red instrument: a zero-weight kind is never returned.
func _leg_weight_zero(kind: String) -> void:
	var weights := {"weapon": 40, "passive": 40, "gold": 20}
	weights[kind] = 0
	var hits := 0
	for i in 200:
		if ChestRewards.pick(weights) == kind:
			hits += 1
	_check("chest_weight_zero", {"never_picked": hits == 0},
		{"kind": kind, "hits": hits, "weights": weights})


# B-T4: the ONE transform lands FIRST, the FULL tier cards ride after it.
func _leg_precedence() -> void:
	var run := _fresh_run()
	var game = run.game
	# DECLARED-PIN construction (sim_boss.gd:215 channel, sim_evolve shape):
	# TWO eligible rows in one loadout — one chest must transform exactly ONE.
	game.weapons = [
		{"id": "talon", "level": 1, "cd": 0.0},
		{"id": "bone-whip", "level": WeaponSystem.MAX_LEVEL, "cd": 0.0},
		{"id": "dart-loop", "level": WeaponSystem.MAX_LEVEL, "cd": 0.0},
	]
	game.passives["cracked-heart"] = 1
	game.passives["iron-wrap"] = 1
	game.time = GATE_OK_T
	_synth_kill(run, true, false) # the real drop funnel -> warden chest
	assert(run.world.chests.size() == 1)
	_isolate(run)
	var gold0: int = game.gold
	var chest: Dictionary = run.world.chests[0]
	game.player.x = chest.x
	var gold_ret: int = run.world.collect_pickups(game)
	game.gold += gold_ret
	var evolved: Array = []
	var in_slot := true
	for i in game.weapons.size():
		var id: String = String(game.weapons[i]["id"])
		if id == "red-wail" or id == "thousand-darts":
			evolved.append(id)
			in_slot = in_slot and game.weapons[i]["level"] \
					== WeaponSystem.MAX_LEVEL and float(game.weapons[i]["cd"]) == 0.0
	var row: Dictionary = ChestRewards.TIERS["warden"]
	var lo: int = int(row["gold_lo"])
	var hi: int = int(row["gold_hi"])
	_check("chest_precedence", {
		# "two transforms in one chest" is the RED this instrument catches
		"exactly_one_transform": evolved.size() == 1,
		"base_removed": not _has_id(game, "bone-whip") \
				or not _has_id(game, "dart-loop"),
		"in_slot_level_kept": in_slot,
		"cards_full_after_transform": game.pending_levels == int(row["item_count"]),
		"gold_in_range": game.gold - gold0 >= lo and game.gold - gold0 <= hi,
	}, {"evolved": evolved, "pending": game.pending_levels,
		"gold_delta": game.gold - gold0, "item_count": int(row["item_count"])})
	run.queue_free()


func _has_id(game, id: String) -> bool:
	for w in game.weapons:
		if w.id == id:
			return true
	return false


func _run_legs() -> void:
	_leg_drop_map()
	_leg_grant("ember")
	_leg_grant("warden")
	_leg_grant("dawn")
	_leg_pick_weights("ember")
	_leg_pick_weights("warden")
	_leg_pick_weights("dawn")
	_leg_weight_zero("weapon")
	_leg_weight_zero("passive")
	_leg_weight_zero("gold")
	_leg_precedence()
	_rows.append({"ev": "chest_tiers_verdict", "ok": _ok, "rows": _rows.size()})
