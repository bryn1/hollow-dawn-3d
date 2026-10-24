# Chest-open acceptance capture (T-M1e, MC 11209; roadmap feature 5 ACCEPT
# "chest-open shot assets/screens/m1-chest.png non-bg pixels >= 200 vs empty
# baseline"). The TICK-DETERMINISTIC capture mechanism is REUSED, not
# re-authored (biome_readability_capture.gd MC 11191 cycle 2 /
# upgrades_visual_capture.gd MC 11201): real X11 window under xvfb, main.gd's
# own physics switched OFF post-activation, the clock advancing ONLY through
# fixed-count _step(1/60) calls, seed pinned via HD3D_SEED (default 11209).
# NO render-frame physics — the stage machine only ever saves after a FIXED
# settle-frame count. Run:
#   xvfb-run godot --render-driver opengl3 --path . -s res://sim/chest_capture.gd
# Shots (one live Main.tscn, in stage order; T-M2t per-tier rows B-T5):
#   m1-chest.png          tier II (warden) chest ON the ground, in view, not
#                         yet collected (> 16 px away — the touch funnel must
#                         NOT eat it before the frame). The boss kill now
#                         stamps its tier from CHEST_TIER_BY_SOURCE, so the
#                         M1 shot is the tier-II render: drawn at
#                         PickupViz.CHEST_TIER_SCALE["warden"] on the icon-
#                         sampled tint. The CHEST row carries its screen-
#                         projected centre at PICK_Y (PICK_Y == the PickupViz
#                         billboard height, harness mirror) + its tier + a
#                         per-tier window ("win").
#   m1-chest-baseline.png the EMPTY baseline: the SAME ticked state with
#                         world.chests cleared (DECLARED deviation — this is
#                         exactly the S8 HUD pattern: same scene, element
#                         hidden; every other pixel is then byte-equal and
#                         the gate's diff isolates the chest's pixels).
#   m2-chest-dawn.png     tier III (dawn), same pose: the real
#                         world.cycle_clear drop (the ONLY dawn drop funnel,
#                         it stamps map["endless-cycle"] itself) with the
#                         dropped dict REPOSED beside the hero (the POSE
#                         deviation class, declared below — the drop and the
#                         tier stamp are real; only the dict position moves
#                         out of the 16 px touch before the next tick).
#   m2-chest-dawn-baseline.png  its own empty baseline (same ticked state,
#                         chests cleared — enemies/tiles byte-equal).
# Declared deviations (spelled where they land): the chest is PLACED through
# the REAL drop funnel (world.kill_enemy on a synthetic boss-flagged kill
# dict — the sim_boss chest-roll-leg shape, CHEST_CHANCE_BOSS 1.0 is the
# pinned guarantee) at a chosen offset beside the hero (the POSE deviation,
# biome-cast class); the clock is NOT warped (a chest drop is time-free by
# the feature-4 rule; only OPENING gates at 600 — stated so no later reader
# mistakes the t for part of the scene).
extends SceneTree

const OUT_ENV := "HD3D_CHEST_SHOTS_DIR"
const DT := 1.0 / 60.0 # the engine's own fixed physics step, verbatim
const SETTLE_FRAMES := 3 # render frames between ticked state and save
const IDLE_TICKS := 60 # 1.0 in-game s of settled live scene before the drop
const DROP_OFFSET_PX := 120.0 # chest beside the hero: in frame, > 16 px
const POST_DROP_TICKS := 30 # the chest sits one half-second in the live sim
const CHEST_MARGIN := 40.0 # CHEST rows only inside the frame margins (px)
const PICK_Y := 0.28 # mirrors PickupViz.PICK_Y (harness convention)

var _main: Node
var _cam: Camera3D
var _stage := 0
var _wait := 0


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/chest-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else 11209)
	assert(DirAccess.make_dir_recursive_absolute(_out_dir()) == OK)
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)
	# activation + physics-gate lessons (biome header): set_physics_process
	# here does NOT stick; both the stub swap and the gate run on stage 0.
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _on_frame() -> void:
	if _wait > 0:
		_wait -= 1
		_advance(_stage)
		return
	if _stage == 0:
		var old: CanvasLayer = _main._screens
		_main.remove_child(old)
		old.queue_free()
		var stub := SimStubScreens.new()
		_main.add_child(stub)
		_main._screens = stub
		stub.start_pressed.connect(_main._start_game)
		stub.card_picked.connect(_main._pick)
		_cam = _main._rig.get_child(0)
		_main._start_game()
		_main.set_physics_process(false) # the tick gate, post-activation
		_advance(1)
		return
	if _stage == 1:
		_run_ticks(IDLE_TICKS)
		_drop_chest()
		_run_ticks(POST_DROP_TICKS)
		_wait = SETTLE_FRAMES
		_advance(2)
		return
	if _stage == 2:
		_save_chest_shot("m1-chest.png")
		_main.world.chests.clear() # DECLARED: the empty-baseline deviation
		_wait = SETTLE_FRAMES
		_advance(3)
		return
	if _stage == 3:
		_save_png("m1-chest-baseline.png", false)
		_drop_dawn_chest() # the real cycle-clear drop, REPOSED (header)
		_run_ticks(POST_DROP_TICKS)
		_wait = SETTLE_FRAMES
		_advance(4)
		return
	if _stage == 4:
		_save_chest_shot("m2-chest-dawn.png")
		_main.world.chests.clear() # DECLARED: the empty-baseline deviation
		_wait = SETTLE_FRAMES
		_advance(5)
		return
	if _stage == 5:
		_save_png("m2-chest-dawn-baseline.png", false)
		_write_rows()
		print("CAPTURE_OK")
		quit()
		return
	print("CAPTURE_FAIL stage machine fell through stage %d" % _stage)
	quit(3)


