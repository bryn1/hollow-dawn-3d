# test_sigil_drop.py — M6 (MC 11675, T-M6d): the RIVEN SIGIL + the coin
# magnet, acceptance legs SD-E1..SD-E6 per docs/M6-SPEC.md §4.3 / §5.3 / §6.
#
# The DOOM SIGIL retired WEAPON-SIDE (§4.1: offer-stream retirement, icons
# KEEPT); the RIVEN SIGIL is the rare COUNTER-DROP that replaces its fantasy:
# every 750th non-boss kill (dedicated counter, zero RNG) drops one sigil;
# ONE touch clears every NON-named enemy (owner carve 2026-10-29 "2. Rec.":
# bosses + MINIBOSSES + the REAPER SURVIVE); pickup rides the F5 magnet seam
# (sigils themselves are NEVER magnetised). Coins joined the ONE magnet
# source this card (220 px/s shipped pull, grip/loadstone ride it).
#
# Instrument honesty (replace-not-delete law): every re-pinned sibling file
# carries its own RETIRED+REPLACED note; the runtime observability of the
# counter/clear/magnet lives in the sim legs (godot/sim/sim_combat.gd, rows
# sigil_drops / sigil_tapfree / sigil_clear / magnet_coins — their ok flags
# gate the journey exit in sim_headless._run_sigil); THIS file pins the
# SOURCE truths + the offer-stream bytes + the deviation-doc contract that
# the sim cannot express.
import functools
import os
import re

import conftest

read = conftest.read_script  # MC 11317 C2 seam (raw script text)
read_code = functools.partial(read, code_only=True)

REPO = conftest.REPO
FIXTURES = os.path.join(REPO, "tests", "fixtures")
WORLD = read("world.gd")
DROPS = read("drops.gd")
DROPS_CODE = read_code("drops.gd")
WEAPONS = read("weapons.gd")
WEAPONS_CODE = read_code("weapons.gd")
PICKUP = read("pickup_viz.gd")
DEVIATION_DOC = os.path.join(REPO, "docs", "BYTE-DEVIATION-M6.md")
CARRY_CAPS = os.path.join(FIXTURES, "carry-caps-m1b.jsonl")


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


# ---- SD-E1: the retirement is OBSERVABLE in the offer stream ------------------

def test_sigil_retired_from_pool_source():
    # weapons.gd: IDS/META are 15; the id is GONE from the code (the retire
    # COMMENT mentioning it is provenance, not a live site — the code-only
    # read is the honest universe here, same law as the F3-1 re-derive).
    ids = re.search(r"const IDS := \[((?:[^\]]|\n)*?)\]", WEAPONS_CODE).group(1)
    assert len([s for s in ids.split(",")]) == 15
    assert "doom-sigil" not in ids
    assert '"doom-sigil"' not in WEAPONS_CODE, "no live META row / no _fire arm"
    assert 'case "doom-sigil"' not in WEAPONS_CODE
    assert const("SIGIL_EVERY_KILLS", DROPS) == 750.0


def test_sigil_retired_from_offer_bytes():
    # The REMINTTED carry-caps fixture: the offer stream never names the
    # retired id again (SD-E1's byte half; 64 rows carried it pre-T-M6d).
    rows = conftest.rows_by_ev(CARRY_CAPS, "caps_offer")
    assert rows, "fixture must carry offer rows"
    for r in rows:
        for card in r["cards"]:
            assert card["id"] != "doom-sigil", r
    # and the sim leg universe: sim_combat.gd SPECS is 15 legs (the journey
    # all_weapons_killed row pins legs:15 — re-minted byte corpus).
    sim = _code_of(os.path.join("godot", "sim", "sim_combat.gd"))
    # (?:[^\]]|\n)*? STOPPED AT THE FIRST ENTRY'S CLOSER — the SPECS
    # const's own end is the line-initial "]"; slice to it (the vacuous
    # 1==15 near-miss, caught by the REMINTED fixture at battery time).
    specs = re.search(r"const SPECS := \[(.*?)\n\]", sim, re.S).group(1)
    assert specs.count("[") == 15
    assert "doom-sigil" not in specs


# ---- SD-E2: the counter is dedicated, zero-RNG, EXACT (source half) ----------

def _code_of(rel):
    # The ONE line-comment law, same reading conftest.read_script(code_only=
    # True) applies to godot/scripts — extended here to sim/test/tool files so
    # a PROVENANCE note naming the retired id never counts as a live site.
    text = open(os.path.join(REPO, rel), encoding="utf-8").read()
    return "\n".join(ln.split("#", 1)[0] for ln in text.splitlines())


