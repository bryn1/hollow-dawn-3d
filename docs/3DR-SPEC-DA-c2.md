# 3DR-SPEC-DA-c2 — Devil's-Advocate gate, MC 11731, cycle 2/3 — target `docs/3DR-SPEC.md` REV 2

- **Author:** devils-advocate (11731). Filed 2026-10-30. Base: `origin/master = b16afe8`
  (REV 2 fold commit; `git worktree .tmp/wt-3drda2 -b feat/3drda2 origin/master`).
- **Law:** M6-DA — every finding carries an EXECUTED check + quoted output, re-runnable from
  a clean checkout of this base. This doc is immutable at its commit; the spec revises IN
  PLACE (M2–M6 precedent). c1 (`docs/3DR-SPEC-DA.md` @ cc33294) is IMMUTABLE — never edited.
  **M6 DA-c2 precedent binding here: a fold row that lies is worse than the original hole —
  adopted-but-not-really-fixed is a P1.**
- **Method:** (a) FOLD-CHECK — each of c1's 13 instruments RE-RUN on REV 2 (§A); (b) NEW
  ATTACKS on what REV 2 CHANGED: the five parse-pin edits EXECUTED as a scratch patch on the
  real `tests/test_sigil_drop.py` (cp+cmp restore after — the worktree is byte-exact again),
  the hero_pawn comment-only pin leg PLANT-TESTED, §5.1 re-derived fresh, fixture arithmetic
  and version/consent rows re-measured (§B). c1 survivors re-checked ONLY where REV 2 touched
  them (§C). Full outputs: `.tmp/3drda2.txt`. NOISE: nothing under `.audits/*/out` written;
  GPU untouched; :8123 untouched; NO SPAWNING.
