# T-M7C best-runs behavioral probe (MC 11628). Same LEG-row convention as
# settings_probe.gd / shop_probe.gd: headless SceneTree runs under a
# throwaway XDG_DATA_HOME (the pytest leg points user:// at /tmp), machine-
# readable `LEG <name> k=v` rows, one real process per mode
# (HD3D_BESTRUNS_MODE):
#   rank   — the RULE legs, no Main: truncation to TOP, the rank law
#            (score desc; survived desc on a score tie; insertion order on
#            a FULL tie — a new row never displaces its equal), per-hero
#            isolation, and the save-side SHAPE sanitize (a hand-rolled
#            blob never crashes; unknown heroes / malformed rows drop;
#            JSON-float rows int(); a past-TOP bucket reads the LAW; an
#            older save without the field defaults {} — the R1 lineage).
#   write  — the DoD's RECORD boot on the REAL Main.tscn + screens.gd +
#            main.gd: the REAL Best Runs click opens the NINTH overlay
#            (mouse route: pressed.emit through the shipped verb chain),
#            Back lands on the menu. Then runs are driven through the
#            SHIPPED game-over path: _start_game + the manual _step loop
#            (sim_headless's own drive idiom) until the shipped hp<=0 arm
#            ENDS the run itself — real survived/kills/score from real
#            stats. Heroes chosen through the well's char row (declared
#            state-seed: dawnwell_capture's BANKROLL precedent). The disk
#            is read back THROUGH THE SHIPPED LOADER after the run (the
#            ONE funnel persisted it; the probe never calls save()).
#   read   — a NEW process (the DoD's quit+relaunch): the identical LEG
#            board rows printed from load_save(), plus the real click
#            route opening the page and COUNTING the painted Labels;
#            pytest asserts the two boots' board rows are IDENTICAL.
extends SceneTree

const SAVE := "user://dawnwell.json"
const CORRUPT := "dawnwell.corrupt.json"
const DT := 1.0 / 60.0
const RUN_CAP := 10000 # ~166 s of sim — past the s8 gameover legs' death
# window; the cap-arm below only ends a hero that somehow out-tanks it

var _main: Node
var _frame := 0
var _mode := "rank"


func _initialize() -> void:
	_mode = OS.get_environment("HD3D_BESTRUNS_MODE")
	if _mode == "rank":
		_legs_rank()
		print("PROBE_DONE")
		quit(0)
		return
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)


# SceneTree-script quit contract (sim_headless): true ENDS the loop.
func _process(_delta: float) -> bool:
	_frame += 1
	if _frame < 2:
		return false # _ready lands a frame after add_child (chest_capture)
	if _mode == "read":
		if _frame == 2:
			_leg_relaunch()
		print("PROBE_DONE")
		quit(0)
		return true
	match _frame:
		2:
			_leg_nav()
		3:
			_leg_runs()
		4:
			_leg_disk()
	if _frame >= 4:
		print("PROBE_DONE")
		quit(0)
		return true
	return false


func _btn(root: Node, text: String) -> Button:
	for b in root.find_children("*", "Button", true, false):
		if b.text == text:
			return b
	return null


# ---- write mode ---------------------------------------------------------------

func _leg_nav() -> void:
	var sc = _main._screens
	assert(sc.has_method("bestruns_visible") and sc.has_method("show_bestruns"),
		"the REAL screens overlay family must carry the best-runs half")
	_main._dawnwell.reset() # fresh-state law (the convert/shop/settings legs)
	var btn := _btn(sc._menu, "Best Runs")
	var clickable := int(btn != null and not btn.disabled and btn.is_visible_in_tree())
	btn.pressed.emit() # the menu's OWN verb: bestruns_requested -> _open_bestruns
	var opens := int(sc.bestruns_visible())
	var menu_hidden := int(not sc._menu.visible)
	var back := _btn(sc._bestruns, "Back to the menu")
	var back_backs := int(back != null and back.is_visible_in_tree())
	back.pressed.emit() # bestruns_closed -> close_bestruns -> show_menu
	print("LEG nav clickable=%d opens=%d menu_hidden=%d back_backs=%d back_menu=%d board_closed=%d" % [
		clickable, opens, menu_hidden, back_backs,
		int(sc._menu.visible), int(not sc.bestruns_visible())])


