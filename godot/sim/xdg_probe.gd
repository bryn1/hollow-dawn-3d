# HOME-well contamination sensor (MC 11706 T-M6H-XDG, T-M6p finding (a);
# judged by tests/test_xdg_hygiene.py). Reads the well through the EXACT
# boot-load path main.gd's _ready consumes — DawnWell.load_save() with NO
# reset and no wipe — because its whole purpose is to report what an UNRESET
# boot inherits from wherever user:// resolves. Prints one machine-readable
# `LEG well k=v ... path=<user_data_dir>` row plus PROBE_DONE. Deliberately
# ZERO class_name (the global class cache stays byte-untouched) and ZERO
# save()/reset() calls (the probe never mutates the well it measures).
extends SceneTree

func _init() -> void:
	var w: DawnWell = DawnWell.load_save()
	print("LEG well gold=%d ranks=%d flags=%d best=%d stage=%d counters=%d char=%d skin=%d path=%s" % [
		w.gold, w.ranks.size(), w.flags.size(), w.best_cycle, w.stage,
		w.counters.size(), w.char, w.skin, OS.get_user_data_dir()])
	print("PROBE_DONE")
	quit()
