# ATTACK leg for the T-S2h strip capture (MC 11112, DOD A3, DESIGN-3D §c).
# RUN-CONDITIONED (F-2): the scripted level-up picks must own Ward or Halo
# by t <= 120 s — the owning level and t are recorded — because hit_cd rises
# ONLY via the ticked _hit sources (ward weapons.gd:147 / halo :188). The
# leg then watches the tracked instance (the horde class-list LAST wraith —
# the same instance gait_probe() reports) for its e.hit_cd rising edge as
# it walks into the ward ring, and measures the §c lunge in SCREEN px: the
# tracked centre's per-step screen positions over the ATK_TIME window, and
# the max deviation of that path from its own chord (the lunge is a sine
# out-and-back bulge on top of the chase, so the chord is the walk
# baseline; frozen scale would add no excursion). The frame pair (walk
# frame | edge frame) is grabbed by the driver's render pipeline.
# Declared deviations (driver header carries the same list): paused tree +
# manual _step (call-rate fast-forward, S6 reading), hp pinned to max (no
# scripted driver survives the horde), screens stubbed (SimStubScreens —
# the established sim-harness mechanism, keeps the card overlay out of the
# frames), tracked re-armed to the new last wraith when the tracked one
# dies. The real spawn loop and real picks run throughout.
class_name StripsAttack
extends RefCounted

const DT := 1.0 / 60.0
const OWN_LIMIT := 120.0 # A3: own Ward or Halo by t <= 120 (recorded)
const WATCH_STEPS := 120 * 60 # 120 sim-s of watch past ownership, then fail
const ATK_STEPS := 13 # ceil(0.2 s / DT) + 1 chord endpoint
const CLASS := "wraith" # band-1 roster class, always in the rotation

var main: Node
var rows: Array = []
var own := {} # {"id","level","t"} — the RUN-CONDITIONED precondition row
var tracked := {}
var done := false
var failed := ""
var want_pair := false # driver grabs (prev draw | current draw) once
var edge_emitted := false
var scale_at_edge := {}
var walk_band: Array = []
var pulses_at_edge := 0
var excursion_px := 0.0
var edge_row := {}

var _samples: Array = [] # tracked centre, screen px, one per sim step
var _edge_at := -1
var _watched := 0


func setup(m: Node) -> void:
	main = m


func tick(batch: int, cam: Camera3D) -> void:
	for _i in batch:
		if done:
			return
		var game = main.game
		if game.phase == "levelup":
			_pick()
			game.paused = true # DECLARED re-pin: set_phase("playing")
			# clears the leg's pause, and main._physics_process would then
			# run _step(delta) at wall speed on top of the manual loop
			# (11.3 sim-s across 40 watch steps — the sampled enemy moved
			# 8x per step and the continuity guard died). Re-pinned here.
			continue
		if game.phase != "playing":
			done = true
			if not own.is_empty() and not done_edge():
				failed = _diag("run ended early: " + String(game.phase))
			else:
				failed = "attack leg run ended early: " + String(game.phase)
			return
		main._step(DT)
		game.hp = game.max_hp # DECLARED pin (boss kill-leg pattern)
		_pin_tracked()
		main._viz.refresh()
		_watch_step(cam)


func _pick() -> void:
	# sim_headless.gd's ward-first ranking, verbatim: new weapon first, then
	# ward/ferocity/haste/grip/insight — ward is the ticked source sought.
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
	main._pick(idx)
	if own.is_empty():
		for w in main.game.weapons:
			if w.id == "ward" or w.id == "halo":
				own = {"id": w.id, "level": w.level,
					"t": roundf(main.game.time * 1000.0) / 1000.0}
				rows.append({"ev": "attack_own", "own": own.id,
					"level": own.level, "t": own.t,
					"ok": own.t <= OWN_LIMIT})


func _watch_step(cam: Camera3D) -> void:
	var t: float = main.game.time
	if own.is_empty():
		if t > OWN_LIMIT:
			done = true
			failed = "attack leg: no Ward/Halo owned by t=120 (precondition F-2)"
		return
	_watched += 1
	_arm_tracked()
	if tracked.is_empty():
		if _watched > WATCH_STEPS:
			done = true
			failed = _diag("no wraith instance to track")
		return
	var h: float = main._viz._heights[CLASS]
	var pt := StripsProbe.to_screen(cam, Vector3(
		tracked.x / CameraRig.PX_PER_M, h * 0.5,
		tracked.y / CameraRig.PX_PER_M))
	if _samples.is_empty() or (_samples.back() as Vector2).distance_to(pt) 			<= 20.0:
		_samples.append(pt) # step-wise continuity guard: a re-arm swap
		# (tracked died, next wraith taken) would inject a position JUMP
		# and fake a huge lunge excursion — rejected, sampling continues.
	else:
		_trips += 1
		if _trips == 1:
			_trip_note = "from %s to %s (samples=%d, edge=%d, tracked_xy=%s)" % [
				str(_samples.back()), str(pt), _samples.size(), _edge_at,
				str(Vector2(tracked.x, tracked.y))]
		if _edge_at >= 0:
			_measure_excursion()
			done = true
		return
	var pd := Vector2(tracked.x - main.game.player.x,
		tracked.y - main.game.player.y).length()
	_min_d = minf(_min_d, pd)
	_max_cd = maxf(_max_cd, tracked.get("hit_cd", 0.0))
	_pulses_seen = int(main._viz.attack_pulses)
	if _edge_at < 0:
		if tracked.get("atk_armed", false):
			_edge_at = _samples.size() - 1
			want_pair = true
			scale_at_edge = main._viz.gait_probe()[CLASS].last
			walk_band = main._viz.gait_probe()[CLASS].range
			pulses_at_edge = main._viz.attack_pulses
		return
	if _samples.size() <= _edge_at + ATK_STEPS:
		return
	_measure_excursion()
	done = true


