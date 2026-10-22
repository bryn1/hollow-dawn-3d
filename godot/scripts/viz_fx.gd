# Weapon FX emitters (DESIGN-3D §i, the §f-named viz_fx.gd): six weapon
# effect classes batched into MultiMeshes / small meshes — one draw per
# effect class, ember rides two (orb + trail ribbon) => FX draws <= 7 of
# §b's budget. All FX are additive, unlit, shadow-cast OFF (§i). Colours are
# v1's (MOON/EMBER/ICHOR/BONE, render.gd:12-18); fade alphas mirror v1's
# _draw_fx (arc 0.35·life/max, ring 0.25·life/max, burst 0.6·life/max, bolts
# + throws + halo constant). Sim truth stays v1-verbatim: this node only
# READS the WeaponSystem transient arrays (weapons.gd bolts/throws/bursts/
# arcs/rings/halos) — it never writes sim state.
# §i live-count caps: the RENDER layer caps its instances at the §i formulas
# (ember 1+floor((L-1)/3), cleaver 1+floor((L-1)/4), halo 1+ceil(L/3) <= 4,
# spike shards SPARKS <= 20 per brief row 4). The sim's own projectile lists
# are untouched — overlapping volleys the sim allows past the render cap are
# the sim's business; the visible-layer budget is this file's.
class_name WeaponFxViz
extends Node3D

# §i draw column: 6 weapon classes, ember = orb + trail => 7 batched draws.
const FX_DRAWS_MAX := 7
const SPARKS := 16 # spike ground-burst shards per burst (brief cap: <= 20)

# Ground-plane decal heights (above ground quad y=0, below entity bodies).
const Y_DECAL := 0.03 # talon wedge + ward ring + spike shards
const Y_ORB := 0.9 # bolt/halo orb flight line (~34 px read)
const TRAIL_M := 0.55 # ember trail ribbon length (visual only, §i)

var game: GameState
var sim: WeaponSystem # the ported weapons.gd instance — READ only

var _arc: MultiMeshInstance3D
var _orb: MultiMeshInstance3D
var _trail: MultiMeshInstance3D
var _axe: MultiMeshInstance3D
var _ring: MultiMeshInstance3D
var _halo: MultiMeshInstance3D
var _shard: MultiMeshInstance3D
var _counts := {} # last refresh()'s RENDERED instance counts per FX slot


func _ready() -> void:
	_arc = _fx_mm(_wedge_mesh(), _mat(GameRenderer.MOON, true))
	_orb = _fx_mm(_orb_mesh(), _mat(GameRenderer.EMBER, true))
	_trail = _fx_mm(_trail_mesh(), _mat(GameRenderer.EMBER, true, 0.45))
	_axe = _fx_mm(_axe_mesh(), _mat(GameRenderer.BONE, false))
	_ring = _fx_mm(_annulus_mesh(), _mat(GameRenderer.MOON, true))
	_halo = _fx_mm(_orb_mesh(), _mat(GameRenderer.EMBER, true))
	_shard = _fx_mm(_shard_mesh(), _mat(GameRenderer.ICHOR, true))


func _process(_delta: float) -> void:
	refresh()


# Rewrite every FX array from the live transient state. Public so the
# headless sim forces one write at a dump step (same pattern as HordeViz).
func refresh() -> void:
	if game == null or sim == null:
		return
	var s := 1.0 / CameraRig.PX_PER_M
	_write_arcs(s)
	var bolts: Array = sim.bolts.slice(maxi(0, sim.bolts.size() - _cap("ember")))
	_write_orbs(_orb, bolts, Y_ORB)
	_write_trails(bolts)
	var throws: Array = sim.throws.slice(maxi(0, sim.throws.size() - _cap("cleaver")))
	_write_throws(throws, s)
	_write_halos()
	_write_rings(s)
	_write_bursts(s)


# RENDERED instance counts per FX slot from the last refresh (the §i cap
# rows compare THESE — the visible-layer live counts — never sim arrays).
func fx_counts() -> Dictionary:
	return _counts.duplicate()


# The §i worst case is always 7 (every class batched at all times); the
# renderer issues fewer calls when a class has zero live instances.
func draw_count() -> int:
	return FX_DRAWS_MAX


