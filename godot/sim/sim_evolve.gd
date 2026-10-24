# Chest-open + evolution legs for M1 feature 5 (MC 11209, T-M1e; PARITY-
# ROADMAP rev3 feature 5 ACCEPT rows). Same headless funnel as sim_caps/
# sim_boss: the REAL Main.tscn, screens stubbed, the run started through the
# real _start_game. Loadouts ride the DECLARED-PIN construction channel
# (the sim_boss.gd:215 channel sim_caps names verbatim) — since T-M1h
# (MC 11220) the 10 base weapons + 10 partner passives are REAL roster
# entries (weapons.gd IDS / levelup.gd PASSIVES); the pins stay for
# DETERMINISM, not for reachability (brief: DECLARED-pin channel per
# sim_boss:215). Two M1h legs: evo_pool_reachability proves the ONE pool
# source (LevelUpDeck.build_pool) now offers every table base AND its
# partner (the "sim can now acquire both parts" row — pool read, zero RNG);
# evo_full_evolve lands 3 FULL evolutions end-to-end through the REAL
# offer funnel (every weapon/passive/upgrade entry taken by a real _pick —
# no id pinned at all — bone-whip, rot-water, doom-sigil; all ten rows
# were runtime-dead before T-M1h), then the real chest-open evolution.
# Chests are PLACED THROUGH THE REAL DROP FUNNEL: a synthetic boss-flagged
# kill dict (xp 0, real flag shape — the sim_boss chest-roll-leg shape) dies
# by world.kill_enemy next to the pawn; CHEST_CHANCE_BOSS 1.0 short-circuits
# the roll (T-M1d's pinned chance — the legs RIDE the existing counts, no
# new RNG mechanism). The OPEN itself is the real world.collect_pickups —
# the one touch funnel main.gd drives (declared: called directly, same
# call site as main.gd:190). Card phase rows drive the real _enter_levelup/
# _pick seam. Truth-table rows (roadmap "rule truth-table" + planted-red):
#   evo_max_partner_after      MAX + partner + t>=600  -> EVOLVES (in-slot,
#                              level kept, cd reset, slot count unchanged)
#   evo_max_partner_before     same but t < 600        -> does NOT (RED side)
#   evo_underlevel_partner     L7 + partner            -> does NOT
#   evo_max_nopartner          MAX, partner 0          -> does NOT
#   evo_max_wrong_passive      MAX + carried NON-partner passive -> does NOT
#   evo_partner_any_rank       partner rank 3          -> EVOLVES ("any rank")
#   evo_non_table_weapon       talon L8 + a partner    -> does NOT
#   evo_all_ten_rows           every TABLE row end-to-end
#   evo_one_per_chest          two eligibles + one chest -> exactly ONE (the
#                              stated reading, evolutions.gd header); a
#                              second chest evolves the second
#   evo_card_seam              chest-open raises pending_levels and the REAL
#                              levelup seam opens (offer non-empty) and
#                              _pick returns to playing — the ONE phase seam,
#                              no parallel UI; both chest legs also assert
#                              the reward card is granted (pending +1) even
#                              when nothing evolves (fallback path stays).
# Seed-pinned (HD3D_SEED, default 11209) — the dump is byte-stable; the
# committed copy tests/fixtures/chests-evolve-m1e.jsonl gates
# tests/test_chests_evolve.py.
extends SceneTree

const GATE_OK_T := 601.0 # strictly past the 600 gate
const GATE_EDGE_T := 599.0 # strictly before it (planted-red side)
const PIN_T_BASE := "bone-whip"
const PIN_T_PARTNER := "cracked-heart"
const PIN_T_EVO := "red-wail" # cross-checked against TABLE by the pytest side
const EVOLVE_SEED := 11209

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
		var d: String = OS.get_environment("HD3D_EVOLVE_DUMP")
		_out = FileAccess.open(d if d != "" else "/tmp/hd3d-evolve-dump.jsonl",
				FileAccess.WRITE)
		assert(_out != null)
		print("EVOLVE_START")
		_run()
	if _frames > 3:
		push_error("evolve sim did not finish in one frame")
		quit(3)
		return true
	return false


