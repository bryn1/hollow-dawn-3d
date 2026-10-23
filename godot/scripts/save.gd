# Dawn Well meta-progression save (M1 W-P persistence work package, MC 11205).
# Format per PARITY-ROADMAP.md M1 feature 1 rev 3: user://dawnwell.json =
# {version:int, gold:int, ranks:{powerup_id:rank}, flags:{unlock_id:1}}.
# Recovery rules (all observables, roadmap reset table): missing file -> fresh
# defaults; undecodable -> quarantine (rename to dawnwell.corrupt.json kept +
# stderr `SAVE_LOAD_FAIL path=...`) + defaults; version newer than this code
# knows -> refuse load, same quarantine path; an older save migrates field-by-
# field (unknown/missing fields default). Write path (roadmap c2 N-4): EVERY
# mutation writes the whole save via temp-file + DirAccess.rename — atomic, a
# torn write cannot land mid-save, so a corrupt file can only come from
# outside. Delete-while-running is UNDEFINED BY DESIGN (roadmap rev 3): the
# in-memory state re-creates the file at the next save(). Consumers: boot
# (main.gd _ready) + the future Dawn Well shop (T-M1f) — no run behavior
# reads meta state on this card (run gold untouched).
class_name DawnWell
extends RefCounted

const SAVE_PATH := "user://dawnwell.json"
const CORRUPT_PATH := "user://dawnwell.corrupt.json"
const TEMP_PATH := "user://dawnwell.json.tmp"
const VERSION := 1 # int; a save with a HIGHER version quarantines

var version := VERSION
var gold := 0
var ranks: Dictionary = {} # powerup_id -> rank (int)
var flags: Dictionary = {} # unlock_id -> 1


# Boot load: missing file is NOT a failure — fresh defaults, silent.
static func load_save() -> DawnWell:
	var well := DawnWell.new()
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return well
	var text := f.get_as_text()
	f.close()
	var data: Variant = JSON.parse_string(text)
	if typeof(data) != TYPE_DICTIONARY:
		quarantine("undecodable")
		return well
	# JSON numbers parse as float; int() lands the roadmap's int fields.
	var save_version := int(data.get("version", 0))
	if save_version > VERSION:
		quarantine("version %d newer than %d" % [save_version, VERSION])
		return well
	# Older (or current) save: field-by-field migration — every field we do
	# not find keeps its default; a rewrite at the next save() carries it.
	well.version = VERSION
	well.gold = int(data.get("gold", 0))
	well.ranks = _int_dict(data.get("ranks", {}))
	well.flags = _int_dict(data.get("flags", {}))
	return well


# Full-state write on every mutation, temp + rename (atomic replace: POSIX
# rename over an existing target is a move, never a merge). False only when
# the write itself failed; callers keep in-memory state regardless.
func save() -> bool:
	var f := FileAccess.open(TEMP_PATH, FileAccess.WRITE)
	if f == null:
		push_error("SAVE_WRITE_FAIL path=%s" % TEMP_PATH)
		return false
	f.store_string(JSON.stringify(as_data()))
	f.close()
	var dir := DirAccess.open("user://")
	if dir == null:
		push_error("SAVE_WRITE_FAIL path=%s" % SAVE_PATH)
		return false
	return dir.rename(TEMP_PATH.trim_prefix("user://"),
		SAVE_PATH.trim_prefix("user://")) == OK


# Reset verb: in-memory defaults AND the file goes (next load reads fresh
# defaults). The quarantine copy, if any, is kept — inspection is its point.
func reset() -> void:
	version = VERSION
	gold = 0
	ranks = {}
	flags = {}
	var dir := DirAccess.open("user://")
	if dir != null and dir.file_exists(SAVE_PATH.trim_prefix("user://")):
		dir.remove(SAVE_PATH.trim_prefix("user://"))


# Rename the offending save aside and print the pinned stderr marker. The
# rename always replaces a previous corrupt copy; the marker prints even if
# the rename itself fails — the observable is the failure, not the rename.
static func quarantine(reason: String) -> void:
	var dir := DirAccess.open("user://")
	if dir != null and dir.file_exists(SAVE_PATH.trim_prefix("user://")):
		if dir.file_exists(CORRUPT_PATH.trim_prefix("user://")):
			dir.remove(CORRUPT_PATH.trim_prefix("user://"))
		dir.rename(SAVE_PATH.trim_prefix("user://"),
			CORRUPT_PATH.trim_prefix("user://"))
	printerr("SAVE_LOAD_FAIL path=%s reason=%s" % [SAVE_PATH, reason])


func as_data() -> Dictionary:
	return {"version": version, "gold": gold, "ranks": ranks, "flags": flags}


static func _int_dict(src: Variant) -> Dictionary:
	var out := {}
	if typeof(src) == TYPE_DICTIONARY:
		for k in src:
			out[String(k)] = int(src[k])
	return out
