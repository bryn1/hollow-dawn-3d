# Entry point: 3D scene wiring (orthographic camera rig, biome ground, per-
# class horde viz, hero pawn), JS bridge registration, fixed-step simulation,
# phase routing (menu/playing/levelup/end), the Contract B snapshot eval and
#   the M5 meta-verb wrappers over the five overlay surfaces (MC 11573, §1.2).
# reason: >400 lines — the ONE fixed-step sim loop + phase router of the
#   whole game (DESIGN-3D §d v1-verbatim); splitting it would fork the loop.
# M5 GROWTH NAMED (audit-3 §1.2, the C1 world.gd shape): 472 -> 596 in M5,
#   503/566/596 @T-M5p/c/k; verb blocks :530/:553-596 = the wire-graph proof.
# The simulation loop below is v1 main.gd VERBATIM (DESIGN-3D §d): same
# constants, same WIN_TIME gate, same score formula; only the visible layer
# wiring is 3D (the v1 Node2D renderer body is deleted, §f — render.gd
# survives as the data module that owns the BIOMES/biome_at tables).
extends Node3D

const VIEW := Vector2(1280, 720)

# M2 §A.1 (T-M2e): the absolute per-hit contact-damage cap at the contact
# site, BEFORE damage_taken (ward/rotten-plate reduction stays downstream).
# 20.0 is the rev-2 P2-1 REACHABLE boss-class bound: max base contact damage
# 12 (world.gd warden) x DMG_CYC >= 1.7 (cycle >= 4) exceeds it, while
# cycle-0 raw == base dmg (DMG_CYC(0) = 1.0) is never capped — flag-off
# byte-stable.
const MAX_CONTACT_DMG := 20.0

var game: GameState
var world: GameWorld
var fx: WeaponSystem
var bridge: Node
var _dawnwell: DawnWell # meta-progression save (M1 W-P, MC 11205)
var _rig: Node3D
var _ground: MeshInstance3D
var _viz: Node3D
var _fxv: Node3D
var _pvz: Node3D # T-S18 pickup layer (MC 11201), reads world pickup arrays only
var _pawn: Node3D
var _hud: CanvasLayer
var _screens: CanvasLayer
var _current_offer: Array = []
var _web := false
var _js: Object # the JavaScriptBridge singleton, web builds only
var _js_cb: Object # keeps the inbound key callback alive


