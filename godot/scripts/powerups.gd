# The Dawn Well shop table + rules (T-M1f, MC 11210; PARITY-ROADMAP rev3 M1
# feature 2). OUR numbers table: 24 power-up rows (the doc's 24/25 count row
# resolves to 24 OUR rows), each with a name, effect family (stat), per-rank
# value, base cost and a proof-scope column. Rank curve OUR row: MAX_RANK = 5
# everywhere; cost curve OUR row: cost at current rank r is base * (r + 1)
# (linear, pinned by tests/test_dawnwell_shop.py alongside the table).
# REFUND_FEE_PCT is the doc's pinned table row (5, floor division — int/int in
# GDScript floors, so refund_for() IS the roadmap formula per rank:
# floor(base * rank * (100 - 5) / 100); refund-all is the sum of those floors,
# matching the doc's "gold returned == Σ spent floor × (1 - FEE/100)").
# Proof split (DA c1 B-5): scope "m1" rows are the snapshot-EXPOSED stats
# (maxHp / xpNext unchanged / gold-rate) whose effects apply at start_run()
# through game_state.gd; scope "m2" rows (speed/area/cooldown/luck-class and
# the other carried families) stay purchasable but run-effectless until the
# M2 dump-probe card — the sealed leg asserts that.
# Consumers: the shop UI (screens.gd), main.gd's verbs, godot/sim/shop_probe
# .gd. Persistence is DawnWell (save.gd) UNTOUCHED: buy/refund/refund_all
# mutate a passed-in save object only; the caller lands it through main's
# ONE _meta_changed() funnel (T-M1a contract).
class_name PowerUps
extends RefCounted

const REFUND_FEE_PCT := 5
const MAX_RANK := 5 # OUR ranks row: one cap for every power-up row

# One row per line — the pytest regex-pin reads ids/stat/per/cost/scope here.
const TABLE := [
	{"id": "vitality", "name": "Vitality", "desc": "+10 max HP", "stat": "maxhp", "per": 10, "cost": 40, "scope": "m1"},
	{"id": "bulwark", "name": "Bulwark", "desc": "+10 max HP", "stat": "maxhp", "per": 10, "cost": 55, "scope": "m1"},
	{"id": "ironbones", "name": "Ironbones", "desc": "+10 max HP", "stat": "maxhp", "per": 10, "cost": 70, "scope": "m1"},
	{"id": "deep-roots", "name": "Deep Roots", "desc": "+10 max HP", "stat": "maxhp", "per": 10, "cost": 90, "scope": "m1"},
	{"id": "sage-thirst", "name": "Sage Thirst", "desc": "+10% xp gain", "stat": "xp", "per": 0.1, "cost": 60, "scope": "m1"},
	{"id": "dusk-ledger", "name": "Dusk Ledger", "desc": "+10% xp gain", "stat": "xp", "per": 0.1, "cost": 85, "scope": "m1"},
	{"id": "grave-scholar", "name": "Grave Scholar", "desc": "+10% xp gain", "stat": "xp", "per": 0.1, "cost": 110, "scope": "m1"},
	{"id": "pale-wisdom", "name": "Pale Wisdom", "desc": "+10% xp gain", "stat": "xp", "per": 0.1, "cost": 140, "scope": "m1"},
	{"id": "grave-greed", "name": "Grave Greed", "desc": "+10% gold from pickups", "stat": "gold", "per": 0.1, "cost": 100, "scope": "m1"},
	{"id": "coin-cup", "name": "Coin Cup", "desc": "+10% gold from pickups", "stat": "gold", "per": 0.1, "cost": 130, "scope": "m1"},
	{"id": "bone-market", "name": "Bone Market", "desc": "+10% gold from pickups", "stat": "gold", "per": 0.1, "cost": 165, "scope": "m1"},
	{"id": "tithe-bell", "name": "Tithe Bell", "desc": "+10% gold from pickups", "stat": "gold", "per": 0.1, "cost": 200, "scope": "m1"},
	{"id": "swift-shroud", "name": "Swift Shroud", "desc": "Sealed until the second dawn: move speed", "stat": "speed", "per": 0.05, "cost": 90, "scope": "m2"},
	{"id": "ghost-foot", "name": "Ghost Foot", "desc": "Sealed until the second dawn: move speed", "stat": "speed", "per": 0.05, "cost": 120, "scope": "m2"},
	{"id": "wide-reap", "name": "Wide Reap", "desc": "Sealed until the second dawn: area", "stat": "area", "per": 0.05, "cost": 110, "scope": "m2"},
	{"id": "crescent-arc", "name": "Crescent Arc", "desc": "Sealed until the second dawn: area", "stat": "area", "per": 0.05, "cost": 145, "scope": "m2"},
	{"id": "quick-hands", "name": "Quick Hands", "desc": "Sealed until the second dawn: cooldown", "stat": "cooldown", "per": 0.05, "cost": 120, "scope": "m2"},
	{"id": "toll-tempo", "name": "Toll Tempo", "desc": "Sealed until the second dawn: cooldown", "stat": "cooldown", "per": 0.05, "cost": 160, "scope": "m2"},
	{"id": "raven-feather", "name": "Raven Feather", "desc": "Sealed until the second dawn: luck", "stat": "luck", "per": 0.05, "cost": 130, "scope": "m2"},
	{"id": "egg-of-dawn", "name": "Egg of Dawn", "desc": "Sealed until the second dawn: luck", "stat": "luck", "per": 0.05, "cost": 170, "scope": "m2"},
	{"id": "split-silhouette", "name": "Split Silhouette", "desc": "Sealed until the second dawn: projectiles", "stat": "projectile", "per": 1, "cost": 200, "scope": "m2"},
	{"id": "echo-vessel", "name": "Echo Vessel", "desc": "Sealed until the second dawn: projectiles", "stat": "projectile", "per": 1, "cost": 240, "scope": "m2"},
	{"id": "magnet-bone", "name": "Magnet Bone", "desc": "Sealed until the second dawn: pickup radius", "stat": "pickup", "per": 0.1, "cost": 100, "scope": "m2"},
	{"id": "moss-mail", "name": "Moss Mail", "desc": "Sealed until the second dawn: armor", "stat": "armor", "per": 1, "cost": 150, "scope": "m2"},
]


