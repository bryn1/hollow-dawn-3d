#!/usr/bin/env python3
"""MC 11118 — TRELLIS.2 batch run: ONE loaded session generates MULTIPLE assets
(amortizes the 163 s model load; MC 11118 brief). Recipe = poc_trellis.py (MC 11096),
reused verbatim: same BiRefNet substitution, same 1024 fp16 pipeline, same to_glb
params — decimation_target is now the per-row tri budget instead of the 1M PoC no-op.
Spec: TSV rows  name<TAB>input.png<TAB>tri_budget<TAB>base_seed.
Fail policy (brief): 3 distinct-seed failures on one row -> SKIPPED row, batch continues.
Usage: batch_trellis.py <spec.tsv> <outdir>"""
import argparse
import os, sys, time, traceback
os.environ.setdefault("PYTORCH_CUDA_ALLOC_CONF", "expandable_segments:True")
os.environ.setdefault("OPENCV_IO_ENABLE_OPENEXR", "1")
sys.path.insert(0, "/opt/imagegen/TRELLIS.2")  # trellis2 is the repo dir, not pip-installed
import torch
from PIL import Image
from trellis2.pipelines import Trellis2ImageTo3DPipeline
from trellis2.pipelines import rembg
import o_voxel
import trimesh

# MC 12334 INTERIOR-STRIP GATE (gate-lab law, MC 12319/12320): the bake goes
# through the two-pass seam in tools/art/trellis_bake_wrap.py. Staging note for
# the batch runner: copy tools/art/{interior_probe,interior_strip,
# trellis_bake_wrap}.py NEXT TO this file in the staged run dir (same convention
# as player_attempts.py). Import failure is LOUD by design — there is no
# unstripped fallback path on this pipeline.
for _art in (os.path.join(os.path.dirname(os.path.abspath(__file__)), "art"),
             os.path.dirname(os.path.abspath(__file__))):
    if _art not in sys.path:
        sys.path.insert(0, _art)
from trellis_bake_wrap import bake_glb_stripped

# Substitution carried VERBATIM from poc_trellis.py (MC 11096): pipeline.json names the
# HF-GATED briaai/RMBG-2.0; we run the SAME-architecture MIT ZhengPeng7/BiRefNet and the
# subclass IGNORES the passed name (pipeline.json overrides a default kwarg).
_BiRefNet = rembg.BiRefNet
class _BiRefNetUngated(_BiRefNet):
    def __init__(self, model_name=None):
        super().__init__("ZhengPeng7/BiRefNet")
rembg.BiRefNet = _BiRefNetUngated

def log(msg):
    print(f"[{time.strftime('%FT%TZ')}] {msg}", flush=True)

def count_tris(path):
    sc = trimesh.load(path, force="scene")
    return sum(len(g.faces) for g in sc.geometry.values())

def attempt(pipe, png, out, seed, budget, quality_on=False, no_strip=False):
    """One seed: gen + export; up to 3 decimation retries if the export exceeds budget.
    Returns (tris, ok). Raises on gen/export failure (caller counts the seed failure).
    MC 11207: optional 5th spec column "quality" reuses player_attempts.quality
    (the MC 11118/11134 extent+fill gate) as an ACCEPTANCE leg inside the seed loop —
    a within-budget but flat-card/slab export raises, burning the next seed."""
    image = Image.open(png)
    mesh = pipe.run(image, seed=seed, pipeline_type="1024")[0]
    mesh.simplify(16777216)  # nvdiffrast limit (vendor example)
    gen = dict(vertices=mesh.vertices, faces=mesh.faces, attr_volume=mesh.attrs,
               coords=mesh.coords, attr_layout=mesh.layout,
               voxel_size=mesh.voxel_size,
               aabb=[[-0.5, -0.5, -0.5], [0.5, 0.5, 0.5]])
    for k, frac in enumerate((1.0, 0.8, 0.6)):
        if no_strip:
            # MC 12338 ESCAPE HATCH: the standing single-pass bake, unstripped
            # and LOUD (row tagged OK-UNSTRIPPED below) — the seam's CLEAN gate
            # at the calibrated rung can legitimately refuse a class of mesh;
            # no standing bake may be silently blocked by it. Default is
            # still strip-ON (argparse --no-strip).
            log(f"  NO-STRIP ESCAPE: {os.path.basename(out)} seed={seed} "
                f"baking UNSTRIPPED (standing single-pass to_glb, MC 12338)")
            glb = o_voxel.postprocess.to_glb(decimation_target=int(budget * frac),
                                             texture_size=2048, remesh=True,
                                             remesh_band=1, remesh_project=0,
                                             verbose=False, **gen)
            glb.export(out)
        else:
            # MC 12334/12338: pass 1 remesh at the calibrated rung -> CPU
            # interior strip -> gate CLEAN -> pass 2 budget-decimate + re-bake
            # (header of trellis_bake_wrap.py).
            bake_glb_stripped(gen, out, int(budget * frac),
                              to_glb=o_voxel.postprocess.to_glb, log=log)
        tris = count_tris(out)
        if tris <= budget:
            if quality_on:
                from player_attempts import quality
                if not quality(out, os.path.basename(out) + f" seed={seed}"):
                    raise RuntimeError(f"QUALITY-FAIL seed={seed} tris={tris}/{budget}")
            return tris, True
        log(f"  decim retry {k+1}: tris={tris} > budget={budget} -> target x{frac*0.8:.2f}")
    return tris, False  # generated but over budget after retries

