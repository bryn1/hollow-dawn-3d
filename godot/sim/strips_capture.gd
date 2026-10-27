# reason: >400 lines — 591 measured at MC 11398 §1.3, the twice-deferred row
#   whose "next touching card" is THIS one (MC 11401 C1): one capture rig,
#   four legs (walk/frozen-control/attack/FX) sharing ONE live Main.tscn +
#   the frozen-control red law; the split is BYTE-RISK on the shot stream
#   and the audit files the header as the honest close (5 lines from 600).
# Route-A gait-strip + A4-FX capture for MC 11112 T-S2h (DOD-ACCEPTANCE S2
# row / A3 / A4, DESIGN-3D §c). Run windowed under Xvfb — a real GL window
# proves the frames exist, which --headless cannot (S5 cards_capture.gd
# pattern, reused verbatim):
#   xvfb-run godot --render-driver opengl3 --path godot -s res://sim/strips_capture.gd
# Legs, in order, over ONE live Main.tscn (each leg restarts through the
# real _start_game funnel):
#  1. WALK STRIP per class (8 roster names): 6 same-class walkers spawned by
#     world.gd's own _spawn_enemy, moving LIVE; sampled per sim step through
#     HordeViz.gait_probe() (the ONE gait mechanism) + the real camera's
#     projected WIDTH series (StripsProbe); 6 evenly-spaced gait-phase
#     frames (exactly 1 cycle, 60 deg apart) blitted into one wide PNG
#     labelled on-screen with the class name via a Label overlay.
#  2. FROZEN-SLIDE CONTROL (REQUIRED RED proof, same scene variant, pure
#     harness — no product-code knob): the same fresh wraith walk leg with
#     the SAME spawn funnel and the SAME per-step HordeViz.refresh, but the
#     CLOCK IS NEVER ADVANCED (no _step call; the gait phase term
#     TAU*f*game.time + gait_p is scale-constant) while movement keeps
#     running through world.update_entities — the game's OWN movement
#     function, verbatim — so the instances slide (120 steps: ~4.6 m,
#     screen travel > 100 px; arrival cannot stall it this early). Both
#     channels must go RED: scale-range 0 AND width p2p ~0, with travel > 0
#     proving it slid. A gate this run never turns RED against its own
#     failure mode is not a gate (D§c: "a frozen slide fails both").
#  3. ATTACK leg (StripsAttack): RUN-CONDITIONED per A3/F-2.
#  4. A4 FX shots x7 (StripsFxLeg): live gameplay, rendered-slot watch.
# Declared deviations (the S6 reading, spelled once): the tree's own tick
# idles (game.paused = true) and main._step is driven manually at DT — the
# fast-forward is call-rate, never dt (the control leg advances NO clock at
# all, see above); walk legs clear the player's weapons (the RUN-CONDITIONED
# ban — with no ticked source hit_cd never rises, so a walk row cannot
# smuggle in the attack squash) and hold world.spawn_acc at 0 (the roster
# under measure stays exactly the 6 spawned walkers; update_spawns then
# never reaches its >= 1.0 threshold — no other enemy ever exists, so
# gait_probe's class-last instance IS the fed instance); hp is pinned to max
# every step (no scripted driver survives the horde, boss-kill-leg
# precedent); screens are the established SimStubScreens (the card overlay
# never paints). Panels are the REAL rendered frames, grabbed at
# frame_post_draw for the batch that reached each phase target.
# DOD S2 row keeps a visual acceptor: the orchestrator describe-image pass
# over the strips is the veto against the jitter look — this rig measures and
# paints, it never judges.
extends SceneTree

const DT := 1.0 / 60.0
const WALKERS := 6 # >= 6 same-class walkers, per the brief
const PANEL := Vector2i(640, 360)
const BATCH_STRIP := 2
const BATCH_TICK := 4
const FREQ_CAP := 2.2 # horde_viz gait cap, restated for the row
const CONTROL_STEPS := 120 # 2 s of verbatim movement; the clock stays 0.0
const ROSTER := ["wraith", "hound", "crawler", "cultist", "moor-brute",
	"dune-scarab", "rime-ghoul", "pale-wight"]

