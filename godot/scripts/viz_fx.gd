# Weapon FX emitters (DESIGN-3D §i, the §f-named viz_fx.gd): six weapon
# reason: >400 lines — 571 measured at MC 11705 T-M6f: M6-SPEC §2.1 NAMES
#   this file as the ONE site of the SKILL_FX table ("data in the file that
#   consumes it — the §i pattern") and of the five writer colour switches;
#   splitting the table out would put the per-instance colour law beside a
#   second table site, the exact second-mechanism class the spec forbids.
# effect classes batched into MultiMeshes / small meshes — one draw per
# effect class, ember rides two (orb + trail ribbon) => FX draws <= 7 of
# §b's budget. All FX are additive, unlit, shadow-cast OFF (§i). M6 F2
# (MC 11705, M6-SPEC §2): the v1 constant colours (MOON/EMBER/ICHOR/BONE)
# become PER-SKILL — the SKILL_FX table below gives EVERY fireable id its
# own look keyed to its shipped icon (colours SAMPLED at card time by
# tools/skill_fx_sample.py, the values pinned below + by
# tests/test_skill_fx.py; scale = render-only LOOK multiplier, never a sim
# radius — the T-S18 ward/spike sim-truth law holds; trail = the bolt
# ribbon length; band = the ring-class annulus inner ratio, the ward
# per-level mechanism extended to per-skill, mesh cache keyed wid×level;
# flash = the evolved rows' brighter ring pulse — the evolved flash IS the
# ring, counted in the existing rings cap read, ZERO new draw classes).
# The colours ride the shipped bulk-gem mechanism (T-M2g): the writers
# switch their MMs to use_colors + vertex_color_use_as_albedo and set each
# instance's colour from SKILL_FX[item.wid] (the wid stamp is weapons.gd's
# additive dict field, §2.1); the material albedos become WHITE × the
# existing per-class alpha law — the fade alphas (arc 0.35·life/max, ring
# 0.25·life/max, burst 0.6·life/max, bolts + throws + halo constant) are
# v1's, kept verbatim: they multiply the instance colour as before. Sim
# truth stays v1-verbatim: this node only READS the WeaponSystem transient
# arrays (weapons.gd bolts/throws/bursts/arcs/rings/halos) — it never
# writes sim state.
# §i live-count caps: the RENDER layer caps its instances at the §i formulas
# (ember 1+floor((L-1)/3), cleaver 1+floor((L-1)/4), halo 1+ceil(L/3) <= 4,
# spike ground-burst shards SPARKS <= 20 per brief row 4). The sim's own
# projectile lists are untouched — overlapping volleys the sim allows past
# the render cap are the sim's business; the visible-layer budget is this
# file's. SINCE T-M6f the family sums resolve through EvolutionSystem.
# effect()'s base map (§3.3): the evolved ids add their BASE family's term
# — the cap family of an evolved weapon is its base family, the both-sites
# rule mirroring sim_combat.caps in the same commit (FX-E3).
class_name WeaponFxViz
extends Node3D

# §i draw column: 6 weapon classes, ember = orb + trail => 7 batched draws.
const FX_DRAWS_MAX := 7
const SPARKS := 20 # spike ground-burst shard CAP (brief §i row 4: <= 20; the
	# suite pins this constant's name and cap). T-S18: the live COUNT rides
	# spike level 8..20 under this cap (see _shards) — Lv1 keeps a quiet
	# 8-shard burst, Lv8 saturates the §i budget.

# Ground-plane decal heights (above ground quad y=0, below entity bodies).
const Y_DECAL := 0.03 # talon wedge + ward ring + spike shards
const Y_ORB := 0.9 # bolt/halo orb flight line (~34 px read)
const TRAIL_M := 0.55 # ember trail ribbon length (visual only, §i)

