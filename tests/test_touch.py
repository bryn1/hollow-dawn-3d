"""TOUCH CONTROLS (T-M7B, MC 11627) — the virtual joystick + pause-on-tap
for phones/tablets on the WEB export, riding the ONE input seam.

ACCEPT rows (capture .tmp/m7b.txt):

  T-E1 vector identity    touch_probe.gd on a throwaway user://: all EIGHT
                         octant drags land the byte-identical vector of
                         their key pair — GDScript `==` on the ONE
                         move_vector() seam plus python re-derivation of
                         the frozen unit/45-degree vectors at the engine's
                         own float32 rounding — and a held RIGHT drag
                         moves the REAL hero through main._step by
                         speed*dt (the touch drives the shipped
                         integration; no second mover). Deadzone + release
                         idle at ZERO.
  T-E2 tap/pause law      the tap feeds EXACTLY ONE Escape press and the
                         shipped main._handle_presses arm flips the shipped
                         game.paused BOTH ways; a drag-release presses
                         nothing (drag is not a tap) and returning inside
                         the deadzone zeroes the live vector.
  T-E3 one-seam fence     bridge.move_vector() is read EXACTLY ONCE in
                         main (the one-player-path law, motion_capture/
                         sim harnesses aside); the touch codes fold INSIDE
                         move_vector (all four axis tests union the touch
                         dict — the additive law); the tap arm feeds pause
                         ONLY as on_key("Escape"); the paused WRITE walk
                         over godot/scripts shows the two shipped homes
                         only (no pause fork — the T-M7A flag stays alone).
  T-E4 desktop unchanged  probe-leg PROOFS: a native InputEventKey still
                         feeds a desktop bridge and is still DROPPED by a
                         web-gated one (the shipped relay law intact);
                         the overlay paints iff bridge.touch_seen (the
                         PRESENCE law — a desktop never sets it), ignores
                         the mouse (never steals a UI click), writes no
                         paused flag, and rides the HUD-family wiring
                         (one preload, one add, zero connects).
"""
import math
import os
import re
import struct
import subprocess
import tempfile

import pytest

import conftest

REPO = conftest.REPO
GODOT = conftest.GODOT
PROBE = "res://sim/touch_probe.gd"
BRIDGE = conftest.read_script("bridge.gd")
BRIDGE_CODE = conftest.read_script("bridge.gd", code_only=True)
MAIN = conftest.read_script("main.gd")
MAIN_CODE = conftest.read_script("main.gd", code_only=True)
THUD = conftest.read_script("touch_hud.gd")
THUD_CODE = conftest.read_script("touch_hud.gd", code_only=True)

# Vector2 is SINGLE precision: the expected diagonals pass through the
# engine's own float32 rounding (the same bit the probe printed).
F32 = lambda x: struct.unpack("f", struct.pack("f", x))[0]  # noqa: E731
S = F32(1.0 / math.sqrt(2.0))
KEY_VECTORS = [(1.0, 0.0), (S, S), (0.0, 1.0), (-S, S),
               (-1.0, 0.0), (-S, -S), (0.0, -1.0), (S, -S)]
KEY_PAIRS = ["KeyD", "KeyD+KeyS", "KeyS", "KeyA+KeyS",
             "KeyA", "KeyA+KeyW", "KeyW", "KeyW+KeyD"]


def _probe_vectors():
    """The GDScript OCTANTS table + octant math, re-implemented in python
    from the BRIDGE's own TOUCH_OCTANTS const (the replace-not-add fence:
    the test reads the shipped table, never restates it)."""
    body = conftest.block(BRIDGE_CODE, "const TOUCH_OCTANTS", "var touch_seen")
    rows = []
    for m in re.finditer(r"\[([^\[\]]*)\]", body):  # one match = one octant
        rows.append(sorted(c for c in ("ArrowRight", "ArrowLeft", "ArrowDown",
                                       "ArrowUp")
                           if '"%s"' % c in m.group(1)))
    assert len(rows) == 8, "the octant table lost a row: %r" % rows
    return rows


def _pair_codes(keys):
    """'KeyD+KeyS' -> the axis arrows that pair means (one code per
    nonzero axis; the diagonal keeps both)."""
    ax = {"KeyD": "ArrowRight", "KeyA": "ArrowLeft"}
    ay = {"KeyS": "ArrowDown", "KeyW": "ArrowUp"}
    codes = [ax[k] for k in keys.split("+") if k in ax] + \
            [ay[k] for k in keys.split("+") if k in ay]
    return sorted(codes)


@pytest.fixture(scope="module")
def probe():
    conftest.ensure_class_cache()
    scratch = tempfile.mkdtemp(prefix="hd3d-touch-")
    env = dict(os.environ, XDG_DATA_HOME=scratch)
    r = subprocess.run(
        [GODOT, "--headless", "--path", os.path.join(REPO, "godot"),
         "-s", PROBE],
        env=env, capture_output=True, text=True, timeout=600)
    assert r.returncode == 0 and "PROBE_DONE" in r.stdout, \
        "touch probe failed:\n%s\n%s" % (r.stdout[-2000:], r.stderr[-2000:])
    return conftest.parse_legs(r.stdout)


# ---- T-E1: the vector identity through the ONE seam ---------------------------

