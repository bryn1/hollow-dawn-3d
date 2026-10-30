# 3DR-SPEC — hollow-dawn-3d "3D REMAKE" milestone (v4.0.0 proposed) — build-depth spec for the DA gate

- **REV 4, 2026-10-31, MC 11749 (`design`) — DA c3 CAP-fold, OWNER-APPROVED.** Owner artifact,
  literal and quoted (never corrected): **"Approve"** (2026-10-31, orchestrator chat) — approving
  EXACTLY: apply `docs/3DR-SPEC-DA-c3.md`'s WHAT-SHIPS-FIX section (the 5 exact spec-TEXT deltas)
  as REV 4, verified by RE-RUNNING c3's OWN instruments at the REV-4 tree (a FOLD-CHECK, not a
  new adversarial cycle). Target verdict: `docs/3DR-SPEC-DA-c3.md` @ `324e456` (CAP cycle 3/3,
  VERDICT FIX, 2P1/1P2/1P3/1P4; ALL THREE DA docs IMMUTABLE — `git diff 324e456..HEAD` over them
  = 0 lines, capture LEG-6). Base: `origin/master = 324e456`; the `93f2825 → 324e456` delta is
  docs-only (the c3 doc alone), so every REV-3 code cite is judged identically at both SHAs.
  **ALL FIVE DELTAS APPLIED, 0 rebuttals, design text UNTOUCHED outside them** (diff-audit
  classification table: every changed line classifies to delta 1–5 or fold mechanics, capture
  LEG-7); the c3 P1-1 lesson BINDS the verification: a proof executed at one base and committed
  at another is the class that dies — **every number below was RE-MEASURED at the COMMITTED
  REV-4 tree** (capture `.tmp/3drspec4.txt`, VERIFY_EXIT=0). **FOLD LEDGER (delta → section →
  transcript; full table at doc end): (1) A-11** — the id-extraction command NAMED+TRIMMED (a
  real `sed 's/^ *//;s/ *$//'` trim step; the awk-gsub-trims claim STRUCK dated — the as-written
  pattern matches a whole `" | "` field, not leading/trailing spaces), third dated citation
  exclusion `docs/3DR-SPEC.md`, BOTH legs re-measured at the committed REV-4 tree: trimmed
  extraction **232 names / 172 multi-word**, zero-hits grep **EMPTY (rc 1)** — and the DA gate
  docs added to the dated exclusion list under a DECLARED READING (stated per the stop
  condition): c3 named only `3DR-SPEC.md`, but the re-run proved the IMMUTABLE `3DR-SPEC-DA-c3`
  doc quotes the same four archetype names inside its own quoted P1-1 transcript
  (`docs/3DR-SPEC-DA-c3.md:57-60` — the ONLY hits the three-exclusion shape left), the same
  cited-lineage class as the spec's own mentions; the DA docs cannot be edited (immutability is
  the owner-quoted law) and c3 itself REJECTED the grep-proof-reword alternative, so the
  exclusion — the mechanism the row already uses — extends one dated line; full-universe noise
  re-measured with the full dated exclusion set: **21 text hits** (REV-3's 32 carried the older
  two-exclusion shape — struck dated, pinned to `324e456` + docs-only) → A-11, §10, REV-3 ledger
  P3-1 row. **(2) mesh paths** — `godot/` prefix on all TWELVE mesh/twin OWNED cells (§5.1 A row
  six + R row six — `exists=True` for the six current meshes under the `godot/` prefix, the
  twins are files-to-be, capture LEG-2), §5.5's transcription annotated, §3.3's New-files
  literals fixed, §1.1's ART row SPLIT into the two real dirs (`godot/assets/glb/*.glb` — the
  43 live; `assets/glb/` + `assets/glb/superseded/` — provenance copies + archive, where A's
  superseded moves land), + the ONE path law: **`res://assets/glb/ == godot/assets/glb/`**
  (`res://` maps to `godot/`, roster.gd:41) → §1.1, §3.3, §5.1, §5.5. **(3) counts** — 28 →
  **29** in all five occurrences + 24 → **25**, the completeness count PINNED to base `324e456`
  (re-run at REV-4: 102-file `tests tools` universe, 29 hits = 18 tests + 11 tools; 29 − 4
  readers = 25 rule-side) → header, §5.5, §10, REV-3 ledger + counts. **(4) never-three** — the
  §5.3 duplicate-table leg's prose is REPLACED by the TWO NAMED greps: `grep -l "const
  CLIP_SOURCE" godot/scripts/*.gd` = exactly ONE file (ONE table; at base `roster.gd`, post-
  split `roster_clips.gd`) and `grep -l "Roster.clip_source(" godot/scripts/*.gd` = exactly ONE
  file (ONE consumer, `hero_pawn.gd`); `roster.gd`'s reason-header comment mentions are the
  SCHEDULED-split's LINEAGE, NOT homes (the reading the replace-not-delete law forces — the
  as-worded naive file-wise grep false-REDD on comments, c3 LEG-9g) — both greps EXECUTED at the
  base (transcripts in capture LEG-4) → §5.3, §9.3. **(5) "verbatim" → "reproduced for the same
  reasons (threshold + channel universe)"** (c3 P4-1: the counterfactual's messages are the
  REV-3 patch's OWN wording — the failure REASONS reproduce, the strings differ) → §2.4
  EXECUTED-PROOF, A-5, REV-3 ledger P1-2 row. OWNED matrix RE-DERIVED post-cell-rename: all six
  pairs **∅** + owned-by-ONE + the completeness grep BOTH halves + glob expansions re-counted
  (`assets/art-src/` 68, `assets/concepts/` 43, `godot/export/` ABSENT — capture LEG-5); fixture
  arithmetic UNTOUCHED-but-RE-CHECKED (**13** jsonl / **2** CSVs / art-s2i **31** rows /
  roster-clips **55** lines / suite **381** collected); NOISE: nothing under `.audits/*/out`;
  GPU untouched; :8123 untouched; NO SPAWNING (one design-profile leaf).
- **REV 3, 2026-10-30, MC 11739 (`design`) — DA c2 fold (FINAL fold before cap-cycle c3).**
  Target verdict: `docs/3DR-SPEC-DA-c2.md` @ `79543fa` (VERDICT FIX, 2P1/2P2/1P3/1P4; BOTH DA
  docs IMMUTABLE — the M2–M6 precedent, this doc revises IN PLACE). Base: `origin/master =
  79543fa`; the `b16afe8 → 79543fa` delta is docs-only (`git diff --stat` = the DA-c2 doc
  alone — verified this session), so every REV-2 code cite is judged identically at both SHAs.
  **ALL SIX findings ADOPTED, 0 rebuttals** — folded at the EXECUTED-FIX standard; the c2
  lesson BINDS this fold: a GREEN proof-of-a-copy is not a proof — every row below carries the
  REAL file's executed transcript numbers. **FOLD LEDGER (finding → disposition → sections;
  full table + transcript rows at the doc end):**
  **P1-1 ADOPTED** — `tests/test_motion.py` joins T-3DR-c's OWNED set (12th entry); the flip's
  effect on its `statics == 6` leg (`:93-98`, LIVE `CLIP_SOURCE` parse, live null count 6) is
  declared with the SAME-CARD UPDATE RULE — the expected-count re-pin to the measured post-flip
  state lands IN the flip card, dated, with its own planted-red (the MV-E4 static-names-a-walk-clip
  legs stay untouched, §5.3/A-4 reuse them, they survive any flip); the WHOLE flip-path
  COMPLETENESS GREP was EXECUTED, universe NAMED (every committed file under `tests/`+`tools/`
  via `git ls-files`; pattern `CLIP_SOURCE|clip_source|roster|statue`; ~~28 hits~~ **29 (REV 4
  re-measure — c3 P2-1: the fold's OWN capture list carries 29, 18 tests + 11 tools; pinned to
  `324e456` + docs-only, capture LEG-3)**) — 4
  flip-surface readers: `test_art_integration.py` + `test_skins.py` (already C) + `test_motion.py`
  (→ C by this fold) + `tools/mocap/README.md` (dated EXEMPTION row: prose pointer, zero
  executable assertions, true after any flip) → §0 F-2, §5.1, §5.2, §5.3, §5.5, §10.
  **P1-2 ADOPTED** — the five edits are **SEVEN**: edit 6 = the `assert shifts >= 5` threshold
  (`:242`) per-doc parameter (M6 keeps ≥5, measured 13 shifting rows today; 3DR pins its honest
  §2.2 count 2), edit 7 = the channel universe (`for ch in ("journey","strips","s8 capture")`,
  `:250`) per-doc parameter (3DR names its §2.2 channels); the REV-2 "five edits" claim STRUCK
  dated. The seven were EXECUTED as a scratch patch on the REAL `tests/test_sigil_drop.py`
  (cp+cmp restored byte-exact + committed-blob cmp + git-clean leg): A-5 leg (i) 3DR-shape COPY
  + valid reply ⇒ **`9 passed in 0.06s`** GREEN; leg (ii) EMPTY cell COPY ⇒ **RED for the
  EMPTY-CELL reason** (`AssertionError: EMPTY owner-ratification cell on a declared shift:
  roster-clips-m5-framediff.csv`, verbatim-quote message measured ABSENT — edit 5 works); leg
  (iii) M6 regression ⇒ **`9 passed in 0.04s`**, `docs/BYTE-DEVIATION-M6.md` byte-untouched;
  the 5-edit COUNTERFACTUAL re-executed on the real file ⇒ **`2 failed, 7 passed`** —
  "3DR: only 2 shifting rows" + "channel journey missing from 3DR" (the c2 finding reproduced,
  not quoted); the REV-2 copy-probe `.tmp/3drspec2-probe.py` RETIRED in-row (GREEN-proof-of-a-
  copy) → §2.4, §5.3, A-5, §10.
  **P2-1 ADOPTED** — the pin leg names its DIFF BASE (committed-vs-committed
  `git diff <accepted base of T-3DR-c>..HEAD -- godot/scripts/hero_pawn.gd` + NON-EMPTY-DIFF-
  REQUIRED; the bare `git diff` wording struck dated; fleet named-base precedent T-M6z "zero
  git-diff since 290534f"); plant-tested BOTH WAYS on the real tree (capture LEG-4): pre-re-word
  empty diff vs the named base ⇒ **RED rc=1**; comment-only re-word COMMITTED ⇒ **GREEN**
  (2 changed lines, all comments); ONE code char (`minf`→`maxf`) COMMITTED ⇒ **RED rc=1** — the
  c2 scenario-C vacuous GREEN is structurally gone → §1.3, §5.3, §6.2.
  **P2-2 ADOPTED** — the REV-2 P3-1 fold row's rationale "M6 rows carry the keyword in both
  cells" is **FALSE and struck dated**: measured parse of the committed M6 footer (shipped
  instrument shape, capture LEG-5): 26 rows — keyword in BOTH cells **11**, VERDICT-only **2**,
  CLASS-only **2**, neither 11; the counterexample quoted in-row (`| s8 capture tables
  (11104/11103) | STAY-expected | MEASURED SHIFT — … | n/a — no shift |`); the `class`
  cell-of-record re-labelled a DECLARED CHOICE for the new doc, not an M6 fact → §2.4,
  REV-2 ledger P3-1 row, REV-3 ledger.
  **P3-1 ADOPTED** — A-11 de-placeholdered with the REAL v1 id list from the shipped pool table
  (`docs/VS-FEATURES.md` §S1 weapon rows → 232 names at this base; distinctive multi-word
  subset 172): both named commands EXECUTED this session — the zero-hits leg
  `grep -rnwIF -f .tmp/vsids-multi.txt --exclude=VS-FEATURES.md --exclude=PARITY-ROADMAP.md
  godot/ docs/` ⇒ **EMPTY** (rc 1); the full-name universe measured NOISY (32 text hits, all
  generic single-word names inside OUR OWN composite names) — triaged in-row, single-word
  residue policed by the composite-name law + the `test_card_icons` v1-byte pin → A-11.
  **REV 4 DATED NOTE (c3 P1-1, 2026-10-31): this row's execution was TRUE at its measured base
  `79543fa` and FALSE on the tree it committed (`93f2825` — the row's own text added a hit; the
  named awk also did not trim), and the c3 re-run's numbers supersede the two commands quoted
  in this row: use the REV-4 A-11 row's — DO NOT USE this row's command form as a close leg.**
  **P4-1 ADOPTED** — §5.5's sentence now states WHERE each glob's ∅ comes from: the A cells are
  DIR cells measured at base (`assets/art-src/` 68 files, `assets/concepts/` 43 — no other
  OWNED cell names any path under them: expansion ∅ by construction, verified this session;
  `godot/export/` ABSENT — dir-to-be) → §5.5.
  Fixture arithmetic UNTOUCHED-but-RE-CHECKED (capture LEG-1): 13 jsonl / 2 CSVs / art-s2i 31
  rows / roster-clips 55 lines / 381 collected — all as REV 2 stated. OWNED matrix +
  DISJOINTNESS RE-DERIVED post-edits: C = 12 entries; all six pairs **∅** + glob expansion ∅ +
  `test_motion.py`/`test_sigil_drop.py`/`hero_pawn.gd`/`roster.gd` owned-by-EXACTLY-ONE; the
  §5.5 proof instrument now carries COMPLETENESS too (capture `.tmp/3drspec3.txt`,
  VERIFY_EXIT=0).
- **REV 2, 2026-10-30, MC 11727 (`design`) — DA c1 fold.** Target verdict:
  `docs/3DR-SPEC-DA.md` @ `cc33294` (VERDICT FIX, 2P1/3P2/3P3/5P4; the DA doc is immutable —
  the M2–M6 precedent, this doc revises IN PLACE). Base: `origin/master = cc33294`; the delta
  `cb4a95e → cc33294` is docs-only (`git diff --stat` = LEDGER 1 + the two 3DR docs — verified
  this session), so every REV-1 code cite is judged identically at both SHAs. **ALL THIRTEEN
  findings ADOPTED, 0 rebuttals** — each finding's instrument RE-RUN this session BEFORE
  folding (M6 REV-FOLD law): fixtures 13 jsonl + 2 CSVs = 15 (art-s2i IS the 13th jsonl);
  SKILL_FX grep 15 hits / 3 files (viz_fx 9 + capture harness 5 + weapons.gd 1); pytest
  collect 381; `hero_pawn.gd:22` stale "six … statue classes" comment real; DA parse probe
  reproduced (3DR-shape leg REDs on the 5-col header contract, M6 legs RED on hardcoded
  verbatim/date/row-count). Dispositions + downstream rows: **REV-2 FOLD LEDGER** at the end
  of this doc. Two decisions DECLARED in-fold (readings stated, per the stop condition):
  **P1-2** — the parse-pin edits go to **T-3DR-c's OWNED set** (a new T-3DR-p card REJECTED:
  five test-file edits cannot parallelize anyway under the serial chain, and T-3DR-c is
  already the corpus/test-re-pin card — smallest-card, mechanism-monogamy); **P2-1** — the
  ZERO-EDIT law yields a **dated comment-only exception** for `hero_pawn.gd` with a
  comment-only pin leg (T-M6q2 W1 precedent: comment-only edits closed the CODE-universe
  grep-to-zero there; the sweep scope is NOT narrowed — fleet law stays). REV 1 stays below
  as lineage (replace-not-delete: struck text dated, never removed).
- **REV 1, 2026-10-30, MC 11720 (`design`).** Base: `origin/master = cb4a95e` (v3.1.0 GA
  `007f04e` + clean-code cycle 4 close — the first clean NEXT-MILESTONE base: the owner's
  clean-code-after-milestone doctrine (2026-10-25) is SATISFIED on this base: audits
  `docs/CLEAN-CODE-AUDIT*.md` + refactor cycle 4, all four cycles closed with MEASURED
  footers; no next-milestone spec on a dirty base — the law holds, stated here so the DA
  can re-check it).
- **Cite convention (DESIGN-3D §Cites precedent, `docs/DESIGN-3D.md:9-13`):** ~~`DESIGN-3D.md`
  and `RESEARCH-3D-3090.md` are the V1-repo (`../vampire_survivor`) docs; citations to them
  are path-relative to THAT repo.~~ **CORRECTED 2026-10-30 (DA P2-3 fold, measured):**
  `DESIGN-3D.md` cites resolve in **THIS repo** (`docs/DESIGN-3D.md`, git-tracked here —
  `git ls-files` = 1; its :4-5 carries the founding quote exactly as the spec's "DESIGN-3D:4-5"
  cite; its §b plan-40/hard-60 lines live at :221/:242/:266); `RESEARCH-3D-3090.md` is the ONLY
  true v1-repo cite — those cites are path-relative to `../vampire_survivor` (that repo's
  `docs/` has no DESIGN-3D.md — measured). Citations `file.gd:NN` without a repo name are
  THIS repo, re-grepped THIS session (all code-truth greps listed in §0 ran on `cb4a95e`,
  re-run at REV 2 on `cc33294` — docs-only delta).
- **Clean-room stance (inherited, binding):** `docs/VS-FEATURES.md` shapes only; every id,
  name, number, color and threshold below is OURS and pinned by OUR suite.
- **docs/ARCHITECTURE.md:** ABSENT by repo precedent (M6-SPEC:172-173 verbatim — the repo runs
  its own spine: LEDGER + DESIGN-3D + PARITY-ROADMAP + M*-SPEC). Cite, do not rewrite; no
  ARCHITECTURE.md is created by this milestone (§7).
- **Length note (exceeds the ~300 hygiene line, stated why):** one pointable build-depth
  artifact for one milestone (M6-SPEC 1339 L / M5 856 L / M4 782 L precedent); each section is
  self-contained so the DA can gate one at a time. Hard cap 1200 L per the MC 11720 brief.

