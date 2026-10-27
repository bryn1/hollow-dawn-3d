"""Dawn Well save subsystem (MC 11205, PARITY-ROADMAP M1 W-P feature 1).

Two legs, per the roadmap ACCEPT row ("pytest pin of the format keys +
reset-rule table ... quarantine-file existence assertion in the leg
output"):

1. SOURCE TRUTH (the repo's test idiom, test_game_numbers-style): save.gd
   pins the file names, the int VERSION, the four roadmap format keys +
   M2 §A.3's best_cycle (T-M2e replaced rows, LEDGER-logged), the
   temp+rename write path, the SAVE_LOAD_FAIL marker, plus the main.gd
   boot wiring and the meta-change funnel — and the no-run-change rule
   (run gold still only touched by the collect line).
2. BEHAVIOR: godot/sim/save_probe.gd runs every reset/recovery rule for
   real against a throwaway user:// (XDG_DATA_HOME, conftest's
   subprocess-env isolation pattern) on the pinned Godot binary; we judge
   its LEG rows and assert the quarantine stderr markers emitted BY
   save.gd (count + reasons) and the corrupt-copy-kept contents.
"""

import json
import os
import re
import subprocess
import tempfile

import pytest

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
GODOT = conftest.GODOT  # MC 11317 C3 one-home law (T-M5p: the resolution
# + ensure_class_cache moved to conftest verbatim, this file delegates —
# the class-cache gate body is byte-identical to its own prior copy)
PROBE = "res://sim/save_probe.gd"

pytestmark = pytest.mark.skipif(
    not os.path.exists(GODOT), reason="Godot binary not installed")

ensure_class_cache = conftest.ensure_class_cache  # C3 seam (donor of the
# body until T-M5p; the CLEAN-CHECKOUT FIX history comment travels with it)


read = conftest.read_script  # MC 11317 C2 seam (raw script text)


SAVE = read("save.gd")
MAIN = read("main.gd")


const = conftest.const  # MC 11317 C2 seam (impl in conftest.py)


def str_const(name, source):
    m = re.search(r'const\s+%s\s*:=\s*"([^"]+)"' % re.escape(name), source)
    assert m, "string constant %s not found in source" % name
    return m.group(1)


# ---- 1. source-truth pins: format + rules table -----------------------------

def test_file_names_pinned():
    assert str_const("SAVE_PATH", SAVE) == "user://dawnwell.json"
    assert str_const("CORRUPT_PATH", SAVE) == "user://dawnwell.corrupt.json"
    assert str_const("TEMP_PATH", SAVE) == "user://dawnwell.json.tmp"


def test_version_is_int_one():
    assert const("VERSION", SAVE) == 1.0
    assert re.search(r"var\s+version\s*:=\s*VERSION", SAVE)


def test_format_keys_pinned():
    # roadmap format {version:int, gold:int, ranks:{id:rank}, flags:{id:1}}
    # + M2 §A.3's best_cycle:int (T-M2e MC 11237): the four roadmap keys
    # PLUS the field-by-field ADDED row, VERSION unchanged — this row was
    # FALSIFIED BY DESIGN when §A.3 landed the fifth field and REPLACED
    # (LEDGER T-M2e row), not deleted: the exactness of the key set is
    # exactly what pins the format.
    # FALSIFIED-BY-DESIGN AND REPLACED at T-M3s (M3-SPEC §1.4, LEDGER row):
    # the key set gained the stage row — again WITHOUT a version bump (§1.4:
    # the field-by-field defaults rule IS the migration). Exactness remains
    # the pin; the T-M2e wording precedent holds.
    # FALSIFIED-BY-DESIGN AND REPLACED a THIRD time at T-M5p (M5-SPEC §1.1,
    # retire ledger R1, LEDGER row): the key set gained the counters row —
    # again WITHOUT a version bump (the same field-by-field defaults rule;
    # the {} migration default leg lands with the T-M5p probe, named in the
    # R1 equal-or-stronger clause). Exactness remains the pin verbatim.
    m = re.search(r'"version":\s*version,\s*"gold":\s*gold,\s*'
                  r'"ranks":\s*ranks,\s*"flags":\s*flags,\s*'
                  r'"best_cycle":\s*best_cycle,\s*"stage":\s*stage,\s*'
                  r'"counters":\s*counters', SAVE)
    assert m, ("as_data() must serialize exactly the roadmap keys + "
               "best_cycle + stage + counters")


