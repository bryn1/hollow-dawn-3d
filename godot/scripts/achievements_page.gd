# Achievements page (M5 §1.1, T-M5p): the SEVENTH overlay's BUILDER — the
# 20-row display that rebuilds per open from the ONE Achievements.TABLE +
# the passed-in well (name, progress `min(count, target)/target`; an
# achieved row titles in EMBER — the stage-select chosen law, §1.1). NO
# mutation lives here (display-only, spec §1.1): the counters and flags
# were persisted at the run end by the ONE funnel (main._end_run). The
# wider column + scroll ride the shop precedent (20 rows > the menu box).
# MC 11573 T-CC3R (CLEAN-CODE-AUDIT-3 §1.1 P2 split): moved VERBATIM out
# of screens.gd — the bodies keep calling screens.gd's ONE panel-style
# idiom (_overlay/_center_box/_label/_button) through the passed-in
# screens instance: zero new UI mechanism, the panel is still built at
# screens.gd's _ready on the ONE _overlay idiom. screens.gd keeps the
# dispatcher (show/close/visible/refresh verbs main routes).
extends RefCounted


static func build(s) -> void:
	var box: VBoxContainer = s._center_box(s._achv)
	# shop precedent (_build_shop): a 20-row table needs more than the
	# menu's 560 column — the same 760 with its own scroll window.
	box.offset_left = -380
	box.offset_right = 380
	box.custom_minimum_size = Vector2(760, 0)
	box.add_child(s._label("Achievements", 24, s.BONE))
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(760, 320)
	box.add_child(scroll)
	s._achv_rows = VBoxContainer.new()
	s._achv_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s._achv_rows.custom_minimum_size = Vector2(740, 0)
	s._achv_rows.add_theme_constant_override("separation", 6)
	scroll.add_child(s._achv_rows)
	var back := Button.new()
	back.text = "Back to the menu"
	back.pressed.connect(func(): s.achievements_closed.emit())
	box.add_child(back)


static func refresh(s) -> void:
	# Rebuilds the 20 rows from the ONE table (shop/stage law): name +
	# progress term; an achieved row in EMBER (the stage-select law — the
	# row IS the achievement, no separate verb, nothing disabled: there is
	# nothing to press).
	for child in s._achv_rows.get_children():
		child.queue_free()
	for row in Achievements.TABLE:
		var prog := Achievements.progress(s._well, row)
		var target := int(row.target)
		var line: Label = s._label("%s — %d/%d" % [row.name, prog, target], 13,
			s.EMBER_TINT if prog >= target else s.BONE)
		line.autowrap_mode = TextServer.AUTOWRAP_OFF
		s._achv_rows.add_child(line)
