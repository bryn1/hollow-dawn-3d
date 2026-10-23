#!/usr/bin/env python3
"""T-M1e chest-open acceptance gate (MC 11209).

Roadmap feature 5 ACCEPT, verbatim: "chest-open shot assets/screens/
m1-chest.png non-bg pixels >= 200 vs empty baseline". The capture is the
TICK-DETERMINISTIC harness godot/sim/chest_capture.gd (the MC 11191
mechanism reused, no second harness — see its header for the declared
deviations). The baseline is the SAME ticked state with world.chests
cleared (the S8 hidden-UI pattern), so every non-equal pixel between the
two frames IS the chest's draw — the gate counts those pixels whose max
channel delta from the baseline exceeds DELTA in the CHEST window (the
capture's projected centre +/- WIN_HALF px) and GREENs at >= 200. A
baseline-vs-baseline copy scores 0 — this is the shape the planted-red run
exercises.

Usage:  python3 tools/chest_pixel_gate.py             # capture + gate
        python3 tools/chest_pixel_gate.py --gate DIR  # gate a shot dir
                                                  # (carries rows.json;
                                                  # planted-mutation copy
                                                  # for the RED proof)
Env:    HD3D_GODOT (godot binary), HD3D_SEED (capture seed, default 11209).
Exit:   0 green, 1 red.
"""
import json
import os
import subprocess
import sys

import numpy as np
from PIL import Image

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GODOT = os.environ.get(
    "HD3D_GODOT",
    "/home/claudecode/Games/.tools/godot/Godot_v4.7.2-stable_linux.x86_64")
SHOTS_DIR = os.path.join(REPO, ".tmp", "chest-shots")
SCRIPT = "res://sim/chest_capture.gd"
CHEST_PNG = "m1-chest.png"
BASE_PNG = "m1-chest-baseline.png"
WIN_HALF = 40        # 80x80 window on the projected chest centre
DELTA = 12           # per-pixel max-channel delta that counts as a drawn px
PX_MIN = 200         # roadmap floor, verbatim


def capture():
    env = dict(os.environ, HD3D_CHEST_SHOTS_DIR=SHOTS_DIR)
    r = subprocess.run(["xvfb-run", "-a", GODOT, "--render-driver", "opengl3",
                        "--path", "godot", "-s", SCRIPT],
                       cwd=REPO, env=env, capture_output=True, text=True,
                       timeout=900)
    print(r.stdout[-4000:])
    if "CAPTURE_OK" not in r.stdout or r.returncode != 0:
        print(r.stderr[-2000:])
        sys.exit(1)


def gate(dir_path):
    rows = json.load(open(os.path.join(dir_path, "rows.json")))
    row = rows[0]
    assert row["leg"] == "chest_shot"
    ok = True
    if not row["in_frame"]:
        print("FAIL chest projected outside the frame: %s" % row)
        ok = False
    chest = np.asarray(Image.open(
        os.path.join(dir_path, CHEST_PNG)).convert("RGB"), dtype=np.int16)
    base = np.asarray(Image.open(
        os.path.join(dir_path, BASE_PNG)).convert("RGB"), dtype=np.int16)
    if chest.shape != base.shape:
        print("FAIL shot/baseline shape mismatch %s vs %s"
              % (chest.shape, base.shape))
        sys.exit(1)
    cx, cy = int(round(row["cx"])), int(round(row["cy"]))
    x0, x1 = max(cx - WIN_HALF, 0), min(cx + WIN_HALF, chest.shape[1])
    y0, y1 = max(cy - WIN_HALF, 0), min(cy + WIN_HALF, chest.shape[0])
    diff = np.abs(chest - base).max(axis=2)
    win_px = int((diff[y0:y1, x0:x1] > DELTA).sum())
    total_px = int((diff > DELTA).sum())
    state_ok = win_px >= PX_MIN
    print("CHEST-WINDOW leg=%s cx=%d cy=%d window=[%d:%d,%d:%d] "
          "non-bg_px=%d (floor %d) frame-wide_diff=%d %s" % (
              row["leg"], cx, cy, x0, x1, y0, y1, win_px, PX_MIN, total_px,
              "PASS" if state_ok else "FAIL"))
    return ok and state_ok


def main():
    if len(sys.argv) >= 3 and sys.argv[1] == "--gate":
        sys.exit(0 if gate(sys.argv[2]) else 1)
    capture()
    sys.exit(0 if gate(SHOTS_DIR) else 1)


if __name__ == "__main__":
    main()
