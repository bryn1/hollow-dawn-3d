# World entities + edge-spawn scaling + drops (plan §5 numbers).
# reason: >400 lines — the ONE world module: M1-M4 law keeps the single
#   spawn latch, the single kill funnel and the ONE tier map in one file
#   (splitting them would put drop rules beside a second spawn site). M4
#   grew it 419->548 (event cone, reaper latch, windows, MC 11398 §1.6):
#   the spawn/entity split stays SCHEDULED — the next card growing this
#   file carries it, this header no longer absolves it.
class_name GameWorld
extends RefCounted

const BOSS_AT := 540.0 # "The Hollow Warden" spawns at 9:00
# Two minibosses after the Warden, before the 900 s win (PARITY-ROADMAP rev3
# M1 feature 4 row: "2 minibosses @ t=600, 780"); each spawns exactly once
# through the latch below, same mechanism as BOSS_AT.
const MINIBOSS_AT := [[600.0, "hollow-knight"], [780.0, "hollow-deacon"]]
const HEAL_DROP_CHANCE := 0.015 # Dawnlight drop roll on a normal enemy death
const HEAL_AMOUNT := 8.0 # hp restored, clamped to max_hp
# Chest drop rolls at the kill funnel (M1 feature 4, DA c1 B-3): the Warden
# always drops a chest (1.0 = guaranteed, S5 ~419 shape ref), a miniboss at
# OUR pinned 0.6. Chest OPENING is M1 feature 5; these are the drop consts.
const CHEST_CHANCE_BOSS := 1.0
const CHEST_CHANCE_MINIBOSS := 0.6
const ALIVE_CAP := 400 # M1 hard rule (roadmap §b): spawns PAUSE at the cap in
# the single spawn loop below — no accumulate-then-burst across a kill gap.

# M2 pillar C (MC 11238 T-M2g, M2-SPEC §C.1): the field-merge rule's two consts,
# OUR values — the threshold is a draw-budget tie (well under the 400 horde
# cap, §7's "gem array additionally bounded <= 200"), the batch keeps the fold
# coarse so bulk drops stay rare. VS-FEATURES §S8 shape ref (>400 gems => the
# source folds into one red gem) with OUR numbers and OUR granularity; we never
# lose XP — the fold carries the merged gems' xp SUM (the _merge_gems invariant).
const GEM_MERGE_THRESHOLD := 200
const GEM_MERGE_BATCH := 100

# M2 pillar A (MC 11237 T-M2e, M2-SPEC §A.1): the three capped cycle scalars,
# OUR numbers, in the ONE spawn/damage seams — not a second mechanism beside
# the existing ramp. HP's deep-cycle clamp is the "cannot explode" bound: the
# effective multiplier never exceeds def.hp * HP_EFFECTIVE_MULT_CAP at ANY
# depth (rev-2 P2-2: it binds at cycle 5 near cycle-end, cycles <= 4 never
# clamp — max product 4.3 * 4.0 = 17.2 < 18). Quantity and damage growth
# saturate against the UNTOUCHED existing ceilings (rate 12/s + ALIVE_CAP)
# and main.gd's MAX_CONTACT_DMG. The statics are read by the spawn/damage
# sites AND the sim_endless eval legs — one formula, no copy.
const HP_EFFECTIVE_MULT_CAP := 18.0


static func hp_cyc(cycle: int) -> float:
	return minf(1.0 + 0.75 * cycle, 6.0)


static func qty_cyc(cycle: int) -> float:
	return minf(1.0 + 0.25 * cycle, 2.0)


static func dmg_cyc(cycle: int) -> float:
	return minf(1.0 + 0.20 * cycle, 2.5)


# Within-cycle minute m_c (§A.1 rev-2 P3-1: "waves restart" = the per-minute
# HP/qty RAMP restarts at the boundary, not the composition — biome bands +
# GATES stay keyed to absolute game.time). With cycle 0 (every non-endless
# run, and every committed dump) this is exactly game.time / 60.0, so the
# flag-off path stays byte-stable (F-4).
static func cycle_minute(game: GameState) -> float:
	return (game.time - game.cycle * GameState.WIN_TIME) / 60.0


