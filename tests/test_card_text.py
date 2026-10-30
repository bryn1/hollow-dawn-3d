"""M6 F4 CARD TEXT (MC 11697 T-M6p, M6-SPEC §6): every offered skill kind
carries a SHORT, UNIQUE, TRUTHFUL explanation at the ONE desc source — the
15 weapon META rows (the SPEC §6.1 pinned copy — the spec names itself
"the bytes the pin compares", so this file parses THE SPEC and compares),
the 15 PASSIVES rows, the ONE bonus card and the 3 LIMIT_CARDS rows; plus
the trigger-honesty rows (Lv5 hint clause + the passive chip stamps) whose
RENDER consumer is screens.gd's chip row (the pixel half lives in
tools/dawnwell_pixel_gate.py's levelup/CHIPS leg).

Source-truth convention: the .gd files are read as text (code_only —
comments never enter a pin); docs/M6-SPEC.md is the copy source.
"""

import functools
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
SPEC = os.path.join(conftest.REPO, "docs", "M6-SPEC.md")

read = functools.partial(conftest.read_script, code_only=True)

WEAPONS = read("weapons.gd")
LEVELUP = read("levelup.gd")
SCREENS = read("screens.gd")


def _spec_meta_copy():
    text = open(SPEC, encoding="utf-8").read()
    block = text[text.index("### 6.1"):text.index("### 6.2")]
    return dict((k, v) for k, v in re.findall(
        r"`([a-z-]+)` \"([^\"]+)\"", block))


def _meta_descs():
    body = WEAPONS[WEAPONS.index("const META"):]
    return {m.group(1): m.group(2) for m in re.finditer(
        r"\"([a-z-]+)\": \{\"name\": \"[^\"]*\", \"icon\": \"icon-[a-z-]+\", "
        r"\"desc\": \"([^\"]*)\"\}", body)}


def _passive_rows():
    body = LEVELUP[LEVELUP.index("const PASSIVES"):
                   LEVELUP.index("static func build_pool")]
    return {m.group(1): m.group(2) for m in re.finditer(
        r"\{\"key\": \"([a-z-]+)\", \"name\": \"[^\"]*\", "
        r"\"desc\": \"([^\"]*)\"\}", body)}


def _limit_rows():
    body = LEVELUP[LEVELUP.index("const LIMIT_CARDS"):]
    return {m.group(1): m.group(2) for m in re.finditer(
        r"\{\"kind\": \"limit\", \"key\": \"([a-z]+)\", \"name\": \"[^\"]*\",\s*"
        r"\"desc\": \"([^\"]*)\", \"icon\"", body)}


# ---- TX-E1: every pool kind explains itself, short + unique -----------------

def test_all_pool_descs_present_short_unique():
    descs = dict(_meta_descs())
    assert len(descs) == 15, "META carries 15 weapon descs (F6 pool 16->15)"
    passives = _passive_rows()
    assert len(passives) == 15
    descs.update(passives)
    bonus = re.search(r"\{\"kind\": \"bonus\", \"name\": \"[^\"]*\", "
                      r"\"desc\": \"([^\"]*)\"", LEVELUP)
    assert bonus, "the bonus card row vanished"
    descs["bonus"] = bonus.group(1)
    limits = _limit_rows()
    assert len(limits) == 3
    descs.update({"limit:" + k: v for k, v in limits.items()})
    for k, d in descs.items():
        assert d, "%s has an empty desc" % k
        assert len(d) <= 72, "%s desc exceeds the 72-char card budget" % k
    vals = list(descs.values())
    dupes = sorted({v for v in vals if vals.count(v) > 1})
    assert not dupes, "two pool kinds share a desc (a lie or a bug): %s" % dupes


def test_meta_copy_is_the_spec_6_1_bytes():
    # §6.1: "the per-row descs below are the SPEC's pinned copy (they are
    # the bytes the pin compares)" — compare live META against the spec.
    spec = _spec_meta_copy()
    assert len(spec) == 15, "the §6.1 table lost/gained a row"
    live = _meta_descs()
    for k, v in spec.items():
        assert live.get(k) == v, "META desc drifted from §6.1: %s" % k


def test_passive_honesty_fixes():
    # The audit's honesty rows (§6.1's rewrite-missing column + §3.3):
    # loadstone is a PULL-RADIUS passive (the magnet term lives in
    # drops.gd — "+15 px" is its own unit, not a percent), rotten-plate is
    # the PLATE intake term and the LIMIT card the LIMIT intake term — the
    # descs must name their OWN term (uniqueness alone can't tell the
    # mechanism; these name it).
    p = _passive_rows()
    assert "pull radius" in p["loadstone"], p["loadstone"]
    assert p["rotten-plate"] == "-1 damage taken (plate)", p["rotten-plate"]
    assert _limit_rows()["arm"] == "-1 damage taken (limit)"


# ---- the trigger-honesty card rows (§3.3 F3's UI half) ----------------------

def test_lv5_hint_clause_at_the_desc_source():
    # The Lv4->5 upgrade card names its evolution IFF the partner is
    # carried (spec §3.3: "names its evolution iff" — never a promise the
    # pick cannot keep): the clause reads TABLE + PASSIVES through the ONE
    # table and appends to meta.desc (still the ONE desc source).
    assert re.search(r"owned\.level \+ 1 == EvolutionSystem\.EVO_LEVEL",
                     LEVELUP)
    assert "EvolutionSystem.TABLE.has(id)" in LEVELUP
    assert "game.passives.get(" in LEVELUP, "the partner-carried condition"
    assert " — Lv%d + %s → %s" in LEVELUP, "the pinned hint copy"
    assert "_evo_title" in LEVELUP and "_passive_name" in LEVELUP


def test_passive_cards_carry_chips():
    # every passive card is stamped with its partner chips AT THE CARD
    # SOURCE (§3.3: the chips ride the card dict; screens never re-derives)
    assert re.search(r"\"chips\": _chips_for\(passive\.key\)", LEVELUP)
    # the chip set reads BOTH tables (evolutions partners + union recipes)
    # through the ONE affects_by_passive entry — never a copied list.
    assert "affects_by_passive" in LEVELUP


def test_screens_render_the_chip_row():
    # the ONE consumer: screens.gd draws card["chips"] through the shipped
    # icon_path resolver (assert-before-load, the §j law) — no second card
    # builder exists, and a card WITHOUT chips paints no row.
    i = SCREENS.index("card.has(\"chips\")")
    block = SCREENS[i:i + 1600]
    assert "HBoxContainer" in block and "TextureRect" in block
    assert "icon_path" in block
    assert "card.chips.size() > 0" in block, "empty chips paint NO row"