func _ready() -> void:
	game = GameState.new()
	world = GameWorld.new()
	fx = WeaponSystem.new()
	fx.bind(world, game)
	_web = OS.has_feature("web")

	# M1 W-P persistence (MC 11205): load the Dawn Well save once at boot.
	# A missing file is the normal first-run defaults case; an undecodable
	# or future-version file quarantines itself inside load_save() (rename
	# to dawnwell.corrupt.json + SAVE_LOAD_FAIL stderr line) and boot
	# continues on defaults. Since T-M1f the Dawn Well shop mutates it —
	# every mutation lands through the _meta_changed funnel below, and run
	# gold stays run-local until the run ends (_end_run cashes it out).
	_dawnwell = DawnWell.load_save()

	# Visible layer (DESIGN-3D §a/§b): every node reads game/world/fx each
	# frame; the sim stays 2D px and the viz converts to metres (S = 24).
	_rig = preload("res://scripts/camera_rig.gd").new()
	_rig.game = game
	add_child(_rig)
	# §b lighting row, LANDED WITH THE ART (T-S2i finding: the scene carried
	# zero lights before this card — shaded horde meshes read pitch black;
	# only unshaded quads drew). One moon DirectionalLight3D, no real-time
	# shadow pass (WASM cost, §b), + WorldEnvironment ambient — v1's flat
	# dark look. Adds ZERO draws (shadow off).
	var moon := DirectionalLight3D.new()
	moon.light_color = GameRenderer.MOON
	moon.light_energy = 1.3 # §b pins the mechanism, not the level; tuned so
	# baked-diffuse GLB horde meshes read on the dark tiles (v1 kept the same
	# readability with sprites over the same dark ground).
	moon.shadow_enabled = false
	moon.rotation_degrees = Vector3(-55.0, -30.0, 0.0)
	add_child(moon)
	var env := Environment.new()
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = GameRenderer.MOON
	env.ambient_light_energy = 0.5
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	_ground = preload("res://scripts/ground.gd").new()
	_ground.game = game
	add_child(_ground)
	_viz = preload("res://scripts/horde_viz.gd").new()
	_viz.game = game
	_viz.world = world
	add_child(_viz)
	_pawn = preload("res://scripts/hero_pawn.gd").new()
	_pawn.game = game
	add_child(_pawn)
	# S4 weapon-FX layer (§i): reads the WeaponSystem transient arrays only.
	_fxv = preload("res://scripts/viz_fx.gd").new()
	_fxv.game = game
	_fxv.sim = fx
	add_child(_fxv)
	# T-S18 pickup layer (MC 11201): §b's planned gem/coin/dawnlight/glow
	# MultiMeshes reading world.coins/gems/heals only — zero gameplay change.
	_pvz = preload("res://scripts/pickup_viz.gd").new()
	_pvz.game = game
	_pvz.world = world
	add_child(_pvz)

	_hud = preload("res://scripts/hud_3d.gd").new()
	_hud.game = game
	_hud.world = world # S6: the boss bar scans world.enemies (mirrors _viz)
	add_child(_hud)

	_screens = preload("res://scripts/screens.gd").new()
	add_child(_screens)
	_screens.start_pressed.connect(_start_game)
	_screens.card_picked.connect(_pick)
	# Dawn Well shop (T-M1f): the menu seam opens the panel; the shop only
	# emits verbs, the mutations happen HERE and persist through the ONE
	# _meta_changed funnel (T-M1a contract: the funnel below stays the file's
	# only call into save()).
	_screens.shop_requested.connect(_open_shop)
	_screens.shop_buy.connect(_shop_buy)
	_screens.shop_refund.connect(_shop_refund)
	_screens.shop_refund_all.connect(_shop_refund_all)
	# Stage select (M3 §2, T-M3s): fifth overlay, same verb contract as the
	# shop — the panel emits, main mutates _dawnwell + persists via the ONE
	# _meta_changed funnel and refreshes.
	_screens.stages_requested.connect(_open_stages)
	_screens.stage_selected.connect(_stage_chosen)
	# Achievements page (M5 §1.1, T-M5p): the SEVENTH overlay, DISPLAY-only
	# — no verb writes here (spec §1.1), the panel emits open/close verbs
	# and the thin wrappers below route them (the funnel call-count pins
	# stay at the shipped set — P-E3).
	_screens.achievements_requested.connect(_open_achievements)
	_screens.achievements_closed.connect(_close_achievements)
	# Roster select (M5 §2.1, T-M5c): the SIXTH overlay (the achievements
	# page is the seventh; this one sits between the stage select and it),
	# same verb contract as the shop — the panel emits verbs ONLY, main
	# mutates _dawnwell + persists through the ONE _meta_changed funnel and
	# refreshes (the R1-anchored funnel law; B-E5's disk-observability legs
	# run THESE verbs from the sim).
	_screens.characters_requested.connect(_open_characters)
	_screens.char_bought.connect(_char_buy)
	_screens.char_selected.connect(_char_select)
	_screens.skin_bought.connect(_char_buy_skin)
	_screens.skin_selected.connect(_char_select_skin)

	bridge = preload("res://scripts/bridge.gd").new()
	bridge.name = "VSHost"
	add_child(bridge)
	if _web:
		_js = Engine.get_singleton("JavaScriptBridge")
		if _js != null:
			_register_key_bridge()


# Godot 4.7 removed JavaScriptBridge.register(); the inbound path is a
# create_callback object hung on window.vsHost.on_key (same JS-side contract).
func _register_key_bridge() -> void:
	_js_cb = _js.call("create_callback", Callable(self, "_on_js_key"))
	_js.call("eval", "window.vsHost = {};", true)
	var host: Object = _js.call("get_interface", "vsHost")
	host.set("on_key", _js_cb)


func _on_js_key(args: Array) -> void:
	if args.size() >= 2:
		bridge.on_key(String(args[0]), bool(args[1]))


