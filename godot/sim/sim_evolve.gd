# Chest truth table + evolution legs for M6-SPEC §3 F3 (MC 11697 T-M6p;
# the moved trigger of the M1 feature-5 line, MC 11209 T-M1e).
# reason: >400/600 lines (640 measured at T-M6p) — the chest truth table + the FULL end-to-end legs +
#   the reserve legs ARE the one evolve dump contract; a split would fork
#   the table from its legs (the MC 11398 §1.5 header law, restated at the
#   T-M6p rewrite; boost MATH rows live in sim_combat's spec channel per
#   PS-E2 — the channel the spec names, merged into the journey dump).
# Same headless funnel as sim_caps/sim_boss: the REAL Main.tscn, screens
# stubbed, the run started through the real _start_game. Loadouts ride the
# DECLARED-PIN construction channel (sim_boss.gd:215); the FULL legs
# acquire EVERY part through the real offer funnel (real make_offer cards +
# real _pick, no id pinned). M6 (MC 11697, M6-SPEC §3.1): THE TRIGGER
# MOVED — a weapon at `at` (5) with its partner carried evolves at the NEXT
# level-up PICK (levelup.apply_offer's upgrade/passive arms), never at a
# chest; the chest arm is union-only (§4.4 R5) and the GATE_T time term is
# gone for evolutions. Chests stay in this table as the DIRECT/INDIRECT
# pair (PS-E3): a chest never evolves (direct-arm rows) and a chest tier
# card's pick can (indirect-twin rows). The reserve legs ride the EXTENDED
# window (§3.4 option (a)): a union base stays unevolved while its recipe
# is achievable — partner below MAX OR partner AT MAX with the passive
# carried; partner gone lifts.
# ROWS (truth table + the §3 ACCEPT seams; both sides per PS-E1/PS-E3/
# PS-E4 — an inverted predicate turns at least one row RED):
#   evo_l5_partner           L5 + partner + pick          -> EVOLVES (in-slot,
#                              level kept, cd reset, slot count unchanged)
#   evo_l4_partner           L4 + partner + pick          -> does NOT (RED side)
#   evo_l5_nopartner         L5, partner 0                -> does NOT
#   evo_l5_wrong_passive     L5 + carried NON-partner     -> does NOT
#   evo_partner_any_rank     partner rank 3               -> EVOLVES ("any rank")
#   evo_non_table_weapon     ember L8 + a partner         -> does NOT
#   evo_all_nine_rows        every TABLE row end-to-end (R2: 9 rows since
#                              the doom-sigil→pale-moon row retired HERE)
#   evo_one_per_pick         two eligibles + one pick -> exactly ONE (first
#                              in game.weapons order); the next pick takes
#                              the second (the per-pick reading, zero RNG)
#   evo_reserve_below_max    rot-water L8 + loadstone, partner censer AT L5
#                              (< MAX) + pick              -> does NOT (dirge
#                              stays reachable; PS-E4 side A)
#   evo_reserve_at_max       rot-water + censer BOTH MAX + loadstone + pick
#                              -> does NOT (the ELIGIBLE-at-MAX window,
#                              PS-E4 side B — the REV-1 killer case); the
#                              NEXT chest lands dirge-eternal (trace rows)
#   evo_reserve_lifted       partner GONE                  -> the-sluice
#                              evolves (the rule never blocks an
#                              unreachable union)
#   evo_no_evolve_at_chest   state eligible for the OLD chest trigger +
#                              chest open -> NOTHING evolves (the retired
#                              direct arm, PS-E3) + the tier card granted
#   evo_chest_card_pick_evolves  the SAME state: the tier card's own pick
#                              evolves it (the indirect route, PS-E3 twin)
#   evo_card_seam            chest-open raises pending_levels and the REAL
#                              levelup seam opens (offer non-empty) and the
#                              drain returns to playing — the ONE phase
#                              seam, no parallel UI (reward rows intact)
#   evo_pool_reachability    every TABLE base + partner offered by the ONE
#                              pool source (9 rows; the doom-sigil
#                              retirement row retired WITH the table row)
#   evo_full_<id>            FULL end-to-end: base + partner + upgrades
#                              acquired by REAL _picks; the evolve lands at
#                              its trigger PICK, chest-free (no chest was
#                              ever opened when it landed)
#   evo_full_second_weapon   two TABLE weapons in one run: EACH evolves at
#                              its OWN trigger pick (the per-pick trigger,
#                              PS-E1's dump-twin side)
# Seed-pinned (HD3D_SEED, default 11209) — the dump is byte-stable; the
# committed copy tests/fixtures/chests-evolve-m1e.jsonl gates
# tests/test_chests_evolve.py (RE-MINTED at this card — the fixture's own
# subject moved: chest trigger → level trigger, table 10→9, GATE_T out of
# the evolve gate, M6-SPEC §9 row 3).
extends SceneTree