## OWNER ORDER (verbatim, binding)

1. **The founding ruling (MC 11094, 2026-10-21), verbatim — typos intact, the artifact is quoted, never corrected, the WHOLE quote on ONE line so the pin-greps match it whole (the SD-E6 quote-cell law):** *"a 3d remake. Same type of viduals, top down, but with chatacter animations, movements. 3090 only with best possible model doing the word regardless of time taken."* (Quoted identically at DESIGN-3D:4-5 and RESEARCH-3D-3090:3-5.)
2. **The re-confirmed order (2026-10-30), verbatim:** *"3d remake first then m7"* →
   3DR runs BEFORE M7; the M7 trio (§7) is named, never scheduled here.
3. **The statue-class ruling already on the record (M6 owner package, 2026-10-29), verbatim:**
   *"Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy"* — item 1 → M6-SPEC §1.5 RULED
   option (c) RE-MASTER + RE-RIG for the six statue-class statics, ruled in as the separate
   card T-M6a-STATUE (M6-SPEC REV 4 header; `docs/RELEASE-v3.1.0.md:97-99` names it THE
   promised-not-shipped item, "parked on the owner's vm100" backup window). 3DR is the
   milestone that card rides into (~~§0.3~~ → THIS item 3 → §3.2's coverage table — the §0.3
   cite was dangling, §0 has no subsections; DA P4-1 fold, dated 2026-10-30).

**DECLARED READING (stated, per the stop condition — ambiguity = state the reading):** the
founding ruling's "character animations, movements" is the milestone's contract. The sim,
the data layer, the camera law and the horde law already shipped (v1.0.0→v3.1.0). What is
NOT shipped under that ruling is the last animation gap the repo itself names: the six
statue-class hero pawns that walk as static meshes with procedural bob (owner-"Rec" pin,
`docs/RIG-DEVIATION-SEL-C.md`), the promised-not-shipped row of v3.1.0. 3DR therefore =
(a) the declared scene-arch TRUTH of the 3D path in THIS repo (§1 — the DESIGN-3D fold, incl.
its dated supersession rows), (b) the corpus law that keeps the byte-anchored sim untouched
while the 3D capture corpora re-anchor (§2), (c) the statue re-master + re-rig batch landing
through the ONE existing animation consumer (§3), (d) FX-identity law (§4), (e) the wave
(§5), version + release trio (§6), exclusions (§7), acceptance (§8). Overturning the reading
= re-scoping what the repo's own release notes call unshipped; the DA attacks here first.

## 0. FINDINGS + CODE TRUTH (every claim re-grepped THIS session on cb4a95e — read before the DA opens any section; **REV 2: F-6/F-7 re-grepped + restated 2026-10-30 on `cc33294` per DA P2-2/P1-1 — the fold rows carry the fresh measurements**)

- **F-1 ONE animation consumer, verbatim truth:** `CLIP_SOURCE` appears in exactly TWO script
  files — `godot/scripts/roster.gd` (the ONE table, `:161-183`, + the ONE getter `clip_source()`
  `:182-183`) and `godot/scripts/hero_pawn.gd` (the ONE consumer: `Roster.clip_source(
  _player_glb())` at `:174`, the AnimationPlayer seek `:199`, the gait-rate law
  `speed_scale = minf(spd / HordeViz.GAIT_STRIDE_M, GAIT_FREQ_MAX)` at `:231`). No sim file,
  no horde file reads it. THE 3DR LAW: rigged statue rows flip INSIDE that ONE consumer;
  zero new mechanism, zero edit to `hero_pawn.gd` (§1.3).
- **F-2 The six statics pin:** `roster.gd:161-183` — 14 rows: 8 clip rows (`player.glb` with
  the `visual: "player-rigged.glb"` twin + char-emberwright / grave-ward / duskrunner /
  iron-penitent + skin-ash / marrow / relic) and 6 `null` rows — char-coinhound,
  char-tallow-seer, char-shroud-saint, char-hoard-wretch, skin-tide, skin-void — each
  `# statue-class static (owner "Rec")`. The pin doc that tests parse:
  `docs/RIG-DEVIATION-SEL-C.md` (7 rigged / 6 static, owner "Rec" 2026-10-27, MC 11440);
  the parsing tests: `tests/test_characters.py:420-451` (B-E8 family) + `tests/test_skins.py:26,117`.
  **REV 3 (c2 P1-1 fold, dated 2026-10-30):** `tests/test_motion.py:93-98` pins the six statics
  on the LIVE `CLIP_SOURCE` too (`assert len(statics) == 6` — MV-E4 family, the null-row count
  measured 6 at this base); every rigged flip shrinks that count, so the file REDS at T-3DR-c
  close unless the card re-pins it — the file joins C's OWNED set (§5.1) under the same-card
  update rule; the completeness grep that finds files like this is now a §5.5 proof leg.
- **F-3 The gait law (the ONLY transform-gait mechanism):** `horde_viz.gd` — per-class
  `_freqs[key] = minf(def.spd / CameraRig.PX_PER_M / GAIT_STRIDE_M, GAIT_FREQ_MAX)` (`:153`),
  stride 1.2 m / 2.2 Hz cap (`:79-80`), the M6 bob+lean (position-keyed), the hit_cd lunge edge
  with `if e.boss: boss_pulses += 1 # the boss rides THIS edge, no second path` (`:205-206`).
  16 horde/boss/miniboss/reaper classes ride `GLB_FILES` (`:41-63`) — MultiMesh, rest-pose
  mesh, transform gait. MultiMesh cannot skin (DESIGN-3D §c, binary-VERIFIED fact); skinned
  horde = Route B, REFUTED by the §b draw math and SURVIVING the c3 DA gate — stays REFUTED.
- **F-4 Camera truth:** `camera_rig.gd` (33 L) — `PX_PER_M := 24.0` (`:12`),
  `CAM_OFFSET := Vector3(0.0, 37.6, 13.7)` (`:14`), `PROJECTION_ORTHOGONAL` + `size` (`:22-23`),
  pitch `PITCH_DEG` (`:27`), and the XZ follow `position = Vector3(game.player.x / PX_PER_M,
  0.0, game.player.y / PX_PER_M)` (`:33`) — the DESIGN-3D §a law is literally this file.
- **F-5 Ground truth:** `ground.gd` (54 L) + `shaders/ground.gdshader` — the single quad
  re-centred on the camera, world-locked tiled UV, band swap through the ONE
  `GameRenderer.band_at(game.stage, game.time + game.flare)` (`ground.gd:37,47-49`).
- **F-6 SKILL_FX truth (RESTATED at REV 2 — DA P2-2 adopted; the REV-1 "9 sites, all in
  viz_fx.gd" claim was FALSE at REV 1's own base — an ERRATUM, the instrument re-run 2026-10-30
  on `cc33294`):** `viz_fx.gd` (571 L) — `const SKILL_FX` (`:71`) = 26 rows, one per fireable id
  (measured: 15 weapons + 11 evolutions incl. requiem-toll / dirge-eternal / eternal-matins /
  red-wail / the-sluice / judgement-cross). Measured grep truth: `grep -rn SKILL_FX godot/` =
  **15 hits in 3 files** — `viz_fx.gd` 9 (table `:71` + header/doc comments + the ONE in-game
  dispatch `SKILL_FX.get` at `:275` + `:407`), `sim/upgrades_visual_capture.gd` **5** (the
  capture harness: `:3`, `:387`, `:399` comments + the two capture-side reads `:415`/`:466`),
  `scripts/weapons.gd` 1 (`:38`, the wid-stamp comment). THE load-bearing claim SURVIVES
  measured: the ONE IN-GAME dispatch is viz_fx `:271-275`/`:407`; the capture harness is
  capture-side, weapons.gd is a comment. (ERRATUM-ON-ERRATUM recorded per the fold law: the
  DA's own FIX line proposed "+2 in the capture harness + 1 in weapons.gd" which sums to 12 ≠
  15 — the measured capture-harness count is **5** (grep -c, this session), the correct fix
  arithmetic is 9 + **5** + 1 = 15; the spec folds the MEASURED numbers, not either prose.)
- **F-7 Byte-anchor truth (arithmetic FIXED at REV 2 — DA P1-1: the REV-1 parenthetical summed
  to 16, not 15 — art-s2i was counted outside the 13 it belongs to):** `sim_headless.gd:104`
  `seed(s.to_int() if s != "" else 11101)`; the committed journey anchor = 5071 rows md5
  `5d863b80…` (post-M6, LEDGER T-M6z row — a RECORDED DIGEST in RELEASE-v3.1.0.md /
  BYTE-DEVIATION-M6, NOT a committed dump file; instrument per §2.1 A-1 row, P4-4 fold).
  Strict fixtures in `tests/fixtures/`: **15 files = 13 strict .jsonl (art-s2i-probe.jsonl IS
  one of the 13) + 2 framediff .csv** (re-measured 2026-10-30 on `cc33294`: `ls *.jsonl` = 13,
  `ls *.csv` = 2; art-s2i 31 rows, roster-clips CSV 55 lines). Of the 13 jsonl, **12 HOLD and
  art-s2i-probe.jsonl REMINTs** (§2.2 — it enumerates the re-mastered meshes' heights, so it
  cannot be both; §2.1 row 2 carries the relabel).
- **F-8 LOC truth (measured this session):** sim-side `world.gd` 450, `game_state.gd` 314,
  `drops.gd` 263, `roster.gd` 416 (reason header names the SCHEDULED `roster_clips.gd` split,
  owned by the statue ruling — §3.4); render-side `horde_viz.gd` 392, `hero_pawn.gd` 255,
  `pickup_viz.gd` 351, `viz_fx.gd` 571, `class_mesh.gd` 112, `render.gd` 231 (data module —
  tables + palette + `biome_at/band_at/tint_of`, zero draw calls since M6 §7.2), `hud_3d.gd`
  290, `ground.gd` 54, `camera_rig.gd` 33; `main.gd` 599 (wiring seam — reason header,
  WATCH row); `screens.gd` 601.
- **F-9 The GPU stack + windows truth:** TRELLIS.2 + UniRig installed on vm100 (LEDGER
  T-P2-1 row, "one imagegen spine, no second zoo"); the window laws (drain_barrier,
  single-row, trap-close rc=0, verifier serving at every close, rc-is-not-truth) are LEDGER
  facts from T-S1a/T-S1p/T-M6b — §5.4 carries them as LAW rows.

## 1. SCENE ARCH — the 3D path AS IT LIVES IN THIS REPO (the DESIGN-3D fold)

### 1.1 The split: render side vs sim side (the brief's named files)

**The law: the sim stays the byte-anchored XZ truth; everything 3D is render-side and READS the
sim, never the reverse.** The sim's `(x, y)` plane maps to the 3D world `(x, 0, y)` at
`PX_PER_M = 24.0` (`camera_rig.gd:12,33`) — v1's every-hit-is-a-distance-test law (DESIGN-3D §a)
unchanged; 2D physics on the XZ plane stays the only physics (no 3D physics engine enters the
milestone — rejected, §7.3-R1).

