# The touch overlay (T-M7B, MC 11627): the joystick VISUAL, DECLARED
# SEAM READING — a HUD-family CanvasLayer sibling wired in main._ready like
# _hud/_screens, the M5/M7A "builder moved OUT, rides the idiom" law. NOT a
# screens.gd verb-overlay: the joystick carries no button and emits no verb
# (screens stays byte-untouched), it is a present-aware read of the bridge,
# the same class of surface as the HUD's PAUSED label.
# PRESENCE LAW (the card's word): the stick paints iff the bridge has seen
# a touch event. A desktop never sets touch_seen, so nothing here ever
# draws — the desktop pixel path is unchanged by construction. The ring
# rests bottom-left as the affordance hint while touch is idle, and jumps
# to the finger (a floating stick) while a drag is live; the radius/knob
# numbers are the BRIDGE's consts (touch_hud preloads nothing of its own —
# one home for every touch number).
extends CanvasLayer

const BONE := Color8(0xd8, 0xd2, 0xc0)
const INK := Color8(0x10, 0x13, 0x1c)

var bridge: Node

var _joy: Control


func _ready() -> void:
	layer = 8 # the HUD (5) and the screen overlays (10) keep their layers
	_joy = _Joy.new()
	_joy.bridge = bridge
	add_child(_joy)


func _process(_delta: float) -> void:
	var seen: bool = bridge != null and bridge.touch_seen
	if _joy.visible != seen:
		_joy.visible = seen


# One Control painting the whole stick each redraw. mouse_filter IGNORE:
# the overlay never steals a UI click (menu buttons stay tappable on web —
# the shipped touch->mouse path owns them, this file only paints).
class _Joy extends Control:
	var bridge: Node

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		visible = false

	func _process(_delta: float) -> void:
		if visible:
			queue_redraw() # touch state moves every frame a finger lives

	func _draw() -> void:
		var r: float = bridge.TOUCH_RADIUS
		# the VIEWPORT rect, not size: a Control under a CanvasLayer carries
		# no layout (size 0) — the rest anchor measured against it would sit
		# off-screen (T-M7B web dogfood caught exactly this).
		var anchor := Vector2(2.5 * r, get_viewport_rect().size.y - 2.5 * r)
		var knob := anchor
		if bridge.touch_active:
			anchor = bridge.joy_anchor
			knob = bridge.joy_knob
		draw_circle(anchor, r, Color(INK.r, INK.g, INK.b, 0.45))
		draw_arc(anchor, r, 0.0, TAU, 40, Color(BONE.r, BONE.g, BONE.b, 0.6),
				2.0)
		draw_circle(knob, r * 0.42, Color(BONE.r, BONE.g, BONE.b, 0.75))
