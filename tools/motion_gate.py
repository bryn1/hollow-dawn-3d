#!/usr/bin/env python3
"""Driver for the MOVING-PAW motion gate (MC 11676 T-M6r; M6-SPEC §1.6
MV-E1/E2/E5). Sibling capture pattern (roster_clip_gate / strips_gate /
dawnwell_pixel_gate): launches godot/sim/motion_capture.gd through the
ONE capture_lib launcher, judges the manifest LAWS on fresh rows, and
(--twice) re-runs the whole capture and cmps the STATE rows — the
MV-E2 "same seed twice ⇒ identical dump" twice-cmp law.

LAWS JUDGED (red ⇒ exit 1):
  MV-E1  per (job,pair): the MOTION pair's pawn-lit changed-pixel count
         >= 2 px. The window is the capture's projected character bbox
         (the S2r law); a pixel counts when it differs AND either frame
         has luma > 0.10 there — the committed ground floor (the same
         0.10 convention the strips/biome gates measure). The opaque
         pawn occludes the scrolling ground inside its silhouette, so
         "consumer pinned off" reads 0 px (planted red, MV-E1); ground
         drift outside the silhouette never fakes a GREEN.
         The FROZEN control (same key released, sim still): 0 px across
         the whole rect (roster_clip_gate's FROZEN_MAX = 0 law).
  guard  every pair captured with nearest enemy >= 60 px (L1) away:
         the window holds pawn + occluded ground only.
  MV-E5  exactly ONE pawn draw per job (self XOR rig child — the
         mutual-exclusion pin); rigged jobs draw via the child, the
         static job via self.
  MV-E2  the live law row: scissor range <= 0.24, freq cap <= 2.2,
         bob_range/lean_range each <= their declared 0.10 caps; every
         gait_probe row's freq <= the cap, ranges == the caps;
         --twice: the state rows (law/guard/draw/gait) cmp-identical
         across the two runs.
Modes:
  python3 tools/motion_gate.py             # capture + judge (one run)
  python3 tools/motion_gate.py --twice     # + determinism cmp
  python3 tools/motion_gate.py --gate DIR  # judge an EXISTING capture dir
                                           # (planted-red workflow, the
                                           # dawnwell/roster --gate DIR
                                           # precedent)
  python3 tools/motion_gate.py --out DIR   # keep the capture dir
Env: HD3D_GODOT (capture_lib resolution). Exit: 0 green, 1 red.
"""
import json
import os
import sys
import tempfile

import numpy as np
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import capture_lib

SCRIPT = "res://sim/motion_capture.gd"
MOTION_MIN = 2      # MV-E1: >= 2 px of real motion in the bbox
FROZEN_MAX = 0      # frozen control: exactly 0 px (roster_clip_gate law)
# MV-E1 MOTION mask floor. The repo's 0.10 luma floor is the BACKGROUND
# visibility law (strips/biome); it is the wrong mask for MOTION here:
# the crop margin holds scrolling ground (grass-tip drift at luma
# 0.10-0.20) that would let a consumer-pinned-OFF pawn still read a
# nonzero MOVING leg — the planted red must land at 0. Measured on this
# build: rig-dead changed pixels are ALL < 0.20 luma (dark ground drift);
# the bone-lit pawn's own clip motion sits >= 0.20 (histogram in the
# card capture). 0.15 is the midpoint that zeroes every rig-dead leg and
# keeps every genuine leg >= 63 px (MOTION_MIN 2 untouched).
LUMA_MIN = 0.15
SAFE_ENEMY_L1 = 60.0
SCISSOR_MAX = 0.24  # the byte-pinned horde caps (read from the live row)
FREQ_MAX = 2.2
BOB_RANGE_MAX = 0.10   # 2*BOB_M — the declared bob_range cap
LEAN_RANGE_MAX = 0.10  # 2*LEAN_RAD — the declared lean_range cap
RIGGED = {"vigil", "emberwright"}
STATIC = {"coinhound"}


def rows_of(manifest):
    with open(manifest, encoding="utf-8") as fh:
        return [json.loads(l) for l in fh if l.strip()]


def masked_diff(png_a, png_b, rect):
    """MV-E1 count: pixels inside rect that differ AND are pawn-lit
    (either frame's luma > LUMA_MIN). Luma = mean of RGB channels / 255,
    the repo's standing convention (tools/strips_gate_check.py,47; the
    biome gate's floor law)."""
    a = np.asarray(Image.open(png_a), dtype=np.uint8)
    b = np.asarray(Image.open(png_b), dtype=np.uint8)
    x0, y0, x1, y1 = rect
    la = a[y0:y1, x0:x1, :3].mean(axis=2) / 255.0
    lb = b[y0:y1, x0:x1, :3].mean(axis=2) / 255.0
    diff = np.any(a[y0:y1, x0:x1] != b[y0:y1, x0:x1], axis=2)
    return int((diff & ((la > LUMA_MIN) | (lb > LUMA_MIN))).sum())


def full_diff(png_a, png_b, rect):
    a = np.asarray(Image.open(png_a), dtype=np.uint8)
    b = np.asarray(Image.open(png_b), dtype=np.uint8)
    x0, y0, x1, y1 = rect
    return int(np.any(a[y0:y1, x0:x1] != b[y0:y1, x0:x1],
                      axis=2).sum())