# Single choke point into the JS bridge: while the bridge is inactive
# (desktop builds, _js null) every call is a silent no-op. No other code
# may call JavaScriptBridge.eval.
func _js_eval(js: String) -> void:
	if _js == null:
		return
	_js.call("eval", js, true)


func _process(delta: float) -> void:
	_hud.update(delta)


# Snapshot + simulation run on the fixed physics tick (Contract B: time
# advances only while playing; the snapshot ships every tick).
func _physics_process(delta: float) -> void:
	_handle_presses()
	if game.phase == "playing" and not game.paused:
		_step(delta)
	_js_eval("window.__vsSnapshot=" + game.snapshot_json(world.enemies.size()))


func _handle_presses() -> void:
	for code: String in bridge.drain_presses():
		if code == "KeyM":
			game.muted = not game.muted # internal flag; this build ships no audio
		elif code == "Escape" and game.phase == "playing":
			game.paused = not game.paused
		# The shop and the stage select are menu-phase UI: while either is
		# open the Enter that would start a run is inert (the panel's own
		# mouse buttons own input — A-E8, shop-guard parity, MC 11282).
		elif game.phase == "menu" and bridge.is_enter(code) and not _screens.shop_visible() \
			and not _screens.stages_visible() and not _screens.chars_visible():
			_start_game()
		elif game.phase == "levelup":
			if code == "Digit1":
				_pick(0)
			elif code == "Digit2":
				_pick(1)
			elif code == "Digit3":
				_pick(2)
			elif bridge.is_enter(code):
				_pick(0)
		# gameover / win: Enter deliberately does NOT restart — the score
		# panel (web) and the Play-again button own that screen.


func _step(dt: float) -> void:
	game.time += dt
	var p: Dictionary = game.player
	var v: Vector2 = bridge.move_vector()
	if v != Vector2.ZERO:
		p.dir_x = v.x
		p.dir_y = v.y
		var spd := game.player_speed()
		p.x += v.x * spd * dt
		p.y += v.y * spd * dt
	world.update_spawns(dt, game, VIEW)
	world.update_entities(dt, game)
	fx.update(dt, game)
	for e in world.enemies:
		var er: float = 55.0 if e.boss else 17.0
		var dx: float = e.x - p.x
		var dy: float = e.y - p.y
		if dx * dx + dy * dy < (er + 16.0) * (er + 16.0):
			# M4 §2.1 END LAW (T-M4r, F-6): the reaper row's dict flag is
			# read FIRST inside the existing boss-radius test — contact is
			# the RUN-END, NOT damage: no damage, no clamp, the phase enum
			# untouched (gameover is shipped). The end law is NOT behind
			# the iframes gate: a stationary surrounded runner refills
			# iframes from the horde on EVERY cleared window (shipped array
			# order + break), so an iframes-gated reaper could never end
			# such a run — B-E2's window (900,930) as WRITTEN names it.
			# Flag off: e.get("reaper") is false for every shipped row, so
			# the branch is a pure fallthrough — same checks, same order,
			# zero RNG, byte-identical (B-E1). The row's dmg 30 never
			# reaches the clamp below (the test_combat_numbers column
			# re-pin names this exclusion; the B-E2 planted "damage 20
			# instead of ending" RED-proves the law from the other side).
			if e.get("reaper", false):
				_end_run("gameover")
				return
			if p.iframes <= 0.0:
				# §A.1: cycle-scaled contact damage, ONE clamped read before
				# damage_taken. cycle 0: dmg_cyc = 1.0 exact and every base dmg
				# (max 12) < MAX_CONTACT_DMG, so the raw read is the verbatim
				# e.dmg — flag-off byte-stable (F-4).
				var raw: float = minf(e.dmg * GameWorld.dmg_cyc(game.cycle), MAX_CONTACT_DMG)
				game.hp -= game.damage_taken(raw)
				p.iframes = GameState.IFRAMES
				break
	game.gold += world.collect_pickups(game)
	if game.hp <= 0.0:
		game.hp = 0.0
		_end_run("gameover")
		return
	if game.time >= GameState.WIN_TIME:
		# M2 pillar A (§A.1): with the flag ON the limit does NOT end the
		# run — the existing win BRANCH becomes the cycle-clear crossing
		# (latched: fires once per WIN_TIME boundary, cycle = int(time //
		# WIN_TIME), the ONE clock). Flag OFF keeps M1's win byte-identical.
		if game.endless:
			var next_cycle := int(game.time / GameState.WIN_TIME)
			if next_cycle > game.cycle:
				game.cycle = next_cycle
				_cycle_clear()
		# M4 §2.1 REAPER NIGHT (T-M4r, MC 11364): with the night flag ON and
		# Endless OFF the limit does NOT end the run — the run CONTINUES,
		# hunted: the world-side arrival latch (world.gd, beside the
		# schedule latch) walks one the-reaper per REAPER_PERIOD past the
		# limit and THIS step's contact arm ends the run on touch (F-6: no
		# damage, no clamp, the phase enum untouched). The ORDER is law:
		# endless is checked FIRST (VS-FEATURES:423 "unless Endless mode is
		# enabled") — the R9 re-pin (tests/test_endless.py, same commit as
		# this arm) source-pins this endless->reaper elif order, making the
		# precedence equal-or-stronger pinned than the retired verbatim row.
		elif game.reaper:
			pass # the hunted night: no win, no clear; the reaper is the end
		else:
			_end_run("win")
			return
	if game.pending_levels > 0:
		_enter_levelup()


