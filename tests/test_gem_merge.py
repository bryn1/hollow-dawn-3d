"""GEM-MERGE (MC 11238 T-M2g): M2-SPEC rev-2 §C.3 ACCEPT rows C-G1..C-G4.

Suite convention (test_endless/test_chests_evolve header): source-truth pins
over the .gd text + behaviour rows judged from the committed, seed-pinned dump
(godot/sim/sim_gems.gd, seed 11238, byte-stable; the re-run byte-identity
itself is the capture's job, the sim_evolve precedent). C-G4 is the pixel row:
its gate is the T-M2g BULK table of tools/upgrades_visual_probe.py (the T-S18
probe mechanism EXTENDED, no new capture mechanism — the capture is the
chest_capture tick-deterministic recipe in godot/sim/gemmerge_capture.gd);
the shot asset + the gate's floor + the capture's existence are pinned here,
the pixels are proven by the probe run (both captured in .tmp/m2g-gems.txt).

Row map (spec row -> evidence here / in the dump):
  C-G1 threshold cap±1          gem_boundary (199 held / 200 -> one bulk,
       count drops 101, fold centroid + SUM byte-exact / 201 merges too) +
       the two consts pinned from world.gd source. RED leg (merge at 199 /
       none at 200) is the planted merge-break, capture.
  C-G2a gem-layer Σxp, UNCOND.  gem_sum_conserved x2 (defaults + DECLARED-
       PINNED insight=3 & meta 1.3 — the fold never reads m): Σ byte-equal
       across the fold. The planted-red (fold drops one gem's xp) drifts Σ
       248.5 -> 248.0 on BOTH variants, capture.
  C-G2b byte-equal @ pinned m=1.0  gem_xp_byte_equal: merge-ON vs merge-OFF
       game.xp/level/pending byte-equal, DECLARED-PINNED insight 0 + meta 1.0
       (the committed-dump default — the rev-2 P2-4 honesty: NO byte-equality
       is claimed at m!=1.0, IEEE; the integer-drop precondition is stated).
  C-G3 bounded under spam       gem_bounded_spam: 6000 REAL kill_enemy drops,
       array never above 200 at the merge seam, folds happened.
  C-G4 bulk viz pixel           shot assets/screens/m2-gemmerge.png (committed)
       + the BULK floor + capture existence pinned below; pixels gated by
       tools/upgrades_visual_probe.py --bulk (GREEN 588/588 vs floor 200;
       planted-reds: bulk suppressed 0/0 RED, bulk that forgot to grow 0/0
       RED, bulk without the brighter tint 588/0 RED — capture).
  §C.1 reuse rows              the merge rides world.gd's ONE entity update
       (_merge_gems called from update_entities, no new array); pickup_viz
       draws the bulk through the ONE gem MM slot moved to its color-instance
       format (use_colors + the albedo opt-in) — draws count untouched; the
       pickup funnel count stays 4 (test_biome_numbers.py:149 stays green —
       no new pickup kind; verified by this suite running green).
"""

import functools
import os
import re

import conftest

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
FIXTURE = os.path.join(conftest.REPO, "tests", "fixtures", "gem-merge-m2g.jsonl")
SHOT = os.path.join(conftest.REPO, "assets", "screens", "m2-gemmerge.png")
CAPTURE = os.path.join(conftest.REPO, "godot", "sim", "gemmerge_capture.gd")
PROBE = os.path.join(conftest.REPO, "tools", "upgrades_visual_probe.py")


read = functools.partial(conftest.read_script,
                       code_only=True)  # MC 11317 C2 seam


WORLD = read("world.gd")
PICKUP = read("pickup_viz.gd")


def const(name, source):
    m = re.search(r"const\s+%s\s*:=\s*([-\d.]+)" % re.escape(name), source)
    assert m, "constant %s not found in source" % name
    return float(m.group(1))


def rows_of(ev):
    return conftest.rows_by_ev(FIXTURE, ev)  # MC 11317 C2 seam


# ---- §C.1 the rule, in the ONE seams (source truth) ---------------------------

def test_merge_consts_200_100():
    assert const("GEM_MERGE_THRESHOLD", WORLD) == 200.0
    assert const("GEM_MERGE_BATCH", WORLD) == 100.0


def test_merge_rides_the_one_entity_update_no_new_array():
    # the fold fires from update_entities (the entity/collect update after the
    # drop), NOT beside it — and only the gems array exists (no bulk array)
    upd = re.search(r"func update_entities.*?(?=\nfunc |\Z)", WORLD, re.S).group(0)
    assert "_merge_gems()" in upd
    m = re.search(r"func _merge_gems.*?(?=\nfunc |\Z)", WORLD, re.S).group(0)
    assert "if gems.size() < GEM_MERGE_THRESHOLD" in m
    assert "gems.remove_at(i)" in m
    # the ONE dict shape: centroid + SUM xp + the big flag, back on gems
    assert re.search(r"gems\.append\(\{\"x\": cx / GEM_MERGE_BATCH, "
                     r"\"y\": cy / GEM_MERGE_BATCH,\s*\"xp\": sxp, \"big\": true\}\)", m)


