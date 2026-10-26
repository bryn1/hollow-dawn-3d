# THE LIMIT-BREAK-LITE legs for M4 pillar C (MC 11365, T-M4l; M4-SPEC
# rev-3 §3.3 ACCEPT rows C-E1..C-E4). Same headless funnel as sim_endless/
# sim_events/sim_reaper: the REAL Main.tscn, screens stubbed, every run
# started through the real _start_game; the all-maxed state is the §2
# WORST-CASE LOADOUT pinned exactly as sim_budget constructs it (the same
# script's own LOADOUT/PARTNERS arrays — zero new mechanism, C-E1 as
# written). Seed-pinned (HD3D_SEED, default 11365 = the card id, the
# sim_events seed law) so the dump is byte-stable; the committed copy
# tests/fixtures/limit-m4.jsonl gates tests/test_limit_break.py. Per-leg
# dump env HD3D_LIMIT_DUMP. DawnWell save wiped per leg ownership; the
# whole channel runs under a throwaway XDG_DATA_HOME (save isolation, the
# sim_reaper pattern).
# ROWS (row-id -> the ACCEPT row it pins):
#   limit_all_maxed  C-E1: the §2 loadout at caps/L8 ⇒ build_pool EMPTY;
#       every one of 100 real level-up offers is 3 LIMIT cards, kind "" —
#       the OFFER never contains "bonus" in that state; offer rows carry
#       the three inline icon names through the screens.gd icon_path()
#       `_:` catch-all, resolved IN-LEG (the P3-5 instrument: an icon
#       name with no shipped file trips the in-code assert here); half
#       the offers ride the REAL _pick seam and the run.limit counters
#       match the picked keys (repeatability).
#   limit_near_cap   C-E2 (both sides): 5 slots + 5 KINDS ⇒ the pool is
#       NON-empty by two independent cap clauses ⇒ ZERO limit rows across
#       100 offers; sim_caps' committed caps-pool legs stay green (byte
#       corpus + test_levelup_caps.py, byte_identity is the capture's).
#   limit_math       C-E3: the formula rows — dmg 1+0.1f+0.08g+0.04k,
#       speed 140(1+0.08h)(1+0.03m), intake raw-ward-rotten-1n clamped
#       >= 0 (Bulwark never heals) — at 0 picks every row equals the
#       shipped byte values (exact float equality, the zero-identity
#       twin; the shop_probe/maxhp exact-formula precedent).
#   limit_gold_law   C-E4 (dump half): ON THE EXHAUSTED state, kind "gold"
#       still hands the untouched bonus_card fill and no limit row enters
#       ANY kind-qualified offer; the committed bonus rows + the allowed-
#       set pins ride their untouched files.
#   limit_snapshot   §3.1 state law: limit lives OUTSIDE the frozen
#       12-field Contract B snapshot (the B-E5 instrument shape).
#   limit_verdict last.
extends SceneTree

const OFFERS := 100 # the sim_caps offer-count precedent (roadmap "100 dumped offers")
const SEED_DEFAULT := 11365 # the card id (the sim_events seed law, MC 11365)

var _funnel := SimFunnel.new() # rows/ok/check: the ONE harness (MC 11317 C3)
var _started := false


func _out_path() -> String:
	return SimFunnel.out_path("HD3D_LIMIT_DUMP", "/tmp/hd3d-limit-m4.jsonl")


func _process(_delta: float) -> bool:
	if not _started:
		_started = true
		print("LIMIT_START")
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else SEED_DEFAULT)
		DawnWell.new().reset() # clean well (save.gd's own reset verb)
		_run_legs()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		assert(f != null)
		for r in _funnel.rows:
			f.store_line(JSON.stringify(r))
		f.close()
		print("LIMIT_OK rows=%d ok=%s" % [_funnel.rows.size(), str(_funnel.ok)])
		quit(0 if _funnel.ok else 3)
	return false


# --- channel helpers ----------------------------------------------------------

