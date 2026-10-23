# Pickup viz seam (T-S18, MC 11201): the draw pass the 3D port never wired —
# no renderer anywhere read world.coins/gems/heals, so gold/XP/heals were
# invisible on the field (MC 11190 playtest root cause; owner ask 2026-10-23
# verbatim: "gold/exp is invizible right now"). This node READS the ONE
# existing arrays: no gameplay change — same drop rates, same 16 px touch-
# collect, same values (world.gd untouched); it never writes sim state. The
# four MultiMesh slots are exactly DESIGN-3D §b's planned rows ("gems 1 +
# coins 1 + dawnlight 1 + dawn-glow 1") — the ≤ 33 draw budget always
# carried them; only the code was missing.
# v1 parity, structural, own art: sizes ride the SIZES table (render.gd:14
# coin/gem 14 px stays the ONE px truth); the Dawnlight cross mirrors v1's
# _draw_dawnlight geometry (ARM 14 / BAR 4 px bars, v1 render.gd:175-182);
# NO spawn-pop — v1 draws every pickup at constant size every frame (VERIFIED
# in v1's render pass), so no pop/bounce is invented here. The glow is v1's
# HaloPass Dawnlight circles (DAWN_GLOW_RADII / DAWN_GLOW_ALPHAS,
# render.gd:55-56); coin/gem have no glow in v1 and get none here.
# Colours are the v1 palette (render.gd:16-22): coin REUSES the existing
# coin.png icon (godot/assets/icons/, the §j atlas row), the heal cross is
# BLOOD (the brief's "heal red cross"; the DAWNLIGHT glow supplies v1's warm
# bright feel on top), and the gem is ICHOR brightened x 1.15 — the ONE
# declared deviation, forced by measurement: the moorland tile's bright
# grass speckles peak at g 137 / g-r 64 (measured on the RED captures),
# indistinguishable from a plain ICHOR quad, and the whole point of this
# card is pickups being READABLE; the brighter variant keeps the hue and
# separates (probe gate g >= 170).
# Billboarding: the camera is a fixed-pitch ortho rig, so the same static
# camera-facing quad basis the HP bar uses (horde_viz §d BAR_BILLBOARD_DEG
# == CameraRig.PITCH_DEG) is correct for these too — no per-instance yaw.
# Z-fighting: billboards float at PICK_Y, clear of the ground quad (y=0),
# the blob shadows (0.02) and every ground decal (0.03).
class_name PickupViz
extends Node3D

# Metres above ground — the harness mirrors this constant for its PICK
# projections (upgrades_visual_capture.gd PICK_Y; kept equal by comment,
# before this file existed the capture projected onto bare ground).
const PICK_Y := 0.28
const ARM_PX := 14.0 # v1 _draw_dawnlight ARM (v1 render.gd:176)
const BAR_PX := 4.0 # v1 _draw_dawnlight BAR
const BILLBOARD_DEG := -70.0 # == CameraRig.PITCH_DEG (§d bar convention)
const GEM_BRIGHT := 1.15 # ICHOR uplift, declared above
const CHEST_PX := 28.0 # M1 f5 (MC 11209): OUR chest billboard size (the doc
	# names no v1 chest — single-tier M1 chest, icon-chest.png from the M1c
	# batch, the §j naming convention); rides the same billboard mechanism.
const DRAWS := 5 # gem + coin + cross + dawn-glow (§b's planned rows) +
	# chests 1 (M1 f5). The §b planned note stays 33 on purpose: the roadmap
	# re-tallies the WORST-CASE LOADOUT draws to planned 40 on the feature-6
	# card (that row names this chest MM by name) — note kept, never a gate;
	# the hard 60 cap row below is the gate and 34 ≤ 60.

var game: GameState
var world: GameWorld

var _gem: MultiMeshInstance3D
var _coin: MultiMeshInstance3D
var _cross: MultiMeshInstance3D
var _glow: MultiMeshInstance3D
var _chest: MultiMeshInstance3D
var _counts := {}


func _ready() -> void:
	# ONE unit-quad mesh per slot; per-instance scale carries the v1 px size
	# (the §b per-instance-transform mechanism, same as the HP bar fill).
	# NO node scale anywhere: MultiMesh instance ORIGINS live in node space,
	# so a node scale would squash every pickup's POSITION toward the world
	# origin too — the first build rendered every coin/gem within centimetres
	# of origin, invisible in every frame (found only by pixel probing — the
	# §e law that only real pixels are proof).
	_gem = _mm(_quad(), _mat(GameRenderer.ICHOR * GEM_BRIGHT))
	_coin = _mm(_quad(), _coin_mat())
	_cross = _mm(_quad(), _mat(GameRenderer.BLOOD))
	_glow = _mm(_quad(), _mat(GameRenderer.DAWNLIGHT, 0.25)) # §b dawn-glow 1
	_chest = _mm(_quad(), _icon_mat("res://assets/icons/icon-chest.png"))


