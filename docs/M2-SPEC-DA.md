# M2-SPEC-DA — adversarial gate on `docs/M2-SPEC.md` @ 475a480 (MC 11221, DA c1)

- **Reviewer:** devils-advocate (11221). Target: `docs/M2-SPEC.md` @ `475a480` (design card 11219).
- **Base note:** all code-truth greps re-run by this reviewer against the tree at `475a480`.
  `origin/master` moved UNDER the review: `cccc523` (T-S20, MC 11218) landed after the spec commit;
  its diff to `475a480` touches ONLY `.tmp/hd3d-strips-s2h-dump.jsonl` — every evidence line below
  remains true at current master. Roster-wiring card 11220: a `feat/roster` worktree exists at
  `cccc523` but is NOT on master at this writing — F-1's premise (roster still unwired) holds.
- **Line anchors** are `file:line` at `475a480`; spec anchors are `M2-SPEC.md` §/row ids.

## 1. The 10-point self-DA checklist (spec §9) — reviewer rows

| # | checklist point | status | evidence (re-grepped at 475a480) |
|---|---|---|---|
| 1 | Clean-room numbers, shape refs only | **verified** | Spec's numbers are OURS and differ from theirs where it matters: merge 200 vs their 400 (`VS-FEATURES.md:644` re-read: ">400 Experience Gems … single red Experience Gem"); HP/qty/dmg curves ours vs the quoted `+100%/+50%/+25% + cap-minus-1` (VS-FEATURES S5 ~465-467 re-read VERIFIED); chest 1-1-3-1-1-5 explicitly NOT cloned (VS-FEATURES ~656 VERIFIED); unions passive-gate is OUR rule (S1.3 ~266-276 re-read VERIFIED). |
| 2 | Drift honesty (F-1) | **verified** | 6 IDS `weapons.gd:6`, 5 PASSIVES `levelup.gd:10-16`, dead TABLE `evolutions.gd:25-36` with `try_evolve` never matching pool ids (`evolutions.gd:14-15,46-57`), 6-ID pin `tests/test_biome_numbers.py:231` — all re-grepped as claimed. LEDGER T-M1g row states verbatim "M1 feature 6/7 … IDS still 6, PASSIVES still 5"; roadmap "16 by M1" `PARITY-ROADMAP.md:38`. Union-2 dependency flagged as orchestrator decision, not assumed (spec §0 F-1 + §5 prereq row). |
| 3 | Reuse-first, no second mechanism | **verified** | Endless rides WIN_TIME (`game_state.gd:7`), spawn loop (`world.gd:105-122`), collect funnel (`world.gd:177-210`), pending_levels seam (`main.gd:209-210`), save funnel (`main.gd:290-291`), dawnwell hand-in (`main.gd:224`, flags dict exists `save.gd:26,51`). Chest tiers ride `build_pool/apply_offer/bonus_card` (`levelup.gd:19,57,70`) + `credit_gold` (`game_state.gd:111`). Gem-merge rides gems array/`add_xp` (`world.gd:164,179-183`). Unions ride the ONE chest-open site (`world.gd:205`). The two new modules (`chest_rewards.gd`, `union.gd`) are named rule-entry exceptions mirroring the `evolutions.gd` separate-table precedent (DA c3 C-2) — accepted as stated. |
| 4 | Endless cannot explode; red row trips EACH clamp | **CONTRADICTED** | Formulas + caps are present in the spec text, but two of the three named red rows CANNOT go red: `MAX_CONTACT_DMG 40.0` is unreachable on every path (P2-1) and `HP_EFFECTIVE_MULT_CAP 18.0` never binds on the cycle-3 leg that A-E3 pins (P2-2). Computations in §2-A below. |
| 5 | Gem-merge XP-neutrality + boundedness rows exist | **partial** | C-G2/C-G3 rows exist; sum-preservation is real and `add_xp` loops multi-level bulk XP correctly (`game_state.gd:99-102` re-grepped). But the **byte-identical** claim fails under any insight/meta-xp multiplier (P2-4) — holds only at multiplier 1.0. |
| 6 | Every ACCEPT row names ONE existing seam; no new capture | **verified** | Every named seam exists at 475a480: `sim_headless`/`sim_s8` (HD3D dump), `save_probe.gd`, `tests/test_save.py:96` format-key pin, `s8_acceptance.py`, `tools/chest_pixel_gate.py` + `godot/sim/chest_capture.gd` (both EXIST — see P3-4 mislabel), `tools/upgrades_visual_probe.py` + `upgrades_visual_capture.gd`, `cards_capture.gd`, `test_card_icons.py`, `sim_boss/sim_evolve/sim_caps/sim_budget`, `test_art_integration.py:21-22,42`. New sim legs follow the per-leg `HD3D_<LEG>_DUMP`+`HD3D_SEED` precedent (`sim_evolve.gd:59`, `sim_budget.gd:53`, `sim_caps.gd:43`) = dump legs, not capture mechanisms. |
| 7 | Every gate can go RED | **partial** | Working planted-reds verified for the HP cap (A-E2 low-cap trick), merge threshold cap±1, one-transform-per-chest, endless-off win, baseline-vs-baseline pixel (M1e precedent red-proven, LEDGER :25). A-E3's damage-side red is vacuous (P2-1) and its clamp-binding assertion is vacuous at cycle 3 (P2-2). |
| 8 | Budget re-derived incl unions, 0 new draw classes | **verified** | Measured 27/40/60 VERIFIED (LEDGER T-M1g "draws row 27/60"; pins `test_art_integration.py:21-22,42` re-grepped). Union FX classes EXIST: `bursts` `weapons.gd:24`, `halos` `weapons.gd:27`, both drawn by existing viz_fx MultiMeshes (`viz_fx.gd:33-39`). `zones` MM is NOT in the tree — correct per the roadmap's own count: "NEW zones list (the ONE new mechanism; reused M2+)" `PARITY-ROADMAP.md:176` and "zones MM +1 … → planned 40" `:184`; the ≈37–40 post-roster figure is the roadmap's own `:87`. Claim stands (wording caveat P3-5). |
| 9 | Contract B untouched | **verified** | `snapshot_json` = exactly 12 fields, re-counted at `game_state.gd:125-138` (phase,hp,maxHp,level,xp,xpNext,gold,kills,time,enemies,weapons,runId). No pillar adds a field or a phase value; endless cycle/flag, chest `tier`, gem `big`, `best_cycle` all live OUTSIDE the snapshot (save/dicts). A-E6's 12-field pin seam exists (`tests/test_dawnwell_shop.py:114` snapshot-scope pin). One value-domain note (P4-6). |
| 10 | Wave-map discipline | **partial** | Same-file monolith honestly named, single serial spine (accepted: it is named + reasoned, §5 L274-277); v1.3.0 pinned (roadmap `:65` M2→v1.3.0); doc-sync rows named; `:231` retirement flagged. BUT the card table's own "parallel with" column contradicts the spine (P2-5), and A-E7's file is missing from the map (P3-3). |

