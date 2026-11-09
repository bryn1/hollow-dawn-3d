#!/usr/bin/env python3
"""STRIP SEAM for the standing TRELLIS.2 bake path (MC 12334; RE-RUNNED MC
12338 — see RUNG below).

WHAT THE SEAM IS, HONESTLY: o_voxel.postprocess.to_glb is ONE monolithic call
(clean -> narrow-band remesh -> decimate -> UV -> TEXTURE BAKE, all inside a CUDA
cumesh/nvdiffrast context; there is no importable stage split and patching
/opt is out of the read-only rule). The gate-lab law is realized as a TWO-PASS
to_glb call around a CPU strip — the only split the vendor surface allows:

  pass 1  to_glb(remesh=True, decimation_target=PASS1_DECIMATION (~1M),
          texture_size=16) -> the remeshed mesh at the CALIBRATED RUNG. The
          bake runs but is discarded (16px textures cost milliseconds). The
          pre-strip GLB is KEPT beside the output as <out>.prestrip.glb —
          debug evidence, not an artifact.
  strip   tools/art/interior_strip.strip_roof (roof rule, gate-lab MC 12320)
  gate    interior_probe on the stripped mesh, AT THE CALIBRATED RUNG, must
          read CLEAN, else the bake is REFUSED (raise).
  pass 2  to_glb(remesh=False, decimation_target=budget, texture_size=<real>)
          on the stripped mesh -> the FINAL textured GLB. The BUDGET
          DECIMATION runs HERE, after the strip. remesh=False is mandatory:
          pass-1's dual-grid remesh is what re-creates the double skin; pass 2
          only decimates + cleans + UVs + bakes the stripped geometry.

RUNG (the MC 12338 fix): the 12334 pass-1 decimated straight to the ship
budget BEFORE the strip. MC 12337 measured why that is dead — at an 8k-tri
budget the decimation has already WELDED the double skin into single sheets
(nothing to strip), and the residual two-sided thin features keep
interior_frac ~0.73 for ANY bake of that class (the OFF arm read 0.9425; the
shipped char-emberwright itself 0.939): the CLEAN gate cannot pass there, so
every standing bake would be blocked. Wall pairs are resolvable at the ~1M
remesh rung, which is exactly where gate-lab (MC 12320) calibrated strip ->
CLEAN — so strip and gate live at PASS1_DECIMATION and the budget binds only
at the end. The SHIP-RUNG benefit is NOT gated by tri count (the old <=65%
row is DROPPED, both arms land at the same budget): it is measured as
interior_frac strip-OFF vs strip-ON AT THE SHIP RUNG, same ref/seed/budget,
plus matched-camera render parity (MC 12337 re-run law).

Gate law (MC 12334): the probe's --selftest contract (PASS x3 at BOTH rungs
since MC 12338) runs ONCE per process BEFORE the first bake; controls failing
REFUSES the bake (RuntimeError). Costs (gate-lab measurements): the strip
runs ~800-1000 s CPU on the ~1M-tri mesh — the GPU window idles; pass 1's
glb export at 1M tris is tens of seconds. That price is the law, not a bug.

Injection points (to_glb, to_torch) exist for the CPU unit test — the real
caller (tools/vm100/batch_trellis.py) passes the vendor function. torch is
imported LAZILY inside _to_torch so this module loads on GPU-less seats.
"""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from interior_probe import load_merged, probe, selftest_ok
from interior_strip import strip_roof

PASS1_TEXTURE_SIZE = 16          # throwaway: pass 1 exists for geometry only
# MC 12338 RUNG: strip+gate run at the rung where gate-lab (MC 12320)
# calibrated strip->CLEAN: walls are RESOLVABLE there (~1M-tri remesh), not at
# the 8k ship budget (MC 12337: welded sheets, CLEAN unpassable). Matches the
# P1 evidence mesh (~993k).
PASS1_DECIMATION = 1_000_000
_SELFTEST = None                 # per-process latch: run once, refuse forever on fail


def _to_torch(x):
    import torch
    dtype = torch.int64 if np.asarray(x).dtype.kind in "iu" else torch.float32
    return torch.as_tensor(np.asarray(x), dtype=dtype)


def bake_glb_stripped(gen, out_path, budget, *, to_glb, to_torch=None,
                      texture_size=2048, log=print):
    """Two-pass seam around the standing bake. `gen` is the to_glb geometry
    kwargs (vertices, faces, attr_volume, coords, attr_layout, voxel_size,
    aabb). Returns the FINAL (budget-decimated) tri count. Raises RuntimeError
    on a gate refusal. ORDER IS THE FIX (MC 12338): strip + gate at
    PASS1_DECIMATION, the budget binds only in pass 2."""
    global _SELFTEST
    if _SELFTEST is None:
        log("interior-gate: running probe --selftest calibration contract...")
        _SELFTEST = bool(selftest_ok())
    if not _SELFTEST:
        raise RuntimeError("INTERIOR-GATE REFUSED: probe selftest controls "
                           "failed — refusing to bake (gate law, MC 12334)")
    to_torch = to_torch or _to_torch
    pre = out_path + ".prestrip.glb"
    log(f"seam pass 1: remesh at the CALIBRATED RUNG (decimation_target="
        f"{PASS1_DECIMATION}, throwaway texture {PASS1_TEXTURE_SIZE})")
    glb1 = to_glb(decimation_target=PASS1_DECIMATION,
                  texture_size=PASS1_TEXTURE_SIZE, remesh=True, remesh_band=1,
                  remesh_project=0, verbose=False, **gen)
    glb1.export(pre)
    m = load_merged(pre)
    s, marked = strip_roof(m)
    log(f"seam strip: {len(m.faces)} -> {len(s.faces)} faces (marked {marked})")
    if probe(s, os.path.basename(pre) + " STRIPPED"):
        raise RuntimeError("INTERIOR-GATE REFUSED: stripped mesh still probes "
                           "INTERIOR — mesh not exported")
    log(f"seam pass 2: budget-decimate + re-bake the stripped mesh "
        f"(decimation_target={budget}, remesh=False, texture {texture_size})")
    glb2 = to_glb(decimation_target=int(budget),
                  texture_size=int(texture_size), remesh=False, verbose=False,
                  **{**gen, "vertices": to_torch(s.vertices),
                     "faces": to_torch(s.faces)})
    glb2.export(out_path)
    return len(load_merged(out_path).faces)


if __name__ == "__main__":
    print(__doc__)
    sys.exit(2)
