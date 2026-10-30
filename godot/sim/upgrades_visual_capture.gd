# Tick-deterministic pickup + upgrade-visual capture (T-S18, MC 11201).
# reason: >400 lines — 485 measured at T-M6q2 (366->485 @f8095d1: the +119
#   26-leg SKILL_FX capture family): ONE capture harness, ONE concern
#   (concern_check 1/1) — the biome_readability_capture-shaped carry: the
#   ONE tick-deterministic capture law rides next to its probe (audit-4
#   §1.3); splitting would fork the harness. Same pinned capture mechanism
#   as biome_readability_capture.gd (MC 11191 cycle 2 — the
#   TICK-DETERMINISTIC pattern this card REUSES, no second harness): a
# real X11 window under xvfb (windowed -s keeps real GL output), main.gd's
# own physics switched OFF at activation, and the clock advancing ONLY
# through fixed-count _step(1/60) calls from a pinned seed (HD3D_SEED,
# default 11201). Run:
#   xvfb-run godot --render-driver opengl3 --path . -s res://sim/upgrades_visual_capture.gd
# Legs, in order, over ONE live Main.tscn:
#  SCENARIO A "first-kill window": a seeded live run through the real
#   _start_game funnel + SimPolicy movement (sim_headless brain, same 0.05 s
#   policy cadence) and real _pick() level-ups; the tick is watched until
#   game.kills reaches 1 (FIRSTKILL row), then six shots save at FIXED tick
#   offsets after that kill (the SHOT_AT table below, sized to the sim's own
#   kill ramp — see its calibration comment). Every
#   pickup on the ground gets a PICK row with its screen position (projected
#   at PICK_Y through the real camera), so the probe counts palette pixels
#   where a pickup IS, whether or not anything draws it (the honest RED).
#  SCENARIO B "family scaling": 12 legs, each of the 6 weapon families at
#   level 1 and level MAX (8). The build is pinned to ONE weapon per leg
#   (the StripsFxLeg declared-pin pattern — other weapons' motion cannot
#   contaminate the family's pixel window), and the leg casts 6 IMMORTAL
#   frozen wraiths (hp pinned high, spd 0 — declared: no kills land during a
#   measurement window, so pickups and death cannot enter it). The clock
#   ticks until the family's OWN transient array is live (projectiles must
#   also leave the pawn by AWAY_PX, the StripsFxLeg lesson), then one shot.
#   The FAM row carries the window centre (player, or the burst point for
#   spike) already projected to screen px.
# Declared deviations (each spelled where it lands): hp is pinned to max
# every tick (boss-kill-leg precedent, no scripted driver survives the wall);
# spawn_acc is held 0 during scenario-B ticks (the cast stays exactly the 6
# pinned targets); PICK_Y below mirrors the product's pickup-billboard height
# (a HARNESS constant kept equal to PickupViz.PICK_Y — before the product
# fix nothing paints there, which is what the RED run is for).
extends SceneTree

const OUT_ENV := "HD3D_UV_SHOTS_DIR"
const DT := 1.0 / 60.0 # the engine's own fixed physics step, verbatim
const SETTLE_FRAMES := 3 # render frames between ticked state and save
	# (viz refreshes are delta-free state reads — biome convention)
# FIXED tick offsets after the first kill (the shot clock is this table, not
# wall clock; determinism carrier). A1 sits right on the kill window; A2..A6
# walk down the run because a Lv1-talon survivor only kills 1 unit by t≈8 s
# and 6 by t≈20 s (calibrated against .tmp/hd3d-boss-s6-dump.jsonl: kills 6
# @20 s, 43 @50 s, 167 @100 s, 434 @170 s) — coins (6 %/kill) and Dawnlight
# (1.5 %/kill) simply cannot exist at first-kill+15 ticks.
const SHOT_AT := [15, 1215, 2415, 4815, 7215, 9615]
const KILL_CAP_TICKS := 20 * 60 # determinism guard: fail, never hang
# A7 "Dawnlight window": the heal drop is 1.5 % per kill (world.gd:137) and
# the SimPolicy priority ladder chases any heal within 450 px (its own
# "near Dawnlight outranks everything"), so a coarse fixed-offset sampler
# sees it on the ground in ~10 % of frames. This shot instead ticks to the
# FIRST tick where world.heals is non-empty — the same EVENT-CONDITIONAL
# reading as s8_capture's boss stage ("warp past BOSS_AT and wait for the
# real gate — the boss gate is world.gd's, not injected"): pinned seed +
# fixed budget = fully deterministic. The budget is the constant below.
const HEAL_SCAN_TICKS := 40000 # ≈ 667 sim-s; the boss guaranteed-heal at
	# 9:00 (world.gd:137 boss roll) plus the late-run kill wall make a miss
	# a bug, never luck — a miss bails the capture with a stated failure
