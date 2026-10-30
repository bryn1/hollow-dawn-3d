# The fifteen auto-fire weapons (plan §5 six + PARITY-ROADMAP rev3 feature 6
# reason: >400 lines — 474 measured at MC 11316 §1.1; T-M6d (MC 11675)
# net -13 code / retirement provenance notes (490 measured at close): ONE _fire dispatch is
#   the ONE fire seam of the kill funnel (every weapon fires through _fire/
#   _hit below); the split alternative would fork the projectile seam
#   beside the fire dispatch and rides the RNG path — audit verdict: header.
# ten, T-M1h): talon, ember, cleaver, halo, ward, spike + bone-whip,
# dart-loop, hewn-axe, pilgrim-cross, censer-of-hours, rot-water, spectral-
# disc, storm-peal, fire-lash. All fire without player input;
# level scales damage/count/rate. M6 F6 (MC 11675, M6-SPEC §4.1/§4.4 R1): the
# sixteenth, DOOM SIGIL, is RETIRED WEAPON-SIDE here — id + META row + _fire
# arm out (offer universe 16→15, pool kinds 32→31; icons KEEP, per the icon
# law the .png stays); its screen-clear rides PICKUP-side as the RIVEN SIGIL
# counter-drop (drops.gd, §4.2). NF-8: that retirement also cuts the
# evolution table 10→9 at T-M6p. The nine REMAINING feature-6 weapons reuse
# the SIX effect
# classes verbatim (arcs/bolts/throws/bursts/rings/halos — the M1h capture
# carries the family mapping table); the brief's NO-NEW-VIZ-MECHANISM ruling
# maps rot-water's lingering zone onto the ward ring-tick class (declared
# deviation from the roadmap's "NEW zones list" cell; zones MM stays
# deferred, plan 40 unconsumed). Damage routes ONLY through _hit below.
# Since T-M2u (M2-SPEC rev-2 §D) the file also carries the TWO UNION
# orbiters (requiem-toll, dirge-eternal) in _update_orbit — union ids ride
# union.gd's table, never IDS/META (DA c3 C-2 math preserved), and their
# branches are compositions of the existing halo/spike/ward classes: the
# effect-class count stays SIX.
# M6 T-M6p (MC 11697, M6-SPEC §3.2): _fire opens with the ONE effect()
# resolution — evolved ids fire their FAMILY arm with the TABLE boosts at
# the existing sites (the ':' no-op hole closes for them; unknown ids keep
# the shipped no-op), every un-evolved fire rides the ×1.0/+0-flag
# identity (IEEE-identical bytes — the corpus guard); the feat flags OR
# onto the appended dicts through the EXISTING pierce/bounce/ret keys and
# the extra-target count term. EDITED UNDER SERIAL: first-owned by T-M6d
# (the §4.1 weapon-side retire), this card's edits land after its close.
# M6 T-M6f (MC 11705, M6-SPEC §2.1): every append dict gains ONE additive
# field `wid: String` — the firing weapon's id (evolved ids carry theirs,
# the union arms stamp theirs) at every append site (19). The renderer
# (viz_fx.gd's SKILL_FX) reads it for the per-skill look; the sim never
# does: array counts/caps UNTOUCHED (§2.1) — the field rides the dict keys
# exactly like the T-M6p feat flags do (both _first_fire twins gain it,
# the feat_flags diff-set math unaffected; the journey boost-tail key rows
# carry the addition, declared MEASURED in docs/BYTE-DEVIATION-M6.md).
class_name WeaponSystem
extends RefCounted

const IDS := ["talon", "ember", "cleaver", "halo", "ward", "spike",
	"bone-whip", "dart-loop", "hewn-axe", "pilgrim-cross", "censer-of-hours",
	"rot-water", "spectral-disc", "storm-peal", "fire-lash"]
	# M6 F6 (MC 11675): "doom-sigil" RETIRED here — weapon-side out of the
	# offer universe (pool 16→15); its screen-clear rides drops.gd's RIVEN
	# SIGIL counter-drop (§4.2); icon-doom-sigil.png KEEPS (icon law — the
	# file stays, the evolve-table row retires at T-M6p).
const MAX_LEVEL := 8

