# HARNESS FUNNEL — the sim-leg plumbing shared by the dump drivers
# (MC 11317 C3; audit MC 11316 §2.1's named seam). Bodies are the donors'
# byte-for-byte: fresh_run = the Main.tscn-instantiate + SimStubScreens-wire
# idiom (~25 sites); check/ok/rows = the leg-row harness (_check x4
# byte-identical); decline/take_first_card = the TWO forked semantics that
# hid under one `_decline` name (zero-pending decline vs the stages pick-0
# loop) — now named separately, each kept exactly; out_path/r3 = dump-path
# and rounding carriers. Callers keep their thin _*-shaped wrappers so every
# leg call site is unchanged; the dumps must and do come out byte-identical
# (re-dump cmp gate, capture .tmp/clean-code.txt).
class_name SimFunnel
extends RefCounted

var rows: Array = []
var ok := true


func check(leg: String, checks: Dictionary, extra: Dictionary) -> void:
	var leg_ok := true
	for k in checks:
		if not checks[k]:
			leg_ok = false
	ok = ok and leg_ok
	var row := {"ev": leg, "checks": checks, "ok": leg_ok}
	for k in extra:
		row[k] = extra[k]
	rows.append(row)


static func fresh_run(tree: Node, opts: Dictionary = {}) -> Node:
	# The donors' order, verbatim: [well wipe] -> instantiate -> add -> stub
	# -> wire start -> [wire pick] -> [save-side flags] -> [save-side stage]
	# -> _start_game. opts: wipe_well (stages donor wipes first), wire_pick,
	# flags (the endless-flag pattern), stage (the stage-select pattern).
	if opts.get("wipe_well", false):
		DawnWell.new().reset() # each leg owns its well state unless it says otherwise
	var run: Node = load("res://Main.tscn").instantiate()
	tree.add_child(run)
	var stub := SimStubScreens.new()
	run.add_child(stub)
	run._screens = stub
	stub.start_pressed.connect(run._start_game)
	if opts.get("wire_pick", false):
		stub.card_picked.connect(run._pick)
	var flags: Dictionary = opts.get("flags", {})
	for k in flags:
		run._dawnwell.flags[k] = flags[k]
	if opts.has("stage"):
		run._dawnwell.stage = opts["stage"]
	run._start_game()
	return run


static func decline(run: Node) -> void:
	if run.game.phase == "levelup":
		run.game.pending_levels = 0
		run.game.set_phase("playing") # decline: keep the pinned build pure


static func take_first_card(run: Node) -> void:
	# The stages `_decline` shape — pick card 0 while the level-up phase
	# holds. NOT the same thing as decline() (audit §2.1's called-out fork);
	# both semantics survive, named, and no caller mixes them.
	while run.game.phase == "levelup":
		run._pick(0)


static func out_path(env_name: String, fallback: String) -> String:
	var d: String = OS.get_environment(env_name)
	return d if d != "" else fallback


static func r3(v: float) -> float:
	return roundi(v * 1000.0) / 1000.0
