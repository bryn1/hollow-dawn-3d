"""Shared test-side seams (MC 11317 C2; audit MC 11316 §2.4/§2.5/§3.1/§5).

ONE home for what the suite used to copy per file: the jsonl dump readers,
the source-pin helpers (read/const/block) and the frozen Contract-B key
list. Moved helpers are byte-identical to their donors (capture rows in
.tmp/clean-code.txt name every file that lost a copy).

DELETED HERE (audit §3.1, zero consumers re-proved THIS card — greps for
server/purge_db/http_request/get_json/post_json/VS_DB/8941/8942/
clean_leaderboard over tests/ return nothing outside this file): the whole
v1-server harness block — the leaderboard-server scaffolding (MC 11026
lineage) the remake carried from the 2D repo. This tree has no server/ and
no static/; the PARITY-ROADMAP row-13 leaderboard claim rides the vendored
v1 server, NOT this suite. The stale "REAL server as a subprocess" docstring
goes with it (audit §4.2 folded row).
"""
import atexit
import json
import os
import re
import shutil
import subprocess
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS = os.path.join(REPO, "godot", "scripts")

# The pinned engine == tools/VERSIONS.txt:8 (the capture_lib resolution),
# HD3D_GODOT the unchanged documented seat override.
GODOT = os.environ.get(
    "HD3D_GODOT",
    "/home/claudecode/Games/.tools/godot/Godot_v4.7.2-stable_linux.x86_64")

CLASS_CACHE = os.path.join(REPO, "godot", ".godot",
                           "global_script_class_cache.cfg")

# ---- HOME-well immunity: the ONE harness seam (MC 11706 T-M6H-XDG; T-M6p
# finding (a), the s8 row of docs/BYTE-DEVIATION-M6.md) -----------------------
# godot's user:// resolves to $XDG_DATA_HOME/godot/app_userdata/<project>
# and FALLS BACK TO $HOME/.local/share when XDG_DATA_HOME is unset — so an
# UNRESET sim inherits the machine's PLAY HISTORY as meta-power (measured at
# card time on this seat's HOME: gold 164, stage2, counters.kills_total
# 2512) and the suite silently pass/fails on it. The immunity lives HERE, at
# the ONE shared bootstrap every test file already imports: a throwaway well
# per pytest RUN, pointed at XDG_DATA_HOME at MODULE-IMPORT time — before
# any probe boot or the --import leg runs — so every subprocess child
# inherits it regardless of author diligence (the suite launches nothing
# outside this process's env). The probes that judge their own user:// FILES
# (save/shop/skins/chars/achv) keep passing their private scratch dirs ON
# TOP of this floor: those are per-test file workspaces, not an immunity
# mechanism — this stays the one seam, none beside it. What it REPLACES is
# the per-card manual "re-run every leg under a throwaway XDG_DATA_HOME"
# step (the T-M6p s8 leg) — no card re-runs that ritual again. Cleaned at
# process exit. Measured by tests/test_xdg_hygiene.py (X-E1 planted-HOME
# red-before/green-after, X-E2 floor-resolution leg).
XDG_WELL = tempfile.mkdtemp(prefix="hd3d-well-")
os.environ["XDG_DATA_HOME"] = XDG_WELL
atexit.register(shutil.rmtree, XDG_WELL, True)


def ensure_class_cache():
    # CLEAN-CHECKOUT FIX (cycle 2), moved to this ONE home at T-M5p (the
    # C3 seam law — the body is byte-identical to its test_save.py donor,
    # which now delegates here): godot/.godot/ — the global class_name
    # cache save.gd's own DawnWell self-reference needs to COMPILE — is
    # gitignored, so a fresh checkout has none and every behavior leg dies
    # at parse (VERIFIED: preload alone cannot dodge it — save.gd itself
    # errors "Identifier not found: DawnWell" without the cache). The fix
    # is the engine's canonical step that the export spine already runs:
    # --headless --import. --import carries a documented post-work
    # shutdown-abort quirk (LEDGER T-S9), so the gate is the cache file,
    # never the rc.
    if os.path.exists(CLASS_CACHE):
        return
    subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(REPO, "godot"),
         "--import"],
        capture_output=True, text=True, timeout=600)
    assert os.path.exists(CLASS_CACHE), \
        "godot --import produced no global class cache"

# The frozen Contract-B 12-field snapshot key list, verbatim (audit §5:
# ONE copy now — test_endless imports this; the sim-side twin at
# godot/sim/sim_stages.gd's `expected` row stays GD on purpose: deduping
# across the language boundary would put the byte corpus behind a test
# import, which the audit's "one conftest constant + import" option
# declares).
SNAPSHOT_KEYS = ["enemies", "gold", "hp", "kills", "level", "maxHp",
                 "phase", "runId", "time", "weapons", "xp", "xpNext"]


# ---- jsonl dump readers (audit §2.4: replaces 10 loader copies) ------------

def jsonl_rows(path):
    """The ONE reader of a committed sim dump: non-blank lines -> dicts,
    order preserved (the dumps are line-appended; byte order IS row order)."""
    out = []
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            if line.strip():
                out.append(json.loads(line))
    return out


def rows_by_ev(path, ev):
    """Rows whose "ev" field equals ev (order preserved) — the ONE filter."""
    return [r for r in jsonl_rows(path) if r.get("ev") == ev]


def stages_row(ev):
    """The ONE reader of the committed stages-m3.jsonl dump (T-M3s, seed
    11282): rows are read through here by every file that judges a replaced
    latch pin, never a second loader."""
    rows = rows_by_ev(os.path.join(REPO, "tests", "fixtures",
                                   "stages-m3.jsonl"), ev)
    assert rows, "stages fixture row %r missing" % ev
    return rows[0]


# ---- source pins (audit §2.5: replaces read x16 / const x11 / block x2) ----

def read_text(path, code_only=False):
    """Source text by path. code_only strips comment text on the way in —
    every structural count is a CODE count (the v1-suite greps raw text;
    here the counts would count prose — the test_boss_numbers law in the
    test_dawnwell_shop single-impl shape, bodies byte-identical to the
    donors)."""
    with open(path, encoding="utf-8") as fh:
        src = fh.read()
    if code_only:
        src = "".join(line.split("#")[0] + "\n" for line in src.splitlines())
    return src


def read_script(name, code_only=False):
    """godot/scripts/<name> through read_text (the SCRIPTS home is ONE)."""
    return read_text(os.path.join(SCRIPTS, name), code_only)


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


def block(source, start_marker, end_marker):
    start = source.index(start_marker)
    rest = source[start:]
    return rest[: rest.index(end_marker)] if end_marker in rest else rest
