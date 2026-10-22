# Biome ground layer (DESIGN-3D §a): one 80 x 60 m quad re-centred on the
# player every frame + shaders/ground.gdshader world-locking the tiling (tile
# = v1's 1024 px / S = 42.7 m, the equivalent of v1's grid-snap tiled draw,
# render.gd:215-222). The band swaps through the ONE GameRenderer.biome_at
# mechanism; the albedo textures are the four v1 tiles carried byte-identical
# (godot/assets/biomes/).
extends MeshInstance3D

const QUAD := Vector2(80.0, 60.0) # §a ground quad, re-centred on the camera

var game: GameState

var _band_name := ""
var _texs := {}


func _ready() -> void:
	var quad := QuadMesh.new()
	quad.size = QUAD
	mesh = quad
	rotation_degrees = Vector3(-90.0, 0.0, 0.0) # lay the XY quad flat on XZ
	var mat := ShaderMaterial.new()
	mat.shader = load("res://shaders/ground.gdshader")
	material_override = mat
	for b in GameRenderer.BIOMES:
		_texs[b.name] = load(b.tex)
	_set_band(GameRenderer.biome_at(0.0).name)


func _process(_delta: float) -> void:
	if game == null:
		return
	position = Vector3(game.player.x / CameraRig.PX_PER_M, 0.0,
		game.player.y / CameraRig.PX_PER_M)
	var band: Dictionary = GameRenderer.biome_at(game.time)
	if band.name != _band_name:
		_set_band(band.name)


func _set_band(band_name: String) -> void:
	_band_name = band_name
	material_override.set_shader_parameter("albedo_tex", _texs.get(band_name))
