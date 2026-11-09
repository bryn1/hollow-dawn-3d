"""MC 12334 — interior-strip gate tests (tools/art/).

Geometry tests on the repo pytest idiom: pure CPU, no engine, no GPU (the brief:
"geometry tests need no engine"). Fixtures are SYNTHETIC (nested shells, the
parametric double-wall cup from interior_probe) — the strip/parity contract:
strip-ON vs strip-OFF on the same fixture => silhouette bbox unchanged within
0.1 %, tri count DOWN, probe INTERIOR->CLEAN; BAD solid sphere stays unchanged.
The wrapper leg fakes o_voxel.postprocess.to_glb (vendor function is CUDA-only,
its GPU legs ride MC 12335) and proves the SEAM: pass 1 remesh=True at the
throwaway texture, strip in between, pass 2 remesh=False at the real texture,
gate refusal loud when the calibration contract fails (planted-bad leg).
"""
import os
import sys

import numpy as np
import pytest
import trimesh

import conftest

TOOLS_ART = os.path.join(conftest.REPO, "tools", "art")
if TOOLS_ART not in sys.path:
    sys.path.insert(0, TOOLS_ART)

import interior_probe as ip          # noqa: E402
import interior_strip as istrip      # noqa: E402
import trellis_bake_wrap as wrap     # noqa: E402


def _nested_fixture():
    """Nested-shell fixture: sphere + 0.95 copy (gate-lab RED1, the class the
    community claim is about)."""
    return trimesh.util.concatenate([
        trimesh.creation.icosphere(3),
        trimesh.creation.icosphere(3, radius=0.95)])


# ---- calibration contracts (must be green HERE, or nothing else means anything)

def test_probe_selftest_green():
    assert ip.selftest_ok() is True


def test_strip_controls_green():
    assert istrip.controls() == 0


# ---- parity check at mesh level: strip-ON vs strip-OFF, same fixture

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


# ---- wrapper seam plumbing (vendor to_glb injected; torch absent on this seat)

class _FakeGlb:
    def __init__(self, mesh):
        self.mesh = mesh

    def export(self, path):
        self.mesh.export(path)


def test_wrapper_seam_plumbing(tmp_path):
    calls = []

    def fake_to_glb(**kw):
        calls.append(kw)
        if kw.get("remesh"):                 # pass 1: "remesh" -> nested fixture
            return _FakeGlb(_nested_fixture())
        v = getattr(kw["vertices"], "numpy", lambda: kw["vertices"])()
        f = getattr(kw["faces"], "numpy", lambda: kw["faces"])()
        return _FakeGlb(trimesh.Trimesh(vertices=np.asarray(v),
                                        faces=np.asarray(f), process=False))

    gen = dict(vertices=None, faces=None, attr_volume=None, coords=None,
               attr_layout={}, voxel_size=None,
               aabb=[[-0.5, -0.5, -0.5], [0.5, 0.5, 0.5]])
    out = str(tmp_path / "asset.glb")
    wrap.bake_glb_stripped(gen, out, 10**9, to_glb=fake_to_glb,
                           to_torch=lambda x: x, log=lambda *_: None)
    assert calls[0]["remesh"] is True
    assert calls[0]["texture_size"] == wrap.PASS1_TEXTURE_SIZE
    assert calls[1]["remesh"] is False        # NEVER re-remesh after the strip
    assert calls[1]["texture_size"] == 2048
    final = trimesh.load(out, force="mesh")
    assert len(final.faces) < 2560            # < the unstripped fixture
    assert ip.probe(final, "wrapper-final") is False
    assert os.path.exists(out + ".prestrip.glb")   # evidence kept beside output


def test_wrapper_gate_refuses(monkeypatch):
    """Planted-bad leg: calibration contract FAILED -> the bake is REFUSED."""
    monkeypatch.setattr(wrap, "_SELFTEST", False)
    with pytest.raises(RuntimeError):
        wrap.bake_glb_stripped({}, "x.glb", 100, to_glb=lambda **k: None)
