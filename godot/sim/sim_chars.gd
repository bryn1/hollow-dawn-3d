# ROSTER legs for M5 pillar B (MC 11422, T-M5c; M5-SPEC rev-2 §2.1/§2.2,
# SEL-C roster data rows). reason: one leg-driver per pillar batch is the
#   sim convention (sim_endless 350 / sim_stages ~460): this header's ROWS
#   table is the row-id -> ACCEPT-row map the suite reads; splitting hides
#   the map.
# Same headless funnel as sim_stages: the REAL Main.tscn, screens stubbed
# (SimStubScreens), every run started through the real _start_game. Seed-
# pinned (HD3D_SEED, default 11422 = the card id, the M3/M4 seed law) so the
# dump is byte-stable; the committed copy tests/fixtures/chars-m5.jsonl is a
# FORWARD-LOCK (generated TWICE cmp-identical, never one of THIS card's byte
# anchors — §7.1's new-M5-fixture class). DawnWell wiped per run (fresh_run
# wipe_well law); save_probe isolation under a throwaway XDG_DATA_HOME.
# THE duplicate() LAW (spec §2.2 + DA-c2 P4-2, measured on the pinned
# 4.7.2): the run mutates its weapon dict (levelup.gd w.level += 1); the
# const table is DEEP read-only, so Roster.start_weapons hands a
# duplicate(true). The `alias_guard` leg below is the SAME-PROCESS MULTI-
# RUN proof that law holds (B-E2's twin leg — the alias the const→var +
# shallow-strip future would plant is caught here, not by a grep).
# ROWS (row-id -> the ACCEPT row it pins):
#   start_rows      B-E2: for each of the 9 SEL-C rows, the t=0 run truth —
#       start weapon id/level/cd == the table row, ONE slot, gold ==
#       Roster.gold_start, max_hp == 100 + rule.hp_add; row 0's weapon is
#       the re-copied SHIPPED talon literal by VALUE (the M2-B3 equality
#       shape, re-pointed to the ROSTER seam).
#   alias_guard     B-E2 (the duplicate() law's twin): run1 char 1 mutates
#       its weapon dict; a FRESH same-process run on the SAME char sees the
#       row at level 1, not the leaked one — a const-row / shallow-duplicate
#       hand-out would leak the mutation across runs.
#   rule_rows       B-E3: per char the four formula seams + gold + max_hp +
#       xp-mult, MEASURED vs a re-evaluated expected (independent literals,
#       not a second call into the same seam); row 0 == the shipped gold
#       numbers (speed 140.0, dmg 1.0, intake 50.0, hp 100.0, gold 0, xp 1.0).
#   start_reset     B-E4: a bare GameState().start_run() resets char_id to
#       the input row (0 = shipped), and the run never carries a 13th
#       snapshot field (the frozen 12-key snapshot shape).
#   pawns           B-E7: the hand-in tail re-skins the SAME pawn node — for
#       each char the pawn mesh == ClassMesh.mesh_for(row.mesh, 1.67) (the
#       ONE loader, cached identity), and the material_override is a FRESH
#       duplicate (distinct object from the mesh's own surface material) so
#       the iframes-alpha rule never mutates the cached import.
#   states          B-E6: the four-state row law (Roster.state over a fresh
#       / funded+unlocked / owned well per char), icon-free (the real
#       Screens render + portrait assert-exists is the pixel-gate leg, the
#       T-M5s assets gate that; the pure state read needs no icon).
extends SceneTree

const DT := 1.0 / 60.0 # unused carrier parity with the sim siblings
const SEED_DEFAULT := 11422
const GOLDEN_ROW0 := {"id": "talon", "level": 1, "cd": 0.0}

const HERO := preload("res://scripts/hero_pawn.gd") # PLAYER_TINT read

var _funnel := SimFunnel.new()
var _started := false


