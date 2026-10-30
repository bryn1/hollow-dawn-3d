#!/usr/bin/env python3
"""T-M2g BULK-GEM row (MC 11238, M2-SPEC rev-2 C-G4) — moved OUT of
tools/upgrades_visual_probe.py at T-M6q2 (MC 11711, audit-4 §1.2 option
(a), the split AT THE AUDIT'S NAMED SEAM; sibling of
upgrades_visual_skill_fx.py, disjoint consumers: tests/test_gem_merge.py
judges THIS section). The CLI stays in the probe:
    python3 tools/upgrades_visual_probe.py --bulk       # capture + gate
    python3 tools/upgrades_visual_probe.py --bulk DIR   # gate a shot dir
(real or planted-mutation copy — carries rows.json) — entry points only
wire; the BULK constants and gate live HERE (the T-S18 probe mechanism
EXTENDED, no new capture mechanism — audit-4 §1.2 moved the section, the
card that grew +151 into one MIXED file left it unpinnable there).

The bulk gem the REAL merge drew (godot/sim/gemmerge_capture.gd — the
chest_capture TICK-deterministic recipe REUSED, no new capture mechanism;
baseline = the SAME ticked state with bulk cleared, the S8 hidden-UI
pattern). Two crops on the GEMMERGE row's centre, both round +-BULK_WIN
windows on the projected centre (the existing window law):
  * DELTA px  — pixels whose max-channel difference from the baseline
    beats BULK_DELTA: the bulk's DRAWN footprint. Measured separations on
    T-M2g's shots: a 28 px bulk quad = 588 px, a 14 px normal-gem quad =
    ~147 px, bulk suppressed = 0 px.
  * PALETTE px — the Table-1 mechanism over the shot: brighter ICHOR
    measured (153,244,93) = GEM_BULK_TINT x the gem material
    (pickup_viz.gd); the NORMAL gem's g~200 and the grass flecks' g~137
    both fail g >= 220 — only a bulk passes, so this crop IS the
    "brighter" half of the row.
The floor is OUR number 200 px on BOTH crops — the repo's shot-floor
family (m1-chest's "non-bg pixels >= 200 vs empty baseline"); measured
headroom is 2.9x and BOTH a bulk suppressed to ground AND a bulk that
forgot to grow or forgot to brighten score at or below it — the C-G4 red
column. Baseline-vs-itself (the planted-mutation copy) scores 0 on both.
"""
import json
import os
import sys

import numpy as np
from PIL import Image

import capture_lib

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

BULK_DIR = os.path.join(REPO, ".tmp", "gemmerge-shots")
BULK_SCRIPT = "res://sim/gemmerge_capture.gd"
BULK_PNG = "m2-gemmerge.png"
BULK_BASE_PNG = "m2-gemmerge-baseline.png"
BULK_WIN = 40 # round crop radius on the projected centre (px)
BULK_DELTA = 12 # per-pixel max-channel delta class (chest-gate family)
BULK_PX_MIN = 200 # OUR floor per crop row (header: measured, floor family)


def _bulk_green(r, g, b): # bulk ICHOR (material x GEM_BULK_TINT, measured)
    return (g >= 220) & (g >= r + 45) & (g >= b + 70)


def bulk_capture():
    os.makedirs(BULK_DIR, exist_ok=True)
    r = capture_lib.run_capture(BULK_SCRIPT, {"HD3D_GM_SHOTS_DIR": BULK_DIR})
    print(r.stdout[-2000:])
    if "CAPTURE_OK" not in r.stdout or r.returncode != 0:
        print(r.stderr[-2000:])
        sys.exit("CAPTURE FAILED (no CAPTURE_OK from %s)" % BULK_SCRIPT)


def bulk_gate(dir_path):
    with open(os.path.join(dir_path, "rows.json")) as fh:
        row = json.load(fh)[0]
    assert row["leg"] == "bulk_gem_shot"
    ok = True
    if not row["in_frame"]:
        print("FAIL bulk projected outside the frame: %s" % row)
        ok = False
    shot = np.asarray(Image.open(os.path.join(dir_path, BULK_PNG))
                      .convert("RGB"), dtype=np.int16)
    base = np.asarray(Image.open(os.path.join(dir_path, BULK_BASE_PNG))
                      .convert("RGB"), dtype=np.int16)
    if shot.shape != base.shape:
        sys.exit("%s: shot/baseline shape mismatch %s vs %s"
                 % (dir_path, shot.shape, base.shape))
    cx, cy = int(round(row["cx"])), int(round(row["cy"]))
    x0, y0 = max(cx - BULK_WIN, 0), max(cy - BULK_WIN, 0)
    x1 = min(cx + BULK_WIN + 1, shot.shape[1])
    y1 = min(cy + BULK_WIN + 1, shot.shape[0])
    yy, xx = np.mgrid[y0:y1, x0:x1]
    win = np.hypot(xx - cx, yy - cy) <= BULK_WIN
    diff = np.abs(shot - base).max(axis=2)[y0:y1, x0:x1]
    delta_px = int((win & (diff > BULK_DELTA)).sum())
    w = shot[y0:y1, x0:x1].astype(np.float64)
    pal_px = int((win & _bulk_green(w[..., 0], w[..., 1], w[..., 2])).sum())
    green = delta_px >= BULK_PX_MIN and pal_px >= BULK_PX_MIN
    print("BULK-GEM leg=%s cx=%d cy=%d delta_px=%d palette_px=%d "
          "(floor %d each) %s" % (row["leg"], cx, cy, delta_px, pal_px,
                                  BULK_PX_MIN, "GREEN" if green else "RED"))
    return ok and green
