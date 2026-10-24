# M2-SPEC-DA-c2 — cycle-2 adversarial gate on `docs/M2-SPEC.md` REV 2 @ `d57c9b4` (MC 11232, DA c2)

- **Reviewer:** devils-advocate (11232). Target: `docs/M2-SPEC.md` rev-2 @ `d57c9b4` (design card
  11219 cycle-2). History: c1 FIX @ `c1cfc12` (`docs/M2-SPEC-DA.md`, immutable) — P1×1, P2×5, P3×8,
  P4×7; producer claims ADOPTION IN FULL, no rebuttals. This review tests that claim, then attacks
  the NEW rev-2 material only, then regression-scans.
- **Line anchors** are `file:line` at `d57c9b4`, re-grepped by THIS reviewer (not carried from c1).
- **Master moves:** at review start `origin/master == d57c9b4` (the target IS the tip; local refs
  were stale, fetched). Roster-wiring card 11220: NOT on master at grep time; per the brief its
  premise (F-1) is already actioned by that card and is NOT re-opened here. If master moved under
  this review the commit chain records it; code greps are pinned to `d57c9b4` regardless.

## 1. PASS 1 — ADOPTION AUDIT (per c1 finding: landed / partial / missing, reviewer-regrepped)

| c1 id | status | evidence (rev-2 section; code re-grepped at d57c9b4) |
|---|---|---|
| P1-1 | **landed** | §A.1 defers the cycle-clear tier to `CHEST_TIER_BY_SOURCE` ("the single source of truth"); A-E4 asserts "tier-`dawn` (III) … per `CHEST_TIER_BY_SOURCE`"; B-T1 asserts cycle-clear/event→dawn; §B.1 map row `endless-cycle → "dawn"` → tier table dawn(III)=3 items/40–90 g. All four places execute the SAME behavior from the SAME row. Diff proof: `git diff 475a480..d57c9b4` deletes the rev-1 warden/II wording (diff L83-/107+/167+/183+). |
| P2-1 | **landed** | §A.1 + checklist 4 + §8.4 all carry `MAX_CONTACT_DMG := 20.0`; provenance sentence names warden base 12. **Re-derived HERE:** `world.gd:35` = `"warden" … "dmg": 12.0` (VERIFIED); deacon 11 (:41), knight 10 (:40), pale-wight 9 (:34). 12×DMG_CYC: k=3→19.2 <20, k=4→21.6 >20 — boss class binds cycle ≥4 ✓; pale-wight binds only k≥7 (9×2.4=21.6) ✓; A-E3's cycle-5 red (12×2.0=24>20, drop clamp ⇒ dump value 24 ⇒ RED) is a REAL red ✓. |
| P2-2 | **landed** | A-E3 re-leggged to a DECLARED-PIN scaling-eval at cycle 5; A-E2 carries the low-cap(6) red. **Math re-run:** binding iff `(1+0.22·m_c)·HP_CYC(k) ≥ 18`; k=5: HP_CYC=4.75 ⇒ m_c ≥ (18/4.75−1)/0.22 = 12.68 ⇒ "cycle 5, m_c ≥ 12.7" ✓ (cycle is 900 s = 15 min, reachable); k=4 max 4.0×4.3=17.2 <18 ✓ never binds k≤4 ✓. Both clamps bind at 5 (HP 18.02>18 at the pinned m_c; contact 24>20) ✓ — matches the row. Seam exists: `sim_budget.gd:92` pin write, `sim_boss.gd:292` pin write (see P3-7). |
| P2-3 | **landed** | §A.1 survival-sim intent + across-run Dawn Well growth + M4 `limit-break-lite` reserved + A-E8 reachability row. Roadmap ACCEPT quoted exactly ("sim endless leg ≥ 2 cycles", `PARITY-ROADMAP.md:221-223` VERIFIED verbatim); growth channel real (`powerups.gd:24 MAX_RANK 5`; `game_state.gd:63` maxHp = 100 + Σ·10 leg VERIFIED); pool-exhaustion cite VERIFIED (`levelup.gd:57-58` bonus_card "+25 gold, +10 hp"). |
| P2-4 | **landed** | §C.1 restates: unconditional gem-layer Σxp conservation + byte-equal ONLY at pinned m=1.0; C-G2 split (a)/(b). **Code agrees:** `game_state.gd:98` = `xp += amount * (1.0 + 0.15 * passives.insight) * meta_xp_mult` (VERIFIED); the multiplier is applied in `add_xp` AT COLLECT (`world.gd:183` = `game.add_xp(g.xp)`), gems carry RAW xp — so merge-at-gem-layer conserves Σxp unconditionally: the restatement is TRUE, not just better-worded. Red (b) at m≠1.0 declared honest ✓. |
| P2-5 | **landed** | §5 card table: every build card's parallel column = "asset batch ONLY"; execution order = ONE serial spine, "no two build cards are parallel"; file-graph paragraph names all four shared files. Rev-1's T-M2e "parallel with: gem-merge authoring" is gone (diff-verified). Residual asset-track ambiguity re-attacked under PASS 2 → N3 (P3, does not reopen P2-5). |
| P3-1 | **landed** | §A.1 "rev-2 P3-1 reading": ramp-restart-not-roster, absolute-time keying named. `world.gd:45` GATES VERIFIED; `render.gd` biome_at saturates on DEAD TUNDRA (last band, VERIFIED code returns last match, no later band) — claim holds; the parenthetical's new citation is sloppy → N2 (P4, new). |
| P3-2 | **landed** | §B.1 bullet "boss/miniboss entries apply CYCLE 1 only"; cites `world.gd:53-54,106-112` — VERIFIED exactly: vars :53-54, one-shot latch block :106-112 (`minibosses_spawned += 1 # latch first` :112). Named consequence matches B.1's chest-source map reading. |
| P3-3 | **landed** | `hud_3d.gd` added to §A.2 AND the T-M2e card row (diff L144/343); file exists in tree (9,065 B) ✓. |
| P3-4 | **landed** | §B.2 relabels `tools/chest_pixel_gate.py` + `godot/sim/chest_capture.gd` as REUSE, "SHIPPED in M1e"; both files EXIST at d57c9b4 (verified) ✓; aligns §8.7. |
| P3-5 | **landed** | §7 now reads horde ≤ 400, "shipped worst-case is 403 = cap + 3 named schedule spawns"; LEDGER T-M1g row VERIFIED carrying exactly that both-readings wording ("HORDE 400 … total 403 … both readings stated"). |
| P3-6 | **landed** | §D.1 RESERVE rule + D-U5 row. Premise VERIFIED: `evolutions.gd:31` rot-water→the-sluice partner `loadstone` (dual role real); `try_evolve` iterates any eligible weapon (`evolutions.gd:49-56` VERIFIED) so cross-time foreclosure was real; reserve + D-U5 red close it. |
| P3-7 | **landed** | D-U2 seam now `sim_boss.gd:292 / sim_budget.gd:92`. Adjudicated at d57c9b4: `_pin_full_build` is defined at :288, its DECLARED-pin write is at :292 — c1's fix said :288, producer's own grep landed on :292; BOTH point at the same seam, and :292 is style-consistent with how `sim_budget.gd:92` (pin write line) is cited. :215 gone. Noted, not a finding. |
| P3-8 | **landed** | `T-M2r-REAPER` tracked as a follow-on card (§A.1 + §8.3 + checklist 10), explicitly NOT excluded; roadmap-is-law row VERIFIED verbatim at `PARITY-ROADMAP.md:221-223` — the Reaper sub-feature is genuinely named there. Tracked-as-card, not silently dropped ✓. |
| P4-1 | **landed** | §B.1 `event` forward-declared, "reserved, not live" (events excluded §8.5) ✓. |
| P4-2 | **landed** | §B.1 declares `endless-cycle` a divergence from roadmap `:224` ("miniboss/boss/event" VERIFIED verbatim) ✓. |
| P4-3 | **landed, with new defect** | Per-leg `HD3D_<LEG>_DUMP` + `HD3D_SEED` wording; precedents VERIFIED (`sim_evolve.gd:59`, `sim_budget.gd:53`, `sim_caps.gd:43`). But the new sentence "the shared `HD3D_OUT` name is only sim_s8's" is FALSE — `HD3D_OUT` also at `sim_headless.gd:76` (VERIFIED). c1's own P4-3 named both legs. → N1 (P4, new). |
| P4-4 | **landed** | A-E6 names committed fixture `tests/fixtures/endless-m2.jsonl`; s8 dumps ARE in `.tmp/` (`s8_acceptance.py:31-33` VERIFIED); naming matches existing fixtures (`chests-evolve-m1e.jsonl` exists) ✓. |
| P4-5 | **landed** | §C.1/§C.2 name the transform→color-instance format change; `pickup_viz.gd:158-163` TRANSFORM_3D-only VERIFIED; "still ONE MM class" preserved ✓. |
| P4-6 | **landed** | §0 F-3 value-domain note; `game_state.gd:122-124,136` weapons rows + `main.gd:154` `window.__vsSnapshot` VERIFIED ✓. |
| P4-7 | **landed** | §D.1: union.gd REFERENCES `EvolutionSystem.GATE_T`; const exists `evolutions.gd:19` (`GATE_T := 600.0`) ✓ no second literal. |