func _run() -> void:
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else EVOLVE_SEED)
	var packed: PackedScene = load("res://Main.tscn")
	_main = packed.instantiate()
	root.add_child(_main) # _ready wires the real scene + bridge (S3 pattern)
	var old: CanvasLayer = _main._screens
	_main.remove_child(old)
	old.queue_free()
	var stub := SimStubScreens.new()
	_main.add_child(stub)
	_main._screens = stub
	stub.start_pressed.connect(_main._start_game)
	stub.card_picked.connect(_main._pick)
	_main._start_game()
	_leg_single(PIN_T_BASE, WeaponSystem.MAX_LEVEL, PIN_T_PARTNER, 1,
		GATE_OK_T, "evo_max_partner_after", true)
	_leg_single(PIN_T_BASE, WeaponSystem.MAX_LEVEL, PIN_T_PARTNER, 1,
		GATE_EDGE_T, "evo_max_partner_before", false)
	_leg_single(PIN_T_BASE, WeaponSystem.MAX_LEVEL - 1, PIN_T_PARTNER, 1,
		GATE_OK_T, "evo_underlevel_partner", false)
	_leg_single(PIN_T_BASE, WeaponSystem.MAX_LEVEL, PIN_T_PARTNER, 0,
		GATE_OK_T, "evo_max_nopartner", false)
	_leg_single(PIN_T_BASE, WeaponSystem.MAX_LEVEL, "ward", 3,
		GATE_OK_T, "evo_max_wrong_passive", false)
	_leg_single(PIN_T_BASE, WeaponSystem.MAX_LEVEL, PIN_T_PARTNER, 3,
		GATE_OK_T, "evo_partner_any_rank", true)
	_leg_single("talon", WeaponSystem.MAX_LEVEL, PIN_T_PARTNER, 1,
		GATE_OK_T, "evo_non_table_weapon", false)
	_leg_all_ten()
	_leg_one_per_chest()
	_leg_card_seam()
	_leg_pool_reachability()
	_leg_full_evolve("bone-whip")
	_leg_full_evolve("rot-water")
	_leg_full_evolve("doom-sigil")
	_emit({"ev": "evolve_verdict", "ok": _ok})
	for r in _rows:
		_out.store_line(JSON.stringify(r))
	_out.close()
	print("EVOLVE_OK rows=%d ok=%s" % [_rows.size(), str(_ok)])
	quit(0 if _ok else 3)


# --- the one chest-open funnel -----------------------------------------------

func _fresh(base_id: String, level: int, partner: String, rank: int,
		t: float) -> Dictionary:
	# Canonical start, then the DECLARED-PIN loadout: talon L1 stays the
	# first slot (the table never matches it), the pin weapon follows.
	var game = _main.game
	game.start_run()
	_main.world.reset()
	game.weapons.append({"id": base_id, "level": level, "cd": 5.0})
	game.passives[partner] = rank
	game.time = t
	# Chest through the REAL drop funnel: a boss-flagged synthetic kill next
	# to the pawn; the pinned 1.0 chance guarantees the drop (declared).
	var p: Dictionary = game.player
	_main.world.kill_enemy(game, {"x": p.x + 8.0, "y": p.y + 8.0,
		"xp": 0.0, "boss": true, "miniboss": false})
	assert(_main.world.chests.size() == 1)
	return {"before": _line(game), "pending0": game.pending_levels}


func _open() -> String:
	# The one open site: pawn stepped onto the chest, real touch funnel.
	var game = _main.game
	var p: Dictionary = game.player
	var c: Dictionary = _main.world.chests[0]
	p.x = c.x
	p.y = c.y
	_main.world.collect_pickups(game)
	assert(_main.world.chests.size() == 0)
	return _line(game)


