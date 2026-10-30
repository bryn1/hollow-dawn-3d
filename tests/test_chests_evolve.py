"""Chests + evolutions (MC 11209 T-M1e; TRIGGER MOVED at MC 11697 T-M6p):
PARITY-ROADMAP rev3 M1 feature 5, re-homed per M6-SPEC §3 (F3).
Growth note (file hygiene, MC 11697): 429 lines (>400) — the T-M6p rewrite
grew the truth table (9 rows + feat/boost columns), the five new legs and
the retired-arm EXCLUDE pins; a split would separate the dump contract
from the source pins that name its rows.
Source-truth suite convention (see test_game_numbers.py header): the .gd
files are read as text; behaviour rows are the committed dump
(godot/sim/sim_evolve.gd, seed-pinned 11209, byte-stable; RE-MINTED at
T-M6p — the fixture's own subject moved: chest trigger -> level trigger,
table 10 -> 9, the time gate out of the evolve rule; M6-SPEC §9 row 3).

Stated readings (evolutions.gd + sim_evolve.gd headers carry the same):
* "weapon at `at` (5) + partner passive carried (any rank) + the next
  level-up PICK applied" is ONE rule entry — EvolutionSystem.try_evolve,
  called ONLY at the levelup.apply_offer seam (the "upgrade" and "passive"
  arms; M6-SPEC §3.1 moved it off the chest: the shipped chest-open arm's
  `else try_evolve` line is RETIRED, pinned absent below). The union
  precedence at the chest (T-M2u) is test_unions' row; GATE_T 600 stayed
  union-side (§4.4 R6), and the evolve rule now has NO time term.
* Replacement is IN-SLOT (feature 3: "evolutions replace in-slot, never
  add a 7th"): same array index, level kept, cd reset (doc's "reset its
  cooldown").
* ONE trigger pick evolves ONE weapon (first eligible in game.weapons
  order) — the one-per-chest law's per-pick twin (§3.1: "the whole rule
  lives in one entry" survives).
* The UNION RESERVE rides the EXTENDED window (§3.4 option (a)): a union
  base stays unevolved while the recipe is achievable — partner below MAX
  OR partner AT MAX with the recipe passive carried (the eligible-at-MAX
  window PS-E4 instruments); the partner gone lifts.
* Chest opening pauses through the FROZEN levelup phase (DA c1 A-2): it
  rides the existing pending_levels -> _enter_levelup seam; a chest can
  still evolve a weapon INDIRECTLY (its tier card's pick rides the same
  seam — PS-E3's declared-honest twin pair). No new phase value may exist
  anywhere (pinned below).
* DA c3 C-2: evolved ids ride the SEPARATE table (feature 5's "evolution
  table pytest pin"), NOT WeaponSystem.META. R2 (T-M6p): the table is NINE
  rows — the doom-sigil -> pale-moon row retired with the pool entry
  (M6-SPEC §4.4); pale-moon must appear in NO live table (pinned below).
"""

import functools
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
GODOT = os.path.join(conftest.REPO, "godot")
FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures",
                       "chests-evolve-m1e.jsonl")
SHOT = os.path.join(conftest.REPO, "assets", "screens", "m1-chest.png")

# The feature-6 partner column, OUR table (rev 3 rows; 9 since the T-M6p
# R2 retirement of the doom-sigil row — replace-not-delete: the row is
# gone HERE because the weapon left the pool at T-M6d and the TABLE row
# retired at this card, M6-SPEC §4.1's site split).
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
}

# The T-M6p boost columns (M6-SPEC §3.2: ONE shape for every row — the
# uniform multiplier law; a per-row drift is a table edit this pin catches).
DOC_BOOSTS = {"at": 5, "dmg": 1.6, "area": 1.35, "cd": 0.75}
DOC_FEATS = {
    "bone-whip": [], "dart-loop": ["pierce"], "hewn-axe": ["ret"],
    "pilgrim-cross": ["pierce"], "censer-of-hours": ["pierce"],
    "rot-water": [], "spectral-disc": ["extra"], "storm-peal": [],
    "fire-lash": ["extra"],
}

read = functools.partial(conftest.read_script,
                       code_only=True)  # MC 11317 C2 seam


