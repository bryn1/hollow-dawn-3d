"""SETTINGS (T-M7A, MC 11626) — the eighth overlay, the ONE audio path,
the persisted window mode, the focus-pause option.

ACCEPT rows ride the seams the card names (capture .tmp/m7a.txt):

  S-E1 bus layout          default_bus_layout.tres ships Master/Music/SFX
                           (Master first — the engine's own law) and
                           project.godot names the layout explicitly.
  S-E2 save rows           the FIVE settings fields land in load_save's
                           field-by-field migration (defaults 100/100/100/
                           0/0 = the shipped state), as_data and reset —
                           VERSION unchanged (the best_cycle/stage/
                           counters/char/skin proof restated; the R1
                           exactness regex in test_save.py is an ordered
                           PREFIX match — appended rows are the pattern's
                           own growth path, zero re-pin needed, stated).
  S-E3 eighth overlay      built on the ONE _overlay idiom in screens
                           _ready; the builder moved OUT (settings_page.gd,
                           the RosterSelect/AchievementsPage split law) and
                           calls the passed-in idiom; the menu seam rides
                           the _button idiom; Back lands on show_menu.
  S-E4 main wiring         the three connects; the ONE value verb carries
                           the whitelist (the _stage_chosen stale-panel
                           law) + the no-op guard (B-E5 no-op-no-write) +
                           exactly ONE funnel call, ZERO .save( sites (the
                           funnel occurrence count itself is re-pinned in
                           test_achievements.py same-commit, 11 -> 12).
  S-E5 Enter guard + stub  the menu-Enter guard gains settings_visible
                           (A-E8 shop parity) + the stub surface.
  S-E6 pause law + byte    the _notification law (focus-out + playing +
                           flag -> the shipped game.paused, no new phase)
                           and the BYTE LAW pin: no settings key reaches
                           the _step/_start_game sim region — the sim
                           consumes NOTHING new.
  S-E7 one audio path      AudioServer.set_bus_volume_db exists ONLY in
                           settings.gd (the one-lookup law).
  S-E8 runtime legs        settings_probe.gd on a throwaway user://, TWO
                           real processes (the DoD's quit+relaunch): the
                           click route opens the overlay; slider writes
                           land in REAL AudioServer bus-db read-backs
                           (-6.020600/-12.041200/-1.938200 == 20*log10 of
                           0.5/0.25/0.8 — pinned constants, not a re-call
                           of the mapping); the fullscreen flag lands on
                           disk; the pause option fires BOTH sides; same-
                           value + unknown-key verbs move zero disk bytes;
                           an older save migrates to defaults; the SECOND
                           process boots the well and the buses are
                           already at the persisted dB (boot apply).
"""
import math
import os
import re
import subprocess
import tempfile

import pytest

import conftest

REPO = conftest.REPO
GODOT = conftest.GODOT
PROBE = "res://sim/settings_probe.gd"
SAVE = conftest.read_script("save.gd")
MAIN = conftest.read_script("main.gd")
SCREENS = conftest.read_script("screens.gd")
PAGE = conftest.read_script("settings_page.gd")
SETTINGS = conftest.read_script("settings.gd")
STUB = conftest.read_text(os.path.join(REPO, "godot", "sim",
                                       "stub_screens.gd"))
TRES = conftest.read_text(os.path.join(REPO, "godot",
                                       "default_bus_layout.tres"))
PROJECT = conftest.read_text(os.path.join(REPO, "godot", "project.godot"))

# The DoD's bus-read-back constants: 20*log10(pct/100) at the probe's
# slider positions — measured independently of the GDScript mapping.
DB_50 = "%.6f" % (20 * math.log10(0.5))     # -6.020599..
DB_25 = "%.6f" % (20 * math.log10(0.25))    # -12.041199..
DB_80 = "%.6f" % (20 * math.log10(0.8))     # -1.938200..


def _run_probe(scratch, mode):
    env = dict(os.environ, XDG_DATA_HOME=scratch, HD3D_SETTINGS_MODE=mode)
    r = subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(REPO, "godot"),
         "-s", PROBE],
        env=env, capture_output=True, text=True, timeout=600)
    assert r.returncode == 0 and "PROBE_DONE" in r.stdout, \
        "probe (%s) failed:\n%s\n%s" % (mode, r.stdout[-2000:], r.stderr[-2000:])
    return conftest.parse_legs(r.stdout)  # T-M7B: parser moved to conftest
                                         # (the seam law, byte-identical)


@pytest.fixture(scope="module")
def probe_two_boots():
    """TWO real godot processes on ONE throwaway user:// (the quit+relaunch
    round-trip): the write boot drives the REAL click route and persists;
    the read boot re-reads the well through the shipped _ready path."""
    conftest.ensure_class_cache()
    scratch = tempfile.mkdtemp(prefix="hd3d-settings-")
    written = _run_probe(scratch, "write")
    relaunched = _run_probe(scratch, "read")
    return written, relaunched


