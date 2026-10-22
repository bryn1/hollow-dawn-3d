# A4 FX shot legs for the T-S2h capture (MC 11112). ONE leg per named FX
# frame, in LIVE gameplay through the real spawn loop — never the card
# overlay (screens are the stub, so a level-up cannot paint cards). The
# build is pinned to all six weapons at L8 (the SimCombat/SimBoss declared
# pinning pattern) and level-ups are declined (pins stay pure), hp is pinned
# to max; the sim's own transient arrays are never touched — the watch fires
# on the RENDERED per-slot counts from WeaponFxViz.fx_counts() (the §i
# visible-layer mechanism) and the pixel truth samples the FOOTPRINT of the
# live instance (positions read from the sim arrays, §i read-only wall):
# StripsProbe.compare against ground references. Fresh-spawned projectiles
# sit ON the survivor pawn (uniform vertically — the local-reference delta
# would read 0 there), so the watch also waits until the sampled instance
# has left the pawn (>= 30 px of travel) and its footprint is inside the
# frame margins. FX frame names per the brief: bolt + ember are the ember
# weapon's two visible slots (orb bolt mid-flight vs the trail ribbon),
# cleaver the axe, halo the orbiting cinder, spike the ground burst, ward
# the expanding ring; talon.png rides along so A4's six-weapon row is
# complete per weapon.
class_name StripsFxLeg
extends RefCounted

const DT := 1.0 / 60.0
const WATCH_STEPS := 40 * 60 # 40 sim-s per shot, then the leg fails
const AWAY_PX := 30.0 # projectile footprint must leave the pawn (px)
const MARGIN := 90.0 # footprint stays inside the painted frame (px)
const VIEW := Vector2(1280, 720)

# png / rendered-slot key / data-window px.
const SHOTS := [
	{"png": "bolt.png", "slot": "bolts", "win": 40, "weapon": "ember"},
	{"png": "ember.png", "slot": "trails", "win": 56, "weapon": "ember"},
	{"png": "cleaver.png", "slot": "axes", "win": 56, "weapon": "cleaver"},
	{"png": "halo.png", "slot": "halos", "win": 44, "weapon": "halo"},
	{"png": "spike.png", "slot": "bursts", "win": 90, "weapon": "spike"},
	{"png": "ward.png", "slot": "rings", "win": 56, "weapon": "ward"},
	{"png": "talon.png", "slot": "arcs", "win": 70, "weapon": "talon"},
]

var main: Node
var shot := {} # current SHOTS entry
var row := {}
var want := {} # non-empty = driver freezes and grabs at the next draw
var done := false
var failed := ""
var steps := 0

var _fxs: Array = [] # shot results, in SHOTS order


func setup(m: Node, i: int) -> void:
	main = m
	shot = SHOTS[i]
	want = {}
	row = {}
	done = false
	failed = ""
	steps = 0


func tick(batch: int, cam: Camera3D) -> void:
	for _i in batch:
		if done or not want.is_empty():
			return
		var game = main.game
		if game.phase == "levelup":
			game.pending_levels = 0
			game.set_phase("playing") # DECLINED (boss-kill-leg pattern)
			game.paused = true # DECLARED re-pin (see StripsAttack: set_
			# phase clears the pause; physics must never drive the sim)
			continue
		if game.phase != "playing":
			done = true
			failed = "fx leg run ended early: " + String(game.phase)
			return
		main._step(DT)
		game.hp = game.max_hp # DECLARED pin
		main._viz.refresh()
		main._fxv.refresh()
		steps += 1
		var counts: Dictionary = main._fxv.fx_counts()
		if counts.get(shot.slot, 0) < 1 or not _far_enough():
			if steps > WATCH_STEPS:
				done = true
				failed = "fx shot %s: no grabbable instance for 40 sim-s" % shot.png
			continue
		var pts: Array = sample_pts(cam)
		var vis := 0
		for p in pts:
			if _in_frame(p):
				vis += 1
		if vis < int(ceil(pts.size() * 0.6)):
			continue # instance mostly outside the painted frame — wait
		row = {"ev": "fx_shot", "png": shot.png, "slot": shot.slot,
			"t": roundf(game.time * 1000.0) / 1000.0, "steps": steps,
			"rendered_counts": counts.duplicate()}
		want = {"png": shot.png, "win": shot.win}
		return


# Projectiles spawn at the survivor's feet — sampling there lands on the
# pawn (a vertical uniform body defeats the ground-reference delta), so the
# watch waits for real flight distance. Ground decals (arc/ring/burst) and
# the orbiting halo never sit on the pawn body: exempt.
func _far_enough() -> bool:
	var p: Dictionary = main.game.player
	match shot.slot:
		"bolts", "trails":
			var b: Dictionary = main.fx.bolts[-1]
			return Vector2(b.x - p.x, b.y - p.y).length() >= AWAY_PX
		"axes":
			var t: Dictionary = main.fx.throws[-1]
			return t.dist >= AWAY_PX
	return true


