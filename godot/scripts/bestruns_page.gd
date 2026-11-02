# Best-runs page (T-M7C, MC 11628): the NINTH overlay's BUILDER — the
# RosterSelect/AchievementsPage/SettingsPage pattern verbatim (MC 11573
# split law): built at screens.gd's _ready on the ONE _overlay idiom,
# calling screens.gd's ONE panel-style idiom (_center_box/_label/_button)
# through the passed-in instance; zero new UI mechanism. Mouse-only by
# design (the owner plays desktop): the page is pure display + one Back
# button; no keyboard focus navigation is shipped or claimed.
# DISPLAY-ONLY contract (the achievements law, §1.1 shape): the rows were
# recorded at the run end by main._end_run and persisted by the ONE
# funnel — NO mutation lives here, no verb but the Back. Rows rebuild per
# open from the ONE Roster.CHARACTERS table + BestRuns.rows (shop law);
# a hero with no runs yet shows an honest "no runs yet" line (disable-
# not-hide kin: the empty state is SEEN, never hidden). The rank-1 row
# titles in EMBER (the stage-select chosen / achievements-achieved law).
# The mm:ss read is this page's OWN one-liner over the row's int seconds
# (main._fmt_time is main-private and the builders never reached into
# main — the achievements page's own-format precedent restated).
extends RefCounted


static func build(s) -> void:
	var box: VBoxContainer = s._center_box(s._bestruns)
	# the achievements/shop precedent: a nine-hero table needs more than
	# the menu's 560 column — the same 760 with its own scroll window.
	box.offset_left = -380
	box.offset_right = 380
	box.custom_minimum_size = Vector2(760, 0)
	box.add_child(s._label("Best Runs", 24, s.BONE))
	box.add_child(s._label("Your five best nights per hero — score first, " +
		"longest survival on a tie.", 12, s.MOON))
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(760, 360)
	box.add_child(scroll)
	s._bestruns_rows = VBoxContainer.new()
	s._bestruns_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s._bestruns_rows.custom_minimum_size = Vector2(740, 0)
	s._bestruns_rows.add_theme_constant_override("separation", 6)
	scroll.add_child(s._bestruns_rows)
	var back := Button.new()
	back.text = "Back to the menu"
	back.pressed.connect(func(): s.bestruns_closed.emit())
	box.add_child(back)


static func refresh(s) -> void:
	# Rebuilds the whole board per open (shop/achievements law): one hero
	# section per Roster row — the hero name as the section header (BONE),
	# then its BestRuns rows in rank order "#n  mm:ss — N kills — score S"
	# (rank 1 in EMBER, the rest BONE), or the honest empty line (MOON).
	for child in s._bestruns_rows.get_children():
		child.queue_free()
	for i in Roster.CHARACTERS.size():
		var hero: Dictionary = Roster.CHARACTERS[i]
		var head: Label = s._label(String(hero.name), 15, s.BONE)
		head.autowrap_mode = TextServer.AUTOWRAP_OFF
		s._bestruns_rows.add_child(head)
		var runs: Array = BestRuns.rows(s._well, i)
		if runs.is_empty():
			var none: Label = s._label("no runs yet", 12, s.MOON)
			none.autowrap_mode = TextServer.AUTOWRAP_OFF
			s._bestruns_rows.add_child(none)
		for r in runs.size():
			var row: Dictionary = runs[r]
			var line: Label = s._label("%d.  %s — %d kills — score %d" % [
				r + 1, _fmt_time(int(row.survived)), int(row.kills),
				int(row.score)], 13, s.EMBER_TINT if r == 0 else s.BONE)
			line.autowrap_mode = TextServer.AUTOWRAP_OFF
			s._bestruns_rows.add_child(line)


static func _fmt_time(secs: int) -> String:
	return "%02d:%02d" % [int(secs / 60), secs % 60]