# M6 F2 (MC 11705, M6-SPEC §2.1): THE SKILL_FX TABLE — one row per
# fireable id: 15 weapon-side (weapons.gd IDS; doom-sigil is DROPPED, not
# weapon-side, per §4.1/T-M6d — its icon file KEEPS, its row does not
# exist), the 9 LIVE evolved ids (evolutions.gd TABLE — pale-moon is
# KEEP-as-file, DEAD-as-fireable, the declared fallback row the pin
# EXCLUDES, named in §2.2 FX-E2) and the 2 union orbiters (union.gd
# TABLE). colour = the §2.1 icon sampling (tools/skill_fx_sample.py, the
# capture-printed values); scale = LOOK transform multiplier (wedge WIDTH
# axis for arcs, orb/axe/shard size for the projectile classes — never a
# sim radius); trail = bolt ribbon-length multiplier (bolts read it, the
# other rows carry the shipped 1.0); band = ring-class annulus inner ratio
# (the per-level widening law -0.03/level rides inside every row — ward's
# Lv1 ratio stays the shipped v1-parity 0.82); flash = the evolved rows'
# brighter ring pulse + the player flash ring (§2.1, FLASH_* consts below).
# Evolved rows read as a BIGGER/BRIGHTER variant of the SAME identity
# (owner quote, §2 header): the scale/band strictly exceeds the base row's
# look, the colour samples the evolved icon of its family.
const SKILL_FX := {
	"talon": {"cls": "arcs", "color": Color(0.529, 0.655, 0.660),
		"scale": 1.0, "trail": 1.0, "band": 0.82, "flash": false},
	"ember": {"cls": "bolts", "color": Color(0.707, 0.148, 0.004),
		"scale": 1.0, "trail": 1.0, "band": 0.82, "flash": false},
	"cleaver": {"cls": "throws", "color": Color(0.308, 0.322, 0.298),
		"scale": 1.0, "trail": 1.0, "band": 0.82, "flash": false},
	"halo": {"cls": "halos", "color": Color(0.324, 0.195, 0.161),
		"scale": 1.0, "trail": 1.0, "band": 0.82, "flash": false},
	"ward": {"cls": "rings", "color": Color(0.553, 0.973, 0.918),
		"scale": 1.0, "trail": 1.0, "band": 0.82, "flash": false},
	"spike": {"cls": "bursts", "color": Color(0.274, 0.391, 0.396),
		"scale": 1.0, "trail": 1.0, "band": 0.82, "flash": false},
	"bone-whip": {"cls": "arcs", "color": Color(1.000, 0.446, 0.126),
		"scale": 1.15, "trail": 1.0, "band": 0.82, "flash": false},
	"dart-loop": {"cls": "bolts", "color": Color(0.165, 0.291, 0.360),
		"scale": 0.75, "trail": 0.35, "band": 0.82, "flash": false},
	"hewn-axe": {"cls": "throws", "color": Color(0.200, 0.285, 0.333),
		"scale": 1.3, "trail": 1.0, "band": 0.82, "flash": false},
	"pilgrim-cross": {"cls": "throws", "color": Color(0.438, 0.417, 0.311),
		"scale": 1.15, "trail": 1.3, "band": 0.82, "flash": false},
	"censer-of-hours": {"cls": "bolts", "color": Color(0.177, 0.224, 0.304),
		"scale": 0.9, "trail": 0.6, "band": 0.82, "flash": false},
	"rot-water": {"cls": "rings", "color": Color(0.187, 1.000, 0.160),
		"scale": 1.0, "trail": 1.0, "band": 0.7, "flash": false},
	"spectral-disc": {"cls": "bolts", "color": Color(0.177, 0.304, 0.360),
		"scale": 1.35, "trail": 0.9, "band": 0.82, "flash": false},
	"storm-peal": {"cls": "bursts", "color": Color(1.000, 0.143, 0.089),
		"scale": 1.1, "trail": 1.0, "band": 0.82, "flash": false},
	"fire-lash": {"cls": "bolts", "color": Color(1.000, 0.139, 0.000),
		"scale": 1.4, "trail": 1.15, "band": 0.82, "flash": false},
	"red-wail": {"cls": "arcs", "color": Color(1.000, 0.000, 0.159),
		"scale": 1.35, "trail": 1.0, "band": 0.82, "flash": true},
	"thousand-darts": {"cls": "bolts", "color": Color(0.468, 0.163, 0.054),
		"scale": 0.9, "trail": 0.5, "band": 0.82, "flash": true},
	"rot-spiral": {"cls": "throws", "color": Color(0.087, 0.461, 0.152),
		"scale": 1.55, "trail": 1.0, "band": 0.82, "flash": true},
	"judgement-cross": {"cls": "throws", "color": Color(0.485, 0.303, 0.099),
		"scale": 1.4, "trail": 1.4, "band": 0.82, "flash": true},
	"eternal-matins": {"cls": "bolts", "color": Color(1.000, 0.113, 0.000),
		"scale": 1.1, "trail": 0.8, "band": 0.82, "flash": true},
	"the-sluice": {"cls": "rings", "color": Color(0.282, 1.000, 0.491),
		"scale": 1.0, "trail": 1.0, "band": 0.6, "flash": true},
	"grave-orbit": {"cls": "bolts", "color": Color(0.520, 0.673, 0.686),
		"scale": 1.6, "trail": 1.0, "band": 0.82, "flash": true},
	"rolling-thunder": {"cls": "bursts", "color": Color(1.000, 0.000, 0.000),
		"scale": 1.35, "trail": 1.0, "band": 0.82, "flash": true},
	"inferno-lash": {"cls": "bolts", "color": Color(1.000, 0.136, 0.000),
		"scale": 1.75, "trail": 1.4, "band": 0.82, "flash": true},
	"requiem-toll": {"cls": "halos", "color": Color(0.850, 0.045, 0.098),
		"scale": 1.25, "trail": 1.0, "band": 0.82, "flash": false},
	"dirge-eternal": {"cls": "rings", "color": Color(0.347, 1.000, 0.612),
		"scale": 1.1, "trail": 1.0, "band": 0.66, "flash": false},
}
# The declared base-fallback row (§2.2 FX-E2): an un-stamped/unKnown wid
# paints the EMBER row colour — the shipped look of the entry class before
# F2 (the bolt class rode EMBER verbatim). tests/test_skill_fx.py EXCLUDES
# pale-moon as this row (it is DEAD-as-fireable, never a fireable id).
const FX_FALLBACK := "ember"
# The evolved flash (§2.1): the rings CLASS, never a new MM — when the
# firing id's row flashes, its ring reads FLASH_GAIN brighter and, with no
# ring live, the SAME MM draws one pulse at the survivor (mini(size,1)
# keeps the ONE draw; counted in the existing rings.size() cap read :207).
const FLASH_GAIN := 2.2
const FLASH_A := 0.35 # constant alpha of the player-flash pulse (reads
	# brighter than the ward ring's 0.25·life/max — the "big boost" row)
