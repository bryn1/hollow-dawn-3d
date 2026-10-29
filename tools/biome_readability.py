#!/usr/bin/env python3
# reason: >400 lines — the ONE readability gate: M6 §7.1's mob-grid leg
#   rides BESIDE the shipped three rows on purpose (mechanism monogamy:
#   one RATIO_MIN, one capture, one tool); the split would fork the floor
#   law the fleet's contrast contract depends on.
"""T-S10 biome-ground readability gate (MC 11159).

Owner ruling 2026-10-23 (verbatim): the biomes "should be more homogen, they
are right now very dominant and and the details are to large. The contrast is
also to small between player and floor texture/color."

Captures the LIVE scene at the four band times t=5/200/350/500 (one shot per
biome) through godot/sim/biome_readability_capture.gd under xvfb real GL
(art_capture pattern, MC 11133; seed pinned 11159), then measures per shot:

DETERMINISM (cycle-2 fix, MC 11191): cycle 1 sampled the live sim at
wall-clock-driven in-game time — the capture stages advanced on RENDER
frames (~3 fps under llvmpipe) while the sim ticked in main.gd's own
_physics_process at 60 Hz, so the tick count between warp and save varied
per process and block_px flickered (tundra 64/16/24 on an unchanged tree).
The capture now idles the tree's own tick (main.set_physics_process(false),
the sim_headless pinning pattern MC 11112) and advances the clock ONLY
through a fixed count of _step(1/60) calls: SETTLE_TICKS = 180 sim steps
(= 3.0 in-game s) per shot, identical RNG draws from the pinned seed, every
process. capture() re-parses the t= on each STATE line and refuses a shot
whose clock moved by more than the fixed budget — the deviation is bounded
in code, not trusted.

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

F7 MOB-GRID LEG (M6-SPEC §7, MC 11677 T-M6c): beside the shipped three
rows, a per-(stage × band × spawnable-class) grid measures the MOB the same
way the pawn is measured — owner complaint "some mobs are very hard to spot
due to low contrast". The capture rides the DECLARED HD3D_MOB_GRID variant
of biome_readability_capture.gd (own shots dir, default windows byte-
invariant); the expected grid is READ from the shipped rows (BIOMES rosters
+ GATES rotation through the ONE _types_open law, the STAGES bosses column,
the ENEMY_TYPES reaper row at the arrival window) — never typed. Per shot:
mob bbox = the instance-pixel bbox (the hero-bbox mechanism: pixels
separating from the band's own ground, anchored on the FIXED placement
point), mob_luma = mean of that bbox RECT (the S10 rect law), mob_ratio =
mob vs the mob-anchored annulus floor, gate >= RATIO_MIN — THE SAME const:
one readability law for pawn and mobs (no second floor const). A mob with
no instance pixels at all (ring+100 then ring+45) is an INVISIBLE mob: RED
row, the planted-dark-copy idiom (a copy of the shots dir with one mob lift
removed must exit 1, row named). --mob-grid DIR gates an existing mob dir
(the planted-fake hook beside --gate DIR).

Usage:  python3 tools/biome_readability.py            # capture + gate (both legs)
        python3 tools/biome_readability.py --gate DIR # gate existing default shots
        python3 tools/biome_readability.py --mob-grid DIR # gate existing mob-grid shots
Env:    HD3D_GODOT (godot binary), HD3D_SEED (capture seed).
Seam:   the launcher lives in tools/capture_lib.py (MC 11317 C1); the
        luma/readability metrics stay HERE — DEFENDED by audit §2.3 as a
        different contract, deliberately not folded into pixel_lib.
"""
import math
import os
import re
import sys

import numpy as np
from PIL import Image

