# Strip-recorder capture math for MC 11112 T-S2h (DOD A3 Route-A dual-channel
# gate, DESIGN-3D §c "the strip recorder owns capture" for the projected
# WIDTH series). This file measures; it never animates: the scale channels
# come from HordeViz.gait_probe() (the ONE gait mechanism, reused verbatim),
# and the projected bbox WIDTH comes from the REAL Camera3D of the running
# window (unproject of the instance's left/right edges at its live scale).
# Convention (D§c, declared ONCE): p2p := (max - min) of the measured series
# over >= 1 full cycle — amplitudes NEVER doubled. Translation normalization:
# the width is the right-minus-left screen-x EXTENT of the same instance
# (under the ortho rig it is translation-invariant); the centre's screen
# travel is recorded separately as the slide evidence that the walk leg
# subtracts out of the width channel.
class_name StripsProbe
extends RefCounted

var n := 0
var s_min := INF
var s_max := -INF
var w_min := INF
var w_max := -INF
var c_first := Vector2.ZERO
var c_last := Vector2.ZERO
var c_x_min := INF
var c_x_max := -INF
var c_y_min := INF
var c_y_max := -INF
var probe_last := {} # last gait_probe() class entry seen


func reset() -> void:
	n = 0
	s_min = INF
	s_max = -INF
	w_min = INF
	w_max = -INF
	c_x_min = INF
	c_x_max = -INF
	c_y_min = INF
	c_y_max = -INF


# Sample ONE instance of class `key` (the horde's class-list last instance —
# the same instance gait_probe() reports; the capture legs keep the class
# list stable so identity holds across the whole cycle window).
func feed(cam: Camera3D, viz: Node, key: String, e: Dictionary) -> void:
	var probe: Dictionary = viz.gait_probe()[key]
	probe_last = probe
	var s: float = probe.last.s
	s_min = minf(s_min, s)
	s_max = maxf(s_max, s)
	# Mesh half-width along world X at the instance's live scale (the scissor
	# scales the transform's X channel — horde_viz.gd:115-118).
	var r: float = viz._mms[key].multimesh.mesh.radius * s
	var h: float = viz._heights[key]
	var ox: float = e.x / CameraRig.PX_PER_M
	var oz: float = e.y / CameraRig.PX_PER_M
	var mid := cam.unproject_position(Vector3(ox, h * 0.5, oz))
	var left := cam.unproject_position(Vector3(ox - r, h * 0.5, oz))
	var right := cam.unproject_position(Vector3(ox + r, h * 0.5, oz))
	var w: float = absf(right.x - left.x)
	w_min = minf(w_min, w)
	w_max = maxf(w_max, w)
	if n == 0:
		c_first = mid
	c_last = mid
	c_x_min = minf(c_x_min, mid.x)
	c_x_max = maxf(c_x_max, mid.x)
	c_y_min = minf(c_y_min, mid.y)
	c_y_max = maxf(c_y_max, mid.y)
	n += 1


# The measured dual-channel row for one class under the ONE convention.
func row() -> Dictionary:
	return {"samples": n,
		"scale_range_measured": _r4(s_max - s_min),
		"scale_range_declared": _r4(probe_last.range[1] - probe_last.range[0]),
		"width_p2p_px": _r4(w_max - w_min),
		"travel_px_2d": _r4(c_last.distance_to(c_first)),
		"center_p2p_px": Vector2(_r4(c_x_max - c_x_min), _r4(c_y_max - c_y_min))}


# Non-background-pixel test for A4 "FX visibly painted", AREA based: over a
# crop window (optionally an annulus) the count of pixels with luma >= HI
# (a bright, additive-FX-class pixel). A single bright ground fleck never
# forms the blob a rendered FX instance paints; the walk frames + an empty
# ground window calibrate the fleck floor (rows in the dump), so the gate
# delta is measured, not asserted.
const HI := 0.6 # "bright pixel" line for the data column (the gate is compare)


static func window_check(img: Image, center: Vector2, r_out: int,
		r_in := 0) -> Dictionary:
	var wpx: int = img.get_width()
	var hpx: int = img.get_height()
	var n := 0
	var hi := 0
	var mx := 0.0
	var cx := int(center.x)
	var cy := int(center.y)
	for yy in range(maxi(0, cy - r_out), mini(hpx, cy + r_out + 1), 1):
		for xx in range(maxi(0, cx - r_out), mini(wpx, cx + r_out + 1), 1):
			var d := Vector2(xx - cx, yy - cy).length()
			if d > r_out or d < r_in:
				continue
			var l := luma(img.get_pixel(xx, yy))
			n += 1
			if l >= HI:
				hi += 1
			mx = maxf(mx, l)
	return {"max_lum": _r4(mx), "hi": hi,
		"hi_frac": _r4(float(hi) / float(maxi(1, n))), "n": n}


static func luma(c: Color) -> float:
	return c.r * 0.299 + c.g * 0.587 + c.b * 0.114


# Pixel-truth diff between two consecutive draws of the SAME window (the
# lunge pair vs its cadence-matched ambient control): counts sampled pixels
# whose luma changed by >= DIFF_THRESH.
const DIFF_THRESH := 0.10