var _main: Node
var _cam: Camera3D
var _label: Label
var _out: FileAccess
var _probe := StripsProbe.new()
var _atk := StripsAttack.new()
var _fxs := StripsFxLeg.new()

var _legs: Array = [] # descriptors: {"mode","key"|"shot"}
var _leg_i := -1
var _mode := ""
var _frozen := false
var _key := ""
var _freq := 0.0
var _steps_total := 0
var _step_i := 0
var _targets: Array = []
var _tracked := {}
var _strip_img: Image
var _panel_i := 0
var _want_panel := -1
var _want_pair := false
var _prev_img: Image
var _fail := ""
var _done_all := false
var _started := false
var _leg_done := false
var _draw_hist: Array = [] # last two attack-leg draws
var _atk_hist: Array = []
var _atk_hist_t: Array = []
var _pair_a: Image = null
var _pair_t0 := -1.0
var _fx_base: Array = [] # pre-fire draws of an fx leg
var _fx_shot_img: Image = null # captured rings/arcs shot, awaiting ambient
var _fx_pending := {} # its row while the tail draws are collected
var _fx_tail: Array = [] # draws after the shot (for the ambient pair)
var _fx_tail_c: Array = [] # slot-rendered==0 flag per tail draw
var _fx_need_base := false


func _dir(env: String, fallback: String) -> String:
	var d: String = OS.get_environment(env)
	return d if d != "" else fallback


func _atk_seed() -> int:
	# T-M3z (MC 11286) DECLARED harness re-pin, capture tool only (product
	# untouched): the F-2 precondition (own Ward or Halo by t<=120) rides the
	# level-up OFFER stream; the unified T-M3b schedule latch changed global
	# RNG consumption, so the stream seeded by 11112 no longer surfaces a
	# ticked source inside the window on the M3 tree. This env override lets
	# the runner pick a seed where the SAME precondition holds — nothing
	# measured is relaxed, only the seed is RE-SELECTED (the s8 A1 gameover-
	# seed precedent). Unset = the shipped 11112; the walk/FX legs keep 11112
	# unconditionally, their outputs stay byte-anchored.
	var s := OS.get_environment("HD3D_ATK_SEED")
	return int(s) if s != "" else 11112


func _initialize() -> void:
	print("S2H_CAPTURE_START")
	_out = FileAccess.open(_dir("HD3D_DUMP", "/tmp/hd3d-strips-s2h-dump.jsonl"),
		FileAccess.WRITE)
	assert(_out != null)
	for d in [_dir("HD3D_STRIP_DIR", "/tmp/s2h-strips"),
			_dir("HD3D_FX_DIR", "/tmp/s2h-fx")]:
		assert(DirAccess.make_dir_recursive_absolute(d) == OK)
	_render_once()


