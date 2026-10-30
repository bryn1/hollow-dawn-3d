# Combat-layer probe for sim_headless.gd (MC 11102 T-S4):
# reason: >400/500 lines (514 measured at MC 11697 T-M6p) — the T-M6p
#   boost-MATH channel (the 9 spec-constant-pinned evo_boost_rows + the
#   effect()-identity row) grew the file; the spec NAMES this channel here
#   (M6-SPEC §3.6 PS-E2: "the boost math rides sim_combat's channel, merged
#   into the journey dump"), and the boost rows share the _first_fire +
#   fx_counts readers with the A4 legs — a split would duplicate them.
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
# mid-level. All six levels also keep every leg's caps exercised. The ten
# T-M1h roster weapons ride their own class families (dart-loop = ember
# formula at L7, hewn-axe = cleaver formula at L5, the single-volley
# classes mid-level, censer = the 4-bolt cross) — per-weapon KILL
# ATTRIBUTION is the roadmap feature-6 ACCEPT row (per-weapon-kills
# pattern from S4, unchanged channel). M6 F6 (MC 11675): the doom-sigil
# leg RETIRED WITH THE WEAPON (this row is §4.4's sim_combat.gd:32 named
# site) — 15 legs; the journey all_weapons_killed row reads legs:15
# (SD-E1/E5), and the sigil's screen-clear becomes observable in the
# M6 sigil + magnet legs at the file's tail instead.
const SPECS := [
	["talon", 2], ["ember", 7], ["cleaver", 5], ["halo", 8],
	["ward", 3], ["spike", 2],
	["bone-whip", 4], ["dart-loop", 7], ["hewn-axe", 5], ["pilgrim-cross", 3],
	["censer-of-hours", 2], ["rot-water", 4], ["spectral-disc", 3],
	["storm-peal", 3], ["fire-lash", 4],
]


# §i live-count cap formulas, spelled as weapons.gd spells its count math
# (1 + floor((L-1)/3) bolts per fire / <= 20 shards / <= 4 orbiters). The
# M1h roster FAMILY sum rides the ONE table in WeaponFxViz (both count
# sites, one formula source); pre-roster builds get the old sums (extra 0).
static func caps(game) -> Dictionary:
	# MIRRORS WeaponFxViz._cap() term for term — the pinned base terms
	# evaluate from the canonical level 1 when that weapon is UNOWNED (v1's
	# shipped form, kept verbatim in BOTH count sites so the comparison
	# never diverges), plus the roster FAMILY sum from the ONE table.
	var el := 1
	var cl := 1
	for w in game.weapons:
		if w.id == "ember":
			el = w.level
		elif w.id == "cleaver":
			cl = w.level
	var out := {"ember": 1 + int((el - 1) / 3), "cleaver": 1 + int((cl - 1) / 4)}
	for w in game.weapons:
		# M6 F2 (MC 11705, §2.1/§3.3 both-sites rule — mirrors viz_fx's
		# _roster_cap verbatim): family membership resolves through
		# effect()'s BASE map, so the evolved ids add their term THROUGH
		# the base family at their own level; roster_one_cap stays keyed
		# on the base id. Un-evolved ids resolve to themselves — the
		# shipped sums evaluate identically (FX-E3 byte-equal re-derive).
		var base := String(EvolutionSystem.effect(w.id).base)
		if WeaponFxViz.BOLT_ROSTER.has(base):
			out.ember += WeaponFxViz.roster_one_cap(base, w.level)
		elif WeaponFxViz.THROW_ROSTER.has(base):
			out.cleaver += WeaponFxViz.roster_one_cap(base, w.level)
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
	# MC 11401 C2: the 6-line fresh_run body copy converted to the ONE seam
	# (audit MC 11398 §2.1 — this was the donor's verbatim body beside it).
	var run: Node = SimFunnel.fresh_run(root)
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