# Pillar B §B.1 source->tier map, the SINGLE source of truth for chest
# tiers (rev-2 P1: §A.1 defers to this row). LIVE SINCE T-M2t (MC 11239):
# every drop site stamps its tier from THIS map — endless-cycle at the cycle
# clear (T-M2e), warden/miniboss at kill_enemy (T-M2t) — and the A-E4/B-T1
# ACCEPT rows assert the SAME tier from the SAME row (the DA-P1 law). The
# event row stays the §B.1 P4-1 forward-declared reservation (event-waves
# are an excluded pillar — the source cannot fire yet). OUR mapping.
# M3 §3.1 (MC 11284 T-M3b) stage 2/2 of the DECLARED two-stage map re-pin
# (rev-3 F-1/DA-c3): the two end-boss classes join as their own KEYS (the
# boss drop site keys on String(enemy.type)) — choir -> warden tier II,
# ossuary-warden -> dawn tier III; the warden keeps its row BY KEY.
const CHEST_TIER_BY_SOURCE := {"miniboss": "ember", "warden": "warden",
	"endless-cycle": "dawn", "event": "dawn", "stage-item": "ember",
	"cathedral-choir": "warden", "ossuary-warden": "dawn"}

# M3 §1.2 (MC 11282 T-M3s) PRESSURE STAIR consts (ossuary-stair row, OUR
# numbers): dwelling inside a plate's radius bumps the EXISTING spawn-rate
# term by SPAWN_SURGE (INSIDE the untouched minf(12.0) ceiling, and below
# the ALIVE_CAP early-return above it — structurally cannot explode, §7)
# and pins the VISUAL band shift to FLARE_SHIFT s, decaying linearly to the
# base band over FLARE_DECAY s. The dwell is a pure position test on the
# existing _dist pattern — it consumes ZERO randf/randi (A-E4's RNG-stream
# row). Stage rows without plates: surge is the exact 1.0 identity and
# flare stays 0.0 (byte-identical corpus, F-4).
const SPAWN_SURGE := 1.5
const PLATE_RADIUS := 120.0 # px, the shape ref S4 ~386 (our N)
const FLARE_SHIFT := 150.0 # s the band NAME runs ahead (visual only — the
const FLARE_DECAY := 30.0  # sim difficulty key stays the pure clock, F-4)

# M4 pillar A (MC 11362 T-M4e, M4-SPEC §1.1): the event-window surge, OUR
# value — the wall is the bigger moment of the night than a plate's 1.5.
# Same law as SPAWN_SURGE: the event multiplies the EXISTING rate term
# INSIDE the untouched minf(12.0) ceiling and stays BELOW the ALIVE_CAP
# early-return (F-4: event spawns do NOT bypass the cap — the declared
# divergence from THEIRS, VS-FEATURES:421). Fixed windows + fixed cones:
# the clock comparison below consumes ZERO randf/randi (A-E5).
const EVENT_SURGE := 2.0
# The identity spawn cone (F-1, the byte law): the full circle, and the
# CONE-DEFAULT read below is IEEE-EXACT to the shipped `randf() * TAU` —
# 0.0 + x*TAU == x*TAU for every randf() sample (TAU - 0.0 == TAU, +0.0).
const CONE_ALL := [0.0, TAU]

# M4 §2.1 (T-M4r): THE REAPER cadence, OUR value — their per-minute shape
# (VS-FEATURES:423 "one Reaper will arrive every minute ... unless Endless
# is enabled"), OUR number. One named const feeding the arrival latch
# below; the latch gate is a CLOCK COMPARISON that consumes ZERO randf/
# randi with the flag off (the byte law).
const REAPER_PERIOD := 60.0

