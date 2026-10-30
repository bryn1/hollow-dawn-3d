# Level-triggered weapon evolutions (M6-SPEC §3 F3, MC 11697 T-M6p; the
# moved trigger of PARITY-ROADMAP rev3 M1 feature 5). THE RULE (spec §3.1,
# replace-not-delete IN this file — same class_name, same TABLE): a weapon
# at L5 (`at`, EVO_LEVEL) whose partner passive is carried (ANY rank) and
# whose union reserve does not hold EVOLVES AT THE NEXT LEVEL-UP PICK —
# the ONE call site is the tail of the "upgrade"/"passive" arms of
# LevelUpDeck.apply_offer (the two arms that can newly satisfy the
# condition; the "weapon" arm cannot — level 1). The chest era's gate
# (MAX + chest opened at t >= GATE_T) is RETIRED: the `t >= 600` term is
# GONE, replaced by `at`; GATE_T itself STAYS as the union's own chest gate
# (union.gd references it — §4.4 R6, the CONST stays union-side, annotated,
# not deleted). Replacement is IN-SLOT (feature 3: "evolutions replace
# in-slot, never add a 7th"): same array position, level kept, cd reset.
# The table is the feature-6 partner column + the M6 boost columns (OUR
# numbers, one row per base weapon, pinned by tests/test_chests_evolve.py:
# dmg 1.6 / area 1.35 / cd 0.75 — the "big boost in damage, area and
# functionality" row, F-3's forced consequence: evolved ids must FIRE,
# weapons.gd resolves them through effect() below). `feat` = named flags
# from the SHIPPED flag set ONLY (pierce/bounce/ret + the extra-target
# count term) — never a new projectile flag.
# DA c3 C-2 stands: evolved ids ride THIS separate table, never
# WeaponSystem.META, keeping the 31-kind WEAPON_KEYS pin math true (the
# doom-sigil→pale-moon row retired HERE at T-M6p per §4.4 R2, 10→9 rows;
# both icon files KEEP on disk, the art provenance law). Base/partner/
# evolved ids follow the ONE icon naming convention
# (assets/icons/icon-<id>.png — T-M1c, manifest tools/vm100/icons-batch-
# m1c.tsv). SINCE T-M1h (MC 11220) the base weapons ride WeaponSystem.
# IDS/META and the partners ride levelup.gd PASSIVES — the TABLE is LIVE.
class_name EvolutionSystem
extends RefCounted

const GATE_T := 600.0 # the UNION's chest gate (union.gd reads it — §4.4 R6).
					# M6 T-M6p: RETIRED as the evolution gate (the evolution
					# trigger moved to the level-up pick, EVO_LEVEL below).

const EVO_LEVEL := 5 # the evolution level (M6-SPEC §3.1: replaces GATE_T as
					# the evolution gate; every TABLE row's `at` pins equal
					# to this const — tests/test_chests_evolve.py).

const IDENTITY_DMG := 1.0 # the ×1.0 / +0-flag identity that keeps every
const IDENTITY_AREA := 1.0 # un-evolved weapon's math IEEE-identical (the
const IDENTITY_CD := 1.0 # limit-break precedent, spec §3.2).
const IDENTITY_FEAT: Array = [] # READ-ONLY shared identity — consumers OR
					# flags onto their dicts, never mutate this.

