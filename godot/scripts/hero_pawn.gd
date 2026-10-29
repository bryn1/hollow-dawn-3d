# The survivor's pawn (§f hero_pawn.gd). T-S2p (MC 11135) swapped the S3
# §a-size capsule placeholder for the player GLB (player.glb, MC 11132)
# at the ONE _player_mesh() seam: ClassMesh height-normalises it to the
# §a row 1.67 m (v1 player 40 px / S) exactly like every horde class, ONE
# draw kept. WASD motion comes through the verbatim main.gd loop (BASE_SPEED
# px/s ÷ S = m/s). Iframes paint v1's rule as data (render.gd:134-138: a
# constant alpha 0.55 while iframes > 0 — cycle-3 wording, no pulse): the
# alpha now rides a PRIVATE duplicate of the GLB's own material (§b
# multiplier convention, same as the horde tints), so the baked albedo
# texture stays visible and only its multiplier alpha dims. The skinned
# GLB + AnimationTree and the L5 player-alt swap ride in with the art
# stage (§c/§d rows).
# M6 F1 (T-M6r, MC 11676) — THE runtime animation consumer: the M5-SPEC
# clips finally PLAY. apply_selection() grows ONE visual child for every
# Roster.CLIP_SOURCE-rigged row (the imported GLB scene through
# ClassMesh.scene_for — skin intact, the import pass ships the
# AnimationPlayer; row 0's visual rides the promoted byte-identical
# player-rigged copy, §1.1), height-normalised at the ROOT-NODE SCALE and
# drawn INSTEAD of self (§b ONE draw kept, never both — the MV-E5 mutual-
# exclusion pin). _process plays "walk" at the stride-tied gait rate while
# the pawn moves and returns it to seek(0) at rest (the static-era frame);
# static rows (CLIP_SOURCE null, the six owner-"Rec" statue classes) take
# the §1.3 procedural bob+lean of the ONE HordeViz.gait_wave law. Byte
# law: the pos assignment below (:94-95 lineage) stays VERBATIM, the
# motion block never writes sim state — it only READS game.player.
extends MeshInstance3D

var game: GameState

var _mat: StandardMaterial3D

# The skinned-child state (M6 F1): the instantiated rig scene + its
# AnimationPlayer, null on the static arm. _prev carries the per-tick
# displacement READ of §1.1 (viz bookkeeping — never sim state).
var _rig: Node3D
var _anim: AnimationPlayer
var _walk_clip := ""
var _ghost: StandardMaterial3D
var _prev := Vector2(INF, INF)

# v1 parity of the READ: the 2D survivor drew UNSHADED (canvas texture x
# modulate, no lighting) in bone-pale over the dark ground. The GLB lands
# under the §b moonlight, and the baked robe texture is very dark (albedo
# luma mean 29 measured, vs the wraith's 66), so shaded + plain-BONE sinks
# the hero into the moor (the §b tint table exists for exactly this:
# "silhouettes separate from the dark background"). The pawn material
# therefore draws UNSHADED with v1's bone hue lifted above 1 (Godot
# multiplies albedo_color into the texture, no clamp) — the sprite-era
# full-brightness read carried onto the GLB. iframes-alpha unchanged.
# T-S10 (MC 11159, owner contrast ruling): the multiplier is lifted 2.6 ->
# 3.6 — the same unshaded-multiplier seam, re-tuned against the darkened
# (tone 0.62) ground so the hero/floor luma ratio clears the >= 2.0 gate.
const PLAYER_TINT := GameRenderer.BONE * 3.6

# §1.3 static-arm motion amplitudes (values OURS, the spec's stated
# reading; the ONE wave function + the frequency caps ride HordeViz — no
# second gait table). The rigged arm's mutual exclusion (MV-E5: child OR
# self, never both): the VERIFIED mechanics ruled out the popular tricks
# on the pinned binary — Camera3D.cull_mask defaults to ALL 20 visibility
# layers (measured 1048575, camera_rig.gd never narrows it, and it is not
# T-M6r's file to narrow), and Node3D.visible=false hides the child WITH
# the parent (3D visibility is inherited); mesh=null would starve the
# art probe's live pawn.mesh row AND sim_chars' mesh-identity pins. So
# self's surface is GHOSTED: a duplicate material at alpha 0 renders zero
# visible pixels (one visible draw = the child), while pawn.mesh stays
# the shipped ArrayMesh for every committed reader. The ghost never
# receives an iframes-alpha write — alpha law: ONE _mat rides the VISIBLE
# node (the child), exactly as the static arm's _mat rides self.
const PAWN_BOB_M := 0.06
const PAWN_LEAN_RAD := 0.06


