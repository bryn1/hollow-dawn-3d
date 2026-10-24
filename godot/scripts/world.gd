# World entities + edge-spawn scaling + drops (plan §5 numbers).
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
const CHEST_TIER_BY_SOURCE := {"miniboss": "ember", "warden": "warden",
	"endless-cycle": "dawn", "event": "dawn"}

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
	"warden": {"hp": 3000.0, "spd": 45.0, "dmg": 12.0, "xp": 0.0, "sprite": "boss-warden", "boss": true},
	# Minibosses (M1 feature 4 schedule above): OUR stat rows (the roadmap
	# names the schedule, not the numbers); xp 0 like the Warden — no gem
	# rain off a single kill. Sprites + meshes deliberately reuse the Warden
	# art until the M1 asset batch lands their two static meshes.
	"hollow-knight": {"hp": 900.0, "spd": 50.0, "dmg": 10.0, "xp": 0.0, "sprite": "boss-warden", "miniboss": true},
	"hollow-deacon": {"hp": 1400.0, "spd": 40.0, "dmg": 11.0, "xp": 0.0, "sprite": "boss-warden", "miniboss": true},
}

# Minute gates at which a swarm type joins the rotation.
const GATES := [[0.0, "wraith"], [2.0, "hound"], [4.0, "crawler"], [6.0, "cultist"]]

var enemies: Array = []
var gems: Array = []
var coins: Array = []
var heals: Array = [] # Dawnlight pickups; +HEAL_AMOUNT hp, clamped to max_hp
var chests: Array = [] # chest DROPS (M1 f4); opening rides collect_pickups (M1 f5)
var spawn_acc := 0.0
var boss_spawned := false
var minibosses_spawned := 0 # latches MINIBOSS_AT in schedule order, once each


func reset() -> void:
	enemies.clear()
	gems.clear()
	coins.clear()
	heals.clear()
	chests.clear()
	spawn_acc = 0.0
	boss_spawned = false
	minibosses_spawned = 0


# Enemy set open at time t (MC 11082): the biome band's own roster
# (BIOMES.enemies via the one biome_at() helper — wraith in every band + the
# band's signature creature) plus the classic gate rotation (GATES, minutes).
# One merged set; the single spawn loop in update_spawns draws from it.
func _types_open(t: float) -> Array:
	var open: Array = GameRenderer.biome_at(t).enemies.duplicate()
	for gate in GATES:
		if t >= gate[0] * 60.0 and not open.has(gate[1]):
			open.append(gate[1])
	return open


func _spawn_ring(view: Vector2) -> float:
	return view.length() / 2.0 + 40.0


func _spawn_enemy(type_key: String, game: GameState, view: Vector2) -> void:
	var def: Dictionary = ENEMY_TYPES[type_key]
	var angle := randf() * TAU
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
		"sprite": def.sprite,
		"hit_cd": 0.0, # per-enemy cooldown for lingering damage sources
	})


func update_spawns(dt: float, game: GameState, view: Vector2) -> void:
	if not boss_spawned and game.time >= BOSS_AT:
		boss_spawned = true
		_spawn_enemy("warden", game, view)
	while minibosses_spawned < MINIBOSS_AT.size() \
			and game.time >= MINIBOSS_AT[minibosses_spawned][0]:
		var mb: Array = MINIBOSS_AT[minibosses_spawned]
		minibosses_spawned += 1 # latch first: the schedule fires once each
		_spawn_enemy(mb[1], game, view)
	if enemies.size() >= ALIVE_CAP:
		return # M1 hard rule: PAUSE the horde loop at the cap — no rate
		# accumulation either, so kills never burst-refill the queue
	# §A.1: cycle-local minute + QTY_CYC on the existing rate term; the
	# minf(12.0, …) ceiling stays UNTOUCHED (§A.1 "cannot explode": quantity
	# growth saturates against it + ALIVE_CAP above). cycle 0: qty_cyc = 1.0
	# exact and m_c = game.time/60 — flag-off byte-stable.
	var minute := cycle_minute(game)
	spawn_acc += minf(12.0, (1.0 + 1.3 * minute) * qty_cyc(game.cycle)) * dt
	var open := _types_open(game.time)
	while spawn_acc >= 1.0:
		spawn_acc -= 1.0
		_spawn_enemy(open[randi() % open.size()], game, view)


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
	# de-tiered (the map-bypass planted-red rides this).
	if enemy.boss and randf() < CHEST_CHANCE_BOSS:
		chests.append({"x": enemy.x, "y": enemy.y,
			"tier": CHEST_TIER_BY_SOURCE["warden"]})
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
	# fire at OPEN time, the gate reads game.time here; the union pillar's
	# try_union takes its try_union-else-try_evolve precedence slot at THIS
	# site when T-M2u lands), then the tier cards + the gold line, both owned
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
