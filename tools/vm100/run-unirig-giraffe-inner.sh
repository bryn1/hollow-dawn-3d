#!/usr/bin/env bash
# MC 11096 — UniRig stack smoke test on the repo's own example (giraffe.glb), via the
# shared artifact-asserting chain script. Proves skeleton->skin->merge + rig-validator
# green case. Call inside with-window.sh.
set -uo pipefail
cd /opt/imagegen/UniRig && ls -l examples/giraffe.glb || exit 1
bash /opt/imagegen/tmp/mc11096/run-unirig-inner.sh \
     examples/giraffe.glb /opt/imagegen/output/mc11096/giraffe-rigged.glb giraffe
echo "GIRAFFE-CHAIN-RC=$?"
