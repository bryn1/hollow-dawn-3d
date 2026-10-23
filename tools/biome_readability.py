#!/usr/bin/env python3
"""T-S10 biome-ground readability gate (MC 11159).

Owner ruling 2026-10-23 (verbatim): the biomes "should be more homogen, they
are right now very dominant and and the details are to large. The contrast is
also to small between player and floor texture/color."

Captures the LIVE scene at the four band times t=5/200/350/500 (one shot per
biome) through godot/sim/biome_readability_capture.gd under xvfb real GL
(art_capture pattern, MC 11133; seed pinned 11159), then measures per shot:

  floor_lum  mean luma (0..255) of the ground crop = rows below the HUD top
             band (y >= HUD_H: v1 hud row y 8..~48 + biome banner y 140..~175
             are HUD, not floor). Gate: <= 34.
  block_px   feature block size: grid of square blocks over the ground crop,
             per-block luma variance, mean over the grid, over the sizes
             8..128 — reported as the SATURATION KNEE of that curve (the
             smallest size whose mean variance reaches 90 % of the curve
             max; giant painted detail pushes the knee to the top of the
             grid, a fine homogeneous ground saturates small).
             Gate: <= 48.
  ratio      hero-vs-floor luma ratio: hero bbox = bbox of the ring-mean
             +100 luma mask anchored within +-45 px of the screen centre
             (the pawn zone; the cast ring at r >= 130 never enters), hero
             luma = mean of that bbox RECT; floor luma = mean of the
             annulus 250..330 px around the centre, below the HUD band.
             Gate: >= 2.0.

Red-capability (fleet rule "every gate proves it can go RED"): this tool
gates any shots dir (--gate DIR), so a planted fake dir — brightened floor /
blurred detail / dimmed hero on copies of the real shots — must exit 1 while
the real dir stays green; see the card evidence for the planted run.

Usage:  python3 tools/biome_readability.py            # capture + gate
        python3 tools/biome_readability.py --gate DIR # gate existing shots
Env:    HD3D_GODOT (godot binary), HD3D_SEED (capture seed).
"""
import os
import subprocess
import sys

import numpy as np
from PIL import Image

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GODOT = os.environ.get(
    "HD3D_GODOT",
    "/home/claudecode/Games/.tools/godot/Godot_v4.7.2-stable_linux.x86_64")
SHOTS_DIR = os.path.join(REPO, ".tmp", "biome-readability-shots")
SCRIPT = "res://sim/biome_readability_capture.gd"

# (key, png, expected BIOMES band name, warped run-clock time)
SHOTS = [
    ("grass", "readability-grass.png", "MOORLAND", 5.0),
    ("desert", "readability-desert.png", "BURNING DUNES", 200.0),
    ("frozen", "readability-frozen.png", "THE FROZEN WASTE", 350.0),
    ("tundra", "readability-tundra.png", "DEAD TUNDRA", 500.0),
]
LUM_MAX = 34.0      # owner brief: floor mean lum <= 34
BLOCK_MAX = 48      # feature block size <= 48 px
RATIO_MIN = 2.0     # hero/floor luma ratio >= 2.0
HUD_H = 180         # HUD top band rows excluded (hud_3d.gd: row y 8..~48,
                    # biome banner y 140, size 26 -> clears y < 180)
BLOCK_SIZES = (8, 16, 24, 32, 48, 64, 96, 128)
HERO_WIN = 70       # pawn-zone window half-size px (cast ring starts r=130)
HERO_MIN_PX = 20    # mask must find a real pawn, not noise
HERO_CONTRAST = 100  # pawn mask: ring luma + this (measured: grass tips
                    # ride at most +80 over the ring; the unshaded pawn
                    # highlights sit +115..215 over it)
ANNULUS = (250, 330)


def capture(shots_dir):
    os.makedirs(shots_dir, exist_ok=True)
    env = dict(os.environ, HD3D_BIOME_SHOTS_DIR=shots_dir)
    r = subprocess.run(
        ["xvfb-run", "-a", GODOT, "--render-driver", "opengl3",
         "--path", os.path.join(REPO, "godot"), "-s", SCRIPT],
        env=env, capture_output=True, text=True, timeout=900)
    out = r.stdout + r.stderr
    if "CAPTURE_OK" not in out:
        print(out[-3000:])
        sys.exit("CAPTURE FAILED (no CAPTURE_OK from %s)" % SCRIPT)
    for key, png, band, t in SHOTS:
        # t is printed at SAVE time, after the settle frames have advanced
        # the clock a little — assert band + png, not the exact warp value.
        if (f"STATE {band} " not in out) or (f"shot={png}" not in out):
            sys.exit("STATE row mismatch for %s: expected band '%s' + "
                     "shot=%s in dump:\n%s" % (png, band, png, out))


