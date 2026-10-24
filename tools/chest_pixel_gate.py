#!/usr/bin/env python3
"""T-M1e chest-open acceptance gate (MC 11209), per-tier since T-M2t (MC 11239).

Roadmap feature 5 ACCEPT, verbatim: "chest-open shot assets/screens/
m1-chest.png non-bg pixels >= 200 vs empty baseline". M2-SPEC rev-2 B-T5
extends the SAME mechanism to PER-TIER window rows: the capture
(godot/sim/chest_capture.gd, TICK-DETERMINISTIC, the MC 11191 recipe — no
second harness) emits one chest_shot ROW per rendered tier (II warden via the
real boss-kill drop; III dawn via the real cycle-clear drop, reposed — see
the capture header), each carrying its own window half ("win", sized from
PickupViz.CHEST_TIER_SCALE) and its own same-state empty baseline
(world.chests cleared — the S8 hidden-UI pattern). The gate counts, PER ROW,
the pixels whose max channel delta from that row's baseline exceeds DELTA in
that row's window (the projected centre +/- win px) and GREENs each row at
>= 200 (PX_MIN: the roadmap floor, verbatim, applied per tier row). A
baseline-vs-baseline copy scores 0 — this is the shape the planted-red run
exercises. T-M2u (MC 11240) adds the D-U7 UNION_HUD row to this SAME
harness (no second gate): the union icon cell on the v1 HUD weapon row,
shot vs the S8 hidden-element baseline (union entry popped), floored at
PX_MIN_HUD (stated below).

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
LEG = "chest_shot"
UNION_LEG = "union_hud"  # T-M2u D-U7 row in the SAME harness (no 2nd tool)
DELTA = 12           # per-pixel max-channel delta that counts as a drawn px
PX_MIN = 200         # roadmap floor, verbatim (B-T5 keeps it per tier row)
# D-U7 floor, OURS and stated: the HUD weapon-row cell is 18x18 CSS px
# (v1 hud row); the baseline is the SAME state with the union entry
# popped (S8 hidden-element pattern), so a BLANK icon scores ~0 px —
# exactly what the planted-red leg measures. 100 = the honest half of
# the roadmap floor, MEASURED against the real render before pinning
# (capture run, .tmp/m2u-unions.txt).
PX_MIN_HUD = 100


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
    shots = [r for r in rows if r["leg"] in (LEG, UNION_LEG)]
    assert shots, "no chest_shot/union_hud rows in rows.json"
    ok = True
    for row in shots:
        is_hud = row["leg"] == UNION_LEG
        if not is_hud and not row["in_frame"]:
            print("FAIL %s chest projected outside the frame: %s"
                  % (row["tier"], row))
            ok = False
        chest = np.asarray(Image.open(
            os.path.join(dir_path, row["png"])).convert("RGB"), dtype=np.int16)
        base = np.asarray(Image.open(
            os.path.join(dir_path, row["baseline"])).convert("RGB"),
            dtype=np.int16)
        if chest.shape != base.shape:
            print("FAIL %s shot/baseline shape mismatch %s vs %s"
                  % (row.get("tier", row.get("union")), chest.shape,
                     base.shape))
            sys.exit(1)
        cx, cy = int(round(row["cx"])), int(round(row["cy"]))
        half = int(row["win"])
        x0, x1 = max(cx - half, 0), min(cx + half, chest.shape[1])
        y0, y1 = max(cy - half, 0), min(cy + half, chest.shape[0])
        diff = np.abs(chest - base).max(axis=2)
        win_px = int((diff[y0:y1, x0:x1] > DELTA).sum())
        total_px = int((diff > DELTA).sum())
        floor = PX_MIN_HUD if is_hud else PX_MIN
        state_ok = win_px >= floor
        ok = ok and state_ok
        print("%s leg=%s what=%s cx=%d cy=%d half=%d "
              "window=[%d:%d,%d:%d] non-bg_px=%d (floor %d) frame-wide_diff=%d %s"
              % ("HUD-WINDOW" if is_hud else "CHEST-WINDOW", row["leg"],
                 row.get("tier", row.get("union", "?")), cx, cy, half,
                 x0, x1, y0, y1, win_px, floor, total_px,
                 "PASS" if state_ok else "FAIL"))
    return ok


def main():
    if len(sys.argv) >= 3 and sys.argv[1] == "--gate":
        sys.exit(0 if gate(sys.argv[2]) else 1)
    capture()
    sys.exit(0 if gate(SHOTS_DIR) else 1)


if __name__ == "__main__":
    main()
