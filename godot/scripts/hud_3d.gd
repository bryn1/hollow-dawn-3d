# HUD over the 3D world (§f hud_3d.gd): the biome-name banner ported from v1
# hud.gd — BIOME_FLASH and the band-change rule run through the ONE
# GameRenderer.biome_at mechanism (DESIGN-3D §d A6 row: banner text = BIOMES
# name, alpha-up 3.0 s). S3 scope is the text-only banner; the timer/HP/XP/
# weapon rows land on this same CanvasLayer with the upgrade-UI stage.
extends CanvasLayer

const BONE := Color8(0xd8, 0xd2, 0xc0)

const BIOME_FLASH := 3.0 # seconds the biome-name banner stays up, fading last 1s

var game: GameState

var _biome: Label
var _biome_name := ""
var _biome_left := 0.0


func _ready() -> void:
	layer = 5
	_biome = Label.new()
	_biome.add_theme_font_size_override("font_size", 26)
	_biome.add_theme_color_override("font_color", BONE)
	_biome.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_biome.position = Vector2(0, 140)
	_biome.size = Vector2(GameRenderer.VIEW.x, 40)
	_biome.modulate.a = 0.0
	add_child(_biome)


func update(delta: float) -> void:
	if game == null:
		return
	_update_biome_flash(delta)


# Ported from v1 hud.gd: on every band change (game.time crossing a BIOMES
# t_start) the band name flashes full-alpha and fades out over BIOME_FLASH s.
func _update_biome_flash(delta: float) -> void:
	if game.phase != "playing":
		_biome_name = "" # re-arm: the next run flashes its first band
	else:
		var band: Dictionary = GameRenderer.biome_at(game.time)
		if band.name != _biome_name:
			_biome_name = band.name
			_biome.text = _biome_name
			_biome_left = BIOME_FLASH
	if _biome_left > 0.0:
		_biome_left = maxf(0.0, _biome_left - delta)
		_biome.modulate.a = clampf(_biome_left, 0.0, 1.0)
