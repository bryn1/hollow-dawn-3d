# Xvfb real-GL live-scene capture for T-S10 (MC 11159); DETERMINISM FIX
# cycle 2 (MC 11191): run with
#   xvfb-run godot --render-driver opengl3 --path . -s res://sim/biome_readability_capture.gd
# Same windowed proof pattern as art_capture.gd (MC 11133): -s keeps a REAL
# X11 window so the saved pixels are real GL output, the run clock is WARPED
# to the four band times (the stated deviation, S2i lineage), and the horde
# rides the REAL _spawn_enemy funnel off the band's own BIOMES roster before
# repositioning onto the visible field, frozen for the frame (POSE-only, the
# same declared deviation class). One shot per biome; the STATE lines print
# the band biome_at() actually reports at the shot time, so the gate reads a
# state, not a still. Seed pinned via HD3D_SEED (default 11159), per the
# S2h/S2p per-run cast-seed convention.
#
# WHY CYCLE 1 FLICKERED (root cause, MC 11191 cycle 2): cycle 1 gated its
# stages on frame_post_draw (render frames, ~3 fps under llvmpipe) while the
# sim still ran in main.gd's OWN _physics_process at 60 Hz — the number of
# PHYSICS ticks absorbed between two render frames is wall-clock driven, so
# between warp and save each process ran a different tick count: different
# roaming spawns, chase state and hero HP in the shot, and block_px flickered
# (tundra measured 64 / 16 / 24 on the unchanged tree). FIX: the sim_headless
# pinning pattern (MC 11112: "the tree's own tick idles here; _step is driven
# manually") — main.gd's physics processing is switched OFF at instantiate
# and the clock advances ONLY through fixed-count _step(DT) calls below. The
# fast-forward is call-rate, never dt: exactly SETTLE_TICKS sim steps per
# shot, identical RNG draws from the pinned seed, every process. game.paused
# stays false on purpose — it is the sim_headless gate too, but here it would
# paint the HUD pause overlay into the shot; cutting _physics_process at the
# node keeps the live scene honest (HUD/viz/ground stay live, they are pure
# functions of sim state — gait phase rides game.time, no AnimationPlayer).
extends SceneTree

const OUT_ENV := "HD3D_BIOME_SHOTS_DIR"
# Band times from the T-S10 brief: 5 mid-moor, 200 mid-dunes, 350 mid-frozen,
# 500 mid-tundra (all strictly inside their BIOMES t_start bands).
const SHOTS := [
	{"t": 5.0, "png": "readability-grass.png"},
	{"t": 200.0, "png": "readability-desert.png"},
	{"t": 350.0, "png": "readability-frozen.png"},
	{"t": 500.0, "png": "readability-tundra.png"},
]
const CAST_N := 14 # round-robin over the band's own roster (art_capture scale)
const DT := 1.0 / 60.0 # the engine's own fixed physics step, verbatim
const SETTLE_TICKS := 60 # sim steps between cast and save = 1.0 in-game s
# (180 leaked the pawn under the ~500 s spawn wall (honest cycle-2 RED);
# FIXED per shot, this is the determinism carrier
const SETTLE_FRAMES := 3 # render frames between the ticked sim state and
# the save (the viz _process functions are delta-free state reads, so any
# one drawn frame after the ticks is byte-equivalent; 3 for safety)

var _main: Node
var _stage := 0
var _wait := 0
var _ticks_this_shot := 0


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/biome-readability-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else 11159)
	assert(DirAccess.make_dir_recursive_absolute(_out_dir()) == OK)
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)
	# NOTE (measured, 4.7.2): set_physics_process(false) here does NOT
	# stick — in -s mode the node's _ready activation lands on the FIRST
	# frame and re-enables processing (probe: processed=false at set, true
	# on frame 1 with the clock ticking). The gate is set in _on_frame
	# stage 0 instead, after activation and before the clock can run.
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


