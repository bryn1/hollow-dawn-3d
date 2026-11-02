# T-M7B touch probe (MC 11627): the LEG-row convention of settings_probe.gd
# / shop_probe.gd — a headless SceneTree run on a throwaway user:// (the
# pytest leg points XDG_DATA_HOME at /tmp). ALL legs run inside ONE frame
# (the sim_headless synchronous contract: no engine tick can drain presses
# or step the world mid-leg), feeding SYNTHETIC InputEventScreenTouch/
# ScreenDrag events through the shipped bridge._input seam:
#   presence — touch_seen false at boot, true only after the first touch;
#   vector identity — each of the 8 octant drags lands the BYTE-IDENTICAL
#     Vector2 of its key pair (both read through bridge.move_vector(), the
#     ONE seam main._step consumes), plus the hero-moves-through-_step leg;
#   tap law — down+up inside the deadzone feeds exactly ONE Escape press
#     and the shipped _handle_presses flips game.paused BOTH ways;
#   drag is not a tap — release after leaving the deadzone presses nothing;
#   desktop gates — the shipped web key-gate and native-key path stay.
extends SceneTree

const DT := 1.0 / 60.0
const ORIGIN := Vector2(300.0, 400.0)
const REACH := 70.0 # px drag length: past TOUCH_DEADZONE (16) and the
	# TOUCH_RADIUS clamp (56) — the clamp proves the VECTOR is the octant,
	# not the raw offset

# octant-centre drags (screen frame, y DOWN) + the key pair each must equal
const OCTANTS := [
	[Vector2.RIGHT, "KeyD"],
	[Vector2(0.7071, 0.7071), "KeyD KeyS"],
	[Vector2.DOWN, "KeyS"],
	[Vector2(-0.7071, 0.7071), "KeyA KeyS"],
	[Vector2.LEFT, "KeyA"],
	[Vector2(-0.7071, -0.7071), "KeyA KeyW"],
	[Vector2.UP, "KeyW"],
	[Vector2(0.7071, -0.7071), "KeyW KeyD"],
]

var _main: Node
var _frame := 0


# SceneTree-script quit contract (sim_headless): true ENDS the loop.
func _process(_delta: float) -> bool:
	_frame += 1
	if _frame < 2:
		return false # _ready lands a frame after add_child (chest_capture)
	if _frame == 2:
		_main = load("res://Main.tscn").instantiate()
		root.add_child(_main)
		var old: CanvasLayer = _main._screens
		_main.remove_child(old)
		old.queue_free()
		var stub := SimStubScreens.new()
		_main.add_child(stub)
		_main._screens = stub
		_run()
		return false # one ENGINE frame: touch_hud._process sees touch_seen
	# frame 3: the PRESENCE paint, one engine frame after the touches.
	# sized= asks the paint's OWN anchor source (the viewport rect) — a
	# Control under a CanvasLayer has NO layout size; the web dogfood
	# screenshot caught the rest anchor painting off-screen.
	var thud: CanvasLayer = _main._thud
	var joy: Control = thud.get_child(0)
	var vp: Vector2 = joy.get_viewport_rect().size
	print("LEG hud_paint visible=%d vp=%s/%s" % [
		int(joy.visible), str(vp.x), str(vp.y)])
	print("PROBE_DONE")
	quit(0)
	return true


func _run() -> void:
	var b = _main.bridge
	var boot := bool(b.touch_seen) # ONE presence row (parse_legs: last wins)
	_leg_vectors(b)
	_leg_deadzone(b)
	_leg_drag_not_tap(b)
	_leg_tap(b)
	_leg_desktop(b)
	print("LEG presence boot=%d end=%d" % [int(boot), int(b.touch_seen)])


func _touch(b: Node, down: bool, pos: Vector2) -> void:
	var ev := InputEventScreenTouch.new()
	ev.index = 0
	ev.position = pos
	ev.pressed = down
	b._input(ev)


func _drag(b: Node, pos: Vector2) -> void:
	var ev := InputEventScreenDrag.new()
	ev.index = 0
	ev.position = pos
	b._input(ev)


func _hold_touch(b: Node, off: Vector2) -> Vector2:
	_touch(b, true, ORIGIN)
	_drag(b, ORIGIN + off)
	return b.move_vector()