import capture_lib

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHOTS_DIR = os.path.join(REPO, ".tmp", "biome-readability-shots")
SCRIPT = "res://sim/biome_readability_capture.gd"
RENDER_SRC = os.path.join(REPO, "godot", "scripts", "render.gd")
WORLD_SRC = os.path.join(REPO, "godot", "scripts", "world.gd")
CAM_SRC = os.path.join(REPO, "godot", "scripts", "camera_rig.gd")
GAME_STATE_SRC = os.path.join(REPO, "godot", "scripts", "game_state.gd")
CAPTURE_SRC = os.path.join(REPO, "godot", "sim", "biome_readability_capture.gd")

# (key, png, expected band name, stage, warp time — the clock then advances
# only through the capture's fixed SETTLE_TICKS budget, never wall clock).
# M3 A-E7 (MC 11282 T-M3s): the gate per STAGE band window — stage 1 keeps
# the shipped four rows; stages 2/3 add §1.1's band windows through the
# stage-keyed STATE rows ("STATE <stage>:<BAND>"). Same three owner gates on
# every window: floor_lum <= 34 / block_px <= 48 / hero ratio >= 2.0.
SHOTS = [
    ("grass", "readability-grass.png", "MOORLAND", 1, 5.0),
    ("desert", "readability-desert.png", "BURNING DUNES", 1, 200.0),
    ("frozen", "readability-frozen.png", "THE FROZEN WASTE", 1, 350.0),
    ("tundra", "readability-tundra.png", "DEAD TUNDRA", 1, 500.0),
    ("s2-moor", "readability-s2-moor.png", "MOORLAND", 2, 150.0),
    ("s2-frozen", "readability-s2-frozen.png", "THE FROZEN WASTE", 2, 450.0),
    ("s2-tundra", "readability-s2-tundra.png", "DEAD TUNDRA", 2, 750.0),
    ("s3-tundra", "readability-s3-tundra.png", "DEAD TUNDRA", 3, 225.0),
    ("s3-frozen", "readability-s3-frozen.png", "THE FROZEN WASTE", 3, 675.0),
]
SETTLE_TICKS = 60   # must match SETTLE_TICKS in the capture script (1.0 s)
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

# --- F7 mob-grid leg (M6-SPEC §7, MC 11677 T-M6c) -----------------------------
# The mob grid rides the DECLARED HD3D_MOB_GRID variant of the capture (own
# dir, default windows byte-invariant) and the SAME readability law: the
# gate below re-uses RATIO_MIN — no second floor const (spec §7.1).
MOB_SHOTS_DIR = os.path.join(REPO, ".tmp", "mob-readability-shots")
MOB_WIN = HERO_WIN         # anchor window half-size px (the pawn law)
MOB_ANCHOR_TOL = 45        # the pawn bbox's anchor tolerance, verbatim
MOB_MIN_PX = 8             # instance mask floor (a 1.42 m mob is ~34 px
                           # wide; the pawn's 20 px assumes a bright pawn)
MOB_REAPER_GUARD = 5.0     # mirrors the capture's declared arrival-guard
                           # (WIN_TIME - 5.0, the band 900.017 reads on)


def _read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


def _mob_anchor():
    """Screen anchor of the capture's FIXED placement point player+
    (0, MOB_DY): ortho rig, ground foreshortening sin(|PITCH_DEG|) — every
    constant READ from its shipped home, never retyped."""
    dy = float(re.search(r"const MOB_DY := ([\d.]+)", _read(CAPTURE_SRC)).group(1))
    pitch = float(re.search(r"const PITCH_DEG := -?([\d.]+)", _read(CAM_SRC)).group(1))
    return 640.0, 360.0 + dy * math.sin(math.radians(pitch))


def _mob_png(stage_id, band_name, cls):
    return "mob-%s-%s-%s.png" % (stage_id,
                                 band_name.lower().replace(" ", "-"), cls)