- **Verdict summary: 2 P1 / 2 P2 / 1 P3 / 1 P4.** The P1s are the SAME failure class as
  c1's two P1s: the spec's own close-battery cannot go green as written — REV 2 fixed the
  P1-2 it was shown but introduced/buried the next instance of it (an unowned required file;
  edits that miss a hardcoded value the fold's own probe silently dropped).

## A. FOLD-CHECK — 13/13 c1 instruments re-run on b16afe8

Score: **9 fold rows VERIFIED TRUE; 1 NOT-REAL (→ c2 P1-2); 3 HALF** (the P2-1 pin leg,
→ c2 P2-1; the P3-1 rationale claim, → c2 P2-2; the P4-3 named-command, → c2 P3-1).

| c1 finding | instrument re-run | measured on REV 2 | fold row |
|---|---|---|---|
| P1-1 | `ls tests/fixtures/*.jsonl \| wc -l` = **13**; `*.csv` = **2**; art-s2i **31** rows; roster-clips **55** lines; §2.1 row 2 says **12 strict jsonl**; §5.3 **journey + 12**; A-1 **12**; F-7 **15 files = 13 strict .jsonl (art-s2i IS one of the 13)**; §10 14 = journey+12+CSV | arithmetic holds everywhere, struck-dated lineage kept | TRUE |
| P1-2 | the five edits EXECUTED (scratch patch, §B-1) + the fold's own probe `.tmp/3drspec2-probe.py` re-run | probe PASSES (exit 0) — but the real battery with the five edits REDs on two UNPARAMETERISED M6 hardcodes | **NOT-REAL → P1-2** |
| P2-1 | `grep -n statue godot/scripts/hero_pawn.gd` → `22:# …the six owner-"Rec" statue classes…`; §1.3 exception + §5.1 C-ownership + §6.2 yielding-law all present; pin leg PLANT-TESTED (§B-2) | exception real; leg as worded GREEN on a COMMITTED code edit | HALF → P2-1 |
| P2-2 | `grep -rn SKILL_FX godot/` → **15 hits / 3 files**; per-file: viz_fx **9**, upgrades_visual_capture.gd **5**, weapons.gd **1**; harness lines exactly `:3 :387 :399 :415 :466`; weapons.gd:38 = the wid-stamp comment; viz_fx `:71` table + `:275`/`:407` dispatch; fold row carries the DA erratum + the **5** correction | measured = claimed = the DA's own erratum check (15/3 = 9+5+1, "+5" in the row) | TRUE |
| P2-3 | `ls ../vampire_survivor/docs/` → ARCHITECTURE/COMPARISON/RESEARCH only (NO DESIGN-3D); `git ls-files docs/ \| grep -c DESIGN-3D` → **1**; DESIGN-3D :4-5 carries the founding quote; :221/:242/:266 carry the plan-40/hard-60 rows | convention corrected exactly as measured | TRUE |
| P3-1 | python byte-compare BYTE-DEVIATION-M6.md:38-44 vs the §2.4 quote | WORD-FOR-WORD identical (diff shows only the dropped leading `- **` bullet + re-wrap — wording/punctuation exact); BUT the fold row's rationale claim "M6 rows carry the keyword in both cells" is FALSE (§B-3) | quote TRUE / claim HALF → P2-2 |
| P3-2 | `grep "single-row windows only"` → only struck text + ledger lineage; LEDGER :30 (T-M1c2) carries "single-row windows thereafter"; T-M6z :79 "T-M6a-SKILLART conditional not fired"; M6-SPEC :481 = planned wording for the never-fired card | re-citation matches the real shipped sources | TRUE |
| P3-3 | `sed -n '32,33p' docs/M6-SPEC.md` → "the v4.0.0 counter-offer is RETIRED-IN-ROW (struck, dated)" — the §6.1 inline cite is byte-matching; `grep -n MAJOR-v4` → no live row | struck dated; recommendation stands alone | TRUE |
| P4-1 | `grep -n "§0.3" docs/3DR-SPEC.md` → struck lineage only, resolves to item 3 → §3.2 | fixed | TRUE |
| P4-2 | `python3 -m pytest --collect-only -q` → **381 tests collected** | A-2 says 381 (stale 380 struck) | TRUE |
| P4-3 | `grep -rln playwright tools/ tests/` → **0**; autopilot: no committed instrument; A-11/A-12 relabelled seat-runnable — **but A-11's "ONE named command" carries the placeholder `<v1 id list>`** | half: label honest, command still not stranger-runnable | HALF → P3-1 |
| P4-4 | `find . -name "*journey*"` → **0**; `5d863b80` recorded in RELEASE-v3.1.0.md AND BYTE-DEVIATION-M6.md | md5-vs-recorded-digest instrument named honestly | TRUE |
| P4-5 | R row now NAMES the six twins + six maps; `player-rigged.glb` + `boss-warden-rigged.glb` exist and appear in NO OWNED cell; GLOB LAW row present | TRUE with one compliance note (→ P4-1) | TRUE |

## B. NEW FINDINGS (all EXECUTED against b16afe8)

### P1-1 — the flip BREAKS `tests/test_motion.py`, which the §5.1 matrix owns to NO card: the completeness leg c1 P1-2 named, fixed for one file and missed for the next (§5.1, §5.3, §8 A-1/A-6)

**CLAIM under attack:** §5.1's header law ("every file ONE card") + §5.3 T-3DR-c DoD
("flips land per the pin doc; … suite green"); §5.5 re-proved only DISJOINTNESS (6/6 ∅ —
c1: "proves disjointness only, not completeness"; REV 2 re-ran that leg, not completeness).

**CHECK (executed):**
```
$ grep -n "statue\|CLIP_SOURCE" tests/test_motion.py   (excerpt)
94:  def test_clip_source_static_rows_name_no_clip():
95:      rows = clip_source_rows()        # parses the LIVE CLIP_SOURCE const
96:      statics = sorted(f for f, s in rows.items() if s is None)
96:      assert len(statics) == 6, ("the six owner-'Rec' statue classes stay static; …")
$ grep -c "test_motion" docs/3DR-SPEC.md   → 0     (never named, never OWNED)
```
§5.1 re-derived fresh from the table cells (all names, this session): A∩R, A∩C, A∩Z, R∩C,
R∩Z, C∩Z all **∅**; `hero_pawn` and `test_sigil_drop` each owned by exactly ONE card (C);
C's OWNED count **11** (the fold row's 9→11 correct) — and `test_motion owned-by: []`.

