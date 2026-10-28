# CLEAN-CODE AUDIT-3 — bryn1/hollow-dawn-3d @ v3.0.0 (MC 11570, T-CC3)

Author: hygiene (11570) <hygiene@agent-town.local>
Base: origin/master @ fea18ea (the v3.0.0 tag commit) — worktree audit
(`.tmp/wt-cc3`), tree untouched; this file + its one LEDGER row are the ONLY
product-tree changes the card makes (proof restated at the bottom).
Method: findings ONLY, zero refactoring executed; the EXISTING instruments, no
new mechanisms — the third application of the owner doctrine (verbatim
2026-10-25: "review/refactor/audit as a next run after the current one is
completed and everything pass. Clean code as doctrine"). Universe rule: the
gate checker's OWN module — `dod_hygiene.is_source` from the one gate home
(`~/.local/bin/dod_hygiene.py`) — imported and walked over `git ls-files`
(669 tracked, 117 is_source: 93 non-test, 24 test), the same rule-(h) shape as
audits MC 11316 and MC 11398. The python suite was RUN on this tree
(`pytest tests -q` → **315 passed**, rc 0, 244 s — matching the LEDGER T-M5z
row). Raw instrument stdout captured at `.tmp/cc3.txt` (main checkout,
gitignored; ends `VERIFY_EXIT=0`). Every row carries its MEASURED number and
its git-log provenance (`cf301c5..fea18ea`, the M5 window). BYTE-RISK = the
fix touches an RNG/spawn/render path or a committed byte-anchor corpus
(journey 5020 + 11 fixtures byte-identical; strips modulo the declared norm;
s8 dumps contract-checked, never byte-pinned).

Headline: **the refactor-2 discipline HELD through all of M5 — the ceiling
walk returns ZERO findings** (no non-test source >400 without a `reason` in
its first 5 lines; no file anywhere, test or non-test, >600 without one). The
C1 headers every M5 card promised in its commit message are real, and the two
deferred triggers (sim_stages "first grower", world.gd code-growth) did NOT
fire. What M5's growth DID produce: `screens.gd` crossed the 600 band and
overshot its own spec-declared crossing plan by 140 lines without any card
making the split-vs-ceiling decision (§1.1, the audit's one P2), the clip
frame-diff capture `roster_capture.gd` landed with ZERO code call-sites while
two suite rows (B-E8/K-E3) judge the committed CSV it mints (§4 + §5), and two
vm100 art-era leftovers have no driver and no doc row. Function-level
cleanliness is measured, not assumed: all 101 functions ADDED in the M5 window
have call-sites (the one-occurrence hunt is empty); `roster.gd`'s 25-table
module and `achievements.gd` are fully wired. Doc-pin verdicts on the four
spot-checked M5 ACCEPT rows: two reach the real engine, two are honest
snapshot gates whose weakest link is named (§5).

## 1. CEILINGS (gate walk; full stdout in the capture)

Walk findings: **0** (non-test >400 no-reason: 0; >600 no-reason both test and
non-test arms: 0). Reasoned and measured (LOC at fea18ea, delta from cf301c5):
screens 715 (+270), main 596 (+124), strips_capture 596 (+5, §3.3),
sim_stages 583 (±0), world 551 (+3, §3.1), sim_events 537 (+4), sim_union 491
(+3), weapons 478 (±0), main-era sim_budget 466 (−6), sim_evolve 439 (+4),
sim_headless 407 (+5). Test files >250 (info only, none near the 600 test
arm): test_characters 553 NEW, test_stages 407, test_skins 394 NEW,
test_dawnwell_shop 371, test_chests_tiers 344, test_boss_numbers 339,
test_endless 306, test_chests_evolve 293, test_biome_numbers 290,
test_save 252.

### 1.1 [P2] godot/scripts/screens.gd — 715 L, the >600 crossing nobody judged

M5 grew it **445 → 715 (+270)** across four cards, measured per commit:
527 @T-M5p (+82, achievements page = SEVENTH overlay), 645 @T-M5c (+118,
roster select = SIXTH), 698 @T-M5k (+53, skin chips), 715 @T-P1b (+17, death
panel buttons). The reason line is **law-text, not a rubber-stamp** — this is
measured, not vibes: each overlay ordinal in the header maps to a greppable
section (":325 fourth", ":440 fifth", ":517 seventh", ":579 sixth"); the "ONE
panel style, zero new UI mechanism" claim measures TRUE (54 `_overlay/_center_
box/_label/_button` call-sites; the ONLY raw `Control.new()/ColorRect.new()`
sites are :184/:188, INSIDE the `_overlay()` idiom builder itself);
concern_check: `flag=clean defs=39 comps=7/1`. What the header does NOT carry
is the doctrine clause the same repo's own world.gd header carries: per MC
10062.242 (restated at audit-2 §1.6) the reason **SCHEDULES** the split, never
absolves it. And M5-SPEC's watch row carried an explicit crossing plan —
M5-SPEC-DA:135 computed **445+~130≈575 < 600** — which the milestone overshot
by **140 L**; the file crossed 600 between T-M5c and T-M5k and no card made or
recorded the split-vs-accepted-ceiling decision. The split is a RENDER path
(the pixel/legibility corpora make it BYTE-RISK-adjacent), so the decision
belongs to the refactor card or the owner — this audit only files it.
Smallest fix: re-word the header per the world.gd C1 precedent — NAME the M5
growth (445→715) and either schedule the section split (the two M5 overlays are
self-contained: :517-578 + :579-end) or state the owner-accepted ceiling.
Byte-risk: NO for the header (comment-only, the C1 pck law precedent).

### 1.2 [P4] godot/scripts/main.gd — 596 L, stale enum, 4 lines from the band

Grew **472 → 596 (+124)** in M5 (503 @T-M5p, 566 @T-M5c, 596 @T-M5k). Its
reason header is honest law for the ONE fixed-step loop, but its enum is
versioned-stale: "phase routing (menu/playing/levelup/end)" predates M5 — the
file's OWN :530 says "Achievements verbs (M5 §1.1, T-M5p)" and :553-:596 are
the roster verbs. 4 lines from 600. Smallest fix (the exact C1 world.gd
shape): the next touching card re-words the enum + names the M5 growth BEFORE
adding lines. Byte-risk: NO. Watch row: any M6 growth crosses the band with a
stale header.

### 1.3 M5 growth map (measured cf301c5..fea18ea: 157 files changed, 36 source)

NEW non-test: `roster.gd` 359 (data table + rule module — the spec's powerups
contract, "ALL rules here"; all 25 static funcs wired: every one has a non-own
file call-site or an internal chain — `skin_is_owned` :320/:335/:353,
`is_wearable` :335, both called by live `skin_buy/skin_select/skin_state`),
`skin_probe` 297, `sim_chars` 293, `achv_probe` 261 (all three: the sim-capture
one-shot family audit-2 §2 DEFENDED), `roster_capture` 231 (but §4.2),
`achievements.gd` 117. Four new files BORN over the ~250 soft target, none
near 400 — family-defended, no gate row, recorded here so a future walk does
not re-ask. Grew but under ceilings (watch numbers): **shop_probe.gd
288→376 (+88, now 24 from 400)**, game_state.gd 254→314 (+60),
dawnwell_capture 144→246 (4 short of 250), hero_pawn 63→96, save 128→163,
conftest 91→123 (still the one helper home). Tests NEW: test_characters 553
(47 from the 600 test arm — M6 watch), test_skins 394, test_achievements 245.
No file silently crossed 400; `test_limit_break` landed AT 250, not past.

## 2. DEFERRAL RE-MEASURE (audit-2 §5 rows, verdicts by number)

- **world.gd split — SCHEDULED, UNTRIGGERED.** 548→551 (+3) and the ONLY
  commit in the window is fd4fbea (the C1 header re-word itself — comment
  only). No M5 product commit touched world.gd: the spec's F-3 "ZERO world.gd
  touch" promise measures HELD. concern_check unchanged: JUSTIFIED-NOT-REDUCED
  (defs=12, comps 4/2, clusters `seed_stage_props;update_entities` — identical
  to audit-2 §1.6). The header's own "the next card growing this file carries
  it" clause is intact and the trigger has not fired.
- **sim_stages.gd 583 — trigger "first grower" did NOT fire.** 583→583, ZERO
  commits in `cf301c5..fea18ea` (measured by git-log, not by file diff).
  Carries honestly; the header's ROWS-table law stands.
- **strips_capture.gd 596 — trigger "next touch" fired for the DEFERRAL card
  itself, then closed.** 591→596: the ONLY touch is fd4fbea (the +5 IS its own
  reason header — the deferred fix landed, naming itself and the split
  BYTE-RISK on the shot stream). Post-C1 growth: 0. At the tag it sits 5 lines
  from the 601 fail line WITH a reason (the gate stays green either way; the
  pressure is doctrine). Carry as a numbered watch row: any future touch must
  re-measure the split, not re-stack the header.
- **screens.gd watch row** — its crossing plan BROKE: §1.1, filed as the P2.

## 3. DUPLICATES (replace-not-delete hunt, M5 additions)

Zero new duplicate mechanisms found — measured, not assumed: the M5 trio
(achievements/roster/skins) rides the EXISTING funnel (test_p_e3_whole_scripts_
save_pin proves `.save(` stays at exactly one call site + the funnel body, and
the `_meta_changed(` occurrence count is pinned with RETIRE-NAMED re-counts
7→9→11 across exactly the three cards that grew it — the audit re-verifies:
pin at 11, current source matches); the skin/roster surfaces reuse `_overlay/
_button/_label` (54 call-sites, no second idiom family); the death-panel is
REUSE-ONLY (probe legs fire the menu's OWN `shop_requested` verb and the SAME
`shop_buy` seam — read at source). `roster.gd` restating the buy/select "law"
shapes from the shop is the spec's named contract ("the Roster.buy shape",
data-table module), not a fork: ONE save path, ONE panel style, differing
concerns (identity vs ranks — the spec's F-6 answer).

## 4. DEAD CODE (dead_code.py v13 + wire-graph grep evidence)

The instrument (`--live godot/scripts --lib tools`) returns 15 stdout rows
(exit 1): 11 ORPHAN-MODULE + 4 DRIVERLESS. **Instrument-version note (named so
the refactor wave does not re-litigate):** MC 10885 revised dead_code (TS
taxonomy) and the ORPHAN-MODULE rows over a `.gd` "live" set (the instrument
has no `.gd` parser → nothing is reachable) are the name-based limit audit-2
§2 already defended for this family — 10 of 11 measure DOC-NAMED this session
(PERMANENCE/LEDGER/M2-SPEC refs per file: strips_gate_check, tile_gate,
tile_post, upgrades_visual_probe, aspect_gate, batch_trellis, dump_render,
icon_gate, player_attempts, validate_glb). Two rows are REAL leftovers:

- [P4] **tools/vm100/01-install-trellis2.sh** — DRIVERLESS and the only
  runnable with ZERO doc refs (grep: docs/, LEDGER, READMEs — empty). Same
  class and same smallest fix as the run-player-s1p.sh row C4 closed: a
  PERMANENCE row naming it (the vm100 install chain its sibling
  `run-unirig-inner.sh` already carries) or delete-with-provenance. NO
  BYTE-RISK (never invoked by any test or product path).
- [P4] **tools/vm100/poc_trellis.py** — ORPHAN, zero doc refs (same grep).
  Same fix shape.
- The remaining DRIVERLESS rows are DEFENDED as measured: `mocap/00-run-all.sh`
  (tools/mocap/README.md names the chain — audit-2 law), and
  `red_controls/mut_a_invincibility.sh` (LEDGER names the committed RED
  CONTROL). `run-unirig-inner.sh` is now PERMANENCE-named (refs re-grepped
  this session — the row audit-2 left unnamed is closed). `run-player-s1p.sh`
  is PERMANENCE-named — audit-2's open row LANDED.
- [P3] **godot/sim/roster_capture.gd — the module-level finding: ZERO code
  call-sites.** Tree-wide grep: referenced only by LEDGER.md and
  docs/M5-SPEC*.md (card provenance text), never by a `.py`/`.sh`/`.gd`/
  `.tscn`. Every sibling capture/probe HAS a code-side driver, measured:
  strips_capture ← tools/strips_gate_check.py, dawnwell_capture ←
  tools/dawnwell_pixel_gate.py, skin_probe ← tests/test_skins.py, achv_probe
  ← tests/test_achievements.py. Consequence (measured in §5): B-E8/K-E3 judge
  the COMMITTED `tests/fixtures/roster-clips-m5-framediff.csv`; nothing in the
  suite re-renders a pixel, and the one instrument that mints that CSV has no
  caller — so a shipped mesh whose clip motion regresses can keep the suite
  green (the CSV currently measures consistent: the capture postdates every
  mesh/rig commit, 506d652/89b9c9f < 1d6373a). Smallest fix, either: wire it
  beside skin_probe's (the family pattern it was COPYED from — test-armed,
  slow-suite cost declared) or a PERMANENCE row naming it the kept manual
  capture WITH a re-mint law on asset-touching cards. NO BYTE-RISK for the
  PERMANENCE shape; the wire option re-dumps only its own CSV.
- Function level: **101 functions ADDED in cf301c5..fea18ea, ZERO uncalled**
  — the precise hunt (a name occurring ONLY on its def line, tree-wide) is
  empty; every one-occurrence candidate traced to an internal call site
  (e.g. `refresh_achievements` :563 ← :529; `close_characters` ← the :620
  button binding; the `_leg_*` family ← driver bodies in their own probe
  files). No dead row.

## 5. VACUITY SPOT-CHECK — 4 M5 ACCEPT rows (does each REACH the implementation?)

- **P-E3 (test_achievements.py:128 `test_p_e3_block_lands_forced_between_
  best_cycle_and_gold` + the whole-scripts save pin): REACHES — verdict REAL.**
  It reads the REAL `main.gd` text (block-scoped to `func _end_run`; the
  `index()` calls LOUD-fail if a pinned line vanishes — no silent pass),
  proves the forced landing order, the single-funnel PIN-HOLD clause
  (`count("_meta_changed()") == 1` in the block, the whole-tree `.save(`
  one-site law, and the re-counted 11-site occurrence set WITH its three
  named growth retire rows). Could it stay GREEN while the impl is broken?
  YES for the achievement MATH (`update()` computing garbage keeps every
  order/count pin green) — and that is the sibling legs' job: the same file's
  sumadd/roundtrip/worse_run probe rows drive the REAL engine and read the
  disk. Weakest assertion: `MAIN.count("_meta_changed(") == 11` — a wiring
  COUNT, not the funnel's effect (the funnel body could no-op and stay green
  here; the funnel's effect is pinned by test_stages/test_save legs).
- **B-E8 (test_characters.py:432 `test_b_e8_clips_move_pixels`): SNAPSHOT
  GATE — honest, doc-armed, never live.** It PARSES the pin doc live (the
  owner "Rec" verbatim + every STATIC row must carry a REASON — real value,
  the doc cannot be quietly rewritten) and cross-checks the doc's rows against
  the roster table, then asserts the COMMITTED CSV's numbers. Could it stay
  GREEN while the impl is broken? **YES** — swap a rigged GLB for a static
  one and nobody re-mints the CSV: the suite renders zero pixels and the
  capture that does (§4.2) has no caller. Weakest assertion: `d >= 2` over the
  CSV's `diff_px` — snapshot values no run recomputes. (Planted-red history is
  real — the row reds pre-build per the card capture.)
- **K-E3 (test_skins.py:257 `test_k_e3_clips_move_pixels`): same class —
  SNAPSHOT GATE, plus the strongest cross-pin of the family** (`states ==`
  the shipped SKINS table's recorded rig states: doc↔code drift goes RED,
  measured by reading both sides). Same weakness named: green under a broken
  shipped skin — weakest assertion `diff_px` read from the same staleable CSV.
- **death-panel (test_dawnwell_shop.py:343
  `test_death_panel_exposes_shop_and_menu`): REACHES — the strongest of the
  four.** The legs run the REAL Main (no relaunch, instance-id proved), the
  REAL `_end_run` death, REAL `find_children` button discovery, REAL
  `pressed.emit()` dispatching the shipped verbs, and the gold read-back is
  `DawnWell.load_save().gold` — FROM DISK — under exact 13-field dict
  equality. Could it stay GREEN while the impl is broken? Only outside the
  named surface: pointer HIT-TESTING is not covered (buttons are emitted, not
  clicked through the viewport). Weakest assertion: `"clickable"` — the
  `disabled`+`is_visible_in_tree()` flag pair, not a real hit-test.

Score: 4/4 named; 2 REAL (P-E3 with the math caveat covered by its sibling
legs; death-panel), 2 SNAPSHOT (B-E8/K-E3 — named weakest assertion: the
committed `diff_px`), and both snapshot rows share ONE root cause, which is
already a finding: §4.2.

## 6. TIDY ROWS (P4, each one line of fixing)

- tests/test_skins.py:383 — `re.findall('"([\w-]+)"', …)` fires
  DeprecationWarning (invalid escape) in the suite output (measured in the
  315-run): make it a raw string.
- docs/M5-SPEC.md:433 names the roster API member `skin_for`; the shipped name
  is `skins_for` — grep-measured ZERO occurrences of the wrong name anywhere
  else (dated spec artifact, misname did NOT propagate; recorded here as the
  retire row, the spec itself is history and stays as written).

## FIX-LIST (clusters: one wave; same-file rule; SAFE unless named)

- **C1 headers (SAFE, comment-only)** — screens.gd: header re-word naming the
  M5 growth + the SCHEDULED-or-owner-accepted decision (§1.1); main.gd: phase
  enum re-word + M5 growth naming (§1.2). Verification: the §1 walk re-run
  stays 0-finding; comment-only pck law (C1/C4 precedent).
- **C2 roster_capture (SAFE — PERMANENCE shape)** — PERMANENCE row naming it
  the kept manual capture + a CSV re-mint law on mesh/rig-touching cards, OR
  the test-side wire beside skin_probe if the owner wants the gate live (§4.2).
  Verification: grep shows the row; if wired: suite 315+1 green, CSV twice-cmp.
- **C3 vm100 leftovers (SAFE, delete-or-name)** — poc_trellis.py +
  01-install-trellis2.sh: PERMANENCE rows or delete-with-provenance (§4.1).
  Verification: dead_code re-run shows the remaining rows ALLOWED/absent.
- **C4 one-liners (SAFE)** — the raw-string fix (§6); grep-to-zero re-check of
  `skin_for` outside the dated spec + this audit's row.

## DEFERRALS (with reasons, re-measured this audit)

- world.gd spawn/entity split — SCHEDULED clause stands; trigger not fired
  (§2.1); M5 proved zero-touch is enforceable.
- sim_stages 583 — trigger not fired (§2.2); carries.
- strips_capture split — BYTE-RISK on the shot stream, header closed the
  deferral; 5-from-band watch row (§2.3).
- screens.gd SPLIT timing itself — the §1.1 decision (section-split the two M5
  overlays vs owner-accepted ceiling) is deliberately NOT made here; the
  refactor card or the owner makes it, this audit named both options and the
  cost (render path, pixel corpora).
- dead_code `--allow` rows for the 10 doc-named tools/ gates — seat-local per
  the audit-2 §5 precedent, not tree debt; the two REAL leftovers are filed
  (§4.1) so the next wave closes them and the instrument's remaining stdout is
  the defended family only.

CAPTURE: `.tmp/cc3.txt` (main checkout, gitignored) — the dod_hygiene-universe
walk, the cf301c5..fea18ea source delta, the per-commit screens/main LOC
history, dead_code + concern_check stdout, the doc-ref and call-site greps,
the 4-row vacuity evidence reads, and the suite run; ends `VERIFY_EXIT=0`.
Instruments run: 6 (walk, delta, dead_code, concern_check, pytest, greps).

GIT-DIFF UNIVERSE PROOF: `git diff --name-only fea18ea..HEAD` on master after
this commit lists exactly `docs/CLEAN-CODE-AUDIT-3.md` + `LEDGER.md` —
docs-only, zero product diff (this card's own gate-run over the untouched
v3.0.0 tree).

# VERDICT: FIX

# REFACTOR-3 — executed over this fix-list (MC 11573 T-CC3R, code, 2026-10-28)

Resume provenance, stated: the prior run of this card was INTERRUPTED mid-build,
leaving uncommitted WIP (modified screens.gd + the 3 M5 test files; NEW
achievements_page.gd + roster_select.gd + .uids) on this worktree. This card
REVIEWED EVERY WIP LINE, kept what served the DoD, and completed the rest; the
LEDGER row repeats the same provenance. Author identity: code (11573).
ZERO-BEHAVIOR-CHANGE LAW executed: the pristine pre-edit base is a worktree
this card created (`git worktree add .tmp/wt-cc3r-base --detach 6fdfc82`); the
journey + every strict fixture were re-dumped on BOTH trees and cmp-verified
(capture .tmp/cc3r.txt; battery scripts .tmp/cc3r-battery*.sh ride the m5z
L0-L7 precedent).

## MIRROR TABLE (per-finding, measured before -> after at this commit)

| § | finding | status | measured |
|---|---|---|---|
| 1.1 | screens.gd 715, >600 crossing nobody judged | CLOSED — SPLIT EXECUTED | screens 715 -> 582; NEW roster_select.gd 131 + achievements_page.gd 52; idiom call-sites 54 -> 54 FAMILY (44 screens + 7 + 3, measured grep); concern_check flag=clean defs=36 (was 39: exactly the 3 moved defs); shop/stage stay HERE (smallest re-pin: 9 pins vs the shop's A-E*/funnel set); <600 band RE-ENTERED |
| 4.2 | roster_capture.gd ZERO code call-sites | CLOSED — WIRED | NEW tools/roster_clip_gate.py (sibling driver pattern: strips_gate_check/dawnwell_pixel_gate; launches res://sim/roster_capture.gd through the ONE capture_lib launcher; call-site greppable: tools/ + capture_lib.py docstring); CSV re-minted BY THE DRIVER (54 rows; 26 motion re-measured, 14 frozen + 14 excused byte-preserved; laws green; TWICE-CMP across two independent xvfb runs; planted reds: motion frame-clone -> motion[min]=0 FAIL rc=1, frozen swap -> frozen=[133188,0] FAIL rc=1, both on COPIES, committed fixture never mutated) |
| 1.2 | main.gd stale phase enum, 4L-from-band | CLOSED — re-worded comment-only | 596 -> 599 (+3: enum names the M5 meta-verb wrappers; growth 503/566/596 @T-M5p/c/k + verb blocks :530/:553-596 = the named wire-graph evidence; reason stays in the first 5 lines; WATCH CARRIED: 1 line from the 601 fail-line, the next touching card re-measures the split FIRST) |
| 4.1 | poc_trellis.py + 01-install-trellis2.sh unreferenced | CLOSED — PERMANENCE rows | two KEPT-probe rows in docs/PERMANENCE.md; measured correction (replace-not-delete): the audit's zero-doc-refs claim for poc_trellis.py re-measured ONE historical mention (docs/CLEAN-CODE-AUDIT.md:126) + a live exec in run-trellis-inner.sh:14 invisible to the instrument (no .sh driver graph — §4 instrument-limit row) |
| 6 | test_skins escape | CLOSED | `'"([\w-]+)"'` -> raw string at the measured line (389 at this base, the audit's :383 pointer was pre-fix); warning class, regex bytes identical |
| 6 | M5-SPEC skin_for misname | CLOSED — dated annotation | spec :433 annotated in place (SHIPPED name `skins_for`; grep-to-zero re-confirmed: the wrong name lives ONLY in the spec line + this audit's row) |
| 2.3 | strips_capture watch | RE-MEASURED only (per fix-list) | 596 at this commit, +0 this card (comment-only law untouched it); 5-from-band row carries |
| — | instrument drift | CARRIED, NAMED | current dead_code.py stdout still lists driver-shaped tools (incl. NEW roster_clip_gate.py) as ORPHAN-MODULE: name-based, no .sh/.gd driver graph; seat-local --allow per audit-2 §5 precedent — NOT tree debt |

## How the split was chosen (the §1.1 decision, made and measured)

Cohesion cut, not size cut: the two M5 overlays (roster select + skin chips,
achievements page) are the YOUNGEST, most self-contained builders; their
bodies moved VERBATIM into static-builder modules that call screens.gd's ONE
panel-style idiom through the passed-in instance (`RosterSelect.build(self)`
/ `AchievementsPage.build(self)`) — zero new UI mechanism, zero new colors,
the overlays still open on screens.gd's `_overlay` in `_ready`, and ALL
dispatcher verbs main routes (show/close/visible/refresh) STAY in screens.gd
(main.gd diff: comment-only). FALSIFIED-COUNT: 9 source pins re-pointed to
the moved homes (3 test_achievements, 4 test_characters, 2 test_skins) —
6 re-pointed with the regex text byte-identical; 3 moved WITH the body's
idiom call and their text shifted `_well`->`s._well`, `_chars_rows`->
`s._chars_rows`, `_well.gold`->`s._well.gold` (strictly MORE specific, same
ONE-seam laws — equal-or-stronger); ZERO pins deleted; suite 315 -> 315
(replace-not-delete). The shop/stage overlays stayed: their pin sets
(A-E*/funnel text) are larger and funnel-adjacent — the split the audit
scheduled, at the cost it named: the moved surfaces are RENDER surfaces,
and the pixel proof is below.

## BYTE-ANCHOR ROWS (base = the 6fdfc82 worktree this card created)

- journey-5020 @HD3D_SEED=11101: BASE dump == FINAL dump == committed
  .tmp/hd3d-boss-s6-dump.jsonl — all three BYTE-IDENTICAL (5020 rows).
- Strict corpus: 11 fixtures × BOTH trees = 22 cmp legs, ALL BYTE-IDENTICAL
  (endless/gems/unions/chests-tiers/chests-evolve/carry-caps/art-probe/
  stages/events/reaper/limit). chars 38/38 unmatched=0; achv BYTE-IDENTICAL
  both sides.
- Strips: fresh capture BOTH sides 75 rows, gate 19/19 GREEN, NORM diff 0
  base-vs-committed, final-vs-committed AND base-vs-final.
- Pixel gates (THE split proof): dawnwell_pixel_gate 4/4 PASS on BASE and on
  FINAL with IDENTICAL counts — shop 60855 / stage 52020 / achievements
  56802 / char_select 65237 — and equal to the m5z-LEDGER numbers; the two
  moved builders render pixel-for-pixel identical (achievements + char_select
  are exactly the split surfaces).
- s8 A1 contract table 11/11 PASS rc=0 on the final tree (fresh strips leg,
  committed-GA-record comparison; the tracked strips dump was cp-backupped
  and cp-restored, cmp-verified byte-identical after the run).
- world.gd diff ZERO (git diff --numstat empty; 551 L unchanged).
- Gate walk re-run on the final tree: 0 findings (ceiling arms both sides;
  new family files 131/52/190 L, all < 250, no reason needed).

CAPTURE: `.tmp/cc3r.txt` (main checkout, gitignored) — ends VERIFY_EXIT=0.
Instruments run: 7 (pytest, corpus battery both trees, roster gate twice-cmp
+ 2 planted reds, pixel gates both trees, strips gate both trees, s8, walk +
dead_code + concern_check).
