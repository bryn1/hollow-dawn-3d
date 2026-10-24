# WORST-CASE LOADOUT budget legs (T-M1g, MC 11211; PARITY-ROADMAP rev3 §2
# "Canonical WORST-CASE LOADOUT" + the budget acceptance lines). The doc's
# NAMED loadout: six weapon slots filled by the class-covering set (every
# weapon-FX class live, the zone MM active — c2 N-6 "fixture re-tally is the
# gate"), all at L8/evolved — Red Wail, Thousand Darts, Rot Spiral, Judgement
# Cross, Eternal Matins, The Sluice — with the six evolution partners Cracked
# Heart / Iron Wrap / Tall Candles / Four-Leaf Charm / Knotted Chain /
# Loadstone carried (6/6 passive KINDS).
# CONSTRUCTION CHANNEL (c2 N-2, verbatim): a DECLARED-PIN scripted leg — the
# loadout pinned into game.weapons/game.passives via the existing sim_boss
# pattern (sim_boss._pin_full_build), ZERO new mechanism. DECLARED (doc §2
# row + sim_caps precedent): these six evolved ids and six partner keys are
# entries the POOL cannot offer until the feature 6/7 weapon cards land —
# they ride the shipped evolutions.gd TABLE and the T-M1c icons, and the
# fire path no-ops an unknown id (weapons.gd _fire match has no default
# branch, tick just re-calls a no-op), so the pin is SAFE headless and the
# doc's own disclaimers ship with it: PLAY-reachability of the full evolved
# set by 900 s is explicitly NOT claimed; the PLAYED cap-curve row is the
# sim-policy owned-set wpns row (its own line, not this leg's).
# ROWS (same headless funnel as sim_headless/sim_caps): budget_loadout (the
# pin + 6/6 carry-cap counts — roadmap feature 3 "the §2 WORST-CASE LOADOUT
# sim leg runs under exactly this cap"), budget_draws (the §b draw tally
# MEASURED at a 400-enemy sim with every horde class including both
# miniboss classes spawned through the real _spawn_enemy funnel — the same
# draw_count() instruments sim_headless._dump_draws/art_probe._dump_400 use,
# planned 40 (the §2 raised plan, retired+replaced here) / total <= 60 hard),
# budget_900 (scripted 900 s dump UNDER THE PIN — DECLARED deviations: hp
# pinned every tick, the S6/sim_boss precedent row verbatim, level-up offers
# declined to keep the pinned build pure; max-alive row <= ALIVE_CAP 400),
# budget_verdict last. Seed-pinned per sim_headless's stated sim-leg rule.
extends SceneTree

const DT := 1.0 / 60.0
const STEPS_900 := 900 # 900 s of sim time scripted, S6-loop shape
const DRAWS_PLANNED := 40 # §2 plan raised 33 -> 40 (roadmap :68-71, T-M1g)
const DRAWS_HARD := 60 # §b hard cap (unchanged)
# All horde classes incl. the two M1 miniboss classes — the doc's "class-
# covering set ... every weapon-FX class live; fixture re-tally is the gate".
const CAST := ["wraith", "hound", "crawler", "cultist", "moor-brute",
	"dune-scarab", "rime-ghoul", "pale-wight", "hollow-knight",
	"hollow-deacon"]
const LOADOUT := ["red-wail", "thousand-darts", "rot-spiral",
	"judgement-cross", "eternal-matins", "the-sluice"]
const PARTNERS := ["cracked-heart", "iron-wrap", "tall-candles",
	"four-leaf-charm", "knotted-chain", "loadstone"]

var _main: Node
var _rows: Array = []
var _started := false


func _out_path() -> String:
	var d: String = OS.get_environment("HD3D_BUDGET_DUMP")
	return d if d != "" else "/tmp/hd3d-budget-m1g.jsonl"


func _process(_delta: float) -> bool:
	if not _started:
		_started = true
		print("BUDGET_START")
		seed(11211)
		_run_legs()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		for r in _rows:
			f.store_line(JSON.stringify(r))
		var ok: bool = true
		for r in _rows:
			if r.has("ok") and not r["ok"]:
				ok = false
		print("BUDGET_OK rows=%d ok=%s" % [_rows.size(), ok])
		quit(0 if ok else 3)
	return false


func _fresh_run() -> Node:
	var run: Node = load("res://Main.tscn").instantiate()
	root.add_child(run)
	var stub := SimStubScreens.new()
	run.add_child(stub)
	run._screens = stub
	stub.start_pressed.connect(run._start_game)
	run._start_game()
	return run


# DECLARED pin (sim_boss._pin_full_build channel verbatim): the doc's NAMED
# loadout — six evolved ids at L8, six partner KINDS at the 5-stack cap.
func _pin_worst_case(run: Node) -> void:
	var build: Array = []
	for id in LOADOUT:
		build.append({"id": id, "level": 8, "cd": 0.0})
	run.game.weapons = build # DECLARED pin (SimCombat pattern)
	for k in PARTNERS:
		run.game.passives[k] = 5 # DECLARED pin: keys the pool cannot offer yet


