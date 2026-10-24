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
	var hp := roundf(def.hp * (1.0 + 0.22 * (game.time / 60.0)))
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
	var minute := game.time / 60.0
	spawn_acc += minf(12.0, 1.0 + 1.3 * minute) * dt
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


# Grip-scaled pull shared by every magnetised pickup kind (gems + Dawnlight).
func _magnetize(items: Array, p: Dictionary, magnet: float, dt: float) -> void:
	for g in items:
		var gx: float = p.x - g.x
		var gy: float = p.y - g.y
		var gd := maxf(sqrt(gx * gx + gy * gy), 1.0)
		if gd < magnet:
			g.x += gx / gd * 220.0 * dt
			g.y += gy / gd * 220.0 * dt


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
	if enemy.boss and randf() < CHEST_CHANCE_BOSS:
		chests.append({"x": enemy.x, "y": enemy.y})
	elif enemy.miniboss and randf() < CHEST_CHANCE_MINIBOSS:
		chests.append({"x": enemy.x, "y": enemy.y})


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
	# Chest OPENING (M1 feature 5): the same 16 px touch funnel. Opening
	# runs the ONE evolution rule first (evolutions fire at OPEN time, the
	# gate reads game.time here), then grants ONE reward card by riding the
	# frozen levelup pause phase — the same pending_levels -> _enter_levelup
	# seam a level-up rides; the exhausted-pool fallback stays the ONE
	# bonus_card (gold) mechanism, ours (roadmap feature 5 phase decision,
	# DA c1 A-2: the enum menu|playing|levelup|gameover|win is untouched).
	for i in range(chests.size() - 1, -1, -1):
		var c: Dictionary = chests[i]
		if _dist(c, game.player) < 16.0:
			chests.remove_at(i)
			EvolutionSystem.try_evolve(game)
			game.pending_levels += 1
	# The meta gold-rate (T-M1f) rides the ONE pickup funnel: collected raw
	# gold enters the run only through GameState.credit_gold — identity with
	# no ranks bought, so every pre-shop dump byte stays identical.
	return game.credit_gold(gold)


static func _dist(a: Dictionary, b: Dictionary) -> float:
	var dx: float = a.x - b.x
	var dy: float = a.y - b.y
	return sqrt(dx * dx + dy * dy)