# ---- S-E1: the bus layout -----------------------------------------------------

def test_s_e1_bus_layout_master_music_sfx():
    names = re.findall(r'bus/\d/name\s*=\s*&"([^"]+)"', TRES)
    assert names == ["Master", "Music", "SFX"], \
        "the layout must ship Master(0)/Music(1)/SFX(2), got %s" % names
    sends = re.findall(r'bus/([12])/send\s*=\s*0', TRES)
    assert sends == ["1", "2"], "Music + SFX SEND to Master (index 0)"
    assert 'buses/default_bus_layout="res://default_bus_layout.tres"' \
        in PROJECT, "project.godot names the layout explicitly"


# ---- S-E2: the save rows (field-by-field, no version bump) -------------------

def test_s_e2_save_rows_added_not_bumped():
    for key in ("vol_master", "vol_music", "vol_sfx", "fullscreen",
                "pause_lose_focus"):
        assert re.search(r"well\.%s = int\(data\.get\(\"%s\", ?\d+\)\)"
                         % (key, key), SAVE), \
            "%s must load through the field-by-field int migration" % key
        assert '"%s": %s' % (key, key) in \
            SAVE.split("func as_data")[1], "%s must serialize" % key
        assert re.search(r"^\t%s = (100|0)$" % key, SAVE.split(
            "func reset")[1].split("var dir")[0], re.M), \
            "%s must reset to its shipped default" % key
    assert "var vol_master := 100" in SAVE and "var fullscreen := 0" in SAVE, \
        "defaults = the shipped loud windowed state"
    assert conftest.const("VERSION", SAVE) == 1.0, \
        "VERSION unchanged — the migration law, not a bump (R1 lineage)"


# ---- S-E3: the eighth overlay in the ONE style ---------------------------------

def test_s_e3_eighth_overlay_one_idiom():
    assert re.search(r"_settings = _overlay\(\)", SCREENS), \
        "eighth overlay, same idiom"
    assert SCREENS.count("_settings.visible = false") >= 2, \
        "show_menu AND hide_all own it (no-blank law)"
    assert re.search(r"func settings_visible\(\) -> bool", SCREENS)
    assert re.search(r'func show_settings\(well: DawnWell\)', SCREENS)
    assert re.search(r'_button\("Settings", _on_settings\)', SCREENS), \
        "menu gains the button, same idiom"
    assert re.search(r"settings_requested\.emit\(\)", SCREENS)
    assert "SettingsPage.build(self)" in SCREENS, \
        "builder moved OUT (the MC 11573 split law)"
    assert re.search(r"static func build\(s\) -> void", PAGE) and \
        re.search(r"s\._center_box\(s\._settings\)", PAGE), \
        "the builder rides the passed-in ONE panel idiom"
    assert re.search(r"s\.settings_value\.emit\(key, int\(v\)\)", PAGE) and \
        re.search(r"s\.settings_value\.emit\(key, 1 if on else 0\)", PAGE), \
        "sliders + checkboxes emit the ONE value verb"
    assert re.search(r"s\.settings_closed\.emit\(\)", PAGE)
    close = conftest.block(SCREENS, "func close_settings", "\nfunc ")
    assert "show_menu()" in close, "the Back lands on show_menu (family law)"
    assert "set_value_no_signal" in PAGE, \
        "refresh PUSHES the well WITHOUT echoing a write back"


# ---- S-E4: main wiring + the ONE funnel ---------------------------------------

def test_s_e4_verb_contract_and_funnel():
    assert "settings_requested.connect(_open_settings)" in MAIN
    assert "settings_value.connect(_settings_value)" in MAIN
    assert "settings_closed.connect(_close_settings)" in MAIN
    assert re.search(r'SETTINGS_KEYS := \["vol_master", "vol_music", "vol_sfx",'
                     r' "fullscreen",\s*\n\s*"pause_lose_focus"\]', MAIN), \
        "the stale-panel whitelist (the _stage_chosen law inside the verb)"
    verb = conftest.block(MAIN, "func _settings_value", "func _notification")
    assert verb.count("_meta_changed()") == 1 and ".save(" not in verb, \
        "ONE funnel call, zero direct disk writes (the P-E3 shape)"
    assert "if not SETTINGS_KEYS.has(key):" in verb and \
        verb.index("SETTINGS_KEYS.has") < verb.index("_dawnwell.set"), \
        "the guard lands BEFORE the write"
    assert "int(_dawnwell.get(key)) == value" in verb, \
        "no-op writes nothing (the B-E5 disk law)"
    # The occurrence-count pin itself lives in test_achievements.py
    # (funnel re-pin 11 -> 12, same commit — replace-not-delete).
    assert MAIN.count("_meta_changed(") == 12, \
        "the funnel gained EXACTLY the settings verb site"


# ---- S-E5: the menu-Enter guard + stub parity ---------------------------------