# §A.1 cycle clear: phase stays "playing", the clock keeps running (no new
# clock), the reward card rides the FROZEN pending_levels -> _enter_levelup
# seam (same step below), and the clear's drop rides the world's single drop
# funnel (tier dawn per §B.1's map). best_cycle is updated HERE and in
# _end_run only, through the ONE _meta_changed funnel (§A.3). The drop is
# the existing world funnel — no drop-kind UI or phase ever appears in this
# file (the test_chests_evolve phase-enum pin stays green by construction).
func _cycle_clear() -> void:
	game.pending_levels += 1
	world.cycle_clear(game)
	if game.cycle > _dawnwell.best_cycle:
		_dawnwell.best_cycle = game.cycle
	_meta_changed()


func _start_game() -> void:
	# vs-fix-11083: a score panel from a finished run is dead UI the moment a
	# new run starts — remove it here, the single run-start funnel (menu Enter
	# plus menu Start / Play again via start_pressed). _js_eval no-ops off-web;
	# the DOM guard no-ops when no panel exists (head_include absent).
	_js_eval("var vsPanel=document.getElementById('vs-submit'); if (vsPanel) vsPanel.remove();")
	world.reset()
	fx.clear_fx()
	# Hand the bought meta ranks to the ONE consumption seam (roadmap M1 f2:
	# ranks are consumed at start_run; the duplicate keeps run state from
	# aliasing the live shop dictionary).
	# The roster selection hand-in (M5 §2.1/F-5, T-M5c): the well's char row
	# rides in as the meta_ranks INPUT pattern — BEFORE start_run, because
	# the rule table is CONSUMED inside start_run (the §2.1b literal tail
	# placement cannot feed that consumption; declared reading in the card
	# capture + LEDGER row). int() lands the JSON-float disk row (save.gd
	# law); an unset/older save reads 0 = row 0 = every committed byte
	# unchanged (B-E1). The pawn re-derive rides the hand-in TAIL below.
	# (PLACED ABOVE the meta_ranks line: the test_dawnwell_shop:153-155
	# wiring pin demands meta_ranks -> start_run adjacency — a STAY probe.)
	game.char_sel = int(_dawnwell.char)
	game.meta_ranks = _dawnwell.ranks.duplicate()
	game.start_run()
	# The endless hand-in (F-4, meta_ranks pattern): the ONE _dawnwell ->
	# start seam, AFTER start_run (which resets the run-mode vars, §A.2).
	# No flag row = endless false = every M1 byte unchanged.
	game.endless = int(_dawnwell.flags.get("endless", 0)) == 1
	# The reaper hand-in (M4 §2.1, T-M4r): the SAME _dawnwell -> start seam,
	# the endless pattern verbatim — a hidden well flag (no UI row, F-7),
	# AFTER start_run (which reset it). No flag row = false = every
	# committed byte unchanged (B-E1).
	game.reaper = int(_dawnwell.flags.get("reaper", 0)) == 1
	# The stage hand-in (M3 §1.1, T-M3s): the SAME _dawnwell -> start seam,
	# the endless pattern — AFTER start_run (which resets stage to the
	# stage-1 id). An unset/older save reads index 1 = "moor-vigil", so
	# every committed dump is the stage-1 default case (F-4). The stage's
	# props seed right after the hand-in (static rows, ZERO RNG — A-E3).
	game.stage = GameRenderer.stage_id_for_index(_dawnwell.stage)
	world.seed_stage_props(game)
	# The skin hand-in (M5 §3.1, T-M5k, MC 11423): the SAME _dawnwell ->
	# start seam (the reaper/stage pattern) — AFTER start_run (which
	# resets skin_id), BEFORE the pawn re-derive below (the §2.1b literal
	# order lands verbatim for this row: a skin feeds NO start_run
	# consumption, so it needs no char_sel input twin). int() lands the
	# JSON-float disk row (save.gd law); unset/older reads 0 = the
	# default look = the shipped mesh (K-E1 byte law).
	game.skin_id = int(_dawnwell.skin)
	# M5 §2.1b (T-M5c, MC 11422): the pawn receives the selection at the
	# hand-in TAIL, the mesh re-read LAST (the P1-1 fix: the pawn was the
	# boot-once body that never saw a selection). apply_selection() IS the
	# _ready body moved verbatim (mesh + material re-derive, duplicate-first
	# PLAYER_TINT law); boot still calls it once through _ready — the
	# pawn is instantiated EXACTLY once at :89-91 (boot-once invariant
	# preserved), this re-skims the SAME node. char_id is already the
	# consumed row (start_run above); zero RNG, zero state mutation.
	_pawn.apply_selection()
	_current_offer = []
	_screens.hide_all()


