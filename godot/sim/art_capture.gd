# Xvfb real-GL live-scene capture for T-S2i (MC 11133): run with
#   xvfb-run godot --render-driver opengl3 --path . -s res://sim/art_capture.gd
# Same windowed proof pattern as cards_capture.gd (-s keeps a REAL X11
# window so the saved pixels are real GL output). Stages: real _start_game
# funnel, then per BIOME shot the run clock is warped (the one stated
# deviation, same warp the sim WIN-gate leg uses) so ground.gd's band swap
# lands on the band, a round-robin horde rides the REAL _spawn_enemy funnel
# and is then repositioned onto the visible field, plus (second shot) ONE
# scene-injected warden instance at its §a height — the STATE lines print
# what the live world holds, so the shot is a state reading, not a still.
extends SceneTree

const OUT_ENV := "HD3D_SHOTS_DIR"
const SHOTS := ["moorland-glb.png", "burning-dunes-glb.png"]
const WARP := [30.0, 200.0] # band 0 MOORLAND + band 1 BURNING DUNES (§d table)
const CAST := [
	["wraith", "moor-brute", "wraith", "hound", "wraith", "moor-brute",
		"crawler", "wraith", "hound", "moor-brute", "cultist", "wraith",
		"hound", "crawler", "moor-brute", "wraith"],
	["wraith", "dune-scarab", "wraith", "dune-scarab", "wraith",
		"dune-scarab", "hound", "wraith", "dune-scarab", "wraith",
		"cultist", "dune-scarab"],
]
const SETTLE := 8 # frames between cast and save (T-S2p: llvmpipe draws at
# ~3 fps, so the old 60-frame settle ran ~20 s of chase and the whole cast
# stood ON the hero at save time)
const FROZE := true # chase frozen for the cast (spd zeroed at placement):
# a POSITIONS/POSE-only capture deviation of the same declared kind as the
# strips frozen control — models, materials, gait animation, FX, lighting
# and the world's own roaming spawns stay fully live; the acceptance shot
# shows the hero unburied inside a live-animated GLB ring.

var _main: Node
var _stage := 0
var _wait := 0


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/s2i-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	# T-S2p: per-run cast seed (S2h per-leg seed convention, MC 11112) — the
	# acceptance material must be reproducible from a clean run, not the luck
	# of an unseeded randf() draw; HD3D_SEED overrides the accepted frame.
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else 11135)
	assert(DirAccess.make_dir_recursive_absolute(_out_dir()) == OK)
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _on_frame() -> void:
	if _main.game.phase == "levelup":
		_main._pick(0) # real pick path — a card overlay is not a shot
		_wait = maxi(_wait, 3) # give the overlay 3 frames to clear
	if _wait > 0:
		_wait -= 1
		_advance(_stage) # keep frames coming; stage unchanged
		return
	match _stage:
		0:  # real run-start funnel (grants talon@1 like every S5/S2h shot)
			_main._start_game()
			_advance(1)
		1:  # MOORLAND: warp the clock to band 0 mid-time, cast the horde
			_cast(0)
			_advance(2)
		2:  # save moorland, then BURNING DUNES: warp + cast + inject warden
			_save(0)
			_cast(1)
			_main.world._spawn_enemy("warden", _main.game, GameRenderer.VIEW)
			# boss-frame anchor at 190 px (S2i composition), same FROZE rule
			var w: Dictionary = _main.world.enemies.back()
			_reposition(w, 190.0)
			if FROZE:
				w.spd = 0.0
			_advance(3)
		3:  # save the dunes + boss shot and leave
			_save(1)
			print("CAPTURE_OK")
			quit()


func _advance(next_stage: int) -> void:
	_stage = next_stage
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


# Warp the clock to the shot's band (stated deviation), then spawn each
# cast member through the real funnel and reposition it onto the visible
# field (ring spawns land off-screen by design — parity, §a).
func _cast(shot: int) -> void:
	_main.game.time = WARP[shot]
	for key in CAST[shot]:
		_main.world._spawn_enemy(key, _main.game, GameRenderer.VIEW)
		var e: Dictionary = _main.world.enemies.back()
		_reposition(e, randf_range(130.0, 220.0))
		if FROZE:
			e.spd = 0.0
	_wait = SETTLE


# Place one enemy at radius r_px on a bearing around the player (px — the
# sim's unit; random unless declared); the viz converts through
# CameraRig.PX_PER_M.
func _reposition(e: Dictionary, r_px: float, bearing := -1.0) -> void:
	var a: float = bearing if bearing >= 0.0 else randf() * TAU
	e.x = _main.game.player.x + cos(a) * r_px
	e.y = _main.game.player.y + sin(a) * r_px


func _save(index: int) -> void:
	var band: Dictionary = GameRenderer.biome_at(_main.game.time)
	var warden := false
	var warden_hp := 0.0
	for e in _main.world.enemies:
		if e.boss:
			warden = true
			warden_hp = e.hp
	print("STATE %s shot=%s alive=%d warden=%s warden_hp=%.0f player_hp=%.0f"
		% [String(band.name), String(SHOTS[index]),
			_main.world.enemies.size(), str(warden), warden_hp,
			_main.game.hp]) # HP lives on GameState, not the player dict
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + String(SHOTS[index])
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])
