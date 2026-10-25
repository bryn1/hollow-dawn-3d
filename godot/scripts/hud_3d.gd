# HUD over the 3D world (§f hud_3d.gd): the biome-name banner ported from v1
# hud.gd — BIOME_FLASH and the band-change rule run through the ONE
# GameRenderer.biome_at mechanism (DESIGN-3D §d A6 row: banner text = BIOMES
# name, alpha-up 3.0 s). THE v1 HUD ROW (timer, HP bar + text, XP bar, level,
# gold, kills, weapon icon row, PAUSED) LANDED HERE AT T-S8 (MC 11148): the
# S3 header deferred these rows "with the upgrade-UI stage" and S5 shipped
# only the cards — the row was never in the tree, which is why MC 11139 saw
# no HUD on the web capture (root cause of the A1 pixel FAIL). It is now the
# v1 hud.gd:31-155 row VERBATIM on this same CanvasLayer (data layer already
# verbatim; the only deviation is the icon dir, res://assets/icons/, per the
# S5 icon-tree layout that screens.gd:25-29 established).
# S6 adds the boss bar (§d row "boss bar + name"): the v1 world-canvas draw
# (render.gd:194-207) ported to this CanvasLayer with its geometry, colours
# and fill rule kept — outside the 3D draw budget (§b), and the ONLY boss HP
# readout: the horde HP-bar MM excludes the boss exactly like v1 (render.gd:
# 185-186 `if e.boss ...: return`, mirrored in horde_viz.gd).
extends CanvasLayer

const INK := Color8(0x10, 0x13, 0x1c)
const BLOOD := Color8(0x8e, 0x2f, 0x35)
const ICHOR := Color8(0x6f, 0xae, 0x5a)
const BONE := Color8(0xd8, 0xd2, 0xc0)
const EMBER_TINT := Color8(0xc9, 0x7b, 0x3d)

const BIOME_FLASH := 3.0 # seconds the biome-name banner stays up, fading last 1s

# §d boss-bar port (render.gd:194-207): 420x10 frame at y 12 centred on VIEW,
# INK under EMBER fill w * clampf(hp / max_hp, 0, 1), name centred at the v1
# baseline y 36 in size 12 BONE. M3 §3.1 (MC 11284): the A5 const BOSS_NAME
# is RETIRED (replace-not-delete, LEDGER T-M3b) — the name is the live boss's
# ENEMY_TYPES row `name` readout, so every stage's end-boss names its own
# bar (the warden row carries the retired const's string verbatim, so the
# stage-1 bar paints byte-identically; C-E3).
const BOSS_BAR_W := 420.0
const BOSS_BAR_H := 10.0
const BOSS_BAR_Y := 12.0

var game: GameState
var world: GameWorld # boss scan source (main.gd wires it, mirrors _viz)

var _timer: Label # v1 hud.gd row, verbatim field set
var _hp_fill: ColorRect
var _hp_text: Label
var _xp_fill: ColorRect
var _level: Label
var _gold: Label
var _kills: Label
var _weapons: HBoxContainer
var _pause: Label
var _cycle: Label # M2 §A/§A.2 (T-M2e): the cycle row — endless ON only
var _biome: Label
var _biome_name := ""
var _biome_left := 0.0
var _row_sig := ""
var _boss_root: Control
var _boss_fill: ColorRect
var _boss_name: Label


