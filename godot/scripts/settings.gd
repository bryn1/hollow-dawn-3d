# Settings application (T-M7A, MC 11626): the ONE audio path + the window-
# mode applier. The Settings overlay (settings_page.gd) only EMITS verbs and
# main.gd's _settings_value verb owns the write + the ONE _meta_changed
# funnel; WHAT the settings do to the engine is decided HERE, once — no
# second site may call AudioServer.set_bus_volume_db (pinned by
# tests/test_settings.py, the one-lookup law of the tint_of precedent).
# Bus law: default_bus_layout.tres ships Master/Music/SFX (Music + SFX send
# to Master); the three sliders map 1:1 onto those buses. This build ships
# NO audio emitters yet (main's KeyM mute stays an internal flag, the shipped
# honest row) — this module + the layout ARE the audio path future emitters
# must route through, and the sliders are VERIFIED by real AudioServer
# get_bus_volume_db read-backs (the DoD's bus-read-back law).
# Volume law: the save stores an int percent (the save.gd int law); the dB
# map is pct -> linear_to_db(pct/100), with 0 pinned to the -60 dB floor
# (linear_to_db(0) is -inf, untestable; -60 is the practical silence).
# Window law: fullscreen is a PERSISTED PREFERENCE (the save-file read-back
# is the DoD's persistence contract); headless and web builds have no real
# windowing, so apply_window() skips there (the guard: a headless boot —
# every sim and probe — would else print engine errors and could not stay
# byte-faithful). Desktop applies on boot (main._ready) and on every change.
# NO SIM FEED: nothing here is read by world/game_state/fx — the sim
# consumes NOTHING new (the byte law).
extends RefCounted

const BUSES := {
	"vol_master": "Master",
	"vol_music": "Music",
	"vol_sfx": "SFX",
}
const SILENCE_DB := -60.0


static func pct_to_db(pct: int) -> float:
	if pct <= 0:
		return SILENCE_DB
	return linear_to_db(pct / 100.0)


static func apply_audio(well: DawnWell) -> void:
	for key: String in BUSES:
		var idx := AudioServer.get_bus_index(BUSES[key])
		if idx >= 0: # the layout loaded; a missing bus is a layout bug,
			AudioServer.set_bus_volume_db(idx, pct_to_db(int(well.get(key))))


static func apply_window(well: DawnWell) -> void:
	if DisplayServer.get_name() == "headless" or OS.has_feature("web"):
		return
	var want := DisplayServer.WINDOW_MODE_FULLSCREEN \
		if int(well.fullscreen) == 1 else DisplayServer.WINDOW_MODE_WINDOWED
	if DisplayServer.window_get_mode() != want:
		DisplayServer.window_set_mode(want)


static func apply(well: DawnWell) -> void:
	apply_audio(well)
	apply_window(well)