EVO = read("evolutions.gd")
WORLD = read("world.gd")
DROPS = read("drops.gd") # M6 T-M6d (MC 11675): the F-10 drops partition
MAIN = read("main.gd")
HUD = read("hud_3d.gd")
PICKUP = read("pickup_viz.gd")
WEAPONS = read("weapons.gd")
LEVELUP = read("levelup.gd")


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


# ---- the gate + the moved trigger seam ---------------------------------------

def test_gate_const_600():
    # T-M6p (MC 11697, M6-SPEC §4.4 R6): GATE_T 600 stays DEFINED here (the
    # union chest gate reads it) but it is the UNION side's time term —
    # the evolve rule no longer owns ANY time term (the one-pick law).
    assert const("GATE_T", EVO) == 600.0
    assert "game.time < GATE_T" not in EVO, \
        "the evolve entry must hold no time term (§4.4 R6: gate stayed union-side)"
    # The trigger lives at the ONE levelup seam — the "upgrade" AND
    # "passive" arms of apply_offer, nowhere else.
    assert LEVELUP.count("EvolutionSystem.try_evolve(game)") == 2, \
        "try_evolve rides exactly the upgrade + passive arms"
    # ... and the retired chest arm stays dead (PS-E3's source twin): the
    # T-M1e `else try_evolve` line at the chest-open site is GONE.
    assert "try_evolve" not in DROPS, \
        "the chest-open arm must NOT evolve (M6-SPEC §3.1 moved the trigger)"


def test_evolution_trigger_reads_apply_offer_only():
    # one seam, no second site: main/world/fire never call try_evolve
    for src in (MAIN, WORLD, WEAPONS):
        assert "try_evolve" not in src
    # the level term is EVO_LEVEL, read per pick, with the partner gate
    assert "w.level < int(row.at)" in EVO or "int(w.level) < int(row.at)" in EVO
    assert const("EVO_LEVEL", EVO) == 5.0


# ---- the evolution table (c3-C2: SEPARATE table, doc rows exact) ------------

def test_evolution_table_rows_match_doc():
    triples = re.findall(
        r"\"([a-z-]+)\":\s*\{\"partner\": \"([a-z-]+)\", \"evo\": \"([a-z-]+)\"",
        " ".join(l for l in EVO.splitlines()
                 if '"partner"' in l and "TABLE" not in l))
    assert dict((b, (p, e)) for b, p, e in triples) == DOC_TABLE, \
        "evolution table must be the roadmap feature-6 partner column"
    assert len(triples) == 9, "NINE rows since the T-M6p R2 retirement"


def test_table_boost_columns_uniform():
    # the uniform multiplier law (M6-SPEC §3.2): every row carries the
    # SAME at/dmg/area/cd and the pinned feat column — parsed from source.
    body = EVO[EVO.index("const TABLE"):EVO.index("func effect")]
    rows = re.findall(r"\{((?:[^{}]|\n)*?)\}", body)
    assert len(rows) == 9
    for raw in rows:
        for k, v in DOC_BOOSTS.items():
            m = re.search(r"\"%s\": ([-\d.]+)" % k, raw)
            assert m and float(m.group(1)) == v, "%s column drifted" % k
    for base, feats in DOC_FEATS.items():
        m = re.search(r"\"%s\": \{(.*?)\}" % base, body, re.S)
        assert m, base
        f = re.search(r"\"feat\": \[([^\]]*)\]", m.group(1)).group(1)
        assert [x.strip().strip('"') for x in f.split(",") if x.strip()] == feats


def test_table_is_separate_evolved_never_in_meta():
    # DA c3 C-2 + T-M6p R2: the EVOLVED ids must never ride
    # WeaponSystem.META/IDS; the nine live table bases ride IDS; the
    # retired doom-sigil stays OUT of IDS AND out of the live table.
    ids = re.search(r"const IDS := \[((?:[^\]]|\n)*?)\]", WEAPONS).group(1)
    for base, (_, evo) in DOC_TABLE.items():
        assert '"%s"' % evo not in WEAPONS, \
            "evolved id %s must never ride META (DA c3 C-2)" % evo
        assert '"%s"' % base in ids, \
            "table base %s must ride IDS (TABLE is live since T-M1h)" % base
    assert "TABLE" not in WEAPONS
    # R2 keepers (§4.4): the retired id family is OUT of every live table
    # (the pale-moon EXCLUDE pin — the R2 row this card owns).
    assert '"doom-sigil"' not in EVO and '"pale-moon"' not in EVO, \
        "the retired row must be gone from the live evolution table"
    assert '"doom-sigil"' not in ids, "retired pool id must NOT ride IDS"