func _release(b: Node) -> void:
	_touch(b, false, ORIGIN)


func _fmt(v: Vector2) -> String:
	# str(float) is Godot's SHORTEST round-trip repr — float() re-parses it
	# exactly (the %.17g printf specifier does not exist in GDScript).
	return "%s/%s" % [str(v.x), str(v.y)]


func _leg_vectors(b: Node) -> void:
	for i in OCTANTS.size():
		var off: Vector2 = OCTANTS[i][0] * REACH
		var tv := _hold_touch(b, off)
		_release(b)
		var keys: String = OCTANTS[i][1]
		for code: String in keys.split(" "):
			b.on_key(code, true)
		var kv: Vector2 = b.move_vector()
		for code: String in keys.split(" "):
			b.on_key(code, false)
		print("LEG vec%d ident=%d tv=%s kv=%s keys=%s" % [
			i, int(tv == kv), _fmt(tv), _fmt(kv),
			OCTANTS[i][1].replace(" ", "+")]) # + not space: LEG tokens
	# the hero moves through the SAME seam: _step reads move_vector() and
	# integrates it — a held RIGHT drag advances the real player dict.
	_main._start_game()
	var p: Dictionary = _main.game.player
	var x0: float = p.x
	var held := _hold_touch(b, OCTANTS[0][0] * REACH)
	_main._step(DT)
	var moved: float = p.x - x0
	_release(b)
	var exp: float = held.x * _main.game.player_speed() * DT
	print("LEG hero_moved ok=%d dx=%.4f exp=%.4f" % [
		int(absf(moved - exp) < 1e-9), moved, exp])


func _leg_deadzone(b: Node) -> void:
	_touch(b, true, ORIGIN)
	_drag(b, ORIGIN + Vector2(5.0, 5.0))
	print("LEG deadzone zero=%d" % int(b.move_vector() == Vector2.ZERO))
	_release(b)
	print("LEG released zero=%d" % int(b.move_vector() == Vector2.ZERO))


func _leg_drag_not_tap(b: Node) -> void:
	b.drain_presses()
	_touch(b, true, ORIGIN)
	_drag(b, ORIGIN + Vector2(80.0, 0.0)) # live move vector
	var live: bool = b.move_vector() != Vector2.ZERO
	_drag(b, ORIGIN + Vector2(2.0, 0.0)) # back inside the deadzone
	var back: bool = b.move_vector() == Vector2.ZERO
	_release(b)
	var pr: Array = b.drain_presses()
	print("LEG drag_not_tap live=%d back=%d presses=%d" % [
		int(live), int(back), pr.size()])


func _leg_tap(b: Node) -> void:
	b.drain_presses()
	_main._start_game() # the REAL run-start funnel: phase == "playing"
	var g = _main.game
	_touch(b, true, ORIGIN)
	_touch(b, false, ORIGIN)
	print("LEG tap presses=%d escape=%d" % [
		b.presses.size(), int(b.presses == ["Escape"])])
	_main._handle_presses() # the shipped drain + the shipped Escape arm
	print("LEG tap_on paused=%d" % int(g.paused))
	# The overlay rides the PRESENCE toggle one engine frame later —
	# resume here and let frame 3 read _thud (the touch_seen gate).
	_touch(b, true, ORIGIN + Vector2(140.0, 0.0))
	_touch(b, false, ORIGIN + Vector2(140.0, 0.0))
	_main._handle_presses()
	print("LEG tap_off paused=%d" % int(g.paused))


func _leg_desktop(b: Node) -> void:
	# the shipped native-key path (desktop): a real InputEventKey still
	# lands on_key through the SAME _input the touch row now shares.
	var ev := InputEventKey.new()
	ev.physical_keycode = KEY_D
	ev.pressed = true
	b._input(ev)
	print("LEG native_key dx=%.1f" % b.move_vector().x)
	ev.pressed = false
	b._input(ev)
	# the shipped web gate: an unadded bridge instance sits at _native
	# == false (the web truth before _ready) — a key must NOT land.
	var w = load("res://scripts/bridge.gd").new()
	var ev2 := InputEventKey.new()
	ev2.physical_keycode = KEY_D
	ev2.pressed = true
	w._input(ev2)
	print("LEG web_key_gate drop=%d" % int(w.move_vector() == Vector2.ZERO))
	w.free()