Checklist tally: 6 verified / 3 partial / 1 contradicted.

## 2. Independent attacks (A–H) — each computed or re-grepped by this reviewer

### A. Endless explosion — caps HOLD the sim; two clamp-reds are VACUOUS; fun metric breaks
- Spec constants: `HP_CYC(k)=min(1+0.75k,6)`, `QTY(k)=min(1+0.25k,2)`, `DMG(k)=min(1+0.20k,2.5)`,
  HP product clamp 18.0, contact clamp 40.0, existing `minf(12.0,…)` rate (`world.gd:118`) and
  `ALIVE_CAP 400` pause (`world.gd:114`) untouched.
- **Sim:** cycle-5 worst case = rate `minf(12, (1+1.3·15)·2)=12/s` gated by the 400-pause — the
  400-alive sim cannot be broken by any k. Cap-hold claim: **CONFIRMED** (arithmetically, both ceilings).
- **P2-1 (vacuous contact clamp):** re-grepped every enemy `dmg` at `world.gd:25-41`: max base 12
  (warden), normal max 9 (pale-wight). Worst single hit = `12×2.5=30 < 40`; normal-enemy worst
  `9×2.5=22.5`. `MAX_CONTACT_DMG 40.0` NEVER binds on any path, so A-E3's planted-red "drop the
  clamp ⇒ RED" cannot go red — violating the spec's own checklist #4/#7 for this cap. (Ward
  subtraction, `game_state.gd:47-48`, lowers real hits further.)
