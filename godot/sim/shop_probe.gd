# Dawn Well shop behavioral probe (T-M1f, MC 11210; PARITY-ROADMAP rev3 M1
# feature 2 ACCEPT rows). Headless SceneTree run, same LEG-row convention as
# save_probe.gd (MC 11205): wipe user:// between legs, throwaway XDG_DATA_HOME
# (the pytest leg points it at /tmp), machine-readable `LEG <name> k=v` rows
# plus `JSON <text>` with the on-disk save and the roadmap's named
# `dawnwell.<id>.rank=N` dump-probe rows. The SAVE_LOAD_FAIL stderr marker of
# the corrupt-into-shop leg is emitted by save.gd itself (T-M1a observables
# RIDDEN, not re-authored); tests/test_dawnwell_shop.py judges rows + stderr.
# Legs walk the real rule surface: PowerUps.buy/refund/refund_all on a real
# DawnWell, rank consumption through GameState.start_run + the real
# snapshot_json, the real collect_pickups gold funnel, and the real main.gd
# _start_game/_end_run wiring (stub screens, the sim_headless precedent).
extends SceneTree

const SAVE := "user://dawnwell.json"
const CORRUPT := "user://dawnwell.corrupt.json"
const TEMP := "user://dawnwell.json.tmp"

var _frames := 0 # _convert leg is frame-driven (see its header)
var _convert_done := false


func _initialize() -> void:
	_leg_curve()
	_leg_buy()
	_leg_poor()
	_leg_max()
	_leg_refund_fee()
	_leg_floor()
	_leg_refund_all()
	_leg_corrupt_shop()
	_leg_effect_snapshot()
	_leg_xp_rate()
	_leg_gold_rate()
	_leg_sealed()
	# Main.tscn enters the tree here; its _ready runs a frame LATER (the
	# chest_capture lesson: stage swaps never run inside _initialize), so
	# _leg_convert completes in _process below — headless frames tick.
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)


# SceneTree-script quit contract (sim_headless): returning true from
# _process ends the run.
func _process(_delta: float) -> bool:
	_frames += 1
	if _convert_done:
		print("PROBE_DONE")
		return true
	if _frames < 2:
		return false
	if _main._screens == null and _frames < 240:
		return false # _ready still pending (should not happen; guard)
	if _main._screens == null:
		print("LEG convert FAIL screens never ready")
		print("PROBE_DONE")
		quit(3)
		return true
	_leg_convert()
	_convert_done = true
	return false


func _fresh(gold: int) -> DawnWell:
	_wipe()
	var w: DawnWell = DawnWell.load_save()
	w.gold = gold
	return w


# OUR cost curve row: cost at rank r = base * (r + 1) — every row, both ends
# of the curve asserted arithmetically (planted fee/floor mutations land on
# the dedicated legs below, not on this pure-math one).
func _leg_curve() -> void:
	var ok := true
	for r in PowerUps.TABLE:
		for rank in range(0, PowerUps.MAX_RANK):
			if PowerUps.cost(r.id, rank) != int(r.cost) * (rank + 1):
				ok = false
	print("LEG curve linear=%d rows=%d max=%d fee=%d" % [
		int(ok), PowerUps.TABLE.size(), PowerUps.MAX_RANK,
		PowerUps.REFUND_FEE_PCT])


func _leg_buy() -> void:
	var w := _fresh(1000)
	var ok := PowerUps.buy(w, "vitality")
	w.save()
	print("JSON " + _read(SAVE))
	var r: DawnWell = DawnWell.load_save()
	print("LEG buy ok=%d rank=%d gold=%d reloaded_rank=%d reloaded_gold=%d" % [
		int(ok), int(w.ranks.get("vitality", -1)), w.gold,
		int(r.ranks.get("vitality", -1)), r.gold])


func _leg_poor() -> void:
	var w := _fresh(10)
	var ok := PowerUps.buy(w, "vitality") # costs 40
	print("LEG poor ok=%d rank_absent=%d gold=%d" % [
		int(ok), int(not w.ranks.has("vitality")), w.gold])