const FLASH_R_PX := 110.0 # player-flash pulse radius (px; the ward's tick
	# r is 80 — the flash reads bigger, the LOOK law above applies)

var game: GameState
var sim: WeaponSystem # the ported weapons.gd instance — READ only

var _arc: MultiMeshInstance3D
var _orb: MultiMeshInstance3D
var _trail: MultiMeshInstance3D
var _axe: MultiMeshInstance3D
var _ring: MultiMeshInstance3D
var _halo: MultiMeshInstance3D
var _shard: MultiMeshInstance3D
var _counts := {} # last refresh()'s RENDERED instance counts per FX slot


func _ready() -> void:
	# F2 (§2.1): materials become WHITE × the per-class alpha law — the
	# per-instance colours ride the bulk-gem mechanism (T-M2g).
	_arc = _fx_mm(_wedge_mesh(), _mat(Color.WHITE, true))
	_orb = _fx_mm(_orb_mesh(), _mat(Color.WHITE, true))
	_trail = _fx_mm(_trail_mesh(), _mat(Color.WHITE, true, 0.45))
	_axe = _fx_mm(_axe_mesh(), _mat(Color.WHITE, false))
	_ring = _fx_mm(_annulus_mesh(0.82), _mat(Color.WHITE, true))
	_halo = _fx_mm(_orb_mesh(), _mat(Color.WHITE, true))
	_shard = _fx_mm(_shard_mesh(), _mat(Color.WHITE, true))
	for mmim in [_arc, _orb, _trail, _axe, _ring, _halo, _shard]:
		mmim.multimesh.use_colors = true


func _process(_delta: float) -> void:
	refresh()


# Rewrite every FX array from the live transient state. Public so the
# headless sim forces one write at a dump step (same pattern as HordeViz).
func refresh() -> void:
	if game == null or sim == null:
		return
	var s := 1.0 / CameraRig.PX_PER_M
	_write_arcs(s)
	var bolts: Array = sim.bolts.slice(maxi(0, sim.bolts.size() - _cap("ember")))
	_write_orbs(_orb, bolts, Y_ORB)
	_write_trails(bolts)
	var throws: Array = sim.throws.slice(maxi(0, sim.throws.size() - _cap("cleaver")))
	_write_throws(throws, s)
	_write_halos()
	_write_rings(s)
	_write_bursts(s)