func live_draws() -> int:
	var n := 0
	for mmim in [_arc, _orb, _trail, _axe, _ring, _halo, _shard]:
		if mmim.multimesh.instance_count > 0:
			n += 1
	return n


# §i formulas, spelled as weapons.gd spells them (same cap source):
func _cap(id: String) -> int:
	match id:
		"ember":
			return 1 + int((_level("ember") - 1) / 3)
		"cleaver":
			return 1 + int((_level("cleaver") - 1) / 4)
		_:
			return 0


# One rotation frame whose local +Z is the given XZ direction (sim px space
# maps x->x, y->z). ONE mechanism shared with horde_viz's attack squash.
static func frame_xz(vx: float, vy: float) -> Basis:
	var d := maxf(sqrt(vx * vx + vy * vy), 1e-6)
	var x := vx / d
	var z := vy / d
	return Basis(Vector3(z, 0.0, -x), Vector3(0.0, 1.0, 0.0), Vector3(x, 0.0, z))


func _level(id: String) -> int:
	for w in game.weapons:
		if w.id == id:
			return w.level
	return 1


func _write_arcs(s: float) -> void:
	var mm: MultiMesh = _arc.multimesh
	mm.instance_count = sim.arcs.size()
	for i in sim.arcs.size():
		var a: Dictionary = sim.arcs[i]
		var f := frame_xz(cos(a.ang), sin(a.ang))
		mm.set_instance_transform(i, Transform3D(
			f.scaled(Vector3.ONE * (a.range * s)), # unit wedge -> v1 range
			Vector3(game.player.x * s, Y_DECAL, game.player.y * s)))
	# v1 alpha 0.35·life/max; arcs never overlap (cd 0.55·0.96^7 > life 0.15)
	_arc.material_override.albedo_color.a = 0.0 if sim.arcs.is_empty() \
		else 0.35 * sim.arcs[-1].life / sim.arcs[-1].max
	_counts.arcs = mm.instance_count


func _write_orbs(mmim: MultiMeshInstance3D, items: Array, y: float) -> void:
	var mm: MultiMesh = mmim.multimesh
	mm.instance_count = items.size()
	for i in items.size():
		mm.set_instance_transform(i, Transform3D(Basis.IDENTITY,
			Vector3(items[i].x / CameraRig.PX_PER_M, y,
				items[i].y / CameraRig.PX_PER_M)))


func _write_trails(bolts: Array) -> void:
	var mm: MultiMesh = _trail.multimesh
	mm.instance_count = bolts.size()
	for i in bolts.size():
		var b: Dictionary = bolts[i]
		var f := frame_xz(-b.vx, -b.vy) # ribbon trails behind the flight
		mm.set_instance_transform(i, Transform3D(f.scaled(Vector3(1.0, 1.0, TRAIL_M)),
			Vector3(b.x / CameraRig.PX_PER_M, Y_ORB, b.y / CameraRig.PX_PER_M)))
	_counts.bolts = _orb.multimesh.instance_count
	_counts.trails = mm.instance_count


# v1 lift: sin(PI·prog)·26 px (render.gd:155) on a spinning axe (visual).
func _write_throws(throws: Array, s: float) -> void:
	var mm: MultiMesh = _axe.multimesh
	mm.instance_count = throws.size()
	for i in throws.size():
		var t: Dictionary = throws[i]
		var prog: float = clampf(t.dist / t.travel, 0.0, 1.0)
		var f := frame_xz(t.vx, t.vy).rotated(Vector3.UP, game.time * 14.0 + i * 2.1)
		mm.set_instance_transform(i, Transform3D(f,
			Vector3(t.x * s, 0.45 + sin(PI * prog) * 26.0 * s, t.y * s)))
	_counts.axes = mm.instance_count


func _write_halos() -> void:
	_write_orbs(_halo, sim.halos, Y_ORB)
	_counts.halos = _halo.multimesh.instance_count


func _write_rings(s: float) -> void:
	var mm: MultiMesh = _ring.multimesh
	mm.instance_count = mini(sim.rings.size(), 1) # cd 0.45 > life 0.12
	if mm.instance_count > 0:
		var r: Dictionary = sim.rings[-1]
		var prog: float = 1.0 - r.life / r.max
		var rm: float = r.r * s * (0.55 + 0.5 * prog) # expanding pulse, §i
		mm.set_instance_transform(0, Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * rm),
			Vector3(game.player.x * s, Y_DECAL + 0.01, game.player.y * s)))
		_ring.material_override.albedo_color.a = 0.25 * r.life / r.max
	else:
		_ring.material_override.albedo_color.a = 0.0
	_counts.rings = mm.instance_count