# The §2.1b apply-step (M5 §2.1b, T-M5c, MC 11422 — the MC 11316 P1-1
# class fix): the ENTIRE _ready body moved here VERBATIM (mesh read + the
# material re-derive, duplicate-first law included; the mesh row is now
# char-guarded INSIDE _player_mesh(), the ONE seam). _ready() calls this
# unchanged — boot = row 0 = the shipped byte behaviour, the boot-once
# invariant holds (main instantiates the pawn exactly once, :89-91) — and
# main._start_game() calls it again at the F-7 hand-in tail so a mid-menu
# selection re-skins the SAME node in-session (B-E7's twin legs).
# M6 F1 grows the VISUAL child here, idempotently, AFTER the mesh +
# material block (kept verbatim — the art probe's live pawn.mesh row and
# the §b material law ride it unchanged).
func apply_selection() -> void:
	mesh = _player_mesh()
	# The iframes-alpha rule carried onto the GLB material (T-S2i seam
	# note): duplicate FIRST — the ClassMesh cache is shared, the imported
	# material is never mutated — then alpha transparency + the bone-pale
	# multiplier over the baked albedo texture.
	var src := mesh.surface_get_material(0) as StandardMaterial3D
	_mat = src.duplicate() if src != null else StandardMaterial3D.new()
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED # v1 2D read
	_mat.albedo_color = PLAYER_TINT # v1's bone-pale survivor read
	material_override = _mat
	_grow_visual()


func _ready() -> void:
	apply_selection()


# The ONE mesh-source seam: the player rides the same ClassMesh loader as
# the horde, height-normalised to the §a row (1.67 m). The live height of
# this very mesh is a table row in the committed probe dump
# (sim/art_probe.gd -> tests/fixtures/art-s2i-probe.jsonl), gated <= 10 %
# by test_art_integration.py.
# M5 §2.1 (T-M5c): the row read is char-guarded HERE, at this ONE seam —
# row 0 keeps the shipped literal call verbatim (byte law F-2 + the
# test_art_integration seam pin); rows 1-8 read the ROSTER mesh row at the
# SAME ClassMesh loader + SAME MODEL_H_PLAYER class height (B-E7: no new
# loader, no per-row height special-case). The skin read LANDED AT T-M5k
# (MC 11423, replace-not-delete of the rides-with note this line carried):
# ONE expression (Roster.skin_mesh) at this SAME seam — §3.1 "Applying a
# skin = the SAME _player_mesh() seam reading well.skin through the
# selected character's skin group". skin 0 / garbage / unwearable all
# read "" (the group clamp lives in roster.gd), so every branch below
# stands verbatim: the shipped default call is byte-untouched (K-E1/F-2)
# and an unwearable stale row shows the CHAR's own mesh, never another
# char's skin.
# M6 F1 (T-M6r, MC 11676, replace-not-delete of the three inline name
# branches): the file-name rule moves ONCE into _player_glb() — the ONE
# mesh-FILE seam the mesh read AND the §1.1 CLIP_SOURCE read both ride
# ("Applying a skin = the SAME seam" restated for the visual source: no
# second rule beside it). The row-0 literal "player.glb" stays EXACTLY
# here (MV-E4's seam-pin family, EXTENDED: Roster.CHARACTERS[0].mesh
# stays the literal for every non-visual consumer — the art fixture
# heights read this very mesh through this very seam).
func _player_mesh() -> Mesh:
	# The row-0 shipped call stays VERBATIM right here (the seam pin, T-S2p
	# / M5 §2.1b / M6 MV-E4 extended-family); every other name the ONE
	# _player_glb() rule produced rides the SAME loader line.
	if _player_glb() == "player.glb":
		return ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER)
	return ClassMesh.mesh_for(_player_glb(), HordeViz.MODEL_H_PLAYER)


# The ONE pawn mesh-FILE read (char-guarded; skin wins, then the roster
# row, then the shipped row-0 literal — the M5c/M5k law, relocated whole
# at T-M6r, semantics byte-equal: the seam pin EXTENDED per the M5 §2.1b
# precedent, the Roster.skin_mesh / literal-substring laws now ride this
# function as the ONE seam's name source). The CLIP_SOURCE key and the
# visual source BOTH read through here (§1.1's "the pawn's visual-source
# read rides the SAME CLIP_SOURCE map" — the ONE seam keeps the choice).
func _player_glb() -> String:
	var char := 0 if game == null else int(game.char_id)
	var skin := Roster.skin_mesh(char, 0 if game == null
		else int(game.skin_id))
	if skin != "":
		return skin
	if char > 0:
		return String(Roster.row(char).mesh)
	return "player.glb"


