#!/usr/bin/env bash
# MC 11108 (T-S1b) — env check for the mocap route. This is the "install script"
# for a deliberate ZERO-INSTALL decision: the chosen route (CMU BVH clips +
# bpy-headless retarget + stdlib glTF validator) needs nothing that is not
# already in /opt/imagegen/venvrig (bpy 4.2.0 + numpy, built by MC 11096).
# Least machinery: no new venv (venvmocap NOT created — a new venv would just
# copy the ~300 MB bpy wheel and add nothing). Run on vm100.
set -u
V=${VENV:-/opt/imagegen/venvrig/bin/python}
fail=0
"$V" - <<'PY' || fail=1
import sys
print("python", sys.version.split()[0])
import bpy
print("bpy", bpy.app.version_string)
assert bpy.app.version[:2] >= (4, 2), "bpy >= 4.2 required"
import numpy
print("numpy", numpy.__version__)
import io_scene_gltf2, io_anim_bvh
print("addons: io_scene_gltf2 (MIT), io_anim_bvh (GPL, tool-only) importable")
PY
[ $fail -eq 0 ] && echo "ENV_CHECK=PASS" || echo "ENV_CHECK=FAIL"
exit $fail