def test_evo_and_partner_icon_files_exist():
    # The ONE naming convention (icon-<id>.png, §j tree; T-M1c manifest
    # tools/vm100/icons-batch-m1c.tsv) — HUD + cards consume icons through
    # exactly this path, so the table's existence IS the icon pin. The
    # retired family KEEPS its icon files (R8 art-KEEP, PERMANENCE rows).
    for base, (partner, evo) in DOC_TABLE.items():
        evo_icon = os.path.join(GODOT, "assets", "icons", "icon-%s.png" % evo)
        assert os.path.isfile(evo_icon), evo_icon
        p_icon = os.path.join(GODOT, "assets", "icons", "passives",
                              "icon-%s.png" % partner)
        assert os.path.isfile(p_icon), p_icon
    for keep in ("icon-doom-sigil.png", "icon-pale-moon.png"):
        assert os.path.isfile(os.path.join(GODOT, "assets", "icons", keep)), \
            "R8: retired ids KEEP their icon files (no orphan delete)"
    assert os.path.isfile(os.path.join(GODOT, "assets", "icons",
                                       "icon-chest.png"))


# ---- the open site: collect_pickups, the ONE touch funnel -------------------

def test_chest_open_wired_in_collect_pickups():
    # RETIRED+REPLACED by T-M2t (MC 11239), re-pinned at T-M6p (MC 11697):
    # the chest-open site is UNION-ONLY + tier grant (§4.4 R5) — the M1-era
    # evolve line retired HERE (its absence is this row's bite, PS-E3's
    # source twin of the direct-arm dump row).
    collect = DROPS[DROPS.index("func collect_pickups"):] # M6 T-M6d: moved VERBATIM
    assert re.search(r"for i in range\(_world\.chests\.size\(\) - 1, -1, -1\):", collect)
    assert re.search(r"_dist\(c, game\.player\) < 16\.0", collect), \
        "chest touch range must be the same 16 px funnel as the other pickups"
    assert re.search(r"UnionSystem\.try_union\(game\)\s*\n"
                     r"\s*gold \+= ChestRewards\.grant\(game, c\)", collect), \
        "the UNION arm fires at OPEN, then the tier grant rides the ONE site"
    assert "try_evolve" not in collect, "the direct evolve arm is DEAD"
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
    # T-M6p RE-PIN (replace-not-delete): the old "levelup knows nothing
    # about evos" claim is EXACTLY what this card reversed — levelup.gd now
    # OWNS the trigger. What stays frozen: no chest knowledge, and the
    # table stays EvolutionSystem's (levelup never holds its own rows).
    assert "chest" not in LEVELUP.lower()
    assert "const TABLE" not in LEVELUP and '"evo":' not in LEVELUP, \
        "the trigger may only CALL the one table entry, never copy it"


def test_hud_resolves_evolved_ids_via_naming_convention():
    # META stays the 6-weapon table; the HUD falls back to icon-<id>.png.
    assert re.search(r"WeaponSystem\.META\.has\(w\.id\)\s*"
                     r"else \"icon-\" \+ w\.id", HUD)
    assert 'META[w.id].icon \\' in HUD or "META.has" in HUD


def test_pickup_viz_draws_chests():
    assert const("DRAWS", PICKUP) == 6.0 # M6 T-M6d: sigil MM 5->6
    assert re.search(r"_write_items\(_chest, world\.chests", PICKUP)
    assert re.search(r"icon-chest\.png", PICKUP)


# ---- behaviour: the committed dump (sim_evolve.gd) --------------------------

def fixture_rows():
    return conftest.jsonl_rows(FIXTURE)  # MC 11317 C2 seam