func _leg_max() -> void:
	var w := _fresh(100000)
	var spent := 0
	for i in range(PowerUps.MAX_RANK + 2): # two attempts past the cap
		if PowerUps.buy(w, "vitality"):
			spent += 1
	var rank := int(w.ranks.get("vitality", -1))
	print("LEG max buys_ok=%d rank=%d cap=%d paid=%d expected=%d" % [
		spent, rank, PowerUps.MAX_RANK, 100000 - w.gold,
		40 * (1 + 2 + 3 + 4 + 5)])


# The fee leg (planted-red target 1): one rank on vitality paid 40; the
# refund is floor(40 * 95 / 100) = 38 — the roadmap's OUR fee pinned at 5.
# Remove the fee and this row pays 40 and the leg goes RED.
func _leg_refund_fee() -> void:
	var w := _fresh(1000)
	PowerUps.buy(w, "vitality") # rank 1, 40g
	var give := PowerUps.refund(w, "vitality")
	print("LEG fee give=%d paid=40 fee_pct=%d rank=%d" % [
		give, PowerUps.REFUND_FEE_PCT, int(w.ranks.get("vitality", -1))])


# The floor leg (planted-red target 2): refunding rank 0 pays ZERO and the
# rank cannot dig below 0. Remove the guard and rank lands on -1 — RED.
func _leg_floor() -> void:
	var w := _fresh(500)
	var give := PowerUps.refund(w, "vitality")
	print("LEG floor give=%d rank=%d gold=%d" % [
		give, int(w.ranks.get("vitality", -9)), w.gold])


func _leg_refund_all() -> void:
	var w := _fresh(1000)
	PowerUps.buy(w, "vitality")
	PowerUps.buy(w, "vitality") # vitality rank 2: paid 40 + 80
	PowerUps.buy(w, "grave-greed") # rank 1: paid 100
	var before := w.gold
	var total := PowerUps.refund_all(w)
	var ranks_left := 0
	for id in w.ranks:
		if int(w.ranks[id]) > 0:
			ranks_left += 1
	print("LEG refund_all before=%d after=%d gave=%d expected=209 ranks_left=%d" % [
		before, w.gold, total, ranks_left])


# The corrupt-save-into-shop leg: a broken save takes the T-M1a quarantine
# path at boot load, and the shop RIDES the defaults — buys against the
# default 0 gold decline, a cashed-out run re-creates a valid file.
func _leg_corrupt_shop() -> void:
	_wipe()
	_write(SAVE, "{dawnwell torn by an outside hand")
	var w: DawnWell = DawnWell.load_save()
	var defaulted := w.gold == 0 and w.ranks.is_empty()
	var declined := PowerUps.buy(w, "vitality") # gold 0 default: decline
	w.gold = 500 # the run's cash-out (leg convert proves that funnel)
	var bought := PowerUps.buy(w, "vitality")
	var ok := w.save()
	var r: DawnWell = DawnWell.load_save()
	print("LEG corrupt_shop quarantined=%d defaults=%d declined=%d bought=%d ok=%d file_back=%d reloaded_rank=%d" % [
		int(_exists(CORRUPT)), int(defaulted),
		int(not declined), int(bought), int(ok), int(_exists(SAVE)),
		int(r.ranks.get("vitality", -1))])


# The roadmap's persistence+shop effect leg verbatim: ranks bought -> next
# run's start_run() applies them -> named dawnwell.<id>.rank dump rows and
# the pinned snapshot arithmetic (maxHp == 100 + Σ maxHp-ranks*10; xpNext
# stays xp_need(level) unchanged).
func _leg_effect_snapshot() -> void:
	var game := GameState.new()
	game.meta_ranks = {"vitality": 2, "bulwark": 1, "sage-thirst": 1,
		"grave-greed": 2}
	game.start_run()
	for id in game.meta_ranks:
		print("dawnwell.%s.rank=%d" % [id, game.meta_ranks[id]])
	var snap: Dictionary = JSON.parse_string(game.snapshot_json(0))
	print("LEG effects maxhp=%.1f expect=%.1f hp=%.1f xpnext=%d expect_xpnext=%d" % [
		snap.maxHp, 100.0 + (2 + 1) * 10.0, snap.hp, int(snap.xpNext),
		GameState.xp_need(1)])