const POLICY_EVERY := 3 # 0.05 s of sim time — the sim_headless cadence
const PICK_Y := 0.28 # metres, mirrors PickupViz.PICK_Y (header)
const PICK_MARGIN := 30.0 # PICK rows only inside the frame margins (px)
const FAMS := ["talon", "ember", "cleaver", "halo", "ward", "spike"]
const LEVELS := [1, WeaponSystem.MAX_LEVEL]
const TARGETS := 6 # immortal cast targets per scenario-B leg
const TARGET_R := 150.0 # ring radius around the player (in frame, in range)
const AWAY_PX := 40.0 # projectiles must leave the pawn (StripsFxLeg lesson)
const FAM_CAP_TICKS := 60 * 60

var _main: Node
var _cam: Camera3D
var _pol := SimPolicy.new()
var _fam_cur := ""
var _lvl_cur := 0
var _stage := 0
var _wait := 0
var _kill_tick := -1
var _heal_tick := -1
var _ticks_this := 0
var _last_policy := -1.0
var _fail := ""


func _out_dir() -> String:
	var d: String = OS.get_environment(OUT_ENV)
	return d if d != "" else ProjectSettings.globalize_path("res://.tmp/upgrades-visual-shots")


func _initialize() -> void:
	print("CAPTURE_START")
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else 11201)
	assert(DirAccess.make_dir_recursive_absolute(_out_dir()) == OK)
	_main = load("res://Main.tscn").instantiate()
	root.add_child(_main)
	# S8 harness lesson: Main's _ready lands on the FIRST tree iteration, NOT
	# inside _initialize — the screens stub-swap + rig/policy binding below
	# would read null here (cycle-1 finding this card hit verbatim:
	# "remove_child(null)" at line 80), so they run on stage 0.
	_pol.main = _main
	# biome_readability lesson: set_physics_process(false) here does NOT stick
	# (the node's _ready activation lands on the FIRST frame) — it is set in
	# stage 0 below, after activation.
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _on_frame() -> void:
	if _wait > 0:
		_wait -= 1
		_advance(_stage)
		return
	if _stage == 0:
		# post-activation: Main's _ready has run, everything is wired now
		var old: CanvasLayer = _main._screens
		_main.remove_child(old)
		old.queue_free()
		var stub := SimStubScreens.new()
		_main.add_child(stub)
		_main._screens = stub
		stub.start_pressed.connect(_main._start_game)
		stub.card_picked.connect(_main._pick)
		_cam = _main._rig.get_child(0)
		_main._start_game()
		_main.set_physics_process(false) # the tick gate, post-activation
		_advance(1)
		return
	if _stage == 1:
		_run_to_first_kill()
		if _fail != "":
			_bail()
			return
		_run_ticks(SHOT_AT[0])
		_wait = SETTLE_FRAMES
		_advance(2)
		return
	# Scenario-A stages: stage 2+si (si = 0..5) saves shot si (its
	# fixed-offset state was ticked at the tail of the previous stage) then
	# ticks to the next offset; stage 7 saves the last shot and arms B leg 0.
	# Bounds are EXCLUSIVE of stage 8 — cycle-1 finding this card hit: a
	# "<= 2 + N" bound let stage 8 run through this branch, shifting every
	# B leg one stage late (talon-L8 never armed).
	if _stage >= 2 and _stage <= 1 + SHOT_AT.size():
		var si := _stage - 2
		_save_pickup_shot(si)
		if si + 1 < SHOT_AT.size():
			_run_ticks(SHOT_AT[si + 1] - SHOT_AT[si])
			_wait = SETTLE_FRAMES
			_advance(_stage + 1)
		else:
			_run_heal_scan()
			if _fail != "":
				_bail()
				return
			_wait = SETTLE_FRAMES
			_advance(2 + SHOT_AT.size()) # stage 8 = the A7 heal shot
		return
	if _stage == 2 + SHOT_AT.size():
		_save_heal_shot()
		_fam_setup(0)
		_wait = SETTLE_FRAMES
		_advance(_stage + 1)
		return
	# Scenario-B stages: stage 9+li saves leg li (set up at the tail of the
	# previous stage) and arms leg li+1. ONE leg per stage — s8_capture lesson
	# (a re-chained one-shot fires TWICE per draw under Xvfb/llvmpipe): the
	# second firing lands on the _wait countdown branch above, so the
	# save+setup below runs exactly once per stage.
	if _stage >= 9 and _stage - 9 < FAMS.size() * LEVELS.size():
		var li := _stage - 9
		_save_fam_shot(li)
		if li + 1 < FAMS.size() * LEVELS.size():
			_fam_setup(li + 1)
			_wait = SETTLE_FRAMES
			_advance(_stage + 1)
		else:
			# T-M6f (MC 11705, §2.2/§2.3): the ONE probe harness ADVANCES
			# into SCENARIO C at the last family leg — per-SKILL windows
			# for every fireable id (its palette method stays DEFENDED,
			# untouched; the C legs ride the SAME StripsFxLeg pin pattern).
			_skill_setup(0)
			_wait = SETTLE_FRAMES
			_advance(_stage + 1)
		return
	# Scenario-C stages (T-M6f): stage 21+ci saves skill leg ci (its leg was
	# set up at the tail of the previous stage — ONE leg per stage, the s8
	# capture lesson the B legs already carry).
	var cb := _stage - (9 + FAMS.size() * LEVELS.size())
	if cb >= 0 and cb < SKILL_IDS.size():
		_save_skill_shot(cb)
		if cb + 1 < SKILL_IDS.size():
			_skill_setup(cb + 1)
			_wait = SETTLE_FRAMES
			_advance(_stage + 1)
		else:
			print("CAPTURE_OK")
			quit()
		return
	_fail = "stage machine fell through stage %d" % _stage
	_bail()


