"""Carry caps (MC 11206 T-M1b; pool ENLARGED by MC 11220 T-M1h): PARITY-
ROADMAP rev3 M1 feature 3, OUR numbers — 6 weapon slots + 6 passive KINDS,
gated in the ONE pool source levelup.gd build_pool. The existing 5-stack
cap per passive kind is unchanged (MAX_PASSIVE_STACKS stays pinned in
test_biome_numbers.py).

Source-truth suite convention (see test_game_numbers.py header): the .gd
files are read as text. Pins here cover (1) the named cap consts, (2) the
gate clauses at the seam — the new-weapon append guarded by the slot gate,
the new-passive-KIND append guarded by the kind gate, the stack cap, and
the STRUCTURE that keeps carried upgrades offerable: the weapon-upgrade
append must sit on its own unguarded elif (a plant that gates upgrades too
breaks exactly this pin, mirroring the sim's plant E).

Behaviour rows are the committed dump (godot/sim/sim_caps.gd, seed-pinned
11206, byte-stable, RE-DUMPED on the T-M1h enlarged pool: 16 weapon kinds +
15 passive kinds). The two legs carrying a synthetic slot/kind pin are
declared in their rows — the synthetic carriers keep the exact 6th-slot/
6th-kind shape the T-M1b planted-red pair exercised; the new-kind cap side
now has fully REAL legs too (passive_roster_kind: the 7th NEW kind never
offered at cap while a carried NEW-kind upgrade stays offerable).
"""

import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures",
                       "carry-caps-m1b.jsonl")


read = conftest.read_script  # MC 11317 C2 seam (raw script text)


LEVELUP = read("levelup.gd")


const = conftest.const  # MC 11317 C2 seam (impl in conftest.py)


# ---- cap consts (roadmap M1 f3: "OUR numbers, named rule") -----------------

def test_cap_consts():
    assert const("MAX_WEAPON_SLOTS", LEVELUP) == 6.0
    assert const("MAX_PASSIVE_KINDS", LEVELUP) == 6.0


# ---- the two clauses in the ONE pool seam (levelup.gd build_pool) ----------

def test_weapon_new_kind_gated_by_slots():
    assert re.search(
        r"var slots_full: bool = game\.weapons\.size\(\) >= MAX_WEAPON_SLOTS",
        LEVELUP)
    assert re.search(
        r"if not slots_full:[^\n]*\n\s*pool\.append\(\{\"kind\": \"weapon\"",
        LEVELUP)


def test_weapon_upgrade_stays_offerable_at_full_slots():
    # The owned-weapon upgrade append sits directly on its own elif: no
    # slots_full guard may ever gate it (plant E RED-proved this leg).
    assert re.search(
        r"elif owned\.level < WeaponSystem\.MAX_LEVEL:\s*\n\s*"
        r"pool\.append\(\{\"kind\": \"upgrade\"",
        LEVELUP)


def test_passive_new_kind_gated_by_carried_kinds():
    assert re.search(
        r"for key in game\.passives:\s*\n\s*if game\.passives\[key\] > 0:\s*"
        r"\n\s*passive_kinds \+= 1",
        LEVELUP)
    assert re.search(
        r"if stacks == 0 and passive_kinds >= MAX_PASSIVE_KINDS:\s*\n\s*"
        r"continue",
        LEVELUP)


def test_passive_stack_cap_still_first_gate():
    # The unchanged 5-stack cap keeps its own early continue.
    assert re.search(
        r"if stacks >= MAX_PASSIVE_STACKS:\s*\n\s*continue",
        LEVELUP)


# ---- behaviour: the committed offer-gating dump (sim_caps.gd) --------------

def fixture_rows():
    return conftest.jsonl_rows(FIXTURE)  # MC 11317 C2 seam


def legs():
    """leg name -> (offer cards, gate row). sim_caps dumps each leg's 100
    caps_offer rows first, then its caps_leg + caps_gate rows, so the gates
    name the blocks in order; the count check pins that order."""
    rows = fixture_rows()
    offers = [r["cards"] for r in rows if r["ev"] == "caps_offer"]
    gates = [r for r in rows if r["ev"] == "caps_gate"]
    assert len(offers) == 100 * len(gates), "dump leg block order drifted"
    out = {}
    for i, g in enumerate(gates):
        cards = [c for batch in offers[i * 100:(i + 1) * 100] for c in batch]
        out[g["leg"]] = (cards, g)
    return out


