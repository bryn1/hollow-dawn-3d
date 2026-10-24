"""ROSTER WIRING pins (MC 11220 T-M1h): the ten feature-6 weapons + the ten
partner passives land on the EXISTING seams — no new mechanism beside an
existing one. Source-truth suite convention (see test_game_numbers.py
header): the .gd files are read as text.

Rows: (1) the 15 passive STAT ROWS on GameState seeded at BOTH sites and
the partner seams at the existing application points (gall-vial rides the
damage multiplier, rotten-plate the intake seam, gilded-skull the xp seam
as its OWN additive term — the pinned insight line untouched; cracked-heart
applies at the ONE passive pick site; loadstone rides the magnet seam);
(2) the ten new _fire arms — per-weapon stat rows (OUR numbers, mapping
table in .tmp/m1h-roster.txt) each spelled on an EXISTING effect class;
(3) the projectile-step roster flags (pierce/bounce/ret) with the v1 path
untouched; (4) the §i family-cap extension keeping the pinned ember/
cleaver terms verbatim (pre-roster builds get the old caps exactly).
"""

import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")


def read(name):
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return fh.read()


WEAPONS = read("weapons.gd")
GAME_STATE = read("game_state.gd")
LEVELUP = read("levelup.gd")
WORLD = read("world.gd")
FX = read("viz_fx.gd")

PARTNER_KEYS = ["cracked-heart", "iron-wrap", "tall-candles", "four-leaf-charm",
                "knotted-chain", "loadstone", "rotten-plate", "twin-runes",
                "gall-vial", "gilded-skull"]


# ---- (1) the 15 STAT ROWS + the partner seams --------------------------------

def test_passive_stat_rows_seeded_both_sites():
    # the dict init AND start_run carry all 15 keys (pool + seams index a
    # real key; the roadmap "one stat row on GameState" obligation)
    for key in PARTNER_KEYS:
        assert GAME_STATE.count('"%s": 0' % key) == 2, key


def test_damage_seams_extended_not_duplicated():
    # ONE multiplier, ONE intake seam, ONE xp seam — partners ride them.
    assert re.search(r"return 1\.0 \+ 0\.1 \* passives\.ferocity "
                     r"\+ 0\.08 \* float\(passives\[\"gall-vial\"\]\)",
                     GAME_STATE)
    assert re.search(r"return maxf\(0\.0, raw - passives\.ward "
                     r"- float\(passives\[\"rotten-plate\"\]\)\)", GAME_STATE)
    # gilded-skull: its OWN additive line in add_xp (the insight pin stays)
    assert re.search(r"xp \+= amount \* 0\.08 \* float\(passives"
                     r"\[\"gilded-skull\"\]\) \* meta_xp_mult", GAME_STATE)


def test_roster_multiplier_seams():
    assert re.search(r"return 1\.0 \+ 0\.06 \* float\(passives\[\"iron-wrap\"\]\)",
                     GAME_STATE)
    assert re.search(r"return 1\.0 \+ 0\.08 \* float\(passives\[\"knotted-chain\"\]\)",
                     GAME_STATE)
    assert re.search(r"return 1\.0 \+ 0\.06 \* float\(passives\[\"tall-candles\"\]\)",
                     GAME_STATE)
    assert re.search(r"return int\(passives\[\"twin-runes\"\]\)", GAME_STATE)


def test_cracked_heart_applies_at_the_pick_seam():
    # +10 max hp (and +10 hp) at the ONE passive pick site (apply_offer).
    assert re.search(r"if card\.key == \"cracked-heart\":", LEVELUP)
    body = LEVELUP[LEVELUP.index('"passive":'):]
    assert re.search(r"game\.max_hp \+= 10\.0", body)
    assert re.search(r"game\.hp \+= 10\.0", body)


def test_loadstone_rides_the_magnet_seam():
    assert re.search(r"magnet \+= 15\.0 \* float\(game\.passives\[\"loadstone\"\]\)",
                     WORLD)
    # the v1 grip line untouched (STAY-GREEN byte-pin elsewhere)
    assert re.search(r"var magnet: float = 60\.0 \* \(1\.0 \+ 0\.25 \* "
                     r"game\.passives\.grip\)", WORLD)


# ---- (2) the ten _fire arms: OUR stat rows, EXISTING classes ---------------