func _leg_runs() -> void:
	# hero 0, then hero 1 (the well's char row is the shipped choice seam),
	# then hero 0 AGAIN — two rows on one hero is what makes the board
	# ORDER observable in the read-back legs (rank law through the real
	# game-over path, not only the unit legs). The hero-1 char row is a
	# DECLARED STATE SEED (dawnwell_capture's BANKROLL precedent): the run-
	# end RECORDING is what this probe judges, not the buy gate — and the
	# start seam never re-checks ownership (the verbs own that law).
	var heroes := [0, 1, 0]
	var ends := 0
	for run in heroes.size():
		var h: int = heroes[run]
		_main._dawnwell.char = h
		_main._start_game() # the REAL run-start funnel
		_main.game.paused = true # the tree tick idles; _step driven manually
		seed(11628 + run) # the per-leg seed convention (S2h/S2i): each run
		var n := 0 # gets its own RNG stream — distinct rows, stable re-run
		while n < RUN_CAP:
			if _main.game.phase == "levelup":
				_main._pick(0) # accept-first-card, the _pick_ward law
			elif _main.game.phase != "playing":
				break
			elif n == RUN_CAP - 1:
				_main.game.hp = 0.0 # cap guard: the planted blow lands in
				# the NEXT _step, which ends the run through the SHIPPED
				# hp<=0 arm — the handler and the recorded row are still
				# 100% the shipped path; survived/kills are real sim
				# values. A stationary runner dies to the horde far before
				# this cap on every shipped hero; the guard only keeps a
				# tanky hero from spinning forever.
			_main._handle_presses()
			_main._step(DT)
			n += 1
		ends += int(_main.game.phase in ["gameover", "win"])
	print("LEG ends runs=%d ended=%d recorded=%d" % [heroes.size(), ends,
		int(DawnWell.load_save().best_runs.size() > 0)]) # the disk read-
	# back THROUGH THE SHIPPED LOADER: the ONE funnel under the gold line
	# wrote every end (probe-side save() calls: zero — the P-E3 law).


# The board printer BOTH boots share — pytest compares the parsed LEG dicts
# for equality (the DoD's "identical rows"), so one function, two callers.
func _print_board(tag: String, w: DawnWell) -> void:
	for h in [0, 1]:
		var rows: Array = BestRuns.rows(w, h)
		var kv := "n=%d" % rows.size()
		for i in 5:
			if i < rows.size():
				kv += " s%d=%d u%d=%d k%d=%d" % [i, int(rows[i].score), i,
					int(rows[i].survived), i, int(rows[i].kills)]
			else:
				kv += " s%d=-1 u%d=-1 k%d=-1" % [i, i, i]
		print("LEG %s%d %s" % [tag, h, kv])


func _leg_disk() -> void:
	_print_board("disk", DawnWell.load_save())


# ---- read mode (the second real boot) -------------------------------------------

func _leg_relaunch() -> void:
	_print_board("relaunch", DawnWell.load_save())
	var sc = _main._screens
	var btn := _btn(sc._menu, "Best Runs")
	btn.pressed.emit() # the REAL click route on the persisted well
	var labels: Array = sc._bestruns_rows.get_children()
	# painted rows = one header per hero (9) + one line per recorded run
	# (min(n, TOP)) + one "no runs yet" line per EMPTY hero — the page
	# shows the persisted rows, exactly, no more no less.
	var w := DawnWell.load_save()
	var expect := Roster.CHARACTERS.size()
	for h in Roster.CHARACTERS.size():
		var n: int = BestRuns.rows(w, h).size()
		expect += n if n > 0 else 1
	print("LEG page opens=%d painted=%d expect=%d match=%d" % [
		int(sc.bestruns_visible()), labels.size(), expect,
		int(labels.size() == expect)])


# ---- rank mode: the rule legs + the shape sanitize ----------------------------

