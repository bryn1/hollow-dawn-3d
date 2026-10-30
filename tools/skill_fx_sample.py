#!/usr/bin/env python3
"""SKILL_FX icon sampler (MC 11705 T-M6f, M6-SPEC §2.1) — the ONE method.

The spec law: "Colors are SAMPLED from the shipped icon PNGs (icon-<id>.png
— the owner's stated reference) at card time with the sampling row printed
into the capture (centre-weighted mean of the icon's dominant non-bg pixel,
OUR method, the values pinned in the table)". This file IS the method — the
capture leg prints these rows and tests/test_skill_fx.py imports this file
and re-derives every table colour from the PNGs (the drift class: a
hand-typed table value REDs against the sampler, FX-E2's planted red).

Method, stated exactly (deterministic, no RNG):
  1. fg = RGBA pixels with alpha >= 128, dropping near-black outline pixels
     (max channel < 60 — the baked icons all ink near-black edges; the
     OWNER's reference is the icon's COLOUR, not its linework).
  2. dominant non-bg cluster = the 32-wide RGB bucket maximising
     sum(max-min) over its fg pixels (the most-coloured body of the icon;
     ties break on count, then the bucket key — a total order).
  3. centre-weighted, saturation-weighted mean over that cluster:
     weight = (alpha/255) * (1 - 0.6 * dist/centre-to-corner) *
              (0.15 + 3 * sat), sat = (max-min)/255.
  4. declared LOOK LIFT: additive FX read dark on the ground; the sampled
     mean is stretched about its Rec.601 luminance by K = 1.5 (a monotone
     chroma lift — the SAME constant for every row, hue/order preserved),
     clamped to [0, 1], rounded to 3 decimals — the pinned table value.

Usage:  python3 tools/skill_fx_sample.py            # rows for the capture
        python3 tools/skill_fx_sample.py --json     # machine rows
Env:    HD3D_ICONS (icons dir override; default <repo>/godot/assets/icons)
"""
import json
import math
import os
import sys

from PIL import Image

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ICONS = os.environ.get("HD3D_ICONS",
                       os.path.join(REPO, "godot", "assets", "icons"))

# The 26 SKILL_FX row ids in table order: 15 weapon-side (weapons.gd IDS,
# doom-sigil RETIRED weapon-side per §4.1 — the icon file KEEPS, the row
# does not exist), the 9 LIVE evolved ids (evolutions.gd TABLE evo column —
# pale-moon retired at T-M6p, §4.4 R2: DEAD-as-fireable, the declared
# fallback row the pin EXCLUDES, named in M6-SPEC §2.2 FX-E2), and the 2
# union orbiters (union.gd TABLE). tests/test_skill_fx.py re-derives this
# list from the GD tables themselves; the literal here is only the default
# sampling order.
IDS = ["talon", "ember", "cleaver", "halo", "ward", "spike",
       "bone-whip", "dart-loop", "hewn-axe", "pilgrim-cross",
       "censer-of-hours", "rot-water", "spectral-disc", "storm-peal",
       "fire-lash",
       "red-wail", "thousand-darts", "rot-spiral", "judgement-cross",
       "eternal-matins", "the-sluice", "grave-orbit", "rolling-thunder",
       "inferno-lash",
       "requiem-toll", "dirge-eternal"]

LIFT_K = 1.5

# READABILITY FLOOR (T-M6f, measured against the strips pixel-truth gate):
# a row's colour is also scaled UP (never down) so its PEAK contribution at
# its class alpha clears the gate's luma threshold with margin:
# alpha(cls) * luma(colour) >= READ_FLOOR (0.22 vs DIFF_THRESH 0.10).
# Without it the dark sampled teals/greens are physically incapable of the
# strips baseline diff (ward max_delta 0.0608, talon 0.1 exactly — RED is
# DETERMINISTIC, not pacing), i.e. an invisible attack look — the very thing
# the owner's F2 clause bans. Hue and row order are preserved; channels
# clamp at the ceiling (rot-water/bone-whip/red-wail/storm-peal clip one
# channel — declared). alpha(cls) is the writer's per-class fade alpha at
# fresh life (viz_fx.gd, verbatim): arcs .35, rings .25, bursts .6,
# bolts/throws/halos 1.0.
READ_FLOOR = 0.22
CLASS_ALPHA = {"arcs": 0.35, "rings": 0.25, "bursts": 0.6,
               "bolts": 1.0, "throws": 1.0, "halos": 1.0}
