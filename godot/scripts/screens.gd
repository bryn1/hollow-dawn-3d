# Screens layer: menu, level-up cards, the end screen and the Dawn Well
# meta shop (T-M1f — the shop is a FOURTH overlay in this ONE panel style:
# same _overlay/_center_box/_label/_button idiom, zero new UI mechanism).
# Mouse works for real users; keyboard picking is routed by main from the
# bridge press queue (Contract B), never from here.
# §j (MC 11103): every card kind resolves to an icon file. v1's blank-icon
# path (passives shipped icon: "", levelup.gd:35) is closed structurally:
# _card() has NO conditional around the icon TextureRect, icon_path() is
# total over the 32 pool kinds (T-M1h M1 count: 16 weapon + 16 upgrade via
# the same 16 icons, 15 passives via PASSIVE_ICONS, bonus via coin), and
# every branch asserts the file exists before load. An unmapped passive key
# cannot reach a card (PASSIVES in levelup.gd is pinned == PASSIVE_ICONS by
# tests/test_card_icons.py).
extends CanvasLayer

signal start_pressed
signal card_picked(index: int)
signal shop_requested
signal shop_buy(id: String)
signal shop_refund(id: String)
signal shop_refund_all

const BONE := Color8(0xd8, 0xd2, 0xc0)
const MOON := Color8(0xae, 0xbd, 0xd4)
const EMBER_TINT := Color8(0xc9, 0x7b, 0x3d)

# §j: the 3090-generated passive icons (assets/icons/new/, prompt
# provenance embedded; the ten weapon-partner rows landed with T-M1h). Kept
# in a passives/ subdir: icon-ward.png exists twice by design (weapon sigil
# vs. shield) and the flat names must stay byte-identical to the art sources.
const PASSIVE_ICONS := {
	"ferocity": "res://assets/icons/passives/icon-ferocity.png",
	"haste": "res://assets/icons/passives/icon-haste.png",
	"ward": "res://assets/icons/passives/icon-ward.png",
	"grip": "res://assets/icons/passives/icon-grip.png",
	"insight": "res://assets/icons/passives/icon-insight.png",
	"cracked-heart": "res://assets/icons/passives/icon-cracked-heart.png",
	"iron-wrap": "res://assets/icons/passives/icon-iron-wrap.png",
	"tall-candles": "res://assets/icons/passives/icon-tall-candles.png",
	"four-leaf-charm": "res://assets/icons/passives/icon-four-leaf-charm.png",
	"knotted-chain": "res://assets/icons/passives/icon-knotted-chain.png",
	"loadstone": "res://assets/icons/passives/icon-loadstone.png",
	"rotten-plate": "res://assets/icons/passives/icon-rotten-plate.png",
	"twin-runes": "res://assets/icons/passives/icon-twin-runes.png",
	"gall-vial": "res://assets/icons/passives/icon-gall-vial.png",
	"gilded-skull": "res://assets/icons/passives/icon-gilded-skull.png",
}

# Icon fallback per §j — never blank: coin.png is a generated, non-empty
# asset and is always reached instead of skipping the TextureRect.
const FALLBACK_ICON := "res://assets/icons/coin.png"


# Total resolver over the 32 pool kinds: weapons/upgrade carry the weapon
# icon name in card.icon; the bonus carries "coin"; passives map by
# key. The asserts are the in-code half of the no-blank guarantee (tests
# assert the other half: the map is pinned and every file exists).
static func icon_path(card: Dictionary) -> String:
	match card.kind:
		"passive":
			assert(PASSIVE_ICONS.has(card.key))
			return PASSIVE_ICONS.get(card.key, FALLBACK_ICON)
		_:
			var path: String = "res://assets/icons/%s.png" % card.icon
			assert(ResourceLoader.exists(path))
			return path if ResourceLoader.exists(path) else FALLBACK_ICON

var _menu: Control
var _levelup: Control
var _end: Control
var _end_title: Label
var _end_stats: Label
var _cards_host: HBoxContainer
# Dawn Well shop (T-M1f): DISPLAY of the passed-in DawnWell only — every
# mutation is main.gd's verb, every rebuild is refresh_shop().
var _shop: Control
var _well: DawnWell
var _shop_gold: Label
var _shop_rows: VBoxContainer


