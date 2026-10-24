#!/usr/bin/env bash
# tools/red_controls/mut_a_invincibility.sh — committed RED CONTROL (TQ-01 fix,
# MC 11252): the sim_headless exit contract must go NON-ZERO when the seeded
# journey never reaches its terminal row.
#
# WHY: audit TESTQUAL TQ-01 (MC 11222 C2) planted a one-line invincibility
# defect (game_state.gd damage_taken -> return 0.0): the journey times out, but
# the declared-warp WIN leg sets _done and, before the fix, the exit check at
# sim_headless.gd (`_fx_bad/_hard_fail` only) masked the journey's _fail — the
# headline runtime gate stayed GREEN while the game was broken. The S2r lesson
# (MC 11138, frozen-control rows in tests/fixtures): a gate is trusted only with
# a COMMITTED red control, revision-tied. This is that control for the journey
# leg: it mutates the ONE damage-intake seam, runs the REAL sim, and FAILS
# LOUD if the gate exits 0 (i.e. the mask regressed); it PASSES when sim_headless
# exits non-zero on the mutated build, and restores the tree byte-exact.
#
# Usage:  HD3D_GODOT=<godot 4.7.2 binary> tools/red_controls/mut_a_invincibility.sh
# Engine default = the tools/VERSIONS.txt pin (same default as tests/test_save.py).
# EXIT: 0 = gate went RED on the planted defect (contract holds); 1 = gate slept
# (mask regression) or the control itself failed. The tree is always restored.
set -uo pipefail

REPO="$(git -C "$(dirname "$0")/../.." rev-parse --show-toplevel)"
cd "$REPO" || exit 1
GODOT="${HD3D_GODOT:-/home/claudecode/Games/.tools/godot/Godot_v4.7.2-stable_linux.x86_64}"
[ -x "$GODOT" ] || { echo "FAIL: engine missing at $GODOT (set HD3D_GODOT)"; exit 1; }

TARGET="godot/scripts/game_state.gd"
# THE pinned line (damage_taken body, tree @ MC 11252 post T-M1h): a drift of
# this seam makes the control FAIL LOUD (assert below) instead of running
# vacuously green — the vacuous-pin lesson from DA-C1 (MC 11239).
PIN='return maxf(0.0, raw - passives.ward - float(passives["rotten-plate"]))'

# class cache for the headless -s run (test_save.py ensure_class_cache pattern)
CACHE="godot/.godot/global_script_class_cache.cfg"
if [ ! -f "$CACHE" ]; then
  echo "-- engine import (fresh tree)"
  timeout 300 "$GODOT" --headless --path godot --import >/dev/null 2>&1 \
    || { echo "FAIL: godot --import"; exit 1; }
fi

restore() { git -C "$REPO" checkout -- "$TARGET"; }
trap restore EXIT

echo "-- plant MUT-A (player invincible: damage_taken -> 0.0) --"
python3 - "$TARGET" "$PIN" <<'PY' || exit 1
import sys
p, pin = sys.argv[1], sys.argv[2]
s = open(p).read()
assert s.count(pin) == 1, "pinned damage line drifted (count=%d): control is" \
    " vacuous — re-pin it against the current damage_taken body" % s.count(pin)
open(p, "w").write(s.replace(pin, "return 0.0 # MUT-A (red control): invincible"))
PY
git diff --stat -- "$TARGET"

DUMP="$(mktemp -t hd3d-mutA-XXXX.jsonl)"
echo "-- run sim_headless on the MUTATED build --"
HD3D_OUT="$DUMP" timeout 900 "$GODOT" --headless --path godot \
  -s res://sim/sim_headless.gd
rc=$?
echo "MUT-A sim_headless EXIT=$rc"
echo "-- dump tell (journey rows) --"
grep -E '"ev":"(gameover|timeout|harness_abort)"' "$DUMP" || echo "(no terminal row)"
rm -f "$DUMP"

if [ "$rc" -eq 124 ]; then
  echo "FAIL: sim_headless HUNG on the mutated build (timeout kill)"
  exit 1
fi
if [ "$rc" -eq 0 ]; then
  echo "FAIL: gate GREEN on a planted invincibility defect — the journey-fail" \
       "mask REGRESSED (sim_headless exited 0 although the journey timed out)."
  exit 1
fi
echo "PASS: mutated build exits non-zero (gate reds on the planted defect)."
echo "RESTORE:"; restore; git diff --quiet -- "$TARGET" && echo "tree byte-exact"
echo "VERIFY: MUTATED_EXIT=$rc EXPECTED=nonzero CONTROL_EXIT=0"
exit 0
