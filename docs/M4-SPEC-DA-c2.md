# M4-SPEC-DA-c2 — Devil's-advocate gate, cycle 2 (MC 11352, T-M4e2)

- **Target:** `docs/M4-SPEC.md` REV 2 @ `60d9811`. `git diff 5695244 60d9811 -- godot/ tests/
  tools/ assets/` = EMPTY this session ⇒ the spec's tree claims are judged at the same bytes the
  producer re-grepped (docs-only delta; verified). History: rev-1 @ `0bf3acd`, c1 verdict FIX @
  `5695244` (2P1/2P2/6P3/4P4, `docs/M4-SPEC-DA.md`, immutable). Rev-2 claims 13/14 adopted, 0
  row-level rejects, 2 sub-items rebutted. Precedent shape honoured: M3-c2 (`docs/M3-SPEC-DA-c2.md`)
  — the cycle-2 class to hunt is TWO INDEPENDENTLY-TRUE ADOPTED FIXES THAT CONTRADICT EACH OTHER.
- **Method:** PASS 1 — every c1 row re-grepped THIS session at `60d9811` (no evidence carried from
  c1). PASS 2 — attacks on REV-2-only material: the A-E4 three-leg arithmetic machine-re-derived off
  the shipped rate term, the B-E6 crash-route against the repo's OWN red-observation precedent, the
  drop-guard byte-truth against `kill_enemy`'s RNG sites, the arrival-latch placement against the
  real `_spawn_enemy` call sites, the R2 17-row partition row-by-row against every sim_stages/sim_bosses
  leg, the inline-icon route read at test-file row level, and F-5's means RE-MEASURED. PASS 3 —
  regression spot of the c1-PASSed rows.
- **Verdict summary:** **FIX.** Adoption is real — 14/14 rows landed with the right mechanisms, both
  rebuttals stand (re-grepped myself) — but the P4-4 fold (A-E5 "…and to run-end") and the §1.1 cone
  mechanism, each true alone, COLLIDE: the row's digest twin cannot go GREEN as written on correct
  code (F-1, P2). One P3 (§2.1's outrun-claim vs the same milestone's repeatable LIMIT·HASTE), three
  P4 tails. No P1; the design core c1 upheld is unchanged.

## 1. PASS 1 — Adoption audit (14/14, each evidence line re-grepped at 60d9811)

