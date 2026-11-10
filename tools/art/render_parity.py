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

FACE-ID FRAMEBUFFER (MC 12352 GATE-INT-V4, same rasterizer, one more output):
  view_basis   a camera direction on the yaw x elevation sphere (mesh frame =
               Z-up, the trimesh frame every tools/art instrument already
               uses; the game rig is camera_rig.gd's ortho 20-deg tilt).
  face_id_buffer the silhouette machinery above, with two additions: (i) an
               optional PERSPECTIVE eye (`dist`, in world units, framed so the
               whole bbox fits — only the ray DIVERGENCE changes), (ii) each
               triangle is filled with its own face id and faces are drawn
               far-to-near, so the surviving value of a pixel is the face that
               eye ACTUALLY sees. Painter's order on centroid depth is the
               CPU choice (no z-buffer, no new dependency — this stays the
               repo's rasterizer, not a second one); the mis-order class and
               the 1-px edge tie-break are named in visibility_strip.py's
               limits section, where the deleting decision is made.
  silhouette   the mask this buffer collapses to (pixel owns some face), for
               matched-camera before/after compares of a GEOMETRY-only edit.

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


# ---- FACE-ID FRAMEBUFFER (MC 12352) — this rasterizer, one more output ------

def view_basis(yaw, elev):
    """Look-FROM unit direction at yaw/elev DEGREES plus its in-plane right/up
    pair, in the mesh frame (Z-up, the trimesh frame tools/art already uses).
    elev is the angle ABOVE the mesh's XY plane: 90 = eye on +Z looking
    straight down (the game rig's 20-deg tilt off straight-down is elev 70,
    camera_rig.gd); 0 = eye in the mesh's own equatorial plane."""
    a, e = np.radians(yaw), np.radians(elev)
    d = np.array([np.cos(e) * np.cos(a), np.cos(e) * np.sin(a), np.sin(e)])
    r = np.cross(d, np.array([0.0, 0.0, 1.0]))
    n = float(np.linalg.norm(r))
    r = np.array([1.0, 0.0, 0.0]) if n < 1e-9 else r / n   # poles: any right
    return d, r, np.cross(d, r)


def frame_focal(bounds, d, r, up, dist, px_span):
    """Focal length in px that fits the SHARED `bounds` box in the canvas for
    one view. Fitting the box (not the mesh) is what makes the framing
    identical for two meshes measured with the same camera — the matched-
    camera law this file was built for."""
    lo, hi = bounds
    corners = np.array([[x, y, z] for x in (lo[0], hi[0])
                        for y in (lo[1], hi[1]) for z in (lo[2], hi[2])])
    depth = corners @ d
    z = np.ones(8) if dist is None else dist + depth
    if np.any(z <= 0):
        raise ValueError(f"eye inside the bounds box (dist={dist}, "
                         f"min z={z.min():.6g}) — an external camera only")
    m = np.maximum(np.abs((corners @ r) / z), np.abs((corners @ up) / z)).max()
    return 0.5 * px_span / m


def face_id_buffer(mesh, size=512, yaw=0.0, elev=0.0, dist=None, bounds=None):
    """ONE external view as a face-id framebuffer: value = face id + 1, 0 =
    background. `dist=None` is ORTHOGRAPHIC (the game's own projection —
    camera_rig.gd sets PROJECTION_ORTHOGONAL); `dist` (world units, bbox
    center to eye) is a perspective eye at the SAME bbox fit, so the only
    difference between the two is ray divergence — a nearer eye sees more of a
    concavity through an opening, never less of a convex shell.
    Faces are painted far-to-near so the surviving pixel value is the face
    that eye actually sees (centroid painter; its limits are declared in
    visibility_strip.py, where deletion decisions are made)."""
    lo, hi = bounds if bounds is not None else (mesh.bounds[0], mesh.bounds[1])
    center = (lo + hi) / 2.0
    d, r, up = view_basis(yaw, elev)
    V = mesh.vertices - center
    depth = V @ d                                  # larger = farther from eye
    f = frame_focal((lo, hi), d, r, up, dist, size - 1)
    if dist is None:
        px, py = (V @ r) * f, (V @ up) * f
    else:
        z = dist + depth
        px, py = f * (V @ r) / z, f * (V @ up) / z
    P = np.stack([px + (size - 1) / 2.0, py + (size - 1) / 2.0], axis=1)
    img = Image.fromarray(np.zeros((size, size), dtype=np.int32))   # mode "I"
    dr = ImageDraw.Draw(img)
    tri = mesh.faces
    for k in np.argsort(-depth[tri].mean(axis=1), kind="stable"):   # far first
        t = P[tri[k]]
        dr.polygon([(float(t[0, 0]), float(t[0, 1])),
                    (float(t[1, 0]), float(t[1, 1])),
                    (float(t[2, 0]), float(t[2, 1]))], fill=int(k) + 1)
    return np.asarray(img, dtype=np.int32)


def silhouette(mesh, size=512, yaw=0.0, elev=0.0, dist=None, bounds=None):
    """The object mask the face-id buffer collapses to (a pixel is ON if some
    face survives there). For matched-camera before/after compares of a
    GEOMETRY-only edit — a hole in the skin is a missing pixel here."""
    return face_id_buffer(mesh, size, yaw, elev, dist, bounds) > 0


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