def test_pickup_viz_bulk_on_the_one_gem_mm():
    # the gem slot moved to its color-instance format (rev-2 P4-5: named)
    assert "_gem = _mm(_quad(), _mat(GameRenderer.ICHOR * GEM_BRIGHT), true)" \
        in PICKUP
    assert "mm.use_colors = color_instance" in PICKUP
    assert "mat.vertex_color_use_as_albedo = true" in PICKUP
    # bulk rides per-instance SCALE + COLOR in _write_items, flag read ONCE
    assert const("GEM_BULK_SCALE", PICKUP) == 2.0
    assert re.search(r"const GEM_BULK_TINT := Color\(", PICKUP)
    assert PICKUP.count('it.get("big", false)') == 1
    assert re.search(r"_write_items\(_gem, world\.gems, basis, GameRenderer\.SIZES\.gem,"
                     r"\s*\n\s*GameRenderer\.SIZES\.gem, GEM_BULK_SCALE\)", PICKUP)
    # ONE MM class per kind — the draw table is untouched (§7: no new class)
    assert const("DRAWS", PICKUP) == 5.0
    # bulk_scale is passed by the GEM call only (coins/crosses/chests inert)
    assert PICKUP.count("GEM_BULK_SCALE") == 2  # the const + the ONE gem call


# ---- C-G1 threshold boundary (dump) ---------------------------------------------

def test_cg1_threshold_boundary_cap_pm_1():
    r = rows_of("gem_boundary")[0]
    assert r["ok"] is True and r["threshold"] == 200 and r["batch"] == 100
    assert r["checks"]["no_merge_at_199"] is True
    assert r["checks"]["merge_at_200_count_drops"] is True and r["n200"] == 101
    assert r["checks"]["merge_at_201_bounded"] is True and r["n201"] == 102
    # the fold carries the batch SUM byte-exact (250 = the pinned 100 drops)
    assert r["bulk_xp_expected"] == r["bulk_xp_observed"] == 250.0


# ---- C-G2 XP-neutrality, TWO legs (rev-2 P2-4) ----------------------------------

def test_cg2a_gem_layer_sum_conserved_unconditional():
    rows = rows_of("gem_sum_conserved")
    assert len(rows) == 2
    for r in rows:
        assert r["ok"] is True
        assert r["checks"]["sum_byte_equal_across_fold"] is True
        assert r["checks"]["bulk_carries_the_fold_sum"] is True
        assert r["sum_pre"] == r["sum_post"]
    variants = {r["leg_variant"] for r in rows}
    assert variants == {"defaults", "pinned-multipliers"}
    pin = [r for r in rows if r["leg_variant"] == "pinned-multipliers"][0]
    # the UNCONDITIONAL claim's witness: conservation held at a pinned m!=1
    assert pin["insight_pinned"] == 3 and pin["meta_xp_mult_pinned"] == 1.3


def test_cg2b_byte_equal_pinned_to_m_1_0():
    r = rows_of("gem_xp_byte_equal")[0]
    assert r["ok"] is True
    assert r["checks"]["xp_bytes_equal"] is True
    assert r["checks"]["level_equal"] is True
    assert r["checks"]["pending_equal"] is True
    assert r["checks"]["one_bulk_fired"] is True
    # the pin is READ and carried, never assumed (m=1.0, the stated scope)
    assert r["checks"]["pin_m_1_0"] is True
    assert r["xp_off"] == r["xp_on"] and r["level_off"] == r["level_on"]
    assert "m=1.0" in r["multiplier"]
    assert "NOT claimed at m!=1.0" in r["multiplier"]


# ---- C-G3 bounded array (dump) --------------------------------------------------

def test_cg3_gem_array_bounded_under_spam():
    r = rows_of("gem_bounded_spam")[0]
    assert r["ok"] is True
    assert r["max_seen"] <= r["threshold"] == 200
    assert r["bulk_now"] >= 1  # folds happened (unbounded growth = the RED)
    assert r["drops"] == 6000


def test_dump_verdict_green():
    v = rows_of("gems_verdict")[0]
    assert v["ok"] is True and v["rows"] == 5


# ---- C-G4 pixel row: asset + gate pins (pixels ride the probe run) --------------

def test_cg4_shot_asset_and_gate_pins():
    assert os.path.exists(SHOT), "bulk-gem shot asset missing"
    assert os.path.exists(CAPTURE), "tick-deterministic capture (chest pattern) missing"
    src = open(PROBE, encoding="utf-8").read()
    m = re.search(r"BULK_PX_MIN\s*=\s*(\d+)", src)
    assert m and int(m.group(1)) == 200, "the BULK floor is OUR 200-px shot family"
    assert '"--bulk"' in src  # the T-S18 probe mechanism, extended (no new tool)