func _line(game) -> String:
	var parts: Array = []
	for w in game.weapons:
		parts.append("%s-%d-%s" % [w.id, w.level, str(int(w.cd * 1000.0))])
	return " ".join(parts)


# --- legs ---------------------------------------------------------------------

func _leg_single(base: String, level: int, partner: String, rank: int,
		t: float, leg_name: String, expect_evo: bool) -> void:
	_leg_base(leg_name, base, level, partner, rank, t)
	var before: Dictionary = _fresh(base, level, partner, rank, t)
	var after := _open()
	var game = _main.game
	var evo_id: String = EvolutionSystem.TABLE.get(base, {}).get("evo", "")
	var checks := {
		"evolved": (evo_id != "" and _has_id(game, evo_id)) == expect_evo,
		"base_gone": (not _has_id(game, base)) if (evo_id != "" and expect_evo) \
				else true,
		"in_slot": _slot_kept(game, evo_id, expect_evo, level),
		"slot_count": game.weapons.size() == 2, # talon + the pinned weapon
		# T-M2t: the chest these legs drop is the boss kill -> tier warden
		# (CHEST_TIER_BY_SOURCE row, B-T1); the card grant is that row's
		# item_count, not the pre-tier +1 (replace-not-delete: the claim the
		# row makes, "the reward card is granted", is unchanged)
		"reward_card": game.pending_levels == int(before["pending0"]) \
				+ ChestRewards.TIERS["warden"].item_count,
	}
	_gate(leg_name, before, after, t, checks, "")


func _leg_all_ten() -> void:
	_leg_base("evo_all_ten_rows", "", 0, "", 0, GATE_OK_T)
	var checks := {}
	var before_lines: Array = []
	var after_lines: Array = []
	for base in EvolutionSystem.TABLE:
		var t_row: Dictionary = _fresh(base, WeaponSystem.MAX_LEVEL,
			EvolutionSystem.TABLE[base].partner, 1, GATE_OK_T)
		var after := _open()
		var game = _main.game
		var evo: String = EvolutionSystem.TABLE[base].evo
		checks[base] = _has_id(game, evo) and not _has_id(game, base) \
				and game.weapons.size() == 2
		before_lines.append(t_row["before"])
		after_lines.append(after)
	_gate("evo_all_ten_rows", {"before": before_lines}, after_lines,
		GATE_OK_T, checks, "every TABLE row through the real funnel")


func _leg_one_per_chest() -> void:
	_leg_base("evo_one_per_chest", "", 0, "", 0, GATE_OK_T)
	var game = _main.game
	game.start_run()
	_main.world.reset()
	game.weapons.append({"id": PIN_T_BASE, "level": WeaponSystem.MAX_LEVEL,
		"cd": 5.0})
	game.weapons.append({"id": "dart-loop", "level": WeaponSystem.MAX_LEVEL,
		"cd": 5.0})
	game.passives[PIN_T_PARTNER] = 1
	game.passives["iron-wrap"] = 1
	game.time = GATE_OK_T
	var before := _line(game)
	_drop_chest(game)
	var after1 := _open()
	var one_ok: bool = _has_id(game, "red-wail") \
			and not _has_id(game, "thousand-darts")
	# second chest: the still-eligible dart-loop evolves too
	_drop_chest(game)
	var after2 := _open()
	_gate("evo_one_per_chest", {"before": before}, [after1, after2],
		GATE_OK_T, {
			"first_chest_one_evo": one_ok,
			"second_chest_second_evo": _has_id(game, "thousand-darts") \
					and _has_id(game, "red-wail"),
		}, "stated reading: one evolution per chest, first eligible in order")