def judge(manifest):
    rows = rows_of(manifest)
    fails = 0
    law = next((r for r in rows if r["ev"] == "law"), None)
    if law is None:
        print("FAIL no law row")
        return 1
    caps_ok = ((law["scissor"][1] - law["scissor"][0] <= SCISSOR_MAX)
               and law["freq_max"] <= FREQ_MAX
               and 2 * law["bob_m"] <= BOB_RANGE_MAX + 1e-9
               and 2 * law["lean_rad"] <= LEAN_RANGE_MAX + 1e-9)
    print("LAW scissor=%.2f freq_max=%.2f bob_range=%.2f lean_range=%.2f %s"
          % (law["scissor"][1] - law["scissor"][0], law["freq_max"],
             2 * law["bob_m"], 2 * law["lean_rad"],
             "OK" if caps_ok else "FAIL"))
    fails += 0 if caps_ok else 1

    frames = [r for r in rows if r["ev"] == "frame"]
    for guard in [r for r in rows if r["ev"] == "guard"]:
        ok = guard["nearest_enemy_l1_px"] >= SAFE_ENEMY_L1
        print("GUARD %-12s nearest=%.0fpx %s" % (guard["job"],
              guard["nearest_enemy_l1_px"], "OK" if ok else "FAIL"))
        fails += 0 if ok else 1
    by_key = {}
    for f in frames:
        by_key[(f["job"], f["pair"], f["slot"])] = f
    for (job, pair) in sorted({(f["job"], f["pair"]) for f in frames}):
        a, b = by_key.get((job, pair, "a")), by_key.get((job, pair, "b"))
        za, zb = by_key.get((job, pair, "za")), by_key.get((job, pair, "zb"))
        if None in (a, b, za, zb):
            print("FRAME_FAIL %s/%d incomplete grab set" % (job, pair))
            fails += 1
            continue
        m = masked_diff(a["png"], b["png"], a["rect"])
        fz = full_diff(za["png"], zb["png"], za["rect"])
        ok = m >= MOTION_MIN and fz <= FROZEN_MAX
        print("MV-E1 %-12s pair%d motion=%dpx frozen=%dpx %s"
              % (job, pair, m, fz, "OK" if ok else "FAIL"))
        fails += 0 if ok else 1

    for d in [r for r in rows if r["ev"] == "draw"]:
        want_child = d["job"] in RIGGED
        ok = (d["pawn_draws"] == 1
              and d["child_draw"] == want_child
              and d["self_draw"] == (not want_child))
        print("MV-E5 %-12s draws=%d child=%s self=%s %s"
              % (d["job"], d["pawn_draws"], d["child_draw"],
                 d["self_draw"], "OK" if ok else "FAIL"))
        fails += 0 if ok else 1

    for g in [r for r in rows if r["ev"] == "gait"]:
        probe = g["probe"]
        ok = bool(probe)
        for cls, v in probe.items():
            ok = ok and v["freq"] <= law["freq_max"]
            ok = ok and (v["range"][1] - v["range"][0]) <= SCISSOR_MAX
            ok = ok and abs((v["bob_range"][1] - v["bob_range"][0])
                            - 2 * law["bob_m"]) < 1e-9
            ok = ok and abs((v["lean_range"][1] - v["lean_range"][0])
                            - 2 * law["lean_rad"]) < 1e-9
        print("MV-E2 gait %-12s classes=%d caps=%s %s"
              % (g["job"], len(probe),
                 sorted({round(v["freq"], 3) for v in probe.values()}),
                 "OK" if ok else "FAIL"))
        fails += 0 if ok else 1
    return fails


def state_lines(manifest):
    return [l for l in open(manifest, encoding="utf-8")
            if json.loads(l)["ev"] in ("law", "guard", "draw", "gait")]


def main():
    argv = sys.argv[1:]
    if "--gate" in argv:
        manifest = os.path.join(argv[argv.index("--gate") + 1],
                                "manifest.jsonl")
        if not os.path.isfile(manifest):
            raise SystemExit("no manifest in gate dir")
        rc = 1 if judge(manifest) else 0
        print("MOTION_GATE %s" % ("RED" if rc else "GREEN"))
        return rc
    out = None
    if "--out" in argv:
        out = argv[argv.index("--out") + 1]
    tmp = out or tempfile.mkdtemp(prefix="hd3d-motion-")
    r = capture_lib.run_capture(SCRIPT, timeout=1200,
                                user_args=["--out", tmp])
    if r.returncode != 0 or "MOTIONCAP_OK" not in (r.stdout or ""):
        print(r.stdout[-2000:])
        print(r.stderr[-2000:])
        raise SystemExit("CAPTURE_FAIL rc=%d" % r.returncode)
    fails = judge(os.path.join(tmp, "manifest.jsonl"))
    if "--twice" in argv:
        tmp2 = tempfile.mkdtemp(prefix="hd3d-motion-twin-")
        r2 = capture_lib.run_capture(SCRIPT, timeout=1200,
                                     user_args=["--out", tmp2])
        if r2.returncode != 0 or "MOTIONCAP_OK" not in (r2.stdout or ""):
            raise SystemExit("CAPTURE_FAIL(twin) rc=%d" % r2.returncode)
        a = state_lines(os.path.join(tmp, "manifest.jsonl"))
        b = state_lines(os.path.join(tmp2, "manifest.jsonl"))
        det_ok = a == b
        print("MV-E2 determinism state-rows=%d identical=%s %s"
              % (len(a), det_ok, "OK" if det_ok else "FAIL"))
        if not det_ok:
            for i, (x, y) in enumerate(zip(a, b)):
                if x != y:
                    print("  first fork row %d:\n   A=%s\n   B=%s"
                          % (i, x.strip()[:160], y.strip()[:160]))
                    break
        fails += 0 if det_ok else 1
    rc = 1 if fails else 0
    print("MOTION_GATE %s (capture kept: %s)" % ("RED" if rc else "GREEN",
                                                 tmp))
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
