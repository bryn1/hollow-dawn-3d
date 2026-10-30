# 3DR-SPEC-DA — Devil's-Advocate gate, MC 11725, cycle 1/3 — target `docs/3DR-SPEC.md` REV 1

- **Author:** devils-advocate (11725). Filed 2026-10-30. Base: `origin/master = 6eb7ab5`
  (spec REV 1 @a975433 + its hygiene fix 6eb7ab5; `cb4a95e` — the spec's own base — VERIFIED
  ancestor via `git merge-base --is-ancestor cb4a95e HEAD` → ANCESTOR-OK).
- **Law:** M6-DA — every finding carries an EXECUTED check + quoted output, re-runnable from
  a clean checkout of this base. This doc is immutable at its commit; the spec revises IN
  PLACE per verdict (M2–M6 precedent). DA docs are not product: no LEDGER row (per brief).
- **Verdict summary: 2 P1 / 3 P2 / 3 P3 / 5 P4.** The two P1s are internal contradictions
  inside the spec's own EXECUTABLE battery (§8.1/§2/§5) — the wave as written cannot close
  green without violating one of its own laws.

## FINDINGS (ranked)

### P1-1 — the HOLD list mislabels its 13th channel: `art-s2i-probe.jsonl` is both HELD and REMINTed; the A-1/T-3DR-c battery as written cannot go green (§2.1 line 2, §2.2, §5.3, F-7, A-1)

**CLAIM under attack:** §2.1 HOLDS "13 strict fixtures" byte-identical, "per the brief (each
row = the instrument `cmp` …)"; §5.3 T-3DR-c DoD runs "the §2.1 HOLD table `cmp`-identical
(journey + 13)"; A-1 repeats "the 13 strict fixtures `cmp` IDENTICAL … (the §2.1 HOLD list,
verbatim)". §2.2 simultaneously REMINTs `art-s2i-probe.jsonl` (heights) and T-3DR-c OWNS it.

**CHECK (executed, repo root):**
```
$ ls tests/fixtures/*.jsonl | wc -l   → 13
$ ls tests/fixtures/*.csv   | wc -l   → 2      (15 files total)
$ ls tests/fixtures/
achv-m5.jsonl         chars-m5.jsonl  gem-merge-m2g.jsonl  stages-m3.jsonl
art-s2i-probe.jsonl   chests-evolve-m1e.jsonl  limit-m4.jsonl  unions-m2u.jsonl
carry-caps-m1b.jsonl  chests-tiers-m2.jsonl    reaper-m4.jsonl
…  (13 jsonl + roster-clips-m5-framediff.csv + skinned-clips-s2r-framediff.csv)
```
§2.1's line NAMES twelve jsonl (carry-caps, chests-evolve, chests-tiers, endless, events,
gem-merge, limit, reaper, stages, unions, achv, chars). The 13th jsonl on disk is
**`art-s2i-probe.jsonl` — the §2.2 REMINT subject**. The re-mastered v3 meshes change the
heights the probe measures (art_probe.gd enumerates `Roster.CHARACTERS` + `SKINS` +
`HordeViz.GLB_FILES`, art_probe.gd:80/135/159), so the file WILL byte-change — cmp-IDENTICAL
and REMINT are mutually exclusive for it.

**Corroboration the spec missed:** F-7's own arithmetic is self-contradictory — "15 files
(13 strict jsonl + art-s2i-probe.jsonl + 2 framediff CSVs)" sums to 16, not 15: art-s2i IS
one of the 13 strict jsonl, the author counted it as a 14th. And T-M6z shows why M6 could
HOLD all 13: "every STAY row 0 (… art-s2i)" — M6 touched zero meshes; 3DR's whole subject is
the six meshes. §10's "14 channels incl. journey" is only self-consistent if the HOLD jsonl
count is 12 (1+12+1 skinned CSV) — the §2.1 row label and A-1 say 13.

**IMPACT:** T-3DR-c's DoD battery is unsatisfiable verbatim: either the card cmp-fails on a
legitimately REMINTed channel, or the author silently drops art-s2i from "13", or the gate
contradicts the deviation doc — exactly the byte-law fork M1–M6 paid to kill.
**FIX:** relabel §2.1 row "**12** strict jsonl (the 13th jsonl, art-s2i-probe, is §2.2's
REMINT)", fix A-1 + §5.3 "(journey + 12)", fix F-7's parenthetical to "13 jsonl (art-s2i
included) + 2 CSVs = 15".