var _armed_n := 0
var _trips := 0
var _trip_note := ""
var _min_d := 1e9
var _max_cd := 0.0
var _pulses_seen := 0


func done_edge() -> bool:
	return _edge_at >= 0


func _diag(why: String) -> String:
	return "attack leg: " + why + " · own " + str(own.get("own", "-")) \
		+ " at t=" + str(own.get("t", -1.0)) + " · watched=" + str(_watched) \
		+ " · min_dist_px=" + str(int(_min_d)) + " · max tracked hit_cd=" \
		+ str(_max_cd) + " · viz pulses=" + str(_pulses_seen) \
		+ " · tracked alive=" + str(main.world.enemies.has(tracked)) \
		+ " · trackeds adopted=" + str(_armed_n) + " · trips=" + str(_trips) + " · trip1: " + _trip_note + _ident()


func _ident() -> String:
	if tracked.is_empty():
		return " · tracked empty"
	var arr: Array = main.world.enemies
	var p: Dictionary = main.game.player
	return " · count_in_arr=" + str(arr.count(tracked)) \
		+ " · last_is_tracked=" + str(arr.size() > 0 and arr[arr.size() - 1] \
		== tracked) + " · tracked_xy=(" + str(int(tracked.x)) + "," \
		+ str(int(tracked.y)) + ") player_xy=(" + str(int(p.x)) + "," \
		+ str(int(p.y)) + ") n=" + str(arr.size())


func _arm_tracked() -> void:
	# Tracked = the class-list's last wraith (== gait_probe's instance);
	# re-armed whenever the current one dies (real ward kills run here).
	if not tracked.is_empty() and main.world.enemies.has(tracked):
		return
	var last := {}
	for e in main.world.enemies:
		if e.type == CLASS:
			last = e
	tracked = last
	_armed_n += 1
	if not tracked.is_empty():
		_pin_tracked() # pin AT ADOPTION: the old adopt-then-die-before-
		# the-next-pin window let a fresh ring spawn standing in the spawn
		# cluster (spike's densest-cluster target) die before its hp pin
		# ever applied — run diag: min_dist 711 px, zero ticked hits.


# Two DECLARED harness pins keep the scripted window observable on the
# live run: the tracked wraith (a) never dies — the pinned build's volleys
# otherwise kill every incoming wraith in the outer ring before melee
# radius, which starved the edge search for 557 sim-s on run5 — and (b)
# sits LAST in the enemy list, so gait_probe's reported instance IS the
# tracked one (fresh spawns append after it). No product code touched;
# hit_cd semantics untouched — the rising edge still comes only from the
# live ticked _hit (F-2), and the pinned instance keeps taking real hits.
func _pin_tracked() -> void:
	if tracked.is_empty() or not main.world.enemies.has(tracked):
		return
	var w: Array = main.world.enemies
	w.erase(tracked)
	w.append(tracked)
	tracked.hp = 100000.0


func _measure_excursion() -> void:
	var span := float(_samples.size() - 1 - _edge_at)
	if span < 4.0:
		# window truncated (tracked died at once / jump guard trip at the
		# start): an honest failure beats a chord built on 2 points.
		done = true
		failed = "attack leg: lunge window truncated to %d samples" 			% int(span + 1)
		return
	var a: Vector2 = _samples[_edge_at]
	var b: Vector2 = _samples[_samples.size() - 1]
	var mx := 0.0
	for i in range(_edge_at, _samples.size()):
		var frac: float = float(i - _edge_at) / span
		var chord: Vector2 = a.lerp(b, frac)
		mx = maxf(mx, (_samples[i] as Vector2).distance_to(chord))
	excursion_px = roundf(mx * 10000.0) / 10000.0
	edge_row = {"ev": "attack_leg", "class": CLASS,
		"continuity_trips": _trips,
		"trigger": "e.hit_cd rising edge — ticked " + String(own.get("id", ""))
			+ " (F-2 precondition met)",
		"own": own.get("id", ""), "own_level": own.get("level", 0),
		"own_t": own.get("t", -1.0),
		"t_owned_by_120": float(own.get("t", 1e9)) <= OWN_LIMIT,
		"attack_pulses": pulses_at_edge,
		"lunge_m": HordeViz.LUNGE_M, "atk_time_s": HordeViz.ATK_TIME,
		"squash_band": [HordeViz.SQUASH_LO, HordeViz.SQUASH_HI],
		"squash_scale_range": roundf((HordeViz.SQUASH_HI - HordeViz.SQUASH_LO)
			/ HordeViz.SQUASH_LO * 10000.0) / 10000.0,
		"scale_at_edge": scale_at_edge, "walk_band": walk_band,
		"outside_walk_band": not _in_band(scale_at_edge, walk_band),
		"max_excursion_px": excursion_px, "samples": _samples.size() - _edge_at}
	rows.append(edge_row)


func _in_band(last: Dictionary, band: Array) -> bool:
	return last.s >= band[0] and last.s <= band[1] and last.d >= band[0] \
		and last.d <= band[1]