func _out_path() -> String:
	return SimFunnel.out_path("HD3D_CHARS_DUMP", "/tmp/hd3d-chars-m5.jsonl")


func _process(_delta: float) -> bool:
	if not _started:
		_started = true
		print("CHARS_START")
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else SEED_DEFAULT)
		DawnWell.new().reset()
		_leg_start_rows()
		_leg_alias_guard()
		_leg_rule_rows()
		_leg_start_reset()
		_leg_pawns()
		_leg_states()
		var f := FileAccess.open(_out_path(), FileAccess.WRITE)
		assert(f != null)
		for r in _funnel.rows:
			f.store_line(JSON.stringify(r))
		f.close()
		print("CHARS_OK rows=%d ok=%s" % [_funnel.rows.size(), str(_funnel.ok)])
		quit(0 if _funnel.ok else 3)
	return false


func _check(leg: String, checks: Dictionary, extra: Dictionary) -> void:
	_funnel.check(leg, checks, extra)


# The B-E3 golden run-state seam readers, all on a FRESH wiped-char run so
# the additive terms are the ONLY deltas off the shipped constants.
func _fresh_char_run(char: int) -> Node:
	return SimFunnel.fresh_run(root, {"wipe_well": true, "char": char})


# B-E2: the t=0 start truth for all nine SEL-C rows, read through a REAL
# fresh run (the run started via the real _start_game hand-in, char row fed
# by the SimFunnel opts growth). Row 0's weapon dict is value-equal to the
# re-copied shipped talon literal — the M2-B3 equality shape, re-pointed at
# the ROSTER seam (the start_run body no longer carries the literal; the
# equality is measured off the LIVE run, the strictest form).
func _leg_start_rows() -> void:
	for i in Roster.CHARACTERS.size():
		var run := _fresh_char_run(i)
		var row: Dictionary = Roster.CHARACTERS[i]
		var want_id: String = String(row.start_weapons[0].id)
		var w0: Dictionary = run.game.weapons[0]
		var checks := {
			"one_slot": run.game.weapons.size() == 1,
			"start_id": String(w0.id) == want_id,
			# the kill-attribution observable (B-E2's planted cell): the id
			# the RUN HOLDS must be a shipped weapons.gd id — a table-key
			# drift never reaches the weapon system, measured at the table,
			# NOT against the roster row that planted it (self-consistency
			# is blind; the source truth is WeaponSystem.IDS).
			"id_shipped": WeaponSystem.IDS.has(String(w0.id)),
			"level_1": int(w0.level) == 1,
			"cd_zero": float(w0.cd) == 0.0,
			"gold_start": run.game.gold == Roster.gold_start(i),
			"max_hp": run.game.max_hp == 100.0 + Roster.rule(i).hp_add,
		}
		var extra := {"ev": "start_row", "char": i, "id": row.id,
			"weapon": {"id": w0.id, "level": int(w0.level), "cd": float(w0.cd)},
			"gold": run.game.gold, "max_hp": run.game.max_hp}
		if i == 0:
			checks["row0_shipped"] = (w0 == GOLDEN_ROW0) # by VALUE
			extra["row0_twin"] = w0 == GOLDEN_ROW0
		_check("start_rows", checks, extra)
		run.free()


# B-E2's duplicate() LAW twin leg (the §2.2 measured law): run1 on char 1
# mutates its OWN weapon dict (the levelup upgrade arm: w.level += 1 — the
# exact shape levelup.gd:133 writes). Then run1 is torn down and a FRESH
# run on the SAME char is built IN THE SAME PROCESS: its weapon must read
# level 1 again. A const-row returned without duplicate(true), or a
# SHALLOW duplicate (which re-shares the weapon row), would leak the +1
# into run2 — the guard fails there (B-E2's planted-red shape).
func _leg_alias_guard() -> void:
	var run1 := _fresh_char_run(1)
	var w: Dictionary = run1.game.weapons[0]
	var before := int(w.level)
	w["level"] = int(w.level) + 1 # the levelup.gd upgrade-arm mutation
	var mutated := int(run1.game.weapons[0].level)
	run1.free() # SAME process — the table const must be untouched
	var run2 := _fresh_char_run(1)
	var clean := int(run2.game.weapons[0].level)
	_check("alias_guard", {
		"before_1": before == 1,
		"mutated_2": mutated == 2,
		"run2_clean": clean == 1, # THE alias-guard observable (RED on a leak)
	}, {"ev": "alias_guard", "before": before, "mutated": mutated,
		"run2_level": clean})
	run2.free()