| c1 id | status | fresh evidence (rev-2 section + tree grep THIS session) |
|---|---|---|
| **P1-1** win-pin vs cap-fork | **LANDED** | §7.2 R9 exists, names the pin by its REAL extent: `def test_win_branch_…` is `test_endless.py:138`, regex `:139-147`, assert `:148` — spec's `:139-148` ✓. Grepped the regex itself: it requires `_cycle_clear\(\)\s*\n\t*else:` with the comment-allowed zone ONLY before `if game.endless:` ⇒ NO text between `_cycle_clear()` and `else:`, and the endless-block body is pinned line-by-line ⇒ EVERY reaper-fork shape breaks it, exactly as R9 states. Equal-or-stronger as DECLARED: the re-pinned regex pins the literal `if game.endless: … elif game.reaper: … else: _end_run("win") return` sequence — matching the source ORDER of the arms pins the elif-chain order (the "unless Endless" law becomes source-pinned; c1's fix did not ask this). Same-commit law STATED ("REPLACE-AND-RE-PIN, same commit", T-M4r row of §6 carries the test file). The rejected alternative (`elif`-substring accident) is named and rejected in R9's own cell ✓. B-E1 names exactly the survivors: `:114-118` contact pin (def :112, regex reads ONLY the raw→damage_taken adjacency at `main.gd:219-220` — a reaper check inserted BEFORE `var raw` keeps it ✓) and `:130-135` hand-in pin (def :130, reads `game.start_run()`→hand-in lines `main.gd:276` ✓ disjoint from :139-148). |
| **P1-2** A-E4 red unreachable | **LANDED** | §1.4 A-E4 now THREE legs. Arithmetic RE-DERIVED from `world.gd:259` (`minf(12.0,(1.0+1.3*minute)*qty_cyc*surge)*dt`) + `cycle_minute:61-62` (cycle-0 ⇒ t/60): mechanism [180,210] ⇒ minute 3.0–3.5 ⇒ base 4.90–5.55, ×2.0 = 9.80–11.10 < 12 ⇒ inside==outside, ratio 2.0 purely observable, planted-1.5 red fires at 1.5 (tolerance class: the shipped `plates_rate` uses ±0.06, `sim_stages.gd:314-315`) ✓. Saturation [480,510] ⇒ base 11.40–12.05, ×2 = 22.80–24.10 vs 12.0 ✓ (observable caveat: F-4). Cap leg minute 11+: base ≥ 15.3 ⇒ both twins 12.0 ✓. Mirrors the shipped `minf_binds_both` (`sim_stages.gd:349-350,375`) / `minf_clamps_surge` (`:427`) shapes the row cites ✓. |
| **P2-1** reaper death vs strict map | **LANDED** | §2.1 Death-guard bullet + B-E6 + §12.4 third exception. Guard route verified byte-true for the shipped rows: `kill_enemy` (`world.gd:342-368`) — warden/choir/ossuary rows carry no `reaper` key ⇒ `enemy.get("reaper", false)` false ⇒ every path byte-identical INCLUDING the RNG sites the guard skips (`:349` gem randf, `:351` coin randf, `:353` heal branch, `:363` chest randf — all skipped ONLY for reaper rows, which no committed stream constructs). Guard placed after `remove_at`+`kills+=1` (`:345-346`), before the +50 bounty `:347-348` ⇒ "no +50" claim true. The keyed boss site `CHEST_TIER_BY_SOURCE[String(enemy.type)]` (`:363-365`) + `SPEC_MAP` exact-equality (`test_chests_tiers.py:109/:142`) untouched ⇒ 7-row map claim consistent. (Red-instrument wording: F-3.) |
| **P2-2** A-E1 self-falsifying | **LANDED** | A-E1 now enumerates the UNMOVED corpus — the 7 non-carve committed fixtures (list matches `ls tests/fixtures/` minus `stages-m3`/`art-s2i-probe` exactly) + the journey + "the 14 PRESERVED stages-m3 rows R2 names"; moved rows asserted under R2/R4 "never under this row" ✓. R9's file (`test_endless.py`) is a test file, not a fixture ⇒ no new collision with A-E1's scope ✓. |
| **P3-1** latch placement | **LANDED** | §2.1/§2.2: ONE world-side placement inside `update_spawns` beside the schedule latch. The zero-call-sites claim I was asked to trace: `grep -rn _spawn_enemy godot/scripts/` ⇒ EXACTLY `world.gd:238` (latch) and `world.gd:263` (horde loop) — TRUE, no main-side call exists, and the spec no longer proposes one. Above-cap-by-position claim TRUE against the code (latch block `:225-238` precedes the cap early-return `:249-250`). `test_boss_numbers.py:74` counts the literal `_spawn_enemy(b[1], game, view)` == 1 — a reaper arrival call is a DIFFERENT literal ⇒ survives ✓. |
| **P3-2** A7 text | **LANDED** | `tools/s8_acceptance.py:230` comment "32 kinds" + `:238` `row("A7", "all 32 pool kinds (16 weapons + 15 passives + 1 bonus)")` — both re-grepped, both exact lines; R7 carries them replace-not-delete, §6 doc-sync names `tools/`. |
| **P3-3** R2 partition | **LANDED + SELF-CORRECTION VERIFIED** | Fixture counted myself: `stages-m3.jsonl` = **17 rows**; the 17 ev-names match R2's partition exactly (3 moved / 14 preserved). Every PRESERVED claim re-verified against its leg: `stage1_schedule`/`schedule_rearm` run `_fresh_run(1)` to t=782 — stage-1 rows unchanged ✓; `rng_stream` digests t≤60 (`sim_stages.gd:296`) ✓; `plates_rate` warp-30+1800 ⇒ ≤60 ✓; `plates_flare` clock-pinned 380 ✓; `plates_cap` warp-540+3600 ⇒ ≤600 < 660, `named_spawns_once==1` unaffected ✓ (R3's retraction is TRUE — the code pins t=540, 3600 steps, exactly as R3 states); `plates_saturation` warp-540+1800 ⇒ ≤570 ✓; `draw_tally` fresh runs at t=0 (pickup-MultiMesh counts 5/5/6, committed payload checked) ✓; `unlock_chain`/`handin`/`snapshot_m3` state/string dumps no clock ✓; `boss_contact_clamp` runs stage 3 warped to t=2700.5 — its COMMITTED payload (`observed_delta 20.0`, `raw_cycle3/4` dicts) is stream-independent: contact breaks on `enemies[0]` (the leg-spawned warden at the pawn) and the warp-fired latch spawns (choir + the NEW 660 acolyte) land on the ring ≈796 px out, never in contact radius ✓ — the row genuinely survives the 660 entry; `stages_verdict` `rows:16` matches `sim_stages.gd:578` append + F-9 (no new sim_stages legs). And the two MOVED schedule legs really DO cross 660: `sim_bosses.gd:74` runs to `t < 782` on stages 2/3 ✓. REV-2's honest self-correction (REV-1 moved `plates_cap` wrongly, `stages_table` was the unnamed mover) verified against the code. |
| **P3-4** file sets | **LANDED** | §6: T-M4r file column names `sim_budget.gd` (the `budget_reaper` leg) ✓; T-M4e `depends on` names `T-M4a — the two event-miniboss mesh rows` ✓; `test_art_integration.py` appears in both T-M4e and T-M4r rows (R4's both-commits re-pin) ✓. |
| **P3-5** inline icons | **LANDED, row-level verified** | `screens.gd icon_path()` `_: ` arm exists with the assert (`:70-73`, `"res://assets/icons/%s.png" % card.icon` + `assert(ResourceLoader.exists(path))`) — the `bonus` row's own route. `icon-cleaver.png`, `icon-dart-loop.png`, `icon-plate.png` ALL PRESENT in `godot/assets/icons/`. The R7 "code pins UNMOVED" claim verified at test level: `test_card_icons.py` reads `levelup.gd` but extracts ONLY the `PASSIVES` block (`const PASSIVES := [ … ]` non-greedy), the weapons.gd META table, and the `"kind": "bonus"` dict — LIMIT_CARDS as a separate const cannot enter; `len(rows) == 32` (`:138`) stays 32 ✓. screens.gd leaves T-M4l's set ✓. |
| **P3-6** F-5 premise | **LANDED — RE-MEASURED** | PIL full-frame grayscale means on the committed 1024² tiles THIS session at 60d9811: grass **29.97**, desert **34.68**, snow **31.04**, tundra **34.34** — the spec's 30.0 / 34.7 / 31.0 / 34.3 reproduce at 0.1 precision; desert is the brightest of four; all inside the 26–36 envelope; `assets/biomes/superseded-v1/` precedent dir present. |
| **P4-1** cites | **LANDED (PARTIAL, both rebuttals STAND)** | Fixed cites verified: cap early-return `world.gd:249-250` ✓, rate term `:259` ✓, pick `:260-263` ✓, slice law `test_biome_numbers.py:38-39` (the `const BIOMES`/`static func biome_at` index pair — exact) ✓. REBUTTAL 1 VERIFIED MINESELF: `grep -n "5\. \*\*+2 minibosses" docs/PARITY-ROADMAP.md` ⇒ **241** — c1's ":240" was wrong (`:240` is item 4's ACCEPT line) ⇒ spec cite stands. REBUTTAL 2 VERIFIED: `static func build_pool` is `levelup.gd:32`, `:31` blank ⇒ spec's `:32-67` stands. (Residual drift in the SAME header parenthetical: F-5.) |
| **P4-2** spawn stamp | **LANDED, re-derived** | `cycle_minute` at t=900 cycle-0 = 15 ⇒ `roundf(50000·(1+0.22·15)·hp_cyc(0))` = 50000×4.3 = **215 000** exactly; ramp `:200-201` + `minf` CAP `:201` (18× def — vacuous at 4.3) ✓. |
| **P4-3** phantom pins | **LANDED** | R8 rewritten; my own grep of `tests/`: ZERO pins read the three stat-expression BODIES (closest: `test_endless.py:115-118` contact-site regex, `main.gd` only — T-M4l never touches it ✓ survives); the named STAY probe matches the real regex text ✓. |
| **P4-4** A-E5 wording | **LANDED IN TEXT — BUT THE LANDED CLAIM IS FALSE AS WRITTEN (F-1)** | The wording "through t=720 and to run-end" is present; its validity was argued from the minute-11 surge-inertness alone, which does not survive the pillar's own CONE (PASS 2 A1). |

