# T-M7A settings behavioral probe (MC 11626). Same LEG-row convention as
# shop_probe.gd / skin_probe.gd: headless SceneTree run under a throwaway
# XDG_DATA_HOME (the pytest leg points user:// at /tmp), machine-readable
# `LEG <name> k=v` rows, one real process per mode (HD3D_SETTINGS_MODE):
#   write  (default) — the REAL click route on the REAL screens.gd +
#          main.gd (the shop_probe _btn/pressed.emit seam, no second UI
#          mechanism): menu Settings button opens the eighth overlay; the
#          sliders move -> AudioServer.get_bus_volume_db READS BACK the
#          mapped dB; the fullscreen checkbox lands in the well AND on
#          disk (headless window mode stays WINDOWED — the apply guard,
#          its own row); the pause-lose-focus option fires the shipped
#          game.paused on a focus-out notification iff on (both sides);
#          same-value + unknown-key verbs write NOTHING (disk bytes);
#          an older save (no settings fields) migrates to the shipped
#          defaults, no quarantine. Ends persisting the final state
#          THROUGH THE REAL FUNNEL.
#   read   — a NEW process (the DoD's quit+relaunch: the second godot
#          invocation reads the well at boot exactly like the shipped
#          _ready path): disk rows + the boot-time bus read-backs + the
#          overlay's widgets showing the persisted values.
extends SceneTree

const SAVE := "user://dawnwell.json"
const CORRUPT := "user://dawnwell.corrupt.json"
const SETTINGS := preload("res://scripts/settings.gd")

var _main: Node
var _frame := 0
var _mode := "write"
var _disk_before := ""


func _initialize() -> void:
	_mode = OS.get_environment("HD3D_SETTINGS_MODE")
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)


# SceneTree-script quit contract (sim_headless): true ENDS the loop.
func _process(_delta: float) -> bool:
	_frame += 1
	if _frame < 2:
		return false # _ready lands a frame after add_child (chest_capture)
	if _mode == "read":
		if _frame == 2:
			_leg_relaunch()
		print("PROBE_DONE")
		quit(0)
		return true
	match _frame:
		2:
			_leg_open()
		3:
			_leg_sliders()
		4:
			_leg_window_pause()
		5:
			_leg_noop()
		6:
			_leg_migrate()
	if _frame >= 6:
		print("PROBE_DONE")
		quit(0)
		return true
	return false


func _btn(root: Node, text: String) -> Button:
	for b in root.find_children("*", "Button", true, false):
		if b.text == text:
			return b
	return null


func _db(idx: int) -> String:
	return "%.6f" % AudioServer.get_bus_volume_db(idx)


func _disk_bytes() -> String:
	var f := FileAccess.open(SAVE, FileAccess.READ)
	return f.get_as_text() if f != null else ""


func _leg_open() -> void:
	var sc = _main._screens
	assert(sc.has_method("settings_visible") and sc.has_method("show_settings"),
		"the REAL screens overlay family must carry the settings half")
	_main._dawnwell.reset() # fresh-state law (the convert/shop legs)
	var btn := _btn(sc._menu, "Settings")
	var clickable := int(btn != null and not btn.disabled and btn.is_visible_in_tree())
	btn.pressed.emit() # the menu's OWN verb: settings_requested -> _open_settings
	print("LEG open clickable=%d opens=%d menu_hidden=%d" % [
		clickable, int(sc.settings_visible()), int(not sc._menu.visible)])
	print("LEG buslayout master=%d music=%d sfx=%d" % [
		AudioServer.get_bus_index("Master"), AudioServer.get_bus_index("Music"),
		AudioServer.get_bus_index("SFX")])


func _leg_sliders() -> void:
	var sc = _main._screens
	sc._settings_sliders["vol_master"].value = 50.0 # the slider's own signal
	sc._settings_sliders["vol_music"].value = 25.0 # -> settings_value verb
	sc._settings_sliders["vol_sfx"].value = 80.0
	print("LEG sliders_db master=%s music=%s sfx=%s" % [
		_db(0), _db(1), _db(2)])
	var w := DawnWell.load_save() # the disk, read back
	print("LEG disk1 vol_master=%d vol_music=%d vol_sfx=%d" % [
		w.vol_master, w.vol_music, w.vol_sfx])


