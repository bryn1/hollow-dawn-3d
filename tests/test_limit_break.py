"""LIMIT-BREAK-LITE (MC 11365 T-M4l): M4-SPEC rev-3 §3.3 ACCEPT rows
C-E1..C-E4.

Source-truth pins over the .gd text + behaviour rows judged from the
committed, seed-pinned dump (godot/sim/sim_limit.gd, seed 11365 = the card
id, byte-stable; re-run byte-identity is the capture's job — the sim_reaper/
sim_events precedent). Screens stay OUT of this card's file set: the limit
rows ride the shipped icon_path() `_:` catch-all with INLINE icon names of
EXISTING files (P3-5), so `screens.gd` and `test_card_icons.py` carry ZERO
diff (git-diff proof in the capture) and the PASSIVES/PASSIVE_ICONS key-set
pins are green UNTOUCHED.

Row map (spec row -> evidence here / in the dump):
  C-E1 all-maxed offers   limit_all_maxed: the §2 loadout (sim_budget's own
       arrays) ⇒ build_pool EMPTY; 100 real offers = 300 kind-"limit" rows,
       ZERO bonus; three inline icon names resolve in-leg through the
       `_:` catch-all; half picked through the real _pick seam, counters
       match. Planted REDs: fallback removed -> offers come back kind
       "bonus" -> all_limit/never_bonus RED; a bad icon name -> the
       in-code assert fires IN-LEG (capture instrument).
  C-E2 near-cap STAYS     limit_near_cap: 5 slots + 5 kinds -> pool
       NON-empty -> zero limit rows; sim_caps' committed legs stay green
       (byte corpus + test_levelup_caps.py). Planted: fallback on a
       non-empty pool -> zero_limit RED.
  C-E3 stat math          limit_math: the three formula rows + the
       zero-picks twin at the shipped byte values; a planted 0.05 fury
       coefficient reddens fury_math.
  C-E4 gold/tier law      limit_gold_law: on the EXHAUSTED state, kind
       "gold" still hands the untouched bonus fill and no limit row
       enters a kinded offer; the committed bonus rows
       (chests-tiers-m2/chests-evolve-m1e) + the test_chests_tiers
       allowed sets ride UNTOUCHED files (byte corpus + suite).
  state law               limit_snapshot: Contract B stays the frozen
       exact-12, "limit" ABSENT (the B-E5 instrument shape).
"""

import functools
import os
import re

import conftest

REPO = conftest.REPO
FIXTURE = os.path.join(REPO, "tests", "fixtures", "limit-m4.jsonl")
CAPS_FIXTURE = os.path.join(REPO, "tests", "fixtures", "carry-caps-m1b.jsonl")
read = functools.partial(conftest.read_script, code_only=True)
LEVELUP = read("levelup.gd")
GAME_STATE = read("game_state.gd")
SCREENS_RAW = conftest.read_script("screens.gd")  # raw: the catch-all comment


def leg(ev):
    rows = [r for r in conftest.jsonl_rows(FIXTURE) if r["ev"] == ev]
    assert len(rows) == 1, "limit-m4 fixture must carry exactly one %r" % ev
    row = rows[0]
    assert row["ok"], "%s leg red: %s" % (ev, row["checks"])
    return row


# ---- C-E1: the fallback table + the funnel seam (source pins) ----------------

def test_c_e1_limit_rows_verbatim_and_separate_const():
    # OUR table (spec §3.1): three repeatable rows; the icons are INLINE
    # names of EXISTING shipped files (P3-5); LIMIT_CARDS is a SEPARATE
    # const so the PASSIVES key-set pins cannot read these rows.
    for key, name, desc, icon in [
            ("dmg", "LIMIT · FURY", "+4% weapon damage", "icon-cleaver"),
            ("spd", "LIMIT · HASTE", "+3% move speed", "icon-dart-loop"),
            ("arm", "LIMIT · BULWARK", "-1 damage taken", "icon-plate")]:
        m = re.search(r'\{"kind": "limit", "key": "%s", "name": "%s",\s*'
                      r'"desc": "%s", "icon": "%s"\}' % (key, re.escape(name),
                      re.escape(desc), icon), LEVELUP)
        assert m, "LIMIT_CARDS row %s not verbatim" % key
        path = os.path.join(REPO, "godot", "assets", "icons", icon + ".png")
        assert os.path.isfile(path) and os.path.getsize(path) > 0, path
    block = re.search(r"const LIMIT_CARDS := \[(.*?)\]\n", LEVELUP, re.S)
    assert block and len(re.findall(r'"kind": "limit"', block.group(1))) == 3
    # separate-const law: the PASSIVES block stays the 15-kind pool table
    pblock = re.search(r"const PASSIVES := \[(.*?)\]\n", LEVELUP, re.S)
    assert "limit" not in pblock.group(1)
    assert len(re.findall(r'"key":\s*"([\w-]+)"', pblock.group(1))) == 15