**IMPACT:** every rigged flip removes a `null` row ⇒ `statics < 6` ⇒ the test REDS at
T-3DR-c close, contradicting its own DoD ("suite green"). The card must either edit a file
§5.1 grants to nobody (violating the one-owner law the §5.5 proof rests on) or close RED.
The all-double-fail path (§3.3) keeps 6 — but that is the NO-SHIP path; a SUCCESSFUL wave
breaks an unowned test. Same shape as c1-P1-2 (required-edit file owned by NO card) and as
the P1-1 battery-fork: the gate cannot close green as written.
**FIX:** add `tests/test_motion.py` to T-3DR-c's OWNED set (re-pin the statics count to the
measured post-flip state, dated; the MV-E4 planted-red legs `static row carries a walk clip`
stay untouched — §5.3/A-4 reuses them and they survive any flip), re-run §5.5 (C gains a
12th entry), and run the COMPLETENESS leg, not just disjointness: every committed test that
PARSES a file T-3DR-c edits must itself be C-owned (`grep -rln "CLIP_SOURCE\|roster\|statue"
tests/ tools/` over the flip universe — this pass shows `test_motion` is the one hit; the
tools/driver side reads the LIVE seam (`roster_capture.gd` mints state from it), verified).

### P1-2 — "the five edits, named so the card can execute them" is FALSE by execution: with the five applied, A-5's leg (i) CANNOT go green, and the fold's probe PASSed only because its copy SILENTLY DROPPED the M6 threshold (§2.4, §5.3, A-5, §10)

**CHECK (executed):** the five §2.4 edits applied VERBATIM-as-specced to the real
`tests/test_sigil_drop.py` (scratch PATCH in the .tmp worktree; matrix entry per doc; the
M6 entry keeps 26/quote/2026-10-29; edit 5's independent empty-cell assert BEFORE the
verbatim check; file restored `cp`+`cmp` byte-exact after, `git status` clean):

```
SCRATCH RUN 1 — A-5 leg (i): 3DR footer shape + VALID package reply (spec claims GREEN):
FAILED test_deviation_doc_footer_contract — AssertionError: every declared SHIFTS/… 
    assert 1 >= 5                     ← the M6 THRESHOLD (shipped :242), NOT parameterised
FAILED test_deviation_doc_names_the_at_risk_channels
    AssertionError: channel journey missing from CAPTURE-DEVIATION-3DR
    ← the second doc-reading test hardcodes the M6 channels ("journey","strips",
      "s8 capture") + the PENDING rule; edit 1 names the "doc-reading tests" but the
      five edits carry NO parameter for the channel universe
SCRATCH RUN 2 — leg (ii) EMPTY cell (COPY):    RED for the EMPTY-CELL reason ✓ (edit 5 works)
SCRATCH RUN 3 — leg (iii) M6 regression:       GREEN (26 rows / 13 shifting verbatim+date /
                                               5-col header, doc byte-untouched) ✓
```
**The probe's false proof (the M6 DA-c2 class, executed):** the fold's instrument
`.tmp/3drspec2-probe.py` re-runs and reports `PROBE_RESULT: PASS (exit 0)` — because its
copied `contract()` carries **zero** occurrences of `shifts` (grep = 0), i.e. it dropped
the shipped `assert shifts >= 5` at `test_sigil_drop.py:242`, and it parses an embedded
LEG1 string rather than ever driving the real file. A GREEN proof-of-a-copy is not a
proof-of-the-instrument: the fold row "the instrument is ONE parse function … the five
edits, named so the card can execute them" + §10 "probe 3 legs" is FALSIFIED by executing
exactly those five edits on the real file. §2.2's REMINT universe (2 REMINT rows, RE-MEASURE
is not a shifting keyword) can never satisfy a ≥5 threshold under ANY honest 3DR doc.

