#!/usr/bin/env bash
# MC 11108 (T-S1b) — mocap+retarget pipeline driver. Run on vm100.
# CPU/bpy only: the 3090 GPU window is NOT opened (retarget needs no GPU);
# its status is recorded before/after to prove llama-swap was undisturbed.
# Usage: 00-run-all.sh [workdir]   (default /opt/imagegen/tmp/mc11108)
set -uo pipefail
S="$(cd "$(dirname "$0")" && pwd)"
OUT=${1:-/opt/imagegen/tmp/mc11108}
V=${VENV:-/opt/imagegen/venvrig/bin/python}
GLB="$OUT/hd3d_humanoid_animproof.glb"
mkdir -p "$OUT"
ts(){ date -u +%FT%TZ; }
st(){ echo "[$(ts)] == $1"; start=$SECONDS; }
en(){ echo "[$(ts)] -- $1 done in $((SECONDS-start))s"; }

echo "[$(ts)] GPU-WINDOW (never opened by this job) status: $(gpu-window status 2>&1)"

st "01 env check"
"$S/01-check-env.sh" || { echo "ENV FAIL"; exit 1; }
en "01"

st "02 fetch clips"
bash "$S/02-fetch-clips.sh" "$OUT" || { echo "FETCH FAIL"; exit 1; }
en "02"

st "03 retarget + export"
"$V" "$S/03-build-retarget.py" "$OUT/data" "$GLB" || { echo "BUILD FAIL"; exit 1; }
en "03"

st "04 validate GLB"
"$V" "$S/04-validate-glb.py" "$GLB" expect || { echo "VALIDATE FAIL"; exit 1; }
en "04"

st "red gate (validator must FAIL on a rigged-but-unanimated file)"
RED=/opt/imagegen/tmp/mc11096/synth-plain.glb
if [ -s "$RED" ]; then
  if "$V" "$S/04-validate-glb.py" "$RED" >/dev/null 2>&1; then
    echo "RED GATE FAIL: validator passed an unanimated GLB"; exit 1
  else
    echo "RED GATE OK (exit=$? on synth-plain.glb, as expected)"
  fi
else
  echo "RED GATE SKIPPED (no synth-plain.glb on disk)"
fi
en "red"

ls -la "$GLB"; sha256sum "$GLB"
echo "[$(ts)] GPU-WINDOW after: $(gpu-window status 2>&1)"
echo "RUN=PASS"
