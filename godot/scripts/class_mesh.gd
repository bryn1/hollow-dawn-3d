# GLB mesh loader for the horde classes (T-S2i, DESIGN-3D §a/§b): each
# class's TRELLIS.2 glb is imported once at load (the pinned 4.7.2 import
# pass, `godot --headless --import`, generates the res:// .scn that the
# runtime load() reads) and NORMALISED so the live aabb height equals the
# §a model height: uniform scale = target_h / raw aabb.size.y baked into a
# private ArrayMesh copy (the shared imported resource is never mutated;
# uniform scale keeps normals exact). Probed on the pinned binary (this
# card): every batch glb imports as ONE MeshInstance3D, ONE surface, ONE
# StandardMaterial3D — so the ArrayMesh rides the existing per-class
# MultiMesh at exactly ONE draw (§b) and the per-instance transforms +
# gait mechanism (§c) stay untouched.
class_name ClassMesh
extends RefCounted

const GLB_DIR := "res://assets/glb/"

static var _cache := {} # "glb@target_h" -> normalised ArrayMesh


# Height-normalised ArrayMesh for one class glb; loaded + scaled ONCE per
# (glb, target) pair and cached for every later read (horde + probes).
static func mesh_for(glb_file: String, target_h: float) -> ArrayMesh:
	var key := glb_file + "@" + str(target_h)
	if not _cache.has(key):
		_cache[key] = _import(glb_file, target_h)
	return _cache[key]


# MEASURED (not computed) live height: the aabb of the very mesh a class
# MultiMesh renders — the T-S2i normalization-table rows read this.
static func measured_height(glb_file: String, target_h: float) -> float:
	return mesh_for(glb_file, target_h).get_aabb().size.y


# --- SKINNED consumer seam (M6 F1 §1.1, T-M6r, MC 11676) ------------------
# THE FINDING this file ships the fix for: _import below (:35-48) copies
# surface 0's arrays into a NEW ArrayMesh — the skin (Skeleton3D binding,
# blend shapes, the imported AnimationPlayer) is STRIPPED, by design: the
# MultiMesh horde never animates through a skeleton (§c Route A). That is
# why the M5 clips never PLAYED: the pawn rode this same stripping loader
# and had nothing left to animate. M6 F1's skinned consumer therefore
# rides the IMPORTED SCENE, not the ArrayMesh: scene_for() hands out the
# pinned import pass's PackedScene (load() = the engine's own cache — no
# second cache beside _cache) and the CALLER instantiates + normalises at
# the ROOT-NODE SCALE — nothing re-frees the skin, the skinning survives.
static func scene_for(glb_file: String) -> PackedScene:
	return load(GLB_DIR + glb_file) as PackedScene


# Rest-pose height of the imported SCENE (the child normaliser's measure-
# ment, ClassMesh.measured_height shape, read off the scene's own mesh
# node — instantiate/find/measure/free ONCE per apply_selection, not per
# frame). The scene-side twin of _find_mesh: first MeshInstance3D below n.
static func scene_rest_height(glb_file: String) -> float:
	var inst: Node = scene_for(glb_file).instantiate()
	var mi := mesh_node(inst)
	var h: float = mi.get_aabb().size.y if mi != null else 0.0
	inst.free()
	return h


# The scene-side twin of _find_mesh: the first MeshInstance3D below n
# (public — hero_pawn's child uses it for the material-override target;
# one walker, never a second beside it).
static func mesh_node(n: Node) -> MeshInstance3D:
	for c in n.get_children():
		if c is MeshInstance3D:
			return c as MeshInstance3D
		var m := mesh_node(c)
		if m != null:
			return m
	return null


static func _import(glb_file: String, target_h: float) -> ArrayMesh:
	var inst: Node = (load(GLB_DIR + glb_file) as PackedScene).instantiate()
	var src := _find_mesh(inst)
	var aabb := src.get_aabb()
	var s := target_h / aabb.size.y
	var arrays: Array = src.surface_get_arrays(0)
	var verts: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	for i in verts.size():
		verts[i] *= s
	var out := ArrayMesh.new()
	out.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	out.surface_set_material(0, _normal_mat(src.surface_get_material(0)))
	inst.free()
	return out


# Material normalisation (import step, probed on the pinned binary): the
# TRELLIS batch glb ships metallic=1.0 with NO metallic/roughness textures
# and its diffuse BAKED into the albedo map — a full-metal surface with no
# reflection probe renders black, so the loader lands metallic=0 on a
# private duplicate (the shared imported material is never mutated).
static func _normal_mat(m: Material) -> Material:
	var std := m as StandardMaterial3D
	if std == null or std.metallic_texture == null:
		return m
	var fixed: StandardMaterial3D = std.duplicate()
	fixed.metallic = 0.0
	return fixed


static func _find_mesh(n: Node) -> Mesh:
	for c in n.get_children():
		if c is MeshInstance3D:
			return (c as MeshInstance3D).mesh
		var m := _find_mesh(c)
		if m != null:
			return m
	return null
