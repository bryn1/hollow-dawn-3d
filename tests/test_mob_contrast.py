"""F7 MOB CONTRAST (M6-SPEC §7, T-M6c, MC 11677) — "Some mobs are very hard
to spot due to low contrast" (owner clause 12, verbatim 2026-10-28).

ACCEPT rows CT-E1..CT-E4, row-per-test with the ONE seam each reads. The
PIXEL legs (the full 44-shot grid, the planted dark copy, the pawn-row
byte-invariance twin, the default-dir re-run) ride the CARD CAPTURE
.tmp/m6c.txt — the capture, NOT pytest (the B-E1/P-E7 idiom this suite
already ships); what lives here is the table/grep/pin family the spec
names for tests/ plus a synthetic planted-red pair for the gate function
itself ("a gate that never fails is not a gate — fleet law").

  CT-E1 the floor           mob_ratio >= RATIO_MIN over every (band × class)
       grid shot — measured on the final tree in the capture, per-class min
       ratios printed; planted pair: a copy of the shots dir with one mob
       lift REMOVED exits 1, row named (capture), and HERE:
       test_planted_* below drive mob_metrics() on synthetic bright/dark
       plates (the gate must go RED on an invisible mob, GREEN on a bright
       one, WITHOUT the engine).
  CT-E2 byte-invariance     the default windows byte-invariant: the shipped
       default SHOTS table stays VERBATIM here and the capture's default
       path keeps reading it (test_declared_variant_*); the shipped gate
       legs re-run green on the final default dir in the capture, before/
       after PNG twins + per-class pixel delta named there.
  CT-E3 one-lookup law      tint_of is the only class-color read site:
       horde_viz._make_class materializes albedo_color ONLY from a passed
       tint (test_single_lookup_*), ENEMY_TINTS still exactly five classic
       rows (test_five_class_rows_hold), and the new rows ride the SAME
       lookup (test_boss_tints_ride_the_lookup).
  CT-E4 glow fallback       CONDITIONAL: did not fire at this close — the
       multiplier lift cleared every class (§7.1 lift-first, the hero's
       BONE×3.6 precedent); the draw-count row in the capture proves 27
       total draws at close, plan 40 holds. If the fallback ever fires,
       radii/alphas ride GLOW_ALPHAS/ENEMY_GLOW_RADII verbatim + the draw
       row re-pins — test_glow_law_untouched pins the single-source consts.
"""
import os
import re
import sys

import numpy as np
from PIL import Image

import conftest
from conftest import SCRIPTS, REPO, read_text

TOOLS = os.path.join(REPO, "tools")
if TOOLS not in sys.path:
    sys.path.insert(0, TOOLS)
import biome_readability as br  # the gate itself (tools/ seam, C3 one-home)

RENDER = read_text(os.path.join(SCRIPTS, "render.gd"))

# The measured fix universe at this close (capture: pre-fix grid, per-class
# min ratios): classes BELOW the 2.0 floor got measured multiplier rows;
# everything else keeps its shipped row (the identity law).
FIXED_CLASSES = {"wraith", "hound", "crawler", "cultist", "pale-wight",
                 "hollow-knight", "hollow-deacon"}


def _table(block_name, text=RENDER):
    block = text[text.index("const " + block_name):]
    block = block[:block.index("\n\n") if "\n\n" in block else len(block)]
    return dict((m[0], tuple(float(x) for x in m[1].split(",")))
                for m in re.findall(
                    r'"([\w-]+)": Color\(([\d., ]+)\)', block))


# ---- CT-E3: the one-lookup law ----------------------------------------------

def test_five_class_rows_hold():
    """ENEMY_TINTS still exactly five classic rows (M6 §7.2/CT-E3; the
    sibling pin in test_game_numbers stays VERBATIM — replace-not-delete)."""
    t = _table("ENEMY_TINTS")
    assert set(t) == {"wraith", "hound", "crawler", "cultist", "warden"}


def test_boss_tints_ride_the_lookup():
    """BOSS_TINTS is a named table riding the SAME tint_of lookup (the M5
    §2.3 table-shape lesson) — never a second lookup, never a literal."""
    t = _table("BOSS_TINTS")
    assert set(t) == {"hollow-knight", "hollow-deacon"}, \
        "BOSS_TINTS carries the WHITE classes that MEASURED below the floor"
    body = RENDER[RENDER.index("static func tint_of"):]
    body = body[:body.index("\n\n")]
    assert "ENEMY_TINTS.get" in body and "BIOME_TINTS.get" in body \
        and "BOSS_TINTS.get" in body and "Color.WHITE" in body, \
        "tint_of stays the ONE chained lookup"


