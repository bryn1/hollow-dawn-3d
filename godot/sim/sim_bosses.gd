# END-BOSS legs for the stages-m3 dump (MC 11284 T-M3b; M3-SPEC rev-3 §3.4
# ACCEPT rows C-E1 + C-E3(readout) + C-E5). The boss half of the sim_stages
# ROWS map — one leg-driver per pillar batch is the sim convention, and the
# sim_stages file sits at the hygiene cap, so the new legs live here and
# REGISTER there (the SimBoss-from-sim_headless shape: a RefCounted leg
# class called by the SceneTree driver, never a second harness).
# Same headless funnel as every
# sim_stages leg: the REAL Main.tscn through _start_game, the DECLARED-PIN
# channel (clock warp + hp-pin, the sim_boss T-M1d leg shape — this is the
# "stage-parameterized" carrier the spec's C-E1 seam names), per-leg card
# seed 11284. The legs are appended by sim_stages._run_legs AFTER snapshot_m3
# (forward-lock law: every pre-existing stages-m3 row keeps its bytes).
# ROWS (row-id -> the ACCEPT row it pins):
#   stage2_schedule            C-E1: stage-2 run, warp 540-DT — the choir
#       walks the field at 540.017 (one stepped tick past the row time,
#       the shipped shape), fires EXACTLY ONCE to 782, latch == 1, NO
#       foreign stage-1 boss class ever fields (both-side negative half 1),
#       and the boss bar NAMES "THE CATHEDRAL CHOIR" while it lives (C-E3
#       readout leg — hud.boss_bar_state, the one bar seam).
#       T-M4e RE-MINT (M4-SPEC §7.2 R2, the declared moved row): the stage-2
#       row gained its [660.0, "sunken-prelate"] bosses entry, so `first`
#       tracks EVERY named spawn (the first_seen map gains the 660.017
#       entry), the latch pin moves 1 -> 2 (named-each count 2) and the
#       once-each check judges BOTH named classes. Equal-or-stronger: the
#       C-E1 claims ride unchanged, the event miniboss's own legs live in
#       sim_events (A-E6).
#   stage3_schedule            C-E1 same shape for the ossuary-warden,
#       bar "THE OSSUARY WARDEN" (tier III's own name, C-E3's second read);
#       T-M4e re-mint identical ([660.0, "stair-acolyte"] row).
#   boss_contact_clamp         C-E5: the P3-1 clamp re-derivation through
#       main.gd's OWN pipeline: DECLARED cycle-3 pin, ossuary teleported
#       onto the pawn (the endless_caps_cycle5 position pin), ONE real
#       _step tick — observed contact delta == MAX_CONTACT_DMG 20 under the
#       raw 14 x dmg_cyc(3) = 22.4 (the A-E3 "contact 24->20" mechanism leg
#       is the pattern); the per-base table (engine-evaluated): cycle 3
#       binds 13/14, cycle 4 binds base 12, every base dmg < 20 at cycle 0
#       (the vacuous-at-cycle-0 row the byte corpus rides).
# The other C-E1 half is carrier-side, not here: the shipped stage1_schedule
# leg stays byte-identical (its latch-3 row IS the "no choir/ossuary on
# stage 1" both-side half — judged by tests/test_boss_numbers.py).
class_name SimBosses
extends RefCounted

const CARD_SEED := 11284 # per-leg card seed (sim_boss per-leg seed law)
const FOREIGN := ["warden", "hollow-knight", "hollow-deacon"] # stage-1-only

# sim = the sim_stages SceneTree driver (its _fresh_run/_check/_decline are
# the ONE harness — no second loader, the sim_boss-from-sim_headless shape).
func run_boss_legs(sim) -> void:
	_leg_schedule(sim, 2, "cathedral-choir", "sunken-prelate",
		"THE CATHEDRAL CHOIR", "stage2_schedule")
	_leg_schedule(sim, 3, "ossuary-warden", "stair-acolyte",
		"THE OSSUARY WARDEN", "stage3_schedule")
	_leg_clamp(sim)


