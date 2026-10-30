# BYTE-DEVIATION-M6.md — the M6 committed-corpus deviation pin (T-M6d, MC 11675)

- **What this file is (M6-SPEC §9, filed FIRST per F-9 — the RIG-DEVIATION-SEL-C
  pinned-deviation precedent, MC 11440/B-E8/K-E3):** M1–M5 shipped byte-identical;
  M6 legitimately shifts committed channels BY DESIGN (pool math §4.4 R1, the F3
  trigger move, the F5 coin magnet, the F6 sigil drops, the F1/F2 visual law).
  A shift CLOSES green only against a row of THIS doc; an unregistered shift is a
  FAIL exactly as an unexplained byte moved in M1–M5. The instrument: each card's
  capture records the per-channel before/after digest + a row-level diff for the
  shifted channels; the standing leak check re-runs the WHOLE corpus — channels
  this doc does not name must still `cmp` identical.
- **The base (pre-edit, pristine, re-dumped by every shifting card's battery):**
  `origin/master = acd00f1` (T-M6-AMEND, the REV-4 owner-ruling amendment — feat/m6d
  REBASED onto it per the wave steering; spec base 290534f→acd00f1, a DOCS-ONLY delta —
  code-identical proof recorded in the card capture: `git diff 290534f..acd00f1 -- godot
  tests tools` is EMPTY, so the pristine base worktree's dumps built on the 290534f code
  stand as the acd00f1 base dumps, stated here in-file). Journey:
  `sim_headless` @`HD3D_SEED=11101` (the 5020-row corpus, `sim_headless.gd:104`);
  strict fixtures: the committed `tests/fixtures/*.jsonl`; strips: modulo the
  declared mechanical norm (engine `_ms` fields + capture-dir png prefixes only);
  s8: the A1 contract rows (runtime records, contract-checked, not byte-checked).
- **OWNER RATIFICATION (rule-2 artifact, verbatim, per REV-4 §9 MC 11674):** the
  owner's reply to the M6 owner package (web UI, 2026-10-29), verbatim — typos
  intact, the artifact is pasted, never corrected:
  **"Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy"**.
  The declared reading (REV-4 header ledger): the reply answers the package items in
  order — 1 → §1.5, 2 → §4.2 (the clear carve: bosses + MINIBOSSES + the REAPER
  survive; sigil-counter eligibility rides this ONE ruling, NF-5), 3 → §8 (v3.1.0
  ships), **"Ratufy" → §9 (the byte-deviation table)**: the REV-3 16-row table is
  RATIFIED AS-IS (SHIFTS-class 5 / AT-RISK 6 rows-7 channels / STAY 5 — no row
  moved). THE FOOTER FORMAT, binding on this first commit: every declared
  SHIFTS/REMINT/RE-DERIVE channel's OWNER-RATIFICATION cell carries the verbatim
  quote + the date in REV-4's exact format — the cell below IS that format; a
  NON-EMPTY cell is the SD-E6 gate contract, the verbatim quote is the content. Per §9 the ASK TEXT derived from
  the REV-3 table (the pre-REV-3 "~4 SHIFTS, 5 STAY" draft is RETIRED — the
  c2 dissent: presenting the owner a premise the code refutes manufactures
  consent); this doc's table IS the REV-3 table, 16 rows.
- **SD-E6 (the ratification gate's instrument, `tests/test_sigil_drop.py`):**
  the footer table parses; every channel row whose VERDICT cell contains
  SHIFTS / REMINT / RE-DERIVE (case-insensitive) must carry a NON-EMPTY
  OWNER-RATIFICATION cell before the shifting card closes. STAY rows carry
  `n/a — no shift` and need nothing. Planted red (named in the row): an EMPTY
  ratification cell on a declared shift ⇒ the leg RED (proved on a COPY — this
  committed doc is never mutated; capture `.tmp/m6d.txt`).

## Per-channel sections (the §9 REV-3 table, one section per row; MEASURED rows
are filled by T-M6d's battery: pristine base worktree @ 290534f re-dumped vs the
final T-M6d tree, `cmp` per channel, row-level diffs recorded)

### 1. journey-5020 @11101 — pre-declared SHIFTS (T-M6d; F3-pool/F5/F6 mechanisms)
- Shifting card: T-M6d. Mechanism: removing a pool id forks `make_offer`'s
  `pool.shuffle()` (levelup.gd:119 — any pool-size change forks every committed
  offer stream); the F5 coin-magnet moves gold-at-step rows; F6 sigil drop
  (zero-RNG) + any touch CLEAR forks the kill stream after that step. Re-anchor:
  NEW committed journey digest @11101; the 5020 name becomes journey-M6 N rows
  (N re-pinned at card time); the old digest is archived as this doc's
  before-row (git history at 290534f).
- MEASURED (T-M6d battery): base tree @11101 re-dump BYTE-EQUAL the committed 5020-row
  expectation (base==committed proven FIRST, capture .tmp/m6d.txt); mine tree 5061
  rows, first divergence ROW 2 — the draws row pickups 5->6 total 27->28 (the §10
  re-tally, declared); all_weapons_killed legs 15; the four sigil/magnet legs
  ok:true; zero false rows; zero SCRIPT ERROR. Journey is capture-side (NOT a
  fixture) — the committed expectation RE-ANCHORS 5020->5061 here, in-row.

### 2. `carry-caps-m1b.jsonl` — pre-declared SHIFTS (offer-stream channels)
- Shifting card: T-M6d. Mechanism: pool 16→15 forks the shuffle wherever the leg
  draws offers; re-anchor where the leg reads offers, STAY where it reads caps
  dumps — per-ROW measured diff recorded here. The 64 rows carrying the
  `doom-sigil` id are §4.1's named KEEP-vs-re-anchor resolution (P4-2: the id's
  rows move HERE; the file is NOT an edit site).
