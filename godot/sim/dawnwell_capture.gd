# Dawn Well shop acceptance capture (T-M1f, MC 11210; roadmap feature 2
# ACCEPT "shop UI leg under Xvfb, shot path assets/screens/m1-dawnwell.png,
# shop-panel crop non-bg pixels >= 200 vs a hidden-UI empty baseline"). The
# TICK-DETERMINISTIC capture mechanism is REUSED, not re-authored (the
# chest_capture.gd / MC 11191 stage machine): real X11 window under xvfb,
# frame_post_draw staging, fixed settle frames. The scene NEVER ticks — the
# shop is menu-phase UI, so the sim clock stays untouched (declared: no
# _step calls at all, every pixel after activation is deterministic).
# Shots (one live Main.tscn with the REAL screens layer — the shop IS the
# acceptance object, no stub):
#   m1-dawnwell.png           shop OPEN over the night scene, seeded with
#                             ranks bought through main's REAL _shop_buy
#                             verbs on a funded well (declared deviation:
#                             the bankroll is granted directly — standing in
#                             for the run cash-outs that fund a real player,
#                             itself proven by the probe's convert leg).
#   m1-dawnwell-baseline.png  the hidden-UI empty baseline: same window,
#                             screens.hide_all() (the S8 pattern — the menu
#                             was already hidden while the shop was open, so
#                             every non-equal pixel IS the shop's draw).
# Opening rides main._open_shop() — the SAME verb the menu button's signal
# calls (the click itself is mouse input this stage cannot press; declared).
extends SceneTree

const OUT_ENV := "HD3D_SHOP_SHOTS_DIR"
const SETTLE_FRAMES := 3
const BANKROLL := 3000 # declared seeding: cash-outs from runs never replayed
const VIEW_HALF := Vector2(640, 360) # the ortho viewport center (1280x720)
const PANEL_HALF := Vector2(380, 220) # screens._center_box shop offsets verbatim

var _main: Node
var _stage := 0
var _wait := 0
var _rows: Array = []


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/shop-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	seed(11210) # the card id, the sim convention (determinism declared)
	assert(DirAccess.make_dir_recursive_absolute(_out_dir()) == OK)
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _on_frame() -> void:
	if _wait > 0:
		_wait -= 1
		_advance(_stage)
		return
	if _stage == 0:
		# main's _ready has run (one frame post-activation, the chest lesson):
		# fund the well, buy through the REAL verbs (each mutates + persists),
		# then open the shop through the SAME verb the menu button emits.
		_main._dawnwell.gold = BANKROLL
		for id: String in ["vitality", "vitality", "bulwark", "sage-thirst",
				"grave-greed"]:
			assert(PowerUps.buy(_main._dawnwell, id))
		_main._dawnwell.save()
		_main._open_shop()
		_wait = SETTLE_FRAMES
		_advance(1)
		return
	if _stage == 1:
		assert(_main._screens.shop_visible())
		_save_png("m1-dawnwell.png", true)
		_main._screens.hide_all() # the hidden-UI baseline (S8 pattern)
		_wait = SETTLE_FRAMES
		_advance(2)
		return
	if _stage == 2:
		assert(not _main._screens.shop_visible())
		_save_png("m1-dawnwell-baseline.png", false)
		_write_rows()
		print("CAPTURE_OK")
		quit()
		return
	print("CAPTURE_FAIL stage machine fell through stage %d" % _stage)
	quit(3)


func _advance(next_stage: int) -> void:
	_stage = next_stage
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _save_png(png: String, with_state: bool) -> void:
	if with_state:
		print("STATE gold=%d ranks=%d" % [_main._dawnwell.gold,
			_main._dawnwell.ranks.size()])
		_rows.append({"leg": "shop_shot",
			"cx": int(VIEW_HALF.x), "cy": int(VIEW_HALF.y),
			"hw": int(PANEL_HALF.x), "hh": int(PANEL_HALF.y),
			"gold": _main._dawnwell.gold,
			"ranks": _main._dawnwell.ranks.size()})
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + png
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])


func _write_rows() -> void:
	var f := FileAccess.open(_out_dir() + "/rows.json", FileAccess.WRITE)
	assert(f != null)
	f.store_string(JSON.stringify(_rows))
	f.close()
