# Dawn Well shop acceptance capture (T-M1f, MC 11210; roadmap feature 2
# ACCEPT "shop UI leg under Xvfb, shot path assets/screens/m1-dawnwell.png,
# shop-panel crop non-bg pixels >= 200 vs a hidden-UI empty baseline"). The
# TICK-DETERMINISTIC capture mechanism is REUSED, not re-authored (the
# chest_capture.gd / MC 11191 stage machine): real X11 window under xvfb,
# frame_post_draw staging, fixed settle frames. The scene NEVER ticks — the
# shop is menu-phase UI, so the sim clock stays untouched (declared: no
# _step calls at all, every pixel after activation is deterministic).
# Shots (one live Main.tscn with the REAL screens layer — the shop IS the
# acceptance object, no stub):
#   m1-dawnwell.png           shop OPEN over the night scene, seeded with
#                             ranks bought through main's REAL _shop_buy
#                             verbs on a funded well (declared deviation:
#                             the bankroll is granted directly — standing in
#                             for the run cash-outs that fund a real player,
#                             itself proven by the probe's convert leg).
#   m1-dawnwell-baseline.png  the hidden-UI empty baseline: same window,
#                             screens.hide_all() (the S8 pattern — the menu
#                             was already hidden while the shop was open, so
#                             every non-equal pixel IS the shop's draw).
# Opening rides main._open_shop() — the SAME verb the menu button's signal
# calls (the click itself is mouse input this stage cannot press; declared).
# M3 A-E6 (MC 11282 T-M3s): one extra window on the SAME machine —
#   m3-stage-select.png       the stage select opened through main's REAL
#                             _open_stages verb on the (never-unlocked)
#                             well, so the shot carries the three rows AND
#                             the two sealed lock lines + disabled Selects
#                             (roadmap :279 wants the lock row ON screen).
#                             The gate reuses the SAME hidden-UI baseline
#                             (the T-M2t per-window precedent, not a new
#                             capture mechanism).
# M5 P-E5 (MC 11421 T-M5p): a third window on the SAME machine —
#   m5-achievements.png       the achievements page opened through main's
#                             REAL _open_achievements verb; counters seeded
#                             directly (the BANKROLL declared-seeding law),
#                             so the shot carries 20 rows with progress
#                             text + achieved rows in EMBER. Same hidden-UI
#                             baseline (T-M2t law).
# M5 B-E6 (MC 11422 T-M5c): a fourth window on the SAME machine —
#   m5-char-select.png        the roster select opened through main's REAL
#                             _open_characters verb on a funded well: row 1
#                             BOUGHT+selected (EMBER title), row 2 owned
#                             (Select), rows 4-8 LOCKED carrying their
#                             achievement names (the roadmap wants the lock
#                             line ON screen). Roster.buy is the rule call
#                             the real verb makes (the PowerUps.buy declared
#                             seeding above, capture tooling only). Same
#                             hidden-UI baseline (T-M2t law).
extends SceneTree

const OUT_ENV := "HD3D_SHOP_SHOTS_DIR"
const SETTLE_FRAMES := 3
const BANKROLL := 3000 # declared seeding: cash-outs from runs never replayed
const VIEW_HALF := Vector2(640, 360) # the ortho viewport center (1280x720)
const PANEL_HALF := Vector2(380, 220) # screens._center_box shop offsets verbatim