# B-E3: the four formula seams + gold + max_hp + xp-mult per char, MEASURED
# off a fresh run vs an INDEPENDENT re-evaluated expected (the shipped
# constants re-spelled here, not a second call into the same seam — so a
# seam that stopped folding the char term goes RED even though it stays
# self-consistent). Row 0 == the shipped numbers exactly (F-2).
func _leg_rule_rows() -> void:
	for i in Roster.CHARACTERS.size():
		var run := _fresh_char_run(i)
		var g: GameState = run.game
		var rule: Dictionary = Roster.rule(i)
		var exp_speed: float = 140.0 * (1.0 + 0.01 * float(rule.spd_pct))
		var exp_dmg: float = 1.0 + 0.01 * float(rule.dmg_pct)
		var exp_intake: float = maxf(0.0, 50.0 - 1.0 * float(rule.armor_add))
		var exp_clamp: float = maxf(0.0, 0.5 - 1.0 * float(rule.armor_add))
		var exp_hp: float = 100.0 + float(rule.hp_add)
		var exp_gold: int = Roster.gold_start(i)
		var exp_xp: float = 1.0 + 0.01 * float(rule.xp_pct)
		_check("rule_rows", {
			"speed": is_equal_approx(g.player_speed(), exp_speed),
			"dmg": is_equal_approx(g.damage_multiplier(), exp_dmg),
			"intake_50": is_equal_approx(g.damage_taken(50.0), exp_intake),
			"intake_clamp": is_equal_approx(g.damage_taken(0.5), exp_clamp),
			"hp": is_equal_approx(g.max_hp, exp_hp),
			"gold": g.gold == exp_gold,
			"xp": is_equal_approx(g.meta_xp_mult, exp_xp),
		}, {"ev": "rule_row", "char": i,
			"speed": g.player_speed(), "dmg": g.damage_multiplier(),
			"intake_50": g.damage_taken(50.0), "hp": g.max_hp,
			"gold": g.gold, "xp": g.meta_xp_mult})
		run.free()


# B-E4: a bare start_run resets char_id from the input (0 = shipped row) and
# the run never leaks a 13th snapshot field (the frozen 12-key Contract B
# shape — F-3). char_id/char_sel live OUTSIDE snapshot_json; a 13th field
# here is the planted-red this leg catches.
func _leg_start_reset() -> void:
	var g := GameState.new()
	g.char_id = 7 # plant a stale selection above the row
	g.start_run() # the reset must clear it back to the input default (0)
	var snap_keys: Array = JSON.parse_string(g.snapshot_json(0)).keys()
	_check("start_reset", {
		"char_id_reset_0": g.char_id == 0,
		"snapshot_12": snap_keys.size() == 12,
		"no_char_field": not snap_keys.has("char"),
		"no_charid_field": not snap_keys.has("char_id"),
	}, {"ev": "start_reset", "char_id": g.char_id, "snap_n": snap_keys.size(),
		"snap_keys": snap_keys}) # g is RefCounted — scope releases it