- MEASURED: SHIFT CONFIRMED — 500 of 715 rows differ (first@204, the offer-stream
  fork); caps_verdict ok:true; doom-sigil mentions 64->0 (id rows re-anchored, the
  §9.2 claim quantified). REMINTED from the mine tree; base==committed proven
  BYTE-EQUAL first.

### 3. `chests-evolve-m1e.jsonl` — REMINT (T-M6p)
- Shifting card: T-M6p (the fixture's OWN subject moves: chest trigger → level
  trigger, table 10→9, GATE_T retired). The 9-row both-sides truth re-mints at
  T-M6p; the union/precedence rows keep their legs (PS-E3's DIRECT-arm legs
  prove the UNtouched lines byte-true — the REV-1 "STAY pair" wording retracted,
  P1-2). T-M6d's pool change ALREADY forks this channel's funnel-fed legs —
  the same fork the REMINT covers; recorded, not re-minted, at T-M6d.
- MEASURED: FORK RECORDED AND RE-MINTED HERE — the pool retirement is a consequence
  of THIS card, so its two rows move with it in this commit: evo_pool_reachability
  carries the retirement claim (base NOT offered, partner still offered — passives
  stay 15); evo_full_doom-sigil RETIRED with the pool entry (no real _pick can ever
  acquire the base — the leg would test a route the game no longer has). doom
  mentions 4->2 (both remaining mentions ARE the retirement claim). T-M6p's TABLE
  retirement re-mints this channel again at its own card — ownership unchanged.

### 4. `chests-tiers-m2.jsonl` — pre-declared SHIFTS, per-row diff (REV 2 P1-2)
- Shifting card: T-M6d. Mechanism: it IS a strict-corpus byte consumer of the
  FORKED stream — `sim_chest_tiers.gd:23-30` opens the REAL `collect_pickups`
  per tier; `:90/:190/:270` drain 240 weighted picks per tier through the real
  `make_offer` + `wire_pick` + `run._pick`. T-M6d's pool 16→15 changes the
  weapon-filtered pool SIZE ⇒ `pool.shuffle()` consumes a DIFFERENT RNG count ⇒
  the legs' card streams AND the byte-dumped pick sequences move.
