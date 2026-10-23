"""Chests + evolutions (MC 11209 T-M1e): PARITY-ROADMAP rev3 M1 feature 5.
Source-truth suite convention (see test_game_numbers.py header): the .gd
files are read as text; behaviour rows are the committed dump
(godot/sim/sim_evolve.gd, seed-pinned 11209, byte-stable).

Stated readings (evolutions.gd + sim_evolve.gd headers carry the same):
* "weapon MAX + partner passive carried (any rank) + chest opened at
  t >= 600" is ONE rule entry — EvolutionSystem.try_evolve, called at the
  ONE chest-open site inside world.collect_pickups (the same 16 px touch
  funnel as gems/coins/heals). 600 is OUR gate (DA c1 G-1: our own v1
  WIN_TIME — the source page's 10:00 is a stated coincidence).
* Replacement is IN-SLOT (feature 3: "evolutions replace in-slot, never
  add a 7th"): same array index, level kept, cd reset (doc's "reset its
  cooldown").
* One chest evolves ONE weapon (first eligible in game.weapons order) —
  the doc's own supply row ("≤ ~3 chest rolls vs 6 evolutions") only reads
  as one evolution per chest.
* Chest opening pauses through the FROZEN levelup phase (DA c1 A-2): it
  rides the existing pending_levels -> _enter_levelup seam; the
  exhausted-pool reward fallback stays the ONE bonus_card gold mechanism
  (ours). No new phase value may exist anywhere (pinned below).
* DA c3 C-2: evolved ids ride the SEPARATE table (feature 5's "evolution
  table pytest pin"), NOT WeaponSystem.META — the 16/32 WEAPON_KEYS math
  in test_card_icons stays untouched, so this file changes NO icons pin.
"""

import json
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
GODOT = os.path.join(conftest.REPO, "godot")
FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures",
                       "chests-evolve-m1e.jsonl")
SHOT = os.path.join(conftest.REPO, "assets", "screens", "m1-chest.png")

# The feature-6 partner column, OUR table (rev 3, verbatim rows):
DOC_TABLE = {
    "bone-whip": ("cracked-heart", "red-wail"),
    "dart-loop": ("iron-wrap", "thousand-darts"),
    "hewn-axe": ("tall-candles", "rot-spiral"),
    "pilgrim-cross": ("four-leaf-charm", "judgement-cross"),
    "censer-of-hours": ("knotted-chain", "eternal-matins"),
    "rot-water": ("loadstone", "the-sluice"),
    "spectral-disc": ("rotten-plate", "grave-orbit"),
    "storm-peal": ("twin-runes", "rolling-thunder"),
    "fire-lash": ("gall-vial", "inferno-lash"),
    "doom-sigil": ("gilded-skull", "pale-moon"),
}


def read(name):
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return "".join(line.split("#")[0] + "\n" for line in fh.read().splitlines())


EVO = read("evolutions.gd")
WORLD = read("world.gd")
MAIN = read("main.gd")
HUD = read("hud_3d.gd")
PICKUP = read("pickup_viz.gd")
WEAPONS = read("weapons.gd")
LEVELUP = read("levelup.gd")


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


# ---- the gate value (roadmap: OUR 600, DA c1 G-1 provenance) ----------------

def test_gate_const_600():
    assert const("GATE_T", EVO) == 600.0
    # the gate reads OPEN time, and the whole rule lives in the ONE entry
    assert re.search(r"if game\.time < GATE_T:\s*\n\s*return \"\"", EVO)
    assert re.search(r"EvolutionSystem\.try_evolve\(game\)", WORLD)


# ---- the evolution table (c3-C2: SEPARATE table, doc rows exact) ------------

def test_evolution_table_rows_match_doc():
    triples = re.findall(
        r"\"([a-z-]+)\":\s*\{\"partner\": \"([a-z-]+)\", \"evo\": \"([a-z-]+)\"\}",
        " ".join(l for l in EVO.splitlines()
                 if '"partner"' in l and "TABLE" not in l))
    assert dict((b, (p, e)) for b, p, e in triples) == DOC_TABLE, \
        "evolution table must be the roadmap feature-6 partner column"
    assert len(triples) == 10


