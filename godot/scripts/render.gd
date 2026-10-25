# Game-number DATA MODULE — the 3D port keeps render.gd's tables and deletes
# its Node2D drawing bodies (DESIGN-3D §f): no ghost 2D renderer, only the
# tables stay cited-as-truth. The 3D nodes (ground.gd, horde_viz.gd, and from
# S4 viz_fx.gd) read these constants; world.gd calls biome_at() through this
# class_name, and the acceptance suite regexes the tables below VERBATIM
# (all values stay at their v1 numbers, DESIGN-3D §d).
class_name GameRenderer
extends RefCounted


const VIEW := Vector2(1280, 720)

# Plan §4 "drawn at" sizes (px, square) — native PNG size is ignored.
const SIZES := {"player": 40.0, "enemy": 34.0, "boss": 128.0, "coin": 14.0, "gem": 14.0}

const INK := Color8(0x10, 0x13, 0x1c)
const MOON := Color8(0xae, 0xbd, 0xd4)
const BONE := Color8(0xd8, 0xd2, 0xc0)
const BLOOD := Color8(0x8e, 0x2f, 0x35)
const ICHOR := Color8(0x6f, 0xae, 0x5a)
const EMBER := Color8(0xc9, 0x7b, 0x3d)
const DAWNLIGHT := Color(1.0, 0.94, 0.66) # bright warm glow of the heal pickup

# Per-type modulate so enemy silhouettes separate from the dark background
# (playthrough finding: sprites read as invisible). Alpha stays 1.0.
const ENEMY_TINTS := {
	"wraith": Color(0.62, 0.70, 0.88),
	"hound": Color(0.88, 0.72, 0.55),
	"crawler": Color(0.58, 0.80, 0.62),
	"cultist": Color(0.75, 0.62, 0.88),
	"warden": Color(1.0, 0.72, 0.45),
}

# Biome signature creatures (MC 11082): same separation rule, own hues. Kept
# as a second table because the acceptance suite pins ENEMY_TINTS to exactly
# the five classic rows; tint_of() is the single lookup both draw paths use.
const BIOME_TINTS := {
	"moor-brute": Color(0.66, 0.78, 0.48),
	"dune-scarab": Color(0.92, 0.78, 0.42),
	"rime-ghoul": Color(0.55, 0.82, 0.95),
	"pale-wight": Color(0.85, 0.82, 0.96),
}


static func tint_of(type: String) -> Color:
	return ENEMY_TINTS.get(type, BIOME_TINTS.get(type, Color.WHITE))

# Additive glow halos on enemies + Dawnlight. v1 drew them on an additive
# CanvasItem child (Godot 4 has no per-draw blend switch); in this build the
# port target is per-class additive MultiMeshes at the exact px->m radii
# (DESIGN-3D §b). These radii and alphas are the single source of truth.
const GLOW_ALPHAS := Vector2(0.10, 0.18)   # outer, inner (enemies)
const ENEMY_GLOW_RADII := Vector2(22.0, 12.0)
const BOSS_GLOW_RADII := Vector2(40.0, 24.0)
const DAWN_GLOW_RADII := Vector2(14.0, 8.0)
const DAWN_GLOW_ALPHAS := Vector2(0.25, 0.40)

# Biome bands (owner ruling MC 11077): the ground tile swaps as the run's
# clock crosses t_start; tundra carries the boss (9:00), the two minibosses
# (10:00/13:00, T-M1d) and win (15:00 since M1 feature 4) end. Band
# t_starts are NOT re-banded — no roadmap row changes them.
# 1024px seamless tiles from static/assets/biomes, mean lum 39-55/255 — dark
# enough to keep the tinted/glowing sprites readable on top.
# Each band also fields its enemy roster (MC 11082, owner biome-enemies ask):
# the classic wraith in every band + the band's signature creature; stats and
# sprites for every id live in world.gd ENEMY_TYPES — this table is the ONE
# band source (biome_at() + these ids), read by the single spawn loop.
const BIOMES := [
	{"name": "MOORLAND", "tex": "res://assets/biomes/grass.png", "t_start": 0.0,
		"enemies": ["wraith", "moor-brute"]},
	{"name": "BURNING DUNES", "tex": "res://assets/biomes/desert.png", "t_start": 150.0,
		"enemies": ["wraith", "dune-scarab"]},
	{"name": "THE FROZEN WASTE", "tex": "res://assets/biomes/snow.png", "t_start": 300.0,
		"enemies": ["wraith", "rime-ghoul"]},
	{"name": "DEAD TUNDRA", "tex": "res://assets/biomes/tundra.png", "t_start": 450.0,
		"enemies": ["wraith", "pale-wight"]},
]


static func biome_at(t: float) -> Dictionary:
	# M3 §1.1 (T-M3s): the stage-1 WRAPPER, kept verbatim in name + return —
	# the four committed capture readers (sim_headless x2, art_capture, the
	# readability gate's base windows) stay on it, and every pre-M3 dump
	# reads the same BIOMES row. band_at("moor-vigil", t) IS the shipped
	# walk below (A-E2 pins the equality; the walk lives there now).
	return band_at("moor-vigil", t)