def test_s_e5_enter_guard_and_stub_parity():
    presses = conftest.block(MAIN, "func _handle_presses", "func _step")
    assert "not _screens.settings_visible()" in presses, \
        "a settings-open menu cannot Enter-start a run (A-E8 parity)"
    assert re.search(r"func settings_visible\(\) -> bool:\s*\n\s*return false",
                     STUB), "the sim stub carries the surface (parity law)"


# ---- S-E6: the pause law + the sim byte fence ---------------------------------

def test_s_e6_focus_pause_law_and_sim_fence():
    note = MAIN.split("func _notification")[1]
    assert "NOTIFICATION_APPLICATION_FOCUS_OUT" in note and \
        'game.phase == "playing"' in note and \
        "pause_lose_focus" in note and "game.paused = true" in note, \
        "focus-out pauses ONLY a playing run, iff the flag is on"
    for region in (conftest.block(MAIN, "func _step", "func _enter_levelup"),
                   conftest.block(MAIN, "func _start_game",
                                  "func _enter_levelup")):
        for key in ("vol_master", "vol_music", "vol_sfx",
                    "pause_lose_focus"):
            assert key not in region, \
                "the sim consumes NOTHING new (byte law): %s in the loop" % key
    boot = conftest.block(MAIN, "func _ready", "func _register_key_bridge")
    assert "Settings.apply(_dawnwell)" in boot, "boot applies the saved rows"
    assert boot.index("DawnWell.load_save()") < boot.index("Settings.apply"), \
        "apply rides AFTER the well load (the boot order)"


# ---- S-E7: the ONE audio path -------------------------------------------------

def test_s_e7_set_bus_volume_db_is_the_one_home():
    hits = []
    for root, dirs, files in os.walk(os.path.join(REPO, "godot")):
        dirs[:] = [d for d in dirs if d not in (".godot", ".tmp", "assets")]
        for fn in files:
            if fn.endswith(".gd"):
                src = conftest.read_text(os.path.join(root, fn))
                if "set_bus_volume_db" in src:
                    hits.append(fn)
    assert hits == ["settings.gd"], \
        "settings.gd is the ONE caller of set_bus_volume_db, got %s" % hits
    assert "linear_to_db" in SETTINGS and "SILENCE_DB := -60.0" in SETTINGS, \
        "the ONE pct->dB law with the silence floor (no -inf untestable)"


# ---- S-E8: the runtime legs (two real boots = quit + relaunch) ---------------

def test_s_e8_overlay_opens_and_buses_read_back(probe_two_boots):
    w, _ = probe_two_boots
    assert w["open"] == {"clickable": 1, "opens": 1, "menu_hidden": 1}, \
        "the REAL Settings click opens the eighth overlay over the menu"
    assert w["buslayout"] == {"master": 0, "music": 1, "sfx": 2}, \
        "the layout is LIVE (index -1 would be a dead layout)"
    assert w["sliders_db"]["master"] == DB_50 and \
        w["sliders_db"]["music"] == DB_25 and \
        w["sliders_db"]["sfx"] == DB_80, \
        "slider moves land in REAL AudioServer bus-db read-backs"
    assert w["window"]["disk_fs"] == 1 and w["window"]["mode"] not in (3, 4), \
        "fullscreen lands in the save; headless keeps its non-fullscreen \
window mode (the apply guard — headless reports ICONIZED, never 3/4)"


def test_s_e8_pause_option_and_noop_no_write(probe_two_boots):
    w, _ = probe_two_boots
    assert w["pause"]["on_fires"] == 1 and w["pause"]["off_fires"] == 0 \
            and w["pause"]["disk_plf"] == 1, \
        "the pause option pauses focus-out iff on — BOTH sides"
    assert w["noop"]["same"] == 1 and w["noop"]["gold"] == 0, \
        "same-value + out-of-whitelist verbs move ZERO disk bytes"


def test_s_e8_older_save_migrates_clean(probe_two_boots):
    w, _ = probe_two_boots
    assert w["migrate"] == {"vol_master": 100, "vol_music": 100,
                            "vol_sfx": 100, "fullscreen": 0,
                            "pause_lose_focus": 0, "corrupt": 0}, \
        "an older save defaults the new rows (no quarantine) — R1 law"


def test_s_e8_relaunch_reads_it_back(probe_two_boots):
    _, r = probe_two_boots
    row = r["relaunch"]
    assert row["disk_fullscreen"] == 1 and row["disk_pause_lose_focus"] == 1
    assert (row["vol_master"], row["vol_music"], row["vol_sfx"]) == \
        (50, 25, 80), "the save-file read-back IS the persisted state"
    assert row["boot_applied"] == 1 and \
        row["boot_db_master"] == DB_50 and \
        row["boot_db_music"] == DB_25 and \
        row["boot_db_sfx"] == DB_80, \
        "the SECOND process applied the persisted dB AT BOOT (real _ready)"
    assert r["ui_values"] == {"vol_master": 50, "vol_music": 25,
                              "vol_sfx": 80, "fs": 1, "plf": 1}, \
        "the persisted values SHOW in the overlay widgets"
