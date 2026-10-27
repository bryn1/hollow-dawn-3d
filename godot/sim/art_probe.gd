# Headless art-integration probe (T-S2i, MC 11133): instantiates the REAL
# Main.tscn (same funnel as sim_headless), then dumps the rows this card's
# gates read — (1) per-class MEASURED live height: the aabb height of the
# very ArrayMesh each class MultiMesh renders (the gait writes scale
# channels x/z only, vertical stays 1.0, so mesh aabb = live instance
# height); (2) the §b draw tally at a 400-enemy sim — 400 alive through the
# real _spawn_enemy funnel, refresh() forced, tally ground + horde MMs +
# pawn + FX worst case (planned 40 / hard cap 60 — plan raised 33 -> 40 by
# the M1 budget re-tally, PARITY-ROADMAP §2, T-M1g MC 11211); (3) the player's own
# live-height row (T-S2p, MC 11135: the GLB pawn mesh — the same
# measured-aabb reading as the class rows); (4) the eight ROSTER mesh rows
# at the same seam (M5 §2.3, T-M5c MC 11422 — R2 forward-growth, the 18
# existing rows byte-preserved as the prefix). One JSON
# line per row; the committed copy lives at
# tests/fixtures/art-s2i-probe.json for test_art_integration.py.
extends SceneTree

const ALIVE_TARGET := 400 # brief §5: draw dump at a 400-enemy sim
const DRAWS_PLANNED := 40 # §b planned worst case (M1 re-tally: 33 + 2
#   miniboss class MMs + zone/chest FX reserve, roadmap §2 T-M1g; note kept in the rows)
const DRAWS_HARD := 60 # §b hard cap
const OUT_ENV := "HD3D_ART_DUMP"
const SWARMERS := ["wraith", "hound", "crawler", "cultist", "moor-brute",
	"dune-scarab", "rime-ghoul", "pale-wight"] # round-robin cast (warden rides the boss rows)

var _main: Node
var _rows: Array = []
var _started := false
var _frames := 0


func _out_path() -> String:
	return SimFunnel.out_path(OUT_ENV, "/tmp/hd3d-art-s2i-dump.jsonl")


# Same SceneTree-script contract as sim_headless: real work runs on the
# FIRST PROCESSED FRAME (nodes added in _initialize never get a _ready),
# and quit() fires only from _process.
func _process(_delta: float) -> bool:
	_frames += 1
	if not _started:
		_started = true
		print("ARTPROBE_START")
		_run()
	if _frames > 3:
		push_error("art probe did not finish in one frame")
		quit(3)
		return true
	return false


func _run() -> void:
	var packed: PackedScene = load("res://Main.tscn")
	_main = packed.instantiate()
	root.add_child(_main)
	var old: CanvasLayer = _main._screens
	_main.remove_child(old)
	old.queue_free()
	var stub := SimStubScreens.new()
	_main.add_child(stub)
	_main._screens = stub
	stub.start_pressed.connect(_main._start_game)
	stub.card_picked.connect(_main._pick)
	_main._start_game()
	_dump_heights()
	_dump_400()
	_dump_player()
	_dump_roster() # M5 T-M5c: R2 forward-growth (+8 char rows, §2.3)
	_dump_skins() # M5 T-M5k: R2 FIFTH growth (+5 skin rows, §3.3 K-E2)
	var f := FileAccess.open(_out_path(), FileAccess.WRITE)
	assert(f != null)
	for r in _rows:
		f.store_line(JSON.stringify(r))
	f.close()
	print("ARTPROBE_OK rows=%d out=%s" % [_rows.size(), _out_path()])
	quit()


func _dump_heights() -> void:
	for key in HordeViz.GLB_FILES:
		var mmim: MultiMeshInstance3D = _main._viz._mms[key]
		var mesh: Mesh = mmim.multimesh.mesh
		# T-M3b (MC 11284): the boss row rides the ENEMY_TYPES boss FLAG, not
		# the one "warden" literal — the warden row's bytes are unchanged (the
		# flag lookup yields the SAME MODEL_H_BOSS); the new classes join at
		# the boss height law (§3.1, replace-not-retire of the literal arm).
		var target: float = HordeViz.MODEL_H_BOSS \
			if GameWorld.ENEMY_TYPES[key].get("boss", false) \
			else HordeViz.MODEL_H_ENEMY
		var measured: float = mesh.get_aabb().size.y
		_rows.append({"ev": "height", "class": key,
			"glb": HordeViz.GLB_FILES[key], "mesh": mesh.get_class(),
			"target_m": target, "measured_m": snappedf(measured, 0.0001),
			"rel_err": snappedf(absf(measured - target) / target, 0.0001)})