func _legs_rank() -> void:
	# truncation: seven rows 100..40 -> the board keeps the top 5; the two
	# weakest never enter (a tail drop, never a rotation).
	var w := DawnWell.new()
	for s in [100, 90, 80, 70, 60, 50, 40]:
		BestRuns.record(w, 0, 10, 1, s)
	var rows: Array = BestRuns.rows(w, 0)
	print("LEG trunc n=%d top=%d fifth=%d has50=%d has40=%d" % [
		rows.size(), int(rows[0].score), int(rows[4].score),
		int(_any(rows, 50)), int(_any(rows, 40))])
	# the rank law: a score tie orders by survived DESC; then a FULL tie
	# keeps the EARLIER row above — the kills stamps below are the
	# insertion witnesses (arrival order 1,2,3 read as 2 then 3 at equal
	# (999, 7), the older twin untouched above).
	var w2 := DawnWell.new()
	BestRuns.record(w2, 0, 5, 1, 100) # (100,5) first
	BestRuns.record(w2, 0, 7, 2, 100) # (100,7): survived desc -> above (100,5)
	BestRuns.record(w2, 0, 7, 3, 999) # (999,7): full win -> head
	var r2: Array = BestRuns.rows(w2, 0)
	BestRuns.record(w2, 0, 7, 4, 999) # full tie with (999,7): lands BELOW it
	r2 = BestRuns.rows(w2, 0)
	print("LEG rank head=%d head_k=%d order=%d,%d,%d survivors=%d,%d" % [
		int(r2[0].score), int(r2[0].kills), int(r2[1].kills),
		int(r2[2].kills), int(r2[3].kills), int(r2[1].survived),
		int(r2[2].survived)])
	# per-hero isolation: hero 1 never sees hero 0's rows; an unused hero
	# reads the empty board.
	var w3 := DawnWell.new()
	BestRuns.record(w3, 0, 10, 1, 100)
	BestRuns.record(w3, 1, 20, 2, 50)
	print("LEG per_hero h0=%d h1=%d h0score=%d h1score=%d h2=%d" % [
		BestRuns.rows(w3, 0).size(), BestRuns.rows(w3, 1).size(),
		int(BestRuns.rows(w3, 0)[0].score), int(BestRuns.rows(w3, 1)[0].score),
		BestRuns.rows(w3, 2).size()])
	_leg_sanitize()


func _any(rows: Array, score: int) -> bool:
	for r in rows:
		if int(r.score) == score:
			return true
	return false


func _leg_sanitize() -> void:
	# Field-shape garbage DEFAULTS the field (the _int_dict lineage: only
	# an UNDECODABLE WHOLE FILE quarantines); unknown heroes and malformed
	# rows drop; int() lands JSON-float rows. Each case starts from a
	# fresh well + no corrupt copy (the previous case's quarantine would
	# otherwise bleed into the next corrupt flag).
	var dir := DirAccess.open("user://")
	var cases := [
		["garbage_top", '{"version":1,"best_runs":"nonsense"}', "empty"],
		["mixed", '{"version":1,"best_runs":{"0":[{"survived":12.5,"kills":3,'
			+ '"score":50},"junk",{"score":1}],"99":[{"survived":1,"kills":1,'
			+ '"score":1}],"abc":[{"survived":1,"kills":1,"score":1}]}}', "mixed"],
	]
	for c in cases:
		if dir.file_exists(CORRUPT):
			dir.remove(CORRUPT)
		var f := FileAccess.open(SAVE, FileAccess.WRITE)
		f.store_string(String(c[1]))
		f.close()
		var w := DawnWell.load_save()
		var corrupt := int(dir.file_exists(CORRUPT))
		if c[2] == "empty":
			print("LEG san_%s defaulted=%d corrupt=%d" % [c[0],
				int(w.best_runs == {}), corrupt])
		else:
			var rows: Array = w.best_runs.get("0", [])
			print("LEG san_mixed hero0=%d score=%d survived=%d lone_hero=%d" % [
				rows.size(), int(rows[0].score), int(rows[0].survived),
				int(w.best_runs.size() == 1)])
	# an older save WITHOUT the field reads {} (the R1 migration proof).
	var f2 := FileAccess.open(SAVE, FileAccess.WRITE)
	f2.store_string('{"version":1,"gold":5,"ranks":{},"flags":{},'
			+ '"best_cycle":0,"stage":1,"counters":{},"char":0,"skin":0,'
			+ '"vol_master":100,"vol_music":100,"vol_sfx":100,'
			+ '"fullscreen":0,"pause_lose_focus":0}')
	f2.close()
	print("LEG san_old defaulted=%d corrupt=%d" % [int(
		DawnWell.load_save().best_runs == {}), int(dir.file_exists(CORRUPT))])
	# a past-TOP disk bucket reads as the rank prefix (the load reads the
	# LAW, not the blob).
	var blob := '{"version":1,"best_runs":{"0":['
	for i in 8:
		if i > 0:
			blob += ","
		blob += '{"survived":%d,"kills":1,"score":%d}' % [8 - i, 99 - i]
	blob += "]}}"
	var f3 := FileAccess.open(SAVE, FileAccess.WRITE)
	f3.store_string(blob)
	f3.close()
	var capped := BestRuns.rows(DawnWell.load_save(), 0)
	print("LEG san_cap n=%d top=%d" % [capped.size(), int(capped[0].score)])
