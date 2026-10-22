# MC 11138 T-S2r — skinned pose frame-diff capture for the player + warden
# GLBs (DESIGN-3D §c skinned contract / DOD-ACCEPTANCE S2 skinned row).
# Run windowed under Xvfb — a real GL window proves the frames exist, which
# --headless cannot (strips/cards_capture.gd pattern, reused: op-queue
# state machine stepped on frame_post_draw — the drivers never rely on
# `await`, and neither does this):
#   xvfb-run <godot> --render-driver opengl3 --path godot \
#     -s res://sim/skinned_capture.gd -- <glb>... --out <dir>
# GLBs load through GLTFDocument at RUNTIME (no editor import step): the
# bytes the card rewrites are the bytes the engine parses.
# Per rig, per clip (walk / attack) on the imported AnimationPlayer:
#   2 distinct-time pairs + 1 FROZEN control pair (same time twice — the
#   required RED side: the gate must measure MOTION, not renderer noise).
# Frames are duplicate()d viewport grabs (Godot 4 get_image() returns a
# REFERENCE — S2h lesson) saved PNG; the per-pair rect is the skinned
# mesh's projected AABB corners (rest extent, limb-swing room baked into
# the 0.75*diagonal radius) — the VM350 PIL abs-diff runs INSIDE that
# character bbox only, same rect for both frames of a pair.
extends SceneTree

const VIEW := Vector2i(640, 640)
const PAIRS := [[0.10, 0.55], [0.30, 0.75]]  # fractions of clip length
const CLIPS := ["walk", "attack"]

var _out_dir: String
var _manifest: FileAccess
var _jobs: Array = []
var _job_i := -1
var _ops: Array = []       # queued {op:...} steps, one per draw
var _rig: String
var _scene_root: Node3D
var _player: AnimationPlayer
var _mesh: MeshInstance3D
var _cam: Camera3D
var _center := Vector3.ZERO
var _radius := 1.0
var _cur: Dictionary = {}   # current leg bookkeeping


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var i := 0
	while i < args.size():
		if args[i] == "--out" and i + 1 < args.size():
			_out_dir = args[i + 1]
			i += 2
			continue
		if args[i].ends_with(".glb"):
			_jobs.append({"rig": args[i].get_file().trim_suffix(".glb"),
			              "glb": args[i]})
		i += 1
	assert(not _jobs.is_empty() and _out_dir != "", "need glb args + --out")
	DirAccess.make_dir_recursive_absolute(_out_dir + "/frames")
	_manifest = FileAccess.open(_out_dir + "/manifest.jsonl", FileAccess.WRITE)
	root.size = VIEW
	_next_job()
	RenderingServer.frame_post_draw.connect(_tick, CONNECT_ONE_SHOT)


func _next_job() -> bool:
	_job_i += 1
	if _job_i >= _jobs.size():
		return false
	var j: Dictionary = _jobs[_job_i]
	_rig = j.rig
	_scene_root = Node3D.new()
	root.add_child(_scene_root)
	var doc := GLTFDocument.new()
	var state := GLTFState.new()
	assert(doc.append_from_file(j.glb, state) == OK, "GLB load failed: " + j.glb)
	var inst := doc.generate_scene(state)
	assert(inst != null, "GLB scene gen failed: " + j.glb)
	_scene_root.add_child(inst)
	_player = _find(inst, "AnimationPlayer") as AnimationPlayer
	_mesh = _find(inst, "MeshInstance3D") as MeshInstance3D
	assert(_player != null and _mesh != null, "no AnimationPlayer/Mesh: " + j.glb)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-55.0, 35.0, 0.0)
	_scene_root.add_child(light)
	_cam = Camera3D.new()
	_scene_root.add_child(_cam)
	var ab := _mesh.get_aabb()
	_center = _mesh.global_transform * ab.get_center()
	_radius = 0.6 * ab.size.length()  # half-diagonal + limb-swing room
	_cam.fov = 40.0
	# fit: put the half-diagonal inside ~80 % of the frame
	var dist: float = _radius / tan(deg_to_rad(_cam.fov * 0.5)) * 1.25
	_cam.position = _center + Vector3(0.0, _radius * 0.1, dist)
	_cam.look_at_from_position(_cam.position, _center, Vector3.UP)
	_cam.current = true
	for clip in CLIPS:
		var ln: float = _player.get_animation(clip).length
		assert(ln > 0.5, "clip too short: " + clip)
		var legs := []
		for pr in PAIRS:
			legs.append({"kind": "motion", "ta": ln * pr[0], "tb": ln * pr[1]})
		legs.append({"kind": "frozen", "ta": ln * 0.5, "tb": ln * 0.5})
		for li in legs.size():
			var leg: Dictionary = legs[li]
			_ops.append({"op": "seek", "clip": clip, "t": leg.ta,
			             "kind": leg.kind, "pair": li, "tb": leg.tb})
			_ops.append({"op": "draw"})
			_ops.append({"op": "draw"})
			_ops.append({"op": "save", "slot": "a", "clip": clip, "pair": li})
			_ops.append({"op": "seek", "clip": clip, "t": leg.tb,
			             "kind": leg.kind, "pair": li, "ta": leg.ta})
			_ops.append({"op": "draw"})
			_ops.append({"op": "draw"})
			_ops.append({"op": "save", "slot": "b", "clip": clip, "pair": li})
	return true