# ---- M6 legs (MC 11675): the Riven Sigil + the coin magnet ------------------
# The sim_boss CHEST ROLL LEG pattern verbatim: scripted runs through the REAL
# funnel (SimFunnel.fresh_run — the real Main.tscn via _start_game, the real
# world/weapons/drops wiring), each leg its OWN seed, rows carry checks + ok —
# the ok flags ARE the judgment and a non-ok row forces rc != 0 at the driver
# (sim_headless._run_sigil). Synthetic kill dicts carry the exact key shape
# _spawn_enemy builds (the funnel + the drops roll read every one of them;
# enemies.find() missing = no entity removed, the roll runs complete).
const SIGIL_KILLS := 1600 # two cadences + edge slack: the drops must land
#	exactly at counter rows 750 and 1500 (SD-E2's observable)

static func _synth(kind: String, x := 0.0, y := 0.0, boss := false,
		miniboss := false, reaper := false) -> Dictionary:
	return {"type": kind, "x": x, "y": y, "hp": 1.0, "max_hp": 1.0,
		"spd": 0.0, "dmg": 0.0, "xp": 0.0, "boss": boss,
		"miniboss": miniboss, "reaper": reaper, "sprite": "",
		"hit_cd": 0.0}


# SD-E2 counter observable: SIGIL_KILLS scripted non-boss kills with one
# boss + one miniboss + one reaper kill interleaved every 100th (the REV-4
# §4.2 ONE carve — bosses AND minibosses AND the reaper are excluded from
# the counter, the same predicate set the clear spares; NF-5's twin planted
# RED drops `and not enemy.miniboss` and this leg goes RED on the cadence).
# The 750th kill happens AT (33, -21): the drop must be emitted at the KILL
# LOCATION (observable, not at the player, not at spawn).
func sigil_drops_leg(root) -> Dictionary:
	seed(41175) # leg seed, the S2h/S2i per-leg convention (card digits)
	var run: Node = SimFunnel.fresh_run(root)
	var d = run.world.drops
	var drops_at: Array = []
	for n in SIGIL_KILLS:
		if (n + 1) % 100 == 0:
			run.world.kill_enemy(run.game, _synth("warden", 0.0, 0.0, true))
			run.world.kill_enemy(run.game,
				_synth("hollow-knight", 0.0, 0.0, false, true))
			run.world.kill_enemy(run.game,
				_synth("the-reaper", 0.0, 0.0, true, false, true))
		if n + 1 == 750:
			run.world.kill_enemy(run.game, _synth("wraith", 33.0, -21.0))
		else:
			run.world.kill_enemy(run.game, _synth("wraith"))
		if d.sigils.size() > drops_at.size():
			drops_at.append(d.sigil_kills)
	var pos_ok: bool = d.sigils.size() == 2 \
		and absf(d.sigils[0].x - 33.0) < 0.01 \
		and absf(d.sigils[0].y + 21.0) < 0.01
	var checks := {
		"exact_cadence_750_1500": drops_at == [750, 1500],
		"counter_nonboss_only": d.sigil_kills == SIGIL_KILLS,
		"kills_count_named_too": run.game.kills \
			== SIGIL_KILLS + 3 * (SIGIL_KILLS / 100),
		"drop_at_kill_location": pos_ok,
	}
	var ok: bool = true
	for k in checks:
		ok = ok and checks[k]
	run.queue_free()
	return {"ev": "sigil_drops", "checks": checks, "ok": ok,
		"drops_at": drops_at, "counter": d.sigil_kills}


# SD-E2 TAP-FREE pair (same-seed twin, two runs in the leg — the spec's
# "byte-identical with the sigil-array EXCLUDED FROM COMPARISON" verbatim):
# run A lets the counter run (2 emits); run B zeroes the counter after every
# kill so the emit line NEVER executes. The RNG-fed drop streams (gems/coins/
# heals/chests), gold and a trailing CALIBRATION triple [randf, randf,
# randi%97] must come out A == B: one consumed randf inside the counter and
# the streams and the calibration fork (planted tap RED, capture).
func sigil_tapfree_leg(root) -> Dictionary:
	var a := _tapfree_run(root, false)
	var b := _tapfree_run(root, true)
	var checks := {
		"gems_identical": a[0] == b[0],
		"coins_identical": a[1] == b[1],
		"heals_identical": a[2] == b[2],
		"chests_identical": a[3] == b[3],
		"gold_identical": a[4] == b[4],
		"calib_identical": a[5] == b[5],
		"emission_differ_by_design": a[6] == 2 and b[6] == 0,
	}
	var ok: bool = true
	for k in checks:
		ok = ok and checks[k]
	return {"ev": "sigil_tapfree", "checks": checks, "ok": ok}


