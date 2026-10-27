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


# The §2.1b apply-step (M5 §2.1b, T-M5c, MC 11422 — the MC 11316 P1-1
# class fix): the ENTIRE _ready body moved here VERBATIM (mesh read + the
# material re-derive, duplicate-first law included; the mesh row is now
# char-guarded INSIDE _player_mesh(), the ONE seam). _ready() calls this
# unchanged — boot = row 0 = the shipped byte behaviour, the boot-once
# invariant holds (main instantiates the pawn exactly once, :89-91) — and
# main._start_game() calls it again at the F-7 hand-in tail so a mid-menu
# selection re-skins the SAME node in-session (B-E7's twin legs).
func apply_selection() -> void:
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


func _ready() -> void:
	apply_selection()


# The ONE mesh-source seam: the player rides the same ClassMesh loader as
# the horde, height-normalised to the §a row (1.67 m). The live height of
# this very mesh is a table row in the committed probe dump
# (sim/art_probe.gd -> tests/fixtures/art-s2i-probe.jsonl), gated <= 10 %
# by test_art_integration.py.
# M5 §2.1 (T-M5c): the row read is char-guarded HERE, at this ONE seam —
# row 0 keeps the shipped literal call verbatim (byte law F-2 + the
# test_art_integration seam pin); rows 1-8 read the ROSTER mesh row at the
# SAME ClassMesh loader + SAME MODEL_H_PLAYER class height (B-E7: no new
# loader, no per-row height special-case). The skin read LANDED AT T-M5k
# (MC 11423, replace-not-delete of the rides-with note this line carried):
# ONE expression (Roster.skin_mesh) at this SAME seam — §3.1 "Applying a
# skin = the SAME _player_mesh() seam reading well.skin through the
# selected character's skin group". skin 0 / garbage / unwearable all
# read "" (the group clamp lives in roster.gd), so every branch below
# stands verbatim: the shipped default call is byte-untouched (K-E1/F-2)
# and an unwearable stale row shows the CHAR's own mesh, never another
# char's skin.
func _player_mesh() -> Mesh:
	var char := 0 if game == null else int(game.char_id)
	var skin := Roster.skin_mesh(char, 0 if game == null
		else int(game.skin_id))
	if skin != "":
		return ClassMesh.mesh_for(skin, HordeViz.MODEL_H_PLAYER)
	if char > 0:
		return ClassMesh.mesh_for(Roster.row(char).mesh,
			HordeViz.MODEL_H_PLAYER)
	return ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER)


func _process(_delta: float) -> void:
	if game == null:
		return
	var p: Dictionary = game.player
	position = Vector3(p.x / CameraRig.PX_PER_M,
		HordeViz.MODEL_H_PLAYER * 0.5, p.y / CameraRig.PX_PER_M)
	_mat.albedo_color.a = 0.55 if p.iframes > 0.0 else 1.0