FIRE_ROWS = {
    "bone-whip": (r"w\.cd = rate\(l, 0\.75\)", r"\(7\.0 \+ 3\.0 \* l\)", "arcs"),
    "dart-loop": (r"w\.cd = rate\(l, 0\.42\)", r"\(5\.0 \+ 2\.5 \* l\)", "bolts"),
    "hewn-axe": (r"w\.cd = rate\(l, 1\.7\)", r"\(20\.0 \+ 8\.0 \* l\)", "throws"),
    "pilgrim-cross": (r"w\.cd = rate\(l, 2\.2\)", r"\(14\.0 \+ 5\.0 \* l\)", "throws"),
    "censer-of-hours": (r"w\.cd = rate\(l, 1\.3\)", r"\(8\.0 \+ 3\.5 \* l\)", "bolts"),
    "rot-water": (r"w\.cd = 0\.7", r"\(3\.0 \+ 1\.6 \* l\)", "rings"),
    "spectral-disc": (r"w\.cd = rate\(l, 1\.5\)", r"\(12\.0 \+ 5\.0 \* l\)", "bolts"),
    "storm-peal": (r"w\.cd = rate\(l, 2\.0\)", r"\(12\.0 \+ 5\.0 \* l\)", "bursts"),
    "fire-lash": (r"w\.cd = rate\(l, 1\.4\)", r"\(16\.0 \+ 6\.0 \* l\)", "bolts"),
    "doom-sigil": (r"w\.cd = rate\(l, 12\.0\)", r"\(40\.0 \+ 14\.0 \* l\)", "rings"),
}


def _arm(wid):
    """One _fire match arm: from its header to the next arm header (or the
    fallback arm). Sliced INSIDE func _fire so the META table's id entries
    cannot shadow the arm."""
    fire = WEAPONS[WEAPONS.index("func _fire"):]
    m = re.search(r'"%s":.*?(?=\n\t\t"|\n\t\t_:)' % re.escape(wid), fire,
                  re.S)
    assert m, wid
    return m.group(0)


def test_new_fire_rows_and_class_reuse():
    for wid, (cd, dmg, fx) in FIRE_ROWS.items():
        arm = _arm(wid)
        assert re.search(cd, arm), wid
        assert re.search(dmg, arm), wid
        # the arm speaks an EXISTING effect class (append) and/or _hit
        assert fx + ".append(" in arm or "_hit(" in arm, wid
    # no new FX arrays: the six transients are exactly the v1 six
    assert len(re.findall(r"^var (bolts|throws|bursts|arcs|rings|halos):",
                          WEAPONS, re.M)) == 6


def test_partner_read_sites_in_the_new_arms():
    # iron-wrap / duration / area / twin-runes consume at the roster spawn
    # math (the six v1 weapons' byte-pinned numbers stay untouched — the
    # STAY-GREEN ruling named in the M1h capture).
    for fn in ("proj_speed_mult()", "duration_mult()", "area_mult()",
               "extra_projectiles()"):
        assert fn in WEAPONS, fn


def test_fire_fallback_noop_kept_for_evolved_ids():
    # evolved ids ride the T-M1e shipped semantics: unknown id -> no-op cd
    assert re.search(r"_:\s*\n\s*w\.cd = 1\.0", WEAPONS)


# ---- (3) projectile-step roster flags, v1 path untouched -------------------

def test_projectile_flags_not_v1_path():
    assert '"pierce"' in WEAPONS and '"bounce"' in WEAPONS and '"ret"' in WEAPONS
    assert re.search(r"const DISC_BOUNCE_R := 460\.0", WEAPONS)
    # the S4 straight-flight pin line survives verbatim
    assert re.search(r"b\.x \+= b\.vx \* dt", WEAPONS)
    assert not re.search(r"re-?aim|homing", WEAPONS, re.IGNORECASE)


# ---- (4) §i family caps keep the pinned terms ------------------------------

def test_render_caps_family_sum_superset_of_pinned():
    # the pinned §i formulas survive verbatim inside the family sums, and
    # the roster contributions ride ONE table mirrored by sim_combat.
    assert re.search(r"1 \+ int\(\(_level\(\"ember\"\) - 1\) / 3\) \+ "
                     r"_roster_cap\(BOLT_ROSTER\)", FX)
    assert re.search(r"1 \+ int\(\(_level\(\"cleaver\"\) - 1\) / 4\) \+ "
                     r"_roster_cap\(THROW_ROSTER\)", FX)
    assert re.search(r"\"dart-loop\":\s*\n\s*return 1 \+ int\(\(level - 1\) / 3\)", FX)
    assert re.search(r"\"hewn-axe\":\s*\n\s*return 1 \+ int\(\(level - 1\) / 4\)", FX)
    assert re.search(r"\"censer-of-hours\":\s*\n\s*return 4", FX)