- **P2-2 (vacuous HP clamp at the pinned leg):** clamp binds iff `(1+0.22·m_c)·(1+0.75k) ≥ 18`.
  At A-E3's own cycle-3 leg the max is `4.3×3.25 = 13.975 < 18` → the clamp never engages; k≤4
  never binds (k=4 max `4.0×4.3=17.2`). Earliest binding is cycle 5 at m_c ≥ 12.7 min
  (`4.75×3.79≈18`). A-E3 asserting "caps binding" at cycle 3 asserts a never-true state, and
  "drop the clamp ⇒ RED" at that leg is inert. The HP cap does have a working red via A-E2's
  low-cap trick — but A-E3 as written cannot go red.
- **P2-3 (un-fun triviality — metric named):** required kill-DPS per spawn ∝ `HP_CYC/QTY` =
  1.0 (k=0) → 2.375 (k=5) → 3.0 asymptote, while the player's DPS growth is HARD-CAPPED by pool
  exhaustion: everything captable ≈ 5 new weapons + 6×7 upgrades + passive stacks/kinds
  (`levelup.gd:26-53`), and the only leftover card is `bonus_card` = "+25 gold, +10 hp"
  (`levelup.gd:57-58,82-83`) — no in-run DPS growth after the cap. With flat DPS the kill:spawn
  throughput ratio falls to ≈0.42 by cycle 5 → alive pins at the 400 cap, death is contact
  attrition (worst contact 80 dps `40/IFRAMES 0.5` is bounded but unhealable at that density);
  meta ranks are between-runs (`powerups.gd MAX_RANK 5`, +200 HP max). Endless is therefore
  ~"a few extra survival cycles", not "indefinite" — and NO ACCEPT row asserts playable
  cycle-reachability (A-E1 pins cycle 2 via scripted warp legs, not survival). Either add a
  per-cycle player-growth row or state the survival-sim intent + a best_cycle reachability row.
- P3-1: "waves restart" overstates — biome bands + GATES rotation are ABSOLUTE-time keyed
  (`world.gd:45`, `render.gd:68-85`; `biome_at` saturates at DEAD TUNDRA/pale-wight), so cycle-2
  m_c=0 spawns are already the hardest composition. Needs a stated reading (reset or saturate).
- P3-2: boss/miniboss latches fire once EVER (`world.gd:53-54,106-112`) → cycles ≥2 have no boss,
  no miniboss, no boss/miniboss chests, no +50g bounty; B.1's source map implies they recur.

### B. Chest-tier farming — no farm loop found (PASS), one dead source
- Roadmap's own arithmetic re-grepped: "≤ ~3 chest rolls available vs 6 evolutions"
  (`PARITY-ROADMAP.md:83`). M1 supply unchanged by M2 (boss 1×1.0 + 2 miniboss ×0.6, `world.gd:15-16`
  ⇒ max 3/cycle-1). M2 adds exactly ONE cycle-clear chest per 900 s (and P3-2 means cycles ≥2 get
  ONLY that one) — rate-bound to 1 per cycle, never a farm.
- Evolution eligibility does NOT re-open: one-transform-per-chest stands (B-T4), and both try_evolve
  and union consumption REPLACE ids in-slot (`evolutions.gd:54`; spec D.1 "removes both bases"), so
  a consumed base can never transform twice. `pending_levels += item_count` drains through the
  bounded `_pick` loop (`main.gd:236-247`). PASS.
- P4-1: source key `event` is dead — event-waves are excluded (§8.5): either drop the key or mark
  it forward-declared. P4-2: `endless-cycle` extends the roadmap's stated M2 #2 source list
  (miniboss/boss/event, `:224`) without a declared divergence row (§6 style).

### C. Gem-merge XP-neutrality — real-sum TRUE, byte-equal CONDITIONAL
- `xp_need = 5+4L+L²` (`game_state.gd:39-40`); `add_xp` `while`-loops multi-level overflow
  (`game_state.gd:99-102`) — a bulk gem of Σxp cannot strand levels. Sum-preservation invariant:
  sound. C-G3 boundedness: merge at ≥200 → −100 +1 ⇒ array ≤200 between bursts: sound.
