# Weapon unions (M2-SPEC rev-2 §D, MC 11240 T-M2u): two MAX-level base
# weapons + the recipe passive carried (ANY rank, the evolutions.gd
# carried-rule shape) + a chest opened at t >= GATE_T replace BOTH bases
# with the union weapon IN-SLOT at the earlier base's index (spec D.1:
# "removes both base weapons and writes the union weapon in-slot", net
# slot count -1, level reset to 1, cd 0 — feature 3 "never add a 7th").
# The gate is the ONE GATE_T: union.gd REFERENCES EvolutionSystem.GATE_T
# (rev-2 P4-7 — no second 600 literal anywhere). Union ids ride THIS
# separate table, never WeaponSystem.META (DA c3 C-2 mirrored from
# evolutions.gd:9-17): the 16/32 icon math and the pool stay untouched;
# the HUD row resolves a union icon through the ONE naming convention
# (icon-<id>.png, hud_3d.gd fallback) — both union icons shipped in
# T-M2a (tools/vm100/icons-batch-m2.tsv).
# UNION PRECEDENCE > EVOLUTION (spec §Reuse; M6 T-M6p §3.1/§4.4 R5): the
# chest-open arm is UNION-ONLY — the evolution trigger MOVED to the
# level-up pick seam (levelup.apply_offer), so the chest's weapon-transform
# slot holds try_union ALONE (the retired `else try_evolve` line is §4.4
# R5). A state eligible for BOTH still takes the union at the chest, and
# the reserve below keeps its base unevolving until the union is out of
# reach. First eligible row in TABLE order transforms (the
# first-eligible-in-order reading, evolutions.gd:23-26 shape).
# The rev-2 P3-6 RESERVE rule lives in reserved_for_union() below and is
# enforced by EvolutionSystem.try_evolve: a TABLE weapon that is a union
# base must NOT evolve while its union recipe is still ACHIEVABLE — the
# partner base carried BELOW MAX, or AT MAX with the recipe passive
# carried (the union is ELIGIBLE and a live chest can still complete it;
# the window EXTENSION, M6 T-M6p §3.4 option (a): the below-MAX-only
# window was complete only while the two triggers shared the chest site).
# Otherwise the new trigger would evolve rot-water into the-sluice and
# PERMANENTLY foreclose dirge-eternal cross-time (rot-water is both an
# evolution base and a union base). Partner GONE (never carried or since
# changed) means the union is unreachable — the reserve lifts and
# evolution proceeds.
class_name UnionSystem
extends RefCounted

# union id -> the two base weapon ids + the partner passive key, §D.1 as
# written. Both unions are LIVE since T-M1h (MC 11220): all four bases
# ride WeaponSystem.IDS and both partners ride levelup.PASSIVES (D-U1
# pinned by tests/test_unions.py).
const TABLE := {
	"requiem-toll": {"a": "halo", "b": "spike", "passive": "insight"},
	"dirge-eternal": {"a": "censer-of-hours", "b": "rot-water",
		"passive": "loadstone"},
}


# The one rule entry, called at the chest-open site (world.gd collect)
# BEFORE EvolutionSystem.try_evolve. Returns the union id when a union
# landed, "" otherwise.
static func try_union(game: GameState) -> String:
	if game.time < EvolutionSystem.GATE_T:
		return ""
	for uid in TABLE:
		var row: Dictionary = TABLE[uid]
		var ia := _index_of(game, row.a)
		var ib := _index_of(game, row.b)
		if ia < 0 or ib < 0 or game.weapons[ia].level < WeaponSystem.MAX_LEVEL \
				or game.weapons[ib].level < WeaponSystem.MAX_LEVEL \
				or int(game.passives.get(row.passive, 0)) < 1:
			continue
		# Both bases GO; the union rides the EARLIER base's slot (in-slot
		# rule), fresh at level 1 with a reset cooldown (D.1 verbatim).
		var slot := mini(ia, ib)
		game.weapons.remove_at(ia)
		game.weapons.remove_at(ib if ib < ia else ib - 1)
		game.weapons.insert(slot, {"id": uid, "level": 1, "cd": 0.0})
		return uid
	return ""


# Rev-2 P3-6 + M6 T-M6p §3.4 (option (a)): is base_id kept from EVOLVING
# because one of its unions is still reachable? True exactly when a TABLE
# row lists base_id as a base AND that row's recipe is still ACHIEVABLE —
# the row's partner base carried below MAX_LEVEL (the shipped below-MAX
# branch), OR the partner AT MAX_LEVEL with the row's recipe passive
# carried (the ELIGIBLE-at-MAX branch: the union can fire at the next
# chest, so the new pick-site trigger must not foreclose it — the chest-era
# co-location that made the below-MAX-only window complete is gone with
# the moved trigger). One predicate, one TABLE walk, the ONE skip site the
# evolution rule reads (evolutions.gd try_evolve). Called from there only.
static func reserved_for_union(game: GameState, base_id: String) -> bool:
	for row in TABLE.values():
		if row.a != base_id and row.b != base_id:
			continue
		var partner: String = row.b if row.a == base_id else row.a
		for w in game.weapons:
			if w.id != partner:
				continue
			if w.level < WeaponSystem.MAX_LEVEL:
				return true
			if int(game.passives.get(row.passive, 0)) >= 1:
				return true
	return false


static func _index_of(game: GameState, id: String) -> int:
	for i in game.weapons.size():
		if game.weapons[i].id == id:
			return i
	return -1