def test_t_e1_octant_vectors_identical_to_key_pairs(probe):
    table = _probe_vectors()
    for i, (ex, ey) in enumerate(KEY_VECTORS):
        row = probe["vec%d" % i]
        assert row["ident"] == 1, "octant %d vector forks" % i
        tx, ty = (float(t) for t in row["tv"].split("/"))
        kx, ky = (float(t) for t in row["kv"].split("/"))
        for got, want in ((tx, ex), (ty, ey), (kx, ex), (ky, ey)):
            assert abs(got - want) < 1e-6, \
                "octant %d: %r vs %r" % (i, (tx, ty), (ex, ey))
        # the octant the probe fed matches the SHIPPED table row for the
        # key pair this octant must equal (table read from bridge.gd)
        assert row["keys"] == KEY_PAIRS[i], \
            "octant %d key pair renamed: %s" % (i, row["keys"])
        assert table[i] == _pair_codes(row["keys"]), \
            "octant %d: table %r != key-pair axes %r" % (
                i, table[i], _pair_codes(row["keys"]))
    assert probe["deadzone"]["zero"] == 1 and \
        probe["released"]["zero"] == 1, "deadzone/release must idle ZERO"
    assert probe["hero_moved"]["ok"] == 1, \
        "the hero did not move through the SAME seam (bridge + _step)"


# ---- T-E2: the tap lands on the shipped pause flag, both ways -----------------

def test_t_e2_pause_on_tap_rides_the_shipped_escape_arm(probe):
    assert probe["tap"]["presses"] == 1 and probe["tap"]["escape"] == 1, \
        "the tap must feed EXACTLY ONE Escape press"
    assert probe["tap_on"]["paused"] == 1, "tap #1 must pause (game.paused)"
    assert probe["tap_off"]["paused"] == 0, "tap #2 must resume"
    drag = probe["drag_not_tap"]
    assert drag["live"] == 1, "a drag past the deadzone must move"
    assert drag["back"] == 1, "back inside the deadzone must zero the vector"
    assert drag["presses"] == 0, "a drag-RELEASE is not a tap (no pause)"


# ---- T-E3: the ONE seam, the additive fold, the no-fork pause walk ------------

def test_t_e3_one_vector_seam_and_no_pause_fork():
    assert MAIN_CODE.count("bridge.move_vector()") == 1, \
        "main reads the move vector from the ONE seam, exactly once"
    mv = conftest.block(BRIDGE_CODE, "func move_vector", "func drain_presses")
    for arrow in ("ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown"):
        assert "_touch_held.has(\"%s\")" % arrow in mv, \
            "the touch folds additively INSIDE move_vector: %s" % arrow
    tap_arm = conftest.block(BRIDGE_CODE, "func _touch_event",
                             "func _drag_event")
    assert 'on_key("Escape", true)' in tap_arm and \
        'on_key("Escape", false)' in tap_arm, \
        "the tap feeds the shipped discrete Escape press/release"
    # the paused WRITE walk (replace-not-add, T-M7A flag stays alone):
    writers = []
    for fn in sorted(os.listdir(os.path.join(REPO, "godot", "scripts"))):
        if not fn.endswith(".gd"):
            continue
        src = conftest.read_text(os.path.join(REPO, "godot", "scripts", fn),
                                 code_only=True)
        if re.search(r"paused\s*=(?!=)", src):
            writers.append(fn)
    assert writers == ["game_state.gd", "main.gd"], \
        "game.paused has exactly the shipped writer homes, got %s" % writers


# ---- T-E4: the desktop paths and the presence law -----------------------------

def test_t_e4_desktop_paths_and_presence_law(probe):
    assert probe["native_key"]["dx"] == "1.0", \
        "the native-key desktop arm of _input still feeds the queues"
    assert probe["hud_paint"]["visible"] == 1, \
        "one engine frame after a touch the stick becomes visible " \
        "(presence toggle; the web screenshot proves the REST anchor " \
        "paints on-screen — a Control under a CanvasLayer has NO layout " \
        "size, so the anchor measures the viewport rect; headless runs " \
        "on a 64x64 dummy window, which is exactly why this leg is the " \
        "toggle, not the size)"
    assert probe["web_key_gate"]["drop"] == 1, \
        "a web bridge must still DROP native keys (the JS relay is the " \
        "web key path — the shipped gate the touch row rode past)"
    assert probe["presence"]["boot"] == 0 and \
        probe["presence"]["end"] == 1, "presence: touch_seen only by touches"
    assert "if not _native:" in BRIDGE, \
        "the native-key gate stays shipped (the touch row rode PAST it)"
    # the overlay: HUD-family wiring, present-aware paint, never a thief
    assert "MOUSE_FILTER_IGNORE" in THUD_CODE, \
        "the overlay must never steal a UI click"
    assert "bridge.touch_seen" in THUD_CODE, \
        "paint gated on presence: a desktop never sets touch_seen"
    assert not re.search(r"paused\s*=(?!=)", THUD_CODE), \
        "the overlay is a paint: it writes no pause state"
    boot = conftest.block(MAIN, "func _ready", "func _register_key_bridge")
    assert boot.count('preload("res://scripts/touch_hud.gd")') == 1 and \
        boot.count("add_child(_thud)") == 1 and \
        "_thud.bridge = bridge" in boot, \
        "the overlay rides ONE preload + ONE wire"
    assert boot.count("_thud") == 3, \
        "the overlay is wired, never called (zero verbs, zero connects, " \
        "zero per-frame pokes from main)"