**IMPACT:** T-3DR-c's parse battery (A-5's three-leg proof, the §5.3 parse DoD) is
unbuildable-as-described a second cycle running — either the card exceeds its §2.4 edit
contract (an unlisted parameterisation) or A-5's leg (i) never goes GREEN. The A-5 leg (iii)
wording itself is safe (M6 entry verified GREEN) — the hole is the missing parameters +
the probe proving the wrong function.
**FIX:** name the SIXTH and SEVENTH edits: (6) the `shifts >= 5` threshold → a per-doc
parameter (M6 entry 5 — measured today: 13 shifting rows; 3DR's pinned when its footer
rows land — ≤2 under §2.2, so the honest 3DR entry value is 1 or 2); (7) the second
doc-reading test's channel universe (`journey/strips/s8 capture`) → a per-doc parameter
(the 3DR entry: its §2.2 channels) OR scope that leg explicitly to the M6 doc, DECLARED,
with the 3DR doc's own at-risk-channels leg named. Re-run the three-leg proof driving the
REAL `test_sigil_drop.py` (not a hand-typed copy): legs (ii)+(iii) already go green/red for
the right reasons in this scratch run — leg (i) goes GREEN the moment edit 6 lands (proven:
with the threshold bypassed the 3DR rows pass through edit-5 + verbatim + date cleanly).

### P2-1 — the hero_pawn comment-only PIN LEG, worded as-specced, passes GREEN on a COMMITTED code edit: at close the leg is vacuous (the c1 P2-1 fix half-real; the fold's "planted RED on any non-comment hunk" is false as worded) (§1.3, §5.3, §6.2)

