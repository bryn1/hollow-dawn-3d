# XP-driven level-up: builds the 3-card offer and applies the pick
# (plan §5 pool: new weapon, weapon level+1, passive; passives cap at 5).
class_name LevelUpDeck
extends RefCounted

const MAX_PASSIVE_STACKS := 5
const MAX_WEAPON_SLOTS := 6 # carry caps (PARITY-ROADMAP M1 feature 3): OUR numbers
const MAX_PASSIVE_KINDS := 6 # — 6 weapon slots + 6 passive KINDS, pool-gated here

const PASSIVES := [
	{"key": "ferocity", "name": "Ferocity", "desc": "+10% weapon damage"},
	{"key": "haste", "name": "Haste", "desc": "+8% move speed"},
	{"key": "ward", "name": "Warding", "desc": "-1 damage taken"},
	{"key": "grip", "name": "Grip", "desc": "+25% pickup radius"},
	{"key": "insight", "name": "Insight", "desc": "+15% xp gain"},
	# The ten weapon partner kinds (PARITY-ROADMAP rev3 feature 6 table,
	# T-M1h; OUR desc rows). Each carries the ONE icon naming convention
	# (passives/icon-<key>.png, screens.gd PASSIVE_ICONS; T-M1c batch).
	{"key": "cracked-heart", "name": "Cracked Heart", "desc": "+10 max hp"},
	{"key": "iron-wrap", "name": "Iron Wrap", "desc": "+6% proj speed"},
	{"key": "tall-candles", "name": "Tall Candles", "desc": "+6% weapon area"},
	{"key": "four-leaf-charm", "name": "Four-Leaf Charm", "desc": "+luck (M2)"},
	{"key": "knotted-chain", "name": "Knotted Chain", "desc": "+8% proj duration"},
	{"key": "loadstone", "name": "Loadstone", "desc": "+25% pickup radius"},
	{"key": "rotten-plate", "name": "Rotten Plate", "desc": "-1 damage taken"},
	{"key": "twin-runes", "name": "Twin Runes", "desc": "+1 projectile"},
	{"key": "gall-vial", "name": "Gall Vial", "desc": "+8% weapon damage"},
	{"key": "gilded-skull", "name": "Gilded Skull", "desc": "+8% xp gain"},
]


static func build_pool(game: GameState) -> Array:
	var pool: Array = []
	# Carry caps (PARITY-ROADMAP M1 feature 3, the two clauses in this one
	# pool seam): NEW weapon kinds stop at MAX_WEAPON_SLOTS carried and NEW
	# passive KINDS stop at MAX_PASSIVE_KINDS distinct carried. What is ALREADY
	# carried stays offerable for its own upgrades: weapons to MAX_LEVEL,
	# passive kinds to MAX_PASSIVE_STACKS (the 5-stack cap, untouched).
	var slots_full: bool = game.weapons.size() >= MAX_WEAPON_SLOTS
	var passive_kinds: int = 0
	for key in game.passives:
		if game.passives[key] > 0:
			passive_kinds += 1
	for id in WeaponSystem.IDS:
		var owned: Dictionary = {}
		for w in game.weapons:
			if w.id == id:
				owned = w
				break
		var meta: Dictionary = WeaponSystem.META[id]
		if owned.is_empty():
			if not slots_full: # new kind only while a slot is open
				pool.append({"kind": "weapon", "id": id, "name": meta.name,
					"desc": meta.desc, "icon": meta.icon})
		elif owned.level < WeaponSystem.MAX_LEVEL:
			pool.append({"kind": "upgrade", "id": id, "name": meta.name,
				"desc": meta.desc, "icon": meta.icon, "to_level": owned.level + 1})
	for passive in PASSIVES:
		var stacks: int = game.passives[passive.key]
		if stacks >= MAX_PASSIVE_STACKS:
			continue # the 5-stack cap per carried kind (unchanged)
		if stacks == 0 and passive_kinds >= MAX_PASSIVE_KINDS:
			continue # a NEW kind never breaks the 6-KIND carry cap
		pool.append({"kind": "passive", "key": passive.key,
			"name": passive.name, "desc": passive.desc, "icon": ""})
	return pool