**Adoption tally: 21/21 landed** (P4-3 landed but introduced one new false sentence — counted
under PASS 2 as N1, not as an adoption failure: the fold's actionable rule is correct).

## 2. The five critical checks the brief named (each independently computed/regrepped)

1. **P1 unification:** A-E4 and B-T1 assert the same tier (dawn III) from the same
   `CHEST_TIER_BY_SOURCE` row; §A.1 names the map as THE source of truth. PASS.
2. **MAX_CONTACT_DMG 20 re-derivation:** warden base 12 at `world.gd:35` VERIFIED; 20 binds the
   boss class from cycle 4, normals from 7; A-E3's cycle-5 red trips. PASS.
3. **A-E3 cycle-5 math re-run:** HP 18× and contact 20 BOTH bind at cycle 5 (HP at m_c ≥ 12.7 —
   inside the 15-min cycle; contact from cycle 4); nothing binds at cycle 3/≤4. Spec text matches.
   PASS.
4. **A-E8 exists with a REAL HP-pin channel:** `sim_s8.gd` HD3D_HP_PIN read :69, applied :83
   (`game.hp = game.max_hp # DECLARED deviation, S6 kill-leg precedent`), sim_boss kill-leg
   hp-pins :107/:235 — all VERIFIED at d57c9b4. `sim_boss.gd:215` (roadmap-era stale pin) not used.
5. **Wave map = one serial spine:** table column test run — the only remaining "parallel with:
   everything" claim is the asset batch (T-M2a); one pair (T-M2a ∥ T-M2u) still shares the `assets/`
   subject (→ N3, P3). No two BUILD cards claim parallel with overlapping files. PASS-with-P3.

## 3. PASS 2 — NEW-CONTENT ATTACK (rev-2 material only)

- **A-E8 honest-limit claim:** "un-pinned survival DEPTH is explicitly NOT claimed" is present,
  and the supporting statement ("the s8 header records seeds dying at t 375–467 under the 12/s
  wall") is TRUE: LEDGER T-S8 row VERIFIED — "seeds 11101-11106 all die t=375..467 (12/s endgame
  wall … driver-survival property)" and HD3D_HP_PIN named as the ONE declared deviation. The row
  claims reachability, not balance. HONEST. (One unspecified mechanic → N5.)
- **A-E2 low-cap red leg:** cap 6 ⇒ cycle-1 clamp engages at m_c ≥ 11.0 (inside 15 min), the
  scaling dump diverges from the cap-18 fixture ⇒ RED. Same trick c1 proved working; correctly
  relocated. SOUND.
- **Gem-merge restatement vs code:** VERIFIED against `game_state.gd:98` (per-call multiply) and
  `world.gd:183` (multiplier applied at collect, gems store raw xp) — the unconditional Σxp claim
  is code-true, the byte-equal restriction to m=1.0 is required and stated. TRUE-AS-WRITTEN.
- **§10 changelog vs actual diff:** sampled 7 rows (P2-1 cap value across A.1/§8.4/checklist 4;
  P1 four-place unification; P2-2 A-E3 rewrite; P3-3 hud_3d both places; P3-7 seam swap incl. the
  `sim_evolve.gd:114-130`→`sim_budget.gd:92` second-seam change, which the changelog's P3-7 line
  does not separately name but which matches the adopted c1 note "sim_budget.gd:92 ✓ correct";
  P3-5 §7 rewrite; P4 folds list). All seven match the diff; no changelog row claims a change the
  diff lacks. CLEAN.
- **T-M2r-REAPER:** tracked-as-card with the roadmap-is-law row VERIFIED (`:221-223`), not an
  exclusion. Not in the §5 build table — correct, it is deferred and flagged for the closing seat
  (checklist 10); it is not a wave card. LANDED.
- **Rev-2 header claim check:** "attacks F/G/H and checklist rows 1/2/3/6/8/9 held as VERIFIED"
  matches c1's tally (6 verified / 3 partial / 1 contradicted + F/G/H pass). ACCURATE.

## 4. PASS 3 — REGRESSION SCAN (c1-surviving rows vs the diff)

Budget rows (`27 / plan 40 / hard 60`, DRAWS_PLANNED 40 pin `test_art_integration.py:21-22,42`),
checklist rows 6/8/9, §0 F-2/F-3 greenfield+Contract-B readings, §7 verdict line: diff shows ONLY
the adopted additions on them (P3-5 horde/403 wording, P4-6 note, checklist 6/8/9 parentheticals
pointing at landed fixes). No verified row lost its substance. Spec test-pins re-grepped:
`test_biome_numbers.py:149` (`< 16.0` count == 4) and `:231` (6-weapon pin), `test_card_icons.py`
:29/76/112/113 + :125 (12-icon row), `test_dawnwell_shop.py:114` — ALL EXIST as cited. NO
REGRESSIONS.

## 5. New findings (rev-2 content; severity per fleet scope-control; NONE blocks this gate)

| id | sev | finding | fix location |
|---|---|---|---|
| N1 | P4 | §A.2 states "the shared `HD3D_OUT` name is only `sim_s8`'s (`sim_s8.gd:54`)" — FALSE: `sim_headless.gd:76` also reads `HD3D_OUT` (VERIFIED; c1's own P4-3 named both legs). Actionable rule (sim_endless declares its own `HD3D_ENDLESS_DUMP`+`HD3D_SEED`) is unaffected. | §A.2 sentence → "`HD3D_OUT` is sim_headless/sim_s8's shared legacy name" |
| N2 | P4 | §A.1 P3-1 parenthetical cites `render.gd:76, band 3 t=6.0` — the last biome band is DEAD TUNDRA at `t_start: 450.0` (render.gd:75-76 VERIFIED); `6.0` is the world.gd:45 GATES minute value. Saturation claim itself HOLDS (no band 4; "for all t≥720" is a true subset of t≥450). | §A.1 — cite `t_start 450.0`, keep the GATES name on the world.gd cite |
| N3 | P3 | Wave-map residual: T-M2a claims "parallel with: **everything**" while T-M2u's files column includes `assets`, and D-U6/D-U7 (budget GLB-pin + union-icon pixel leg) consume the very icon/mesh rows T-M2a generates "throughout" — no depends-on names T-M2a completion. If T-M2a's batch (incl. the +3 re-roll reserve) lands after T-M2u runs, those legs go RED. Files are per-asset-unique so this is a scheduling RED risk, not a lost-edit risk (hence P3, not P2). | §5 — T-M2u depends-on += "T-M2a union-icon/mesh rows"; T-M2u files → "assets (from T-M2a, sequenced)" |
| N4 | P4 | The producer's `--- RESULT ---` handback block leaked INTO the committed spec (M2-SPEC.md :538-544) — harness chatter in a product doc; the trail belongs on MC 11219. One-subject-per-doc hygiene. | strip the block (can ride the landing commit; no new producer cycle needed) |
| N5 | P4 | A-E8 mechanics gap: an HP-PINNED leg never dies, so `best_cycle=2` needs a named leg end — un-pin after the second clear ⇒ real gameover ⇒ `_end_run` records it; and A.3's "(both `gameover` and endless clear)" is ambiguous (a cycle clear does NOT call `_end_run`). Reading taken: update best_cycle at every `_end_run`, kind-agnostic. State one sentence in A-E8. | §A.3 parenthetical + §A.4 A-E8 |
| N6 | P4 | §7 asserts "the worst-case cycle-5 leg re-asserts horde ≤ 400" but no ACCEPT row names a cycle-5 ALIVE assertion (A-E3 pins clamps only; A-E2 dumps k≤3; A-E8 stops at cycle 2). Substantively safe — the 12/s + 400 ceilings are untouched and the existing sim_caps baseline holds by construction (INFERRED) — but the sentence points at a leg that doesn't exist. | §7 — add a horde-alive row to A-E3's dump, or cite the sim_caps re-run |

## 6. Stated readings of ambiguity (reviewer's, in lieu of inventing rulings)

- **c1 :288 vs rev-2 :292 for sim_boss:** read as the same seam (function start vs its DECLARED-pin
  write); rev-2's choice matches the sim_budget:92 citation style and the producer's stated own
  grep. Accepted; recorded above.
- **F-1 / roster card 11220:** per the dispatch brief F-1 is already actioned by that card; NOT
  re-opened. The spec's "flagged, not assumed" stance remains the correct posture until the card
  lands; grep-time master state recorded in the header.
- **v1 cite `world.gd:144-147`** (excludes the add_xp line at v1 :148): pre-existing rev-1 wording,
  unchanged by rev-2 (diff context line), and c1's attack G already verified the substance. Not
  re-scored in cycle 2.
- **N3 P2-vs-P3 line:** P2-5's violation authorized a same-FILE parallel pair (lost edits); N3's
  overlap is a generated-asset directory + an unnamed soft dependency (a leg goes RED and blocks,
  it cannot silently lose an edit). Classed P3 by that difference, deliberately.

## 7. Verdict rationale

All 21 c1 findings LANDED, each re-grepped by this reviewer at `d57c9b4` — including the three
where a partial adoption would have been easy to fake (P1 four-place tier unification, P2-1's
reachable-cap re-derivation off the real warden row, P2-2's cycle-5 binding math, which this
reviewer re-computed independently: HP first-binds at m_c ≥ 12.68 inside cycle 5, contact binds
from cycle 4). The rev-2 new content carries NO P1/P2: the A-E8 reachability row rests on a real
shipped HP-pin channel and an honest LEDGER death-record, the gem-merge restatement is code-true
at `game_state.gd:98` + `world.gd:183`, and the changelog matches its diffs on all seven samples.
Six new findings: one P3 (wave-map asset-track scheduling gap, N3) + five P4 wording/hygiene rows —
none gates the M2 wave's authorization per the spec's own ACCEPT rows; all are cheap and can ride
the landing commit or the build cards that touch the sections. M2 wave: AUTHORIZED to build per §5
spine + ACCEPT rows.

# VERDICT: SHIP