static func row(id: String) -> Dictionary:
	for r in TABLE:
		if r.id == id:
			return r
	return {}


# OUR cost curve: the next rank on a row costs base * (current_rank + 1).
static func cost(id: String, current_rank: int) -> int:
	var r := row(id)
	return int(r.cost) * (current_rank + 1) if not r.is_empty() else 0


# Per-rank refund: what rank number `rank` (1..MAX_RANK) paid back, minus the
# fee. int * int / int floors in GDScript — the doc's floor division verbatim.
static func refund_for(id: String, rank: int) -> int:
	if rank <= 0:
		return 0
	var r := row(id)
	if r.is_empty():
		return 0
	return int(r.cost) * rank * (100 - REFUND_FEE_PCT) / 100


# --- mutations on a DawnWell save (caller persists via main._meta_changed) --

static func buy(well: DawnWell, id: String) -> bool:
	var r := row(id)
	if r.is_empty():
		return false
	var rank := int(well.ranks.get(id, 0))
	if rank >= MAX_RANK: # disable-when-maxed rule (S7 ~610), rule-side twin
		return false
	var price := cost(id, rank)
	if well.gold < price:
		return false
	well.gold -= price
	well.ranks[id] = rank + 1
	return true


# ONE rank back: returns the gold it gave, 0 at rank 0 (the floor — a refund
# can never dig below rank 0 nor pay for nothing).
static func refund(well: DawnWell, id: String) -> int:
	var rank := int(well.ranks.get(id, 0))
	if rank <= 0:
		return 0
	if row(id).is_empty():
		return 0
	var give := refund_for(id, rank)
	well.ranks[id] = rank - 1
	well.gold += give
	return give


# The shop's REFUND-ALL button (their refund-all semantics, S7 ~609, OUR fee):
# every owned rank on every row returns floor(paid * 95 / 100) each — the Σ
# the roadmap refund leg asserts — and every rank lands on the floor 0.
static func refund_all(well: DawnWell) -> int:
	var total := 0
	for r in TABLE:
		var rank := int(well.ranks.get(r.id, 0))
		for k in range(rank, 0, -1):
			total += refund_for(r.id, k)
		if rank > 0:
			well.ranks[r.id] = 0
	well.gold += total
	return total


# --- effect aggregates (consumed at GameState.start_run, M1-scope rows only) -

static func max_hp_bonus(ranks: Dictionary) -> float:
	var total := 0.0
	for r in TABLE:
		if r.stat == "maxhp":
			total += float(r.per) * int(ranks.get(r.id, 0))
	return total


static func xp_bonus(ranks: Dictionary) -> float:
	var total := 0.0
	for r in TABLE:
		if r.stat == "xp":
			total += float(r.per) * int(ranks.get(r.id, 0))
	return total


static func gold_bonus(ranks: Dictionary) -> float:
	var total := 0.0
	for r in TABLE:
		if r.stat == "gold":
			total += float(r.per) * int(ranks.get(r.id, 0))
	return total