# The §2 WORST-CASE LOADOUT EXACTLY as sim_budget constructs it (C-E1 as
# written: the same script's own LOADOUT/PARTNERS arrays, the same level-8 /
# 5-stack pin — the sim_boss._pin_full_build channel, zero new mechanism).
# DECLARED (sim_budget's own header): the six evolved ids are CHEST-ONLY
# entries the pool never offers and the fire path no-ops an unknown id, so
# the pin is SAFE headless.
func _pin_worst_case(run: Node) -> void:
	var budget = load("res://sim/sim_budget.gd")
	var build: Array = []
	for id in budget.LOADOUT:
		build.append({"id": id, "level": 8, "cd": 0.0})
	run.game.weapons = build # DECLARED pin (SimCombat pattern)
	for k in budget.PARTNERS:
		run.game.passives[k] = 5 # DECLARED pin: real keys at the 5-stack cap


# --- legs ---------------------------------------------------------------------

# C-E1: the exhaustion state IS the §2 loadout (6/6 slots at MAX_LEVEL,
# 6/6 carried kinds at the 5-stack cap — build_pool returns empty). Every
# subsequent offer is 3 LIMIT cards, never a bonus; icons resolve through
# the shipped `_:` catch-all; every other offer rides the real _pick seam
# and the counters follow the picked keys (repeatable forever).
func _leg_all_maxed() -> void:
	var run := SimFunnel.fresh_run(root, {"wire_pick": true, "wipe_well": true})
	_pin_worst_case(run)
	var game = run.game
	var pool_empty := LevelUpDeck.build_pool(game).is_empty()
	var screens_script = load("res://scripts/screens.gd")
	var kind_counts := {}
	var icons_seen: Array = []
	var bonus_rows := 0
	var picked := 0
	var pick_keys := {"dmg": 0, "spd": 0, "arm": 0}
	var icon_paths_ok := true
	for i in OFFERS:
		game.pending_levels = 1
		run._enter_levelup() # the exact call _step makes (main.gd) — real funnel
		for c in run._current_offer:
			kind_counts[c.kind] = int(kind_counts.get(c.kind, 0)) + 1
			if c.kind == "bonus":
				bonus_rows += 1
			# P3-5 instrument: the SAME static the real card build calls;
			# its `_:` arm asserts the shipped file exists (planted bad
			# icon = the assert fires IN-LEG, capture-proven RED).
			var p: String = screens_script.icon_path(c)
			if p != "res://assets/icons/%s.png" % c.icon:
				icon_paths_ok = false
			if not icons_seen.has(c.icon):
				icons_seen.append(c.icon)
		if i % 2 == 0:
			# the REAL pick seam (wire_pick -> run._pick -> apply_offer's
			# "limit" arm): card 0's key is the counter that must move. A
			# card without a key (kind "bonus" — the shape the planted
			# "fallback removed" RED hands back) counts ZERO everywhere,
			# so the failure lands in the checks, never in a runtime error.
			var card0: Dictionary = run._current_offer[0]
			var k0: String = String(card0.get("key", ""))
			if pick_keys.has(k0):
				pick_keys[k0] += 1
				picked += 1
			else:
				pick_keys["none"] = int(pick_keys.get("none", 0)) + 1
			run._pick(0)
		else:
			SimFunnel.decline(run)
	icons_seen.sort()
	var total: int = OFFERS * 3
	var counters_ok: bool = picked == pick_keys.dmg + pick_keys.spd \
			+ pick_keys.arm and game.limit.dmg == pick_keys.dmg \
			and game.limit.spd == pick_keys.spd and game.limit.arm == pick_keys.arm
	_funnel.check("limit_all_maxed", {
		"pool_exhausted": pool_empty, # the §2 loadout IS the trigger state
		"all_limit": kind_counts.size() == 1 \
				and int(kind_counts.get("limit", -1)) == total,
		"never_bonus": bonus_rows == 0, # the shipped fill never coexists
		"three_icons": icons_seen == ["icon-cleaver", "icon-dart-loop",
 				"icon-plate"], # the inline names, verbatim
		"icons_resolve": icon_paths_ok, # icon_path() `_:` catch-all, in-leg
		"counters_match": counters_ok, # real _pick -> apply_offer bumps
		"pool_stays_empty": LevelUpDeck.build_pool(game).is_empty(), # forever
	}, {"kind_counts": kind_counts, "icons": icons_seen, "offers": OFFERS,
		"picked": picked, "limit": game.limit,
		"declared": "sim_budget _pin_worst_case verbatim (§2 loadout); half " +
 				"the offers picked through the real _pick seam, half declined"})


