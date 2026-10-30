"""Weapon unions (MC 11240 T-M2u): M2-SPEC rev-2 §D ACCEPT rows, the same
suite convention as test_chests_evolve.py (source-truth .gd reads with
comments stripped + the committed seed-pinned dump of godot/sim/sim_union.gd,
seed 11240, byte-stable; the re-run byte-identity is the sim's job, both
captured in .tmp/m2u-unions.txt).

Stated readings (union.gd + sim_union.gd headers carry the same):
* The ONE rule entry is UnionSystem.try_union at the chest-open site, and
  it holds PRECEDENCE over try_evolve at that site (a chest performs the
  union when eligible, else the evolution — one weapon-transform per
  chest, the evolutions.gd:22-24 reading).
* D-U2 says "union1 GREEN now; union2 flagged until T-M1h-ROSTER" — the
  roster is LIVE (T-M1h, MC 11220), so BOTH recipe bases ride IDS and
  both partners ride PASSIVES: that flag is CLOSED and pinned GREEN.
* Rev-2 P3-6 RESERVE: evolving a union base while its union partner is
  carried below MAX would permanently foreclose the union cross-time
  (rot-water is both an evolution base and a union base), so try_evolve
  skips reserved bases — and ONLY reserved ones (partner gone = the
  reserve lifts; the uni_reserve_lifted row keeps that side honest).
* §D mesh row verbatim: the two union GLBs (T-M2a) are static props and
  the shipped tree has NO in-game weapon-prop consumer (the ten M1c
  weapon meshes are unconsumed too, PERMANENCE.md) — mesh consumption is
  deferred to M3; union behaviour rides the existing effect classes.
* D-U7 seam deviation, stated: a union id NEVER enters a level-up card
  (it is not in the pool — build_pool draws IDS), so the render surface
  is the v1 HUD weapon row (the icon-<id>.png fallback, hud_3d.gd); the
  pixel proof rides the EXISTING chest capture harness (no second tool)
  with a union-HUD shot + the S8 hidden-element baseline.
"""

import functools
import os
import re

import conftest

REPO = conftest.REPO
SCRIPTS = os.path.join(REPO, "godot", "scripts")
GODOT = os.path.join(REPO, "godot")
SIMS = os.path.join(REPO, "godot", "sim")
FIXTURE = os.path.join(REPO, "tests", "fixtures", "unions-m2u.jsonl")
ICONS = os.path.join(GODOT, "assets", "icons")
GLBS = os.path.join(GODOT, "assets", "glb")

# §D.1 recipe table AS WRITTEN (our names, our ids):
DOC_TABLE = {
    "requiem-toll": ("halo", "spike", "insight"),
    "dirge-eternal": ("censer-of-hours", "rot-water", "loadstone"),
}


read = functools.partial(conftest.read_text,
                     code_only=True)  # MC 11317 C2 seam


UNION = read(os.path.join(SCRIPTS, "union.gd"))
EVO = read(os.path.join(SCRIPTS, "evolutions.gd"))
WORLD = read(os.path.join(SCRIPTS, "world.gd"))
WEAPONS = read(os.path.join(SCRIPTS, "weapons.gd"))
LEVELUP = read(os.path.join(SCRIPTS, "levelup.gd"))
SIM_BUDGET = read(os.path.join(SIMS, "sim_budget.gd"))
CAPTURE = read(os.path.join(SIMS, "chest_capture.gd"))
GATE = open(os.path.join(REPO, "tools", "chest_pixel_gate.py"),
            encoding="utf-8").read()


def fixture_rows(ev):
    return conftest.rows_by_ev(FIXTURE, ev)  # MC 11317 C2 seam


# ---- D-U1: the union table is a pytest pin (id, both bases, passive) -------

def test_union_table_rows_match_spec():
    m = re.search(r"const TABLE := \{((?:.|\n)*?)\n\}", UNION)
    assert m, "union.gd must carry the ONE TABLE"
    body = m.group(1)
    table = {}
    for uid, a, b, p in re.findall(
            r"\"([a-z-]+)\": \{\"a\": \"([a-z-]+)\", \"b\": \"([a-z-]+)\",\s*\""
            r"passive\": \"([a-z-]+)\"\}", body):
        table[uid] = (a, b, p)
    assert table == DOC_TABLE, "the TABLE must be the §D.1 recipe rows verbatim"