- MEASURED: SHIFT — 4 rows differ; the per-tier 240-pick counts move weapon
  124->123 / passive 64->65 (the retired weapon's weight falls to a passive — the
  P1-2 mechanism, exactly); chest_tiers_verdict ok:true; REMINTED; base==committed
  proven BYTE-EQUAL first.

### 5. `unions-m2u` + `limit-m4` — AT-RISK (measured at card time, REV 2 P2-4)
- Both sims read the REAL funnel: `sim_union.gd:15` full legs acquire EVERY
  part through real `make_offer` + `_pick` (pick ORDER over the forked stream
  moves the dumped sequences ⇒ EXPECTS SHIFTS). LIMIT: the byte producer is the
  UNKINDED `limit_all_maxed` main-funnel leg (`limit-m4.jsonl:1`; the KINDED
  `make_offer(game, kind)` calls never reach the LIMIT_CARDS arm — `kind == ""`
  only, `levelup.gd:117-118`, REV 3 NF-6); the PINNED exhausted pool shuffles
  LIMIT_CARDS (size 3, unchanged by 16→15) ⇒ the shuffle fork need NOT touch it.
  Per-row `cmp` at card time records the verdict BEFORE the owning card closes.
- MEASURED (the pair, per-channel honest outcomes, REV 2 P2-4): unions-m2u SHIFT —
  3 rows (the full legs read the forked offer stream), union_verdict ok:true,
  REMINTED. limit-m4 BYTE-EQUAL — the pinned-exhausted all-maxed stream is
  seed-independent and survived the retirement UNCHANGED; STAY, measured.

### 6. `endless-m2.jsonl` — AT-RISK → EXPECTS SHIFTS (REV 3 NF-1)
- BYTE EVIDENCE (§9 NF-1 row): `sim_endless.gd:95` wires the funnel and the
  fixture DUMPS `"phase":"levelup"` rows — an offer is `make_offer`'d (the
  shuffle consumes RNG at `levelup.gd:119`) BEFORE any decline ⇒ the shuffle
  fork (IDS 16→15) is consumed INSIDE this byte-dumped leg; every downstream
  `randf()` rides the forked stream. Per-row `cmp` records the verdict.
- MEASURED: BYTE-EQUAL — the REV 3 "EXPECTS SHIFTS" expectation is FALSIFIED by
  measurement, and the falsification is the honest row: the decline-path offer
  draws never surface in the dumped bytes (shuffle advances identically to base —
  measured, not argued). STAY stands.