var _main: Node
var _stage := 0
var _wait := 0
var _rows: Array = []
var _offer: Array = [] # T-M6p: the seeded level-up offer (rows read it)


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/shop-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	seed(11210) # the card id, the sim convention (determinism declared)
	assert(DirAccess.make_dir_recursive_absolute(_out_dir()) == OK)
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _on_frame() -> void:
	if _wait > 0:
		_wait -= 1
		_advance(_stage)
		return
	if _stage == 0:
		# main's _ready has run (one frame post-activation, the chest lesson):
		# fund the well, buy through the REAL verbs (each mutates + persists),
		# then open the shop through the SAME verb the menu button emits.
		_main._dawnwell.gold = BANKROLL
		for id: String in ["vitality", "vitality", "bulwark", "sage-thirst",
				"grave-greed"]:
			assert(PowerUps.buy(_main._dawnwell, id))
		_main._dawnwell.save()
		_main._open_shop()
		_wait = SETTLE_FRAMES
		_advance(1)
		return
	if _stage == 1:
		assert(_main._screens.shop_visible())
		_save_png("m1-dawnwell.png", true)
		_main._screens.hide_all() # the hidden-UI baseline (S8 pattern)
		_wait = SETTLE_FRAMES
		_advance(2)
		return
	if _stage == 2:
		assert(not _main._screens.shop_visible())
		_save_png("m1-dawnwell-baseline.png", false)
		# A-E6: open the stage select through the REAL verb (the menu seam
		# the button's signal calls), on the well NO run ever unlocked — the
		# shot must carry both lock lines.
		_main._open_stages()
		_wait = SETTLE_FRAMES
		_advance(3)
		return
	if _stage == 3:
		assert(_main._screens.stages_visible())
		_save_png("m3-stage-select.png", true)
		# Overlays are opened from the MENU only (the shipped idiom: a panel
		# is closed before the next one opens) — close the select the same
		# way stage 1 closed the shop, so the achievements shot carries ONLY
		# its own draw over the hidden-UI baseline.
		_main._screens.hide_all()
		_wait = SETTLE_FRAMES
		_advance(4)
		return
	if _stage == 4:
		assert(not _main._screens.stages_visible())
		# M5 P-E5 (MC 11421 T-M5p): one more window on the SAME machine —
		# the achievements page opened through main's REAL _open_achievements
		# verb. DECLARED seeding (the BANKROLL precedent above, capture
		# tooling only): counter values stand in for the run cash-outs a
		# real player would accumulate; the page itself is display-only,
		# nothing here mutates through a game path.
		_main._dawnwell.counters = {"kills_total": 12345, "gold_earned": 800,
			"runs_total": 12, "wins_total": 1, "minutes_total": 40,
			"max_level": 20, "evolutions_seen": 0, "unions_seen": 0}
		_main._open_achievements()
		_wait = SETTLE_FRAMES
		_advance(5)
		return
	if _stage == 5:
		assert(_main._screens.achievements_visible())
		_save_png("m5-achievements.png", true)
		# T-M5c B-E6: close the page the shipped way (a panel closes before
		# the next opens), then the roster shot on the funded well.
		_main._screens.hide_all()
		_wait = SETTLE_FRAMES
		_advance(6)
		return
	if _stage == 6:
		assert(not _main._screens.achievements_visible())
		# DECLARED seeding (BANKROLL law, capture tooling only): row 1 is
		# bought + chosen, row 2 bought, gates UNSET so rows 4-8 render
		# their lock lines. Roster.buy is the pure rule the real _char_buy
		# verb calls; the well state is the shot's subject, not a game path.
		assert(Roster.buy(_main._dawnwell, 1))
		assert(Roster.buy(_main._dawnwell, 2))
		_main._dawnwell.char = 1
		_main._open_characters()
		_wait = SETTLE_FRAMES
		_advance(7)
		return
	if _stage == 7:
		assert(_main._screens.chars_visible())
		_save_png("m5-char-select.png", true)
		_main._screens.hide_all()
		_wait = SETTLE_FRAMES
		_advance(8)
		return
	if _stage == 8:
		# T-M6p E-5 (M6-SPEC §3.3/§6.3): the level-up panel with the F3
		# chip rows painted. DECLARED seeding (the BANKROLL law, capture
		# tooling only): the three cards are the LIVE PASSIVES rows (names
		# + descs verbatim) in the exact card shape build_pool stamps —
		# loadstone + rotten-plate carry their partner chips, the generic
		# ferocity carries none (the chips==partner-set law, PS-E5). The
		# render path is the REAL one: game.set_phase + screens.show_levelup
		# are exactly what _enter_levelup calls.
		var offer: Array = [
			{"kind": "passive", "key": "loadstone", "name": "Loadstone",
				"desc": "+15 px pull radius per stack", "icon": "",
				"chips": ["icon-rot-water", "icon-censer-of-hours"]},
			{"kind": "passive", "key": "rotten-plate", "name": "Rotten Plate",
				"desc": "-1 damage taken (plate)", "icon": "",
				"chips": ["icon-spectral-disc"]},
			{"kind": "passive", "key": "ferocity", "name": "Ferocity",
				"desc": "+10% weapon damage", "icon": "", "chips": []},
		]
		_offer = offer
		_main.game.set_phase("levelup")
		_main._screens.show_levelup(offer)
		_wait = SETTLE_FRAMES
		_advance(9)
		return
	if _stage == 9:
		_save_png("m6-levelup-chips.png", true)
		_write_rows()
		print("CAPTURE_OK")
		quit()
		return
	print("CAPTURE_FAIL stage machine fell through stage %d" % _stage)
	quit(3)