# B-E7: the hand-in tail re-skins the SAME pawn node (the P1-1 fix) — for
# each char the pawn mesh is the ONE ClassMesh loader's cached object for
# that row's GLB at the 1.67 m row (identity == the direct mesh_for call, so
# no second loader, no re-instantiation), and material_override is a FRESH
# duplicate distinct from the mesh's own surface material (the iframes-alpha
# rule dims the pawn's PRIVATE copy, never the shared import).
func _leg_pawns() -> void:
	for i in Roster.CHARACTERS.size():
		var run := _fresh_char_run(i)
		var row: Dictionary = Roster.CHARACTERS[i]
		var want: Mesh = ClassMesh.mesh_for(String(row.mesh),
			HordeViz.MODEL_H_PLAYER)
		var pawn: MeshInstance3D = run._pawn
		var mesh_ok: bool = pawn.mesh == want # cached identity (same object)
		var mat := pawn.material_override as StandardMaterial3D
		var src := want.surface_get_material(0) as StandardMaterial3D
		var checks := {
			"mesh_identity": mesh_ok,
			"has_override": mat != null,
		}
		var extra := {"ev": "pawn", "char": i, "mesh": row.mesh,
			"override": mat != null}
		if mat != null:
			checks["fresh_dup"] = (src == null) or (mat != src)
			checks["unshaded"] = mat.shading_mode \
				== BaseMaterial3D.SHADING_MODE_UNSHADED
			checks["tint"] = mat.albedo_color == HERO.PLAYER_TINT
			extra["fresh_dup"] = checks["fresh_dup"]
		_check("pawns", checks, extra)
		run.free()


# B-E6: the four-state row law read through Roster.state (the single source
# the panel renders and the sim dumps — no second source). Three well
# contexts per char: a fresh well (row 0 owned/default, gated rows LOCKED,
# ungated BUY), a funded+all-gates well (ungated + gated now BUY/SELECT),
# and a well with this char OWNED (SELECTED when chosen, else OWNED). The
# real Screens render + portrait assert-exists is the pixel-gate leg (the
# T-M5s assets gate it); this pins the state logic, icon-free.
func _leg_states() -> void:
	var fresh := DawnWell.new()
	fresh.reset()
	var funded := DawnWell.new()
	funded.reset()
	funded.gold = 100000
	for a in Achievements.TABLE:
		funded.flags["achv:" + String(a.id)] = 1
	for i in Roster.CHARACTERS.size():
		var id: String = String(Roster.CHARACTERS[i].id)
		var owned := DawnWell.new()
		owned.reset()
		owned.gold = 100000
		for a in Achievements.TABLE:
			owned.flags["achv:" + String(a.id)] = 1
		owned.flags[Roster.CHAR_PREFIX + id] = 1
		owned.char = i
		_check("states", {
			"fresh_ok": _state_ok(fresh, i),
			"gated_unlocked": Roster.state(funded, i) != "locked",
			"owned_selected": Roster.state(owned, i) == "selected",
			"owned_other": _owned_other(i),
		}, {"ev": "state", "char": i, "id": id,
			"fresh": Roster.state(fresh, i),
			"funded": Roster.state(funded, i),
			"owned": Roster.state(owned, i)})


# fresh-state sanity: row 0 is default-selected (owned-by-default), every
# other ungated row is BUY, every gated row on the empty well is LOCKED.
func _state_ok(w: DawnWell, i: int) -> bool:
	if i == 0:
		return Roster.state(w, i) == "selected"
	return Roster.state(w, i) == ("locked" if Roster.is_locked(w, i) else "buy")


# an owned char that is NOT the chosen row reads "owned"; row 0 owned-by-
# default on an empty well is the selected default (handled in _state_ok).
func _owned_other(i: int) -> bool:
	var w := DawnWell.new()
	w.reset()
	w.gold = 100000
	for a in Achievements.TABLE:
		w.flags["achv:" + String(a.id)] = 1
	var id: String = String(Roster.CHARACTERS[i].id)
	w.flags[Roster.CHAR_PREFIX + id] = 1
	if i == 0:
		return true # row 0 owned default is the selected case, skip
	w.char = 0 # another row chosen -> this owned row is "owned"
	return Roster.state(w, i) == "owned"