func _in_frame(pt: Vector2) -> bool:
	return pt.x >= MARGIN and pt.x <= VIEW.x - MARGIN \
		and pt.y >= MARGIN and pt.y <= VIEW.y - MARGIN


func grab(img: Image, cam: Camera3D, base_img: Image = null) -> void:
	var pts: Array = sample_pts(cam)
	var px: Vector2 = pts[0]
	row["screen_px"] = [roundf(px.x), roundf(px.y)]
	if shot.slot in ["arcs", "trails"]:
		# SOLID on-screen FX (the 70-deg talon fan, the ember trail
		# ribbon): a fixed +y ground reference lands inside the shape
		# itself / on decorrelated texture — reference = the SAME pixel
		# on this leg's pre-fire baseline draw (StripsProbe.compare_vs).
		row["compare"] = StripsProbe.compare_vs(base_img, img, pts)
	else:
		row["compare"] = StripsProbe.compare(img, pts)
	row["check"] = StripsProbe.window_check(img, px, int(shot.win))
	_fxs.append(row)
	done = true


func rows() -> Array:
	return _fxs


# Screen-space footprint of the LIVE instance (the rendered slice is the sim
# array's LAST entries — viz_fx slice(-cap)); points are the mesh extent in
# px at S = 24 px/m, sampled through the same camera that paints them.
func sample_pts(cam: Camera3D) -> Array:
	var pts: Array = []
	var s := 1.0 / CameraRig.PX_PER_M
	match shot.slot:
		"bolts", "halos":
			var arr: Array = main.fx.bolts if shot.slot == "bolts" else main.fx.halos
			var c: Dictionary = arr[-1]
			var base := cam.unproject_position(Vector3(c.x * s, WeaponFxViz.Y_ORB,
				c.y * s))
			for o in [Vector2.ZERO, Vector2(3, 0), Vector2(-3, 0), Vector2(0, 3),
					Vector2(0, -3), Vector2(2, 2), Vector2(-2, -2),
					Vector2(2, -2), Vector2(-2, 2)]:
				pts.append(base + o)
		"trails":
			var b: Dictionary = main.fx.bolts[-1]
			var d: Vector2 = Vector2(-b.vx, -b.vy).normalized() # behind flight
			for t in [0.05, 0.15, 0.25, 0.35, 0.45]:
				pts.append(cam.unproject_position(Vector3(
					b.x * s + d.x * t, WeaponFxViz.Y_ORB,
					b.y * s + d.y * t)))
		"axes":
			var t2: Dictionary = main.fx.throws[-1]
			# the axe flies the viz's own arc height (viz_fx.gd:163):
			# y = 0.45 + sin(PI * dist/travel) * 26 px
			var ay: float = 0.45 + sin(PI * clampf(t2.dist / t2.travel,
				0.0, 1.0)) * 26.0 * s
			var base2 := cam.unproject_position(Vector3(t2.x * s, ay, t2.y * s))
			for ox in [-5.0, 0.0, 5.0]:
				for oy in [-1.0, 0.0, 1.0]:
					pts.append(base2 + Vector2(ox, oy))
		"bursts":
			var u: Dictionary = main.fx.bursts[-1]
			var prog: float = 1.0 - u.life / u.max
			var rm: float = u.r * s * (0.25 + 0.75 * prog)
			for i in 8:
				var a := float(i) / 8.0 * TAU
				pts.append(cam.unproject_position(Vector3(
					u.x * s + cos(a) * rm, WeaponFxViz.Y_DECAL + 0.2,
					u.y * s + sin(a) * rm)))
		"rings":
			var r: Dictionary = main.fx.rings[-1]
			var p: Dictionary = main.game.player
			var prog2: float = 1.0 - r.life / r.max
			# annulus band is [0.82, 1.0] * rm — sample its centre (0.9)
			var rm2: float = r.r * s * (0.55 + 0.5 * prog2) * 0.9
			for i in 12:
				var a2 := float(i) / 12.0 * TAU
				pts.append(cam.unproject_position(Vector3(
					p.x * s + cos(a2) * rm2, WeaponFxViz.Y_DECAL + 0.01,
					p.y * s + sin(a2) * rm2)))
		"arcs":
			var a3: Dictionary = main.fx.arcs[-1]
			var p2: Dictionary = main.game.player
			for frac in [0.5, 0.75]:
				for k in 5:
					var ang: float = a3.ang - 0.4 + 0.8 * float(k) / 4.0
					pts.append(cam.unproject_position(Vector3(
						(p2.x + cos(ang) * a3.range * frac) * s,
						WeaponFxViz.Y_DECAL,
						(p2.y + sin(ang) * a3.range * frac) * s)))
	return pts