# M6 F1 §1.1: idempotent visual-child rebuild. Rigged source (CLIP_SOURCE
# row, keyed by the ONE _player_glb() read): instantiate the imported
# scene of the row's VISUAL file (row 0: the promoted byte-identical
# player-rigged.glb; every other rigged row: its own file), normalise the
# §a height at the ROOT-NODE SCALE (the skinning survives because nothing
# re-frees it), carry the ONE _mat onto the child surfaces (duplicate-
# first law already paid by the material block above — the SAME _mat
# object rides, iframes-alpha lands on the visible node), move self's own
# draw off the camera layer (MV-E5: child OR self, never both), start at
# the rest frame (paused seek(0) = the static-era frame). Static source:
# no child, self draws — §1.3's procedural arm rides _process.
func _grow_visual() -> void:
	if _rig != null:
		_rig.free()
		_rig = null
		_anim = null
		_walk_clip = ""
	_prev = Vector2(INF, INF)
	var clip_v = Roster.clip_source(_player_glb())
	if not (clip_v is Dictionary):
		set_surface_override_material(0, null) # static arm: restore the
		return # live-surface draw, no child, no clip (§1.3 rides _process)
	var clip: Dictionary = clip_v
	var vis := String(clip.get("visual", _player_glb()))
	var inst := ClassMesh.scene_for(vis).instantiate()
	var rest := ClassMesh.scene_rest_height(vis)
	inst.scale = Vector3.ONE * (HordeViz.MODEL_H_PLAYER / rest) \
		if rest > 0.0 else Vector3.ONE
	var mi := ClassMesh.mesh_node(inst)
	if mi != null:
		mi.material_override = _mat # the ONE _mat rides the VISIBLE node
	# MV-E5 mutual exclusion: ghost self's SURFACE (a per-surface
	# override at alpha 0 — zero visible pixels; the header carries why
	# layers/visible were ruled out on this binary). material_override
	# stays the shared _mat for every committed reader (the sim_chars
	# tint/fresh_dup probes, the iframes-alpha row), and pawn.mesh stays
	# the shipped ArrayMesh for the art probe's live row.
	_ghost = _mat.duplicate()
	_ghost.albedo_color.a = 0.0
	set_surface_override_material(0, _ghost)
	_rig = inst as Node3D
	add_child(_rig)
	_anim = _rig.get_node_or_null(NodePath(String(
		clip.get("clip_node", "AnimationPlayer")))) as AnimationPlayer
	_walk_clip = String(clip.get("walk", "walk"))
	if _anim != null:
		_anim.play(_walk_clip)
		_anim.pause()
		_anim.seek(0.0, true) # rest = the static-era frame (byte story)


func _process(_delta: float) -> void:
	if game == null:
		return
	var p: Dictionary = game.player
	position = Vector3(p.x / CameraRig.PX_PER_M,
		HordeViz.MODEL_H_PLAYER * 0.5, p.y / CameraRig.PX_PER_M)
	_mat.albedo_color.a = 0.55 if p.iframes > 0.0 else 1.0
	# --- M6 F1 motion (§1.1 clip arm / §1.3 procedural arm) ---
	# Everything below READS sim state and writes ONLY the pawn's own
	# visual transform / the child's AnimationPlayer. The pos rows above
	# stay the byte-anchored law; game.player is never written here.
	var spd := 0.0 # m/s — §1.1's per-tick displacement read
	var d := Vector2.ZERO # the tick's travel vector (lean direction)
	if _prev != Vector2.INF and _delta > 0.0:
		d = Vector2(p.x - _prev.x, p.y - _prev.y)
		spd = d.length() / _delta / CameraRig.PX_PER_M
	_prev = Vector2(p.x, p.y)
	if _anim != null:
		# Rigged arm: the shipped M5 clips PLAY while moving, at the
		# ONE gait frequency law (speed/stride capped, read from HordeViz
		# — no second table). Attack clips stay unplayed in-game: the
		# auto-fire FX is the hero's attack read (§0/F-1; F2 owns the
		# attack look); the clips stay capture-proven by the S2r gate.
		if spd > HordeViz.GAIT_EPS_MPS:
			_anim.speed_scale = minf(spd / HordeViz.GAIT_STRIDE_M,
				HordeViz.GAIT_FREQ_MAX)
			if not _anim.is_playing():
				_anim.play(_walk_clip) # resume after a rest pause
		else:
			_anim.pause()
			_anim.seek(0.0, true) # rest back to the static-era frame
		return
	# Static arm (§1.3): the SAME bob/lean family at pawn amplitudes, the
	# SAME stride-tied frequency law and the SAME spawn-position phase law
	# the horde rows ride (gait_p's formula, off the pawn's own sim px —
	# deterministic, no RNG). Applied ONLY while moving (the §1.1 speed
	# gate); at rest the transform returns to the shipped static-era pose
	# row-for-row.
	if spd > HordeViz.GAIT_EPS_MPS:
		var f := minf(spd / HordeViz.GAIT_STRIDE_M, HordeViz.GAIT_FREQ_MAX)
		var phase := fmod(p.x * 0.017 + p.y * 0.031, TAU) # the gait_p law
		var w := HordeViz.gait_wave(game.time, phase, f)
		position.y += PAWN_BOB_M * w
		if d.length_squared() > 0.0:
			basis = Basis(Vector3(d.y, 0.0, -d.x).normalized(),
				PAWN_LEAN_RAD * w) # lean toward the travel direction
	else:
		position.y = HordeViz.MODEL_H_PLAYER * 0.5 # rest row (row-for-row
		basis = Basis.IDENTITY # the static-era pose at rest)
