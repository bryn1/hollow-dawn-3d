# Dawn Well save behavioral probe (MC 11205, M1 W-P persistence).
# Runs every load/write/reset leg of the PARITY-ROADMAP M1 feature-1 rules
# table sequentially, wiping user:// between legs, and prints machine-
# readable rows: `LEG <name> k=v ...` plus one `JSON <text>` row with the
# on-disk save contents. The SAVE_LOAD_FAIL stderr marker is emitted by
# save.gd itself (never echoed here); tests/test_save.py judges the rows
# AND the stderr count. Env: point XDG_DATA_HOME at a throwaway dir (the
# pytest leg does) so user:// lands there, never the real app_userdata.
# Statics are called on DawnWell / a loaded instance — same API main.gd and
# the future Dawn Well shop (T-M1f) consume.
extends SceneTree

const SAVE := "user://dawnwell.json"
const CORRUPT := "user://dawnwell.corrupt.json"
const TEMP := "user://dawnwell.json.tmp"


func _init() -> void:
	_leg_missing()
	_leg_roundtrip()
	_leg_corrupt()
	_leg_skew()
	_leg_migrate()
	_leg_bestcycle()
	_leg_reset()
	_leg_recreate()
	print("PROBE_DONE")
	quit()


func _leg_missing() -> void:
	_wipe()
	var w: DawnWell = DawnWell.load_save()
	print("LEG missing defaults=%d corrupt_absent=%d" % [
		int(w.gold == 0 and w.ranks.is_empty() and w.flags.is_empty()),
		int(not _exists(CORRUPT))])


func _leg_roundtrip() -> void:
	_wipe()
	_write(TEMP, "stale torn temp") # a stale temp must not block the rename
	var w: DawnWell = DawnWell.load_save()
	w.gold = 123
	w.ranks = {"might": 2}
	w.flags = {"stage2": 1}
	w.best_cycle = 3 # M2 §A.3 (T-M2e): the new row roundtrips on the same path
	var ok := w.save()
	print("LEG roundtrip ok=%d file=%d temp_gone=%d" % [
		int(ok), int(_exists(SAVE)), int(not _exists(TEMP))])
	print("JSON " + _read(SAVE))
	var r: DawnWell = DawnWell.load_save()
	print("LEG reload gold=%d ranks=%d flags=%d version=%d best_cycle=%d" % [
		r.gold, int(r.ranks.get("might", -1)), int(r.flags.get("stage2", -1)),
		r.version, r.best_cycle])


func _leg_corrupt() -> void:
	_wipe()
	_write(SAVE, "not json {{{ half a file")
	var w: DawnWell = DawnWell.load_save()
	print("LEG corrupt quarantined=%d defaults=%d corrupt_present=%d save_gone=%d" % [
		int(_exists(CORRUPT)),
		int(w.gold == 0 and w.ranks.is_empty()),
		int(_exists(CORRUPT)), int(not _exists(SAVE))])
	print("LEG corrupt_keep kept=%s" % (_read(CORRUPT).replace(" ", "_")))


func _leg_skew() -> void:
	_wipe()
	_write(SAVE, JSON.stringify({"version": 999, "gold": 7}))
	var w: DawnWell = DawnWell.load_save()
	print("LEG skew quarantined=%d defaults=%d corrupt_present=%d" % [
		int(_exists(CORRUPT)), int(w.gold == 0 and w.version == DawnWell.VERSION),
		int(_exists(CORRUPT))])


func _leg_migrate() -> void:
	_wipe()
	_write(SAVE, JSON.stringify({"version": 0, "gold": 5})) # older save, new fields absent
	var w: DawnWell = DawnWell.load_save()
	print("LEG migrate gold=%d ranks_default=%d flags_default=%d quarantined=%d best_cycle_default=%d" % [
		w.gold, int(w.ranks.is_empty()), int(w.flags.is_empty()),
		int(_exists(CORRUPT)), int(w.best_cycle == 0)]) # A-E5: no field -> 0


func _leg_bestcycle() -> void:
	# A-E5 save side: a DEEPLY-persisted best survives reload; the never-
	# decreases rule itself is main.gd's max-update at the ONE funnel
	# (behavior leg: sim_endless endless_bestcycle; source pin: test_endless).
	_wipe()
	var w: DawnWell = DawnWell.load_save()
	w.best_cycle = 7
	w.save()
	var r: DawnWell = DawnWell.load_save()
	print("LEG bestcycle persisted=%d value=%d" % [int(r.best_cycle == 7), r.best_cycle])


func _leg_reset() -> void:
	_wipe()
	var w: DawnWell = DawnWell.load_save()
	w.gold = 55
	w.save()
	w.reset()
	print("LEG reset file_gone=%d gold=%d" % [int(not _exists(SAVE)), w.gold])


func _leg_recreate() -> void:
	_wipe()
	var w: DawnWell = DawnWell.load_save()
	w.gold = 9
	w.save()
	var dir := DirAccess.open("user://")
	dir.remove(SAVE.trim_prefix("user://")) # delete-while-running (undefined by design)
	var ok := w.save() # next mutation re-creates the file
	print("LEG recreate ok=%d file_back=%d gold=%d" % [int(ok), int(_exists(SAVE)), w.gold])


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


func _read(p: String) -> String:
	var f := FileAccess.open(p, FileAccess.READ)
	if f == null:
		return ""
	var t := f.get_as_text()
	f.close()
	return t
