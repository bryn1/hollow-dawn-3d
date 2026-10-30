# The drop/pickup half of the world — kill-funnel rolls, the ONE magnet seam,
# the gem fold, the touch-collect funnel, and the M6 Riven Sigil counter-drop.
# This file is the NAMED partition the world.gd SCHEDULED split finally made
# at T-M6d (MC 11675, M6-SPEC §0 F-10 citing audit-2/§F-10): "the drop/pickup
# concern (kill_enemy rolls + drop consts + sigil array/touch/consume +
# _magnetize + _merge_gems) moves OUT to a new drops.gd (class Drops); world.gd
# keeps the call-through (kill_enemy stays the ONE funnel entry — every caller
# unchanged)". The spawn/entity law — the single spawn latch, the kill-funnel
# ENTRY, the ONE tier map, ENEMY_TYPES/GATES and the entity arrays — stays in
# world.gd; this module is bound to it (the WeaponSystem.bind pattern) and
# reads/writes the world's pickup arrays through that one reference.
# VERBATIM-MOVE LAW (the split commit): the moved bodies are the shipped
# logic, zero edits — a byte-diff review shows mechanical `_world.` prefixes
# and the const moves only. The CHEST-ARM LINE (try_union-else-try_evolve)
# moved HERE verbatim and STAYS until T-M6p removes it (the cross-card
# honesty row, M6-SPEC §3.5/§4.4 R5: "T-M6d moves the line VERBATIM first,
# T-M6p removes it").
# M6 F6 (M6-SPEC §4.2, owner ruling 2026-10-29 "2. Rec."): the Doom Sigil's
# screen-clear retires WEAPON-SIDE (weapons.gd, pool 16→15, kinds 32→31 —
# NF-8: that also cuts the evolution table 10→9 at T-M6p) and rides HERE as
# the RIVEN SIGIL rare counter-drop: a dedicated Drops.sigil_kills non-boss,
# non-miniboss counter (NF-5: a sigil that one-shots its own chest drop is
# degenerate — minibosses carry the counter nothing), incremented AFTER the
# reaper death-guard inside the ONE kill funnel — never a game.kills read
# (game.kills counts the reaper too; a stale mid-capture read could never
# contradict it), never a snapshot field (F-3: the 12-field pin at
# sim_stages.gd:164 + test_endless A-E6 stay armed). Every SIGIL_EVERY_KILLS-th
# counted kill drops ONE sigil AT THE KILL LOCATION. The counter consumes
# ZERO RNG: every gem/coin/heal/chest roll keeps its RNG-stream position
# byte-identical (SD-E2's tap-free twin, executed not argued).
class_name Drops
extends RefCounted

const HEAL_DROP_CHANCE := 0.015 # Dawnlight drop roll on a normal enemy death
const HEAL_AMOUNT := 8.0 # hp restored, clamped to max_hp
# Chest drop rolls at the kill funnel (M1 feature 4, DA c1 B-3): the Warden
# always drops a chest (1.0 = guaranteed, S5 ~419 shape ref), a miniboss at
# OUR pinned 0.6. Chest OPENING is M1 feature 5; these are the drop consts.
const CHEST_CHANCE_BOSS := 1.0
const CHEST_CHANCE_MINIBOSS := 0.6

# M2 pillar C (MC 11238 T-M2g, M2-SPEC §C.1): the field-merge rule's two consts,
# OUR values — the threshold is a draw-budget tie (well under the 400 horde
# cap, §7's "gem array additionally bounded <= 200"), the batch keeps the fold
# coarse so bulk drops stay rare. VS-FEATURES §S8 shape ref (>400 gems => the
# source folds into one red gem) with OUR numbers and OUR granularity; we never
# lose XP — the fold carries the merged gems' xp SUM (the merge_gems invariant).
const GEM_MERGE_THRESHOLD := 200
const GEM_MERGE_BATCH := 100

# M6 F6 (MC 11675): RIVEN SIGIL cadence — OUR value, the one named const.
# A drop is deterministic on the counter (ZERO RNG — the SD-E2 tap-free law):
# "every 750th non-boss kill" is observable, counter-pin + exact-750th leg +
# 1499/1501 edges + a boss/miniboss/reaper-interleaved twin (the sim_boss
# CHEST ROLL LEG pattern, sim_combat's sigil legs).
const SIGIL_EVERY_KILLS := 750