func _enter_levelup() -> void:
	game.set_phase("levelup")
	_current_offer = _next_offer()
	_screens.show_levelup(_current_offer)


# The ONE offer funnel of the levelup seam. A queued tier reward kind (the
# §B.1 grant FIFO, game_state.reward_kinds) shapes the next offer through
# the SAME make_offer seam; "" is the untouched pool (every pre-tier byte,
# the shuffle RNG consumption included, is unchanged). The pop never moves
# pending_levels — the frozen phase/drain seam is exactly as shipped.
func _next_offer() -> Array:
	var kind: String = ""
	if not game.reward_kinds.is_empty():
		kind = game.reward_kinds.pop_front()
	return LevelUpDeck.make_offer(game, kind)


func _pick(index: int) -> void:
	if game.phase != "levelup" or index < 0 or index >= _current_offer.size():
		return
	LevelUpDeck.apply_offer(game, _current_offer[index])
	game.pending_levels -= 1
	if game.pending_levels > 0:
		_current_offer = _next_offer()
		_screens.show_levelup(_current_offer)
		return
	_current_offer = []
	_screens.hide_all()
	game.set_phase("playing")


func _end_run(result: String) -> void:
	game.end_run(result)
	# Dawn Well gold income (T-M1f): the run's gold cashes out into the well
	# 1:1 at EVERY run end — death AND win (the gap-table row "gold dies
	# with the run" is what M1 feature 2 closes; conversion declared in the
	# card capture) — and the ONE funnel persists it.
	# §A.3 best_cycle: max-update at EVERY run end (gameover included) and
	# at every cycle clear (_cycle_clear); NEVER decreases (A-E5). Flag-off
	# runs sit at cycle 0, so their best_cycle write is the field default —
	# the field-by-field save migration keeps older files at 0 (§A.3).
	if game.cycle > _dawnwell.best_cycle:
		_dawnwell.best_cycle = game.cycle
	# M5 §1.1 counter store + achievement flags (T-M5p): the ONE run-end
	# update site, landing FORCED above the gold cash-out (the shipped
	# gold->funnel adjacency pin allows whitespace only between the two
	# lines — the block may never land there; P2-1) and beside the
	# best_cycle max-rule write above. Pure int math over stats / weapons
	# / cycle / the well (zero RNG, no sim touch); Σ-add + max-rule rows
	# ride well.counters, achievement flags ride the SAME flags dict as
	# achv:<id> (F-4, SET-only, death never unsets). This block calls
	# neither save() nor the funnel below — the ONE persisting call under
	# the gold line covers it with the cash-out (P-E3 PIN-HOLD).
	Achievements.update(_dawnwell, game, world)
	# M3 §1.1/§2 unlock chain (T-M3s): riding the EXISTING flags dict — a
	# run of stage S at level >= the next row's unlock_level SETS that row's
	# flag (SET only; death never unset anything, the flag dict is write-1
	# law). ONE funnel below persists it — this adds NO second _meta_changed
	# call site (A-E5's red instrument: funnel call count per end stays 1).
	var next_stage: Dictionary = GameRenderer.stage_unlock_after(game.stage)
	if not next_stage.is_empty() and game.level >= int(next_stage.unlock_level):
		_dawnwell.flags[String(next_stage.unlock_flag)] = 1
	_dawnwell.gold += game.stats.gold
	_meta_changed()
	# M4 §2.1 END SCREEN (T-M4r, no new surface): with a reaper having been
	# LIVE this run (the flag handed in AND the world-side arrival latch
	# fired) the panel PREPENDS ONE line — the same panel, the same
	# show_end(win=false, lines) call, the five shipped rows verbatim after
	# it, the score/time/level/gold rows and the leaderboard JS payload
	# unchanged. Stats read time > 900 naturally: "stage complete, then
	# hunted" is what the numbers say.
	var end_lines: Array = [
		"Survived " + _fmt_time(game.stats.time),
		"Kills %d" % game.stats.kills,
		"Level %d" % game.stats.level,
		"Gold %d" % game.stats.gold,
		"Score %d" % _score(game.stats),
	]
	if game.reaper and world.reaper_spawned > 0:
		end_lines.push_front("The Reaper took you at %s"
				% _fmt_time(game.stats.time))
	_screens.show_end(result == "win", end_lines)
	# The JS-side existence check keeps this a no-op even when the bridge is
	# active but the DOM submit panel was never installed (head_include absent).
	_js_eval("if (window.vsShowSubmit) vsShowSubmit(" + JSON.stringify({
		"score": _score(game.stats),
		"time_survived": roundf(game.stats.time * 10.0) / 10.0,
		"kills": game.stats.kills,
		"level": game.stats.level,
	}) + ")")