func _tapfree_run(root, zero_counter: bool) -> Array:
	seed(41176) # SAME seed both runs — the twin is an identity claim
	var run: Node = SimFunnel.fresh_run(root)
	var d = run.world.drops
	for _n in SIGIL_KILLS:
		run.world.kill_enemy(run.game, _synth("wraith"))
		if zero_counter:
			d.sigil_kills = 0
	var calib: Array = [roundi(randf() * 1e6), roundi(randf() * 1e6),
		randi() % 97]
	var out: Array = [_arr_sig(run.world.gems), _arr_sig(run.world.coins),
		_arr_sig(run.world.heals), _arr_sig(run.world.chests),
		run.game.gold, calib, d.sigils.size()]
	run.queue_free()
	return out


static func _arr_sig(arr: Array) -> Array:
	# Position fingerprint of an RNG-fed drop stream, r3-rounded
	# (the dump's own float comparison).
	var out: Array = []
	for it in arr:
		out.append([roundi(it.x * 1000.0) / 1000.0,
			roundi(it.y * 1000.0) / 1000.0])
	return out


# SD-E3 clear, BOTH SIDES, + the touch-only twin (MG-E2's named exclusion).
# Field: 5 eligible + boss + miniboss + reaper (the ONE carve: owner ruling
# 2026-10-29 "2. Rec." — the named three SURVIVE, untouched, not damaged:
# heavy damage is spec-not-this-card). ONE collect with a sigil AT the
# player: exactly the 5 eligible die THROUGH THE ONE funnel (kills delta
# pins it; their rolls ride), the named three survive hp-untouched in the
# array, the sigil is consumed (ONE touch = ONE clear) and exactly ONE ring
# FX marks the moment — the retired weapon-side arm's own bytes (r 760 /
# life .5) on the shipped rings transient, bound through WeaponSystem.bind.
# Touch-only twin: sigil at 30 px (outside the 16 px touch) with the magnet
# WIDENED (grip 5 + loadstone 5 ⇒ ring 210 px): the sigil stays byte-static
# while a coin at 100 px moves the full pull step — live-tick proof, so the
# static check cannot be satisfied by a dead tick. Planted: the carve term
# dropped ⇒ the boss-survives leg RED; a magnet call on sigils ⇒ the static
# leg RED (capture).
func sigil_clear_leg(root) -> Dictionary:
	seed(41177)
	var run: Node = SimFunnel.fresh_run(root)
	var game = run.game
	var w = run.world
	var p = game.player
	for i in 5:
		w.enemies.append(_synth("wraith", 20.0 + i * 5.0, 10.0))
	var boss = _synth("warden", -25.0, 0.0, true)
	var mini = _synth("hollow-knight", 25.0, -20.0, false, true)
	var reap = _synth("the-reaper", 0.0, -30.0, true, false, true)
	w.enemies.append(boss)
	w.enemies.append(mini)
	w.enemies.append(reap)
	w.drops.sigils.append({"x": p.x, "y": p.y})
	var kills0: int = game.kills
	w.collect_pickups(game)
	var rings: Array = run.fx.rings
	var checks := {
		"eligible_cleared_exactly": game.kills - kills0 == 5 \
			and w.enemies.size() == 3,
		"named_three_survive_untouched": boss.hp == 1.0 and mini.hp == 1.0 \
			and reap.hp == 1.0 and w.enemies.has(boss) \
			and w.enemies.has(mini) and w.enemies.has(reap),
		"sigil_consumed_one_touch": w.drops.sigils.is_empty(),
		"one_ring_mark_r760": rings.size() == 1 and rings[0].r == 760.0 \
			and rings[0].life == 0.5,
	}
	# Touch-only twin (the magnet set is gems+coins+heals, sigils EXCLUDED):
	game.passives["grip"] = 5
	game.passives["loadstone"] = 5
	w.drops.sigils.append({"x": p.x + 30.0, "y": p.y})
	w.coins.append({"x": p.x + 100.0, "y": p.y, "gold": 1})
	var twin_i: int = w.coins.size() - 1
	w.update_entities(DT, game)
	var sig: Dictionary = w.drops.sigils[0]
	checks["sigil_touch_only_static"] = absf(sig.x - (p.x + 30.0)) < 0.001 \
		and absf(sig.y - p.y) < 0.001
	checks["coin_pulled_same_tick"] = absf(w.coins[twin_i].x
		- (100.0 - 220.0 * DT)) < 0.01
	var ok: bool = true
	for k in checks:
		ok = ok and checks[k]
	run.queue_free()
	return {"ev": "sigil_clear", "checks": checks, "ok": ok}