- **P2-4:** `add_xp` multiplies EACH call by `(1+0.15·insight)·meta_xp_mult` (`game_state.gd:98`).
  IEEE-754: `Σ(xp_i·m) ≠ (Σxp_i)·m` when m≠1.0 — insight ranks and Dawn Well xp ranks SHIP in
  v1.2.0 (`powerups.gd`, shop T-M1f), so on real saves the C-G2 "byte-identical merge-on vs
  merge-off" claim is false, and a boundary flip can differ the level sequence. Fix: pin C-G2 to a
  DECLARED no-rank/insight-0 leg and say so, or restate as exact-sum equality with a boundary test.
- P4-5 (visual): "brighter" bulk gems need per-instance color — current pickup MMs are
  TRANSFORM-format only (`pickup_viz.gd:158-163`); still ONE MM class (claim holds) but the row
  should name the format change.

### D. Union-2 dependency — honest carry, CONFIRMED; two seams need stating
- Spec's premise matches the TABLE ids exactly: `censer-of-hours` `evolutions.gd:30`, `rot-water`
  `evolutions.gd:31`, and union-2's passive `loadstone` is rot-water's OWN evolution partner
  (`evolutions.gd:31`) — so T-M1h (the 10 weapons + 10 partner passives) necessarily carries all
  three. Art already shipped: `tools/vm100/icons-batch-m1c.tsv:6,7,27` (weapon-censer-of-hours,
  weapon-rot-water, passive-loadstone). Union-1 fully buildable today: `halo`+`spike`
  (`weapons.gd:6`), `insight` (`levelup.gd:15`), FX classes `halos`/`bursts` exist. Honest.
- P3-6 (cross-time foreclosure, unnamed): rot-water is BOTH a union-2 base and an evolution base
  (→ the-sluice). A chest that opens with rot-water at MAX + loadstone carried BEFORE censer
  reaches MAX falls through `try_union` and EVOLVES it (evolutions.gd:49-56 iterates any eligible),
  permanently foreclosing Dirge Eternal. D-U3 pins only same-chest precedence. State the reading
  (or reserve union bases in try_evolve).
- P3-7: D-U2's seam cite `sim_boss.gd:215` is wrong — the DECLARED-PIN loadout fn `_pin_full_build`
  is at `sim_boss.gd:288` (:215 is the miniboss-schedule-leg comment); `sim_budget.gd:92` ✓ correct.

### E. Wave map — same-file overlaps mostly caught; ONE table column contradicts the spine
- world.gd is touched by ALL four pillars (A.2, B.2, C.2, D.2) — honestly named; single serial
  spine accepted (the monolith is real and the spec says so). weapons.gd ROSTER↔UNIONS named;
  world.gd:205 chest↔union ordering named. **P2-5:** the T-M2e row's "parallel with" column says
  "gem-merge authoring / assets" — T-M2g edits world.gd (C.2) and T-M2e edits world.gd:84-122
  (A.2), violating the section's OWN same-file rule and contradicting the execution order two
  lines later (which serializes them). As written, the table authorizes the lost-edit build.
- P3-3: A-E7 (cycle HUD text) requires a `hud_3d.gd` edit — absent from A.2 and the T-M2e files
  column. No collision (only endless touches it), but the card's scope line is incomplete.
- P3-4: B.2 lists `tools/chest_pixel_gate.py` + `chest_capture.gd` as **NEW**; both EXIST at
  475a480 (shipped by M1e, LEDGER :25) — contradicts the spec's own §8.7 "reuse" claim.

### F. Budget — "0 new draw classes" HOLDS for every pillar
- Endless: 0 (no viz). Chest tiers: per-instance scale/tint on the EXISTING chest MM
  (`pickup_viz.gd:58,74,96`). Gem-merge: EXISTING gem MM (`:54,70,88`). Unions: reused classes
  verified (`weapons.gd:24,27` + `viz_fx.gd:33-39`); zones MM belongs to T-M1h and is in the
  roadmap's planned-40 already (`:176,:184`). CONTRADICTED-row search came up empty — the claim
  survives re-grep. Caveats: P3-5 below, P4-5 above.
- P3-5: the budget/A.4 alive assertion should read **horde ≤ 400**, not "max-alive ≤ 400 total":
  the shipped-by-design reading is total 403 = cap 400 + the 3 named schedule spawns above the
  guard (LEDGER T-M1g, both readings stated there). A cycle-3 row asserting total ≤400 would
  fight the existing green baseline.

