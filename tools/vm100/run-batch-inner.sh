#!/usr/bin/env bash
# MC 11118 — TRELLIS.2 batch run body (call inside with-window.sh). Env identical to
# run-trellis-inner.sh (MC 11096): HF offline (all weights cached incl gated DINOv3),
# CUDA 12.2 for nvdiffrast JIT, venv3d. Usage: run-batch-inner.sh <spec.tsv> [runid]
# MC 11207: optional runid (default mc11118 — S1a callers unchanged) selects the staged
# scripts /opt/imagegen/tmp/<runid>/ and outputs /opt/imagegen/output/<runid>/.
set -uo pipefail
SPINE=/opt/imagegen
SPEC=$(readlink -f "$1")   # resolve BEFORE cd — caller's cwd is not TRELLIS.2 (MC 11118)
RUN=${2:-mc11118}
[ -f "$SPEC" ] || { echo "SPEC-MISSING: $SPEC"; exit 1; }
cd "$SPINE/TRELLIS.2" || exit 1
nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader
export CUDA_HOME=/usr/local/cuda-12.2
export PATH=$CUDA_HOME/bin:$PATH
export HF_HUB_OFFLINE=1
HF_HOME=$SPINE/models/hf PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True \
  "$SPINE/venv3d/bin/python" "$SPINE/tmp/$RUN/batch_trellis.py" "$SPEC" "$SPINE/output/$RUN"
rc=$?
echo "TRELLIS_BATCH_RC=$rc"
# Artifact assertions (per run-trellis-inner.sh discipline: assert FILES, not RC):
missing=0
while IFS=$'\t' read -r name _ _ _; do
  if ! [ -s "$SPINE/output/$RUN/$name.glb" ]; then echo "ARTIFACT-MISSING: $name.glb"; missing=1; fi
done < <(grep -v '^#' "$SPEC" | grep -v '^\s*$')
exit $(( rc || missing ))