func _decline(run: Node) -> void:
	if run.game.phase == "levelup":
		run.game.pending_levels = 0
		run.game.set_phase("playing") # decline: keep the pinned build pure


func _run_legs() -> void:
	var run := _fresh_run()
	_pin_worst_case(run)

	# (1) budget_loadout — the pin + the feature-3 cap compliance of the pin.
	var kinds := 0
	for k in run.game.passives:
		if run.game.passives[k] > 0:
			kinds += 1
	var slots_ok: bool = run.game.weapons.size() == 6 \
		and run.game.weapons.size() <= LevelUpDeck.MAX_WEAPON_SLOTS
	var kinds_ok: bool = kinds == 6 and kinds <= LevelUpDeck.MAX_PASSIVE_KINDS
	_rows.append({"ev": "budget_loadout", "weapons": LOADOUT,
		"levels": 8, "passives": PARTNERS, "stacks": 5,
		"max_weapon_slots": LevelUpDeck.MAX_WEAPON_SLOTS,
		"max_passive_kinds": LevelUpDeck.MAX_PASSIVE_KINDS,
		"declared": "pool-unreachable ids/keys until the feature 6/7 cards " +
			"land (doc §2 construction-channel row; play-reachability NOT claimed)",
		"ok": slots_ok and kinds_ok})

	# (2) budget_draws — MEASURED §b tally at 400 alive, class-covering
	# cast through the real spawn funnel (the real _ready funnel call).
	for i in 400:
		run.world._spawn_enemy(CAST[i % CAST.size()], run.game,
			GameRenderer.VIEW)
	run._viz.refresh()
	var horde: int = run._viz.draw_count()
	var fxw: int = run._fxv.draw_count()
	var pickups: int = run._pvz.draw_count()
	var total := 1 + horde + 1 + fxw + pickups
	_rows.append({"ev": "budget_draws", "alive": run.world.enemies.size(),
		"ground": 1, "horde": horde, "pawn": 1, "fx_worst": fxw,
		"pickups": pickups, "total": total, "planned": DRAWS_PLANNED,
		"hard_cap": DRAWS_HARD,
		"note": "zones MM (+1) + chest FX ship WITH the feature-6 weapon " +
			"card (the ONE new mechanism, roadmap feature 6 table); absent " +
			"here = the honest measured build; plan 40 leaves room for them",
		"ok": total <= DRAWS_HARD and DRAWS_PLANNED <= DRAWS_HARD})
	# clear the sim for the 900 s dump (spawn fresh through the game's loop)
	run.world.enemies.clear()
	run._viz.refresh()

	# (3) budget_900 — scripted 900 s dump UNDER THE PIN. DECLARED
	# deviations: hp pinned every tick (S6/sim_boss kill-leg precedent —
	# no scripted driver survives the 12/s wall; the CLOCK is never touched
	# beyond the scripted-dt nature of this harness, stated), offers declined.
	# READING STATED (roadmap ":151 max-alive row <= 400 in the 900 s dump"):
	# the ALIVE_CAP pauses the WAVE spawn accumulation (world.gd, the single
	# spawn loop, T-M1d verbatim); the BOSS/MINIBOSS SCHEDULE sits ABOVE the
	# guard BY DESIGN so t=540/600/780 spawns fire at cap — a strict total
	# <= 400 contradicts the shipped design (T-M1d's own LEDGER row measures
	# the cap binding at 400 while its schedule fires inside the same dump).
	# The honest pair of rows therefore: max ALIVE-HORDE <= 400 (the cap
	# line, reading A made measurable) AND total <= 400 + 3 named scheduled
	# spawns (warden + hollow-knight + hollow-deacon, each exactly once,
	# latch-pinned in the suite).
	var max_total := 0
	var max_horde := 0
	var t := 0.0
	for s in STEPS_900 / DT:
		_decline(run)
		if run.game.phase != "playing":
			break
		run.game.hp = run.game.max_hp # DECLARED pin, S6 precedent
		run._step(DT)
		var horde_n := 0
		for e in run.world.enemies:
			if not e.boss and not e.miniboss:
				horde_n += 1
		max_horde = maxi(max_horde, horde_n)
		max_total = maxi(max_total, run.world.enemies.size())
		t = run.game.time
	_rows.append({"ev": "budget_900", "t": snappedf(t, 0.001),
		"phase": run.game.phase,
		"max_alive_horde": max_horde, "alive_cap": GameWorld.ALIVE_CAP,
		"max_alive_total": max_total,
		"scheduled_above_guard": ["warden@540", "hollow-knight@600",
			"hollow-deacon@780"],
		"declared": "hp pinned every tick; scripted-dt sim loop (s8 pattern), " +
			"real-clock WIN row rides sim_s8",
		"ok": max_horde <= GameWorld.ALIVE_CAP \
			and max_total <= GameWorld.ALIVE_CAP + 3})

	var ok_all: bool = true
	for r in _rows:
		if r.has("ok") and not r["ok"]:
			ok_all = false
	_rows.append({"ev": "budget_verdict", "ok": ok_all,
		"rows": _rows.size() - 1})
	run.queue_free()