func _boot() -> void:
	# Tree is processing here (first _process), so add_child runs Main's
	# _ready immediately (the sim_headless pattern; _initialize is too early).
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)
	# Wall-clock economy for the long legs (attack watch ~35 sim-s, fx slots
	# up to 30 sim-s): the sim is driven MANUALLY at DT = 1/60 — physics and
	# the tree never feed it time — so Engine.time_scale only multiplies the
	# renderer's wall cadence, NEVER a sim dt (every v1 constant verbatim,
	# the S6 "call-rate, never dt" reading). DECLARED here once.
	Engine.time_scale = 8.0
	var old: CanvasLayer = _main._screens
	_main.remove_child(old)
	old.queue_free()
	var stub := SimStubScreens.new()
	_main.add_child(stub)
	_main._screens = stub
	stub.card_picked.connect(_main._pick)
	_cam = _main._rig.get_child(0)
	_label = _make_label()
	_emit({"ev": "camera", "viewport": [root.size.x, root.size.y],
		"projection": "PROJECTION_ORTHOGONAL" if _cam.projection == Camera3D.PROJECTION_ORTHOGONAL else str(_cam.projection),
		"ortho_size": _cam.size, "px_per_m": CameraRig.PX_PER_M})
	var legs: Array = []
	for k in ROSTER:
		legs.append({"mode": "strip", "key": k})
	legs.append({"mode": "control", "key": "wraith"})
	legs.append({"mode": "attack"})
	for i in StripsFxLeg.SHOTS.size():
		legs.append({"mode": "fx", "shot": i})
	_legs = legs
	var only := OS.get_environment("HD3D_ONLY") # debug: run one mode only
	if only != "":
		_legs = legs.filter(func(l): return l.mode == only)
	var pngs := OS.get_environment("HD3D_PNGS") # debug: fx legs subset
	if pngs != "":
		var want := pngs.split(",")
		_legs = _legs.filter(func(l):
			return l.mode != "fx" or StripsFxLeg.SHOTS[int(l.shot)].png in want)


func _render_once() -> void:
	RenderingServer.frame_post_draw.connect(_on_draw, CONNECT_ONE_SHOT)


func _process(_delta: float) -> bool:
	if _done_all:
		return false
	if not _started:
		_started = true
		_boot()
		_next_leg()
		return false
	match _mode:
		"strip":
			if _leg_done:
				_leg_done = false
				_next_leg()
			elif _want_panel < 0:
				_tick_walk(BATCH_STRIP)
		"control":
			if _leg_done:
				_leg_done = false
				_next_leg()
			elif _want_panel < 0 and _step_i < _steps_total:
				_tick_frozen()
		"attack":
			# pairing needs draws DENSER than the sim clock: under llvmpipe
			# a draw costs ~0.3 s real and the batched leg ran 8x faster,
			# so the 0.09 s lunge window fell entirely between two draws.
			# One step per frame while a pair is pending or armed.
			_atk.tick(1 if (_want_pair or _pair_a != null
				or _atk.want_pair) else BATCH_TICK, _cam)
			if _atk.want_pair and not _want_pair:
				_atk.want_pair = false
				_want_pair = true
			if _atk.done and not _want_pair:
				if _atk.failed != "":
					_hard_fail(_atk.failed)
				else:
					_close_attack()
		"fx":
			if _fx_need_base:
				return false # hold the sim until the pre-fire baseline
				# draw is captured (tree order is process THEN draw, so the
				# first draw of a leg sees the first tick's fire; one idle
				# frame costs nothing and makes base[0] truly pre-fire)
			_fxs.tick(BATCH_TICK, _cam)
			if _fxs.done:
				if _fxs.failed != "":
					_hard_fail(_fxs.failed)
				elif not _fx_pending.is_empty():
					_step_pending()
				else:
					_next_leg()
	if _fail != "" and not _done_all:
		_done_all = true
		quit(3)
		return true
	return false


# --- leg lifecycle -------------------------------------------------------------