def test_table_is_separate_never_in_meta():
    # DA c3 C-2 reading: evolved ids NEVER ride WeaponSystem.META (else the
    # test_card_icons 16/32 replacement math breaks).
    for base, (_, evo) in DOC_TABLE.items():
        assert '"%s"' % base not in WEAPONS and '"%s"' % evo not in WEAPONS, \
            "table ids must stay out of weapons.gd"
    assert "TABLE" not in WEAPONS


def test_evo_and_partner_icon_files_exist():
    # The ONE naming convention (icon-<id>.png, §j tree; T-M1c manifest
    # tools/vm100/icons-batch-m1c.tsv) — HUD + cards consume icons through
    # exactly this path, so the table's existence IS the icon pin.
    for base, (partner, evo) in DOC_TABLE.items():
        evo_icon = os.path.join(GODOT, "assets", "icons", "icon-%s.png" % evo)
        assert os.path.isfile(evo_icon), evo_icon
        p_icon = os.path.join(GODOT, "assets", "icons", "passives",
                              "icon-%s.png" % partner)
        assert os.path.isfile(p_icon), p_icon
    assert os.path.isfile(os.path.join(GODOT, "assets", "icons",
                                       "icon-chest.png"))


# ---- the open site: collect_pickups, the ONE touch funnel -------------------

def test_chest_open_wired_in_collect_pickups():
    collect = WORLD[WORLD.index("func collect_pickups"):]
    assert re.search(r"for i in range\(chests\.size\(\) - 1, -1, -1\):", collect)
    assert re.search(r"_dist\(c, game\.player\) < 16\.0", collect), \
        "chest touch range must be the same 16 px funnel as the other pickups"
    assert re.search(r"EvolutionSystem\.try_evolve\(game\)\s*\n"
                     r"\s*game\.pending_levels \+= 1", collect), \
        "the rule fires at OPEN, then the reward card rides pending_levels"
    assert collect.count("chests.remove_at") == 1, "one consume site"


def test_phase_enum_stays_frozen():
    # DA c1 A-2: chest opening reuses the frozen enum — no new phase value
    # may appear anywhere, and main must keep exactly the two set_phase
    # transitions of the existing seam.
    raw_game = open(os.path.join(SCRIPTS, "game_state.gd"),
                    encoding="utf-8").read()
    assert "menu | playing | levelup | gameover | win" in raw_game, \
        "the frozen enum comment (phase var) must stay"
    assert set(re.findall(r"set_phase\(\"(\w+)\"\)", MAIN)) == {"levelup",
                                                                "playing"}
    assert "chest" not in MAIN.lower(), \
        "no chest-specific phase/UI in main.gd — the seam is the existing one"
    # and no parallel card UI: levelup.gd knows nothing about chests/evos
    assert "chest" not in LEVELUP.lower() and "evo" not in LEVELUP.lower()


def test_hud_resolves_evolved_ids_via_naming_convention():
    # META stays the 6-weapon table; the HUD falls back to icon-<id>.png.
    assert re.search(r"WeaponSystem\.META\.has\(w\.id\)\s*"
                     r"else \"icon-\" \+ w\.id", HUD)
    assert 'META[w.id].icon \\' in HUD or "META.has" in HUD


def test_pickup_viz_draws_chests():
    assert const("DRAWS", PICKUP) == 5.0
    assert re.search(r"_write_items\(_chest, world\.chests", PICKUP)
    assert re.search(r"icon-chest\.png", PICKUP)
    # §b draw budget discipline: the note may not be bumped silently here
    # (the roadmap re-tallies planned 40 on the feature-6 card) — the hard
    # cap test lives in test_art_integration; this pins the seam's own row.


