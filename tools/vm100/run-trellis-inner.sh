#!/usr/bin/env bash
# MC 11096 — TRELLIS.2 proof run body (call inside with-window.sh). No window logic here.
set -uo pipefail
SPINE=/opt/imagegen
OUT=$SPINE/output/mc11096
IN=$SPINE/tmp/mc11096/rime-ghoul.png
PT=${1:-1024}
cd "$SPINE/TRELLIS.2" || exit 1
nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader
export CUDA_HOME=/usr/local/cuda-12.2
export PATH=$CUDA_HOME/bin:$PATH   # nvdiffrast JIT needs nvcc if it must build at runtime
export HF_HUB_OFFLINE=1            # all weights cached incl gated DINOv3; avoids unauth 401s on gated metadata
HF_HOME=$SPINE/models/hf PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True \
  "$SPINE/venv3d/bin/python" "$SPINE/tmp/mc11096/poc_trellis.py" "$IN" "$OUT/ghoul.glb" "$PT"
rc=$?
echo "TRELLIS_RC=$rc"
if [ $rc -eq 0 ]; then
  [ -s "$OUT/ghoul.glb" ] || { echo "ARTIFACT-MISSING: $OUT/ghoul.glb"; exit 1; }
  ls -l "$OUT/ghoul.glb"
  "$SPINE/venv3d/bin/python" "$SPINE/tmp/mc11096/validate_glb.py" visual "$OUT/ghoul.glb"
  echo "VISUAL_VALIDATE_RC=$?"
fi
exit $rc