func _next_leg() -> void:
	_leg_i += 1
	if _leg_i >= _legs.size():
		_emit({"ev": "s2h_legs_done", "legs": _legs.size()})
		_done_all = true
		_out.flush()
		quit(0) # SceneTree.quit ends the loop; without it the runner idled
		# forever AFTER the full dump was complete (seen this session)
		return
	var leg: Dictionary = _legs[_leg_i]
	_mode = leg.mode
	_frozen = _mode == "control"
	_step_i = 0
	_panel_i = 0
	_probe.reset()
	match _mode:
		"strip", "control":
			_key = leg.key
			_tracked = _fresh_walk(_key)
			_freq = _main._viz.gait_probe()[_key].freq
			if _frozen:
				# No panel targets matter for the RED rows, but the panels
				# are painted anyway: the control strip is visual evidence
				# of a slide that never changes shape.
				_steps_total = CONTROL_STEPS
				_targets = [0, 24, 48, 71, 95, 119]
				_label.text = "FROZEN-SLIDE CONTROL — %s · scale-constant · slides" % _key
			else:
				# exactly ONE full cycle, 6 panels at 60 deg phase spacing
				_steps_total = maxi(30, ceili(60.0 / _freq))
				_targets = []
				for k in 6:
					_targets.append(int(round(float(k) * (_steps_total - 1) / 5.0)))
				_label.text = "%s — Route-A walk strip · 6 gait-phase frames · f=%.2f Hz" % [_key, _freq]
			_strip_img = Image.create(PANEL.x * 6, PANEL.y, false,
				Image.FORMAT_RGBA8)
		"attack":
			_main._start_game() # real build: talon@1 grant, real spawn loop
			seed(_atk_seed()) # T-M3z: env RE-SELECT sees _atk_seed(); unset = 11112
			_main.game.paused = true
			_atk.setup(_main)
			_prev_img = null
			_label.text = "wraith — hit_cd rising edge: walk | lunge+squash"
		"fx":
			_fx_base = []
			_fx_shot_img = null
			_fx_pending = {}
			_fx_tail = []
			_fx_tail_c = []
			_fx_need_base = _frozen_decal_shot(int(leg.shot))
			_fresh_fx(int(leg.shot))


func _fresh_walk(key: String) -> Dictionary:
	_main._start_game()
	seed(11112) # DECLARED (see _fresh_fx)
	_main.game.weapons = [] # DECLARED: the walk legs are lunge-banned (F-2 inverted)
	_main.game.paused = true # manual step: call-rate, never dt
	for _i in WALKERS:
		_main.world._spawn_enemy(key, _main.game, _main.VIEW)
	# DECLARED capture placement (positions only — gait phases, speeds and
	# every measured channel untouched): the ring spawns sit at VIEW radius
	# (mostly off-screen); the strip panels need the walkers IN FRAME, so
	# spread them in a visible row ahead of the player (below = +y = down
	# on screen under the -70 deg ortho rig).
	var n: int = _main.world.enemies.size()
	for j in WALKERS:
		var e: Dictionary = _main.world.enemies[n - WALKERS + j]
		e.x = _main.game.player.x + (float(j) - 2.5) * 52.0
		e.y = _main.game.player.y + 80.0 + float(j % 3) * 35.0
	_main._viz.refresh() # seeds gait_p; class-last == my last spawn
	return _main.world.enemies[-1]


func _fresh_fx(i: int) -> void:
	_main._start_game()
	seed(11112) # DECLARED: global randf() drives spawn angles/drops; seeded
	# for run-to-run reproducibility of THIS capture only (product untouched)
	var build: Array = [{"id": StripsFxLeg.SHOTS[i].weapon, "level": 8,
		"cd": 0.0}] # DECLARED pin (SimCombat pattern): ONE weapon per shot
	# leg — other weapons' motion (halo orbs sweep the player-centred
	# windows) cannot contaminate the baseline/ambient pixel truth.
	_main.game.weapons = build
	_main.game.paused = true
	_fxs.setup(_main, i)
	_label.text = "A4 FX live — %s" % StripsFxLeg.SHOTS[i].png


# Walk strip: real _step per sim step; spawns suppressed at the accumulator
# (update_spawns never crosses its threshold), hp pinned, probe sampled.
func _tick_walk(batch: int) -> void:
	if _step_i >= _steps_total:
		return
	for _i in batch:
		if _step_i >= _steps_total:
			return
		_main.world.spawn_acc = 0.0 # DECLARED suppression (header)
		_main._step(DT)
		_main.game.hp = _main.game.max_hp
		_main._viz.refresh()
		_probe.feed(_cam, _main._viz, _key, _tracked)
		_step_i += 1
		var k := _targets.find(_step_i - 1)
		if k >= 0:
			_want_panel = k
			return


