# HUD over the 3D world (§f hud_3d.gd): the biome-name banner ported from v1
# hud.gd — BIOME_FLASH and the band-change rule run through the ONE
# GameRenderer.biome_at mechanism (DESIGN-3D §d A6 row: banner text = BIOMES
# name, alpha-up 3.0 s). S3 scope is the text-only banner; the timer/HP/XP/
# weapon rows land on this same CanvasLayer with the upgrade-UI stage.
# S6 adds the boss bar (§d row "boss bar + name"): the v1 world-canvas draw
# (render.gd:194-207) ported to this CanvasLayer with its geometry, colours
# and fill rule kept — outside the 3D draw budget (§b), and the ONLY boss HP
# readout: the horde HP-bar MM excludes the boss exactly like v1 (render.gd:
# 185-186 `if e.boss ...: return`, mirrored in horde_viz.gd).
extends CanvasLayer

const BONE := Color8(0xd8, 0xd2, 0xc0)

const BIOME_FLASH := 3.0 # seconds the biome-name banner stays up, fading last 1s

# §d boss-bar port (render.gd:194-207): 420x10 frame at y 12 centred on VIEW,
# INK under EMBER fill w * clampf(hp / max_hp, 0, 1), name centred at the v1
# baseline y 36 in size 12 BONE. The name string is the pinned A5 literal.
const BOSS_BAR_W := 420.0
const BOSS_BAR_H := 10.0
const BOSS_BAR_Y := 12.0
const BOSS_NAME := "THE HOLLOW WARDEN"

var game: GameState
var world: GameWorld # boss scan source (main.gd wires it, mirrors _viz)

var _biome: Label
var _biome_name := ""
var _biome_left := 0.0
var _boss_root: Control
var _boss_fill: ColorRect


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
	_build_boss_bar()


func update(delta: float) -> void:
	if game == null:
		return
	_update_biome_flash(delta)
	_update_boss_bar()


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


# §d port of render.gd _draw_boss_bar: one frame rect (INK), one fill rect
# (EMBER) that grows from the LEFT edge exactly like v1's draw_rect, one
# centred name Label. Hidden until a boss exists (v1: boss.is_empty -> no
# draw at all).
func _build_boss_bar() -> void:
	var x := (GameRenderer.VIEW.x - BOSS_BAR_W) / 2.0
	_boss_root = Control.new()
	_boss_root.position = Vector2(0, 0)
	_boss_root.size = Vector2(GameRenderer.VIEW.x, BOSS_BAR_Y + BOSS_BAR_H + 26.0)
	_boss_root.visible = false
	add_child(_boss_root)
	var bg := ColorRect.new()
	bg.color = GameRenderer.INK
	bg.position = Vector2(x, BOSS_BAR_Y)
	bg.size = Vector2(BOSS_BAR_W, BOSS_BAR_H)
	_boss_root.add_child(bg)
	_boss_fill = ColorRect.new()
	_boss_fill.color = GameRenderer.EMBER
	_boss_fill.position = Vector2(x, BOSS_BAR_Y)
	_boss_fill.size = Vector2(BOSS_BAR_W, BOSS_BAR_H)
	_boss_root.add_child(_boss_fill)
	var name_label := Label.new()
	name_label.text = BOSS_NAME
	name_label.add_theme_font_size_override("font_size", 12)
	name_label.add_theme_color_override("font_color", BONE)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.position = Vector2(0, 24) # v1 baseline y 36 (draw_string)
	name_label.size = Vector2(GameRenderer.VIEW.x, 16)
	_boss_root.add_child(name_label)


# v1 boss scan, verbatim shape (render.gd:195-200): first boss in the live
# enemy list, none is no bar. Fill rides the same clampf rule every tick.
func _update_boss_bar() -> void:
	if world == null:
		return
	var boss: Dictionary = {}
	for e in world.enemies:
		if e.boss:
			boss = e
			break
	_boss_root.visible = not boss.is_empty()
	if boss.is_empty():
		return
	_boss_fill.size = Vector2(
		BOSS_BAR_W * clampf(boss.hp / boss.max_hp, 0.0, 1.0), BOSS_BAR_H)


# Runtime probe for the sim dump (A5 row: bar + name visible while the boss
# lives). Geometry read back from the live fill rect, not recomputed here.
func boss_bar_state() -> Dictionary:
	return {"visible": _boss_root.visible, "name": BOSS_NAME,
		"fill_w": roundf(_boss_fill.size.x * 1000.0) / 1000.0,
		"max_w": BOSS_BAR_W, "h": BOSS_BAR_H, "y": BOSS_BAR_Y}
