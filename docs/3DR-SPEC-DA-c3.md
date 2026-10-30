# 3DR-SPEC-DA-c3 — Devil's-Advocate gate, MC 11744, cycle 3/3 (CAP) — target `docs/3DR-SPEC.md` REV 3

- **Author:** devils-advocate (11744). Filed 2026-10-30. Base: `origin/master = 93f2825`
  (REV 3 fold commit; `git worktree .tmp/wt-3drda3 -b feat/3drda3 origin/master`).
- **Law:** M6-DA — every finding carries an EXECUTED check + quoted output, re-runnable from
  a clean checkout of this base. This doc is immutable at its commit; the spec revises IN
  PLACE (M2–M6 precedent). `docs/3DR-SPEC-DA.md` @ `cc33294` and `docs/3DR-SPEC-DA-c2.md` @
  `79543fa` are IMMUTABLE — never edited. **This is the CAP cycle (3/3): a FIX verdict names
  the exact REV-4 deltas; the wave cannot start; the orchestrator escalates package-blocked
  to the owner (M6 cap law).**
- **Method (per the brief):** (a) FOLD-CHECK — all six c2 findings RE-EXECUTED on the REAL
  instruments, not accepted from the capture (M6 c3 precedent: fold rows re-derived from
  fixtures/real files): the seven §2.4 edits INDEPENDENTLY RE-AUTHORED as a scratch patch on
  the real `tests/test_sigil_drop.py` (cp+cmp restore, committed-blob cmp, git-clean leg);
  the completeness grep re-run over the named universe; the hero_pawn pin-leg planted BOTH
  WAYS vs the named base (scratch commits destroyed by `reset --hard`, never pushed); the
  11/26 footer math re-parsed; the A-11 id-extract re-run. (b) FOLD-ROW HONESTY — every
  REV-3 row carrying a transcript re-executed; quoted numbers compared to the re-run.
  (c) FINAL SWEEP — OWNED matrix re-derived from the §5.1 cells (pairs + expansion +
  owned-by-ONE + C-entry count), fixture arithmetic, §2.4 ask-text + §6.1 derivability,
  GPU LAW rows vs fleet law, serial edges, acceptance honesty. (d) NEW attacks.
  Full outputs: `.tmp/3drda3.txt`. NOISE: nothing under `.audits/*/out` written; GPU
  untouched; :8123 untouched; NO SPAWNING; every scratch mutation restore-cmp byte-exact.
- **Verdict summary: 2 P1 / 1 P2 / 1 P3 / 1 P4.** The five c2 fold rows the instruments could
  fully re-verify are TRUE down to the quoted numbers — the EXECUTED-FIX standard held. The
  two NEW P1s are of the same family the doc keeps producing: the close-battery cannot go
  green as written on the tree the fold itself just committed (P1-1: the A-11 fold row broke
  its own zero-hits leg; P1-2: the mesh/twin OWNED cells name a directory the live meshes
  and the runtime are not in).

## A. FOLD-CHECK — the six c2 findings re-executed on the real tree at 93f2825

Score: **5 fold rows VERIFIED TRUE to the transcript (numbers matched or timing-noise); 1
partially TRUE (the P3-1 row's execution is true at its measured base and FALSE at the
committed base — that is c3 P1-1, below).** No transcript was fabricated: the independently
re-authored patch reproduced REV 3's quoted pytest lines exactly.