def test_c_e1_fill_gated_on_unkinded_empty_pool():
    mo = LEVELUP.split("static func make_offer")[1].split("static func ")[0]
    m = re.search(r'if kind == "" and pool\.is_empty\(\):\s*\n'
                  r"\s*pool = LIMIT_CARDS\.duplicate\(\)", mo)
    assert m, "the fallback is the gated make_offer fill (spec §3.1)"
    # gated AFTER the kind match (the tier/gold arms run first, unchanged)
    assert mo.index('"gold":') < m.start(), "the fill must sit after the match"
    # the shipped fill line stays the ONLY other fallback (bonus_card)
    assert "pool[i] if i < pool.size() else bonus_card()" in mo


def test_c_e1_apply_branch_before_bonus_fallthrough():
    # the "limit" arm bumps the counter; the `_:` gold/hp bonus stays LAST
    # (code_only view: the arm's comment rows are stripped, the shape is not)
    m = re.search(r'"limit":\s*\n\s*game\.limit\[card\.key\] \+= 1\s*\n'
                  r'\t*_:', LEVELUP)
    assert m, "apply_offer gains the limit arm before the bonus fallthrough"


def test_c_e1_all_maxed_leg():
    row = leg("limit_all_maxed")
    c = row["checks"]
    assert c["pool_exhausted"], "the §2 loadout must BE the exhaustion state"
    assert c["all_limit"], "every subsequent offer is 3 LIMIT cards"
    assert c["never_bonus"], "the OFFER never contains bonus in that state"
    assert c["three_icons"], "offer rows carry the three inline icon names"
    assert c["icons_resolve"], "the icon_path() `_:` catch-all resolved them"
    assert c["counters_match"] and c["pool_stays_empty"]
    assert row["icons"] == ["icon-cleaver", "icon-dart-loop", "icon-plate"]
    assert row["kind_counts"] == {"limit": 300}
    lim = row["limit"]
    assert lim["dmg"] + lim["spd"] + lim["arm"] == row["picked"] == 50


# ---- P3-5: screens LEAVES this card's file set (STAY pins) --------------------

def test_p3_5_no_new_resolver_leg():
    # NO LIMIT_ICONS beside the dead mapping the audit named; the `_:`
    # catch-all is the ONE route (its shape pinned as shipped).
    assert "LIMIT_ICONS" not in SCREENS_RAW
    assert re.search(r'_:\s*\n\s*var path: String = "res://assets/icons/'
                     r'%s\.png" % card\.icon\s*\n\s*assert\(ResourceLoader'
                     r"\.exists\(path\)\)", SCREENS_RAW), \
        "the `_:` catch-all (assert-per-file) must stay the shipped shape"


# ---- C-E2: near-cap stays pool-only -------------------------------------------

def test_c_e2_near_cap_leg():
    row = leg("limit_near_cap")
    c = row["checks"]
    assert c["pool_nonempty"] and c["zero_limit"] and c["pool_offers_present"]
    assert row["limit_rows"] == 0 and row["pool_rows"] == 300


def test_c_e2_caps_stay_probe():
    # The committed caps fixture (its own channel's byte identity is the
    # capture's job) carries no fallback-era rows: ZERO bonus and ZERO
    # limit rows — the grep proof of §3.1, kept executable.
    with open(CAPS_FIXTURE, encoding="utf-8") as fh:
        blob = fh.read()
    assert '"bonus"' not in blob
    assert '"limit"' not in blob


# ---- C-E3: stat math -----------------------------------------------------------

def test_c_e3_math_leg():
    row = leg("limit_math")
    c = row["checks"]
    assert c["fury_math"] and c["haste_math"] and c["bulwark_math"]
    assert c["clamped_ge_zero"] and c["counters"] and c["zero_bytes_exact"]
    # independent Python recompute of the C-E3 formula rows, IEEE order
    p = row["pins"]
    assert abs(row["dmg_mult"] - (1 + 0.1 * p["ferocity"] + 0.08 * p["gall_vial"]
                                  + 0.04 * p["k_fury"])) < 1e-12
    assert abs(row["speed"] - (140.0 * (1 + 0.08 * p["haste"])
                               * (1 + 0.03 * p["m_haste"]))) < 1e-12
    assert abs(row["intake_10"] - (10.0 - p["ward"] - p["rotten_plate"]
                                   - 1.0 * p["n_bulwark"])) < 1e-12
    assert row["intake_0p5"] == 0.0  # clamped >= 0 — Bulwark never heals
    # zero-picks twin: the SHIPPED byte values, exactly
    assert row["mult_0"] == 1.0 and row["speed_0"] == 140.0 \
        and row["intake_0"] == 37.0
    assert row["limit"] == {"dmg": 2, "spd": 3, "arm": 2}