### P1-2 — A-5's instrument (the "SD-E6 parse, doc-path parameterised") is unbuildable-as-described and its file is owned by NO card: a gate row no card builds (M6 F-1 class) (§2.4, A-5, §5.1)

**CLAIM under attack:** §2.4: "The parse-instrument = the shipped SD-E6 idiom extended to
parse the new doc (one mechanism, new doc path — the leg parameterised by doc path, NO second
table parser)"; A-5: "empty OWNER-RATIFICATION cell on a declared REMINT row ⇒ RED | the
SD-E6 parse, doc-path parameterised".

**MINIMAL PARSE PROBE (executed):** the shipped parser copied VERBATIM from
`tests/test_sigil_drop.py` (`_footer_rows` + the contract asserts, only the PATH parameterised
— the script itself is a DA scratch instrument, its full source and run are transcribed in
the capture `.tmp/3drda.txt`):
```
$ python3 .tmp/probe_sde6_3drda.py
legA(§2.4-shape + empty cell) RED: AssertionError: the footer header IS the parse contract (5 cols, owner cell last)
legB(M6-shape + empty cell)   RED: AssertionError: declared-shift cell must carry the owner reply VERBATIM: roster-clips-m5
legC(M6-shape + valid 3DR reply) RED: AssertionError: declared-shift cell must carry the owner reply VERBATIM: roster-clips-m5
```
Three executed facts: (i) the §2.4-prescribed column set (`channel | shifting card |
mechanism | declared diff | STAY rows | OWNER-RATIFICATION`) is NOT parseable by the shipped
leg at all — its header contract asserts 5 columns `channel|class|verdict|mechanism|owner-ratification`
(test_sigil_drop.py:203-206); the §2.4 doc shape as specced never reaches the empty-cell rule.
(ii) the shipped leg's empty-cell RED is a SIDE EFFECT of a hardcoded M6 verbatim assert
(`verbatim = "Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy"`, test_sigil_drop.py:231)
— a shifting row's own branch has NO independent non-empty assert. (iii) legC: a *correct*
3DR-package owner reply ("Rec all. v4. ok", 2026-11-02) goes RED — the verbatim string, the
ruling date `"2026-10-29"` (:236) and the row count `assert len(rows) == 26` (:228) are all
hardcoded to M6. So "the leg parameterised by doc path" is not the only parameterisation
needed: path + quote + date + row-count + a new independent empty-cell assert are five edits,
all in `tests/test_sigil_drop.py`.

**And the matrix has no owner for it.** §5.1's OWNED columns (executed completeness probe,
capture-quoted): `required-edit tests/test_sigil_drop.py: owned-by-matrix=False` while
roster.gd/tests×3 are `owned-by-matrix=True`. §5.1's header law: "every file ONE card";
§5.5's pairwise ∅ recompute is TRUE for the listed names (verified EMPTY on all six pairs)
but proves disjointness only, not completeness. T-3DR-c closes green while A-5's instrument
is unbuilt by law.

**FIX:** add `tests/test_sigil_drop.py` to T-3DR-c's OWNED set; state the five parameterisation
edits (or extract a shared parse function once, two doc-paths, per replace-do-not-add); align
§2.4's column list to the shipped 5-col contract (channel|class|verdict|mechanism|owner-ratification)
or explicitly declare the header-contract change. Add the independent non-empty assert on the
shifting branch so legB's RED does not depend on the M6 quote.

### P2-1 — §6.2's retired-claim grep-to-zero collides with §3.4/§3.5's hero_pawn.gd ZERO-EDIT: a stale live-read claim survives IN a file the spec forbids touching