# RENDERED instance counts per FX slot from the last refresh (the §i cap
# rows compare THESE — the visible-layer live counts — never sim arrays).
func fx_counts() -> Dictionary:
	return _counts.duplicate()


# The §i worst case is always 7 (every class batched at all times); the
# renderer issues fewer calls when a class has zero live instances.
func draw_count() -> int:
	return FX_DRAWS_MAX


func live_draws() -> int:
	var n := 0
	for mmim in [_arc, _orb, _trail, _axe, _ring, _halo, _shard]:
		if mmim.multimesh.instance_count > 0:
			n += 1
	return n


# §i formulas, spelled as weapons.gd spells them (same cap source). M1h
# (roster): the ten new weapons REUSE these effect classes, so the render
# cap is the FAMILY sum — the pinned ember/cleaver terms stay verbatim and
# each bolt-/throw-class roster weapon adds its OWN fire-count (the table
# sim_combat mirrors). A build without the roster gets the OLD caps exactly
# (extra = 0, every pre-M1h cap row byte-equal). M6 F2 (MC 11705, §2.1/
# §3.3): the family membership resolves through EvolutionSystem.effect()'s
# BASE map — the evolved ids add their own term THROUGH the base family
# (roster_one_cap stays keyed on the base id, spelling the same arm math),
# so a build carrying thousand-darts adds exactly what dart-loop added at
# the same level and no cap ever becomes per-id alone (FX-E3's planted red).
const BOLT_ROSTER := ["dart-loop", "fire-lash", "spectral-disc", "censer-of-hours"]
const THROW_ROSTER := ["hewn-axe", "pilgrim-cross"]

# Per-weapon fire-count, spelled as weapons.gd _fire spells its appends
# (ONE table, both count sites — sim_combat.caps calls this same table).
static func roster_one_cap(id: String, level: int) -> int:
	match id:
		"dart-loop":
			return 1 + int((level - 1) / 3)
		"hewn-axe":
			return 1 + int((level - 1) / 4)
		"censer-of-hours":
			return 4 # the cross volley
		_:
			return 1


func _cap(id: String) -> int:
	match id:
		"ember":
			return 1 + int((_level("ember") - 1) / 3) + _roster_cap(BOLT_ROSTER)
		"cleaver":
			return 1 + int((_level("cleaver") - 1) / 4) + _roster_cap(THROW_ROSTER)
		_:
			return 0


func _roster_cap(family: Array) -> int:
	var n := 0
	for w in game.weapons:
		var base := String(EvolutionSystem.effect(w.id).base)
		if family.has(base):
			n += roster_one_cap(base, w.level)
	return n


# One rotation frame whose local +Z is the given XZ direction (sim px space
# maps x->x, y->z). ONE mechanism shared with horde_viz's attack squash.
static func frame_xz(vx: float, vy: float) -> Basis:
	var d := maxf(sqrt(vx * vx + vy * vy), 1e-6)
	var x := vx / d
	var z := vy / d
	return Basis(Vector3(z, 0.0, -x), Vector3(0.0, 1.0, 0.0), Vector3(x, 0.0, z))


func _level(id: String) -> int:
	for w in game.weapons:
		if w.id == id:
			return w.level
	return 1


# The §2.1 row lookup: SKILL_FX[wid], the declared FX_FALLBACK row else
# (an un-stamped id paints the shipped family default — the §2.2 pin's
# base-fallback, NEVER a silent colour).
static func fx_row(wid: String) -> Dictionary:
	return SKILL_FX.get(wid, SKILL_FX[FX_FALLBACK])


func _write_arcs(s: float) -> void:
	var mm: MultiMesh = _arc.multimesh
	mm.instance_count = sim.arcs.size()
	for i in sim.arcs.size():
		var a: Dictionary = sim.arcs[i]
		var row: Dictionary = fx_row(String(a.get("wid", "")))
		var f := frame_xz(cos(a.ang), sin(a.ang))
		# F2 LOOK scale rides the wedge WIDTH axis only — the wedge RADIUS
		# is the sim's hit range (the T-S18 sim-truth law extended: a wider
		# radius would LIE); the sideways read is the individual arc look.
		mm.set_instance_transform(i, Transform3D(
			f.scaled(Vector3(row.scale, 1.0, 1.0) * (a.range * s)), # unit wedge -> v1 range
			Vector3(game.player.x * s, Y_DECAL, game.player.y * s)))
		mm.set_instance_color(i, row.color)
	# v1 alpha 0.35·life/max; arcs never overlap (cd 0.55·0.96^7 > life 0.15)
	_arc.material_override.albedo_color.a = 0.0 if sim.arcs.is_empty() \
		else 0.35 * sim.arcs[-1].life / sim.arcs[-1].max
	_counts.arcs = mm.instance_count