def gates():
    return {r["leg"]: r for r in fixture_rows() if "leg" in r}


def test_dump_shape_and_verdict():
    rows = fixture_rows()
    legs = []
    for r in rows:
        if r["ev"] in ("evolution_gate", "evo_all_nine_row"):
            if r["leg"] not in legs:
                legs.append(r["leg"])
        elif r["ev"] in ("evo_one_per_pick", "evo_card_seam",
                         "evo_pool_reachability", "evo_full_second_weapon"):
            legs.append(r["ev"])
        elif r["ev"] == "evo_full":
            legs.append(r["leg"])
    assert legs == ["evo_l5_partner", "evo_l4_partner", "evo_l5_nopartner",
                    "evo_l5_wrong_passive", "evo_partner_any_rank",
                    "evo_non_table_weapon", "evo_all_nine",
                    "evo_one_per_pick", "evo_reserve_below_max",
                    "evo_reserve_at_max", "evo_reserve_lifted",
                    "evo_no_evolve_at_chest", "evo_chest_card_pick_evolves",
                    "evo_card_seam", "evo_pool_reachability",
                    "evo_full_bone-whip", "evo_full_rot-water",
                    "evo_full_second_weapon"], \
        "the level-trigger truth table is the committed row order"
    assert all(r.get("ok", True) for r in rows), "committed dump has a RED leg"
    assert [r for r in rows if r["ev"] == "evolve_verdict"][-1]["ok"] is True


def test_pool_reachability_leg():
    # T-M1h (9 rows since R2): the ONE pool source offers EVERY table base
    # + its partner (the "sim can now acquire both parts" row).
    g = [r for r in fixture_rows() if r["ev"] == "evo_pool_reachability"][0]
    assert g["ok"] is True
    assert g["missing"] == [] and g["all_offered"] is True
    assert g["rows"] == 9, "the pool row counts the live table (9)"


def test_full_evolve_legs():
    # FULL evolutions end-to-end: every entry acquired by REAL _picks; the
    # evolution lands at its TRIGGER PICK chest-free (T-M6p: no chest was
    # ever OPENED when the evolved id first appeared — the chest_free
    # check is the moved trigger's full-leg bite).
    fulls = [r for r in fixture_rows() if r["ev"] == "evo_full"]
    assert [r["leg"] for r in fulls] == ["evo_full_bone-whip",
                                         "evo_full_rot-water"]
    for g in fulls:
        for k in ("evolved_by_pick", "in_slot", "slot_cap", "chest_free"):
            assert g["checks"][k], "%s: %s" % (g["leg"], k)


def test_full_second_weapon_leg():
    # PS-E1's per-pick law end-to-end: one run, TWO table weapons, each
    # evolves at its OWN trigger pick — never both in one pick.
    g = [r for r in fixture_rows() if r["ev"] == "evo_full_second_weapon"][0]
    assert g["ok"] is True
    for k in ("both_evolved", "distinct_picks", "one_per_pick"):
        assert g["checks"][k], k


def test_evolve_leg_with_partner():
    # roadmap ACCEPT verbatim: "evolved id in game.weapons, base removed,
    # slot count unchanged" (+ in-slot, level kept, cd reset — header) —
    # at the level-up PICK now (T-M6p).
    g = gates()["evo_l5_partner"]
    assert any(e.startswith("red-wail-5-0") for e in g["after"])
    assert not any(e.startswith("bone-whip-") for e in g["after"])
    assert any(e.startswith("talon-1-") for e in g["after"]), "2 entries"
    for k in ("trigger_pick_applied", "evolved", "base_gone",
              "slot_count_kept", "in_slot_level_cd"):
        assert g["checks"][k], k
    assert g["at"] == 5, "the level term is the table's at-column (no time gate)"


def test_planted_red_underlevel():
    # PS-E1's RED side: the SAME state one LEVEL short must NOT evolve at
    # the very same trigger pick (an inverted level predicate turns RED).
    g = gates()["evo_l4_partner"]
    assert any(e.startswith("bone-whip-4-") for e in g["after"])
    assert not any(e.startswith("red-wail") for e in g["after"])
    assert g["checks"]["trigger_pick_applied"] is True