const EVO_SEED := 11209
const GATE_OK_T := 601.0 # strictly past the UNION's chest gate (GATE_T —
					# union-side since T-M6p; the chest rows still cross it)

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
		var d: String = OS.get_environment("HD3D_EVO_DUMP")
		_out = FileAccess.open(d if d != "" else
			ProjectSettings.globalize_path("res://.tmp/chests-evolve.jsonl"),
			FileAccess.WRITE)
		assert(_out != null)
		print("EVO_START")
		_run()
	if _frames > 3:
		push_error("evolve sim did not finish in one frame")
		quit(3)
		return true
	return false


func _run() -> void:
	seed(EVO_SEED)
	_main = SimFunnel.fresh_run(root, {})
	_leg_trigger("evo_l5_partner", "bone-whip", 5, "cracked-heart", 1, true)
	_leg_trigger("evo_l4_partner", "bone-whip", 4, "cracked-heart", 1, false)
	_leg_trigger("evo_l5_nopartner", "bone-whip", 5, "cracked-heart", 0, false)
	_leg_trigger("evo_l5_wrong_passive", "bone-whip", 5, "cracked-heart", 0,
		false, ["ward", 3])
	_leg_trigger("evo_partner_any_rank", "bone-whip", 5, "cracked-heart",
		3, true)
	_leg_trigger("evo_non_table_weapon", "ember", 8, "cracked-heart", 1, false)
	_leg_all_nine()
	_leg_one_per_pick()
	_leg_reserve_below_max()
	_leg_reserve_at_max()
	_leg_reserve_lifted()
	_leg_no_evolve_at_chest()
	_leg_chest_card_pick_evolves()
	_leg_card_seam()
	_leg_pool_reachability()
	_leg_full_evolve("bone-whip")
	_leg_full_evolve("rot-water")
	_leg_full_second_weapon()
	_emit({"ev": "evolve_verdict", "ok": _ok})
	for r in _rows:
		_out.store_line(JSON.stringify(r))
	_out.close()
	print("EVO_DONE ok=%s rows=%d" % [_ok, _rows.size()])
	quit(0 if _ok else 3)


# ---- truth table through the real level-up funnel --------------------------

# One pinned NO/YES side: talon (non-table, keeps slot/order math stable) +
# the pinned base at `level` + the partner passive at `rank`; ONE
# trigger-eligible pick through the REAL seam (SimFunnel.take_trigger_card
# — a PASSIVE card, never the partner key: the pick can never newly
# satisfy the table rule itself). The evolution, when due, lands inside
# that same apply_offer (the moved trigger, spec §3.1).
func _leg_trigger(leg: String, base: String, level: int, passive: String,
		rank: int, expect: bool, other_passive: Array = []) -> void:
	var before := _pin(base, level, passive, rank, [])
	if not other_passive.is_empty():
		# the wrong-passive side: a carried NON-partner passive (rank 3)
		# must not satisfy the rule ("carried" is the partner, any rank).
		_main.game.passives[other_passive[0]] = other_passive[1]
	var evo: String = EvolutionSystem.TABLE[base].evo if EvolutionSystem.TABLE.has(base) else ""
	var applied := SimFunnel.take_trigger_card(_main,
		[passive] if rank == 0 else [])
	var after := _after()
	var checks := {
		"trigger_pick_applied": applied,
		"evolved": _has_id(_main.game, evo) == expect,
		"base_gone": (not _in(after, base)) == expect,
		"slot_count_kept": _main.game.weapons.size() == before.size(),
	}
	if expect:
		checks["in_slot_level_cd"] = _slot_kept(_main.game, evo, true, level, 1)
	_leg(leg, before, after, checks,
		"pinned state + ONE trigger pick through the real funnel")


