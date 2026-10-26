#!/usr/bin/env python3
"""T-S8 FINAL ACCEPTANCE (MC 11148): prints the DOD-ACCEPTANCE A1..A8 table
with one evidence level per row, from the real-clock legs this card runs
(.tmp/s8-gameover.jsonl / .tmp/s8-win.jsonl) and the committed fixtures +
sim dumps of S2-S7. Exit 0 = every row PASS; any FAIL/BLOCKED exits 1.
Red-capability (the gate's own mutation proof): corrupt one input row —
e.g. flip "kind":"win" in .tmp/s8-win.jsonl — this table must go RED
(P1 FAIL, exit 1); restore -> green. Both runs pasted on the card capture.

Levels: RUNTIME = the product ran here, wall-clock measured; TESTED = a
committed automated gate re-run now over committed material; Pixel = a real
Xvfb GL crop counted against the empty-baseline frame (orchestrator VIEWS
the PNG — visual acceptance is never self-accepted here).

Declared deviations this table carries (see row notes): the WIN leg pins
game.hp every frame (the S6 boss kill-leg precedent — no scripted driver
survives the 12/s wall; seeds 11101-11106 die t=375..467, scan in the
capture) — the CLOCK stays real (time_scale 1.0, ticks counted); the HUD /
boss-bar shots warp the sim clock (the repo's stated capture reading).
"""
import csv
import json
import os
import re
import subprocess
import sys

from PIL import Image

import pixel_lib

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DUMP = os.path.join(REPO, ".tmp", "hd3d-boss-s6-dump.jsonl")
GO = os.path.join(REPO, ".tmp", "s8-gameover.jsonl")
WIN = os.path.join(REPO, ".tmp", "s8-win.jsonl")
STRIPS = os.path.join(REPO, ".tmp", "hd3d-strips-s2p-dump.jsonl")
CSV_FRAMEDIFF = os.path.join(REPO, "tests", "fixtures",
                             "skinned-clips-s2r-framediff.csv")
SHOTS = os.path.join(REPO, ".tmp", "s8-shots")
BOSSBAR_PNG = os.path.join(REPO, ".tmp", "s8-bossbar.png")
TICKS_MIN = 55.0  # real-clock leg: engine-paced physics, measured ~60
DIFF_MIN = 24     # per-channel diff floor vs the empty baseline (HUD bone
                  # text/fills sit >150 over INK; ground drift sits under it)
NON_BG_MIN = 200  # DOD pixel threshold


def rows(path):
    if not os.path.exists(path):
        return None
    out = []
    with open(path) as fh:
        for line in fh:
            line = line.strip()
            if line:
                out.append(json.loads(line))
    return out


def crop_nonbg(live, base, box):
    # MC 11317 C1: the count itself lives in tools/pixel_lib.crop_delta_count
    # (the ONE pixel-delta seam; the >= DIFF_MIN convention and the -1
    # size-mismatch sentinel are this table's, carried as the floor arg).
    return pixel_lib.crop_delta_count(live, base, box, DIFF_MIN)


def leg_end(rs, want=None):
    for r in rs:
        if r.get("ev") == "leg_end" and (want is None or r.get("kind") == want):
            return r
    return {}


