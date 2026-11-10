#!/usr/bin/env python3
"""GATE-INT-V4 CONTROLS: the six fixtures + the --selftest contract that prove
the visibility rule (tools/art/visibility_strip.py) CAN do the right thing.

One concern per file: this module owns FIXTURES and VERDICTS, the rule module
owns the mask. pytest (tests/test_art_visibility_gate.py) imports the same
fixtures from here, so there is ONE fixture set — the MC 12338 lesson (a
control that only proves one rung proves half the law) generalises to: a rule
and its selftest must never disagree about what the fixture was.

The legs:
  1 nested shells        inner shell invisible -> removed; outer untouched;
                         ratio ~0.5 (the rule still WORKS on real double skin)
  2 PAINTED OPEN CUP     the MC 12345 killer. The lining is painted, visible
                         from above through the mouth -> NOTHING in an open cup
                         is provably invisible, so the correct answer here is
                         removed_ratio ~0. If this leg goes red the rule is
                         back to eating visible skin.
  3 limb-interface proxy torus through a sphere body: the body skin OUTSIDE
                         the limb (the interface ring) is untouched, and three
                         HELD-OUT views (not in the declared set) render the
                         stripped mesh with a pixel-identical silhouette.
  4 punched gap window   PLANTED-BAD leg (fleet law: a control that has never
                         gone red is not a control). Same faces as leg 1 —
                         which the mask DOES delete behind a closed shell —
                         seen through a window punched in that shell: they must
                         flip to KEPT. A rule blind to a hole keeps deleting
                         them, which is exactly the 12345 failure class.
  5 determinism          same mesh, two runs, byte-equal masks (no RNG).
  6 shipped-file GLB     godot/assets/glb/char-emberwright.glb roundtrip: kept
                         faces carry UNMUTATED UVs (f32-tolerant, the ae5b13e
                         idiom) and the removed ratio is sane. Read-only: the
                         shipped bytes are never written (16-hold law).

Usage:  visibility_controls.py          (same as visibility_strip --selftest)
"""
import os
import sys
import time

import numpy as np
import trimesh
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import render_parity as rp
from interior_probe import cup_fixture
from visibility_strip import SHIPPED_GLB, strip_invisible, visible_face_mask

# HELD-OUT views for leg 3: inside the declared yaw/elev gaps (22.5-deg yaw
# step) — a strip that survives views it was never fitted to is the claim.
HELD_OUT_VIEWS = ((11.25, 70), (190.0, 26), (300.0, -20))


def paint(m, rgb):
    """A real uv layer + material, so 'painted lining' is a UV claim a test can
    check row-by-row and not a word in a docstring."""
    v = m.vertices
    uv = np.stack([0.5 + np.arctan2(v[:, 1], v[:, 0]) / (2 * np.pi),
                   0.5 + np.arcsin(np.clip(v[:, 2], -1, 1)) / np.pi], axis=1)
    m.visual = trimesh.visual.TextureVisuals(
        uv=uv, material=trimesh.visual.material.SimpleMaterial(
            image=Image.new("RGB", (8, 8), tuple(int(c) for c in rgb))))
    return m


def gate_fixtures():
    """The six legs' meshes. 'cup-painted' reuses the interior_probe parametric
    cup (the SAME welded double-wall fixture the roof-rule contract uses —
    no second cup) and paints it; 'limb-proxy' is the MC 12345 interface class.
    Layout note for both: trimesh.util.concatenate keeps component order, so
    the first len(inner) faces are the inner/first component."""
    inner_n = len(trimesh.creation.icosphere(3).faces)
    nested = trimesh.util.concatenate([
        trimesh.creation.icosphere(3),
        trimesh.creation.icosphere(3, radius=0.95)])
    body = trimesh.creation.icosphere(3, radius=1.0)
    limb = trimesh.creation.torus(major_radius=1.0, minor_radius=0.3)
    limb.apply_translation([0.0, 0.0, 0.35])
    return {"nested": nested, "inner-n": inner_n,
            "cup-painted": paint(cup_fixture(), (200, 30, 30)),
            "limb-proxy": trimesh.util.concatenate([body, limb])}


def cup_lining_faces(cup):
    """The painted LINING: wall faces inside the outer boundary and above the
    floor — the class of face whose deletion made MC 12345 a REJECT."""
    C, N = cup.triangles_center, cup.face_normals
    rad = np.maximum(np.abs(C[:, 0] - 0.5), np.abs(C[:, 1] - 0.5))
    return (rad < 0.5 - 0.01) & (np.abs(N[:, 2]) < 0.5) & (C[:, 2] > 0.04)


def limb_skin_faces(proxy, body_n=1280):
    """Body skin OUTSIDE the limb tube: the visible ring around a limb-root
    interface (12345's other killer)."""
    C = proxy.triangles_center
    tube = np.hypot(np.hypot(C[:, 0], C[:, 1]) - 1.0, C[:, 2] - 0.35)
    return (np.arange(len(proxy.faces)) < body_n) & (tube > 0.3 + 0.06)


def kept_faces(mesh, keep):
    """The preserve_visual mechanism, once, for the legs that render the
    result (same call pair strip_invisible makes)."""
    out = mesh.copy()
    out.update_faces(keep)
    used = np.zeros(len(mesh.vertices), dtype=bool)
    used[out.faces] = True
    out.update_vertices(used)
    return out