func _advance(next_stage: int) -> void:
	_stage = next_stage
	RenderingServer.frame_post_draw.connect(_on_frame, CONNECT_ONE_SHOT)


func _bail() -> void:
	print("CAPTURE_FAIL %s" % _fail)
	quit(3)


# --- scenario A -------------------------------------------------------------

# Seeded live run: real _step, SimPolicy input every 0.05 s of sim time, real
# _pick through the level-up funnel, hp pinned (declared). Ticks until
# game.kills == 1 (FIRSTKILL row); shots A1..A6 then land at the fixed
# SHOT_AT tick offsets after that kill (stage machine above).
func _run_to_first_kill() -> void:
	var n := 0
	while _main.game.kills < 1 and n < KILL_CAP_TICKS:
		_sim_tick()
		n += 1
	if _main.game.kills < 1:
		_fail = "no kill within %d ticks" % KILL_CAP_TICKS
		return
	_kill_tick = n
	print("FIRSTKILL tick=%d t=%.3f kills=%d gems=%d coins=%d heals=%d" % [
		_kill_tick, _main.game.time, _main.game.kills, _main.world.gems.size(),
		_main.world.coins.size(), _main.world.heals.size()])


func _run_ticks(n: int) -> void:
	for _i in n:
		_sim_tick()