# ---- behaviour: the committed dump (sim_evolve.gd) --------------------------

def fixture_rows():
    with open(FIXTURE, encoding="utf-8") as fh:
        return [json.loads(line) for line in fh if line.strip()]


def gates():
    return {r["leg"]: r for r in fixture_rows() if r["ev"] == "evo_gate"}


def test_dump_shape_and_verdict():
    rows = fixture_rows()
    legs = [r["leg"] for r in rows if r["ev"] == "evo_gate"]
    assert legs == ["evo_max_partner_after", "evo_max_partner_before",
                    "evo_underlevel_partner", "evo_max_nopartner",
                    "evo_max_wrong_passive", "evo_partner_any_rank",
                    "evo_non_table_weapon", "evo_all_ten_rows",
                    "evo_one_per_chest", "evo_card_seam"]
    assert all(g["ok"] for g in gates().values()), "committed dump has a RED leg"
    assert [r for r in rows if r["ev"] == "evolve_verdict"][-1]["ok"] is True


def test_evolve_leg_with_partner():
    # roadmap ACCEPT verbatim: "evolved id in game.weapons, base removed,
    # slot count unchanged" (+ in-slot, level kept, cd reset — header).
    g = gates()["evo_max_partner_after"]
    assert "red-wail-8-0" in g["after"] and "bone-whip" not in g["after"]
    assert "talon-1" in g["after"], "slot count unchanged (2 entries)"
    assert g["checks"]["in_slot"] and g["checks"]["base_gone"] \
        and g["checks"]["slot_count"]
    assert g["checks"]["reward_card"], "the open grants its reward card too"


def test_planted_red_before_gate():
    # roadmap ACCEPT verbatim: "planted-red chest at t < gate must NOT
    # evolve" — and the reward card still lands (the fallback path).
    g = gates()["evo_max_partner_before"]
    assert g["t"] == 599.0
    assert "bone-whip-8-5000" in g["after"] and "red-wail" not in g["after"]
    assert g["checks"]["evolved"] and g["checks"]["reward_card"]


def test_negative_rows():
    for leg, base in [("evo_underlevel_partner", "bone-whip-7"),
                      ("evo_max_nopartner", "bone-whip-8"),
                      ("evo_max_wrong_passive", "bone-whip-8"),
                      ("evo_non_table_weapon", "talon-8")]:
        g = gates()[leg]
        assert base in g["after"], leg
        assert "red-wail" not in g["after"], leg


def test_partner_any_rank_row():
    g = gates()["evo_partner_any_rank"]
    assert "red-wail-8-0" in g["after"], "any rank of the partner counts"


def test_all_ten_table_rows_leg():
    g = gates()["evo_all_ten_rows"]
    assert g["after"] == [
        "talon-1-0 %s-8-0" % evo for _, evo in DOC_TABLE.values()], \
        "every table row must replace in-slot through the real funnel"
    assert all(g["checks"].values())


def test_one_evolution_per_chest():
    g = gates()["evo_one_per_chest"]
    assert g["checks"]["first_chest_one_evo"] \
        and g["checks"]["second_chest_second_evo"]
    # after1: only red-wail; after2: both evolved, slot count still 3
    assert "thousand-darts" not in g["after"][0]
    assert "thousand-darts-8-0" in g["after"][1] and g["after"][1].count("talon") == 1


def test_card_seam_leg():
    # the open pauses through the ONE frozen seam and closes through _pick
    g = gates()["evo_card_seam"]
    for k in ("phase_stays_playing", "pending_raised", "seam_phase_levelup",
              "offer_nonempty", "back_to_playing", "pending_spent",
              "evo_survives_pick"):
        assert g["checks"][k], k


# ---- the acceptance shot (pixel floor lives in tools/chest_pixel_gate.py) ---

def test_shot_asset_exists():
    assert os.path.isfile(SHOT), \
        "assets/screens/m1-chest.png must be committed (gate: chest_pixel_gate)"