**CHECK (executed):**
```
$ grep -n "statue" godot/scripts/hero_pawn.gd
22:# static rows (CLIP_SOURCE null, the six owner-"Rec" statue classes) take
```
At GA a flipped row makes "the six … statue classes" a stale live-read count claim. §6.2(2):
"no stale claim survives — the retired-claim grep-to-zero law"; the fleet treated exactly this
class as P1 when it sat in code comments (LEDGER T-M6q2: "grep-to-zero over the CODE universe
— m6z's sweep had covered docs only"). §3.4/§3.5 forbid any hero_pawn.gd edit. The roster.gd
`statue-class static` comments move under T-3DR-c's seam edit (resolved there); hero_pawn is
the sole contradiction the spec does not name.
**FIX:** §6.2 must name the law that yields — either the ZERO-EDIT law carries a dated comment-
exception row for T-3DR-c/z (comment-only, law-3 precedent T-M6q2 W1), or the sweep scope
excludes zero-edit files and says so.

### P2-2 — §0 F-6's "code truth" grep claim is FALSE at the spec's own base (§0 "re-grepped THIS session", §10 self-check row 1)

**CHECK (executed):**
```
$ grep -rn "SKILL_FX" godot/ | wc -l   → 15   (F-6 claims 9)
$ grep -rln "SKILL_FX" godot/          →
godot/sim/upgrades_visual_capture.gd   godot/scripts/weapons.gd   godot/scripts/viz_fx.gd
```
F-6 claims the grep yields "9 sites, all in `viz_fx.gd` + its header comment". Measured: 15
hits across THREE files — `upgrades_visual_capture.gd` reads `WeaponFxViz.SKILL_FX[wid]` at
:415/:466 (four hits), `weapons.gd:38` documents the wid stamp (one hit). The load-bearing
"ONE dispatch site" survives (the in-game lookup is `SKILL_FX.get` viz_fx.gd:275/:407 and the
capture harness is capture-side), so no functional harm to the wave — but §0 is the section
the spec itself bills as "every claim re-grepped THIS session" and §10 ticks that claim; this
row was not grepped. An unfalsified §0 is not a §0.
**FIX:** restate F-6: "9 hits in viz_fx.gd (+2 in the capture harness + 1 in weapons.gd,
comments/reads; the ONE in-game dispatch stays viz_fx:271-275/407)".

### P2-3 — the §Cite convention sends the §1.4 fold-table cites to the v1 repo, where DESIGN-3D.md does not exist (broken citation path on the load-bearing fold table)

**CHECK (executed):**
```
$ ls /home/claudecode/Games/vampire_survivor/docs/
ARCHITECTURE.md  COMPARISON.md  RESEARCH-3D-3090.md      (no DESIGN-3D.md)
$ sed -n '4,5p' ../vampire_survivor/docs/DESIGN-3D.md    → sed: No such file or directory
$ git ls-files docs/ | grep -c DESIGN-3D                → 1  (it is git-tracked HERE)
```
Spec lines 9-13: "`DESIGN-3D.md` and `RESEARCH-3D-3090.md` are the V1-repo docs; citations to
them are path-relative to THAT repo." False for DESIGN-3D.md — it lives in THIS repo
(`docs/DESIGN-3D.md`; its :4-5 carries the founding quote exactly as the spec's "DESIGN-3D:4-5"
cite resolves HERE; :22/:33/§b plan-40/hard-60 lines verified locally at 221/242/266).
RESEARCH-3D-3090.md is the only true v1-doc cite. A DA or card following the stated convention
for D-1..D-10 hits a dead path (this DA's first fetch did).
**FIX:** correct the convention line: DESIGN-3D.md cites are THIS repo; RESEARCH-3D-3090.md
cites are `../vampire_survivor`.

### P3-1 — §2.4's SD-E6 law "carried VERBATIM" is a paraphrase (the spec violates its own quote-cell law while quoting it); the doc-vs-parser cell mismatch is inherited too

**CHECK (executed):** BYTE-DEVIATION-M6.md:38-44 verbatim: "every channel row whose VERDICT
cell contains SHIFTS / REMINT / RE-DERIVE (case-insensitive) must carry a NON-EMPTY
OWNER-RATIFICATION cell before the shifting card closes." The spec's quotation
("…channel's OWNER-RATIFICATION cell carries the verbatim quote + the date … a NON-EMPTY cell
is the gate contract…") is not that text — the ellipsed fragments don't match, and "carries
the verbatim quote + the date" is imported from elsewhere (the §9 REV-4 ruling row, LEDGER
T-M6-AMEND). Additionally the SHIPPED instrument tests the **class** cell, not the verdict
cell (`cls = r["class"].upper()`, test_sigil_drop.py:229) — the doc's own wording and the
instrument disagree; the spec inherits the doc wording.
**FIX:** quote :38-44 exactly (or drop "VERBATIM"), and when P1-2's leg is written, pick the
cell of record (class) and say so.

### P3-2 — LAW-SINGLE-ROW attributes the law to the never-fired T-M6a-SKILLART "precedent" and quotes a sentence that exists nowhere (§5.4)

**CHECK (executed):**
```
$ grep -rn "single-row windows only" docs/ LEDGER.md   → docs/3DR-SPEC.md:372 ONLY
$ grep -n "T-M6a-SKILLART" LEDGER.md                   → m6z: "conditional not fired"
```
The quoted string "single-row windows only, no accumulation" occurs only inside 3DR-SPEC
itself; T-M6a-SKILLART never ran (RELEASE/T-M6z), so it has no *precedent*; the real shipped
sources are LEDGER T-M1c2 "single-row windows thereafter" and M6-SPEC:481/1097/1101
("single-row windows + drain_barrier" — planned text for the never-fired card). The LAW is
true; its citation is fabricated-flavoured. Under this spec's own quote law (and M6-DA
precedent on misquotes) that is a FIX row.
**FIX:** re-cite: "LEDGER T-M1c2 (the accumulation-OOM lesson) + T-S1q/T-M4a/T-M5s all-single-
row windows since; M6-SPEC §10 wording".

