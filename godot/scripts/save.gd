# Dawn Well meta-progression save (M1 W-P persistence work package, MC 11205).
# Format per PARITY-ROADMAP.md M1 feature 1 rev 3: user://dawnwell.json =
# {version:int, gold:int, ranks:{powerup_id:rank}, flags:{unlock_id:1}} +
# M2 §A.3's best_cycle:int (T-M2e, MC 11237) + M3 §1.4's stage:int (T-M3s,
# MC 11282) + M5 §1.1's counters:{name:int} (T-M5p, MC 11421) + M5 §2.1's
# char:int (T-M5c, MC 11422) + M5 §3.1's skin:int (T-M5k, MC 11423) —
# field-by-field ADDED rows, VERSION unchanged (1) exactly as each spec
# pins it — + T-M7A's settings rows vol_master/vol_music/vol_sfx/int per
# cent, fullscreen, pause_lose_focus int 0/1 (MC 11626), the same law
# again: a missing field defaults (100/100/100/0/0 = the shipped loud
# windowed no-auto-pause state), a HIGHER-version save still quarantines
# + T-M7C's best_runs dict (MC 11628): "<char_index>" -> the hero's top-5
# best-run rows ({"survived","kills","score"} ints) — the same law once
# more: a missing field defaults {} (no board yet = the shipped state for
# every older save), a HIGHER-version save still quarantines; the shape
# is SANITIZED field-by-shape on load (_runs_map: non-dict sources and
# malformed rows read as absent, int() lands the JSON-float rows exactly
# like every int field above; the rank/truncation law is BestRuns' own).
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
# M2 §A.3 (T-M2e): the deepest cycle any run has CLEARED (or died in),
# updated ONLY through main.gd's max-rule at a cycle clear / run end, on the
# ONE _meta_changed funnel. NO VERSION bump — the field-by-field migration
# above defaults a missing field, so an older save keeps working and a fresh
# one reads 0 (A-E5).
var best_cycle := 0
# M3 §1.4 (T-M3s, MC 11282): the chosen stage, 1-based (STAGES index + 1).
# Another field-by-field ADDED row, VERSION unchanged — the version-bump law
# (M3-SPEC §7 persistence row, §1.4 A-E5): a bump exists to quarantine a
# shape a loader can't MIGRATE; every M3 field is an additive default (the
# best_cycle proof), and a HIGHER-version save still quarantines (existing
# rule, untouched). An older save without the field reads 1 = moor-vigil.
var stage := 1
# M5 §1.1 (T-M5p, MC 11421): the achievement counter store, counter_name ->
# int — ANOTHER field-by-field ADDED row, VERSION unchanged (the best_cycle/
# stage proof verbatim: a missing field defaults {} here, a HIGHER-version
# save still quarantines, the write path stays the shipped temp+rename).
# The disk key-set pin rides the growth (test_save.py R1 re-pin, LEDGER
# row); the {} default leg lands with the T-M5p probe (equal-or-stronger).
var counters: Dictionary = {} # counter_name -> int
# M5 §2.1 (T-M5c, MC 11422): the chosen roster row, 0-based index into
# Roster.CHARACTERS. ANOTHER field-by-field ADDED row, VERSION unchanged
# (the best_cycle/stage/counters proof verbatim: a missing field defaults
# 0 = row 0 = the shipped identity, a HIGHER-version save still
# quarantines, the write path stays the shipped temp+rename). The R1
# disk-key-set pin rides the growth in test_save.py same-commit (replace-
# not-delete, equal-or-stronger; LEDGER row).
var char := 0
# M5 §3.1 (T-M5k, MC 11423): the WORN SKIN as a GROUP POSITION — 0 = the
# default look (the character's own mesh; the byte law: an unset/older
# save row shows the shipped player.glb), k >= 1 = the selected
# character's skin group's k-th entry (Roster.skin_pos_of_id maps the
# chip ids). THE FIFTH field-by-field ADDED row, VERSION unchanged (the
# best_cycle/stage/counters/char proof verbatim: a missing field
# defaults 0 = default look, a HIGHER-version save still quarantines,
# the write path stays the shipped temp+rename). The R1 disk-key-set pin
# moves AGAIN in test_save.py same-commit (the serial pair T-M5c named;
# replace-not-delete, equal-or-stronger; LEDGER row).
var skin := 0
# T-M7A (MC 11626): the SETTINGS rows — three volume percents (0..100, the
# Settings overlay's slider domain; Settings.pct_to_db maps them to bus dB),
# fullscreen (1 = the window mode applied at boot by Settings.apply_window)
# and pause_lose_focus (1 = focus-out pauses a playing run, main's
# _notification law). SIX more field-by-field ADDED rows, VERSION unchanged
# (the best_cycle/stage/counters/char/skin proof verbatim); the defaults
# 100/100/100/0/0 are the shipped state — an older save keeps every byte of
# behaviour.
var vol_master := 100
var vol_music := 100
var vol_sfx := 100
var fullscreen := 0
var pause_lose_focus := 0
# T-M7C (MC 11628): the LOCAL best-runs board — hero index (String key,
# the JSON law) -> at most BestRuns.TOP rank-ordered run rows. ANOTHER
# field-by-field ADDED row, VERSION unchanged (the best_cycle/stage/
# counters/char/skin/settings proof verbatim); {} = the shipped no-runs-
# yet state for every older save. The R1 disk-key-set pins ride the
# growth same-commit (test_save.py + the test_dawnwell_shop.py second
# reader, replace-not-delete, equal-or-stronger; LEDGER row).
var best_runs: Dictionary = {}


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
	well.best_cycle = int(data.get("best_cycle", 0)) # §A.3: older saves -> 0
	well.stage = int(data.get("stage", 1)) # §1.4 M3: older saves -> 1 (moor-vigil)
	well.counters = _int_dict(data.get("counters", {})) # §1.1 M5: older saves -> {}
	well.char = int(data.get("char", 0)) # §2.1 M5: older saves -> 0 (row 0)
	well.skin = int(data.get("skin", 0)) # §3.1 M5: older saves -> 0 (default)
	# T-M7A settings rows: older saves -> the shipped state (full volume,
	# windowed, no auto-pause) — the same field-by-field migration law.
	well.vol_master = int(data.get("vol_master", 100))
	well.vol_music = int(data.get("vol_music", 100))
	well.vol_sfx = int(data.get("vol_sfx", 100))
	well.fullscreen = int(data.get("fullscreen", 0))
	well.pause_lose_focus = int(data.get("pause_lose_focus", 0))
	# T-M7C best_runs: older saves -> {} = no board yet — the same
	# field-by-field migration law; the shape is sanitized, not trusted.
	well.best_runs = _runs_map(data.get("best_runs", {}))
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
	best_cycle = 0
	stage = 1
	counters = {}
	char = 0
	skin = 0
	vol_master = 100
	vol_music = 100
	vol_sfx = 100
	fullscreen = 0
	pause_lose_focus = 0
	best_runs = {}
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
	return {"version": version, "gold": gold, "ranks": ranks, "flags": flags,
		"best_cycle": best_cycle, "stage": stage, "counters": counters,
		"char": char, "skin": skin, "vol_master": vol_master,
		"vol_music": vol_music, "vol_sfx": vol_sfx, "fullscreen": fullscreen,
		"pause_lose_focus": pause_lose_focus, "best_runs": best_runs}


