# M5-SPEC-DA-c2 — Devil's-advocate gate, cycle 2 (MC 11412, T-M5e)

- **Target:** `docs/M5-SPEC.md` REV 2 @ `73f63da`. `git diff 9b1d067..73f63da -- godot/ tests/
  tools/ assets/` = EMPTY this session ⇒ docs-only delta (verified); the spec's tree claims are
  judged at the same bytes the producer re-grepped. History: rev-1 @ `e58569f`, c1 verdict FIX @
  `9b1d067` (1P1/4P2/3P3/4P4, `docs/M5-SPEC-DA.md`, immutable). Rev-2 claims 12/12 adopted, 0
  rebutted, 2 mechanism corrections inside adopted rows (F-3/F-13), rows 1-5 landed as declared
  lines. Precedent shape honoured: M4-c2 (`docs/M4-SPEC-DA-c2.md`) — the cycle-2 class to hunt is
  TWO INDEPENDENTLY-TRUE ADOPTED FIXES (OR A FIX AND ITS OWN CITE) THAT CONTRADICT EACH OTHER.
- **Method:** PASS 1 — every c1 row re-grepped THIS session at `73f63da` (no evidence carried from
  c1). PASS 2 — attacks on the REV-2 delta ONLY: the new §2.1b apply-step read against the real
  `hero_pawn.gd` body and the real sim channel; the P-E3 counts re-run by grep; the const-READ-ONLY
  mechanism correction re-probed by ME on the pinned binary `Godot_v4.7.2-stable_linux.x86_64`
  (two probes, this session); the F-2 precision rebuttal judged against the regex text verbatim;
  a fold-collision pass over 12 NEW × EXISTING pairs (pairs CLEARING named in §2.5). PASS 3 —
  regression spot: the SEL table, the owner marker, the ACCEPT row count, the byte-anchor sections,
  and the suite RE-RUN by me on THIS rev's tree: **278 passed, PYTEST_RC=0** (8.12 s warm cache —
  the spec's own REV-2 line declares its run warm; the canonical cold `--import` 157.24 s line is
  the producer's, quoted not quoted-from).
- **Verdict summary:** **SHIP.** Adoption is real — 12/12 rows landed with the right mechanisms and
  rows 1-5 verified as DECLARED LINES, both self-caughts honest and true (the ember-bolt id truth
  confirmed in `weapons.gd:23`; the deep-read-only correction reproduced by my own probes), the
  gate-internal precision rebuttal CONCEDED (my c1 example was wrong — §3). No P1, no P2. Four P4
  tails (one new misattribution introduced BY the P4-1 fix, two cite-range/signature drifts, one
  wave-map name) — wave-brief material, gate-clean.

## 1. PASS 1 — Adoption audit (12/12, each evidence line re-grepped at 73f63da)