func _leg_all_nine() -> void:
	# Every TABLE row (9 since the T-M6p R2 retirement): pin L8 + partner,
	# one trigger pick, base replaced in-slot level kept cd reset. The row
	# COUNT is itself the R2 truth: 9 rows here, the 10th (doom-sigil →
	# pale-moon) retired with the pool entry (§4.4 R2).
	var bases_ok := 0
	for base in EvolutionSystem.TABLE:
		var level := 8
		_pin(base, level, EvolutionSystem.TABLE[base].partner, 1, [])
		var applied := SimFunnel.take_trigger_card(_main, [])
		var evo: String = EvolutionSystem.TABLE[base].evo
		var ok_row: bool = applied and _has_id(_main.game, evo) \
				and base not in _after() \
				and _slot_kept(_main.game, evo, true, level, 1) \
				and _main.game.weapons.size() == 2
		if ok_row:
			bases_ok += 1
		_emit({"ev": "evo_all_nine_row", "leg": "evo_all_nine", "base": base,
			"evo": evo, "after": _after(), "ok": ok_row})
	_ok = _ok and bases_ok == EvolutionSystem.TABLE.size()


func _leg_one_per_pick() -> void:
	# Two eligible TABLE weapons + one trigger pick = EXACTLY one evolution
	# (first in game.weapons order); the next pick evolves the second — the
	# per-pick reading of the old one-per-chest law (spec §3.1: "the whole
	# rule lives in one entry" survives, one evolution per applied pick).
	var before := _pin("bone-whip", 8, "cracked-heart", 1, [])
	_main.game.weapons.append({"id": "dart-loop", "level": 8, "cd": 0.0})
	_main.game.passives["iron-wrap"] = 1
	var after_row0 := _after()
	SimFunnel.take_trigger_card(_main, [])
	var after1 := _after()
	var checks1 := {
		"first_pick_first_base": _in(after1, "red-wail") \
				and not _in(after1, "thousand-darts"),
		"one_evolution_per_pick": _main.game.weapons.size() == 3,
	}
	SimFunnel.take_trigger_card(_main, [])
	var after2 := _after()
	var checks2 := {
		"second_pick_second_base": _in(after2, "thousand-darts") \
				and _in(after2, "red-wail"),
		"slots_kept": _main.game.weapons.size() == 3,
	}
	var combined := checks1.duplicate(true)
	for k in checks2:
		combined[k] = checks2[k]
	var leg_ok := true
	for k in combined:
		leg_ok = leg_ok and combined[k]
	_ok = _ok and leg_ok
	_emit({"ev": "evo_one_per_pick", "before": before + after_row0,
		"after_1": after1, "after_2": after2,
		"checks": combined, "ok": leg_ok})


# ---- the reserve legs at the NEW trigger (PS-E4, §3.4 option (a)) ----------

func _leg_reserve_below_max() -> void:
	# rot-water L8 + loadstone + censer-of-hours AT L5 (below MAX): the
	# dirge-eternal recipe is still achievable (partner below MAX = the
	# shipped branch), so the pick must NOT evolve rot-water.
	var before := _pin("rot-water", 8, "loadstone", 1, [])
	_main.game.weapons.append({"id": "censer-of-hours", "level": 5, "cd": 0.0})
	var applied := SimFunnel.take_trigger_card(_main, ["loadstone"])
	var after := _after()
	_leg("evo_reserve_below_max", before, after, {
		"trigger_pick_applied": applied,
		"sluice_absent": not _in(after, "the-sluice"),
		"rot_water_kept": _in(after, "rot-water"),
		"censer_kept": _in(after, "censer-of-hours"),
	}, "PS-E4 side A — reserve holds below MAX at the new trigger")


