# CLEAN-CODE AUDIT-4 — bryn1/hollow-dawn-3d @ v3.1.0 (MC 11710, T-M6q-AUDIT)

Author: code (11710) <code@agent-town.local>
Base: origin/master @ 60ddca3 (the v3.1.0 tag commit rides it) — worktree
audit (`.tmp/wt-m6q`), tree untouched; this file + its one LEDGER row are the
ONLY product-tree changes the card makes (proof restated at the bottom).
Method: findings ONLY, zero refactoring executed; the EXISTING instruments, no
new mechanisms — the fourth application of the owner doctrine (verbatim
2026-10-25: "review/refactor/audit as a next run after the current one is
completed and everything pass. Clean code as doctrine"). Universe rule: the
gate checker's OWN module — `dod_hygiene.is_source` from the one gate home
(`~/.local/bin/dod_hygiene.py`) — imported and walked over `git ls-files`
(714 tracked, 132 is_source: 101 non-test, 31 test), the same rule-(h) shape
as audits MC 11316, MC 11398 and MC 11570, run through the SAME walker script
(`.tmp/cc3_walk.py` reused with base=acd00f1, worktree=wt-m6q — the one
mechanism, parameterized, no second walk). The python suite was RUN on this
tree (`pytest tests -q` → **380 passed**, rc 0, 45 s — matching the LEDGER
T-M6z row). Raw instrument stdout captured at `.tmp/m6q.txt` (main checkout,
gitignored; ends `VERIFY_EXIT=0`). Every row carries its MEASURED number and
its git-log provenance (`acd00f1..60ddca3`, the M6 window: 8 commits, T-M6c →
T-M6z). BYTE-RISK = the fix touches an RNG/spawn/render path or a committed
byte-anchor corpus (journey 5071 + 13 strict fixtures byte-identical; strips
modulo the declared norm; s8 dumps contract-checked, never byte-pinned).

Headline: **the M6 discipline mostly held — the ceiling walk returns FOUR
non-test findings, and the refactor-3 headers prove it** — but TWO are the
single most dangerous class in the doctrine: RETIRED CLAIMS that survived
their own retirement inside PRODUCT CODE, invisible to the release's
grep-to-zero because that sweep's universe was docs+README, not `godot/` +
`tests/` (screens.gd still claims "32 pool kinds / 16 weapon" in the present
tense; test_levelup_caps.py still claims the committed caps dump carries "16
weapon kinds" — the fixture was RE-MINTED at T-M6d, 0 doom rows measured).
The second mechanism hunt over the M6 delta measures ZERO real forks: the
SKILL_FX table, the CLIP_SOURCE seam, the XDG immunity seam, the
level-up-PICK evolve trigger and the drops.gd partition are all one-site,
each measured by call-sites, not by header claims. The dead-code hunt refutes
the brief's three suspects BY MEASUREMENT (doom-sigil weapon-side: zero live
sites, all occurrences are exclusion pins or the KEEPT icon; pale-moon: same;
stale id pins: the test-only-id sweep returns only synthetic ids, dirs and
encodings) and files the two REAL leftovers: a VACUOUS leg fragment in
test_mob_contrast.py — entailed by an assertion two lines above it, its label
still naming the refuted WHITE-seven premise — and the upgrades_visual pair,
the only >400-no-reason crossing that a card grew +151 lines into ONE commit
while `concern_check` flags it the tree's sole `MIXED`. The gate walk's fifth
finding is a pure mechanics catch: world.gd's FRESH, honest `reason:` line
sits on line 6 — T-M6d's header rewrite pushed it out of the first-5 window.

## 1. CEILINGS (gate walk; full stdout in the capture)

Walk inventory — non-test source files at the tag, M6 window deltas, nesting
proxy = max indent depth over code lines (tabs / 4-space steps):

| file | LOC (Δ M6, @commit) | reason | nesting | concern | verdict |
|---|---|---|---|---|---|
| screens.gd | 601 (+19 @f376a4f) | yes (line 2) | 5 | clean 9/1 | **F-1 P1/P2 row** |
| sim_evolve.gd | 640 (+185 @f376a4f, 455@9fbe009) | yes (fresh "640 at T-M6p") | 6 | clean 1/1 | **F-9 P4 band row** |
| upgrades_visual_probe.py | 538 (+151 @f8095d1) | **NO** | 12 | **MIXED 4/2** | **F-3 P2** |
| upgrades_visual_capture.gd | 485 (+119 @f8095d1) | **NO** | 5 | clean 1/1 | **F-4 P3** |
| roster.gd | 405 (+46 @91b371c) | **NO** | 3 | no-defs (§4 note) | **F-5 P3** |
| world.gd | 450 (−101 @9fbe009) | yes but @**line 6** | 4 | clean 2/1 | **F-6 P3** |
| main.gd | 599 (±0) | yes | — | clean | watch carries (CC3R) |
| strips_capture.gd | 596 (±0) | yes | — | clean | watch carries (§2.3) |
| sim_stages.gd | 588 (+5 @9fbe009) | yes (ROWS law) | 5 | clean 2/1 | trigger FIRED §2.2 |
| viz_fx.gd | 571 (+197 @f8095d1) | yes ("571 at T-M6f") | 5 | clean 4/1 | carries |
| weapons.gd | 567 (+89) | yes | — | clean 3/1 | carries |
| sim_combat.gd | 521 (+422; 514@f376a4f, +7@f8095d1) | stale count §3-F-8 | 5 | clean 6/1 | **F-8 P4** |
| biome_readability.py | 468 (+252 @a98d456) | yes (mob-leg monogamy) | 16 | clean 3/1 | carries |
| sim_union.gd | 527 (+36 @f376a4f) | stale count §3-F-8 | 5 | clean 1/1 | **F-8 P4** |
| sim_headless.gd | 436 (+29; 423@9fbe009, 436@f376a4f) | stale count §3-F-8 | 5 | clean 1/1 | **F-8 P4** |

Findings: 4 gate-FINDING rows (>400 non-test no-reason: roster, world,
upgrades_visual_capture, upgrades_visual_probe) + the 2 >600 files (screens
601, sim_evolve 640) filed per this card's brief. Test arm: ZERO findings
(none >600); watch: test_characters 563 (47 from the 600 test arm, audit-3
row carries), test_chests_evolve 429 (+136 M6). Grew-but-under watch numbers:
hero_pawn 255 (crossed the 250 soft), biome_readability_capture 326 (+124),
dawnwell_capture 302 (+56), shop_probe 376 (UNTOUCHED in M6, audit-3 watch
carries — 24 from 400).

### 1.1 [P1] godot/scripts/screens.gd:20-21,85 — the retired pool-16 claim, ALIVE in product code

T-M6z's grep-to-zero over the four retired claims (".tmp/m6z.txt":
"G2 weapon-pool-16: raw 40 UNMARKED-live 0") ran its universe over
**docs+README**. The code universe was never swept and the claim survived its
retirement TWICE: screens.gd:20 "# total over the 32 pool kinds (T-M1h M1
count: 16 weapon + 16 upgrade via" + ":85 # Total resolver over the 32 pool
kinds". The live truth, measured THIS session: `tests/test_card_text.py:63`
pins META at **15** weapon rows ("F6 pool 16->15"), `test_card_icons.py:142`
pins the icon universe at **31** kinds (15+15+1), and drops.gd:20 ITSELF
states "pool 16→15, kinds 32→31". Fleet doctrine (Verify discipline,
CONTRADICTED class): "a claim that survives its implementation is not docs
debt — file it P1". Same-file band facts, fixed by the ONE re-word: the
+19 @f376a4f chips block (:301-325, verified riding the ONE `icon_path`
resolver — no second mechanism) RE-CROSSED 600 (CC3R split to 582 → 601 at
the tag) and the header names the M5 history only — the split-vs-accepted-
ceiling decision is due again (audit-3 §1.1's precedent repeat). Smallest fix
(header re-word, comment-only, pck law): re-state 31 kinds / 15 weapon / 16
icons (15 offer + the T-M6d KEEPT doom-sigil billboard), name the 582→601 M6
growth, and carry the decision row: SPLIT `_card` + chips (:275-end builder
cluster, the RosterSelect.build(self) idiom precedent) OR owner-accepted
ceiling. Byte-risk: NO for the header (comment-only); the split option is a
RENDER path (dawnwell_pixel_gate char/shop/stage corpora) so the decision
belongs to the refactor card or the owner, not here.

### 1.2 [P2] tools/upgrades_visual_probe.py — 538 L, +151 in ONE commit, the tree's only MIXED

Grew 387→538 at f8095d1 (+151, T-M6f Table-3 section) crossing 400 with no
reason line; `concern_check` scans 17 files ≥400 and returns EXACTLY ONE
finding: this file, `flag=MIXED comps=4/2` (palette classifiers + capture +
windows/blobs + SKILL-FX measures + the BULK-GEM law). Nesting proxy 12.
Consumer inventory (measured, drives the seam): `tests/test_gem_merge.py`
judges the BULK-GEM section (": the BULK floor + capture existence pinned");
`tests/test_skill_fx.py` imports `skill_fx_sample` (its live sampler) and
pins the probe's Table-3 SOURCE only. Seam named AFTER reading both sections
and their consumers: the T-M6f Table-3 block (:289-348) and the T-M2g
BULK-GEM block (:350-end) are self-contained with disjoint consumers — the
smallest correct change is either (a) extract both to sibling modules,
leaving capture/parse/palette/window here and re-pointing the two test
imports, or (b) a biome_readability-shaped reason header (mechanism
monogamy: one pickup-visibility capture + its gate) — REJECTED by this
audit as insufficient alone: the MIXED flag is the instrument telling you
the reason clause would paper a real four-concern file; if (b) is chosen the
fix row must ALSO name the scheduled split and the next grower. Sub-row
(measured, name-and-pin): the Table-3 `SKILL_CLASS_ALPHA` table restates the
viz_fx.gd writer alpha law in Python (the comment claims "one shared
constant table" — it is TWO sites across a language boundary) and has ZERO
suite pins (grep tests/*.py for `SKILL_CLASS_ALPHA`: zero); a writer-side
alpha edit desyncs the pixel box silently until the next card-time probe
run. Fix inside (a)/(b): one test_skill_fx row pinning the probe's numbers
against viz_fx's, or a declared re-measure law on writer-touching cards.
Byte-risk: NO (tools-only; the committed shot assets are read, never
re-minted, by test_gem_merge).

### 1.3 [P3] godot/sim/upgrades_visual_capture.gd — 485 L, the capture side of the same crossing

+119 @f8095d1 (the 26-leg SKILL_FX capture family), crossed 400 no-reason.
`concern_check` flag=clean (comps 1/1): ONE capture harness, one concern —
this one is a genuine C1 case: add the biome_readability_capture-shaped
reason header naming the T-M6f growth (366→485) and the ONE-capture law.
Byte-risk NO (comment-only). Carried with §1.2 so ONE card lands the pair
disjointly.

### 1.4 [P3] godot/scripts/roster.gd — 405 L, born over the line by the CLIP_SOURCE table

+46 @91b371c (T-M6r: the CLIP_SOURCE rig table + getter, :150-172). The
audit-3 §1.3 defence ("the spec's powerups contract, ALL rules here") still
holds for the CHARACTERS rules; the clip table is the YOUNGER rider.
Smallest fix: C1 reason header naming the M6 growth (359→405) with a
SCHEDULED clause aimed at a named future card — **T-M6a-STATUE** (LEDGER-
named, the owner-ruled statue→skinned decision): the next grower IS the
clip-table's own subject (the six null statue rows flip to clip rows), and
that card carries the seam: `CLIP_SOURCE` + `clip_source()` → `roster_clips.gd`,
same data-table precedent as roster_select.gd/achievements_page.gd (CC3R).
Byte-risk NO.

### 1.5 [P3] godot/scripts/world.gd — 450 L, the honest header that slipped the window

`FINDING-400NOREASON` by window mechanics, measured: T-M6d's partition
narrative (3 lines, :1-5) pushed the file's `reason:` line to **:6**,
outside `dod_hygiene._head_says(readlines()[:5])`. The header itself is the
model of the law: it names the F-10 cut (551→450 measured), the remaining
one-file law (spawn latch + kill-funnel ENTRY + the ONE CHEST_TIER_BY_SOURCE
map) and the call-through design — verified at source, not claimed:
`collect_pickups` is a one-line delegator to `drops.collect_pickups`,
`reset()` clears the world arrays + one `drops.reset()` call, and the two
files' function sets overlap ONLY in those two named delegators (measured,
`comm -12` → {collect_pickups, reset}). Smallest fix: reorder the comment so
`reason:` lands within the first 5 lines (comment-only; the gate walk then
returns this file clean). Byte-risk NO.

### 1.6 [P4] godot/sim/sim_evolve.gd — 640 L, the +185 band entry that IS the contract

>600 with a FRESH measured header ("640 measured at T-M6p", concern clean
1/1, nesting 6). The defence measures TRUE today: the chest truth table +
the end-to-end legs + the reserve legs are one dump contract (splitting the
table from its legs is the exact MC 11398 §1.5 violation the header names;
boost MATH rides sim_combat's spec-named channel per PS-E2). Filed per this
card's brief as a band row + watch: +185 in a single commit made it M6's
fastest single-file grower — the next touching card re-measures the band
BEFORE adding lines, per the world.gd/strips_capture precedent wording.

## 2. DEFERRAL RE-MEASURE (audit-3 rows, verdicts by number)

- **world.gd split — PARTIALLY EXECUTED.** T-M6d's F-10 partition cut it
  551→450 and the dropped/pickup half rides drops.gd behind verified call-
  throughs (§1.5). The remaining clause (spawn latch / kill funnel / tier
  map) stands, its header honest but window-misplaced (§1.5). The F-3
  "zero world.gd touch" era is over by OWNER design (the spec named the
  partition) — not a trigger breach.
- **sim_stages "first grower" — FIRED.** 583→588 (+5 @9fbe009, the pool-15
  REMINT shape). 12 lines from the band, no LOC number in its header to go
  stale, concern clean. Watch row: the trigger has now fired once — the
  next grower re-measures the split, not the ROWS-table re-word.
- **strips_capture watch — CARRIED.** 596, ±0, 5 lines from the 601 fail
  line with a reason; law unchanged: any future touch re-measures the split.
- **screens.gd watch — BROKEN AGAIN, filed** (§1.1): CC3R's 582 re-crossed
  to 601 at f376a4f and the header never named it.
- **audit-3 C2 (roster_capture wire) — HELD.** The CC3R driver
  tools/roster_clip_gate.py now has code call-sites measured
  (tests/test_characters.py, tests/test_skins.py, tools/motion_gate.py) —
  the §4.2 zero-call-site class is closed and stays closed.

## 3. M6-DELTA REVIEW (acd00f1..60ddca3 — second mechanisms, dead code, stale pins)

The window: 8 commits (a98d456 T-M6c, 91b371c T-M6r, 5887b2c T-M6d-1,
9fbe009 T-M6d, f376a4f F3+F4, 0fb8b45 T-M6H-XDG, f8095d1 T-M6f, 60ddca3
T-M6z), 99 files changed, 38 source (delta instrument re-run:
`.tmp/cc3_delta.py` reused, base=acd00f1). NEW: drops.gd 263,
motion_capture.gd 252, xdg_probe.gd 17, motion_gate.py 219,
skill_fx_sample.py 165 + 7 test files. The suspects this brief named,
MEASURED:

- **doom-sigil weapon-side remnants still loading — REFUTED (zero).** The
  quoted id `"doom-sigil"` has ZERO non-comment sites in godot/ (capture
  grep): every hit is a retirement-narrative comment or an EXCLUDE pin in
  tests (test_sigil_drop.py:55-56 reads CODE-ONLY text via the conftest
  comment law — the pin cannot be fooled by the retirement comments, and
  its fixture half re-derives from the re-minted caps dump: zero doom rows,
  measured by grep over tests/fixtures/). IDS=15, META row gone, the ONE
  `case` arm gone; icon-doom-sigil.png is the KEEPT pickup billboard with a
  LIVE consumer (pickup_viz.gd:88 SIGIL_ICON → the RIVEN drop, named by
  M6-SPEC §4.2 icon law).
- **refuted WHITE-7 premise leftovers — ONE, filed (F-7 below).**
  T-M6c refuted the spec's seven-need-lifts premise by grid measurement
  (2 of 7 failed the floor; BOSS_TINTS carries only those 2, the header at
  render.gd states the truth). Docs mentions are dated lineage hits
  (release sweep G4: raw 2 UNMARKED-live 0). The code-universe residue is
  exactly ONE site.
- **[P3] F-7 tests/test_mob_contrast.py:242-246 — a VACUOUS leg fragment
  wearing the refuted premise's name.** The `white = {seven ids}` +
  `assert white <= {r[4] for r in grid}` fragment is ENTAILED by the
  assertion two lines above: :228-229 pins `{r[4]} == ENEMY_TYPES` and all
  seven ids are ENEMY_TYPES keys (measured, this session: subset test
  True) — the fragment can never go RED independently: fleet law, "a check
  that can never go RED is not a check". And its NAME is now false:
  hollow-knight + hollow-deacon took BOSS_TINTS rows at T-M6c, so the live
  fallback-WHITE set is FIVE, not seven — the comment perpetuates the
  refuted premise. Smallest fix: retarget the fragment to the live five-
  member fallback set (derived from render.gd's tables, not a literal) —
  that also makes it a real check again (it can go RED when a fallback
  class vanishes from the grid); alternative: delete-with-provenance.
  Consumer inventory: the file's other legs drive
  `br.expected_grid()`/tools/biome_readability.py LIVE (test-armed gate —
  the family pattern; no driver missing). Byte-risk: NO (test-only).
- **stale pins naming removed ids — one REAL (§3-F-2 below), zero id-pins.**
  Systematic sweep: every quoted `[\w-]+` id in tests/ that appears in NO
  product source returns only synthetic/derived names (bone-whip-4,
  ember-8, red-wail-5-0 = the evolved-id naming convention;
  biome-readability-shots = a dir; utf-8 = encoding) — no test names a
  retired product id as present.
- **[P1] F-2 tests/test_levelup_caps.py:16 — stale dump provenance.**
  The header claims the committed caps dump is "RE-DUMPED on the T-M1h
  enlarged pool: 16 weapon kinds + 15 passive kinds" — the committed
  carry-caps fixture was RE-MINTED at T-M6d (v3.1.0 LEDGER row: "carry-caps
  … doom 64->0"; the fixture file itself: grep "doom" = 0 rows) so its
  committed bytes carry 15 weapon kinds, and the SAME file's :156 already
  says "pool 16→15, kinds 32→31". A dated-provenance claim that mis-
  describes the committed artifact is a live claim — CONTRADICTED class,
  filed P1 with F-1 (same root cause: the T-M6z G2 sweep universe was
  docs+README; the code universe was never in it). Smallest fix: one-line
  re-date ("RE-MINTED at T-M6d: 15 weapon kinds"). Test-only, byte-risk NO.
- **[P4] F-8 stale measured-LOC header numbers, three files** (M6 grew the
  file, not the number): sim_union.gd header "(488 measured at MC 11398 §1)"
  vs 527 actual (+36 @f376a4f); sim_headless.gd "(402 measured at MC 11398
  §1.5)" vs 436 (+29: +16 @9fbe009, +13 @f376a4f); sim_combat.gd "(514
  measured at MC 11697 T-M6p)" vs 521 (+7 @f8095d1 — the same card DID
  re-measure viz_fx's header, missed sim_combat's). One comment-only re-
  measure commit; the numbers feed the NEXT walk.
- Second-mechanism hunt — **ZERO forks measured** (each by call-sites):
  SKILL_FX = one table def (viz_fx:71), all writers read through it,
  `_flash_row` reads the SAME table by design (declared no-fallback
  variant); chips ride `icon_path()` catch-all (the diff proves no second
  resolver); CLIP_SOURCE = one table + one getter (roster:150/:172), the
  statue arm rides the SAME `HordeViz.gait_wave` law (not a second gait
  mechanism, read at hero_pawn:238-255); XDG immunity = ONE conftest import-
  block seam, the REPLACED manual s8 ritual measures retired IN-SUITE (all
  four s8_acceptance invokers are pytest tests, inheriting the floor; zero
  XDG sites in tools/; the per-test scratch dirs are `dict(os.environ, …)`
  overrides riding the same floor, declared not-immunity-mechanisms) —
  honest row kept: STANDALONE CLI battery runs of s8 still take a manual
  well (the T-M6H card's own battery did); try_evolve = ONE seam (two arms
  in levelup.apply_offer, :200/:211, the stated reading); mob-leg rides the
  ONE `RATIO_MIN` (pinned `len==1` at test_mob_contrast:173 — the pin
  itself has a def and a planted-red); drops.gd split overlaps world.gd
  ONLY in the two named delegators (§1.5). Sim .gd dead-def sweep: ZERO.
  Test skips: only the named `GODOT`-binary skipif family.

## 4. INSTRUMENT ROWS (named so the refactor wave does not re-litigate)

- dead_code v13 re-run (same invocation): 28 rows, exit 1 (audit-3 ran 25).
  The +3 NEW ORPHAN-MODULE rows (motion_gate.py, roster_clip_gate.py,
  skill_fx_sample.py) ALL measure live consumers this session
  (tests/test_motion.py + tests/test_characters.py + tests/test_skins.py +
  tools/motion_gate.py respectively) — the named instrument limit (no
  .sh/.py-test driver graph) stands; seat-local `--allow` family, NOT tree
  debt (audit-2 §5, CC3R mirror-table precedent).
- `concern_check` reports roster.gd `flag=no-defs defs=0` though the file
  has static funcs — the instrument's .gd def-pattern is the same
  name-based family limit; roster's concern verdict rests on the audit-3
  §1.3 full wiring re-check, cited.
- `tests/fixtures/achv-m5.jsonl`: ZERO suite readers by design — the
  achievements behaviour is judged LIVE by achv_probe legs; the fixture is
  the refactor-battery byte anchor (BYTE-DEVIATION-M6 §16/§13 STAY rows
  name it). Record-only (audit-3 §1.3 precedent), so the next walk does not
  re-ask; it is NOT the roster_capture class (that finding was a MINTER with
  no driver; the minter here has its test driver).

## 5. GREP-ZERO RULES FOR THIS AUDIT'S OWN CLAIMS (all re-run in the capture)

1. `grep -n "32 pool kinds" godot/scripts/screens.gd` → exactly :20, :85 (F-1 sites).
2. `grep -n "16 weapon kinds" tests/test_levelup_caps.py` → exactly :16 (F-2 site).
3. `grep -rn "WHITE seven\|white seven" godot tests` → exactly test_mob_contrast.py:242 (F-7 sole site).
4. `"doom-sigil"` quoted, comment-stripped, godot/ → 0 sites (refutation).
5. `grep -c '"doom' tests/fixtures/`-walk → 0 fixtures contain doom rows.
6. `grep -rn "SKILL_CLASS_ALPHA" tests/` → 0 (F-3 sub-row).
7. try_evolve call-sites in godot/scripts/ → 2, both in levelup.gd (seam law).
8. white-set ⊆ ENEMY_TYPES → True (F-7 entailment).
9. dead_code ORPHAN rows for the 3 new tools → each grep-names ≥1 consumer file (§4).
10. header numbers vs `wc -l`: sim_union 488/527, sim_headless 402/436, sim_combat 514/521 (F-8).

## FIX-LIST (clusters: wave-splittable — ONE REFACTOR child per group, files DISJOINT)

- **W1 screens (comment-only + decision row)** — F-1: screens.gd header
  re-word (31 kinds / 15 weapon / KEEPT icon naming + the 582→601 M6 naming
  + the SPLIT-or-accepted-ceiling decision, both options priced: the _card
  + chips builder cluster is the render-surface split candidate, the pixel
  gates are its proof). Files: {godot/scripts/screens.gd}. Verification:
  grep rule 1 → 0; §1 walk re-run stays finding-clean; C1 pck law.
- **W2 upgrades pair (split-or-name, the only code-shape option in the
  list)** — F-3 + F-4: probe Table-3/BULK-GEM extraction (imports
  re-pointed in tests/test_gem_merge.py + tests/test_skill_fx.py) OR the
  declared-schedule header + the SKILL_CLASS_ALPHA pin row; capture.gd
  reason header. Files: {tools/upgrades_visual_probe.py,
  godot/sim/upgrades_visual_capture.gd, tests/test_gem_merge.py,
  tests/test_skill_fx.py}. Byte-risk NO (gates re-run GREEN either way;
  no fixture is re-minted — the probe only READS committed shots).
- **W3 gd C1 headers (all comment-only)** — F-5 roster reason header +
  T-M6a-STATUE scheduled clause; F-6 world window reorder; F-8 three
  re-measured numbers. Files: {godot/scripts/roster.gd, godot/scripts/
  world.gd, godot/sim/sim_union.gd, godot/sim/sim_headless.gd,
  godot/sim/sim_combat.gd}. Verification: gate walk → 0 FINDING rows; the
  grep rules 10 numbers match.
- **W4 test hygiene (test-only)** — F-2 caps header re-date; F-7 vacuous
  fragment retargeted to the derived live fallback set (the new form must
  plant-red: rename one fallback class out of the grid ⇒ leg goes RED).
  Files: {tests/test_levelup_caps.py, tests/test_mob_contrast.py}.
  Verification: suite green (380 ± new legs); planted-red transcript.

DISJOINTNESS PROOF: W1={screens}, W2={probe, capture, gem_merge, skill_fx},
W3={roster, world, sim_union, sim_headless, sim_combat}, W4={levelup_caps,
mob_contrast} — pairwise intersections empty, checked name-by-name.

## DEFERRALS (with reasons, re-measured this audit)

- screens.gd SPLIT timing — §1.1's decision deliberately not made here
  (render path + pixel corpora; the refactor card or the owner makes it).
- upgrades_visual_probe option (a) vs (b) — the audit RECOMMENDS (a) the
  split (MIXED measured), but the choice is priced and belongs to the
  refactor card.
- world.gd remaining split — clause stands post-F-10 (§2.1); trigger
  (spawn/entity law growth) not fired: world.gd SHED 101 lines in M6.
- sim_stages — trigger fired once with a +5 REMINT-shaped growth; carried
  as §2.2 watch, split not due.
- strips_capture 5-from-band — watch carries (§2.3).
- T-M6a-STATUE's roster.gd touch — named in W3's clause BEFORE it lands, so
  that card carries the clip-table seam per its own terms.
- sim_evolve 640 table/legs split — defence measures true today (§1.6);
  next-grower re-measure law named.
- dead_code --allow rows and concern_check .gd def-pattern — seat-local
  instrument family, not tree debt (§4).

CAPTURE: `.tmp/m6q.txt` (main checkout, gitignored) — the reused cc3-walk +
cc3-delta transcripts, the per-commit LOC history, dead_code +
concern_check + nesting-proxy stdout, the consumer inventories per dead-code
row, the §5 grep-zero rules, the suite run (380 passed); ends
`VERIFY_EXIT=0`. Instruments run: 7 (walk, delta, dead_code, concern_check,
nesting, greps, pytest).

GIT-DIFF UNIVERSE PROOF: `git diff --name-only 60ddca3..HEAD` on master
after this commit lists exactly `docs/CLEAN-CODE-AUDIT-4.md` + `LEDGER.md` —
docs-only, zero product diff (this card's gate runs executed over the
untouched v3.1.0 tree; Godot `--import` rc 0 on the worktree first, per
brief).

# VERDICT: FIX