func _write_bursts(s: float) -> void:
	var mm: MultiMesh = _shard.multimesh
	if sim.bursts.is_empty():
		mm.instance_count = 0
		_shard.material_override.albedo_color.a = 0.0
		_counts.bursts = 0
		_counts.shards = 0
		return
	var b: Dictionary = sim.bursts[-1] # cd >= 1.95 s > life 0.25 s
	var prog: float = 1.0 - b.life / b.max
	var rm: float = b.r * s * (0.25 + 0.75 * prog)
	mm.instance_count = SPARKS
	for i in SPARKS:
		var a := float(i) / float(SPARKS) * TAU
		var dx := cos(a)
		var dz := sin(a)
		var f := frame_xz(dx, dz)
		mm.set_instance_transform(i, Transform3D(
			f.scaled(Vector3(1.0, 0.4 + 0.6 * prog, 1.0)),
			Vector3(b.x * s + dx * rm, Y_DECAL + 0.2, b.y * s + dz * rm)))
	_shard.material_override.albedo_color.a = 0.6 * b.life / b.max
	_counts.bursts = 1
	_counts.shards = SPARKS


func _fx_mm(mesh: Mesh, mat: StandardMaterial3D) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	var mmim := MultiMeshInstance3D.new()
	mmim.multimesh = mm
	mmim.material_override = mat
	mmim.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF # §i
	add_child(mmim)
	return mmim


func _mat(col: Color, additive: bool, alpha := 1.0) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(col.r, col.g, col.b, alpha)
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	if additive:
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	return mat


# --- flat-in-XZ geometry helpers (unit sized; instances scale) ------------

func _trail_mesh() -> ArrayMesh:
	# Flat quad, z in [-1,0]: trails behind local +Z (the bolt's flight).
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	_tri(st, Vector3(-1, 0, 0), Vector3(1, 0, 0), Vector3(1, 0, -1))
	_tri(st, Vector3(-1, 0, 0), Vector3(1, 0, -1), Vector3(-1, 0, -1))
	st.generate_normals()
	return st.commit()


func _wedge_mesh() -> ArrayMesh:
	# Talon quarter-disc: fan from the survivor out to unit radius spanning
	# ±0.62 rad about +Z (v1 _draw_fx wedge, render.gd:143-148 in 3D).
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in 8:
		var a0 := -0.62 + 1.24 * float(i) / 8.0
		var a1 := -0.62 + 1.24 * float(i + 1) / 8.0
		_tri(st, Vector3.ZERO, Vector3(sin(a0), 0, cos(a0)), Vector3(sin(a1), 0, cos(a1)))
	st.generate_normals()
	return st.commit()


func _annulus_mesh() -> ArrayMesh:
	# Ward ring-pulse decal: flat annulus, inner 0.82 of unit outer radius.
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in 24:
		var a0 := float(i) / 24.0 * TAU
		var a1 := float(i + 1) / 24.0 * TAU
		var i0 := Vector3(sin(a0), 0, cos(a0)) * 0.82
		var i1 := Vector3(sin(a1), 0, cos(a1)) * 0.82
		var o0 := Vector3(sin(a0), 0, cos(a0))
		var o1 := Vector3(sin(a1), 0, cos(a1))
		_tri(st, i0, o0, o1)
		_tri(st, i0, o1, i1)
	st.generate_normals()
	return st.commit()


func _orb_mesh() -> SphereMesh:
	var s := SphereMesh.new()
	s.radius = 0.2
	s.height = 0.4
	s.radial_segments = 8
	s.rings = 6
	return s


func _axe_mesh() -> BoxMesh:
	var b := BoxMesh.new()
	b.size = Vector3(0.45, 0.08, 0.14) # bone-axe read; T2 prop at art stage
	return b


func _shard_mesh() -> BoxMesh:
	var b := BoxMesh.new()
	b.size = Vector3(0.08, 0.55, 0.16) # radial ground shard, §i spike row
	return b


static func _tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	st.add_vertex(a)
	st.add_vertex(b)
	st.add_vertex(c)