def test_sigil_counter_is_dedicated_zero_rng():
    # The counter rides the ONE kill funnel AFTER the reaper guard (never a
    # game.kills read — game.kills counts the reaper too), excludes boss AND
    # miniboss (the REV-4 §4.2 ONE ruling), and emits on modulo ONLY: a
    # planted randf() tap forks the sim's tapfree twin (sigil_tapfree leg).
    roll = DROPS_CODE[DROPS_CODE.index("func roll"):]
    reaper_i = roll.index("reaper")
    guard_i = roll.index("return")
    assert reaper_i < guard_i < roll.index("sigil_kills += 1"), \
        "the sigil counter must sit AFTER the reaper death-guard"
    m = re.search(r"if not enemy\.boss and not enemy\.miniboss:\s*\n"
                  r"\s*sigil_kills \+= 1\s*\n"
                  r"\s*if sigil_kills % SIGIL_EVERY_KILLS == 0:\s*\n"
                  "\\s*sigils\\.append\\(\\{\"x\": enemy\\.x, "
                  "\"y\": enemy\\.y\\}\\)",
                  roll)
    assert m, "dedicated counter + modulo-only emit at the kill location"
    emit = m.group(0)
    assert "randf" not in emit and "randi" not in emit, "zero RNG on the seam"


# ---- SD-E3: the ONE carve, in code, ONE predicate (source half) --------------

def test_clear_carve_is_the_one_predicate():
    # owners ruling 2026-10-29 "2. Rec." (REV-4 §4.2): bosses + minibosses +
    # the reaper survive the clear — the SAME predicate the counter excludes
    # (NF-5: one carve law, not two drifting lists). Drop any term and the
    # sim sigil_clear twin goes RED (named_three_survive_untouched).
    collect = DROPS_CODE[DROPS_CODE.index("func collect_pickups"):]
    m = re.search(r"for e in _world\.enemies\.duplicate\(\):\s*\n"
                  r"\s*if not e\.boss and not e\.miniboss and "
                  "not e\\.get\\(\"reaper\", false\\):", collect)
    assert m, "the clear spares exactly boss+miniboss+reaper — ONE predicate"
    # kills ride the ONE funnel (the screen-clear is not a second kill path)
    assert re.search(r"_world\.kill_enemy\(game, e\)", collect)
    # ONE touch = ONE clear: the sigil is consumed at the moment of the tap
    assert re.search(r"sigils\.remove_at\(i\)", collect)
    # the mark: the retired weapon arm's own bytes on the shipped rings class
    assert re.search("fx_rings\\.append\\(\\{\"r\": 760\\.0, \"life\": 0\\.5,"
                     " \\\"max\\\": 0\\.5\\}\\)", collect)


# ---- SD-E4: the pickup row is REAL (billboard) and the tally moved -----------

def test_sigil_pickup_viz_row_and_tally():
    assert const("DRAWS", PICKUP) == 6.0 # §10 re-tally: pickup 5→6, 27→28
    assert re.search(r"_sigil = _mm\(_quad\(\), _icon_mat\(SIGIL_ICON\)\)",
                     PICKUP), "the coin's ONE billboard mechanism, reused"
    assert re.search(r"_write_items\(_sigil, world\.drops\.sigils", PICKUP)
    assert "icon-doom-sigil.png" in PICKUP, "the KEEPT icon rides the drop"
    icon = os.path.join(REPO, "godot", "assets", "icons",
                        "icon-doom-sigil.png")
    assert os.path.isfile(icon) and os.path.getsize(icon) > 0, \
        "SD-E4 assert-exists: the retired weapon's shipped icon is the art"


def test_sigils_never_magnetised():
    # MG-E2's named exclusion: the magnet set is gems+coins+heals. The
    # magnetize body must carry EXACTLY three _magnetize calls and never
    # touch the sigil array; the sigil touch lives in collect_pickups only.
    mag = DROPS_CODE[DROPS_CODE.index("func magnetize(")
                     : DROPS_CODE.index("func _magnetize")]
    assert mag.count("_magnetize(") == 3, "gems + coins + heals — three, one"
    assert "sigils" not in mag, "sigils are NEVER magnetised (§5.1)"
    helper = DROPS_CODE[DROPS_CODE.index("func _magnetize")
                        : DROPS_CODE.index("func merge_gems")]
    assert "sigils" not in helper, \
        "no sigil reach in the pull helper either"


# ---- SD-E5: the weapon-side universe greps to ZERO ----------------------------

