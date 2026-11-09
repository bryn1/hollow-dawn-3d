#!/usr/bin/env python3
"""RENDER-PARITY GATE for the interior strip (MC 12342 law).

The real gate on a strip bake is NOT the probe (ship-rung CLEAN is the wrong
target and is gamed by the stripper's own holes — MC 12339 finding). The real
gate is what the PLAYER SEES: strip-ON vs the same-seed strip-OFF arm must
render as the same solid figure. This tool owns the deterministic half:

  mask      background = median of the border pixels; object = |px-bg| > tol
  rasterize CPU orthographic silhouette of a mesh (PIL triangle polygons) —
            lets the gate machinery + its RED control be tested WITHOUT bpy
            or GPU. A real card feeds matched-camera bpy renders (the repo's
            tools/vm100/dump_render.py yaw-orbit, MC 11213 idiom) — same
            camera for both arms; the SOLID eyeball leg is the stored-
            describe-image reads (MC 12339 ship-law (d) idiom).
  iou       |A & B| / |A | B| over the object masks.
  FLOOR     0.95. Calibrated on the MC 12339 measurements: the broken seam
            scored 0.741 (yaw0) / 0.803 (yaw90); a correct geometry-only
            strip removes only invisible inner faces and must sit at ~1.0;
            the floor clears the worst measured bad value with margin and
            is enforced by the planted-bad RED control (a deliberate visible
            hole MUST drop below it — tests/test_art_interior_gate.py).

CLI:  render_parity.py A.png B.png [--floor 0.95]
      prints IOU=<x.xxx> and PASS|FAIL; exit 0 pass / 1 fail / 2 usage.
"""
import argparse
import sys

import numpy as np
from PIL import Image, ImageDraw

DEFAULT_FLOOR = 0.95


def mask_from_png(path, tol=30):
    a = np.asarray(Image.open(path).convert("RGB")).astype(int)
    bg = np.median(np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]]), axis=0)
    return np.abs(a - bg).sum(axis=2) > tol


def rasterize(mesh, size=256, axis=2, bounds=None):
    """Orthographic silhouette mask: drop `axis`, map world XY (using shared
    `bounds` — the matched camera) to the canvas, fill triangles."""
    lo, hi = bounds if bounds is not None else (mesh.bounds[0], mesh.bounds[1])
    u, v = [i for i in range(3) if i != axis]
    span = max(float(hi[u] - lo[u]), float(hi[v] - lo[v]))
    def proj(pts):
        x = (pts[:, u] - lo[u]) / span * (size - 1)
        y = (pts[:, v] - lo[v]) / span * (size - 1)
        return np.stack([x, y], axis=1)
    img = Image.new("L", (size, size), 0)
    dr = ImageDraw.Draw(img)
    P = proj(mesh.vertices)[mesh.faces]
    for tri in P.astype(int):
        dr.polygon([tuple(tri[0]), tuple(tri[1]), tuple(tri[2])], fill=255)
    return np.asarray(img) > 127


def iou(a, b):
    union = (a | b).sum()
    return float((a & b).sum()) / float(union) if union else 0.0


def gate_masks(a, b, floor=DEFAULT_FLOOR):
    v = iou(a, b)
    return v, bool(v >= floor)


def main():
    ap = argparse.ArgumentParser(description="silhouette IoU render-parity gate")
    ap.add_argument("a")
    ap.add_argument("b")
    ap.add_argument("--floor", type=float, default=DEFAULT_FLOOR)
    args = ap.parse_args()
    v, ok = gate_masks(mask_from_png(args.a), mask_from_png(args.b),
                       args.floor)
    print(f"IOU={v:.3f} FLOOR={args.floor} " + ("PASS" if ok else "FAIL"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
