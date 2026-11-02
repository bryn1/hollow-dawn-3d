# The ONLY gameplay input path, fed from one of two sources gated here at a
# single point (OS.has_feature("web")): on web the export's head_include
# installs window keydown/keyup listeners that call on_key for every key;
# on desktop (no JavaScriptBridge/DOM) native key events feed the SAME
# held/presses queues in _input. main reads only the queues either way.
# T-M7B (MC 11627) adds the TOUCH row below: the engine's own touch events
# (InputEventScreenTouch/Drag — real DOM touches on web, synthetic ones in
# the probe) feed the SAME held/presses queues — the joystick joins
# move_vector() additively and the pause tap feeds the shipped Escape
# press. No new vector, no new pause flag, desktop paths byte-unchanged.
extends Node

const MOVE_KEYS := ["KeyW", "KeyA", "KeyS", "KeyD",
	"ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"]
const DISCRETE_KEYS := ["Escape", "KeyM", "Digit1", "Digit2", "Digit3",
	"Enter", "NumpadEnter", "KeyEnter"]

# Physical keys -> the DOM-style codes the queues are keyed on (desktop only;
# mirrors the e.code values the web relay forwards).
const NATIVE_CODES := {
	KEY_W: "KeyW", KEY_A: "KeyA", KEY_S: "KeyS", KEY_D: "KeyD",
	KEY_UP: "ArrowUp", KEY_DOWN: "ArrowDown", KEY_LEFT: "ArrowLeft",
	KEY_RIGHT: "ArrowRight", KEY_ESCAPE: "Escape", KEY_M: "KeyM",
	KEY_1: "Digit1", KEY_2: "Digit2", KEY_3: "Digit3",
	KEY_ENTER: "Enter", KEY_KP_ENTER: "NumpadEnter",
}

var held := {} # code -> true while the key is down
var presses: Array = [] # discrete codes, drained once per frame by main
var _native := false # true on desktop: _input feeds the queues

# --- The touch row (T-M7B, MC 11627): same queues, same vector, no fork ----
# The FIRST active touch anchors a floating joystick at its press point;
# drags past TOUCH_DEADZONE quantise to 45-degree octants and feed the
# arrow codes the queues already speak (the octant table, screen frame with
# y growing DOWN). A touch released WITHOUT ever leaving the deadzone is a
# TAP: it feeds the shipped Escape press/release, so pause-on-tap lands on
# game.paused through main._handle_presses — the ONE shipped pause flag
# (T-M7A focus-out law restated: no new phase, no new surface). PRESENT-
# AWARE by construction: touch_seen flips only when a touch event arrives,
# so a desktop never arms the joystick visual and never sees one byte of
# behaviour change (the sim feeds on_key only — no sim harness ever pushes
# a touch event, the byte law's input-side proof).
const TOUCH_DEADZONE := 16.0 # px: inside it a drag is the zero vector and
	# a release under it all touch is a tap (the declared tap law)
const TOUCH_RADIUS := 56.0 # px: the knob clamp the overlay paints (its
	# ONE visual source is this const — touch_hud.gd preloads it)
const TOUCH_OCTANTS := [
	["ArrowRight"], ["ArrowRight", "ArrowDown"], ["ArrowDown"],
	["ArrowLeft", "ArrowDown"], ["ArrowLeft"], ["ArrowLeft", "ArrowUp"],
	["ArrowUp"], ["ArrowRight", "ArrowUp"],
] # index = int(round(atan2(dy, dx) / (PI/4.0))) + 8, then % 8

var touch_seen := false # presence law: true once a touch event arrived
var touch_active := false # a joystick touch is currently down
var joy_anchor := Vector2.ZERO # press point of the active touch (visual)
var joy_knob := Vector2.ZERO # live knob position, clamped (visual)
var _touch_held := {} # arrow codes held by the joystick. A SEPARATE dict,
	# folded into move_vector() beside the key codes: a physical key and a
	# touch never erase each other on release, and opposing inputs cancel
	# exactly like the shipped KeyA+KeyD pair does.
var _joy_id := -1 # the tracked finger; extra fingers are inert
var _joy_moved := false # the touch left the deadzone: a drag, never a tap