# C-E2 (both sides): NEAR the cap (5 slots + 5 KINDS — both clauses one
# below their edge) the pool is NON-empty and the fallback never fires:
# zero limit rows across 100 real offers; every row is a pool card.
func _leg_near_cap() -> void:
	var run := SimFunnel.fresh_run(root, {"wire_pick": true, "wipe_well": true})
	# DECLARED pins (the sim_caps shapes): 5 REAL weapons below L8 + 5
	# carried KINDS @1 — weapons upgrade rows + 10 un-carried weapon kinds
	# + 10 un-carried kinds stay in the pool.
	run.game.weapons.clear()
	for r in [["talon", 1], ["ember", 2], ["cleaver", 3], ["halo", 4],
			["ward", 5]]:
		run.game.weapons.append({"id": r[0], "level": r[1], "cd": 0.0})
	for key in ["ferocity", "haste", "ward", "grip", "cracked-heart"]:
		run.game.passives[key] = 1
	var pool_nonempty := not LevelUpDeck.build_pool(run.game).is_empty()
	var limit_rows := 0
	var pool_rows := 0
	for i in OFFERS:
		run.game.pending_levels = 1
		run._enter_levelup()
		for c in run._current_offer:
			if c.kind == "limit":
				limit_rows += 1
			if c.kind == "weapon" or c.kind == "upgrade" or c.kind == "passive":
				pool_rows += 1
		SimFunnel.decline(run)
	_funnel.check("limit_near_cap", {
		"pool_nonempty": pool_nonempty,
		"zero_limit": limit_rows == 0, # planted early-fallback reddens this
		"pool_offers_present": pool_rows == OFFERS * 3, # every row a pool card
	}, {"limit_rows": limit_rows, "pool_rows": pool_rows, "offers": OFFERS,
		"declared": "pins: 5 real weapons < L8 + 5 carried kinds @1 " +
 				"(sim_caps weapon_below_cap / passive_below_kinds shapes)"})


