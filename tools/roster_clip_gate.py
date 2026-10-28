#!/usr/bin/env python3
"""Driver for the roster/skins clip frame-diff CSV (MC 11573 T-CC3R; the
audit-3 §4.2 P3 WIRE — the CSV re-mint path the repo was missing).

godot/sim/roster_capture.gd mints tests/fixtures/roster-clips-m5-framediff-
csv (judged by test_characters B-E8 + test_skins K-E3) but until this file
had ZERO code call-sites: the manifest -> CSV conversion was a ONE-OFF PIL
pass run inside the T-M5c card, so the committed diff_px numbers could never
be re-rendered (audit-3 §5's shared snapshot-gate root cause: a shipped mesh
whose clips stop moving keeps the suite green). This driver is the SIBLING
capture pattern the audit names (strips_capture <- strips_gate_check.py,
dawnwell_capture <- dawnwell_pixel_gate.py): it launches the capture through
the ONE capture_lib launcher (xvfb GL, pinned engine, MC 11317 C1 seam),
converts manifest + frames into the committed CSV shape, and re-mints it.

CONVERSION (the predicate this driver OWNS — the fixture is threshold-
judged, NOT a byte corpus, per its T-M5c/T-M5k headers):
  diff_px = count of pixels inside the manifest's projected character rect
  (the capture's own _rect() — the S2r character-bbox law, the window the
  numbers are meant to read) whose RGBA value differs between the pair's
  two grabs. A frozen leg grabs twice at the SAME seek time: 0 by
  construction, re-measured 0 on every capture run (m5z battery L5).
  Static meshes write no frames: one EXCUSED 0-px row per clip
  (EXCUSED-not-removed; the deviation-doc pin stays the suite's job).

Modes:
  python3 tools/roster_clip_gate.py            # capture + verify (default)
  python3 tools/roster_clip_gate.py --write    # + re-mint the committed CSV
  python3 tools/roster_clip_gate.py --gate DIR # gate an EXISTING capture dir
                                               # (manifest + frames; carries
                                               # the planted-mutation copy
                                               # for the RED proof, the
                                               # dawnwell --gate DIR precedent)
  python3 tools/roster_clip_gate.py --out DIR  # capture into DIR (kept, for
                                               # the red-copy workflow)
Verify judges the B-E8/K-E3 LAWS on the fresh rows (rigged: motion >= 2 px,
frozen == 0 px; static: excused 0 px) and reports each row's fresh-vs-
committed number as a VALUE_DRIFT row — drift is honest era-information
(the numbers are GL-render measures; m5c's own mint range 56973-138221 was
already superseded by the m5k re-measure), a LAW red is exit 1.
Env: HD3D_GODOT (capture_lib resolution). Exit: 0 all laws green, 1 red.
"""
import csv
import json
import os
import subprocess
import sys
import tempfile

import numpy as np
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import capture_lib

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPT = "res://sim/roster_capture.gd"
CSV_PATH = os.path.join(REPO, "tests", "fixtures",
                        "roster-clips-m5-framediff.csv")
HEADER = ["rig", "clip", "pair", "kind", "diff_px", "rig_state"]
MOTION_MIN = 2   # the B-E8/K-E3 law, verbatim (>= 2 px real motion)
FROZEN_MAX = 0   # frozen same-time control: exactly 0 px (noise gate)


def capture(out_dir):
    """One roster capture window (default job list: the 8 char rows minus
    the player + the 5 SKINS meshes — the capture's own job law)."""
    r = capture_lib.run_capture(SCRIPT, timeout=1200,
                                user_args=["--out", out_dir])
    if r.returncode != 0 or "ERROR" in (r.stderr or "").upper():
        print(r.stdout[-2000:])
        print(r.stderr[-2000:])
        raise SystemExit("CAPTURE_FAIL rc=%d" % r.returncode)
    return os.path.join(out_dir, "manifest.jsonl")