# M6 F4 (MC 11697 T-M6p, M6-SPEC §6.1): the desc column IS the spec's
# PINNED COPY — every pool weapon reads its FUNCTION line (shape +
# seeking/targeting + the class the player sees), non-empty, unique,
# ≤ 72 chars, pinned by tests/test_card_text.py (TX-E1).
const META := {
	"talon": {"name": "Talon Lash", "icon": "icon-talon", "desc": "Arc in front of you — hits everything you face"},
	"ember": {"name": "Ember Bolt", "icon": "icon-ember", "desc": "Seeking bolts — nearest foe first, more at higher Lv"},
	"cleaver": {"name": "Bone Cleaver", "icon": "icon-cleaver", "desc": "Heavy arcing throw, one hit per landing"},
	"halo": {"name": "Cinder Halo", "icon": "icon-halo", "desc": "Cinders orbit you — tick-damage on contact"},
	"ward": {"name": "Warding Aura", "icon": "icon-ward", "desc": "Aura at your feet — continuous tick on everything close"},
	"spike": {"name": "Grave Spike", "icon": "icon-spike", "desc": "Ground burst under the DENSEST cluster"},
	"bone-whip": {"name": "Bone Whip", "icon": "icon-bone-whip", "desc": "Piercing line ahead — passes through with a tick cadence"},
	"dart-loop": {"name": "Dart Loop", "icon": "icon-dart-loop", "desc": "Rapid facing darts — +1 per Twin Runes"},
	"hewn-axe": {"name": "Hewn Axe", "icon": "icon-hewn-axe", "desc": "Heavy returning-free axe throw — pierces, ticking"},
	"pilgrim-cross": {"name": "Pilgrim Cross", "icon": "icon-pilgrim-cross", "desc": "Throw that curves back home"},
	"censer-of-hours": {"name": "Censer of Hours", "icon": "icon-censer-of-hours", "desc": "Cross volley — 4 bolts turning with you"},
	"rot-water": {"name": "Rot Water", "icon": "icon-rot-water", "desc": "Rot ring at your feet — ticking zone"},
	"spectral-disc": {"name": "Spectral Disc", "icon": "icon-spectral-disc", "desc": "Piercing disc — bounces off the playfield edge"},
	"storm-peal": {"name": "Storm Peal", "icon": "icon-storm-peal", "desc": "Lightning at a RANDOM foe in the field"},
	"fire-lash": {"name": "Fire Lash", "icon": "icon-fire-lash", "desc": "Heavy bolt at a random foe — +1 per Twin Runes"},
	# M6 F6: the "doom-sigil" META row RETIRED with the id (pool 16→15, §4.1).
}

const BOLT_SPEED := 300.0
const THROW_SPEED := 260.0
# Spectral Disc "edge" (M1h, declared): the world has no fixed arena (the
# ground re-centres on the player — ground.gd header), so the ONE edge is
# the playfield ring around the survivor; the disc reflects there.
const DISC_BOUNCE_R := 460.0

# Transient state read by the renderer each frame.
var bolts: Array = []
var throws: Array = []
var bursts: Array = []
var arcs: Array = []
var rings: Array = []
var halos: Array = []

var _world: GameWorld
var _game: GameState # late-bound by main at boot


func bind(world: GameWorld, game: GameState) -> void:
	_world = world
	_game = game
	# M6 F6 (MC 11675): the sigil clear's ONE ring mark rides THIS shipped
	# rings transient — the weapon-side retirement MOVED the screen-clear
	# moment to drops.gd, whose fx_rings seam is bound HERE, inside the
	# shipped bind call (main.gd stays untouched; the clear arm never fires
	# unless a sigil is touched, so this line changes no shipped behaviour).
	_world.drops.bind_fx(rings)


func clear_fx() -> void:
	bolts.clear()
	throws.clear()
	bursts.clear()
	arcs.clear()
	rings.clear()
	halos.clear()


static func rate(level: int, base: float) -> float:
	return base * pow(0.96, level - 1)


# M6 T-M6p §3.2: the extra-target feat term — +1 count for evolved rows
# that carry it, EXACTLY +0 (int identity) for every un-evolved fire.
static func _feat_extra(eff: Dictionary) -> int:
	return 1 if eff.feat.has("extra") else 0


