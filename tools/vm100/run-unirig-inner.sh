#!/usr/bin/env bash
# MC 11096 — UniRig rig pipeline (skeleton -> skin -> merge). Call inside with-window.sh.
# Usage: run-unirig-inner.sh <input.glb> <rigged-out.glb> <stem>
# Artifact assertions: UniRig's launch scripts end in bare `wait` and can exit 0 while
# having produced nothing (proven 2026-10-22, skin-stage crash). We check FILES, not RC.
set -uo pipefail
SPINE=/opt/imagegen
IN="$1"; OUTGLB="$2"; STEM="$3"
OUT=${UNIRIG_OUT:-$SPINE/output/mc11096}   # MC 11118: env-overrideable out dir
SK="$OUT/${STEM}_skeleton.fbx"; SKIN="$OUT/${STEM}_skin.fbx"
cd "$SPINE/UniRig" || exit 1
export HF_HOME=$SPINE/models/hf PATH="$SPINE/venvrig/bin:$PATH"
nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader

stage() {
  local t0; t0=$(date +%s)
  echo "=== $(date -u +%FT%TZ) $* ==="
  "$@"
  local rc=$?
  echo "STAGE rc=$rc secs=$(( $(date +%s) - t0 )) for: $*"
  return $rc
}

stage bash launch/inference/generate_skeleton.sh --input "$IN" --output "$SK"
[ -s "$SK" ] || { echo "ARTIFACT-MISSING: $SK"; exit 1; }

stage bash launch/inference/generate_skin.sh --input "$SK" --output "$SKIN"
if [ ! -s "$SKIN" ]; then
  found=$(find results -name 'result_fbx.fbx' -newer "$SK" 2>/dev/null | head -1)
  if [ -n "$found" ]; then cp "$found" "$SKIN"; echo "skin recovered from $found"; fi
fi
[ -s "$SKIN" ] || { echo "ARTIFACT-MISSING: $SKIN"; exit 1; }

stage bash launch/inference/merge.sh --source "$SKIN" --target "$IN" --output "$OUTGLB"
[ -s "$OUTGLB" ] || { echo "ARTIFACT-MISSING: $OUTGLB"; exit 1; }
ls -l "$OUTGLB"

"$SPINE/venvrig/bin/python" "$SPINE/tmp/mc11096/validate_glb.py" rig "$OUTGLB"
echo "RIG_VALIDATE_RC=$?"
echo "UNIRIG-CHAIN-DONE"