| c2 finding | instrument re-run (this session) | measured on REV 3 | fold row |
|---|---|---|---|
| P1-1 (test_motion owned; completeness grep) | `git ls-files tests tools` (102) `xargs grep -liE "CLIP_SOURCE\|clip_source\|roster\|statue"`; live-seam subset; statics-count hunt; `:93-103` read at source | flip-surface readers = EXACTLY the four named (art_integration/motion/skins + mocap/README, zero-execution exemption) — **no 5th reader** (the only statics-count assert in the universe is `test_motion.py:96`); live null count 6; the file is C's 12th entry; `test_motion` named in the doc: 0 @79543fa → 13 @93f2825 | **TRUE except the count → P2-1 (28 vs measured 29)** |
| P1-2 (seven edits, REAL file) | the seven edits RE-AUTHORED from §2.4 prose alone, applied to the real `tests/test_sigil_drop.py` (preflight blob cmp); legs run; 5-edit counterfactual; cp+cmp+blob+clean restore | leg (i) **`9 passed in 0.07s`** GREEN (REV 3: 0.06s — timing noise, count matches); leg (ii) RED, `AssertionError: EMPTY owner-ratification cell on a declared shift: roster-clips-m5-framediff.csv`, verbatim-quote message ABSENT (edit 5 fires for the right reason); leg (iii) **`9 passed in 0.04s`** + `git status --porcelain docs/BYTE-DEVIATION-M6.md` empty; COUNTERFACTUAL **`2 failed, 7 passed`** with BOTH messages byte-identical ("3DR: only 2 shifting rows", "channel journey missing from 3DR") — reproduced independently, transcript GENUINE | **TRUE** ("both c2 messages reproduced verbatim" is loose wording → P4-1) |
| P2-1 (pin leg, named base) | the leg implemented EXACTLY as §1.3 words it (committed-vs-committed vs base 93f2825, non-empty required, comment-only, fail-closed blank); planted BOTH WAYS with scratch commits (destroyed, never pushed, hero_pawn restore-cmp byte-exact) | empty diff ⇒ **RED rc=1** (owes the re-word); comment-only re-word COMMITTED ⇒ **GREEN** (4 comment lines); code char (`minf`→`maxf`) COMMITTED ⇒ **RED rc=1** — the c2 scenario-C vacuous GREEN is structurally gone | **TRUE** |
| P2-2 (M6 footer 11/2/2/11) | shipped-instrument-shape parse of the committed footer, keyword in class vs verdict cell | `rows: 26  BOTH: 11  VERDICT-only: 2  CLASS-only: 2  neither: 11` — MATCH; the quoted s8 counterexample is row-accurate (class STAY-expected / verdict MEASURED SHIFT / owner `n/a — no shift`) | **TRUE** |
| P3-1 (A-11 real id list) | the SPEC's TWO NAMED commands verbatim (sed/awk extract → `grep ' '` → zero-hits grep), then trimmed-name variants at BOTH bases | extraction: **232 names** ✓; multi-word subset: **232, NOT 172** (the named awk does not trim — the parenthetical is false); zero-hits leg @79543fa: EMPTY ✓ **as executed**; @93f2825 (the committed tree): **1 HIT — docs/3DR-SPEC.md:769, the A-11 row itself** | **FALSE AT THE COMMITTED BASE → P1-1** |
| P4-1 (DIR cells truth) | `git ls-files assets/art-src \| wc -l`; `assets/concepts`; `godot/export` | 68 / 43 / ABSENT — MATCH; expansion ∅ re-derived in §5.5 LEG-8 shape (0 names from any other OWNED cell under the three dirs) | **TRUE** |

## B. NEW FINDINGS (all EXECUTED against 93f2825; capture `.tmp/3drda3.txt`)

### P1-1 — the A-11 fold row BROKE ITS OWN LEG: the zero-hits grep REDS on the committed tree, so NO card of the wave can close green as the row words it (§8.1 A-11; §10; REV-3 ledger P3-1 row)

**CLAIM under attack:** A-11 (REV 3): the two named commands were "both EXECUTED this
session" ⇒ zero-hits **EMPTY (rc 1)**, "At every card close: run both legs … EMPTY output
means PASS."