func update(dt: float, game: GameState) -> void:
	# §D unions ride the halo orbit class: the ONE halos list is recomputed
	# every step — cleared ONCE here (it lived inside _update_halo, its
	# only writer until T-M2u added the two union orbiters sharing it) —
	# then every orbit weapon appends its own orbs. Pre-union builds get
	# the byte-identical sequence (a lone halo clears then appends in the
	# same step, exactly as before).
	halos.clear()
	for w in game.weapons:
		# M6 T-M6p §3.2: the orbit branch list keys through effect().base —
		# the ONE resolution (un-evolved ids and the union ids are the
		# identity; a halo-family EVOLVED id would ride the same branch).
		var orbit_base: String = EvolutionSystem.effect(w.id).base
		if orbit_base == "halo" or orbit_base == "requiem-toll" \
				or orbit_base == "dirge-eternal":
			_update_orbit(w, dt, game)
			continue
		w.cd -= dt
		if w.cd > 0.0:
			continue
		_fire(w, game)
	_step_projectiles(dt)
	_step_fx(dt)


func _nearest(game: GameState, count: int) -> Array:
	var p: Dictionary = game.player
	var sorted := _world.enemies.duplicate()
	sorted.sort_custom(func(a, b): return _dist2(a, p) < _dist2(b, p))
	return sorted.slice(0, count)


static func _dist2(a: Dictionary, b: Dictionary) -> float:
	var dx: float = a.x - b.x
	var dy: float = a.y - b.y
	return dx * dx + dy * dy


# Every weapon routes damage through this single entry (ported from main.js).
func _hit(area: Dictionary, dmg: float, ticked := false) -> int:
	var n := 0
	var alive: Array = _world.enemies.duplicate()
	for e in alive:
		var er: float = 55.0 if e.boss else 17.0
		var dx: float = e.x - area.x
		var dy: float = e.y - area.y
		var reach: float = area.r + er
		if dx * dx + dy * dy > reach * reach:
			continue
		if area.has("half"):
			var da: float = atan2(dy, dx) - area.ang
			if absf(atan2(sin(da), cos(da))) > area.half:
				continue
		if ticked:
			if e.hit_cd > 0.0:
				continue
			e.hit_cd = 0.3
		e.hp -= dmg
		n += 1
		if e.hp <= 0.0:
			_world.kill_enemy(_game, e)
	return n


