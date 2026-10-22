# Orthographic top-down camera rig (DESIGN-3D §a): one Camera3D on a rig node
# re-centred on the player every frame. v1 entities are size-pinned regardless
# of distance (render.gd:10), so the projection is ORTHOGONAL with size 30.0 m
# at the 720 px viewport => the ground scale S = PX_PER_M = 24 px/m (this
# constant is the ONE ground-scale source; the viz nodes reference it).
# Pitched 20 deg off straight-down (rotation -70 deg about X); 40 m out =>
# offset (0, 40*cos20, 40*sin20) = (0, 37.6, 13.7); near 0.5 / far 90 brackets
# the 5.4 m boss + glow (§a fixes cycle-1's dangling ref).
class_name CameraRig
extends Node3D

const PX_PER_M := 24.0 # §a ground scale S = 720 px / ortho size 30 m
const ORTHO_SIZE := 30.0
const CAM_OFFSET := Vector3(0.0, 37.6, 13.7)
const PITCH_DEG := -70.0 # 20 deg off straight-down (70 deg below horizontal)

var game: GameState


func _ready() -> void:
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = ORTHO_SIZE
	cam.near = 0.5
	cam.far = 90.0
	cam.position = CAM_OFFSET
	cam.rotation_degrees = Vector3(PITCH_DEG, 0.0, 0.0)
	add_child(cam)


func _process(_delta: float) -> void:
	if game != null:
		position = Vector3(game.player.x / PX_PER_M, 0.0, game.player.y / PX_PER_M)
