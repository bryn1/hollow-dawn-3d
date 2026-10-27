# MC 11423 T-M5k — SKINS behavioral probe (M5-SPEC §3, K-E4: "the probe
# verbs, the shop law shape"). Same LEG-row convention as shop_probe.gd /
# save_probe.gd: headless SceneTree run under a throwaway XDG_DATA_HOME
# (the pytest leg points user:// at /tmp), machine-readable `LEG <name>
# k=v` rows, one `JSON <text>` disk row where a leg saves. The Roster
# skin rules are driven for REAL (buy/spend/flag/select/no-op), the disk
# is read back, and the pawn legs ride SimFunnel.fresh_run (the REAL
# Main.tscn + the real _start_game hand-in — "the pawn the SIM actually
# shows", the B-E7 instrument shape). NO wall-clock/timing rows: the
# output is byte-deterministic at seed 11423 (the card-id seed law, twice-
# cmp proven in the capture). Legs:
#   table        K-E5 shape at runtime: 5 rows, the price curve, the group
#                law (row 0 non-empty, every other row empty), the id->pos
#                map incl. the default row 0.
#   buy          K-E4: buying all five on a funded well writes the five
#                `skin:<id>` flags and spends EXACTLY the table prices
#                through the ONE rule surface; disk reload reads it back.
#   poor         K-E4 no-op side: unaffordable buys refuse, NO write.
#   twice        K-E4: a skin already owned is never bought twice (buy-
#                once, refund never — the shop law restated).
#   wear         K-E4 BOTH sides of the wear law: selecting a skin the
#                SELECTED char can wear writes the `skin` well row (disk
#                roundtrip); selecting one its group does NOT carry (the
#                empty-group chars) is a NO-OP — no row, no gold move.
#                The planted "wear-check bypass" red lands HERE.
#   reselect     re-selecting the worn row (and the default) writes
#                nothing — the disk file is BYTE-IDENTICAL across the call.
#   states       the chip four-state rows through Roster.skin_state (the
#                Roster.state twin for the chip family): fresh/funded/
#                owned wells on the vigil + an empty-group char.
#   pawns        K-E1/K-E2 live seam truth: skin 0 (unset) shows the
#                shipped player.glb mesh OBJECT (the cache-identity row-0
#                twin — the plant "the seam reads skin 1 by default" goes
#                RED here while B-E1's byte corpora stay GREEN, the
#                independent-attribution pair); pos 1-5 show the skin's
#                OWN mesh at the ONE ClassMesh seam; an unwearable pos on
#                a no-skins char falls back to that char's own mesh (the
#                RENDER side of the wear law — stale/garbage rows never
#                paint another char's skin). Every pawn carries a FRESH
#                material duplicate with the UNSHADED + PLAYER_TINT law.
#   migrate      the R1 migration-default leg: a save WITHOUT the `skin`
#                field loads skin 0 (no quarantine — the best_cycle/
#                stage/char proof restated, the version stays 1).
extends SceneTree

const SAVE := "user://dawnwell.json"
const CORRUPT := "user://dawnwell.corrupt.json"
const TEMP := "user://dawnwell.json.tmp"
const HERO := preload("res://scripts/hero_pawn.gd") # PLAYER_TINT read

var _pawn_queue: Array = [] # legs run across frames (fresh_run needs a
#   LIVE tree — _ready runs on add_child inside an ACTIVE tree, the
#   sim_chars stepping pattern; a synchronous _initialize call sees a Nil
#   _dawnwell)
var _frame := 0


func _initialize() -> void:
	seed(11423) # the card-id seed law (M3/M4/M5 sim convention)
	_leg_table()
	_leg_buy()
	_leg_poor()
	_leg_twice()
	_leg_wear()
	_leg_reselect()
	_leg_states()
	_leg_migrate() # runs synchronously (pure DawnWell, no tree)
	_leg_pawns() # queues the live-pawn legs; _process drains them
	# (PROBE_DONE + quit move to the drain — the tree legs cannot run here)


# SceneTree's own _process (signature: (float) -> bool, true = keep
# running — the sim-donor stepping shape, NOT a Node's _process).
func _process(_delta: float) -> bool:
	# THE SceneTree contract (art_probe's comment, re-learned the hard
	# way): the returned bool is the QUIT flag — true ENDS the loop.
	_frame += 1
	if _pawn_queue.is_empty():
		print("PROBE_DONE")
		quit(0)
		return true
	if _frame % 2 == 0: # one fresh_run per two frames (donor cadence)
		var leg: Array = _pawn_queue.pop_front()
		_pawn_leg(leg[0], leg[1], leg[2], leg[3])
	return false


func _wipe() -> void:
	var dir := DirAccess.open("user://")
	if dir == null:
		return
	for p in [SAVE, CORRUPT, TEMP]:
		var q: String = p.trim_prefix("user://")
		if dir.file_exists(q):
			dir.remove(q)