def test_write_path_is_temp_plus_rename():
    assert re.search(r"FileAccess\.open\(TEMP_PATH,\s*FileAccess\.WRITE", SAVE), \
        "save() must write only the temp file"
    assert re.search(r"dir\.rename\(TEMP_PATH", SAVE), \
        "save() must land the file via DirAccess.rename (atomic replace)"
    assert not re.search(r"FileAccess\.open\(SAVE_PATH,\s*FileAccess\.WRITE", SAVE), \
        "save() must never open the real save file for writing"


def test_quarantine_rule_pins():
    assert re.search(r'dir\.rename\(SAVE_PATH\.trim_prefix\("user://"\),\s*'
                     r'CORRUPT_PATH\.trim_prefix\("user://"\)', SAVE), \
        "quarantine() must rename the save to the corrupt path"
    assert re.search(r'printerr\("SAVE_LOAD_FAIL path=%s', SAVE), \
        "quarantine() must print the pinned stderr marker"
    assert re.search(r"save_version > VERSION", SAVE), \
        "load_save() must refuse a version newer than this code knows"


def test_boot_and_funnel_wired_in_main():
    assert re.search(r"_dawnwell\s*=\s*DawnWell\.load_save\(\)", MAIN), \
        "main.gd _ready must load the Dawn Well save at boot"
    assert re.search(r"func _meta_changed\(\) -> void:\s*\n\s*_dawnwell\.save\(\)", MAIN), \
        "main.gd must carry the save-on-meta-change funnel calling save()"
    assert MAIN.count("_dawnwell.save()") == 1, \
        "the funnel is the ONE save call site; the shop (T-M1f) mutates through " \
        "verbs and persists via _meta_changed(), never its own save()"


def test_run_behavior_untouched():
    # run gold stays run-local: the collect line is still its only writer
    # and no DawnWell state appears in the step/end path.
    assert re.search(r"game\.gold \+= world\.collect_pickups\(game\)", MAIN)
    assert "DawnWell" not in MAIN.split("func _step")[1], \
        "no meta-state use inside _step and below except the funnel"
    assert re.search(r"func _meta_changed", MAIN)


# ---- 2. behavior legs: the real save on a real throwaway user:// -----------

@pytest.fixture(scope="module")
def probe():
    """One REAL headless run of save_probe.gd on a throwaway XDG_DATA_HOME
    (user:// lands in /tmp, never the real app_userdata; conftest's
    subprocess-env isolation pattern). Returns (rows, json_text, stderr)."""
    ensure_class_cache()
    scratch = tempfile.mkdtemp(prefix="hd3d-save-")
    r = subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(conftest.REPO, "godot"),
         "-s", PROBE],
        env=dict(os.environ, XDG_DATA_HOME=scratch),
        capture_output=True, text=True, timeout=180)
    assert r.returncode == 0 and "PROBE_DONE" in r.stdout, \
        "probe run failed:\n%s\n%s" % (r.stdout[-2000:], r.stderr[-2000:])
    rows, json_text = {}, None
    for line in r.stdout.splitlines():
        if line.startswith("JSON "):
            json_text = line[len("JSON "):]
        elif line.startswith("LEG "):
            parts = line.split()
            kv = {}
            for tok in parts[2:]:
                k, _, v = tok.partition("=")
                kv[k] = int(v) if re.fullmatch(r"-?\d+", v) else v
            rows[parts[1]] = kv
    return rows, json_text, r.stderr