**CHECK (executed, LEG-6 + LEG-6b):**
```
git show 79543fa:docs/3DR-SPEC.md | grep -cw "King Bible"  → 0   (EMPTY leg TRUE at the measured base)
git show 93f2825:docs/3DR-SPEC.md | grep -cw "King Bible"  → 1   (RED at the COMMITTED base)
$ grep -rnwIF -f vsids-multi.txt(172, trimmed) --exclude=VS-FEATURES.md --exclude=PARITY-ROADMAP.md godot/ docs/
docs/3DR-SPEC.md:769: … its 4 multi-word hits King Bible/Santa Water/Lightning Ring/Fire Wand …
rc=0  ← NOT EMPTY — the hit is the A-11 ROW ITSELF; 3DR-SPEC.md is not in the excludes
```
The fold's own text (quoting the four v1 archetype names to describe the declared lineage)
introduced the 5th hit AFTER the leg was run — the row's "executed at 79543fa" is honest,
and the tree the fold then committed invalidates it. **TWO sub-defects ride the same row:**
(1) the named extraction command is unbuildable-as-written: the awk `gsub(/^ +\| +$/,"",$3)`
does NOT trim (the parenthetical "the awk gsub trims leading/trailing spaces" is FALSE), so
every name carries a leading space and the named `grep ' ' .tmp/vsids.txt` yields **232**
names, not the claimed 172 (the fold actually ran a DIFFERENT, trimming command —
`.tmp/run3.sh` — the capture itself says "full command in .tmp/run3.sh"); (2) WORSE, the
untrimmed pattern set is FALSE-NEGATIVE: the spec-as-written grep over the same universe
returned **EMPTY (0 hits)** where the trimmed set finds 1 — leading-space patterns drop
matches preceded by a word char, so the leg as named can MASK real clean-room leaks while
reading green.
**IMPACT:** the row is in EVERY card's close battery (a, r, c, z) and is non-empty on the
committed base ⇒ the battery cannot go green as worded — the same class as c1-P1-1 and
c2-P1-2, third cycle running; and the false-negative direction means even a green run of the
named command is not the evidence it claims.
**FIX (REV-4 deltas, three):** (i) fix the extraction — pipe through `sed 's/^ *//;s/ *$//'`
before `sort -u` (or awk `{gsub(/^ +| +$/,"",$3);print $3}`) and re-state the multi-word
subset count MEASURED at the REV-4 base (172 reproduces with the trim); (ii) add
`--exclude=3DR-SPEC.md` as the THIRD named clean-room citation exclusion, dated, with the
reason ("the spec's own declared-lineage mentions, the archetype-map law of this row") — OR
reword the row to spell the four names in a grep-proof form (e.g. `King B[i]ble`-style is
REJECTED: the exclusion is the mechanism the row already uses for the roadmap); (iii) re-run
both legs AT THE REV-4 COMMITTED base and carry those numbers (full-universe noise becomes
33 at 93f2825 with the trim — re-measure at the final base and keep the honest-scope note).

### P1-2 — the mesh/twin OWNED cells name `assets/glb/` where the live meshes and the runtime path are `godot/assets/glb/`; under the matrix's own literal law the 12 wave mesh writes are OWNED-by-NO cell, and a literal execution lands R's GPU twins in a dead directory (§5.1 A+R rows, §5.5, §3.3, §1.1 ART row)

**CLAIM under attack:** §5.1's header law ("every file ONE card") + §5.5 ("the proof runs on
NAMES") + §3.3 ("re-mastered meshes `assets/glb/<class>.glb` (v3, the live literal) + rig
twins `assets/glb/<class>-rigged.glb`") + §1.1's ART row "`assets/glb/*.glb` (43 live +
superseded archive dirs)".

**CHECK (executed, LEG-8 PATH-CHECK + path truth):** the repo has TWO `assets/glb` —
top-level (committed: 4 player/boss provenance copies + the `superseded/` archive dir) and
`godot/assets/glb/` (**the 43 live meshes** — `char-coinhound.glb` etc.). The runtime reads
`res://assets/glb/` — `res://` maps to `godot/` (roster.gd:41 "the GLB family under
res://assets/glb/"), i.e. repo path `godot/assets/glb/`; the proven pattern the spec itself
cites, `player-rigged.glb`, lives at `godot/assets/glb/player-rigged.glb` (plus a top-level
provenance copy). Every one of the twelve OWNED-cell names
(`assets/glb/char-coinhound.glb` … `assets/glb/skin-void-rigged.glb`) resolves to **no file
and no live path**: `exists=False` for all 12 as-written; `godot/`-prefixed exists=True for
the 6 current meshes (LEG-8 transcript).
**IMPACT:** (a) under the matrix's OWN literal semantics the wave's twelve mesh/twin writes
(A: six live-mesh replacements; R: six NEW twins) sit in files no OWNED cell names — the
c2-P1-1 completeness hole (required write owned by none) re-appeared in PATH form; the §5.5
proof cannot catch it because it proves over the cell names, which resolve to nothing;
(b) a literal-executing T-3DR-r ships the six rigged twins into the top-level dir the game
never loads — surfacing at r's own framediff/capture DoD (the capture consumer reads
`res://…`), after the UniRig windows spent. The anim-maps cells (`assets/anim/maps/…`) are
CORRECT as written (top-level dir exists, 9 committed maps) — the defect is the GLB cells.
**FIX (REV-4 delta, one rule):** prefix `godot/` on all twelve mesh/twin cells in §5.1 (A
row, R row), the §5.5 transcription and §3.3's New-files row; split the §1.1 ART row into
the two real dirs (`godot/assets/glb/*.glb` — the 43 live; `assets/glb/` + `assets/glb/
superseded/` — provenance + archive, which is also where A's "(+ their superseded moves)"
land); add one line stating `res://assets/glb/ == godot/assets/glb/` so the shorthand
cannot recur. (Maps + art-src + concepts paths stay as written — measured correct.)

