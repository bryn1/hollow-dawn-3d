#!/usr/bin/env python3
"""T-S18 pickup-visibility + visible-upgrade-changes probe (MC 11201).

Owner ask (verbatim, 2026-10-23): "visible changes when upgrading skills.
Also gold/exp is invizible right now" — MC 11190's VM120 playtest root-
caused BOTH (.tmp/playtest-s12.md): coins/gems/heals have NO draw pass in
the 3D renderer (world state holds them, nothing paints them), and the field
does not change with weapon levels. This probe measures both claims in real
GL pixels through the TICK-DETERMINISTIC capture harness
(godot/sim/upgrades_visual_capture.gd, the MC 11191 cycle-2 mechanism —
fixed _step(1/60) after activation, seed pinned 11201; NO second capture
mechanism was authored).

Table 1 PICKUPS — seven live-run shots: six at fixed ticks after the first
kill, plus an event-conditional Dawnlight-window shot (the 1.5 %-drop heal
cannot be met at coarse fixed offsets; the scan-to-first-heal is the same
deterministic event reading as s8_capture's boss gate — see the capture
header).
For every ground pickup the capture projects (PICK rows), count pixels whose
chroma matches that kind's palette inside PICK_R px of its screen position.
A kind's row is GREEN when its best frame reaches PICK_PX_MIN (>= 40) AND
the sim state held that kind on screen (a kind that never drops is stated,
not skipped). Palette tests are the viz constants' chroma signatures
(coin.png downsampled gold, ICHOR gem green, BLOOD cross red); a palette
matching the UNPAINTED ground is the tell this gate can never go green on
noise — the RED run (0 px everywhere) is the proof the tests separate.

Table 2 FAMILIES — 12 legs: each of the 6 weapon families at Lv1 and Lv8
(one weapon per leg, immortal frozen cast, effect array live at the shot —
the StripsFxLeg pin pattern). Count the effect-zone palette pixels inside
the per-family window at the FAM row's centre. A family is GREEN when its
Lv1 zone is real (>= L1_PX_MIN px) and Lv8 reaches >= 25% more. For the
bible/orbit family (halo) the ORBIT BLOB COUNT is the headline measure
(connected components of the EMBER mask, >= 8 px each): count = 1+ceil(L/3)
in the sim (weapons.gd:175) must show as 2 blobs at Lv1 and 4 at Lv8.
Gate: >= 5 of 6 families scale (families whose ONLY per-level sim quantity
is damage carry their declaration in viz_fx.gd's code comments; the honest
mechanism there is level-as-intensity within the sim's true radius).

Table 3 SKILLS (T-M6f, MC 11705, M6-SPEC §2.2/§2.3) — 26 legs, one per
SKILL_FX row: the per-skill pixel LAW MOVED to
tools/upgrades_visual_skill_fx.py at T-M6q2 (MC 11711, audit-4 §1.2
split at the named seam); this file loads the row's window and calls
skill_px() — the gate output below is unchanged.

Usage:  python3 tools/upgrades_visual_probe.py            # capture + gate
        python3 tools/upgrades_visual_probe.py --gate DIR # gate a shot dir
                                                  # (real or planted-mutation
                                                  # copy — carries rows.json)
        python3 tools/upgrades_visual_probe.py --bulk     # T-M2g BULK-GEM row
                                                  # (MC 11238, M2-SPEC C-G4) — capture +
                                                  # gate; the row's MOVED-OUT law (T-M6q2)
                                                  # lives in tools/upgrades_visual_bulk.py
        python3 tools/upgrades_visual_probe.py --bulk DIR # gate a bulk shot
                                                  # dir (planted-mutation copy carries
                                                  # rows.json)
Env:    HD3D_GODOT (godot binary), HD3D_SEED (capture seed).
Seam:   both capture launches go through tools/capture_lib.py (MC 11317
        C1); the palette/blob measures stay HERE — audit §2.3 defends them
        as a different contract from the pixel-delta seam. T-M6q2 (MC
        11711) moved the Table-3 law (upgrades_visual_skill_fx.py) and
        the BULK-GEM row (upgrades_visual_bulk.py) OUT; the CLI wires
        them, the capture/parse/palette/window machinery stays one file.
"""
import json
import os
import sys

