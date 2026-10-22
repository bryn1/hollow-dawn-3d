# The survivor's pawn (§f hero_pawn.gd). S3 ships a §a-size capsule
# placeholder (1.67 m = v1 player 40 px / S) standing at (x, y) / S on the
# XZ plane; WASD motion comes through the verbatim main.gd loop (BASE_SPEED
# px/s ÷ S = m/s). Iframes paint v1's rule as data (render.gd:134-138: a
# constant alpha 0.55 while iframes > 0 — cycle-3 wording, no pulse). The
# skinned GLB + AnimationTree and the L5 player-alt swap ride in with the
# art stage (§c/§d rows).
extends MeshInstance3D

var game: GameState

var _mat: StandardMaterial3D


func _ready() -> void:
	var cap := CapsuleMesh.new()
	cap.radius = HordeViz.MODEL_H_PLAYER * 0.25
	cap.height = HordeViz.MODEL_H_PLAYER
	mesh = cap
	_mat = StandardMaterial3D.new()
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat.albedo_color = GameRenderer.BONE # v1's bone-pale survivor read
	material_override = _mat


func _process(_delta: float) -> void:
	if game == null:
		return
	var p: Dictionary = game.player
	position = Vector3(p.x / CameraRig.PX_PER_M,
		HordeViz.MODEL_H_PLAYER * 0.5, p.y / CameraRig.PX_PER_M)
	_mat.albedo_color.a = 0.55 if p.iframes > 0.0 else 1.0