func _leg_reserve_at_max() -> void:
	# THE REV-1 KILLER CASE (PS-E4 side B): rot-water AND censer-of-hours
	# BOTH at MAX + loadstone carried, and a plain level-up pick lands
	# BEFORE any chest. With the REV-1 below-MAX-only predicate rot-water
	# here evolves into the-sluice and dirge-eternal is FOREVER locked —
	# this row goes RED the moment the eligible-at-MAX window is missing.
	# The window holds: the next chest must still land dirge-eternal
	# (trace rows: before / after the pick / after the chest-open).
	var before := _pin("rot-water", 8, "loadstone", 1, [])
	_main.game.weapons.append({"id": "censer-of-hours", "level": 8, "cd": 0.0})
	var applied := SimFunnel.take_trigger_card(_main, ["loadstone"])
	var after_pick := _after()
	_main.game.time = GATE_OK_T
	_drop_chest()
	_main.world.collect_pickups(_main.game)
	var after := _after()
	_leg("evo_reserve_at_max", before + after_pick, after, {
		"trigger_pick_applied": applied,
		"sluice_absent_at_pick": not _in(after_pick, "the-sluice"),
		"both_bases_survive_pick": _in(after_pick, "rot-water") \
				and _in(after_pick, "censer-of-hours"),
		"dirge_landed_at_chest": _in(after, "dirge-eternal") \
				and not _in(after, "rot-water") \
				and not _in(after, "censer-of-hours"),
	}, "PS-E4 side B — eligible-at-MAX window; the union still completes")


func _leg_reserve_lifted() -> void:
	# Partner GONE (never carried): the union is unreachable, the reserve
	# lifts, the pick evolves the base (the rule never blocks an
	# unreachable union — the shipped lifted-side truth, new trigger).
	var before := _pin("rot-water", 8, "loadstone", 1, [])
	var applied := SimFunnel.take_trigger_card(_main, [])
	var after := _after()
	_leg("evo_reserve_lifted", before, after, {
		"trigger_pick_applied": applied,
		"sluice_evolved": _in(after, "the-sluice") and not _in(after, "rot-water"),
		"in_slot_level_cd": _slot_kept(_main.game, "the-sluice", true, 8, 1),
	}, "reserve lifts when the union is unreachable")


# ---- the chest pair (PS-E3): the direct arm is dead, the route is indirect --

func _leg_no_evolve_at_chest() -> void:
	# The DIRECT-arm row (PS-E3): the state that evolved at the chest under
	# the M1 law (L8 + partner + chest at t>=GATE_T) now changes NOTHING
	# at the open — the retired `else try_evolve` line's absence is the
	# byte this row pins (a restored line turns it RED). The tier card and
	# the union arm stay untouched (R5): the grant still raises pending.
	var before := _pin("bone-whip", 8, "cracked-heart", 1, [])
	_main.game.time = GATE_OK_T
	_drop_chest()
	_main.world.collect_pickups(_main.game)
	var after := _after()
	_leg("evo_no_evolve_at_chest", before, after, {
		"chest_consumed": _main.world.chests.is_empty(),
		"no_direct_evolution": not _in(after, "red-wail") \
				and _in(after, "bone-whip"),
		"no_union": not _in(after, "requiem-toll") \
				and not _in(after, "dirge-eternal"),
		"reward_card_granted": _main.game.pending_levels > 0,
	}, "PS-E3 direct arm — the chest never evolves (retired line)")


func _leg_chest_card_pick_evolves() -> void:
	# The INDIRECT-twin row (PS-E3): the same eligible state evolves when
	# the chest's OWN TIER CARD is picked through the real drain — the
	# level trigger reads chest cards exactly like level cards (one seam).
	var before := _pin("bone-whip", 8, "cracked-heart", 1, [])
	_main.game.time = GATE_OK_T
	_drop_chest()
	_main.world.collect_pickups(_main.game)
	var pending := int(_main.game.pending_levels)
	var drained := 0
	var evolved := false
	while not evolved and drained < pending + 6:
		drained += 1
		if _main.game.phase != "levelup":
			_main.game.pending_levels = maxi(int(_main.game.pending_levels), 1)
			_main._enter_levelup()
		var picked := false
		for c in _main._current_offer.size():
			var card: Dictionary = _main._current_offer[c]
			if card.kind == "passive" or card.kind == "upgrade":
				_main._pick(c)
				picked = true
				break
		if not picked:
			SimFunnel.decline(_main)
		evolved = _has_id(_main.game, "red-wail")
	var guard := 0
	while _main.game.phase == "levelup" and guard < pending + 6:
		guard += 1
		_main._pick(0) # drain the rest through the SAME seam (frozen shape)
	var after := _after()
	_leg("evo_chest_card_pick_evolves", before, after, {
		"pending_from_chest": pending > 0,
		"evolved_via_card_pick": evolved,
		"in_slot": _slot_kept(_main.game, "red-wail", true, 8, 1),
		"back_to_playing": _main.game.phase == "playing",
	}, "PS-E3 indirect twin — the tier card's pick carries the trigger")


