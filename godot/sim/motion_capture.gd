# MC 11676 T-M6r — MOVING-PAW clip-play capture for the runtime animation
# consumer (M6-SPEC §1.6 MV-E1/E2/E5): the shipped M5 clips finally PLAY
# while the survivor moves, proved on a REAL Godot window (xvfb, pinned
# 4.7.2, the ONE capture_lib launcher — skinned_capture.gd / s8_capture.gd
# pattern: op-queue stepped one op per frame_post_draw, no awaits).
# Windowed run (the tools/motion_gate.py driver wraps this):
#   xvfb-run <godot> --render-driver opengl3 --path godot \
#     -s res://sim/motion_capture.gd -- --out <dir>
# Jobs (the spec's 4 motion legs + their frozen controls): the DEFAULT
# char (row 0 — rigged through the promoted byte-identical player-rigged
# copy) gets TWO distinct-time pairs like S2r's PAIRS law; one rigged
# char (emberwright, via the ONE SimFunnel opts char hand-in) and one
# STATIC char (coinhound — owner "Rec" statue class: the procedural
# bob+lean arm of §1.3 is what must move) get one pair each.
# STATED READINGS (capture-time, the repo's convention):
#  * game.paused=true + manual _step(1/60) — sim_headless's fast-forward
#    law: the SIM is scripted, the VIZ is live (the tree's real _process
#    still ticks hero_pawn, where the clips/bob ride). Input drives
#    movement through the ONE bridge.on_key seam — the same funnel the
#    player's WASD rides.
#  * The frame-diff WINDOW follows the pawn on screen (CameraRig hard-
#    centres it every frame) and the gate counts pixels that differ AND
#    are pawn-lit (luma > 0.10 — the committed ground/background floor,
#    the same 0.10 convention the strips/biome gates measure). The opaque
#    pawn occludes the scrolling ground inside its silhouette, so a
#    consumer pinned OFF reads 0 px there: the MV-E1 planted red ("child
#    never plays ⇒ moving leg 0 px") lands exactly at 0, never on ground
#    drift or renderer noise.
#  * Auto-fire FX is off per leg (game.weapons emptied on THIS harness
#    run — capture-leg state, not a byte corpus: the bright talon arc
#    crossing the window would measure the FX, not the rig) and the UI
#    layers are hidden (menu/HUD ride their own committed gates).
#  * Guard rows: every pair is taken with NO unit inside 60 px (L1) of
#    the pawn — the early scripted window keeps spawn distance.
# State rows: a law row (the live gait constants the gate checks caps
# against), a draw row per job (MV-E5: exactly ONE of self-surface / rig
# child draws), and gait_probe twins per job (MV-E2; the driver also
# re-runs the whole capture and cmps the STATE rows — same seed twice ⇒
# identical dump, the twice-cmp law).
extends SceneTree

const VIEW := Vector2i(640, 640)
const DT := 1.0 / 60.0
const MOVE_KEY := "KeyD" # the bridge seam's right-travel key
const SAFE_ENEMY_L1 := 60.0
# pair step marks (sim steps from pair start). Each pair spans ~30 frames
# — a productive half-period of the stride-tied gait; the SECOND vigil
# pair is offset +6 so its two grabs land on a DIFFERENT clip phase than
# pair 0's (the MV-E1 "2 distinct-time pairs" law) without wrapping the
# clip loop back onto a near-identical pose (a 66->96 span over-ran the
# loop and read ~0 even alive — a false-red risk, rejected by measure).
const GRAB_A := 12
const GRAB_B := 42
const GRAB_C := 18
const GRAB_D := 48
const FROZEN_GAP := 10

const JOBS := [
	{"name": "vigil", "char": 0,
		"pairs": [[GRAB_A, GRAB_B], [GRAB_C, GRAB_D]]},
	{"name": "emberwright", "char": 1, "pairs": [[GRAB_A, GRAB_B]]},
	{"name": "coinhound", "char": 3, "pairs": [[GRAB_A, GRAB_B]]},
]