import numpy as np
from PIL import Image

import capture_lib
import upgrades_visual_bulk as bulk_gem
import upgrades_visual_skill_fx as skill_fx

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHOTS_DIR = os.path.join(REPO, ".tmp", "upgrades-visual-shots")
SCRIPT = "res://sim/upgrades_visual_capture.gd"

PICK_SHOTS = ["A%d-pickups.png" % i for i in range(1, 7)] \
    + ["A7-healwin.png"]
PICK_R = 16          # window radius around a projected pickup (14 px sprite)
PICK_PX_MIN = 40     # DoD threshold
FAMS = ["talon", "ember", "cleaver", "halo", "ward", "spike"]
L1_PX_MIN = 12       # a Lv1 effect zone must be real before % delta means
DELTA_MIN = 0.25     # DoD: >= 25% more effect-zone pixels at max level
FAM_GREEN_MIN = 5    # DoD: >= 5 of 6 families measured scaling
CC_MIN = 8           # connected-component floor px (halo orbit blobs)

# effect-zone window radii (px) per family — sized to the MAX-level extent
# (truncation at the window edge would dilute the delta toward 0)
FAM_WIN = {"talon": 130, "ember": 90, "cleaver": 90, "halo": 100,
           "ward": 95, "spike": 80}

# Palette chroma tests over RGB arrays (thresholds tuned against the REAL
# frames this card captured, 2026-10-23 — measured separations, not guesses:
# moorland's bright grass speckles peak at g≈137 with g-r≈64, so the painted
# gem is a BRIGHTER ICHOR (albedo x 1.15, g≈200) and the green test gates at
# g>=170; wraith tints read bluer than MOON, so the MOON test caps b-r <= 40
# (measured: ring/wedge b-r ~15-25, wraith bodies ~45-66); EMBER orbs blow
# out the green channel under additive blending (measured (255,250,122)
# over the pawn), so the test keys on the r-b axis the blow-out preserves.
# The RED run re-recorded with these exact tests shows the unpainted ground
# passing NONE of them (that is the separation, measured).
def _gold(r, g, b):        # coin.png glyph, downsampled gold (r>g>b warm)
    return (r > g + 10) & (g > b + 18) & (r >= 60)


def _green(r, g, b):       # bright ICHOR gem: ICHOR x 1.15 unshaded
    return (g >= r + 45) & (g >= b + 70) & (g >= 170)


def _red(r, g, b):         # BLOOD 0x8e,0x2f,0x35 heal cross
    return (r > g + 45) & (r > b + 30) & (r >= 90)


def _moon(r, g, b):        # MOON 0xae,0xbd,0xd4 additive (talon/ward);
	# b>=40 rides the MEASURED ring band at v1-parity alpha 0.25·life (band
	# p10 b=52 over dark ground), not a guessed brightness.
	return (b >= r + 8) & (b >= g - 3) & (b >= 40) & (b - r <= 40)


def _ember(r, g, b):       # EMBER 0xc9,0x7b,0x3d additive (ember/halo);
    return (r - b >= 70) & (g >= b + 20) & (r >= 90)  # blow-out tolerant


def _bone(r, g, b):        # BONE 0xd8,0xd2,0xc0 unshaded axe body
    return (r >= 185) & (g >= 175) & (b >= 140) & ((r - b) >= 20) \
        & ((r - b) <= 90)


def _ichor(r, g, b):       # ICHOR additive spike shards
    return (g > r + 30) & (g > b + 40) & (g >= 110)


# T-M6f RE-PIN (MC 11705, replace-not-delete): F2 RETIRED the constant
# family colours (MOON/EMBER/BONE/ICHOR per-class albedos -> per-instance
# SKILL_FX colours), so the three masks keyed to the RETIRED facts would
# claim a product that no longer exists — a surviving claim is CONTRADICTED,
# not debt. These signatures are re-tuned to the FAMILY row's SHIPPED sampled
# colour against THIS card's real frames (same measured discipline the T-S18
# header spells; separations re-checked on the wraith/speckle rejects the
# original masks carried): the axe sage is a near-neutral warm grey the
# wraith-blue and the green flecks both miss; the teal ring/shard bands ride
# the wraith's b-r cap reject. talon/ember/halo keep their masks (their F2
# colours land inside the same cones — re-measured GREEN, unchanged bytes).
def _sage(r, g, b):        # cleaver axe: SKILL_FX.cleaver unshaded (~78,82,76)
    return (r >= b - 6) & (r <= b + 8) & (g >= r) & (g >= b) & (b >= 40) \
        & (g <= 120)