# FROZEN CONTROL: the clock is never advanced (game.time stays 0.0 — the
# gait sin term is frozen, every scale channel CONSTANT), while movement
# runs through the game's own world.update_entities(DT, game), verbatim.
# Same probe, same camera projection, same instance.
func _tick_frozen() -> void:
	if _step_i >= _steps_total:
		return
	for _i in BATCH_STRIP:
		if _step_i >= _steps_total:
			return
		_main.world.update_entities(DT, _main.game)
		_main._viz.refresh()
		_probe.feed(_cam, _main._viz, _key, _tracked)
		_step_i += 1
		var k := _targets.find(_step_i - 1)
		if k >= 0:
			_want_panel = k
			return


func _step_pending() -> void:
	# keep the sim ticking while the decal dies (the leg is done; this is
	# the same manual cadence the legs use — physics stays paused)
	for _i in BATCH_TICK:
		_main.game.hp = _main.game.max_hp
		_main._step(DT)
		_main._viz.refresh()
	var n := _fx_tail.size()
	if n >= 2 and bool(_fx_tail_c[n - 1]) and bool(_fx_tail_c[n - 2]):
		var r: int = int(_fxs.shot.win)
		var ctr := Vector2(root.size.x / 2.0, root.size.y / 2.0)
		_fx_pending["base_diff"] = StripsProbe.diff_count(_fx_base[0],
			_fx_shot_img, ctr, r)
		_fx_pending["amb_diff"] = StripsProbe.diff_count(_fx_tail[n - 2],
			_fx_tail[n - 1], ctr, r)
		_fx_pending["amb_tail_idx"] = n - 2
		# Faint alpha decals over textured ground: their pixel truth is the
		# BASELINE diff (pre-fire draw of the same leg -> shot, window =
		# player-centred) over an AMBIENT control pair drawn AFTER the decal
		# died (slot count 0 on both) — pawn idle drift and gem blinks only.
		# The leg keeps stepping during collection; the emit happens when
		# the pair lands (timeout below emits with no ambient and the gate
		# goes RED, never silently green).
		_emit(_fx_pending)
		_fx_pending = {}
		_fx_shot_img = null
		return
	if n >= 8: # no slot-free pair arrived — emit the baseline WITHOUT
		# ambient; the checker's gate stays RED, never silently green.
		var r8: int = int(_fxs.shot.win)
		var c8 := Vector2(root.size.x / 2.0, root.size.y / 2.0)
		_fx_pending["base_diff"] = StripsProbe.diff_count(_fx_base[0],
			_fx_shot_img, c8, r8)
		_emit(_fx_pending)
		_fx_pending = {}
		_fx_shot_img = null


# --- draw handler (every painted frame) ----------------------------------------

