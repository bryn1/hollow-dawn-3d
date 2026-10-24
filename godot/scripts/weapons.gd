# The sixteen auto-fire weapons (plan §5 six + PARITY-ROADMAP rev3 feature 6
# ten, T-M1h): talon, ember, cleaver, halo, ward, spike + bone-whip,
# dart-loop, hewn-axe, pilgrim-cross, censer-of-hours, rot-water, spectral-
# disc, storm-peal, fire-lash, doom-sigil. All fire without player input;
# level scales damage/count/rate. The ten NEW weapons reuse the SIX effect
# classes verbatim (arcs/bolts/throws/bursts/rings/halos — the M1h capture
# carries the family mapping table); the brief's NO-NEW-VIZ-MECHANISM ruling
# maps rot-water's lingering zone onto the ward ring-tick class (declared
# deviation from the roadmap's "NEW zones list" cell; zones MM stays
# deferred, plan 40 unconsumed). Damage routes ONLY through _hit below.
class_name WeaponSystem
extends RefCounted

const IDS := ["talon", "ember", "cleaver", "halo", "ward", "spike",
	"bone-whip", "dart-loop", "hewn-axe", "pilgrim-cross", "censer-of-hours",
	"rot-water", "spectral-disc", "storm-peal", "fire-lash", "doom-sigil"]
const MAX_LEVEL := 8

