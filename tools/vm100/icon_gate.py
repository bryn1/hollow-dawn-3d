#!/usr/bin/env python3
"""MC 11207 (T-M1c) — the card-icon legibility gate, reusing the aspect_gate.py
pattern (tools/vm100/aspect_gate.py, MC 11134): measure from the file, print one
row per asset, print BOTH legs for every row (no short-circuit), exit 0 only if
every row PASSes.

Why (icon-era equivalent of the MC 11133 finding): an icon that comes back as a
FRAMED CARD (opaque background plate + border) or as a near-empty/solid slab
passes "file exists, 512px" but is not a legible cutout — same false-confidence
class the mesh gates close for GLBs.

Legs (all printed, all must hold):
  DIMS   512x512 RGBA (DESIGN-3D §j / test_card_icons.py convention)
  TRANSP alpha_min == 0 — a real cutout, not an opaque background plate
  FILL   alpha>=128 coverage in [0.02, 0.90] — not near-empty, not a slab
         (the player_attempts.py flat-card/slab intent, icon scale)
  PROV   PNG tEXt key "impeccable:prompt" non-empty (provenance convention,
         same key tests/test_card_icons.py reads)
Usage: icon_gate.py <icon.png> [<icon.png>...]  -> one row per file; exit 0
only if every row PASSes.
"""
import sys

from PIL import Image

SIZE = (512, 512)
FILL_MIN, FILL_MAX = 0.02, 0.90


def gate(path):
    im = Image.open(path)
    ok_dims = im.size == SIZE and im.mode == "RGBA"
    a = im.convert("RGBA").getchannel("A")
    amin = a.getextrema()[0]
    hist = a.histogram()
    fill = sum(hist[128:]) / float(SIZE[0] * SIZE[1])
    prov = (im.text.get("impeccable:prompt") or "").strip()
    ok = (ok_dims and amin == 0 and FILL_MIN <= fill <= FILL_MAX and bool(prov))
    print("ICON %s: DIMS=%s TRANSP=%s(alpha_min=%d) FILL=%.3f[%g..%g] PROV=%s"
          " GATE=%s" % (path, "OK" if ok_dims else "BAD(%s,%s)" % (im.size, im.mode),
                        "OK" if amin == 0 else "BAD", amin, fill, FILL_MIN, FILL_MAX,
                        "OK" if prov else "MISSING", "PASS" if ok else "FAIL"))
    return ok


def main():
    paths = sys.argv[1:]
    if not paths:
        sys.exit("usage: icon_gate.py <icon.png> [...]")
    fails = [p for p in paths if not gate(p)]
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
