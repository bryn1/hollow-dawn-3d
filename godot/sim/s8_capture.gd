# Xvfb real-GL HUD + boss-bar pixel proof (T-S8, MC 11148; same windowed
# -s pattern as art_capture.gd / cards_capture.gd — a REAL X11 window so the
# saved pixels are real GL output). Run:
#   xvfb-run godot --render-driver opengl3 --path . -s res://sim/s8_capture.gd
# Stages: (0-1) EMPTY baseline frame — HUD hidden, menu phase, world never
# started (the "background" every crop counts against); (2) real _start_game
# funnel, clock WARPED to t=15 (declared deviation, the stated reading this
# repo's capture pattern carries — the brief's row is "sim t>10s", the
# WORLD stays live), settle, then the HUD shot; (3-4) warp to 541 s (the S6
# spawn-leg reading), tick in until world.gd's OWN boss gate fires the
# Warden, then the boss-bar shot. STATE rows print the live readings (sim t,
# hud boss_bar_state()) so each shot is a state reading, not a still. The
# frame_post_draw chain is PERSISTENT with one step per emission: under
# Xvfb/llvmpipe a re-chained CONNECT_ONE_SHOT handler was measured firing
# twice per draw and re-running stages — a stage must run exactly once.
extends SceneTree

const OUT_ENV := "HD3D_SHOTS_DIR"
const SETTLE := 8 # frames, the S2p llvmpipe convention (~3 fps draws)
const WARP_HUD := 15.0 # > 10 s sim time (brief), band 0
const WARP_BOSS := 541.0 # S6 spawn-leg reading: past BOSS_AT 540.0

var _main: Node
var _stage := 0
var _wait := 0


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/s8-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else 11148) # per-run seed, S2h convention
	assert(DirAccess.make_dir_recursive_absolute(_out_dir()) == OK)
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main) # _ready lands on the first tree iteration, NOT
	# inside _initialize — property writes there hit Nil (S8 harness lesson)
	RenderingServer.frame_post_draw.connect(_on_frame)


func _on_frame() -> void:
	if _main.game.phase == "levelup":
		_main._pick(0) # real pick path (art_capture convention)
	if _wait > 0:
		_wait -= 1
		return
	match _stage:
		0:  # menu phase, world never started: hide the HUD, let it land
			_main._hud.visible = false
			_wait = 2
			_stage = 1
		1:  # EMPTY baseline shot
			_save("baseline")
			_main._hud.visible = true
			_main._start_game()
			_stage = 2
		2:  # HUD shot: declared warp past 10 s, live spawns + live HUD
			_main.game.time = WARP_HUD
			_wait = SETTLE
			_stage = 3
		3:  # HUD save, then the S6 reading: warp past BOSS_AT and wait for
			# the real gate — the boss gate is world.gd's, not injected
			_freeze_cast()
			_save("hud")
			_main.game.time = WARP_BOSS
			_stage = 4
		4:
			if _boss().is_empty():
				return
			_freeze_cast()
			_wait = SETTLE
			_stage = 5
		5:
			_save("bossbar")
			print("CAPTURE_OK")
			quit()


# Declared FROZE convention (art_capture/S2p): chase zeroed at save so the
# crop is stable under llvmpipe's ~3 fps; models, HUD, gait animation and
# lighting stay live.
func _freeze_cast() -> void:
	for e in _main.world.enemies:
		e.spd = 0.0


func _boss() -> Dictionary:
	for e in _main.world.enemies:
		if e.boss:
			return e
	return {}


func _save(kind: String) -> void:
	var boss: Dictionary = _boss()
	print("STATE %s t=%.3f phase=%s alive=%d hud_visible=%s bar=%s" % [
		kind, _main.game.time, _main.game.phase, _main.world.enemies.size(),
		str(_main._hud.visible), JSON.stringify(_main._hud.boss_bar_state())])
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + kind + ".png"
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])
