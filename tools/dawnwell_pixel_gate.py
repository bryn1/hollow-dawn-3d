#!/usr/bin/env python3
"""T-M1f Dawn Well shop acceptance gate (MC 11210).

Roadmap feature 2 ACCEPT, verbatim: "shop UI leg under Xvfb, shot path
assets/screens/m1-dawnwell.png, shop-panel crop non-bg pixels >= 200 vs a
hidden-UI empty baseline (S8 HUD pixel-floor pattern)". The capture is the
TICK-deterministic harness godot/sim/dawnwell_capture.gd (the MC 11191
mechanism reused — see its header for the declared deviations). The baseline
is the SAME window with the UI hidden, so every non-equal pixel inside the
shop-panel crop (the screens._center_box rect the capture pins in rows.json)
IS the shop's draw; the gate counts pixels whose max channel delta exceeds
DELTA and GREENs at >= 200. A baseline-vs-baseline copy scores 0 — the shape
the planted-red run exercises.

Usage:  python3 tools/dawnwell_pixel_gate.py             # capture + gate
        python3 tools/dawnwell_pixel_gate.py --gate DIR  # gate a shot dir
                                                   # (carries rows.json;
                                                   # planted-mutation copy
                                                   # for the RED proof)
Env:    HD3D_GODOT (godot binary), XDG_DATA_HOME (set by this tool to a
        throwaway dir so the capture's real saves never touch app_userdata).
Exit:   0 green, 1 red.
"""
import json
import os
import subprocess
import sys
import tempfile

import numpy as np
from PIL import Image

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GODOT = os.environ.get(
    "HD3D_GODOT",
    "/home/claudecode/Games/.tools/godot/Godot_v4.7.2-stable_linux.x86_64")
SHOTS_DIR = os.path.join(REPO, ".tmp", "shop-shots")
SCRIPT = "res://sim/dawnwell_capture.gd"
SHOP_PNG = "m1-dawnwell.png"
BASE_PNG = "m1-dawnwell-baseline.png"
DELTA = 12   # per-pixel max-channel delta that counts as a drawn px
PX_MIN = 200  # roadmap floor, verbatim


def capture():
    scratch = tempfile.mkdtemp(prefix="hd3d-shop-shot-")
    env = dict(os.environ, HD3D_SHOP_SHOTS_DIR=SHOTS_DIR,
               XDG_DATA_HOME=scratch)
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
    assert row["leg"] == "shop_shot"
    ok = True
    if not (row["gold"] == 3000 - (40 + 80) - 55 - 60 - 100 and row["ranks"] == 4):
        print("FAIL seeded shop state wrong: %s" % row)
        ok = False
    shop = np.asarray(Image.open(
        os.path.join(dir_path, SHOP_PNG)).convert("RGB"), dtype=np.int16)
    base = np.asarray(Image.open(
        os.path.join(dir_path, BASE_PNG)).convert("RGB"), dtype=np.int16)
    if shop.shape != base.shape:
        print("FAIL shot/baseline shape mismatch %s vs %s"
              % (shop.shape, base.shape))
        sys.exit(1)
    cx, cy, hw, hh = row["cx"], row["cy"], row["hw"], row["hh"]
    x0, x1 = max(cx - hw, 0), min(cx + hw, shop.shape[1])
    y0, y1 = max(cy - hh, 0), min(cy + hh, shop.shape[0])
    diff = np.abs(shop - base).max(axis=2)
    win_px = int((diff[y0:y1, x0:x1] > DELTA).sum())
    total_px = int((diff > DELTA).sum())
    state_ok = win_px >= PX_MIN
    print("SHOP-PANEL leg=%s cx=%d cy=%d crop=[%d:%d,%d:%d] "
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