### P3-3 — §6.1's v4.0.0 case cites a SUPERSEDED M6 row and mischaracterises it (the framing stays honest; the support line does not)

**CHECK (executed):**
```
$ sed -n '32,33p' docs/M6-SPEC.md
  - **§8 RESOLVED = SHIPS v3.1.0** — quote *"3. Ship."* …
    T-M6z tags v3.1.0; the v4.0.0 counter-offer is RETIRED-IN-ROW (struck, dated); the
$ grep -n "MAJOR-v4" docs/M6-SPEC.md   → (no live row; only the struck candidate)
```
§6.1: "the M6 §8 row already recorded a dated 'MAJOR-v4 candidate (OWNER-DECISION)' for the
statue ruling's landing, which is exactly what ships here." Measured: (a) the candidate row
was struck by the owner's *"3. Ship."* — versioned-truth doctrine: superseded text is DO NOT
USE as live support; (b) it was about M6's OWN stamp (M6 shipped without the statue landing),
not "for the statue ruling's landing". The owner-decision framing itself is clean (v3.2.0
stated as the honest MINOR alternative, no manufactured consent — see SURVIVED-5), but the
support citation must carry its dated retirement or be dropped.

### P4-1 — dangling internal cite `§0.3` (line 32): §0 has no subsections; the content cited lives in OWNER ORDER item 3 / §3.2.
### P4-2 — A-2 "count at base: 380 at T-M6z" is stale at this base: `python3 -m pytest --collect-only -q` → **381 tests collected** (LEDGER T-M6q2: "suite 380 -> 381"). Say 381.
### P4-3 — A-11/A-12 name instruments that are not committed repo files: `grep -rln "playwright" tools/ tests/` → zero hits; `grep -rn "autopilot" <repo>` → only 3DR-SPEC itself; the v1.1.0 precedent ran Playwright ad-hoc from the seat (LEDGER T-S11), and no committed "VS corpus zero-hits" gate exists (the clean-room law rides card-capture greps + test_card_icons' v1-byte pin). §8.1's header bills every row as "runnable, deterministic, red-capable" — these two rows are seat-runnable, not repo-runnable; declare the instrument as the fleet browser MCP + a named capture grep (one command each) so the leg is re-runnable by a stranger.
### P4-4 — A-1/§2.1's "`cmp` vs the committed anchor": no committed journey dump exists (`find . -name "*journey*"` → empty); the "anchor" is the md5 string recorded in RELEASE-v3.1.0.md/BYTE-DEVIATION-M6 (5d863b80…). The shipped practice (T-M6z) is pristine-base-worktree re-dump vs final dump + md5-vs-recorded — runnable, but name the instrument honestly (md5sum vs recorded digest, not file-vs-file cmp).
### P4-5 — §5.1's R-glob `assets/glb/*-rigged.glb` is broader than "six NEW" (it pattern-covers the two HOLD twins); §5.5's proof runs on NAMES — the capture re-computation leg must normalise globs or the disjointness proof leg is vacuous for glob rows.

