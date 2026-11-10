"""MC 12352 GATE-INT-V4: the visibility-restricted strip (tools/art/
visibility_strip.py) and its six-leg contract (tools/art/visibility_controls.py).

Why these fixtures exist: the roof rule (interior_strip.strip_roof) was
integrated three times and MC 12345 CLOSED IT AS REJECT — it deleted VISIBLE
skin (cloth-over-body lining, limb interfaces: render holes, silhouette IoU
0.849-0.945 against the 0.95 floor). So every test here is a CONTROL that
proves the new rule can do the right thing on exactly the geometry class that
killed it, and the bake-then-strip ORDER that MC 12342 VINDICATED is asserted
unchanged (one closed-remesh bake, geometry-only delete afterwards, UVs intact).

Pure CPU, no engine, no GPU, no RNG: the mask is fixed-view and asserted
byte-equal across runs. The shipped char-emberwright.glb is READ, never
written (16-hold law, asserted here too).
"""
import hashlib
import os
import subprocess
import sys

import numpy as np
import pytest
import trimesh

import conftest

TOOLS_ART = os.path.join(conftest.REPO, "tools", "art")
if TOOLS_ART not in sys.path:
    sys.path.insert(0, TOOLS_ART)

import render_parity as rp            # noqa: E402
import trellis_bake_wrap as wrap      # noqa: E402
import visibility_controls as vc      # noqa: E402
import visibility_strip as vs         # noqa: E402

FIX = vc.gate_fixtures()               # ONE fixture set for selftest + pytest


# ---- the machine DoD: the rule is reachable, the contract is green ----------

def test_visible_gate_token_and_dod_grep():
    """DoD: the rule names itself (grep -c visible_gate >= 1)."""
    src = open(os.path.join(TOOLS_ART, "visibility_strip.py")).read()
    assert src.count("visible_gate") >= 3          # views fn + constants + doc
    assert "def visible_gate_views" in src


def test_selftest_contract_green():
    assert vc.controls() == 0                      # PASS x6


def test_selftest_cli_exits_zero():
    r = subprocess.run([sys.executable, os.path.join(TOOLS_ART,
                                                     "visibility_strip.py"),
                        "--selftest"], capture_output=True, text=True)
    assert r.returncode == 0, r.stdout[-600:] + r.stderr[-600:]
    assert "VISIBLE-GATE CONTROLS: PASS x6/6" in r.stdout


# ---- fixture 1: nested shells — the rule must still DO something -----------

def test_nested_shells_inner_removed_outer_untouched():
    m = FIX["nested"]
    mask = vs.visible_face_mask(m)
    inner = np.arange(mask.size) >= mask.size - FIX["inner-n"]
    assert mask[inner].sum() == 0                  # hidden inner shell DELETED
    assert mask[~inner].all()                      # outer shell UNTOUCHED
    ratio = 1.0 - mask.mean()
    assert 0.4 < ratio < 0.6                       # ~the hidden shell, no more


# ---- fixture 2: the MC 12345 killer — visible painted lining MUST stay -----

def test_open_cup_visible_painted_lining_is_kept():
    """If this test goes red the rule is back to eating visible skin, which is
    the exact REJECT reason of MC 12345. An open cup has NOTHING provably
    invisible: the lining is seen from above through the mouth."""
    cup = FIX["cup-painted"]
    mask = vs.visible_face_mask(cup)
    lining = vc.cup_lining_faces(cup)
    assert lining.sum() == 256                     # the fixture is the one cup
    assert mask[lining].all()                      # every painted lining face
    assert 1.0 - mask.mean() < 0.02                # and nothing else either


# ---- fixture 3: limb-interface proxy ----------------------------------------

def test_limb_interface_skin_is_kept():
    """Torus through a sphere body (the limb-through-skin class). Skin outside
    the limb tube is visible and must survive; the stripped mesh must render
    the SAME silhouette from views it was never fitted to."""
    px = FIX["limb-proxy"]
    mask = vs.visible_face_mask(px)
    skin = vc.limb_skin_faces(px, body_n=FIX["inner-n"])
    assert mask[skin].all()                        # skin near the interface
    kept = vc.kept_faces(px, mask)
    for (yaw, elev) in vc.HELD_OUT_VIEWS:          # inside the sampling gaps
        a = rp.silhouette(px, 256, yaw, elev)
        b = rp.silhouette(kept, 256, yaw, elev)
        assert int((a != b).sum()) == 0            # no hole opens anywhere


# ---- fixture 3b: the planted-bad leg (a gate that never went RED is not one)

def test_planted_bad_faces_behind_a_punched_window_are_kept():
    """Same faces fixture 1 deletes behind a CLOSED shell, seen through a
    window punched in that shell: a rule blind to a hole deletes them anyway
    (= the 12345 failure class) and this test goes red for it."""
    closed = FIX["nested"]
    m_closed = vs.visible_face_mask(closed)
    hidden = vc.window_interior_faces(closed)
    assert hidden.sum() > 10 and m_closed[hidden].sum() == 0   # red-side proof
    win, punched = vc.punched_window(closed)
    assert punched > 10                            # the window is real
    mask = vs.visible_face_mask(win)
    assert mask[vc.window_interior_faces(win)].all()


# ---- fixture 4: determinism ------------------------------------------------

def test_mask_is_deterministic_byte_equal():
    cup = FIX["cup-painted"]
    a = vs.visible_face_mask(cup)
    b = vs.visible_face_mask(cup)
    assert a.dtype == bool and a.shape == (len(cup.faces),)
    assert a.tobytes() == b.tobytes()              # no RNG in the mask path


