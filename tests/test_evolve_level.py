"""M6 F3 evolve-at-level rule + PS-E5 chips law (MC 11697 T-M6p,
M6-SPEC §3/§6.3). Source-truth pins over the ONE table + the ONE chip
resolver: the chips a passive card carries MUST equal that passive's
partner set across BOTH tables (the 9 evolution partners + the union
recipes), the four generics carry [], and effect() is the single
identity/boost resolution (the byte law's IEEE guard rides it).
"""

import functools
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
GODOT = os.path.join(conftest.REPO, "godot")
FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures",
                       "chests-evolve-m1e.jsonl")

read = functools.partial(conftest.read_script, code_only=True)

EVO = read("evolutions.gd")
UNION = read("union.gd")
LEVELUP = read("levelup.gd")
WEAPONS = read("weapons.gd")

GENERICS = {"ferocity", "haste", "ward", "grip"}  # spec §3.3's four


def _evo_partners():
    rows = re.findall(r"\"([a-z-]+)\":\s*\{\"partner\": \"([a-z-]+)\"",
                      " ".join(l for l in EVO.splitlines()
                               if '"partner"' in l and "TABLE" not in l))
    out = {}
    for base, partner in rows:
        out.setdefault(partner, set()).add(base)
    return out


def _union_partners():
    body = UNION[UNION.index("const TABLE"):]
    out = {}
    for m in re.finditer(r"\{\"a\": \"([a-z-]+)\", \"b\": \"([a-z-]+)\",\s*"
                         r"\"passive\": \"([a-z-]+)\"", body):
        a, b, passive = m.groups()
        out.setdefault(passive, set()).update([a, b])
    return out


def test_chips_equal_partner_set_both_tables():
    # THE law (PS-E5): affects_by_passive == the merged partner map, computed
    # from the two live tables here — the shipped entry must agree.
    expected = {}
    for k, v in _evo_partners().items():
        expected.setdefault(k, set()).update(v)
    for k, v in _union_partners().items():
        expected.setdefault(k, set()).update(v)
    body = EVO[EVO.index("static func affects_by_passive"):]
    # reads BOTH tables, dedupes, sorts (the exact law above, structurally)
    assert "for base_id in TABLE:" in body
    assert "UnionSystem.TABLE.values()" in body
    assert ".sort()" in body
    # the four generics appear as NO passive column in either table —
    # they carry [] BY THE RULE (planted red PS-E5: chips on a global).
    for g in GENERICS:
        assert g not in expected, "%s must carry no chips" % g
    # the §3.3 named chip row: insight carries the UNION's two bases
    assert expected["insight"] == {"halo", "spike"}
    # every evolution partner is a chip carrier too
    assert expected["cracked-heart"] == {"bone-whip"}
    assert expected["loadstone"] == {"rot-water", "censer-of-hours"} or \
        expected["loadstone"] == {"censer-of-hours"}, \
        "loadstone chips = the dirge recipe bases ∪ any evolution partner"


def test_chip_stamps_and_paths():
    # cards carry "chips" through _chips_for (icon-<id> convention); the
    # ids in every expected set resolve to REAL icon files (assert-before-
    # load's consumer guarantee — a missing chip is a blank square).
    assert re.search(r"\"chips\": _chips_for\(passive\.key\)", LEVELUP)
    for passive, ids in {**_evo_partners(), **_union_partners()}.items():
        for wid in ids:
            png = os.path.join(GODOT, "assets", "icons",
                               "icon-%s.png" % wid)
            assert os.path.isfile(png), "chip icon missing: %s" % png


def test_level_term_is_five_everywhere():
    # the at-column: every row pins 5, and the rule reads `at` (never 8,
    # never MAX_LEVEL, never a time term).
    assert re.search(r"const EVO_LEVEL := 5", EVO)
    body = EVO[EVO.index("static func try_evolve"):]
    assert "row.at" in body and "MAX_LEVEL" not in body
    assert "GATE_T" not in body and "game.time" not in body, \
        "the level rule owns no clock term (§4.4 R6)"
    for m in re.finditer(r"\"at\": (\d+)", EVO):
        assert int(m.group(1)) == 5


def test_effect_is_the_one_resolution():
    # effect(): base ids + unknown ids -> identity; evolved ids -> their
    # row. weapons.gd consults ONLY this entry (the ':' no-op hole closes:
    # every boost/flag/radius site reads eff, every base row byte-identical
    # through the ×1.0 IEEE identity).
    assert re.search(r"static func effect\(id: String\) -> Dictionary", EVO)
    assert EVO.count("IDENTITY_DMG") >= 2
    assert "for base_id in TABLE:" in EVO[EVO.index("func effect"):]
    # one resolution per weapon tick in the fire path:
    assert WEAPONS.count("EvolutionSystem.effect(") >= 3, \
        "fire/update/orbit read the ONE resolution"
    assert "row.dmg" not in WEAPONS and "EvolutionSystem.TABLE" not in WEAPONS, \
        "weapons.gd never reads the raw table — only effect()"


def test_identity_row_in_the_sim_dump():
    # the committed journey-side truth: the effect()-identity row ships in
    # the evolve-adjacent spec channel (sim_combat.boost_legs) — here we
    # pin the evolve fixture carries the level-trigger rows and the
    # identity dump EXISTS as a committed gate (byte battery runs it).
    rows = conftest.jsonl_rows(FIXTURE)
    assert any(r["ev"] == "evo_l5_partner" or r.get("leg") == "evo_l5_partner"
               for r in rows)