def test_c_e3_three_additive_seams():
    # the three seams, ONE term each, additive zero-identity (T-M1h shape)
    assert re.search(r"return BASE_SPEED \* \(1\.0 \+ 0\.08 \* passives\.haste\)"
                     r" \* \(1\.0 \+ 0\.03 \* limit\.spd\)", GAME_STATE)
    assert re.search(r"return maxf\(0\.0, raw - passives\.ward\s*\n"
                     r"\s*- float\(passives\[\"rotten-plate\"\]\) "
                     r"- 1\.0 \* limit\.arm\)", GAME_STATE)
    assert re.search(r"return 1\.0 \+ 0\.1 \* passives\.ferocity "
                     r"\+ 0\.08 \* float\(passives\[\"gall-vial\"\]\) "
                     r"\\\s*\n\s*\+ 0\.04 \* limit\.dmg", GAME_STATE)


def test_c_e3_state_row_reset_outside_snapshot():
    assert re.search(r'var limit := \{"dmg": 0, "spd": 0, "arm": 0\}',
                     GAME_STATE)
    sr = GAME_STATE.split("func start_run()")[1].split("func ")[0]
    assert 'limit = {"dmg": 0, "spd": 0, "arm": 0}' in sr, \
        "start_run() resets the counter row (the fresh-run law)"
    snap = GAME_STATE.split("func snapshot_json")[1]
    assert "limit" not in snap, "the frozen 12-field snapshot never gains it"


# ---- C-E4: the gold/tier law ---------------------------------------------------

def test_c_e4_gold_law_leg():
    row = leg("limit_gold_law")
    c = row["checks"]
    assert c["gold_bonus_fill"], "kind \"gold\" still yields the untouched " \
        "bonus fill — the ONE gold mechanism (C-E4)"
    assert c["no_limit_in_kind_offers"], "no limit row enters a kinded offer"
    assert row["offers"]["gold"] == ["bonus", "bonus", "bonus"]


def test_c_e4_committed_bonus_rows_stay_probe():
    # The two committed bonus rows (§3.1's living RED probe pair) exist in
    # their fixtures; their byte identity + the allowed-set rows
    # (test_chests_tiers.py) ride UNTOUCHED files — capture + suite halves.
    tiers = os.path.join(REPO, "tests", "fixtures", "chests-tiers-m2.jsonl")
    evolve = os.path.join(REPO, "tests", "fixtures", "chests-evolve-m1e.jsonl")
    assert any("bonus" in str(r.get("offers", ""))
               for r in conftest.jsonl_rows(tiers)), "chests-tiers bonus row gone"
    assert any("bonus_card" in str(r.get("note", ""))
               for r in conftest.jsonl_rows(evolve)), "chests-evolve bonus note gone"


# ---- state law: Contract B stays the frozen twelve ------------------------------

def test_snapshot_exact_12_limit_absent():
    row = leg("limit_snapshot")
    assert row["checks"]["exact_12"], "Contract B is the frozen 12 (F-3)"
    assert row["checks"]["limit_absent"], "a 13th snapshot field named limit " \
        "IS the planted RED; the counter row lives outside snapshot_json"


# ---- R7: the s8 A7 doc-sync row (replace-not-delete, same commit) ---------------

def test_r7_a7_text_names_the_fallbacks_beside_32():
    src = open(os.path.join(REPO, "tools", "s8_acceptance.py"),
               encoding="utf-8").read()
    assert "all 32 pool kinds (16 weapons + 15 passives + 1 bonus)" in src, \
        "the 32-pool-kind claim STAYS (replace-not-delete, not delete)"
    assert "NOT pool kinds" in src and "LIMIT" in src, \
        "the R7 row must name the three fallback offers beside the 32"


# ---- verdict row -----------------------------------------------------------------

def test_fixture_verdict_green():
    rows = conftest.jsonl_rows(FIXTURE)
    v = [r for r in rows if r["ev"] == "limit_verdict"]
    assert len(v) == 1 and v[0]["ok"], "the channel verdict row must be ok"
    assert v[0]["rows"] == len(rows) - 1 == 5