# Stats + sprite per enemy id (plan §5 classics pinned by the acceptance
# suite; biome signature creatures MC 11082 — sprites mirrored from
# static/assets/enemies/ under res://assets/enemies/). Which ids spawn when:
# BIOMES.enemies in render.gd (band roster) + the GATES rotation below.
const ENEMY_TYPES := {
	"wraith": {"hp": 8.0, "spd": 55.0, "dmg": 2.0, "xp": 1.0, "sprite": "enemy-wraith"},
	"hound": {"hp": 6.0, "spd": 95.0, "dmg": 3.0, "xp": 1.0, "sprite": "enemy-hound"},
	"crawler": {"hp": 30.0, "spd": 35.0, "dmg": 5.0, "xp": 3.0, "sprite": "enemy-crawler"},
	"cultist": {"hp": 18.0, "spd": 60.0, "dmg": 6.0, "xp": 4.0, "sprite": "enemy-cultist"},
	# Band signatures: moor-brute slow+tanky, dune-scarab fast+weak swarmer,
	# rime-ghoul mid, pale-wight hardest (highest hp + damage).
	"moor-brute": {"hp": 26.0, "spd": 32.0, "dmg": 4.0, "xp": 2.0, "sprite": "enemies/moor-brute"},
	"dune-scarab": {"hp": 5.0, "spd": 105.0, "dmg": 2.0, "xp": 1.0, "sprite": "enemies/dune-scarab"},
	"rime-ghoul": {"hp": 18.0, "spd": 60.0, "dmg": 5.0, "xp": 3.0, "sprite": "enemies/rime-ghoul"},
	"pale-wight": {"hp": 45.0, "spd": 52.0, "dmg": 9.0, "xp": 4.0, "sprite": "enemies/pale-wight"},
	# M3 §3.1 (MC 11284 T-M3b): the boss rows field a `name` — the ONE boss-
	# bar readout (hud_3d.gd, retired const); the warden's row carries the
	# old const string VERBATIM so the stage-1 bar paints byte-identically.
	"warden": {"hp": 3000.0, "spd": 45.0, "dmg": 12.0, "xp": 0.0, "sprite": "boss-warden", "boss": true, "name": "THE HOLLOW WARDEN"},
	# Minibosses (M1 feature 4 schedule above): OUR stat rows (the roadmap
	# names the schedule, not the numbers); xp 0 like the Warden — no gem
	# rain off a single kill. Sprites + meshes deliberately reuse the Warden
	# art until the M1 asset batch lands their two static meshes.
	"hollow-knight": {"hp": 900.0, "spd": 50.0, "dmg": 10.0, "xp": 0.0, "sprite": "boss-warden", "miniboss": true},
	"hollow-deacon": {"hp": 1400.0, "spd": 40.0, "dmg": 11.0, "xp": 0.0, "sprite": "boss-warden", "miniboss": true},
	# M4 §1.2 EVENT-MINIBOSSES (MC 11362 T-M4e, OUR ladder: bound between
	# the knight/deacon 900/1400 pair and the choir/ossuary 4200/5600 pair —
	# 1500 carries the sunken wall (stage 2), 2100 the stair (stage 3, the
	# harder gate); dmg 12/13 stay AT the warden/choir ceiling (below the
	# MAX_CONTACT_DMG clamp at cycle 0, F-6); spd drops with size (deacon 40
	# precedent); xp 0 = the boss no-gem-rain rule; the sprite reuses the
	# warden art (the M1 miniboss precedent) while the MESH rides the T-M4a
	# TRELLIS rows: horde_viz GLB_FILES names sunken-prelate.glb /
	# stair-acolyte.glb at the ONE per-class seam. Drops ride the UNTOUCHED
	# source-kind "miniboss" branch (F-3: the ONE CHEST_TIER_BY_SOURCE map
	# stays 7 rows; the §B.1 "event" key stays the reserved forward-decl).
	"sunken-prelate": {"hp": 1500.0, "spd": 44.0, "dmg": 12.0, "xp": 0.0, "sprite": "boss-warden", "miniboss": true},
	"stair-acolyte": {"hp": 2100.0, "spd": 42.0, "dmg": 13.0, "xp": 0.0, "sprite": "boss-warden", "miniboss": true},
	# M3 §3.1 end-bosses (MC 11284, OUR ladder: hp x1.4 -> x1.33, dmg stays
	# below MAX_CONTACT_DMG at cycle 0, spd drops with size — warden 45 /
	# deacon 40 precedent; xp 0 = the boss no-gem-rain rule). Spawn t=540 is
	# the STAGES bosses column (render.gd), not a row field: one timing.
	"cathedral-choir": {"hp": 4200.0, "spd": 42.0, "dmg": 13.0, "xp": 0.0, "sprite": "cathedral-choir", "boss": true, "name": "THE CATHEDRAL CHOIR"},
	"ossuary-warden": {"hp": 5600.0, "spd": 38.0, "dmg": 14.0, "xp": 0.0, "sprite": "ossuary-warden", "boss": true, "name": "THE OSSUARY WARDEN"},
	# M4 §2.1 THE REAPER (MC 11364 T-M4r, the night-flag pursuer): OUR row —
	# the archetype (limit-pursuer), not a clone (roadmap §3). spd 200 > the
	# shipped 196 passive cap (BASE_SPEED 140 x the 5-stack haste,
	# game_state.gd:5/:81), so the flag-ON pursuer is un-outrunnable at the
	# cap; the honest deep-LIMIT bound (c2 F-2: LIMIT·HASTE repeats) is
	# MULTI-reaper pressure + the spawn stamp, not a speed delta — no ACCEPT
	# row claims outrunnability. hp rides the SHIPPED ramp at the arrival
	# tick (the first arrival at 900.017 stamps roundf(50000·(1+0.22·15)·
	# hp_cyc(0)) — "unkillable within the night" reads against the STAMP,
	# not the 50000 def, P4-2). xp 0 = the boss no-gem-rain rule; dmg 30 is
	# never read (F-6: the contact law ENDS the run at main.gd before the
	# damage line, so the 20-clamp never sees it — the test_combat_numbers
	# column re-pin names this row as the clamp's one EXCLUSION, end-law
	# pinned). boss:true buys the 55 px contact radius + the boss bar (the
	# live ENEMY_TYPES name readout paints THE REAPER, M3's hud law); the
	# reaper:true dict flag is the END LAW, read FIRST in the contact loop.
	# The ONLY construction site is the flag-gated arrival latch below — the
	# row can never spawn without the well flag. The sprite reuses the
	# warden art (M1 miniboss precedent) while the MESH rides the T-M4a
	# TRELLIS row: horde_viz GLB_FILES names the-reaper.glb at the ONE
	# per-class seam (heights 5.33 m boss class, the R4 art-fixture row).
	"the-reaper": {"hp": 50000.0, "spd": 200.0, "dmg": 30.0, "xp": 0.0, "sprite": "boss-warden", "boss": true, "reaper": true, "name": "THE REAPER"},
}

