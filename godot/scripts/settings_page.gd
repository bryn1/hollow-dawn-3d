# Settings page (T-M7A, MC 11626): the EIGHTH overlay's BUILDER — the
# RosterSelect/AchievementsPage pattern verbatim (MC 11573 split law): the
# panel is built at screens.gd's _ready on the ONE _overlay idiom and calls
# screens.gd's ONE panel-style idiom (_center_box/_label/_button) through
# the passed-in instance; zero new UI mechanism. Mouse-only by design (the
# owner plays desktop): HSliders + CheckBoxes + Buttons are all mouse-
# operable; no keyboard focus navigation is shipped or claimed.
# VERBS-ONLY contract (the shop law): the panel NEVER mutates — each slider
# drag / checkbox toggle emits the ONE settings_value(key, value) verb and
# main.gd's _settings_value owns the well write, the Settings.apply and the
# ONE _meta_changed funnel (no-op-no-write, the B-E5 law). refresh() PUSHES
# the well's state INTO the widgets (set_value_no_signal / button_pressed)
# so opening the panel never echoes a write back — the shop refresh law
# restated for stateful widgets.
extends RefCounted

const KEYS_SLIDERS := [
	["vol_master", "Master volume"],
	["vol_music", "Music volume"],
	["vol_sfx", "Sound effects volume"],
]
const KEYS_CHECKS := [
	["fullscreen", "Fullscreen window"],
	["pause_lose_focus", "Pause when the window loses focus"],
]


static func build(s) -> void:
	var box: VBoxContainer = s._center_box(s._settings)
	box.add_child(s._label("Settings", 24, s.BONE))
	for row: Array in KEYS_SLIDERS:
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 10)
		var title: Label = s._label(String(row[1]), 13, s.BONE)
		title.autowrap_mode = TextServer.AUTOWRAP_OFF
		title.custom_minimum_size = Vector2(200, 0) # shop row law
		line.add_child(title)
		var slider := HSlider.new()
		slider.min_value = 0.0
		slider.max_value = 100.0
		slider.step = 1.0
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.custom_minimum_size = Vector2(300, 0)
		var key: String = String(row[0])
		slider.value_changed.connect(func(v: float): s.settings_value.emit(key, int(v)))
		line.add_child(slider)
		s._settings_sliders[key] = slider
		box.add_child(line)
	for row: Array in KEYS_CHECKS:
		var check := CheckBox.new()
		check.text = String(row[1])
		var key: String = String(row[0])
		check.toggled.connect(func(on: bool): s.settings_value.emit(key, 1 if on else 0))
		s._settings_checks[key] = check
		box.add_child(check)
	var back := Button.new()
	back.text = "Back to the menu"
	back.pressed.connect(func(): s.settings_closed.emit())
	box.add_child(back)


static func refresh(s) -> void:
	# The well is the single source; widgets receive it WITHOUT signals (a
	# signal on open would echo every value back through the verb — the
	# no-op guard would eat it, but the panel never WRITES is the law).
	for key: String in s._settings_sliders:
		s._settings_sliders[key].set_value_no_signal(int(s._well.get(key)))
	for key: String in s._settings_checks:
		s._settings_checks[key].button_pressed = int(s._well.get(key)) == 1