# MG-E1 magnet family (ONE source, now coin-inclusive): pinned grip 0 (ring
# 60 px) — a coin at 50 px moves the shipped 220 px/s step, a coin at 80 px
# and one at 150 px stay, and the HEAL + GEM twins at 50 px move EXACTLY as
# before (the planted heals-double-pull REDs the twins row, capture). Then
# grip 2 + loadstone 2 (ring 90 + 30 = 120 px): the coin at 100 px moves —
# the passives actually drive the coin kind (MG-E1's named row).
func magnet_coins_leg(root) -> Dictionary:
	seed(41178)
	var run: Node = SimFunnel.fresh_run(root)
	var game = run.game
	var w = run.world
	var p = game.player
	w.coins.append({"x": 50.0, "y": 0.0, "gold": 1})
	w.coins.append({"x": 80.0, "y": 0.0, "gold": 1})
	w.coins.append({"x": 150.0, "y": 0.0, "gold": 1})
	w.heals.append({"x": 0.0, "y": 50.0})
	w.gems.append({"x": -50.0, "y": 0.0, "xp": 1.0})
	w.update_entities(DT, game)
	var pull := 220.0 * DT
	var checks := {
		"coin_in_ring_moves": absf(w.coins[0].x - (50.0 - pull)) < 0.01,
		"coin_outside_ring_static": absf(w.coins[1].x - 80.0) < 0.001 \
			and absf(w.coins[1].y) < 0.001,
		"coin_far_static": absf(w.coins[2].x - 150.0) < 0.001,
		"heal_twin_unchanged_path": absf(w.heals[0].y - (50.0 - pull)) < 0.01 \
			and absf(w.heals[0].x) < 0.001,
		"gem_twin_unchanged_path": absf(w.gems[0].x + 50.0 - pull) \
			< 0.01 and absf(w.gems[0].y) < 0.001,
	}
	game.passives["grip"] = 2
	game.passives["loadstone"] = 2
	w.coins.append({"x": 100.0, "y": 0.0, "gold": 1})
	w.update_entities(DT, game)
	checks["coin_widened_ring_passive"] = absf(w.coins[3].x
		- (100.0 - pull)) < 0.01
	var ok: bool = true
	for k in checks:
		ok = ok and checks[k]
	run.queue_free()
	return {"ev": "magnet_coins", "checks": checks, "ok": ok}