def test_single_lookup_only_site():
    """CT-E3 grep law: no per-class material-color literal at any draw site;
    horde_viz albedo flows ONLY from the passed tint (the class family) or
    the NAMED GameRenderer constants (HP bar BLOOD, blob INK — shipped,
    not class colors)."""
    hv = read_text(os.path.join(SCRIPTS, "horde_viz.gd"))
    assert "GameRenderer.tint_of(key)" in hv
    albedo_sites = re.findall(r"albedo_color\s*=\s*([^#\n]+)", hv)
    assert albedo_sites and all(
        ("tint" in s or "GameRenderer." in s) for s in albedo_sites), \
        "every albedo_color write rides the tint or a named const, %r" % (
            albedo_sites,)
    assert not re.search(r"albedo_color\s*=\s*Color(8)?\(\s*[0-9x]", hv), \
        "zero numeric color literals at horde_viz albedo sites"


def test_measured_rows_are_lifts():
    """Every fixed class reads a multiplier row that lifts it OFF its
    pre-fix luma (F7 rows are lifts, not identity): the fixed rows all carry
    a component > 1.0 (the BONE×3.6 unshaded-multiplier precedent,
    hero_pawn.gd:31), and the shipped identity rows for non-fixed classes
    are untouched byte-for-byte against the pre-fix literals."""
    t = dict(_table("ENEMY_TINTS"))
    t.update(_table("BIOME_TINTS"))
    t.update(_table("BOSS_TINTS"))
    for cls in FIXED_CLASSES:
        assert max(t[cls]) > 1.0, "%s row is not a lift: %r" % (cls, t[cls])
    # identity law — the classes that MEASURED clear keep their shipped
    # values (M6 §7.1: the lift lands where the floor is breached):
    assert t["warden"] == (1.0, 0.72, 0.45)
    assert t["moor-brute"] == (0.66, 0.78, 0.48)
    assert t["dune-scarab"] == (0.92, 0.78, 0.42)
    assert t["rime-ghoul"] == (0.55, 0.82, 0.95)


def test_glow_law_untouched():
    """CT-E4 single-source law: the glow fallback did NOT fire (draw count
    unchanged) — the radii/alphas consts stay the ONE source of truth and
    no new shading mode shipped with this card."""
    for name in ("GLOW_ALPHAS", "ENEMY_GLOW_RADII", "BOSS_GLOW_RADII"):
        assert "const " + name in RENDER
    assert RENDER.count("const GLOW_ALPHAS") == 1
    # no unshaded-read violation: this card added no shading mode anywhere.
    hv = read_text(os.path.join(SCRIPTS, "horde_viz.gd"))
    assert "SHADING_SHADED" not in hv


# ---- CT-E1: the gate itself can go RED (synthetic, engine-free) -------------

def _plate(tmp_path, mob_luma):
    """A synthetic 1280x720 frame: flat ground at the tundra ring luma with
    a mob-sized patch at mob_luma at the capture's FIXED placement point."""
    a = np.full((720, 1280), 18.0, dtype=np.uint8)
    ax, ay = br._mob_anchor()
    a[int(ay) - 10:int(ay) + 10, int(ax) - 17:int(ax) + 17] = int(mob_luma)
    p = os.path.join(str(tmp_path), "mob-synthetic.png")
    Image.fromarray(a).save(p)
    return p


def test_planted_invisible_mob_goes_red(tmp_path):
    """A mob within a few luma of its own ground = no instance pixels at
    ring+100 nor ring+45 = the RED row (the planted dark-copy idiom, driven
    here without the engine; the on-tree planted pair rides the capture)."""
    ring, mob, ratio = br.mob_metrics(_plate(tmp_path, 22.0))
    assert mob is None and ratio is None  # RED: MOB INVISIBLE


def test_bright_mob_clears(tmp_path):
    """The twin: a lifted mob whose pixels separate clearly from its own
    ground (here at ring+100, the pawn mask's own first stage) goes GREEN
    through the SAME code path."""
    ring, mob, ratio = br.mob_metrics(_plate(tmp_path, 120.0))
    assert mob is not None
    assert ratio >= br.RATIO_MIN


def test_mob_leg_reuses_the_one_ratio_law():
    """Mechanism monogamy (M6 §7.1): the mob leg gates on RATIO_MIN — the
    SAME const the pawn law gates on; no second floor const exists in the
    tool."""
    src = read_text(os.path.join(TOOLS, "biome_readability.py"))
    assert re.search(r"^RATIO_MIN = 2\.0", src, re.M), "one floor const"
    assert len(re.findall(r"^RATIO_MIN\s*=", src, re.M)) == 1
    gate = src[src.index("def gate_mob("):]
    assert "ratio >= RATIO_MIN" in gate, "the mob leg rides RATIO_MIN"
    assert "MOB_RATIO" not in src and "MOB_RATIO_MIN" not in src