def _ringteal(r, g, b):    # ward ring: SKILL_FX.ward additive teal band
    return (b >= g - 8) & (b >= r + 6) & ((b - r) <= 40) & (b >= 24) \
        & (g >= r + 4)


def _shardteal(r, g, b):   # spike shards: SKILL_FX.spike additive teal-green
    return (b >= g - 6) & (g >= r + 8) & ((b - r) <= 40) & (b >= 28)


KIND_TEST = {"gems": _green, "coins": _gold, "heals": _red}
FAM_TEST = {"talon": _moon, "ember": _ember, "cleaver": _sage,
            "halo": _ember, "ward": _ringteal, "spike": _shardteal}


def capture(shots_dir):
    os.makedirs(shots_dir, exist_ok=True)
    log = os.path.join(shots_dir, "capture.log")
    r = capture_lib.run_capture(SCRIPT, {"HD3D_UV_SHOTS_DIR": shots_dir},
                                timeout=2400)  # T-M6f: scenario C's 26
                                # per-SKILL legs extend the run; measured
                                # budget on this card's llvmpipe box (the
                                # 1200 s A/B budget predates them)
    out = r.stdout + r.stderr  # capture.log keeps the merged content the
    with open(log, "w") as fh:  # streamed run wrote (written post-run now)
        fh.write(out)
    if "CAPTURE_OK" not in out:
        print(out[-4000:])
        sys.exit("CAPTURE FAILED (no CAPTURE_OK from %s)" % SCRIPT)
    rows = parse_rows(out)
    with open(os.path.join(shots_dir, "rows.json"), "w") as fh:
        json.dump(rows, fh, indent=1)
    return rows


def parse_rows(out):
    """FIRSTKILL / A + PICK / FAM rows -> sidecar dict (the --gate copy path
    re-measures planted shots against the REAL run's coordinates)."""
    rows = {"firstkill": None, "shots": {}, "fam": {}, "skill": {}}
    cur = None
    for line in out.splitlines():
        if line.startswith("FIRSTKILL"):
            rows["firstkill"] = line.strip()
        elif line.startswith("A shot="):
            parts = dict(p.split("=", 1) for p in line.split()[1:])
            cur = parts["shot"]
            rows["shots"][cur] = {"state": line.strip(), "picks": []}
        elif line.startswith("PICK ") and cur:
            _, kind, x, y = line.split()
            rows["shots"][cur]["picks"].append([kind, float(x), float(y)])
        elif line.startswith("FAM fam="):
            parts = dict(p.split("=", 1) for p in line.split()[1:])
            rows["fam"]["%s-L%s" % (parts["fam"], parts["L"])] = {
                "row": line.strip(), "png": parts["png"],
                "cx": float(parts["cx"]), "cy": float(parts["cy"]),
                "arr": int(parts["arr"])}
        elif line.startswith("SKILL id="):
            # T-M6f scenario-C rows (MC 11705, §2.3)
            parts = dict(p.split("=", 1) for p in line.split()[1:])
            rows["skill"][parts["id"]] = {
                "row": line.strip(), "png": parts["png"],
                "cls": parts["cls"],
                "cx": float(parts["cx"]), "cy": float(parts["cy"]),
                "col": [float(v) for v in parts["col"].split(",")],
                "flash": int(parts["flash"]), "rings": int(parts["rings"]),
                "draws": int(parts["draws"])}
    if rows["firstkill"] is None:
        sys.exit("no FIRSTKILL row in capture output")
    for png in PICK_SHOTS:
        if png not in rows["shots"]:
            sys.exit("missing A shot %s in capture output" % png)
    for f in FAMS:
        for lv in (1, 8):
            if "%s-L%d" % (f, lv) not in rows["fam"]:
                sys.exit("missing FAM row %s-L%d" % (f, lv))
    missing = [i for i in skill_fx.skill_fx_ids() if i not in rows["skill"]]
    if missing:
        sys.exit("missing SKILL rows: %s" % missing)
    return rows