def test_valid_roundtrip(probe):
    rows, json_text, _ = probe
    assert rows["roundtrip"] == {"ok": 1, "file": 1, "temp_gone": 1}
    disk = json.loads(json_text)
    # FALSIFIED-BY-DESIGN + REPLACED three times, honestly: T-M2e (§A.3
    # best_cycle) then T-M3s (§1.4 stage, LEDGER row), then T-M5p (M5-SPEC
    # §1.1 counters, retire ledger R1 — the third same-commit re-pin, the
    # EXACT grown set named, LEDGER row); exactness of the CURRENT set is
    # the pin, and the reload row now reads the stage back off the disk.
    # R1 equal-or-stronger: the older six still roundtrip byte-true here
    # (the equality row below carries them verbatim), the VERSION==1
    # no-bump leg is test_version_is_int_one (untouched), and the counters
    # {} default leg rides the T-M5p probe (migrate, test_achievements.py).
    assert set(disk) == {"version", "gold", "ranks", "flags", "best_cycle",
                         "stage", "counters"}, \
        "on-disk keys must be exactly the roadmap's four + best_cycle + stage + counters"
    assert disk == {"version": 1, "gold": 123, "ranks": {"might": 2},
                    "flags": {"stage2": 1}, "best_cycle": 3, "stage": 3,
                    "counters": {}}
    assert rows["reload"] == {"gold": 123, "ranks": 2, "flags": 1,
                              "version": 1, "best_cycle": 3, "stage": 3}
    # a stale torn temp must not block the atomic rename (recreate from garbage)
    assert re.search(r'"version":\s*1', json_text), "version must serialize as an int"


def test_missing_file_is_fresh_defaults(probe):
    rows, _, stderr = probe
    assert rows["missing"] == {"defaults": 1, "corrupt_absent": 1}


def test_corrupt_quarantine_observable(probe):
    rows, _, stderr = probe
    assert rows["corrupt"] == {"quarantined": 1, "defaults": 1,
                               "corrupt_present": 1, "save_gone": 1}
    assert rows["corrupt_keep"]["kept"] == "not_json_{{{_half_a_file", \
        "the corrupt copy must be KEPT verbatim for inspection"
    markers = [ln for ln in stderr.splitlines()
               if ln.startswith("SAVE_LOAD_FAIL path=user://dawnwell.json")]
    assert any("reason=undecodable" in m for m in markers), \
        "corrupt load must print the SAVE_LOAD_FAIL marker on stderr"


def test_version_skew_quarantines(probe):
    rows, _, stderr = probe
    assert rows["skew"] == {"quarantined": 1, "defaults": 1, "corrupt_present": 1}
    markers = [ln for ln in stderr.splitlines()
               if ln.startswith("SAVE_LOAD_FAIL path=user://dawnwell.json")]
    assert any("reason=version 999" in m for m in markers), \
        "a future-version save must take the same quarantine path"
    assert len(markers) == 2, "exactly corrupt+skew quarantine, never more"


def test_older_version_migrates_field_by_field(probe):
    rows, _, stderr = probe
    # best_cycle_default=1: A-E5's older-save leg (field absent -> 0, §A.3
    # field-by-field migration, no VERSION bump) — row EXTENDED at T-M2e,
    # and again at T-M3s: stage_default=1 is §1.4's old-save leg (field
    # absent -> the default stage 1, the same no-version-bump rule).
    assert rows["migrate"] == {"gold": 5, "ranks_default": 1,
                               "flags_default": 1, "quarantined": 0,
                               "best_cycle_default": 1, "stage_default": 1}
    assert not any("reason=migrate" in ln for ln in stderr.splitlines())


def test_best_cycle_persists(probe):
    # A-E5 save side: a persisted best_cycle reloads intact (the never-
    # decreases rule is main.gd's, pinned in test_endless + behavior-run in
    # the sim_endless endless_bestcycle leg).
    rows, _, _ = probe
    assert rows["bestcycle"] == {"persisted": 1, "value": 7}


def test_reset_verb(probe):
    rows, _, _ = probe
    assert rows["reset"] == {"file_gone": 1, "gold": 0}


def test_delete_while_running_recreates(probe):
    # UNDEFINED BY DESIGN per roadmap: state re-creates the file on next save.
    rows, _, _ = probe
    assert rows["recreate"] == {"ok": 1, "file_back": 1, "gold": 9}