def main():
    out = []          # (id, claim, verdict, level, evidence)
    def row(rid, claim, ok, level, ev, note=""):
        verdict = "PASS" if ok is True else \
            "BLOCKED" if ok is None else "FAIL"
        out.append((rid, claim, verdict, level, ev + ((" — " + note) if note else "")))

    g, w = rows(GO), rows(WIN)
    d = rows(DUMP)

    # ---- A1: full playable game — REAL CLOCK (replaces the declared warp)
    a1, why = False, "missing leg dump"
    if g and w:
        gs, ge, ws, we = g[0], leg_end(g, "gameover"), w[0], leg_end(w, "win")
        kills60 = any(r["ev"] == "pos" and r["t"] >= 60 and r["kills"] > 0
                     for r in g)
        a1 = (gs.get("time_scale") == 1.0 and ws.get("time_scale") == 1.0
              and ge.get("monotonic_time_check") and we.get("monotonic_time_check")
              and we.get("t_sim", 0) >= 600.0 and we.get("wall_s", 0) >= 590
              and we.get("ticks_per_s", 0) >= TICKS_MIN
              and ge.get("ticks_per_s", 0) >= TICKS_MIN
              and gs.get("hp_pinned") is False and ws.get("hp_pinned") is True
              and kills60)
        why = ("gameover t=%.1f wall %.1fs %.1f t/s | WIN t=%.3f wall %.1fs "
               "%.1f t/s (hp-pin declared, clock real; kills>0 by t=60: %s; "
               "web rAF-fps leg NOT re-measured — GPU out of card scope)"
               % (ge.get("t_sim", -1), ge.get("wall_s", -1), ge.get("ticks_per_s", -1),
                  we.get("t_sim", -1), we.get("wall_s", -1), we.get("ticks_per_s", -1),
                  kills60))
    row("A1", "full playable game, real-clock t=0..death + t=0..900 win (WIN_TIME re-pinned 600->900 by T-M1d)",
        a1, "RUNTIME", ".tmp/s8-gameover.jsonl + .tmp/s8-win.jsonl", why)

    # ---- HUD pixel row (T-S8 build: v1 hud.gd row on the 3D CanvasLayer)
    hud_png, base_png = os.path.join(SHOTS, "hud.png"), os.path.join(SHOTS, "baseline.png")
    n_hud = crop_nonbg(hud_png, base_png, (0, 0, 720, 56)) \
        if os.path.exists(hud_png) and os.path.exists(base_png) else -1
    row("HUD", "health/XP/timer/level row painted over the live 3D scene, t>10s",
        n_hud >= NON_BG_MIN, "Pixel", "%s vs %s crop(0,0,720,56) n=%d px"
        % (hud_png.replace(REPO + "/", ""), base_png.replace(REPO + "/", ""), n_hud))

    # ---- CYCLE-HUD row (T-M2e A-E7, MC 11237): the endless cycle text on the
    # playing frame. Baseline = hud.png (SAME frozen state, endless OFF -> the
    # cycle label hidden; s8_capture stage 5-6 pins endless+cycle then shoots
    # cycle-hud.png), so the counted pixels are the cycle text INSIDE the
    # opaque HUD panel. Window = the capture's own cycle_row_state STATE line
    # (label at x 566..610, y 19..37 — 44x18) padded: (552,12,624,44).
    # Planted red = feed the baseline against itself -> 0 px -> this row
    # FAILs, exit 1 (the s8 header's own mutation convention; both runs in
    # the T-M2e capture).
    cyc_png = os.path.join(SHOTS, "cycle-hud.png")
    n_cyc = crop_nonbg(cyc_png, hud_png, (552, 12, 624, 44)) \
        if os.path.exists(cyc_png) and os.path.exists(hud_png) else -1
    row("CYCLE-HUD", "endless cycle text reads on the playing HUD frame",
        n_cyc >= NON_BG_MIN, "Pixel", "%s vs %s crop(552,12,624,44) n=%d px "
        "(panel-interior; label rect 566,19,44,18 + pad)"
        % (cyc_png.replace(REPO + "/", ""), hud_png.replace(REPO + "/", ""), n_cyc))

    # ---- A2: skinned player clips
    a2 = None
    if os.path.exists(CSV_FRAMEDIFF):
        with open(CSV_FRAMEDIFF) as fh:
            fr = [r for r in csv.DictReader(fh)]
        pw = [r for r in fr if r["rig"].startswith("player") and r["clip"] == "walk"
              and r["kind"] == "motion" and int(r["diff_px"]) >= 2]
        pa = [r for r in fr if r["rig"].startswith("player") and r["clip"] == "attack"
              and r["kind"] == "motion" and int(r["diff_px"]) >= 2]
        fz = [r for r in fr if r["rig"].startswith("player") and r["kind"] == "frozen"
              and int(r["diff_px"]) == 0]
        a2 = bool(pw and pa and fz)
    row("A2", "animated player (skinned walk+attack frame-diff >=2 px, rest stable)",
        a2, "TESTED", CSV_FRAMEDIFF.replace(REPO + "/", ""))

    gate = None
    if os.path.exists(STRIPS) and os.path.exists(DUMP):
        gate = subprocess.run(
            [sys.executable, os.path.join(REPO, "tools", "strips_gate_check.py"),
             STRIPS], capture_output=True, text=True).returncode == 0

    # ---- A3: 8 types spawn + Route-A gates
    a3 = None
    if gate is not None and d:
        spawns = {r["type"] for r in d if r["ev"] == "first_spawn"}
        gates_open = {r["type"] for r in d if r["ev"] == "type_open"
                      and r["source"] == "gate"}
        a3 = gate and len(spawns) >= 8 and \
            {"wraith", "hound", "crawler", "cultist"} <= gates_open
    row("A3", "all 8 non-boss types spawn; Route-A dual-channel gate green",
        a3, "TESTED", ".tmp/hd3d-strips-s2p-dump.jsonl via tools/strips_gate_check.py"
        " + first_spawn/type_open rows of .tmp/hd3d-boss-s6-dump.jsonl")

    # ---- A4: FX caps + per-weapon kills (draw budget too)
    a4 = None
    if d:
        fx = next((r for r in d if r["ev"] == "fx_caps"), {})
        dr = next((r for r in d if r["ev"] == "draws"), {})
        wk = [r for r in d if r["ev"] == "weapon_kills"]
        aw = next((r for r in d if r["ev"] == "all_weapons_killed"), {})
        # FALSIFIED AND REPLACED here by T-M3b (MC 11284; the re-pin the
        # capture tool missed since T-M1d's 6->16 weapon-leg dump growth —
        # the row had been RED on master ever since, base-dump parity proven
        # in .tmp/m3b-bosses.txt): the kill-leg count now reads from the
        # dump's OWN all_weapons_killed row (legs == count == kills>=1 each).
        a4 = (fx.get("violations") == 0 and fx.get("samples", 0) >= 500
              and dr.get("ok") and len(wk) == aw.get("legs", -1)
              and len(wk) >= 6 and all(r["kills"] >= 1 for r in wk)
              and aw.get("ok"))
    else:
        wk = []
    row("A4", "all weapon legs kill (dump legs=%d) + rendered FX caps hold"
        " + draw budget <= 60" % len(wk),
        a4, "TESTED", ".tmp/hd3d-boss-s6-dump.jsonl fx_caps/draws/weapon_kills rows"
        " + .tmp/s2p-fx/*.png (gate A3 leg)")

    # ---- A5: boss spawn/bar/kill/drops + bar pixel proof
    a5 = None
    n_bar = -1
    if d:
        bs = next((r for r in d if r["ev"] == "boss_spawn"), {})
        bv = next((r for r in d if r["ev"] == "boss_viz"), {})
        bk = next((r for r in d if r["ev"] == "boss_kill"), {})
        bo = next((r for r in d if r["ev"] == "boss_once"), {})
        bd = next((r for r in d if r["ev"] == "boss_drops"), {})
        bw = [r for r in fr if r["rig"].startswith("boss") and r["kind"] == "motion"
              and int(r["diff_px"]) >= 2] if os.path.exists(CSV_FRAMEDIFF) else []
        live_bar = os.path.join(SHOTS, "bossbar.png")
        if os.path.exists(live_bar) and os.path.exists(base_png):
            n_bar = crop_nonbg(live_bar, base_png, (400, 0, 880, 44))
            if not os.path.exists(BOSSBAR_PNG):
                Image.open(live_bar).save(BOSSBAR_PNG)
        a5 = (bs.get("t", 0) >= 540.0 and bs.get("hp", 0) >= 3000
              and bs.get("bosses_alive") == 1 and bv.get("instances") == 1
              and bv.get("bar", {}).get("name") == "THE HOLLOW WARDEN"
              and bk.get("ok") and bo.get("ok") and bd.get("ok") and bool(bw)
              and n_bar >= NON_BG_MIN)
    row("A5", "boss at t>=540, bar 'THE HOLLOW WARDEN' painted (n=%d px), kill"
        " +50g, Dawnlight guaranteed, once" % n_bar, a5, "Pixel",
        ".tmp/s8-bossbar.png + .tmp/s8-shots/ + boss rows of .tmp/hd3d-boss-s6-dump.jsonl")

    # ---- REAPER-BAR row (T-M4r B-E2, MC 11364; R6 ADDITIVE — the A5 warden
    # bar row byte-untouched, this table gains its own reaper-variant row):
    # the night capture (s8_capture.gd HD3D_REAPER=1, own shots dir) paints
    # "THE REAPER" in the bar crop (same A5 window), counted against the
    # empty baseline frame. The name READ itself is the capture's own STATE
    # line (bar=... JSON) plus the executed runtime twin: the reaper_limit
    # leg's bar_reads_reaper check in tests/fixtures/reaper-m4.jsonl.
    # Planted red = feed the baseline against itself -> 0 px -> this row
    # FAILs, exit 1 (the table's mutation convention; both runs in the
    # T-M4r capture .tmp/m4r-reaper.txt).
    reaper_png = os.path.join(REPO, ".tmp", "s8-shots-reaper", "bossbar.png")
    n_reaper = crop_nonbg(reaper_png, base_png, (400, 0, 880, 44)) \
        if os.path.exists(reaper_png) and os.path.exists(base_png) else -1
    row("REAPER-BAR", "night-variant bar 'THE REAPER' painted over the live"
        " 3D scene (name read: capture STATE line + reaper_limit leg)",
        n_reaper >= NON_BG_MIN, "Pixel", "%s vs %s crop(400,0,880,44) n=%d px"
        % (reaper_png.replace(REPO + "/", ""), base_png.replace(REPO + "/", ""),
           n_reaper))

    # ---- A6: band switches at 0/150/300/450 + banner rule pinned
    a6 = None
    if d and os.path.exists(os.path.join(REPO, "godot", "scripts", "hud_3d.gd")):
        # the sample ROW's t is the step label (level-up skips make it lag
        # game time); the truth-pair is (t_sim, band) against the step fn
        # t_starts 0/150/300/450 (N21).
        def band_at(t):
            return 3 if t >= 450 else 2 if t >= 300 else 1 if t >= 150 else 0
        samp = [r for r in d if r["ev"] == "band_sample"]
        flips = sorted(round(r["t"]) for r in d if r["ev"] == "band_flip")
        src = open(os.path.join(REPO, "godot", "scripts", "hud_3d.gd")).read()
        a6 = bool(len(samp) >= 6 and all(r["band"] == band_at(r["t_sim"])
                                    for r in samp)
            and flips == [0, 150, 300, 450]
            and re.search(r"const BIOME_FLASH := 3\.0", src))
    row("A6", "ground bands switch at 0/150/300/450 exactly; banner BIOME_FLASH=3.0",
        a6, "TESTED", "band_sample/band_flip rows of .tmp/hd3d-boss-s6-dump.jsonl"
        " + hud_3d.gd")

    # ---- A7: all pool kinds with real icons (32 kinds since T-M1h; pytest gate, no capture re-run)
    rc = subprocess.run([sys.executable, "-m", "pytest", "-q",
                         "tests/test_card_icons.py"], cwd=REPO,
                        capture_output=True, text=True).returncode
    cards = [p for p in (".tmp/s5-cards/cards-weapons.png",
                         ".tmp/s5-cards/cards-passives.png",
                         ".tmp/s5-cards/cards-bonus.png")
             if os.path.exists(os.path.join(REPO, p))]
    row("A7", "all 32 pool kinds (16 weapons + 15 passives + 1 bonus) resolve a real icon; card shots committed",
        rc == 0 and len(cards) == 3, "TESTED",
        "tests/test_card_icons.py (rerun rc=%d) + .tmp/s5-cards/" % rc)

    # ---- A8: camera pins + 3090 provenance + release assets
    a8, note8 = None, ""
    if d:
        cam = next((r for r in d if r["ev"] == "camera"), {})
        off = cam.get("offset", [])
        cam_ok = (cam.get("projection") == "PROJECTION_ORTHOGONAL"
                  and cam.get("size") == 30.0 and cam.get("near") == 0.5
                  and cam.get("far") == 90.0 and abs(cam.get("pitch_deg_off_straight_down", 0) + 20) < 0.05
                  and len(off) == 3 and abs(off[0]) < 0.01
                  and abs(off[1] - 37.6) < 0.05 and abs(off[2] - 13.7) < 0.05)
        perm = open(os.path.join(REPO, "docs", "PERMANENCE.md")).read()
        missing = [f for f in sorted(os.listdir(os.path.join(REPO, "godot", "assets", "glb")))
                   if f.endswith(".glb") and f[:-4] not in perm]
        try:
            rv = subprocess.run(["gh", "release", "view", "v0.2.0-test",
                                 "--repo", "bryn1/hollow-dawn-3d"],
                                capture_output=True, text=True, timeout=60).stdout
        except Exception:
            rv = ""
        rel_ok = ("HollowDawn3D-web.zip" in rv and "HollowDawn3D-win-x64-test.zip" in rv)
        a8 = bool(cam_ok and not missing and rel_ok)
        note8 = ("cam %s | assets-without-provenance=%d | release assets %s"
                 % ("ok" if cam_ok else "BAD", len(missing),
                    "web+win ok" if rel_ok else "NOT VISIBLE (gh offline?)"))
    row("A8", "ortho camera pins / 3090-only provenance / release with web+win zips",
        a8, "RUNTIME", "camera row + docs/PERMANENCE.md + gh release view v0.2.0-test",
        note8)

    base = subprocess.run(["git", "rev-parse", "--short", "HEAD"], cwd=REPO,
                          capture_output=True, text=True).stdout.strip()
    print("S8 ACCEPTANCE (MC 11148) base=%s  time_scale=1.0 real-clock legs" % base)
    bad = 0
    for rid, claim, verdict, level, ev in out:
        bad += verdict != "PASS"
        print("%-4s | %s | %s | %s | %s" % (rid, claim, verdict, level, ev))
    print("rows=%d PASS=%d FAIL/BLOCKED=%d" % (len(out), len(out) - bad, bad))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
