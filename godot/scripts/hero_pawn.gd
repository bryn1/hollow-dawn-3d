# The survivor's pawn (§f hero_pawn.gd). T-S2p (MC 11135) swapped the S3
# §a-size capsule placeholder for the player GLB (player.glb, MC 11132)
# at the ONE _player_mesh() seam: ClassMesh height-normalises it to the
# §a row 1.67 m (v1 player 40 px / S) exactly like every horde class, ONE
# draw kept. WASD motion comes through the verbatim main.gd loop (BASE_SPEED
# px/s ÷ S = m/s). Iframes paint v1's rule as data (render.gd:134-138: a
# constant alpha 0.55 while iframes > 0 — cycle-3 wording, no pulse): the
# alpha now rides a PRIVATE duplicate of the GLB's own material (§b
# multiplier convention, same as the horde tints), so the baked albedo
# texture stays visible and only its multiplier alpha dims. The skinned
# GLB + AnimationTree and the L5 player-alt swap ride in with the art
# stage (§c/§d rows).
extends MeshInstance3D

var game: GameState

var _mat: StandardMaterial3D

# v1 parity of the READ: the 2D survivor drew UNSHADED (canvas texture x
# modulate, no lighting) in bone-pale over the dark ground. The GLB lands
# under the §b moonlight, and the baked robe texture is very dark (albedo
# luma mean 29 measured, vs the wraith's 66), so shaded + plain-BONE sinks
# the hero into the moor (the §b tint table exists for exactly this:
# "silhouettes separate from the dark background"). The pawn material
# therefore draws UNSHADED with v1's bone hue lifted above 1 (Godot
# multiplies albedo_color into the texture, no clamp) — the sprite-era
# full-brightness read carried onto the GLB. iframes-alpha unchanged.
# T-S10 (MC 11159, owner contrast ruling): the multiplier is lifted 2.6 ->
# 3.6 — the same unshaded-multiplier seam, re-tuned against the darkened
# (tone 0.62) ground so the hero/floor luma ratio clears the >= 2.0 gate.
const PLAYER_TINT := GameRenderer.BONE * 3.6


func _ready() -> void:
	mesh = _player_mesh()
	# The iframes-alpha rule carried onto the GLB material (T-S2i seam
	# note): duplicate FIRST — the ClassMesh cache is shared, the imported
	# material is never mutated — then alpha transparency + the bone-pale
	# multiplier over the baked albedo texture.
	var src := mesh.surface_get_material(0) as StandardMaterial3D
	_mat = src.duplicate() if src != null else StandardMaterial3D.new()
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED # v1 2D read
	_mat.albedo_color = PLAYER_TINT # v1's bone-pale survivor read
	material_override = _mat


# The ONE mesh-source seam: the player rides the same ClassMesh loader as
# the horde, height-normalised to the §a row (1.67 m). The live height of
# this very mesh is a table row in the committed probe dump
# (sim/art_probe.gd -> tests/fixtures/art-s2i-probe.jsonl), gated <= 10 %
# by test_art_integration.py.
func _player_mesh() -> Mesh:
	return ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER)


func _process(_delta: float) -> void:
	if game == null:
		return
	var p: Dictionary = game.player
	position = Vector3(p.x / CameraRig.PX_PER_M,
		HordeViz.MODEL_H_PLAYER * 0.5, p.y / CameraRig.PX_PER_M)
	_mat.albedo_color.a = 0.55 if p.iframes > 0.0 else 1.0