static func compare_radial(img: Image, pts: Array, dirs: Array,
		dist: float, thresh := REF_THRESH) -> Dictionary:
	# Ground reference OUTWARD along each point's own ray: the talon
	# wedge is a solid 70-deg fan ~27 px deep on screen, so a single
	# fixed +y reference would land inside the FX for half the points
	# (measure-design flaw, not weakness). dirs are screen-space unit
	# vectors away from the player, built by the leg from the same
	# angles as pts. Same contract as compare() otherwise.
	var wpx: int = img.get_width() - 1
	var hpx: int = img.get_height() - 1
	var above := 0
	var vis := 0
	var max_delta := 0.0
	var _ds: Array = []
	for i in pts.size():
		var a: Vector2 = pts[i]
		if a.x < 0 or a.x > wpx or a.y < 0 or a.y > hpx:
			_ds.append("off")
			continue
		vis += 1
		var q: Vector2 = a + (dirs[i] as Vector2) * dist
		var dl: float = luma(img.get_pixel(int(a.x), int(a.y))) \
			- luma(img.get_pixel(clampi(int(q.x), 0, wpx),
				clampi(int(q.y), 0, hpx)))
		_ds.append(_r4(dl))
		if dl >= thresh:
			above += 1
		max_delta = maxf(max_delta, dl)
	return {"n": pts.size(), "visible": vis, "above": above,
		"max_delta": _r4(max_delta), "deltas": _ds}


static func compare_vs(a_img: Image, b_img: Image, pts: Array,
		thresh := REF_THRESH) -> Dictionary:
	# Footprint vs the SAME pixel on the leg's pre-fire baseline draw:
	# for the solid talon wedge a ground reference (any fixed or radial
	# offset) decorrelates into texture noise or lands inside the FX
	# itself — the honest reference for a solid FX is its own pixel
	# before the fire. Same contract shape as compare().
	var wpx: int = a_img.get_width() - 1
	var hpx: int = a_img.get_height() - 1
	var above := 0
	var vis := 0
	var max_delta := 0.0
	var _ds: Array = []
	for p in pts:
		var a: Vector2 = p
		if a.x < 0 or a.x > wpx or a.y < 0 or a.y > hpx:
			_ds.append("off")
			continue
		vis += 1
		var dl: float = luma(b_img.get_pixel(int(a.x), int(a.y))) \
			- luma(a_img.get_pixel(int(a.x), int(a.y)))
		_ds.append(_r4(dl))
		if dl >= thresh:
			above += 1
		max_delta = maxf(max_delta, dl)
	return {"n": pts.size(), "visible": vis, "above": above,
		"max_delta": _r4(max_delta), "deltas": _ds}


static func diff_count(a: Image, b: Image, center: Vector2,
		r_out: int) -> Dictionary:
	var cx := int(center.x)
	var cy := int(center.y)
	var changed := 0
	var n := 0
	var max_d := 0.0
	for yy in range(maxi(0, cy - r_out), mini(a.get_height(), cy + r_out + 1), 1):
		for xx in range(maxi(0, cx - r_out), mini(a.get_width(), cx + r_out + 1), 1):
			var d: float = absf(luma(a.get_pixel(xx, yy)) - luma(b.get_pixel(xx, yy)))
			n += 1
			if d >= DIFF_THRESH:
				changed += 1
			max_d = maxf(max_d, d)
	return {"changed": changed, "n": n, "max_delta": _r4(max_d)}


# A4 pixel truth with LOCAL references: each FX footprint screen point is
# compared against ground 21 px below it (the same biome texture patch a
# hair away), so dark-ground texture noise cancels and even the faint
# alpha-0.25 ward ring (a +0.18 add) reads. "above" counts points whose
# luma beats its own reference by THRESH — a plain ground grid (the noise-
# floor rows, same call) counts ~0; a painted FX footprint counts most of
# its samples.
const REF_OFF := Vector2(0, 21)
const REF_THRESH := 0.15


static func compare(img: Image, pts: Array, off := REF_OFF,
		thresh := REF_THRESH) -> Dictionary:
	var wpx: int = img.get_width() - 1
	var hpx: int = img.get_height() - 1
	var above := 0
	var vis := 0
	var max_delta := 0.0
	var _ds: Array = []
	for p in pts:
		var a: Vector2 = p
		if a.x < 0 or a.x > wpx or a.y < 0 or a.y > hpx:
			_ds.append("off") # outside the painted frame — not sampleable
			continue
		vis += 1
		var rx: int = int(a.x)
		var ry: int = int(a.y)
		var fx: int = clampi(int(a.x + off.x), 0, wpx)
		var fy: int = clampi(int(a.y + off.y), 0, hpx)
		var dl: float = luma(img.get_pixel(rx, ry)) - luma(img.get_pixel(fx, fy))
		_ds.append(_r4(dl))
		if dl >= thresh:
			above += 1
		max_delta = maxf(max_delta, dl)
	return {"n": pts.size(), "visible": vis, "above": above,
		"max_delta": _r4(max_delta), "deltas": _ds}


# World point -> viewport px through the real camera (the same projection
# the strip window paints with).
static func to_screen(cam: Camera3D, world: Vector3) -> Vector2:
	return cam.unproject_position(world)


static func _r4(v: float) -> float:
	return roundi(v * 10000.0) / 10000.0
