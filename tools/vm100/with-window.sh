#!/usr/bin/env bash
# MC 11096 — run one command inside a bounded vm100 GPU window (gpu-window pauses
# llama-swap/knut while open; hard cap 120 min; touches every 10 min so the 20-min
# idle-close cannot fire mid-job; ALWAYS closes on any exit path, trap ends in exit).
# Usage: with-window.sh <minutes> <cmd> [args...]
set -uo pipefail
MIN=${1:?usage: with-window.sh <minutes> <cmd>...}; shift
ts() { date -u +%FT%TZ; }
echo "[$(ts)] GPU-WINDOW before: $(gpu-window status)"
gpu-window open --minutes "$MIN" || { echo "[$(ts)] GPU-WINDOW OPEN FAILED"; exit 1; }
echo "[$(ts)] GPU-WINDOW OPEN (--minutes $MIN)"
closewin() {
  local rc=$?; trap - EXIT INT TERM HUP
  kill "${TPID:-0}" 2>/dev/null
  gpu-window close >/dev/null 2>&1
  echo "[$(ts)] GPU-WINDOW CLOSED rc=$rc after: $(gpu-window status)"
  exit $rc
}
trap closewin EXIT INT TERM HUP
"$@" & PID=$!
( while kill -0 "$PID" 2>/dev/null; do sleep 600; gpu-window touch; done ) & TPID=$!
wait "$PID"; rc=$?
exit $rc