# Riven Sigil field instances — the 5th pickup kind on the ONE touch funnel.
# World-side run state BESIDE the drop arrays (reset() below, the drop-array
# law; NOT game.kills, NOT a snapshot field — the SD-E2 pin family).
var sigils: Array = []
# The dedicated counter (run state, reset per run — never derived from
# game.kills, which counts the reaper).
var sigil_kills := 0
# The ONE ring-FX seam for the clear mark: bound to the WeaponSystem's shipped
# `rings` array (weapon-side retirement MOVED the clear moment here; the ring
# dict is the retired doom-sigil arm's own byte shape r 760 / life 0.5 — the
# existing rings class, no new FX mechanism).
var fx_rings: Array = []

var _world: GameWorld


func bind(world: GameWorld) -> void:
	_world = world


# Called from WeaponSystem.bind (main.gd untouched — the wiring rides the
# shipped bind call): the sigil clear marks itself with ONE big ring through
# the shipped rings transient. An UNBOUND fx_rings (bare GameWorld.new() in a
# sim leg that never binds weapons) keeps the mark inert, never a crash.
func bind_fx(rings: Array) -> void:
	fx_rings = rings


func reset() -> void:
	sigils.clear()
	sigil_kills = 0


# The drop rolls of the ONE kill funnel — world.kill_enemy (the funnel ENTRY,
# entity removal + game.kills) calls through here every kill; every caller of
# the funnel is unchanged (F-10). Body moved VERBATIM from world.gd.
func roll(game: GameState, enemy: Dictionary) -> void:
	# M4 §2.1 DEATH GUARD (T-M4r, B-E6): a reaper death pays NOTHING — no
	# chest roll (the ONE CHEST_TIER_BY_SOURCE stays 7 rows, F-3: a keyed
	# read of "the-reaper" would be the missing-key SOFT-null that appends
	# a phantom null-tier chest — the map-bypass law, first EXECUTED
	# evidence rides the sim_reaper zero-drop-array-delta leg), no +50
	# boss bounty, no coin/heal rolls; `xp: 0` already means no gem. The
	# kill counts; the drop arrays stay untouched. Planted removal
	# RED-proves the delta leg (capture .tmp/m4r-reaper.txt).
	if enemy.get("reaper", false):
		return
	# M6 F6 COUNTER (SD-E2): incremented HERE, after the reaper guard, on
	# NON-boss AND non-miniboss kills only (NF-5 — the §4.4 R4 fold-collision
	# twin: bosses AND minibosses exclude, exactly the same predicate set the
	# clear below spares; the event-minibosses sunken-prelate/stair-acolyte
	# carry miniboss:true and ride the exclusion). ZERO RNG: no randf/
	# randi before, inside or after the increment — every gem/coin/heal/
	# chest roll below keeps its exact position in the RNG stream (the
	# tap-free twin leg executes the identity; planted tap RED-proves it).
	if not enemy.boss and not enemy.miniboss:
		sigil_kills += 1
		if sigil_kills % SIGIL_EVERY_KILLS == 0:
			sigils.append({"x": enemy.x, "y": enemy.y})
	if enemy.boss:
		game.gold += 50
	if enemy.xp > 0.0 and randf() < 0.7:
		_world.gems.append({"x": enemy.x, "y": enemy.y, "xp": enemy.xp})
	if randf() < 0.06:
		_world.coins.append({"x": enemy.x, "y": enemy.y,
			"gold": 1 + randi() % 3})
	if enemy.boss or randf() < HEAL_DROP_CHANCE:
		_world.heals.append({"x": enemy.x, "y": enemy.y})
	# T-M2t §B.1: every drop carries its tier FROM THE MAP at the drop site
	# (roll = the boss/miniboss sources; world.cycle_clear = endless-cycle;
	# the event row stays the §B.1 P4-1 forward-declared reservation).
	# Strict map lookup: a bypassed source crashes at the drop, never silently
	# de-tiered (the map-bypass planted-red rides this). M3 §3.1 P2-1: the
	# boss line is keyed BY THE KILLED TYPE (String(enemy.type)) — the one
	# literal "warden" site is retired, every boss class reads its own map
	# row (the warden lands on the same "warden" row BY KEY, byte-identical).
	if enemy.boss and randf() < CHEST_CHANCE_BOSS:
		_world.chests.append({"x": enemy.x, "y": enemy.y,
			"tier": GameWorld.CHEST_TIER_BY_SOURCE[String(enemy.type)]})
	elif enemy.miniboss and randf() < CHEST_CHANCE_MINIBOSS:
		_world.chests.append({"x": enemy.x, "y": enemy.y,
			"tier": GameWorld.CHEST_TIER_BY_SOURCE["miniboss"]})