# ============================================================================
# STAGES (M3 pillar A, MC 11282 T-M3s, M3-SPEC §1.1) — THE stage table:
# id / display name / gimmick / bands / per-stage bosses (the SCHEDULE the
# one world.gd loop iterates, §3.1) / limit / unlock. OUR numbers, all of
# them. Stage-1 rows reference the SHIPPED consts verbatim (F-4, the
# byte-stability anchor: GameWorld.BOSS_AT + the MINIBOSS_AT pair, and the
# four shipped BIOMES rows re-keyed at the shipped t_starts) — the whole
# committed sim corpus runs these rows as today. bands re-key the shipped
# BIOMES rows BY NAME; band_at() resolves identity back to them, so roster
# + tile stay the ONE table (§1.1). Unlock chain (§1.1 + §2): sunken-chapel
# opens at level >= 10 in a moor-vigil run, ossuary-stair at level >= 14 in
# a sunken-chapel run — the flags ride the EXISTING DawnWell.flags dict,
# SET (never unset) by main._end_run through the ONE _meta_changed funnel.
# cairns/plates are §1.2 gimmick data (fixed px coords; our radii/surge/
# flare consts live at their named sites in world.gd); stage 1 fields NONE.
const STAGES := [
	{"id": "moor-vigil", "name": "MOOR VIGIL", "gimmick": "none",
		"bands": [["MOORLAND", 0.0], ["BURNING DUNES", 150.0],
			["THE FROZEN WASTE", 300.0], ["DEAD TUNDRA", 450.0]],
		"bosses": [[GameWorld.BOSS_AT, "warden"]] + GameWorld.MINIBOSS_AT,
		"cairns": [], "plates": [],
		"limit": 900.0, "unlock_level": 0, "unlock_stage": "", "unlock_flag": ""},
	{"id": "sunken-chapel", "name": "SUNKEN CHAPEL", "gimmick": "drowned-cairns",
		"bands": [["MOORLAND", 0.0], ["THE FROZEN WASTE", 300.0],
			["DEAD TUNDRA", 600.0]],
		"bosses": [[540.0, "cathedral-choir"]],
		"cairns": [[260.0, 150.0], [-260.0, -150.0]], "plates": [],
		"limit": 900.0, "unlock_level": 10, "unlock_stage": "moor-vigil",
		"unlock_flag": "stage2"},
	{"id": "ossuary-stair", "name": "OSSUARY STAIR", "gimmick": "pressure-stair",
		"bands": [["DEAD TUNDRA", 0.0], ["THE FROZEN WASTE", 450.0]],
		"bosses": [[540.0, "ossuary-warden"]],
		"cairns": [], "plates": [[-220.0, 0.0], [220.0, 0.0]],
		"limit": 900.0, "unlock_level": 14, "unlock_stage": "sunken-chapel",
		"unlock_flag": "stage3"},
]


# Unset / unknown / out-of-range ids read STAGES[0] — moor-vigil is the
# default case (A-E5's old-save reading is the same law, save side).
static func stage_row(stage_id: String) -> Dictionary:
	for s in STAGES:
		if s.id == stage_id:
			return s
	return STAGES[0]


# save.gd fields stage as an int (1-based, §1.4 persistence row); out-of-
# range reads stage 1 — never a crash, the field-by-field default law.
static func stage_id_for_index(idx: int) -> String:
	if idx < 1 or idx > STAGES.size():
		return String(STAGES[0].id) # unknown reads the default, never a crash
	return String(STAGES[idx - 1].id)


static func stage_index_for(stage_id: String) -> int:
	for i in STAGES.size():
		if STAGES[i].id == stage_id:
			return i + 1
	return 1


static func stage_bosses(stage_id: String) -> Array:
	return stage_row(stage_id).bosses


# The row the chain OPENS when a run of stage_id ends ({} ends the chain).
static func stage_unlock_after(stage_id: String) -> Dictionary:
	for s in STAGES:
		if s.unlock_stage == stage_id:
			return s
	return {}


# The ONE stage-keyed band mechanism (M3 §1.1): the same saturating walk
# biome_at shipped, over the stage's own band rows, resolving each row back
# to the shipped BIOMES entry (identity — roster + tile never duplicate).
# PLACEMENT LAW (rev-3 P3-3): this table and band_at live BELOW biome_at —
# test_biome_numbers slices BIOMES to biome_at, so a band row above it
# would leak into that stage-1 pin (the A-E2 placement RED leg).
static func band_at(stage_id: String, t: float) -> Dictionary:
	var bands: Array = stage_row(stage_id).bands
	var pick: Dictionary = _biome_named(String(bands[0][0]))
	for b in bands:
		if t >= b[1]:
			pick = _biome_named(String(b[0]))
	return pick


static func _biome_named(band_name: String) -> Dictionary:
	for b in BIOMES:
		if b.name == band_name:
			return b
	return BIOMES[0]
