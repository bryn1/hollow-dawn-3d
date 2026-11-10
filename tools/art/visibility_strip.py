#!/usr/bin/env python3
"""VISIBILITY STRIP (GATE-INT-V4, MC 12352): delete ONLY faces that are
provably invisible from every camera the game can put on this asset.

WHY THIS RULE EXISTS — read before editing. The roof rule (interior_strip.py,
still shipped and UNTOUCHED here) deleted faces because a wall-pair test said
"an inner face is hidden behind an outer one". For the geometry TRELLIS.2
actually bakes that premise is FALSE: MC 12345 (knut-VERIFIED) measured the
emberwright bake after that strip at render IoU 0.849-0.945 against the 0.95
floor — cloth-over-body lining and limb-interface skin IS visible (through
gaps, at grazing angles, under the rig's own tilt). So nothing here deletes
on similarity evidence. This module asks the one question that decides a
pixel: does this face own ANY pixel of ANY declared external view? A face that
never wins a pixel cannot be seen by that camera set; a face that wins one is
KEPT. The architecture it plugs into (bake once, then strip as pure geometry)
is the half of MC 12342 that was VINDICATED; only the RULE was rejected.

METHOD. Rasterize into a FACE-ID FRAMEBUFFER using tools/art/render_parity.py
— the repo's existing CPU rasterizer, extended there, NOT duplicated here —
over a declared fixed sampling set: an orthographic yaw x elevation sphere
plus two perspective rings. Keep every face id that appears in any buffer,
plus the edge-adjacent 1-ring of that set (KEEP_RING). The rasterizer's known
error class is one pixel wide and lives at depth discontinuities, and depth
discontinuities are exactly interfaces — cloth rim, limb root. Losing one face
there is how 12345 died; one ring costs one face-layer of yield.

CONSTANTS, each justified against THIS game's camera (see GATE_* below): the
rig is ORTHOGRAPHIC (godot/scripts/camera_rig.gd), size 30 m at PX_PER_M=24
with the eye at offset (0, 37.6, 13.7) = pitch 20 deg off straight-down
(docs/DESIGN-3D.md §a, docs/DOD-ACCEPTANCE.md A8), and the player model is
MODEL_H_PLAYER=1.67 m (godot/scripts/horde_viz.gd:32) — so a hero paints about
40 px tall, which is what sizes the mask canvas.

DETERMINISM. Fixed views, framing derived from the SHARED bounds box, stable
argsort, no RNG anywhere in the mask path: two runs on one mesh are
byte-equal (asserted in tests/test_art_visibility_gate.py and by --selftest
leg 5).

HONEST LIMITS — this mask is a CONSERVATIVE OUTER-VISIBILITY CLAIM, not a
proof of invisibility. What could still expose a hole:
  * SAMPLING GAPS: a face visible only inside a yaw window narrower than
    22.5 deg, or an elevation window narrower than ~15 deg (a hairline gap
    between two plates), is missed and deleted. KEEP_RING rescues only the one
    face-layer touching a visible face.
  * PROJECTION MODEL: the declared set is the game's orthographic projection
    plus two perspective rings. An extreme close-up (eye nearer than
    1.15 x the bounding sphere) or a camera INSIDE a garment/mantle cavity is
    outside the set and will see faces this mask deletes.
  * DEPTH ORDER: the CPU rasterizer is centroid painter's, not a z-buffer, so
    interpenetrating triangles can mis-order; a face only ever covered by a
    mis-ordered neighbour is deleted. One dilation ring is the mitigation, a
    real z-buffer (bpy/GPU leg) is the upgrade path.
  * EDGE TIE-BREAKS: a shared triangle edge resolves to one owner per pixel,
    so a face visible only along an edge can go; its neighbour stays, so the
    surface still reads solid at that edge.
  * DEFORMATION: cloth/physics/skinning that moves the outer skin exposes what
    is hidden today. Nothing models that (this game ships rigid models with
    baked animation, docs/3DR-SPEC.md §a).
  * BAKED-TEXTURE OPTICS: the repo declares no mirror and no reflection —
    class_mesh.gd:94 lands metallic=0 precisely because a reflection probe
    renders black, horde_viz.gd:129 runs "no real-time shadow pass", and
    "flash" is a VFX ring (viz_fx.gd:66-73). If a mirror / SSR ever ships, the
    declared view set must grow with it or that reflection shows a hole.
  * YIELD: at the ship rung the double skin is already welded by budget
    decimation (the MC 12337 finding), so the honest yield on the SHIPPED
    emberwright is 0.70 % of faces WITH the 1-ring, 3.0 % without it. The
    value of this rule is that it cannot eat visible skin; the yield row is a
    MEASUREMENT, never a gate.
  * KEEP_RING IS INSURANCE, NOT A PROVEN CONTROL: mutating it to 0 leaves all
    six legs GREEN (measured — removed 225 -> 116 faces at 512 px on the
    shipped asset, every rescued face edge-adjacent to visible skin). It stays
    because the rasterizer's error class is one pixel wide and sits at depth
    discontinuities, i.e. exactly on the interfaces whose deletion MC 12345
    REJECTED; the upgrade path that would let it go to 0 is a z-buffer
    rasterizer (bpy/GPU leg), not another threshold.

CONTROLS: `--selftest` runs the six legs in tools/art/visibility_controls.py
(nested shells / PAINTED OPEN CUP — the 12345 killer / limb-interface proxy /
punched-gap-window planted-bad / determinism / shipped-file roundtrip) and
exits 0 only on PASS x6. trellis_bake_wrap refuses a --strip-v2 bake on a red
contract (the MC 12334 calibration law, carried).

USAGE:
  visibility_strip.py --selftest
  visibility_strip.py <in.glb> <out.glb>    # GLB charts welded before reading
"""
import os
import sys
import argparse

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import render_parity as rp                      # the ONE CPU rasterizer