func _score(stats: Dictionary) -> int:
	return roundi(stats.time * 10.0 + stats.kills * 5.0 + stats.level * 25.0 + stats.gold)


func _fmt_time(t: float) -> String:
	var s := int(maxf(0.0, floor(t)))
	return "%02d:%02d" % [int(s / 60.0), s % 60]


# Save-on-meta-change funnel (MC 11205): the ONE place meta state is
# persisted. The Dawn Well shop (T-M1f) mutates _dawnwell (gold / ranks /
# flags) through the verbs below and calls this after EVERY mutation —
# save() writes the whole save atomically (temp file + rename), and
# delete-while-running is UNDEFINED BY DESIGN: the in-memory state
# re-creates the file at the next call (PARITY-ROADMAP M1 feature 1).
func _meta_changed() -> void:
	_dawnwell.save()


# --- Dawn Well shop verbs (T-M1f) --------------------------------------------
# The rules live in PowerUps (the ONE table); these are thin mutators over
# the loaded save + the funnel. A no-op mutation (unaffordable, maxed, or an
# empty refund) does NOT write: the funnel fires only on real change, and
# refresh_shop() re-reads state either way so a disabled button re-labels
# itself after every click.

func _open_shop() -> void:
	_screens.show_shop(_dawnwell)


func _shop_buy(id: String) -> void:
	if PowerUps.buy(_dawnwell, id):
		_meta_changed()
	_screens.refresh_shop()


func _shop_refund(id: String) -> void:
	if PowerUps.refund(_dawnwell, id) > 0:
		_meta_changed()
	_screens.refresh_shop()


func _shop_refund_all() -> void:
	if PowerUps.refund_all(_dawnwell) > 0:
		_meta_changed()
	_screens.refresh_shop()