def _counts(cards):
    weapons = [c for c in cards if c["kind"] == "weapon"]
    upgrades = [c for c in cards if c["kind"] == "upgrade"]
    passives = [c for c in cards if c["kind"] == "passive"]
    return weapons, upgrades, passives


def test_dump_shape():
    rows = fixture_rows()
    gates = [r for r in rows if r["ev"] == "caps_gate"]
    assert [g["leg"] for g in gates] == [
        "weapon_full_slots", "weapon_all_six_real", "weapon_below_cap",
        "passive_full_kinds", "passive_below_kinds", "passive_stack_cap_edge",
        "passive_roster_kind"]
    assert all(g["ok"] for g in gates), "committed dump carries a RED leg"
    assert [r for r in rows if r["ev"] == "caps_verdict"][-1]["ok"] is True
    for name, (cards, gate) in legs().items():
        assert len(cards) == 300, name  # roadmap: 100 dumped offers


def test_weapon_full_slots_legs():
    # Full slots (both the DECLARED-pin 6th-slot leg and the literal
    # all-six-real leg): ZERO kind:"weapon" rows, upgrades still offered.
    for name in ("weapon_full_slots", "weapon_all_six_real"):
        cards, gate = legs()[name]
        weapons, upgrades, _ = _counts(cards)
        assert weapons == [], name
        assert len(upgrades) > 0, name
        assert gate["checks"]["new_weapon_rows_zero"] is True
        assert gate["checks"]["upgrade_rows_present"] is True


def test_weapon_below_cap_leg():
    # <6 slots: the un-carried kinds ARE offered — on the T-M1h enlarged
    # roster that is the whole un-carried rest, spike + the ten feature-6
    # weapons (the six-era pin {"spike"} was REPLACED, not deleted, when
    # the pool grew; no CARRIED kind may ever leak into these rows).
    cards, gate = legs()["weapon_below_cap"]
    weapons, _, _ = _counts(cards)
    assert len(weapons) > 0
    assert set(c["id"] for c in weapons) == {
        "spike", "bone-whip", "dart-loop", "hewn-axe", "pilgrim-cross",
        "censer-of-hours", "rot-water", "spectral-disc", "storm-peal",
        "fire-lash", "doom-sigil"}
    assert gate["ok"] is True


def test_passive_full_kinds_leg():
    # 6 distinct KINDS carried: the un-carried KIND (insight) is never
    # offered; carried-kind upgrades stay offerable.
    cards, gate = legs()["passive_full_kinds"]
    _, _, passives = _counts(cards)
    assert [c for c in passives if c["id"] == "insight"] == []
    assert len(passives) > 0
    assert gate["checks"]["new_kind_rows_zero"] is True
    assert gate["checks"]["carried_kind_rows_present"] is True


def test_passive_below_kinds_leg():
    # 5 carried kinds (on the cap edge): the 6th KIND IS still offered
    # (c2 N-3: the cap blocks the 7th, never the 6th).
    cards, gate = legs()["passive_below_kinds"]
    _, _, passives = _counts(cards)
    assert len([c for c in passives if c["id"] == "insight"]) > 0
    assert gate["ok"] is True


def test_passive_stack_cap_edge_leg():
    # A carried kind AT the 5-stack cap is gone; one at 4 stacks stays.
    cards, gate = legs()["passive_stack_cap_edge"]
    _, _, passives = _counts(cards)
    assert [c for c in passives if c["id"] == "insight"] == []
    assert len([c for c in passives if c["id"] == "ferocity"]) > 0
    assert gate["ok"] is True


def test_passive_roster_kind_leg():
    # T-M1h NEW leg (brief: 7th NEW kind never offered at the 6-KIND cap,
    # NEW-kind upgrades offerable), fully REAL pins: three feature-6
    # partners carried inside a legal 6-kind loadout.
    cards, gate = legs()["passive_roster_kind"]
    _, _, passives = _counts(cards)
    assert [c for c in passives if c["id"] == "loadstone"] == []
    assert len([c for c in passives if c["id"] == "cracked-heart"]) > 0
    assert gate["checks"]["new_kind_rows_zero"] is True
    assert gate["checks"]["new_kind_upgrade_present"] is True
    assert gate["ok"] is True
