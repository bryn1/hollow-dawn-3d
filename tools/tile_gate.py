#!/usr/bin/env python3
"""MC 11361 (T-M4a) — the ONE committed biome-tile gate, landing per
M4-SPEC §4 (REV 3, MC 11334): "no committed gate script exists for them —
grep tools/ at card time; if still absent, this card LANDS the one gate
tools/tile_gate.py with those thresholds + a planted out-of-band red, the
same move §j made for icons". The measurements are the T-S15 set VERBATIM
(the repo's untracked scratch measure at .tmp/measure_tiles.py, donor of
this file — same formulas, same thresholds, named at fcfde6f):

  WRAP   wrap_h/wrap_v = mean |left 8px strip - right 8px strip| (and the
         top/bottom rows). Seam pass: BOTH axes <= 1.6 x the interior strip
         baseline (base = mean |block - neighbour-of-same-offset| over the
         interior, step 4 px).
  LUMA   mean Rec.709 luma in [26, 36] — the moonlit dark band the v2
         family ships in (T-S10 floors ride <= 34 with headroom).
  EVEN   8 row bands + 8 col bands; max band luma - min band luma <= 8.

Exit 0 only if EVERY file passes EVERY leg; every leg prints for every row
(a gate never short-cuits — a red row must not hide the row after it).
Red-capability (fleet rule "every gate proves it can go RED"): a planted
+luma-20 copy of a shipped tile must exit 1 on the named LUMA leg while
the real files stay green — see the card capture (`.tmp/m4a-art.txt`).

Usage: tile_gate.py <tile.png> [<tile.png>...]  -> one row per file; exit 0
only if every row PASSes.
"""
import sys

import numpy as np
from PIL import Image

STRIP = 8
BANDS = 8
WRAP_MAX = 1.6   # x the interior strip baseline, both axes
LUM_LO, LUM_HI = 26.0, 36.0
EVEN_MAX = 8.0   # 8-band delta (luma units)


def measure(path):
    a = np.asarray(Image.open(path).convert("RGB"), dtype=np.float64)
    g = a @ [0.2126, 0.7152, 0.0722]
    h, w, _ = a.shape
    wrap_h = np.abs(a[:, :STRIP, :] - a[:, -STRIP:, :]).mean()
    wrap_v = np.abs(a[:STRIP, :, :] - a[-STRIP:, :, :]).mean()
    # interior baseline: mean |diff| of neighbouring STRIP-wide blocks,
    # horizontally and vertically sampled across the interior (step 4 px).
    base_h = np.mean([np.abs(a[:, s + STRIP:s + 2 * STRIP, :]
                             - a[:, s:s + STRIP, :]).mean()
                      for s in range(0, w - 2 * STRIP, 4)])
    base_v = np.mean([np.abs(a[s + STRIP:s + 2 * STRIP, :, :]
                             - a[s:s + STRIP, :, :]).mean()
                      for s in range(0, h - 2 * STRIP, 4)])
    base = (base_h + base_v) / 2.0
    rowb = g.reshape(BANDS, h // BANDS, w).mean(axis=(1, 2))
    colb = g.reshape(h, BANDS, w // BANDS).mean(axis=(0, 2))
    even = max(np.concatenate([rowb, colb])) - min(
        np.concatenate([rowb, colb]))
    lum = g.mean()
    return dict(lum=lum, wrap_h=wrap_h, wrap_v=wrap_v, base=base,
                even=even, ratio_h=wrap_h / base, ratio_v=wrap_v / base)


def gate(path):
    m = measure(path)
    ok_wrap = m["ratio_h"] <= WRAP_MAX and m["ratio_v"] <= WRAP_MAX
    ok_lum = LUM_LO <= m["lum"] <= LUM_HI
    ok_even = m["even"] <= EVEN_MAX
    print("TILE %s: LUM=%.1f[26..36] WRAP_H=%.2f WRAP_V=%.2f BASE=%.2f "
          "X_H=%.2f X_V=%.2f[<=%.1f] EVEN=%.2f[<=%.1f] GATE=%s"
          % (path.split("/")[-1], m["lum"], m["wrap_h"], m["wrap_v"],
             m["base"], m["ratio_h"], m["ratio_v"], WRAP_MAX, m["even"],
             EVEN_MAX,
             "PASS" if ok_wrap and ok_lum and ok_even else "FAIL"))
    return ok_wrap and ok_lum and ok_even


if __name__ == "__main__":
    args = sys.argv[1:]
    oks = [gate(p) for p in args]
    sys.exit(0 if args and all(oks) else 1)