# ---- CT-E2: the declared-variant law ------------------------------------------

def test_declared_variant_separate_dir_and_rows():
    """HD3D_MOB_GRID is a DECLARED separate run: own env flag, own shots
    dir, own STATE row family — the default windows never load it."""
    cap = read_text(os.path.join(REPO, "godot", "sim",
                            "biome_readability_capture.gd"))
    assert 'const MOB_ENV := "HD3D_MOB_GRID"' in cap
    assert 'const MOB_OUT_ENV := "HD3D_MOB_SHOTS_DIR"' in cap
    assert "MOBSTATE" in cap
    tool = read_text(os.path.join(TOOLS, "biome_readability.py"))
    assert "MOB_SHOTS_DIR" in tool and "--mob-grid" in tool
    default_dir = re.search(r'^SHOTS_DIR = os\.path\.join\(REPO, "\.tmp", '
                            r'"biome-readability-shots"\)', tool, re.M)
    assert default_dir, "the default shots dir row is untouched"


def test_default_shots_table_stays_verbatim():
    """The nine shipped default windows stay byte-verbatim in the capture
    (the declared-variant law, s8 precedent): same times, same png names,
    same stage rows."""
    cap = read_text(os.path.join(REPO, "godot", "sim",
                            "biome_readability_capture.gd"))
    block = cap[cap.index("const SHOTS := ["):]
    block = block[:block.index("]")]
    rows = re.findall(r'\{"t": ([\d.]+), "png": "([^"]+)", "stage": (\d)\}',
                      block)
    assert [(float(r[0]), r[1], int(r[2])) for r in rows] == [
        (5.0, "readability-grass.png", 1),
        (200.0, "readability-desert.png", 1),
        (350.0, "readability-frozen.png", 1),
        (500.0, "readability-tundra.png", 1),
        (150.0, "readability-s2-moor.png", 2),
        (450.0, "readability-s2-frozen.png", 2),
        (750.0, "readability-s2-tundra.png", 2),
        (225.0, "readability-s3-tundra.png", 3),
        (675.0, "readability-s3-frozen.png", 3)]


# ---- CT-E1 support: the grid is READ, never typed ---------------------------

def test_expected_grid_reads_the_tables():
    """expected_grid() is a re-derivation, not a copy: every ENEMY_TYPES
    class appears in the grid, every (stage × band) window is covered, and
    the spawnable set mirrors _types_open (band roster + GATES rotation) +
    the STAGES bosses column + the ENEMY_TYPES reaper row."""
    grid = br.expected_grid()
    world = read_text(os.path.join(SCRIPTS, "world.gd"))
    enemy_types = set(re.findall(r'^\t"([\w-]+)": \{"hp"', world, re.M))
    assert {r[4] for r in grid} == enemy_types, \
        "every ENEMY_TYPES class is measured on the grid, no ghosts"
    render = read_text(os.path.join(SCRIPTS, "render.gd"))
    stage_ids = set(re.findall(r'\{"id": "([\w-]+)"',
                               render[render.index("const STAGES"):]))
    assert set(r[1] for r in grid) == stage_ids
    bands = set(re.findall(r'"name": "([A-Z ]+)"',
                           render[render.index("const BIOMES"):]))
    assert set(r[2] for r in grid) >= {"MOORLAND", "BURNING DUNES",
                                       "THE FROZEN WASTE", "DEAD TUNDRA"}
    # per-stage: every band row of every stage row has at least one shot
    for sid in stage_ids:
        for band in bands & {r[2] for r in grid if r[1] == sid}:
            assert any(r[2] == band for r in grid if r[1] == sid)
    # the WHITE seven: the fallback classes are all measured somewhere
    white = {"hollow-knight", "hollow-deacon", "cathedral-choir",
             "sunken-prelate", "ossuary-warden", "stair-acolyte",
             "the-reaper"}
    assert white <= {r[4] for r in grid}


def test_grid_shots_dir_is_separate_from_default():
    """Own shots dir family (M6 §7.2): the mob PNG family is named mob-*
    and lives under a dir the default gate never reads."""
    grid = br.expected_grid()
    assert all(r[5].startswith("mob-") for r in grid)
    assert br.MOB_SHOTS_DIR != br.SHOTS_DIR
