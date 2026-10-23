# The scripted survivor's brain for sim_headless.gd: a human's kiting loop
# quantised to the 8 bridge directions (the ONLY input channel; the bridge
# is the one path). The harness asks for a heading every 0.05 s; this module
# reads the world and answers with a WASD combo string.
class_name SimPolicy
extends RefCounted

const FLEE_RADIUS := 140.0 # sum-vector escape while any unit is inside

var main: Node # the running Main node (game/world in read-only use)
var _combo := ""
var _panicking := false
var _fleeing := false
var _zig := Vector2.RIGHT
var _zig_t := 0.0


# Priority ladder: near Dawnlight > mixer (healthy, early) > panic/flee >
# zig-zag sweep. Quantised to the 8 axis-key combos the bridge accepts.
func combo() -> String:
	var game = main.game
	var p: Dictionary = game.player
	var pp := Vector2(p.x, p.y)
	var nearest := -1.0
	var nearest_pos := Vector2.ZERO
	var danger := Vector2.ZERO
	for e in main.world.enemies:
		var off := Vector2(e.x, e.y) - pp
		var d := off.length()
		if nearest < 0.0 or d < nearest:
			nearest = d
			nearest_pos = Vector2(e.x, e.y)
		if d < FLEE_RADIUS:
			danger -= off / maxf(d, 1.0)
	var dir := Vector2.ZERO
	var heal_dir := Vector2.ZERO
	if not main.world.heals.is_empty():
		heal_dir = _nearest_of(main.world.heals, pp)
		if heal_dir.length() > 450.0:
			heal_dir = Vector2.ZERO # cross-chasing a Dawnlight through fresh
			# spawn walls costs more HP than its +8 pays back; the sweep
			# reaches it on its own pass.
	if heal_dir != Vector2.ZERO:
		dir = heal_dir # near Dawnlights outrank everything: the HP budget IS heals
	elif game.hp > 60.0 and nearest >= 0.0 and nearest < 400.0 and game.time < 420.0:
		# Mixer: the talon arc faces the way we move, so a healthy survivor
		# walks AT the nearest unit — kills land at our feet, their gems one
		# pickup radius away, and XP funds the picks that turn one weapon
		# into an engine. iframes absorb the single contact the closing path
		# allows; the HP gate hands over to the sweep when the budget thins.
		dir = (pp - nearest_pos) if nearest < 45.0 else (nearest_pos - pp)
	elif game.hp < 40.0:
		_panicking = true
	elif _panicking and nearest > 600.0:
		_panicking = false
	if dir == Vector2.ZERO:
		if _panicking or _flee_state(nearest):
			# panic / flee: sprint out of the tail; the summed escape
			# gradient finds the thin side of the knot
			dir = danger if danger != Vector2.ZERO else pp - nearest_pos
		else:
			# The zig-zag sweep — the human's U-turn kite: one heading for
			# 20 s (arc kills forward, bolts seek into the tail), then back
			# over our own trail. Every pursuer is slower than 140 px/s, and
			# the return leg walks the 60 px magnet across the gems and
			# Dawnlights the forward leg just dropped: XP and HP recycle here.
			if game.time - _zig_t > 20.0:
				_zig = -_zig
				_zig_t = game.time
			dir = _zig
	var ix := 0
	var iy := 0
	if dir.x > 0.35:
		ix = 1
	elif dir.x < -0.35:
		ix = -1
	if dir.y > 0.35:
		iy = 1
	elif dir.y < -0.35:
		iy = -1
	return ("W" if iy < 0 else "") + ("A" if ix < 0 else "") + \
		("S" if iy > 0 else "") + ("D" if ix > 0 else "")


# Scripted level-up pick (T-S8, MC 11148): the sim_headless.gd ranking moved
# VERBATIM so the real-clock legs (sim_s8.gd) drive the same brain as the
# S3 journey — new weapon first (its bolts seek on their own), then
# ward/ferocity/haste/grip/insight upgrades in survival order.
func pick_index(main: Node) -> int:
	var idx := 0
	var pick_rank := 9
	for i in main._current_offer.size():
		var card: Dictionary = main._current_offer[i]
		var rank := 8
		if card.kind == "weapon":
			rank = 0
		elif card.kind == "upgrade":
			rank = [1, 2, 3, 4, 5].find(["ward", "ferocity", "haste", "grip",
				"insight"].find(card.get("key", card.get("id", ""))))
			if rank < 0:
				rank = 5
		if rank < pick_rank:
			pick_rank = rank
			idx = i
	return idx


# Hysteresis so the kiter never chatters on the fence: engage inside 140 px,
# release past 180 px (both far outside the 33 px contact ring).
func _flee_state(nearest: float) -> bool:
	if nearest >= 0.0 and nearest < FLEE_RADIUS:
		_fleeing = true
	elif nearest < 0.0 or nearest > 180.0:
		_fleeing = false
	return _fleeing


func _nearest_of(items: Array, pp: Vector2) -> Vector2:
	var best_d := 1e18
	var out := Vector2.ZERO
	for it in items:
		var gd := Vector2(it.x, it.y).distance_to(pp)
		if gd < best_d:
			best_d = gd
			out = Vector2(it.x, it.y) - pp
	return out
