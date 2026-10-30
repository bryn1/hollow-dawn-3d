#!/usr/bin/env python3
"""T-M6f Table 3 SKILL-FX measures (MC 11705, M6-SPEC §2.2/§2.3) — moved
OUT of tools/upgrades_visual_probe.py at T-M6q2 (MC 11711, audit-4 §1.2
option (a), the split AT THE AUDIT'S NAMED SEAM): Table 3 and the T-M2g
BULK-GEM row (upgrades_visual_bulk.py) are self-contained with DISJOINT
consumers; the capture/parse/palette/window machinery stays in the probe
(ONE pickup-visibility capture mechanism — the audit §2.3 defence).

Table 3 SKILLS — 26 legs, one per SKILL_FX row (15 weapon-side + 9 live
evolved + 2 unions), the capture's scenario C (SAME declared-pin pattern
as Table 2, the palette method DEFENDED and untouched: this module
EXTENDS it, it does not replace it). The caller (the probe) loads the
per-class round window with its OWN load_window and hands skill_px the
masked pixels; a writer that forgot the wid law paints the fallback
colour (EMBER-row) — only rows whose colour sits in that direction can
pass; every distinct row is RED. The row is GREEN at >= SKILL_PX_MIN px
(MEASURED floors, tuned against T-M6f's real frames), plus the
structural flags the capture reads off the renderer: a flash row must
show rings >= 1 (the evolved flash riding the EXISTING rings MM through
the mini(size,1) cap read) and EVERY row must show live draws <= 7
(§b ONE-draw law — a planted second MM class is RED there, FX-E4).

THE LAW (measured, T-M6f's real frames; header Table 3 carries the
contract): a window pixel BELONGS to its row's colour when (a) its DELTA
from the per-window median ambient has norm >= SKILL_NORM_MIN (24 — the
measured moorland noise floor), (b) every channel delta sits inside the
row's CLASS-ALPHA contribution box [-slack, hi_k*255*alpha*colour] — the
same per-class alpha constants the WRITER spells (viz_fx.gd: arcs 0.35,
bolts/halos/throws-orbs 1.0, rings 0.25 with the FLASH_GAIN 2.2 headroom,
bursts 0.6), which is what kills the bright grass-fleck leak a bare hue
test admits (flecks' delta misses the dark rows' channel boxes), and (c)
the delta DIRECTION aligns with the sampled colour (cos >=
SKILL_COS_MIN). SKILL_PX_MIN (25) is the count floor the weakest real row
clears with 4.6x headroom (storm-peal 115 px measured across the 26-leg
run). Separation (the plant column): a writer that forgot the wid law
paints the EMBER fallback — 17 of 26 rows measure 0 aligned px (the gate
needs ALL, so the table is RED; the 9 warm-direction survivors are
declared).

SKILL_CLASS_ALPHA honesty note (audit-4 F-3 sub-row, CLOSED at T-M6q2):
these numbers RESTATE the writer's alpha law across the language
boundary (a .gd const cannot be imported into Python) — they are no
longer the zero-pinned restatement the audit filed: tests/test_skill_fx.
py parses viz_fx.gd's OWN constants (FLASH_GAIN + the three fade
coefficients) and pins this table digit-for-digit, so a writer-side
alpha edit goes RED there, never silently desynced until the next
card-time probe run.
"""
import os
import re

import numpy as np

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

SKILL_WIN = {"arcs": 130, "bolts": 90, "throws": 90, "halos": 100,
             "rings": 95, "bursts": 80}
# the writer's per-class alpha law (viz_fx.gd) — PINNED to that source by
# tests/test_skill_fx.py (see the docstring note; T-M6q2 closed the pin):
SKILL_CLASS_ALPHA = {"arcs": 0.35, "bolts": 1.0, "throws": 1.0,
                     "halos": 1.0, "rings": 0.25 * 2.2, "bursts": 0.6}
SKILL_NORM_MIN = 24.0
SKILL_COS_MIN = 0.85
SKILL_PX_MIN = 25
SKILL_HI_K = 2.2 # box headroom (fades ride BELOW their peak; nothing
SKILL_SLACK = 8.0 # painted sits BELOW the median ambient by more than this


def skill_fx_ids():
    """The 26 row ids, parsed from the ONE table site (viz_fx.gd, §2.1) —
    the probe never carries a second list."""
    with open(os.path.join(REPO, "godot", "scripts", "viz_fx.gd")) as fh:
        src = fh.read()
    return re.findall(
        r'"([\w-]+)": \{"cls": "\w+", "color": Color\(', src)


def skill_px(px, col, cls):
    """Aligned-pixel count over a round window's MASKED pixels (the caller
    owns the window machinery — the probe's load_window stays the ONE
    window mechanism): the class-alpha box + direction law above."""
    if px.size == 0:
        return 0
    amb = np.median(px, axis=0) # per-window self-calibrating ambient
    dl = px - amb
    n = np.linalg.norm(dl, axis=1)
    s = dl[n >= SKILL_NORM_MIN]
    if len(s) == 0:
        return 0
    cap = SKILL_HI_K * 255.0 * SKILL_CLASS_ALPHA[cls] * np.asarray(col) \
        + SKILL_SLACK
    keep = (s <= cap).all(axis=1) & (s >= -SKILL_SLACK).all(axis=1)
    s = s[keep]
    if len(s) == 0:
        return 0
    c = np.asarray(col)
    c = c / (np.linalg.norm(c) + 1e-9)
    cs = (s @ c) / (np.linalg.norm(s, axis=1) + 1e-9)
    return int((cs >= SKILL_COS_MIN).sum())
