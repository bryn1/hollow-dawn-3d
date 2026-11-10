#!/usr/bin/env python3
"""INTERIOR-STRIP SEAM for the standing TRELLIS.2 bake path — BAKE-ONCE,
STRIP-AFTER (MC 12342 architecture; supersedes the MC 12334/12338 two-pass
seam, whose dated hazard record is in docs/RIG-DEVIATION-3DR-2.md §Gate-lab
and whose fix history is in git at 5b82094/b54bd6f).

WHY THIS SHAPE (MC 12339 real-mesh evidence): the two-pass seam (remesh ->
strip -> remesh=False re-bake) (i) stripped VISIBLE skin at cloth-over-body
interfaces and the CLEAN gate could not catch it (an opened shell lets probe
rays escape — the metric is gamed by the stripper's own holes), and (ii) the
remesh=False re-bake on an open shell structurally breaks the texture bake
(near-black patchy skin). The inner walls it removes are INVISIBLE — they
carry no pixels — so the correct order is: bake once on the CLOSED remeshed
mesh (full textures, the vendor's own Y-up path, the same single-pass shape
as the --no-strip default), then delete inner faces as PURE GEOMETRY.

  bake   to_glb(remesh=True, decimation_target=budget, texture_size=<real>)
         -> <out>.prestrip.glb KEPT beside the output (textured evidence).
  strip  strip_roof(preserve_visual=True): face-removal only; UVs on kept
         faces are EXACT (update_faces + update_vertices, unit-tested;
         asserted to survive the GLB roundtrip). NEVER a re-bake, NEVER
         remesh after the strip.
  gate   the post-strip probe at the ship rung is a MEASUREMENT row (logged,
         never blocking — ship-rung CLEAN is the wrong target, MC 12339);
         the REAL gate is render parity: tools/art/render_parity.py (4-yaw
         matched-camera solid check + IoU floor vs the same-seed unstripped
         arm; the RED control — a punched hole MUST fail the floor — is
         proven CPU-side in tests/test_art_interior_gate.py; the full bpy
         leg rides the next real bake card).
  cal    the probe --selftest contract (PASS x3 at BOTH rungs) still runs
         once per process BEFORE any strip — a measurement is meaningless
         uncalibrated; controls failing REFUSES (RuntimeError).

Batch default is no-strip (MC 12342 commit 1); this seam is the explicit
--strip opt-in until the render-parity gate has gone GREEN on a real bake.

MC 12352 GATE-INT-V4: bake_then_strip_v2 is the SAME order with the RULE the
card was about — visibility-restricted deletion (tools/art/visibility_strip.py,
whose six-leg --selftest is this seam's calibration). The roof rule above stays
reachable behind --strip only because it is still named by --strip and by the
existing tests; MC 12345 REJECTED it as a ship path, and the batch default is
still strip-OFF for both.
"""
import os
import sys

import trimesh

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from interior_probe import probe, selftest_ok
from interior_strip import strip_roof
from visibility_controls import controls as visible_gate_controls
from visibility_strip import strip_invisible

_SELFTEST = None                 # per-process latch: run once, refuse forever on fail
_SELFTEST_V2 = None              #   same law for the V4 visible-gate contract


def _bake_then(gen, out_path, budget, to_glb, texture_size, log, *,
               calibrate, strip, unit):
    """THE ORDER, in one place (MC 12342, VINDICATED; MC 12352 changed only
    which RULE is applied): bake ONCE on the closed remeshed mesh at full
    texture, keep the textured prestrip export beside the output, then delete
    faces as PURE GEOMETRY. NEVER a re-bake, NEVER remesh after the strip.
    `calibrate()` must return True or this REFUSES; `strip(mesh)` returns
    (kept_mesh, metric) with `unit` naming that metric for the log."""
    if not calibrate():
        raise RuntimeError("INTERIOR-GATE REFUSED: calibration controls failed "
                           "— refusing to bake (gate law, MC 12334)")
    pre = out_path + ".prestrip.glb"
    log(f"seam bake: single closed-remesh bake (decimation_target={budget}, "
        f"texture {texture_size}) — textures intact, prestrip kept")
    glb = to_glb(decimation_target=int(budget),
                 texture_size=int(texture_size), remesh=True, remesh_band=1,
                 remesh_project=0, verbose=False, **gen)
    glb.export(pre)
    m = trimesh.load(pre, force="mesh", process=False)
    s, metric = strip(m)
    log(f"seam strip (pure geometry): {len(m.faces)} -> {len(s.faces)} faces "
        f"({unit}={metric:g}); UVs preserved on kept faces (no re-bake)")
    # MEASUREMENT row (MC 12342): NOT a gate — ship-rung CLEAN is the wrong
    # target, gamed by the stripper's own holes (MC 12339 finding).
    probe(s, os.path.basename(out_path) + " STRIPPED (measurement only)")
    s.export(out_path)
    return len(s.faces)


def _calibrate_v1(log):
    global _SELFTEST
    if _SELFTEST is None:
        log("interior-gate: running probe --selftest calibration contract...")
        _SELFTEST = bool(selftest_ok())
    return _SELFTEST


def _calibrate_v2(log):
    global _SELFTEST_V2
    if _SELFTEST_V2 is None:
        log("visible-gate: running visibility_strip --selftest contract "
            "(six legs, MC 12352)...")
        _SELFTEST_V2 = (visible_gate_controls() == 0)
    return _SELFTEST_V2


def bake_then_strip(gen, out_path, budget, *, to_glb, texture_size=2048,
                    log=print):
    """Roof-rule seam (MC 12342). The RULE here is the one MC 12345 REJECTED
    (it ate visible skin); it stays only because --strip still reaches it and
    its tests pin it. New work rides bake_then_strip_v2."""
    return _bake_then(gen, out_path, budget, to_glb, texture_size, log,
                      calibrate=lambda: _calibrate_v1(log),
                      strip=lambda m: strip_roof(m, preserve_visual=True),
                      unit="marked")


def bake_then_strip_v2(gen, out_path, budget, *, to_glb, texture_size=2048,
                       log=print):
    """GATE-INT-V4 (MC 12352): the same bake-then-strip order, the VISIBILITY
    rule — tools/art/visibility_strip.py keeps every face an external camera
    of the declared set can see (the roof rule's "inner faces are invisible"
    premise is what MC 12345 measured FALSE). Calibration contract is the V4
    module's own six-leg --selftest; red controls REFUSE the bake."""
    return _bake_then(gen, out_path, budget, to_glb, texture_size, log,
                      calibrate=lambda: _calibrate_v2(log),
                      strip=strip_invisible, unit="removed_ratio")


if __name__ == "__main__":
    print(__doc__)
    sys.exit(2)