func _process(_delta: float) -> void:
	refresh()


# Rewrite every pickup array from the live world state. Public so the
# headless harness forces one write at a dump step (HordeViz/WeaponFxViz
# pattern). READ-ONLY on world.* — the sim owns collection.
func refresh() -> void:
	if game == null or world == null:
		return
	var basis := Basis(Vector3(1.0, 0.0, 0.0), deg_to_rad(BILLBOARD_DEG))
	_write_items(_gem, world.gems, basis, GameRenderer.SIZES.gem,
		GameRenderer.SIZES.gem)
	_write_items(_coin, world.coins, basis, GameRenderer.SIZES.coin,
		GameRenderer.SIZES.coin)
	_write_items(_glow, world.heals, basis,
		2.0 * GameRenderer.DAWN_GLOW_RADII.x, 2.0 * GameRenderer.DAWN_GLOW_RADII.x)
	# M1 f5 (MC 11209): the chest rides the SAME billboard write — reads
	# world.chests only, never writes sim state (opening stays world.gd's).
	_write_items(_chest, world.chests, basis, CHEST_PX, CHEST_PX)
	# v1 cross: two bars per Dawnlight (ARM x BAR + BAR x ARM), 1 MM 2 draws'
	# worth of instances (the §b dawnlight-1 draw stays ONE call)
	var mm: MultiMesh = _cross.multimesh
	var s := 1.0 / CameraRig.PX_PER_M
	mm.instance_count = world.heals.size() * 2
	for i in world.heals.size():
		var h: Dictionary = world.heals[i]
		var o := Vector3(h.x * s, PICK_Y, h.y * s)
		mm.set_instance_transform(i * 2, Transform3D(
			_bb(basis, ARM_PX * s, BAR_PX * s, s), o))
		mm.set_instance_transform(i * 2 + 1, Transform3D(
			_bb(basis, BAR_PX * s, ARM_PX * s, s), o))
	_counts.gems = world.gems.size()
	_counts.coins = world.coins.size()
	_counts.heals = world.heals.size()
	_counts.chests = world.chests.size()


# RENDERED instance counts per pickup slot from the last refresh.
func pickup_counts() -> Dictionary:
	return _counts.duplicate()


# §b rows: the four MultiMeshInstance3D draws of this node (worst case;
# empty slots cost no draw call at runtime).
func draw_count() -> int:
	return DRAWS


# Local-space w x h billboard transform. NOT Basis.scaled() — measured on
# the pinned 4.7.2 binary, scaled() mixes components across the rotated
# axes (the vertical heal bar collapsed to cos-pitch height), while
# multiplying the stored axis vectors scales exactly along the billboard's
# own w/h axes. Same convention as horde_viz, which only ever scales X of
# the rotated bar basis (hp fill) and never met this edge.
func _bb(basis: Basis, w: float, h: float, th: float) -> Basis:
	var b := basis
	b.x = b.x * w
	b.y = b.y * h
	b.z = b.z * th
	return b


func _write_items(mmim: MultiMeshInstance3D, items: Array, basis: Basis,
		w_px: float, h_px: float) -> void:
	var s := 1.0 / CameraRig.PX_PER_M
	var mm: MultiMesh = mmim.multimesh
	mm.instance_count = items.size()
	var b := _bb(basis, w_px * s, h_px * s, s)
	for i in items.size():
		var it: Dictionary = items[i]
		mm.set_instance_transform(i, Transform3D(b,
			Vector3(it.x * s, PICK_Y, it.y * s)))


func _quad() -> QuadMesh:
	var q := QuadMesh.new()
	q.size = Vector2(1.0, 1.0) # unit: per-instance scale carries v1 px sizes
	return q


func _mm(mesh: Mesh, mat: StandardMaterial3D) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	var mmim := MultiMeshInstance3D.new()
	mmim.multimesh = mm
	mmim.material_override = mat
	mmim.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mmim)
	return mmim


func _mat(col: Color, alpha := 1.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = col
	m.albedo_color.a = alpha
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	if alpha < 1.0: # the dawn-glow rides v1 HaloPass blend (render.gd:237-244)
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.cull_mode = BaseMaterial3D.CULL_DISABLED # S2h billboard lesson
	return m


func _coin_mat() -> StandardMaterial3D:
	return _icon_mat("res://assets/icons/coin.png")


func _icon_mat(path: String) -> StandardMaterial3D:
	# Textured billboard material — the ONE such mechanism here (coin, then
	# the M1 chest; both unshaded white albedo over the icon file).
	var m := _mat(Color.WHITE)
	m.albedo_texture = load(path)
	return m