# Grip-scaled pull shared by every magnetised pickup kind (M6 F5, M6-SPEC §5:
# the magnet source stays ONE — the grip line is its ONLY read, loadstone the
# ONE additive term — and the coin set JOINS the kinds it moves). Moved with
# the pickup concern per §0 F-10; the call-through at world.update_entities is
# unchanged (§5.1) and main.gd is untouched. Coins pull at the SHIPPED gem/heal
# value 220 px/s — no new constant; the sigil is NOT magnetised (§5.1: a
# magnet that clears the screen is a bomb — touch-only, MG-E2's named set).
func magnetize(game: GameState, dt: float) -> void:
	var p: Dictionary = game.player
	var magnet: float = 60.0 * (1.0 + 0.25 * game.passives.grip)
	# Loadstone (feature-6 partner, T-M1h): +25% of the base magnet per
	# stack, OWN term on the SAME magnet seam (the grip line is a byte-pin).
	magnet += 15.0 * float(game.passives["loadstone"])
	_magnetize(_world.gems, p, magnet, dt)
	_magnetize(_world.heals, p, magnet, dt)
	_magnetize(_world.coins, p, magnet, dt) # M6 F5: the coin kind joins the
	# ONE source — zero RNG, values/touch/rates untouched; it joins at the
	# tail so gems/heals keep their shipped per-tick order (byte-minimal).


# Grip-scaled pull shared by every magnetised pickup item list (moved VERBATIM
# from world.gd; the coin call above is this same function, no twin).
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
func merge_gems() -> void:
	if _world.gems.size() < GEM_MERGE_THRESHOLD:
		return
	var cx := 0.0
	var cy := 0.0
	var sxp := 0.0
	for i in GEM_MERGE_BATCH:
		cx += _world.gems[i].x
		cy += _world.gems[i].y
		sxp += _world.gems[i].xp
	for i in range(GEM_MERGE_BATCH - 1, -1, -1):
		_world.gems.remove_at(i) # the oldest BATCH entries, tail-first (stable head)
	_world.gems.append({"x": cx / GEM_MERGE_BATCH, "y": cy / GEM_MERGE_BATCH,
		"xp": sxp, "big": true})


# Consume pickups inside touch range; returns gold picked up this step.
# (M6 F6:) the RIVEN SIGIL is the 5th kind on this ONE funnel — 16 px touch
# like every kind, touch-ONLY (never magnetised), ONE touch = ONE clear.
func collect_pickups(game: GameState) -> int:
	var gold := 0
	for i in range(_world.gems.size() - 1, -1, -1):
		var g: Dictionary = _world.gems[i]
		if GameWorld._dist(g, game.player) < 16.0:
			_world.gems.remove_at(i)
			game.add_xp(g.xp)
	for i in range(_world.coins.size() - 1, -1, -1):
		var c: Dictionary = _world.coins[i]
		if GameWorld._dist(c, game.player) < 16.0:
			_world.coins.remove_at(i)
			gold += c.gold
	for i in range(_world.heals.size() - 1, -1, -1):
		var h: Dictionary = _world.heals[i]
		if GameWorld._dist(h, game.player) < 16.0:
			_world.heals.remove_at(i) # consumed even at full hp — never a wasted item
			game.hp = minf(game.max_hp, game.hp + HEAL_AMOUNT)
	# M6 F6 TOUCH/CLEAR (M6-SPEC §4.2, beside the heals arm): ONE touch of a
	# sigil kills every non-BOSS, non-MINIBOSS, non-REAPER enemy on the field,
	# each through the ONE kill_enemy funnel (the counters advance; the boss
	# bounty/gem/coin/heal/chest rolls ride, zero new RNG beyond the shipped
	# rolls); the carve means bosses + minibosses + reaper SURVIVE the clear
	# (owner ruling 2026-10-29 verbatim "2. Rec." — heavy damage is spec,
	# not this card). ZERO RNG in this arm itself (SD-E3: every roll rides the
	# shipped kill funnel, nothing rolls FOR the clear); the moment marks
	# itself with ONE big ring FX — the retired weapon-side sigil's own ring
	# bytes (r 760 / life .5) through the shipped rings transient.
	for i in range(sigils.size() - 1, -1, -1):
		var s: Dictionary = sigils[i]
		if GameWorld._dist(s, game.player) < 16.0:
			sigils.remove_at(i)
			for e in _world.enemies.duplicate():
				if not e.boss and not e.miniboss and not e.get("reaper", false):
					_world.kill_enemy(game, e)
			fx_rings.append({"r": 760.0, "life": 0.5, "max": 0.5})
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
	for i in range(_world.chests.size() - 1, -1, -1):
		var c: Dictionary = _world.chests[i]
		if GameWorld._dist(c, game.player) < 16.0:
			_world.chests.remove_at(i)
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