var _out_dir: String
var _manifest: FileAccess
var _ops: Array = []
var _steps_left := 0
var _run: Node
var _cam: Camera3D
var _job_name := ""
var _job_i := -1


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var i := 0
	while i < args.size():
		if args[i] == "--out" and i + 1 < args.size():
			_out_dir = args[i + 1]
			i += 2
			continue
		i += 1
	assert(_out_dir != null and _out_dir != "", "need --out <dir>")
	seed(11676) # card-id seed, the per-leg seed convention
	DirAccess.make_dir_recursive_absolute(_out_dir + "/frames")
	_manifest = FileAccess.open(_out_dir + "/manifest.jsonl", FileAccess.WRITE)
	root.size = VIEW
	# NOTE (sim_chars/sim_headless donor law): _next_job must NOT run in
	# _initialize — Main._ready (the _dawnwell/_screens wiring fresh_run
	# writes) only fires once the tree is ACTIVE, i.e. from the first
	# frame callback on. The op queue starts empty; the first _on_frame
	# opens job 0.
	RenderingServer.frame_post_draw.connect(_on_frame)


func _next_job() -> bool:
	_free_run()
	_job_i += 1
	if _job_i >= JOBS.size():
		return false
	var j: Dictionary = JOBS[_job_i]
	_job_name = String(j.name)
	_run = SimFunnel.fresh_run(root, {"char": int(j.char)})
	_cam = _run._rig.get_child(0) as Camera3D
	# Capture-leg state (declared in the header): auto-fire FX off, UI
	# layers hidden, the real menu screen removed, sim scripted by manual
	# _step while the viz stays live.
	_run.game.weapons.clear()
	_run._hud.visible = false
	var stub: Node = _run._screens
	for c in _run.get_children():
		if c is CanvasLayer and c != stub and c != _run._hud:
			_run.remove_child(c)
			c.free()
	_run.game.paused = true
	if _job_i == 0:
		_ops.append({"op": "law"})
	for k in range(j.pairs.size()):
		var pr: Array = j.pairs[k]
		_ops.append({"op": "guard", "pair": k})
		_ops.append({"op": "move", "down": true, "pair": k})
		_ops.append({"op": "steps", "n": int(pr[0]), "pair": k})
		_ops.append({"op": "grab", "slot": "a", "pair": k})
		_ops.append({"op": "steps", "n": int(pr[1]) - int(pr[0]),
			"pair": k})
		_ops.append({"op": "grab", "slot": "b", "pair": k})
		_ops.append({"op": "move", "down": false, "pair": k})
		_ops.append({"op": "steps", "n": 2, "pair": k})
		_ops.append({"op": "grab", "slot": "za", "pair": k})
		_ops.append({"op": "steps", "n": FROZEN_GAP, "pair": k})
		_ops.append({"op": "grab", "slot": "zb", "pair": k})
	_ops.append({"op": "draw"})
	_ops.append({"op": "gait"})
	return true