func _on_draw() -> void:
	# S5 cards_capture pattern verbatim: re-arm via a one-shot lambda that
	# reconnects AFTER this emission finished (connecting directly here is
	# "already connected" and floods the log).
	RenderingServer.frame_post_draw.connect(func():
		RenderingServer.frame_post_draw.connect(_on_draw, CONNECT_ONE_SHOT),
		CONNECT_ONE_SHOT)
	var img: Image = root.get_texture().get_image()
	match _mode:
		"strip", "control":
			if _want_panel >= 0:
				_grab_panel(img)
		"attack":
			# DECLARED 4.7 quirk: get_image() returns a REFERENCE, so every
			# retained frame must duplicate() or refs alias the LATEST draw.
			_atk_hist.append(img.duplicate())
			_atk_hist_t.append(_main.game.time)
			if _atk_hist.size() > 480:
				_atk_hist.pop_front()
				_atk_hist_t.pop_front()
			if _want_pair:
				# lunge pair (0.09 s span — the lunge+squash half period,
				# so the edge walker's DRAW excursion is visible; a 1-draw
				# pair measured ~0.2 px of lunge and diluted under ambient
				# gait noise): A = latest draw, B at +0.09 s below.
				_want_pair = false
				_pair_a = _atk_hist[_atk_hist.size() - 1]
				_pair_t0 = _main.game.time
			elif _pair_a != null and _main.game.time >= _pair_t0 + 0.09 \
					and not _atk._samples.is_empty():
				_grab_pair(img)
		"fx":
			if not _fx_pending.is_empty():
				if _fx_tail.size() < 8:
					_fx_tail.append(img.duplicate())
					_fx_tail_c.append(int(_main._fxv._counts.get(_fxs.shot.slot, 0)) == 0)
			elif _fx_need_base:
				# FIRST draw of a decal leg = pre-fire baseline: it precedes
				# the first tick (tree order process -> draw), so no slot of
				# THIS leg can have fired yet — structurally guaranteed, no
				# reliance on (possibly stale) last-leg rendered counts.
				_fx_base.append(img.duplicate())
				_fx_need_base = false
			elif not _fxs.done and not _fxs.want.is_empty():
				_grab_shot(img)


# --- panel + PNG builders --------------------------------------------------------

func _grab_panel(img: Image) -> void:
	var k := _want_panel
	_want_panel = -1
	# panel CENTRED on the viewport (player, hence the walker row below
	# them, is at screen centre under the camera rig)
	var region: Image = img.get_region(Rect2i((root.size.x - PANEL.x) / 2,
		(root.size.y - PANEL.y) / 2, PANEL.x, PANEL.y))
	_strip_img.blit_rect(region, Rect2i(0, 0, PANEL.x, PANEL.y),
		Vector2i(_panel_i * PANEL.x, 0))
	_panel_i += 1
	# every painted walk frame doubles as an FX false-positive floor frame:
	# a 9-pt ground grid (central 0.80w x 0.28h of the panel) over its own
	# ground reference — no FX exists in a walk leg, so compare.above here
	# is pure terrain noise (the checker gates fx footprints above this).
	var pts: Array = []
	for i in 3:
		for j in 3:
			pts.append(Vector2(PANEL.x * (0.5 + 0.3 * (i - 1)),
				PANEL.y * (0.20 + 0.09 * (j - 1))))
	_emit({"ev": "fx_noise_floor", "frame": "%s#%d" % [_key, _panel_i - 1],
		"compare": StripsProbe.compare(region, pts)})
	if _panel_i >= 6:
		var key := ("wraith-frozen-control" if _frozen else "%s-walk" % _key)
		var path := "%s/%s.png" % [_dir("HD3D_STRIP_DIR", "/tmp/s2h-strips"), key]
		assert(_strip_img.save_png(path) == OK)
		var row: Dictionary = {"ev": "frozen_control" if _frozen else "strip_gate",
			"class": _key, "png": path, "panels": 6,
			"steps": _step_i, "freq_hz": _freq}
		if _frozen:
			row["game_time"] = _main.game.time
		else:
			var raw := float(_tracked.spd) / (CameraRig.PX_PER_M * 1.2)
			row["freq_raw"] = raw
			row["capped"] = raw > FREQ_CAP + 1e-9
			if _key == "pale-wight":
				row["exempt_floor"] = 0.22 # DECLARED roster exemption
		row.merge(_probe.row())
		_emit(row)
		_leg_done = true


func _make_label() -> Label:
	var layer := CanvasLayer.new()
	layer.layer = 100
	root.add_child(layer)
	var l := Label.new()
	l.position = Vector2(332, 190) # inside the centred panel
	l.add_theme_font_size_override("font_size", 28)
	l.add_theme_color_override("font_color", Color(1, 1, 1))
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	l.add_theme_constant_override("outline_size", 8)
	layer.add_child(l)
	return l


func _emit(row: Dictionary) -> void:
	row["_ms"] = Time.get_ticks_msec()
	_out.store_line(JSON.stringify(row))
	_out.flush()


