# The character roster (M5-SPEC §2, T-M5c, MC 11422): the ONE CHARACTERS
# table + the pure rules over it (powerups.gd contract — rules live HERE,
# main holds the DawnWell object). SEL-C = 9 rows: the owner ruling "C"
# (2026-10-27, docs/M5-SPEC.md RULING line) over the §2.5 SEL table —
# row 0 IS the shipped identity (game_state.gd's falsified talon row, the
# IEEE-identity rule: every rule term rides an additive/multiplicative
# default, so a row-0 run is byte-for-byte the shipped game, F-2), and the
# eight new rows ride the spec's rule-field/gate/cost columns (the SEL-B/C
# clause: cost continues the F-6 flat additive curve 1800/2100/2400, gates
# are PILLAR A achievement ids — the cross-pillar same-commit law B-E9).
# Start weapons are shipped ids (weapons.gd IDS — zero new weapon code);
# the rows 6-8 weapon picks are OURS, stated in the LEDGER row (the spec
# names the SEL-C rule fields + gates, not those three weapons).
# THE `duplicate()` LAW (spec §2.2 + DA c2 P4-2, measured on the pinned
# 4.7.2): const rows are DEEP read-only — the sim mutates a run's weapon
# dict (levelup.gd w.level += 1) — so every state-homing hand-out goes
# through duplicate(true) (a shallow one re-shares the rows). start_weapons/
# start_passives are the only hand-out seams; rule() rows are read-only
# reads by contract (no consumer mutates them).
class_name Roster
extends RefCounted

const CHAR_PREFIX := "char:" # well.flags key prefix (F-4: flags ride the
# existing dict, the achv:/stage2 write-1 SET-only law)

