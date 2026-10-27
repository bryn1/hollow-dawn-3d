# Achievements + the run-end counter store (M5-SPEC §1.1, T-M5p, MC 11421).
# The rule module beside powerups.gd / evolutions.gd / union.gd (the rule-
# module precedent since M1): the ONE counter TABLE (nine named counters,
# OUR ids and targets — the VS-FEATURES S7 shape, zero copied condition
# text), the ONE run-end update entry (main._end_run calls update() above
# the gold cash-out; F-3: every counter is computable from game.stats /
# game.weapons / game.cycle / the well — ZERO world.gd growth), and the
# progress read the achievements page renders. Flags ride the EXISTING
# well.flags dict as achv:<id> (F-4, the stage2/stage3 write-1 law SET-only;
# death never unsets). update() writes NOTHING to disk itself: the ONE
# _meta_changed() funnel at the shipped call site below the gold line
# persists counters + flags with the cash-out (P-E3 PIN-HOLD: the block
# calls neither save() nor the funnel). `world` is the spec's F-3 read-set
# carried in the signature; no shipped row consumes a world field (the
# reaper achievements were weighed and REJECTED, §9.5) — the param keeps the
# run-end seam stable for the roster wave's reads.
class_name Achievements
extends RefCounted

const ACHV_PREFIX := "achv:"

# id / display name / counter / target — 20 rows exactly (4+3+3+2+3+2+1+1+1
# over the nine counters; P-E6 pins the count, id uniqueness and the
# counter set). `best_cycle` is READ through _counter (it lives on the well
# field, this store never re-homes it — §1.1).
const TABLE := [
	{"id": "kills-1k", "name": "Thousand Fells", "counter": "kills_total", "target": 1000},
	{"id": "kills-10k", "name": "Ten Thousand Fells", "counter": "kills_total", "target": 10000},
	{"id": "kills-50k", "name": "Field of Bones", "counter": "kills_total", "target": 50000},
	{"id": "kills-200k", "name": "The Long Slaughter", "counter": "kills_total", "target": 200000},
	{"id": "gold-500", "name": "First Coins of Dawn", "counter": "gold_earned", "target": 500},
	{"id": "gold-2500", "name": "Well Fed", "counter": "gold_earned", "target": 2500},
	{"id": "gold-10000", "name": "The Gilded Well", "counter": "gold_earned", "target": 10000},
	{"id": "runs-10", "name": "Ten Nights Walked", "counter": "runs_total", "target": 10},
	{"id": "runs-50", "name": "Fifty Nights Deep", "counter": "runs_total", "target": 50},
	{"id": "runs-150", "name": "Hundred and Fifty Nights", "counter": "runs_total", "target": 150},
	{"id": "win-1", "name": "Until Dawn", "counter": "wins_total", "target": 1},
	{"id": "win-5", "name": "Five Dawns", "counter": "wins_total", "target": 5},
	{"id": "level-12", "name": "Seasoned", "counter": "max_level", "target": 12},
	{"id": "level-18", "name": "Hardened", "counter": "max_level", "target": 18},
	{"id": "level-25", "name": "Dawnblessed", "counter": "max_level", "target": 25},
	{"id": "minutes-60", "name": "One Hour in the Dark", "counter": "minutes_total", "target": 60},
	{"id": "minutes-300", "name": "Five Hours Watched", "counter": "minutes_total", "target": 300},
	{"id": "cycle-1", "name": "The Second Night", "counter": "best_cycle", "target": 1},
	{"id": "evo-1", "name": "One Transfiguration", "counter": "evolutions_seen", "target": 1},
	{"id": "union-1", "name": "Two Become One", "counter": "unions_seen", "target": 1},
]

# The named counter set (P-E6: every TABLE row's counter must be one of
# these — an orphan counter is a PIN FAILURE, not a runtime surprise).
const COUNTERS := ["kills_total", "gold_earned", "runs_total", "wins_total",
	"max_level", "minutes_total", "best_cycle", "evolutions_seen",
	"unions_seen"]


# THE run-end update (main._end_run, the ONE call site). Σ-add rows add
# EXACTLY; max-rule rows max EXACTLY (the best_cycle never-decreases law,
# main.gd's own shape); then SET-only flag rows for every target the NEW
# counter values satisfy. Pure int math over the read set — zero RNG.
static func update(well: DawnWell, game: GameState, world: GameWorld) -> void:
	_add(well, "kills_total", int(game.stats.kills))
	_add(well, "gold_earned", int(game.stats.gold))
	_add(well, "runs_total", 1) # every run end counts (P-E1: the always-
	# write law — unlike a shop VERB no-op, a run end never lands flat)
	if game.phase == "win": # game.end_run set phase = result BEFORE this
		_add(well, "wins_total", 1)
	_add(well, "minutes_total", int(floor(float(game.stats.time) / 60.0)))
	_max(well, "max_level", int(game.stats.level))
	_max(well, "evolutions_seen", _distinct_in(game, _evolved_ids()))
	_max(well, "unions_seen", _distinct_in(game, UnionSystem.TABLE.keys()))
	for row in TABLE:
		if counter(well, String(row.counter)) >= int(row.target):
			well.flags[ACHV_PREFIX + String(row.id)] = 1


# The page's progress term: min(count, target) — display-only, total over
# the table (the no-blank law; an unknown counter reads 0, the P-E6 red
# class is the orphan pin above, not a crash here).
static func progress(well: DawnWell, row: Dictionary) -> int:
	return mini(counter(well, String(row.counter)), int(row.target))


# The ONE counter read: best_cycle rides its shipped well field (§1.1: this
# store READS it, never re-homes it); every other name reads counters.
static func counter(well: DawnWell, name: String) -> int:
	if name == "best_cycle":
		return well.best_cycle
	return int(well.counters.get(name, 0))


static func _add(well: DawnWell, name: String, delta: int) -> void:
	well.counters[name] = int(well.counters.get(name, 0)) + delta


static func _max(well: DawnWell, name: String, value: int) -> void:
	well.counters[name] = maxi(int(well.counters.get(name, 0)), value)


# The evolved-id column of the ONE evolution table (row.evo — the ids an
# in-slot evolution LEAVES in game.weapons; the table keys are the bases).
static func _evolved_ids() -> Array:
	var out: Array = []
	for row in EvolutionSystem.TABLE.values():
		out.append(row.evo)
	return out


# Distinct ids of `ids` currently carried in game.weapons (each counted
# once) — read through the shipped EvolutionSystem / UnionSystem tables,
# the ONE table each, no second copy (evolutions/replace in-slot: an
# evolved/union id simply IS the weapon row's id).
static func _distinct_in(game: GameState, ids: Array) -> int:
	var seen := {}
	for w in game.weapons:
		if ids.has(w.id) and not seen.has(w.id):
			seen[w.id] = true
	return seen.size()
