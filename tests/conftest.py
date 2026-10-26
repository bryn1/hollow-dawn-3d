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
import json
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS = os.path.join(REPO, "godot", "scripts")

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