def expected_grid():
    """The grid the capture MUST cover, READ from the shipped rows (never
    typed — M6 §7.1): per stage band row sampled mid-band, the ONE
    _types_open law (band roster + GATES rotation); the STAGES bosses
    column (each window +0.05 s, mirroring the capture); the ENEMY_TYPES
    reaper row at the arrival window. Rows:
    (stage_idx, stage_id, band_name, t, class, png)."""
    rsrc = _read(RENDER_SRC)
    wsrc = _read(WORLD_SRC)
    biomes = {name: re.findall(r'"([^"]+)"', en)
              for name, en in re.findall(
                  r'\{"name": "([^"]+)".*?"enemies": \[([^\]]*)\]', rsrc, re.S)}
    gates = re.findall(r"\[([\d.]+), \"([\w-]+)\"\]",
                       re.search(r"const GATES := (\[.*\])", wsrc).group(1))
    boss_at = re.search(r"const BOSS_AT := ([\d.]+)", wsrc).group(1)
    miniboss = re.search(r"const MINIBOSS_AT := (\[.*?\]\])", wsrc).group(1)
    win_time = float(re.search(r"const WIN_TIME := ([\d.]+)",
                               _read(GAME_STATE_SRC)).group(1))
    reaper = re.search(r'"([\w-]+)": \{[^}\n]*"reaper": true', wsrc).group(1)
    stages_txt = rsrc[rsrc.index("const STAGES"):]
    s1_id, s1_bands = None, None
    rows = []
    for i, block in enumerate(re.split(r'\{"id": ', stages_txt)[1:]):
        stage_id = re.match(r'"([^"]+)"', block).group(1)
        bands = [(m[0], float(m[1])) for m in re.findall(
            r'\["([A-Z ]+)", ([\d.]+)\]',
            re.search(r'"bands": (\[.*?\]\])', block, re.S).group(1))]
        if i == 0:
            s1_id, s1_bands = stage_id, bands
        limit = float(re.search(r'"limit": ([\d.]+)', block).group(1))
        bosses_txt = re.search(r'"bosses": (.*?),\s*"cairns"', block,
                               re.S).group(1)
        bosses_txt = bosses_txt.replace("GameWorld.BOSS_AT", boss_at) \
                               .replace("GameWorld.MINIBOSS_AT", miniboss)
        bosses = [(float(m[0]), m[1]) for m in re.findall(
            r'\[([\d.]+), "([\w-]+)"\]', bosses_txt)]
        for bi, (band, t0) in enumerate(bands):
            t1 = bands[bi + 1][1] if bi + 1 < len(bands) else limit
            t = (t0 + t1) / 2.0
            open_cls = list(biomes[_band_name_at(bands, t)])
            for gmin, gcls in gates:
                if t >= float(gmin) * 60.0 and gcls not in open_cls:
                    open_cls.append(gcls)
            for cls in open_cls:
                rows.append((i + 1, stage_id, band, t, cls,
                             _mob_png(stage_id, band, cls)))
        for bt, bcls in bosses:
            t = bt + 0.05
            rows.append((i + 1, stage_id, _band_name_at(bands, t), t, bcls,
                         _mob_png(stage_id, _band_name_at(bands, t), bcls)))
    rt = win_time - MOB_REAPER_GUARD
    rband = _band_name_at(s1_bands, rt)
    rows.append((1, s1_id, rband, rt, reaper, _mob_png(s1_id, rband, reaper)))
    return rows


def _band_name_at(bands, t):
    """band_at's saturating walk, mirrored (render.gd is the ONE law; this
    is the gate's independent re-derivation of the same table)."""
    pick = bands[0][0]
    for name, t_start in bands:
        if t >= t_start:
            pick = name
    return pick


