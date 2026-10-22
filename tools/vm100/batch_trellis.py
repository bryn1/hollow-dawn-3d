#!/usr/bin/env python3
"""MC 11118 — TRELLIS.2 batch run: ONE loaded session generates MULTIPLE assets
(amortizes the 163 s model load; MC 11118 brief). Recipe = poc_trellis.py (MC 11096),
reused verbatim: same BiRefNet substitution, same 1024 fp16 pipeline, same to_glb
params — decimation_target is now the per-row tri budget instead of the 1M PoC no-op.
Spec: TSV rows  name<TAB>input.png<TAB>tri_budget<TAB>base_seed.
Fail policy (brief): 3 distinct-seed failures on one row -> SKIPPED row, batch continues.
Usage: batch_trellis.py <spec.tsv> <outdir>"""
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

def attempt(pipe, png, out, seed, budget):
    """One seed: gen + export; up to 3 decimation retries if the export exceeds budget.
    Returns (tris, ok). Raises on gen/export failure (caller counts the seed failure)."""
    image = Image.open(png)
    mesh = pipe.run(image, seed=seed, pipeline_type="1024")[0]
    mesh.simplify(16777216)  # nvdiffrast limit (vendor example)
    for k, frac in enumerate((1.0, 0.8, 0.6)):
        glb = o_voxel.postprocess.to_glb(
            vertices=mesh.vertices, faces=mesh.faces, attr_volume=mesh.attrs,
            coords=mesh.coords, attr_layout=mesh.layout, voxel_size=mesh.voxel_size,
            aabb=[[-0.5, -0.5, -0.5], [0.5, 0.5, 0.5]],
            decimation_target=int(budget * frac), texture_size=2048,
            remesh=True, remesh_band=1, remesh_project=0, verbose=False,
        )
        glb.export(out)
        tris = count_tris(out)
        if tris <= budget:
            return tris, True
        log(f"  decim retry {k+1}: tris={tris} > budget={budget} -> target x{frac*0.8:.2f}")
    return tris, False  # generated but over budget after retries

spec, outdir = sys.argv[1], sys.argv[2]
rows = []
for line in open(spec):
    line = line.strip()
    if line and not line.startswith("#"):
        name, png, budget, seed = line.split("\t")
        rows.append((name, png, int(budget), int(seed)))

t0 = time.time()
log(f"loading pipeline microsoft/TRELLIS.2-4B (one session for {len(rows)} rows)")
pipe = Trellis2ImageTo3DPipeline.from_pretrained("microsoft/TRELLIS.2-4B")
pipe.cuda()
log(f"load_s={time.time()-t0:.1f}")

ok_n = 0
results = []
for name, png, budget, seed in rows:
    out = os.path.join(outdir, f"{name}.glb")
    t = time.time()
    skipped_err = None
    for s in (seed, seed + 1, seed + 2):  # 3 distinct-seed attempts
        try:
            tris, within = attempt(pipe, png, out, s, budget)
            if within:
                ok_n += 1
                results.append((name, "OK", s, tris, budget))
                log(f"ROW {name} OK seed={s} tris={tris}/{budget} "
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
