# Chest-driven weapon evolutions (PARITY-ROADMAP rev3 M1 feature 5). OUR
# rule, OUR gate value: weapon at MAX + its partner passive carried (ANY
# rank) + a chest opened at t >= 600 replaces the base weapon with its
# evolved form IN-SLOT (roadmap feature 3: "evolutions replace in-slot,
# never add a 7th") and resets its cooldown. Gate provenance (DA c1 G-1):
# 600 is OUR own v1 WIN_TIME — the source page's 10:00 is a stated
# coincidence, not the source of the number.
# The table is the feature-6 partner column (the doc's table is OUR content;
# DA c3 C-2: evolved ids ride THIS separate table, never WeaponSystem.META,
# keeping the 16/32 WEAPON_KEYS pin math true). Base/partner/evolved ids
# follow the ONE icon naming convention (assets/icons/icon-<id>.png — the
# ten evo icons + ten partner-passive icons shipped by T-M1c, manifest
# tools/vm100/icons-batch-m1c.tsv. SINCE T-M1h (MC 11220) the ten base
# weapons ride WeaponSystem.IDS/META and the ten partners ride levelup.gd
# PASSIVES — the TABLE is LIVE: the pool can offer both parts, and
# sim_evolve's reachability + full-evolution legs ride that (the evolved
# ids still stay out of META, DA c3 C-2, keeping the 16/32 math true).
class_name EvolutionSystem
extends RefCounted

const GATE_T := 600.0 # chest must OPEN at t >= 600 (our value, DA c1 G-1)

# base weapon id -> {partner passive key, evolved id}. First eligible weapon
# in game.weapons order evolves per chest (stated reading: one chest, one
# evolution — the doc's supply row "≤ 3 chest rolls vs 6 evolutions" only
# reads as one evolution per chest).
const TABLE := {
	"bone-whip": {"partner": "cracked-heart", "evo": "red-wail"},
	"dart-loop": {"partner": "iron-wrap", "evo": "thousand-darts"},
	"hewn-axe": {"partner": "tall-candles", "evo": "rot-spiral"},
	"pilgrim-cross": {"partner": "four-leaf-charm", "evo": "judgement-cross"},
	"censer-of-hours": {"partner": "knotted-chain", "evo": "eternal-matins"},
	"rot-water": {"partner": "loadstone", "evo": "the-sluice"},
	"spectral-disc": {"partner": "rotten-plate", "evo": "grave-orbit"},
	"storm-peal": {"partner": "twin-runes", "evo": "rolling-thunder"},
	"fire-lash": {"partner": "gall-vial", "evo": "inferno-lash"},
	"doom-sigil": {"partner": "gilded-skull", "evo": "pale-moon"},
}


# The ONE rule entry, called at the chest-open site (world.gd collect).
# Returns the evolved id when an evolution landed, "" otherwise. The whole
# rule lives here: the gate reads game.time at OPEN time, MAX is the one
# WeaponSystem.MAX_LEVEL, and "carried" is passives.get(partner, 0) >= 1
# (feature 7's keys are new dict entries — .get keeps this total before
# they ship). Replacement is in-slot: same array position, level kept,
# cd reset (the doc's "reset its cooldown").
static func try_evolve(game: GameState) -> String:
	if game.time < GATE_T:
		return ""
	for w in game.weapons:
		var row: Dictionary = TABLE.get(w.id, {})
		# Rev-2 P3-6 RESERVE (T-M2u, union.gd header): a TABLE weapon that
		# is a UNION base is skipped while its union partner is carried
		# below MAX — evolving it now would permanently foreclose that
		# union cross-time (rot-water/censer-of-hours are both an evolution
		# base and a union base). Partner gone => union unreachable => the
		# reserve lifts and this row evolves as before.
		if row.is_empty() or w.level < WeaponSystem.MAX_LEVEL \
				or int(game.passives.get(row.partner, 0)) < 1 \
				or UnionSystem.reserved_for_union(game, w.id):
			continue
		w.id = row.evo
		w.cd = 0.0
		return row.evo
	return ""
