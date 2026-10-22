#!/usr/bin/env python3
"""MC 11096 — TRELLIS.2 image->3D proof run. Run from /opt/imagegen/TRELLIS.2.
Usage: poc_trellis.py <input.png> <out.glb> [pipeline_type]
Vendor example.py minus the envmap/video legs (not needed for the GLB DoD).
24GB rules from RESEARCH-3D-3090: <=1024^3, PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True."""
import os, sys, time
os.environ.setdefault("PYTORCH_CUDA_ALLOC_CONF", "expandable_segments:True")
os.environ.setdefault("OPENCV_IO_ENABLE_OPENEXR", "1")
sys.path.insert(0, "/opt/imagegen/TRELLIS.2")  # trellis2 is the repo dir, not pip-installed
import torch
from PIL import Image
from trellis2.pipelines import Trellis2ImageTo3DPipeline
from trellis2.pipelines import rembg
import o_voxel

# Deviation (recorded): pipeline.json names rembg briaai/RMBG-2.0 = HF-GATED
# ("Cannot access gated repo" 401 even from cache without auth). Substituted the
# SAME-architecture original research release ZhengPeng7/BiRefNet (MIT, ungated,
# cached). The gated repo id arrives as an explicit kwarg from pipeline.json, so the
# subclass IGNORES the passed name (v1 defect: default kwarg was overridden by caller).
_BiRefNet = rembg.BiRefNet
class _BiRefNetUngated(_BiRefNet):
    def __init__(self, model_name=None):
        super().__init__("ZhengPeng7/BiRefNet")
rembg.BiRefNet = _BiRefNetUngated

inp, out = sys.argv[1], sys.argv[2]
ptype = sys.argv[3] if len(sys.argv) > 3 else "1024"
t0 = time.time()

print(f"[{time.strftime('%FT%TZ')}] loading pipeline microsoft/TRELLIS.2-4B")
pipe = Trellis2ImageTo3DPipeline.from_pretrained("microsoft/TRELLIS.2-4B")
pipe.cuda()
print(f"load_s={time.time()-t0:.1f}")

t = time.time()
image = Image.open(inp)
mesh = pipe.run(image, seed=42, pipeline_type=ptype)[0]
mesh.simplify(16777216)  # nvdiffrast limit (vendor example)
print(f"gen_s={time.time()-t:.1f} pipeline_type={ptype}")
print("peak_vram_mib=", torch.cuda.max_memory_allocated() / 2**20)

t = time.time()
glb = o_voxel.postprocess.to_glb(
    vertices=mesh.vertices, faces=mesh.faces, attr_volume=mesh.attrs,
    coords=mesh.coords, attr_layout=mesh.layout, voxel_size=mesh.voxel_size,
    aabb=[[-0.5, -0.5, -0.5], [0.5, 0.5, 0.5]],
    decimation_target=1000000, texture_size=2048,
    remesh=True, remesh_band=1, remesh_project=0, verbose=True,
)
glb.export(out)  # PNG textures (larger than webp, no codec risk downstream)
print(f"glb_s={time.time()-t:.1f} bytes={os.path.getsize(out)} -> {out}")