func _write_orbs(mmim: MultiMeshInstance3D, items: Array, y: float) -> void:
	var mm: MultiMesh = mmim.multimesh
	mm.instance_count = items.size()
	for i in items.size():
		var row: Dictionary = fx_row(String(items[i].get("wid", "")))
		# The orb mesh (r 0.2 m) is a LOOK size — the sim's hit radius rides
		# item.r untouched (§2.1); row.scale is the per-skill size read.
		mm.set_instance_transform(i, Transform3D(
			Basis.IDENTITY.scaled(Vector3.ONE * float(row.scale)),
			Vector3(items[i].x / CameraRig.PX_PER_M, y,
				items[i].y / CameraRig.PX_PER_M)))
		mm.set_instance_color(i, row.color)


func _write_trails(bolts: Array) -> void:
	var mm: MultiMesh = _trail.multimesh
	mm.instance_count = bolts.size()
	for i in bolts.size():
		var b: Dictionary = bolts[i]
		var row: Dictionary = fx_row(String(b.get("wid", "")))
		var f := frame_xz(-b.vx, -b.vy) # ribbon trails behind the flight
		mm.set_instance_transform(i, Transform3D(f.scaled(
			Vector3(row.scale, 1.0, TRAIL_M * row.trail)), # F2: per-skill ribbon
			Vector3(b.x / CameraRig.PX_PER_M, Y_ORB, b.y / CameraRig.PX_PER_M)))
		mm.set_instance_color(i, row.color)
	_counts.bolts = _orb.multimesh.instance_count
	_counts.trails = mm.instance_count


# v1 lift: sin(PI·prog)·26 px (render.gd:155) on a spinning axe (visual).
func _write_throws(throws: Array, s: float) -> void:
	var mm: MultiMesh = _axe.multimesh
	mm.instance_count = throws.size()
	for i in throws.size():
		var t: Dictionary = throws[i]
		var row: Dictionary = fx_row(String(t.get("wid", "")))
		var prog: float = clampf(t.dist / t.travel, 0.0, 1.0)
		var f := frame_xz(t.vx, t.vy).rotated(Vector3.UP, game.time * 14.0 + i * 2.1)
		mm.set_instance_transform(i, Transform3D(f.scaled(
			Vector3.ONE * float(row.scale)), # F2: per-skill axe size (look only)
			Vector3(t.x * s, 0.45 + sin(PI * prog) * 26.0 * s, t.y * s)))
		mm.set_instance_color(i, row.color)
	_counts.axes = mm.instance_count


func _write_halos() -> void:
	_write_orbs(_halo, sim.halos, Y_ORB)
	_counts.halos = _halo.multimesh.instance_count


