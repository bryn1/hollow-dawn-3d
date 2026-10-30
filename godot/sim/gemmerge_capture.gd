# Bulk-gem acceptance capture (T-M2g, MC 11238; M2-SPEC rev-2 §C.3 C-G4
# ACCEPT "bulk gem renders larger + brighter vs baseline with bulk cleared").
# The TICK-DETERMINISTIC capture mechanism is REUSED, not re-authored — the
# chest_capture.gd recipe (itself the MC 11191 cycle-2 mechanism): real X11
# window under xvfb, main.gd's own physics switched OFF post-activation, the
# clock advancing ONLY through fixed-count _step(1/60) calls, seed pinned via
# HD3D_SEED (default 11238). NO new capture mechanism anywhere (spec §7).
# Shots (one live Main.tscn, in stage order):
#   m2-gemmerge.png          the REAL merge fired: the world holds ONE bulk
#                            gem (folded at the product's own threshold seam)
#                            in view; the GEMMERGE row carries its screen-
#                            projected centre at PICK_Y (PickupViz mirror).
#   m2-gemmerge-baseline.png the SAME ticked state with ONLY the bulk gem
#                            cleared from world.gems (the S8 hidden-UI /
#                            chest-baseline pattern — every other pixel is
#                            byte-equal, so the gate's diff isolates the
#                            bulk gem's draw; the 100 singles of the second
#                            drop pose ride BOTH frames).
# Declared deviations (spelled where they land): during the IDLE_TICKS settle
# world.spawn_acc is held 0 and world.enemies cleared after it (the
# upgrades_visual_capture._fam_setup suppression precedent — the pinned cast
# is then EXACTLY the synthetic drops, so the fold's centroid is the pose-A
# drop point and can never drift off-frame); the drops ride the REAL
# kill_enemy 70 % funnel at two fixed poses (the chest DROP_OFFSET pose
# class): first the oldest BATCH at pose A (left of the hero), then the rest
# past the threshold at pose B (right) — the fold therefore lands clean of
# the surviving singles; the poses are outside the 60 px magnet and the
# 16 px touch funnel, so nothing magnetises or eats them before the frame.
extends SceneTree

const OUT_ENV := "HD3D_GM_SHOTS_DIR"
const DT := 1.0 / 60.0 # the engine's own fixed physics step, verbatim
const SETTLE_FRAMES := 3 # render frames between ticked state and save
const IDLE_TICKS := 60 # 1.0 in-game s of settled live scene before the feed
const POSE_A_PX := -150.0 # fold pose (left of the hero): in frame, > 16 px
const POSE_B_PX := 150.0 # survivors pose (right): the fold lands CLEAN of it
const FEED_CAP := 800 # drop-roll guard: the 70 % roll needs ~286 rolls for
	# 200 gems at the pinned seed — a feed cap miss is a bug, never luck
const MERGE_TICKS := 2 # real _step ticks that fire the fold (rate*dt stays
	# under 1 spawn with spawn_acc held 0 — the merge seam, nothing else)
const BULK_MARGIN := 40.0 # GEMMERGE rows only inside the frame margins (px)
const PICK_Y := 0.28 # mirrors PickupViz.PICK_Y (harness convention)

var _main: Node
var _cam: Camera3D
var _stage := 0
var _wait := 0


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/gemmerge-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else 11238)
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
		_main.world.enemies.clear() # DECLARED cast suppression (header)
		_feed_drops()
		_run_ticks(MERGE_TICKS) # the REAL merge seam fires in update_entities
		_wait = SETTLE_FRAMES
		_advance(2)
		return
	if _stage == 2:
		_save_bulk_shot()
		_clear_bulk() # DECLARED: the bulk-cleared baseline deviation
		_wait = SETTLE_FRAMES
		_advance(3)
		return
	if _stage == 3:
		_save_png("m2-gemmerge-baseline.png")
		_write_rows()
		print("CAPTURE_OK")
		quit()
		return
	print("CAPTURE_FAIL stage machine fell through stage %d" % _stage)
	quit(3)


func _advance(next_stage: int) -> void:
	_stage = next_stage
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


# Fixed-count _step drive (chest/biome convention): the clock advances by
# CALL COUNT only; spawn_acc held 0 every tick (declared cast suppression —
# the horde cannot enter the pinned frame); gameover/win idles the loop.
func _run_ticks(n: int) -> void:
	for i in range(n):
		if _main.game.phase == "playing":
			_main.world.spawn_acc = 0.0 # DECLARED suppression (header)
			_main._step(DT)
		elif _main.game.phase == "levelup":
			_main._pick(0)
		else:
			break
	while _main.game.phase == "levelup":
		_main._pick(0)


# The REAL drop funnel (world.kill_enemy, the 70 % roll rides the pinned
# seed) at the two fixed poses of the header: pose A feeds the fold's
# BATCH gems, pose B the survivors, then one tick PAST the threshold fires
# the product's own fold. Asserts the pinned shape so a rotted harness fails
# HERE, never silently in the pixels.
func _feed_drops() -> void:
	var p: Dictionary = _main.game.player
	var batch: int = Drops.GEM_MERGE_BATCH
	var thr: int = Drops.GEM_MERGE_THRESHOLD
	var kills := 0
	while _main.world.gems.size() < batch and kills < FEED_CAP:
		_kill_at(p.x + POSE_A_PX, p.y)
		kills += 1
	while _main.world.gems.size() < thr and kills < FEED_CAP:
		_kill_at(p.x + POSE_B_PX, p.y)
		kills += 1
	assert(_main.world.gems.size() >= thr)
	print("FEED kills=%d gems=%d batch=%d thr=%d" % [kills,
		_main.world.gems.size(), batch, thr])


func _kill_at(x: float, y: float) -> void:
	_main.world.kill_enemy(_main.game, {"x": x, "y": y, "xp": 2.0,
		"boss": false, "miniboss": false}) # the real 70 % gem roll


func _bulk() -> Dictionary:
	for g in _main.world.gems:
		if g.get("big", false):
			return g
	return {}


func _clear_bulk() -> void:
	var keep: Array = []
	for g in _main.world.gems:
		if not g.get("big", false):
			keep.append(g)
	_main.world.gems.clear()
	for g in keep:
		_main.world.gems.append(g)


func _save_bulk_shot() -> void:
	var b: Dictionary = _bulk()
	assert(not b.is_empty()) # the merge must have fired (product seam)
	var sp := _cam.unproject_position(Vector3(b.x / CameraRig.PX_PER_M,
		PICK_Y, b.y / CameraRig.PX_PER_M))
	print("GEMMERGE x=%.1f y=%.1f t=%.3f gems=%d bulk_xp=%.1f" % [
		sp.x, sp.y, _main.game.time, _main.world.gems.size(), b.xp])
	_rows.append({"leg": "bulk_gem_shot",
		"cx": roundf(sp.x * 10.0) / 10.0, "cy": roundf(sp.y * 10.0) / 10.0,
		"t": roundf(_main.game.time * 100.0) / 100.0,
		"bulk_xp": b.xp, "gems": _main.world.gems.size(),
		"in_frame": sp.x >= BULK_MARGIN and sp.y >= BULK_MARGIN
				and sp.x <= GameRenderer.VIEW.x - BULK_MARGIN
				and sp.y <= GameRenderer.VIEW.y - BULK_MARGIN})
	_save_png("m2-gemmerge.png")


func _save_png(png: String) -> void:
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