func _leg_xp_rate() -> void:
	var base := GameState.new()
	base.start_run()
	base.add_xp(9.5)
	var boosted := GameState.new()
	boosted.meta_ranks = {"sage-thirst": 1}
	boosted.start_run()
	boosted.add_xp(9.5) # 9.5 * 1.10 = 10.45 >= xp_need(1) = 10
	var boosted_snap: Dictionary = JSON.parse_string(boosted.snapshot_json(0))
	print("LEG xprate base_level=%d boosted_level=%d xpnext_is_formula=%d" % [
		base.level, boosted.level,
		int(boosted_snap.xpNext == GameState.xp_need(boosted.level))])


func _leg_gold_rate() -> void:
	var base := _collect_leg({})
	var boosted := _collect_leg({"grave-greed": 2, "coin-cup": 1})
	print("LEG goldrate base_gold=%d expect_base=10 boosted_gold=%d expect=%d" % [
		base, boosted, 13])


func _collect_leg(ranks: Dictionary) -> int:
	var game := GameState.new()
	game.meta_ranks = ranks
	game.start_run()
	var world := GameWorld.new()
	for i in range(10):
		world.coins.append({"x": 0.0, "y": 0.0, "gold": 1})
	# main._step's OWN line — the collect funnel returns the credited gold
	# and the caller adds it; skipping the add was this leg's first bug.
	game.gold += world.collect_pickups(game)
	return game.gold


# M2-probe split (DA c1 B-5): every sealed (scope "m2") rank is purchasable
# but runs change NOTHING until the M2 card proves its stat row.
func _leg_sealed() -> void:
	var clean := GameState.new()
	clean.start_run()
	var sealed := GameState.new()
	sealed.meta_ranks = {"swift-shroud": 5, "wide-reap": 5, "quick-hands": 5,
		"raven-feather": 5, "split-silhouette": 5, "magnet-bone": 5,
		"moss-mail": 5}
	sealed.start_run()
	var clean_snap: Dictionary = JSON.parse_string(clean.snapshot_json(0))
	var sealed_snap: Dictionary = JSON.parse_string(sealed.snapshot_json(0))
	print("LEG sealed same_maxhp=%d same_xpnext=%d same_speed=%d same_hp=%d" % [
		int(clean_snap.maxHp == sealed_snap.maxHp),
		int(clean_snap.xpNext == sealed_snap.xpNext),
		int(clean.player_speed() == sealed.player_speed()),
		int(clean_snap.hp == sealed_snap.hp)])


# The real main.gd wiring (frame-driven entry, _process above): _start_game
# hands the well's ranks to start_run, _end_run cashes the run's gold out
# through the ONE funnel (stub screens, the sim_headless/chest_capture
# instantiation precedent).
var _main: Node

func _leg_convert() -> void:
	_main._dawnwell.reset() # T-M1a verb: fresh state + file gone (determinism)
	var old: CanvasLayer = _main._screens
	_main.remove_child(old)
	old.queue_free()
	var stub := SimStubScreens.new()
	_main.add_child(stub)
	_main._screens = stub
	_main._start_game()
	_main.game.gold = 77
	_main._end_run("gameover")
	var r: DawnWell = DawnWell.load_save()
	var ranks_note := "ranks" if not r.ranks.is_empty() else "empty"
	print("LEG convert well_gold=%d on_disk=%d file=%d ranks=%s" % [
		_main._dawnwell.gold, r.gold, int(_exists(SAVE)), ranks_note])


func _wipe() -> void:
	var dir := DirAccess.open("user://")
	if dir == null:
		return
	for p: String in [SAVE, CORRUPT, TEMP]:
		var rel := p.trim_prefix("user://")
		if dir.file_exists(rel):
			dir.remove(rel)


func _exists(p: String) -> bool:
	return FileAccess.file_exists(p)


func _write(p: String, text: String) -> void:
	var f := FileAccess.open(p, FileAccess.WRITE)
	f.store_string(text)
	f.close()


func _read(p: String) -> String:
	var f := FileAccess.open(p, FileAccess.READ)
	if f == null:
		return ""
	var t := f.get_as_text()
	f.close()
	return t