# base weapon id -> {partner passive key, evolved id, at, dmg, area, cd,
# feat}. First eligible weapon in game.weapons order evolves per trigger
# pick (the per-pick reading of the old one-per-chest row: ONE evolution
# per applied pick, zero RNG, zero phase change). `feat` picks are OUR
# table (pinned by tests/test_evolve_level.py): every flag rides a flag
# the shipped steppers already honour.
const TABLE := {
	"bone-whip": {"partner": "cracked-heart", "evo": "red-wail",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": []},
	"dart-loop": {"partner": "iron-wrap", "evo": "thousand-darts",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": ["pierce"]},
	"hewn-axe": {"partner": "tall-candles", "evo": "rot-spiral",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": ["ret"]},
	"pilgrim-cross": {"partner": "four-leaf-charm", "evo": "judgement-cross",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": ["pierce"]},
	"censer-of-hours": {"partner": "knotted-chain", "evo": "eternal-matins",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": ["pierce"]},
	"rot-water": {"partner": "loadstone", "evo": "the-sluice",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": []},
	"spectral-disc": {"partner": "rotten-plate", "evo": "grave-orbit",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": ["extra"]},
	"storm-peal": {"partner": "twin-runes", "evo": "rolling-thunder",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": []},
	"fire-lash": {"partner": "gall-vial", "evo": "inferno-lash",
		"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75, "feat": ["extra"]},
	# M6 T-M6p (MC 11697, M6-SPEC §4.4 R2): the "doom-sigil -> pale-moon"
	# row RETIRED HERE with its pool entry (10 -> 9 — the EVOLUTION-SIDE
	# half of the F6 retirement, this card's per §4.1's site split; the
	# weapon side landed at T-M6d). pale-moon retires as a live evolution
	# target; both PNGs KEEP (icons-batch/art-batch + PERMANENCE provenance,
	# R8). tests assert pale-moon absent from every live table.
}


# The ONE boost/identity resolution (M6-SPEC §3.2): weapons.gd asks effect()
# what a weapon id MEANS. Un-evolved ids (and the union ids — their
# behaviour already lives in the orbit branches) resolve to the identity
# row {base: id, ×1.0 multipliers, no flags}; an evolved id resolves to its
# family base + the TABLE row's boosts. Zero RNG, zero state.
static func effect(id: String) -> Dictionary:
	if TABLE.has(id):
		return {"base": id, "dmg": IDENTITY_DMG, "area": IDENTITY_AREA,
			"cd": IDENTITY_CD, "feat": IDENTITY_FEAT}
	for base_id in TABLE:
		var row: Dictionary = TABLE[base_id]
		if row.evo == id:
			return {"base": base_id, "dmg": row.dmg, "area": row.area,
				"cd": row.cd, "feat": row.feat}
	return {"base": id, "dmg": IDENTITY_DMG, "area": IDENTITY_AREA,
		"cd": IDENTITY_CD, "feat": IDENTITY_FEAT}


# The connective-UI read (M6-SPEC §3.3): passive key -> the weapon ids the
# passive CONNECTS to — the partner column of the EVOLUTION table AND of
# union.gd's table (one read over the tables that exist, no second copy;
# PS-E5's law is chips == the partner set over BOTH tables, so insight
# carries the requiem-toll bases and loadstone carries both).
# Deterministic: deduped + sorted. Zero state.
static func affects_by_passive() -> Dictionary:
	var out: Dictionary = {}
	for base_id in TABLE:
		var key: String = TABLE[base_id].partner
		if base_id not in out.get(key, []):
			out[key] = out.get(key, []) + [base_id]
	for row in UnionSystem.TABLE.values():
		var ids: Array = out.get(row.passive, [])
		for base_id in [row.a, row.b]:
			if base_id not in ids:
				ids.append(base_id)
		out[row.passive] = ids
	for key in out:
		out[key].sort()
	return out


# The ONE rule entry, called at the tail of the "upgrade" and "passive"
# arms of LevelUpDeck.apply_offer (the moved trigger, M6-SPEC §3.1 — the
# chest-era call site at world/drops.gd is RETIRED, §4.4 R5). Returns the
# evolved id when an evolution landed, "" otherwise. The whole rule lives
# here: `at` is the level gate (row `at` pins == EVO_LEVEL), "carried" is
# passives.get(partner, 0) >= 1, and the RESERVE skip below reads the ONE
# union predicate. Replacement is in-slot: same array position, level
# kept, cd reset (the doc's "reset its cooldown").
static func try_evolve(game: GameState) -> String:
	for w in game.weapons:
		var row: Dictionary = TABLE.get(w.id, {})
		# RESERVE (T-M2u rev-2 P3-6, WINDOW EXTENDED at M6 T-M6p §3.4
		# option (a)): a TABLE weapon that is a UNION base is skipped while
		# its union recipe is still ACHIEVABLE — the partner base carried
		# below MAX (the shipped window) OR the partner AT MAX with the
		# recipe passive carried (the union is ELIGIBLE and a live chest
		# can still complete it; the chest-era co-location that made the
		# below-MAX-only window complete is gone with the moved trigger).
		# Partner GONE => the union is unreachable => the reserve lifts and
		# this row evolves as before.
		if row.is_empty() or int(w.level) < int(row.at) \
				or int(game.passives.get(row.partner, 0)) < 1 \
				or UnionSystem.reserved_for_union(game, w.id):
			continue
		w.id = row.evo
		w.cd = 0.0
		return row.evo
	return ""