def capture(shots_dir):
    os.makedirs(shots_dir, exist_ok=True)
    r = capture_lib.run_capture(SCRIPT, {"HD3D_BIOME_SHOTS_DIR": shots_dir})
    out = r.stdout + r.stderr
    if "CAPTURE_OK" not in out:
        print(out[-3000:])
        sys.exit("CAPTURE FAILED (no CAPTURE_OK from %s)" % SCRIPT)
    for key, png, band, stage, t in SHOTS:
        # t is printed at SAVE time, after the FIXED tick budget has
        # advanced the clock — assert stage-qualified band + png, and that
        # the clock moved by at most the fixed budget (warp .. warp +
        # SETTLE_TICKS/60); _pick() consumes budget iterations, so it may
        # advance LESS.
        if (f"STATE {stage}:{band} " not in out) or (f"shot={png}" not in out):
            sys.exit("STATE row mismatch for %s: expected stage %d band '%s' + "
                     "shot=%s in dump:\n%s" % (png, stage, band, png, out))
        m = re.search(r"STATE %d:%s t=([\d.]+)" % (stage, re.escape(band)), out)
        if m is None:
            sys.exit("no parseable t= on the %s STATE row:\n%s" % (png, out))
        shot_t = float(m.group(1))
        if not t <= shot_t <= t + SETTLE_TICKS / 60.0 + 1e-6:
            sys.exit("%s: clock advanced to %.1f, outside the pinned "
                     "budget [%.1f, %.1f] — capture is not tick-driven"
                     % (png, shot_t, t, t + SETTLE_TICKS / 60.0))


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
    if args[:1] == ["--gate"]:
        if len(args) != 2:
            sys.exit("usage: --gate DIR")
        return gate_default(args[1])
    if args[:1] == ["--mob-grid"]:
        if len(args) != 2:
            sys.exit("usage: --mob-grid DIR")
        return gate_mob(args[1])
    ok = capture_and_gate()
    ok = gate_mob_capture_and_gate() and ok
    return 0 if ok else 1


def capture_and_gate():
    """The shipped three legs, untouched (CT-E2's byte-invariance subject).
    Extracted verbatim from main() at T-M6c — same rows, same prints."""
    shots = SHOTS_DIR
    capture(shots)
    return gate_default(shots)


def gate_default(shots):
    ok = True
    print("== T-S10 biome readability (MC 11159) — floor lum <= %.0f, "
          "block <= %d px, hero/floor >= %.1f ==" % (LUM_MAX, BLOCK_MAX,
                                                     RATIO_MIN))
    print("%-9s %9s %11s %13s  verdict" % ("biome", "floor_lum", "block_px",
                                           "hero/floor"))
    for key, png, band, _stage, _t in SHOTS:
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


def gate_mob_capture_and_gate():
    os.makedirs(MOB_SHOTS_DIR, exist_ok=True)
    capture_mob(MOB_SHOTS_DIR)
    return gate_mob(MOB_SHOTS_DIR)


def capture_mob(shots_dir):
    """The declared HD3D_MOB_GRID run (own dir, own STATE rows); the
    default windows never load this path."""
    os.makedirs(shots_dir, exist_ok=True)
    r = capture_lib.run_capture(
        SCRIPT, {"HD3D_MOB_GRID": "1", "HD3D_MOB_SHOTS_DIR": shots_dir},
        timeout=3600)
    out = r.stdout + r.stderr
    if "CAPTURE_OK" not in out:
        print(out[-3000:])
        sys.exit("CAPTURE FAILED (no CAPTURE_OK from %s mob-grid mode)"
                 % SCRIPT)
    grid = expected_grid()
    m = re.search(r"MOBGRID windows=(\d+)", out)
    if m is None or int(m.group(1)) != len(grid):
        sys.exit("mob grid window count mismatch: capture printed %r, "
                 "expected_grid() reads %d from the shipped rows"
                 % (None if m is None else m.group(1), len(grid)))
    for _stage, _sid, band, t, cls, png in grid:
        if ("cls=%s " % cls) not in out or ("shot=%s" % png) not in out \
                or ("MOBSTATE %d:%s " % (_stage, band)) not in out:
            sys.exit("MOBSTATE row mismatch for %s (band %s): dump:\n%s"
                     % (png, band, out[-2000:]))
        m = re.search(r"MOBSTATE %d:%s t=([\d.]+) cls=%s"
                      % (_stage, re.escape(band), re.escape(cls)), out)
        if m is None:
            sys.exit("no parseable t= on the %s MOBSTATE row:\n%s"
                     % (png, out[-2000:]))
        shot_t = float(m.group(1))
        if not t <= shot_t <= t + SETTLE_TICKS / 60.0 + 1e-6:
            sys.exit("%s: clock advanced to %.1f, outside the pinned "
                     "budget [%.1f, %.1f] — capture is not tick-driven"
                     % (png, shot_t, t, t + SETTLE_TICKS / 60.0))