func _leg_card_seam() -> void:
	# The frozen level-up phase seam (DA c1 A-2): the open raises exactly
	# item_count pendings, the real _enter_levelup opens a 3-card offer and
	# the real _pick returns to playing — no parallel UI. The evolution
	# claim lives in the pair above; THIS row pins the seam itself (the
	# shipped offer-shape truth: every pick is one real card).
	_main.game.start_run()
	_main.world.reset()
	_main.game.time = GATE_OK_T
	_main.game.weapons.append({"id": "bone-whip", "level": 8, "cd": 0.0})
	_main.game.passives["cracked-heart"] = 1
	_drop_chest()
	var placed: bool = not _main.world.chests.is_empty()
	_main.world.collect_pickups(_main.game) # the real open: consumes, grants
	var checks := {}
	checks["chest_opened"] = placed and _main.world.chests.is_empty()
	var pend: int = _main.game.pending_levels
	_main._enter_levelup()
	checks["seam_phase_levelup"] = _main.game.phase == "levelup"
	checks["offer_nonempty"] = _main._current_offer.size() == 3
	var card: Dictionary = _main._current_offer[0]
	checks["drained_card_shape"] = card.has("kind") and card.has("name") \
			and card.has("desc")
	var pending_before_drain: int = _main.game.pending_levels
	var drained := 0
	while _main.game.phase == "levelup" and drained < pend + 2:
		drained += 1
		_main._pick(0)
	checks["back_to_playing"] = _main.game.phase == "playing"
	checks["pending_spent"] = _main.game.pending_levels == pending_before_drain - drained
	checks["drained_all"] = drained == pending_before_drain
	var slots_ok: bool = _main.game.weapons.size() <= 6
	var ids_ok: bool = true
	for w in _main.game.weapons:
		ids_ok = ids_ok and (w.id in WeaponSystem.IDS \
				or w.id in EvolutionSystem.TABLE.values().map(
						func(r): return r.evo) \
				or w.id in UnionSystem.TABLE)
	checks["loadout_wellformed"] = slots_ok and ids_ok
	var leg_ok := true
	for k in checks:
		leg_ok = leg_ok and checks[k]
	_ok = _ok and leg_ok
	_emit({"ev": "evo_card_seam", "before": _after(), "after": _after(),
		"t": GATE_OK_T, "checks": checks, "ok": leg_ok})


# ---- the pool reachability row (T-M1h; 9 rows since the R2 retirement) -----

func _leg_pool_reachability() -> void:
	# Every base weapon AND its partner passive of the ONE TABLE are
	# offerable from the ONE pool source (LevelUpDeck.build_pool, the same
	# seam make_offer shuffles) — the "sim can now acquire both parts"
	# truth the M1h roster landed. Zero RNG: a direct pool read.
	# (T-M6d retired the doom-sigil branch with the POOL entry; T-M6p
	# retired the TABLE row too — the loop is now exactly 9 rows, the
	# honest count, §4.1's evolution-side split.)
	_main.game.start_run()
	_main.world.reset()
	var pool: Array = LevelUpDeck.build_pool(_main.game)
	var offered: Dictionary = {}
	for card in pool:
		if card.kind == "weapon":
			offered[card.id] = true
		elif card.kind == "passive":
			offered[card.key] = true
	var all_offered := true
	var missing := []
	for base in EvolutionSystem.TABLE:
		for key in [base, EvolutionSystem.TABLE[base].partner]:
			if not offered.has(key):
				all_offered = false
				missing.append(key)
	_emit({"ev": "evo_pool_reachability", "offered_bases": offered.keys(),
		"all_offered": all_offered, "missing": missing,
		"rows": EvolutionSystem.TABLE.size(),
		"ok": all_offered})
	_ok = _ok and all_offered


# ---- the FULL end-to-end evolutions through the real offer funnel ----------