func _dump_400() -> void:
	var keys := SWARMERS.size()
	for i in range(ALIVE_TARGET):
		_main.world._spawn_enemy(SWARMERS[i % keys], _main.game,
			GameRenderer.VIEW)
	_main._viz.refresh()
	var horde: int = _main._viz.draw_count()
	var fxw: int = _main._fxv.draw_count()
	var total := 1 + horde + 1 + fxw
	_rows.append({"ev": "draws", "alive": _main.world.enemies.size(),
		"ground": 1, "horde": horde, "pawn": 1, "fx_worst": fxw,
		"total": total, "planned": DRAWS_PLANNED, "hard_cap": DRAWS_HARD,
		"ok": total <= DRAWS_HARD})


func _dump_player() -> void:
	# T-S2p: the player row joins the MEASURED height table — the aabb of
	# the very ArrayMesh the pawn renders (hero_pawn._player_mesh() seam).
	var pawn: MeshInstance3D = _main._pawn
	var mesh: Mesh = pawn.mesh
	var measured: float = mesh.get_aabb().size.y
	_rows.append({"ev": "height", "class": "player", "glb": "player.glb",
		"mesh": mesh.get_class(), "target_m": HordeViz.MODEL_H_PLAYER,
		"measured_m": snappedf(measured, 0.0001),
		"rel_err": snappedf(absf(measured - HordeViz.MODEL_H_PLAYER)
			/ HordeViz.MODEL_H_PLAYER, 0.0001)})


func _dump_roster() -> void:
	# M5 §2.3 (T-M5c, MC 11422): the eight NEW roster meshes join the same
	# measured-height table at the ONE ClassMesh seam, at the PLAYER-class
	# row (1.67 m) — the same measured-aabb reading as every other row, no
	# second loader, no per-row height special case (B-E7). R2 forward-lock
	# growth: the 18 existing rows stay byte-preserved as the prefix, the
	# new rows append (row 0 the-vigil is the PLAYER row above — measured
	# off the LIVE pawn, no twin). tests/fixtures/art-s2i-probe.jsonl is
	# re-minted after the T-M5s asset commit lands (this row set IS that
	# gate); test_art_integration.py's additions list carries the ids.
	for row in Roster.CHARACTERS:
		if String(row.mesh) == "player.glb":
			continue # the player row already measures it
		var mesh: Mesh = ClassMesh.mesh_for(String(row.mesh),
			HordeViz.MODEL_H_PLAYER)
		var measured: float = mesh.get_aabb().size.y
		_rows.append({"ev": "height", "class": String(row.id),
			"glb": String(row.mesh), "mesh": mesh.get_class(),
			"target_m": HordeViz.MODEL_H_PLAYER,
			"measured_m": snappedf(measured, 0.0001),
			"rel_err": snappedf(absf(measured - HordeViz.MODEL_H_PLAYER)
				/ HordeViz.MODEL_H_PLAYER, 0.0001)})


func _dump_skins() -> void:
	# M5 §3.3 K-E2 (T-M5k, MC 11423): the five SKINS meshes join the SAME
	# measured-height table at the ONE ClassMesh seam at the PLAYER row —
	# the R2 FIFTH forward-lock growth (13->15->17->18->26->31 measured
	# through T-M3b/T-M4e/T-M4r/T-M5c/T-M5k): the 26 prior rows stay
	# byte-preserved as the prefix (the PLAYER row among them — the K-E1
	# art clause: the default look never measured a skin), the five new
	# rows append. NO pawn read here: this measures the meshes the seam
	# CAN hand out (the skin mesh is the same loader + same height law
	# the char rows ride), the LIVE skin read rides the probe's pawn legs.
	for srow in Roster.SKINS:
		var mesh: Mesh = ClassMesh.mesh_for(String(srow.mesh),
			HordeViz.MODEL_H_PLAYER)
		var measured: float = mesh.get_aabb().size.y
		_rows.append({"ev": "height", "class": String(srow.id),
			"glb": String(srow.mesh), "mesh": mesh.get_class(),
			"target_m": HordeViz.MODEL_H_PLAYER,
			"measured_m": snappedf(measured, 0.0001),
			"rel_err": snappedf(absf(measured - HordeViz.MODEL_H_PLAYER)
				/ HordeViz.MODEL_H_PLAYER, 0.0001)})
