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
Seam:   the launcher lives in tools/capture_lib.py and the window counting
        in tools/pixel_lib.py (MC 11317 C1; the gate's rows and floors stay
        HERE — the seams count, this file judges).
"""
import json
import os
import sys
import tempfile

import numpy as np
from PIL import Image

import capture_lib
import pixel_lib

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHOTS_DIR = os.path.join(REPO, ".tmp", "shop-shots")
SCRIPT = "res://sim/dawnwell_capture.gd"
SHOP_PNG = "m1-dawnwell.png"
BASE_PNG = "m1-dawnwell-baseline.png"
DELTA = 12   # per-pixel max-channel delta that counts as a drawn px
PX_MIN = 200  # roadmap floor, verbatim
# M3 A-E6 (MC 11282 T-M3s): rows.json now carries one leg PER OVERLAY
# window (the T-M2t per-tier-window precedent: gate loops rows, not rows[0])
# — the stage select crops its _center_box rect against the SAME hidden-UI
# baseline; its row also carries the state truth the shot must show: 3
# stage rows, 2 sealed lock lines on a never-unlocked well, chosen == 1.


def capture():
    scratch = tempfile.mkdtemp(prefix="hd3d-shop-shot-")
    r = capture_lib.run_capture(SCRIPT,
                                {"HD3D_SHOP_SHOTS_DIR": SHOTS_DIR,
                                 "XDG_DATA_HOME": scratch})
    print(r.stdout[-4000:])
    if "CAPTURE_OK" not in r.stdout or r.returncode != 0:
        print(r.stderr[-2000:])
        sys.exit(1)


def gate(dir_path):
    rows = json.load(open(os.path.join(dir_path, "rows.json")))
    base = np.asarray(Image.open(
        os.path.join(dir_path, BASE_PNG)).convert("RGB"), dtype=np.int16)
    ok = True
    for row in rows:
        img_path = os.path.join(dir_path, {"shop_shot": SHOP_PNG,
                                           "stage_select_shot":
                                           "m3-stage-select.png"}[row["leg"]])
        shot = np.asarray(Image.open(img_path).convert("RGB"), dtype=np.int16)
        if shot.shape != base.shape:
            print("FAIL shot/baseline shape mismatch %s vs %s"
                  % (shot.shape, base.shape))
            sys.exit(1)
        if row["leg"] == "shop_shot":
            if not (row["gold"] == 3000 - (40 + 80) - 55 - 60 - 100
                    and row["ranks"] == 4):
                print("FAIL seeded shop state wrong: %s" % row)
                ok = False
        elif row["leg"] == "stage_select_shot":
            # the state the shot must paint (A-E6 + roadmap :279): three
            # stage rows, two locked with their Sealed lines, stage 1 chosen
            if not (row["rows"] == 3 and row["sealed"] == 2
                    and row["chosen"] == 1):
                print("FAIL stage-select state wrong: %s" % row)
                ok = False
        cx, cy, hw, hh = row["cx"], row["cy"], row["hw"], row["hh"]
        win_px, total_px, (x0, x1, y0, y1) = pixel_lib.window_delta_counts(
            shot, base, cx, cy, hw, hh, DELTA)
        state_ok = win_px >= PX_MIN
        ok = ok and state_ok
        print("OVERLAY leg=%s cx=%d cy=%d crop=[%d:%d,%d:%d] "
              "non-bg_px=%d (floor %d) frame-wide_diff=%d %s" % (
                  row["leg"], cx, cy, x0, x1, y0, y1, win_px, PX_MIN, total_px,
                  "PASS" if state_ok else "FAIL"))
    return ok


def main():
    if len(sys.argv) >= 3 and sys.argv[1] == "--gate":
        sys.exit(0 if gate(sys.argv[2]) else 1)
    capture()
    sys.exit(0 if gate(SHOTS_DIR) else 1)


if __name__ == "__main__":
    main()