def mob_metrics(path):
    """The mob bbox + luma: the hero-bbox mechanism re-pointed at the
    capture's FIXED placement point — instance pixels = pixels separating
    from the band's own ground (the mob-anchored annulus), mob_luma = mean
    of the bbox RECT (the S10 rect law). Returns (floor_ring, mob_luma or
    None, ratio or None); None mob = NO instance pixels at either stage =
    the mob is invisible on its own ground (a RED row, never an error)."""
    a = np.asarray(Image.open(path).convert("L"), dtype=np.float64)
    if a.shape != (720, 1280):
        sys.exit("%s: expected a 1280x720 windowed capture, got %s"
                 % (path, a.shape[::-1]))
    ax, ay = _mob_anchor()
    yy, xx = np.mgrid[0:a.shape[0], 0:a.shape[1]]
    d = np.hypot(xx - ax, yy - ay)
    ann = a[(d >= ANNULUS[0]) & (d < ANNULUS[1]) & (yy >= HUD_H)]
    floor_ring = float(ann.mean())
    win = a[int(ay - MOB_WIN):int(ay + MOB_WIN),
            int(ax - MOB_WIN):int(ax + MOB_WIN)]

    def inst_bbox(thr):
        mrows, mcols = np.nonzero(win > thr)
        keep = ((np.abs(mrows - MOB_WIN) <= MOB_ANCHOR_TOL)
                & (np.abs(mcols - MOB_WIN) <= MOB_ANCHOR_TOL))
        rs, cs = mrows[keep], mcols[keep]
        if rs.size < MOB_MIN_PX:
            return None
        return win[rs.min():rs.max() + 1, cs.min():cs.max() + 1].mean()

    mob = inst_bbox(floor_ring + HERO_CONTRAST)
    if mob is None:
        mob = inst_bbox(floor_ring + 45)
    if mob is None:
        return floor_ring, None, None
    return floor_ring, float(mob), float(mob) / floor_ring


def gate_mob(shots):
    """F7 CT-E1 leg: every (stage × band × spawnable-class) grid shot reads
    mob_ratio >= RATIO_MIN — the SAME floor const as the pawn law (§7.1
    mechanism monogamy). Missing shot / invisible mob / thin ratio: RED,
    row named (the planted-fake dir hook is --mob-grid DIR)."""
    grid = expected_grid()
    ok = True
    print("== T-M6c mob grid (MC 11677, M6 §7) — mob/floor >= %.1f over "
          "%d (band × class) shots ==" % (RATIO_MIN, len(grid)))
    print("%-28s %-16s %11s %13s  verdict" % ("shot", "class", "floor_ring",
                                              "mob/floor"))
    for _stage, _sid, band, _t, cls, png in grid:
        path = os.path.join(shots, png)
        label = "%s/%s" % (band, cls)
        if not os.path.exists(path):
            print("%-28s %-16s %11s %13s  RED MISSING SHOT" % (png, cls,
                                                                "-", "-"))
            ok = False
            continue
        ring, mob, ratio = mob_metrics(path)
        if mob is None:
            print("%-28s %-16s %11.1f %13s  RED MOB INVISIBLE (no "
                  "instance pixels on its own ground)" % (png, cls, ring,
                                                          "-"))
            ok = False
            continue
        green = ratio >= RATIO_MIN
        ok = ok and green
        print("%-28s %-16s %11.1f %13.2f  %s" % (png, cls, ring, ratio,
                                                 "GREEN" if green else "RED"))
    print("GATE MOB: %s" % ("ALL GREEN" if ok else "RED ROWS PRESENT"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