def load_window(path, cx, cy, r):
    """RGB float array over the +-r box at (cx,cy), clamped to frame, plus
    the per-pixel distance mask (round window)."""
    a = np.asarray(Image.open(path).convert("RGB"), dtype=np.float64)
    if a.shape[:2] != (720, 1280):
        sys.exit("%s: expected a 1280x720 windowed capture, got %s"
                 % (path, a.shape[::-1]))
    x0, y0 = int(max(0, cx - r)), int(max(0, cy - r))
    x1, y1 = int(min(a.shape[1], cx + r + 1)), int(min(a.shape[0], cy + r + 1))
    w = a[y0:y1, x0:x1]
    yy, xx = np.mgrid[y0:y1, x0:x1]
    d = np.hypot(xx - cx, yy - cy) <= r
    return w, d


def count_palette(path, cx, cy, r, test):
    w, d = load_window(path, cx, cy, r)
    m = d & test(w[..., 0], w[..., 1], w[..., 2])
    return int(m.sum()), m, d


def blobs(mask, win_d):
    """Connected components (>= CC_MIN px, 4-adjacency BFS on numpy masks —
    the window is small; no scipy dependency)."""
    m = mask & win_d
    lab = np.zeros(m.shape, dtype=bool)
    n = 0
    for i in range(m.shape[0]):
        for j in range(m.shape[1]):
            if not m[i, j] or lab[i, j]:
                continue
            stack, size, pix = [(i, j)], 0, []
            lab[i, j] = True
            while stack:
                y, x = stack.pop()
                size += 1
                pix.append((y, x))
                for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    ny, nx = y + dy, x + dx
                    if 0 <= ny < m.shape[0] and 0 <= nx < m.shape[1] \
                            and m[ny, nx] and not lab[ny, nx]:
                        lab[ny, nx] = True
                        stack.append((ny, nx))
            if size >= CC_MIN:
                n += 1
    return n


