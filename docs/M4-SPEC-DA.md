# M4-SPEC-DA — Devil's-advocate gate, cycle 1 (MC 11338, T-M4d)

- **Target:** `docs/M4-SPEC.md` REV-1 @ `0bf3acd` (spec ships ON TOP of `84671d7` (T-M4x, tools/vm100
  deletions + PERMANENCE rewrites) over the claimed read-base `9a60e40` — `git show --stat 84671d7`
  re-run: it touches **none** of the spec's cited game/test files, so every citation below is judged
  at both SHAs identically; the spec's "read at 9a60e40" base claim survives, the base-vs-ship drift
  excuse does not exist).
- **Method:** every code/doc/fixture citation re-grepped THIS session at `0bf3acd` against the real
  tree (`godot/scripts/`, `godot/sim/`, `tests/`, `tools/`, `docs/`); the A-E4 arithmetic machine-
  re-derived off the shipped rate term (`world.gd:259`); F-5's measured-luma premise measured
  directly (PIL grayscale means on the four committed 1024² tiles — the instrument the claim names).
  All 19 ACCEPT rows sampled (A-E1..7, B-E1..5, C-E1..4, D-E1..3; the brief's "20" count is the
  brief's slip — the spec carries 19).
- **Prior art honoured:** M2 c1 (1 P1 self-contradiction), M3 c1 (P1-1: a source-regex pin vs a
  mechanism change — the fold-collision lesson). The SAME failure class recurs twice here: P1-1 is
  the M3-P1-1 class verbatim, and P2-2 is a second in-document fold collision (a STAY row vs the
  spec's own declared carve). Findings P1..P4; gate rule (spec §12 + fleet law): SHIP only with no
  P1/P2.

## 0. Verdict summary

**FIX.** 2 × P1, 2 × P2, 6 × P3, 4 × P4. The architecture survives — the event-window mechanism,
the SEL-A version call, the reaper-as-END law vs `MAX_CONTACT_DMG`, the byte-law restatement, the
budget and the tracked-row honesty all held against re-grep — but two ACCEPT contracts are false
as written against the spec's OWN tree (the win-branch regex pin dies under the cap fork; the
surge-red can never fire at the pinned window), the reaper's death path drives straight into the
shipped strict-map law the spec protects from change, and A-E1 as written cannot go GREEN on its
own commit. None is reconsideration material; all are same-document fixes. §7 names the edits.

## 1. The ten self-DA rows (spec §12) — statuses with re-grepped evidence

| # | row | status | evidence (re-grepped at 0bf3acd) |
|---|---|---|---|
| 1 | clean-room | **VERIFIED** | `VS-FEATURES.md:378/:423` (Reaper quote, verbatim at both cites), `:421` (wave/300-alive rule verbatim), `:462` (swarm/wall group names — Pipeestrello etc. named, never reused), `~:473` (Limit Break quote incl. the evolve-loss warning the spec §3 cites), S6 `:477`, achievement chains S7 `~:613-624` — all re-read, all exist as quoted. Every shipped number is ours (2.0/660/1500/2100/12/13/50000/200/60/0.04/0.03/−1). |
| 2 | F-1 stage-gating by file:line | **VERIFIED** | Roadmap `:240` item 5 exists (spec cites `:241` — P4-1 drift); the stage-1 `events: []` + window `[660,720]` reading is byte-lawful: `stage1_schedule`/plate legs run t ≤ 540 and the journey is a **stage-1, 620 s** window (`sim_headless.gd:30` TOTAL_STEPS 37200, win "out of this window by design") — events, reaper and the win fork are all invisible to the journey by construction. The cone-default IEEE identity (`0.0 + x ≡ x`) is arithmetically sound; RNG consumption unchanged (the stream draws are `:193` angle + `:263` type only). |
| 3 | version law (§5) | **VERIFIED** | `PARITY-ROADMAP.md:63-66` re-read verbatim: "major = a new player-navigated UI surface (M3 stage select → v2.0.0); … (M1 → v1.2.0, M2 → v1.3.0, **M4 → v2.1.0**)". §M4 `:315-332` names the purchase screen + achievements page (the collision the spec declares); SEL-B/C rejected with measured price (`:328-331`: 11 TRELLIS + 6 retargets — re-read ✓). A1 below steelmans the counter-case; it loses. |
| 4 | reuse-first / monogamy | **PARTIAL** | Events: ONE rate term (`:259`), ONE latch (`:142/:225-237`), ONE `_types_open` (`:179/:260`), ONE chest map untouched — real. Reaper: ONE cap branch (`main.gd:226-240`), ONE flags dict (`save.gd:29`, `main.gd:276` hand-in) — real. **But two undeclared exceptions:** the reaper ARRIVAL trigger (`_spawn_enemy` has ZERO product call sites outside `world.gd` today — a `main.gd` "arrival loop" (§2.2) is a second spawn trigger beside the ONE loop, and §12.4 declares only TWO exceptions, neither this — P3-1); and the `screens.gd` `LIMIT_ICONS` + `icon_path` match-leg duplicates the shipped `_:` catch-all that already resolves any card carrying its own `icon` (the `bonus_card` `"icon": "coin"` precedent) — a second icon mechanism where reuse needed zero code (P3-5). |
| 5 | ACCEPT rows: one seam + firing red | **PARTIAL** | Channels all exist and are right: `SimFunnel.fresh_run(opts)` carries `flags` (`sim_funnel.gd:28-44` — B-E4's "both keys" real), `sim_bosses:90/:133` duck-surface via the `sim_stages.gd:98` `_check` delegator (re-read — F-9 survives, sim_stages AT 578 L, new files ride SimFunnel, delegator untouched), `sim_chest_tiers` drop-map shape, table-pin pattern `test_stages.py:79-97` (real; `:81-82` = the two bosses rows exactly as R1 says), the shop_probe/maxhp formula-row precedent. **Failures: A-E4's red cannot fire (P1-2); A-E1 cannot go green (P2-2); B-E1's STAY claim is false because of the pin P1-1 kills.** |
| 6 | ceilings unbreached | **PARTIAL** | `ALIVE_CAP` return `world.gd:249-250` sits ABOVE `surge` in `minf(12.0,…)` (`:259`) — an event surge inside is structurally capped ✓ (F-4 honest, and the divergence from THEIR `:421` cap-exemption is correctly declared). Zero-cone-RNG ✓ (clock comparison like the plate dwell). "the-reaper … ONLY site is the cap fork": spawn-site claim TRUE as designed. **The miss is the DEATH site, not the spawn site — P2-1.** |
| 7 | byte-stability | **PARTIAL** | §7.1's three classes match the post-MC-11317 law EXACTLY (strict list = the 9 committed fixtures re-listed file-for-file — `ls tests/fixtures/` count-matched; strips modulo `_ms`/`CAPDIR` = the C3 wording; s8 runtime-records-as-contract-checks ✓; journey re-dump included ✓; R6's "10 rows" = the real count, `grep -c '    row('` = 10). Carves (a)/(b)/(c) declared ✓. **But A-E1 contradicts the carves (P2-2) and R2's named-preservation list omits 7 of the 17 stages-m3 rows (P3-3).** |
| 8 | budget re-derived | **VERIFIED** | Arithmetic re-derived: stage 1 27 (no new live class); stage 2 ≤ 28 (+prelate MM); stage 3 ≤ 29 (+acolyte MM on M3's ≤28 — the M3 DA A9 bound); reaper run ≤ 28 (+reaper MM) — all ≤ 40 (`test_art_integration.py:42` DRAWS_PLANNED=40 re-read ✓) ≤ 60. Named counts: 3 (stage-1 403) / 2 (402 after T-M4e, matches shipped `bosses` rows: stage 2/3 carry ONE entry each — `render.gd:116,:121` re-read) ✓. `DRAWS_PLANNED` stays 40 with the same-commit rule restated ✓. |
| 9 | Contract B + persistence | **MISSING** | Snapshot zero-delta ✓ (exact-12 `snapshot_json:194-211` untouched; `reaper`/`limit` outside, endless/cycle/stage pattern `:37-47` ✓; `test_save.py` flags-shape rows re-read — dict unchanged ⇒ STAY real; `VERSION` stays 1 lawful — no new save field, flags-dict reuse ✓). **The row's OWN instrument claim is false: "the frozen `win`-branch regex pin (`test_endless.py:147`) stays byte-true on the flag-off path" — it cannot (P1-1).** |
| 10 | wave-map discipline | **PARTIAL** | Serial spine + pairwise edges verified true (`T-M4e`↔`T-M4r`: world/horde_viz/test_art_integration/sim_budget; `T-M4r`↔`T-M4l`: game_state ✓ named; `T-M4e`/`T-M4l` disjoint ✓); asset batch file-disjoint ✓ (`superseded-v1/` precedent dir EXISTS re-checked); mesh coupling NAMED in the T-M4a row + execution order (the M3 P2-2 lesson mostly applied — but T-M4e's `depends on` column says "—" where T-M4r's names T-M4a — half-absorbed). Deferrals named with the forward surface-version decision ✓; T-M4z carries the GitHub-Release trio as rows ✓. **Misses: P3-4.** |

Tally: **5 verified / 4 partial / 1 missing.**

## 2. Independent attacks

### A1 — VERSION LAW (attack SEL-A, strongest side first)

The strongest case against: the roadmap's OWN §M4 tranche ships the milestone the law priced at a
MAJOR (`:315-332` names player-navigated surfaces), so v2.1.0 is only true because the author cut
the surfaces out — the cut and the version number together do the work the surface law exists to
police; a later "Nightfall 2" with a picker gets its major for free because M4 taught everyone the
trick. This is the whole anti-SEL-A case.

It loses on three re-grepped facts: `:66` literally PRE-COMMITS "M4 → v2.1.0" (the roadmap chose;
the spec cites an owner-ratified artifact, it does not manufacture consent — Rule 2 satisfied);
F-7's four near-misses each verified against shipped code — the hidden-flag channel has the endless
precedent (`main.gd:276`, zero UI since v1.3.0, gated in the M2 DA), the end line rides the SAME
`show_end(win, lines)` panel (`main.gd:342-347` — lines are an array argument, not a new surface),
limit cards ride the frozen `make_offer → _enter_levelup` funnel every reward since M1 rides, and
the tile is a path-swap at a shipped path; the roadmap's landing-note discipline is its own deferral
mechanism (`:243-259`, `:299-303` re-read — both name the NOT-LANDED rows exactly as §5 claims).
Manufacturing v3.0.0 NOW would falsify `:66` with no owner artifact — the heavier Rule-2 move.
SEL-A stands. **No severity.** (M3 DA's A1 precedent holds a second time.)

### A2 — BYTE CORPUS vs THE SPEC'S OWN CARVES (fold collision #2)

§7.1 class 1 = "ALL files under tests/fixtures/" strict-`cmp`, and it lists `stages-m3` (carve (a))
and `art-s2i-probe` (carve (b)) INSIDE that class. A-E1 then demands "the strict corpus (§7.1: every
committed fixture file + the journey re-dump) byte-identical on the T-M4e tree" — the tree on which
R2 re-mints stages-m3 and R4 grows art-s2i-probe, in that same commit. As written A-E1 cannot go
green on its own commit; a builder who "fixes" the cmp failure by re-minting-then-comparing re-opens
exactly the M3 P2-3 circularity it was written to close. Also machine-checked the R2 remint scope:
`stages-m3.jsonl` is **17 rows** (ev-names enumerated); R2's moving set is right (stage2/3_schedule,
plates_cap named count, verdict) and its named-preservation list covers only 6 of the remaining 11 —
the 7 unnamed (`stages_table`, `plates_flare`, `draw_tally`, `unlock_chain`, `handin`,
`snapshot_m3`, `boss_contact_clamp`) all RE-VERIFIED byte-safe (`draw_tally` counts `_pvz.draw_count()`
— pickup MMs only, enemy-class MMs are horde_viz's; `boss_contact_clamp` iterates a hardcoded
`[12.0,13.0,14.0]` list — the reaper's dmg 30 cannot enter it) — but the re-mint asserts the named
set, and a named list is a contract. Journey: 620 s stage-1 window ⇒ events/reaper/win-fork all
invisible ✓ (the strongest byte-claim in the spec, and it is true).

### A3 — REAPER vs SHIPPED MACHINERY

End-not-damage (F-6) survives the `MAX_CONTACT_DMG` attack: the reaper check ends the run before
the clamped read (`main.gd:219`), the clamp table cannot gain a row (bases 12/13/14 hardcoded in
the leg; reaper never damages) ✓. Endless-precedence is real (`main.gd:233` endless-first; B-E4
planted check-order red fires ✓). Speed pin honest: `BASE_SPEED 140` (`game_state.gd:5`) × max
haste 5×0.08 = 196 < 200 ✓; the spawned dict copies `def.spd` so the B-E3 "spd pinned 1.0" leg is
feasible by the shipped `sim_bosses:127-128` mutate-the-row idiom ✓. Contact radius: `55.0 if e.boss`
(`main.gd:211`) — the `boss: true` claim checks out ✓. **The kill path is the hole:** `kill_enemy`'s
boss branch (`:363-365`) is a STRICT map lookup the file itself declares "a bypassed source CRASHES
at the drop, never silently de-tiered"; `the-reaper` ships `boss: true` with NO map row, and §7.2's
STAY list forbids the map from gaining rows (SPEC_MAP exact-equality, `test_chests_tiers.py:109/:142`
— the M3 P2-1 law). A reaper death (reachable in DECLARED-PIN legs; in play ~unkillable but that
is a reading, not a mechanism) walks straight into it. The spec never mentions the death site —
its F-2/§11 tail argues about spawn and contact only. **P2-1.**

### A4 — A-E4 MECHANISM LEG (machine re-derivation; the strongest finding)

Shipped rate term: `world.gd:259` `spawn_acc += minf(12.0, (1.0 + 1.3*minute) * qty_cyc * surge) * dt`
with `minute = game.time/60` continuous (`cycle_minute:61`, returns float — the byte comment says
"m_c = game.time/60" verbatim). At the leg's DECLARED-PIN window [180,210] the factor is 4.90–5.55,
×2.0 = **9.80–11.10 ≤ 12 — inside and outside `minf` are the SAME number**. The planted red ("plant
the surge OUTSIDE `minf` ⇒ 22.2/s") is unreachable there: outside-minf yields 22.2/s only where the
base is 11.1 (t≈507.7), i.e. inside the clamp-bound region — the author computed the red at a
minute-8.5 window and wrote the pin at minute 3. And the two expectations are mutually exclusive in
ONE leg: ratio==2.0 requires `base·2 ≤ 12` (uncapped ⇒ outside==inside ⇒ no red), while any red
requires `base·2 > 12` (capped ⇒ ratio < 2). The M3 precedent the row itself cites
(`minf_clamps_surge`, "same-position twins at the minute-9 clamp") got it right — a
clamp-bound leg. Fleet law "a check that has never failed is not a check": this gate cannot go RED
as written. **P1-2.** (The cap leg is TRUE as stated — minute-11 base ≥ 15.3 caps with or without
the surge — and is also WHY A-E5's digest-identity twin holds: the event surge is rate-inert at
minute 11, spawn counts identical, stream identical. The window placement was deliberate; only the
mechanism leg's pin is wrong.)

### A5 — LIMIT-BREAK vs THE GOLD/BONUS LAW + the icon law

Fallback placement verified feasible: `make_offer` builds pool → `match kind` ("gold" sets `pool=[]`
→ the untouched `bonus_card` fill at `:92`-ish) → shuffle → fill — inserting `if kind == "" and
pool.is_empty(): pool = LIMIT_CARDS` after the match leaves the gold path byte-identical; the two
committed bonus rows (`chests-tiers-m2`, `chests-evolve-m1e`; the caps fixture carries ZERO bonus
rows — grep-consistent with C-E4's claim) are the living probe ✓; `PASSIVES`↔`PASSIVE_ICONS`
key-set pin (`test_card_icons.py`) cannot read LIMIT_CARDS as a separate const ✓; `apply_offer`'s
`_:` catch-all (gold+heal) is correctly pre-empted by a named `"limit"` branch (and C-E3's planted
zero-identity twin would catch a forgotten branch). The three stat seams are the shipped partner
pattern verbatim (`+0.04·dmg` like gall's `+0.08`; `×(1+0.03·spd)` inside `player_speed`; `-1.0·arm`
inside the existing `maxf(0.0, …)` — Bulwark≥0 checked ✓). The exhaustion state is constructible by
the shipped `sim_budget._pin_worst_case` construction channel ✓. **The crack is icons:** the
resolver's `_:` arm ALREADY resolves any card carrying its own `icon` field (weapons, upgrades,
bonus all ride it); LIMIT_CARDS — static rows like `bonus_card` — need only `icon: "<shipped file>"`
and screens.gd is NOT touched: the proposed `LIMIT_ICONS` + new match-leg is a SECOND mechanism
beside the one that answers the question (fleet's named #1 defect), it drags screens.gd + R7's
screens half + a §j re-pin along for zero observable, and it slightly erodes F-7's "no screens.gd
touch" story the version decision leans on. **P3-5.** (A7's `s8_acceptance.py:238` "all 32 pool
kinds" line-text falsification is the separate P3-2.)

### A6 — WAVE MAP vs REAL FILE SETS

Pairwise edges re-verified true (row 10 above). `T-M4a` parallel-safety holds against the spine's
file lists. **Two misses:** (a) B-E5's `budget_reaper` leg lands in `sim_budget.gd`, which appears
in NO T-M4r row (only in T-M4e's) — a named-leg file missing from the card that must close it, the
M3 P2-1 class; (b) T-M4e's `depends on` column is "—" while its GLB_FILES +2 coverage re-pin
(`test_art_integration.py` file-exists loop re-read) requires T-M4a's two event-miniboss meshes —
the coupling IS declared in T-M4a's row and the execution-order paragraph, but T-M4r's row names
its mesh dependency in the column and T-M4e's does not (the M3 P2-2 asymmetry, half-absorbed).
**P3-4.** R8's predicted re-grep found nothing to retire: no test today reads the three stat
expressions verbatim (the closest pins are `test_biome_numbers.py:83` BASE_SPEED const value and
the two `game.hp -= game.damage_taken(raw)` call-site regexes — all survive T-M4l untouched) — the
row over-defends; stated as P4-3, harmless.

### A7 — BYTE-LAW POST-MC-11317 (restatement check)

Class 1 = committed fixtures (9 files — listed file-for-file, count-matched) + fresh journey
re-dump ✓; class 2 strips modulo `_ms`/`CAPDIR` = the C3 norm ✓; class 3 s8 gameover/win as
contract-checks with the planted kind-flip control (`s8_acceptance.py:7`) kept as law ✓; the
three NEW fixtures generate-twice-cmp + forward-lock-for-M5-only ✓ (the M3 A-E1 circularity fix
properly inherited — this restatement is the spec's strongest byte-law text since M3's fix cycle).
F-5's measured premise did NOT survive: the tile means at base are 30.0 / 34.7 / 31.0 / 34.3
(grayscale, full-frame) — not "an identical mean-luma band 30.5–31.1 across all four": the desert
is the BRIGHTEST tile, 4.7 luma above moorland. (Desert unchanged since T-S15's own `1bc13cc`
sharpen pass, so the quoted band is not stale-by-move — it mis-measures the committed set, or names
an undisclosed crop.) The §4 contract itself (wrap-diff ≤ 1.6×, mean 26–36, 8-band delta ≤ 8 —
re-read, all four tiles sit inside 26–36) still holds and the hue reading is unfalsified by a gray
ruler — but the "identical band erased the identity" premise must be re-derived or restated. **P3-6.**

### A8 — TRACKED-ROW HONESTY

`T-M3e-EVENTWAVE` consumption real (roadmap `:299-303` landing note names it verbatim as the M3
NOT-LANDED card); `T-M2r-REAPER` consumption real (`:249` M2-note deferral + gap row 6 "Reaper
analogue DEFERRED (T-M2r-REAPER)" re-read). Gap rows 5/6/10 exist and their CURRENT cells move as
the doc-sync row says (row 10's achievements-PAGE cell re-read ✓). Deferred M4 items 1/2/4 named
with cards and the forward surface-version decision ✓; pre-existing deferrals re-named ✓. Retired-
claim discipline stated as grep-to-zero on the two consumed names ✓. **No finding** (the A7 P3-2
line-text is the only un-retired claim the sweep misses; §6's doc-sync list does not name it).

### A9 — BUDGET

Row 8 verified; additionally the §9 "reapers above the named-count guard BY DESIGN" claim is
consistent with the shipped idiom (scheduled once-each spawns already sit above the guard via the
pre-cap latch, 403/402 readings) — NOT the F-4 cap-bypass their-side shape, correctly distinguished.
"Limit-break deep growth … pool cannot exhaust before ~54 picks" — re-derived: 6 weapons × (1+7) +
6 kinds × 5 = 48 + 30 = 78 picks at the caps before exhaustion (the spec's "~54" is the pessimistic
reachable path; the claim direction — never in a committed dump — is what matters and holds under
every reading). **No finding.**

### A10 — REAPER MECHANICS MISC (placement + hand-in)

Hand-in pattern verified (`main.gd:270-283`: after `start_run`, endless pattern verbatim); `game_state`
resets at `:135-138` ✓; end screen lines are a display array into `show_end` and the JS payload
fields are unchanged ✓ ("The Reaper took you at %s" prepends cleanly); B-E2's `(900,930)` window
checked against the spawn ring (≈ view/2+40 ≈ 1000 px @ 200 px/s ≈ 5 s) ✓. The arrival-law PLACEMENT
is the residue: §2.1 puts the latch int on `GameWorld` ("beside `schedule_spawned`", reset in
`world.reset()`) while §2.2 puts the "arrival loop" in `main.gd` — two files, one mechanism, cap-
interaction undetermined (B-E5/§9's above-guard reading needs a pre-cap position or an independent
call). **P3-1.**

## 3. Findings register

| id | sev | one-liner | where to fix |
|---|---|---|---|
| P1-1 | **P1** | §2.1's cap fork + §2.1/§7.2-STAY/§12.9's claim "`test_endless.py:147` stays byte-true" are mutually false: `:140-147` regex-pins the flag-off leg VERBATIM as `else:` → `_end_run("win")` → `return`, and the reaper inner fork must land INSIDE that literal (any shape — `if game.reaper:`, `elif not`, guarded-call — breaks the adjacency). No retire row exists in R1-R8. The build spine as specified cannot keep the suite green. The M3 P1-1 class, same document lineage. | Add **R9** (replace-not-delete, same commit as T-M4r): `test_endless.py:139-148` retires to a re-pinned regex matching the FORKED leg (flag-off bytes: `_end_run("win")`+`return` still verbatim inside the reaper-guard) + the runtime A-E1 leg as the equal-or-stronger replacement; strike "test_endless byte laws STAY" from §7.2's STAY list (the OTHER endless laws — :114-118 contact pin, :244 win leg — do survive untouched; name which law moved). |
| P1-2 | **P1** | A-E4's mechanism leg cannot go RED as written: at the pinned [180,210] (continuous minute 3.0–3.5, base 4.90–5.55) surge-inside and surge-outside `minf(12,…)` are the SAME 9.80–11.10/s; the "22.2/s" red needs base 11.1 (t≈508, clamp-bound) — and ratio==2.0 (uncapped) and cap-violation (clamped) are mutually exclusive in one leg. Fleet red-proven law violated on Pillar A's load-bearing mechanism row. | §1.4 A-E4: split into TWO legs mirroring the shipped `minf_clamps_surge` precedent: ratio-leg at [180,210] (ratio 2.0, NO planted cap-red) + clamp-leg at the minute-9 clamp (≈[480,540]: green 12.0/s, planted-outside red ≈ 21.5–24.0/s, named check `surge_capped`); fix the "22.2" number to the measured planted value. |
| P2-1 | **P2** | `the-reaper` ships `boss: true`; `kill_enemy`'s boss branch (`:363-365`) is the shipped STRICT keyed lookup ("a bypassed source crashes at the drop") with `CHEST_TIER_BY_SOURCE["the-reaper"]` missing, and §7.2 STAY protects the 7-row map + `test_chests_tiers.py:109/:142` SPEC_MAP exact-equality from ANY added row. Reaper death = crash-or-lost-chest at a site the spec forbids touching; "unkillable" is a reading with no leg pinning it (DECLARED-PIN legs can create killable reapers). | §2.1: declare the death site — preferred: the drop-site gains the named `reaper`-guard (exception #3, named in §12.4's exception list, mirroring the contact-check exception; + a B-E leg "reaper death drops NO chest and errors none"); alternative: retire-and-replace R10 = SPEC_MAP + "the-reaper" row (then §7.2's STAY list and test_chests_tiers move too — pick one, name it). |
| P2-2 | **P2** | A-E1 is self-falsifying: it demands the STRICT corpus — "every committed fixture file" per §7.1 class 1, which LISTED `stages-m3` (carve a) and `art-s2i-probe` (carve b) — byte-identical on the very T-M4e tree whose R2/R4 re-mint/grow them. Green-when-true fails on its own commit; the likely builder "fix" re-opens M3's P2-3 circularity (compare-vs-self-mint). | §1.4 A-E1: scope to "the strict corpus MINUS the two carve files, whose non-moved rows' byte-preservation is asserted INSIDE R2/R4; the unmoved corpus (endless/gems/unions/chests×2/caps/framesiff) + the journey re-dump are the leak instrument" (the M3 P2-3 fix wording, which the spec already adopted elsewhere). |
| P3-1 | P3 | Reaper arrival-law placement contradicts itself across sections: §2.1 "second latch BESIDE `schedule_spawned`" + `reaper_spawned` on `GameWorld`/`world.reset()` vs §2.2 "`main.gd` … arrival loop"; `_spawn_enemy` has zero product call sites outside `world.gd` today, so the main-side shape is a second spawn trigger beside the ONE loop — an UNdeclared exception (§12.4 names only two), and the cap interaction (B-E5/§9 above-guard BY DESIGN) is placement-determined. | §2.1+§2.2: land the arrival check INSIDE `world.update_spawns` beside the schedule latch, ABOVE the cap return (keeps the ONE-loop law literally AND the declared above-guard), OR name the main-side site as exception #3 in §12.4; one sentence either way. |
| P3-2 | P3 | `s8_acceptance.py:238` (A7) line-text "all **32 pool kinds** (16 weapons + 15 passives + 1 bonus)" falsifies at T-M4l (35 kinds); the gate survives (it runs `test_card_icons.py` rc + 3 shot files) but the CLAIM text is a retired claim the fleet doc-truth doctrine requires rewritten — R7 names only `test_card_icons.py`, and §6's doc-sync list omits tools/. | R7's row: add "the A7 line-text in `tools/s8_acceptance.py` retires in the same commit (32→35 kinds, LIMIT rows named)"; §6 doc-sync list: add `tools/s8_acceptance.py` text rows. |
| P3-3 | P3 | R2's named byte-preservation list covers 6 of the 11 non-moved rows of the 17-row `stages-m3.jsonl` (7 unnamed: `stages_table`, `plates_flare`, `draw_tally`, `unlock_chain`, `handin`, `snapshot_m3`, `boss_contact_clamp`) — all RE-VERIFIED byte-safe (pickup-only tally; hardcoded 12/13/14 clamp bases; stage-1-only checks), but the re-mint asserts a NAMED set and the named set is incomplete. | §7.2 R2: complete the named list (all 17 row names partitioned moved/kept), or reword to "every row not named as moved, all 17 ev-names enumerated in the leg". |
| P3-4 | P3 | Wave-map file-set misses: `sim_budget.gd` (B-E5's `budget_reaper` leg) appears in no T-M4r row; T-M4e's `depends on` is "—" though its `GLB_FILES +2` coverage re-pin needs T-M4a's two event-miniboss meshes committed (M3 P2-2 lesson half-absorbed: T-M4r names its mesh row, T-M4e doesn't). | §6: T-M4r files += `sim_budget.gd`; T-M4e `depends on` += `T-M4a (2 event-miniboss mesh rows)`. |
| P3-5 | P3 | `LIMIT_ICONS` + an `icon_path` match-leg is a SECOND icon mechanism beside the shipped `_:` catch-all, which already resolves any card carrying its own `icon` (the `bonus_card` `"icon": "coin"` precedent; weapons ride it). LIMIT_CARDS rows are static rows — carrying `icon:` inline needs ZERO screens.gd code, keeps §j's assert-per-kind law through the existing path, shrinks T-M4l's file set and R7's screens half, and keeps screens.gd OUT of the milestone the version argument says ships no surface-adjacent edits. | §3.1/§3.2 + §6 (T-M4l files) + R7: either adopt the inline-icon route (preferred) or keep the mapping and add it to §12.4's declared-exception list with the reason it beats the catch-all. |
| P3-6 | P3 | F-5's measured premise is contradicted at base by the instrument it names: committed tile means (grayscale, full-frame) = grass 30.0, desert **34.7**, snow 31.0, tundra 34.3 — not "30.5–31.1 across all four" (desert is the brightest tile; desert unchanged since T-S15's own `1bc13cc`, so this mis-measures, not stale-by-move). The §4 contract envelope (26–36 etc.) survives (all four inside it) and the hue claim is gray-unfalsifiable — the card stands, the premise sentence does not. | §0 F-5: re-derive the sentence (name the crop/instrument or restate as measured at base: "the v2 set is flattened to within ~5 luma, desert the brightest"; the NAME-vs-warmth motivation rides hue, say so). |
| P4-1 | P4 | citation drift (names all resolve; cluster off-by-N): cap early-return ":251-253" → `:249-250`; rate term ":262" → `:259`; pick ":263-266" → `:260-263`; roadmap M2 item 5 ":241" → `:240`; `build_pool :32-67` → `:31-67`; `test_biome_numbers ":41-45"` → ~`:39-43`. The header says "every dependency claim re-grepped HERE" — these six say otherwise (small). | Code-truth header cluster + §0 F-1 + §3.1 + §7.2 R1-adjacent cites; one re-grep pass. |
| P4-2 | P4 | §2.1's "unkillable within the night — no dps ceiling … kills 50 000" reads the DEF hp; spawn hp rides the shipped per-minute ramp (`:200-201`, hp_cyc(0)=1.0) ≈ **215 000 at t=900**, so the claim is stronger than stated but mis-derived — M3 DA's own P4-2 lesson (def-value ≠ spawn-value) not applied. | §2.1 enemy-row bullet: quote the spawn-time value (50 000 × 4.3 = 215 000 at first arrival) + the ramp line ref. |
| P4-3 | P4 | R8 retires a pin class that does not exist (no test reads the three stat expressions verbatim today; the real neighbours — BASE_SPEED const `:83`, the two `game.hp -= game.damage_taken(raw)` call regexes — all survive T-M4l). Over-defence, harmless; state it or point R8 at the real call-site pins' "untouched" STAY. | §7.2 R8 + the STAY paragraph (name the call-site regexes as STAY probes). |
| P4-4 | P4 | A-E5's green wording is weaker than its red: "digest identically THROUGH t=660" is trivially true (events exist only ≥660); the non-trivial true claim is identity THROUGH 720+ (the minute-11 surge is rate-inert ⇒ identical spawn counts ⇒ identical stream) — and that is exactly what catches the planted cone-`randi` at 660. | §1.4 A-E5: one phrase ("…identically through t=720 and to run-end"); the mechanism itself VERIFIED sound. |

**Counts: P1 = 2, P2 = 2, P3 = 6, P4 = 4.**

## 4. What survived the attack (for the record)

SEL-A ⇒ v2.1.0 is the roadmap's own pre-committed verdict (`:66` re-read) and F-7's four
no-new-surface claims each verify against shipped code; the event-window mechanism is a true
composite of the ONE rate term, ONE latch, ONE type set and the untouched cap (F-4's declared
divergence from THEIRS is honest); the minute-11 window placement is deliberately byte-lawful —
the surge is rate-inert there, which is what makes A-E5's zero-RNG twin TRUE and the stages-m3
pre-540 legs provably safe; the reaper-as-END survives the `MAX_CONTACT_DMG` law and the
endless-precedence branch is real; §7.1's byte law is the post-MC-11317 norm EXACTLY (fixture list
count-matched file-for-file, strips modulo clause, s8 contract-checks, journey re-dump) and the
journey's 620-s stage-1 window makes the biggest byte claims true BY CONSTRUCTION; R6's "10 rows"
is the real count; the budget holds with margin and `DRAWS_PLANNED` stays 40; the tracked-row
ledger is honest both ways (consumed names verified in the landing notes; every deferred item named
with a card); the asset batch is file-disjoint with the mesh coupling declared; the C-pillar's gold
path is byte-safe by placement and the exhaustion-state is constructible on the shipped
construction channel; and the `sim_stages`-not-grown pledge + `_check`-delegator survival (F-9)
verified line-exact (578 L, delegator at `:98`, duck-sites `sim_bosses:90/:133`).

## 5. Strongest finding, one line

The spec promises the frozen win-branch regex (`test_endless.py:140-147`) stays byte-true while
its own §2.1 inserts the reaper fork INSIDE the literal that regex pins verbatim — and no retire
row covers it, so the serial spine's first reaper commit cannot close green (P1-1; with the inert
A-E4 red, P1-2, the spec's two flagship executability promises both fail as written).

## 6. Reading-of-ambiguity statement

The spec's stated readings (F-1…F-9) were each checked against roadmap + code and none compelled a
different reading EXCEPT where the document contradicts itself (P1-1, P2-1, P2-2, P3-1). The
"20 ACCEPT rows" figure in the dispatch brief overcounts the spec's 19 — recorded as brief noise,
not a spec finding. `C-E5` in F-6 is M3's row-id, explicitly attributed ("the clamp-bind table M3
shipped") — read as a cross-milestone reference, not a phantom M4 row. Where the spec says "re-grep
at card time" (R8, tile-gate-if-absent) I treated the declaration as the contract and verified the
if-absent leg at base (`tools/tile_gate.py` ABSENT confirmed — the §4 fallback is real, and the
card lands the gate + planted red honestly).

## 7. Fix list for cycle 2 (exact sections)

1. **§7.2 + §2.1 + §12.9** — P1-1: add R9 (test_endless win-branch regex retire-and-replace,
   same-commit, re-pinned to the forked shape) and correct the STAY claims it falsifies.
2. **§1.4 A-E4** — P1-2: split the mechanism leg (ratio-leg uncapped, no red; clamp-leg at the
   minute-9 clamp with the 24.0/s-class red); fix the 22.2 figure.
3. **§2.1 + §12.4 + (B-E leg)** — P2-1: declare the reaper DEATH site (drop-guard exception or
   SPEC_MAP retire — pick and name).
4. **§1.4 A-E1** — P2-2: scope to the unmoved corpus, carve rows asserted inside R2/R4.
5. **§2.1/§2.2 + §12.4** — P3-1: one placement for the arrival latch (world-side above-cap, or a
   named third exception).
6. **R7 + §6 doc-sync** — P3-2: s8_acceptance A7 line-text into the retire ledger.
7. **R2** — P3-3: complete the 17-row named partition.
8. **§6** — P3-4: T-M4r files += sim_budget.gd; T-M4e depends-on += T-M4a mesh rows.
9. **§3.1/§3.2/§6/R7** — P3-5: inline-icon route (or declare the mapping as an exception).
10. **§0 F-5** — P3-6: re-derive the luma sentence against the committed tiles.
11. **Header + §0 + scattered** — P4-1..P4-4 citation and wording fixes (same commit, author's call).

Rows 1–4 (P1s + P2s) are the gate; after they land as declared lines, c2 can SHIP on re-check.

# VERDICT: FIX
