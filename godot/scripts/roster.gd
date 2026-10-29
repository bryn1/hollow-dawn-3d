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
const SKIN_PREFIX := "skin:" # the skin flag row's prefix (M5 §3.1, F-4
# restated: the SAME flags dict, the write-1 SET-only law unchanged)
const SKIN_DEFAULT_ID := "default" # the pos-0 chip's id string (the verbs
# stay thin: the id->pos map, default included, lives in this module)

# mesh = the GLB family under res://assets/glb/ (row 0 keeps the shipped
# player.glb — the byte law: the pawn's default branch still names it);
# portrait = the §j file family icon-portrait-<id>.png (total resolver,
# assert-exists at every draw site). THE SKIN GROUP LANDED AT T-M5k
# (MC 11423, replace-not-delete of the frozen-shape note this line carried):
# spec §3.1 group law — only the-vigil's group is populated (the five
# SKINS ids below, in table order); every other row ships `skins: []`
# (the row exists, empty — per-character skin sets are the named
# follow-on, spec §9.4). The field froze at T-M5c exactly for this.
const CHARACTERS := [
	{"id": "the-vigil", "name": "THE VIGIL", "mesh": "player.glb",
	 "portrait": "icon-portrait-the-vigil", "cost": 0, "gate": "",
	 "skins": ["skin-ash", "skin-marrow", "skin-tide", "skin-relic",
	 	"skin-void"],
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


# --- CLIP SOURCE (M6-SPEC §1.1, T-M6r, MC 11676) — the ONE clip map ------
# Per mesh file under res://assets/glb/, the SKINNED runtime consumer's
# clip row, or null = STATIC. The law this table pins (docs/
# RIG-DEVIATION-SEL-C.md, owner "Rec" 2026-10-27, MC 11440): the seven
# RIGGED rows carry the named clips the mocap chain shipped (walk +
# attack); the six statue-class rows are static EXCUSED-not-removed and
# take the §1.3 procedural arm — they name NO clip here (null). clip_node
# = the AnimationPlayer node name inside the IMPORTED GLB scene (the
# pinned import pass ships it; the runtime-GLTFDocument route stays
# harness-side, §1.1); walk = the clip the pawn plays while moving. The
# attack clip is NOT played in-game (stated reading §0/F-1: the auto-fire
# FX is the hero's attack read; F2 owns the attack look) — it stays
# capture-proven.
# ROW 0: the PAWN VISUAL promotes the byte-identical twin player-rigged
# (S2r rewrite, docs/PERMANENCE.md; the promotion copy + .import sidecar
# is the T-M5s permanence law) — the ONE "visual" key that differs from
# its map key, §1.1's row-0 law. Every NON-visual consumer keeps reading
# the literal "player.glb" (Roster.CHARACTERS[0].mesh stays: the art
# fixture heights + the test_art_integration seam-pin ride it).
# The map is a read-only row by contract (the duplicate() law's read-side
# restated: no consumer mutates it; the hand-out is the scalar read below).
const CLIP_SOURCE := {
	"player.glb": {"visual": "player-rigged.glb",
		"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-emberwright.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-grave-ward.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-coinhound.glb": null, # statue-class static (owner "Rec")
	"char-duskrunner.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-tallow-seer.glb": null, # statue-class static (owner "Rec")
	"char-shroud-saint.glb": null, # statue-class static (owner "Rec")
	"char-iron-penitent.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-hoard-wretch.glb": null, # statue-class static (owner "Rec")
	"skin-ash.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"skin-marrow.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"skin-tide.glb": null, # statue-class static (owner "Rec")
	"skin-relic.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"skin-void.glb": null, # statue-class static (owner "Rec")
}


# The ONE clip-map read: Dictionary (rigged: optional "visual" twin +
# "clip_node" + "walk") or null (static / unmapped — the procedural arm).
static func clip_source(glb_file: String): # Dictionary | null
	return CLIP_SOURCE.get(glb_file)


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


# --- SKINS (M5 §3.1, T-M5k, MC 11423) — the ONE table law rides here ----
# The five meshes ship on the EXISTING player-rig shape (the roadmap DA-c1
# P2-6 law: REAL distinct meshes, not re-tints; the rig/clip honesty rides
# docs/RIG-DEVIATION-SEL-C.md, owner "Rec" MC 11440 — ash/marrow/relic
# RIGGED walk+attack, tide/void ship STATIC, EXCUSED-not-removed, the
# K-E3 doc-pin judge re-measures every row). Prices = the spec's flat
# curve 200/400/600/800/1000; NO gate field — roadmap item 4 names none.
# THE `duplicate()` LAW: these rows are read-only reads by contract (the
# rule() wording restated) — every state-homing hand-out is a String/int
# scalar, no dict ever leaves toward run state.
const SKINS := [
	{"id": "skin-ash", "name": "ASH", "mesh": "skin-ash.glb",
	 "chip": "icon-skin-ash", "cost": 200,
	 "desc": "Pale ash over the vigil's own shape."},
	{"id": "skin-marrow", "name": "MARROW", "mesh": "skin-marrow.glb",
	 "chip": "icon-skin-marrow", "cost": 400,
	 "desc": "Bone-white carvings, candle-lit edges."},
	{"id": "skin-tide", "name": "TIDE", "mesh": "skin-tide.glb",
	 "chip": "icon-skin-tide", "cost": 600,
	 "desc": "Sea-dark plating from the drowned choir."},
	{"id": "skin-relic", "name": "RELIC", "mesh": "skin-relic.glb",
	 "chip": "icon-skin-relic", "cost": 800,
	 "desc": "Gilt reliquary shell — the vigil's own skeleton."},
	{"id": "skin-void", "name": "VOID", "mesh": "skin-void.glb",
	 "chip": "icon-skin-void", "cost": 1000,
	 "desc": "The dark between the moor-fires."},
]


# The worn group of a char row (§3.1 group law: row 0's five, everyone
# else the empty row that T-M5c froze).
static func skins_for(char: int) -> Array:
	return row(char).skins


# id -> well-row position (GROUP POSITION, reading (1) of the card): 0 =
# the default look (SKIN_DEFAULT_ID), k >= 1 = the group's k-th entry =
# SKINS[k-1] (the group order is pinned == this table's order by K-E5);
# unknown ids read -1 (the refusal arm, index_of's shape).
static func skin_pos_of_id(id: String) -> int:
	if id == SKIN_DEFAULT_ID:
		return 0
	for i in SKINS.size():
		if SKINS[i].id == id:
			return i + 1
	return -1


# pos -> SKINS row. pos 0 has NO row (the default look is the char's own
# mesh); readers guard on pos >= 1 FIRST (the is_wearable/skin_mesh/clamp
# arms below), so this clamp only guards a garbage int from crashing —
# the row() never-crashes/never-leaks law restated.
static func skin_row(pos: int) -> Dictionary:
	return SKINS[clampi(pos - 1, 0, SKINS.size() - 1)]


static func skin_id(pos: int) -> String:
	return String(skin_row(pos).id)


static func skin_cost(pos: int) -> int:
	return int(skin_row(pos).cost)


# The ONE skin-mesh read (the seam expression hero_pawn carries): "" =
# no skin. Clamps THROUGH the group, so skin 0, a garbage pos and a
# skin the char cannot wear ALL read "" — the RENDER stays as clean as
# the write law (a stale row after a char switch shows that char's own
# mesh, never another char's skin).
static func skin_mesh(char: int, skin: int) -> String:
	if skin < 1 or skin > SKINS.size():
		return ""
	if not skins_for(char).has(skin_id(skin)):
		return ""
	return String(skin_row(skin).mesh)


static func skin_is_owned(well: DawnWell, pos: int) -> bool:
	# pos 0 owns by default (the char's own look needs no flag row — the
	# char row-0 owns-by-default law restated); no flag is written for it.
	return pos == 0 or well.flags.has(SKIN_PREFIX + skin_id(pos))


# The wear law: the SELECTED character's group carries the id (the group
# law: an empty-group char wears NOTHING). pos 0 is always wearable.
static func is_wearable(well: DawnWell, pos: int) -> bool:
	if pos == 0:
		return true
	if pos < 1 or pos > SKINS.size():
		return false
	return skins_for(int(well.char)).has(skin_id(pos))


# Purchase law verbatim (the char/shop both-sides shape): payable +
# unowned + in-table writes flag skin:<id> and spends EXACTLY the table
# price; every other input is a NO-OP-NO-WRITE returning false. No disk
# here (main's ONE _meta_changed funnel persists; the K-E4 leg measures
# the spend value-compared against the curve).
static func skin_buy(well: DawnWell, pos: int) -> bool:
	if pos < 1 or pos > SKINS.size() or skin_is_owned(well, pos):
		return false
	var price := skin_cost(pos)
	if well.gold < price:
		return false
	well.gold -= price
	well.flags[SKIN_PREFIX + skin_id(pos)] = 1
	return true


# Select law (the _char_select guard restated into the rule module, the
# Roster.buy shape): owned + wearable + a REAL change writes the well
# row; the worn row / default re-select and the unwearable pos (empty
# group — the K-E4 planted-red seat) are NO-OP-NO-WRITE false.
static func skin_select(well: DawnWell, pos: int) -> bool:
	if not skin_is_owned(well, pos) or not is_wearable(well, pos):
		return false
	if int(well.skin) == pos:
		return false
	well.skin = pos
	return true


# The chip four-state row (Roster.state's twin for the chip family — ONE
# source: the panel renders it, the probe dumps it). "unwearable" renders
# NOTHING (group law — the K-E4 chip-disabled UI side, reading (4)).
static func skin_state(well: DawnWell, char: int, pos: int) -> String:
	if pos == 0:
		return "selected" if int(well.skin) == 0 else "owned"
	if not skins_for(char).has(skin_id(pos)):
		return "unwearable"
	if int(well.skin) == pos:
		return "selected"
	return "owned" if skin_is_owned(well, pos) else "buy"


# §j total resolver for the chip family (the portrait_path law restated):
# every draw site asserts the file exists before load.
static func skin_chip_path(pos: int) -> String:
	return "res://assets/icons/%s.png" % String(skin_row(pos).chip)