### G. Greenfield claims vs v1 — CONFIRMED by independent re-grep
- `/home/claudecode/Games/vampire_survivor`: `game_state.gd:7` = `WIN_TIME := 600.0` ✓; terminal
  win gate at `main.gd:134` (`if game.time >= GameState.WIN_TIME`) ✓; gems collect individually —
  one `add_xp` per gem, `world.gd:144-148` ✓; repo-wide grep `endless|cycle|merge` over
  `godot/scripts/*.gd`: no functional hits (only an unrelated "merged set" comment, `world.gd:50`).
  v1 implements NEITHER feature; both pillars genuinely greenfield. F-2 is honest.

### H. Contract B snapshot — no field changes, no 13th field; one value-domain note
- 12 fields re-counted (`game_state.gd:125-138`). Per feature: endless/cycle → new GameState vars,
  NOT in the snapshot (A-E6 pins; scope-pin exists `test_dawnwell_shop.py:114`); `best_cycle` →
  dawnwell.json meta save, not the run snapshot (`save.gd:98-99`); chest `tier` → world dict only;
  gem `big`/Σxp → gems array only; phase enum unchanged (endless keeps `playing`).
- P4-6: the `weapons` field's VALUE domain widens (union ids flow into
  `window.__vsSnapshot`, `game_state.gd:122-124,136` + `main.gd:154`). Shape frozen; repo has no
  in-repo consumer whitelisting ids — flag once so the web shell is not surprised. No 13th field.

## 3. Findings register (severity per fleet scope-control; P1/P2 block SHIP)

