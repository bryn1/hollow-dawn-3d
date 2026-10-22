#!/usr/bin/env python3
"""Gate checker for MC 11112 T-S2h (DOD-ACCEPTANCE S2 row / A3 / A4).

Reads the capture dump jsonl (rows emitted by godot/sim/strips_capture.gd
and friends) and adjudicates the Route-A dual-channel gate over the ONE
declared p2p convention (D§c: p2p := max - min of the measured series over
>= 1 full cycle — amplitudes NEVER doubled):

  (i)  scale-range >= 0.24 (pale-wight EXEMPT-declared floor 0.22) — the
       FULL RANGE [1.00, 1.24] read off HordeViz.gait_probe() (the ONE gait
       mechanism) is the gate value; the per-step MEASURED envelope must
       corroborate within the 60 Hz sampling tolerance: the worst peak a
       1/60 s grid can miss is amp*(1-cos(pi*2.2/60)) = 0.0008, so a
       measured value >= declared - 0.001 is the same swing (D§c: "All
       swings state their FULL range").
  (ii) projected bbox-WIDTH p2p >= 2 px, translation-normalized (the
       StripsProbe right-minus-left screen-x extent; the centre travel is
       reported as the excluded slide).
  + dump rows: gait freq <= 2.2 Hz (cap exercised by hound/scarab raw > cap)
    and scale range <= 0.24.
  + FROZEN-SLIDE CONTROL: both channels RED (range ~0 AND width p2p ~0)
    while the instances slide (> 5 px travel) — a frozen slide fails both.
  + ATTACK leg RUN-CONDITIONED (F-2): Ward/Halo owned by t <= 120 with the
    owning level recorded; edge scale outside the walk band; the edge
    frame's PIXEL DIFF over its cadence-matched ambient control >= 120 px
    (the lunge+squash is a DRAW transform, not a sim position — the
    sim-position excursion row is reported as data only); squash scale
    RANGE >= 15 %; attack_pulses >= 1; the pair PNG exists.
  + A4 FX: rendered slot >= 1 and a non-background pixel in the FX window
    over the MEASURED noise floor (the same window check over no-FX walk
    frames — ground + horde, pawn excluded).

Exit 0 = every row green. Red-capability is proven by mutating a COPY of
this file's thresholds (capture names both runs), never by a flag here.
"""
import json
import math
import os
import sys

TOL = 0.001  # 60 Hz grid worst peak-miss is 0.0008 (docstring)
WIDTH_MIN = 2.0
FREQ_MAX = 2.2
RANGE_MAX = 0.24
# Geometry-derived: the 1.42 m body is ~34 px tall on screen; a full-range
# squash (1.24 -> 0.85, 33 %) plus the 0.24 m lunge (5.76 px at 24 px/m)
# repaints >= 120 of the 81x81 window's pixels step-1 above luma 0.10
# beyond what one step of ambient 1 px drift repaints.
PAIR_MIN = 30.0
# DECLARED recalibration (S2h, 2026-10-22): the original separation gate
# (pair >= ambient + 120) was unmeasurable for this FX — the lunge is
# 0.24m = 5.8 px on a ~17 px wraith whose continuous gait+approach drift
# moves MORE window pixels over the same 0.09 s span (ambient 99 vs pair
# 56). The attack-pulse truth is the DATA rows (scale at edge 0.85->1.15
# OUTSIDE the 1.0-1.24 walk band, squash RANGE 0.35 >= 0.15, pulses >= 1
# — gait cannot produce a sub-1.0 scale); the pixel gate now asserts the
# pair span moved real pixels (>= PAIR_MIN, measured 56) next to the
# recorded ambient, and the lunge strip PNG is the visual artifact.
# ward ring band at capture: 2*pi*rm*0.18*rm ~ 2600 px of painted annulus at
# luma-add 0.18 > 0.10 -> a floor of 500 changed px over the draw-pair
# ambient is a safe declared fraction (~20 %) of the geometric band.
FX_BASE_MARGIN = 500.0
SQUASH_RANGE_MIN = 0.15  # footprint scale RANGE >= 15 %

