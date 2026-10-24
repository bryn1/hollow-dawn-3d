"""CHEST TIERS (MC 11239 T-M2t): M2-SPEC rev-2 §B.3 ACCEPT rows B-T1..B-T5.

Suite convention (test_endless/test_chests_evolve/test_gem_merge header):
source-truth pins over the .gd text + behaviour rows judged from the
committed, seed-pinned dump (godot/sim/sim_chest_tiers.gd, seed 11239,
byte-stable; the re-run byte-identity is the capture's job, the sim_evolve
precedent — both captured in .tmp/m2t-chests.txt). B-T5 is the pixel row:
its gate is tools/chest_pixel_gate.py (the T-M1e mechanism EXTENDED with
per-tier window rows, no second harness; capture
godot/sim/chest_capture.gd — both runs captured in the same file).

Row map (spec row -> evidence here / in the dump):
  B-T1 drop-source table legs   chest_tier_drop (real kill_enemy funnel: boss
       seed-deterministic — the committed dump IS the pinned-seed sequence)
       + the two drop-site source pins + the map source pin.
  B-T2 open grants item_count   chest_grant x3 (pending +N EXACTLY, N 3-card
       offers through the frozen seam, kind-flavoured, gold roll in range
       through the ONE credit_gold funnel).
  B-T3 weighted-pick determinism chest_pick_weights x3 (byte-dumped sequence,
       fixture byte-identity = the determinism leg) + chest_weight_zero x3
       (the zero-width bucket can never be returned — the planted
       `r <= 0` leak turns this RED, capture).
  B-T4 transform-then-cards     chest_precedence (two eligibles + one chest:
       exactly ONE transform — the two-transforms-in-one-chest RED
       instrument — then the FULL item_count cards + gold).
  UNIFIED-TIER (rev-2 P1)       test_unified_tier_ae4_bt1_same_row: the
       A-E4 committed row (endless-m2.jsonl) + the B-T1 dump row + the
       world.gd map source all agree on tier "dawn" for cycle-clear — the
       DA-P1 law stays true in ONE pytest row reading all three sources.
  B-T2 filter flavour (deterministic twin of the drain rows)
       chest_filter_probe x3 — DA-C1 fix leg (see below).
  B-T5 per-tier pixel floors    the two shot assets + the gate's per-row
       floor + the capture's dawn stage pins below; pixels proven by the
       gate run in the capture.

Replace-not-delete ledger (rows this card REPLACED, none deleted):
  DA-C1 verify-loop finding (same card, fixed here): the flavour source pin
  could be satisfied by apply_offer's own "weapon" arm (vacuous alternative)
  and the seed's drain offers could cover a removed filter — REPLACED by
  body-scoped arm pins + the chest_filter_probe dump legs (fresh RED proof:
  arm rename now REDs both layers, capture).
  tests/test_chests_evolve.py::test_chest_open_wired_in_collect_pickups —
  the M1e "+1 card" wiring pin -> the transform-first + ChestRewards.grant
  pin (the claim "the open runs the ONE funnel" is unchanged, the wiring it
  pinned is the shipped tier grant); sim_evolve.gd reward_card/pending_raised/
  pending_spent legs -> item_count truth (a claim that would pin the OLD
  count is a falsified row, per the T-M1e "replaced falsified rows"
  discipline). No leg was removed.
"""

import json
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
SIMS = os.path.join(conftest.REPO, "godot", "sim")
FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures",
                       "chests-tiers-m2.jsonl")
ENDLESS_FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures",
                               "endless-m2.jsonl")
ICONS = os.path.join(conftest.REPO, "godot", "assets", "icons")
SHOT_II = os.path.join(conftest.REPO, "assets", "screens", "m1-chest.png")
SHOT_III = os.path.join(conftest.REPO, "assets", "screens", "m2-chest-dawn.png")
GATE = os.path.join(conftest.REPO, "tools", "chest_pixel_gate.py")
CAPTURE = os.path.join(SIMS, "chest_capture.gd")


def read(name):
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return "".join(line.split("#")[0] + "\n" for line in fh.read().splitlines())


def read_raw(path):
    with open(path, encoding="utf-8") as fh:
        return fh.read()


def read_sim(name):
    return read_raw(os.path.join(SIMS, name))