func _leg_window_pause() -> void:
	var sc = _main._screens
	sc._settings_checks["fullscreen"].button_pressed = true # -> toggled
	print("LEG window mode=%d disk_fs=%d" % [
		DisplayServer.window_get_mode(), DawnWell.load_save().fullscreen])
	sc._settings_checks["pause_lose_focus"].button_pressed = true
	_main._start_game() # the REAL run-start funnel: phase playing
	_main.game.paused = false
	_main._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	var on_fires := int(_main.game.paused)
	_main._settings_value("pause_lose_focus", 0) # the real verb, off side
	_main.game.paused = false
	_main._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	var off_fires := int(_main.game.paused)
	_main._settings_value("pause_lose_focus", 1) # restore: persisted state
	print("LEG pause on_fires=%d off_fires=%d disk_plf=%d" % [
		on_fires, off_fires, DawnWell.load_save().pause_lose_focus])


func _leg_noop() -> void:
	_disk_before = _disk_bytes()
	_main._settings_value("vol_master", 50) # same value: B-E5 law
	_main._settings_value("gold", 999) # out-of-whitelist: refused
	var same := int(_disk_bytes() == _disk_before)
	print("LEG noop same=%d gold=%d" % [same, DawnWell.load_save().gold])


func _leg_migrate() -> void:
	# An older save (every field through `skin`, no settings rows) must
	# load the SHIPPED defaults through the field-by-field migration —
	# no quarantine (the best_cycle/stage/counters/char/skin proof).
	var f := FileAccess.open(SAVE, FileAccess.WRITE)
	f.store_string('{"version":1,"gold":5,"ranks":{},"flags":{},'
			+ '"best_cycle":0,"stage":1,"counters":{},"char":0,"skin":0}')
	f.close()
	var w := DawnWell.load_save()
	var dir := DirAccess.open("user://")
	print("LEG migrate vol_master=%d vol_music=%d vol_sfx=%d fullscreen=%d pause_lose_focus=%d corrupt=%d" % [
		w.vol_master, w.vol_music, w.vol_sfx, w.fullscreen,
		w.pause_lose_focus,
		int(dir.file_exists(CORRUPT.trim_prefix("user://")))])
	# Persist the FULL state once more THROUGH THE REAL FUNNEL so the read
	# mode (the relaunch process) boots exactly this well.
	_main._meta_changed()
	var r := DawnWell.load_save()
	print("LEG disk2 vol_master=%d vol_music=%d vol_sfx=%d fullscreen=%d pause_lose_focus=%d" % [
		r.vol_master, r.vol_music, r.vol_sfx, r.fullscreen,
		r.pause_lose_focus])


func _leg_relaunch() -> void:
	var w := DawnWell.load_save()
	# TOLERANCE law (measured T-M7A): AudioServer stores the bus volume as
	# LINEAR and re-derives the dB read-back, so get(pct_to_db(x)) !=
	# pct_to_db(x) in the last ulps — the read-back is compared at 1e-4 dB.
	var applied := int(absf(AudioServer.get_bus_volume_db(0) - SETTINGS.pct_to_db(w.vol_master)) < 0.0001
		and absf(AudioServer.get_bus_volume_db(1) - SETTINGS.pct_to_db(w.vol_music)) < 0.0001
		and absf(AudioServer.get_bus_volume_db(2) - SETTINGS.pct_to_db(w.vol_sfx)) < 0.0001)
	print("LEG relaunch disk_fullscreen=%d disk_pause_lose_focus=%d vol_master=%d vol_music=%d vol_sfx=%d boot_db_master=%s boot_db_music=%s boot_db_sfx=%s boot_applied=%d" % [
		w.fullscreen, w.pause_lose_focus, w.vol_master, w.vol_music,
		w.vol_sfx, _db(0), _db(1), _db(2), applied])
	_main._open_settings() # the persisted state SHOWS in the widgets
	var sc = _main._screens
	print("LEG ui_values vol_master=%d vol_music=%d vol_sfx=%d fs=%d plf=%d" % [
		int(sc._settings_sliders["vol_master"].value),
		int(sc._settings_sliders["vol_music"].value),
		int(sc._settings_sliders["vol_sfx"].value),
		int(sc._settings_checks["fullscreen"].button_pressed),
		int(sc._settings_checks["pause_lose_focus"].button_pressed)])