# PS-E1's full legs: EVERY weapon/passive/upgrade entry taken by a real
# _pick (no id pinned at all); the evolution lands at its TRIGGER PICK —
# before and without any chest (chest-free is asserted: no chest was ever
# opened when the evolved id first appeared).
func _leg_full_evolve(base: String) -> void:
	var evo: String = EvolutionSystem.TABLE[base].evo
	var partner: String = EvolutionSystem.TABLE[base].partner
	_main.game.start_run()
	_main.world.reset()
	var game = _main.game
	var added := false
	var partner_added := false
	var upgraded := 0
	var idx := -1
	var evolved_at_step := -1
	for i in 800:
		if _has_id(game, evo):
			evolved_at_step = i
			break
		game.pending_levels = 1
		_main._enter_levelup()
		var offer: Array = _main._current_offer
		var picked := false
		for c in offer.size():
			var card: Dictionary = offer[c]
			if not added and card.kind == "weapon" and card.id == base:
				_main._pick(c)
				added = true
				idx = game.weapons.size() - 1
				picked = true
				break
			if not partner_added and card.kind == "passive" \
					and card.key == partner:
				_main._pick(c)
				partner_added = true
				picked = true
				break
			if added and upgraded < 8 and card.kind == "upgrade" \
					and card.id == base:
				_main._pick(c)
				upgraded += 1
				picked = true
				break
		if not picked:
			SimFunnel.decline(_main)
	var slots_ok: bool = game.weapons.size() <= 6
	var in_slot: bool = idx >= 0 and game.weapons[idx].id == evo
	var chest_free: bool = _main.world.chests.is_empty()
	var leg_ok: bool = evolved_at_step >= 0 and in_slot and slots_ok \
			and chest_free and base not in _after() \
			and float(game.weapons[idx].cd) >= 0.0
	_ok = _ok and leg_ok
	_emit({"ev": "evo_full", "leg": "evo_full_%s" % base,
		"acquired": _after(), "slots_ok": slots_ok,
		"in_slot_idx": idx, "evolved_at_step": evolved_at_step,
		"chest_free": chest_free,
		"checks": {"evolved_by_pick": evolved_at_step >= 0,
			"in_slot": in_slot, "slot_cap": slots_ok,
			"chest_free": chest_free},
		"ok": leg_ok})


func _leg_full_second_weapon() -> void:
	# PS-E1: the trigger is PER PICK — one run acquires TWO table weapons;
	# each evolves at its OWN trigger pick, in acquisition order, never
	# both in one pick. Rows: the step each evolved + the ordered after
	# states (the dump-twin shape: deterministic, zero RNG beyond the
	# shipped shuffle).
	_main.game.start_run()
	_main.world.reset()
	var game = _main.game
	var got := {}
	var evolved_at := {}

	for i in 800:
		if evolved_at.has("bone-whip") and evolved_at.has("dart-loop"):
			break
		game.pending_levels = 1
		_main._enter_levelup()
		var offer: Array = _main._current_offer
		var picked := false
		for c in offer.size():
			var card: Dictionary = offer[c]
			for base in ["bone-whip", "dart-loop"]:
				var partner: String = EvolutionSystem.TABLE[base].partner
				if card.kind == "weapon" and card.id == base \
						and not got.has(base):
					_main._pick(c)
					got[base] = true
					picked = true
					break
				if card.kind == "passive" and card.key == partner:
					_main._pick(c)
					picked = true
					break
				if got.has(base) and card.kind == "upgrade" and card.id == base:
					_main._pick(c)
					picked = true
					break
			if picked:
				break
		if not picked:
			SimFunnel.decline(_main)
		for base in ["bone-whip", "dart-loop"]:
			if not evolved_at.has(base) \
					and _has_id(game, EvolutionSystem.TABLE[base].evo):
				evolved_at[base] = {"pick": i, "after": _after()}
	var both := evolved_at.has("bone-whip") and evolved_at.has("dart-loop")
	var per_pick: bool = both and int(evolved_at["bone-whip"].pick) \
			!= int(evolved_at["dart-loop"].pick)
	var one_per_pick_observed: bool = per_pick
	if per_pick:
		# the EARLIER evolution's after-line must not carry the LATER
		# base's evo id: exactly one transform happened at that pick.
		var first_base := "bone-whip" \
				if int(evolved_at["bone-whip"].pick) \
						< int(evolved_at["dart-loop"].pick) else "dart-loop"
		var second_evo: String = String(EvolutionSystem.TABLE["dart-loop"].evo) \
				if first_base == "bone-whip" \
				else String(EvolutionSystem.TABLE["bone-whip"].evo)
		one_per_pick_observed = (" ".join(evolved_at[first_base].after)) \
				.find(second_evo) < 0
	_ok = _ok and per_pick and one_per_pick_observed
	_emit({"ev": "evo_full_second_weapon", "evolved_at": evolved_at,
		"checks": {"both_evolved": both, "distinct_picks": per_pick,
			"one_per_pick": one_per_pick_observed},
		"ok": per_pick and one_per_pick_observed})