| side | files (godot/) | 3DR touch law |
|---|---|---|
| **SIM (byte-anchored truth)** | `scripts/game_state.gd` 314, `scripts/world.gd` 450, `scripts/drops.gd` 263, `scripts/weapons.gd`, `scripts/levelup.gd`, `scripts/evolutions.gd`, `scripts/union.gd`, `scripts/chest_rewards.gd`, `scripts/powerups.gd`, `scripts/achievements.gd`, `scripts/save.gd`, `scripts/bridge.gd`; rule side of `scripts/roster.gd` (CHARACTERS/SKINS/rules); all of `sim/sim_*.gd` dump drivers + `sim/sim_funnel.gd` (the shared seam, kb MC 11317) | **ZERO BYTES** — the strongest acceptance row (§8 A-1) is the journey + strict corpus `cmp`-identical proof that this stayed true |
| **RENDER (the 3D truth)** | `scripts/camera_rig.gd` 33, `scripts/ground.gd` 54 + `shaders/ground.gdshader`, `scripts/class_mesh.gd` 112, `scripts/horde_viz.gd` 392, `scripts/hero_pawn.gd` 255, `scripts/pickup_viz.gd` 351, `scripts/viz_fx.gd` 571, `scripts/hud_3d.gd` 290, `scripts/render.gd` 231 (data module), `scripts/main.gd` 599 (wiring); UI: `scripts/screens.gd` 601, `roster_select.gd`, `achievements_page.gd` | touched ONLY through §5's card-ownership matrix; `hero_pawn.gd` and `horde_viz.gd` stay ZERO-EDIT (§1.3, §3.5 — `hero_pawn.gd` under the DATED comment-only exception, §1.3, P2-1 fold) |
| **ART** | ~~`assets/glb/*.glb` (43 live + superseded archive dirs)~~ **SPLIT 2026-10-31 (REV 4, c3 P1-2 — the row collapsed TWO real dirs into one name: the repo has both)**: `godot/assets/glb/*.glb` — **the 43 LIVE meshes, the runtime family** (`char-coinhound.glb` …, `player-rigged.glb` the proven twin pattern) — + `assets/glb/` (top-level: the four committed provenance copies — `player.glb`, `player-alt.glb`, `player-rigged.glb`, `boss-warden-rigged.glb`) + `assets/glb/superseded/` (the archive dir — where §5.1 A's "superseded moves" land), `assets/art-src/` (turntable refs), `assets/concepts/`, `assets/anim/maps/*.json`, `assets/biomes/` | §3's coverage table + the art gates |

**PATH LAW (REV 4, dated 2026-10-31, c3 P1-2 fold — one line so the shorthand cannot recur):
`res://assets/glb/` == `godot/assets/glb/`** — `res://` maps to the `godot/` dir (roster.gd:41
names "the GLB family under res://assets/glb/", which the game loads from repo path
`godot/assets/glb/`); a mesh/twin cell written WITHOUT the `godot/` prefix resolves to the
top-level provenance+archive dir the game never loads — every OWNED-cell mesh/twin path below is
therefore the full `godot/assets/glb/…` literal (the §5.5 proof runs on NAMES, and a name that
resolves to the dead dir proves nothing).

### 1.2 The declared 3D render path (each line = DESIGN-3D law → the live file this session)

- **Node3D world + ortho rig:** one `Camera3D`, PROJECTION_ORTHOGONAL, size 30.0, pitch 20°,
  offset `Vector3(0, 37.6, 13.7)`, S = 24 px/m, field ≈ 53.3 × 31.9 m — `camera_rig.gd` (F-4)
  IS DESIGN-3D §a; sizes DERIVED from the v1 size table (player 40 px → 1.7 m, enemy 34 px →
  1.45 m, boss 128 px → 5.4 m) via `class_mesh.gd` height-normalisation (`:19-28`).
- **Ground quad + world-locked tiled shader:** `ground.gd` + `shaders/ground.gdshader`, tile
  1024 px ÷ S = 42.7 m world-locked; the 4 biome tiles byte-carried; band = the ONE
  `band_at(stage, t)` (`ground.gd:37,47-49`) — DESIGN-3D §a carried.
- **GLB pawns via the ONE CLIP_SOURCE consumer:** hero pawns (player row 0 + 8 chars + 5 skins)
  through `roster.gd` `CLIP_SOURCE` → `hero_pawn.apply_selection()` (`:84-100`) → the ONE
  `_player_mesh()` seam (`:129`) + the ONE `Roster.clip_source()` read (`:174`); rigged rows
  grow ONE visual child (GLB scene + AnimationPlayer), static rows take the procedural arm
  (the SAME §1.2 gait law — M6-SPEC:135); **no second animation path may be added** (§1.3).
- **The horde/boss law:** 16 classes as GLB MultiMeshes under the ONE transform-gait law
  (F-3); the boss is ONE instance of the per-class swap at MODEL_H_BOSS riding the same lunge
  edge (horde_viz header:2-20, `:205-206`) — DESIGN-3D §b's older "player 1 + boss 1 separate
  draws" row is SUPERSEDED (dated fold, §1.4 row D-3): the S6 law shipped and survives.

### 1.3 THE MECHANISM-MONOGAMY LAW (the brief's "NO second animation path", binding on every card)

Repo-wide today `CLIP_SOURCE` has TWO script homes (F-1). The 3DR law, one sentence: **every
rigged asset 3DR ships becomes a row FLIPPING from `null` to a clip row inside the ONE
`CLIP_SOURCE` table and plays through the ONE `hero_pawn` consumer — a card that adds any
other clip source, other AnimationPlayer site, other gait mechanism or per-mob skinned path is
a P0 by this spec's law.** Corollaries, each = reuse of a shipped mechanism:
- rig flips change `roster.gd` rows ONLY + the scheduled seam file (§3.4) — `hero_pawn.gd`
  ZERO ~~edits~~ **non-comment** edits (it already branches on the map at `:174`; a rigged
  statue is a data change). **DATED COMMENT-ONLY EXCEPTION (2026-10-30, DA P2-1 fold):** the
  comment at `hero_pawn.gd:22` names "the six owner-'Rec' statue classes" — at GA a flipped row
  makes that a stale live-read claim, and the fleet treats stale CODE comments as findings
  (LEDGER T-M6q2 W1: grep-to-zero over the CODE universe, closed comment-only). T-3DR-c may
  edit `hero_pawn.gd` **comment lines ONLY** (the `:22` lineage wording, dated re-word to the
  measured post-flip state); the ZERO-EDIT law stands for every byte of CODE in the file.
  **PIN LEG (§5.3, red-capable — REV 3, c2 P2-1 fold, dated 2026-10-30: THE DIFF BASE IS
  NAMED; the REV-2 bare-`git diff` wording is STRUCK dated — every card commits before it
  closes, so a bare working-tree diff at close is empty BY CONSTRUCTION and the leg could
  never fire, measured by the DA: rc 0 GREEN on a COMMITTED code edit):** at T-3DR-c close,
  **`git diff <accepted base of T-3DR-c>..HEAD -- godot/scripts/hero_pawn.gd`** (committed-vs-
  committed; the base = the commit T-3DR-c branches from — the fleet's named-base precedent,
  T-M6z "both CSVs zero git-diff **since 290534f**") must be **NON-EMPTY** (an empty diff = the
  dated `:22` re-word was never committed; the non-empty-diff-required clause forbids
  vacuous-green-by-emptiness) AND **every changed line a comment** (starts `#` after strip;
  fail-closed on added blank lines — a comment re-flow that ADDs one reddens the leg: stated
  direction, acceptable; sound HERE because `hero_pawn.gd` carries ZERO `"""` strings, c2
  measured). PLANT-TESTED BOTH WAYS at this fold on the real tree (capture `.tmp/3drspec3.txt`
  LEG-4): pre-re-word empty diff vs the named base ⇒ RED (rc 1); comment-only re-word
  COMMITTED ⇒ GREEN (2 changed lines, all comments); ONE code char (`minf`→`maxf`) COMMITTED ⇒
  RED (rc 1); the scratch plant commits were destroyed by `reset --hard`, never pushed, and
  `hero_pawn.gd` restore-cmp byte-exact;
- the procedural arm (M6 §1.3) stays the fallback for any double-fail (§3.3) — reuse, not a
  new mechanism;
- the skinned boss twin (M5 `boss-warden-rigged.glb`, 46 joints, RIG_VALID) stays
  CAPTURE-ONLY provenance; an in-game skinned boss would need a second consumer (Route B
  shape) — declared NOT-in-scope (§7.3-R2) with the §b draw math as the price.

### 1.4 DESIGN-3D CITATION TABLE (fold, do not re-litigate — dated supersession rows included)

| row | DESIGN-3D (v1 repo) | status in THIS repo at cb4a95e |
|---|---|---|
| D-1 | §a scene (ortho 20° rig, S=24, derived sizes, ground quad, 2D-on-XZ) | LIVE as §1.1-1.2 (camera_rig.gd / ground.gd / class_mesh.gd, F-4/F-5); cycle-1's 1.0/0.85/3.2 m sizes + `orthographic_size` were WITHDRAWN pre-port (DESIGN-3D:33, :22) — stay withdrawn |
| D-2 | §b draw budget (plan 40, hard cap 60; measured 28 at M6 re-tally, LEDGER T-M6r) | LIVE — the budget law; §8 A-9 re-runs the tally |
| D-3 | §b "player 1 + boss 1 separate draws" | **SUPERSEDED (dated: S6 shipped 2026-10-23)** — the boss rides the horde per-class swap + same lunge edge (F-3); folded, not re-litigated |
| D-4 | §c Route A (transform gait; skinned = player + boss only) + gait law | **LIVE-as-Amended (dated: M5/M6)** — Route A + lunge shipped; skinned live for the HERO/pawn universe through CLIP_SOURCE (M6 §1.1); gait law horde_viz:153,183 (F-3); "boss skinned in-game" rides D-3 |
| D-5 | §d numbers = verbatim v1 data port; `tests/acceptance_suite.js` 29 checks ported | LIVE (sim side, §1.1) — 3DR touches ZERO data-layer bytes; the suite stays green (§8 A-1) |
| D-6 | §e server NOT ported (leaderboard deferred) | LIVE — the leaderboard rejoins the M7 trio by name (§7.1), nothing scheduled |
| D-7 | §f file layout (the ported spine) | SUPERSEDED BY §1.1 (dated: this milestone restates the split against THIS tree — layout v2 shape, no ARCHITECTURE.md, repo precedent) |
| D-8 | §g export chain (WASM + Windows, rAF software floor) | LIVE — both targets ship from the tagged tree (§6.2); VM120 field-test row declared (§8 B-3) |
| D-9 | §h rejected alternatives (Meshy; skinned horde Route B; perspective; Mixamo) | LIVE as REJECTED (§7.3) — Route B REFUTED by the §b math, DA c3 upheld; Hunyuan rides the §3.1 stack exclusion row |
| D-10 | §i weapon FX one-row-per-skill table → §j card icons | LIVE-as-Amended (dated: M6 F2) — the §i table IS `viz_fx.gd SKILL_FX` (F-6), 26 rows; §4 carries the identity law |

## 2. THE CORPUS LAW — HOLD vs RE-ANCHOR (the deviation-doc-as-pin mechanism, REUSED not re-invented)

### 2.1 The HOLD list — byte-unchanged, this milestone (sim unchanged → no fork to forgive)

3DR edits ZERO sim bytes (§1.1's law) ⇒ no RNG consumer, no pool, no drop order, no schedule
moves ⇒ unlike M6 (which legitimately shifted channels BY DESIGN and paid the full §9 ledger
+ 16-row ratified doc), **3DR's committed sim corpora HOLD byte-identical — no shift is
declared and an unexplained byte moved is a FAIL exactly as in M1–M5.** The HOLD list, named
per the brief (each row = the instrument `cmp` + the owner-ratification row that CANNOT exist
for it — a HOLD channel needs no ratification, "n/a — no shift"):

| channel | 3DR verdict | instrument |
|---|---|---|
| journey-5071 @`HD3D_SEED=11101` (F-7) | **HOLD byte-identical** | `sim_headless` re-dump on a pristine base worktree, `md5sum` **vs the RECORDED digest `5d863b80…`** (RELEASE-v3.1.0.md / BYTE-DEVIATION-M6 — there is NO committed dump file to `cmp` a file against; the shipped practice is T-M6z's re-dump-vs-recorded-digest, named honestly per DA P4-4 fold), every 3DR card's battery |
| ~~13 strict fixtures~~ → **12 strict jsonl (P1-1 fold, 2026-10-30: the 13th jsonl on disk, `art-s2i-probe.jsonl`, is §2.2's REMINT subject — it is NOT holdable, see its REMINT row; the label counted it twice)**: `carry-caps-m1b, chests-evolve-m1e, chests-tiers-m2, endless-m2, events-m4, gem-merge-m2g, limit-m4, reaper-m4, stages-m3, unions-m2u, achv-m5, chars-m5` (.jsonl) | **HOLD byte-identical** | `cmp` per channel vs the committed files (the BYTE-DEVIATION-M6 leak-check idiom: channels the deviation doc does NOT name must still `cmp` identical — here ALL 12 + the journey digest do) |
| `skinned-clips-s2r-framediff.csv` | **HOLD** | its sources are player + warden rigged twins — untouched by 3DR (statue twins are NEW files, §3.2) |
| strips dumps (75) + strips gate 19 checks + `SKILL_FX` probe Tables 3/3, 6/6, 26/26 | **HOLD** (horde + FX-side byte-identical sources; the pawn flip cannot move them — §4) | the shipped gates re-run green, twice-cmp |
| biome-readability grid (9/9 anchor + 44-window mob grid, F7 floors) | **HOLD** (mob side + default-pawn captures unaffected; the readability floors CARRY, §2.3) | shipped gate re-run |
| s8 gameover/win dumps | **HOLD contract-checked** (the standing declaration, BYTE-DEVIATION-M6:21 — runtime records, contract checks, not byte) | `tools/s8_acceptance.py` |

### 2.2 The RE-ANCHOR list — the NEW 3D capture corpora (re-measured under the flipped meshes)

The channels whose SUBJECT 3DR legitimately moves (the pawn rigs + their meshes). Format =
the M6-SPEC §9 pre-declared table, reused; per-row measured diff lands in the new pin doc
(§2.4) by the shifting card's FIRST commit, per F-9/M6 law (deviation doc FIRST).

| channel | 3DR verdict | why (mechanism + cite) |
|---|---|---|
| `roster-clips-m5-framediff.csv` (55 lines) | **REMINT** | the six statue rows' motion IS 3DR's subject: a flipped row flips from EXCUSED-0px to a >=2px motion row (or stays EXCUSED under a double-fail §3.3 — the REMINT records whichever outcome the pin doc carries); driver `tools/roster_clip_gate.py` re-measures, twice-cmp |
| `art-s2i-probe.jsonl` (31 rows — the 13th jsonl, NOT in §2.1's HOLD 12; P1-1 fold moves it out of the HOLD label's double-count) | **REMINT (heights only)** | MEASURED REASON (P1-1 fold): the probe enumerates `Roster.CHARACTERS` (art_probe.gd:135) + `Roster.SKINS` (`:159`) + `HordeViz.GLB_FILES` (`:80`) — the six re-mastered v3 meshes ARE its CHARACTERS/SKINS inputs, so the file WILL byte-change; it was never holdable (M6 could HOLD all 13 precisely because M6 touched zero meshes — LEDGER T-M6z "every STAY row 0 (… art-s2i)"). Six `CHARACTERS/SKINS` mesh-literal rows RE-MEASURE live heights on the re-mastered v3 files (art_probe.gd — M6 §9 NF-2's honest row); row-0 player + all horde rows byte-PRESERVED (the forward-lock law: prior rows byte-preserved, subject rows carry the measured diff) |
| roster-capture + dawnwell pixel-gate character shots | **RE-MEASURE, expect STAY** | portraits/silhouettes unchanged (icons untouched); legs re-run green, committed PNGs STAY; a diff = a finding, not a re-anchor |
| motion-capture shots (bob/lean) | **RE-MEASURE, expect STAY** | for rigless arms; the flipped pawns' walk frames ride the CLIPS now — new shots, fresh baselines recorded into the pin doc (not a committed-corpus channel — shot PNGs, the s8-style contract row) |

### 2.3 Readability floors CARRY, F7-style (the brief's "floors carried")

The two shipped floors stay the acceptance instrument for the flipped pawns, with their
committed constants UNCHANGED: the MOB CONTRAST law (F7 — RATIO_MIN 2.0 as the ONE const,
`tools/biome_readability.py`, all 8 mob classes findable) and the SKILL_FX readability floor
(alpha × luma >= 0.22 — the T-M6c measured floor, BYTE-DEVIATION-M6 §table row) stay verbatim;
the flipped statues must pass them WITHOUT floor edits — a flipped pawn that muddies its
concept shot is a re-master finding (§3.3's VISUAL gate is the first line of defence, the F7
grid the second). Pure-red ceiling-clamp honesty + the twice-cmp crop-anchor determinism law
carry verbatim (kb VERIFIED 2026-10-29).

### 2.4 The deviation-doc-as-pin, with the OWNER-RATIFICATION law CARRIED VERBATIM
(REV 2: the quote made truly verbatim + the parse instrument made buildable — DA P1-2 + P3-1
folds)

Mechanism REUSED, not re-invented (M6-SPEC §9 + the M5 B-E8 planted-red precedent, kb
"deviation-doc-as-pin pattern, VERIFIED via planted-red MC 11440"). The new pin artifact:
**`docs/CAPTURE-DEVIATION-3DR.md`** — T-3DR-c's FIRST commit, channels per §2.2. The footer
table carries **the SHIPPED 5-column parse contract** —
`channel | class | verdict | mechanism | owner-ratification` (`tests/test_sigil_drop.py:204-206`
asserts exactly this header). ~~structure `{channel, shifting card, mechanism, declared diff,
STAY rows, OWNER-RATIFICATION}`~~ — the REV-1 6-column shape is RETRacted (DA P1-2: the shipped
leg could not parse it at all — the leg died at the header contract before the empty-cell rule;
dated 2026-10-30); the shifting-card / declared-diff / STAY detail rides the doc BODY sections,
the footer stays the 5-col contract. **CELL OF RECORD = the `class` cell** (the shipped
instrument tests `cls = r["class"].upper()`, `test_sigil_drop.py:232` — declared here per DA
P3-1: the M6 doc's own prose says "VERDICT cell", the instrument reads CLASS; 3DR picks the
instrument's truth and says so; ~~M6 rows carry the keyword in both cells, which is why the
mismatch stayed silent there~~ **CORRECTED 2026-10-30 (c2 P2-2 fold, measured — the REV-2 claim
is FALSE and struck dated): of the 26 committed M6 footer rows the keyword sits in BOTH cells
in 11, VERDICT-cell-only in 2, CLASS-cell-only in 2 (instrument parse, capture
`.tmp/3drspec3.txt` LEG-5). The counterexample row: `| s8 capture tables (11104/11103) |
STAY-expected | MEASURED SHIFT — A1-contract GREEN both trees; … | … | n/a — no shift |` — a
MEASURED SHIFT in the cell the quoted law says governs, class STAY-expected, closed `n/a — no
shift` under the law's NON-EMPTY wording (law-legal, but never the verbatim answer). The
mismatch was NOT silent at M6; 3DR's `class` cell-of-record is therefore a DECLARED CHOICE for
the new doc, not an M6 fact — and 3DR footer rows carry the keyword in BOTH cells by law, so
the choice never has to bite.**).

The M6 law, quoted EXACTLY from `docs/BYTE-DEVIATION-M6.md:38-44` (the REV-1 ellipsed
paraphrase — "carries the verbatim quote + the date … a NON-EMPTY cell is the gate contract"
— is RETRACTED as a quotation per DA P3-1; it paraphrases the §9 REV-4 ruling-row + SD-E6
prose, not this text; the "carries the verbatim quote + the date" requirement is REAL but
lives in M6-SPEC §9 REV-4, cited as such, not here): **"SD-E6 (the ratification gate's
instrument, `tests/test_sigil_drop.py`): the footer table parses; every channel row whose
VERDICT cell contains SHIFTS / REMINT / RE-DERIVE (case-insensitive) must carry a NON-EMPTY
OWNER-RATIFICATION cell before the shifting card closes. STAY rows carry `n/a — no shift` and
need nothing. Planted red (named in the row): an EMPTY ratification cell on a declared shift ⇒
the leg RED (proved on a COPY — this committed doc is never mutated; capture `.tmp/m6d.txt`)."**
**The empty-cell blocks-close rule** stands as REV 1 declared: no card whose channel row carries
an unratified declared shift CLOSES green; the ask text (§2.2 table → owner package, web UI)
must return the owner's verbatim answer (typos intact, pasted never corrected) into every
shifting row before close; HOLD/STAY rows carry `n/a — no shift` and need nothing.

**THE PARSE INSTRUMENT, made buildable (P1-2 fold — REV 1's "the leg parameterised by doc
path, NO second table parser" was edits short of true; the DA's 3-leg probe RED
reproduced; REV 3, c2 P1-2 fold dated 2026-10-30: the count is SEVEN, not five — REV 2's
"five ways"/"five edits" is STRUCK dated, the missed two are edits 6 and 7 below):** the
shipped SD-E6 leg is hardcoded to M6 in seven ways, all in `tests/test_sigil_drop.py`. The
instrument is ONE parse function, a per-doc PARAMETERS MATRIX, and one new assert — the seven
edits, named so the card can execute them (all T-3DR-c's, §5.1):

1. **PATH** — `_footer_rows()` (and the doc-reading tests) read `DEVIATION_DOC` (`:36`); the
   leg becomes parameterised over (doc path, params) — a matrix entry per doc, so M6's entry
   keeps `docs/BYTE-DEVIATION-M6.md` and 3DR's entry carries `docs/CAPTURE-DEVIATION-3DR.md`.
2. **VERBATIM** — the M6 quote literal (`:229`) becomes the M6 entry's parameter; the 3DR
   entry's verbatim string is THIS milestone's owner-package reply (lands with the answer).
3. **RULING DATE** — the `"2026-10-29"` assert (`:239`) becomes a parameter; the M6 entry keeps
   `2026-10-29`; 3DR rows carry their own ruling date.
4. **ROW COUNT** — `assert len(rows) == 26` (`:228`) becomes a per-doc parameter; **the M6
   entry stays EXACTLY 26** (its footer is byte-anchored by this test today); the 3DR doc's
   count is measured by T-3DR-c's battery and pinned when its rows land.
5. **INDEPENDENT NON-EMPTY ASSERT on the shifting branch** — today the shifting branch's RED
   is a SIDE EFFECT of the verbatim assert (the STAY branch alone has `assert r["owner"]`,
   `:241`); add `assert r["owner"], …` BEFORE the verbatim check on the shifting branch so the
   empty-cell planted-red fails for the EMPTY-CELL reason, not via the M6 quote.
6. **SHIFTING THRESHOLD (REV 3 — the c2 P1-2 6th edit)** — `assert shifts >= 5` (`:242`) is a
   per-doc parameter, not a shared constant: the M6 entry keeps ≥5 (measured today: 13 shifting
   rows); the 3DR entry pins its honest §2.2 count — **2** (the §2.2 universe is 2 REMINT rows
   + 2 RE-MEASURE/STAY rows, and RE-MEASURE/STAY carry no shifting keyword, so a ≥5 threshold
   is unsatisfiable by ANY honest 3DR doc — executed counterfactual, capture LEG-3:
   `AssertionError: 3DR: only 2 shifting rows`). The value is pinned when the 3DR footer rows
   land, same rule as edit 4.
7. **AT-RISK CHANNEL UNIVERSE (REV 3 — the c2 P1-2 7th edit)** — the SECOND doc-reading test
   (`test_deviation_doc_names_the_at_risk_channels`) hardcodes the M6 channel names
   (`for ch in ("journey", "strips", "s8 capture")`, `:250`); the universe becomes a per-doc
   parameter (the M6 entry keeps the three; the 3DR entry names its §2.2 channels:
   `roster-clips`, `art-s2i`). The PENDING close-time rule (`:254-255`) stays UNIVERSAL law —
   shared, unparameterised. Executed counterfactual without this edit, capture LEG-3:
   `AssertionError: channel journey missing from 3DR`.

**EXECUTED PROOF OF THE INSTRUMENT (REV 3 — the c2 lesson binding: the REAL file, never a
weakened copy):** the seven edits above were applied VERBATIM-AS-SPECCED as a scratch PATCH to
the REAL `tests/test_sigil_drop.py` in the worktree and the REAL file was RUN (capture
`.tmp/3drspec3.txt` LEG-3; preflight committed-blob cmp proves the backup started pristine;
restore = cp + cmp byte-exact + `git show <base>:…` blob cmp + git-clean leg): leg (i) 3DR
footer shape (COPY — the doc of record arrives at C's first commit; a SCRATCH reply string
stands in for the package answer, the real verbatim lands with the owner's word) ⇒
**`9 passed in 0.06s`** GREEN; leg (ii) EMPTY owner cell on a declared REMINT row (COPY) ⇒
**RED for the EMPTY-CELL reason** — `AssertionError: EMPTY owner-ratification cell on a
declared shift: roster-clips-m5-framediff.csv` with the verbatim-quote message measured
ABSENT (edit 5 works for the right reason); leg (iii) M6 entry in the same matrix run against
the COMMITTED doc ⇒ **`9 passed in 0.04s`**, `docs/BYTE-DEVIATION-M6.md` byte-untouched
(`git status --porcelain` empty). The 5-EDIT COUNTERFACTUAL (edits 6+7 re-hardcoded to M6
values) re-executed on the real file ⇒ **`2 failed, 7 passed`**, both c2 messages ~~reproduced
verbatim~~ **reproduced for the same reasons (threshold + channel universe)** (c3 P4-1 struck
dated 2026-10-31: the printed messages are the REV-3 patch's OWN wording — a parameterised leg
re-words its own messages; c2's literals were `assert 1 >= 5` and "channel journey missing from
CAPTURE-DEVIATION-3DR" — the failure REASONS (the `:242` threshold, the `:250` channel universe)
reproduce, the strings differ; c3's re-authored patch re-confirmed both reasons byte-shown). The
REV-2 probe `.tmp/3drspec2-probe.py` is **RETIRED IN-ROW** (dated 2026-10-30):
its `PROBE_RESULT: PASS` proved a hand-typed COPY whose contract dropped the shipped
`assert shifts >= 5` (c2: grep 0 hits) — a GREEN-proof-of-a-copy is not a proof; the T-3DR-c
capture runs A-5 against this file, not a transcription.

**REGRESSION LEG (binding, DoD row §5.3):** after the parameterisation the M6 leg MUST still
parse `docs/BYTE-DEVIATION-M6.md` GREEN, byte-untouched — its 26 rows, 5-col header and
`2026-10-29` literals are PROTECTED by the edit shape being additive (matrix entry + parameter
plumbing INCLUDING edits 6+7 + one new assert; the M6 test leg keeps its literal values — 26,
the quote, 2026-10-29, ≥5, the three channels — as its ENTRY's parameters; the T-M6p/T-M6f
re-pin lineage comments at `:218-227` move to the M6 entry, replace-not-delete). The M6
doc is not owned by any 3DR card: ZERO bytes to it. The shipped planted-red stays: empty cell
on a REMINT row ON A COPY ⇒ RED (the committed doc is never mutated). A-5 (§8.1) carries the
three-leg proof: 3DR-shape + valid reply ⇒ GREEN; 3DR-shape + empty cell ⇒ RED; M6 doc
regression ⇒ GREEN.

## 3. ART LAW — the 3090-only MIT stack; coverage; rig-yield; the statue batch

### 3.1 THE STACK (RESEARCH-3D-3090 pinned law — v1 repo `docs/RESEARCH-3D-3090.md` §a/§d, cited)

Owner's "3090 only with best possible model … regardless of time taken" is READ as the
research doc read it: batch-offline exclusive-window generation on the fleet 3090 (RESEARCH
header: the GPU window is shared with the verifier, which is PAUSED while open), MIT-clean
models only, slow-accept beats fast-reject.

| slot | CHOSEN (MIT) | runner-up / fallback | REJECTED — why (dated law) |
|---|---|---|---|
| image→3D | **TRELLIS.2 (4B)** — SOTA, MIT, 24 GB = the 3090 ceiling exactly; installed on vm100 (LEDGER T-P2-1) | TRELLIS v1 / TripoSG (MIT, comfortable at 24 GB) | **Hunyuan3D-2.1 / 2.0 — EXCLUDED: the Tencent Community License carves out EU/UK/SK (no EU distribution) AND 2.1 wants 29 GB > 24 GB** (RESEARCH §a/§d; the owner ships browser+desktop builds — a license-excluded generator's outputs are a distribution risk, not a maybe); Meshy/Tripo API — CLOUD, contradicts "3090 only" |
| auto-rig | **UniRig-2D** (MIT) — the shipped consumer (13 M5 meshes: 7 rigs, 28-53 joints) | TripoSG-rig / manual | Mixamo — upload-based EULA, no commercial redistribution certainty (RESEARCH §b) |
| motion | **CMU mocap via `tools/mocap/` 05/06 (MIT)** + procedural arm | hand-keyed | text→motion (MDM/T2M-GPT) — **overkill: the game needs WALK+ATTACK, mocap already ships it** (RESEARCH §c verbatim "overkill … if mocap + procedural covers all needs, T2M adds risk") |
| textures | TRELLIS-painted, carried through UniRig merge (PROVEN: the M5 rigs keep texture refs through the merge, LEDGER T-M5r row) | — | — |

### 3.2 COVERAGE TABLE — per mob/hero class (the brief's ask), states AS OF cb4a95e → 3DR target

| universe | classes | state @cb4a95e | 3DR target | mechanism |
|---|---|---|---|---|
| hero row 0 (player) | `player.glb` + `player-rigged.glb` twin | RIGGED (walk clip live, byte-identical promotion) | HOLD | the ONE consumer |
| hero chars (8) | emberwright, grave-ward, duskrunner, iron-penitent | RIGGED walk+attack | HOLD | ONE consumer |
| | coinhound, tallow-seer, shroud-saint, hoard-wretch | **STATIC (owner "Rec")** | **RE-MASTER + RE-RIG (ruled: "Ibwant skeletons with movements.")** | ONE consumer — rows flip `null`→clip (§3.4) |
| skins (5) | ash, marrow, relic | RIGGED | HOLD | ONE consumer |
| | skin-tide, skin-void | **STATIC (owner "Rec")** | **RE-MASTER + RE-RIG** | same |
| boss twins | player-rigged + boss-warden-rigged (M5) | capture-proven (framediff CSV) | HOLD (capture-only provenance — §1.3 corollary) | n/a |
| mobs (16 horde/boss/miniboss/reaper) | wraith…the-reaper (`GLB_FILES`) | ROUTE-A transform gait + lunge | **HOLD — BY LAW** (MultiMesh cannot skin; Route B REFUTED §7.3-R1) | the ONE gait law |

"Rigged already" = 8 pawns; "statue batch" = 6 rows (4 chars + 2 skins), the ruled re-rig
(T-M6a-STATUE's subject); "new masters" = the six NEW reference artworks the re-rig requires —
option (c) changes the INPUT (M6-SPEC §1.5 REV-4 scope note: the rig-yield law is a law about
RETRIES on the same mesh + seed-fixed 12345, not about new inputs), so each failed class gets
a NEW ref carrying the riggable wording family.

### 3.3 RIG-YIELD LAW + TWO-FAIL STOP + THE OWNER-VETOABLE STATIC FALLBACK (all REUSED)

Carried verbatim from the shipped law (RIG-DEVIATION-SEL-C + M6-SPEC §1.5 + kb fleet fact,
VERIFIED across 13 meshes): UniRig inference collapses DETERMINISTICALLY on sculpture-class
geometry (seed-fixed 12345 — retries do not change the result); the ref wording that yields
riggable skeletons (kb, the emberwright/grave-ward family): *"arms flat at sides, two legs
visible (robe opening), censer/props carved flush as relief"* + the fused-lantern bell-robe
line for skins. Honest odds stay stated: LOW-TO-MODERATE, LOW for the shroud/quadruped/wing
classes (tallow-seer-v2 carried the fused-arms wording and still collapsed — the wording is a
LEAD, not a promise). THE LAWS:
- **TWO-FAIL STOP (per character):** mesh stage 2 fails OR rig stage 2 fails ⇒ the class
  STOPS, no further burns; mesh reserve law CARRIED: **1/3 reserve HELD — a fourth burn needs
  a new owner word** (RIG-DEVIATION-SEL-C:11).
- **STATIC FALLBACK REUSED, owner-vetoable:** a stopped class ships the shipped procedural arm
  (M6 §1.3: walk-bob + lean on the static mesh — visible motion, zero rig) exactly as it does
  today; this is the M6-SPEC §1.5 declared reading the owner can veto, and the veto costs
  nothing because it is the SHIPPED state, not new work.
- **ART GATES (each REUSED, no new validator):** TRELLIS tri budget (player 8000 / char 9500),
  extent+fill gates (`tools/vm100/player_attempts.py` precedent — the collapse tell), 4-yaw
  SOLID, UniRig RIG_VALID (skins=1), post-merge tri dump, VISUAL validate, aspect gates,
  `tools/mocap/04_validate_glb.py`; PERMANENCE rows per asset (the imagegen/art permanence
  law), `assets/art-src/` refs committed.
- **New files land NEW:** re-mastered meshes `godot/assets/glb/<class>.glb` (v3, the live
  literal — REV 4 path law, c3 P1-2: the `godot/` prefix IS the live dir per §1.1's
  `res://assets/glb/ == godot/assets/glb/` line; prior versions move to the superseded archive
  dir `assets/glb/superseded/` — the top-level archive, the shipped convention) + rig twins
  `godot/assets/glb/<class>-rigged.glb` + `assets/anim/maps/<class>.json` (the ONE maps dir —
  measured correct as written, c3 LEG-8: the top-level dir exists, 9 committed maps) —
  CLIP_SOURCE rows gain the `visual` twin key per the player-row pattern (`roster.gd:162-163`).

### 3.4 The flip + the SCHEDULED seam (file-level)

`roster.gd`'s own reason header (read this session, :1-12) SCHEDULES the clip seam
(`CLIP_SOURCE` + `clip_source()` → `roster_clips.gd`) to the statue ruling's card, per audit-4
§1.4 and the CC3R data-table precedent. 3DR lands it: T-3DR-c creates
**`godot/scripts/roster_clips.gd`** (the seam file — the SAME map, the SAME getter, moved
byte-faithfully), `roster.gd` keeps a delegating call (its rule side untouched), and the six
rows flip per the §3.3 outcomes INSIDE the moved table. `hero_pawn.gd` ZERO ~~edits~~
non-comment edits (F-1's consumer reads the getter either way; the `:22` comment re-word is
T-3DR-c's under the §1.3 dated exception + pin leg); the B-E8/SKINS test family re-pins to
`docs/RIG-DEVIATION-3DR.md` (the new pin doc — the SEL-C doc gets a dated supersession row,
replace-not-delete: struck "7 rigged / 6 static" + the new state line, its rows STAY as
lineage), the art-integration seam-pin (`test_art_integration.py:188+` law) EXTENDED per the
M5 §2.1b precedent (substring law kept; the flip must not touch the art fixture's player row).

### 3.5 What does NOT move (art-side)

`horde_viz.gd` (all 16 mob rows byte-unchanged — §3.2 HOLD-BY-LAW); `hero_pawn.gd` (CODE
byte-unchanged; its `:22` comment moves ONLY under the §1.3 dated comment-only exception,
P2-1 fold), `class_mesh.gd`, `camera_rig.gd`, `ground.gd`, the shaders, the biome tiles; the 7+1 rigged
twins; the icons (the one-icon-per-id law); PERMANENCE stays ONE file.

## 4. FX LAW — SKILL_FX identity survives into 3D (the brief's clause 4)

The 26-row `SKILL_FX` table (F-6) IS the 3D skill-look law already (M6 F2 shipped it INTO the
3D tree — color-first on the shipped COLOR-instance mechanism, per-weapon `wid` stamps, the
`SKILL_CLASS_ALPHA` pin). 3DR adds ZERO FX bytes: the identity law is one sentence — **every
fireable id keeps its SKILL_FX row's color + shape identity; a re-mastered statue pawn cannot
touch an FX row, and a card that re-keys a color to pass the §2.3 floors is a P0** (the FX
side re-keys nothing; if a flipped pawn's silhouette ever made an FX unreadable at the pickup/
halo seams, the fix is the pawn art, never the FX table). ACCEPTANCE rides the shipped
instrument: probe Tables 3/3 + 6/6 + **26/26 per-skill distinctness** re-run GREEN on the final
3DR tree (§8 A-7), plus the alpha-law pin leg (the cross-language PIN + planted-red, T-M6q2
row) byte-true. The Doom-Sigil riven-drop look and the F4 descs ride untouched.

## 5. THE WAVE PLAN — file-ownership matrix, serial edges, per-card DoD, GPU LAW rows

### 5.1 The cards (T-* = card ids; every file ONE card; LEDGER append-line exempt — fleet law,
the closing commit appends its own LEDGER row; disjointness is proven over ALL other files)

| card | subject / windows | OWNS (exclusive) |
|---|---|---|
| **T-3DR-a** (GPU, art) | six re-MASTER refs (imagegen, the riggable-wording family §3.3) + TRELLIS.2 mesh gen, one single-row window per attempt, per-character TWO-FAIL STOP, reserve law | `assets/art-src/*` (the six refs + rejected shots), `assets/concepts/*` (six), `godot/assets/glb/char-coinhound.glb`, `godot/assets/glb/char-tallow-seer.glb`, `godot/assets/glb/char-shroud-saint.glb`, `godot/assets/glb/char-hoard-wretch.glb`, `godot/assets/glb/skin-tide.glb`, `godot/assets/glb/skin-void.glb` (six — full godot/ literals REV 4, c3 P1-2: the live runtime dir, §1.1's path law; + their superseded moves to the top-level archive dir assets/glb/superseded/ — named in §1.1's ART row, not an OWNED cell), `tools/vm100/art-batch-3dr.tsv` (manifest), `.tmp/3dra.txt` capture |
| **T-3DR-r** (GPU, rig) | UniRig-2D rig + skin-merge + `tools/mocap/05/06` CMU retarget walk+attack per ACCEPTED mesh, single-row windows, same STOP; mesh-side permanence rows included here (last art-side card, serial after a); OWNED twins/maps NAMED, not globbed — the REV-1 glob `assets/glb/*-rigged.glb` pattern-covered the two HOLD twins and the §5.5 proof runs on names (DA P4-5 fold) | `godot/assets/glb/char-coinhound-rigged.glb`, `godot/assets/glb/char-tallow-seer-rigged.glb`, `godot/assets/glb/char-shroud-saint-rigged.glb`, `godot/assets/glb/char-hoard-wretch-rigged.glb`, `godot/assets/glb/skin-tide-rigged.glb`, `godot/assets/glb/skin-void-rigged.glb` (six NEW twins — full godot/ literals REV 4, c3 P1-2: twins land in the dir the runtime loads, the proven player-rigged.glb pattern), `assets/anim/maps/char-coinhound.json`, `char-tallow-seer.json`, `char-shroud-saint.json`, `char-hoard-wretch.json`, `skin-tide.json`, `skin-void.json` (six NEW, one dir), `docs/RIG-DEVIATION-3DR.md` NEW, `docs/RIG-DEVIATION-SEL-C.md` (dated supersession row only), `docs/PERMANENCE.md`, `.tmp/3drr.txt` capture |
| **T-3DR-c** (ZERO GPU, repo) | the flip + the seam + the corpus + **the §2.4 parse parameterisation**: `docs/CAPTURE-DEVIATION-3DR.md` FIRST commit (§2.4), seam split, row flips per the pin doc, CSV REMINT, test re-pins, the **seven** §2.4 parse edits (REV 3, c2 P1-2 — the five struck dated) + regression leg, the `hero_pawn.gd:22` comment re-word under the §1.3 exception, the `test_motion.py` statics re-pin (c2 P1-1) | `docs/CAPTURE-DEVIATION-3DR.md` NEW, `godot/scripts/roster_clips.gd` NEW, `godot/scripts/roster.gd` (seam only), `tests/test_characters.py`, `tests/test_skins.py`, `tests/test_art_integration.py`, **`tests/test_sigil_drop.py`** (the **seven** §2.4 parameterisation edits, REV 3 — DA P1-2 fold + c2 P1-2 fold: the file was owned by NO card while A-5's instrument lives there; a separate T-3DR-p parse-pin card REJECTED — edits in the card's own battery file cannot parallelize under the serial chain either way), `tests/fixtures/roster-clips-m5-framediff.csv`, `tests/fixtures/art-s2i-probe.jsonl`, **`godot/scripts/hero_pawn.gd`** (COMMENT lines only, §1.3 dated exception + pin leg — DA P2-1 fold), **`tests/test_motion.py`** (the statics-count re-pin — c2 P1-1 fold, dated 2026-10-30: `test_clip_source_static_rows_name_no_clip` `:93-98` parses the LIVE `CLIP_SOURCE` and asserts exactly 6 null statics (measured 6 at this base), so every flip REDS it at close; the file was OWNED by NO card while the flip made the card's own "suite green" DoD unsatisfiable; SAME-CARD UPDATE RULE: the expected-count re-pin to the measured post-flip state (6 − k, k = flipped classes, dated) lands IN THIS CARD with its own planted-red — the MV-E4 static-names-a-clip legs `:99-103` stay UNTOUCHED and planted-red-capable, §5.3/A-4 reuses them and they survive any flip), `.tmp/3drc.txt` capture |
| **T-3DR-z** (ZERO GPU, release) | the full battery, VM120 + browser + describe-image rows (§8 B), version per §6 RULED value, the Release Trio, README/roadmap de-stale | `docs/RELEASE-v<VER>.md` NEW, `README.md`, `docs/PARITY-ROADMAP.md`, `godot/project.godot` (+version), `godot/export/**` rebuilt artifacts, `.tmp/3drz.txt` capture |
| **T-3DR-q pair** (after GA, NOT wave-gating) | the clean-code pair the doctrine requires BEFORE any M7 spec (owner 2026-10-25; the MC 11316/11317 pattern): T-3DR-q-AUDIT findings-only → T-3DR-q-REFACTOR (byte-anchor corpora unchanged, suite green, zero behavior, before/after measurements) | filed at GA; ownership matrix at filing (the T-M6q pattern) |

### 5.2 Serial edges (named; the only ordering)

**GATE(owner vm100 backup clears) → T-3DR-a → T-3DR-r → T-3DR-c → T-3DR-z → (GA) → T-3DR-q
pair → [M7 spec opens, §7.1]**. a→r: the rig consumes accepted meshes; r→c: the flip consumes
the pin doc's measured outcomes (a flipped row names its rigged twin — the MV-E4 planted-red:
`CLIP_SOURCE` naming "walk" on a clip-less file ⇒ the validator leg RED, the M6 §1.6 leg
reused verbatim); c→z: the battery needs the final tree. a ∥ nothing (the art windows are one
serial lane — single-row law §5.4). No two cards share a file ⇒ within-wave parallelism is
DISALLOWED by the serial chain itself; the matrix disjointness is the DA-checkable proof the
wave cannot collide even if steering loosens (the proof instrument the capture re-runs: §5.5 —
**REV 3, c2 P1-1: the §5.5 instrument carries DISJOINTNESS *and* COMPLETENESS; disjointness
alone twice let a required-edit file sit owned-by-none**).

### 5.3 Per-card DoD (each: what CLOSES it + its byte-law channel rows)

- **T-3DR-a DoD:** per class: ref committed (riggable wording + identity kept — the M5
  portrait-identity law: keep unless CLEAR mismatch), mesh passes the §3.3 gate battery or the
  class carries a dated STOP row; capture `.tmp/3dra.txt` ends VERIFY_EXIT=0 with the per-
  window rows (open/close timestamps, drain_barrier PASS, rc, verifier-serving-at-close, per
  §5.4); channel rows: none touch bytes yet — states the mesh inventory delta.
- **T-3DR-r DoD:** `docs/RIG-DEVIATION-3DR.md` complete (per-row rigged/static state + reason
  cells on statics + the owner-ratification chain: the 2026-10-29 quote + this milestone's
  package answer where a NEW ask arises), every RIGGED row = walk+attack named animations +
  skins=1 + textures survive + post-merge tri dump; framediff-measured motion on each rigged
  twin; capture VERIFY_EXIT=0; channels: skinned s2r CSV HOLD-confirmed.
- **T-3DR-c DoD:** deviation doc FIRST commit; seam split (ONE table, ONE getter — the
  duplicate-table leg, NAMED REV 4 (c3 P3-1 — the ~~`CLIP_SOURCE` still TWO script homes at
  close — roster_clips.gd + hero_pawn.gd, NEVER three~~ prose struck dated 2026-10-31: unnamed
  instrument, and file-wise it false-REDS on the roster.gd reason-header COMMENT mentions,
  which replace-not-delete keeps as the SCHEDULED-split's lineage — comments are lineage, NOT
  homes, declared reading): **`grep -l "const CLIP_SOURCE" godot/scripts/*.gd` = exactly ONE
  file — the ONE const home/table: `roster_clips.gd` after this card's split (at the base:
  exactly `godot/scripts/roster.gd`, executed 2026-10-31 capture LEG-4) — NEVER two tables**;
  **`grep -l "Roster.clip_source(" godot/scripts/*.gd` = exactly ONE file — the ONE consumer:
  `godot/scripts/hero_pawn.gd` (executed at the base, same LEG-4)**; roster.gd's delegator
  keeps the ONE read path); flips land per the
  pin doc; **byte-law channel battery: the §2.1 HOLD table ~~(journey + 13)~~ (journey + 12 —
  P1-1 fold; the journey leg is md5-vs-the-RECORDED-digest per §2.1, the 12 strict jsonl
  `cmp`-identical), the §2.2 REMINTs measured + row-diffed into the doc, empty-cell RED leg
  re-runs, suite green** (381 at this base per A-2, re-measured at close + legs this card adds),
  MV-E4/validator planted-red GREEN-on-red; **parse battery (§2.4, P1-2 + c2 P1-2 REV-3 fold):
  the SEVEN parameterisation edits land (path / verbatim / date / row-count / the independent
  empty-cell assert / the shifting threshold / the channel universe), the three-leg proof runs
  DRIVING THE REAL `tests/test_sigil_drop.py` (3DR-shape + valid reply GREEN / 3DR-shape +
  EMPTY cell RED for the EMPTY-CELL reason / M6 BYTE-DEVIATION-M6.md regression GREEN with its
  26 rows + 5-col header + 2026-10-29 literals byte-untouched) — a copy-probe does NOT satisfy
  this leg (the c2 GREEN-proof-of-a-copy lesson; the §2.4 EXECUTED-PROOF block carries the
  real-file transcripts as the shape to beat)**; **hero_pawn pin leg (§1.3, P2-1 + c2 P2-1
  REV-3 fold): `git diff <accepted base of this card>..HEAD -- godot/scripts/hero_pawn.gd` is
  NON-EMPTY and comment-lines-only, planted RED on an empty diff and on any non-comment
  hunk**; **statics re-pin leg (c2 P1-1 fold): `tests/test_motion.py:93-98` re-pinned to the
  measured post-flip null count, dated, its MV-E4 planted-red legs untouched and still
  red-capable**; **COMPLETENESS leg (c2 P1-1 fold): the §5.5 flip-path grep re-run at close —
  no committed flip-surface reader is owned-by-none**; capture VERIFY_EXIT=0.
- **T-3DR-z DoD:** the §8 acceptance battery on the tagged tree; the Release Trio (§6.2) in
  the same push; ratification quoted VERBATIM into RELEASE notes + the deviation-doc footer
  cells (the empty-cell rule bites z's close if any cell is empty); capture VERIFY_EXIT=0.

### 5.4 GPU WINDOW LAW ROWS (binding on a/r; the LEDGER-shipped facts, restated as LAW —
every 3DR capture carries these as greppable rows)

| law | content (source) |
|---|---|
| **LAW-GATE** | **OWNER-BACKUP GATE FIRST: no 3DR GPU window opens before the owner's vm100 backup window CLEARS** — the parking condition the v3.1.0 release notes name (RELEASE-v3.1.0.md:97-99 "parked on the owner's vm100 backup"); T-3DR-a's first window is the FIRST thing behind the gate; the spec authors zero windows (this is a read/author job — MC 11720 brief) |
| **LAW-BARRIER** | `tools/vm100/drain_barrier` PASS before ANY model load (the consumer-side mitigation committed after the window-4 OOM: a `systemctl restart llama-swap` inside an open window root-caused, LEDGER T-S1a) |
| **LAW-SINGLE-ROW** | one asset per window, no accumulation. ~~(the M5 batch lesson; the T-M6a-SKILLART precedent "single-row windows only, no accumulation")~~ **RE-CITED 2026-10-30 (DA P3-2: the quoted sentence existed nowhere outside this spec, and T-M6a-SKILLART never fired — a never-fired card has no precedent): the real shipped sources are LEDGER T-M1c2 (the regen2 in-session VRAM accumulation OOM → "single-row windows thereafter" — the ACTUAL lesson, windows ledger in `.tmp/m1c2-art.txt`) + the all-single-row GPU cards T-S1q/T-M4a/T-M5s; the M6-SPEC:481/1097/1101 "single-row windows + drain_barrier" wording is PLANNED text for the never-fired T-M6a-STATUE — planned, cited as such, not precedent. The LAW itself is true** |
| **LAW-TRAP-CLOSE** | every window trap-CLOSES with rc=0 recorded; no idle-open window, ever; the generator window closes so the verifier resumes (imagegen window law) |
| **LAW-VERIFIER-AT-CLOSE** | llama-swap / verifier serving PROVEN after every close (every M5/M6 GPU card's capture line: "verifier serves after every close") |
| **LAW-ARTIFACTS** | rc IS NOT TRUTH: assert ARTIFACTS exist after UniRig (its launchers exit 0 producing nothing — kb VERIFIED 2026-10-22); the validators are the truth |

### 5.5 Disjointness proof (the §5.1 matrix, pairwise — the capture re-runs the instrument;
**REV 2: RE-COMPUTED after the P1-2/P2-1 ownership edits + the P4-5 glob-narrowing — the sets
below are the post-fold sets**)

Cards (files sets — names everywhere except the two DIR cells stated as such below): A={DIR
`assets/art-src/`, DIR `assets/concepts/`, six glbs NAMED at full `godot/assets/glb/…` literals
(REV 4 path-law transcription, c3 P1-2 — the cells are the six meshes of §5.1 verbatim),
tools/vm100 tsv}, R={six rigged glbs NAMED at full `godot/assets/glb/…-rigged.glb` literals
(same REV 4
transcription), six anim maps NAMED, RIG-DEVIATION-3DR, SEL-C supersession row, PERMANENCE}, C={CAPTURE-
DEVIATION-3DR, roster_clips.gd, roster.gd seam, **5** tests (characters/skins/art_integration/
**sigil_drop**/**motion** — the fifth is the c2 P1-1 fold), 2 fixtures, **hero_pawn.gd
(comment-only)**} = 11 files + capture = 12 entries, Z={RELEASE, README, ROADMAP,
project.godot, DIR `godot/export/`}.
A∩R=∅ (mesh vs -rigged twin, distinct names — §3.3's new-file law; NAMED rows make the twin
distinctness checkable, the REV-1 glob could not be name-checked — P4-5); A∩C=∅; A∩Z=∅;
R∩C=∅ (R owns no roster/tests; the SEL-C doc vs the tests that parse it: the tests are C's,
the doc is R's, and r→c SERIAL means C reads the doc only AFTER r closed — the one cross-file
READ, no shared WRITE); R∩Z=∅; C∩Z=∅; hero_pawn.gd + test_sigil_drop.py + **test_motion.py**
appear in exactly ONE owned set (C's — the P1-2 fold made sigil_drop owned-by-ONE; the c2
P1-1 fold did the same for test_motion, which had been owned by NO card). **GLOB LAW (P4-5
fold; REV 3 CELLS TRUTH per c2 P4-1 — the REV-2 header sentence claimed "all names, no globs"
and OVERSTATED compliance, only R/C were glob-narrowed; struck dated 2026-10-30 — the honest
statement: the remaining glob cells are DIR cells owning dirs NO other OWNED cell names, so
their pairwise ∅ holds BY CONSTRUCTION under expansion, measured this session:
`assets/art-src/` exists (68 files), `assets/concepts/` exists (43 files), `godot/export/` is
ABSENT at this base (dir-to-be) — zero names from any other set fall under them; expansion ∅,
capture `.tmp/3drspec3.txt` LEG-7/LEG-8).** The proof runs on NAMES — any OWNED-cell glob is
expanded or narrowed before the pairwise check; a glob-vs-glob row pair is VACUOUS, not proof.
**COMPLETENESS LEG (c2 P1-1 fold, binding — disjointness proves the sets don't collide, NOT
that every required file is owned; the leg c1 named and REV 2 re-missed):** the universe is
EVERY committed file under `tests/` + `tools/` (`git ls-files tests tools`), the pattern is
`CLIP_SOURCE|clip_source|roster|statue`; ~~executed at this fold: 28 hits~~ **RE-EXECUTED REV 4
(c3 P2-1 — the fold row's quoted 28 contradicted its own capture's list; the count is PINNED to
the named base, not to "this fold"): at `324e456` + the REV-4 docs-only delta (the tests/+tools/
universe is unchanged) the grep gives 102 files in the universe, **29 hits = 18 tests + 11 tools**
(capture LEG-3),** of which the four
FLIP-SURFACE readers (read/cite the live seam) resolve as — `tests/test_art_integration.py`
(C ✓), `tests/test_skins.py` (C ✓), `tests/test_motion.py` (C ✓ by THIS fold), and
`tools/mocap/README.md` — the one DATED EXEMPTION: a prose pointer ("Roster.CLIP_SOURCE is the
ONE seam"), ZERO executable assertions, true after any flip; the ~~24~~ **25** (REV 4: 29 − the 4
readers) rule-side/manifest/prose
hits (roster rule table, band rosters, batch TSVs, capture drivers — `tools/roster_clip_gate.py`
reads the LIVE seam VIA `roster_capture.gd` state, its CSV fixture is C-owned, the driver's
law is count-agnostic) cannot change verdict on a rig-state flip and need no owner (the suite-
green close battery is the backstop for any misclassification). The T-3DR-c close capture
re-runs BOTH legs. LEDGER.md exempt-append per §5.1. Proof rows computed by grepping the OWNED
columns of §5.1 into a pairwise ∅ table + the completeness grep — `.tmp/3drspec3.txt`
re-computes BOTH from THIS table at this fold (all six pairs ∅ + expansion ∅ + owned-by-ONE +
completeness resolve; a spec edit that breaks either breaks the proof leg; REV-1/REV-2 captures
`.tmp/3drspec.txt`/`.tmp/3drspec2.txt` stand as lineage).

## 6. VERSION DECISION + THE RELEASE TRIO

### 6.1 The stamp (⚠ OWNER-DECISION — recommendation first, no manufactured consent)

**RECOMMENDATION: v4.0.0 (MAJOR).** The mechanical surface law (roadmap §2: major = a new
player-navigated UI surface) does NOT fire on its own terms — 3DR adds no surface (the honest
MINOR reading, v3.2.0, stays on this row). The case for v4.0.0: the surface law was written
for feature milestones; 3DR CLOSES the founding milestone — the owner ruling that says the
product IS a 3D remake with character animations. ~~and the M6 §8 row already recorded a
dated "MAJOR-v4 candidate (OWNER-DECISION)" for the statue ruling's landing, which is exactly
what ships here.~~ **SUPPORT LINE RETIRED 2026-10-30 (DA P3-3, versioned-truth law):** that
M6 §8 candidate row was STRUCK by the owner's own *"3. Ship."* (M6-SPEC REV-4:32-33 —
"RETIRED-IN-ROW (struck, dated)") and was about M6's OWN stamp, not the statue landing —
superseded text is DO NOT USE as live support. The recommendation stands on the
closing-the-founding-milestone case ALONE; the alternative and consent discipline unchanged:
v3.2.0 (pure surface law). The value settles BEFORE any
annotated tag ships bytes (the v2.0.0 lesson, roadmap §2) — the T-3DR-z card tags the RULED
value only.

### 6.2 The GitHub-Release trio (owner doctrine 2026-10-25 — release-card DoD rows)

1. **Release notes committed AT the tag:** `docs/RELEASE-v<VER>.md` — what shipped (the flipped
   classes + the seam + the battery numbers), known limits honest (any double-fail class
   shipping the §3.3 fallback named as such — the promised-not-shipped row is CLOSED or
   EXPLICITLY re-parked, never silently dropped), the RATIFICATION block verbatim (typos
   intact);
2. **README current AT the tag** (no stale claim survives — the retired-claim grep-to-zero law;
   the v3.1.0 notes' "rides procedural until T-M6a-STATUE lands" claim becomes a dated
   supersession row); the sweep covers the CODE universe too (T-M6q2 law) — the ONE collision
   it meets is the `hero_pawn.gd:22` stale "six … statue classes" comment, and **the law that
   YIELDS is named: the §1.3 ZERO-EDIT law, under its DATED comment-only exception (P2-1 fold,
   2026-10-30) — T-3DR-c's comment re-word + pin leg resolves it at the flip card, the sweep
   scope is NOT narrowed (a grep-row exclusion for zero-edit files was REJECTED: the fleet
   treats stale code comments as findings, T-M6q2 W1 closed exactly that class comment-only,
   and an exclusion would reopen it);**
3. **Doc-sync sweep grep-to-zero** (LEDGER/ROADMAP/M6-SPEC §1.5/§11 lines carry their dated
   supersession notes; the RIG-DEVIATION-SEL-C "6 static" claim retires per §3.4's
   replace-not-delete row — grep `6 static|statue-class static` to zero live-reading hits).
Tag law carries: annotated tag on a tagged-tree commit; both export targets (WASM `64f301f3…`
+ Windows `a9c058a2…` — the v3.1.0 pinned pair, tools/VERSIONS.txt) re-exported FROM the
tagged tree; gh release assets = both zips + sha256sums, draft=false prerelease=false;
capture `.tmp/3drz.txt` ends VERIFY_EXIT=0.

## 7. WHAT 3DR IS NOT — exclusions with dated-supersession discipline

### 7.1 The M7 trio — NAMED, explicitly AFTER 3DR per the owner's pick, NOT scheduled here

Owner re-confirmation (2026-10-30), verbatim: *"3d remake first then m7"*. The trio this
names-but-does-not-schedule, each with where it already lives (deferred/excluded rows, NOT
re-decided): **(1) the settings/options screen** (deferred in the roadmap's settings row;
today = Esc-pause + M-mute only, the v1.2.0 landing row); **(2) mobile touch controls**
(roadmap §3.3 EXCLUDED row, "no mobile scope"); **(3) the leaderboard/cloud-save server**
(DESIGN-3D §e "Server: NOT ported"; roadmap gap row 13 — the former "rides the v1 server"
claim was RETIRED CONTRADICTED, MC 11398/11401: zero commits ever touched `server/`). When
M7 opens, ITS spec carries the dated supersession rows for these exclusion lines; until then
each line stays true and 3DR files nothing against them (naming ≠ scheduling).

### 7.2 In-milestone exclusions (the wave must not smuggle these)

No new ids/weapons/classes (the pool stays 15/15 + unions); no roster CHANGES of IDENTITY
(flips are rig-state, never new rows — the IEEE row-0 law); no new HUD/skill overlays (§2's
surface law's own guard); no new save fields (Contract B frozen); no audio (polish tier
untouched); no new GLBs beyond the six+six (§3.2's coverage table is the closed universe);
no floor-constant edits (§2.3); no FX re-keys (§4).

### 7.3 REJECTED-ALTERNATIVES LEDGER (fleet law: weigh in the SPEC, never at implementation time)

- **R1 skinned horde (Route B)** — REFUTED pre-port and DA-upheld (DESIGN-3D §c: MultiMesh
  cannot skin; 50-300 skinned surfaces vs plan 40 / hard 60; WASM single-thread cost); stays
  REFUTED, dated (c3 verdict SURVIVES).
- **R2 in-game skinned boss** — a SECOND consumer shape (§1.3); the S6 one-instance-on-the-
  horde-path law shipped and survives (D-3); the rigged twin stays capture-proven.
- **R3 3D physics engine** — DESIGN-3D §a rejected: every v1 hit-check is a distance test;
  parity + WASM cost (the sim byte-anchor law makes it structurally impossible anyway).
- **R4 perspective camera** — rejected (DESIGN-3D §a: v1 entities are size-pinned regardless
  of distance); the ortho law is `camera_rig.gd` literally (F-4).
- **R5 Hunyuan3D (any version)** — the §3.1 EXCLUSION row (EU/UK/SK license carve + 29 GB);
  carried per the brief — do NOT re-litigate.
- **R6 text-to-motion models** — overkill, RESEARCH §c; mocap + procedural ships it today.
- **R7 new capture/validator zoo** — every gate 3DR uses is shipped (§3.3, §5.4 LAW-ARTIFACTS);
  a card adding a parallel mechanism where a shipped one answers is a P0 (replace-do-not-add).

## 8. ACCEPTANCE — executable rows where stable; honest non-executable declarations where not

The owner's D3 cap (ratified 2026-10-27, MC 11509 D3): executable acceptance layers exist
ONLY where a stable behavioural contract exists; **GAME VISUALS are explicitly OUT —
"browser + describe-image verification stays"** — the visual rows below are therefore
DECLARED, with their declared instrument, never faked as executable.

### 8.1 EXECUTABLE rows (runnable, deterministic, red-capable — **REV 2 honesty note per DA
P4-3 fold: A-11/A-12 run AT THE SEAT, not from a committed repo script; each now names ONE
concrete command so a stranger re-runs it; the rest are repo-runnable**)

| # | row | instrument |
|---|---|---|
| A-1 | **sim unchanged, byte-proof:** journey-5071 @11101 md5-vs-the-RECORDED-digest (`5d863b80…`, RELEASE-v3.1.0.md/BYTE-DEVIATION-M6 — no committed dump exists, P4-4 fold) + the **12** strict jsonl `cmp` IDENTICAL (the §2.1 HOLD list, verbatim — the 13th jsonl is §2.2's REMINT subject, P1-1 fold) on every card's battery | pristine base worktree: `sim_headless` re-dump + `md5sum` vs the recorded digest (the T-M6z practice), `cmp` per strict fixture, + the leak-check idiom |
| A-2 | suite green: pytest 380+ (count at base: ~~380 at T-M6z~~ **381** — LEDGER T-M6q2 "suite 380 -> 381"; re-measured THIS session `python3 -m pytest --collect-only -q` → 381 collected, P4-2 fold; the exact number re-measured at T-3DR-c) on the pinned engine (tools/VERSIONS.txt pins) | pytest, `HD3D_GODOT` seat path |
| A-3 | the B-E8-family pin parses `docs/RIG-DEVIATION-3DR.md`: ratification line asserted, reason cells on every static row, rigged rows measured >= 2px framediff, static rows EXCUSED-0 — PLANTED RED (doc flip ⇒ test RED, the MC 11440 planted-red pattern) | `tests/test_characters.py` (C's edits) |
| A-4 | the MV-E4-family validator leg: a CLIP_SOURCE row naming "walk" on a clip-less file ⇒ RED | shipped validator, reused verbatim |
| A-5 | the §2.4 ratification gate, THREE legs (P1-2 fold; REV 3 transcripts, c2 P1-2): (i) the 3DR footer shape + a valid package reply ⇒ GREEN — executed on the REAL patched file: **`9 passed in 0.06s`** (scratch 3DR footer COPY; a scratch reply stands in until the owner answer lands); (ii) the 3DR footer shape + an EMPTY cell on a declared REMINT row ⇒ RED **for the empty-cell reason** — executed: `AssertionError: EMPTY owner-ratification cell on a declared shift: roster-clips-m5-framediff.csv`, the verbatim-quote message measured ABSENT in the run (edit 5 fires for the right reason; proved on a COPY); (iii) **M6 regression:** the same matrix parses `docs/BYTE-DEVIATION-M6.md` GREEN, byte-untouched — executed: **`9 passed in 0.04s`** + `git status` empty on the doc (26 rows / 5-col header / 2026-10-29 literals protected). 5-edit COUNTERFACTUAL executed too: `2 failed, 7 passed` ("3DR: only 2 shifting rows" + "channel journey missing from 3DR" — both reproduced FOR THE SAME REASONS, threshold + channel universe; the strings are the REV-3 patch's own wording, c3 P4-1 dated 2026-10-31) | the SD-E6 parse AFTER the **SEVEN** §2.4 parameterisation edits — path / verbatim / date / row-count / independent empty-cell assert / **shifting threshold** / **channel universe** (`tests/test_sigil_drop.py`, T-3DR-c's) — three-leg proof DRIVING THE REAL FILE in the card capture; a hand-typed copy-probe does NOT satisfy the leg (the 5-edit wording was unbuildable-as-described TWO cycles running: REV 1's one-liner, then REV 2's five edits missing :242 + :250 — the §2.4 EXECUTED-PROOF block + `.tmp/3drspec3.txt` LEG-3 carry the real-file shape) |
| A-6 | roster-clips driver: twice-cmp across independent xvfb runs, all 55 rows gate (rigged >= 2px, static EXCUSED), laws green; PLANTED RED (frame-clone ⇒ motion min = 0 ⇒ rc 1) | `tools/roster_clip_gate.py` |
| A-7 | FX distinctness: probe Tables 3/3 + 6/6 + 26/26 GREEN on the final tree; alpha-law pin leg byte-true | `tools/upgrades_visual_*.py` trio |
| A-8 | readability: mob grid 44 windows >= RATIO_MIN 2.0 (ONE const, unchanged); 9/9 anchor grid | `tools/biome_readability.py` |
| A-9 | draw-budget tally re-run: measured <= plan 40 (baseline 28; the flipped pawns add ZERO draws — the pawn stays 1 draw, visible mutual-exclusion law MV-E5 reused) | horde_viz `draw_count` + sim_budget legs |
| A-10 | art gates per shipped validator: tri budgets, extent/fill, 4-yaw SOLID, RIG_VALID skins=1, post-merge tri, aspect, mocap validate | the §3.3 battery (LAW-ARTIFACTS) |
| A-11 | clean-room: VS corpus zero-hits law unchanged — ~~the shipped grep gate~~ ~~`grep -rniE "<v1 id list>" …`~~ **DECLARED instrument, seat-runnable, with the REAL id list — the c2 P3-1 placeholder struck dated 2026-10-30. ~~REV-3 form — TWO named commands, both EXECUTED this session (capture LEG-6). (1) THE ID LIST comes FROM THE SHIPPED POOL TABLE — `docs/VS-FEATURES.md` §S1 weapon rows: `sed -n '/^## S1 WEAPONS/,/^## S2/p' docs/VS-FEATURES.md \| awk -F'\|' '/^\| *[0-9]+ *\|/ {gsub(/^ +\| +$/,"",$3); print $3}' \| grep -v '^$' \| sort -u > .tmp/vsids.txt` (claim: "the awk gsub trims leading/trailing spaces") → 232 names. (2) `grep ' ' .tmp/vsids.txt > .tmp/vsids-multi.txt` (claim: 172 names), then `grep -rnwIF -f .tmp/vsids-multi.txt --exclude=VS-FEATURES.md --exclude=PARITY-ROADMAP.md godot/ docs/` ⇒ "EMPTY (rc 1) executed at 79543fa".~~ **STRUCK DATED 2026-10-31 (c3 P1-1, owner-approved "Approve" fold): the row BROKE ITS OWN LEG — the gsub pattern matches a WHOLE `" \| "` field, not leading/trailing spaces, so the extraction did NOT trim (the named `grep ' '` yields the FULL 232, not 172 — the fold ran a different, trimming command it did not name); UNTRIMMED `-f` patterns are FALSE-NEGATIVE (a leading-space pattern drops a match preceded by a word char — green-that-masks, the worse direction); AND the zero-hits leg RED-ed on the tree the fold COMMITTED (`93f2825`: 1 hit — this row's own quoted archetype names).** REV-4 FORM — THE TWO COMMANDS EVERY CARD RUNS, RE-EXECUTED AT THE COMMITTED REV-4 TREE (capture `.tmp/3drspec4.txt` LEG-1): (1) THE ID LIST comes FROM THE SHIPPED POOL TABLE — `docs/VS-FEATURES.md` §S1 weapon rows: `sed -n '/^## S1 WEAPONS/,/^## S2/p' docs/VS-FEATURES.md \| awk -F'\|' '/^\| *[0-9]+ *\|/ {print $3}' \| sed 's/^ *//;s/ *$//' \| grep -v '^$' \| sort -u > .tmp/vsids.txt` (every `\|` rendered here is a RAW pipe escaped for this table; **THE TRIM IS THE NAMED SED STEP** — the awk-gsub trim claim is the struck defect, not this command) → **232 names** re-measured at the REV-4 base (incl. [DLC] rows — the whole shipped inventory universe, no curated hole). (2) THE ZERO-HITS LEG runs the distinctive multi-word subset: `grep ' ' .tmp/vsids.txt > .tmp/vsids-multi.txt` (**172 names** re-measured WITH the trim) then `grep -rnwIF -f .tmp/vsids-multi.txt --exclude=VS-FEATURES.md --exclude=PARITY-ROADMAP.md --exclude=3DR-SPEC.md --exclude=3DR-SPEC-DA.md --exclude=3DR-SPEC-DA-c2.md --exclude=3DR-SPEC-DA-c3.md godot/ docs/` ⇒ **EMPTY output (rc 1) — RE-EXECUTED AT THE COMMITTED REV-4 TREE** (paste the real output; the three-exclusion shape left exactly 3 hit-lines, all inside the IMMUTABLE `3DR-SPEC-DA-c3` doc's own quoted P1-1 transcript, `docs/3DR-SPEC-DA-c3.md:57-60`). THE EXCLUSIONS are the repo's declared clean-room citation surfaces, each dated: `VS-FEATURES.md` (the inventory doc itself) + `PARITY-ROADMAP.md`'s archetype map (its 4 multi-word hits King Bible/Santa Water/Lightning Ring/Fire Wand ARE the declared lineage rows) — 2026-10-30; **`3DR-SPEC.md`** (this spec's own declared-lineage mentions — the archetype-map law of THIS row; c3 P1-1 fix (ii), dated 2026-10-31); **+ the three DA gate docs** (dated 2026-10-31, DECLARED READING stated in the REV-4 header — the immutable gate cycles quote the same four names inside quoted transcripts, the same cited-lineage class as the spec's own mentions; they CANNOT be edited (DA immutability) and c3 itself rejected the grep-proof-reword alternative, so the dated exclusion — the mechanism this row already uses — extends; a FUTURE DA doc must be added HERE when it lands). HONEST SCOPE NOTE (re-measured at the REV-4 base, why the leg is scoped): the FULL 232-name universe is NOISY — with THIS row's full dated exclusion set: **21 text hits** (~~32 text hits at base~~ struck dated — that count rode the older two-exclusion shape; REV 4 re-run pins the count to `324e456` + docs-only delta, hit-by-hit triage in capture LEG-1), ALL generic single-word v1 names (Whip/Axe/Cross/Bone/Knife…) inside OUR OWN composite names (Bone Whip, Hewn Axe, Pilgrim Cross, Bone Market…) + binary matches; the single-word residue is policed by the composite-name law (every shipped META name differs from every v1 name — the archetype map is the declared lineage) and the asset side by `test_card_icons`'s v1-byte pin. At every card close: run both legs, paste the real output into the capture — EMPTY output means PASS** | card-capture greps (the two commands above, in-row) + the shipped `test_card_icons` v1-byte pin |
| A-12 | boot smoke both targets from the tagged tree + VM350 playwright 0 console errors + 0 failed requests (the v2.0.0/v3.1.0 rows, one-click autopilot leg reused) — ~~playwright probe on the shipped build~~ **DECLARED instrument, seat-runnable (P4-3 fold: no committed playwright script exists; the v1.1.0 precedent ran it ad-hoc from the seat, LEDGER T-S11): the fleet browser MCP (Playwright, `browser_*`) driven against the served tag's WASM build, one command per leg (load → console_messages + failed requests read-back), outputs pasted into `.tmp/3drz.txt` verbatim so the leg is re-runnable by a stranger** | fleet browser MCP at the seat + the pasted console/network read-back in the capture |

### 8.2 DECLARED (non-executable per D3 — the owner's eyes are the instrument)

| # | row | declared instrument + honest note |
|---|---|---|
| B-1 | "Same type of viduals, top down" — the LOOK of the owner's ruling | browser + describe-image (Lane E sees natively): per-class turntable shots + in-game shots at the shipped camera; describe-image verdict per flipped class (blank/garbled/overlapping check); **declared, not a gate script — this is the cap, stated** |
| B-2 | "chatacter animations, movements" — a flipped pawn VISIBLY walks | A-6's framediff is the EXECUTABLE proxy; the human/describe read of the walk shot is the declared row (the M6 precedent: MV-E legs measured proxies + declared the human read) |
| B-3 | real-browser field test (the v1.0.0 10-minute test class) | VM120 (the shared Windows seat, fleet skill) browser run on the WASM tag: 0 console errors (executable) + play-feels honest note (declared); rAF software floor DECLARED, not a bug (v1.0.0 law) |
| B-4 | per-skill attack looks "feel individual" | A-7's 26/26 distinctness is the executable floor; the feel read is declared (B-1's instrument) |
| B-5 | the statue classes' IDENTITY survived the re-master (it is still coinhound/tallow-seer/…) | describe-image vs the portrait-icon law; the M5 "keep unless clear mismatch" ruling reused |

### 8.3 Milestone close

GA = every §8.1 row green + the §8.2 rows delivered with captures + the §6.2 trio in the same
push + LEDGER STATUS row. Any double-failed class shipping the §3.3 fallback CLOSES the
milestone HONESTLY (ruled law: two-fail STOP ships static-procedural; the release notes name
it, the promised-not-shipped row re-parks with the owner's next word) — the milestone is not
held hostage to a model the rig-yield law predicts; the owner's veto to keep trying rides the
reserve law (§3.3).

## 9. DA PRE-EMPTION BRIEF (attack here)

1. **The §0 declared reading** — is 3DR = "the completion of the founding ruling via the six"
   the right scope, or does the owner's 2026-10-30 line re-open more? The repo's OWN release
   notes call the six THE promised-not-shipped item — the reading is the repo's, not the
   author's convenience. If the DA finds a second unshipped thread of the founding ruling
   inside THIS repo's docs, it is a P1 finding and it folds.
2. **The HOLD-by-zero-bytes claim (§2.1)** — the strongest row in the spec and the easiest to
   falsify: any 3DR card that touches a sim byte forks the corpus; the `cmp` battery is the
   red-capable proof; check the §5.1 matrix truly contains no sim file (it must, or the HOLD
   list is a lie).
3. **The ONE-consumer claim (F-1/§1.3)** — re-grep `CLIP_SOURCE` (two script homes at base;
   roster_clips.gd after C; hero_pawn stays (CODE stays — a dated comment re-word is under the
   §1.3 P2-1 exception + pin leg; the comment lines are not a consumer); ~~NEVER three — the
   duplicate-table grep at A/C~~ **the §5.3 NAMED greps (REV 4, c3 P3-1): ONE `const CLIP_SOURCE`
   home + ONE `Roster.clip_source(` consumer; comment mentions are lineage, not homes**).
4. **The seam ownership (§3.4)** — the split is SCHEDULED by roster.gd's own header to the
   statue ruling; 3DR-C owning it is the dated plan, not scope creep; `hero_pawn.gd` zero-edit
   is the load-bearing check.
5. **The version row (§6.1)** — v4.0.0 vs v3.2.0 is a REAL OWNER-DECISION; no consent is
   manufactured (the recommendation + the honest MINOR reading both stand on the row).
6. **§3.3 honesty** — LOW odds on some classes are STATED, the fallback is the shipped state,
   and the reserve law caps the burns; a DA that reads option (c) as a promise misreads the
   law — quote: the wording family is "a LEAD, not a promise" (M6-SPEC §1.5, re-grepped).
7. **GPU gates** — LAW-GATE is not decoration: the vm100 backup is the owner's; a window before
   the gate is a P0 by this spec.

## 10. SELF-DA CHECKLIST (what the author ran before filing — this session, on cb4a95e;
**REV 2 pass 2026-10-30 on `cc33294` folded into each affected row**)

- [x] every `file:line` cite re-grepped this session (F-1..F-9; camera_rig/hero_pawn/roster/
  horde_viz/sim_headless greps shown in the capture); DESIGN-3D/RESEARCH/M6-SPEC/roadmap/
  LEDGER/RIG-DEVIATION/BYTE-DEVIATION/RELEASE-v3.1.0 read in full or at named lines. **REV 2:
  the P2-2 FALSE row was the exception — F-6 restated with the measured 15-hits/3-files truth
  (viz_fx 9 + capture harness 5 + weapons.gd 1); every other §0 cite re-run at cc33294
  (docs-only delta), plus the new cites this REV adds (test_sigil_drop :204-206/:228/:229/
  :232/:239/:241; art_probe :80/:135/:159; BYTE-DEVIATION-M6:38-44) measured this session.
  **REV 3 adds, all measured this session: test_motion :93-98 (statics==6 on the LIVE
  CLIP_SOURCE; null-row count 6); test_sigil_drop :242 (`shifts >= 5`) + :250 (channel
  hardcode) read at the source; the committed M6 footer parsed row-by-row (26 rows — BOTH
  cells 11 / VERDICT-only 2 / CLASS-only 2 / neither 11); VS-FEATURES §S1 pool table
  extracted (232 names; 172 multi-word); the full-universe grep's 32 hits eyeballed
  hit-by-hit — all generic words inside our own composite names. REV 4 (c3 P1-1/P2-1 fold, all
  re-measured at the COMMITTED REV-4 tree, capture `.tmp/3drspec4.txt` LEG-1/LEG-3): the
  trimmed extraction REPRODUCES 232 / 172; the zero-hits leg is **EMPTY (rc 1)** at the
  committed REV-4 tree with the row's full dated exclusion set; the full-universe noise with
  that set is **21** hits, triaged hit-by-hit (same verdict: generic words inside our own
  composites); the completeness grep: 102-file universe, **29** hits (18 tests + 11 tools,
  pinned to `324e456` + docs-only).**
- [x] mechanism-monogamy: one animation consumer (F-1), one gait law, one SKILL_FX table, one
  deviation-doc mechanism (SD-E6 parse extended by doc-path — **REV 2, P1-2: honest wording =
  ONE parse function + a per-doc parameters matrix, NOT "path-only"; REV 3, c2 P1-2: the matrix
  carries SEVEN named §2.4 edits, not five — and the mechanism stays ONE parse function, the
  added edits are parameters of the same matrix, no second parser**),
  one seam (the scheduled split
  moves files, not mechanisms), one PERMANENCE, one maps dir, one icon key.
- [x] reuse inventory: every gate/validator/window law 3DR uses is NAMED with its shipped
  source (no new zoo — R7); the rejected list is weighed here, not at build time. (**REV 2,
  P3-2:** LAW-SINGLE-ROW's cite fixed to the real shipped source, LEDGER T-M1c2).
- [x] byte-law: HOLD list explicit (14 channels incl. journey — **REV 2, P1-1: = journey + 12
  strict jsonl + the skinned CSV; the 13th jsonl, art-s2i, is the §2.2 REMINT and was removed
  from the HOLD label's count, which double-counted it**), REMINT list explicit with
  measured-diff law, empty-cell blocks-close CARRIED verbatim (**REV 2, P3-1: the quote made
  truly verbatim against BYTE-DEVIATION-M6:38-44**), deviation doc FIRST-commit law.
- [x] consent artifacts: every owner word quoted verbatim (founding ruling, 2026-10-30 line,
  "Ibwant skeletons…", "Rec"), typos intact; the version row leaves the decision WITH the
  owner; the fallback veto costs the owner nothing. (**REV 2, P3-3:** the v4 support line that
  quoted a STRUCK M6 row retired in-row — the decision framing unchanged.)
- [x] the DA-checkable disjointness proof (§5.5) is re-computed by the capture from this table.
  **REV 2: re-computed AFTER the ownership edits (C gains test_sigil_drop.py + hero_pawn.gd
  comment-only; R globs narrowed to names) — all six pairs ∅, instrument + output in
  `.tmp/3drspec2.txt`. REV 3 (c2 P1-1): RE-DERIVED AGAIN post-fold — C = 12 entries (+
  test_motion.py), all six pairs ∅ + glob-expansion ∅ measured (A/Z DIR cells) + owned-by-ONE
  checks, AND the COMPLETENESS leg now runs as the second half of the §5.5 instrument
  (~~28~~ **29 (REV 4 re-measure, pinned to `324e456` + docs-only — c3 P2-1)** pattern hits
  over the committed tests/+tools/ universe, flip-surface readers all resolved)
  — instrument + output in `.tmp/3drspec3.txt`; REV 4 re-derived BOTH halves AFTER the cell
  rename: six pairs ∅ + expansion ∅ + owned-by-ONE + 29 hits, capture `.tmp/3drspec4.txt`
  LEG-5.**
- [x] NOISE: nothing under `.audits/*/out` written (this job writes only docs/3DR-SPEC.md +
  the LEDGER row + `.tmp/3drspec.txt`; **REV 2/MC 11727: only docs/3DR-SPEC.md + the LEDGER
  row + `.tmp/3drspec2.txt` (+ the scratch `.tmp/3drspec2-probe.py` parse-probe, .tmp is
  gitignored; REV 3 RETIRES that probe in-row per c2 — its PASS proved a copy). REV 3/MC 11739:
  only docs/3DR-SPEC.md + the LEDGER row + `.tmp/3drspec3.txt` + worktree `.tmp/` scratch
  (patch script, footer copies, drivers — every scratch patch cp+cmp restored:
  test_sigil_drop.py + hero_pawn.gd byte-exact vs the committed blobs, plant commits destroyed
  by reset, never pushed**. REV 4/MC 11749: only docs/3DR-SPEC.md + the LEDGER row +
  `.tmp/3drspec4.txt` + worktree `.tmp/` scratch (the id lists + noise/completeness triage
  lists — this fold ran NO scratch patch on any test file: the five deltas are spec-TEXT and
  every re-run instrument is a read-only grep, so the RESTORE LAW had nothing to restore —
  `git status --porcelain` between the two owned files, capture LEG-7)**); GPU untouched (:8123 untouched; zero windows opened);
  NO SPAWNING (this is one design-profile leaf).

## DA GATE (this doc's own cycle ledger)

REV 1 filed 2026-10-30 for the DA gate (the M2–M6 precedent: this doc revises IN PLACE per
verdict; `docs/3DR-SPEC-DA.md` stays immutable at its own commit). c1 verdict lands → REV 2
with a dated fold ledger (finding → change → section); resolved/retired labels dated;
lineage never deleted. After DA SHIP: the owner package (§2.4 ask text + §6.1 version row) →
re-confirmed spec → T-3DR-a behind the LAW-GATE.
**c1 LANDED 2026-10-30** (`docs/3DR-SPEC-DA.md` @ `cc33294`, VERDICT FIX, 2P1/3P2/3P3/5P4) →
**REV 2 filed the same day (MC 11727)** — 13/13 adopted, 0 rebuttals, fold ledger below.
**c2 LANDED 2026-10-30** (`docs/3DR-SPEC-DA-c2.md` @ `79543fa`, VERDICT FIX, 2P1/2P2/1P3/1P4 —
the SAME failure class as c1's P1s: the close-battery could not go green as written) →
**REV 3 filed the same day (MC 11739)** — 6/6 adopted, 0 rebuttals, every fold row carrying
REAL-instrument transcripts (the c2 lesson binding — no GREEN-proof-of-a-copy anywhere in this
fold; the REV-2 copy-probe retired in-row). Ready for DA c3 (CAP CYCLE — c3 re-checks the fold
rows against the real tree; a FIX verdict past c3 escalates to the owner per the M6 cap law).
**c3 LANDED 2026-10-30** (`docs/3DR-SPEC-DA-c3.md` @ `324e456`, CAP cycle 3/3, VERDICT FIX,
2P1/1P2/1P3/1P4 — the two P1s: the A-11 fold row broke its own zero-hits leg on the committed
tree, and twelve mesh/twin OWNED cells named a dir the runtime is not in) → per the M6 cap law
the ORCHESTRATOR ESCALATED PACKAGE-BLOCKED and the OWNER RULED, literal artifact quoted:
**"Approve" (2026-10-31)** — exactly c3's WHAT-SHIPS-FIX section (the 5 spec-TEXT deltas) as
REV 4, verified by re-running c3's own instruments at the REV-4 tree (fold-check, NOT a new
adversarial cycle) → **REV 4 filed 2026-10-31 (MC 11749)** — 5/5 deltas, 0 rebuttals, every
fold number re-measured AT THE COMMITTED REV-4 TREE (the c3 P1-1 class dies when proof-base and
commit-base differ — this fold holds proof and commit at ONE tree). The CAP law is spent: the
gate cycle ends here; the wave STILL cannot start until the owner package (§2.4 ask text +
§6.1 version row) is answered — REV 4 unblocks the package, not the wave.
After DA SHIP: the owner package (§2.4 ask text + §6.1 version row) → re-confirmed spec →
T-3DR-a behind the LAW-GATE.

## REV-2 FOLD LEDGER (DA c1 `docs/3DR-SPEC-DA.md` @ `cc33294` → this REV; finding → change → sections)

All thirteen findings ADOPTED, 0 rebuttals; each finding's instrument RE-RUN on this tree
BEFORE adoption (M6 REV-FOLD law; outputs in `.tmp/3drspec2.txt`). The two gate P1s' FIX
choices are DECLARED readings (stated in the header + their rows): P1-2 → fold the parse
edits into **T-3DR-c** (no new T-3DR-p card); P2-1 → **ZERO-EDIT yields a dated
comment-only exception + pin leg** (sweep-scope exclusion REJECTED — it would reopen the
T-M6q2 CODE-universe class). Rows 1-13, 13/13:

| finding | sev | disposition | what changed (WHERE → HOW) | sections touched |
|---|---|---|---|---|
| **P1-1** | P1 | ADOPTED | Fixture arithmetic re-measured (13 jsonl + 2 CSVs = 15; art-s2i IS the 13th jsonl): §2.1 HOLD row relabelled ~~13~~ **12 strict jsonl** (struck dated), art-s2i's §2.2 REMINT row carries the MEASURED REASON (art_probe enumerates CHARACTERS :135 / SKINS :159 / GLB_FILES :80 — six re-mastered meshes ARE its inputs; M6 could hold it only because M6 touched zero meshes, T-M6z "every STAY row 0 (… art-s2i)"); F-7's self-contradictory parenthetical (summed 16) fixed to 13+2=15 with art-s2i inside the 13; A-1 + §5.3 battery re-stated (journey + **12**) — **the A-1 battery CAN now close green** (the REV-1 version was unsatisfiable: cmp-IDENTICAL and REMINT on the same file) | header, §0 F-7, §2.1 row 2, §2.2 art-s2i row, §5.3, A-1, §10 byte-law row |
| **P1-2** | P1 | ADOPTED — ownership decision DECLARED: **T-3DR-c** (new T-3DR-p REJECTED: five edits in the card's own battery file; the serial chain forbids a parallel card anyway) | §2.4 REWRITTEN into a buildable instrument: footer shape aligned to the SHIPPED 5-col parse contract (the REV-1 6-col shape RETRACTED struck — the shipped leg died at the header assert, test_sigil_drop.py:204-206, before any empty-cell rule); the FIVE parameterisation edits NAMED (path `:36` / verbatim `:229` / date `:239` / row-count `:228` / NEW independent non-empty assert on the shifting branch so empty-cell RED is not the M6-quote side-effect, `:241` STAY branch today); M6 leg protected as an entry of a per-doc PARAMETERS MATRIX (replace-do-not-add: one parse function, two doc paths); **REGRESSION LEG** added (M6 BYTE-DEVIATION-M6.md stays GREEN byte-untouched — 26 rows/5-col header/2026-10-29 protected); §5.1 T-3DR-c OWNED set gains `tests/test_sigil_drop.py`; §5.5 recomputed (sigil_drop now owned-by-ONE; six pairs ∅); A-5 re-stated as the THREE-LEG proof (3DR-shape valid ⇒ GREEN / empty cell ⇒ RED-for-the-empty-cell-reason / M6 regression ⇒ GREEN) | §2.4, §5.1 C row, §5.3, §5.5, A-5, §10 mechanism row |
| **P2-1** | P2 | ADOPTED — law-collision resolved: ZERO-EDIT yields a dated **comment-only exception** (option: grep-row re-scope REJECTED — a sweep exclusion for zero-edit files would reopen the stale-code-comment class T-M6q2 W1 closed comment-only) | §1.3 corollary amended (`hero_pawn.gd` ZERO **non-comment** edits; `:22` "the six owner-'Rec' statue classes" re-word owned by T-3DR-c under the exception); **PIN LEG** specced (the hero_pawn diff must be comment-lines-only, planted RED on any non-comment hunk); §1.1/§3.4/§3.5 cross-refs amended; §6.2 names the yielding law; §5.1 C row gains `godot/scripts/hero_pawn.gd` (comment-only); §9.3 honest note | §1.1 table, §1.3, §3.4, §3.5, §5.1 C row, §5.3, §6.2, §8.1 A-5 area (pin leg rides §5.3), §9.3 |
| **P2-2** | P2 | ADOPTED | F-6 RE-STATED to the measured grep truth: `grep -rn SKILL_FX godot/` = **15 hits / 3 files** (viz_fx.gd 9 — table :71 + comments + the ONE in-game dispatch :275/:407; upgrades_visual_capture.gd **5** — harness comments :3/:387/:399 + capture-side reads :415/:466; weapons.gd 1 — :38 wid-stamp comment); the ONE-in-game-dispatch claim survives measured and is re-pointed; **ERRATUM-ON-ERRATUM recorded here per the fold law: the DA's own FIX line "+2 in the capture harness" is arithmetically short (9+2+1=12≠15); the measured capture-harness count is 5 — the spec folds MEASURED numbers, not either prose** | §0 F-6, §0 header note, §10 cite row |
| **P2-3** | P2 | ADOPTED | Cite convention FIXED (measured: v1 repo `docs/` has NO DESIGN-3D.md — `ls` empty; DESIGN-3D.md is git-tracked HERE, `git ls-files` = 1; its :4-5 founding-quote cite resolves here): DESIGN-3D cites → THIS repo; RESEARCH-3D-3090.md → the ONLY v1-repo cite (`../vampire_survivor`); old convention struck dated — the §1.4 fold table's D-1..D-10 cites now resolve on a live path (the REV-1 convention sent a DA/executor to a dead path — this DA's first fetch proved it) | Cite-convention bullet, §10 cite row |
| **P3-1** | P3 | ADOPTED | §2.4 quote made TRULY verbatim: BYTE-DEVIATION-M6:38-44 quoted word-for-word (the REV-1 ellipsed paraphrase RETRACTED struck — its "verbatim quote + the date" fragment lives in M6-SPEC §9 REV-4, cited as such); the inherited doc-vs-parser cell mismatch RESOLVED by declaration: **CELL OF RECORD = `class`** (the shipped instrument reads `cls = r["class"].upper()`, :232; ~~M6 rows carry the keyword in BOTH cells, which kept the mismatch silent there — stated~~ **STRUCK + CORRECTED 2026-10-30 (c2 P2-2 fold): FALSE as measured — of the 26 committed M6 rows the keyword is in BOTH cells in 11, VERDICT-only in 2 (incl. the s8 row: class STAY-expected, verdict "MEASURED SHIFT — …", owner `n/a — no shift`), CLASS-only in 2; the mismatch was NOT silent at M6; the class-cell is a CHOICE for 3DR, where rows carry the keyword in BOTH cells by law — parse instrument capture `.tmp/3drspec3.txt` LEG-5**) | §2.4, §10 byte-law row; **REV 3 amends this row's rationale only — the quote-verbatim disposition stands (c2 fold-check: quote TRUE / claim HALF)** |
| **P3-2** | P3 | ADOPTED | LAW-SINGLE-ROW RE-CITED: the quoted sentence "single-row windows only, no accumulation" existed only in this spec (grep-to-zero shown by the DA), and T-M6a-SKILLART never fired (RELEASE/T-M6z "conditional not fired") — a never-fired card is not a precedent; real sources named: LEDGER T-M1c2 (regen2 accumulation OOM → "single-row windows thereafter") + the all-single-row cards T-S1q/T-M4a/T-M5s; M6-SPEC:481/1097/1101 wording labelled PLANNED-for-never-fired, not precedent. The LAW itself unchanged | §5.4 LAW-SINGLE-ROW |
| **P3-3** | P3 | ADOPTED | §6.1 support line STRUCK dated: the M6 §8 "MAJOR-v4 candidate" row was retired-in-row by the owner's own *"3. Ship."* (M6-SPEC REV-4:32-33 measured) AND was about M6's OWN stamp, not the statue landing — superseded text is DO NOT USE as live support (versioned-truth doctrine); the v4.0.0 recommendation now rests on the closing-the-founding-milestone case ALONE; the v3.2.0 MINOR alternative + owner-decision framing unchanged (DA SURVIVED-5 upheld) | §6.1 |
| **P4-1** | P4 | ADOPTED | Dangling `§0.3` cite (line 32) fixed: §0 has no subsections — the cite now resolves to OWNER ORDER item 3 → §3.2 (struck dated) | OWNER ORDER item 3 |
| **P4-2** | P4 | ADOPTED | A-2 count fixed: base suite = **381** (re-measured THIS session `pytest --collect-only -q` → 381 collected; LEDGER T-M6q2 "suite 380 -> 381" is the why; the stale 380 struck dated) | A-2, §5.3 (rides the same number) |
| **P4-3** | P4 | ADOPTED | A-11/A-12 instruments made honest + re-runnable: NO committed playwright script and NO committed VS-corpus zero-hits gate exist (DA greps: zero tools/tests hits; the v1.1.0 precedent ran Playwright ad-hoc from the seat, LEDGER T-S11) — both rows relabelled **DECLARED instrument, seat-runnable** per the D3 cap honesty, each naming ONE concrete command/read-back (grep form; browser-MCP console+network read-back pasted into the capture); §8.1 header carries the seat-runnable exception note (the header's "runnable" claim was false for exactly these two rows) | §8.1 header, A-11, A-12 |
| **P4-4** | P4 | ADOPTED | A-1/§2.1 instrument named honestly: no committed journey dump exists (`find *journey*` empty — DA check) — the instrument is the T-M6z practice: pristine-base-worktree re-dump + `md5sum` vs the RECORDED digest `5d863b80…` (RELEASE-v3.1.0.md/BYTE-DEVIATION-M6), not file-vs-file cmp; "cmp vs the committed anchor" struck dated | §2.1 journey row, F-7, A-1 |
| **P4-5** | P4 | ADOPTED | §5.1 R row's globs narrowed to NAMES (the six `-rigged.glb` twins + the six maps explicitly — the REV-1 glob `assets/glb/*-rigged.glb` pattern-covered the two HOLD twins, so the proof could not name-check twin distinctness); GLOB LAW added to §5.5: the proof runs on NAMES, any glob is expanded or narrowed before the pairwise check, glob-vs-glob is VACUOUS not proof | §5.1 R row, §5.5 |

**Counts after the fold:** findings folded **13/13** (2 P1 + 3 P2 + 3 P3 + 5 P4, the DA's
own ranking, none rebutted); §5.1 T-3DR-c OWNED set **9 → 11 files** (gains
test_sigil_drop.py + hero_pawn.gd comment-only); §5.5 pairwise ∅ **6/6 re-proved on the
post-fold sets**; A-5 grew from 1 leg to 3; §5.3 T-3DR-c gained the parse battery + the
hero_pawn pin leg; HOLD channel count stays 14 (journey + 12 jsonl + skinned CSV) — the
label was the bug, the list was not.

## REV-3 FOLD LEDGER (DA c2 `docs/3DR-SPEC-DA-c2.md` @ `79543fa` → this REV; finding → change → sections)

All six findings ADOPTED, 0 rebuttals; the c2 lesson BINDS: every row below carries the REAL
file's EXECUTED transcript (capture `.tmp/3drspec3.txt`, VERIFY_EXIT=0) — weakened-copy proofs
are the class this fold exists to kill, and the REV-2 copy-probe is retired in-row. Every
scratch mutation (patched test file, plant commits, scratch docs) cp+cmp/restore-cmp byte-exact
or reset-and-cmp verified in the capture. Rows 1-6, 6/6:

| finding | sev | disposition | what changed (WHERE → HOW) + REAL-instrument transcript | sections touched |
|---|---|---|---|---|
| **P1-1** | P1 | ADOPTED | `tests/test_motion.py` added to T-3DR-c's OWNED set (§5.1 cell, the 12th entry) with the flip's effect DECLARED via the same-card update rule: `:93-98` asserts `len(statics) == 6` on the LIVE `CLIP_SOURCE` (null-row count measured **6** at base), so the re-pin to the measured post-flip count (6 − k, dated) lands in the flip card WITH its own planted-red; the MV-E4 static-names-a-clip legs stay untouched and red-capable (§5.3/A-4). THE COMPLETENESS GREP EXECUTED, universe named (committed `tests/`+`tools/` via `git ls-files`; pattern `CLIP_SOURCE\|clip_source\|roster\|statue`): ~~28 hits~~ **29 (REV 4, c3 P2-1 — the fold's own capture LIST carries 29: 18 tests + 11 tools; the quoted count was the row's arithmetic error; re-measured + pinned to `324e456` + docs-only, capture LEG-3)**; flip-surface readers = art_integration ✓C / skins ✓C / **motion → C by this fold** / `tools/mocap/README.md` = dated prose-pointer EXEMPTION (zero executable assertions, true after any flip); §5.5 carries the leg as half 2 of the proof instrument, §5.3's DoD re-runs it at close | §0 F-2 (dated note), §5.1 C row, §5.2, §5.3, §5.5, §10, header |
| **P1-2** | P1 | ADOPTED | The five edits are **SEVEN** (REV-2 "five" struck dated): +edit 6 the `shifts >= 5` threshold (`:242`) → per-doc parameter (M6 ≥5, measured 13 shifting; 3DR pins its honest §2.2 count **2** — RE-MEASURE/STAY carry no shifting keyword); +edit 7 the channel universe (`("journey","strips","s8 capture")`, `:250`) → per-doc parameter (3DR names `roster-clips`+`art-s2i`); the PENDING rule stays universal. EXECUTED as a scratch patch on the REAL `tests/test_sigil_drop.py` (preflight committed-blob cmp; restore cp+cmp + blob cmp + git-clean): leg (i) **`9 passed in 0.06s`**; leg (ii) RED **for the empty-cell reason** (`EMPTY owner-ratification cell on a declared shift: roster-clips-m5-framediff.csv`; verbatim-quote message measured ABSENT); leg (iii) **`9 passed in 0.04s`**, M6 doc byte-untouched; the 5-edit COUNTERFACTUAL re-executed **`2 failed, 7 passed`** ("3DR: only 2 shifting rows" + "channel journey missing from 3DR" — REV 4, c3 P4-1 dated 2026-10-31: these strings are the REV-3 patch's OWN wording, reproduced FOR THE SAME REASONS (the :242 threshold + the :250 channel universe), not verbatim). The REV-2 `.tmp/3drspec2-probe.py` RETIRED in-row (GREEN-proof-of-a-copy) | §2.4 (edits 6+7 + EXECUTED-PROOF block + regression-leg wording), §5.3 parse battery, A-5, §10, header |
| **P2-1** | P2 | ADOPTED | Pin leg now reads **committed-vs-committed against the NAMED BASE** (`git diff <accepted base of T-3DR-c>..HEAD -- godot/scripts/hero_pawn.gd`) + **NON-EMPTY-DIFF-REQUIRED** (empty diff = the owed `:22` re-word missing; the bare-`git diff` wording struck dated — c2 scenario-C vacuous GREEN structurally gone). PLANT-TESTED BOTH WAYS this fold (LEG-4): scenario 0 pre-re-word empty diff ⇒ RED rc=1; comment-only re-word COMMITTED ⇒ GREEN (2 lines, all comments); code char (`minf`→`maxf`) COMMITTED ⇒ RED rc=1; scratch plant commits destroyed by `reset --hard`, never pushed, `hero_pawn.gd` restore-cmp byte-exact. Fail-closed-on-blank-line direction stated; `#`-after-strip sound (zero `"""` in the file, c2 measured) | §1.3 pin leg, §5.3, §6.2 cross-ref (wording already rode §5.3), header |
| **P2-2** | P2 | ADOPTED | The REV-2 P3-1 fold row's rationale STRUCK dated and replaced by the measured parse of the COMMITTED M6 footer (shipped instrument shape, LEG-5): 26 rows — keyword in BOTH cells **11**, VERDICT-only **2**, CLASS-only **2**, neither 11; the s8 counterexample quoted IN-ROW (`class=STAY-expected`, `verdict="MEASURED SHIFT — …"`, owner `n/a — no shift` — law-legal NON-EMPTY, never the verbatim answer); the 3DR `class` cell-of-record re-labelled a DECLARED CHOICE (never an M6 fact) + 3DR rows carry the keyword in BOTH cells by law, so the choice never bites; §2.4 + the REV-2 ledger row both carry the dated strike | §2.4 cell-of-record, REV-2 ledger P3-1 row, header |
| **P3-1** | P3 | ADOPTED | A-11 de-placeholdered with the REAL id list FROM THE SHIPPED POOL TABLE, both commands executed (LEG-6): extraction `sed -n '/^## S1 WEAPONS/,/^## S2/p' docs/VS-FEATURES.md \| awk …` → **232 names**; leg on the distinctive multi-word subset (**172**) `grep -rnwIF -f .tmp/vsids-multi.txt --exclude=VS-FEATURES.md --exclude=PARITY-ROADMAP.md godot/ docs/` ⇒ **EMPTY (rc 1)**; the full-universe **32** noisy hits measured + triaged in-row (generic words inside our own composites) with the composite-name law + `test_card_icons` byte-pin named as the single-word/asset-side police. **REV 4 CORRECTION (c3 P1-1, dated 2026-10-31): this row's execution was TRUE at its measured base `79543fa` and FALSE at the tree it committed (`93f2825`, 1 hit — the row's own text); the named extraction command did not trim. The REV-4 A-11 row supersedes the command form quoted HERE — DO NOT USE this row's commands as a close leg; both legs re-measured EMPTY(172-trimmed/232) at the committed REV-4 tree, capture `.tmp/3drspec4.txt` LEG-1** | A-11, header |
| **P4-1** | P4 | ADOPTED | §5.5 header sentence corrected: the "all names, no globs" claim struck dated — the A cells own two real dirs (measured: `assets/art-src/` **68** files, `assets/concepts/` **43** files), `godot/export/` ABSENT (dir-to-be); NO other OWNED cell names any path under them, so the pairs are ∅ BY CONSTRUCTION under expansion — measured this session (LEG-7/LEG-8), stated as such instead of an overstated universal compliance claim | §5.5 GLOB LAW paragraph, header |

**Counts after the fold:** findings folded **6/6** (2 P1 + 2 P2 + 1 P3 + 1 P4, the DA's own
ranking, none rebutted); §5.1 T-3DR-c OWNED set **11 → 12 entries** (gains `tests/test_motion.py`);
§5.5 pairwise ∅ **6/6 re-proved on the REV-3 sets + glob-expansion ∅ + owned-by-ONE + the
COMPLETENESS leg** (~~28~~ **29 (REV 4)** hits resolved); §2.4 parse edits **7**; A-5 three legs REAL-FILE executed
(`9 passed / RED-for-empty-cell / 9 passed`) with the 5-edit counterfactual reproduced;
fixture arithmetic untouched-but-re-checked (**13/2/31/55, suite 381**); HOLD channel count
unchanged at 14 — no §2/§3 substance moved; both DA docs IMMUTABLE; the c3 cap-cycle re-checks
THESE rows.

## REV-4 FOLD LEDGER (DA c3 `docs/3DR-SPEC-DA-c3.md` @ `324e456` WHAT-SHIPS-FIX + owner
"Approve" 2026-10-31 → this REV; delta → change → transcript; every number RE-MEASURED AT THE
COMMITTED REV-4 TREE, capture `.tmp/3drspec4.txt`, VERIFY_EXIT=0)

All five deltas APPLIED, 0 rebuttals, 0 design changes (owner approval scope, quoted: the 5
exact spec-TEXT deltas of the c3 WHAT-SHIPS-FIX section; verification = re-running c3's OWN
instruments at the REV-4 tree — a fold-check, not a new adversarial cycle). Rows 1-5, 5/5:

| delta | c3 sev | disposition | what changed (WHERE → HOW) + REV-4 transcript (committed tree) | sections touched |
|---|---|---|---|---|
| **1 (P1-1 A-11)** | P1 | APPLIED (exclusion extension DECLARED, stated in the REV-4 header) | The row RE-AUTHORED: extraction command NAMED+TRIMMED (`sed 's/^ *//;s/ *$//'` step before `sort -u`; the awk-gsub-trims claim struck dated — the pattern matched a whole `" \| "` field), third dated exclusion `3DR-SPEC.md`, DA gate docs added under the same dated cited-lineage class (measured: with only the three c3 named exclusions the sole remaining hits were `docs/3DR-SPEC-DA-c3.md:57-60` — the immutable doc's own quoted transcript; c3 rejected the reword alternative, exclusion is the row's mechanism). TRANSCRIPT (LEG-1, committed REV-4 tree): 232 names / multi-word **172** / zero-hits grep **EMPTY rc=1** / full-universe noise with the full dated exclusion set **21**, triaged hit-by-hit (generic single-word names inside OUR composites) | A-11, header (REV-4 bullet + REV-3 P3-1 row note), §10 cite row, REV-3 ledger P3-1 row |
| **2 (P1-2 mesh paths)** | P1 | APPLIED | `godot/` prefix on all TWELVE mesh/twin OWNED cells as full literals (§5.1 A six meshes + R six twins), the §5.5 transcription annotated to the new literals, §3.3's New-files literals + superseded-archive naming, §1.1's ART row SPLIT (`godot/assets/glb/*.glb` 43 live vs `assets/glb/` provenance + `assets/glb/superseded/` archive), + the ONE path law `res://assets/glb/ == godot/assets/glb/`. TRANSCRIPT (LEG-2): the six current meshes `exists=True` under the prefix (`godot/assets/glb/char-coinhound.glb` …; 43 files in the dir), the six twins correctly ABSENT (files-to-be), `player-rigged.glb` proven pattern lives in `godot/assets/glb/` (+ top-level provenance copies + `superseded/` — 4 names + dir), `assets/anim/maps/` 9 committed maps (cells stay as written, c3-measured correct) | §1.1 ART row + path law, §3.3, §5.1 A+R rows, §5.5 transcription |
| **3 (P2-1 counts)** | P2 | APPLIED | 28 → **29** in ALL FIVE occurrences (header P1-1 row, §5.5 leg, §10 checklist, REV-3 ledger P1-1 row, counts row), 24 → **25** (§5.5 rule-side = 29 − 4 readers), the count PINNED to base `324e456` + docs-only delta (file lists grow with commits — pinned to a SHA, not to "this fold"). TRANSCRIPT (LEG-3): `git ls-files tests tools` = **102** files; pattern grep -liE = **29** files = **18 tests + 11 tools**; flip-surface readers re-verified at the four named files (no 5th); 29 − 4 = **25** rule-side | header, §5.5, §10, REV-3 ledger P1-1 row + counts row |
| **4 (P3-1 never-three)** | P3 | APPLIED | §5.3's duplicate-table leg RE-READ as TWO NAMED greps — `grep -l "const CLIP_SOURCE" godot/scripts/*.gd` = ONE const home (ONE table; post-split `roster_clips.gd`) + `grep -l "Roster.clip_source(" godot/scripts/*.gd` = ONE consumer (`hero_pawn.gd`) — the NEVER-three prose struck dated (unnamed + comment-fragile: the roster.gd reason-header comments are the SCHEDULED-split's LINEAGE, not homes — replace-not-delete keeps them, declared reading); §9.3's pointer follows. TRANSCRIPT (LEG-4, base tree — the leg's target state is post-C): const-grep → exactly `godot/scripts/roster.gd` (1 file); consumer-grep → exactly `godot/scripts/hero_pawn.gd` (1 file) — the instrument discriminates TODAY | §5.3, §9.3, header |
| **5 (P4-1 one word)** | P4 | APPLIED | "reproduced verbatim" → "reproduced for the same reasons (threshold + channel universe)" — the counterfactual's messages are the REV-3 patch's own wording (a parameterised leg re-words its messages); the failure REASONS (`:242` threshold, `:250` channel universe) reproduce, c3's re-authored patch byte-confirmed both. TRANSCRIPT: wording audit LEG-7 — the phrase greps ZERO as a live-reading claim at the REV-4 tree (its one surviving occurrence is this ledger line quoting the replaced wording; the §2.4 occurrence sits inside the dated strike; c3's own doc quotes it as its finding target and is immutable) | §2.4 EXECUTED-PROOF, A-5, REV-3 ledger P1-2 row |

**Counts after the fold:** deltas applied **5/5** (2 P1 + 1 P2 + 1 P3 + 1 P4, c3's own ranking,
none rebutted); OWNED matrix RE-DERIVED post-cell-rename (LEG-5): all six pairs **∅** (the
mesh/twin rename keeps mesh-vs-twin name distinctness over the FULL literals), glob-expansion
∅ re-counted (`assets/art-src/` **68**, `assets/concepts/` **43**, `godot/export/` **ABSENT**,
no other OWNED name under any DIR cell), owned-by-ONE re-checked (`test_motion.py`,
`test_sigil_drop.py`, `hero_pawn.gd`, `roster.gd` — single), C = **12** entries unchanged, the
completeness grep re-run BOTH halves (LEG-3); fixture arithmetic UNTOUCHED-but-RE-CHECKED
(LEG-1: **13** jsonl / **2** CSVs / art-s2i **31** rows / roster-clips **55** lines / suite
**381** collected); design text UNTOUCHED outside the 5 deltas (LEG-7 diff-audit: every changed
line classifies to delta 1-5 or fold mechanics — header/DA-gate/ledger/LEDGER row, mandated by
the fold's own DoD); DA docs c1/c2/c3 IMMUTABLE (LEG-6: `git diff 324e456..HEAD` over the three
= **0 lines**); HOLD channel count unchanged at 14; the wave stays BLOCKED behind the owner
package (§2.4 ask + §6.1 version row) exactly as before this fold — the approval covered the
fold, not the wave.