func _exists(p: String) -> bool:
	var dir := DirAccess.open("user://")
	return dir != null and dir.file_exists(p.trim_prefix("user://"))


func _read(p: String) -> String:
	var f := FileAccess.open(p, FileAccess.READ)
	if f == null:
		return ""
	var t := f.get_as_text()
	f.close()
	return t


func _fresh(gold: int) -> DawnWell:
	_wipe()
	var w: DawnWell = DawnWell.load_save()
	w.gold = gold
	return w


# K-E5 runtime shape: the table, the curve, the group law, the id map.
func _leg_table() -> void:
	var prices := [200, 400, 600, 800, 1000]
	var prices_ok := Roster.SKINS.size() == 5
	for i in Roster.SKINS.size():
		prices_ok = prices_ok and int(Roster.SKINS[i].cost) == prices[i]
	var group_ok := Roster.skins_for(0).size() == 5
	for c in range(1, Roster.CHARACTERS.size()):
		group_ok = group_ok and Roster.skins_for(c).is_empty()
	# the id->pos map: table order + 1; "default" is the pos-0 row.
	var map_ok := Roster.skin_pos_of_id("default") == 0
	for i in Roster.SKINS.size():
		map_ok = map_ok and Roster.skin_pos_of_id(
			String(Roster.SKINS[i].id)) == i + 1
	print("LEG table rows=%d prices_ok=%d group_ok=%d map_ok=%d unknown=%d" % [
		Roster.SKINS.size(), int(prices_ok), int(group_ok), int(map_ok),
		int(Roster.skin_pos_of_id("skin-nope"))])


# K-E4: the full purchase arc through the ONE rule surface + disk truth.
func _leg_buy() -> void:
	var w := _fresh(3000)
	var ok_count := 0
	for pos in range(1, Roster.SKINS.size() + 1):
		if Roster.skin_buy(w, pos):
			ok_count += 1
	var flags := 0
	for s in Roster.SKINS:
		if w.flags.has(Roster.SKIN_PREFIX + String(s.id)):
			flags += 1
	var save_ok := w.save()
	print("JSON " + _read(SAVE))
	var r := DawnWell.load_save()
	var rflags := 0
	for s in Roster.SKINS:
		if r.flags.has(Roster.SKIN_PREFIX + String(s.id)):
			rflags += 1
	print(("LEG buy ok=%d spent=%d expected=%d flags=%d gold=%d "
			+ "reload_flags=%d reload_gold=%d saved=%d skin_zero=%d") % [
		ok_count, 3000 - w.gold, 200 + 400 + 600 + 800 + 1000, flags, w.gold,
		rflags, r.gold, int(save_ok), int(int(r.skin) == 0)])


# K-E4 no-op side (the shop's poor leg): refuse, no flag, gold intact.
func _leg_poor() -> void:
	var w := _fresh(199)
	var ok := Roster.skin_buy(w, 1) # costs 200
	print("LEG poor ok=%d flag_absent=%d gold=%d pos_bad=%d" % [
		int(ok), int(not w.flags.has("skin:skin-ash")), w.gold,
		int(not Roster.skin_buy(w, 99))])


# K-E4 buy-once: the second buy of an owned skin is refused (refund never).
func _leg_twice() -> void:
	var w := _fresh(3000)
	var first := Roster.skin_buy(w, 1)
	var second := Roster.skin_buy(w, 1)
	print("LEG twice first=%d second=%d paid=%d expected=%d" % [
		int(first), int(second), 3000 - w.gold, 200])


# K-E4 wear law BOTH sides: the vigil wears (row + disk written), the
# empty-group char does NOT (no-op). Selecting the default (pos 0) is
# always legal for an owner of nothing — it is the char's own look.
func _leg_wear() -> void:
	var w := _fresh(3000)
	Roster.skin_buy(w, 1)
	var sel := Roster.skin_select(w, 1)
	var disk := w.save()
	var skin_disk := int(DawnWell.load_save().skin)
	# the same well, the GRAVE-WARD selected: the id is owned but NOT in
	# row 2's group -> NO-OP (the K-E4 planted-red seat).
	w.char = 2
	var no_wear := Roster.skin_select(w, 1)
	# the K-E4 planted-red seat, DEEP: buy pos 2 (morrow) on the vigil,
	# then select pos 2 on char 2 (an empty-group char) WHILE pos 1 is
	# worn. A wear-guard bypass slips past the re-select guard here
	# (pos 2 != worn pos 1) and WRITES an unwearable row — the exact bug.
	Roster.skin_buy(w, 2)
	var deep_wear := Roster.skin_select(w, 2)
	var gold_held := w.gold
	var skin_held := int(w.skin) # read BEFORE the next select (a print-time
	#   read would observe the back-call's write — leg-order honesty)
	var back := Roster.skin_select(w, 0) # default: always wearable
	print(("LEG wear select=%d skin_disk=%d saved=%d no_wear=%d skin_held=%d "
			+ "gold_held=%d default_select=%d skin_now=%d deep_wear=%d "
			+ "deep_skin=%d") % [
		int(sel), skin_disk, int(disk), int(no_wear), int(skin_held == 1),
		int(gold_held == 2400), int(back), int(int(w.skin) == 0),
		int(deep_wear), int(skin_held == 1)])