## SURVIVED — refutation attempts that FAILED against the code (the spec holds here)

1. **One-consumer monogamy (§1.3/F-1, A-4).** `grep -rn CLIP_SOURCE --include=*.gd godot/` →
   the identifier lives ONLY in roster.gd (`:161` table, `:183` getter) + hero_pawn comment
   lines; the consumer read is verbatim `var clip_v = Roster.clip_source(_player_glb())`
   :174, AnimationPlayer :197-199, gait law :231-232 — all spec cites exact. **Zero-edit holds
   mechanically:** `var vis := String(clip.get("visual", _player_glb()))` (:178) + `clip_node`/
   `walk` defaults mean a statue flip is a pure data change; MV-E5 draws=1 survives via the
   shipped rig/static mutual-exclusion arms (LEDGER T-M6r; tools/motion_gate.py:22).
2. **The seam is SCHEDULED, not scope-creep (§3.4).** roster.gd's header :5-12 verbatim:
   "SCHEDULED clause, named card: T-M6a-STATUE … carries the clip seam CLIP_SOURCE +
   clip_source() -> roster_clips.gd … so that card's wave is the split, per audit-4 §1.4".
3. **No statue-batch deadlock (attack 3).** Serial chain a→r→c→z terminates; two-fail STOP
   ships the SHIPPED procedural arm (zero new bytes, costless veto); §2.2 declares the REMINT
   row conditionally ("a flipped row … or stays EXCUSED under a double-fail") so the owner
   package answer pre-ratifies both outcomes; SD-E6's PENDING-measure assert (test_sigil_
   drop.py:255-261) is the close gate. Owner non-answer stalls the wave by design, not by defect.
4. **GPU LAW rows are faithful (attack 4).** T-S1a drain_barrier row VERIFIED (LEDGER :12),
   T-S1p trap-close rc=0 + verifier serves post-close VERIFIED (:13), TRELLIS.2+UniRig on
   vm100 VERIFIED (:11); the "PAUSED while open" fact matches RESEARCH-3D-3090.md:9-11
   VERBATIM and its risks-3 row keeps the short-offline-batch law; the parked T-M6a-STATUE
   does not double-claim the gate — 3DR IS the milestone it rides into (OWNER ORDER 3,
   RELEASE-v3.1.0:95-100). Worst-case GPU ≈ a few hours at measured window lengths
   (T-S1p 7m13s; T-M5s 13 windows 07:59→09:14) — owner's "regardless of time taken" governs.
5. **Owner-rows honesty (attack 8, the v4 question apart from P3-3).** "Ibwant skeletons…"/
   "Rec"/"3. Ship."/"3d remake first then m7" all match the committed artifacts verbatim
   (T-M6z byte-exact check; RELEASE-v3.1.0; RIG-DEVIATION-SEL-C "Rec"); the fallback veto
   costs the owner nothing (it names the shipped state); §7 names but schedules nothing for
   the M7 trio (the matrix owns zero settings/touch/leaderboard files — disjointness recompute
   EMPTY on all six pairs).
6. **FX identity under 3D (attack 6).** READ_FLOOR 0.22 is a committed const
   (tools/skill_fx_sample.py:73), RATIO_MIN 2.0 the ONE const (biome_readability.py:116),
   26 rows measured, probe 3/3+6/6+26/26 shipped (T-M6z/T-M6q2: fresh captures byte-identical
   across the probe split). Flipped statues cannot contaminate FX sampling: the walk-strip /
   probe channels do not sample pawn pixels (T-M6r measured row: bob/lean "rides transforms
   the walk-strip channels do not sample") and captures run on the default (HOLD) pawn.

## WHAT SHIPS FIX

Both P1s are spec-text + matrix fixes (one count relabel; one OWNED-column addition + five
stated parser edits) — the DESIGN survives; this is FIX, not RECONSIDER. REV 2 must carry a
dated fold ledger per the M2–M6 precedent.

# VERDICT: FIX