# ---- helpers ---------------------------------------------------------------

# DECLARED-PIN construction channel (sim_boss.gd:215 verbatim): talon first
# (non-table, keeps slot/order math stable), the base at `level`, the
# partner passive at `rank` (0 = never carried, the dict-key stays 0), plus
# extra [id, level] weapon pins (the union-recipe legs).
func _pin(base: String, level: int, passive: String, rank: int,
		extra: Array) -> Array:
	_main.game.start_run()
	_main.world.reset()
	_main.game.weapons.append({"id": base, "level": level, "cd": 0.0})
	_main.game.passives[passive] = rank
	var i := 0
	while i < extra.size():
		_main.game.weapons.append({"id": extra[i], "level": extra[i + 1],
			"cd": 0.0})
		i += 2
	return _after()


# A chest placed through the REAL drop funnel (sim_boss chest-roll-leg
# shape, the T-M1e donor verbatim): a synthetic boss-flagged kill (xp 0,
# real flag shape) dies by world.kill_enemy next to the pawn;
# CHEST_CHANCE_BOSS 1.0 short-circuits the roll (T-M1d's pinned chance —
# the legs RIDE the existing counts, no new RNG mechanism). T-M3b keyed-
# drop law: the synth carries the warden's TYPE (the strict drop-map row
# this synth class means).
func _drop_chest() -> void:
	var p: Dictionary = _main.game.player
	_main.world.kill_enemy(_main.game, {"x": p.x + 8.0, "y": p.y + 8.0,
		"xp": 0.0, "boss": true, "miniboss": false,
		"type": "warden"})


func _after() -> Array:
	var out: Array = []
	for w in _main.game.weapons:
		out.append("%s-%d-%d" % [w.id, w.level, int(round(float(w.cd)))])
	return out


# Composed-entry membership over the pin AFTER lines ("rot-water-8-0"
# rows): the Array `in` operator is element-EQUALITY, so substring checks
# on composed entries read false-negative — this is the ONE membership
# reader for the composed rows (spec §3.6 rows are honest about ids).
func _in(entries: Array, id: String) -> bool:
	for e in entries:
		if String(e).begins_with(id + "-"):
			return true
	return false


func _leg(leg: String, before: Array, after: Array, checks: Dictionary,
		note: String) -> void:
	var leg_ok := true
	for k in checks:
		leg_ok = leg_ok and checks[k]
	_ok = _ok and leg_ok
	_emit({"ev": "evolution_gate", "leg": leg, "at": EvolutionSystem.EVO_LEVEL,
		"before": before, "after": after, "checks": checks, "note": note,
		"ok": leg_ok})


func _has_id(game, id: String) -> bool:
	for w in game.weapons:
		if w.id == id:
			return true
	return false


func _slot_kept(game, evo: String, evolved: bool, level: int,
		idx: int = -1) -> bool:
	if not (evolved and evo != ""):
		return true
	for i in game.weapons.size():
		if game.weapons[i].id == evo:
			# the replacement is IN-SLOT (the base's index), level kept,
			# cooldown reset (doc). idx -1 = pinned-leg default (base sat
			# at slot index 1, talon first); the full legs pass the index.
			if idx >= 0 and i != idx:
				return false
			return game.weapons[i].level == level \
					and float(game.weapons[i].cd) == 0.0
	return false


func _emit(row: Dictionary) -> void:
	_rows.append(row)