func _leg_card_seam() -> void:
	# Chest after the gate -> the ONE frozen levelup seam opens and closes:
	# pending_levels (from the real open) -> _enter_levelup (the exact call
	# main.gd _step makes) -> real 3-card offer -> real _pick -> playing.
	_leg_base("evo_card_seam", PIN_T_BASE, WeaponSystem.MAX_LEVEL,
		PIN_T_PARTNER, 1, GATE_OK_T)
	var before: Dictionary = _fresh(PIN_T_BASE, WeaponSystem.MAX_LEVEL,
		PIN_T_PARTNER, 1, GATE_OK_T)
	var after := _open()
	var game = _main.game
	var checks := {
		"phase_stays_playing": game.phase == "playing",
		# T-M2t: warden chest = item_count offers through the ONE seam
		"pending_raised": game.pending_levels == int(before["pending0"]) \
				+ ChestRewards.TIERS["warden"].item_count,
	}
	_main._enter_levelup()
	checks["seam_phase_levelup"] = game.phase == "levelup"
	checks["offer_nonempty"] = _main._current_offer.size() == 3
	_main._pick(0)
	# a tier chest leaves several pending offers; drain the rest through the
	# SAME seam (_pick's own refill) until the phase closes
	var drained := 1
	while game.phase == "levelup":
		_main._pick(0)
		drained += 1
	checks["back_to_playing"] = game.phase == "playing"
	checks["pending_spent"] = game.pending_levels == int(before["pending0"])
	checks["drained_all_offers"] = drained == ChestRewards.TIERS["warden"].item_count
	checks["evo_survives_pick"] = _evo_entry_kept(game, PIN_T_EVO,
		WeaponSystem.MAX_LEVEL, 1) # a pick may upgrade OTHER slots; the evolved
	# entry itself must be untouched by the seam (in-slot, cd reset kept)
	_gate("evo_card_seam", before, after, GATE_OK_T, checks,
		"real _enter_levelup/_pick seam (levelup fallback = gold rides the "
				+ "unchanged bonus_card mechanism)")


func _drop_chest(game) -> void:
	var p: Dictionary = game.player
	_main.world.kill_enemy(game, {"x": p.x + 8.0, "y": p.y + 8.0,
		"xp": 0.0, "boss": true, "miniboss": false})


# --- M1h legs (MC 11220): pool reachability + FULL end-to-end evolutions ---

func _leg_pool_reachability() -> void:
	# The ONE pool source read directly (zero RNG, zero pin beyond the
	# canonical run state): every TABLE base weapon is offerable as a NEW
	# kind and every partner passive as a NEW KIND (slots/kinds wide open).
	_leg_base("evo_pool_reachability", "", 0, "", 0, GATE_OK_T)
	var game = _main.game
	game.start_run()
	var checks := {}
	var lines: Array = []
	for base in EvolutionSystem.TABLE:
		var partner: String = EvolutionSystem.TABLE[base].partner
		var pool: Array = LevelUpDeck.build_pool(game) # canonical 1/15 state
		var got_w := false
		var got_p := false
		for card in pool:
			if card.kind == "weapon" and card.id == base:
				got_w = true
			if card.kind == "passive" and card.key == partner:
				got_p = true
		checks[base] = got_w and got_p
		lines.append("%s+%s offered=%s" % [base, partner, str(got_w and got_p)])
	_gate("evo_pool_reachability", {"before": "canonical run"}, lines,
		GATE_OK_T, checks, "build_pool offers every table base + partner")


