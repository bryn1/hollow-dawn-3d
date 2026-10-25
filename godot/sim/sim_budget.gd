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
# row + sim_caps precedent): the six evolved ids are CHEST-ONLY entries the
# POOL never offers (feature 5's rule), and the fire path no-ops an unknown
# id (weapons.gd _fire fallback arm), so the pin is SAFE headless. ROSTER
# note (T-M1h, MC 11220): the six partner keys are now REAL pool passives
# and the six evolved ids' BASE weapons are pool-reachable (the reachability
# + full-evolution legs ride that in sim_evolve); PLAY-reachability of the
# full evolved SET by 900 s is still explicitly NOT claimed (evolution needs
# three late chests); the PLAYED cap-curve row is the sim-policy owned-set
# wpns row (its own line, not this leg's).
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
# budget_stage3 (C-E4, T-M3b MC 11284: the stage-3 WORST-case re-tally — own
# end-boss + plate MM live at the cap, §7's per-stage draw law),
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
		run.game.passives[k] = 5 # DECLARED pin: real keys at the 5-stack cap


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
		"declared": "evolved ids stay CHEST-ONLY (pool never offers them); " +
			"partner keys are real pool passives since T-M1h; play-reachability " +
			"of the full evolved set NOT claimed (doc §2 row)",
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
		"note": "T-M1h (MC 11220) MAPS rot-water's lingering zone onto the " +
			"ward ring-tick class (brief's NO-NEW-VIZ ruling supersedes the " +
			"roadmap's NEW-zones-list cell; zones MM deferred, the +1 it " +
			"would have added stays UNCONSUMED inside plan 40). Measured " +
			"tally re-run on the T-M1h tree under the same pin.",
		"ok": total <= DRAWS_HARD and DRAWS_PLANNED <= DRAWS_HARD})
	# clear the sim for the 900 s dump (spawn fresh through the game's loop)
	run.world.enemies.clear()
	run._viz.refresh()

	# (2b) budget_draws_unions — T-M2u D-U6 RE-CHECK leg (M2 §7: union FX
	# add ZERO draw classes — requiem-toll rides halos + bursts,
	# dirge-eternal the ward ring-tick class + halos, per §D.1; the zones
	# MM stays DEFERRED per the T-M1h declared mapping, stated): the §2
	# WORST-CASE LOADOUT with the two unions SUBSTITUTED for two evolved
	# entries (slot math: a union consumes two bases' slots and takes one,
	# so the six-slot build is 4 evolved + 2 unions), insight + loadstone
	# carried in the six-kind cap, the unions FIRE under a live 400-enemy
	# horde (60 real _step ticks, hp pinned — the declared S6/sim_boss
	# precedent), then the same draw_count() instrument. The pin is
	# restored verbatim for the budget_900 dump below.
	var u_build: Array = []
	for uid in ["requiem-toll", "dirge-eternal", "red-wail", "thousand-darts",
			"rot-spiral", "judgement-cross"]:
		u_build.append({"id": uid, "level": 8, "cd": 0.0})
	run.game.weapons = u_build # DECLARED pin (channel verbatim)
	run.game.passives = {"ferocity": 0, "haste": 0, "ward": 0, "grip": 0,
		"insight": 5, "cracked-heart": 5, "iron-wrap": 5, "tall-candles": 5,
		"four-leaf-charm": 5, "knotted-chain": 0, "loadstone": 5,
		"rotten-plate": 0, "twin-runes": 0, "gall-vial": 0, "gilded-skull": 0}
	for i in 400:
		run.world._spawn_enemy(CAST[i % CAST.size()], run.game,
			GameRenderer.VIEW)
	var u_halos := 0
	var u_bursts := 0
	var u_rings := 0
	for s in 60: # the unions fire: halos/bursts/rings live at the tally
		run.game.hp = run.game.max_hp # DECLARED pin (S6 precedent row)
		run._step(DT)
		u_halos = maxi(u_halos, run.fx.halos.size())
		u_bursts = maxi(u_bursts, run.fx.bursts.size())
		u_rings = maxi(u_rings, run.fx.rings.size())
	run._viz.refresh()
	run._fxv.refresh() # the unions fired DURING the ticks — sample NOW
	var u_horde: int = run._viz.draw_count()
	var u_fxw: int = run._fxv.draw_count()
	var u_pick: int = run._pvz.draw_count()
	var u_total := 1 + u_horde + 1 + u_fxw + u_pick
	var u_kinds := 0
	for k in run.game.passives:
		if run.game.passives[k] > 0:
			u_kinds += 1
	_rows.append({"ev": "budget_draws_unions", "alive": run.world.enemies.size(),
		"ground": 1, "horde": u_horde, "pawn": 1, "fx_worst": u_fxw,
		"pickups": u_pick, "total": u_total, "planned": DRAWS_PLANNED,
		"hard_cap": DRAWS_HARD, "weapon_slots": run.game.weapons.size(),
		"passive_kinds": u_kinds,
		"unions_fired": {"halos_max": u_halos, "bursts_max": u_bursts,
			"rings_max": u_rings},
		"note": "D-U6: 4 evolved + 2 unions (substituted for eternal-matins" +
			"/the-sluice), insight+loadstone in the 6-kind cap; zero new " +
			"draw CLASS (spec §7) — unions reuse halos+bursts / ring-tick" +
			"+halos. Measured under a live firing horde (60 ticks, hp " +
			"pinned, S6 declared precedent).",
		"ok": u_total <= DRAWS_HARD \
				and u_kinds <= LevelUpDeck.MAX_PASSIVE_KINDS \
				and u_halos >= 1 and u_bursts >= 1 and u_rings >= 1})
	run.world.enemies.clear()
	run._viz.refresh()
	run.game.passives["insight"] = 0 # undo this leg's declared passive swap...
	_pin_worst_case(run) # ...then restore the named loadout for the 900 s dump

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

	# (4) budget_stage3 — C-E4 re-tally on the WORST stage (MC 11284 T-M3b,
	# spec §7): stage 3, DECLARED worst-case loadout pinned, the FULL stage-3
	# band roster at the 400-cap through the real _spawn_enemy funnel, the
	# stage's OWN end-boss firing through the real schedule tick (t=540 pin),
	# the player DWELLED on plate[0] so the plate MM is live, then 60 real
	# _step ticks under the hp-pin (the union-leg precedent) before the
	# draw_count() sample. §7's per-stage law: stage 1 keeps the byte-pinned
	# 13 (horde_viz stage-gates its boss-class MMs — a stage only ever
	# fields its own end-boss, the replaced classes are §7's idle rows);
	# stage 3 is the worst (plate MM joins + own ossuary): plan 40, hard 60.
	var s3: Node = load("res://Main.tscn").instantiate()
	root.add_child(s3)
	var stub3 := SimStubScreens.new()
	s3.add_child(stub3)
	s3._screens = stub3
	stub3.start_pressed.connect(s3._start_game)
	stub3.card_picked.connect(s3._pick)
	s3._dawnwell.stage = 3 # DECLARED save-side row pin (sim_stages pattern)
	s3._start_game()
	_pin_worst_case(s3)
	var s3row: Dictionary = GameRenderer.stage_row("ossuary-stair")
	s3.game.player.x = float(s3row.plates[0][0]) # dwell: plate MM live
	s3.game.player.y = float(s3row.plates[0][1])
	s3.game.time = 540.0 - DT # DECLARED pin: the ossuary fires on tick 1
	var S3_CAST := ["wraith", "pale-wight", "rime-ghoul", "hound", "crawler",
		"cultist"] # stage-3 bands + GATES live classes
	for i in 400:
		s3.world._spawn_enemy(S3_CAST[i % S3_CAST.size()], s3.game,
			GameRenderer.VIEW)
	var s3_max_total := 0
	var s3_horde := 0
	var s3_named := 0
	var s3_boss_ticks := 0
	for s in 60:
		_decline(s3)
		s3.game.hp = s3.game.max_hp # DECLARED pin (union-leg precedent)
		s3._step(DT)
		var hn := 0
		var bn := 0
		for e in s3.world.enemies:
			if e.boss:
				bn += 1
			elif not e.miniboss:
				hn += 1
		if bn > 0:
			s3_boss_ticks += 1
		s3_horde = maxi(s3_horde, hn)
		s3_named = maxi(s3_named, bn)
		s3_max_total = maxi(s3_max_total, s3.world.enemies.size())
	s3._viz.refresh()
	s3._fxv.refresh()
	var s3_horde_draws: int = s3._viz.draw_count()
	var s3_fx: int = s3._fxv.draw_count()
	var s3_pick: int = s3._pvz.draw_count()
	var s3_total := 1 + s3_horde_draws + 1 + s3_fx + s3_pick
	_rows.append({"ev": "budget_stage3", "alive_max_total": s3_max_total,
		"alive_cap": GameWorld.ALIVE_CAP, "horde_max": s3_horde,
		"named_max": s3_named, "boss_ticks_live": s3_boss_ticks,
		"ground": 1, "horde": s3_horde_draws, "pawn": 1, "fx_worst": s3_fx,
		"pickups": s3_pick, "total": s3_total, "planned": DRAWS_PLANNED,
		"hard_cap": DRAWS_HARD,
		"note": "C-E4 (T-M3b): stage-3 WORST case — own end-boss live, plate " +
			"MM live, full stage-3 roster at the cap; §7 replaces stage-1's " +
			"three named classes with ONE (the replaced classes idle: their " +
			"MMs stage-gate out of the tally)",
		"ok": s3_total <= DRAWS_HARD and s3_total <= DRAWS_PLANNED \
			and s3_horde <= GameWorld.ALIVE_CAP \
			and s3_named <= 1 and s3_boss_ticks == 60})
	s3.queue_free()

	var ok_all: bool = true
	for r in _rows:
		if r.has("ok") and not r["ok"]:
			ok_all = false
	_rows.append({"ev": "budget_verdict", "ok": ok_all,
		"rows": _rows.size() - 1})
	run.queue_free()