func _sim_tick() -> void:
	var game = _main.game
	if game.phase == "levelup":
		_main._pick(_pol.pick_index(_main))
		return # a pick costs no sim tick (same accounting as biome capture)
	if game.phase != "playing":
		return # gameover/win idles the loop (never advance past an ended run)
	if game.time - _last_policy >= 0.05:
		_last_policy = game.time
		_hold(_pol.combo())
	_main._handle_presses()
	_main._step(DT)
	game.hp = game.max_hp # DECLARED pin (boss-kill-leg precedent)


func _hold(combo: String) -> void:
	_main.bridge.on_key("KeyW", combo.contains("W"))
	_main.bridge.on_key("KeyA", combo.contains("A"))
	_main.bridge.on_key("KeyS", combo.contains("S"))
	_main.bridge.on_key("KeyD", combo.contains("D"))


# Tick to the FIRST live Dawnlight on the ground (event-conditional, see the
# HEAL_SCAN_TICKS comment). Ticks stop on a non-playing phase (win/gameover
# idles the loop) — a scan that ends without a heal bails, never fakes.
func _run_heal_scan() -> void:
	var n := 0
	while _main.world.heals.is_empty() and n < HEAL_SCAN_TICKS:
		if _main.game.phase != "playing":
			_fail = "heal scan: run ended (%s) with no Dawnlight on the ground" \
				% String(_main.game.phase)
			return
		_sim_tick()
		n += 1
	if _main.world.heals.is_empty():
		_fail = "heal scan: no Dawnlight within %d ticks" % HEAL_SCAN_TICKS
		return
	_heal_tick = n
	print("HEALWIN tick=%d t=%.3f kills=%d gems=%d coins=%d heals=%d" % [
		n, _main.game.time, _main.game.kills, _main.world.gems.size(),
		_main.world.coins.size(), _main.world.heals.size()])


func _save_heal_shot() -> void:
	print("A shot=A7-healwin.png t=%.3f kills=%d gems=%d coins=%d heals=%d heal_at=%d" % [
		_main.game.time, _main.game.kills, _main.world.gems.size(),
		_main.world.coins.size(), _main.world.heals.size(), _heal_tick])
	_save_pickup_picks("A7-healwin.png")


func _save_pickup_shot(shot: int) -> void:
	var png := "A%d-pickups.png" % (shot + 1)
	print("A shot=%s t=%.3f kills=%d gems=%d coins=%d heals=%d killtick=%d" % [
		png, _main.game.time, _main.game.kills, _main.world.gems.size(),
		_main.world.coins.size(), _main.world.heals.size(), _kill_tick])
	_save_pickup_picks(png)


# PICK rows: every ground pickup projected through the real camera at the
# product's billboard height (PICK_Y, header) — printed whether or not the
# product paints anything there, which is the honest RED.
func _save_pickup_picks(png: String) -> void:
	for kind in ["gems", "coins", "heals"]:
		for it in _main.world.get(kind):
			var sp: Vector2 = _cam.unproject_position(Vector3(
				it.x / CameraRig.PX_PER_M, PICK_Y,
				it.y / CameraRig.PX_PER_M))
			if sp.x >= PICK_MARGIN and sp.y >= PICK_MARGIN \
					and sp.x <= GameRenderer.VIEW.x - PICK_MARGIN \
					and sp.y <= GameRenderer.VIEW.y - PICK_MARGIN:
				print("PICK %s %.1f %.1f" % [kind, sp.x, sp.y])
	_save_png(png)


# --- scenario B -------------------------------------------------------------

func _fam_setup(li: int) -> void:
	var fam: String = FAMS[li / LEVELS.size()]
	var lvl: int = LEVELS[li % LEVELS.size()]
	_fam_cur = fam
	_lvl_cur = lvl
	_main._start_game() # real funnel clears world + FX transients
	_main.game.weapons = [{"id": fam, "level": lvl, "cd": 0.0}] # DECLARED pin
	for _i in TARGETS:
		_main.world._spawn_enemy("wraith", _main.game, GameRenderer.VIEW)
		var e: Dictionary = _main.world.enemies.back()
		var a := float(_i) / float(TARGETS) * TAU
		e.x = _main.game.player.x + cos(a) * TARGET_R
		e.y = _main.game.player.y + sin(a) * TARGET_R
		e.spd = 0.0 # FROZE cast (art_capture convention)
		e.hp = 100000.0 # DECLARED immortal cast: no kills die inside the
		e.max_hp = 100000.0 # measurement window -> no pickups, no death
	_ticks_this = 0
	var arr: Array = _fam_array(fam)
	for n in FAM_CAP_TICKS:
		_main.world.spawn_acc = 0.0 # DECLARED suppression (casts stay 6)
		_main._step(DT)
		_main.game.hp = _main.game.max_hp
		_ticks_this += 1
		if not arr.is_empty() and _away_ok(fam):
			return
	_fail = "family %s L%d: array never live within %d ticks" % [fam, lvl, FAM_CAP_TICKS]
	_bail()