# ---- M6 T-M6p boost-MATH legs (MC 11697, M6-SPEC §3.6 PS-E2) ---------------
# GROWTH NOTE (file-size law): the boost formula twins ARE this file's
# spec channel (PS-E2 names the existing sim_combat spec channel — the
# per-weapon spec-channel legs merged into the journey dump by
# sim_headless._run_sigil; _run_boosts rides the same merge). Each TABLE
# row runs the SAME scripted first fire twice: once with the evolved id,
# once with the family base (the UN-evolved twin — the shipped byte value,
# the zero-identity guard). The dict/arc/ring/burst entries the fire
# appends ARE the observable; the hp-delta classes read the pinned enemy's
# hp across the one fire tick (one enemy, full-sector classes hit nothing
# else). Equality rows are EXACT float `==` on IEEE: the evolved value is
# the shipped formula re-computed with ONE extra ×table-constant factor,
# the twin pins the same operands, so a planted nerf (dmg 1.6 -> 1.05)
# turns the evolved row RED while every twin stays GREEN (PS-E2's named
# attribution pair). cd rows read w.cd on the fire tick (the fresh
# cooldown, before any decay). feat rows: the dict key appears on the
# evolved entry and NOT on the twin (extra-target rows count entries).
func boost_legs(root: Window) -> Array:
	var out: Array = []
	for base in EvolutionSystem.TABLE:
		out.append(_boost_row(root, base))
	# effect()-identity rows (PS-E2's named dump row): EVERY live id —
	# the 15 pool weapons, the 9 evolutions, the unions, the roster start
	# — resolves through the ONE effect(): the 9 evolved ids to their
	# row's constants, EVERYTHING ELSE to the ×1.0 identity with an empty
	# feat list (the IEEE guard the byte law rides).
	var bad: Array = []
	for id in WeaponSystem.IDS:
		var e: Dictionary = EvolutionSystem.effect(id)
		var expect: Dictionary = {"base": id}
		for bid in EvolutionSystem.TABLE:
			if EvolutionSystem.TABLE[bid].evo == id:
				expect = {"base": bid, "dmg": EvolutionSystem.TABLE[bid].dmg,
					"area": EvolutionSystem.TABLE[bid].area,
					"cd": EvolutionSystem.TABLE[bid].cd,
					"feat": EvolutionSystem.TABLE[bid].feat}
		if not expect.has("dmg"):
			expect = {"base": id, "dmg": EvolutionSystem.IDENTITY_DMG,
				"area": EvolutionSystem.IDENTITY_AREA,
				"cd": EvolutionSystem.IDENTITY_CD,
				"feat": EvolutionSystem.IDENTITY_FEAT}
		if e.dmg != expect.dmg or e.area != expect.area or e.cd != expect.cd \
				or e.base != expect.base or e.feat != expect.feat:
			bad.append(id)
	out.append({"ev": "evo_effect_identity", "ids": WeaponSystem.IDS.size(),
		"bad": bad, "ok": bad.is_empty()})
	return out


# THE pinned spec copy (M6-SPEC §3.2, MC 11697): the expected multipliers
# and feat columns live HERE as constants, read never from the live table
# — an instrument that derives its expectation from the object it tests is
# plant-immune (PS-E2's law: the planted nerf 1.6 -> 1.05 goes RED while
# the twin rows stay GREEN). table_match below is the other half: it names
# a table that drifts away from the spec copy.
const SPEC_BOOST := {"dmg": 1.6, "area": 1.35, "cd": 0.75}
const SPEC_FEATS := {
	"bone-whip": [], "dart-loop": ["pierce"], "hewn-axe": ["ret"],
	"pilgrim-cross": ["pierce"], "censer-of-hours": ["pierce"],
	"rot-water": [], "spectral-disc": ["extra"], "storm-peal": [],
	"fire-lash": ["extra"],
}


func _boost_row(root: Window, base: String) -> Dictionary:
	var row: Dictionary = EvolutionSystem.TABLE[base]
	var twin := _first_fire(root, base)
	var evo := _first_fire(root, String(row.evo))
	var want_feats: Array = SPEC_FEATS[base]
	var checks := {
		"dmg_row": evo.dmg == twin.dmg * SPEC_BOOST.dmg,
		"area_row": evo.r == twin.r * SPEC_BOOST.area,
		"cd_row": evo.cd == twin.cd * SPEC_BOOST.cd,
		"table_match": row.dmg == SPEC_BOOST.dmg and row.area == SPEC_BOOST.area \
			and row.cd == SPEC_BOOST.cd and row.feat == want_feats,
	}
	var evo_keys: Array = evo["keys"]
	var twin_keys: Array = twin["keys"]
	var added: Array = []
	for k in evo_keys:
		# String() ON PURPOSE: the feat flags are set with dict-property
		# syntax (bolts.back().pierce = true), which keys the entry with a
		# StringName — comparing raw keys against the String `want` list
		# would read false-negative on identical content.
		if twin_keys.find(k) < 0:
			added.append(String(k))
	var want: Array = []
	if want_feats.has("pierce"):
		want.append("pierce")
	if want_feats.has("ret"):
		want.append("ret")
	checks["feat_flags"] = added == want # empty-feat rows: NO key added
	checks["count_row"] = evo.count == twin.count + (1 if row.feat.has("extra") else 0)
	checks["twin_identity"] = twin.dmg > 0.0 and twin.cd > 0.0 and twin.count > 0
	var ok: bool = true
	for k in checks:
		ok = ok and checks[k]
	return {"ev": "evo_boost_row", "leg": "evo_boost_" + base, "base": base,
		"evo": row.evo, "row": {"dmg": row.dmg, "area": row.area,
			"cd": row.cd, "feat": row.feat},
		"twin": {"dmg": twin.dmg, "r": twin.r, "cd": twin.cd,
			"count": twin.count},
		"evolved": {"dmg": evo.dmg, "r": evo.r, "cd": evo.cd,
			"count": evo.count},
		"twin_keys": twin["keys"], "evo_keys": evo["keys"],
		"feat_added": added, "feat_want": want,
		"checks": checks, "ok": ok}


