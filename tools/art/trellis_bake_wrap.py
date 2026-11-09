#!/usr/bin/env python3
"""STRIP SEAM for the standing TRELLIS.2 bake path (MC 12334).

WHAT THE SEAM IS, HONESTLY: o_voxel.postprocess.to_glb is ONE monolithic call
(clean -> narrow-band remesh -> decimate -> UV -> TEXTURE BAKE, all inside a CUDA
cumesh/nvdiffrast context; there is no importable stage split and patching
/opt is out of the read-only rule). The gate-lab law ("strip AFTER decimate+
remesh, BEFORE texture bake") is therefore realized as a TWO-PASS to_glb call
around a CPU strip — the only split the vendor surface allows:

  pass 1  to_glb(remesh=True, decimation_target=budget, texture_size=16)
          -> the remeshed+decimated mesh; the bake runs but is discarded (16px
          textures cost milliseconds). The pre-strip GLB is KEPT beside the
          output as <out>.prestrip.glb — debug evidence, not an artifact.
  strip   tools/art/interior_strip.strip_roof (roof rule, gate-lab MC 12320)
  gate    interior_probe probe on the stripped mesh must read CLEAN, else the
          bake is REFUSED (raise) — a mesh that is still double-walled after
          stripping must not ship silently.
  pass 2  to_glb(remesh=False, decimation_target=budget, texture_size=<real>)
          on the stripped mesh -> the FINAL textured GLB. remesh=False is
          mandatory: pass-1's dual-grid remesh is what re-creates the double
          skin; pass 2 only cleans + UVs + bakes the stripped geometry.

Gate law (MC 12334): the probe's --selftest contract runs ONCE per process
BEFORE the first bake; controls failing REFUSES the bake (RuntimeError). The
strip itself costs ~800-1000 s CPU per ~950k-tri asset (gate-lab measurement)
— the GPU window idles during the strip; that price is the law, not a bug.

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
_SELFTEST = None                 # per-process latch: run once, refuse forever on fail


def _to_torch(x):
    import torch
    dtype = torch.int64 if np.asarray(x).dtype.kind in "iu" else torch.float32
    return torch.as_tensor(np.asarray(x), dtype=dtype)


def bake_glb_stripped(gen, out_path, budget, *, to_glb, to_torch=None,
                      texture_size=2048, log=print):
    """Two-pass seam around the standing bake. `gen` is the to_glb geometry
    kwargs (vertices, faces, attr_volume, coords, attr_layout, voxel_size,
    aabb). Returns (tris_after_strip). Raises RuntimeError on a gate refusal."""
    global _SELFTEST
    if _SELFTEST is None:
        log("interior-gate: running probe --selftest calibration contract...")
        _SELFTEST = bool(selftest_ok())
    if not _SELFTEST:
        raise RuntimeError("INTERIOR-GATE REFUSED: probe selftest controls "
                           "failed — refusing to bake (gate law, MC 12334)")
    to_torch = to_torch or _to_torch
    pre = out_path + ".prestrip.glb"
    log(f"seam pass 1: remesh+decimate (throwaway texture {PASS1_TEXTURE_SIZE})")
    glb1 = to_glb(decimation_target=int(budget),
                  texture_size=PASS1_TEXTURE_SIZE, remesh=True, remesh_band=1,
                  remesh_project=0, verbose=False, **gen)
    glb1.export(pre)
    m = load_merged(pre)
    s, marked = strip_roof(m)
    log(f"seam strip: {len(m.faces)} -> {len(s.faces)} faces (marked {marked})")
    if probe(s, os.path.basename(pre) + " STRIPPED"):
        raise RuntimeError("INTERIOR-GATE REFUSED: stripped mesh still probes "
                           "INTERIOR — mesh not exported")
    log(f"seam pass 2: re-bake on stripped mesh (remesh=False, texture "
        f"{texture_size})")
    glb2 = to_glb(decimation_target=int(budget),
                  texture_size=int(texture_size), remesh=False, verbose=False,
                  **{**gen, "vertices": to_torch(s.vertices),
                     "faces": to_torch(s.faces)})
    glb2.export(out_path)
    return len(s.faces)


if __name__ == "__main__":
    print(__doc__)
    sys.exit(2)