# Minute gates at which a swarm type joins the rotation.
const GATES := [[0.0, "wraith"], [2.0, "hound"], [4.0, "crawler"], [6.0, "cultist"]]

var enemies: Array = []
var gems: Array = []
var coins: Array = []
var heals: Array = [] # Dawnlight pickups; +HEAL_AMOUNT hp, clamped to max_hp
var chests: Array = [] # chest DROPS (M1 f4); opening rides collect_pickups (M1 f5)
var spawn_acc := 0.0
# M3 §3.1 (T-M3s): ONE latch index latches the stage row's bosses list in
# schedule order (the STAGES column is the schedule's single source). This
# REPLACES the warden `boss_spawned` bool + the `minibosses_spawned` index
# (same commit, replace-not-delete: the claims those regex pins proved move
# to the sim_stages stage1_schedule dump legs + the journey's boss_once
# rows — see tests/test_boss_numbers.py's retired-and-replaced row notes).
var schedule_spawned := 0
# M4 §1.1 (T-M4e): the stage row's events list, copied per run by
# seed_stage_props below (the SAME per-run stage-prop seam that lands the
# cairns). The copy is the DECLARED-PIN seam the A-E5 digest twin uses
# (window/cone pins, the sim clock/hp-pin precedent) — the table in
# render.gd stays the ONE data source, read at run start exactly like the
# schedule column; stage 1 copies the empty row (F-1: the vigil is inert).
var event_windows: Array = []
# M4 §2.1 (T-M4r): the WORLD-side reaper arrival latch — a reaper count
# reset in reset() below, checked in update_spawns BESIDE the schedule
# latch (the same above-cap placement every named schedule spawn holds:
# no new cap exception, no second loop). n-th arrival gate: game.time >=
# WIN_TIME + REAPER_PERIOD * reaper_spawned (the B-E3 row: 900.017, then
# 960.017, one more per period). Flag off: the gate short-circuits on
# game.reaper before any spawn — the RNG stream of every committed dump
# is byte-unchanged (B-E1).
var reaper_spawned := 0


func reset() -> void:
	enemies.clear()
	gems.clear()
	coins.clear()
	heals.clear()
	chests.clear()
	spawn_acc = 0.0
	schedule_spawned = 0
	reaper_spawned = 0


# M3 §1.2 (T-M3s) DROWNED CAIRNS (sunken-chapel row): static seeding of the
# stage row's cairn coords onto the ONE existing chest array — the chest
# viz, touch-open and reward funnel all ride unchanged (no 5th pickup kind,
# no second drop funnel). The tier stamps from THE MAP, the new
# "stage-item" row (the A-E3 tier-from-map law, single source; value ember,
# the same value the select card promises — §6 promise==deliver). Zero RNG:
# fixed table coords, no rolls (A-E3's RNG-stream row). Plates are NOT
# seeded here — they are static GROUND rows read by the plate logic below.
# §1.2 (T-M3s): the cairns are literally chests (the spec's own words) —
# the table's coord rows ride the SAME comparison space the shipped funnel
# already uses (the spec calls that funnel "16 px", world.gd:355 — the spec
# "px" IS world.gd's numeric space, no second unit convention; the camera
# divides world units by PX_PER_M at draw time exactly as it does for every
# other position, so no conversion exists HERE either).
func seed_stage_props(game: GameState) -> void:
	for c in GameRenderer.stage_row(game.stage).cairns:
		chests.append({"x": c[0], "y": c[1],
			"tier": CHEST_TIER_BY_SOURCE["stage-item"]})
	# M4 §1.1 (T-M4e): the events row lands as this run's window list (see
	# the var note above); a static copy — ZERO RNG (A-E3's stream law).
	event_windows = GameRenderer.stage_row(game.stage).events