func _fire(w: Dictionary, game: GameState) -> void:
	var p: Dictionary = game.player
	var mul := game.damage_multiplier()
	var l: int = w.level
	# M6 T-M6p (M6-SPEC §3.2): the ONE resolution. An evolved id fires its
	# FAMILY branch (eff.base) with the TABLE row's boosts consumed at the
	# existing sites (mul × eff.dmg, radii/range × eff.area, cd × eff.cd,
	# eff.feat ORed onto the appended dicts through the EXISTING flags).
	# Un-evolved ids — and the union ids, whose behaviour already lives in
	# the orbit branches — take the ×1.0/+0-flag identity, so every
	# non-evolved weapon's math stays IEEE-identical (the limit-break
	# precedent). The ':' no-op hole below is thereby closed for evolved
	# ids: they resolve to their family arm HERE and FIRE (F-3's forced
	# consequence); unknown ids keep the shipped no-op semantics (R1).
	var eff := EvolutionSystem.effect(w.id)
	match eff.base:
		"talon":
			w.cd = rate(l, 0.55) * eff.cd
			var ang := atan2(p.dir_y, p.dir_x)
			var half := 0.62
			var range_px: float = (90.0 + 4.0 * l) * eff.area
			_hit({"x": p.x, "y": p.y, "r": range_px, "half": half, "ang": ang},
				(6.0 + 3.0 * l) * mul * eff.dmg)
			arcs.append({"ang": ang, "half": half, "range": range_px, "life": 0.15,
				"max": 0.15, "wid": w.id})
		"ember":
			var targets := _nearest(game, 1 + int((l - 1) / 3))
			if targets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 0.85) * eff.cd
			for t in targets:
				var d := maxf(sqrt(_dist2(t, p)), 1.0)
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / d * BOLT_SPEED,
					"vy": (t.y - p.y) / d * BOLT_SPEED,
					"dmg": (9.0 + 4.0 * l) * mul * eff.dmg, "life": 1.1,
					"r": 9.0 * eff.area, "wid": w.id,
				})
		"cleaver":
			var ctargets := _nearest(game, 1 + int((l - 1) / 4))
			if ctargets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 1.15) * eff.cd
			for t in ctargets:
				var cd := maxf(sqrt(_dist2(t, p)), 1.0)
				throws.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / cd * THROW_SPEED,
					"vy": (t.y - p.y) / cd * THROW_SPEED,
					"dmg": (15.0 + 6.0 * l) * mul * eff.dmg, "life": cd / THROW_SPEED,
					"travel": cd, "dist": 0.0, "r": 12.0 * eff.area, "wid": w.id,
				})
		"ward":
			w.cd = 0.45 * eff.cd
			_hit({"x": p.x, "y": p.y, "r": 80.0 * eff.area},
				(4.0 + 2.0 * l) * mul * eff.dmg, true)
			rings.append({"r": 80.0 * eff.area, "life": 0.12, "max": 0.12,
				"wid": w.id})
		"spike":
			var burst_r: float = 56.0 * eff.area
			var best: Dictionary = {}
			var best_n := 0
			for cand in _world.enemies:
				var n := 0
				for e in _world.enemies:
					if _dist2(cand, e) < burst_r * burst_r:
						n += 1
				if n > best_n:
					best_n = n
					best = cand
			if best.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 2.6) * eff.cd
			_hit({"x": best.x, "y": best.y, "r": burst_r},
				(18.0 + 7.0 * l) * mul * eff.dmg)
			bursts.append({"x": best.x, "y": best.y, "r": burst_r, "life": 0.25,
				"max": 0.25, "wid": w.id})
		# ---- feature-6 roster (T-M1h): the ten new weapons, each riding an
		# EXISTING effect class — no new viz mechanism (family mapping table
		# in the M1h capture). Partner passives read at the spawn math of
		# THIS block (v1-era weapons' numbers are S4 byte-pins, STAY-GREEN).
		"bone-whip": # class: talon arc — piercing (full-sector) line ahead
			w.cd = rate(l, 0.75) * eff.cd
			var wang := atan2(p.dir_y, p.dir_x)
			var whalf := 0.30
			var wrange: float = (100.0 + 4.0 * l) * game.area_mult() * eff.area
			_hit({"x": p.x, "y": p.y, "r": wrange, "half": whalf, "ang": wang},
				(7.0 + 3.0 * l) * mul * eff.dmg)
			arcs.append({"ang": wang, "half": whalf, "range": wrange,
				"life": 0.18, "max": 0.18, "wid": w.id})
		"dart-loop": # class: ember bolts — rapid faced shots
			w.cd = rate(l, 0.42) * eff.cd
			var dn := 1 + int((l - 1) / 3) + game.extra_projectiles() \
					+ _feat_extra(eff)
			var dd2 := maxf(sqrt(p.dir_x * p.dir_x + p.dir_y * p.dir_y), 0.001)
			var dsp: float = BOLT_SPEED * 1.2 * game.proj_speed_mult()
			for di in dn:
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": p.dir_x / dd2 * dsp, "vy": p.dir_y / dd2 * dsp,
					"dmg": (5.0 + 2.5 * l) * mul * eff.dmg,
					"life": 0.8 * game.duration_mult(),
					"r": 8.0 * eff.area, "wid": w.id,
				})
				# M6 T-M6p feat OR (THOUSAND DARTS pierces; un-evolved dart
				# loop takes the empty-feat identity — no key added, the
				# shipped projectile dict is byte-unchanged).
				if eff.feat.has("pierce"):
					bolts.back().pierce = true
		"hewn-axe": # class: cleaver throws — heavy axe throws
			var xtargets := _nearest(game, 1 + int((l - 1) / 4) + game.extra_projectiles())
			if xtargets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 1.7) * eff.cd
			for t in xtargets:
				var xd := maxf(sqrt(_dist2(t, p)), 1.0)
				var xsp: float = THROW_SPEED * 1.1 * game.proj_speed_mult()
				throws.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / xd * xsp, "vy": (t.y - p.y) / xd * xsp,
					"dmg": (20.0 + 8.0 * l) * mul * eff.dmg, "life": xd / xsp,
					"travel": xd, "dist": 0.0, "r": 13.0 * eff.area,
					"pierce": true, "wid": w.id, # roadmap "throws + pierce" (tick)
				})
				# M6 T-M6p feat OR (ROT SPIRAL returns — the ONE return flag
				# on the shipped stepper; base axe keeps returning-free).
				if eff.feat.has("ret"):
					throws.back().ret = true
		"pilgrim-cross": # class: cleaver throws — boomerang return-throw
			var ktargets := _nearest(game, 1 + game.extra_projectiles())
			if ktargets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 2.2) * eff.cd
			for t in ktargets:
				var kd := maxf(sqrt(_dist2(t, p)), 1.0)
				var ksp: float = THROW_SPEED * 1.1 * game.proj_speed_mult()
				throws.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / kd * ksp, "vy": (t.y - p.y) / kd * ksp,
					"dmg": (14.0 + 5.0 * l) * mul * eff.dmg,
					"life": 2.5 * kd / ksp,
					"travel": kd * 1.25, "dist": 0.0, "r": 11.0 * eff.area,
					"ret": true, "wid": w.id, # the ONE return flag (step flips home)
				})
				# M6 T-M6p feat OR (JUDGEMENT CROSS pierces on the way).
				if eff.feat.has("pierce"):
					throws.back().pierce = true
		"censer-of-hours": # class: ember bolts — cross-pattern volley
			w.cd = rate(l, 1.3) * eff.cd
			if not w.has("orbit"):
				w.orbit = 0.0
			w.orbit = fmod(w.orbit + 0.6, TAU)
			var cvsp: float = BOLT_SPEED * 0.9 * game.proj_speed_mult()
			for ci in 4:
				var ca: float = w.orbit + float(ci) * PI / 2.0
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": cos(ca) * cvsp, "vy": sin(ca) * cvsp,
					"dmg": (8.0 + 3.5 * l) * mul * eff.dmg,
					"life": 1.0 * game.duration_mult(),
					"r": 9.0 * eff.area, "wid": w.id,
				})
				# M6 T-M6p feat OR (ETERNAL MATINS pierces the whole cross).
				if eff.feat.has("pierce"):
					bolts.back().pierce = true
		"rot-water": # class: ward ring-tick — rotting zone at the feet
			w.cd = 0.7 * eff.cd
			var zr: float = (60.0 + 3.0 * l) * game.area_mult() * eff.area
			_hit({"x": p.x, "y": p.y, "r": zr}, (3.0 + 1.6 * l) * mul * eff.dmg, true)
			rings.append({"r": zr, "life": 0.3, "max": 0.3, "wid": w.id})
		"spectral-disc": # class: ember bolts — piercing, playfield-edge bounce
			var stargets := _nearest(game, 1 + game.extra_projectiles() \
					+ _feat_extra(eff)) # GRAVE ORBIT: +1 disc (extra-target)
			if stargets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 1.5) * eff.cd
			var sspd: float = BOLT_SPEED * 0.8 * game.proj_speed_mult()
			for t in stargets:
				var sd := maxf(sqrt(_dist2(t, p)), 1.0)
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / sd * sspd, "vy": (t.y - p.y) / sd * sspd,
					"dmg": (12.0 + 5.0 * l) * mul * eff.dmg,
					"life": 2.5 * game.duration_mult(),
					"r": 11.0 * eff.area, "pierce": true, "bounce": true,
					"wid": w.id,
				})
		"storm-peal": # class: spike burst — strike at a RANDOM foe
			if _world.enemies.is_empty():
				w.cd = 0.0
				return
			var struck: Dictionary = _world.enemies[randi() % _world.enemies.size()]
			w.cd = rate(l, 2.0) * eff.cd
			var spr: float = 48.0 * game.area_mult() * eff.area
			_hit({"x": struck.x, "y": struck.y, "r": spr},
				(12.0 + 5.0 * l) * mul * eff.dmg)
			bursts.append({"x": struck.x, "y": struck.y, "r": spr,
				"life": 0.25, "max": 0.25, "wid": w.id})
		"fire-lash": # class: ember bolts — heavy bolt at a random foe
			if _world.enemies.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 1.4) * eff.cd
			var flsp: float = BOLT_SPEED * 0.75 * game.proj_speed_mult()
			for fi in 1 + game.extra_projectiles() + _feat_extra(eff):
				# INFERNO LASH: extra-target = +1 heavy bolt (extra)
				var pick: Dictionary = _world.enemies[randi() % _world.enemies.size()]
				var fd := maxf(sqrt(_dist2(pick, p)), 1.0)
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": (pick.x - p.x) / fd * flsp, "vy": (pick.y - p.y) / fd * flsp,
					"dmg": (16.0 + 6.0 * l) * mul * eff.dmg,
					"life": 1.5 * game.duration_mult(),
					"r": 13.0 * eff.area, "wid": w.id,
				})
		_:
			w.cd = 1.0 # evolved ids ride the T-M1e rule: fire no-ops unknown
			# ids until their own behavior card lands (sim_budget states this
			# shipped semantics; the pool never offers an evolved id).