func _write_rings(s: float) -> void:
	var mm: MultiMesh = _ring.multimesh
	mm.instance_count = mini(sim.rings.size(), 1) # cd 0.45 > life 0.12
	if mm.instance_count > 0:
		var r: Dictionary = sim.rings[-1]
		var wid := String(r.get("wid", ""))
		var row: Dictionary = fx_row(wid)
		var prog: float = 1.0 - r.life / r.max
		var rm: float = r.r * s * (0.55 + 0.5 * prog) # expanding pulse, §i
		# T-S18 (MC 11201) VISIBLE UPGRADES, declared: the ward's per-level
		# sim quantity is DAMAGE ONLY (weapons.gd:145-148 — tick r stays the
		# constant 80 px at every level), so a larger visible ring would LIE
		# about the damage range (the DoD forbids any sim change here). The
		# level therefore reads as INTENSITY: the annulus band widens from
		# Lv1's v1-parity inner ratio 0.82 down to 0.61 at Lv8 (band area
		# ~ x1.9 — the probe's measured delta), radius stays sim-truth.
		# M6 F2 (MC 11705, §2.1): the mechanism extends PER-SKILL — every
		# ring-class row owns its Lv1 ratio ("band"), the per-level law
		# rides inside it, the mesh cache keys wid×level (the ward's byte
		# story: ward Lv1 inner stays the shipped 0.82 verbatim).
		mm.mesh = _ring_mesh(wid, row, _level(wid))
		mm.set_instance_transform(0, Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * rm),
			Vector3(game.player.x * s, Y_DECAL + 0.01, game.player.y * s)))
		mm.set_instance_color(0, row.color)
		var a: float = 0.25 * r.life / r.max # the v1 ring fade row, verbatim
		if bool(row.flash):
			a = minf(a * FLASH_GAIN, 1.0) # evolved flash: the SAME pulse,
			# brighter (the evolved flash IS the ring — §2.1)
		_ring.material_override.albedo_color.a = a
	else:
		# F2 evolved flash pulse (§2.1): with NO ring live, the SAME MM
		# draws one brighter annulus at the survivor while a flash row's
		# entry is live — mini(size,1) has kept the ONE ring draw all
		# along; a flash weapon's ring flash IS this instance (counted in
		# the rings cap read, ZERO new draw classes).
		var frow := _flash_row()
		if not frow.is_empty():
			mm.instance_count = 1
			mm.mesh = _ring_mesh("flash", frow, 1)
			mm.set_instance_transform(0, Transform3D(
				Basis.IDENTITY.scaled(Vector3.ONE
					* (FLASH_R_PX / CameraRig.PX_PER_M) * float(frow.scale)),
				Vector3(game.player.x / CameraRig.PX_PER_M, Y_DECAL + 0.01,
					game.player.y / CameraRig.PX_PER_M)))
			mm.set_instance_color(0, frow.color)
			_ring.material_override.albedo_color.a = FLASH_A
		else:
			_ring.material_override.albedo_color.a = 0.0
	_counts.rings = mm.instance_count


# The newest live transient entry that carries a FLASH row (§2.1): the
# tail of each transient array, checked in a FIXED order (deterministic —
# refresh() is the only driver, the headless sim forces it identically).
func _flash_row() -> Dictionary:
	for list in [sim.rings, sim.bursts, sim.arcs, sim.throws, sim.bolts,
			sim.halos]:
		if list.is_empty():
			continue
		var row: Dictionary = SKILL_FX.get(
			String(list[list.size() - 1].get("wid", "")), {})
		if not row.is_empty() and bool(row.flash):
			return row
	return {}


# One cached annulus per (wid, level) — §b keeps this ONE ring draw
# (F2: the cache key extends per-skill, the §2.1 law).
var _ring_meshes := {}


func _ring_mesh(key: String, row: Dictionary, level: int) -> ArrayMesh:
	var k := "%s:%d" % [key, level]
	if not _ring_meshes.has(k):
		_ring_meshes[k] = _annulus_mesh(float(row.band)
			- 0.03 * float(level - 1)) # the T-S18 widening law, per row
	return _ring_meshes[k]


func _write_bursts(s: float) -> void:
	var mm: MultiMesh = _shard.multimesh
	if sim.bursts.is_empty():
		mm.instance_count = 0
		_shard.material_override.albedo_color.a = 0.0
		_counts.bursts = 0
		_counts.shards = 0
		return
	var b: Dictionary = sim.bursts[-1] # cd >= 1.95 s > life 0.25 s
	var row: Dictionary = fx_row(String(b.get("wid", "")))
	var prog: float = 1.0 - b.life / b.max
	var rm: float = b.r * s * (0.25 + 0.75 * prog)
	# T-S18 (MC 11201) VISIBLE UPGRADES, declared: like ward, the spike's
	# per-level sim quantity is DAMAGE ONLY (weapons.gd:149-166 — burst r
	# stays the constant 56 px), so the burst RADIUS stays sim-truth and the
	# level reads as shard COUNT: 8 at Lv1 (v1-parity quiet burst) up to the
	# §i budget cap 20 at Lv8 (the count rides levels inside the §i <= 20
	# cap the row always carried; sim_headless/SimCombat cap_violations
	# re-checks exactly this bound on every FX sample). F2: the shard SIZE
	# is a LOOK read (row.scale) — the burst radius above stays sim-truth.
	var n := _shards()
	mm.instance_count = n
	for i in n:
		var a := float(i) / float(n) * TAU
		var dx := cos(a)
		var dz := sin(a)
		var f := frame_xz(dx, dz)
		mm.set_instance_transform(i, Transform3D(
			f.scaled(Vector3(row.scale, (0.4 + 0.6 * prog) * row.scale,
				row.scale)),
			Vector3(b.x * s + dx * rm, Y_DECAL + 0.2, b.y * s + dz * rm)))
		mm.set_instance_color(i, row.color)
	_shard.material_override.albedo_color.a = 0.6 * b.life / b.max
	_counts.bursts = 1
	_counts.shards = n


