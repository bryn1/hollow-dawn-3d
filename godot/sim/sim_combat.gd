# Combat-layer probe for sim_headless.gd (MC 11102 T-S4):
# (1) §i/A4 live-FX cap formulas + the per-sample violation check — the
#     capped thing is the RENDERED live count (WeaponFxViz.fx_counts()),
#     never the sim's own projectile lists (sim stays v1-verbatim);
# (2) single-weapon kill-attribution legs: one fresh run per weapon class
#     through the real _start_game funnel and the real main.gd _step loop,
#     game.weapons pinned to ONE weapon so every kill in the leg is
#     attributed to it — the main journey runs six concurrent sources and
#     cannot name the killer; this is how the dump proves >=1 kill PER
#     weapon class. Legs run with their own seed and their own clock; every
#     leg ends far below t=300 (the dump window).
class_name SimCombat
extends RefCounted

const DT := 1.0 / 60.0
const LEG_STEPS := 5400 # 90 sim-seconds per attribution leg (t stays < 300)
const SHARDS_MAX := 20 # brief §i: spike ground-burst shards <= 20
const HALO_MAX := 4 # §i: halo count 1+ceil(L/3) <= 4
# [weapon, level] — level chosen per §i cap coverage: ember L7 => cap 3,
# cleaver L5 => cap 2, halo L8 => count 4 (the A4 row-2/3/4 caps), the rest
# mid-level. All six levels also keep every leg's caps exercised.
const SPECS := [
	["talon", 2], ["ember", 7], ["cleaver", 5], ["halo", 8],
	["ward", 3], ["spike", 2],
]


# §i live-count cap formulas, spelled as weapons.gd spells its count math
# (1 + floor((L-1)/3) bolts per fire / <= 20 shards / <= 4 orbiters).
static func caps(game) -> Dictionary:
	var out := {"ember": 0, "cleaver": 0}
	for w in game.weapons:
		if w.id == "ember":
			out.ember = 1 + int((w.level - 1) / 3)
		elif w.id == "cleaver":
			out.cleaver = 1 + int((w.level - 1) / 4)
	return out


# c: the RENDERED counts from WeaponFxViz.fx_counts(). Returns human-readable
# violations — empty is the only acceptable answer, EVERY sample.
static func cap_violations(game, c: Dictionary) -> Array:
	var bad: Array = []
	var k := caps(game)
	if c.get("bolts", 0) > k.ember:
		bad.append("bolts %d > ember cap %d" % [c.bolts, k.ember])
	if c.get("trails", 0) > k.ember:
		bad.append("trails %d > ember cap %d" % [c.trails, k.ember])
	if c.get("axes", 0) > k.cleaver:
		bad.append("axes %d > cleaver cap %d" % [c.axes, k.cleaver])
	if c.get("halos", 0) > HALO_MAX:
		bad.append("halos %d > halo cap %d" % [c.halos, HALO_MAX])
	if c.get("shards", 0) > SHARDS_MAX:
		bad.append("shards %d > shard cap %d" % [c.shards, SHARDS_MAX])
	return bad


# One fresh run through the REAL funnel, weapons pinned to the single class;
# ticks the REAL main.gd _step (spawns, chase, contact, drops all live).
# Level-ups that melee legs trigger are DECLINED (pending_levels consumed,
# no card applied) so the build stays one-weapon and the attribution pure.
func run_leg(root: Window, weapon_id: String, level: int) -> Dictionary:
	var run: Node = load("res://Main.tscn").instantiate()
	root.add_child(run)
	var stub := SimStubScreens.new()
	run.add_child(stub)
	run._screens = stub
	stub.start_pressed.connect(run._start_game)
	run._start_game()
	run.game.weapons = [{"id": weapon_id, "level": level, "cd": 0.0}]
	for _n in LEG_STEPS:
		if run.game.phase == "levelup":
			run.game.pending_levels = 0
			run.game.set_phase("playing") # decline: keep one weapon only
		if run.game.phase != "playing":
			break
		run._step(DT)
	var row := {"ev": "weapon_kills", "weapon": weapon_id, "level": level,
		"kills": run.game.kills, "t": roundi(run.game.time * 1000.0) / 1000.0,
		"hp": roundi(run.game.hp * 10.0) / 10.0}
	run.queue_free()
	return row