# Enemy set open at time t (MC 11082): the STAGE's band roster at t
# (M3 §1.1: band_at(stage, t) — stage 1 reads the shipped BIOMES walk
# byte-identically) plus the classic gate rotation (GATES, minutes).
# One merged set; the single spawn loop in update_spawns draws from it.
func _types_open(stage_id: String, t: float) -> Array:
	var open: Array = GameRenderer.band_at(stage_id, t).enemies.duplicate()
	for gate in GATES:
		if t >= gate[0] * 60.0 and not open.has(gate[1]):
			open.append(gate[1])
	return open


func _spawn_ring(view: Vector2) -> float:
	return view.length() / 2.0 + 40.0


func _spawn_enemy(type_key: String, game: GameState, view: Vector2,
		cone: Array = CONE_ALL) -> void:
	var def: Dictionary = ENEMY_TYPES[type_key]
	# M4 §1.1 (T-M4e): the optional CONE parameter — the default read below
	# is IEEE-EXACT the shipped `randf() * TAU` (CONE_ALL = [0.0, TAU]:
	# float(0.0) + randf() * (float(TAU) - float(0.0)) == randf() * TAU:
	# TAU - 0.0 == TAU, 0.0 + x == x, every sample, F-1 byte law). An event
	# window narrows the arc; the single randf() per spawn is UNCHANGED —
	# geometry consumes, never a second draw (A-E5's zero-RNG law).
	var angle: float = float(cone[0]) + randf() * (float(cone[1]) - float(cone[0]))
	var r := _spawn_ring(view)
	# §A.1 cycle scaling on the ONE existing ramp term: cycle-local minute
	# (m_c) rides the M1 per-minute term verbatim, HP_CYC multiplies it, and
	# the single HP_EFFECTIVE_MULT_CAP clamp below is the deep-cycle bound.
	# cycle 0: hp_cyc = 1.0 (exact float identity) and the clamp is vacuous
	# (ramp max 4.3 < 18), so flag-off spawns stay byte-stable.
	var hp := roundf(def.hp * (1.0 + 0.22 * cycle_minute(game)) * hp_cyc(game.cycle))
	hp = minf(hp, def.hp * HP_EFFECTIVE_MULT_CAP)
	enemies.append({
		"type": type_key,
		"x": game.player.x + cos(angle) * r,
		"y": game.player.y + sin(angle) * r,
		"hp": hp,
		"max_hp": hp,
		"spd": def.spd,
		"dmg": def.dmg,
		"xp": def.xp,
		"boss": def.get("boss", false),
		"miniboss": def.get("miniboss", false),
		# M4 §2.1 (T-M4r): the END-LAW flag the contact loop reads FIRST
		# (main.gd) — the same def.get idiom as the boss/miniboss flags.
		"reaper": def.get("reaper", false),
		"sprite": def.sprite,
		"hit_cd": 0.0, # per-enemy cooldown for lingering damage sources
	})