# --- fx shot + attack pair grabs --------------------------------------------------



func _grab_shot(img: Image) -> void:
	var shot: Dictionary = _fxs.shot
	var path := "%s/%s" % [_dir("HD3D_FX_DIR", "/tmp/s2h-fx"), shot.png]
	assert(img.save_png(path) == OK)
	var bimg: Image = _fx_base[0] if not _fx_base.is_empty() else null
	_fxs.grab(img, _cam, bimg)
	var row: Dictionary = _fxs.row
	row["png_path"] = path
	if shot.slot in ["rings", "arcs", "trails"]:
		# Faint alpha decals over textured ground: their pixel truth is
		# the BASELINE diff (pre-fire draw of this leg -> shot, player-
		# centred window) over an AMBIENT control pair drawn AFTER the
		# decal died (slot count 0 on both draws). Deferred emit.
		_fx_shot_img = img.duplicate()
		_fx_pending = row
		# halt refire AND empty the fx world while the ambient control
		# collects: the captured shot lives on in _fx_shot_img, and a
		# long-lived projectile (ember bolt mid-flight) would keep its
		# slot busy past the timeout, dying the baseline gate. (capture-
		# side only; DECLARED — the ambient pair is the fx-free window.)
		if _main.game.weapons.size() > 0:
			_main.game.weapons[0].cd = 999.0 # DECLARED capture pin
		var fxo: Object = _main.fx # transient arrays live on weapons.gd
		for aname in ["bolts", "throws", "bursts", "arcs", "rings", "halos"]:
			(fxo.get(aname) as Array).clear()
		return
	_emit(row)


func _grab_pair(img: Image) -> void:
	# The lunge is a DRAW transform (MultiMesh offset+squash in horde_viz),
	# NOT a sim position — pixel truth = pair frames spanning the lunge at
	# the tracked wraith's edge sample (+-22 px), against the CADENCE-
	# MATCHED ambient pair (the same 0.09 s span taken just BEFORE the
	# attack, from the time-stamped draw history).
	var aimg: Image = _pair_a # edge-frame A (draw branch stored it)
	_pair_a = null
	var path := "%s/wraith-lunge.png" % _dir("HD3D_STRIP_DIR", "/tmp/s2h-strips")
	assert(img.save_png(path) == OK)
	var ctr: Vector2 = _atk._samples[_atk._edge_at]
	var prow: Dictionary = {"ev": "attack_pair", "png": path,
		"window_px": 22, "t": _main.game.time, "span_s": 0.09,
		"ctr": [roundf(ctr.x), roundf(ctr.y)]}
	prow["pair_diff"] = StripsProbe.diff_count(aimg, img, ctr, 22)
	var ia := -1 # ambient pair: entries closest to t0-0.09 and t0
	var ib := -1
	var ba := 1e9
	var bb := 1e9
	for k in _atk_hist_t.size():
		var t: float = _atk_hist_t[k]
		var da: float = absf(t - (_pair_t0 - 0.09))
		if da < ba and da < 0.25:
			ba = da
			ia = k
		var db: float = absf(t - _pair_t0)
		if db < bb and db < 0.25:
			bb = db
			ib = k
	if ia >= 0 and ib > ia:
		prow["ambient_diff"] = StripsProbe.diff_count(_atk_hist[ia],
			_atk_hist[ib], ctr, 22)
	_emit(prow)
	if _atk.done:
		_close_attack()


func _close_attack() -> void:
	for r in _atk.rows:
		_emit(r)
	_next_leg()


func _hard_fail(msg: String) -> void:
	_emit({"ev": "s2h_fail", "note": msg})
	_fail = msg


# --- GL boot workaround -----------------------------------------------------------

func _frozen_decal_shot(i: int) -> bool:
	return StripsFxLeg.SHOTS[i].slot in ["rings", "arcs", "trails"]