func _advance(next_stage: int) -> void:
	_stage = next_stage
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _save_png(png: String, with_state: bool) -> void:
	if png == "m3-stage-select.png":
		_rows.append({"leg": "stage_select_shot",
			"cx": int(VIEW_HALF.x), "cy": int(VIEW_HALF.y),
			"hw": int(PANEL_HALF.x), "hh": int(PANEL_HALF.y),
			"rows": GameRenderer.STAGES.size(),
			"sealed": GameRenderer.STAGES.size() - 1 - int(
				_main._dawnwell.flags.get("stage2", 0)) - int(
				_main._dawnwell.flags.get("stage3", 0)),
			"chosen": int(_main._dawnwell.stage)})
		var img2: Image = root.get_texture().get_image()
		assert(img2.save_png(_out_dir() + "/" + png) == OK)
		print("SAVED %s %dx%d" % [_out_dir() + "/" + png,
			img2.get_width(), img2.get_height()])
		return
	if png == "m5-achievements.png":
		# M5 P-E5 state rows (the stage-select leg's shape): the table size
		# + the achieved count the shot must paint in EMBER.
		var achieved := 0
		for arow in Achievements.TABLE:
			if Achievements.progress(_main._dawnwell, arow) >= int(arow.target):
				achieved += 1
		_rows.append({"leg": "achievements_shot",
			"cx": int(VIEW_HALF.x), "cy": int(VIEW_HALF.y),
			"hw": int(PANEL_HALF.x), "hh": int(PANEL_HALF.y),
			"rows": Achievements.TABLE.size(), "achieved": achieved})
		var img3: Image = root.get_texture().get_image()
		assert(img3.save_png(_out_dir() + "/" + png) == OK)
		print("SAVED %s %dx%d" % [_out_dir() + "/" + png,
			img3.get_width(), img3.get_height()])
		return
	if png == "m5-char-select.png":
		# M5 B-E6 state rows (the stage-select leg's shape): the roster
		# table size + the LOCKED count the shot must paint with gate
		# names + the owned/selected rows the funded well carries.
		var owned := 0
		var locked := 0
		for i in Roster.CHARACTERS.size():
			if Roster.is_owned(_main._dawnwell, i):
				owned += 1
			elif Roster.is_locked(_main._dawnwell, i):
				locked += 1
		_rows.append({"leg": "char_select_shot",
			"cx": int(VIEW_HALF.x), "cy": int(VIEW_HALF.y),
			"hw": int(PANEL_HALF.x), "hh": int(PANEL_HALF.y),
			"rows": Roster.CHARACTERS.size(), "locked": locked,
			"owned": owned, "selected": int(_main._dawnwell.char)})
		var img4: Image = root.get_texture().get_image()
		assert(img4.save_png(_out_dir() + "/" + png) == OK)
		print("SAVED %s %dx%d" % [_out_dir() + "/" + png,
			img4.get_width(), img4.get_height()])
		return
	if png == "m6-levelup-chips.png":
		# T-M6p E-5 state rows (the stage-select leg's shape): the three
		# offered cards + the chip total the shot must paint (2 partner
		# chips on loadstone + 1 on rotten-plate; the generic none — the
		# chips==partner-set law, PS-E5's pixel half).
		_rows.append({"leg": "levelup_chips_shot",
			"cx": int(VIEW_HALF.x), "cy": int(VIEW_HALF.y),
			"hw": int(PANEL_HALF.x), "hh": int(PANEL_HALF.y),
			"cards": _offer.size(), "chips": _chip_total()})
		var img5: Image = root.get_texture().get_image()
		assert(img5.save_png(_out_dir() + "/" + png) == OK)
		print("SAVED %s %dx%d" % [_out_dir() + "/" + png,
			img5.get_width(), img5.get_height()])
		return
	if with_state:
		print("STATE gold=%d ranks=%d" % [_main._dawnwell.gold,
			_main._dawnwell.ranks.size()])
		_rows.append({"leg": "shop_shot",
			"cx": int(VIEW_HALF.x), "cy": int(VIEW_HALF.y),
			"hw": int(PANEL_HALF.x), "hh": int(PANEL_HALF.y),
			"gold": _main._dawnwell.gold,
			"ranks": _main._dawnwell.ranks.size()})
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + png
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])


func _write_rows() -> void:
	var f := FileAccess.open(_out_dir() + "/rows.json", FileAccess.WRITE)
	assert(f != null)
	f.store_string(JSON.stringify(_rows))
	f.close()


func _chip_total() -> int:
	# MEASURED, not hardcoded: the rows read the offer the capture actually
	# stamped — a planted strip of one card's chips reddens this row
	# (PS-E5's law: chips == the partner set, never a hardcoded green).
	var n := 0
	for c in _offer:
		n += (c.chips as Array).size()
	return n