| c1 id | status | fresh evidence (rev-2 section + tree grep THIS session) |
|---|---|---|
| **P1-1** pawn never receives selection | **LANDED — executable, the fix is real** | §2.1b exists: `apply_selection()` = the `_ready` body moved, called at the F-7 hand-in tail after `game.char_id`/`game.skin_id` (mesh re-read LAST). The landing is executable end-to-end, re-derived by me: the pawn is created at EXACTLY `main.gd:32/:89-91` (`_pawn` appears nowhere else — re-grepped); `SimFunnel.fresh_run` instantiates `Main.tscn` and calls `run._start_game()` (`sim_funnel.gd:37-50`) ⇒ the apply-step runs in every SIM run too, and `run._pawn` is reachable for the leg's live read — "the pawn the SIM actually shows" is literally true. `ClassMesh.mesh_for` is a static cache (`class_mesh.gd:23-26`) ⇒ B-E7's row-0 twin "cache identity" claim is checkable as written. NO pin reads `_ready` or the material block: the ONLY HERO-source test is `test_art_integration.py:156-162` and it reads the `_player_mesh()` BODY as a SUBSTRING (`ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER) in seam.group(0)` + `"CapsuleMesh" not in HERO`) — extension keeps both verbatim ✓. B-E7 carries the twin-leg + the "apply-step DELETED" planted red naming its own check — the feature-dead class is instrumented (c1's strongest finding closed by an observable, not prose). |
| **P2-1** block placement vs gold→funnel pin | **LANDED** | §1.1 lands the block ABOVE `_dawnwell.gold += game.stats.gold`, below the best_cycle write — and the tree says the lines exist where cited: best_cycle max-rule `main.gd:365-366`, stage-chain block `:367-374`, gold `:375`, `_meta_changed()` `:376`. The pin re-read VERBATIM: `test_dawnwell_shop.py:156-157` = `re.search(r"_dawnwell\.gold \+= game\.stats\.gold\s*\n\s*" r"_meta_changed\(\)", MAIN)` — whitespace-only between, comments do NOT qualify (c1's reading confirmed). PIN-HOLD clause as declared (no call, no save, neither literal touched). §7.2 STAY cite extended to `:136-157` naming `:156-157` ✓. I additionally verified the landing against the OTHER `_end_run` reader, `test_stages.py:290-298`: its pins are membership on `stage_unlock_after`/level-check/flag-write + `erase/pop_at` absent + `end_run.count("_meta_changed()") == 1` — an above-gold insertion with zero funnel calls survives ALL of them ✓. Gate-internal precision rebuttal: CONCEDED, §3. |
| **P2-2** aliasing law | **LANDED + mechanism correction JUDGED TRUE (probe §2.1)** | §0 F-5 duplicate() law + §2.1 consumption + B-E2 twin-leg, as the fix clause has them. "row 0's duplicate EQUALS the shipped `:173` row BY VALUE" — the shipped literal re-read at `game_state.gd:173`: `[{"id": "talon", "level": 1, "cd": 0.0}]` ✓; the equality pin is value-comparable as written. The correction ("deeply READ-ONLY … LOUD failure") reproduced by MY probe on the pinned binary — §2.1. The spec's law says DEEP duplicate, and my probe proves deep-vs-shallow is the live distinction (a shallow `duplicate()` re-shares the const rows verbatim: `arr[0] == T["weapons"][0]` TRUE). One red-signature tail on B-E2: F-2 (P4, §4). |
| **P2-3** zero-write leg contradiction | **LANDED** | P-E1 now the zero-DIFF shape verbatim from the fix clause ("SETS no new flag and moves NO max-rule counter, the Σ-add rows move by the EXACT deltas and NOTHING else moves"), and §1.1 carries the honest always-write law with the `runs_total += 1` admission. Internally consistent with the §1.1 counter table re-checked row by row (the max-rule legs — `max_level`, `evolutions_seen`, `unions_seen` — are exactly the counters the leg freezes; `best_cycle` is READ-only there ✓). |
| **P2-4** phantom instrument | **LANDED — all four counts re-measured by me** | `test_save.py:133` = `assert MAIN.count("_dawnwell.save()") == 1` (MAIN-scoped ✓); `test_stages.py:296` = `end_run.count("_meta_changed()") == 1` + `MAIN.count("func _meta_changed") == 1` (block-scoped ✓); whole-`godot/scripts/` grep of `\.save(` ⇒ EXACTLY one site, `main.gd:421` (the funnel inside `_meta_changed` at `:420-421`) ✓; `_meta_changed(` parenthesized occurrences in main.gd ⇒ calls `:287/:376/:437/:443/:449/:471` + definition `:420` = 7 — EXACTLY the row's list (comment hits carry no paren; the row's count is the count) ✓. The P-E3 reds both name instruments that fire: the whole-scripts pin and the `:156-157` adjacency the P2-1 landing now owns. |
| **P3-1** 18-row fixture | **LANDED — history verified from git objects** | `tests/fixtures/art-s2i-probe.jsonl` = **18** lines at `73f63da`; `git show 9efcf6e:…` = **15**, `1e6d366` = **17**, `48fad4b` = **18** — the §12 F-6 commit-pinned history is EXACT. §7.1 + R2 both re-worded to 18/FOURTH; B-E7 says prior 18 ✓. |
| **P3-2** sim_events 537 | **LANDED** | `wc -l`: sim_events **537**, sim_stages **583**, strips_capture **596**, world.gd **551** — all four carry numbers now true; §10's preemption row updated 533→537 in the same delta ✓. |
| **P3-3** six drifted cites | **LANDED — all six re-measured** | `game.start_run()` = `main.gd:302` ✓; `VERSION := 1` = `save.gd:24` ✓; `func save()` = `save.gd:76` ✓; fields gold→stage = `save.gd:27-42` ✓; five overlays = `screens.gd:98-107` ✓; `start_run() :144`, `set_phase :182` in `game_state.gd` ✓. Header also matches the file line counts I re-measured: game_state 254, main 472, screens 445, save 128, hero_pawn 63. |
| **P4-1** §h/§a attribution | **LANDED — BUT THE FIX INTRODUCED A NEW MISATTRIBUTION (F-1, P4)** | Perspective now at §a — TRUE (`DESIGN-3D.md:19-20` verbatim "(perspective rejected: v1 entities are size-pinned…)"). But "full 3D physics at §a's collision law" (F-1) and "perspective + 3D physics at §a" (§9.1) are wrong: §a carries NO collision law (grep: the file's collision lines are §h's), and §h `:352-353` REJECTS full 3D physics IN ITS OWN BULLETS ("**Full 3D physics** — … a second collision mechanism beside v1's proven 2D one") — the very phrase "collision law" is §h's wording, re-homed to §a. §12 F-9's cell says "the rest at §h" — the ledger cell contradicts the text it declares. Substance (a rejection exists, the `DESIGN-3D.md:4` owner quote is verbatim-real) unchanged. |
| **P4-2** T-S1p window | **LANDED** | LEDGER:13 re-read: "ONE bounded GPU window OPEN 15:37:25/CLOSED 15:44:38 rc=0" — the §2.5 re-wording ("ONE bounded window (15:37→15:44, the LEDGER row as measured)") is exact, and "~3/mesh stays the RESERVED estimate" matches T-M1c2's 4/12 history ✓. |
| **P4-3** B-E4 cross-ref | **LANDED** | B-E4 red cell now reads "the M4-SPEC B-E1 endless-pattern red" ✓. |
| **P4-4** roadmap M2 #4 | **LANDED** | §6 doc-sync names roadmap `:238-240` with the LANDED/NOT-LANDED re-word, replace-not-delete; the roadmap lines re-read: `:240` "ACCEPT: fresh-save leg shows gated card ABSENT…" IS the pool-gating half §9.2 excludes — the clause is true as written. |
| **F-13 (self-caught)** ember-bolt | **ADOPTED-HONEST — verified** | `weapons.gd IDS` `:23-24`: `"ember"` present, `ember-bolt` absent anywhere in the file (grep-zero) — the c1-era table id WAS dead; the row-1 table now reads `ember`, and ALL five non-default start weapons (`ember/ward/talon/dart-loop/censer-of-hours`) ∈ IDS ✓. The typo's new life as B-E2's planted red is executable: the row names its instrument (kill-attribution leg never sees the weapon) and B-E9's cross-pillar pin (ids ∈ weapons.gd) catches the same class at the table — complementary instruments, one class ✓. |
| **F-14 (PASS list)** | **CONFIRMED UNTOUCHED** | §2.5 option rows byte-identical in the diff (only the P4-2 preamble lines moved, declared); OWNER-DECISION-PENDING 6 hits in the doc (same count); suite re-run by me: 278 passed RC=0. |

**Adoption tally: 12/12 landed, 0 rebutted at row level, consistent with the §12 ledger's own
arithmetic; the 2 disclosed mechanism corrections are corrections to the spec's OWN reason-text
(one of them — mine — conceded below), not to any fix clause. Rows 1-5 (the P1 + four P2s) VERIFIED
landed as declared lines.**

## 2. PASS 2 — New-material attacks (REV-2 delta only)

### 2.1 The const READ-ONLY correction — re-probed by me (VERDICT: true, fold not weakened)

On the pinned `Godot_v4.7.2-stable_linux.x86_64` (the repo's own `capture_lib.py:21-23` default,
`--headless -s`), my probe #1: `const T := {"weapons":[{…}]}`; `T["weapons"][0]["level"] = 5` ⇒
`ERROR: Dictionary is in read-only state.` + `SCRIPT ERROR: Invalid assignment on read-only value
(on base: 'Dictionary')` — the spec's quoted engine text VERBATIM — and execution ABORTS AT THE
ASSIGNMENT (the probe's later prints never ran: LOUD means abort-loud, even stronger than the
spec's claim). Probe #2: `duplicate(true)` returns a WRITABLE deep copy (mutation + `append` pass,
const untouched) while a SHALLOW `duplicate()` re-shares the const rows (`arr[0] == T["weapons"][0]`
TRUE — the shallow trap is real and the spec's law says DEEP, as written). **Does the correction
weaken the fold? No:** without `duplicate()` the FIRST weapon mutation of every run aborts
(`levelup.gd:133` `w.level += 1` — an in-place dict assignment, re-read; `:129` appends to the
weapons ARRAY too — a const array fails the append as well) — the game is broken outright, so
duplicate() is the fix FOR the loud failure (exactly how the spec states it), not dead weight; the
green-side twin-leg (two `fresh_run`s in one process, byte-equal weapons rows) tests something real
— it is the guard for the shallow-vs-deep and mutable-shape classes my probe #2 proves exist. One
tail: the B-E2 RED cell still narrates the silent signature the correction killed (F-2, P4, §4).

### 2.2 The F-2 precision rebuttal — CONCEDED, finding stands

The spec says my c1 example "between :374/:375 breaks the pin" is wrong because the regex STARTS at
the gold line. The regex verbatim (`test_dawnwell_shop.py:156-157`, re-read above) proves it: an
insert BEFORE `:375` leaves the `gold…\s*\n\s*_meta_changed()` span intact. **I concede the example
— it was wrong.** The finding stands regardless, exactly as the spec's own cell says: "BESIDE
:372-376" licensed the two readings that DO fail (between `:375/:376` — breaks the adjacency regex;
below `:376` — counters persist one mutation late, P-E2's on-disk legs RED) and never named the one
landing that works; §1.1 now names it. A wrong illustrative example inside a correct finding is a
gate-internal blemish, not a retraction — the REV-2 disposition recorded it precisely that way.

### 2.3 The new §2.1b — attacked at body level

The fix text vs the real file: `_ready` is `:34-45` and its body is `:35-45` — the cited ranges
(`:34-43`, body `:35-43`) truncate two lines short: `:44` (`_mat.albedo_color = PLAYER_TINT`) and
`:45` (`material_override = _mat`) — the tint-assignment and override lines a "MOVED verbatim" law
must carry (F-3, P4; the prose enumerates every statement, and the honest note rides: c1's OWN cite
`:36-43,:50` drifted too — `:50` is `_player_mesh`, the iframes-α line is `:63` — the spec inherited
the gate's numbers, both sides' cites are card-time re-grep duty). Lifecycle claims verified: one
creation site; `world.reset()` is `main.gd:296` INSIDE `_start_game` before the hand-ins and the
pawn is not in `world`'s file set (grep: `HeroPawn`/`hero_pawn` appear nowhere in `godot/sim/`);
mid-run selection unreachable (the five shipped overlays are menu-phase verbs behind the ONE
`hide_all()` funnel; B-E7's "nothing else" law holds). Idempotence claim verified against the body:
each call re-derives mesh + a FRESH material duplicate (the body's `duplicate()` FIRST law, `:40-41`),
old `_mat` dies with the old override; `_process`'s iframes-α line (`:63`) reads the live `_mat` —
after a run-start apply at iframes 0 the alpha is the tint alpha, byte-law for the capture streams
holds (row-0 re-derivation returns the SAME cached mesh + identical tint ⇒ pixel-invariant).

### 2.4 P-E3's new grep-pin — attacked for blind spots

The scope `all of godot/scripts/` is right-sized, not gamed: the new `achv_probe.gd`/`sim_chars.gd`
land in `godot/sim/` (harness drivers, not shipped game code) and their probes MUST write through
the shipped `DawnWell.save()` to be roundtrip-on-disk instruments — a pin that caught them would
pin the probe pattern itself false. The law's real target — game code bypassing the ONE funnel — is
fully covered by the stated scope (`main.gd:421` the sole legal site, measured). The row's "no
cross-file blind spot" reads as scoped to the game tree; stated, not filed.

### 2.5 Fold-collision pass over the NEW × EXISTING pairs (12 run, 12 CLEAR)

(a) **apply-step × PLAYER_TINT boot law** — CLEAR: the body moves with its tint lines; `_process`
reads the re-derived `_mat`; run-start iframes=0 keeps the alpha law. (b) **apply-step × art-fixture
rows (R2/`:152` seam-pin)** — CLEAR: substring form survives the extension verbatim; CapsuleMesh
guard unaffected; NO test reads `_ready` (grep of `tests/` for HERO reads: only `test_art_integration`).
(c) **apply-step × SimFunnel sim-runs** — CLEAR: `fresh_run` runs `Main.tscn._start_game`, so the
step executes in sims; the body touches zero RNG and zero `game` state ⇒ every committed dump inert.
(d) **alias-guard × journey determinism** — CLEAR: row-0 deep-duplicate EQUALS the `:173` literal by
value (probe §2.1 shape), duplicate() consumes no RNG, journey runs row 0. (e) **pawn-lifecycle leg ×
boot-once invariant** — CLEAR: one creation site, apply at boot + every run start, leg reachable via
`run._pawn`. (f) **P2-1 landing × `test_stages.py:290-298`** — CLEAR (verified line-by-line, §1).
(g) **P-E3 grep-pin × new sim files** — CLEAR (§2.4). (h) **duplicate() law × F-2 byte law** — CLEAR:
equality pinned BY VALUE, the `:173` literal stays, B-E3's row-0 twins unchanged. (i) **ember-bolt
planted × B-E9 cross-pillar pin** — CLEAR: same drift class, two complementary instruments, all six
table start-weapons ∈ IDS. (j) **new hand-in lines × `test_endless.py:130-135` + `test_stages.py:318`**
— CLEAR: both re-read as MEMBERSHIP regexes (`:133-135` start_run→endless with comments-only between;
`:318` `re.search(seed_stage_props…, hand[hi:])` — tail lines can't break a membership) — the spec's
"MEMBERSHIP regexes, not adjacency" claim is TRUE as written. (k) **char_id/skin_id resets ×
`test_endless.py:123-127`** — CLEAR (names endless/cycle only). (l) **apply_selection × mid-run
overlay exclusivity** — CLEAR (menu-phase-only verbs, §2.3). No collisions that do not clear.

## 3. The c1-vs-reality ledger, kept honest (concessions on the record)

1. My P2-1 example ("between :374/:375 breaks the pin") — **WRONG, conceded** (§2.2); the finding's
   two failing readings stand and the spec adopted the fix as written.
2. My P2-2 mechanism read ("silent run-2 poisoning") — **SUPERSEDED by the pinned binary**: the naive
   hand-off ABORTS at the first mutation (§2.1, my own probe). The fix clause and the leg were
   adopted correctly; my mechanism story was not.
3. My own cite `hero_pawn.gd:36-43,:50` (P1-1 row) — drifted (`:50` is the seam function; the
   iframes-α line is `:63`); the spec inherited it into §2.1b/§12 — the same drift family as F-3
   below, one shared cause: cycle-1 read the body by eye, not by `cat -n`.

## 4. Findings register

| id | sev | one-liner | fix (one clause) |
|---|---|---|---|
| F-1 | P4 | The P4-1 fix introduced a NEW misattribution: "full 3D physics at §a's collision law" (F-1) / "perspective + 3D physics at §a" (§9.1) — §a has no collision law; §h `:352-353` rejects full 3D physics verbatim, and §12 F-9's own cell ("the rest at §h") contradicts the text it declares landed. | F-1 + §9.1: move "full 3D physics" back to §h's list (perspective stays §a `:19-20`, where the fix correctly put it). |
| F-2 | P4 | B-E2's planted-red signature ("`duplicate()` removed with run 1 upgrading ⇒ run 2's dump row carries the upgrade") is UNREACHABLE on the const table the spec itself now says is deeply read-only — the mutant ABORTS at run 1's first mutation (my probe; `levelup.gd:133` `w.level += 1` is an in-place dict assign); the leg still goes RED via the engine abort (missing dump row), but the written signature contradicts §0 F-5's own admitted law (the M4-c2 F-3 instrument-mis-naming class). | B-E2 red cell, one clause: fire the planted read-only ABORT (name it), OR plant the mutable-shape future the §0 F-5 text says the leg guards (const→var demotion + duplicate() removed — the silent signature then exists and the leg catches it). |
| F-3 | P4 | §2.1b cites `hero_pawn._ready` as `(:34-43)` / body `(:35-43)`: `_ready` is `:34-45`, body `:35-45` — the truncated two lines (`:44` tint assign, `:45` material_override) are the tint law the MOVE must carry; prose enumerates the statements, so intent survives (and the gate's own c1 cite `:36-43,:50` was the drift source — §3). | §2.1b: two line-number touches (`:34-45`, `:35-45`); card-time re-grep duty restated applies to both docs. |
| F-4 | P4 | §6's T-M5c file column names "`test_hero seams`" — no `tests/test_hero*` file exists; the hero seam-pin lives in `test_art_integration.py` (§2.4 names it correctly — the wave-map column is the sole offender). | file column: "`test_art_integration.py` hero-seam rows" (or name the new file it means). |

**Counts: P1 = 0, P2 = 0, P3 = 0, P4 = 4.**

## 5. What survived (for the record)

Everything the c1 PASS-list carried, spot-re-verified at `73f63da` per the regression row, plus the
new material: the apply-step is executable in BOTH channels (session + sim) with its instrument leg
reachable; the P-E3 pin counts are four-for-four exact against the tree (including the seven-site
`_meta_changed(` list, line-for-line); the duplicate() law says DEEP and the deep-vs-shallow trap it
guards is REAL on the pinned binary (my probe #2); the fixture history cites resolve against the
git objects (15/17/18 at the named SHAs); the ember-bolt self-catch is true and re-armed as a
planted red; the F-7/test_stages:318 MEMBERSHIP claim is literally true of both regexes; the SEL
table, the OWNER-DECISION-PENDING marker (6 hits), the 24 ACCEPT rows, the byte-anchor classes
(5020 @11101, 12 fixtures, strips norm, s8 contract-class) and the wave/version/owner-line core are
byte-stable through the fold; the suite is green on this tree under MY run (278, RC=0).

## 6. Reading-of-ambiguity statement

- "test_hero seams" (§6) is read as shorthand for the hero seam-pin (⇒ F-4 naming nit, not a
  missing-file finding — §2.4 carries the correct name).
- "the `_ready` body (:35-43) MOVED verbatim" is read as full-body intent (the prose enumerates all
  statements; ⇒ F-3 as a cite-range row, not a law defect).
- The F-2 concession is scoped to the c1 EXAMPLE sentence; the P2-1 finding itself (ambiguous
  BESIDE, two failing readings, unnamed lawful landing) stands as adopted — the producer's reading
  and mine agree on that, and the adopted text is lawful.
- "LOUD" is read from my probe as function-ABORT (later statements never execute), which is the
  strong reading the spec's claims benefit from — stated as VERIFIED by direct observation.
- The suite's warm 8.12 s vs the producer's cold 157 s: the REV-2 line self-declares warm; the cold
  line is the author's own run quoted with its capture; not a finding.

## 7. Wave-brief log (P4 rides, none gates)

1. **F-1 + §9.1** — full-3D-physics attribution back to §h.
2. **B-E2 red cell** — F-2 abort-signature (or mutable-shape plant) clause.
3. **§2.1b cites** — `:34-45`/`:35-45`.
4. **§6 file column** — F-4 name fix.
(All four are same-commit text touches; none touches a mechanism, a pin, or a byte anchor.)

## 8. Verdict

Rows 1-5 of the c1 fix list are verified landed as declared lines (each re-grepped THIS session);
12/12 adoption is real; both self-caughts judged honest — one (ember-bolt) verified true in the
tree, one (READ-ONLY) verified true at the pinned binary by my own probes; the gate's own example
error is conceded and does not move the finding; the new content introduces four P4 cite/signature
tails and zero P1/P2. Nothing blocks the wave: T-M5p→T-M5c→T-M5k→T-M5z may file once the owner's
SEL ruling arrives (the marker rides untouched, by design — the gate does not verdict it).

# VERDICT: SHIP