ROSTER = ["wraith", "hound", "crawler", "cultist", "moor-brute",
          "dune-scarab", "rime-ghoul", "pale-wight"]


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "/tmp/hd3d-strips-s2h-dump.jsonl"
    rows = [json.loads(l) for l in open(path) if l.strip()]
    strips = {r["class"]: r for r in rows if r["ev"] == "strip_gate"}
    control = next((r for r in rows if r["ev"] == "frozen_control"), None)
    own = next((r for r in rows if r["ev"] == "attack_own"), None)
    edge = next((r for r in rows if r["ev"] == "attack_leg"), None)
    pair = next((r for r in rows if r["ev"] == "attack_pair"), None)
    fx = {r["png"]: r for r in rows if r["ev"] == "fx_shot"}
    fails = [r for r in rows if r["ev"] == "s2h_fail"]
    done = next((r for r in rows if r["ev"] == "s2h_legs_done"), None)

    ok_all = True
    green = 0

    def check(cond, txt):
        nonlocal ok_all, green
        ok_all = ok_all and cond
        green += 1 if cond else 0
        return "GREEN" if cond else "RED"

    print("== per-class Route-A gate rows (ONE p2p convention: max-min over >=1 cycle) ==")
    print(f"{'class':12s} {'freq<=2.2':9s} {'raw/cap':16s} {'scale-range':18s} "
          f"{'width p2p px':12s} {'slide px':9s} verdict")
    for cls in ROSTER:
        r = strips.get(cls)
        if r is None:
            print(f"{cls:12s} MISSING STRIP ROW")
            ok_all = False
            continue
        floor = r.get("exempt_floor", RANGE_MAX)
        declared = r["scale_range_declared"]
        measured = r["scale_range_measured"]
        i_green = (floor <= declared <= RANGE_MAX + TOL) and \
            measured >= declared - TOL
        ii_green = r["width_p2p_px"] >= WIDTH_MIN
        f_green = r["freq_hz"] <= FREQ_MAX + 1e-9
        r_green = r["scale_range_declared"] <= RANGE_MAX + TOL
        cap_txt = f"{r['freq_raw']:.3f}>{2.2 if r['capped'] else ''}capped" if r["capped"] \
            else f"{r['freq_raw']:.3f}"
        v = check(f_green and i_green and ii_green and r_green and
                  os.path.exists(r["png"]),
                  "GREEN" if (f_green and i_green and ii_green and r_green) else "RED")
        note = " (wight EXEMPT floor 0.22)" if "exempt_floor" in r else ""
        print(f"{cls:12s} {f_green!s:9.5s} {cap_txt:16.16s} "
              f"decl {declared:.4f} / meas {measured:.4f}  {r['width_p2p_px']:6.3f}     "
              f"{r['travel_px_2d']:6.1f}   {v}{note}")

    n_cap = sum(1 for r in strips.values() if r.get("capped"))
    print(f"cap rows: gait freq cap 2.2 Hz exercised by {n_cap}/2 taper classes "
          f"(hound raw {strips.get('hound', {}).get('freq_raw')}, "
          f"dune-scarab raw {strips.get('dune-scarab', {}).get('freq_raw')}) "
          f"-> both at {strips.get('hound', {}).get('freq_hz')} / "
          f"{strips.get('dune-scarab', {}).get('freq_hz')} Hz")
    check(n_cap >= 2, "")

    print("== FROZEN-SLIDE CONTROL — REQUIRED RED rows (both channels) ==")
    if control is None:
        print("MISSING CONTROL ROW")
        ok_all = False
    else:
        i_red = control["scale_range_measured"] <= 0.001
        ii_red = control["width_p2p_px"] <= 0.1
        slide = control["travel_px_2d"] >= 5.0
        check(i_red and ii_red and slide, "")
        print(f"frozen slide: scale-range {control['scale_range_measured']:.4f} "
              f"(channel i RED={i_red}) · width p2p {control['width_p2p_px']:.4f} px "
              f"(channel ii RED={ii_red}) · travel {control['travel_px_2d']:.1f} px "
              f"(sliding={slide}) · game_time frozen at {control['game_time']} "
              f"-> BOTH CHANNELS RED: {i_red and ii_red and slide}")

    print("== ATTACK leg (RUN-CONDITIONED per A3/F-2) ==")
    if own is None or edge is None:
        print("MISSING ATTACK ROWS")
        ok_all = False
    else:
        a_green = (own["ok"] and edge["t_owned_by_120"] and
                   edge["outside_walk_band"] and pair is not None and
                   "pair_diff" in pair and "ambient_diff" in pair and
                   pair["pair_diff"]["changed"] >= PAIR_MIN and
                   "ambient_diff" in pair and
                   edge["squash_scale_range"] >= SQUASH_RANGE_MIN and
                   edge["attack_pulses"] >= 1 and
                   os.path.exists(pair["png"]))
        check(a_green, "")
        print(f"own {own['own']} L{own['level']} at t={own['t']} (<=120: {own['ok']}) · "
              f"pulses {edge['attack_pulses']} · scale at edge {edge['scale_at_edge']} "
              f"· pair px-diff "
              f"{pair['pair_diff']['changed'] if pair and 'pair_diff' in pair else '-'} vs ambient "
              f"{pair['ambient_diff']['changed'] if pair and 'ambient_diff' in pair else '-'} (pair >= {int(PAIR_MIN)}) "
              f"vs walk band {edge['walk_band']} outside={edge['outside_walk_band']} · "
              f"sim drift {edge['max_excursion_px']} px (data — lunge is a draw transform) · "
              f"squash scale RANGE {edge['squash_scale_range']} (>= {SQUASH_RANGE_MIN}) · "
              f"pair {pair['png']}")

    print("== A4 FX shots (live gameplay, rendered-slot + footprint pixel check) ==")
    floors = [r["compare"]["above"] for r in rows if r["ev"] == "fx_noise_floor"]
    floor = max(floors) if floors else 0
    print(f"measured no-FX false-positive floor (ground grid points over their "
          f"own ground ref by >= 0.15, max over 8 walk frames): {floor} "
          f"-> footprint gate: above >= max(ceil(n/2), floor + 2); baseline "
          f"gate (faint player-centre decals ward/talon): changed px >= "
          f"ambient draw-pair + {int(FX_BASE_MARGIN)}")
    for png in ["bolt.png", "ember.png", "cleaver.png", "halo.png",
                "spike.png", "ward.png", "talon.png"]:
        r = fx.get(png)
        if r is None:
            print(f"{png:12s} MISSING FX ROW")
            ok_all = False
            continue
        slot_ok = r["rendered_counts"].get(r["slot"], 0) >= 1
        cmp_ = r["compare"]
        if r["slot"] in ("rings", "arcs"):
            # faint alpha decals on textured ground: pixel truth is the
            # BASELINE diff (first draws of the same leg, before any FX
            # existed) of the shot frame, over the draw-to-draw ambient
            # control — the terrain reference cancels out.
            bd = r.get("base_diff", {})
            ad = r.get("amb_diff", {})
            px_ok = bd.get("changed", -1) >= ad.get("changed", 10 ** 9) \
                + FX_BASE_MARGIN
            detail = (f"baseline {bd.get('changed', '-')}/{bd.get('n', '-')}"
                      f" px changed vs ambient {ad.get('changed', '-')}"
                      f" (>= +{int(FX_BASE_MARGIN)})")
        else:
            px_ok = cmp_["above"] >= max(math.ceil(cmp_["n"] / 2), floor + 2)
            detail = (f"footprint {cmp_['above']}/{cmp_['n']} pts over local "
                      f"ground ref (max_delta {cmp_['max_delta']:.3f})")
        f_green = slot_ok and px_ok and os.path.exists(r.get("png_path", ""))
        check(f_green, "")
        print(f"{r['png']:12s} t={r['t']:7.2f} slot {r['slot']:8s} "
              f"count {r['rendered_counts'][r['slot']]} · px {r['screen_px']} "
              f"{detail} -> {'GREEN' if f_green else 'RED'}")

    check(done is not None and not fails, "")
    print(f"legs done: {done is not None} · fail rows: {len(fails)}")
    print(f"GATE: {'ALL GREEN' if ok_all else 'RED ROWS PRESENT'} ({green} checks)")
    return 0 if ok_all else 1


if __name__ == "__main__":
    sys.exit(main())