# Projectiles spawn ON the pawn body (StripsFxLeg lesson): wait until the
# live instance has real flight distance before the shot. Ground decals and
# the orbit ring never sit on the pawn.
func _away_ok(fam: String) -> bool:
	var p: Dictionary = _main.game.player
	match fam:
		"ember":
			var b: Dictionary = _main.fx.bolts[-1]
			return Vector2(b.x - p.x, b.y - p.y).length() >= AWAY_PX
		"cleaver":
			return _main.fx.throws[-1].dist >= AWAY_PX
	return true


func _fam_array(fam: String) -> Array:
	match fam:
		"talon": return _main.fx.arcs
		"ember": return _main.fx.bolts
		"cleaver": return _main.fx.throws
		"halo": return _main.fx.halos
		"ward": return _main.fx.rings
		_: return _main.fx.bursts


func _save_fam_shot(li: int) -> void:
	var png := "%s-L%d.png" % [_fam_cur, _lvl_cur]
	var game = _main.game
	var p: Dictionary = game.player
	var ctr := Vector2(p.x / CameraRig.PX_PER_M, p.y / CameraRig.PX_PER_M)
	if _fam_cur == "spike" and not _main.fx.bursts.is_empty():
		var b: Dictionary = _main.fx.bursts[-1]
		ctr = Vector2(b.x, b.y) / CameraRig.PX_PER_M
	var sp: Vector2 = _cam.unproject_position(Vector3(ctr.x, 0.05, ctr.y))
	print("FAM fam=%s L=%d tick=%d t=%.3f arr=%d cx=%.1f cy=%.1f png=%s" % [
		_fam_cur, _lvl_cur, _ticks_this, game.time,
		_fam_array(_fam_cur).size(), sp.x, sp.y, png])
	_save_png(png)


# --- scenario C (T-M6f, MC 11705, M6-SPEC §2.2/§2.3) -------------------------
# ONE leg per SKILL_FX row (the 26 fireable ids: 15 weapon-side + the 9
# live evolved + the 2 union orbiters): the SAME declared-pin pattern as
# scenario B (weapons pinned to the ONE firing id — the evolved ids pin
# directly, the sim_boss-declared construction the §2.3 FX-E4 row names),
# the SAME immortal frozen cast, the array-live + away gates. The SKILL
# row carries what the probe's palette window judges: the row's own
# sampled colour (printed FROM the table, the drift class the pytest pin
# separately catches), the RENDERED rings/draws counts read off the
# renderer (the flash leg: flash ids must show rings >= 1 through the
# existing cap read; live_draws must stay <= FX_DRAWS_MAX — a planted
# second MM goes RED here, FX-E4's red column).

# The SKILL_FX row ids in table order (the §2.1 table's own order —
# tests/test_skill_fx.py pins the leg list equals the table's keys).
const SKILL_IDS := ["talon", "ember", "cleaver", "halo", "ward", "spike",
	"bone-whip", "dart-loop", "hewn-axe", "pilgrim-cross",
	"censer-of-hours", "rot-water", "spectral-disc", "storm-peal",
	"fire-lash", "red-wail", "thousand-darts", "rot-spiral",
	"judgement-cross", "eternal-matins", "the-sluice", "grave-orbit",
	"rolling-thunder", "inferno-lash", "requiem-toll", "dirge-eternal"]