func _tick(_d = null) -> void:
	if _ops.is_empty():
		root.remove_child(_scene_root)
		_scene_root.free()
		if not _next_job():
			quit(0)
			return
	var step: Dictionary = _ops.pop_front()
	match step.op:
		"seek":
			_player.stop()
			_player.speed_scale = 0.0
			_player.play(step.clip)
			_player.seek(step.t, true)
			if step.has("tb"):  # first seek of the pair: start a row
				_cur = {"rig": _rig, "clip": step.clip,
				        "kind": step.kind, "pair": step.pair,
				        "ta": step.t, "tb": step.tb}
			else:  # second seek: same leg, record time b
				_cur["tb"] = step.t
		"save":
			var path := "%s/frames/%s_%s_%d_%s.png" % [
				_out_dir, _rig, step.clip, step.pair, step.slot]
			var img := _grab()
			assert(img.save_png(path) == OK)
			_cur["f" + step.slot] = path
			if step.slot == "b":
				_cur["rect"] = _rect(img)
				_manifest.store_line(JSON.stringify(_cur))
				_manifest.flush()
				_cur = {}
		"draw":
			pass
	RenderingServer.frame_post_draw.connect(_tick, CONNECT_ONE_SHOT)


func _grab() -> Image:
	return root.get_texture().get_image().duplicate()


func _rect(img: Image) -> Array:
	# the character bbox = projected skinned-mesh AABB corners (rest AABB;
	# these rigs rest with limbs out, so clips stay inside) +15 % margin,
	# clamped to the REAL frame size
	var w := _mesh.global_transform
	var ab := _mesh.get_aabb()
	var lo := Vector3(INF, INF, 0.0)
	var hi := Vector3(-INF, -INF, 0.0)
	for sx in [0.0, 1.0]:
		for sy in [0.0, 1.0]:
			for sz in [0.0, 1.0]:
				var p := _cam.unproject_position(w * ab.position + w.basis
					* Vector3(sx * ab.size.x, sy * ab.size.y, sz * ab.size.z))
				lo = lo.min(Vector3(p.x, p.y, 0))
				hi = hi.max(Vector3(p.x, p.y, 0))
	var m := (hi - lo) * 0.15
	lo -= Vector3(m.x, m.y, 0)
	hi += Vector3(m.x, m.y, 0)
	return [int(clamp(lo.x, 0, img.get_width())),
	        int(clamp(lo.y, 0, img.get_height())),
	        int(clamp(hi.x, 0, img.get_width())),
	        int(clamp(hi.y, 0, img.get_height()))]


func _find(n: Node, cname: String) -> Node:
	for ch in n.get_children():
		if ch.get_class() == cname:
			return ch
		var r := _find(ch, cname)
		if r != null:
			return r
	return null