# Orbit positions are continuous (no cooldown): recomputed every step for
# the halo class (v1 branch, byte-verbatim numbers — S4 pins) AND the two
# M2 §D unions, all sharing the ONE halos list (cleared in update). The
# union branches are COMPOSITIONS of the existing branches, no new viz
# mechanism (standing ruling):
#  * requiem-toll = THIS orbit branch ∩ the spike cluster burst — orbiting
#    burst-cinders ride halos + bursts (spec D.1 row "reuses halos +
#    bursts"), its volley targets the densest cluster AT fire time (the
#    spike semantic; projectiles then fly through the ONE _hit entry).
#  * dirge-eternal = the ward/rot-water ring-TICK zone class ∩ this orbit
#    branch — spec D.1 row "reuses the zones MM + halos"; the zones MM has
#    stayed DEFERRED since the T-M1h declared mapping (rot-water's zone
#    rides the ward ring-tick class), so the orbiting zone rides that SAME
#    class: ticked hits along the orbit band + the ONE ring pulse class +
#    halos for the orbs. Our numbers on both rows.
func _update_orbit(w: Dictionary, dt: float, game: GameState) -> void:
	var p: Dictionary = game.player
	var mul := game.damage_multiplier()
	if not w.has("orbit"):
		w.orbit = 0.0
	# M6 T-M6p §3.2: the orbit arms key through the ONE effect() base
	# (union ids and halo are the identity; halo-family evolutions would
	# ride the `_:` arm — the same single expression as update()'s list).
	match EvolutionSystem.effect(w.id).base:
		"requiem-toll":
			var rl: int = w.level
			w.orbit = fmod(w.orbit + (2.4 + 0.08 * rl) * dt, TAU)
			var rc := 1 + int(ceil(rl / 3.0))
			var rr: float = 58.0 + 3.0 * rl
			var rd: float = (8.0 + 2.5 * rl) * mul
			for i in rc:
				var a: float = w.orbit + i * TAU / rc
				var ox: float = p.x + cos(a) * rr
				var oy: float = p.y + sin(a) * rr
				halos.append({"x": ox, "y": oy, "wid": w.id})
				_hit({"x": ox, "y": oy, "r": 17.0}, rd, true)
			w.cd -= dt
			if w.cd <= 0.0:
				w.cd = rate(rl, 2.2)
				var burst_r := 60.0
				var best: Dictionary = {}
				var best_n := 0
				for cand in _world.enemies:
					var n := 0
					for e in _world.enemies:
						if _dist2(cand, e) < burst_r * burst_r:
							n += 1
					if n > best_n:
						best_n = n
						best = cand
				if best.is_empty():
					return
				_hit({"x": best.x, "y": best.y, "r": burst_r},
					(20.0 + 8.0 * rl) * mul)
				bursts.append({"x": best.x, "y": best.y, "r": burst_r,
					"life": 0.25, "max": 0.25, "wid": w.id})
		"dirge-eternal":
			var dl: int = w.level
			w.orbit = fmod(w.orbit + (1.8 + 0.06 * dl) * dt, TAU)
			var dc := 1 + int(ceil(dl / 3.0))
			var dr: float = 50.0 + 3.0 * dl
			var dz: float = (28.0 + 2.0 * dl) * game.area_mult()
			var dd: float = (5.0 + 2.0 * dl) * mul
			for i in dc:
				var da: float = w.orbit + i * TAU / dc
				var ox2: float = p.x + cos(da) * dr
				var oy2: float = p.y + sin(da) * dr
				halos.append({"x": ox2, "y": oy2, "wid": w.id})
				_hit({"x": ox2, "y": oy2, "r": dz}, dd, true)
			w.cd -= dt
			if w.cd <= 0.0:
				w.cd = 0.7
				var fz: float = dr + dz
				_hit({"x": p.x, "y": p.y, "r": fz},
					(4.0 + 1.5 * dl) * mul, true)
				rings.append({"r": fz, "life": 0.5, "max": 0.5, "wid": w.id})
		_:
			w.orbit = fmod(w.orbit + (2.4 + 0.08 * w.level) * dt, TAU)
			var count := 1 + int(ceil(w.level / 3.0))
			var radius: float = 52.0 + 3.0 * w.level
			var dmg: float = (6.0 + 2.0 * w.level) * mul
			for i in count:
				var a2: float = w.orbit + i * TAU / count
				var hx: float = p.x + cos(a2) * radius
				var hy: float = p.y + sin(a2) * radius
				halos.append({"x": hx, "y": hy, "wid": w.id})
				_hit({"x": hx, "y": hy, "r": 17.0}, dmg, true)


