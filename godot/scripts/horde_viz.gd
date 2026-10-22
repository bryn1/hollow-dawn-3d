# Horde viz (DESIGN-3D §b): ONE MultiMeshInstance3D per enemy class, the
# per-frame transform rewrite being the horde's whole animation mechanism
# (Route A, §c). S3 ships §a build-size capsule placeholders; the scissor
# stub alternates each instance's width<->depth scale channels over the FULL
# RANGE 1.00<->1.24 (ONE p2p convention, amplitudes never doubled) at gait
# freq f = min(spd_m_per_s / GAIT_STRIDE_M, GAIT_FREQ_MAX) — speeds stay the
# v1 px/s values (world.gd §d), divided by S at this boundary. The HP-bar MM
# ports v1's rule (render.gd:185-191): a bar instance exists only while the
# enemy is damaged, per-instance scale.x = hp / max_hp (§b). Class tint is
# one StandardMaterial3D per class at albedo_color = tint_of(type) (§b).
# Sim px map to metres on the XZ plane via CameraRig.PX_PER_M (§a collision).
class_name HordeViz
extends Node3D

# §a build sizes: size_px / S off the v1 SIZES table (render.gd:10 stays the
# px truth) — player 40 px -> 1.67 m, non-boss 34 px -> 1.42 m, boss 128 ->
# 5.33 m. The GLB stage models to these; the placeholder capsules use them.
const MODEL_H_PLAYER := 1.67
const MODEL_H_ENEMY := 1.42
const MODEL_H_BOSS := 5.33

# §c gait constants (dump acceptance rows: freq <= 2.2 Hz, scale range <= 0.24).
const GAIT_STRIDE_M := 1.2
const GAIT_FREQ_MAX := 2.2
const SCISSOR_MIN := 1.00
const SCISSOR_MAX := 1.24

const HP_BAR_M := Vector2(0.7, 0.08) # full-hp bar footprint; scale.x = hp/max
const BAR_Y_CLEARANCE := 0.15

var game: GameState
var world: GameWorld

var _mms := {} # type key -> MultiMeshInstance3D
var _heights := {} # type key -> model height (m)
var _freqs := {} # type key -> gait Hz
var _scales := {} # type key -> {"s": last width scale, "d": last depth scale}
var _bar_mmim: MultiMeshInstance3D
var _bar_basis := Basis(Vector3(1.0, 0.0, 0.0), PI / 2.0) # quad laid flat on XZ


func _ready() -> void:
	for key in GameWorld.ENEMY_TYPES:
		var def: Dictionary = GameWorld.ENEMY_TYPES[key]
		var h: float = MODEL_H_BOSS if def.get("boss", false) else MODEL_H_ENEMY
		_heights[key] = h
		_freqs[key] = minf(def.spd / CameraRig.PX_PER_M / GAIT_STRIDE_M, GAIT_FREQ_MAX)
		_mms[key] = _make_class(key, h, GameRenderer.tint_of(key))
	_bar_mmim = _make_bar()


func _process(_delta: float) -> void:
	refresh()


# Rewrite every class's transform_array (and the HP-bar array) from the live
# sim state. Public so the headless sim can force one write at a dump step.
func refresh() -> void:
	if game == null or world == null:
		return
	var by_class := {}
	var damaged: Array = []
	for e in world.enemies:
		if not e.boss and e.hp < e.max_hp:
			damaged.append(e)
		var arr: Array = by_class.get(e.type, [])
		arr.append(e)
		by_class[e.type] = arr
	var mid := (SCISSOR_MIN + SCISSOR_MAX) / 2.0
	var amp := (SCISSOR_MAX - SCISSOR_MIN) / 2.0
	for key in _mms:
		var mm: MultiMesh = _mms[key].multimesh
		var list: Array = by_class.get(key, [])
		mm.instance_count = list.size()
		var h: float = _heights[key]
		var f: float = _freqs[key]
		var last_s := mid
		var last_d := mid
		for i in list.size():
			var e: Dictionary = list[i]
			if not e.has("gait_p"):
				# spawn-anchored phase so instances do not all beat as one
				e.gait_p = fmod(e.x * 0.017 + e.y * 0.031, TAU)
			last_s = mid + amp * sin(TAU * f * game.time + e.gait_p)
			last_d = SCISSOR_MIN + SCISSOR_MAX - last_s # anti-phase, same range
			mm.set_instance_transform(i, Transform3D(
				Basis(Vector3(last_s, 0.0, 0.0), Vector3(0.0, 1.0, 0.0),
					Vector3(0.0, 0.0, last_d)),
				Vector3(e.x / CameraRig.PX_PER_M, h * 0.5, e.y / CameraRig.PX_PER_M)))
		_scales[key] = {"s": last_s, "d": last_d}
	_write_hp_bars(damaged)


# v1 rule (render.gd:185-191): the boss rides its own bar, full-hp enemies
# draw none — so instances here exist ONLY for damaged non-boss units.
func _write_hp_bars(damaged: Array) -> void:
	var mm: MultiMesh = _bar_mmim.multimesh
	mm.instance_count = damaged.size()
	for i in damaged.size():
		var e: Dictionary = damaged[i]
		var fill := clampf(e.hp / e.max_hp, 0.0, 1.0)
		var h: float = _heights.get(e.type, MODEL_H_ENEMY)
		mm.set_instance_transform(i, Transform3D(
			_bar_basis.scaled(Vector3(fill, 1.0, 1.0)),
			Vector3(e.x / CameraRig.PX_PER_M, h + BAR_Y_CLEARANCE,
				e.y / CameraRig.PX_PER_M)))


func gait_probe() -> Dictionary:
	var out := {}
	for key in _freqs:
		out[key] = {"freq": _freqs[key], "range": [SCISSOR_MIN, SCISSOR_MAX],
			"last": _scales.get(key, {})}
	return out


func _make_class(key: String, h: float, tint: Color) -> MultiMeshInstance3D:
	var mesh := CapsuleMesh.new()
	mesh.radius = h * 0.25
	mesh.height = h
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh # VERIFIED on the pinned 4.7.2 binary: mesh lives on MultiMesh
	var mmim := MultiMeshInstance3D.new()
	mmim.multimesh = mm
	var mat := StandardMaterial3D.new()
	mat.albedo_color = tint
	mmim.material_override = mat
	add_child(mmim)
	return mmim


func _make_bar() -> MultiMeshInstance3D:
	var mesh := QuadMesh.new()
	mesh.size = HP_BAR_M
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	var mmim := MultiMeshInstance3D.new()
	mmim.multimesh = mm
	var mat := StandardMaterial3D.new()
	mat.albedo_color = GameRenderer.BLOOD
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mmim.material_override = mat
	add_child(mmim)
	return mmim