func _ready() -> void:
	_native = not OS.has_feature("web")


# Desktop builds only: native key events feed the same queues the DOM relay
# fills on web. Unmatched keys and auto-repeats are dropped (the web relay
# likewise ignores e.repeat). Touch (T-M7B) rides EVERY platform: on web the
# engine's DOM relay delivers real touches here, so only the key arm keeps
# the _native gate (web keys stay on the JS relay, the INPUT-focus law above).
func _input(event: InputEvent) -> void:
	var touch := event as InputEventScreenTouch
	if touch != null:
		_touch_event(touch)
		return
	var drag := event as InputEventScreenDrag
	if drag != null:
		_drag_event(drag)
		return
	if not _native:
		return
	var key := event as InputEventKey
	if key == null or key.echo:
		return
	var code: String = NATIVE_CODES.get(key.physical_keycode, "")
	if code != "":
		on_key(code, key.pressed)


func on_key(code: String, down: bool) -> void:
	if down:
		held[code] = true
		if code in DISCRETE_KEYS:
			presses.append(code)
	else:
		held.erase(code)


# The joystick's down/up half. A press claims the stick (first finger only);
# a release of the tracked finger either clears the arrow codes (a drag was
# live) or — never having left the deadzone — IS THE TAP: the shipped Escape
# press/release pair enters presses and main._handle_presses flips the
# shipped game.paused. The tap is phase-blind HERE on purpose: the shipped
# arm already gates Escape on phase == "playing" (one gate, one home).
func _touch_event(ev: InputEventScreenTouch) -> void:
	touch_seen = true
	if ev.pressed:
		if _joy_id != -1:
			return # second finger: the stick is one-finger, ignore
		_joy_id = ev.index
		joy_anchor = ev.position
		joy_knob = ev.position
		_joy_moved = false
		touch_active = true
	elif ev.index == _joy_id:
		if not _joy_moved:
			on_key("Escape", true)
			on_key("Escape", false)
		_touch_held.clear()
		_joy_id = -1
		touch_active = false


# The joystick's drag half: inside the deadzone the vector stays zero (and
# the touch can still be a tap); past it the octant table feeds the arrow
# codes. The knob clamps to TOUCH_RADIUS for the overlay; the VECTOR is the
# octant, so every touch vector is a key-pair vector (the DoD's identity).
func _drag_event(ev: InputEventScreenDrag) -> void:
	if ev.index != _joy_id:
		return
	var off := ev.position - joy_anchor
	var d := off.length()
	joy_knob = joy_anchor + (off * (TOUCH_RADIUS / d) if d > TOUCH_RADIUS
			else off)
	if d < TOUCH_DEADZONE:
		_touch_held.clear()
		return
	_joy_moved = true
	_touch_held.clear()
	var oct := int(round(atan2(off.y, off.x) / (PI / 4.0))) + 8
	for code: String in TOUCH_OCTANTS[oct % 8]:
		_touch_held[code] = true


func is_enter(code: String) -> bool:
	return code == "Enter" or code == "NumpadEnter" or code == "KeyEnter"


# Normalised 8-direction move vector, or ZERO when idle. T-M7B: the touch
# arrows fold INTO this one function (additive, never a second vector):
# key and touch codes union per axis, then the same normalize tail runs, so
# a touch octant returns the byte-identical Vector2 of its key pair.
func move_vector() -> Vector2:
	var x := 0.0
	var y := 0.0
	if held.has("KeyA") or held.has("ArrowLeft") or _touch_held.has("ArrowLeft"):
		x -= 1.0
	if held.has("KeyD") or held.has("ArrowRight") or _touch_held.has("ArrowRight"):
		x += 1.0
	if held.has("KeyW") or held.has("ArrowUp") or _touch_held.has("ArrowUp"):
		y -= 1.0
	if held.has("KeyS") or held.has("ArrowDown") or _touch_held.has("ArrowDown"):
		y += 1.0
	if x == 0.0 and y == 0.0:
		return Vector2.ZERO
	return Vector2(x, y).normalized()


func drain_presses() -> Array:
	var out := presses
	presses = []
	return out
