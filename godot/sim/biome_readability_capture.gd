# Xvfb real-GL live-scene capture for T-S10 (MC 11159): run with
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
const SETTLE := 8 # frames between cast and save (llvmpipe ~3 fps, MC 11135)

var _main: Node
var _stage := 0
var _wait := 0


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
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


# art_capture stage pattern: stage 0 = real run start; each stage k in
# 1..N+1 saves shot k-2 (a settled cast), then warps + casts shot k-1 and
# advances — the cast STAGES immediately, so the _wait countdown can never
# re-enter the cast branch (cycle-1 fix: re-advancing on the same stage
# live-looped the sim forever with no save, no quit).
func _on_frame() -> void:
	if _main.game.phase == "levelup":
		_main._pick(0) # real pick path — a card overlay is not a shot
		_wait = maxi(_wait, 3) # give the overlay 3 frames to clear
	if _wait > 0:
		_wait -= 1
		_advance(_stage) # keep frames coming; stage unchanged
		return
	if _stage == 0:
		_main._start_game()
		_advance(1)
		return
	if _stage >= 2:
		_save(_stage - 2)
	if _stage <= SHOTS.size():
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
# POSE rides into the shot (declared deviation).
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
	_wait = SETTLE


func _save(index: int) -> void:
	var band: Dictionary = GameRenderer.biome_at(_main.game.time)
	print("STATE %s t=%.1f shot=%s alive=%d player_hp=%.0f"
		% [String(band.name), _main.game.time, String(SHOTS[index].png),
			_main.world.enemies.size(), _main.game.hp])
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + String(SHOTS[index].png)
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])