def punched_window(nested, half=0.35):
    """Planted-bad control: a WINDOW punched in the -X side of the OUTER shell.
    The inner faces behind it become visible THROUGH the gap; a rule that
    cannot see through a hole deletes them and goes red."""
    m = nested.copy()
    C = m.triangles_center
    keep = window_footprint(C, half) & (np.linalg.norm(C, axis=1) > 0.99)
    m.update_faces(~keep)                    # OUTER shell only: the lining
    used = np.zeros(len(m.vertices), dtype=bool)   # must stay behind the hole
    used[m.faces] = True
    m.update_vertices(used)
    return m, int(keep.sum())


def window_interior_faces(mesh, half=0.35):
    """Faces sitting in the window's COLUMN — and INSIDE the outer shell (an
    icosphere(3) face center is at r~0.998, the inner shell's at r~0.948, so
    the 0.99 cut separates the two cleanly). In the CLOSED fixture this is
    exactly the patch the mask deletes; through the window it must be kept."""
    C = mesh.triangles_center
    return window_footprint(C, half) & (np.linalg.norm(C, axis=1) < 0.99)


def window_footprint(C, half):
    """The punched column: -X cap, |y| and |z| within `half` of the axis."""
    return (C[:, 0] < -1.0 + half) & (np.abs(C[:, 1]) < half) \
        & (np.abs(C[:, 2]) < half)


def controls():
    """exit 0 == PASS x6; anything else and nothing may delete geometry."""
    ok, n, t0 = True, 0, time.time()

    def leg(name, good, detail):
        nonlocal ok, n
        print(f"CONTROL {name}: {detail} -> {'PASS' if good else 'FAIL'}",
              flush=True)
        if good:
            n += 1
        else:
            ok = False

    fx = gate_fixtures()

    m = visible_face_mask(fx["nested"])
    inner = np.arange(m.size) >= m.size - fx["inner-n"]
    ratio = float(1.0 - m.mean())
    leg("1-nested-shells", m[inner].sum() == 0 and m[~inner].all()
        and 0.4 < ratio < 0.6,
        f"inner kept={int(m[inner].sum())}/{int(inner.sum())} outer "
        f"kept={int(m[~inner].sum())}/{int((~inner).sum())} ratio={ratio:.3f}")

    cup = fx["cup-painted"]
    mc = visible_face_mask(cup)
    lin = cup_lining_faces(cup)
    leg("2-open-cup-painted-lining", bool(mc[lin].all())
        and (1.0 - mc.mean()) < 0.02,
        f"lining kept={int(mc[lin].sum())}/{int(lin.sum())} "
        f"(the 12345 killer) removed_ratio={1.0 - mc.mean():.4f}")

    px = fx["limb-proxy"]
    mp = visible_face_mask(px)
    skin = limb_skin_faces(px, body_n=fx["inner-n"])
    kept = kept_faces(px, mp)
    dpx = max(int((rp.silhouette(px, 256, y, e)
                   != rp.silhouette(kept, 256, y, e)).sum())
              for (y, e) in HELD_OUT_VIEWS)
    leg("3-limb-interface-proxy", int(mp[skin].sum()) == int(skin.sum())
        and dpx == 0,
        f"skin kept={int(mp[skin].sum())}/{int(skin.sum())} removed_ratio="
        f"{1.0 - mp.mean():.4f} held-out silhouette diff px={dpx}")

    closed = fx["nested"]
    hidden_closed = window_interior_faces(closed)
    win, punched = punched_window(closed)
    mw = visible_face_mask(win)
    hidden_open = window_interior_faces(win)
    leg("4-gap-window-planted-bad",
        int(m[hidden_closed].sum()) == 0 and bool(mw[hidden_open].all()),
        f"same patch: closed shell deleted={int((~m[hidden_closed]).sum())}/"
        f"{int(hidden_closed.sum())} -> through a {punched}-face window "
        f"kept={int(mw[hidden_open].sum())}/{int(hidden_open.sum())} "
        f"(blind to the hole = the 12345 class, and this leg goes RED for it)")

    leg("5-determinism", visible_face_mask(cup).tobytes()
        == visible_face_mask(cup).tobytes(), "two runs byte-equal")

    sh = trimesh.load(SHIPPED_GLB, force="mesh", process=False)
    orig_uv = np.asarray(sh.visual.uv[sh.faces], dtype=np.float32).copy()
    out, rr = strip_invisible(sh)
    keys = {tuple(np.round(np.asarray(t, np.float64), 5).ravel())
            for t in orig_uv}
    pure = all(tuple(np.round(np.asarray(t, np.float64), 5).ravel()) in keys
               for t in out.visual.uv[out.faces])
    leg("6-shipped-file-roundtrip", pure and hasattr(out.visual, "uv")
        and len(out.visual.uv) > 0 and 0.0 < rr < 0.35,
        f"{os.path.basename(SHIPPED_GLB)} faces={len(sh.faces)} "
        f"removed_ratio={rr:.4f} kept-face UVs unmutated={pure} "
        f"(f32-tolerant, ae5b13e idiom)")

    print(f"VISIBLE-GATE CONTROLS: {'PASS' if ok else 'FAIL'} x{n}/6 "
          f"in {time.time() - t0:.0f}s", flush=True)
    return 0 if ok else 2


if __name__ == "__main__":
    sys.exit(controls())