**Adoption tally: 14/14 landed; the "13 of 14 adopted, 1 partial, 0 rejected" arithmetic in the
header/§13 is internally consistent (13 ADOPTED cells + the disclosed P4-1 PARTIAL). Rebuttals:
2/2 stand. One landed row carries a new defect: P4-4 ⇒ F-1.**

## 2. PASS 2 — New-material attacks (REV-2 delta)

### A1 — THE FOLD COLLISION: P4-4's digest extension × §1.1's live cone (F-1, P2)

A-E5 now claims: twin runs (event window vs the same run pre-window) "digest the RNG stream
identically through t=720 and to run-end", channel "the `dwell_zero_rng` idiom". The shipped idiom
works (`sim_stages.gd:427-428`: `str(dwell)==str(no_plate)`) for exactly ONE reason the events pillar
does not share: the plate dwell is SURGE-only — it never touches spawn geometry, so at the clamp the
twins spawn the same counts at the same stream positions with the SAME angles. The event window
carries a CONE: inside [660,720) the same consumed `randf` value lands at `135°+x·90°`, not `x·360°`
— spawn GEOMETRY diverges by design from 660.017. Horde geometry divergence ⇒ weapon intercept timing
diverges ⇒ the kill-time rolls consume the global stream at different counts per twin (gem `randf`
`world.gd:349`, coin `randf` `:351`, chest `randf` `:363`) ⇒ after the first differential kill (near-
certain inside a 12/s window over a 60 s span) every later draw sits at a different stream position —
the twin digests fork INSIDE the window on CORRECT code. "To run-end" is therefore unsatisfiable under
any twin/idiom the row names; and the planted `randi()` red's signature ("digests fork at 660 while
rates stay identical") is indistinguishable from the cone's own legitimate divergence on the same
digest. The surge-inertness that P4-4's fix leaned on (`minute 11 ⇒ base ≥ 15.3 ⇒ both twins 12/s`)
equalizes spawn COUNTS only — it is exactly the quantity c1 checked and the only one the cone defeats.
This is the M3-c2 F-1 class precisely: two independently-true rows (the P4-4 fold; the §1.1 cone
design c1's A2/A4 upheld) meeting on one row of the spec.
**Fix (exact):** scope the digest twin to the geometry-inert leg the idiom needs — pin the leg's cone
to the `[0.0, TAU]` identity (which is the row's actual subject: "the cone DEFAULT is the IEEE
identity", and the identity path is what threatens every byte corpus) or run the shipped
clear-at-window-start hp-pinned `_plate_window` shape — and keep the whole-run comparison on THAT leg;
the live-cone geometry claim stays A-E3's (`cone_share`), which is position-based and unaffected.
One clause in the A-E5 observable cell.

### A2 — A-E4 three legs (holds, one observable tail F-4)

Mechanism and cap legs re-derive exact (§1 P1-2). Saturation GREEN holds: both twins stay under
ALIVE_CAP (event twin ≈ 360 spawns over 30 s from a cleared window start). The saturation RED cell
quotes "22.80–24.10/s" — that is the instantaneous rate term, not an observable over the full 30 s:
the planted-outside-minf twin demands ≈ 684 spawns and hits ALIVE_CAP at ≈ t≈497 (the early-return
then accumulates NOTHING, `world.gd:249-251`), so the WINDOW-MEAN observable clamps to ≈ (400 +
refills)/30 s. The red still fires on any ≤12.0/s check, and the printed figures are observable in a
pre-cap sub-window (the shipped windows clear at start, so ~17 s at 22.8–24.1/s IS measurable) — but
the leg must NAME which it measures. F-4 (P4).

### A3 — B-E6 crash-as-instrument (executable; instrument mis-named)

The planted red ("remove the guard ⇒ the boss roll reads `CHEST_TIER_BY_SOURCE["the-reaper"]` ⇒
null-key crash errors the leg") is EXECUTABLE, and it does NOT pollute other legs: the sim dumps are
committed artifacts judged by pytest, and conftest's own seam (`assert rows, "row %r missing"`) reddens
a missing/aborted row cleanly; a planted mutation is byte-exact-restored by law. But the repo's OWN
recorded map-bypass red was never a crash observation — it was observed by VALUE-COMPARE + source
regex (`sim_chest_tiers.gd:20-24` "the check compares the DUMPED map value"; `test_chests_tiers.py:144-158`
keyed-site regexes), and the "a bypassed source crashes at the drop" line (`world.gd:358`) is a law
COMMENT this repo has never executed as a red. Godot 4's missing-key `dict[k]` is a soft error: the
engine reports it and evaluation continues with null ⇒ the mutant run may APPEND a null-tier chest
row rather than abort. Either way B-E6 goes red — via its own zero-delta expectation (a phantom
chests-array entry violates "ZERO new entries") or via the abort surfacing as a missing row — but the
row should NAME THE ARRAY-DELTA CHECK as the instrument and stop asserting the unexecuted crash law
(the green leg's first run then becomes the repo's first EXECUTED evidence for `world.gd:358`'s claim —
say that instead). F-3 (P4). No pollution risk: the delta check makes the red observable without the
crash, and the crash path stays contained to the leg's own dump.

### A4 — §2.1 outrun-claim × T-M4l LIMIT·HASTE (F-2, P3) — fold-collision #2, narrower reach

"spd 200 > BASE_SPEED 140 + every measured haste build at the 5-stack cap (140·1.4 = 196) — the
pursuer CANNOT be outrun forever, OUR pin, checked by test" (`game_state.gd:5,80-81`: 140·(1+0.08·5)
= 196 < 200 ✓ at the caps). The same milestone's §3.1 ships `LIMIT · HASTE` "+3% move speed …
repeatable FOREVER" at the `player_speed()` seam: 140·1.4·(1+0.03·m) exceeds 200 at m ≥ 2. §9's hedge
("Limit-break deep growth: ENDLESS-ONLY reachable") does NOT cover it — the reaper by §2.1's own design
runs with endless OFF and never ends, so a reaper-ON run past pool exhaustion is exactly the state
where live reapers and uncapped haste coexist. And no ACCEPT row checks outrun-ability (the "checked
by test" refers to no named row). Fix: one qualifying clause in §2.1 (scope the claim to the 5-stack
era, or state that multi-reaper pressure + the 215 000 stamp, not the speed delta, is the end-law
against deep-limit builds) and de-hedge §9 ("never reachable inside a flag-OFF 900 s run"). P3.

### A5 — Fold candidates checked and CLEARING (record, so cycle-3 need not re-litigate)

(a) drop-guard × B-E6: consistent scoping — the guard is the GREEN law, the crash is the PLANTED
absence; same death site, no contradiction. (b) R9's literal × B-E1's STAY rows: `:114-118`/`:130-135`
regexes read disjoint line-spans of `main.gd`; the reaper contact-check insertion keeps the
raw→damage_taken adjacency the contact pin requires. (c) saturation leg [480,510] × plates rows
([30,60]/[380,440]/[540,600]): windows disjoint; the stages-m3 rows live in a different file and F-9
keeps sim_stages unlegged; saturation lands in `events-m4`. (d) A-E1 × R9: fixture scope vs test-file
scope — no overlap. (e) reaper hand-in × `handin` row: the row dumps only stage strings ✓. (f) the
new STAGES `events` field × the existing table pins: `test_stages.py:79-97` asserts FIELD-WISE
(`stages[i]["bosses"] == …`), never dict-equality ⇒ stage-1's `events: []` passes the STAY pins; the
stage-2/3 bosses lines `:81-82` are exactly R1's movers, stage-1's `:79-80` genuinely stays.
(g) `test_card_icons.py` cannot read LIMIT_CARDS (§1 P3-5). (h) T-M4r after the T-M4e fixture re-mint:
flag-off paths consume zero RNG ⇒ the re-minted stages-m3 rows survive T-M4r unchanged ✓.

### A6 — The c1-verified core (spot re-checks, PASS 3)

SEL-A: roadmap `:63-66` re-grepped verbatim, "M4 → v2.1.0" intact, §M4 `:315-331` still names the two
deferred surfaces, the 11+6 pricing at `:328-331` ✓. Byte law: class-1 fixture list = exactly the 9
committed files; three classes unchanged from c1's PASS ✓. Wave map: `sim_budget.gd` in T-M4r ✓,
mesh coupling named in both consumers ✓, serial spine covers the `tools/s8_acceptance.py` T-M4r↔T-M4l
sharing (both file sets list it; order declared) ✓. s8_acceptance: `row(` count 10 (R6's "10 rows") ✓,
planted kind-flip control header `:5-8` ✓. `sim_funnel.gd:34,45-47` fresh_run carries a `flags` dict ⇒
B-E4's "both keys" is real. `sim_headless.gd:30` TOTAL_STEPS 37200 = 620 s stage-1 window — the journey
invisibility of events/reaper/win-fork survives ✓. `VS-FEATURES:423` Reaper quote verbatim ✓.
tracked rows T-M4c/T-M4p/T-M4k/T-M2c/roster/unlock-store named with cards ✓. ACCEPT count: 7+6+4+3 =
20 = §13's figure ✓ (the c1 brief-noise row resolved).

## 3. Findings register

| id | sev | one-liner | fix |
|---|---|---|---|
| F-1 | **P2** | A-E5's "digest identically through t=720 and to run-end" (the P4-4 fold) cannot go GREEN as written: the live cone mutates spawn geometry inside the window, kill-time rolls then diverge the stream ⇒ digests fork on CORRECT code; the planted-`randi` red is masked by the same legitimate divergence. The `dwell_zero_rng` idiom the row names is valid ONLY because the plate dwell never touched geometry. (P4-4-fold × §1.1-cone: the M3-c2 F-1 class.) | §1.4 A-E5: run the digest twin with the leg's cone PINNED TO THE `[0.0, TAU]` IDENTITY (the row's own subject — the default-path stream identity is what every byte corpus depends on) or the shipped clear-at-window-start hp-pinned window idiom; keep "to run-end" on that leg; live-cone geometry stays A-E3's `cone_share`. |
| F-2 | P3 | §2.1 "CANNOT be outrun forever … checked by test" vs §3.1's repeatable LIMIT·HASTE (+3%, forever) and §9's "endless-only reachable" hedge — reaper-ON runs never end, so the hedge does not hold the case it must exclude; no ACCEPT row checks outrunning. | one clause each in §2.1 (scope to the 5-stack caps / multi-reaper pressure is the end-law) and §9 ("never inside a flag-OFF 900 s run"). |
| F-3 | P4 | B-E6's red names "null-key crash errors the leg — the shipped strict-map law as the instrument", but the repo's executed map-bypass red was value-compare+regex (`sim_chest_tiers.gd:20-24`, `test_chests_tiers.py:144-158`); `world.gd:358`'s crash law has never been executed; GDScript's missing-key `[]` is soft-error+null ⇒ the observable may be a phantom chest row, not an abort. | name the leg's own ZERO-DROP-ARRAY check as the primary instrument; present the green leg as the first executed evidence of the `:358` law. |
| F-4 | P4 | A-E4 saturation red quotes 22.80–24.10/s — the instantaneous term; the 30-s WINDOW MEAN clamps at ALIVE_CAP (~17 s to 400 from a cleared start). Red still fires (>12.0/s), printed figure observable only in a pre-cap sub-window. | name the measurement window (sub-window before the cap hit) or state the twin-divergence shape like the shipped `minf_clamps_surge`. |
| F-5 | P4 | REV-2 header cite parenthetical still drifts: latch block ENDS at `:238` (":225-240" spans the plate comments); "flare-decay+plate-surge `:245-250`" — the decay line is `:243`, outside the cited range, which instead re-covers the separately-cited cap return. | two line-number touches in the header. |

**Counts: P1 = 0, P2 = 1, P3 = 1, P4 = 3.**

## 4. What survived (for the record)

All fourteen c1 rows landed with true mechanisms — every adopted claim re-grepped THIS session
(no carry-over): the R9 pin-lawyering is honest (the regex as-written admits the equal-or-stronger
order-pin, same-commit law stated, rejected alternative named); the A-E4 split re-derives exact off
the shipped rate term; the drop-guard keeps every shipped boss row byte-true INCLUDING RNG
consumption; the zero-call-sites claim is literally true; the 17-row partition is EXACT row-for-row
and every PRESERVED window claim survives the new 660 entries (including the non-obvious
`boss_contact_clamp`, whose payload is stream-independent); the inline-icon route survives the real
`test_card_icons.py` at row level; both rebuttals stand; F-5 re-measures to 0.1 precision; the SEL-A
law rows, byte law, wave-map, s8 tables and the journey-invisibility core all survive unchanged
from c1's PASS.

## 5. Reading-of-ambiguity statement

- "13 of the 14 adopted" is read as 13 fully-adopted + 1 disclosed partial (P4-1) + 0 rejected —
  §13's cells support the count; not a finding.
- A-E5's twin is read at the row's LITERAL wording (event window vs pre-window, state/stream digest,
  to run-end). Under a cone-pinned-identity reading the row becomes true — that reading is exactly
  F-1's FIX text; the finding stands for any reading that keeps the cone live in the digest twin.
- §2.1 ":244" / ":139-148" are read as def-line / def-to-assert ranges (the real lines :246/:147
  sit inside them); not findings.
- F-6's "no new damage base exceeds 13" is read as scoped to clamp-REACHABLE bases (the reaper's 30
  never reaches the clamp per F-6 itself) — stated reading, consistent.
- B-E4's planted red ("check reaper before endless in the cap fork") I read as firing through the
  CYCLE-CLEAR expectation (endless arm starved), not through a reaper-spawn row (the world-side
  `not game.endless` gate suppresses spawns in endless) — the leg's green text includes the clear
  rows, so the red is executable; noted, not filed.

## 6. Fix list for cycle 3 (exact sections)

1. **§1.4 A-E5** — F-1 identity-cone (or cleared-window) scoping of the digest twin (the gate's one
   blocking row).
2. **§2.1 + §9** — F-2 outrun-claim qualification + hedge rewrite.
3. **§2.3 B-E6 red cell** — F-3 instrument re-naming.
4. **§1.4 A-E4 saturation cell** — F-4 measurement window named.
5. **Header** — F-5 two line numbers.

Row 1 is the only gate-biter; rows 2-5 ride the same commit. c3 re-checks row 1's scoping text and
the regression it must not reopen (A-E3 keeps the live-cone share check; the byte corpora rows of
§7.1/§7.2 unchanged).

# VERDICT: FIX