func update_spawns(dt: float, game: GameState, view: Vector2) -> void:
	# M3 §3.1 (T-M3s): the ONE latch-index loop over the stage row's bosses
	# list. The stage-1 row IS the shipped BOSS_AT/MINIBOSS_AT schedule
	# (§1.1), so the spawn order/RNG stream is byte-identical: same tick,
	# same entry, latch first. The warden/miniboss latches this retires are
	# the declared replace-not-delete pair (see schedule_spawned's header).
	var sched: Array = GameRenderer.stage_bosses(game.stage)
	while schedule_spawned < sched.size() \
			and game.time >= sched[schedule_spawned][0]:
		var b: Array = sched[schedule_spawned]
		# A stage's boss row IS the boss: the id lands in ENEMY_TYPES with
		# its own card (M3-SPEC §3.1 — T-M3b fields cathedral-choir +
		# ossuary-warden). While a row's id has no stats row the schedule
		# DEFERS (no latch, no crash, no silent no-op): stages 2/3 are
		# unlockable mid-spine, and master must stay runnable between the
		# serial spine's cards. Stage 1's rows are all shipped ids — the
		# has() test consumes zero RNG and never holds (byte corpus).
		if not ENEMY_TYPES.has(String(b[1])):
			break
		schedule_spawned += 1 # latch first: the schedule fires each once
		_spawn_enemy(b[1], game, view)
	# M4 §2.1 REAPER ARRIVAL (T-M4r): BESIDE the schedule latch above and
	# therefore ABOVE the cap early-return BY POSITION — the same above-cap
	# placement every named schedule spawn already holds (no new cap
	# exception, no second loop; the pursuer must not stall behind a full
	# field — it IS the run's end law, main.gd's contact arm). Gate:
	# game.reaper and not game.endless (the VS-FEATURES:423 "unless
	# Endless" precedence, mirrored by the endless-first elif ORDER of the
	# cap fork in main.gd — B-E4) + the clock n-th-arrival comparison
	# (ZERO randf/randi at the gate itself, the A-E5 idiom; the spawn
	# below rides the SAME _spawn_enemy funnel, full circle, default cone
	# CONE_ALL — no cone for the pursuer). Flag off: short-circuit, the
	# RNG stream of every committed dump is byte-unchanged (B-E1).
	while game.reaper and not game.endless \
			and game.time >= GameState.WIN_TIME + REAPER_PERIOD * reaper_spawned:
		reaper_spawned += 1 # latch first: one arrival per period
		_spawn_enemy("the-reaper", game, view)
	# M3 §1.2 plate logic (see the consts): decay first, dwell re-sets the
	# shift -> inside a plate flare pins at exactly FLARE_SHIFT; zero RNG.
	# Stage 1 / plate-less rows: flare stays the exact 0.0 it was, surge the
	# exact 1.0 identity (byte corpus, F-4).
	game.flare = maxf(0.0, game.flare - FLARE_SHIFT / FLARE_DECAY * dt)
	var surge := 1.0
	for pl in GameRenderer.stage_row(game.stage).plates:
		if _dist({"x": pl[0], "y": pl[1]}, game.player) < PLATE_RADIUS:
			surge = SPAWN_SURGE
			game.flare = FLARE_SHIFT
	# M4 §1.1 EVENT WINDOWS (T-M4e, the sunken-tide / stair-wall rows): next
	# to the plate loop, the SAME shape — fixed geometry read from the run's
	# copied row, ZERO randf/randi consumed by the selection (the A-E5 law;
	# a clock comparison only, the plate dwell is the shipped precedent).
	# Inside t in [t0, t1): surge takes maxf(surge, EVENT_SURGE) (BELOW the
	# cap return: event spawns do NOT bypass ALIVE_CAP, F-4) and the horde
	# spawns for the window draw inside the row's cone. Row = [t0, t1,
	# center_deg, width_deg] -> cone [(c-w/2), (c+w/2)] rad; stage 3's
	# 0°-centered row reads negative, which sin/cos take unchanged.
	var cone: Array = CONE_ALL
	for ev in event_windows:
		if game.time >= float(ev[0]) and game.time < float(ev[1]):
			surge = maxf(surge, EVENT_SURGE)
			var half := float(ev[3]) * 0.5
			cone = [deg_to_rad(float(ev[2]) - half),
				deg_to_rad(float(ev[2]) + half)]
	if enemies.size() >= ALIVE_CAP:
		return # M1 hard rule: PAUSE the horde loop at the cap — no rate
		# accumulation either, so kills never burst-refill the queue
	# §A.1: cycle-local minute + QTY_CYC on the existing rate term; the
	# minf(12.0, …) ceiling stays UNTOUCHED (§A.1 "cannot explode": quantity
	# growth saturates against it + ALIVE_CAP above). cycle 0: qty_cyc = 1.0
	# exact and m_c = game.time/60 — flag-off byte-stable. M3 §1.2: the
	# plate surge multiplies the SAME term INSIDE the ceiling (1.0 identity
	# everywhere else — IEEE-exact, the endless fixture stays byte-equal).
	var minute := cycle_minute(game)
	spawn_acc += minf(12.0, (1.0 + 1.3 * minute) * qty_cyc(game.cycle) * surge) * dt
	var open := _types_open(game.stage, game.time)
	while spawn_acc >= 1.0:
		spawn_acc -= 1.0
		# M4: the horde draw rides the cone above — CONE_ALL outside every
		# window (stage-1 rows: the loop never runs, identity byte path).
		_spawn_enemy(open[randi() % open.size()], game, view, cone)