func _ready() -> void:
	layer = 5
	var panel := PanelContainer.new() # v1 hud.gd:33-62 row, verbatim
	panel.position = Vector2(8, 8)
	add_child(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	panel.add_child(row)
	_timer = _label("00:00")
	row.add_child(_timer)
	row.add_child(_bar("hp", 160))
	row.add_child(_bar("xp", 160))
	_level = _label("Lv 1")
	row.add_child(_level)
	_gold = _label("Gold 0")
	row.add_child(_gold)
	_kills = _label("Kills 0")
	row.add_child(_kills)
	_weapons = HBoxContainer.new()
	_weapons.add_theme_constant_override("separation", 4)
	row.add_child(_weapons)
	_pause = _label("PAUSED")
	_pause.modulate = EMBER_TINT
	_pause.visible = false
	row.add_child(_pause)
	# M2 §A.2 (rev-2 P3-3, T-M2e): the cycle text lands in hud_3d.gd on the
	# v1 row (existing _label style, BONE 13), appended AFTER the verbatim
	# v1 row — invisible for every non-endless run, so the M1 HUD stays as
	# shipped. The number shown is the sim's 0-based cycle index, the SAME
	# value the dump rows and dawnwell.best_cycle carry (one truth, stated).
	_cycle = _label("Cycle 0")
	_cycle.visible = false
	row.add_child(_cycle)
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
	_timer.text = _fmt_time(game.time) # v1 hud.gd:68-78, verbatim
	_hp_fill.size = Vector2(158.0 * clampf(game.hp / game.max_hp, 0.0, 1.0), 14)
	_hp_text.text = "%d/%d" % [int(maxf(0.0, ceil(game.hp))), int(game.max_hp)]
	var need := float(GameState.xp_need(game.level))
	_xp_fill.size = Vector2(158.0 * clampf(game.xp / need, 0.0, 1.0), 14)
	_level.text = "Lv %d" % game.level
	_gold.text = "Gold %d" % game.gold
	_kills.text = "Kills %d" % game.kills
	_pause.visible = game.paused and game.phase == "playing"
	# §A/§A.2 cycle row: endless-gated (flag-off HUD stays byte-identical).
	_cycle.visible = game.endless
	if game.endless:
		_cycle.text = "Cycle %d" % game.cycle
	_render_weapon_row()
	_update_biome_flash(delta)
	_update_boss_bar()


# Ported from v1 hud.gd: on every band change (game.time crossing a BIOMES
# t_start) the band name flashes full-alpha and fades out over BIOME_FLASH s.
func _update_biome_flash(delta: float) -> void:
	if game.phase != "playing":
		_biome_name = "" # re-arm: the next run flashes its first band
	else:
		# M3 §1.1/§1.2 (T-M3s): the stage-keyed, flare-aware banner read
		# (the ONE band mechanism; stage 1 + flare 0 == the shipped walk).
		var band: Dictionary = GameRenderer.band_at(game.stage, game.time + game.flare)
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
	# T-M2u (MC 11240, D-U7 pixel-leg finding): as a CanvasLayer sibling
	# added AFTER the HUD panel, the bar painted OVER the v1 weapon-icon
	# row whenever a boss lived — every weapon icon (union ids included)
	# blanked behind the EMBER fill. Draw order only: the bar now paints
	# FIRST (z -1); geometry/fill/name/visibility rules untouched, so the
	# row reads on top exactly where the HUD panel occupies the bar band,
	# while the bar's centred 420 px body stays fully visible (the panel
	# ends left of the bar's centre).
	_boss_root.z_index = -1
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
	_boss_name = Label.new() # live text per boss tick (_update_boss_bar)
	_boss_name.add_theme_font_size_override("font_size", 12)
	_boss_name.add_theme_color_override("font_color", BONE)
	_boss_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_boss_name.position = Vector2(0, 24) # v1 baseline y 36 (draw_string)
	_boss_name.size = Vector2(GameRenderer.VIEW.x, 16)
	_boss_root.add_child(_boss_name)


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
	# C-E3: the row `name` is the bar's label — every stage's end-boss names
	# its own bar; no boss is no bar, exactly as shipped (one bar seam).
	_boss_name.text = String(GameWorld.ENEMY_TYPES[boss.type].get("name", ""))
	_boss_fill.size = Vector2(
		BOSS_BAR_W * clampf(boss.hp / boss.max_hp, 0.0, 1.0), BOSS_BAR_H)


# v1 hud.gd:98-118 weapon icon row, verbatim (icon dir deviation: the S5 tree
# carries the weapon icons in res://assets/icons/, screens.gd:25-29 layout).
func _render_weapon_row() -> void:
	var sig := ""
	for w in game.weapons:
		sig += w.id + str(w.level) + ","
	if sig == _row_sig:
		return
	_row_sig = sig
	for child in _weapons.get_children():
		child.queue_free()
	for w in game.weapons:
		var cell := VBoxContainer.new()
		var icon := TextureRect.new()
		# M1 f5 (MC 11209): evolved weapon ids ride the SEPARATE evolution
		# table (DA c3 C-2) and are deliberately NOT in WeaponSystem.META —
		# the icon falls back to the ONE naming convention (icon-<id>.png,
		# the §j tree the evo icons shipped into), so an evolved weapon
		# still reads on the HUD row.
		var icon_name: String = WeaponSystem.META[w.id].icon \
				if WeaponSystem.META.has(w.id) else "icon-" + w.id
		icon.texture = load("res://assets/icons/" + icon_name + ".png")
		icon.custom_minimum_size = Vector2(18, 18)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		cell.add_child(icon)
		var lv := _label(str(w.level))
		lv.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cell.add_child(lv)
		_weapons.add_child(cell)


# v1 hud.gd:121-143 bar factory, verbatim.
func _bar(kind: String, width: float) -> Control:
	var track := Control.new()
	track.custom_minimum_size = Vector2(width, 16)
	track.clip_contents = true
	var bg := ColorRect.new()
	bg.color = Color(INK, 0.9)
	bg.size = Vector2(width - 2.0, 14)
	bg.position = Vector2.ONE
	track.add_child(bg)
	var fill := ColorRect.new()
	fill.color = BLOOD if kind == "hp" else ICHOR
	fill.position = Vector2.ONE
	fill.size = Vector2(width - 2.0, 14)
	track.add_child(fill)
	if kind == "hp":
		_hp_fill = fill
		_hp_text = _label("100/100")
		_hp_text.add_theme_font_size_override("font_size", 10)
		_hp_text.position = Vector2(4, 1)
		track.add_child(_hp_text)
	else:
		_xp_fill = fill
	return track


# v1 hud.gd:146-151, verbatim.
func _label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", BONE)
	return label


func _fmt_time(t: float) -> String:
	var s := int(maxf(0.0, floor(t)))
	return "%02d:%02d" % [int(s / 60.0), s % 60]


# Runtime probe for the sim dump (A5 row: bar + name visible while the boss
# lives). Geometry read back from the live fill rect, not recomputed here;
# the name reads back the LIVE label (M3 C-E3 per-boss readout).
func boss_bar_state() -> Dictionary:
	return {"visible": _boss_root.visible, "name": _boss_name.text,
		"fill_w": roundf(_boss_fill.size.x * 1000.0) / 1000.0,
		"max_w": BOSS_BAR_W, "h": BOSS_BAR_H, "y": BOSS_BAR_Y}


# A-E7 probe (T-M2e): live cycle-row state + global rect, read back the same
# way boss_bar_state reads the bar — the s8 capture prints it and the pixel
# crop window (tools/s8_acceptance.py CYCLE-HUD row) is pinned to it.
func cycle_row_state() -> Dictionary:
	var r: Rect2 = _cycle.get_global_rect()
	return {"visible": _cycle.visible, "text": _cycle.text,
		"x": roundf(r.position.x), "y": roundf(r.position.y),
		"w": roundf(r.size.x), "h": roundf(r.size.y)}
