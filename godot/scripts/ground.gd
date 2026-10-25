# Biome ground layer (DESIGN-3D §a): one 80 x 60 m quad re-centred on the
# player every frame + shaders/ground.gdshader world-locking the tiling
# (T-S10, MC 11159: TILE_M 11.0 m, 4x the v1 detail density — the v1
# 42.7 m tile made the ground the loudest layer; see the shader header).
# The band swaps through the ONE GameRenderer.biome_at mechanism; the albedo
# textures are the four v1 tiles carried byte-identical
# (godot/assets/biomes/), mip-mapped at load (the density needs it; the
# .import files are gitignored, so the mip pass is the committed mechanism).
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
	# T-S10 (MC 11159): at TILE_M 11.0 a 1024 px tile shrinks ~4x on screen,
	# so the load needs mipmaps + linear sampling or the detail shimmers as
	# the camera pans; .import metadata is gitignored (local truth), so the
	# mip pass runs ONCE here on copies of the loaded tiles.
	var mat := ShaderMaterial.new()
	mat.shader = load("res://shaders/ground.gdshader")
	material_override = mat
	for b in GameRenderer.BIOMES:
		var img: Image = load(b.tex).get_image()
		img.generate_mipmaps()
		_texs[b.name] = ImageTexture.create_from_image(img)
	# M3 §1.1 (T-M3s): the stage-keyed read — boot/menu runs the stage-1
	# default id, so this is the shipped MOORLAND byte-for-byte.
	_set_band(GameRenderer.band_at(game.stage, game.time + game.flare).name)


func _process(_delta: float) -> void:
	if game == null:
		return
	position = Vector3(game.player.x / CameraRig.PX_PER_M, 0.0,
		game.player.y / CameraRig.PX_PER_M)
	# M3 §1.1/§1.2: band_at(stage, t + flare) — stage 1 + no flare is the
	# shipped walk exactly; the flare term only moves the NAME (§1.2, visual).
	var band: Dictionary = GameRenderer.band_at(game.stage, game.time + game.flare)
	if band.name != _band_name:
		_set_band(band.name)


func _set_band(band_name: String) -> void:
	_band_name = band_name
	material_override.set_shader_parameter("albedo_tex", _texs.get(band_name))
