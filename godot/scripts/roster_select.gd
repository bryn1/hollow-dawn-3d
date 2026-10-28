# Roster select overlay (M5 §2.2, T-M5c): the SIXTH overlay's BUILDER —
# nine rows from the ONE Roster.CHARACTERS table + the well (shop/stage
# law); Roster.state is the single four-state source (locked/buy/owned/
# selected, B-E6). A locked row is DISABLED, never hidden, and NAMES its
# achievement (roadmap law; Roster.gate_name reads the ONE achievements
# table). The portrait TextureRect carries no conditional — §j assert-
# before-load. The panel emits verbs ONLY; main's wrappers mutate +
# persist via the ONE funnel (B-E5). Wider column + scroll: shop/
# achievements precedent. The skin chip row (M5 §3.1, T-M5k) rides the
# selected row's non-empty group — an inner row-set, not a third surface.
# MC 11573 T-CC3R (CLEAN-CODE-AUDIT-3 §1.1 P2 split): moved VERBATIM out
# of screens.gd — every builder call still routes through screens.gd's
# ONE panel-style idiom (_overlay/_center_box/_label/_button) on the
# passed-in instance: zero new UI mechanism, zero new colors, the panel
# is still opened on the ONE _overlay in screens.gd's _ready. screens.gd
# keeps the dispatcher (show/close/visible/refresh verbs main routes).
extends RefCounted


static func build(s) -> void:
	var box: VBoxContainer = s._center_box(s._chars) # shop precedent: portrait rows > the 560
	box.offset_left = -380
	box.offset_right = 380
	box.custom_minimum_size = Vector2(760, 0)
	box.add_child(s._label("Characters", 24, s.BONE))
	s._chars_gold = s._label("Gold in the well: 0", 15, s.EMBER_TINT)
	box.add_child(s._chars_gold)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(760, 360)
	box.add_child(scroll)
	s._chars_rows = VBoxContainer.new()
	s._chars_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s._chars_rows.custom_minimum_size = Vector2(740, 0)
	s._chars_rows.add_theme_constant_override("separation", 10)
	scroll.add_child(s._chars_rows)
	box.add_child(s._button("Back to the menu", s.close_characters))


static func refresh(s) -> void:
	for child in s._chars_rows.get_children():
		child.queue_free()
	s._chars_gold.text = "Gold in the well: %d" % s._well.gold
	for i in Roster.CHARACTERS.size():
		var row: Dictionary = Roster.CHARACTERS[i]
		var st := Roster.state(s._well, i)
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 10)
		var portrait := TextureRect.new() # §j: NO conditional, assert-first
		var path: String = Roster.portrait_path(i)
		assert(ResourceLoader.exists(path))
		portrait.texture = load(path)
		portrait.custom_minimum_size = Vector2(64, 64)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		line.add_child(portrait)
		var title: Label = s._label(String(row.name), 14,
			s.EMBER_TINT if st == "selected" else s.BONE)
		title.autowrap_mode = TextServer.AUTOWRAP_OFF
		title.custom_minimum_size = Vector2(180, 0)
		line.add_child(title)
		var desc: Label = s._label(String(row.desc), 12, s.MOON)
		desc.autowrap_mode = TextServer.AUTOWRAP_OFF
		desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		line.add_child(desc)
		var act := Button.new()
		var cid: String = String(row.id)
		match st:
			"locked":
				act.text = "Locked — %s" % Roster.gate_name(i)
				act.disabled = true
			"buy":
				act.text = "Buy %dg" % Roster.cost(i)
				act.disabled = s._well.gold < Roster.cost(i)
				act.pressed.connect(func(): s.char_bought.emit(cid))
			"owned":
				act.text = "Select"
				act.pressed.connect(func(): s.char_selected.emit(cid))
			_: # "selected": a no-op verb cannot fire (the stage law)
				act.text = "Selected"
				act.disabled = true
		line.add_child(act)
		s._chars_rows.add_child(line)
		if st == "selected":
			var grp: Array = Roster.skins_for(i)
			if grp.size() > 0:
				# The skin chip row (M5 §3.1): an inner row-set under the
				# selected row — rendered ONLY when that character's skin
				# group is NON-EMPTY (the group law is the chip-disabled
				# UI side: an empty-group char renders no chip row at
				# all, reading (4) of the card; F-8's "not a third
				# surface"). State comes from the ONE Roster.skin_state.
				s._chars_rows.add_child(skin_chips(s, i, grp))


static func skin_chips(s, char: int, grp: Array) -> HBoxContainer:
	# The chip row: the default look + one chip per group entry, the SAME
	# disabled-not-hidden law as the char rows (the shop's both sides:
	# the buy chip DISABLES unaffordable). §j total law: the chip icon
	# asserts before load, unconditional draw (no blank chip ever).
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	row.add_child(s._label("  Skins:", 12, s.MOON))
	for pos in range(0, grp.size() + 1):
		var chip := Button.new()
		var st := Roster.skin_state(s._well, char, pos)
		var sid: String = Roster.SKIN_DEFAULT_ID if pos == 0 \
			else Roster.skin_id(pos)
		chip.custom_minimum_size = Vector2(118, 36)
		if pos > 0:
			var path: String = Roster.skin_chip_path(pos)
			assert(ResourceLoader.exists(path))
			chip.icon = load(path)
			chip.expand_icon = true
			chip.icon_max_width = 22
		var nm := "No skin" if pos == 0 else String(Roster.skin_row(pos).name)
		match st:
			"buy":
				chip.text = "%s %dg" % [nm, Roster.skin_cost(pos)]
				chip.disabled = s._well.gold < Roster.skin_cost(pos)
				chip.pressed.connect(func(): s.skin_bought.emit(sid))
			"owned":
				chip.text = "Wear %s" % nm
				chip.pressed.connect(func(): s.skin_selected.emit(sid))
			_: # "selected" (also "unwearable" can never reach a chip —
				# the row only renders for group entries)
				chip.text = "%s — worn" % nm
				chip.disabled = true
				chip.add_theme_color_override("font_disabled_color",
					s.EMBER_TINT) # the EMBER title law, stage precedent
	return row
