"""MC 11706 T-M6H-XDG — HOME-well contamination immunity (T-M6p finding (a),
named in docs/BYTE-DEVIATION-M6.md's s8 row).

Mechanism of the class: godot's user:// resolves to
$XDG_DATA_HOME/godot/app_userdata/<project> and FALLS BACK TO
$HOME/.local/share/... when XDG_DATA_HOME is unset — so any sim that skips
DawnWell.reset inherits the machine's PLAY HISTORY as meta-power (measured
on this seat's HOME at card time: gold 164, stage2 flag, counters.kills_total
2512). Immunity lives at the ONE shared bootstrap — tests/conftest.py pins a
per-run throwaway XDG_DATA_HOME at import, before any probe boot, and every
subprocess child inherits it; THIS file only measures the seam (the sensor is
godot/sim/xdg_probe.gd, reading the well through main.gd's own boot path with
no reset).

  X-E1 planted HOME well cannot reach a sim   META-POWER planted at godot's
       $HOME fallback under a FAKE home; the boot is the WORST-CASE author
       env (it pins HOME and NOTHING ELSE — immunity must not depend on
       author diligence); a pristine sim default is asserted.
  X-E2 user:// lands on the harness floor     the probe's own reported
       user_data_dir == the conftest throwaway, never under $HOME.

RED before the seam (transcripted in the card capture): X-E1 reads the
planted gold/flags, X-E2 resolves under $HOME. GREEN after: both pristine.
"""
import json
import os
import shutil
import subprocess
import tempfile

import conftest

GODOT = conftest.GODOT
REPO = conftest.REPO
PROBE = "res://sim/xdg_probe.gd"

# app_userdata dir name == the project's own config/name, PARSED (a hardcode
# here would drift silently from project.godot — same law as reading the
# boot path through the shipped loader instead of re-implementing it).
PROJECT = [ln.split('="')[1].rstrip('"')
           for ln in conftest.read_text(os.path.join(REPO, "godot",
           "project.godot")).splitlines()
           if ln.startswith("config/name")][0]

# Distinct nonzero values per field (a zero could read as a default): ANY of
# them surfacing in a sim's well row IS the contamination.
POISON = {"version": 1, "gold": 777777, "ranks": {"cleaver": 9},
          "flags": {"stage2": 1, "achv:kills-1k": 1}, "best_cycle": 9,
          "stage": 3, "counters": {"kills_total": 999999}, "char": 2,
          "skin": 1}


def _boot(env_extra=None):
    """One REAL headless probe run through the harness boot stack; the
    LEG-row parser is the conftest jsonl/LEG family's shape."""
    conftest.ensure_class_cache()
    r = subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(REPO, "godot"),
         "-s", PROBE],
        env=dict(os.environ, **(env_extra or {})),
        capture_output=True, text=True, timeout=600)
    lines = r.stdout.splitlines()
    assert "PROBE_DONE" in lines, "xdg probe did not finish:\n%s\n%s" % (
        r.stdout[-2000:], r.stderr[-2000:])
    leg = [ln for ln in lines if ln.startswith("LEG well ")]
    assert len(leg) == 1, lines
    # path= is LAST and may contain SPACES (config/name "Hollow Dawn") —
    # partition before the token split or the app_userdata dir shatters.
    head, _, path = leg[0].partition(" path=")
    row = dict(kv.split("=", 1) for kv in head.split()[2:])
    row["path"] = path
    return row


def _planted_home():
    """A FAKE home with the well planted at godot's $HOME fallback location —
    never the real HOME (the machine's play history is not a test fixture)."""
    home = tempfile.mkdtemp(prefix="hd3d-fake-home-")
    well_dir = os.path.join(home, ".local", "share", "godot",
                            "app_userdata", PROJECT)
    os.makedirs(well_dir)
    with open(os.path.join(well_dir, "dawnwell.json"), "w",
              encoding="utf-8") as fh:
        json.dump(POISON, fh)
    return home


def test_x_e1_planted_home_well_cannot_reach_a_sim():
    home = _planted_home()
    try:
        # WORST-CASE AUTHOR BOOT: the env pins HOME (the contamination) and
        # nothing else — the sim's immunity must come from the harness seam
        # alone, not from this call remembering an XDG scratch of its own.
        row = _boot({"HOME": home})
    finally:
        shutil.rmtree(home, ignore_errors=True)
    assert row["gold"] == "0", "planted meta-power reached the sim: %r" % row
    for field in ("ranks", "flags", "counters"):
        assert row[field] == "0", "%s leaked: %r" % (field, row)
    assert row["best"] == "0" and row["char"] == "0" and row["skin"] == "0"
    assert row["stage"] == "1", "stage leaked: %r" % row  # fresh default


def test_x_e2_user_data_dir_lands_on_the_harness_floor():
    row = _boot()  # plain harness boot: no env pinned at all
    well = os.path.realpath(row["path"])
    floor = os.path.realpath(os.environ["XDG_DATA_HOME"])
    assert well.startswith(floor + os.sep), \
        "user:// resolved %s, outside the harness floor %s" % (well, floor)
    assert not well.startswith(os.path.realpath(
        os.path.expanduser("~")) + os.sep), \
        "user:// resolved under the real HOME: %s" % well
