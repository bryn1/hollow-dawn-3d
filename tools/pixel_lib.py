#!/usr/bin/env python3
"""ONE pixel-delta seam (MC 11317 C1; audit MC 11316 §2.3).

The counted question — "how many pixels differ from the empty-baseline frame
by more than a delta floor (channel-max |delta|), inside a window clamped to
the frame" — existed three times: chest_pixel_gate and dawnwell_pixel_gate
carried a VERBATIM square/rect window pair, s8_acceptance.crop_nonbg a third
(PIL crop, `>=` floor, DIFF_MIN=24). ONE formula here (maxdiff); the three
adapters keep each gate's exact window shape and comparison, so every count
is byte-for-byte what the copies computed:

  window_delta_counts  chest/dawnwell: half-window rectangle around a
                       projected centre + the frame-wide count, strict >.
  crop_delta_count     s8 pixel legs: PIL box crop of the two PNGs, >= floor,
                       the declared -1 size-mismatch sentinel.

DEFENDED by the audit, deliberately NOT folded: biome_readability.metrics
(luma/readability contract) and upgrades_visual_probe's round-window
palette/bulk masks (palette test, not a baseline delta).

Red-capability: a baseline-vs-baseline copy scores 0 through this seam —
that IS the planted-red shape both pixel gates document; re-proven at the
C1 commit (capture .tmp/clean-code.txt), the seam must not launder a
baseline copy into a green count.
"""
import numpy as np
from PIL import Image


def maxdiff(shot, base):
    """Channel-max |shot-base| as int16 (deltas <= 255 never overflow)."""
    if shot.shape != base.shape:
        raise ValueError("shot/base shape mismatch %s vs %s"
                         % (shot.shape, base.shape))
    return np.abs(shot - base).max(axis=2)


def window_delta_counts(shot, base, cx, cy, half_x, half_y, delta):
    """(window_px, frame_px, (x0, x1, y0, y1)) — pixels whose maxdiff exceeds
    delta inside the [cx±half_x, cy±half_y] window clamped to the frame
    (chest passes half_x == half_y; dawnwell the shop rect's hw, hh)."""
    x0, x1 = max(cx - half_x, 0), min(cx + half_x, shot.shape[1])
    y0, y1 = max(cy - half_y, 0), min(cy + half_y, shot.shape[0])
    diff = maxdiff(shot, base)
    win_px = int((diff[y0:y1, x0:x1] > delta).sum())
    total_px = int((diff > delta).sum())
    return win_px, total_px, (x0, x1, y0, y1)


def crop_delta_count(live_path, base_path, box, floor):
    """The s8 crop_nonbg contract: open both PNGs, crop to box, count pixels
    whose maxdiff is >= floor; -1 on a size mismatch (the legs' sentinel)."""
    im = Image.open(live_path).convert("RGB").crop(box)
    bg = Image.open(base_path).convert("RGB").crop(box)
    if im.size != bg.size:
        return -1
    a = np.asarray(im, dtype=np.int16)
    b = np.asarray(bg, dtype=np.int16)
    return int((maxdiff(a, b) >= floor).sum())