| id | sev | finding | fix location |
|---|---|---|---|
| P1-1 | P1 | Cycle-clear chest tier CONTRADICTS itself: §A.1 + row A-E4 pin "warden (tier II)"; §B.1 `CHEST_TIER_BY_SOURCE` (`endless-cycle/event → "dawn"`) + row B-T1 pin tier III. Two ACCEPT rows execute incompatible behavior at the same drop site (item_count 2-vs-3, gold 15-40 vs 40-90). | §A.1 L104-105, A-E4; §B.1 L155-156, B-T1 — pick ONE tier, align all four places |
| P2-1 | P2 | `MAX_CONTACT_DMG 40.0` unreachable (max base dmg 12 × DMG_CYC 2.5 = 30 < 40; normal 22.5) → A-E3's planted-red cannot go red; violates checklist #4/#7. | §A.1 damage cap (value under ~24, or retire clamp + red), row A-E3 red column |
| P2-2 | P2 | `HP_EFFECTIVE_MULT_CAP 18.0` never binds at A-E3's pinned cycle-3 leg (max 13.975; k≤4 max 17.2; first binds cycle 5 m_c≥12.7). "Caps binding" + "drop the clamp ⇒ RED" are inert at cycle 3. | row A-E3 — re-leg to cycle 5+ (HP side) or move the binding assertion to A-E2's low-cap red |
| P2-3 | P2 | Endless fun-metric break: required DPS/spawn = HP_CYC/QTY rises 1.0→2.375 (cycle 5) →3.0 while in-run DPS growth hard-caps at pool exhaustion (bonus_card = gold+hp only, `levelup.gd:57-58,82-83`); throughput ratio ≈0.42 by cycle 5, alive pins at 400, no ACCEPT row pins playable cycle reachability. | §A.1 — add a per-cycle player-growth row OR declare survival-sim intent + a reachability ACCEPT row |
| P2-4 | P2 | C-G2 "byte-identical" XP claim false under insight/meta-xp multipliers (per-call multiply, `game_state.gd:98`; IEEE Σ(a·m)≠(Σa)·m); true only at multiplier 1.0. | §C.1 XP-neutrality + C-G2 — DECLARED-pin the multiplier-1.0 leg and say so, or restate exact-sum equality |
| P2-5 | P2 | Wave-map self-contradiction: T-M2e card row says "parallel with: gem-merge authoring" while both cards edit `world.gd` — violates the §5 same-file rule and contradicts the same section's serial execution order. | §5 card table, T-M2e "parallel with" column → "asset batch only" |
| P3-1 | P3 | "Waves restart" overstates: biome/GATES rotation absolute-time keyed; `biome_at` saturates on the hardest band (`render.gd:80-85`) — cycle-2 start is already hardest composition. | §A.1 stated reading |
| P3-2 | P3 | Boss/miniboss latch-once (`world.gd:53-54,106-112`) → cycles ≥2: no bosses, no miniboss chests, no +50g; B.1 source map implies recurrence. | §A.1/§B.1 — name the latch consequence (or a re-arm row) |
| P3-3 | P3 | A-E7 needs `hud_3d.gd`; file absent from A.2 and the T-M2e card files column. | §A.2, §5 T-M2e row |
| P3-4 | P3 | B.2 marks `chest_pixel_gate.py`+`chest_capture.gd` NEW; both exist (M1e) — contradicts §8.7. | §B.2 |
| P3-5 | P3 | "max-alive ≤ 400" should be horde-≤400: shipped design total is 403 (cap + 3 schedule spawns, LEDGER T-M1g). | §7 alive-ceiling bullet, §A.4 A-E3 wording |
| P3-6 | P3 | rot-water evolution (→the-sluice) can permanently foreclose union-2 cross-time; D-U3 pins only same-chest precedence. | §D.1 stated reading (or reserve union bases in try_evolve) |
| P3-7 | P3 | D-U2 seam cite `sim_boss.gd:215` wrong — `_pin_full_build` is `sim_boss.gd:288`. | row D-U2 |
| P3-8 | P3 | §8.3 RETIRES the roadmap-named M2 #1 sub-feature "Reaper analogue at the non-endless limit" (`PARITY-ROADMAP.md:221-223`) on the spec's own design reason — the only roadmap sub-feature neither deferred-to-a-card nor owner-quoted; roadmap rev3 is law. | §8.3 — route as follow-on card or quote an owner ruling |
| P4-1 | P4 | Dead source key `event` (events excluded §8.5). | §B.1 |
| P4-2 | P4 | `endless-cycle` chest source extends roadmap M2 #2's list without a declared divergence row. | §B.1/§6 style |
| P4-3 | P4 | "HD3D_OUT" misnamed as THE channel — sim-leg precedent is `HD3D_<LEG>_DUMP`+`HD3D_SEED`; `HD3D_OUT` exists only in sim_headless/sim_s8. | §A.2/§7/§8.7 wording |
| P4-4 | P4 | A-E6 "committed dump": s8 gameover/win dumps live in `.tmp/` (`s8_acceptance.py:31-33`) — name the committed fixture the byte-identical row lands in (B.2 does; A doesn't). | §A.4 A-E6 |
| P4-5 | P4 | Bulk-gem "brighter" needs per-instance color (MMs are transform-format, `pickup_viz.gd:158-163`) — still one class; name the format change. | §C.1/§C.2 |
| P4-6 | P4 | Contract B `weapons` field value-domain widens with union ids (shape unchanged; no in-repo consumer). | §0 F-3 one-line note |
| P4-7 | P4 | D.1 "GATE_T reused from evolutions.gd:19" — name the mechanism (reference `EvolutionSystem.GATE_T`, not copy the 600). | §D.1 |

## 4. Stated readings of ambiguity (reviewer's, in lieu of inventing rulings)

- The brief's v1 path (`Games/vampire_survivor`) is the 2D original; the M2 spec itself lives in
  `hollow_dawn_3d` — the reviewer took the spec target as the 3D repo (where 475a480 resolves) and
  the v1 path literally, matching the spec's own F-2. No contradiction found.
- The serial spine is NOT counted as a finding: the spec names the world.gd monolith and its
  consequence honestly; the finding is only the table column that contradicts it (P2-5).
- "Un-fun triviality" was scored per the brief with one named metric (kill:spawn throughput ratio
  under flat post-cap DPS), not vibes.

## 5. Verdict rationale

One P1 (self-contradicting chest tier for the cycle clear — two ACCEPT rows, incompatible outputs)
and five P2s (two vacuous planted-reds that break the spec's own "every gate can go RED" law, one
fun/economy break, one false byte-equality claim, one wave-map self-contradiction). The
decomposition itself is sound — four self-contained pillars, one named seam per row, an honest
F-1 — so this is a FIX, not a RECONSIDER: repair §A.1/§B.1/A-E3/A-E4, §C.1/C-G2, §5 table, plus
the P3 wording rows. F, G, H and checklist rows 1/2/3/6/8/9 hold as verified.

# VERDICT: FIX