# --- the declared camera set (every number justified in visible_gate_views) --
GATE_RES = 512
GATE_YAWS = 16
GATE_ELEVS = (-60, -20, 10, 26, 45, 70, 90)
GATE_CLOSE_SPHERE_MULT = 1.15        # perspective eye distance, x bounding-
GATE_CLOSE_YAWS = 8                  #   sphere radius (provably outside every
GATE_CLOSE_ELEVS = (20, 70)          #   vertex; closer than any declared cam)
GATE_TURNTABLE_SPAN_MULT = 2.6       # the capture camera's own distance,
GATE_TURNTABLE_YAWS = 8              #   x max bbox extent (dump_render.py:43)
GATE_TURNTABLE_ELEV = 26
KEEP_RING = 1

# Leg 6 of the contract reads the SHIPPED asset — read-only (the 16-hold law
# forbids writing to godot/assets/, and nothing in this module ever does).
REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SHIPPED_GLB = os.path.join(REPO, "godot", "assets", "glb", "char-emberwright.glb")


def welded_edge_pairs(mesh):
    """Face pairs sharing an EDGE after welding duplicate vertex POSITIONS.
    GLB UV charts split a topologically-one mesh (the interior_probe stack
    truth), so trimesh's own face_adjacency under-reads adjacency at every UV
    seam — and under-reading here means under-dilating, i.e. deleting a skin
    face next to a hole. Positions are rounded to 1e-9 (grid noise floor); the
    weld is a READING of the mesh, never a mutation of it."""
    _, inv = np.unique(np.round(mesh.vertices, 9), axis=0, return_inverse=True)
    wf = inv[mesh.faces]
    fidx = np.repeat(np.arange(len(wf), dtype=np.int64), 3)
    va = wf[:, [0, 1, 2]].reshape(-1)
    vb = wf[:, [1, 2, 0]].reshape(-1)
    a, b = np.minimum(va, vb), np.maximum(va, vb)
    o = np.lexsort((b, a))
    a, b, fidx = a[o], b[o], fidx[o]
    same = (a[1:] == a[:-1]) & (b[1:] == b[:-1])
    return fidx[:-1][same], fidx[1:][same]