static func _int_dict(src: Variant) -> Dictionary:
	var out := {}
	if typeof(src) == TYPE_DICTIONARY:
		for k in src:
			out[String(k)] = int(src[k])
	return out


# The best_runs shape law (T-M7C, MC 11628) — the _int_dict shape twin:
# a non-dict source reads {} (never a crash, never a quarantine — the
# field-by-field default law); keys must be ints (String-num or JSON-
# float, int() lands both) or the bucket is dropped; values must be
# Arrays of well-formed {"survived","kills","score"} dicts — a malformed
# row reads as absent, and a bucket past BestRuns.TOP truncates to the
# rank prefix (a hand-rolled disk can grow the board past the law; the
# load reads the LAW, not the blob).
static func _runs_map(src: Variant) -> Dictionary:
	var out := {}
	if typeof(src) != TYPE_DICTIONARY:
		return out
	for k in src:
		var ks := String(str(k)) # str(): JSON keys arrive String;
		if not ks.is_valid_int():
			continue # non-numeric key: the bucket is dropped (the
			# int("abc")==0 alias would otherwise LAND it on hero 0 —
			# measured live on the probe's mixed-leg first run)
		var idx := ks.to_int()
		if idx < 0 or idx >= Roster.CHARACTERS.size():
			continue # no such hero: the bucket is dropped
		if typeof(src[k]) != TYPE_ARRAY:
			continue
		var rows: Array = []
		for row in src[k]:
			if typeof(row) != TYPE_DICTIONARY or not row.has("score") \
					or not row.has("survived") or not row.has("kills"):
				continue
			rows.append({"survived": int(row.survived), "kills": int(row.kills),
				"score": int(row.score)})
			if rows.size() == BestRuns.TOP:
				break
		if not rows.is_empty():
			out[String.num_int64(idx)] = rows
	return out