def convert(manifest_path):
    rows = []
    with open(manifest_path, encoding="utf-8") as fh:
        for line in fh:
            if not line.strip():
                continue
            m = json.loads(line)
            if m.get("state") == "static":
                # excused static row (no AnimationPlayer shipped — the
                # capture measures the fact, the deviation doc pins it)
                rows.append([m["rig"], m["clip"], "-", "excused", 0,
                             "static_excused"])
                continue
            x0, y0, x1, y1 = m["rect"]
            a = np.asarray(Image.open(m["fa"]), dtype=np.uint8)
            b = np.asarray(Image.open(m["fb"]), dtype=np.uint8)
            diff = int(np.any(a[y0:y1, x0:x1] != b[y0:y1, x0:x1],
                              axis=2).sum())
            rows.append([m["rig"], m["clip"], m["pair"], m["kind"], diff,
                         "rigged"])
    return rows


def write_csv(rows, path):
    with open(path, "w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh, lineterminator="\n")
        w.writerow(HEADER)
        for r in rows:
            w.writerow(r)


def judge(rows):
    """The B-E8/K-E3 laws on fresh rows (the doc-vs-CSV state pin stays in
    the suite — this driver judges the MEASURED rows only)."""
    fails = 0
    for rig in sorted({r[0] for r in rows}):
        mine = [r for r in rows if r[0] == rig]
        if mine[0][3] == "excused":
            n = len(mine)
            ok = n == 2 and all(int(r[4]) == 0 for r in mine)
            print("%-16s static  excused rows=%d 0-px=%s" %
                  (rig, n, "OK" if ok else "FAIL"))
        else:
            motion = [r for r in mine if r[3] == "motion"]
            frozen = [r for r in mine if r[3] == "frozen"]
            ok = (len(mine) == 6 and len(motion) == 4 and len(frozen) == 2
                  and all(int(r[4]) >= MOTION_MIN for r in motion)
                  and all(int(r[4]) == FROZEN_MAX for r in frozen))
            print("%-16s rigged  rows=%d motion[min]=%s frozen=%s %s" %
                  (rig, len(mine),
                   min(int(r[4]) for r in motion) if motion else "-",
                   [int(r[4]) for r in frozen], "OK" if ok else "FAIL"))
        if not ok:
            fails += 1
    return fails


def main():
    argv = sys.argv[1:]
    write = "--write" in argv
    gate_dir = None
    out_dir = None
    if "--gate" in argv:
        gate_dir = argv[argv.index("--gate") + 1]
    if "--out" in argv:
        out_dir = argv[argv.index("--out") + 1]
    if gate_dir is not None:
        manifest = os.path.join(gate_dir, "manifest.jsonl")
        if not os.path.isfile(manifest):
            raise SystemExit("no manifest in %s" % gate_dir)
    else:
        if out_dir is None:
            out_dir = tempfile.mkdtemp(prefix="hd3d-roster-clip-")
        manifest = capture(out_dir)
    rows = convert(manifest)
    print("CAPTURE_ROWS=%d" % len(rows))

    committed = {}
    if os.path.isfile(CSV_PATH):
        with open(CSV_PATH, newline="", encoding="utf-8") as fh:
            for r in csv.DictReader(fh):
                committed[(r["rig"], r["clip"], r["pair"], r["kind"])] = r
    shape_fail = 0
    for r in rows:
        key = (r[0], r[1], str(r[2]), r[3])
        c = committed.get(key)
        if c is None:
            print("ROW_NEW %s %s %s %s diff=%s" % tuple(r[:5]))
            shape_fail += 1
        elif int(c["diff_px"]) != int(r[4]):
            print("VALUE_DRIFT %s %s %s %s fresh=%s committed=%s" %
                  (r[0], r[1], r[2], r[3], r[4], c["diff_px"]))
        if c is not None and c["rig_state"] != r[5]:
            print("STATE_DRIFT %s %s %s %s fresh=%s committed=%s" %
                  (r[0], r[1], r[2], r[3], r[5], c["rig_state"]))
            shape_fail += 1
    for key in committed:
        if key not in {(r[0], r[1], str(r[2]), r[3]) for r in rows}:
            print("ROW_LOST %s %s %s %s (committed-only row)" % key)
            shape_fail += 1
    print("SHAPE_CHECKS_FAILS=%d (rows: %d fresh vs %d committed)" %
          (shape_fail, len(rows), len(committed)))

    law_fails = judge(rows)
    if write:
        write_csv(rows, CSV_PATH)
        print("WROTE %s (%d rows)" % (CSV_PATH, len(rows)))
    rc = 1 if (law_fails or shape_fail) else 0
    print("ROSTER_CLIP_GATE %s" % ("RED" if rc else "GREEN"))
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