def visible_gate_views(mesh):
    """THE DECLARED CAMERA SET — the rule can only ever claim invisibility
    against this list, so this function IS the rule's reach.

    (yaw_deg, elev_deg, dist); dist=None is orthographic, which is what the
    GAME uses (camera_rig.gd sets PROJECTION_ORTHOGONAL, so the in-game eye
    distance 40 m does not change which faces are visible at all — only its
    20-deg pitch does, and that is the 70-deg elevation band: in the Z-up mesh
    frame the offset (0, 37.6, 13.7) sits 70 deg above the mesh plane).
    GATE_RES=512 sizes the canvas: the hero paints ~40 px tall in-game
    (30 m ortho size, PX_PER_M=24, a 1.67 m model), so 512 px is ~13x the
    linear detail the game can resolve — every sliver the game merges into one
    pixel still owns a pixel of the mask, which is the safe direction
    (measured on the shipped emberwright: 354/7891 faces removable at 256 px,
    245/7891 at 512 px). The 0.95 IoU parity floor stays on its own matched
    256-px canvas (calibrated on MC 12339's 0.741/0.803) — untouched here.
    16 yaws = 22.5 deg: the hero pawn yaws continuously (hero_pawn.gd) so
    every yaw is a live view and the union keeps anything visible anywhere.
    The perspective rings cost ~1 s each and are pure insurance. Note the
    GEOMETRY honestly: for a CONVEX shell a nearer eye sees strictly LESS (the
    silhouette rim turns away as the eye approaches — the parallel-ray sphere
    is the superset there), so a close ring is not "more conservative" by
    itself. What it buys is the CONCAVE case: a divergent bundle reaches a
    lining through an opening at angles a parallel bundle never does (the
    cup-lining mechanism of MC 12345), and the turntable ring is the very
    camera the render-parity gate looks through, so the mask can never delete
    a face that gate is about to judge. Measured on the shipped emberwright
    (512 px): the orthographic sphere alone leaves 235 removable faces, +close
    ring 225, +turntable 225 — the rings buy 10 faces of kept skin."""
    lo, hi = mesh.bounds
    span = float((hi - lo).max())
    r_bs = float(np.linalg.norm(hi - lo)) / 2.0
    views = [(y * 360.0 / GATE_YAWS, e, None)
             for e in GATE_ELEVS for y in range(GATE_YAWS)]
    views += [(y * 360.0 / GATE_CLOSE_YAWS, e, GATE_CLOSE_SPHERE_MULT * r_bs)
              for e in GATE_CLOSE_ELEVS for y in range(GATE_CLOSE_YAWS)]
    views += [(y * 360.0 / GATE_TURNTABLE_YAWS, GATE_TURNTABLE_ELEV,
               GATE_TURNTABLE_SPAN_MULT * span)
              for y in range(GATE_TURNTABLE_YAWS)]
    return views


def visible_face_mask(mesh, size=GATE_RES, views=None):
    """bool array over mesh.faces: True = KEEP (visible from at least one
    declared view, or edge-adjacent to a face that is)."""
    views = visible_gate_views(mesh) if views is None else views
    bounds = mesh.bounds
    seen = np.zeros(len(mesh.faces), dtype=bool)
    for (yaw, elev, dist) in views:
        ids = np.unique(rp.face_id_buffer(mesh, size, yaw, elev, dist, bounds))
        seen[ids[ids > 0] - 1] = True
        if seen.all():                       # nothing left to prove; same mask
            break
    ea, eb = welded_edge_pairs(mesh)
    for _ in range(KEEP_RING):
        ring = np.zeros(len(seen), dtype=bool)
        touch = seen[ea] ^ seen[eb]          # an edge with one visible side
        ring[eb[touch]] = True
        ring[ea[touch]] = True
        seen |= ring
    return seen


def strip_invisible(mesh):
    """(kept_mesh, removed_ratio). PURE GEOMETRY — face removal only, so UVs
    and material on kept faces ride trimesh's own face_visual bookkeeping: the
    same update_faces + update_vertices mechanism commit ae5b13e's UV-parity
    test pins for strip_roof (whose roof RULE stays untouched on this card).
    Kept-face ORDER is preserved, so original_id = flatnonzero(keep)[kept_id].
    The CALLER owns the calibration contract (trellis_bake_wrap refuses a
    --strip-v2 bake on a red --selftest; the CLI does the same) — this function
    stays pure so a control leg can call it without recursing into itself."""
    keep = visible_face_mask(mesh)
    out = mesh.copy()
    out.update_faces(keep)
    used = np.zeros(len(mesh.vertices), dtype=bool)
    used[out.faces] = True
    out.update_vertices(used)
    return out, float(1.0 - keep.mean())


if __name__ == "__main__":
    from visibility_controls import controls
    from interior_probe import load_merged

    ap = argparse.ArgumentParser(
        description="visibility-restricted strip (GATE-INT-V4, MC 12352)")
    ap.add_argument("files", nargs="*")
    ap.add_argument("--selftest", action="store_true",
                    help="run the six gate controls; exit 0 on PASS x6")
    a = ap.parse_args()
    if a.selftest:
        sys.exit(controls())
    src, dst = a.files[0], a.files[1]
    if controls() != 0:                      # never delete on an uncalibrated
        sys.exit(2)                          #   mask (MC 12334 law, carried)
    m = load_merged(src)                     # weld the UV charts (stack truth)
    out, rr = strip_invisible(m)
    out.export(dst)
    print(f"EXPORTED {dst} faces {len(m.faces)} -> {len(out.faces)} "
          f"removed_ratio={rr:.4f} bytes={os.path.getsize(dst)}", flush=True)
