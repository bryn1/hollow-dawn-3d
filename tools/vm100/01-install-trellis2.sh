#!/usr/bin/env bash
# MC 11096 T-P2-1 — TRELLIS.2 install on the vm100 imagegen spine (sibling venv venv3d).
# Runs WITHOUT the GPU window (pip/build/download only). Idempotent; safe to re-run.
# Chosen layout: venv at /opt/imagegen/venv3d (system py3.10), repo /opt/imagegen/TRELLIS.2,
# weights in ONE shared HF cache /opt/imagegen/models/hf (one model zoo).
# Deviations from vendor setup.sh (recorded): no conda (venv), gradio/tensorboard/pillow-simd
# skipped (not imported by trellis2/; pillow-simd is dead upstream), apt untouched.
# Rollback: rm -rf /opt/imagegen/venv3d /opt/imagegen/TRELLIS.2 /tmp/extensions-mc11096 \
#           /opt/imagegen/models/hf
set -uo pipefail
SPINE=/opt/imagegen
VENV=$SPINE/venv3d
REPO=$SPINE/TRELLIS.2
PIP=$VENV/bin/pip
export CUDA_HOME=/usr/local/cuda-12.2
export PATH=$CUDA_HOME/bin:$PATH
export TORCH_CUDA_ARCH_LIST="8.6"   # 3090 = sm_86; single-arch builds
export MAX_JOBS=10
export PIP_DISABLE_PIP_VERSION_CHECK=1
step() { echo "[$(date -u +%FT%TZ)] STEP $*"; }
fail() { echo "[$(date -u +%FT%TZ)] STEP-FAILED: $*"; exit 1; }

step venv
[ -x "$VENV/bin/pip" ] || python3 -m venv "$VENV" || fail venv
$PIP install -q -U pip setuptools wheel || fail pip-upgrade

step torch-2.6.0-cu124
$VENV/bin/python -c "import torch" 2>/dev/null || \
$PIP install -q torch==2.6.0 torchvision==0.21.0 --index-url https://download.pytorch.org/whl/cu124 || fail torch

step repo-submodules
cd "$REPO" || fail repo
git submodule update --init --recursive --quiet || fail submodules

step basic-deps
$PIP install -q imageio imageio-ffmpeg tqdm easydict opencv-python-headless ninja \
  trimesh transformers lpips zstandard pandas kornia timm huggingface_hub || fail basic
$PIP install -q "utils3d @ git+https://github.com/EasternJournalist/utils3d.git@9a4eb15e4021b67b12c460c7057d642626897ec8" || fail utils3d

step flash-attn-2.7.3
$VENV/bin/python -c "import flash_attn" 2>/dev/null || \
$PIP install -q flash-attn==2.7.3 --no-build-isolation || fail flash-attn

step cuda-ext-nvdiffrast-nvdiffrec-cumesh-flexgemm-o-voxel
EXT=/tmp/extensions-mc11096; mkdir -p "$EXT"
[ -d $EXT/nvdiffrast ] || git clone -q -b v0.4.0 https://github.com/NVlabs/nvdiffrast.git $EXT/nvdiffrast || fail clone-nvdiffrast
$PIP install -q $EXT/nvdiffrast --no-build-isolation || fail nvdiffrast
[ -d $EXT/nvdiffrec ] || git clone -q -b renderutils https://github.com/JeffreyXiang/nvdiffrec.git $EXT/nvdiffrec || fail clone-nvdiffrec
$PIP install -q $EXT/nvdiffrec --no-build-isolation || fail nvdiffrec
[ -d $EXT/CuMesh ] || git clone -q --recursive https://github.com/JeffreyXiang/CuMesh.git $EXT/CuMesh || fail clone-cumesh
$PIP install -q $EXT/CuMesh --no-build-isolation || fail cumesh
[ -d $EXT/FlexGEMM ] || git clone -q --recursive https://github.com/JeffreyXiang/FlexGEMM.git $EXT/FlexGEMM || fail clone-flexgemm
$PIP install -q $EXT/FlexGEMM --no-build-isolation || fail flexgemm
rm -rf $EXT/o-voxel && cp -r "$REPO/o-voxel" $EXT/o-voxel || fail cp-o-voxel
$PIP install -q $EXT/o-voxel --no-build-isolation || fail o-voxel

step weights-microsoft-TRELLIS.2-4B
export HF_HOME=$SPINE/models/hf
$VENV/bin/hf download microsoft/TRELLIS.2-4B || fail weights

step import-check
$VENV/bin/python - <<'EOF' || fail imports
import torch, trimesh, transformers
import o_voxel, cumesh, flash_attn, nvdiffrast
import trellis2.pipelines, trellis2.utils
print("torch", torch.__version__, "| transformers", transformers.__version__,
      "| cuda_ok", torch.cuda.is_available())
EOF
echo "[$(date -u +%FT%TZ)] INSTALL-TRELLIS2-DONE"
