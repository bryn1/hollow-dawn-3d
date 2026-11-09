"""MC 12334 controls; MC 12338 rungs + ordering; MC 12342 re-write to the
BAKE-ONCE STRIP-AFTER architecture (tools/art/).

Geometry tests on the repo pytest idiom: pure CPU, no engine, no GPU.
Fixtures are SYNTHETIC (nested shells, the parametric double-wall cup, and a
UV-TEXTURED nested pair — the post-bake strip must keep UVs EXACT on kept
faces). The seam leg fakes o_voxel.postprocess.to_glb and proves the MC
12342 shape: ONE closed-remesh bake at full texture, strip as pure geometry
afterwards, prestrip kept beside the output, the post-strip probe a
measurement (never a refusal), and the calibration contract still refusing
the bake when its own controls are red (planted-bad leg).
The render-parity gate carries its own planted-bad RED control (MC 12342
law: a gate that has never gone RED is not a gate): a punched visible hole
MUST drop the silhouette IoU below the floor. The full bpy 4-yaw leg rides
the next real bake card (CPU rasterizer + stored-mask IoU machinery here).
"""
import os
import sys

import numpy as np
import pytest
import trimesh
from PIL import Image

import conftest

TOOLS_ART = os.path.join(conftest.REPO, "tools", "art")
if TOOLS_ART not in sys.path:
    sys.path.insert(0, TOOLS_ART)

import interior_probe as ip          # noqa: E402
import interior_strip as istrip      # noqa: E402
import render_parity as rp           # noqa: E402
import trellis_bake_wrap as wrap     # noqa: E402


def _nested_fixture():
    """Nested-shell fixture: sphere + 0.95 copy (gate-lab RED1)."""
    return trimesh.util.concatenate([
        trimesh.creation.icosphere(3),
        trimesh.creation.icosphere(3, radius=0.95)])


def _textured_nested_fixture():
    """Nested pair with a REAL uv layer + image (the UV-preservation fixture;
    MC 12342)."""
    parts = []
    for r in (1.0, 0.95):
        m = trimesh.creation.icosphere(3, radius=r)
        v = m.vertices
        uv = np.stack([0.5 + np.arctan2(v[:, 1], v[:, 0]) / (2 * np.pi),
                       0.5 + np.arcsin(np.clip(v[:, 2], -1, 1)) / np.pi],
                      axis=1)
        m.visual = trimesh.visual.TextureVisuals(
            uv=uv, material=trimesh.visual.material.SimpleMaterial(
                image=Image.new("RGB", (8, 8), (200, 30, 30))))
        parts.append(m)
    return trimesh.util.concatenate(parts)


# ---- calibration contracts (must be green HERE, or nothing else means anything)

def test_probe_selftest_green():
    assert ip.selftest_ok() is True


def test_strip_controls_green():
    assert istrip.controls() == 0


# ---- parity checks at mesh level: strip-ON vs strip-OFF, same fixture

def test_probe_detects_nested_fixture():
    assert ip.probe(_nested_fixture(), "fixture-nested") is True


def test_strip_flips_and_keeps_silhouette():
    m = _nested_fixture()
    bbox0 = m.bounds.copy()
    tri0 = len(m.faces)
    s, marked = istrip.strip_roof(m, verbose=False)
    assert marked > 0                       # the stripper acted
    assert len(s.faces) < tri0              # tri count DOWN
    assert np.allclose(s.bounds, bbox0, rtol=0.001, atol=1e-9)   # bbox <= 0.1 %
    assert ip.probe(s, "fixture-nested-after") is False   # INTERIOR -> CLEAN


def test_strip_cup_parity_and_bad_control():
    m = ip.cup_fixture()                    # welded double wall, no booleans
    bbox0 = m.bounds.copy()
    assert m.is_watertight and m.is_winding_consistent      # fixture is sound
    assert ip.probe(m, "cup-before") is True
    s, marked = istrip.strip_roof(m, verbose=False)
    assert marked > 0 and len(s.faces) < len(m.faces)
    assert np.allclose(s.bounds, bbox0, rtol=0.001, atol=1e-9)
    assert ip.probe(s, "cup-after") is False
    sph = trimesh.creation.icosphere(4)     # BAD control: solid stays solid
    s2, marked2 = istrip.strip_roof(sph, verbose=False)
    assert marked2 == 0 and len(s2.faces) == len(sph.faces)