**CHECK (executed — the leg PLANT-TESTED exactly as §1.3 words it: "at T-3DR-c close,
`git diff` over `hero_pawn.gd` must show EVERY changed line a comment (starts `#` after
strip)"):**
```
scenario A  comment-only re-word of :22, working tree … PIN-LEG GREEN (3 lines, all comments) ✓
scenario B  ONE code char flipped, working tree ……. AssertionError: NON-COMMENT changed
            line: '…HordeViz.GAIT_FREQ_MAX)'  rc=1 (RED) ✓
scenario C  the same code edit COMMITTED (scratch commit b505840, then reset), the leg run
            AT CLOSE exactly as worded (bare `git diff`):
            PIN-LEG GREEN (0 changed lines, all comments)  rc=0  ← VACUOUS
            same edit vs a NAMED BASE (git diff b16afe8 -- …): RED ✓ (rc=1)
```
Every card commits before it closes; a bare `git diff` at close is empty by construction, so
"any non-comment hunk ⇒ leg RED" cannot fire on the state the DoD names. The fleet precedent
already names bases ("both CSVs zero git-diff **since 290534f**", T-M6z). The `#`-after-strip
mechanic itself is sound HERE: hero_pawn.gd carries **zero** `"""` strings (measured), and
the leg is fail-closed on re-flow blank lines (a comment re-flow that ADDs a blank line
REDDENS it — acceptable direction, note it).
**FIX:** one clause — name the diff base (`git diff <base-of-T-3DR-c>..HEAD --
godot/scripts/hero_pawn.gd`, base = the commit C branches from) + keep the planted case.

### P2-2 — the P3-1 fold row's rationale claim "M6 rows carry the keyword in both cells" is FALSE at the protected M6 doc (a false measured claim in a fold row — the c1-P2-2 class, in the fold ledger itself) (§2.4, fold ledger P3-1)

**CHECK (executed):** parsing the committed `BYTE-DEVIATION-M6.md` footer (26 rows),
keyword (SHIFTS/REMINT/RE-DERIVE) in class-cell vs verdict-cell:
```
rows: 26   keyword in BOTH cells: 11   VERDICT-only: 2   CLASS-only: 2
row 11: channel=s8 capture tables | class=STAY-expected | verdict="MEASURED SHIFT — A1-…"
        | owner="n/a — no shift"
row  4: class=AT-RISK (no kw) + verdict "…SHIFT REMINTED…" | row 10: class=RE-DERIVE +
        verdict "MEASURED STAY …" | row 16: class=REMINT (kw in both directions covered)
```
So the mismatch §2.4 resolves for 3DR was **not** silent at M6: the s8 row declares a
MEASURED SHIFT in the cell the quoted law says governs (VERDICT), and the instrument reads
CLASS — it rode through on `n/a — no shift` (law-legal under the law's NON-EMPTY wording,
never the verbatim answer — but the fold row asserts such rows do not exist). The
cell-of-record DECLARATION itself is fine for the new doc (an explicit reading, stated);
what fails is the historical fact, inside the fold ledger, asserted as measured.
**FIX:** correct the P3-1 fold row's rationale: "11/26 carry it in both; 2 verdict-only
(one: the s8 row, closed `n/a — no shift` under the law's NON-EMPTY wording) and 2
class-only rows exist — 3DR's class-cell declaration is a CHOICE, not a M6 fact".

### P3-1 — A-11's "ONE concrete command so a stranger re-runs it" still contains a PLACEHOLDER (`<v1 id list>`), so the P4-3 fold's stated purpose is unmet (§8.1 A-11)

**CHECK (executed):** the row literally reads `grep -rniE "<v1 id list>"
--exclude=VS-FEATURES.md godot/ docs/` — the id universe is nowhere named or committed
(the v1-byte pin that exists is `test_card_icons`'s, measured: it is a byte-pin, not the
list). A stranger cannot run the command.
**FIX:** one clause: the id list = the ids extracted from `docs/VS-FEATURES.md` by a named
command (emit it IN the capture: `grep -o … VS-FEATURES.md > .tmp/vsids.txt` then
`grep -rnif .tmp/vsids.txt …`), so both legs of the leg are re-runnable.

### P4-1 — §5.5's GLOB LAW is enforced on R/C only: the A row still holds `assets/art-src/*` + `assets/concepts/*` and Z holds `godot/export/**` while the §5.5 row claims "all names, no globs" (§5.1, §5.5)

**CHECK (executed):** the re-derivation above (§A) proves the pairs ∅ EVEN UNDER expansion
(no other set names any path inside those dirs — so the proof is vacuously true, not
broken), but the §5.5 header sentence overstates compliance: only R/C were glob-narrowed.
**FIX:** state "A/Z glob cells own dirs no other cell names — expansion is ∅ by
construction, verified this session" (one dated line) or narrow the A cells to names at
the first-commit manifest (`tools/vm100/art-batch-3dr.tsv` already names them).

## C. SURVIVED — re-checked ONLY where REV 2 touched (the rest stands from c1, immutable)

1. **Mechanism-monogamy core (F-1/§1.3):** `CLIP_SOURCE` lives in exactly TWO script files
   at b16afe8 (`roster.gd` + `hero_pawn.gd`, grep fresh); the ONE consumer read
   `Roster.clip_source(_player_glb())` verbatim at :174; §5.3's duplicate-table grep
   (NEVER three) is satisfiable. The comment-only exception does not create a third home
   (comment lines are not a consumer — c1 SURVIVED-1 holds).
2. **The M6 regression leg (new in REV 2):** EXECUTED GREEN against the committed doc —
   26 rows, 13 shifting rows carrying the verbatim + 2026-10-29, 5-col header, doc
   byte-untouched (scratch run 3). The PROTECTED claim is true; only the 3DR-forward legs
   fail (P1-2).
3. **The fixture arithmetic (P1-1 fold):** 13 jsonl / 2 CSVs / art-s2i 31 / CSV 55 all
   re-measured exactly as the fold claims; the 12-row HOLD list names 12 real files
   (verified against `ls`).
4. **Version/consent rows (§6.1/§6.2):** no manufactured consent; the struck M6 cite is
   byte-matching and correctly characterised; the honest v3.2.0 alternative stands
   (c1 SURVIVED-5 upheld); the §6.2 hero_pawn sentence matches the §1.3 exception exactly
   (law named, sweep not narrowed).
5. **The GPU LAW rows REV 2 re-cited:** LAW-SINGLE-ROW's real sources verified
   (T-M1c2 line, T-M6z SKILLART "conditional not fired"); LAW-GATE/BARRIER/TRAP-CLOSE/
   VERIFIER/ARTIFACTS rows are LEDGER facts unchanged from c1 SURVIVED-4.
6. **Founder order rows:** the founding quote still matches pin-grep whole on ONE line
   (awk/grep count = 1); "3d remake first then m7" unchanged.

## WHAT SHIPS FIX

All six findings are spec-text/matrix/prose fixes — two OWNED-cell additions (test_motion;
glob sentence), two parameter names (threshold + channel universe), one diff-base clause,
one corrected fold-ledger rationale, one id-list command. The DESIGN survives unchanged;
the fold ledger's dispositions are sound except where the measurements above contradict
them. REV 3 must carry the dated fold rows again. This is FIX, not RECONSIDER.

# VERDICT: FIX