func _ready() -> void:
	layer = 10
	_menu = _overlay()
	_build_menu()
	_levelup = _overlay()
	_build_levelup()
	_end = _overlay()
	_build_end()
	_shop = _overlay() # on top of _end (added last): the shop dims all
	_build_shop()
	show_menu()


func show_menu() -> void:
	_end.visible = false
	_levelup.visible = false
	_shop.visible = false
	_menu.visible = true


func hide_all() -> void:
	_menu.visible = false
	_levelup.visible = false
	_end.visible = false
	_shop.visible = false


func show_levelup(offer: Array) -> void:
	_end.visible = false
	_menu.visible = false
	_levelup.visible = true
	for child in _cards_host.get_children():
		child.queue_free()
	for i in offer.size():
		_cards_host.add_child(_card(offer[i], i))


func show_end(win: bool, lines: Array) -> void:
	_menu.visible = false
	_levelup.visible = false
	_end.visible = true
	_end_title.text = "You survived until dawn" if win else "The night took you"
	_end_stats.text = "\n".join(lines)


func _overlay() -> Control:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.visible = false
	add_child(root)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.55)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(dim)
	return root


func _center_box(root: Control) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_child(box)
	box.custom_minimum_size = Vector2(560, 0)
	box.offset_left = -280
	box.offset_right = 280
	box.offset_top = -220
	box.offset_bottom = 220
	box.add_theme_constant_override("separation", 14)
	return box


func _build_menu() -> void:
	var box := _center_box(_menu)
	box.add_child(_label("Hollow Dawn", 42, BONE))
	box.add_child(_label("Survive until dawn. Your weapons fire on their own.",
		15, MOON))
	box.add_child(_label("WASD / Arrows — move\nEsc — pause\nM — mute (no audio in this build)\n1 / 2 / 3 — choose a card",
		13, MOON))
	box.add_child(_button("Enter the night", _on_start))
	box.add_child(_button("The Dawn Well", _on_shop))


func _build_levelup() -> void:
	var box := _center_box(_levelup)
	# §j: three 220-px cards + 2×18 separation = 696 need a wider column
	# than the menu's 560 — the cards would sit visibly off-centre.
	box.offset_left = -360
	box.offset_right = 360
	box.custom_minimum_size = Vector2(720, 0)
	box.add_child(_label("Choose an upgrade", 24, BONE))
	_cards_host = HBoxContainer.new()
	_cards_host.add_theme_constant_override("separation", 18)
	box.add_child(_cards_host)


func _build_end() -> void:
	var box := _center_box(_end)
	_end_title = _label("", 28, BONE)
	box.add_child(_end_title)
	_end_stats = _label("", 15, MOON)
	box.add_child(_end_stats)
	if OS.has_feature("web"): # desktop has no DOM score panel to point at
		box.add_child(_label("Sign the ledger in the score panel (top right).",
			12, MOON))
	box.add_child(_button("Play again", _on_start))


func _card(card: Dictionary, index: int) -> Control:
	var holder := Control.new()
	holder.custom_minimum_size = Vector2(220, 275)
	var frame := TextureRect.new()
	frame.texture = load("res://assets/card-frame.png")
	frame.custom_minimum_size = Vector2(220, 275)
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	holder.add_child(frame)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 18
	box.offset_right = -18
	box.offset_top = 24
	box.offset_bottom = -24
	holder.add_child(box)
	# §j: unconditional icon — this is where v1 could draw a blank card
	# (v1 guarded the TextureRect on a non-empty icon string); no branch
	# may guard this TextureRect again.
	var icon := TextureRect.new()
	var path: String = icon_path(card)
	assert(ResourceLoader.exists(path))
	icon.texture = load(path)
	icon.custom_minimum_size = Vector2(80, 80) # brief: 64-96 px inside the frame
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	box.add_child(icon)
	box.add_child(_label(card.name, 16, BONE))
	box.add_child(_label(card.desc, 12, MOON))
	if card.kind == "upgrade":
		box.add_child(_label("Lv %d" % card.to_level, 12, EMBER_TINT))
	box.add_child(_label(str(index + 1), 14, EMBER_TINT))
	var click := Button.new()
	click.flat = true
	click.set_anchors_preset(Control.PRESET_FULL_RECT)
	click.pressed.connect(func(): card_picked.emit(index))
	holder.add_child(click)
	return holder