func _shards() -> int:
	# The T-S18 COUNT law keyed on the SPIKE level stays verbatim (the row
	# always carried it; F2 changes colour/size, never a count law).
	var l := _level("spike")
	return mini(8 + (l - 1) * 12 / 7, SPARKS)


func _fx_mm(mesh: Mesh, mat: StandardMaterial3D) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	var mmim := MultiMeshInstance3D.new()
	mmim.multimesh = mm
	mmim.material_override = mat
	mmim.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF # §i
	add_child(mmim)
	return mmim


func _mat(col: Color, additive: bool, alpha := 1.0) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(col.r, col.g, col.b, alpha)
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	# F2 (§2.1): the bulk-gem colour law (T-M2g, pinned 4.7.2) — instance
	# colours multiply the WHITE albedo through vertex colour.
	mat.vertex_color_use_as_albedo = true
	# P1 FIX (S2h gate, 2026-10-22): the flat decal meshes (_annulus_mesh,
	# _wedge_mesh, _trail_mesh) are wound so generate_normals() yields
	# DOWNWARD normals (Godot is left-handed); with the default back-face
	# cull the top-down camera saw only culled back faces — the ward ring,
	# talon wedge and trail ribbon were invisible in every build. Disable
	# culling on these tiny unshaded quads (boxes/spheres are unaffected).
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	if additive:
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	return mat


# --- flat-in-XZ geometry helpers (unit sized; instances scale) ------------

func _trail_mesh() -> ArrayMesh:
	# Flat quad, z in [-1,0]: trails behind local +Z (the bolt's flight).
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	_tri(st, Vector3(-1, 0, 0), Vector3(1, 0, 0), Vector3(1, 0, -1))
	_tri(st, Vector3(-1, 0, 0), Vector3(1, 0, -1), Vector3(-1, 0, -1))
	st.generate_normals()
	return st.commit()


func _wedge_mesh() -> ArrayMesh:
	# Talon quarter-disc: fan from the survivor out to unit radius spanning
	# ±0.62 rad about +Z (v1 _draw_fx wedge, render.gd:143-148 in 3D).
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in 8:
		var a0 := -0.62 + 1.24 * float(i) / 8.0
		var a1 := -0.62 + 1.24 * float(i + 1) / 8.0
		_tri(st, Vector3.ZERO, Vector3(sin(a0), 0, cos(a0)), Vector3(sin(a1), 0, cos(a1)))
	st.generate_normals()
	return st.commit()


func _annulus_mesh(inner: float) -> ArrayMesh:
	# Ward ring-pulse decal: flat annulus, inner ratio of unit outer radius
	# (T-S18: the ratio rides ward level — _ring_mesh caches one per level;
	# F2 §2.1: the cache keys wid×level, the ratio per SKILL_FX row).
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in 12:
		var a0 := TAU * float(i) / 12.0
		var a1 := TAU * float(i + 1) / 12.0
		var i0 := Vector3(sin(a0), 0, cos(a0)) * inner
		var i1 := Vector3(sin(a1), 0, cos(a1)) * inner
		var o0 := Vector3(sin(a0), 0, cos(a0))
		var o1 := Vector3(sin(a1), 0, cos(a1))
		_tri(st, i0, o0, o1)
		_tri(st, i0, o1, i1)
	st.generate_normals()
	return st.commit()


func _orb_mesh() -> SphereMesh:
	var s := SphereMesh.new()
	s.radius = 0.2
	s.height = 0.4
	s.radial_segments = 8
	s.rings = 6
	return s


func _axe_mesh() -> BoxMesh:
	var b := BoxMesh.new()
	b.size = Vector3(0.45, 0.08, 0.14) # bone-axe read; T2 prop at art stage
	return b


func _shard_mesh() -> BoxMesh:
	var b := BoxMesh.new()
	b.size = Vector3(0.08, 0.55, 0.16) # radial ground shard, §i spike row
	return b


static func _tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	st.add_vertex(a)
	st.add_vertex(b)
	st.add_vertex(c)