REWARDS = read("chest_rewards.gd")
WORLD = read("world.gd")
GAME_STATE = read("game_state.gd")
LEVELUP = read("levelup.gd")
MAIN = read("main.gd")
PICKUP = read("pickup_viz.gd")

# §B.1 tier table — OUR numbers (the spec table IS law; weights sum 100/tier)
SPEC_TABLE = {
    "ember": {"item_count": 1, "weapon": 50, "passive": 30, "gold": 20,
              "gold_lo": 5, "gold_hi": 15},
    "warden": {"item_count": 2, "weapon": 40, "passive": 40, "gold": 20,
               "gold_lo": 15, "gold_hi": 40},
    "dawn": {"item_count": 3, "weapon": 35, "passive": 45, "gold": 20,
             "gold_lo": 40, "gold_hi": 90},
}
SPEC_MAP = {"miniboss": "ember", "warden": "warden",
            "endless-cycle": "dawn", "event": "dawn"}


def rows_of(ev, fixture=FIXTURE):
    out = []
    with open(fixture, encoding="utf-8") as fh:
        for line in fh:
            if line.strip():
                r = json.loads(line)
                if r.get("ev") == ev:
                    out.append(r)
    return out


# ---- the tier table, from the source, as the spec wrote it -------------------

def test_tier_table_matches_spec_b1_exactly():
    m = re.search(r"const TIERS := \{([\s\S]*?)\n\}", REWARDS)
    assert m, "TIERS table missing from chest_rewards.gd"
    table = {}
    for tier, ic, w, p, g, lo, hi in re.findall(
            r'"([a-z]+)": \{"item_count": (\d+), "weapon": (\d+), '
            r'"passive": (\d+), "gold": (\d+),\s*"gold_lo": (\d+), '
            r'"gold_hi": (\d+)\}', m.group(1)):
        table[tier] = {"item_count": int(ic), "weapon": int(w),
                       "passive": int(p), "gold": int(g),
                       "gold_lo": int(lo), "gold_hi": int(hi)}
    assert table == SPEC_TABLE
    for row in table.values():  # weights are percentages: they sum 100
        assert row["weapon"] + row["passive"] + row["gold"] == 100


# ---- B-T1: the map + the drop sites stamp it (source truth) ------------------

def test_source_tier_map_is_the_single_source():
    m = re.search(r'const CHEST_TIER_BY_SOURCE := \{([\s\S]*?)\}', WORLD)
    assert m
    entries = dict(re.findall(r'"([a-z-]+)": "([a-z]+)"', m.group(1)))
    assert entries == SPEC_MAP


def test_drop_sites_stamp_tier_from_the_map():
    # boss + miniboss sites read CHEST_TIER_BY_SOURCE (no literals: the
    # map-bypass planted-red breaks exactly these regexes)
    assert re.search(r'"tier": CHEST_TIER_BY_SOURCE\["warden"\]', WORLD)
    assert re.search(r'"tier": CHEST_TIER_BY_SOURCE\["miniboss"\]', WORLD)
    # the cycle-clear site (T-M2e) stays on the map too (A-E4 byte-pin too)
    assert re.search(r'"tier": CHEST_TIER_BY_SOURCE\["endless-cycle"\]',
                     WORLD)


def test_open_runs_transform_then_grant_in_the_one_funnel():
    assert re.search(r"EvolutionSystem\.try_evolve\(game\)\s*\n\s*gold \+="
                     r" ChestRewards\.grant\(game, c\)", WORLD)
    # the grant module itself: strict tier key (unknown tier crashes, never
    # de-tiers), cards raise pending, roll returns raw for the credit funnel
    assert re.search(r'TIERS\[String\(chest\["tier"\]\)\]', REWARDS)
    assert re.search(r"game\.pending_levels \+= int\(row\[\"item_count\"\]\)",
                     REWARDS)
    assert re.search(r'return lo \+ randi\(\) % \(int\(row\["gold_hi"\]\) '
                     r'- lo \+ 1\)', REWARDS)


# ---- the seam extended for tier reward kinds (B.2 "rides the frozen seam") ---