# Bolts and throws are single-hit: they vanish on the frame they land.
# M1h roster flags (feature 6, NO new classes — same steppers): "pierce"
# bolts ride through (ticked hits pace the re-tick at the pinned 0.3 s),
# "bounce" bolts reflect off the DISC_BOUNCE_R playfield ring, "ret" throws
# flip heading home once past their travel. Unflagged projectiles take the
# exact v1 path (byte-stable legs; the S4 pin `b.x += b.vx * dt` stays).
func _step_projectiles(dt: float) -> void:
	for i in range(bolts.size() - 1, -1, -1):
		var b: Dictionary = bolts[i]
		b.x += b.vx * dt
		b.y += b.vy * dt
		b.life -= dt
		var landed := false
		if b.get("pierce", false):
			_hit({"x": b.x, "y": b.y, "r": b.r}, b.dmg, true)
		else:
			landed = _hit({"x": b.x, "y": b.y, "r": b.r}, b.dmg) > 0
		if b.get("bounce", false):
			var p: Dictionary = _game.player
			var bdx: float = b.x - p.x
			var bdy: float = b.y - p.y
			var bd := maxf(sqrt(bdx * bdx + bdy * bdy), 1e-6)
			if bd > DISC_BOUNCE_R:
				var nx := bdx / bd
				var ny := bdy / bd
				var dn: float = b.vx * nx + b.vy * ny
				b.vx -= 2.0 * dn * nx
				b.vy -= 2.0 * dn * ny
		if landed or b.life <= 0.0:
			bolts.remove_at(i)
	for i in range(throws.size() - 1, -1, -1):
		var t: Dictionary = throws[i]
		if t.get("ret", false) and not t.get("coming", false) \
				and t.dist >= t.travel:
			t.coming = true # the ONE turn: head home at the launch speed
			var tp: Dictionary = _game.player
			var td := maxf(sqrt((tp.x - t.x) * (tp.x - t.x) \
					+ (tp.y - t.y) * (tp.y - t.y)), 1.0)
			var tsp := sqrt(t.vx * t.vx + t.vy * t.vy)
			t.vx = (tp.x - t.x) / td * tsp
			t.vy = (tp.y - t.y) / td * tsp
		t.x += t.vx * dt
		t.y += t.vy * dt
		t.dist += THROW_SPEED * dt
		t.life -= dt
		var tlanded := false
		if t.get("pierce", false):
			_hit({"x": t.x, "y": t.y, "r": t.r}, t.dmg, true)
		else:
			tlanded = _hit({"x": t.x, "y": t.y, "r": t.r}, t.dmg) > 0
		if tlanded or t.life <= 0.0:
			throws.remove_at(i)


func _step_fx(dt: float) -> void:
	for list in [arcs, rings, bursts]:
		for i in range(list.size() - 1, -1, -1):
			list[i].life -= dt
			if list[i].life <= 0.0:
				list.remove_at(i)