const META := {
	"talon": {"name": "Talon Lash", "icon": "icon-talon", "desc": "Raking arc in front of you"},
	"ember": {"name": "Ember Bolt", "icon": "icon-ember", "desc": "Bolts seek the nearest foe"},
	"cleaver": {"name": "Bone Cleaver", "icon": "icon-cleaver", "desc": "Heavy arcing throws"},
	"halo": {"name": "Cinder Halo", "icon": "icon-halo", "desc": "Cinders orbit around you"},
	"ward": {"name": "Warding Aura", "icon": "icon-ward", "desc": "Sears all who come close"},
	"spike": {"name": "Grave Spike", "icon": "icon-spike", "desc": "Bursts under the densest cluster"},
	"bone-whip": {"name": "Bone Whip", "icon": "icon-bone-whip", "desc": "Piercing line ahead"},
	"dart-loop": {"name": "Dart Loop", "icon": "icon-dart-loop", "desc": "Rapid faced darts"},
	"hewn-axe": {"name": "Hewn Axe", "icon": "icon-hewn-axe", "desc": "Heavy axe throws"},
	"pilgrim-cross": {"name": "Pilgrim Cross", "icon": "icon-pilgrim-cross", "desc": "Throw that comes back"},
	"censer-of-hours": {"name": "Censer of Hours", "icon": "icon-censer-of-hours", "desc": "Cross-pattern volley"},
	"rot-water": {"name": "Rot Water", "icon": "icon-rot-water", "desc": "Rot ring sears your feet"},
	"spectral-disc": {"name": "Spectral Disc", "icon": "icon-spectral-disc", "desc": "Piercing bouncing disc"},
	"storm-peal": {"name": "Storm Peal", "icon": "icon-storm-peal", "desc": "Strikes random foes"},
	"fire-lash": {"name": "Fire Lash", "icon": "icon-fire-lash", "desc": "Heavy bolt, random foe"},
	"doom-sigil": {"name": "Doom Sigil", "icon": "icon-doom-sigil", "desc": "Rare screen-clear blast"},
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


func clear_fx() -> void:
	bolts.clear()
	throws.clear()
	bursts.clear()
	arcs.clear()
	rings.clear()
	halos.clear()


static func rate(level: int, base: float) -> float:
	return base * pow(0.96, level - 1)


func update(dt: float, game: GameState) -> void:
	for w in game.weapons:
		if w.id == "halo":
			_update_halo(w, dt, game)
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
	match w.id:
		"talon":
			w.cd = rate(l, 0.55)
			var ang := atan2(p.dir_y, p.dir_x)
			var half := 0.62
			var range_px := 90.0 + 4.0 * l
			_hit({"x": p.x, "y": p.y, "r": range_px, "half": half, "ang": ang},
				(6.0 + 3.0 * l) * mul)
			arcs.append({"ang": ang, "half": half, "range": range_px, "life": 0.15, "max": 0.15})
		"ember":
			var targets := _nearest(game, 1 + int((l - 1) / 3))
			if targets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 0.85)
			for t in targets:
				var d := maxf(sqrt(_dist2(t, p)), 1.0)
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / d * BOLT_SPEED,
					"vy": (t.y - p.y) / d * BOLT_SPEED,
					"dmg": (9.0 + 4.0 * l) * mul, "life": 1.1, "r": 9.0,
				})
		"cleaver":
			var ctargets := _nearest(game, 1 + int((l - 1) / 4))
			if ctargets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 1.15)
			for t in ctargets:
				var cd := maxf(sqrt(_dist2(t, p)), 1.0)
				throws.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / cd * THROW_SPEED,
					"vy": (t.y - p.y) / cd * THROW_SPEED,
					"dmg": (15.0 + 6.0 * l) * mul, "life": cd / THROW_SPEED,
					"travel": cd, "dist": 0.0, "r": 12.0,
				})
		"ward":
			w.cd = 0.45
			_hit({"x": p.x, "y": p.y, "r": 80.0}, (4.0 + 2.0 * l) * mul, true)
			rings.append({"r": 80.0, "life": 0.12, "max": 0.12})
		"spike":
			var burst_r := 56.0
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
			w.cd = rate(l, 2.6)
			_hit({"x": best.x, "y": best.y, "r": burst_r}, (18.0 + 7.0 * l) * mul)
			bursts.append({"x": best.x, "y": best.y, "r": burst_r, "life": 0.25, "max": 0.25})
		# ---- feature-6 roster (T-M1h): the ten new weapons, each riding an
		# EXISTING effect class — no new viz mechanism (family mapping table
		# in the M1h capture). Partner passives read at the spawn math of
		# THIS block (v1-era weapons' numbers are S4 byte-pins, STAY-GREEN).
		"bone-whip": # class: talon arc — piercing (full-sector) line ahead
			w.cd = rate(l, 0.75)
			var wang := atan2(p.dir_y, p.dir_x)
			var whalf := 0.30
			var wrange: float = (100.0 + 4.0 * l) * game.area_mult()
			_hit({"x": p.x, "y": p.y, "r": wrange, "half": whalf, "ang": wang},
				(7.0 + 3.0 * l) * mul)
			arcs.append({"ang": wang, "half": whalf, "range": wrange,
				"life": 0.18, "max": 0.18})
		"dart-loop": # class: ember bolts — rapid faced shots
			w.cd = rate(l, 0.42)
			var dn := 1 + int((l - 1) / 3) + game.extra_projectiles()
			var dd2 := maxf(sqrt(p.dir_x * p.dir_x + p.dir_y * p.dir_y), 0.001)
			var dsp: float = BOLT_SPEED * 1.2 * game.proj_speed_mult()
			for di in dn:
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": p.dir_x / dd2 * dsp, "vy": p.dir_y / dd2 * dsp,
					"dmg": (5.0 + 2.5 * l) * mul, "life": 0.8 * game.duration_mult(),
					"r": 8.0,
				})
		"hewn-axe": # class: cleaver throws — heavy axe throws
			var xtargets := _nearest(game, 1 + int((l - 1) / 4) + game.extra_projectiles())
			if xtargets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 1.7)
			for t in xtargets:
				var xd := maxf(sqrt(_dist2(t, p)), 1.0)
				var xsp: float = THROW_SPEED * 1.1 * game.proj_speed_mult()
				throws.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / xd * xsp, "vy": (t.y - p.y) / xd * xsp,
					"dmg": (20.0 + 8.0 * l) * mul, "life": xd / xsp,
					"travel": xd, "dist": 0.0, "r": 13.0,
					"pierce": true, # roadmap "throws + pierce" (tick-paced)
				})
		"pilgrim-cross": # class: cleaver throws — boomerang return-throw
			var ktargets := _nearest(game, 1 + game.extra_projectiles())
			if ktargets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 2.2)
			for t in ktargets:
				var kd := maxf(sqrt(_dist2(t, p)), 1.0)
				var ksp: float = THROW_SPEED * 1.1 * game.proj_speed_mult()
				throws.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / kd * ksp, "vy": (t.y - p.y) / kd * ksp,
					"dmg": (14.0 + 5.0 * l) * mul, "life": 2.5 * kd / ksp,
					"travel": kd * 1.25, "dist": 0.0, "r": 11.0,
					"ret": true, # the ONE return flag (step flips heading home)
				})
		"censer-of-hours": # class: ember bolts — cross-pattern volley
			w.cd = rate(l, 1.3)
			if not w.has("orbit"):
				w.orbit = 0.0
			w.orbit = fmod(w.orbit + 0.6, TAU)
			var cvsp: float = BOLT_SPEED * 0.9 * game.proj_speed_mult()
			for ci in 4:
				var ca: float = w.orbit + float(ci) * PI / 2.0
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": cos(ca) * cvsp, "vy": sin(ca) * cvsp,
					"dmg": (8.0 + 3.5 * l) * mul, "life": 1.0 * game.duration_mult(),
					"r": 9.0,
				})
		"rot-water": # class: ward ring-tick — rotting zone at the feet
			w.cd = 0.7
			var zr: float = (60.0 + 3.0 * l) * game.area_mult()
			_hit({"x": p.x, "y": p.y, "r": zr}, (3.0 + 1.6 * l) * mul, true)
			rings.append({"r": zr, "life": 0.3, "max": 0.3})
		"spectral-disc": # class: ember bolts — piercing, playfield-edge bounce
			var stargets := _nearest(game, 1 + game.extra_projectiles())
			if stargets.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 1.5)
			var sspd: float = BOLT_SPEED * 0.8 * game.proj_speed_mult()
			for t in stargets:
				var sd := maxf(sqrt(_dist2(t, p)), 1.0)
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": (t.x - p.x) / sd * sspd, "vy": (t.y - p.y) / sd * sspd,
					"dmg": (12.0 + 5.0 * l) * mul, "life": 2.5 * game.duration_mult(),
					"r": 11.0, "pierce": true, "bounce": true,
				})
		"storm-peal": # class: spike burst — strike at a RANDOM foe
			if _world.enemies.is_empty():
				w.cd = 0.0
				return
			var struck: Dictionary = _world.enemies[randi() % _world.enemies.size()]
			w.cd = rate(l, 2.0)
			var spr: float = 48.0 * game.area_mult()
			_hit({"x": struck.x, "y": struck.y, "r": spr}, (12.0 + 5.0 * l) * mul)
			bursts.append({"x": struck.x, "y": struck.y, "r": spr,
				"life": 0.25, "max": 0.25})
		"fire-lash": # class: ember bolts — heavy bolt at a random foe
			if _world.enemies.is_empty():
				w.cd = 0.0
				return
			w.cd = rate(l, 1.4)
			var flsp: float = BOLT_SPEED * 0.75 * game.proj_speed_mult()
			for fi in 1 + game.extra_projectiles():
				var pick: Dictionary = _world.enemies[randi() % _world.enemies.size()]
				var fd := maxf(sqrt(_dist2(pick, p)), 1.0)
				bolts.append({
					"x": p.x, "y": p.y,
					"vx": (pick.x - p.x) / fd * flsp, "vy": (pick.y - p.y) / fd * flsp,
					"dmg": (16.0 + 6.0 * l) * mul, "life": 1.5 * game.duration_mult(),
					"r": 13.0,
				})
		"doom-sigil": # class: ward ring + ONE full-screen _hit — long cd
			w.cd = rate(l, 12.0)
			_hit({"x": p.x, "y": p.y, "r": 760.0}, (40.0 + 14.0 * l) * mul)
			rings.append({"r": 760.0, "life": 0.5, "max": 0.5})
		_:
			w.cd = 1.0 # evolved ids ride the T-M1e rule: fire no-ops unknown
			# ids until their own behavior card lands (sim_budget states this
			# shipped semantics; the pool never offers an evolved id).


# Orbit positions are continuous (no cooldown): recomputed every step.
func _update_halo(w: Dictionary, dt: float, game: GameState) -> void:
	var p: Dictionary = game.player
	var mul := game.damage_multiplier()
	var count := 1 + int(ceil(w.level / 3.0))
	var radius: float = 52.0 + 3.0 * w.level
	var speed: float = 2.4 + 0.08 * w.level
	var dmg: float = (6.0 + 2.0 * w.level) * mul
	if not w.has("orbit"):
		w.orbit = 0.0
	w.orbit = fmod(w.orbit + speed * dt, TAU)
	halos.clear()
	for i in count:
		var a: float = w.orbit + i * TAU / count
		var ox: float = p.x + cos(a) * radius
		var oy: float = p.y + sin(a) * radius
		halos.append({"x": ox, "y": oy})
		_hit({"x": ox, "y": oy, "r": 17.0}, dmg, true)


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