func _on_start() -> void:
	start_pressed.emit()


func _on_shop() -> void:
	shop_requested.emit()


# --- Dawn Well shop (T-M1f): the fourth overlay in the ONE panel style ----

# main owns the DawnWell object; the panel only shows it and emits the verb
# signals (buy / refund / refund-all) — main mutates + persists (T-M1a funnel)
# and calls refresh_shop() after every mutation.
func show_shop(well: DawnWell) -> void:
	_well = well
	_menu.visible = false
	_shop.visible = true
	refresh_shop()


func shop_visible() -> bool:
	return _shop.visible


func close_shop() -> void:
	_shop.visible = false
	show_menu()


func refresh_shop() -> void:
	# Rebuilds the 24 rows from the ONE table (powerups.gd): name + rank,
	# OUR per-rank effect line, cost curve row. disable-when-maxed (S7 ~610):
	# a maxed row's Buy is DISABLED, never hidden; refund sits on the rank-0
	# floor with its Refund disabled there.
	for child in _shop_rows.get_children():
		child.queue_free()
	_shop_gold.text = "Gold in the well: %d" % _well.gold
	for row in PowerUps.TABLE:
		var id: String = row.id
		var rank := int(_well.ranks.get(id, 0))
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 10)
		var title := _label("%s  %d/%d" % [row.name, rank, PowerUps.MAX_RANK],
			13, BONE)
		# Row text opts OUT of the shared _label autowrap (menu cards wrap;
		# a table row that wraps one letter per line is unreadable) and
		# carries its column width, so the HBox lays out L->R.
		title.autowrap_mode = TextServer.AUTOWRAP_OFF
		title.custom_minimum_size = Vector2(170, 0)
		line.add_child(title)
		var effect := _label(row.desc, 12, MOON)
		effect.autowrap_mode = TextServer.AUTOWRAP_OFF
		effect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		line.add_child(effect)
		var price := PowerUps.cost(id, rank)
		var buy := Button.new()
		buy.text = "MAX" if rank >= PowerUps.MAX_RANK else "Buy %dg" % price
		buy.disabled = rank >= PowerUps.MAX_RANK or _well.gold < price
		buy.pressed.connect(func(): shop_buy.emit(id))
		line.add_child(buy)
		var back := Button.new()
		back.text = "Refund %dg" % PowerUps.refund_for(id, rank)
		back.disabled = rank <= 0
		back.pressed.connect(func(): shop_refund.emit(id))
		line.add_child(back)
		_shop_rows.add_child(line)


func _build_shop() -> void:
	var box := _center_box(_shop)
	# §j precedent (_build_levelup's wider column): a 24-row table with a
	# name column, an effect line and TWO buttons needs more than the
	# menu's 560 — the Refund buttons clipped at the scroll edge.
	box.offset_left = -380
	box.offset_right = 380
	box.custom_minimum_size = Vector2(760, 0)
	box.add_child(_label("The Dawn Well", 24, BONE))
	_shop_gold = _label("Gold in the well: 0", 15, EMBER_TINT)
	box.add_child(_shop_gold)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(760, 320)
	box.add_child(scroll)
	_shop_rows = VBoxContainer.new()
	_shop_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# The ScrollContainer gives its child no natural width — the table must
	# carry one (740 inside the 760 column), else every column collapses.
	_shop_rows.custom_minimum_size = Vector2(740, 0)
	_shop_rows.add_theme_constant_override("separation", 6)
	scroll.add_child(_shop_rows)
	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 18)
	var refund_all := Button.new()
	refund_all.text = "Refund everything (-%d%%)" % PowerUps.REFUND_FEE_PCT
	refund_all.pressed.connect(func(): shop_refund_all.emit())
	buttons.add_child(refund_all)
	buttons.add_child(_button("Back to the menu", close_shop))
	box.add_child(buttons)


func _button(text: String, handler: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.pressed.connect(handler)
	return button


func _label(text: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label
