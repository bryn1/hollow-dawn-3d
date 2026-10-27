# Achievements counter-store behavioral probe (M5-SPEC §1.3 P-E1/P-E2/
# P-E4/P-E6, T-M5p, MC 11421). The save_probe.gd pattern verbatim: legs run
# the REAL product seams (game.end_run builds stats + phase, Achievements.
# update is the ONE run-end entry, DawnWell.save/load roundtrip the disk)
# sequentially against a throwaway user:// (point XDG_DATA_HOME at a temp
# dir so user:// lands there, never the real app_userdata), and print
# machine-readable rows: `LEG <name> k=v ...` (one int per named check).
# The SAME rows are written as jsonl to HD3D_ACHV_OUT (the committed
# forward-lock fixture, generated twice cmp-identical; tests judge the
# FRESH stdout rows — the committed copy is the M6 anchor, never this
# card's baseline). Seed pinned via HD3D_SEED, default = the card id (the
# v2.1.0 seed law): the whole path is int math — no RNG exists here — so
# the pin is the law, not a necessity. tests/test_achievements.py judges
# the rows; the planted-red columns run on the FINAL tree in the capture.
extends SceneTree

const SAVE := "user://dawnwell.json"
const CORRUPT := "user://dawnwell.corrupt.json"
const TEMP := "user://dawnwell.json.tmp"
const SEED_DEFAULT := 11421 # the card id, the sim_events seed law


var _rows: Array = []
var _well: DawnWell # the sumadd -> roundtrip -> worse hand-off (one life)


func _init() -> void:
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else SEED_DEFAULT)
	_leg_sumadd()
	_leg_roundtrip()
	_leg_worse()
	_leg_zerodiff()
	_leg_migrate()
	_leg_table()
	var ok := true
	for r in _rows:
		ok = ok and bool(r["ok"])
	print("VERDICT rows=%d ok=%s" % [_rows.size(), str(ok)])
	_write_dump()
	print("PROBE_DONE")
	quit()


# P-E1 side A + P-E2: a known run moves every law EXACTLY and sets exactly
# the reached flags (a level-13 win, 1000 kills, 600 gold, 125 s, one
# evolved + one union weapon carried — ids read through the shipped
# EvolutionSystem/UnionSystem tables, the same read update() uses).
func _leg_sumadd() -> void:
	_wipe()
	_well = DawnWell.load_save()
	var game := _run(125.0, 1000, 13, 600, "win", [
		{"id": "red-wail", "level": 1, "cd": 0.0},
		{"id": "requiem-toll", "level": 1, "cd": 0.0},
		{"id": "dart-loop", "level": 3, "cd": 0.0}])
	Achievements.update(_well, game, GameWorld.new())
	var c: Dictionary = _well.counters
	_emit("sumadd", {
		"kills_exact": int(c.get("kills_total", -1)) == 1000,
		"gold_exact": int(c.get("gold_earned", -1)) == 600,
		"runs_one": int(c.get("runs_total", -1)) == 1,
		"win_one": int(c.get("wins_total", -1)) == 1,
		"minutes_floor_2": int(c.get("minutes_total", -1)) == 2,
		"max_level_13": int(c.get("max_level", -1)) == 13,
		"evo_one": int(c.get("evolutions_seen", -1)) == 1,
		"union_one": int(c.get("unions_seen", -1)) == 1,
		"best_cycle_not_rehomed": (not c.has("best_cycle")) and _well.best_cycle == 0,
		"flags_set": _flag("kills-1k") and _flag("gold-500") \
			and _flag("win-1") and _flag("level-12") \
			and _flag("evo-1") and _flag("union-1"),
		"flags_absent": not _flag("kills-10k") and not _flag("gold-2500") \
			and not _flag("win-5") and not _flag("level-18") \
			and not _flag("minutes-60") and not _flag("cycle-1"),
	})


# P-E2 disk half: the counters + achv: flags survive save -> reload and
# read back off the ON-DISK JSON (the roundtrip-on-disk pin shape).
func _leg_roundtrip() -> void:
	assert(_well.save())
	var r: DawnWell = DawnWell.load_save()
	var disk := _disk_json()
	_emit("roundtrip", {
		"counters_reload": int(r.counters.get("kills_total", -1)) == 1000 \
			and int(r.counters.get("max_level", -1)) == 13,
		"flags_reload": int(r.flags.get("achv:kills-1k", 0)) == 1,
		"disk_has_counters": disk.has("counters") \
			and int(disk["counters"].get("kills_total", -1)) == 1000,
		"disk_flag_one": int(disk["flags"].get("achv:kills-1k", 0)) == 1,
		"version_still_1": int(disk.get("version", 0)) == DawnWell.VERSION,
	})
	_well = r # the worse leg runs on the RELOADED well


# P-E1 max rule + P-E2 never-unsets: a WORSE run on the same well adds the
# exact Σ deltas, keeps every max-rule value, and unsets nothing on death.
func _leg_worse() -> void:
	var game := _run(5.0, 10, 3, 0, "gameover", [])
	Achievements.update(_well, game, GameWorld.new())
	var c: Dictionary = _well.counters
	_emit("worse_run", {
		"kills_add_exact": int(c.get("kills_total", -1)) == 1010,
		"gold_add_exact": int(c.get("gold_earned", -1)) == 600,
		"runs_two": int(c.get("runs_total", -1)) == 2,
		"wins_unchanged": int(c.get("wins_total", -1)) == 1,
		"minutes_add_zero": int(c.get("minutes_total", -1)) == 2,
		"max_level_never_decreases": int(c.get("max_level", -1)) == 13,
		"evo_never_decreases": int(c.get("evolutions_seen", -1)) == 1,
		"flags_kept": _flag("kills-1k") and _flag("gold-500") \
			and _flag("win-1") and _flag("level-12") \
			and _flag("evo-1") and _flag("union-1"),
		"flags_int_one": _flags_are_int_one(_well),
	})


