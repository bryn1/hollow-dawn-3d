# test_skill_fx.py — M6 F2 (MC 11705, T-M6f): the per-SKILL attack looks,
# acceptance legs FX-E1..FX-E4's SOURCE-side pins per docs/M6-SPEC.md §2.
#
# THE LAW THIS FILE PINS (owner quote, M6-SPEC §2 header): "animations for
# attacks all look roughly the same and should have individual looks that
# correspond with the icon of the skills". The ONE dispatch site
# (godot/scripts/viz_fx.gd) carries the SKILL_FX table — one row per
# FIREABLE id (15 weapon-side + the 9 LIVE evolved + the 2 union
# orbiters = 26): colour SAMPLED from the shipped icon by the ONE method
# (tools/skill_fx_sample.py — re-derived here, the drift class), scale /
# trail / band LOOK params, and the flash flag on the evolved rows.
#
# Pin honesty (replace-not-delete law): doom-sigil is DROPPED weapon-side
# (§4.1, T-M6d) — no row exists and the coverage pins EXCLUDE it;
# pale-moon is KEEP-as-file, DEAD-as-fireable (§4.4 R2/T-M6p) — the pin
# names its EXCLUSION explicitly (FX-E2: an added pale-moon row is the
# planted red this leg catches). The renderer-side behaviour legs (window
# colours per skill, flash through the existing rings cap) live in the
# upgrades_visual_probe Table 3 capture legs — this file pins the source
# truths the capture cannot express.
import functools
import math
import os
import re
import sys

import conftest

read = conftest.read_script  # MC 11317 C2 seam (raw script text)
read_code = functools.partial(read, code_only=True)

REPO = conftest.REPO
VIZ = read("viz_fx.gd")
VIZ_CODE = read_code("viz_fx.gd")
WEAPONS_CODE = read_code("weapons.gd")
EVO = read_code("evolutions.gd")
UNION = read_code("union.gd")
ICONS = os.path.join(REPO, "godot", "assets", "icons")

sys.path.insert(0, os.path.join(REPO, "tools"))
import skill_fx_sample  # the ONE sampling method (§2.1)
import upgrades_visual_skill_fx as sfx  # the Table-3 measure law (T-M6q2)

# --- the table, parsed from the ONE site --------------------------------------

_ROW = re.compile(
    r'"([\w-]+)": \{"cls": "(\w+)", "color": Color\(([^)]*)\),\s*'
    r'"scale": ([\d.]+), "trail": ([\d.]+), "band": ([\d.]+), '
    r'"flash": (true|false)\}')


def skill_fx():
    out = {}
    for m in _ROW.finditer(VIZ):
        rgb = tuple(float(v) for v in m.group(3).split(","))
        out[m.group(1)] = {"cls": m.group(2), "color": rgb,
                           "scale": float(m.group(4)),
                           "trail": float(m.group(5)),
                           "band": float(m.group(6)),
                           "flash": m.group(7) == "true"}
    return out


FX = skill_fx()


def dist(a, b):
    return math.sqrt(sum((x - y) * (x - y) for x, y in zip(a, b)))


IDS = re.search(r'const IDS := \[([^\]]+)\]', WEAPONS_CODE).group(1)
IDS = re.findall(r'"([\w-]+)"', IDS)
EVO_MAP = dict(re.findall(
    r'"([\w-]+)": \{"partner": "[\w-]+", "evo": "([\w-]+)"', EVO))
UNION_IDS = re.findall(r'"([\w-]+)": \{"a":', UNION)


# --- FX-E1 coverage + identity pins -------------------------------------------

def test_fx_e1_coverage_is_the_26_fireable_ids():
    """Rows == 15 weapon-side + the 9 live evolved + the 2 union orbiters.
    doom-sigil (DROPPED §4.1) and pale-moon (DEAD-as-fireable §4.4 R2, the
    declared fallback) have NO row — the FX-E2 planted red (add a pale-moon
    row) goes RED here."""
    want = set(IDS) | set(EVO_MAP.values()) | set(UNION_IDS)
    assert len(IDS) == 15 and len(EVO_MAP) == 9 and len(UNION_IDS) == 2
    assert set(FX) == want, (sorted(set(FX) ^ want))
    assert "doom-sigil" not in FX and "pale-moon" not in FX


def test_fx_e1_every_row_has_its_shipped_icon():
    """The owner's reference is the icon: every row id has icon-<id>.png on
    disk (the icon law: dead ids' files KEEP — the rows do not exist)."""
    for i in FX:
        assert os.path.exists(os.path.join(ICONS, "icon-%s.png" % i)), i


