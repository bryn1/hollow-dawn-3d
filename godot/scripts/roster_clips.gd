# The clip seam (3DR-SPEC §3.4, T-3DR-c, MC 11774): the CLIP_SOURCE table +
# its ONE getter + the ONE row->visual-twin resolution (visual_for, below),
# MOVED byte-faithfully out of roster.gd under roster.gd's own SCHEDULED
# clause (the T-M6q2 reason header, named card, audit-4 §1.4, the
# roster_select.gd/achievements_page.gd data-table CC3R precedent).
# THE LAW (T-3DR-CC2 re-word honest, MC 11918, CC1 audit F-1+F-3 pair):
# Roster's clip_source/visual_for getters are the delegating reads — every
# consumer keeps the ONE call path. Consumers MEASURED over godot/**/*.gd
# (universe WIDENED to cover godot/sim/ — the §5.3 law grep as first
# written ran over godot/scripts/*.gd only, blind to the capture leg: the
# CC1 audit's named blind spot, its grep rules 3/4): TWO honest named
# consumers of the seam — godot/scripts/hero_pawn.gd (the runtime player:
# static-arm read + walk/clip_node fields + the visual read) and
# godot/sim/roster_capture.gd (the dated capture seam read, MC 11774).
# This file is the single const + resolution home: the row->visual
# question resolves ONCE, here, never re-implemented at a reader
# (test_motion.test_row_visual_resolution_is_the_one_mechanism pins it).
class_name RosterClips
extends RefCounted

# --- CLIP SOURCE (M6-SPEC §1.1, T-M6r, MC 11676) — the ONE clip map ------
# Per mesh file under res://assets/glb/, the SKINNED runtime consumer's
# clip row, or null = STATIC. The law this table pins (docs/
# RIG-DEVIATION-SEL-C.md, owner "Rec" 2026-10-27, MC 11440; state re-pinned
# by docs/RIG-DEVIATION-3DR.md, MC 11773/11774): the RIGGED rows carry the
# named clips the mocap chain shipped (walk + attack); the statue-class
# rows that DOUBLE-FAILED the rig stage stay static EXCUSED-not-removed
# and take the §1.3 procedural arm — they name NO clip here (null), under
# the owner-ratified STATIC FALLBACK (package item 3, owner "Rec"
# 2026-10-31: "UniRig seed 12345, TWO-FAIL STOP per char -> static+procedural
# fallback, never a broken animation; fallback rows named in docs").
# 3DR FLIP (T-3DR-c, dated 2026-11-02, MC 11774): THREE of the six M5
# statue rows flipped to their rigged twins (char-tallow-seer, skin-tide,
# skin-void — the 3DR-a meshes + 3DR-r rig pass, rig-yield 3/6); the other
# three (char-coinhound, char-shroud-saint, char-hoard-wretch) STAY static
# with the reason rows in docs/RIG-DEVIATION-3DR.md. clip_node
# = the AnimationPlayer node name inside the IMPORTED GLB scene (the
# pinned import pass ships it; the runtime-GLTFDocument route stays
# harness-side, §1.1); walk = the clip the pawn plays while moving. The
# attack clip is NOT played in-game (stated reading §0/F-1: the auto-fire
# FX is the hero's attack read; F2 owns the attack look) — it stays
# capture-proven.
# ROW 0: the PAWN VISUAL promotes the byte-identical twin player-rigged
# (S2r rewrite, docs/PERMANENCE.md; the promotion copy + .import sidecar
# is the T-M5s permanence law) — the ONE "visual" key that differs from
# its map key, §1.1's row-0 law. Every NON-visual consumer keeps reading
# the literal "player.glb" (Roster.CHARACTERS[0].mesh stays: the art
# fixture heights + the test_art_integration seam-pin ride it). The 3DR
# flipped rows carry the SAME "visual" twin key per this row-0 pattern
# (§3.3 new-file law: the v3 mesh literal stays the map key + the art
# fixture read; the RUNTIME visual is the rigged twin).
# The map is a read-only row by contract (the duplicate() law's read-side
# restated: no consumer mutates it; the hand-out is the scalar read below).
const CLIP_SOURCE := {
	"player.glb": {"visual": "player-rigged.glb",
		"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-emberwright.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-grave-ward.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-coinhound.glb": null, # statue-class static (double-fail, 3DR-r)
	"char-duskrunner.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-tallow-seer.glb": {"visual": "char-tallow-seer-rigged.glb",
		"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-shroud-saint.glb": null, # statue-class static (double-fail, 3DR-r)
	"char-iron-penitent.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"char-hoard-wretch.glb": null, # statue-class static (double-fail, 3DR-r)
	"skin-ash.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"skin-marrow.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"skin-tide.glb": {"visual": "skin-tide-rigged.glb",
		"clip_node": "AnimationPlayer", "walk": "walk"},
	"skin-relic.glb": {"clip_node": "AnimationPlayer", "walk": "walk"},
	"skin-void.glb": {"visual": "skin-void-rigged.glb",
		"clip_node": "AnimationPlayer", "walk": "walk"},
}


# The ONE clip-map read: Dictionary (rigged: optional "visual" twin +
# "clip_node" + "walk") or null (static / unmapped — the procedural arm).
static func clip_source(glb_file: String): # Dictionary | null
	return CLIP_SOURCE.get(glb_file)


# The ONE row->visual-twin resolution (T-3DR-CC2 hoist, MC 11918, CC1 F-3):
# the FILE a row DRAWS — the rigged twin where the row carries a "visual"
# key (the row-0 pattern above), else the map key itself. Hoisted from the
# TWO inline readers the flip wave left behind (hero_pawn._grow_visual's
# clip.get and the capture's _seam_src getter); BOTH named consumers call
# this ONE site through the Roster.visual_for delegating getter. The
# returned string is byte-equal to what each reader produced before — the
# CC1 capture legs prove the same bytes execute (zero behavior change).
static func visual_for(glb_file: String) -> String:
	var clip = CLIP_SOURCE.get(glb_file)
	if clip is Dictionary and clip.has("visual"):
		return String(clip.visual)
	return glb_file