def main():
    args = sys.argv[1:]
    if args[:1] == ["--bulk"]: # T-M2g C-G4 row (law: upgrades_visual_bulk.py)
        if len(args) == 2:
            sys.exit(0 if bulk_gem.bulk_gate(args[1]) else 1)
        if len(args) > 2:
            sys.exit("usage: --bulk [DIR]")
        bulk_gem.bulk_capture()
        sys.exit(0 if bulk_gem.bulk_gate(bulk_gem.BULK_DIR) else 1)
    shots = SHOTS_DIR
    if args[:1] == ["--gate"]:
        if len(args) != 2:
            sys.exit("usage: --gate DIR")
        shots = args[1]
        with open(os.path.join(shots, "rows.json")) as fh:
            rows = json.load(fh)
    else:
        rows = capture(shots)

    ok = True
    # ---- Table 1: pickup pixels ------------------------------------------------
    print("== T-S18 pickups (MC 11201) — palette px within %d px of each"
          " projected ground pickup; kind GREEN at >= %d px on its best frame =="
          % (PICK_R, PICK_PX_MIN))
    hdr = "%-7s" % "kind" + "".join("%12s" % s.split("-")[0] for s in PICK_SHOTS) \
        + "%10s %8s" % ("max", "verdict")
    print(hdr)
    for kind, label in (("coins", "coins"), ("gems", "gems"), ("heals", "heals")):
        cells, best, present = [], 0, False
        for png in PICK_SHOTS:
            pts = [p for p in rows["shots"][png]["picks"] if p[0] == kind]
            if pts:
                present = True
            path = os.path.join(shots, png)
            if not os.path.exists(path):
                sys.exit("missing shot %s" % path)
            tot = 0
            for _, x, y in pts:
                tot += count_palette(path, x, y, PICK_R, KIND_TEST[kind])[0]
            cells.append("%12d" % tot)
            best = max(best, tot)
        green = present and best >= PICK_PX_MIN
        ok = ok and green
        print("%-7s" % label + "".join(cells) + "%10d %s" % (
            best, "GREEN" if green else ("ABSENT" if not present else "RED")))

    # ---- Table 2: weapon-level scaling ----------------------------------------
    print("== T-S18 weapon scaling (MC 11201) — effect-zone palette px, Lv1 "
          "vs Lv8 (halo additionally counts orbit blobs via connected "
          "components); GREEN at delta >= %.0f%% and Lv1 >= %d px =="
          % (DELTA_MIN * 100, L1_PX_MIN))
    print("%-8s %10s %10s %8s %14s  verdict" % ("family", "px_L1", "px_L8",
                                                "delta%", "halo blobs"))
    scaled = 0
    for fam in FAMS:
        r = FAM_WIN[fam]
        e1 = rows["fam"]["%s-L1" % fam]
        e8 = rows["fam"]["%s-L8" % fam]
        p1 = count_palette(os.path.join(shots, e1["png"]), e1["cx"], e1["cy"],
                           r, FAM_TEST[fam])[0]
        m8, mk8, d8 = count_palette(os.path.join(shots, e8["png"]), e8["cx"],
                                    e8["cy"], r, FAM_TEST[fam])
        note = ""
        green = p1 >= L1_PX_MIN and m8 >= (1.0 + DELTA_MIN) * p1
        if fam == "halo":
            c1 = blobs(*count_palette(os.path.join(shots, e1["png"]),
                                       e1["cx"], e1["cy"], r, FAM_TEST[fam])[1:])
            c8 = blobs(mk8, d8)
            note = "%d -> %d" % (c1, c8)
            green = green and c1 >= 2 and c8 >= (1.0 + DELTA_MIN) * c1
        scaled += 1 if green else 0
        print("%-8s %10d %10d %7.0f%% %14s  %s" % (
            fam, p1, m8, (m8 - p1) / max(p1, 1) * 100.0, note,
            "GREEN" if green else "RED"))
    fam_ok = scaled >= FAM_GREEN_MIN
    ok = ok and fam_ok
    print("families scaled: %d/6 (gate >= %d)" % (scaled, FAM_GREEN_MIN))

    # ---- Table 3: per-skill windows (T-M6f, MC 11705, §2.2/§2.3) -----------
    # the measure law + windows ride upgrades_visual_skill_fx.py (T-M6q2);
    # the window machinery (load_window) stays HERE, the ONE window seam.
    print("== T-M6f per-skill FX (MC 11705) — delta px inside each row's "
          "own class-alpha colour box, direction-aligned to its sampled "
          "colour; GREEN at >= %d px "
          "+ flash rings >= 1 + live draws <= 7 ==" % skill_fx.SKILL_PX_MIN)
    print("%-18s %-7s %6s %6s %6s  verdict" % ("skill", "cls", "px",
                                               "rings", "draws"))
    all_ids = skill_fx.skill_fx_ids()
    skills_green = 0
    for sid in all_ids:
        e = rows["skill"][sid]
        path = os.path.join(shots, e["png"])
        if not os.path.exists(path):
            sys.exit("missing shot %s" % path)
        w, d = load_window(path, e["cx"], e["cy"],
                           skill_fx.SKILL_WIN[e["cls"]])
        px = skill_fx.skill_px(w[d], e["col"], e["cls"])
        flash_ok = e["flash"] == 0 or e["rings"] >= 1
        draws_ok = e["draws"] <= 7
        green = px >= skill_fx.SKILL_PX_MIN and flash_ok and draws_ok
        skills_green += 1 if green else 0
        print("%-18s %-7s %6d %6d %6d  %s%s" % (
            sid, e["cls"], px, e["rings"], e["draws"],
            "GREEN" if green else "RED",
            "" if green else (" flash-rings=%d" % e["rings"]
                              if flash_ok is False else
                              (" draws=%d" % e["draws"]
                               if draws_ok is False else ""))))
    sk_ok = skills_green == len(all_ids)
    ok = ok and sk_ok
    print("skills painted per-skill: %d/%d (gate: ALL)" % (
        skills_green, len(all_ids)))
    print("GATE: %s" % ("ALL GREEN" if ok else "RED ROWS PRESENT"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