# Swarmers home in on the survivor; gems magnet within Grip-scaled radius.
func update_entities(dt: float, game: GameState) -> void:
	var p: Dictionary = game.player
	for e in enemies:
		var dx: float = p.x - e.x
		var dy: float = p.y - e.y
		var d := maxf(sqrt(dx * dx + dy * dy), 1.0)
		e.x += dx / d * e.spd * dt
		e.y += dy / d * e.spd * dt
		if e.hit_cd > 0.0:
			e.hit_cd -= dt
	var magnet: float = 60.0 * (1.0 + 0.25 * game.passives.grip)
	# Loadstone (feature-6 partner, T-M1h): +25% of the base magnet per
	# stack, OWN term on the SAME magnet seam (the grip line is a byte-pin).
	magnet += 15.0 * float(game.passives["loadstone"])
	_magnetize(gems, p, magnet, dt)
	_magnetize(heals, p, magnet, dt)
	if p.iframes > 0.0:
		p.iframes -= dt
	# §C.1 field-merge rides this ONE entity update, after the drop (the drop
	# happens in kill_enemy between two updates): the merge check runs every
	# tick, so the array leaves this seam at <= GEM_MERGE_THRESHOLD (the C-G3
	# observation point; a same-tick kill burst can transiently sit above the
	# threshold and is folded at the next update — stated reading).
	_merge_gems()


# Grip-scaled pull shared by every magnetised pickup kind (gems + Dawnlight).
func _magnetize(items: Array, p: Dictionary, magnet: float, dt: float) -> void:
	for g in items:
		var gx: float = p.x - g.x
		var gy: float = p.y - g.y
		var gd := maxf(sqrt(gx * gx + gy * gy), 1.0)
		if gd < magnet:
			g.x += gx / gd * 220.0 * dt
			g.y += gy / gd * 220.0 * dt


# §C.1 field-merge: at the threshold the OLDEST GEM_MERGE_BATCH gems (append
# order = drop order, so the array head) fold into ONE bulk gem at their
# centroid carrying the SUM of their xp plus big:true (the ONE flag
# pickup_viz.gd reads for the larger+brighter draw). The gem-array Σxp is
# UNCHANGED across the fold — the unconditional XP-neutrality invariant
# (rev-2 P2-4); the sum accumulates head-to-tail so the bulk's xp is a fixed
# float result, independent of the fold's position in the tick. The bulk gem
# is the same dict kind riding the same array: no new pickup kind, the magnet
# path and the 16 px collect funnel below eat it like any gem.
func _merge_gems() -> void:
	if gems.size() < GEM_MERGE_THRESHOLD:
		return
	var cx := 0.0
	var cy := 0.0
	var sxp := 0.0
	for i in GEM_MERGE_BATCH:
		cx += gems[i].x
		cy += gems[i].y
		sxp += gems[i].xp
	for i in range(GEM_MERGE_BATCH - 1, -1, -1):
		gems.remove_at(i) # the oldest BATCH entries, tail-first (stable head)
	gems.append({"x": cx / GEM_MERGE_BATCH, "y": cy / GEM_MERGE_BATCH,
		"xp": sxp, "big": true})


# M2 §A.1 cycle clear: the clear's ONE drop through the single drop array,
# tier from CHEST_TIER_BY_SOURCE's endless-cycle row (dawn = tier III — the
# A-E4 / B-T1 single-source row, rev-2 P1). Rides the existing chest array +
# the 16 px collect/open funnel (pickup_viz draws it; no new kind, the
# test_biome_numbers 4-kind pin holds).
func cycle_clear(game: GameState) -> void:
	chests.append({"x": game.player.x, "y": game.player.y,
		"tier": CHEST_TIER_BY_SOURCE["endless-cycle"]})