# C-E3: the stat math at the THREE seams. DECLARED: bare GameState (the
# shop_probe exact-formula precedent), partners/originals pinned at real
# stack counts (the formulas' own terms — pins, not balance claims), and
# the picks applied through apply_offer — the exact call main._pick makes —
# with the shipped LIMIT_CARDS rows themselves.
func _leg_math() -> void:
	var game := GameState.new()
	game.start_run()
	# The zero-picks twin: with limit 0 every row equals the SHIPPED byte
	# values (exact float equality — the corpora ride this identity).
	var m0: float = game.damage_multiplier()
	var s0: float = game.player_speed()
	var t0: float = game.damage_taken(37.0)
	game.passives.ferocity = 2
	game.passives["gall-vial"] = 3
	game.passives.haste = 4
	game.passives.ward = 1
	game.passives["rotten-plate"] = 2
	for i in 2: # k fury picks (+4% weapon damage each)
		LevelUpDeck.apply_offer(game, LevelUpDeck.LIMIT_CARDS[0])
	for i in 3: # m haste picks (+3% move speed each)
		LevelUpDeck.apply_offer(game, LevelUpDeck.LIMIT_CARDS[1])
	for i in 2: # n bulwark picks (-1 damage taken each)
		LevelUpDeck.apply_offer(game, LevelUpDeck.LIMIT_CARDS[2])
	var dmg: float = game.damage_multiplier()
	var spd: float = game.player_speed()
	var intake: float = game.damage_taken(10.0)
	var clamped: float = game.damage_taken(0.5)
	_funnel.check("limit_math", {
		"zero_bytes_exact": m0 == 1.0 and s0 == 140.0 and t0 == 37.0,
		"fury_math": dmg == 1 + 0.1 * 2 + 0.08 * 3 + 0.04 * 2,
		"haste_math": spd == 140.0 * (1.0 + 0.08 * 4) * (1.0 + 0.03 * 3),
		"bulwark_math": intake == 10.0 - 1.0 - 2.0 - 1.0 * 2,
		"clamped_ge_zero": clamped == 0.0, # intake never heals (maxf law)
		"counters": game.limit.dmg == 2 and game.limit.spd == 3 \
				and game.limit.arm == 2,
	}, {"dmg_mult": dmg, "speed": spd, "intake_10": intake,
		"intake_0p5": clamped, "limit": game.limit,
		"mult_0": m0, "speed_0": s0, "intake_0": t0,
		"pins": {"ferocity": 2, "gall_vial": 3, "haste": 4, "ward": 1,
				"rotten_plate": 2, "k_fury": 2, "m_haste": 3, "n_bulwark": 2},
		"declared": "bare GameState + DECLARED passive pins (the exact-" +
 				"formula precedent); picks applied through apply_offer"})


# C-E4 (dump half): the exhaustion state changes NOTHING for the kinded
# paths — kind "gold" still hands the untouched bonus fill (the ONE gold
# mechanism) and no limit row enters a weapon/passive/gold offer. The
# committed bonus rows (chests-tiers-m2 / chests-evolve-m1e) and the
# test_chests_tiers allowed-set pins ride their untouched files.
func _leg_gold_law() -> void:
	var run := SimFunnel.fresh_run(root, {"wire_pick": true, "wipe_well": true})
	_pin_worst_case(run) # EXHAUSTED pool — the fallback's own trigger state
	var offers := {}
	for kind in ["gold", "weapon", "passive"]:
		var kinds: Array = []
		for c in LevelUpDeck.make_offer(run.game, kind):
			kinds.append(c.kind)
		offers[kind] = kinds
	var no_limit := true
	for kind in offers:
		for k in offers[kind]:
			if k == "limit":
				no_limit = false
	_funnel.check("limit_gold_law", {
		"gold_bonus_fill": offers["gold"] == ["bonus", "bonus", "bonus"],
		"no_limit_in_kind_offers": no_limit,
	}, {"offers": offers,
		"note": "kind != \"\" never reaches LIMIT_CARDS (§3.1): the empty " +
 				"filtered/gold pools keep riding the untouched bonus_card fill"})


# §3.1 state law (the B-E5 instrument shape): the limit dict lives OUTSIDE
# the frozen Contract B snapshot; a 13th field named limit is the planted
# RED (test_endless's exact-12 source pin reddens with it).
func _leg_snapshot() -> void:
	var game := GameState.new()
	game.start_run()
	game.limit = {"dmg": 2, "spd": 1, "arm": 1} # a picked-up limit state
	var snap: Dictionary = JSON.parse_string(game.snapshot_json(0))
	var keys: Array = snap.keys()
	keys.sort()
	var expected: Array = ["enemies", "gold", "hp", "kills", "level", "maxHp",
		"phase", "runId", "time", "weapons", "xp", "xpNext"]
	expected.sort()
	_funnel.check("limit_snapshot", {
		"exact_12": keys == expected,
		"limit_absent": not keys.has("limit"),
	}, {"keys": keys, "count": keys.size()})


func _run_legs() -> void:
	_leg_all_maxed()
	_leg_near_cap()
	_leg_math()
	_leg_gold_law()
	_leg_snapshot()
	_funnel.rows.append({"ev": "limit_verdict", "ok": _funnel.ok,
		"rows": _funnel.rows.size()})
