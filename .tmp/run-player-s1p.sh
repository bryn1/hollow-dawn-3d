#!/usr/bin/env bash
# MC 11132 — driver glue for the player row from the remastered sprite. REUSES
# player_attempts.py (drain_barrier + extent/fill gates, unchanged) and
# run-unirig-inner.sh verbatim; this file only adds the MC 11131 env-failure
# classification: a crash with NO "QUALITY" line produced = environment failure
# (llama-swap consumer restart inside the window), NOT a seed attempt -> re-barrier
# (the retry re-invokes player_attempts.py, whose barrier runs first) and retry the
# same seed ONCE; recurrence -> exit 2 (BLOCKED path). Quality REJECT with a QUALITY
# line = seed spent, next seed. Seeds per brief: 42, then 43, 44.
set -uo pipefail
SPR=/opt/imagegen/tmp/mc11132/player-remaster.png
T=/opt/imagegen/tmp/mc11118
O=/opt/imagegen/output/mc11118
OUT132=/opt/imagegen/output/mc11132
mkdir -p "$OUT132"
[ -s "$SPR" ] || { echo "SPRITE-MISSING: $SPR"; exit 1; }
ACCEPT=""
for seed in 42 43 44; do
  status=""
  for try in 1 2; do
    echo "--- attempt seed=$seed try=$try $(date -u +%FT%TZ) ---"
    log=$(python3 "$T/player_attempts.py" "$SPR" "$seed" player 2>&1); rc=$?
    echo "$log"
    if echo "$log" | grep -q "ACCEPTED-SEED=$seed"; then ACCEPT=$seed; break 2; fi
    if echo "$log" | grep -q "^QUALITY"; then status=seed-fail; echo "SEED-SPENT=$seed"; break; fi
    status=env-fail
    echo "ENV-FAIL seed=$seed try=$try rc=$rc — NOT a seed attempt (MC 11131); re-barrier + retry once"
  done
  if [ "$status" = env-fail ]; then
    echo "ABORT-ENV: env failure recurred on seed $seed (MC 11131 fleet defect)"
    exit 2
  fi
done
if [ -z "$ACCEPT" ]; then echo "ALL-SEEDS-REJECTED (quality)"; exit 3; fi
echo "ACCEPTED=$ACCEPT"
UNIRIG_OUT=$OUT132 bash "$T/run-unirig-inner.sh" "$O/player-s$ACCEPT.glb" "$OUT132/player-rigged.glb" "player-s$ACCEPT"
echo "UNIRIG_RC=$?"