### 7. `events-m4.jsonl` — AT-RISK → EXPECTS SHIFTS (REV 3 NF-1)
- BYTE EVIDENCE: `sim_events.gd:114` wires the funnel; the fixture dumps an
  RNG-DEPENDENT digest (`digest_off_end`, the leg's check IS `rng_stream`) ⇒
  the forked shuffle count + different `_pick(0)` draws move every dumped field
  that rides `randf()`. c3-P4 honest correction (T-M6d re-measure, this
  battery): the `digest_off_end` `types[]` array carries **45** entries on the
  290534f base bytes — the spec's "47 entries" cite at §9 is the drifted half;
  the 45-vs-47 delta is a spec-cite erratum, not a code fact (the digest moves
  either way; recorded here per the honest-verdict law).
- MEASURED: SHIFT as EXPECTED — 4 rows (the digest leg's rng_stream-fed fields
  move); REMINTED. Digest types[] = 45 on BOTH trees (the c3 P4 correction
  restated: spec §9 said 47; measured 45 — the doc, not the spec, carries the
  truth).

### 8. `stages-m3.jsonl` — AT-RISK → EXPECTS SHIFTS (REV 3 NF-1)
- BYTE EVIDENCE: `sim_stages.gd:111/:521` wire the funnel and the cairns leg
  DUMPS THE SEAM ITSELF (`offer_drew_three_cards`) ⇒ the forked pool draws
  DIFFERENT cards, `apply_offer` lands different state. Per-row `cmp` records.
- MEASURED: SHIFT — draw_tally 5/5/6 -> 6/6/7 (the sigil MM rides EVERY stage — the
  §10 27->28 fact, same mechanism) plus the offer-fork rows; stages_verdict
  ok:true; REMINTED; sim_stages keys renamed stage1_six/stage2_six/stage3_seven
  with provenance notes, test_s7 re-pinned in-row.

### 9. `reaper-m4.jsonl` — AT-RISK (per-row `cmp` decides, REV 3 NF-1)
- Funnel wired (`sim_reaper.gd:102/:125/:245`), level-ups CERTAIN at run length;
  the dumped fields are SCHEDULE-driven but the forked stream moves every
  earlier `randf()` (spawn positions → contact timing → arrivals). The cmp, not
  a paragraph, decides.
- MEASURED: BYTE-EQUAL — the reaper guard sits at the SAME seam VERBATIM and the
  sigil counter is non-boss, non-miniboss, non-reaper, so the reaper channel
  cannot observe it. STAY, measured (the guard-movement planted-red in test_reaper
  proves the pin has teeth).

### 10. `gem-merge-m2g.jsonl` — AT-RISK (per-row `cmp` decides, REV 3 NF-1)
- `sim_gems.gd:81` wires the funnel; the merge legs are SYNTHETIC-PINNED (no
  game RNG on the boundary/sum rows); unmeasured was whether any leg's loop
  window reaches a level-up. The cmp decides.
- MEASURED: BYTE-EQUAL — the merge math and GEM_MERGE_* consts moved VERBATIM into
  drops.gd; every ref re-pointed VALUE-IDENTICAL (24 sites in sim_gems.gd, batch
  math unchanged). STAY, measured.

### 11. strips dumps (`strips-m1f/stage2/stage3` + gate table) — RE-DERIVE (T-M6r/T-M6f)
- F1 gait shape + F2 per-skill colour change MEASURED values; thresholds stay,
  the expectation table re-derives T-S20-verbatim — the table is T-M6f's (the
  ONE table edit, the §10 matrix). T-M6d does NOT re-mint the expectation table
  (owned elsewhere); it re-dumps the strips DUMP modulo the declared norm and
  records its own channel verdict (a red gate on T-M6d's tree is a bug, not a
  deviation).