# ---- fixture 5: shipped-file roundtrip (READ-ONLY, ae5b13e UV idiom) -------

@pytest.fixture(scope="module")
def shipped_roundtrip():
    path = vs.SHIPPED_GLB
    md5 = hashlib.md5(open(path, "rb").read()).hexdigest()
    sh = trimesh.load(path, force="mesh", process=False)
    orig_uv = np.asarray(sh.visual.uv[sh.faces], dtype=np.float32).copy()
    out, rr = vs.strip_invisible(sh)
    yield sh, orig_uv, out, rr, path
    # the shipped bytes are untouched by this whole card (16-hold law)
    assert hashlib.md5(open(path, "rb").read()).hexdigest() == md5


def test_shipped_file_kept_faces_have_unmutated_uvs(shipped_roundtrip):
    sh, orig_uv, out, rr, path = shipped_roundtrip
    assert len(sh.faces) == 7891 and os.path.basename(path) == \
        "char-emberwright.glb"
    assert hasattr(out.visual, "uv") and len(out.visual.uv) > 0
    # GLB stores TEXCOORD as float32: judge both sides at f64 after 5-decimal
    # rounding (np.round PRESERVES dtype — f32 keys never hash-match f64 ones).
    def key(t):
        return tuple(np.round(np.asarray(t, np.float64), 5).ravel())
    orig_set = {key(o) for o in orig_uv}
    assert all(key(f) in orig_set for f in out.visual.uv[out.faces])
    assert out.visual.material is not None         # visual survived too


def test_shipped_file_removed_ratio_is_sane(shipped_roundtrip):
    _, _, out, rr, _ = shipped_roundtrip
    # Welded double skin (MC 12337) + a CONSERVATIVE mask = a small yield, and
    # the point of V4 is that the yield can never come out of visible skin.
    assert 0.0 < rr < 0.35
    assert 0 < len(out.faces) < 7891
    assert out.bounds.shape == (2, 3)
    assert np.isfinite(out.vertices).all()          # still a real mesh


# ---- the seam: bake ONCE, then geometry-only strip (MC 12342 order) --------

class _FakeGlb:
    def __init__(self, mesh):
        self.mesh = mesh

    def export(self, path):
        self.mesh.export(path)


def test_seam_v2_bakes_once_then_geometry_only(tmp_path, monkeypatch):
    calls = []

    def fake_to_glb(**kw):
        calls.append(kw)
        return _FakeGlb(FIX["nested"])              # "the bake"

    monkeypatch.setattr(wrap, "_SELFTEST_V2", True)  # contract is green (tested
    gen = dict(vertices=None, faces=None, attr_volume=None, coords=None,
               attr_layout={}, voxel_size=None,
               aabb=[[-0.5, -0.5, -0.5], [0.5, 0.5, 0.5]])
    out = str(tmp_path / "asset.glb")
    final = wrap.bake_then_strip_v2(gen, out, 8000, to_glb=fake_to_glb,
                                    log=lambda *_: None)
    assert len(calls) == 1                          # ONE closed-remesh bake
    assert calls[0]["remesh"] is True               # the VINDICATED order:
    assert calls[0]["decimation_target"] == 8000    # budget binds IN THE BAKE,
    assert calls[0]["texture_size"] == 2048         # never a second pass
    assert os.path.exists(out + ".prestrip.glb")    # textured evidence kept
    assert final == 1280                            # hidden shell gone, skin on
    assert vs.visible_face_mask(trimesh.load(out, force="mesh",
                                            process=False)).all()


def test_seam_v2_refuses_uncalibrated(monkeypatch):
    """Planted-bad leg: red V4 contract -> the bake REFUSES (an uncalibrated
    mask has no right to delete geometry — the MC 12334 law, carried to V4)."""
    monkeypatch.setattr(wrap, "_SELFTEST_V2", False)
    with pytest.raises(RuntimeError):
        wrap.bake_then_strip_v2({}, "x.glb", 100, to_glb=lambda **k: None)


def test_seam_v1_still_reachable_and_pinned(tmp_path, monkeypatch):
    """The rejected roof rule is not silently removed (it is what --strip names
    and what tests/test_art_interior_gate.py pins); it is only no longer the
    new work."""
    calls = []
    monkeypatch.setattr(wrap, "_SELFTEST", True)
    out = str(tmp_path / "v1_pin.glb")
    gen = dict(vertices=None, faces=None, attr_volume=None, coords=None,
               attr_layout={}, voxel_size=None,
               aabb=[[-0.5, -0.5, -0.5], [0.5, 0.5, 0.5]])
    n = wrap.bake_then_strip(gen, out, 8000,
                             to_glb=lambda **k: (calls.append(k),
                                                 _FakeGlb(FIX["nested"]))[1],
                             log=lambda *_: None)
    assert len(calls) == 1 and calls[0]["remesh"] is True
    assert n < 2560                                # roof rule still strips
    assert os.path.exists(out + ".prestrip.glb")   # same order, same evidence


# ---- batch default stays strip-OFF, --strip-v2 is the new opt-in -----------

def test_batch_strip_v2_passthrough_default_off():
    src = open(os.path.join(conftest.REPO, "tools", "vm100",
                            "batch_trellis.py")).read()
    assert "default: no-strip" in src              # DoD grep, still pinned
    assert "no_strip = not _args.strip" in src     # unchanged MC 12342 pin
    assert "and not _args.strip_v2" in src          # V2 is opt-in too
    assert '"--strip-v2"' in src                    # the new CLI flag
    assert "bake_then_strip_v2(" in src             # wired to the seam
    assert "bake_then_strip(" in src                # v1 still reachable