func _on_frame(_d = null) -> void:
	if _steps_left > 0:
		_run._step(DT)
		_steps_left -= 1
		return
	if _ops.is_empty():
		if not _next_job():
			_finish()
			return
	var op: Dictionary = _ops.pop_front()
	match String(op.op):
		"steps":
			_steps_left = int(op.n)
			if _steps_left == 0:
				_on_frame() # degenerate: nothing to wait for
		"move":
			_run.bridge.on_key(MOVE_KEY, bool(op.down))
			if not bool(op.down):
				_run._step(DT) # first no-input step: viz sees speed 0
		"grab":
			var img := root.get_texture().get_image()
			var path := "%s/frames/%s_%s.png" % [_out_dir, _job_name,
				String(op.slot) + "_" + str(_frame_tag)]
			assert(img.save_png(path) == OK)
			_manifest.store_line(JSON.stringify({"ev": "frame",
				"job": _job_name, "slot": String(op.slot),
				"pair": int(op.get("pair", 0)),
				"png": path, "rect": _rect(_run._pawn),
				"pawn_m": [_run.game.player.x / CameraRig.PX_PER_M,
					_run.game.player.y / CameraRig.PX_PER_M]}))
			_manifest.flush()
		"guard":
			var p: Dictionary = _run.game.player
			var nearest := INF
			for e in _run.world.enemies:
				nearest = minf(nearest, absf(e.x - p.x) + absf(e.y - p.y))
			_emit({"ev": "guard", "job": _job_name,
				"nearest_enemy_l1_px": nearest})
		"law":
			_emit({"ev": "law", "bob_m": HordeViz.BOB_M,
				"lean_rad": HordeViz.LEAN_RAD,
				"gait_eps_mps": HordeViz.GAIT_EPS_MPS,
				"stride_m": HordeViz.GAIT_STRIDE_M,
				"freq_max": HordeViz.GAIT_FREQ_MAX,
				"scissor": [HordeViz.SCISSOR_MIN, HordeViz.SCISSOR_MAX]})
		"gait":
			_emit({"ev": "gait", "job": _job_name,
				"probe": _run._viz.gait_probe()})
		"draw":
			var pawn: MeshInstance3D = _run._pawn
			# MV-E5: a SURFACE draws iff it renders visible pixels — the
			# rigged arm ghosts self's surface 0 at alpha 0 (hero_pawn's
			# header: the camera culls all 20 layers, and visible=false
			# was measured to half-hide the child too — per-surface
			# ghosting, not layers, is the verified mutual-exclusion
			# seam on this binary).
			var ghost := pawn.get_surface_override_material(0) \
				as StandardMaterial3D
			var self_alpha := ghost.albedo_color.a if ghost != null else 1.0
			var self_draw := pawn.visible and pawn.mesh != null \
				and self_alpha > 0.5
			_emit({"ev": "draw", "job": _job_name, "self_draw": self_draw,
				"self_alpha": self_alpha,
				"child_draw": pawn.get_child_count() > 0,
				"pawn_draws": int(self_draw)
					+ int(pawn.get_child_count() > 0)})
	_frame_tag += 1


var _frame_tag := 0


func _emit(row: Dictionary) -> void:
	_manifest.store_line(JSON.stringify(row))
	_manifest.flush()


func _rect(n: MeshInstance3D) -> Array:
	# the character bbox: the pawn's live aabb projected through the REAL
	# camera (skinned_capture.gd's law), +15 % margin, clamped to the
	# frame AS IT IS — the window size is the project's (the -s harness's
	# root.size write does not outlive window creation), never a pinned
	# constant of this capture's.
	var vs := root.get_visible_rect().size
	var ab := n.get_aabb()
	var lo := Vector2(INF, INF)
	var hi := Vector2(-INF, -INF)
	for sx in [0.0, 1.0]:
		for sy in [0.0, 1.0]:
			for sz in [0.0, 1.0]:
				var w: Vector3 = n.global_transform * (ab.position
					+ Vector3(sx * ab.size.x, sy * ab.size.y,
						sz * ab.size.z))
				var p := _cam.unproject_position(w)
				lo = lo.min(Vector2(p.x, p.y))
				hi = hi.max(Vector2(p.x, p.y))
	var m := (hi - lo) * 0.15
	lo -= m
	hi += m
	return [int(clamp(lo.x, 0.0, VIEW.x)), int(clamp(lo.y, 0.0, VIEW.y)),
		int(clamp(hi.x, 0.0, VIEW.x)), int(clamp(hi.y, 0.0, VIEW.y))]


func _finish() -> void:
	_free_run()
	_manifest.flush()
	print("MOTIONCAP_OK out=", _out_dir)
	quit(0)


func _free_run() -> void:
	if _run != null:
		root.remove_child(_run)
		_run.free()
		_run = null