# One scripted first fire: fresh real funnel, the ONE weapon pinned at L5
# (cd 0 -> fires on the first tick, before any spawner wave), enemies
# pinned to the class's minimum observable set (2 where extra-target
# needs a second foe), then ONE run._step(DT). dmg: the dict entry's dmg
# key, or the pinned enemy's hp delta for the hp-delta classes (arc /
# ring / burst — the shipped _hit arms, the same S6 kill-leg precedent of
# hp observation). r: the entry's radius key (arcs.range, rings.r,
# bursts.r, bolts.r). cd: w.cd read ON the fire tick. count: entries
# appended (hp-delta classes append exactly one FX entry).
func _first_fire(root: Window, id: String) -> Dictionary:
	var run: Node = SimFunnel.fresh_run(root)
	var game = run.game
	var w := {"id": id, "level": 5, "cd": 0.0}
	game.weapons = [w]
	# passives stay at the shipped start_run zero-seed (the ONE identity
	# state: every passive rank 0 — clearing the dict would remove the
	# shipped pre-seeded keys the rate/magnet readers walk property-style).
	var eff: Dictionary = EvolutionSystem.effect(id)
	var foe := _synth("hound", 40.0, 0.0)
	# hp pinned at 64.0 — a POWER OF TWO: the one hp -= dmg round-trip
	# (64.0 − (64.0 − d) re-read as the delta) lands bit-exact on the
	# weapon's own IEEE dmg value for every pinned formula here (all dmg
	# < 64, the foe survives: no kill/xp noise enters the leg).
	foe.hp = 64.0
	foe.max_hp = 64.0
	foe.spd = 0.0
	foe.dmg = 0.0
	foe.xp = 0.0
	run.world.enemies.append(foe)
	if eff.feat.has("extra"):
		var foe2 := _synth("hound", 70.0, 30.0)
		foe2.hp = 64.0
		foe2.max_hp = 64.0
		foe2.spd = 0.0
		foe2.dmg = 0.0
		foe2.xp = 0.0
		run.world.enemies.append(foe2)
	var hp_before: float = foe.hp
	var before: Dictionary = _fx_counts(run)
	var entry_keys: Array = []
	run._step(DT)
	if game.phase == "levelup":
		game.pending_levels = 0
		game.set_phase("playing")
	var after: Dictionary = _fx_counts(run)
	var entry_count: int = 0
	var dmg_v: float = 0.0
	var r_v: float = 0.0
	var fx = run.fx
	for key in after:
		var grew: int = int(after[key]) - int(before.get(key, 0))
		if grew > 0:
			entry_count += grew
			var entries: Array = fx.get(key)
			var e: Dictionary = entries[entries.size() - 1]
			# the LAST grown array's entry carries the observable keys:
			# the feat flags are dict-key ADDITIONS on this entry (the
			# twin's identical entry is the no-addition baseline).
			entry_keys = e.keys()
			if e.has("dmg"):
				dmg_v = e.dmg
			if e.has("r"):
				r_v = e.r
			elif e.has("range"):
				r_v = e.range
	if dmg_v == 0.0:
		dmg_v = hp_before - foe.hp # the hp-delta classes: the _hit arm
	return {"dmg": dmg_v, "r": r_v, "cd": float(w.cd),
		"count": entry_count, "keys": entry_keys}


func _fx_counts(run) -> Dictionary:
	var fx = run.fx
	return {"bolts": fx.bolts.size(), "throws": fx.throws.size(),
		"arcs": fx.arcs.size(), "rings": fx.rings.size(),
		"bursts": fx.bursts.size()}
