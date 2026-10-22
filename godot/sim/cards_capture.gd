# Rendered-proof capture for §j / A7 (MC 11103): run with
#   xvfb-run godot --render-driver opengl3 --path . -s res://sim/cards_capture.gd
# (-s keeps a REAL X11 window on Xvfb — a windowed run proves pixels exist,
# which --headless cannot). Instantiates the real Main.tscn, starts a run
# through the real _start_game funnel, reaches the level-up overlay via the
# real _enter_levelup path, and screenshots the root viewport texture for
# the three card FAMILIES: fresh weapons, capped-weapon passives, and the
# emptied-pool coin bonus. Frame stepping is signal-based (frame_post_draw)
# so the card Control trees get a layout pass before each save_png.
extends SceneTree

const OUT_ENV := "HD3D_CAPTURE_DIR"
const SHOTS := ["cards-weapons.png", "cards-passives.png", "cards-bonus.png"]

var _main: Node
var _stage := 0


func _out_dir() -> String:
	# The runner points HD3D_CAPTURE_DIR at .tmp/s5-cards/ in the checkout;
	# the res:// fallback keeps the rig runnable from the project dir alone.
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/s5-cards")


func _initialize() -> void:
	print("CAPTURE_START")
	assert(DirAccess.make_dir_recursive_absolute(_out_dir()) == OK)
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _on_frame() -> void:
	match _stage:
		0:  # Main ready → real run-start funnel (grants talon@1, game_state.gd:56)
			_main._start_game()
			_advance(1)
		1:  # WEAPON family: passives at the cap → pool = weapon/upgrade
			# cards only (all six v1 weapon icons; talon@1 may offer its upgrade).
			for passive in LevelUpDeck.PASSIVES:
				_main.game.passives[passive.key] = LevelUpDeck.MAX_PASSIVE_STACKS
			_main._enter_levelup()
			_advance(2)
		2:  # apply the pick (real path), then own every weapon at MAX_LEVEL
			# and clear the passive stacks → pool = exactly the 5 passive cards.
			_save(0)
			_main._pick(0)
			var owned := {}
			for w in _main.game.weapons:
				owned[w.id] = w
			for id in WeaponSystem.IDS:
				if owned.has(id):
					owned[id].level = WeaponSystem.MAX_LEVEL
				else:
					_main.game.weapons.append(
						{"id": id, "level": WeaponSystem.MAX_LEVEL, "cd": 0.0})
			for passive in LevelUpDeck.PASSIVES:
				_main.game.passives[passive.key] = 0
			_main._enter_levelup()
			_advance(3)
		3:  # apply the pick, then cap the passives too → empty pool = bonus
			_save(1)
			_main._pick(0)
			for passive in LevelUpDeck.PASSIVES:
				_main.game.passives[passive.key] = LevelUpDeck.MAX_PASSIVE_STACKS
			_main._enter_levelup()
			_advance(4)
		4:  # capture the coin bonus and leave
			_save(2)
			print("CAPTURE_OK")
			quit()


func _advance(next_stage: int) -> void:
	_stage = next_stage
	# Two post-draws before each save: cards are added mid-frame and need a
	# layout + paint pass; the single post-draw between stages keeps frames
	# coming (one-shot reconnection per stage).
	RenderingServer.frame_post_draw.connect(func():
		RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT),
		CONNECT_ONE_SHOT)


func _save(index: int) -> void:
	var offer: Array = _main._current_offer
	var kinds: Array = []
	for c in offer:
		kinds.append(String(c.kind) + ":" + String(c.get("id", c.get("key", "coin"))))
	print("OFFER %d %s" % [index, ",".join(kinds)])
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + String(SHOTS[index])
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])