def test_strip_preserves_uv_on_kept_faces():
    """MC 12342 post-bake law: the strip is face-removal ONLY — UVs on kept
    faces are EXACT, twice over: (1) BAD control (solid, nothing stripped)
    keeps face-uv row-for-row IDENTICAL through the machinery; (2) the
    nested pair strips, and every surviving face's uv triangle (after a GLB
    roundtrip, i.e. what the SHIPPED file carries) is EXACTLY one of the
    original per-face uv triangles."""
    sph_parts = trimesh.creation.icosphere(4)   # BAD control: strip nothing
    uv = np.stack([0.5 + np.arctan2(sph_parts.vertices[:, 1],
                                    sph_parts.vertices[:, 0]) / (2 * np.pi),
                   0.5 + np.arcsin(np.clip(sph_parts.vertices[:, 2], -1, 1))
                   / np.pi], axis=1)
    sph_parts.visual = trimesh.visual.TextureVisuals(
        uv=uv, material=trimesh.visual.material.SimpleMaterial(
            image=Image.new("RGB", (8, 8), (10, 200, 10))))
    orig0 = sph_parts.visual.uv[sph_parts.faces].copy()
    s0, marked0 = istrip.strip_roof(sph_parts, verbose=False,
                                    preserve_visual=True)
    assert marked0 == 0                        # solid: nothing stripped
    assert np.array_equal(s0.visual.uv[s0.faces], orig0)   # EXACT parity
    m = _textured_nested_fixture()
    orig_face_uv = m.visual.uv[m.faces].copy()
    s, marked = istrip.strip_roof(m, verbose=False, preserve_visual=True)
    assert marked > 0                          # actually stripped
    tmp = "/tmp/uv_probe_tmp.glb"
    s.export(tmp)
    r = trimesh.load(tmp, force="mesh", process=False)
    assert hasattr(r.visual, "uv") and len(r.visual.uv) > 0
    # GLB stores TEXCOORD as float32 (measured post-export delta 4.5e-08 —
    # rounding only, no flip): parity judged at 5-decimal precision.
    def key(t):
        # np.round PRESERVES dtype (f32 keys vs f64 keys never hash-match) —
        # judge both sides at f64 after the 5-decimal rounding.
        return tuple(np.round(np.asarray(t, dtype=np.float64), 5).ravel())
    orig_set = {key(o) for o in orig_face_uv.astype(np.float32)}
    assert all(key(f) in orig_set
               for f in r.visual.uv[r.faces])   # shipped-file parity
    os.remove(tmp)


# ---- wrapper seam (MC 12342 shape; vendor to_glb injected; no GPU here)

class _FakeGlb:
    def __init__(self, mesh):
        self.mesh = mesh

    def export(self, path):
        self.mesh.export(path)


def test_wrapper_bake_once_then_geometry_strip(tmp_path):
    calls = []

    def fake_to_glb(**kw):
        calls.append(kw)
        return _FakeGlb(_nested_fixture())     # "the bake"

    gen = dict(vertices=None, faces=None, attr_volume=None, coords=None,
               attr_layout={}, voxel_size=None,
               aabb=[[-0.5, -0.5, -0.5], [0.5, 0.5, 0.5]])
    out = str(tmp_path / "asset.glb")
    final = wrap.bake_then_strip(gen, out, 8000, to_glb=fake_to_glb,
                                 log=lambda *_: None)
    # MC 12342 ORDERING: exactly ONE vendor bake — closed remesh, real
    # texture, budget binds IN THE BAKE; no second pass exists to re-break.
    assert len(calls) == 1
    assert calls[0]["remesh"] is True
    assert calls[0]["decimation_target"] == 8000
    assert calls[0]["texture_size"] == 2048
    assert final < 2560                        # stripped geometry shrank it
    assert os.path.exists(out + ".prestrip.glb")   # textured evidence kept
    assert ip.probe(trimesh.load(out, force="mesh"), "wrapper-final") is False


def test_wrapper_calibration_refuses(monkeypatch):
    """Planted-bad leg: calibration contract FAILED -> bake/measurement
    REFUSED (a measurement is meaningless uncalibrated)."""
    monkeypatch.setattr(wrap, "_SELFTEST", False)
    with pytest.raises(RuntimeError):
        wrap.bake_then_strip({}, "x.glb", 100, to_glb=lambda **k: None)


# ---- render-parity gate + its planted-bad RED control (MC 12342 law)

def test_render_parity_green_identical_and_red_punched_hole():
    base = trimesh.creation.icosphere(3)      # the "unstripped arm" proxy
    m_good = base.copy()                      # geometry-only strip == same
    bounds = base.bounds
    m_red = base.copy()
    C = m_red.triangles_center
    hole = (np.abs(C[:, 0]) < 0.40) & (np.abs(C[:, 1]) < 0.40)
    # (both caps punched: a one-sided window still has its silhouette
    # covered by the far side under orthographic projection — the gate
    # measures the SILOUETTE, the punch must gap it)
    keep = ~hole
    m_red.update_faces(keep)                  # the PLANTED VISIBLE HOLE
    used = np.zeros(len(m_red.vertices), bool)
    used[m_red.faces] = True
    m_red.update_vertices(used)
    assert hole.sum() > 20                    # the punch is visible
    b = rp.rasterize(m_good, bounds=bounds)
    g = rp.rasterize(m_good, bounds=bounds)
    r = rp.rasterize(m_red, bounds=bounds)
    v_ok, ok = rp.gate_masks(b, g)
    assert ok and v_ok == 1.0                 # GREEN: identical silhouettes
    v_red, red_ok = rp.gate_masks(b, r)
    assert not red_ok and v_red < rp.DEFAULT_FLOOR   # RED control FIRES
    # the MC 12339 measured bad values also fail the floor (calibration
    # of FLOOR on real evidence):
    assert 0.741 < rp.DEFAULT_FLOOR and 0.803 < rp.DEFAULT_FLOOR


# ---- the batch safety default is PINNED (MC 12342 commit-1 law)

def test_batch_default_is_no_strip():
    src = open(os.path.join(conftest.REPO, "tools", "vm100",
                            "batch_trellis.py")).read()
    assert "default: no-strip" in src              # DoD grep, pinned
    assert "no_strip = not _args.strip" in src     # opt-in seam
    assert "bake_then_strip(" in src               # seam branch on new API
