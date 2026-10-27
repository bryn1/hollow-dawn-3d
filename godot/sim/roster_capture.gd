# MC 11422 T-M5c — ROSTER clip frame-diff capture for the eight new
# character GLBs (M5-SPEC §2.3 B-E8: walk/attack >= 2 px per mesh + the
# FROZEN same-time control 0 px — the clips are REAL motion through the
# skin, not renderer noise).
# DONOR: sim/skinned_capture.gd (MC 11138 T-S2r). That file is BYTE-LOCKED
# by its committed fixture's provenance (tests/fixtures/skinned-clips-s2r-
# framediff.csv), so the mechanism could not be shared by refactor without
# touching it — this driver carries the SAME op-machine (op-queue stepped
# on frame_post_draw; GLTFDocument runtime load; duplicate()d viewport
# grabs; projected-AABB rect; 2 motion pairs + 1 frozen control per clip),
# with the roster as the job source. The CSV conversion + validator ride
# the S2r shape (tools/... one-off PIL pass -> committed
# tests/fixtures/roster-clips-m5-framediff.csv, generated TWICE cmp-
# identical, judged by test_skinned_clips-shaped rows in
# tests/test_characters.py B-E8). RIG STATE IS MEASURED, NOT ASSUMED
# (docs/RIG-DEVIATION-SEL-C.md, MC 11440 owner "Rec"): a mesh with an
# AnimationPlayer MUST ship both named clips (else loud), a mesh without
# one writes an EXCUSED static row per clip (EXCUSED-not-removed; the
# validator pins the measured state against the deviation table). CSV
# columns: rig,clip,pair,kind,diff_px,rig_state. Run windowed under Xvfb (a real GL
# window proves the frames exist; --headless cannot):
#   xvfb-run <godot> --render-driver opengl3 --path godot \
#     -s res://sim/roster_capture.gd -- [<glb>...] --out <dir>
# With NO glb args the job list is the eight NEW ROSTER rows (rows 1-8;
# row 0 is the shipped player, already measured by the S2r set).
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
	if _jobs.is_empty():
		# the roster default: the eight NEW meshes (row 0 = player.glb is
		# the shipped pawn, its clips measured by the S2r set already) +
		# the five SKINS meshes (M5 §3.1 K-E3, T-M5k MC 11423: the skins
		# ride the SAME op-machine, the SAME fixture and the SAME pin doc
		# — roster-capture rows GROW for skins, no second capture; the
		# char jobs keep their queue order, the skin jobs APPEND). The
		# diff_px values are GL-render measures: this fixture is the
		# threshold-judged forward-lock (B-E8/K-E3 judge >= 2 / == 0 px;
		# the twice-cmp determinism runs land in the card capture), NOT a
		# byte corpus — the §7.1 byte law rides the journey/fixtures.
		for row in Roster.CHARACTERS:
			if String(row.mesh) != "player.glb":
				_jobs.append({"rig": String(row.id),
				              "glb": "res://assets/glb/" + String(row.mesh)})
		for srow in Roster.SKINS:
			_jobs.append({"rig": String(srow.id),
			              "glb": "res://assets/glb/" + String(srow.mesh)})
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
	assert(_mesh != null, "no MeshInstance3D: " + j.glb)
	if _player == null:
		# MEASURED STATIC (docs/RIG-DEVIATION-SEL-C.md, MC 11440, owner
		# "Rec"): no skeleton ships for this mesh, so no clip can be
		# played. The capture MEASURES the fact and records an excused
		# manifest row per clip (EXCUSED-not-removed — the row stays in
		# the CSV); the validator (test_characters B-E8) judges the fact
		# against the deviation doc row, so a mesh drifting out of its
		# recorded state goes RED there, never silently here.
		for clip in CLIPS:
			_manifest.store_line(JSON.stringify({"rig": _rig, "clip": clip,
			                                     "state": "static"}))
		_manifest.flush()
		return true
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-55.0, 35.0, 0.0)
	_scene_root.add_child(light)
	_cam = Camera3D.new()
	_scene_root.add_child(_cam)
	var ab := _mesh.get_aabb()
	# local == global: the instance rides _scene_root at the origin (and
	# _initialize runs before the tree processes, where a global read
	# returns identity anyway — declared, not assumed)
	_center = ab.get_center()
	_radius = 0.6 * ab.size.length()  # half-diagonal + limb-swing room
	_cam.fov = 40.0
	# fit: put the half-diagonal inside ~80 % of the frame
	var dist: float = _radius / tan(deg_to_rad(_cam.fov * 0.5)) * 1.25
	_cam.position = _center + Vector3(0.0, _radius * 0.1, dist)
	_cam.look_at_from_position(_cam.position, _center, Vector3.UP)
	_cam.current = true
	for clip in CLIPS:
		assert(_player.has_animation(clip),
		       "AnimationPlayer WITHOUT NAMED CLIP: " + clip + " in " + j.glb
		       + " — a rigged mesh must ship walk+attack")
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
	while _ops.is_empty():
		# the current job is done — retire it and load the next. A STATIC
		# job queues NO ops (its excused manifest rows are already
		# written), so the loop simply skips it without needing a draw.
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