# Death payout: ~70% gem, 6% coin (1-3g); the Warden adds +50 gold.
# Dawnlight heal: 1.5% roll on any death, guaranteed once from a boss.
# Chest drop: boss 1.0 / miniboss CHEST_CHANCE_MINIBOSS (M1 f4 rows).
func kill_enemy(game: GameState, enemy: Dictionary) -> void:
	var i := enemies.find(enemy)
	if i >= 0:
		enemies.remove_at(i)
	game.kills += 1
	# M4 §2.1 DEATH GUARD (T-M4r, B-E6): a reaper death pays NOTHING — no
	# chest roll (the ONE CHEST_TIER_BY_SOURCE stays 7 rows, F-3: a keyed
	# read of "the-reaper" would be the missing-key SOFT-null that appends
	# a phantom null-tier chest — the map-bypass law, first EXECUTED
	# evidence rides the sim_reaper zero-drop-array-delta leg), no +50
	# boss bounty at :347, no coin/heal rolls; `xp: 0` already means no
	# gem. The kill counts; the drop arrays stay untouched. Planted
	# removal RED-proves the delta leg (capture .tmp/m4r-reaper.txt).
	if enemy.get("reaper", false):
		return
	if enemy.boss:
		game.gold += 50
	if enemy.xp > 0.0 and randf() < 0.7:
		gems.append({"x": enemy.x, "y": enemy.y, "xp": enemy.xp})
	if randf() < 0.06:
		coins.append({"x": enemy.x, "y": enemy.y, "gold": 1 + randi() % 3})
	if enemy.boss or randf() < HEAL_DROP_CHANCE:
		heals.append({"x": enemy.x, "y": enemy.y})
	# T-M2t §B.1: every drop carries its tier FROM THE MAP at the drop site
	# (kill_enemy = the boss/miniboss sources; cycle_clear above = endless-
	# cycle; the event row stays the §B.1 P4-1 forward-declared reservation).
	# Strict map lookup: a bypassed source crashes at the drop, never silently
	# de-tiered (the map-bypass planted-red rides this). M3 §3.1 P2-1: the
	# boss line is keyed BY THE KILLED TYPE (String(enemy.type)) — the one
	# literal "warden" site is retired, every boss class reads its own map
	# row (the warden lands on the same "warden" row BY KEY, byte-identical).
	if enemy.boss and randf() < CHEST_CHANCE_BOSS:
		chests.append({"x": enemy.x, "y": enemy.y,
			"tier": CHEST_TIER_BY_SOURCE[String(enemy.type)]})
	elif enemy.miniboss and randf() < CHEST_CHANCE_MINIBOSS:
		chests.append({"x": enemy.x, "y": enemy.y,
			"tier": CHEST_TIER_BY_SOURCE["miniboss"]})


# Consume pickups inside touch range; returns gold picked up this step.
func collect_pickups(game: GameState) -> int:
	var gold := 0
	for i in range(gems.size() - 1, -1, -1):
		var g: Dictionary = gems[i]
		if _dist(g, game.player) < 16.0:
			gems.remove_at(i)
			game.add_xp(g.xp)
	for i in range(coins.size() - 1, -1, -1):
		var c: Dictionary = coins[i]
		if _dist(c, game.player) < 16.0:
			coins.remove_at(i)
			gold += c.gold
	for i in range(heals.size() - 1, -1, -1):
		var h: Dictionary = heals[i]
		if _dist(h, game.player) < 16.0:
			heals.remove_at(i) # consumed even at full hp — never a wasted item
			game.hp = minf(game.max_hp, game.hp + HEAL_AMOUNT)
	# Chest OPENING (M1 feature 5): the same 16 px touch funnel. The M2 §B.1
	# OPEN ORDER is exactly three lines: the ONE transform first (evolutions
	# fire at OPEN time, the gate reads game.time here; since T-M2u the
	# union pillar holds the try_union-else-try_evolve precedence slot at
	# THIS site), then the tier cards + the gold line, both owned
	# by chest_rewards.gd — the cards ride the frozen pending_levels ->
	# _enter_levelup seam (each is one 3-card offer, the per-offer reward
	# kind pops the game.reward_kinds FIFO), the gold roll returns raw and
	# enters the run through the ONE credit_gold funnel below (roadmap
	# feature 5 phase decision, DA c1 A-2: the enum
	# menu|playing|levelup|gameover|win is untouched).
	for i in range(chests.size() - 1, -1, -1):
		var c: Dictionary = chests[i]
		if _dist(c, game.player) < 16.0:
			chests.remove_at(i)
			# T-M2u landed: union precedence > evolution (§D) — a chest
			# performs the UNION when eligible, else the evolution (still
			# exactly ONE weapon-transform per chest).
			if UnionSystem.try_union(game) == "":
				EvolutionSystem.try_evolve(game)
			gold += ChestRewards.grant(game, c)
	# The meta gold-rate (T-M1f) rides the ONE pickup funnel: collected raw
	# gold enters the run only through GameState.credit_gold — identity with
	# no ranks bought, so every pre-shop dump byte stays identical.
	return game.credit_gold(gold)


static func _dist(a: Dictionary, b: Dictionary) -> float:
	var dx: float = a.x - b.x
	var dy: float = a.y - b.y
	return sqrt(dx * dx + dy * dy)