# art_capture stage pattern: stage 0 = real run start; each stage k in
# 1..N+1 saves shot k-2 (a settled cast), then warps + casts shot k-1 and
# advances — the cast STAGES immediately, so the _wait countdown can never
# re-enter the cast branch (cycle-1 fix: re-advancing on the same stage
# live-looped the sim forever with no save, no quit).
func _on_frame() -> void:
	if _wait > 0:
		_wait -= 1
		_advance(_stage) # keep frames coming; stage unchanged
		return
	if _stage == 0:
		_main._start_game()
		_main.set_physics_process(false) # sim_headless gate, post-activation
		# (see _initialize note): the tree's own _step never fires again;
		# the clock advances only through _tick() below. Pre-start ticks
		# already spent are harmless: phase was "menu", so _step never ran.
		_advance(1)
		return
	if _stage >= 2:
		_save(_stage - 2)
	if _stage <= SHOTS.size():
		# Each shot is a FRESH run of its band (sim_headless WIN-gate leg
		# pattern): the real _start_game funnel clears the world, then the
		# clock warps and the band roster casts. Cycle 1 kept ONE process-
		# persistent horde across all four warps, so by DEAD TUNDRA (t=500,
		# ~12/s spawn wall) the ground was carpeted by four bands' roaming
		# survivors — the block-knee then measured horde density, not tile
		# detail, and the pawn buried under it (cycle-2 honest RED).
		# Declared deviation: every shot shows a fresh Lv1 hero + its own
		# band's horde; comparability across biomes is the point.
		_main._start_game()
		_main.game.time = float(SHOTS[_stage - 1].t)
		_cast(_stage - 1)
		_advance(_stage + 1)
	else:
		print("CAPTURE_OK")
		quit()


func _advance(next_stage: int) -> void:
	_stage = next_stage
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


# Round-robin the BIOMES[shot].enemies roster through the real funnel and
# reposition onto the visible field (ring spawns land off-screen by design,
# parity §a); FROZE like art_capture: spd zeroed at placement, so only the
# POSE rides into the shot (declared deviation). Then the FIXED tick budget
# runs synchronously (spawns/chase/FX live), then a fixed frame settle.
func _cast(shot: int) -> void:
	var roster: Array = GameRenderer.BIOMES[shot].enemies
	for i in range(CAST_N):
		_main.world._spawn_enemy(roster[i % roster.size()], _main.game,
			GameRenderer.VIEW)
		var e: Dictionary = _main.world.enemies.back()
		var a: float = randf() * TAU
		var r: float = randf_range(130.0, 220.0)
		e.x = _main.game.player.x + cos(a) * r
		e.y = _main.game.player.y + sin(a) * r
		e.spd = 0.0
	_tick(SETTLE_TICKS)
	_wait = SETTLE_FRAMES


# The determinism core: n calls of the REAL main.gd _step at the FIXED DT —
# spawns, chase, contact, drops all live, the clock advances by CALL COUNT
# only, never wall-clock dt (sim_headless wording, MC 11112). A level-up
# inside the run is pumped through the real _pick(0) between steps (a card
# overlay mid-tick is transient state, and the drain below guarantees the
# phase is "playing" again before any frame draws). gameover/win idles the
# loop: the clock never advances past an ended run.
func _tick(n: int) -> void:
	_ticks_this_shot = 0
	for i in range(n):
		if _main.game.phase == "playing":
			_main._step(DT)
			_ticks_this_shot += 1
		elif _main.game.phase == "levelup":
			_main._pick(0)
		else:
			break
	while _main.game.phase == "levelup":
		_main._pick(0)


func _save(index: int) -> void:
	var band: Dictionary = GameRenderer.biome_at(_main.game.time)
	print("STATE %s t=%.1f shot=%s alive=%d ticks=%d player_hp=%.0f"
		% [String(band.name), _main.game.time, String(SHOTS[index].png),
			_main.world.enemies.size(), _ticks_this_shot, _main.game.hp])
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + String(SHOTS[index].png)
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])