def test_fx_e2_table_colours_equal_the_one_sampling_method():
    """Every pinned colour is tools/skill_fx_sample.py's value for that
    icon, digit-for-digit (§2.1 capture-printed rows; FX-E2's planted red
    is a hand-typed drift — RED here)."""
    for i, row in FX.items():
        got = skill_fx_sample.sample_icon(
            os.path.join(ICONS, "icon-%s.png" % i))
        assert row["color"] == got, "%s: table %s vs sampled %s" % (
            i, row["color"], got)


def test_fx_e1_no_two_rows_share_the_colour():
    """The individual-look law: NO exact colour duplicates across the 26
    rows. (Base-vs-evolved rows may read CLOSE — that IS the "bigger
    variant of the SAME identity" law — but never equal; the closest such
    pair, fire-lash/inferno-lash, measures 0.003.)"""
    ids = sorted(FX)
    for a_i, a in enumerate(ids):
        for b in ids[a_i + 1:]:
            d = dist(FX[a]["color"], FX[b]["color"])
            assert d > 0.002, "%s/%s share colour (%.4f)" % (a, b, d)


def test_fx_e1_weapon_side_colours_separate():
    """The 15 WEAPON-side rows separate pairwise by >= 0.012 (measured min
    0.013, dart-loop/spectral-disc — separated further by their scale/trail
    rows). FX-E1's planted red (two weapons one colour) is RED far above
    this floor."""
    ids = IDS
    worst = None
    for a_i, a in enumerate(ids):
        for b in ids[a_i + 1:]:
            d = dist(FX[a]["color"], FX[b]["color"])
            if worst is None or d < worst[2]:
                worst = (a, b, d)
    assert worst[2] >= 0.012, worst
    # The spec's named same-class pairs, floors MEASURED at card time
    # (the §2.2 FX-E1 leg: per-class pairs, floors declared as fractions
    # of the measured separations):
    named = [("ember", "dart-loop", 0.35), ("talon", "bone-whip", 0.35),
             ("ward", "rot-water", 0.15), ("spike", "storm-peal", 0.75),
             ("cleaver", "hewn-axe", 0.10)]
    for a, b, floor in named:
        d = dist(FX[a]["color"], FX[b]["color"])
        assert d >= floor, "%s/%s = %.3f < %.2f" % (a, b, d, floor)


# --- FX-E3 evolved = bigger/brighter variant of the SAME identity ------------

def test_fx_e3_evolved_rows_are_family_variant_plus_flash():
    """Each evolved row rides its BASE row's effect class (no new class —
    the M1h NO-NEW-VIZ ruling), flashes (the evolved flash IS the ring,
    §2.1), and its LOOK strictly exceeds the base's: bigger transform for
    the projectile classes, a WIDER band (smaller inner ratio) for the
    ring class (the ward/spike sim-truth law: rings read intensity as
    band, never radius)."""
    for base, evo in EVO_MAP.items():
        b, e = FX[base], FX[evo]
        assert e["cls"] == b["cls"], "%s/%s class differs" % (base, evo)
        assert e["flash"] is True, evo
        if e["cls"] == "rings":
            assert e["band"] < b["band"], (base, evo, b["band"], e["band"])
        else:
            assert e["scale"] > b["scale"], (base, evo, b["scale"],
                                             e["scale"])


def test_fx_e3_rows_never_touch_sim_radii():
    """The sim-truth law in source form: the writers scale ONLY look
    transforms (mesh basis / ribbon length / annulus band) — the pulse
    RADIUS rows read sim state (r.r, b.r) and multiply it by s (px->m)
    only; no SKILL_FX term may touch them."""
    assert re.search(r'var rm: float = r\.r \* s \* \(0\.55 \+ 0\.5 \* prog\)',
                     VIZ_CODE)
    assert re.search(r'var rm: float = b\.r \* s \* \(0\.25 \+ 0\.75 \* prog\)',
                     VIZ_CODE)
    # the arcs wedge: the WIDTH axis (x) carries the look scale, the
    # RADIUS axis (z) carries only a.range * s (the sim's own range):
    assert re.search(r'f\.scaled\(Vector3\(row\.scale, 1\.0, 1\.0\) '
                     r'\* \(a\.range \* s\)\)', VIZ_CODE)


# --- FX-E4 structural + dispatch-site pins ------------------------------------

