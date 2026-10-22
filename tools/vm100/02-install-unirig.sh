#!/usr/bin/env bash
# MC 11096 T-P2-1 — UniRig install on the vm100 spine. Runs WITHOUT the GPU window.
# Why a SECOND env: UniRig pins transformers==4.51.3 + numpy==1.26.4 + bpy==4.2, and bpy 4.2
# ships cp311-only wheels -> needs python 3.11, which vm100 does not have and we will not add
# system-wide. Self-contained python 3.11 via static micromamba under /opt/imagegen —
# no conda/system install. TRELLIS.2 venv3d (py3.10, unpinned transformers) is untouched.
# Rollback: rm -rf /opt/imagegen/venvrig /opt/imagegen/micromamba /opt/imagegen/UniRig
set -uo pipefail
SPINE=/opt/imagegen
VENV=$SPINE/venvrig
REPO=$SPINE/UniRig
MAMBA=$SPINE/micromamba/bin/micromamba
export CUDA_HOME=/usr/local/cuda-12.2
export PATH=$CUDA_HOME/bin:$PATH
export TORCH_CUDA_ARCH_LIST="8.6"
export MAX_JOBS=10
export PIP_DISABLE_PIP_VERSION_CHECK=1
export MAMBA_ROOT_PREFIX=$SPINE/conda-envs
step() { echo "[$(date -u +%FT%TZ)] STEP $*"; }
fail() { echo "[$(date -u +%FT%TZ)] STEP-FAILED: $*"; exit 1; }

step micromamba-static
# micro.mamba.pm api download landed empty on vm100 (silent tar no-op, step "passed");
# use the official static binary asset from micromamba-releases instead, and verify.
if [ ! -x "$MAMBA" ]; then
  mkdir -p "$SPINE/micromamba/bin"
  curl -fsSL https://github.com/mamba-org/micromamba-releases/releases/latest/download/micromamba-linux-64 \
    -o "$MAMBA" && chmod +x "$MAMBA" || fail micromamba
  "$MAMBA" --version || fail micromamba-version
fi

step py311-env
[ -x "$VENV/bin/python" ] || $MAMBA create -y -q -p "$VENV" python=3.11 -c conda-forge || fail py311
$VENV/bin/python -m ensurepip -q 2>/dev/null; $VENV/bin/pip install -q -U pip || fail pip

step torch-2.6.0-cu124
$VENV/bin/python -c "import torch" 2>/dev/null || \
$VENV/bin/pip install -q torch==2.6.0 torchvision --index-url https://download.pytorch.org/whl/cu124 || fail torch

step flash-attn-prebuilt-first
# requirements.txt has flash_attn unpinned; pre-installing the prebuilt wheel keeps
# -r requirements.txt from triggering a source build.
$VENV/bin/python -c "import flash_attn" 2>/dev/null || \
$VENV/bin/pip install -q flash-attn==2.7.3 --no-build-isolation || fail flash-attn

step requirements
cd "$REPO" || fail repo
$VENV/bin/pip install -q -r requirements.txt || fail requirements

step spconv-and-pyg
$VENV/bin/python -c "import spconv" 2>/dev/null || \
$VENV/bin/pip install -q spconv-cu124 || fail spconv
$VENV/bin/python -c "import torch_scatter, torch_cluster" 2>/dev/null || \
$VENV/bin/pip install -q torch_scatter torch_cluster \
  -f https://data.pyg.org/whl/torch-2.6.0+cu124.html --no-cache-dir || fail pyg

step numpy-pin-last
$VENV/bin/pip install -q numpy==1.26.4 || fail numpy

step ckpts-VAST-AI-UniRig
export HF_HOME=$SPINE/models/hf
$VENV/bin/python - <<'EOF' || fail ckpts
from huggingface_hub import hf_hub_download
for f in ("skeleton/articulation-xl_quantization_256/model.ckpt",
          "skin/articulation-xl/model.ckpt"):
    print(hf_hub_download("VAST-AI/UniRig", f))
EOF

step import-check
$VENV/bin/python - <<'EOF' || fail imports
import torch, bpy, trimesh, spconv, open3d, transformers, pyrender
print("py", torch.__version__, "| bpy", bpy.app.version_string,
      "| transformers", transformers.__version__)
EOF
echo "[$(date -u +%FT%TZ)] INSTALL-UNIRIG-DONE"
