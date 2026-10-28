#!/usr/bin/env python3
"""ONE capture-launcher seam (MC 11317 C1; audit MC 11316 §2.2).

Every Xvfb GL capture under tools/ launches the pinned engine the same way:
    xvfb-run -a $HD3D_GODOT --render-driver opengl3 --path <repo>/godot -s <script>
Four gates carried VERBATIM copies of that launcher plus the same binary
resolution (the path literal's other homes: this seam and the tools/
VERSIONS.txt pin doc, which stays a doc). ONE resolution (godot_bin), ONE
launcher (run_capture): same argv, same env discipline — every caller passes
its HD3D_* output dirs as ABSOLUTE paths (they already did; the seam only
drops the redundant cwd=REPO + relative --path pair). The CAPTURE_OK check
stays with each caller: the gates' own printed rows + planted-red runs are
the output-identity acceptance (re-run counts in .tmp/clean-code.txt).
"""
import os
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# The pinned engine == tools/VERSIONS.txt:8; HD3D_GODOT is the unchanged,
# documented seat override.
GODOT_DEFAULT = "/home/claudecode/Games/.tools/godot/" \
    "Godot_v4.7.2-stable_linux.x86_64"


def godot_bin():
    return os.environ.get("HD3D_GODOT", GODOT_DEFAULT)


def run_capture(script, env_extra=None, timeout=900, user_args=None):
    """One capture under xvfb. Returns the CompletedProcess (text; stdout and
    stderr captured separately so each caller keeps its own CAPTURE_OK check:
    chest/dawnwell/bulk judge stdout, biome/upgrades judge stdout+stderr).
    user_args (MC 11573, audit-3 §4.2 wire) ride AFTER the engine's `--`
    separator — the OS.get_cmdline_user_args() channel captures like
    roster_capture.gd read their job/out args from; argv before `--` and the
    env discipline stay the ONE shape every existing caller already passes."""
    env = dict(os.environ, **(env_extra or {}))
    argv = ["xvfb-run", "-a", godot_bin(), "--render-driver", "opengl3",
            "--path", os.path.join(REPO, "godot"), "-s", script]
    if user_args:
        argv += ["--"] + list(user_args)
    return subprocess.run(argv, env=env, capture_output=True, text=True,
                          timeout=timeout)