# P-E1 zero-DIFF leg (REV-2/P2-3): a run whose stats move ONLY Σ-add rows
# (values far from every target, level below the planted max, no evolved/
# union weapons) SETS no new flag and moves NO max-rule counter; the Σ-add
# rows move by the EXACT deltas and NOTHING else moves.
func _leg_zerodiff() -> void:
	_wipe()
	var w: DawnWell = DawnWell.load_save()
	w.counters = {"kills_total": 7, "gold_earned": 3, "runs_total": 1,
		"minutes_total": 1, "max_level": 5}
	var game := _run(5.0, 4, 2, 2, "gameover", [])
	Achievements.update(w, game, GameWorld.new())
	var c: Dictionary = w.counters
	_emit("zero_diff", {
		"kills_delta_exact": int(c.get("kills_total", -1)) == 11,
		"gold_delta_exact": int(c.get("gold_earned", -1)) == 5,
		"runs_delta_exact": int(c.get("runs_total", -1)) == 2,
		"minutes_delta_exact": int(c.get("minutes_total", -1)) == 1,
		"max_level_unmoved": int(c.get("max_level", -1)) == 5,
		"evo_unmoved": int(c.get("evolutions_seen", 0)) == 0,
		"union_unmoved": int(c.get("unions_seen", 0)) == 0,
		"no_new_flags": w.flags.is_empty(),
		"best_cycle_unmoved": w.best_cycle == 0 and not c.has("best_cycle"),
	})


# P-E4 migration half (R1 equal-or-stronger): an older save WITHOUT the
# counters field loads to {} — field-by-field default, VERSION unchanged,
# no quarantine.
func _leg_migrate() -> void:
	_wipe()
	_write(SAVE, JSON.stringify({"version": 0, "gold": 5}))
	var w: DawnWell = DawnWell.load_save()
	_emit("migrate", {
		"counters_default_empty": w.counters.is_empty(),
		"gold_kept": w.gold == 5,
		"version_current": w.version == DawnWell.VERSION,
		"not_quarantined": not _exists(CORRUPT),
	})


# P-E6 probe side: the table's SHAPE as data — 20 rows, unique ids, every
# counter in the named set (a planted orphan counter reddens counter_set),
# every row resolves a name + an in-range progress line (no-blank law; a
# planted unknown-counter progress reddens progress_in_range).
func _leg_table() -> void:
	_wipe()
	var w: DawnWell = DawnWell.load_save()
	var ids := {}
	var set_ok := true
	var names_ok := true
	var range_ok := true
	for row in Achievements.TABLE:
		ids[String(row.id)] = true
		set_ok = set_ok and Achievements.COUNTERS.has(String(row.counter))
		names_ok = names_ok and String(row.name) != ""
		var p := Achievements.progress(w, row)
		range_ok = range_ok and p >= 0 and p <= int(row.target)
	_emit("table", {
		"rows_20": Achievements.TABLE.size() == 20,
		"ids_unique": ids.size() == Achievements.TABLE.size(),
		"counter_set": set_ok,
		"names_nonempty": names_ok,
		"progress_in_range": range_ok,
		"prefix_const": Achievements.ACHV_PREFIX == "achv:",
	})


# --- helpers ---------------------------------------------------------------

# The ONE run builder: set the shipped fields, then game.end_run(result) —
# the product's own stats-building seam (main._end_run calls it first).
func _run(time: float, kills: int, level: int, gold: int, result: String,
		weapons: Array) -> GameState:
	var game := GameState.new()
	game.time = time
	game.kills = kills
	game.level = level
	game.gold = gold
	game.weapons = weapons
	game.end_run(result)
	return game


func _flag(id: String) -> bool:
	return int(_well.flags.get(Achievements.ACHV_PREFIX + id, 0)) == 1


func _flags_are_int_one(w: DawnWell) -> bool:
	for k in w.flags:
		if not String(k).begins_with(Achievements.ACHV_PREFIX) \
				or int(w.flags[k]) != 1:
			return false
	return not w.flags.is_empty()


func _disk_json() -> Dictionary:
	var f := FileAccess.open(SAVE, FileAccess.READ)
	if f == null:
		return {}
	var t := f.get_as_text()
	f.close()
	var d: Variant = JSON.parse_string(t)
	return d if typeof(d) == TYPE_DICTIONARY else {}


func _emit(name: String, checks: Dictionary) -> void:
	var ok := true
	var parts: Array[String] = []
	for k in checks:
		var v := int(bool(checks[k]))
		ok = ok and v == 1
		parts.append("%s=%d" % [k, v])
	print("LEG %s %s" % [name, " ".join(parts)])
	_rows.append({"ev": name, "checks": checks, "ok": ok})


func _write_dump() -> void:
	var path: String = OS.get_environment("HD3D_ACHV_OUT")
	if path == "":
		path = "/tmp/hd3d-achv-m5.jsonl"
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return
	for r in _rows:
		f.store_string(JSON.stringify(r) + "\n")
	f.close()


func _wipe() -> void:
	var dir := DirAccess.open("user://")
	if dir == null:
		return
	for p: String in [SAVE, CORRUPT, TEMP]:
		var rel := p.trim_prefix("user://")
		if dir.file_exists(rel):
			dir.remove(rel)


func _exists(p: String) -> bool:
	return FileAccess.file_exists(p)


func _write(p: String, text: String) -> void:
	var f := FileAccess.open(p, FileAccess.WRITE)
	f.store_string(text)
	f.close()