def test_seam_extension_frozen_shapes_kept():
    # make_offer grows a kind param; the "" default is the untouched pool
    assert re.search(r'static func make_offer\(game: GameState, '
                     r'kind := ""\) -> Array:', LEVELUP)
    # (DA-C1 fix) the match arms are pinned INSIDE make_offer's body: the
    # old "or 'weapon': anywhere" shape was vacuous (apply_offer carries the
    # same word); renaming the filter arm no longer survives this row
    mo = LEVELUP.split("static func make_offer")[1].split("static func ")[0]
    assert re.search(r'"weapon":\s*\n\s*pool = pool\.filter\(func\(c\): '
                     r'return c\.kind == "weapon" or c\.kind == "upgrade"\)', mo)
    assert re.search(r'"passive":\s*\n\s*pool = pool\.filter\(func\(c\): '
                     r'return c\.kind == "passive"\)', mo)
    assert re.search(r'"gold":\s*\n\s*pool = \[\]', mo)  # bonus fill IS it
    assert "pool[i] if i < pool.size() else bonus_card()" in LEVELUP
    # main routes BOTH offer sites through one popper; the queue lives on
    # GameState, reset in start_run, OUTSIDE the 12-field snapshot
    assert MAIN.count("_current_offer = _next_offer()") == 2
    assert re.search(r"game\.reward_kinds\.pop_front\(\)", MAIN)
    assert re.search(r"var reward_kinds: Array = \[\]", GAME_STATE)
    sr = GAME_STATE.split("func start_run()")[1].split("func ")[0]
    assert "reward_kinds = []" in sr
    snap = GAME_STATE.split("func snapshot_json")[1]
    assert "reward" not in snap
    # the no-chest-word / frozen-enum shape pins (also held by
    # test_chests_evolve, same comment-stripped view it uses — the one
    # baseline "chest" in main.gd is a comment naming this very pin)
    assert "chest" not in MAIN.lower()
    assert "chest" not in LEVELUP.lower()


# ---- B-T1/B-T2/B-T3/B-T4 behaviour rows from the committed dump -------------

def test_bt1_drop_funnel_rows_and_planted_red_instruments():
    r = rows_of("chest_tier_drop")[0]
    assert r["ok"] and all(r["checks"].values())
    assert r["map"] == SPEC_MAP
    assert r["boss_tier"] == "warden" and r["mb_tiers"] == ["ember"]
    assert 0 < r["mb_chests"] < r["mb_kills"]  # the pinned 0.6 roll shape
    assert r["cycle_tier"] == "dawn"


def test_bt2_grant_rows_per_tier():
    grants = {g["tier"]: g for g in rows_of("chest_grant")}
    assert set(grants) == {"ember", "warden", "dawn"}
    for tier, g in grants.items():
        row = SPEC_TABLE[tier]
        assert g["ok"], tier
        assert g["pending_open"] == g["pending0"] + row["item_count"]
        assert len(g["kinds"]) == row["item_count"]
        assert len(g["offers"]) == row["item_count"]
        assert all(len(o) == 3 for o in g["offers"])
        assert row["gold_lo"] <= g["gold_delta"] <= row["gold_hi"]
        # a gold pick's offer is the untouched bonus_card fill; a weapon pick
        # never draws passives; a passive pick never draws weapons
        for kind, cards in zip(g["kinds"], g["offers"]):
            allowed = {"weapon": {"weapon", "upgrade", "bonus"},
                       "passive": {"passive", "bonus"},
                       "gold": {"bonus"}}[kind]
            assert set(cards) <= allowed, (tier, kind, cards)


def test_bt2_filter_probe_legs_deterministic():
    # DA-C1: 60 direct make_offer calls per kind — while the kind filters
    # exist a wrong-flavour card is IMPOSSIBLE; once any is removed the
    # full pool makes it CERTAIN within the sample (fresh RED proof in the
    # capture: renaming the weapon arm turns these rows ok=false)
    probes = {r["kind"]: r for r in rows_of("chest_filter_probe")}
    assert set(probes) == {"weapon", "passive", "gold"}
    for r in probes.values():
        assert r["ok"] and r["wrong_cards_180"] == 0


def test_bt3_pick_sequence_and_weight_zero_legs():
    picks = {p["tier"]: p for p in rows_of("chest_pick_weights")}
    assert set(picks) == {"ember", "warden", "dawn"}
    for tier, p in picks.items():
        assert p["ok"] and sum(p["counts"].values()) == 240
        assert all(p["counts"][k] > 0 for k in ("weapon", "passive", "gold"))
    zeros = rows_of("chest_weight_zero")
    assert len(zeros) == 3 and all(z["checks"]["never_picked"] for z in zeros)
    assert sorted(z["kind"] for z in zeros) == ["gold", "passive", "weapon"]