def test_negative_rows():
    for leg, base in [("evo_l4_partner", "bone-whip-4"),
                      ("evo_l5_nopartner", "bone-whip-5"),
                      ("evo_l5_wrong_passive", "bone-whip-5"),
                      ("evo_non_table_weapon", "ember-8")]:
        g = gates()[leg]
        assert any(e.startswith(base + "-") for e in g["after"]), leg
        assert not any(e.startswith("red-wail") for e in g["after"]), leg


def test_partner_any_rank_row():
    g = gates()["evo_partner_any_rank"]
    assert any(e.startswith("red-wail-") for e in g["after"]), \
        "any rank of the partner counts (rank 3 pinned)"


def test_all_nine_table_rows_leg():
    # every TABLE row end-to-end through the real funnel (R2: NINE rows —
    # the tenth retired with the doom-sigil pool entry at T-M6d/T-M6p).
    rows = [r for r in fixture_rows() if r["ev"] == "evo_all_nine_row"]
    assert len(rows) == 9
    seen = {}
    for r in rows:
        assert r["ok"] is True, r["base"]
        seen[r["base"]] = r["evo"]
    assert seen == {b: e for b, (_, e) in DOC_TABLE.items()}


def test_one_evolution_per_pick():
    g = [r for r in fixture_rows() if r["ev"] == "evo_one_per_pick"][0]
    assert g["checks"]["first_pick_first_base"] \
        and g["checks"]["second_pick_second_base"]
    assert g["checks"]["one_evolution_per_pick"] and g["checks"]["slots_kept"]
    assert not any(e.startswith("thousand-darts") for e in g["after_1"])
    assert any(e.startswith("thousand-darts") for e in g["after_2"])


# ---- the reserve legs (PS-E4, the EXTENDED window) ---------------------------

def test_reserve_holds_below_max():
    g = gates()["evo_reserve_below_max"]
    for k in ("trigger_pick_applied", "sluice_absent", "rot_water_kept",
              "censer_kept"):
        assert g["checks"][k], k


def test_reserve_holds_at_max():
    # THE REV-1 KILLER CASE: both bases AT MAX + passive carried and a
    # pick BEFORE the chest — the eligible-at-MAX window must hold (the
    # REV-1 below-MAX-only predicate evolves here and forecloses the
    # union forever); the next chest still lands dirge-eternal.
    g = gates()["evo_reserve_at_max"]
    for k in ("sluice_absent_at_pick", "both_bases_survive_pick",
              "dirge_landed_at_chest"):
        assert g["checks"][k], k


def test_reserve_lifts_when_unreachable():
    g = gates()["evo_reserve_lifted"]
    assert g["checks"]["sluice_evolved"] and g["checks"]["in_slot_level_cd"]


# ---- the chest pair (PS-E3): direct arm dead, indirect route honest ---------

def test_no_direct_evolution_at_chest():
    g = gates()["evo_no_evolve_at_chest"]
    for k in ("chest_consumed", "no_direct_evolution", "no_union",
              "reward_card_granted"):
        assert g["checks"][k], k


def test_chest_card_pick_evolves_indirectly():
    # the declared-honest twin (M6-SPEC §3.6 PS-E3): the SAME eligible
    # state evolves when the chest's tier card is PICKED — the level
    # trigger reads chest cards exactly like level cards (one seam).
    g = gates()["evo_chest_card_pick_evolves"]
    for k in ("pending_from_chest", "evolved_via_card_pick", "in_slot",
              "back_to_playing"):
        assert g["checks"][k], k


def test_card_seam_leg():
    # the open pauses through the ONE frozen seam and closes through _pick
    g = [r for r in fixture_rows() if r["ev"] == "evo_card_seam"][0]
    for k in ("chest_opened", "seam_phase_levelup", "offer_nonempty",
              "drained_card_shape", "back_to_playing", "pending_spent",
              "drained_all", "loadout_wellformed"):
        assert g["checks"][k], k


# ---- the acceptance shot (pixel floor lives in tools/chest_pixel_gate.py) ---

def test_shot_asset_exists():
    assert os.path.isfile(SHOT), \
        "assets/screens/m1-chest.png must be committed (gate: chest_pixel_gate)"