def test_bases_are_real_pool_weapons_and_partners_real_passives():
    # D-U2's T-M1h-ROSTER flag CLOSED: BOTH unions' bases ride WeaponSystem
    # .IDS and both partners ride levelup.PASSIVES (the roster card landed;
    # the union table is LIVE, not art-only).
    ids = re.search(r"const IDS := \[((?:[^\]]|\n)*?)\]", WEAPONS).group(1)
    passives = " ".join(l for l in LEVELUP.splitlines() if '"key"' in l)
    for uid, (a, b, p) in DOC_TABLE.items():
        assert '"%s"' % a in ids and '"%s"' % b in ids, \
            "union base %s/%s of %s must ride IDS (roster live)" % (a, b, uid)
        assert '"%s"' % p in passives, \
            "union partner %s of %s must ride PASSIVES" % (p, uid)


def test_union_ids_never_enter_meta_or_ids():
    # DA c3 C-2 mirrored (evolutions.gd:9-17): union ids ride the SEPARATE
    # table — the 16/32 WEAPON_KEYS math of test_card_icons stays true.
    ids = re.search(r"const IDS := \[((?:[^\]]|\n)*?)\]", WEAPONS).group(1)
    meta = re.search(r"const META := \{((?:.|\n)*?)\n\}", WEAPONS).group(1)
    for uid in DOC_TABLE:
        assert '"%s"' % uid not in ids, "union id %s must never ride IDS" % uid
        assert '"%s"' % uid not in meta, \
            "union id %s must never ride META (DA c3 C-2)" % uid
    # ...and the HUD resolves it by the ONE naming convention:
    assert re.search(r"\"icon-\" \+ w\.id", read(
        os.path.join(SCRIPTS, "hud_3d.gd"))), "HUD icon fallback must ride icon-<id>"


# ---- the ONE seam: try_union ELSE try_evolve, at the chest-open site -------

def test_chest_open_precedence_in_source():
    body = re.search(r"for i in range\(_world\.chests\.size\(\) - 1, -1, -1\):"
                     r"((?:.|\n)*?)gold \+= ChestRewards",
                     # M6 T-M6d (MC 11675): the ONE funnel moved to drops.gd
                     read(os.path.join(SCRIPTS, "drops.gd"))).group(1)
    assert re.search(r"if UnionSystem\.try_union\(game\) == \"\":", body)
    assert re.search(r"try_union\(game\) == \"\":\s*\n\s*EvolutionSystem"
                     r"\.try_evolve\(game\)", body), \
        "the union takes the chest ONLY; evolution runs ELSE (one transform)"


def test_gate_is_one_reference_no_second_600():
    # rev-2 P4-7: union.gd REFERENCES EvolutionSystem.GATE_T — it must NOT
    # carry its own 600 literal.
    assert re.search(r"if game\.time < EvolutionSystem\.GATE_T:", UNION)
    assert "600" not in UNION, "no second 600 literal (rev-2 P4-7)"


# ---- the rule entry shape (in-slot, net -1, level 1, cd 0) ------------------

def test_in_slot_write_rule():
    assert re.search(r"game\.weapons\.remove_at\(ia\)", UNION)
    assert re.search(r"game\.weapons\.remove_at\(ib if ib < ia else ib - 1\)",
                     UNION), "both bases must GO (net slot -1, never a 7th)"
    assert re.search(r"game\.weapons\.insert\(slot, \{\"id\": uid, "
                     r"\"level\": 1, \"cd\": 0\.0\}\)", UNION), \
        "the union rides the earlier base's slot, level 1, cd 0"


# ---- D-U5: the reserve rule, both halves, on the source seam ---------------

def test_reserve_rule_is_enforced_by_try_evolve():
    assert re.search(r"UnionSystem\.reserved_for_union\(game, w\.id\)", EVO), \
        "try_evolve must skip a reserved union base (rev-2 P3-6)"
    assert re.search(r"if w\.id == partner and w\.level < "
                     r"WeaponSystem\.MAX_LEVEL:", UNION), \
        "the reserve holds exactly while the partner is carried below MAX"


# ---- §D behaviour: the _fire/_update branches are compositions, no new class

def test_union_branches_reuse_existing_effect_classes():
    for uid in DOC_TABLE:
        assert "\"%s\":" % uid in WEAPONS, "%s needs its orbit branch" % uid
    assert WEAPONS.count("func _update_orbit") == 1, \
        "one shared orbit branch (halo + the two unions), not three twins"
    assert re.search(r"halos\.clear\(\)\n\tfor w in game\.weapons:", WEAPONS), \
        "the ONE halos list is cleared once per step and shared (header)"
    # NO new transient array on the class (the six stay six):
    for arr in ("bolts", "throws", "bursts", "arcs", "rings", "halos"):
        assert re.search(r"^var %s: Array = \[\]" % arr, WEAPONS, re.M)
    assert not re.search(r"^var zones", WEAPONS, re.M), \
        "no zones array (the zones MM stays DEFERRED — T-M1h mapping)"