ID_CLS = {"talon": "arcs", "bone-whip": "arcs", "red-wail": "arcs",
          "ward": "rings", "rot-water": "rings", "the-sluice": "rings",
          "dirge-eternal": "rings",
          "spike": "bursts", "storm-peal": "bursts",
          "rolling-thunder": "bursts",
          "ember": "bolts", "dart-loop": "bolts", "censer-of-hours": "bolts",
          "spectral-disc": "bolts", "fire-lash": "bolts",
          "thousand-darts": "bolts", "eternal-matins": "bolts",
          "grave-orbit": "bolts", "inferno-lash": "bolts",
          "cleaver": "throws", "hewn-axe": "throws",
          "pilgrim-cross": "throws", "rot-spiral": "throws",
          "judgement-cross": "throws",
          "halo": "halos", "requiem-toll": "halos"}


def lift(col, cls):
    """declared lift (chroma stretch K=1.5) + readability floor, clamped."""
    lum = 0.2126 * col[0] + 0.7152 * col[1] + 0.0722 * col[2]
    c = [lum + (v - lum) * LIFT_K for v in col]
    lum2 = 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]
    contrib = CLASS_ALPHA.get(cls, 1.0) * lum2
    if contrib < READ_FLOOR and lum2 > 1e-9:
        c = [v * (READ_FLOOR / contrib) for v in c]
    return tuple(round(min(1.0, max(0.0, v)), 3) for v in c)


def sample_icon(path, cls=None):
    """The §2.1 sampling method — see the header. Returns (r, g, b) floats
    in [0, 1], 3-decimal rounded: the value the SKILL_FX table pins."""
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    px = im.load()
    cx, cy = (w - 1) / 2.0, (h - 1) / 2.0
    dmax = math.hypot(cx, cy)
    hist = {}
    pix = []
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 128:
                continue
            mx, mn = max(r, g, b), min(r, g, b)
            if mx < 60:
                continue
            key = (r >> 5, g >> 5, b >> 5)
            cell = hist.setdefault(key, [0, 0.0])
            cell[0] += 1
            cell[1] += mx - mn
            pix.append((x, y, r, g, b, a))
    assert pix, "icon %s has no non-bg pixels" % path
    dom = max(hist, key=lambda k: (hist[k][1], hist[k][0], k))
    sw = sg = sb = ss = 0.0
    for x, y, r, g, b, a in pix:
        if (r >> 5, g >> 5, b >> 5) != dom:
            continue
        d = math.hypot(x - cx, y - cy) / dmax
        sat = (max(r, g, b) - min(r, g, b)) / 255.0
        wgt = (a / 255.0) * (1.0 - 0.6 * d) * (0.15 + 3.0 * sat)
        sw += r * wgt
        sg += g * wgt
        sb += b * wgt
        ss += wgt
    c = [sw / ss / 255.0, sg / ss / 255.0, sb / ss / 255.0]
    if cls is None: # derive the row's class from the shipped icon filename
        cls = ID_CLS.get(os.path.basename(path)[len("icon-"):-len(".png")],
                         "bolts")
    return lift(c, cls)


def main():
    as_json = "--json" in sys.argv
    ids = sys.argv[1:] if not as_json else [
        a for a in sys.argv[1:] if not a.startswith("--")] or IDS
    rows = []
    for i in (ids or IDS):
        path = os.path.join(ICONS, "icon-%s.png" % i)
        assert os.path.exists(path), "no shipped icon for row id %r" % i
        rgb = sample_icon(path)
        rows.append({"id": i, "color": list(rgb)})
    if as_json:
        print(json.dumps(rows))
    else:
        print("SKILL_FX icon sampling (§2.1, method tools/skill_fx_sample.py)")
        for r in rows:
            c = r["color"]
            print("  %-18s (%.3f, %.3f, %.3f)" % (r["id"], c[0], c[1], c[2]))


if __name__ == "__main__":
    main()