func _advance(next_stage: int) -> void:
	_stage = next_stage
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _drop_chest() -> void:
	# The REAL drop funnel at a chosen pose (header, declared): synthetic
	# boss-flagged kill dict (xp 0, real flag shape) dies 120 px right of
	# the hero — too far to be collected, inside the frame.
	var p: Dictionary = _main.game.player
	_main.world.kill_enemy(_main.game, {"x": p.x + DROP_OFFSET_PX, "y": p.y,
		"xp": 0.0, "boss": true, "miniboss": false})
	assert(_main.world.chests.size() == 1)


func _drop_dawn_chest() -> void:
	# T-M2t B-T5: the ONLY dawn drop funnel is the real world.cycle_clear
	# (it stamps map["endless-cycle"] itself). Its drop lands ON the pawn
	# (16 px touch would eat it before the frame), so the dropped DICT is
	# moved to the same pose offset as the boss stage — the POSE deviation
	# class (display), the drop + tier stamp stay real (header).
	_main.world.cycle_clear(_main.game)
	assert(_main.world.chests.size() == 1)
	var p: Dictionary = _main.game.player
	var c: Dictionary = _main.world.chests[0]
	assert(String(c["tier"]) == String(GameWorld.CHEST_TIER_BY_SOURCE["endless-cycle"]))
	c.x = p.x + DROP_OFFSET_PX
	c.y = p.y


# Fixed-count _step drive (biome convention): the clock advances by CALL
# COUNT only; a transient level-up (xp cannot exist here, drained anyway)
# never rides into a frame. gameover/win idles the loop.
func _run_ticks(n: int) -> void:
	for i in range(n):
		if _main.game.phase == "playing":
			_main._step(DT)
		elif _main.game.phase == "levelup":
			_main._pick(0)
		else:
			break
	while _main.game.phase == "levelup":
		_main._pick(0)


func _chest_screen_center() -> Vector2:
	var c: Dictionary = _main.world.chests[0]
	return _cam.unproject_position(Vector3(c.x / CameraRig.PX_PER_M, PICK_Y,
		c.y / CameraRig.PX_PER_M))


func _save_chest_shot(png: String) -> void:
	assert(_main.world.chests.size() == 1)
	var c: Dictionary = _main.world.chests[0]
	var p: Dictionary = _main.game.player
	var sp := _chest_screen_center()
	var tier: String = String(c["tier"])
	# per-tier window: the chest billboard at this tier's viz scale, plus
	# margin (the gate counts non-bg px in THIS window on the shot vs the
	# same-state baseline — the B-T5 "per-tier window row").
	var scale: float = float(PickupViz.CHEST_TIER_SCALE.get(tier, 1.0))
	var win: int = int(ceil(PickupViz.CHEST_PX * scale / 2.0)) + 12
	print("CHEST x=%.1f y=%.1f t=%.3f chests=%d dist_px=%.1f tier=%s" % [sp.x,
		sp.y, _main.game.time, _main.world.chests.size(),
		sqrt(pow(c.x - p.x, 2) + pow(c.y - p.y, 2)), tier])
	_rows.append({"leg": "chest_shot", "png": png, "tier": tier, "win": win,
		"baseline": png.replace(".png", "-baseline.png"),
		"cx": roundf(sp.x * 10.0) / 10.0,
		"cy": roundf(sp.y * 10.0) / 10.0, "t": roundf(_main.game.time * 100.0) / 100.0,
		"in_frame": sp.x >= CHEST_MARGIN and sp.y >= CHEST_MARGIN
				and sp.x <= GameRenderer.VIEW.x - CHEST_MARGIN
				and sp.y <= GameRenderer.VIEW.y - CHEST_MARGIN})
	_save_png(png, true)


func _save_png(png: String, with_state: bool) -> void:
	if with_state:
		print("STATE t=%.1f chests=%d alive=%d player_hp=%.0f" % [
			_main.game.time, _main.world.chests.size(),
			_main.world.enemies.size(), _main.game.hp])
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + png
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])


var _rows: Array = []


func _write_rows() -> void:
	var f := FileAccess.open(_out_dir() + "/rows.json", FileAccess.WRITE)
	assert(f != null)
	f.store_string(JSON.stringify(_rows))
	f.close()
