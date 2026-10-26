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
var _run_stage := 1 # T-M3b (MC 11284) DECLARED variant: HD3D_STAGE picks
# which stage row the run walks (the dawnwell select seam, main.gd:282 —
# the same wiring sim_budget's stage-3 leg uses). Default stays the shipped
# stage 1, so the byte-anchored stage-1 shots are untouched; the capture
# re-run at HD3D_STAGE=2 is the C-E3 pixel proof that the boss bar paints
# the STAGE's own end-boss name from the live row.
var _run_reaper := false # T-M4r (MC 11364) DECLARED variant: HD3D_REAPER=1
# walks THE REAPER night instead of the 540 boss bar (M4 §2.2, the
# HD3D_STAGE pattern verbatim): the night flag rides the ONE well-flag seam
# at stage 1 (the select-seam site above), the run warps past the LIMIT to
# WARP_REAPER, and the bar shot carries the first ARRIVED reaper. Declared
# capture pins (named at the shot, the CYCLE-HUD row's pattern): the freeze
# lands on the first frame the reaper is on the field (200 px/s × one frame
# of llvmpipe draw gap stays far short of the ring walk — the pursuer
# cannot end the run before its own portrait is taken), and the earlier
# schedule bosses are funnel-killed through the REAL kill_enemy seam so the
# shipped first-boss bar law reads THE REAPER (their drops are artifacts of
# the pin, not claims — the reaper drop law is sim_reaper's B-E6 leg). The
# variant is a SEPARATE run writing to its own HD3D_SHOTS_DIR; default
# shots byte-untouched.


const WARP_REAPER := 901.0 # past WIN_TIME: the arrival latch has fired

var _run_eventwave := false # T-M4z (MC 11363) DECLARED variant: HD3D_EVENTWAVE=1
# walks the STAGE-2 event window instead of the 540 boss bar (M4 §1.1, the
# HD3D_STAGE pattern verbatim): the run stage is FORCED to 2 (the window is a
# stage-2 row), the run warps INSIDE the window to WARP_EVENTWAVE, and the
# wave shot carries the stage's OWN event miniboss plus the live window
# crowd (F-1 law: prelate is stage 2's row, acolyte stage 3's — no stage
# carries both). Declared capture
# pins (named at the shot, the reaper-row pattern): the gate is the REAL
# schedule latch (the variant only waits for both 660 rows), the freeze lands
# on the first frame the window reads live, and the warp skips the run's
# pre-window damage — the player stands at the shipped start hp (the same
# stated reading the warp rows already carry). A SEPARATE run writing to its
# own HD3D_SHOTS_DIR; default shots byte-untouched.


const WARP_EVENTWAVE := 662.0 # inside [660,720), both 660 latch rows fired


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/s8-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else 11148) # per-run seed, S2h convention
	var st := OS.get_environment("HD3D_STAGE")
	_run_stage = st.to_int() if st != "" else 1
	assert(_run_stage >= 1 and _run_stage <= 3)
	var rp := OS.get_environment("HD3D_REAPER") # T-M4r variant switch (declared)
	_run_reaper = rp == "1"
	_run_eventwave = OS.get_environment("HD3D_EVENTWAVE") == "1" # T-M4z
	if _run_eventwave:
		_run_stage = 2 # declared force: the window is a stage-2 row
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
			_main._dawnwell.stage = _run_stage # declared select seam (above)
			if _run_reaper:
				_main._dawnwell.flags["reaper"] = 1 # declared night-flag seam
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
			_main.game.time = (WARP_REAPER if _run_reaper
					else (WARP_EVENTWAVE if _run_eventwave else WARP_BOSS))
			_stage = 4
		4:
			if _run_eventwave:
				if _event_minibosses() < 1:
					return # the real schedule latch owns the gate (ONE class
				           # per stage row — F-1: prelate is stage 2's, acolyte
				           # stage 3's; no stage ever carries both)
				_freeze_cast() # first-window-frame freeze (declared, header note)
				_wait = SETTLE
				_stage = 5
				return
			if _run_reaper:
				if _reapers() == 0:
					return # the real arrival latch owns the gate, not injected
				_freeze_cast() # first-frame freeze (declared, header note)
				for e in _main.world.enemies.duplicate():
					if e.boss and not e.get("reaper", false):
						_main.world.kill_enemy(_main.game, e) # declared pin
				_wait = SETTLE
				_stage = 5
				return
			if _boss().is_empty():
				return
			_freeze_cast()
			_wait = SETTLE
			_stage = 5
		5:
			if _run_eventwave:
				_save("eventwave") # cone crowd + the stage's own miniboss
				print("CAPTURE_OK") # variant ends at the wave shot
				quit()
			_save("bossbar")
			if _run_reaper:
				print("CAPTURE_OK") # variant ends at the reaper bar shot
				quit()
			# M2 T-M2e A-E7 stage: the cycle HUD row. DECLARED pins (the
			# stated capture reading this harness already carries — HUD text
			# reads game state, the world stays live, chase stays frozen):
			# endless ON + cycle counter at 2 (the A-E8 reached-cycle value);
			# the HAND-IN seam itself is behavior-tested in sim_endless.
			_main.game.endless = true
			_main.game.cycle = 2
			_wait = SETTLE
			_stage = 6
		6:  # cycle-HUD shot: same frozen world, HUD now carries the cycle row
			_stage = 7 # one-shot: the PERSISTENT frame chain must not re-save
			_save("cycle-hud")
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


# T-M4r: reapers on the field (the dict-flag read — the same law main.gd's
# contact loop makes; the variant's gate is the REAL arrival latch).
func _reapers() -> int:
	var n := 0
	for e in _main.world.enemies:
		if e.get("reaper", false):
			n += 1
	return n


# T-M4z: the window's own two 660 latch rows on the field (String(type) read,
# the same law the keyed drop site makes; the variant gate is the REAL latch).
func _event_minibosses() -> int:
	var n := 0
	for e in _main.world.enemies:
		var t := String(e.type)
		if t == "sunken-prelate" or t == "stair-acolyte":
			n += 1
	return n


func _save(kind: String) -> void:
	var boss: Dictionary = _boss()
	print("STATE %s t=%.3f phase=%s alive=%d hud_visible=%s bar=%s cycle_row=%s" % [
		kind, _main.game.time, _main.game.phase, _main.world.enemies.size(),
		str(_main._hud.visible), JSON.stringify(_main._hud.boss_bar_state()),
		JSON.stringify(_main._hud.cycle_row_state())])
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + kind + ".png"
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])