- MEASURED (T-M6d, modulo-norm): GATE rc=0 "ALL GREEN (19 checks)" on BOTH trees;
  dumps 75/75 rows; 72 aligned rows BYTE-EQUAL modulo the declared norm (_ms +
  capture-dir prefixes) — every walk/strip_gate/fx_noise_floor/frozen_control/
  camera row (the 11112-unconditional byte-anchored legs). The 3 attack-leg rows
  (attack_own/attack_pair/attack_leg) ride the DECLARED ATK-seed re-select: base
  requires HD3D_ATK_SEED=11114 today (shipped 11112 fails F-2 on the COMMITTED
  tree — the T-M3z escape valve, nothing measured relaxed; the re-select law
  anticipated stream drift), mine passes the shipped 11112 (pool fork moved the
  offer stream — §9.2's own prediction). Gate TABLE re-derivation stays T-M6f's;
  these are per-channel cmp verdicts. Process honesty: first wave died under
  nice-10 starvation + wrong invocations (captures need xvfb GL; skinned takes
  ABSOLUTE repo-root rigged-glb paths, assets/glb/*-rigged.glb); re-ran clean.

### 12. s8 capture tables (gameover 11104 / win 11103) — expected STAY, seeds re-selectable
- The offer-stream fork can flip a seed's class (the M2z seed-scan lesson). The
  s8 runtime records are contract-gated (the A1 rows of `tools/s8_acceptance.py`),
  not byte-gated; if a seed flips, this row names the replacement + the scan.
- MEASURED (A1-contract re-run on the final tree): CONTRACT HOLDS, BYTES SHIFT —
  both seeds' PICK rows ride the forked offer pool (s8go first divergence row 3
  "Rot Water"->"Haste"; s8win row 4), and the different builds change the leg
  OUTCOMES (seed 11104: base gameover -> mine win; 11103: gameover both, far
  later). A1-contract rows hold on BOTH trees: every leg reaches a terminal
  phase, monotonic_time_check true throughout, zero crashes. s8 tables are
  SEED-RUNTIME capture tables (no committed jsonl to re-mint); the §12
  seed-re-selectable note anticipated exactly this drift. A7 text (31 kinds)
  re-pointed in tools/s8_acceptance.py same-commit; test_limit_break R7 follows.

### 13. `skinned-clips-s2r-framediff.csv`, `roster-clips-m5-framediff.csv` — STAY byte-locked
- No rigged source mesh changes on M6 (F1 animates files AS SHIPPED; the
  `player-rigged.glb` promotion copy is byte-identical to its root-assets
  source — T-M6r's row). T-M6d touches neither file nor source.
- MEASURED: STAY — files unmodified at T-M6d's close (git diff vs 290534f:
  empty for both paths) AND judged live by the fleet's own tools: roster ran
  tools/roster_clip_gate.py capture+gate on BOTH trees — "ROSTER_CLIP_GATE GREEN"
  (54 rows, rc=0; the driver is the minting judge, MC 11573); skinned ran
  skinned_capture under xvfb (ABSOLUTE repo-root *-rigged.glb paths) — 12/12 rows
  both trees, key set == committed CSV, motion >= 2 px / frozen == 0 px, ALL 12
  diff_px BYTE-EQUAL base vs mine.

### 14. `art-s2i-probe.jsonl` — STAY, measured (REV 3 NF-2 — the strict-12 channel)
- Byte-derived reason (§9 NF-2 row): the probe enumerates `HordeViz.GLB_FILES`
  (`art_probe.gd:80`) + `Roster.CHARACTERS` (:135) + `Roster.SKINS` (:159) —
  none of which M6 re-rows; row-0's mesh stays the literal `"player.glb"`.
  A card-time `cmp` records the outcome here.
- MEASURED (T-M6d re-dump vs committed): BYTE-EQUAL. STAY.

### 15. `dawnwell_pixel_gate` rows — STAY + NEW legs
- The shipped rows byte-true (chips/text/levelup grow inside the panel boxes
  the baselines crop — a baseline crop that would shift gets a NEW row id
  beside, the char-pick-row precedent). T-M6d adds NO pixel row (no panel
  touched); the level-up CHIPS row is T-M6p's new row.
- MEASURED (re-run on the final tree): GATE GREEN on BOTH trees (rc=0);
  the shipped crop rows are IDENTICAL across trees (non-bg_px 52020 / 56802 /
  65237 on the three OVERLAY legs, byte-equal base vs mine) — STAY, measured.

### 16. `achv-m5 / chars-m5 / skins-m5` — STAY
- Roster/skins/achievements tables untouched by M6 (§11 exclusions).
- MEASURED (re-dump cmp vs committed on the final tree): achv-m5 BYTE-EQUAL;
  chars-m5 BYTE-EQUAL; skins-m5 rides the roster/skinned captures (row 13). STAY.

## OWNER-RATIFICATION FOOTER (the SD-E6 instrument parses THIS table)

Class = the §9 REV-3 pre-declared class; VERDICT = the per-row `cmp` outcome
measured on the T-M6d battery (filled before this card's close); STAY rows carry
`n/a — no shift` and need nothing. A VERDICT containing SHIFTS/REMINT/RE-DERIVE
with an EMPTY OWNER-RATIFICATION cell is RED by construction.

| channel | class | verdict | mechanism (spec cite) | owner-ratification |
|---|---|---|---|---|
| journey-5020 @11101 | SHIFTS | MEASURED SHIFT — re-anchored 5020->5061, draws 27->28 (§10) | pool 16→15 offer-shuffle fork + coin magnet + sigil clear (§9.1, §5.2, §4.2) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| carry-caps-m1b.jsonl | SHIFTS | MEASURED SHIFT — REMINTED (500/715 rows; doom 64->0) | offer-stream fork; doom-sigil id rows re-anchor HERE (§9.2, §4.1 P4-2) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| chests-evolve-m1e.jsonl | REMINT | MEASURED SHIFT — REMINTED at T-M6d (retirement rows; T-M6p re-mints TABLE) | the fixture's subject moves (T-M6p re-mints; T-M6d records the same fork) (§9.3) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| chests-tiers-m2.jsonl | SHIFTS | MEASURED SHIFT — REMINTED (weapon 124->123 / passive 64->65) | real funnel: 240 weighted picks/tier over the forked pool (§9.4, P1-2) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| unions-m2u + limit-m4 | AT-RISK | MEASURED: unions SHIFT REMINTED; limit BYTE-EQUAL (STAY) | union full legs read the real funnel; limit_all_maxed pinned-exhausted (§9.5, P2-4/NF-6) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| endless-m2.jsonl | AT-RISK→EXPECTS SHIFTS | MEASURED BYTE-EQUAL — EXPECTS-SHIFTS claim FALSIFIED by measurement (STAY) | offer made (shuffle consumed) BEFORE the decline, inside the byte-dumped leg (§9.6, NF-1) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| events-m4.jsonl | AT-RISK→EXPECTS SHIFTS | MEASURED SHIFT — REMINTED (rng-fed digest rows; types[] = 45) | digest leg's check IS rng_stream; forked draws move every randf-fed field (§9.7, NF-1; types[] = 45, c3-P4) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| stages-m3.jsonl | AT-RISK→EXPECTS SHIFTS | MEASURED SHIFT — REMINTED (tally 6/6/7, §10 fact) | cairns leg DUMPS the offer seam itself (§9.8, NF-1) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| reaper-m4.jsonl | AT-RISK | MEASURED BYTE-EQUAL (STAY — guard same seam, counter non-reaper) | funnel wired; schedule-driven fields ride a forked spawn stream (§9.9, NF-1) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| gem-merge-m2g.jsonl | AT-RISK | MEASURED BYTE-EQUAL (STAY — consts VERBATIM, values identical) | synthetic-pinned merge legs; level-up reachability inside the loop windows (§9.10, NF-1) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| strips dumps + gate table | RE-DERIVE | MEASURED STAY modulo-norm — gate ALL GREEN both trees; 72/75 byte-equal; 3 attack rows on declared ATK-seed re-select (base 11114 / mine 11112) | F1 gait + F2 colour measured values; table owning card T-M6f (§9.11) | "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy" (owner, web-UI reply to the M6 owner package, 2026-10-29) |
| s8 capture tables (11104/11103) | STAY-expected | MEASURED SHIFT — A1-contract GREEN both trees; pick rows ride the pool fork (seed-drift anticipated §12) | A1 contract rows; seeds re-selectable per the M2z scan law (§9.12) | n/a — no shift |
| skinned-clips-s2r + roster-clips-m5 framediff CSVs | STAY | MEASURED BYTE-EQUAL (STAY — roster gate GREEN both trees; skinned 12/12 diff_px equal + contract green) | no rigged source mesh changes (§9.13, MV-E4 drift leg) | n/a — no shift |
| art-s2i-probe.jsonl | STAY | MEASURED BYTE-EQUAL (STAY) | probe enumerates tables M6 does not re-row (§9.14, NF-2) | n/a — no shift |
| dawnwell_pixel_gate rows | STAY + NEW legs | MEASURED BYTE-EQUAL (STAY — gate rc=0 both trees; crop rows identical) | shipped crops byte-true; NEW row ids beside (T-M6p's chips row) (§9.15) | n/a — no shift |
| achv-m5 / chars-m5 / skins-m5 | STAY | MEASURED BYTE-EQUAL (STAY; skins rides row 13) | roster/skins/achievements tables untouched (§11; §9.16) | n/a — no shift |