# Every part ACQUIRED through the real offer funnel (real make_offer cards,
# real _pick), then the real chest evolves it. The pinned weapon is NEVER
# written into game.weapons by this leg — that is what FULL means.
func _leg_full_evolve(base: String) -> void:
	_leg_base("evo_full_" + base, base, WeaponSystem.MAX_LEVEL,
		EvolutionSystem.TABLE[base].partner, 1, GATE_OK_T)
	var game = _main.game
	game.start_run()
	_main.world.reset()
	var partner: String = EvolutionSystem.TABLE[base].partner
	var before := _line(game)
	var rank_at_acquire := 0
	var slot_idx := -1
	for i in 800: # seed-pinned RNG: terminates on this seed; else leg REDs
		var lv := -1
		for w in game.weapons:
			if w.id == base:
				lv = w.level
				break
		rank_at_acquire = int(game.passives[partner])
		if lv >= WeaponSystem.MAX_LEVEL and rank_at_acquire >= 1:
			for j in game.weapons.size():
				if game.weapons[j].id == base:
					slot_idx = j
			break
		game.pending_levels = 1
		_main._enter_levelup()
		var pick := -1
		for c in _main._current_offer.size():
			var card: Dictionary = _main._current_offer[c]
			var k: String = card.kind
			if (k == "weapon" and card.id == base) \
					or (k == "passive" and card.key == partner) \
					or (k == "upgrade" and card.id == base):
				pick = c
				break
		if pick < 0:
			# decline the off-target offer (sim_boss._decline pattern) — the
			# funnel must not dilute the loadout with unrelated cards.
			game.pending_levels = 0
			game.set_phase("playing")
		else:
			_main._pick(pick)
	var acquired := _line(game)
	game.time = GATE_OK_T
	_drop_chest(game)
	var after := _open()
	var evo: String = EvolutionSystem.TABLE[base].evo
	_gate("evo_full_" + base, {"before": before, "acquired": acquired},
		after, GATE_OK_T, {
			"weapon_acquired_by_pick": _owned_from_line(acquired, base) \
					>= WeaponSystem.MAX_LEVEL, # entry exists (level MAX)
			"partner_acquired_by_pick": rank_at_acquire >= 1,
			"evolved": _has_id(game, evo),
			"base_gone": not _has_id(game, base),
			"in_slot": slot_idx >= 0 \
					and _evo_entry_kept(game, evo, WeaponSystem.MAX_LEVEL,
							slot_idx),
			"slot_cap_kept": game.weapons.size() \
					<= LevelUpDeck.MAX_WEAPON_SLOTS,
		}, "FULL: every entry acquired by real _pick (no id pinned); " +
				"off-target offers DECLINED (sim_boss._decline pattern)")


func _owned(game, id: String) -> int:
	for w in game.weapons:
		if w.id == id:
			return w.level
	return -1


func _owned_from_line(line: String, id: String) -> int:
	for part in line.split(" "):
		if part.begins_with(id + "-"):
			return int(part.split("-")[id.split("-").size()])
	return -1


func _leg_base(leg_name: String, base: String, level: int, partner: String,
		rank: int, t: float) -> void:
	_rows.append({"ev": "evo_leg", "leg": leg_name, "base": base,
		"level": level, "partner": partner, "rank": rank, "t": t,
		"gate": EvolutionSystem.GATE_T})


func _gate(leg_name: String, before, after, t: float, checks: Dictionary,
		note: String) -> void:
	var leg_ok := true
	for k in checks:
		if not checks[k]:
			leg_ok = false
	_ok = _ok and leg_ok
	_emit({"ev": "evo_gate", "leg": leg_name, "before": before,
		"after": after, "t": t, "checks": checks, "note": note,
		"ok": leg_ok})


func _has_id(game, id: String) -> bool:
	for w in game.weapons:
		if w.id == id:
			return true
	return false


func _slot_kept(game, evo: String, evolved: bool, level: int) -> bool:
	if not (evolved and evo != ""):
		return true
	return _evo_entry_kept(game, evo, level, 1)


func _evo_entry_kept(game, evo: String, level: int, idx: int = -1) -> bool:
	for i in game.weapons.size():
		if game.weapons[i].id == evo:
			# the replacement is IN-SLOT (the base's index), level kept,
			# cooldown reset (doc). idx -1 = pinned-leg default (base sat at
			# slot index 1, talon first); the full legs pass the real index.
			if idx >= 0 and i != idx:
				return false
			return game.weapons[i].level == level \
					and float(game.weapons[i].cd) == 0.0
	return false


func _emit(row: Dictionary) -> void:
	_rows.append(row)