# mesh = the GLB family under res://assets/glb/ (row 0 keeps the shipped
# player.glb — the byte law: the pawn's default branch still names it);
# portrait = the §j file family icon-portrait-<id>.png (total resolver,
# assert-exists at every draw site). skins ride empty for every row at
# this card (spec §3.1: only the-vigil's group is populated, and the SKINS
# rows land with T-M5k — wave map; the field rides now so the row shape is
# frozen once).
const CHARACTERS := [
	{"id": "the-vigil", "name": "THE VIGIL", "mesh": "player.glb",
	 "portrait": "icon-portrait-the-vigil", "cost": 0, "gate": "",
	 "skins": [],
	 "desc": "The survivor the night already knows. No boon, no burden.",
	 "start_weapons": [{"id": "talon", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 0, "dmg_pct": 0, "spd_pct": 0, "xp_pct": 0,
	 	"gold_add": 0, "armor_add": 0}},
	{"id": "emberwright", "name": "THE EMBERWRIGHT",
	 "mesh": "char-emberwright.glb",
	 "portrait": "icon-portrait-emberwright", "cost": 300, "gate": "",
	 "skins": [],
	 "desc": "Ember Bolt from the first tick. +8% damage, nothing else.",
	 "start_weapons": [{"id": "ember", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 0, "dmg_pct": 8, "spd_pct": 0, "xp_pct": 0,
	 	"gold_add": 0, "armor_add": 0}},
	{"id": "grave-ward", "name": "THE GRAVE-WARD",
	 "mesh": "char-grave-ward.glb",
	 "portrait": "icon-portrait-grave-ward", "cost": 600, "gate": "",
	 "skins": [],
	 "desc": "Warding aura from the start. Every hit lands one softer.",
	 "start_weapons": [{"id": "ward", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 0, "dmg_pct": 0, "spd_pct": 0, "xp_pct": 0,
	 	"gold_add": 0, "armor_add": 1}},
	{"id": "coinhound", "name": "THE COINHOUND",
	 "mesh": "char-coinhound.glb",
	 "portrait": "icon-portrait-coinhound", "cost": 900, "gate": "",
	 "skins": [],
	 "desc": "Talon Lash, and 40 gold already in the pocket.",
	 "start_weapons": [{"id": "talon", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 0, "dmg_pct": 0, "spd_pct": 0, "xp_pct": 0,
	 	"gold_add": 40, "armor_add": 0}},
	{"id": "duskrunner", "name": "THE DUSKRUNNER",
	 "mesh": "char-duskrunner.glb",
	 "portrait": "icon-portrait-duskrunner", "cost": 1200,
	 "gate": "achv:kills-50k",
	 "skins": [],
	 "desc": "Dart Loop and +6% speed. The gate wants 50 000 fells.",
	 "start_weapons": [{"id": "dart-loop", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 0, "dmg_pct": 0, "spd_pct": 6, "xp_pct": 0,
	 	"gold_add": 0, "armor_add": 0}},
	{"id": "tallow-seer", "name": "THE TALLOW-SEER",
	 "mesh": "char-tallow-seer.glb",
	 "portrait": "icon-portrait-tallow-seer", "cost": 1500,
	 "gate": "achv:cycle-1",
	 "skins": [],
	 "desc": "Censer of Hours and +10% XP, for one who cleared a night.",
	 "start_weapons": [{"id": "censer-of-hours", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 0, "dmg_pct": 0, "spd_pct": 0, "xp_pct": 10,
	 	"gold_add": 0, "armor_add": 0}},
	{"id": "shroud-saint", "name": "THE SHROUD-SAINT",
	 "mesh": "char-shroud-saint.glb",
	 "portrait": "icon-portrait-shroud-saint", "cost": 1800,
	 "gate": "achv:level-25",
	 "skins": [],
	 "desc": "Warding aura, every hit one softer, for the Dawnblessed.",
	 "start_weapons": [{"id": "ward", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 0, "dmg_pct": 0, "spd_pct": 0, "xp_pct": 0,
	 	"gold_add": 0, "armor_add": 1}},
	{"id": "iron-penitent", "name": "THE IRON-PENITENT",
	 "mesh": "char-iron-penitent.glb",
	 "portrait": "icon-portrait-iron-penitent", "cost": 2100,
	 "gate": "achv:runs-150",
	 "skins": [],
	 "desc": "Pilgrim Cross. +20 max hp, -4% damage. 150 nights walked.",
	 "start_weapons": [{"id": "pilgrim-cross", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 20, "dmg_pct": -4, "spd_pct": 0, "xp_pct": 0,
	 	"gold_add": 0, "armor_add": 0}},
	{"id": "hoard-wretch", "name": "THE HOARD-WRETCH",
	 "mesh": "char-hoard-wretch.glb",
	 "portrait": "icon-portrait-hoard-wretch", "cost": 2400,
	 "gate": "achv:gold-10000",
	 "skins": [],
	 "desc": "Bone Whip. +80 gold at dawn, -3% speed. Gilded Well gate.",
	 "start_weapons": [{"id": "bone-whip", "level": 1, "cd": 0.0}],
	 "start_passives": {},
	 "rule": {"hp_add": 0, "dmg_pct": 0, "spd_pct": -3, "xp_pct": 0,
	 	"gold_add": 80, "armor_add": 0}},
]


# Clamp the well row through the table (the stage out_of_range_clamps
# precedent: a garbage int never crashes, never leaks past the table).
static func row(char: int) -> Dictionary:
	return CHARACTERS[clampi(char, 0, CHARACTERS.size() - 1)]


static func index_of(id: String) -> int:
	for i in CHARACTERS.size():
		if CHARACTERS[i].id == id:
			return i
	return -1


# The rule read for the three formula seams + start_run (read-only rows by
# contract — the duplicate() law names the hand-out seams).
static func rule(char: int) -> Dictionary:
	return row(char).rule


static func start_weapons(char: int) -> Array:
	return row(char).start_weapons.duplicate(true)


static func start_passives(char: int) -> Dictionary:
	return row(char).start_passives.duplicate(true)


# Start gold (F-5 consumption line): row 0 adds exactly nothing (F-2).
static func gold_start(char: int) -> int:
	return int(row(char).rule.gold_add)


static func cost(char: int) -> int:
	return int(row(char).cost)


static func is_owned(well: DawnWell, char: int) -> bool:
	# row 0 owns by default (roadmap "the-vigil owns by default" — the
	# shipped identity needs no flag row; no flag is ever written for it).
	return char == 0 or well.flags.has(CHAR_PREFIX + String(row(char).id))


static func is_locked(well: DawnWell, char: int) -> bool:
	var gate := String(row(char).gate)
	if gate == "" or is_owned(well, char):
		return false
	return not well.flags.has(gate)


static func gate_name(char: int) -> String:
	# The lock line names the achievement (roadmap: "Locked shows the
	# achievement name") — read through the ONE achievements table.
	var gate := String(row(char).gate)
	if gate == "":
		return ""
	for a in Achievements.TABLE:
		if Achievements.ACHV_PREFIX + String(a.id) == gate:
			return String(a.name)
	return ""


# The four-state row law (§2.2): locked / buy / owned / selected — the
# panel renders it, the sim dumps it (B-E6), one source.
static func state(well: DawnWell, char: int) -> String:
	if is_locked(well, char):
		return "locked"
	if is_owned(well, char):
		return "selected" if int(well.char) == char else "owned"
	return "buy"


# Purchase law verbatim (shop's both sides): payable + unlocked + unowned
# writes flag char:<id> and spends exactly the table price; EVERY other
# input is a NO-OP-NO-WRITE returning false (the PowerUps.buy shape — this
# function never touches disk; main's ONE _meta_changed funnel persists).
static func buy(well: DawnWell, char: int) -> bool:
	if is_owned(well, char) or is_locked(well, char):
		return false
	var price := cost(char)
	if well.gold < price:
		return false
	well.gold -= price
	well.flags[CHAR_PREFIX + String(row(char).id)] = 1
	return true


# §j total resolver restated for the new file family (the no-blank law):
# every draw site asserts the file exists before load.
static func portrait_path(char: int) -> String:
	return "res://assets/icons/%s.png" % String(row(char).portrait)