# The universe is the WEAPON-SIDE offer/fire surface this card owns
# (M6-SPEC §4.4 named sites). The EVOLVE side (evolutions.gd, sim_evolve.gd
# and the two test files that pin it) is T-M6p's retirement, NOT this card's;
# the ICONS and the pickup-side reads (pickup_viz.gd, drops.gd's icon const)
# are KEEPT by the §4.1 icon law — a KEEP carve, named, never silent.
WEAPON_SIDE_UNIVERSE = [
    os.path.join("godot", "scripts", "weapons.gd"),
    os.path.join("godot", "sim", "sim_combat.gd"),
    os.path.join("tests", "test_biome_numbers.py"),
    os.path.join("tests", "test_card_icons.py"),
    os.path.join("tests", "test_levelup_caps.py"),
    os.path.join("tests", "test_roster_m1h.py"),
    os.path.join("tools", "s8_acceptance.py"),
]


def test_weapon_side_grep_to_zero():
    # Code-only (comment law per _code_of): a provenance COMMENT naming the
    # retired id is lineage; a QUOTED live site is what §4.1 forbids. The
    # evolve-side KEEP (evolutions.gd, sim_evolve.gd, their pins) is NOT in
    # this universe by the spec's own named-site list — T-M6p retires it.
    for rel in WEAPON_SIDE_UNIVERSE:
        code = _code_of(rel)
        # lines ASSERTING absence (`not in` guards — the retirement's own
        # teeth) are the OPPOSITE of a live site and stay:
        code = "\n".join(ln for ln in code.splitlines()
                         if "not in" not in ln)
        assert '"doom-sigil"' not in code, "live doom-sigil site in %s" % rel


# ---- SD-E6: the deviation doc PARSES as a contract (deviation-doc-as-pin) ----
# The doc is the card's honest break; the footer table is machine-read here:
# 16 channel rows, and EVERY SHIFTS/REMINT/RE-DERIVE row carries the owner
# ratification verbatim (the REV-4 §9 binding cell format — non-empty is the
# gate contract, the verbatim quote is the content). A RED planted on a COPY
# (emptied cell) is proven in the card capture; the parse lives here.

def _footer_rows():
    text = open(DEVIATION_DOC, encoding="utf-8").read()
    table = text[text.index("## OWNER-RATIFICATION FOOTER"):]
    rows = [ln for ln in table.splitlines() if ln.startswith("|")]
    header = rows[0]
    _hc = [c.strip() for c in header.strip("|").split("|")]
    assert len(_hc) == 5 and _hc[0] == "channel" and _hc[1] == "class" \
        and _hc[2] == "verdict" and _hc[4] == "owner-ratification", \
        "the footer header IS the parse contract (5 cols, owner cell last)"
    out = []
    for ln in rows[2:]:  # skip the |---| separator
        cells = [c.strip() for c in ln.strip("|").split("|")]
        assert len(cells) == 5, ln
        out.append(dict(zip(["channel", "class", "verdict", "mechanism",
                             "owner"], cells)))
    return out


def test_deviation_doc_footer_contract():
    rows = _footer_rows()
    assert len(rows) == 16, "the ratified §9 REV-3 table is 16 channels"
    verbatim = "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy"
    shifts = 0
    for r in rows:
        cls = r["class"].upper()
        shifting = any(k in cls for k in ("SHIFT", "REMINT", "RE-DERIVE"))
        if shifting:
            shifts += 1
            assert verbatim in r["owner"], \
                "declared-shift cell must carry the owner reply VERBATIM: %s" \
                % r["channel"]
            assert "2026-10-29" in r["owner"], "the ruling date rides the cell"
        else:
            assert r["owner"], "no empty cells anywhere in the contract"
    assert shifts >= 5, "every declared SHIFTS/REMINT/RE-DERIVE row carries it"


def test_deviation_doc_names_the_at_risk_channels():
    # The AT-RISK channels get MEASURED honest verdicts in the doc body
    # (honest per-channel rows are this card's DoD; the footer verdict cells
    # are filled from the battery, never pre-written green).
    text = open(DEVIATION_DOC, encoding="utf-8").read()
    for ch in ("journey", "strips", "s8 capture"):
        assert ch in text, "channel %s missing from the deviation doc" % ch
    # the battery must FILL the verdicts: no PENDING may survive at close —
    # this assert is the close-time gate (it went red until the battery ran).
    assert "PENDING-measure" not in text and "MEASURED: PENDING" not in text, \
        "the battery owed honest MEASURED rows — doc not closed"