def test_fx_e4_skill_fx_lives_at_the_one_site():
    """SKILL_FX is a const of godot/scripts/viz_fx.gd ONLY (§2.1 "data in
    the file that consumes it") — a second table site is RED."""
    hits = []
    for root, dirs, files in os.walk(os.path.join(REPO, "godot")):
        dirs[:] = [d for d in dirs if d not in (".godot", ".imports")]
        for f in files:
            if f.endswith(".gd"):
                p = os.path.join(root, f)
                with open(p, encoding="utf-8") as fh:
                    if "const SKILL_FX" in fh.read():
                        hits.append(os.path.relpath(p, REPO))
    assert hits == ["godot/scripts/viz_fx.gd"], hits


def test_fx_e4_flash_never_adds_a_draw_class():
    """§b ONE-draw law: exactly SEVEN MultiMesh creations (the shipped
    seven classes); the evolved flash rides the EXISTING rings MM through
    the mini(size,1) cap read — a planted second MM/draw class is RED."""
    assert VIZ_CODE.count("= _fx_mm(") == 7
    assert "const FX_DRAWS_MAX := 7" in VIZ_CODE
    assert VIZ_CODE.count("func _fx_mm(") == 1


def test_fx_e4_every_append_dict_stamps_its_wid():
    """§2.1: every transient append dict carries the firing weapon's id —
    every literal `X.append({` site in weapons.gd (19) carries
    "wid": w.id; an unstamped site paints the fallback and is RED here."""
    appends = re.findall(r'\b(bolts|throws|bursts|arcs|rings|halos)\.append\(\{',
                         WEAPONS_CODE)
    assert len(appends) == 19, len(appends)
    # every append dict literal spans to the matching "})" and carries it
    n_wid = WEAPONS_CODE.count('"wid": w.id')
    assert n_wid == 19, n_wid


def test_fx_fallback_row_is_declared_and_pale_moon_excluded():
    """FX-E2's declared fallback: an un-stamped wid paints the EMBER row
    (the shipped look of the largest entry class) — NOT a silent colour,
    and NOT pale-moon (dead-as-fireable: its row must never exist)."""
    m = re.search(r'const FX_FALLBACK := "([\w-]+)"', VIZ)
    assert m and m.group(1) == "ember"
    assert "pale-moon" not in FX


def test_caps_family_sum_resolves_through_the_base_map_both_sites():
    """FX-E3 (T-M6f §3.3 mirror): the cap FAMILY sums resolve family
    membership through EvolutionSystem.effect()'s base map at BOTH sites
    (viz_fx._roster_cap, sim_combat.caps) — the both-sites rule; a per-id
    cap alone is the planted red (fx_caps violations)."""
    assert "EvolutionSystem.effect(w.id).base" in VIZ_CODE
    with open(os.path.join(REPO, "godot", "sim", "sim_combat.gd")) as fh:
        sim = fh.read()
    assert "EvolutionSystem.effect(w.id).base" in sim
    # roster_one_cap stays keyed on the BASE id (spelling the same arm
    # math — the evolved id adds its term THROUGH the base family):
    assert '"dart-loop":' in VIZ_CODE and "roster_one_cap(base, w.level)" in sim


# --- T-M6q2 (audit-4 F-3 sub-row): the cross-boundary alpha pin --------------

def test_probe_table3_alpha_law_pinned_to_the_writer():
    """audit-4 F-3: the Table-3 colour box (upgrades_visual_skill_fx.py,
    moved out of the probe at T-M6q2) restates the WRITER's per-class
    alpha law across the language boundary — the file audit called it
    ZERO-PINNED ("a writer-side alpha edit desyncs the pixel box
    silently"). The pin closes it HERE: every SKILL_CLASS_ALPHA member is
    re-derived from viz_fx.gd's OWN constants (the three fade
    coefficients, the FLASH_GAIN headroom, the constant-alpha material
    default), digit-for-digit. Planted-red: edit one writer coefficient
    in viz_fx.gd => this leg goes RED, not the next card-time probe run."""
    gain = float(re.search(r"const FLASH_GAIN := ([\d.]+)", VIZ_CODE).group(1))
    writer = {
        "arcs": float(re.search(r"([\d.]+) \* sim\.arcs", VIZ_CODE).group(1)),
        "rings": float(re.search(r"([\d.]+) \* r\.life",
                                 VIZ_CODE).group(1)) * gain,
        "bursts": float(re.search(r"([\d.]+) \* b\.life", VIZ_CODE).group(1)),
    }
    # bolts/throws/halos ride the constant-alpha rows (no fade term): the
    # _mat() default, verified at source:
    assert "alpha := 1.0" in VIZ_CODE
    for cls in ("bolts", "throws", "halos"):
        writer[cls] = 1.0
    assert sfx.SKILL_CLASS_ALPHA == writer, (sfx.SKILL_CLASS_ALPHA, writer)