# ---- the committed dump: every §D ACCEPT leg green, both unions end-to-end --

def test_sim_dump_all_legs_green():
    gates = fixture_rows("union_gate")
    assert gates, "fixture carries no union_gate rows"
    red = [r["leg"] for r in gates if not r["ok"]]
    assert not red, "RED union legs: %s" % red
    verdict = fixture_rows("union_verdict")[-1]
    assert verdict["ok"] is True


def test_both_unions_end_to_end_and_negatives():
    legs = {r["leg"] for r in fixture_rows("union_gate")}
    for uid in DOC_TABLE:
        assert "uni_after_" + uid in legs            # scripted chest, in-slot
        assert "uni_undermax_" + uid in legs          # base MAX-1 -> refusal
        assert "uni_full_" + uid in legs              # real _picks + chest
        assert "uni_fire_" + uid in legs              # kills >= 1, alone
    assert {"uni_no_passive", "uni_wrong_passive", "uni_before_gate",
            "uni_precedence", "uni_reserve_keeps",
            "uni_reserve_lifted"} <= legs, "the §D negatives + seams"


def test_fire_legs_attribute_kills_with_both_branches_live():
    # the §D mapping named: requiem-toll halos+bursts (spec row verbatim);
    # dirge-eternal the ward ring-TICK class + halos (the zones MM stays
    # DEFERRED since T-M1h's declared mapping — stated in weapons.gd).
    by_leg = {r["leg"]: r for r in fixture_rows("union_gate")}
    for uid, key in [("requiem-toll", "bursts_observed"),
                     ("dirge-eternal", "rings_observed")]:
        after = by_leg["uni_fire_" + uid]["after"]
        assert after["kills"] >= 1, "%s alone must kill" % uid
        checks = by_leg["uni_fire_" + uid]["checks"]
        assert checks["kills_attributed"] and checks["composed_branches_live"]


# ---- D-U6: the budget re-check leg MEASURED <= 60 hard ----------------------

def test_budget_recheck_leg_in_sim_budget():
    assert "budget_draws_unions" in SIM_BUDGET, \
        "sim_budget carries the D-U6 re-check leg (its instrument's home)"
    # the pins stay the plan's: planned 40 / hard 60 (spec §7 — no new
    # draw CLASS, so no re-tally; the leg PROVES that on the measured row).
    assert re.search(r"const DRAWS_PLANNED := 40", SIM_BUDGET)
    assert re.search(r"const DRAWS_HARD := 60", SIM_BUDGET)


# ---- D-U7: the HUD pixel leg rides the EXISTING capture + gate --------------

def test_union_hud_pixel_leg_pins():
    assert re.search(r"leg\": \"union_hud\"", CAPTURE) or \
        re.search(r"\"leg\": \"union_hud\"", CAPTURE), \
        "chest_capture carries the union_hud row (no second harness)"
    assert "m2u-union-hud.png" in CAPTURE and "PX_MIN_HUD" in GATE
    assert re.search(r"UNION_LEG = \"union_hud\"", GATE)
    # the asset half of the no-blank guarantee (test_card_icons math is
    # untouched — these two files are NOT in the 32):
    for uid in DOC_TABLE:
        png = os.path.join(ICONS, "icon-%s.png" % uid)
        assert os.path.exists(png) and os.path.getsize(png) > 10000, \
            "icon-%s.png must exist and be a real render" % uid
        glb = os.path.join(GLBS, "weapon-%s.glb" % uid)
        assert os.path.exists(glb), ("§6 mesh row: weapon-%s.glb ships as a "
            "STATIC PROP (no in-game weapon-prop consumer in the tree — M3, "
            "stated)" % uid)


# ---- the T-M1h dependency row (D-U1/D-U2): BOTH bases exist in code today --

def test_roster_dependency_closed_not_prose():
    # spec D.1 marked dirge-eternal "NO / NO ... depends on T-M1h-ROSTER";
    # the roster SHIPPED (346758c, MC 11220) — pin that the dependency is
    # satisfied, so nobody re-flags it from the spec text alone.
    ids = re.search(r"const IDS := \[((?:[^\]]|\n)*?)\]", WEAPONS).group(1)
    assert '"censer-of-hours"' in ids and '"rot-water"' in ids
