#!/usr/bin/env bash
# MC 11108 (T-S1b) — fetch 3 CMU mocap clips as BVH. Run on vm100.
# DATA: CMU Graphics Lab Motion Capture Database, subjects 07 (walk),
# 09 (run), 02 trial 05 (punch -> "attack"). License, verbatim from
# http://mocap.cs.cmu.edu/faqs.php (fetched 2026-10-22):
#   "The motion capture data may be copied, modified, or redistributed
#    without permission."
# BVH FORMAT: the B. Hahne conversion release linked from CMU's own
# resources page, mirrored at github.com/una-dinosauria/cmu-mocap
# (format conversion only; the CMU grant above is the license of record).
# Raw clips land in $OUT/data and are NEVER committed to the repo.
set -euo pipefail
OUT=${1:?usage: 02-fetch-clips.sh <workdir>}
BASE="https://raw.githubusercontent.com/una-dinosauria/cmu-mocap/master/data"
mkdir -p "$OUT/data"
cd "$OUT/data"
# <target> <mirror path>
CLIPS="07_01.bvh 007/07_01.bvh 09_01.bvh 009/09_01.bvh 02_05.bvh 002/02_05.bvh"
set -- $CLIPS
while [ $# -ge 2 ]; do
  t=$1; p=$2; shift 2
  if [ ! -s "$t" ]; then
    curl -fsS --retry 3 --connect-timeout 15 -o "$t" "$BASE/$p"
  fi
done
# integrity: expect > 50 KB each and HIERARCHY header on line 1
ok=1
for f in 07_01.bvh 09_01.bvh 02_05.bvh; do
  sz=$(stat -c%s "$f"); head -1 "$f" | grep -q '^HIERARCHY' || { echo "$f: bad header"; ok=0; }
  [ "$sz" -gt 50000 ] || { echo "$f: suspicious size $sz"; ok=0; }
done
sha256sum 07_01.bvh 09_01.bvh 02_05.bvh | tee sha256.txt
[ $ok -eq 1 ] && echo "FETCH=PASS" || { echo "FETCH=FAIL"; exit 1; }
