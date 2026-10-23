# Real-clock acceptance harness (T-S8, MC 11148): replaces the DECLARED
# clock-warp of the S3 WIN row with wall time. The game ticks itself —
# main.gd's own _physics_process at the engine's fixed 60 Hz with
# Engine.time_scale held at 1.0; this script never calls _step and never
# touches game.time. Deviations vs a human session are only the S3 ones:
# the screens layer is stubbed (SimStubScreens) and input/picks come from
# SimPolicy — same brain, same 0.05 s-of-sim-time policy cadence, driven
# off the game clock instead of a manual loop. Rows (HD3D_OUT, default
# /tmp/hd3d-s8.jsonl): leg_start (wall-clock ISO + unix), pos samples every
# 10 s of sim time (kills/hp/lvl trace), physics ticks counted off
# physics_frame, leg_end (wall delta + ticks + ticks/sec + the end stats) —
# plus monotonic_time_check: game.time never decreases and only advances
# while phase == "playing". HD3D_TMAX stops a leg at a sim-time cap (leg
# row "stop", rc 2) — the harness sanity leg, never the acceptance rows;
# HD3D_MAX_WALL is the safety abort (rc 4). HD3D_HP_PIN=1 declares the ONE
# extra deviation the WIN leg carries: game.hp pinned to max every frame —
# the SAME declared deviation the S6 boss kill-leg carries (sim_boss.gd
# header 2), because no scripted driver survives the 12/s endgame wall
# (scan this card ran: seeds 11101-11106 die at t 375..467). The CLOCK is
# never touched: it is a survival pin at true 1.0x, not a warp.
extends SceneTree

const POLICY_DT := 0.05 # 0.05 s of SIM time — the S3 POLICY_EVERY cadence
const POS_EVERY := 10.0 # 10 s pos/stat rows, S3 POS_EVERY convention

var _main: Node
var _pol := SimPolicy.new()
var _out: FileAccess
var _started := false
var _hp_pin := false
var _t0_ms := 0
var _ticks := 0
var _last_policy := -1.0
var _last_pos := 0.0
var _last_seen_time := 0.0
var _mono_ok := true
var _picks := 0
var _ended := false


func _initialize() -> void:
	assert(Engine.time_scale == 1.0) # TRUE 1.0x is the card; never rescale


func _on_physics() -> void:
	_ticks += 1


func _process(_delta: float) -> bool:
	if not _started:
		_started = true # S3 pattern: real scene wiring on the first frame
		var s := OS.get_environment("HD3D_SEED")
		seed(s.to_int() if s != "" else 11101)
		var out := OS.get_environment("HD3D_OUT")
		_out = FileAccess.open(out if out != "" else "/tmp/hd3d-s8.jsonl",
				FileAccess.WRITE)
		assert(_out != null)
		_main = load("res://Main.tscn").instantiate()
		root.add_child(_main) # _ready wires the real 3D scene + bridge
		var old: CanvasLayer = _main._screens # same stub-swap as sim_headless
		_main.remove_child(old)
		old.queue_free()
		var stub := SimStubScreens.new()
		_main.add_child(stub)
		_main._screens = stub
		stub.start_pressed.connect(_main._start_game)
		stub.card_picked.connect(_main._pick)
		_pol.main = _main
		_hp_pin = OS.get_environment("HD3D_HP_PIN") == "1"
		physics_frame.connect(_on_physics)
		_t0_ms = Time.get_ticks_msec()
		_main._start_game()
		_emit({"ev": "leg_start", "seed": s if s != "" else "11101",
			"time_scale": Engine.time_scale, "hp_pinned": _hp_pin,
			"wall_start_iso": Time.get_datetime_string_from_system(),
			"wall_start_unix": _wall_start_unix(),
			"phase": _main.game.phase})
	if _ended:
		return false
	var game = _main.game
	var t: float = game.time
	if _hp_pin and game.phase == "playing":
		game.hp = game.max_hp # DECLARED deviation, S6 kill-leg precedent
	if t < _last_seen_time - 0.0001:
		_mono_ok = false
	_last_seen_time = t
	if game.phase == "levelup":
		var idx: int = _pol.pick_index(_main)
		_emit({"ev": "pick", "t": _r3(t), "card": _main._current_offer[idx].name,
			"level": game.level})
		_main._pick(idx)
		_picks += 1
	if t - _last_policy >= POLICY_DT:
		_last_policy = t
		_hold(_pol.combo())
	if t - _last_pos >= POS_EVERY:
		_last_pos = t
		var p: Dictionary = game.player
		_emit({"ev": "pos", "t": _r3(t), "hp": _r1(game.hp), "lvl": game.level,
			"xp": _r1(game.xp), "kills": game.kills, "gold": game.gold,
			"x": _r1(p.x), "y": _r1(p.y),
			"enemies": _main.world.enemies.size()})
	var tmax := OS.get_environment("HD3D_TMAX")
	if tmax != "" and t >= tmax.to_float():
		_emit_end("stop")
		quit(2)
		return true
	var maxwall := OS.get_environment("HD3D_MAX_WALL")
	if maxwall != "" and _wall_s() >= maxwall.to_float():
		_emit({"ev": "wall_timeout", "t": _r3(t), "wall_s": _r2(_wall_s())})
		quit(4)
		return true
	if game.phase in ["gameover", "win"]:
		_emit_end(game.phase)
		quit(0)
		return true
	return false


func _hold(combo: String) -> void:
	_main.bridge.on_key("KeyW", combo.contains("W"))
	_main.bridge.on_key("KeyA", combo.contains("A"))
	_main.bridge.on_key("KeyS", combo.contains("S"))
	_main.bridge.on_key("KeyD", combo.contains("D"))


func _emit_end(kind: String) -> void:
	_ended = true
	var game = _main.game
	var wall: float = _wall_s()
	# stats is only filled by end_run; the HD3D_TMAX stop has none, so the
	# row reads the live game fields (stats.time == game.time by v1 contract).
	var stats := {"time": game.time, "kills": game.kills,
		"level": game.level, "gold": game.gold}
	_emit({"ev": "leg_end", "kind": kind, "phase": game.phase,
		"hp_pinned": _hp_pin, "time_scale": Engine.time_scale,
		"t_sim": _r3(game.time), "wall_start_unix": _wall_start_unix(),
		"wall_end_iso": Time.get_datetime_string_from_system(),
		"wall_end_unix": Time.get_unix_time_from_system(),
		"wall_s": _r2(wall), "ticks": _ticks,
		"ticks_per_s": _r2(_ticks / maxf(wall, 0.001)),
		"sim_t_per_wall_s": _r3(game.time / maxf(wall, 0.001)),
		"monotonic_time_check": _mono_ok, "picks": _picks,
		"time": stats.time, "kills": stats.kills, "level": stats.level,
		"gold": stats.gold, "hp": _r1(game.hp),
		"score": _main._score(stats)})
	_out.flush()


func _wall_s() -> float:
	return (Time.get_ticks_msec() - _t0_ms) / 1000.0


func _wall_start_unix() -> float:
	return Time.get_unix_time_from_system() - _wall_s()


func _emit(row: Dictionary) -> void:
	_out.store_line(JSON.stringify(row))
	_out.flush() # live progress readable while the engine runs


func _r1(v: float) -> float:
	return roundi(v * 10.0) / 10.0


func _r2(v: float) -> float:
	return roundi(v * 100.0) / 100.0


func _r3(v: float) -> float:
	return roundi(v * 1000.0) / 1000.0