### P2-1 — the completeness grep counts 29, not 28, in all five occurrences; the derived "24 rule-side" is 25 (§0 header, §5.5, §10, REV-3 ledger P1-1 row + counts)

**CHECK (executed, LEG-2):** the named universe (`git ls-files tests tools` = 102) and
pattern (`CLIP_SOURCE|clip_source|roster|statue`, `-liE`) re-run: the file list is
BYTE-IDENTICAL to the fold capture's own list — which lists **29 files** (18 tests + 11
tools) while the capture header and the spec say "28 hits" in five places (lines 18, 649,
858, 930, 940) and "24 rule-side/manifest/prose hits" (line 653). So the fold row's quoted
count contradicts its OWN transcript's list (and both re-runs): measured 29 = 4 flip-surface
readers + **25** rule-side.
**IMPACT:** the resolution logic is UNAFFECTED (the four readers re-verified; no 5th
live-seam reader exists — LEG-2 hunt: the only CLIP_SOURCE/clip_source files are the four
named, the only statics-count assert is test_motion.py:96) — this is a measured-count error
inside fold rows, the c2-P2-2 class (false measured claim in a fold row), not a hole.
**FIX:** "28 hits" → **29** (all five occurrences); "24 rule-side" → **25**; the capture
line the fold quotes re-dated to a re-run at the REV-4 base (file lists can grow with the
card's own commits — pin the count to the base, not to "this fold").

### P3-1 — the "NEVER three" duplicate-table grep has no named instrument and false-REDS on comments as worded (§5.3 T-3DR-c DoD; §9.3)

**CHECK (executed, LEG-9g):** uppercase `CLIP_SOURCE` appears in exactly 2 .gd files at base
— `roster.gd` (the table :161 **and** the reason-header comments :5/:8) and `hero_pawn.gd`
(comments + the :174 read). A post-split SIMULATION (table moved to `roster_clips.gd`,
`roster.gd` comments untouched — replace-not-delete keeps them as the SCHEDULED-split
lineage!): naive file-wise grep ⇒ **3 .gd files** — the leg "CLIP_SOURCE still TWO script
homes at close — NEVER three" REDS for the wrong reason at close unless C rewords the
comments, which the same doc's lineage law pushes against.
**IMPACT:** satisfiable (C owns roster.gd and may re-word) but the instrument is unnamed
and the naive reading is comment-fragile — the exact P1-2-c2 lesson (a leg must name its
command) applied to the wave's OTHER grep-leg.
**FIX (REV-4 delta, one sentence):** name the instrument: `grep -l "const CLIP_SOURCE"
godot/scripts/*.gd` = exactly ONE file (`roster_clips.gd`) — ONE TABLE — and `grep -l
"Roster.clip_source(" godot/scripts/*.gd` = exactly ONE file (`hero_pawn.gd`) — ONE
CONSUMER; comment mentions are lineage, NOT homes (state the reading).

### P4-1 — A-5's "both c2 messages reproduced verbatim" is loose: the reproduced messages are the REV-3 patch's own wording (semantics true) (§2.4 EXECUTED-PROOF, A-5, REV-3 ledger P1-2 row)

**CHECK:** c2's literal messages were `assert 1 >= 5` / `channel journey missing from
CAPTURE-DEVIATION-3DR`; the counterfactual (re-executed here) prints `3DR: only 2 shifting
rows` / `channel journey missing from 3DR` — the same failure REASONS (threshold / channel
universe), different strings (a parameterised leg necessarily re-words its own messages).
**FIX:** one word: "reproduced verbatim" → "reproduced for the same reasons (threshold +
channel universe)".

## C. SURVIVED — re-checked where REV 3 touched (the c1/c2 survivors stay immutable)

1. **Fixture arithmetic:** 13 jsonl / 2 CSVs / art-s2i 31 / roster-clips 55 / suite 381 —
   all MATCH (LEG-1); sigil_drop baseline 9 passed.
2. **§5.5 matrix (as strings):** all six pairs ∅, glob-expansion ∅, the four named
   owned-by-ONE files single, C = 12 entries (LEG-8) — the P4-1 DIR-cell story matches
   (68 / 43 / ABSENT). (The GLB-path defect above is about where the NAMES resolve, not the
   pairwise arithmetic.)
3. **The seven-edit buildability itself:** leg (i) GREEN with the honest 3DR shape proves
   the parameter design is SOUND — the fold's P1-2 disposition holds (its count claim P2-1
   here and its "verbatim" wording P4-1 do not reopen it).
4. **Pin-leg soundness:** GREEN on comment-commits / RED on code-commits / RED on empty —
   exactly as §1.3 words it now (LEG-4); hero_pawn.gd carries zero `"""` strings (c2
   measured; untouched).
5. **GPU LAW rows vs fleet law:** all six LAW rows greppable (§5.4): backup-gate FIRST
   (LAW-GATE — its cite RELEASE-v3.1.0.md:97-99 is real: "parked on the owner's vm100
   backup window"), drain_barrier, single-row (honestly re-cited per c2 P3-2), trap-close
   rc=0, verifier-at-close, rc-is-not-truth; rig-yield TWO-FAIL STOP + owner-vetoable
   shipped-state fallback + 1/3 reserve (§3.3 + RIG-DEVIATION-SEL-C:11 measured).
6. **Serial edges named with what-waits-what:** GATE→a→r→c→z→GA→q pair (§5.2): a→r meshes,
   r→c the pin doc's measured outcomes, c→z the final tree; within-wave parallelism
   disallowed by the chain itself — stated.
7. **§2.4 owner-ratification ask-text + §6.1 version row are DERIVABLE from doc rows alone:**
   the ask rides §2.2's two REMINT rows (channels + mechanisms named), the reply format +
   empty-cell rule ride §2.4 verbatim law + edits 2/3, the fallback veto is §3.3's named
   declared reading, and §6.1 carries the recommendation (v4.0.0) AND the honest alternative
   (v3.2.0) with the no-manufactured-consent law — no conversation needed (ratification-ask
   law holds).
8. **Acceptance honesty:** §8.1 header + A-11/A-12 seat-runnable declarations match the D3
   cap; §8.2 rows carry declared instruments (browser + describe-image), never faked as
   executable. Strips HOLD row's "75 dumps" is real (75-row committed dumps — measured).
9. **The SD-E6 quote + protected-literals:** unchanged from the c2 byte-comparison (TRUE;
   the protected M6 leg re-ran GREEN byte-untouched inside this cycle's LEG-3).

## WHAT SHIPS FIX — the exact REV-4 deltas (CAP cycle: the wave stays blocked until these land; orchestrator escalates package-blocked to the owner per M6 cap law)

All findings are spec-text deltas — no design change, no ownership reshuffle, nothing the
design profile cannot land in ONE revision:

1. **P1-1 (A-11):** trim the id extraction (name the fixed command), add
   `--exclude=3DR-SPEC.md` as a third dated clean-room citation exclusion, re-run BOTH legs
   at the REV-4 base and carry the re-measured numbers (172 multi-word with the trim; the
   full-universe noise count at the final base; zero-hits EMPTY AT THE COMMITTED BASE).
2. **P1-2 (mesh paths):** `godot/assets/glb/…` on all twelve mesh/twin cells (§5.1 A+R,
   §5.5, §3.3); §1.1 ART row split into the two real dirs; one line naming
   `res://assets/glb/ == godot/assets/glb/`.
3. **P2-1 (counts):** 28→29 (five occurrences), 24→25, count pinned to a base SHA.
4. **P3-1 (never-three):** name the two greps (ONE const home + ONE consumer; comments are
   lineage).
5. **P4-1 (one word):** "reproduced verbatim" → "reproduced for the same reasons".

The DESIGN survives untouched: the HOLD/REMINT law, the seven-edit parse instrument, the
pin leg, the ownership law, the GPU LAW rows, the wave shape and the consent rows all held
their re-execution. REV 4 must carry the dated fold rows (M6 REV-FOLD law) re-measured ON
THE REV-4 TREE — P1-1 is precisely the class that dies when the proof base and the commit
base differ.

# VERDICT: FIX