# K-E4 re-select no-op: disk BYTE-IDENTICAL across the refused call (the
# _dawnwell.stage != idx guard pattern restated for the skin row).
func _leg_reselect() -> void:
	var w := _fresh(3000)
	Roster.skin_buy(w, 1)
	Roster.skin_select(w, 1)
	w.save()
	var before := _read(SAVE)
	var refused := Roster.skin_select(w, 1)
	print("LEG reselect refused=%d disk_same=%d" % [
		int(not refused), int(_read(SAVE) == before)])


# chip state rows (Roster.skin_state — the Roster.state twin, one source
# for panel + sim): fresh / funded / owned wells on the vigil; an
# empty-group char reads UNWEARABLE for every table entry.
func _leg_states() -> void:
	var fresh := _fresh(0)
	var s := ""
	for pos in range(0, 6):
		s += "%s:%s;" % [pos, Roster.skin_state(fresh, 0, pos)]
	var funded := _fresh(3000)
	var s2 := ""
	for pos in range(0, 6):
		s2 += "%s:%s;" % [pos, Roster.skin_state(funded, 0, pos)]
	Roster.skin_buy(funded, 1)
	var s3 := "%d:%s;%d:%s" % [1, Roster.skin_state(funded, 0, 1),
		2, Roster.skin_state(funded, 0, 2)]
	Roster.skin_select(funded, 1)
	var s4 := "%d:%s;%d:%s" % [0, Roster.skin_state(funded, 0, 0),
		1, Roster.skin_state(funded, 0, 1)]
	funded.char = 3 # the COINHOUND: owned flag, EMPTY group
	var s5 := "%d:%s" % [1, Roster.skin_state(funded, 3, 1)]
	print(("LEG states fresh=[%s] funded=[%s] owned1=[%s] worn1=[%s] "
			+ "nogroup_char=[%s]") % [s, s2, s3, s4, s5])


# K-E1/K-E2 live pawn legs at the ONE seam (SimFunnel.fresh_run — the
# real _start_game hand-in + apply_selection tail; the `skin` opts key is
# the DECLARED growth, the char/stage pattern). Every check compares the
# LIVE mesh OBJECT against the ONE loader's cached return (identity, not
# a byte compare — the B-E7 shape) + the fresh-duplicate material law.
func _leg_pawns() -> void:
	_pawn_queue.append([0, 0, "player.glb", "pawn_default"]) # row-0 twin
	for pos in range(1, Roster.SKINS.size() + 1):
		_pawn_queue.append([0, pos, String(Roster.SKINS[pos - 1].mesh),
			"pawn_vigil_%d" % pos])
	_pawn_queue.append([2, 1, String(Roster.row(2).mesh), "pawn_nowear"])


func _pawn_leg(char: int, skin: int, want_glb: String, leg: String) -> void:
	var opts := {"wipe_well": true, "char": char}
	if skin > 0:
		opts["skin"] = skin
	var run := SimFunnel.fresh_run(root, opts)
	var pawn: MeshInstance3D = run._pawn
	var want := ClassMesh.mesh_for(want_glb, HordeViz.MODEL_H_PLAYER)
	var mat: StandardMaterial3D = pawn.material_override
	var src := want.surface_get_material(0) as StandardMaterial3D
	print(("LEG %s glb=%s char=%d skin=%d mesh_identity=%d fresh_dup=%d "
			+ "unshaded=%d tint=%d") % [
		leg, want_glb, char, skin,
		int(pawn.mesh == want),
		int(src == null or mat != src),
		int(mat.shading_mode == BaseMaterial3D.SHADING_MODE_UNSHADED),
		int(mat.albedo_color == HERO.PLAYER_TINT)])
	run.queue_free()
	# a run in the tree keeps consuming frames between legs; free is enough
	# (fresh_run adds to root, the sim siblings' pattern — legs are t=0
	# reads, no stepping)


# R1 migration-default leg: an OLDER save (no `skin` key) loads skin 0,
# NOT quarantined; the field rides, the version does not bump.
func _leg_migrate() -> void:
	_wipe()
	var dir := DirAccess.open("user://")
	var f := FileAccess.open(SAVE, FileAccess.WRITE)
	f.store_string('{"version": 1, "gold": 5, "ranks": {}, "flags": {}, '
		+ '"best_cycle": 0, "stage": 1, "counters": {}, "char": 2}')
	f.close()
	var w := DawnWell.load_save()
	print(("LEG migrate skin_default=%d char_kept=%d gold_kept=%d "
			+ "not_quarantined=%d") % [
		int(int(w.skin) == 0), int(int(w.char) == 2), int(w.gold == 5),
		int(not _exists(CORRUPT))])
	dir.remove(SAVE.trim_prefix("user://"))