# Nothing left to grant (everything capped): offer a rich consolation.
static func bonus_card() -> Dictionary:
	return {"kind": "bonus", "name": "Coin Cache", "desc": "+25 gold, +10 hp", "icon": "coin"}


# M4 pillar C (MC 11365 T-M4l, M4-SPEC §3.1): the LIMIT-BREAK-LITE rows —
# pool-exhaustion FALLBACK offers, NOT pool kinds (the §j roster stays 32;
# the s8 A7 text row names the trio beside them, R7). Reached only when
# make_offer("", ...) finds the built pool EMPTY (the §2 all-maxed loadout
# IS the exhaustion state); the tier/gold paths never touch this table and
# the bonus fill above stays the ONLY fallback for kind != "". Repeatable
# forever: each pick bumps game.limit[key] (game_state.gd), read at the
# THREE additive zero-identity seams there. Icons are INLINE names of
# EXISTING shipped files — the screens.gd icon_path() `_:` catch-all
# resolves them exactly how the shipped bonus row rides "coin" (P3-5: no
# LIMIT_ICONS mapping, no screens.gd change, assert-per-file kept armed).
const LIMIT_CARDS := [
	{"kind": "limit", "key": "dmg", "name": "LIMIT · FURY",
		"desc": "+4% weapon damage", "icon": "icon-cleaver"},
	{"kind": "limit", "key": "spd", "name": "LIMIT · HASTE",
		"desc": "+3% move speed", "icon": "icon-dart-loop"},
	{"kind": "limit", "key": "arm", "name": "LIMIT · BULWARK",
		"desc": "-1 damage taken", "icon": "icon-plate"},
]


# kind (M2 §B.1, MC 11239 T-M2t): the frozen offer seam EXTENDED for tier
# reward kinds — weapon/passive offers draw the SAME build_pool filtered to
# their category, a gold offer takes an empty pool so the untouched
# bonus_card fill below IS the reward (the one gold-card mechanism, ours).
# kind "" (every pre-tier call) is the verbatim full pool — the shuffle
# consumes the same RNG and the same three cards come out.
static func make_offer(game: GameState, kind := "") -> Array:
	var pool := build_pool(game)
	match kind:
		"weapon":
			pool = pool.filter(func(c): return c.kind == "weapon" or c.kind == "upgrade")
		"passive":
			pool = pool.filter(func(c): return c.kind == "passive")
		"gold":
			pool = []
	# M4 §3.1 (T-M4l): the pool-exhaustion fallback — ONLY the unkinded
	# level-up funnel (kind "") and ONLY on an EMPTY pool (the §2 all-maxed
	# loadout); the tier/gold paths never reach LIMIT_CARDS and the bonus
	# fill below stays the ONE fallback for kind != "" (C-E4 law: the two
	# committed bonus rows are the living red probe if this moves).
	# duplicate(): shuffle() below mutates the array it is handed — the
	# const is shared and the offer must never alias it.
	if kind == "" and pool.is_empty():
		pool = LIMIT_CARDS.duplicate()
	pool.shuffle()
	var cards: Array = []
	for i in 3:
		cards.append(pool[i] if i < pool.size() else bonus_card())
	return cards


static func apply_offer(game: GameState, card: Dictionary) -> void:
	match card.kind:
		"weapon":
			game.weapons.append({"id": card.id, "level": 1, "cd": 0.0})
		"upgrade":
			for w in game.weapons:
				if w.id == card.id and w.level < WeaponSystem.MAX_LEVEL:
					w.level += 1
					break
		"passive":
			game.passives[card.key] += 1
			if card.key == "cracked-heart":
				# +10 max hp (and +10 with it) per stack, applied AT the ONE
				# passive pick site — the same event application seam the
				# Coin Cache bonus uses for its +10 hp (M1h partner row).
				game.max_hp += 10.0
				game.hp += 10.0
		"limit":
			# M4 §3.1 (T-M4l): a LIMIT card pick bumps the run's counter —
			# repeatable forever (the caps stay untouched; the exhaustion
			# state IS the loadout, so the pool never re-opens). The three
			# additive zero-identity seams live in game_state.gd.
			game.limit[card.key] += 1
		_:
			game.gold += 25
			game.hp = minf(game.max_hp, game.hp + 10.0)