const SKILL_LEVEL := 5 # mid-level: the LOOK reads (colour/scale/band) are
	# level-independent rows; level 5 sits inside the shipped count curves

var _skill_cur := ""


func _skill_setup(ci: int) -> void:
	var wid: String = SKILL_IDS[ci]
	var cls := String(WeaponFxViz.SKILL_FX[wid].cls)
	_skill_cur = wid
	_main._start_game() # real funnel clears world + FX transients
	_main.game.weapons = [{"id": wid, "level": SKILL_LEVEL, "cd": 0.0}]
	# DECLARED pin (scenario-B law): the evolved ids and union ids are
	# PINNED directly into the weapon slot — a declared-pin construction,
	# the §2.3 FX-E4 seam, never a pool offer (the pool never fires them).
	for _i in TARGETS:
		_main.world._spawn_enemy("wraith", _main.game, GameRenderer.VIEW)
		var e: Dictionary = _main.world.enemies.back()
		var a := float(_i) / float(TARGETS) * TAU
		e.x = _main.game.player.x + cos(a) * TARGET_R
		e.y = _main.game.player.y + sin(a) * TARGET_R
		e.spd = 0.0 # FROZE cast (art_capture convention)
		e.hp = 100000.0 # DECLARED immortal cast (scenario-B reading)
		e.max_hp = 100000.0
	_ticks_this = 0
	var arr: Array = _fx_class_array(cls)
	for n in FAM_CAP_TICKS:
		_main.world.spawn_acc = 0.0 # DECLARED suppression (casts stay 6)
		_main._step(DT)
		_main.game.hp = _main.game.max_hp
		_ticks_this += 1
		if not arr.is_empty() and _away_cls(cls):
			return
	_fail = "skill %s: array never live within %d ticks" % [wid, FAM_CAP_TICKS]
	_bail()


func _away_cls(cls: String) -> bool:
	match cls:
		"bolts":
			var p: Dictionary = _main.game.player
			var b: Dictionary = _main.fx.bolts[-1]
			return Vector2(b.x - p.x, b.y - p.y).length() >= AWAY_PX
		"throws":
			return _main.fx.throws[-1].dist >= AWAY_PX
	return true


func _fx_class_array(cls: String) -> Array:
	match cls:
		"arcs": return _main.fx.arcs
		"bolts": return _main.fx.bolts
		"throws": return _main.fx.throws
		"halos": return _main.fx.halos
		"rings": return _main.fx.rings
		_: return _main.fx.bursts


func _save_skill_shot(ci: int) -> void:
	var row: Dictionary = WeaponFxViz.SKILL_FX[_skill_cur]
	var col: Color = row.color
	var cls := String(row.cls)
	var counts: Dictionary = _main._fxv.fx_counts()
	var game = _main.game
	var p: Dictionary = game.player
	var ctr := Vector2(p.x / CameraRig.PX_PER_M, p.y / CameraRig.PX_PER_M)
	if cls == "bursts" and not _main.fx.bursts.is_empty():
		var b: Dictionary = _main.fx.bursts[-1] # the spike reading, verbatim
		ctr = Vector2(b.x, b.y) / CameraRig.PX_PER_M
	var sp: Vector2 = _cam.unproject_position(Vector3(ctr.x, 0.05, ctr.y))
	var png := "S-%s.png" % _skill_cur
	print("SKILL id=%s cls=%s tick=%d t=%.3f arr=%d cx=%.1f cy=%.1f col=%.3f,%.3f,%.3f flash=%d rings=%d draws=%d png=%s" % [
		_skill_cur, cls, _ticks_this, game.time,
		_fx_class_array(cls).size(), sp.x, sp.y, col.r, col.g, col.b,
		1 if bool(row.flash) else 0, int(counts.get("rings", 0)),
		_main._fxv.live_draws(), png])
	_save_png(png)


func _save_png(png: String) -> void:
	var img: Image = root.get_texture().get_image()
	var path: String = _out_dir() + "/" + png
	assert(img.save_png(path) == OK)
	print("SAVED %s %dx%d" % [path, img.get_width(), img.get_height()])