# --- Stage select verbs (M3 §2, T-M3s) ----------------------------------------
# Same contract as the shop verbs: the panel only displays the well +
# emits the verb; main owns the mutation + the ONE funnel. A locked choice
# cannot happen through the UI (its Select is DISABLED — S7 disable-not-
# hide precedent), but the verb re-checks the chain so a stale panel click
# can never chain-unlock (§2). A no-op selection does NOT write (shop
# precedent: the funnel fires only on real change).

func _open_stages() -> void:
	_screens.show_stages(_dawnwell)


func _stage_chosen(stage_id: String) -> void:
	var idx := GameRenderer.stage_index_for(stage_id)
	if idx == 1 or int(_dawnwell.flags.get(
			String(GameRenderer.stage_row(stage_id).unlock_flag), 0)) == 1:
		if _dawnwell.stage != idx:
			_dawnwell.stage = idx
			_meta_changed()
	_screens.refresh_stages()


# --- Achievements verbs (M5 §1.1, T-M5p) ---------------------------------------
# The same panel contract WITHOUT the writes: the page is display-only
# (spec §1.1 — no verb writes here), so these are pure routing wrappers,
# zero meta mutation and zero persisting calls (the P-E3 whole-scripts
# grep pin counts the shipped funnel sites, this card adds none).

func _open_achievements() -> void:
	_screens.show_achievements(_dawnwell)


func _close_achievements() -> void:
	_screens.close_achievements()


# --- Roster select verbs (M5 §2.1/§2.2, T-M5c, MC 11422) ---------------------
# The shop/stage verb contract verbatim: the panel displays and emits, main
# mutates _dawnwell and persists through the ONE meta funnel, then refreshes
# (the P-E3 whole-scripts save pin holds — these verbs carry ZERO direct
# disk-write sites; the funnel occurrence set grows by exactly these two
# call SITES, the re-pin lives in test_achievements.py same-commit). The
# NO-OP-NO-WRITE law (B-E5): a refused buy/select never enters the funnel,
# so nothing reaches disk (the disk legs in sim_chars.gd read the file back).
# Comment-wording note: this block spells no counter literals on purpose —
# it sits inside the _close_achievements block the P-E5 display-only law
# extracts, and verb text must stay free of the counted strings.

func _open_characters() -> void:
	_screens.show_characters(_dawnwell)


func _char_buy(char_id: String) -> void:
	if Roster.buy(_dawnwell, Roster.index_of(char_id)):
		_meta_changed()
	_screens.refresh_characters()


func _char_select(char_id: String) -> void:
	var idx := Roster.index_of(char_id)
	# The _stage_chosen stale-panel law (A-E8): the verb RE-CHECKS the rule,
	# never trusts the rendered button; an out-of-table id (idx < 0) is the
	# same refusal arm. A re-select of the already-chosen row writes
	# nothing (the _dawnwell.stage != idx guard pattern — B-E5's no-op leg
	# byte-compares the disk before/after exactly this call).
	if idx >= 0 and Roster.is_owned(_dawnwell, idx) and _dawnwell.char != idx:
		_dawnwell.char = idx
		_meta_changed()
	_screens.refresh_characters()


# The skin verbs (M5 §2.2 named + §3.1, T-M5k, MC 11423): the SAME thin
# shape — the panel displays and emits, the Roster rule re-checks the
# whole law (owned + WEARABLE + real change — the stale-panel and the
# wear law ride INSIDE skin_select, the Roster.buy shape; an unknown id
# reads -1 = refusal arm, the default chip maps to pos 0), the verb
# persists through the ONE funnel, then refreshes. NO disk-write site
# here (the B-E5 law restated; the funnel occurrence count re-pins in
# test_achievements.py same-commit, 9 -> 11 — the R-series serial).
func _char_buy_skin(skin_id: String) -> void:
	if Roster.skin_buy(_dawnwell, Roster.skin_pos_of_id(skin_id)):
		_meta_changed()
	_screens.refresh_characters()


func _char_select_skin(skin_id: String) -> void:
	if Roster.skin_select(_dawnwell, Roster.skin_pos_of_id(skin_id)):
		_meta_changed()
	_screens.refresh_characters()