def block_size(gray):
    """Feature block size = the saturation knee of the mean per-block luma
    variance over sizes 8..128: the smallest size whose mean variance
    reaches 90 % of the curve maximum (detail at/over that size saturates
    the field — RED's giant painted detail pushed the knee to the top of
    the grid; a fine homogeneous ground saturates at <= 48)."""
    peaks = {}
    for b in BLOCK_SIZES:
        h, w = (gray.shape[0] // b) * b, (gray.shape[1] // b) * b
        blocks = gray[:h, :w].reshape(h // b, b, w // b, b)
        peaks[b] = float(blocks.var(axis=(1, 3)).mean())
    mx = max(peaks.values())
    knee = next(b for b in BLOCK_SIZES if peaks[b] >= 0.9 * mx)
    return knee, peaks


def metrics(path):
    a = np.asarray(Image.open(path).convert("L"), dtype=np.float64)
    if a.shape != (720, 1280):
        sys.exit("%s: expected a 1280x720 windowed capture, got %s"
                 % (path, a.shape[::-1]))
    ground = a[HUD_H:, :]
    floor_all = float(ground.mean())
    cx, cy = a.shape[1] / 2.0, a.shape[0] / 2.0
    # floor via the annulus crop (clears the cast ring at r <= ~240)
    yy, xx = np.mgrid[HUD_H:a.shape[0], :a.shape[1]]
    d = np.hypot(xx - cx, yy - cy)
    ann = ground[(d >= ANNULUS[0]) & (d < ANNULUS[1])]
    floor_ring = float(ann.mean())
    # hero bbox via the pawn zone: mask = pixels HERO_CONTRAST over the
    # ring mean, anchored within +-45 px of the screen centre (the pawn's
    # projection point) so scattered grass tips can never expand the box;
    # hero luma = mean of that bbox RECT (pawn + the ground it rides on).
    # Two-stage (red-capability class of the owner ruling "contrast too
    # small"): if nothing separates at ring+100, the pawn does NOT stand
    # off the floor — fall back to ring+45, which reports the pawn zone as
    # hero≈floor (the RED reading) instead of erroring.
    win = a[int(cy - HERO_WIN):int(cy + HERO_WIN),
            int(cx - HERO_WIN):int(cx + HERO_WIN)]

    def pawn_bbox(thr):
        mrows, mcols = np.nonzero(win > thr)
        keep = ((np.abs(mrows - HERO_WIN) <= 45)
                & (np.abs(mcols - HERO_WIN) <= 45))
        rs, cs = mrows[keep], mcols[keep]
        if rs.size < HERO_MIN_PX:
            return None
        return win[rs.min():rs.max() + 1, cs.min():cs.max() + 1].mean()

    hero = pawn_bbox(floor_ring + HERO_CONTRAST)
    if hero is None:
        hero = pawn_bbox(floor_ring + 45)
    if hero is None:
        sys.exit("%s: pawn-zone mask found no anchor (< %d px even at "
                 "ring+45) — hero not visible" % (path, HERO_MIN_PX))
    blk, _ = block_size(ground)
    return floor_all, blk, hero / floor_ring, hero, floor_ring


def main():
    args = sys.argv[1:]
    shots = SHOTS_DIR
    if args[:1] == ["--gate"]:
        if len(args) != 2:
            sys.exit("usage: --gate DIR")
        shots = args[1]
    else:
        capture(shots)
    ok = True
    print("== T-S10 biome readability (MC 11159) — floor lum <= %.0f, "
          "block <= %d px, hero/floor >= %.1f ==" % (LUM_MAX, BLOCK_MAX,
                                                     RATIO_MIN))
    print("%-9s %9s %11s %13s  verdict" % ("biome", "floor_lum", "block_px",
                                           "hero/floor"))
    for key, png, band, _t in SHOTS:
        path = os.path.join(shots, png)
        if not os.path.exists(path):
            print("%-9s MISSING SHOT %s" % (key, path))
            ok = False
            continue
        floor_all, blk, ratio, hero, ring = metrics(path)
        green = floor_all <= LUM_MAX and blk <= BLOCK_MAX and ratio >= RATIO_MIN
        ok = ok and green
        print("%-9s %9.1f %11d %13.2f  %s" % (key, floor_all, blk, ratio,
                                              "GREEN" if green else "RED"))
        print("          (floor ring %.1f / hero bbox %.1f)" % (ring, hero))
    print("GATE: %s" % ("ALL GREEN" if ok else "RED ROWS PRESENT"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