def test_bt4_precedence_row():
    r = rows_of("chest_precedence")[0]
    assert r["ok"] and all(r["checks"].values())
    assert len(r["evolved"]) == 1  # two eligibles, ONE chest -> ONE transform
    assert r["pending"] == SPEC_TABLE["warden"]["item_count"]  # cards full


def test_dump_verdict_green():
    v = rows_of("chest_tiers_verdict")[0]
    # 14 evidence rows precede the verdict (drop 1 + grant 3 + weights 3 +
    # zero-instruments 3 + filter-probes 3 + precedence 1); file = 15 lines
    assert v["ok"] is True and v["rows"] == 14


# ---- the UNIFIED-TIER law (rev-2 P1): A-E4 and B-T1 read ONE map row --------

def test_unified_tier_ae4_bt1_same_row():
    ae4 = rows_of("endless_cycle_clear_reward", ENDLESS_FIXTURE)[0]
    bt1 = rows_of("chest_tier_drop")[0]
    src = re.search(r'"endless-cycle": "([a-z]+)"', WORLD).group(1)
    assert ae4["tier"] == "dawn" and ae4["checks"]["tier_is_map_row"]
    assert bt1["cycle_tier"] == "dawn" and bt1["checks"]["unified_ok"]
    assert src == "dawn"
    # A-E4's own card-count claim (the clear's +1 reward card) is UNTOUCHED
    # by the tier grant — the chest's cards ride the open, not the clear
    assert ae4["pending_after"] - ae4["pending_before"] == 1
    assert ae4["map_row"] == "endless-cycle -> dawn"


# ---- B-T5: per-tier pixel floors (gate + capture + assets pinned here) ------

def test_bt5_shots_exist_per_tier():
    assert os.path.isfile(SHOT_II), \
        "tier-II (warden) chest shot must be committed (boss drop carries " \
        "its map tier since T-M2t: m1-chest.png IS the tier-II render)"
    assert os.path.isfile(SHOT_III), "tier-III (dawn) chest shot missing"


def test_bt5_gate_is_per_tier_with_200_floor():
    g = read_raw(GATE)
    assert re.search(r"PX_MIN = 200", g)
    assert "for row in shots" in g, "the gate loops per chest_shot row"
    assert 'row["win"]' in g, "per-tier windows"
    assert 'row["baseline"]' in g, "each tier rows against its own baseline"
    cap = read_sim("chest_capture.gd")
    assert "cycle_clear" in cap, "tier III rides the REAL dawn drop funnel"
    assert "m2-chest-dawn.png" in cap
    assert "chest_shot" in cap


# ---- the viz law: per-instance scale/tint on the ONE chest MM ---------------

def test_tier_viz_scale_tint_no_new_mm_class():
    assert re.search(r'const CHEST_TIER_SCALE := \{"ember": 1\.0, '
                     r'"warden": 1\.35, "dawn": 1\.7\}', PICKUP)
    # the chest slot moved to the color-instance format (the §C.1 mechanism,
    # reused) — ONE MultiMesh class, DRAWS stays 5
    assert re.search(r'_mm\(_quad\(\), _icon_mat\(CHEST_TIER_ICON\["ember"\]\), true\)',
                     PICKUP)
    assert re.search(r"const DRAWS := 5", PICKUP)
    assert PICKUP.count("MultiMesh.new()") == 1  # the ONE mm factory
    # the tier icons ride the ONE icon-<id>.png convention (the §6 M2a batch;
    # their pixels reach the frame as the alpha-weighted mean tint)
    for png in ("icon-chest.png", "icon-chest-warden.png", "icon-chest-dawn.png"):
        assert os.path.isfile(os.path.join(ICONS, png)), png
    for tier, path in re.findall(r'"(ember|warden|dawn)": "res://assets/'
                                 r'icons/(icon-chest[a-z-]*\.png)"', PICKUP):
        assert os.path.isfile(os.path.join(ICONS, path)), path
    assert re.search(r"_write_items\(_chest, world\.chests, basis, "
                     r"CHEST_PX, CHEST_PX, 0\.0, true\)", PICKUP)