_ap = argparse.ArgumentParser(description="batch TRELLIS.2 bake (MC 11118)")
_ap.add_argument("spec")
_ap.add_argument("outdir")
_ap.add_argument("--no-strip", action="store_true",
                 help="MC 12338 escape hatch: bake UNSTRIPPED through the "
                      "standing single-pass to_glb; LOUD in the log and "
                      "tagged OK-UNSTRIPPED per row (default: strip-ON)")
_args = _ap.parse_args()
spec, outdir, no_strip = _args.spec, _args.outdir, _args.no_strip
rows = []
for line in open(spec):
    line = line.strip()
    if line and not line.startswith("#"):
        parts = line.split("\t")
        name, png, budget, seed = parts[:4]
        q = "quality" in parts[4:]  # MC 11207 optional 5th column; 4-col rows unchanged
        rows.append((name, png, int(budget), int(seed), q))

t0 = time.time()
from player_attempts import drain_barrier  # MC 11118 window-4 lesson, MC 11207: the
drain_barrier()  # barrier moves INTO the shared driver — no batch touches the GPU
                 # while llama-swap is mid-restart, no seed burned (see docstring there)
log(f"loading pipeline microsoft/TRELLIS.2-4B (one session for {len(rows)} rows)")
pipe = Trellis2ImageTo3DPipeline.from_pretrained("microsoft/TRELLIS.2-4B")
pipe.cuda()
log(f"load_s={time.time()-t0:.1f}")

ok_n = 0
results = []
for name, png, budget, seed, q in rows:
    out = os.path.join(outdir, f"{name}.glb")
    t = time.time()
    skipped_err = None
    for s in (seed, seed + 1, seed + 2):  # 3 distinct-seed attempts
        try:
            tris, within = attempt(pipe, png, out, s, budget, quality_on=q,
                                no_strip=no_strip)
            if within:
                ok_n += 1
                results.append((name, "OK-UNSTRIPPED" if no_strip else "OK",
                             s, tris, budget))
                log(f"ROW {name} {'OK-UNSTRIPPED' if no_strip else 'OK'} seed={s} tris={tris}/{budget} "
                    f"bytes={os.path.getsize(out)} secs={time.time()-t:.0f}")
            else:
                results.append((name, "OVERBUDGET", s, tris, budget))
                log(f"ROW {name} OVERBUDGET seed={s} tris={tris}/{budget} (3 decim passes)")
            skipped_err = None
            break
        except Exception as e:
            skipped_err = f"{type(e).__name__}: {e}"
            log(f"ROW {name} FAIL-ATTEMPT seed={s} err={skipped_err}")
            traceback.print_exc()
            torch.cuda.empty_cache()
    else:
        if skipped_err:
            results.append((name, "SKIPPED", "", 0, budget))
            log(f"ROW {name} SKIPPED after 3 distinct-seed failures, last error: {skipped_err}")

log(f"BATCH-DONE ok={ok_n}/{len(rows)} detail=" +
    ";".join(f"{r[0]}:{r[1]}" for r in results))
print("PEAK_VRAM_MIB=", torch.cuda.max_memory_allocated() / 2**20)
sys.exit(0 if ok_n >= 1 else 1)