func _leg_schedule(sim, stage_idx: int, boss_id: String, miniboss_id: String,
		bar_name: String, leg: String) -> void:
	seed(CARD_SEED)
	var dt: float = sim.DT
	var run: Node = sim._fresh_run(stage_idx)
	run.game.time = GameWorld.BOSS_AT # DECLARED clock pin (the shipped
	# stage1_schedule shape): the boss row fires on the FIRST stepped tick,
	# 540.017 — the same first-seen observable the stage-1 row carries.
	var first_t := -1.0
	var guard := 0
	while guard < 60:
		guard += 1
		sim._decline(run)
		run.game.hp = run.game.max_hp # DECLARED hp-pin (endless pattern)
		run._step(dt)
		for e in run.world.enemies:
			if e.type == boss_id and first_t < 0.0:
				first_t = roundi(run.game.time * 1000.0) / 1000.0
		if first_t > 0.0:
			break
	run._hud.update(dt) # drive the ONE bar readout (C-E3)
	var bar: Dictionary = run._hud.boss_bar_state()
	# T-M4e R2 re-mint: first_seen is a MAP over BOTH named classes (the
	# end-boss + the stage's own event miniboss — the 660 entry the moved
	# row names); per-class CUMULATIVE spawn counts, the shipped shape.
	var first_seen := {boss_id: first_t}
	var appearances := {} # type -> cumulative spawns (0->2 counts 2)
	var prev := {} # tick-start counts, the rising-edge carrier
	var foreign_seen: Array = []
	while run.game.phase != "gameover" and run.game.time < 782.0:
		sim._decline(run)
		run.game.hp = run.game.max_hp
		if run.game.phase != "playing":
			break
		run._step(dt)
		var now := {}
		for e in run.world.enemies:
			if e.type == boss_id or e.type == miniboss_id:
				now[e.type] = int(now.get(e.type, 0)) + 1
				if not first_seen.has(e.type):
					first_seen[e.type] = roundi(run.game.time * 1000.0) / 1000.0
			elif e.type in FOREIGN and not foreign_seen.has(e.type):
				foreign_seen.append(e.type) # the BOTH-SIDE negative
		for k in now:
			var d: int = int(now[k]) - int(prev.get(k, 0))
			if d > 0:
				appearances[k] = int(appearances.get(k, 0)) + d
		prev = now
	sim._check(leg, {
		"boss_first_seen_540": first_t == 540.017,
		"boss_spawns_once": int(appearances.get(boss_id, 0)) == 1, # cannot spawn TWICE
		# M4 §1.2 (R2): the stage's event miniboss fires ONCE through the
		# ONE latch at its own 660 row, first-seen 660.017.
		"event_miniboss_first_seen_660": float(first_seen.get(miniboss_id, -1.0)) \
			== 660.017,
		"event_miniboss_spawns_once": int(appearances.get(miniboss_id, 0)) == 1,
		"schedule_latch_2": run.world.schedule_spawned == 2, # R2: 1 -> 2
		"no_foreign_bosses": foreign_seen.is_empty(),
		"bar_names_the_stage_boss": bool(bar.get("visible", false)) \
			and String(bar.get("name", "")) == bar_name,
	}, {"boss": boss_id, "first_seen": first_seen, "miniboss": miniboss_id,
		"appearances": appearances, "latch": run.world.schedule_spawned,
		"foreign_seen": foreign_seen, "bar": bar})
	run.queue_free()


# C-E5: the clamp re-derivation PER BASE through main.gd's own contact line
# (the spec's P3-1 fold): cycle 3 binds bases 13/14, cycle 4 binds base 12,
# cycle 0 vacuous for all three — and the OBSERVED ossuary read is the
# clamped 20.0, not 22.4, through the real _step.
func _leg_clamp(sim) -> void:
	seed(CARD_SEED)
	var dt: float = sim.DT
	var run: Node = sim._fresh_run(3)
	run.game.endless = true # DECLARED flag pin (the endless_caps_cycle5 shape:
	# the flag keeps a pinned cycle-k clock from win-ending the run at 900)
	run.game.cycle = 3 # DECLARED cycle pin (the eval channel, sim_endless)
	run.game.time = 3 * GameState.WIN_TIME + 0.5 # the clock FOLLOWS the
	# cycle (cycle_minute stays minute-0: a pinned cycle with time≈0 would
	# drive the spawn ramp NEGATIVE — the leg would spawn a −hp boss)
	var raw3 := {} # engine-evaluated, never literals: base -> raw x dmg_cyc(3)
	for base in [12.0, 13.0, 14.0]:
		raw3[str(int(base))] = roundi(base * GameWorld.dmg_cyc(3) * 1000.0) \
			/ 1000.0
	var raw4 := {} # and the cycle-4 products for the base-12 bind row
	for base in [12.0, 13.0, 14.0]:
		raw4[str(int(base))] = roundi(base * GameWorld.dmg_cyc(4) * 1000.0) \
			/ 1000.0
	# the observed half: ossuary teleported onto the pawn, one REAL _step
	run.world._spawn_enemy("ossuary-warden", run.game, GameRenderer.VIEW)
	var boss: Dictionary = run.world.enemies[0]
	boss.x = run.game.player.x # DECLARED position pin (contact is the read)
	boss.y = run.game.player.y
	run.game.hp = run.game.max_hp
	run.game.player.iframes = 0.0
	run._step(dt)
	var delta: float = run.game.max_hp - run.game.hp
	sim._check("boss_contact_clamp", {
		"ossuary_raw_binds_at_cycle3": raw3["14"] == 22.4 \
			and float(raw3["14"]) > run.MAX_CONTACT_DMG,
		"choir_raw_binds_at_cycle3": raw3["13"] == 20.8 \
			and float(raw3["13"]) > run.MAX_CONTACT_DMG,
		"warden_base12_not_yet_at_cycle3": raw3["12"] == 19.2 \
			and float(raw3["12"]) <= run.MAX_CONTACT_DMG \
			and float(raw4["12"]) == 21.6, # cycle 4 is ITS bind (spec P3-1)
		"cycle0_vacuous_all_bases": GameWorld.dmg_cyc(0) == 1.0 \
			and 14.0 < run.MAX_CONTACT_DMG, # the byte-corpus row (F-4)
		"observed_delta_is_clamped": absf(delta - run.MAX_CONTACT_DMG) \
			< 0.001,
	}, {"cycle": 3, "raw_cycle3": raw3, "raw_cycle4": raw4,
		"observed_delta": roundi(delta * 1000.0) / 1000.0,
		"max_contact_dmg": run.MAX_CONTACT_DMG})
	run.queue_free()
