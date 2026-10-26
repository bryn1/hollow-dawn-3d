#!/usr/bin/env python3
"""MC 11361 (T-M4a) — the COMMITTED v2 biome-tile post recipe (M4-SPEC §8:
"the v2 recipe's deterministic post chain is part of the contract, so the
tile is reproducible from the manifest + the recipe commit"). Body = the
T-S15 deterministic post VERBATIM (the MC 11191 scratch donor
.tmp/post_tiles.py at base fcfde6f — sigma 96 multiplicative luma LF
flatten, luma scale to 30.5, unsharp k=1.5 s=6 over the 8-24 px grain band
(T-S15 cycle 2, 1bc13cc), re-scale, periodic quarter-band seamless blend);
reproduce a shipped tile with:  python3 tile_post.py RAW.png OUT.png
then gate it with tools/tile_gate.py. The accepted raws ride
assets/art-src/ with tEXt impeccable:prompt + manifest seeds/sha16
(tools/vm100 note: manifest is tools/vm100/tile-batch-m4.tsv).

Original T-S15 docstring follows verbatim.
"""
"""T-S15 (MC 11191) variant post: deterministic tiling pipeline over the
generated art (no new art content — linear/periodic ops only):

1. LF flatten  — subtract a wrap-padded gaussian blur (sigma 96) and add
   back its global mean: kills the macro patches diffusion always paints
   (evenness gate); wrap padding keeps the op periodic, fine grain + hue
   are untouched.
2. Luma scale  — linear multiply so mean luma lands at 30.5 (26-36 gate).
3. Seamless    — blend a(x) with roll(a, 512) via a periodic weight that is
   1 across the wrap boundary (where a is discontinuous, roll is smooth)
   and 0 across the tile centre (where roll is discontinuous, a is smooth);
   the two 256 px ramps at the quarter points carry the double-exposure.
   Result is genuinely periodic: the wrap strips become interior columns.

Scratch tool (repo .tmp, gitignored). Usage: post.py IN.png OUT.png
"""
import sys

import numpy as np
from PIL import Image

SIGMA = 96.0
SEAM = 256
TARGET = 30.5


def gauss_wrap(a, sigma):
    """Circular gaussian via FFT (FFT convolution == wrap padding)."""
    h, w = a.shape[:2]
    fy = np.fft.fftfreq(h)[:, None]
    fx = np.fft.rfftfreq(w)[None, :]
    k = np.exp(-2.0 * np.pi ** 2 * sigma ** 2 * (fy ** 2 + fx ** 2))
    out = np.empty_like(a)
    for c in range(a.shape[2]):
        out[..., c] = np.fft.irfft2(np.fft.rfft2(a[..., c]) * k,
                                    s=(h, w))
    return out


def _ss(t):
    return t * t * (3.0 - 2.0 * t)


def seamless(a, axis):
    n = a.shape[axis]
    r = np.roll(a, n // 2, axis=axis)
    x = np.arange(n)
    lo1, hi1 = n // 4 - SEAM // 2, n // 4 + SEAM // 2
    lo2, hi2 = 3 * n // 4 - SEAM // 2, 3 * n // 4 + SEAM // 2
    w = np.ones(n)
    w[(x >= lo1) & (x <= hi1)] = 1.0 - _ss(
        (x[(x >= lo1) & (x <= hi1)] - lo1) / SEAM)
    w[(x > hi1) & (x < lo2)] = 0.0
    w[(x >= lo2) & (x <= hi2)] = _ss(
        (x[(x >= lo2) & (x <= hi2)] - lo2) / SEAM)
    shape = [1, 1, 1]
    shape[axis] = n
    return w.reshape(shape) * r + (1.0 - w.reshape(shape)) * a


def post(src, dst):
    a = np.asarray(Image.open(src).convert("RGB"), dtype=np.float64)
    # multiplicative luma-only LF flatten: the macro patch field is divided
    # out of every pixel equally across channels, so the channel ratios
    # (hue/sat) are exactly preserved; per-channel subtraction would kill
    # the color cast (it lives in the low frequencies).
    lum = a @ [0.2126, 0.7152, 0.0722]
    lg = gauss_wrap(lum[..., None], SIGMA)[..., 0]
    a *= np.clip(lg.mean() / np.maximum(lg, 8.0), 0.4, 2.5)[..., None]
    lum = a @ [0.2126, 0.7152, 0.0722]
    a *= TARGET / max(lum.mean(), 1e-6)
    # unsharp the 8-24 px grain band: the owner brief asks for FINE detail,
    # and on the live scene the readability block-knee needs the tile's own
    # small-scale variance to dominate over the scene actors' (T-S10 gate).
    blur = gauss_wrap(a, 6.0)
    a = a + 1.5 * (a - blur)
    lum = a @ [0.2126, 0.7152, 0.0722]
    a *= TARGET / max(lum.mean(), 1e-6)
    a = seamless(a, 1)
    a = seamless(a, 0)
    Image.fromarray(np.clip(a, 0, 255).astype(np.uint8)).save(dst)


if __name__ == "__main__":
    post(sys.argv[1], sys.argv[2])
