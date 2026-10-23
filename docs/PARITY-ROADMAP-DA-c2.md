# PARITY-ROADMAP-DA-c2 — adversarial gate cycle 2 over docs/PARITY-ROADMAP.md rev 2 (MC 11203, T-S17c)

- Reviewed target: `docs/PARITY-ROADMAP.md` @ abb4a61 (VERIFIED: `git pull` → already up to date; HEAD = abb4a61).
- Inputs read this session: rev 2 (full), c1 verdict `docs/PARITY-ROADMAP-DA.md` @ 000ba42 (immutable, not edited),
  code/tests truth: `levelup.gd`, `game_state.gd`, `world.gd`, `tests/test_game_numbers.py`,
  `tests/test_biome_numbers.py`, `tests/test_boss_numbers.py`, `tests/test_card_icons.py`,
  `tests/test_art_integration.py`, `docs/VS-FEATURES.md` (S2 ~313), `docs/DESIGN-3D.md` §b (:72),
  `godot/sim/` harness inventory. Method: refutation against the DoD, not the producer's summary.
- c1 verdict was FIX (1 P1 + 6 P2 + 6 P3, ranked 7-edit list). Rev 2 claims full adoption + one rebuttal.

## PASS 1 — ADOPTION AUDIT (7 ranked edits + folded P3s)

| # | c1 ranked edit | State | Rev-2 evidence (section:line) |
|---|---|---|---|
| 1 | Suite-pin references corrected (§2+§4, incl. IDS pin) | LANDED | §4 "Suite pins (corrected per DA c1 E-2)":276–280 names BOTH WIN pins (`test_game_numbers.py:39` + `test_biome_numbers.py:65`) and both BOSS pins (`:35` + `test_boss_numbers.py:64`, stay-green); IDS pin in M1 feature 7 (:170–171). All four locations re-grepped here: accurate (see PASS 2). Completeness of the feature-7 list is attacked separately → NEW P2-A. |
| 2 | Draw plan 33→40 declared divergence + retirement row | LANDED | §2 "Draw plan 33→40 declared as a deliberate divergence":61–64; feature 7 bullet `test_art_integration.py` planned-33 (:42, :144) → planned-40 :175–176; §b note rewrite via spine doc-sync row. DESIGN-3D.md:72 still pins "planned worst case 33, hard cap 60" — the divergence is correctly framed as a future M1-commit action. |
| 3 | Acceptance wording tightened (pixel floors, pinned consts, named observables, B-5 snapshot) | LANDED | Pixel floor ≥ 200 twice: :112–113 (`m1-dawnwell.png`), :144 (`m1-chest.png`) — matches S8 pattern (LEDGER 15 511 px vs 200). `CHEST_CHANCE_BOSS := 1.0` + `CHEST_CHANCE_MINIBOSS := 0.6` pinned :131–132 (code grep = 0 hits: new consts, correctly slated M1; `HEAL_DROP_CHANCE := 0.015` pattern real at world.gd:6). `REFUND_FEE_PCT := 5` (floor division) pinned :102 with refund-leg assert :111. "Fail loudly" replaced by named observables (`SAVE_LOAD_FAIL path=...` stderr + quarantine rename, both sides) :90–93. B-5: power-up effects restricted to snapshot-exposed stats + `HD3D_OUT` dump-probe rows :103–110 — snapshot really is the 12-field shape (game_state.gd:87–104 re-read). |
| 4 | Spine doc-sync row | LANDED | :50–55: same-release-commit rewrite of README.md:12–14 + DESIGN-3D §b/§d, grep-zero retired-claim rule stated. |
| 5 | Persistence own deliverable + declared format; asset re-roll budget | LANDED (form: reserve, not 2nd batch) | Feature 1 = own work-package W-P, format `{version,gold,ranks,flags}` :87–99; grep `user://` godot/ = 0 hits re-run here (TRUE, none exists). Asset rows: "one batch + a declared re-roll reserve (~30 % of rows held)" citing S1a/S1p/S1q :183–189 — functionally the c1 ask (budget for the re-roll card), wording deviates from "≥2 batches"; accepted as equivalent. M1 re-sized 12–14 :81. |
| 6 | M4 assets 6→11 or state reuse | LANDED | :241–245: 11 TRELLIS-class items (6 characters + 5 skins as distinct meshes on the same rig), badges-reuse stated. |
| 7 | **P1**: carry caps + worst-case loadout in every budget line | LANDED with one new wording defect | Feature 3 :115–126 (6 slots + 6 kinds, pool gating at `levelup.gd:17-36`, both-sides legs); §2 Canonical WORST-CASE LOADOUT :65–75; cited at ≤40 planned (:71), 400-alive (:130), feature-6 FX re-tally (:161–162), feature-3 cap leg (:125–126), NO-credit rule (:74). Loadout names cross-checked against the feature-6 table: all 6 evolutions + 6 partners present and consistent. See NEW P2-B (construction channel) and NEW P2-C (passive clause off-by-one). |

**Folded c1 P3s (all six present):** combo tally corrected to 93 (row 2 :32); ev-gate 600 provenance line (:139–141);
re-tally undercount note (:71–72); rAF boot-window-only honesty (:76–79); S12 parent-confirm (:84–85, :290–291);
semver convention line (:56–59). **Adoption: 7/7 + 6/6 folded P3s.**

## PASS 2 — REBUTTAL ADJUDICATION (c1 E-2)

Greps run THIS session (not the producer's):
- `tests/test_game_numbers.py:39` — **defines `test_win_threshold_600()`** (asserts `const("WIN_TIME", GAME_STATE) == 600.0`
  + the main.gd gate regex). `:35` defines `test_boss_at_540`. c1's E-2(b) "no such test exists" and the "NOT in
  test_game_numbers.py" half of E-2(a) are **FALSE**.
- `tests/test_biome_numbers.py:65` — also **defines `test_win_time_600()`**, same asserts (producer's second-pin claim TRUE).
- `tests/test_boss_numbers.py:64` — `test_boss_spawns_exactly_once_at_540` (c1's location TRUE).
- `pytest test_game_numbers.py test_biome_numbers.py test_boss_numbers.py test_card_icons.py` → **58 passed** —
  the rebuttal's "present and green" claim VERIFIED by execution.

**Ruling: c1-EVIDENCE-ERROR UPHELD (producer's rebuttal correct on the disputed row), and the true state is
both-pins-true**: WIN_TIME 600 is pinned twice (`test_game_numbers.py:39` + `test_biome_numbers.py:65`), BOSS_AT 540
twice (`:35` + `test_boss_numbers.py:64`). c1's SUBSTANTIVE findings survive untouched — the second-pin pair and the
unlisted IDS/icons/planned-33 obligations were real gaps in rev-1 §4 and are adopted in feature 7. What an executor
must do: treat both WIN pins as **retire-deliberately** targets (both named in feature 7 → replaced by 900 pins in
the same commit); NEVER delete-by-single-name-grep; the BOSS stay-green pair must be kept GREEN deliberately (it is a
live pair in two files, not one). The adopted fix list survives either ruling — feature 7 names both pins, so no
executor path deletes a live green pin. c1 gets no face protection and the producer no punishment: the evidence row
was wrong, the rebuttal is right, the plan is better for the exchange.

## PASS 3 — NEW-CONTENT ATTACK (rev-2 material only)

| # | Target | Finding | Evidence | Sev |
|---|---|---|---|---|
| N-1 | Feature 7 "the M1 retire-and-replace suite list" (claims completeness; ACCEPT: "pytest 100 % green on the M1 tip, no RED carry") | **INCOMPLETE — the weapon side of test_card_icons.py is an M1 RED obligation and is unlisted.** The 12-card icons suite pins three more things that M1's 16-weapon/32-kind pool breaks: `WEAPON_KEYS` static 6-ID list (:29), `meta_icons()` equality `sorted(table) == sorted(WEAPON_KEYS)` (:76), and the pool-count pin `assert len(rows) == 12` in `test_all_12_kinds_resolve_to_real_icons` (:117–124). The first M1 weapon-icon commit goes RED on all three. This is the SAME failure class c1 E-2(d) flagged (unlisted pin → RED carry), now in the rev-2 list that was written to fix exactly that. FIX: add one feature-7 bullet — "`tests/test_card_icons.py` 6-weapon keys/count pins (:29, :76, :124 `len(rows)==12`) → 16-weapon keys, 32-kind count, + 10 new weapon-icon provenance rows (REPLACE)". | test_card_icons.py:29,76,117–124 (read this session, all three pins VERIFIED); rev 2 :165–181 | **P2 (NEW-A)** |
| N-2 | WORST-CASE LOADOUT constructibility in the sim-leg harness that exists TODAY | **Constructible via DECLARED-pin injection — NOT as a played run; the plan never names the channel, and the played reading is arithmetically impossible.** Harness inventory today: `godot/sim/sim_headless.gd` (driver) + `sim_policy.gd` (scripted picks, `pick_index` :89) + `sim_s8.gd` (real-clock) + `sim_boss.gd`/`sim_combat.gd` (scripted legs). `sim_boss.gd:215` ALREADY pins an all-six-L8 build: `run.game.weapons = build # DECLARED pin (SimCombat pattern)` — precedent VERIFIED, so injection is buildable today with zero new mechanism. But PLAY-reachability fails twice: (i) level-up budget — ~29–30 picks at 900 s (c1 A-1's own XP math, unchanged by caps) vs the named loadout's need ≈ 6 acquisitions + 6×7 upgrades + 6 partner kinds ≈ 54 picks; (ii) evolution supply — chests come only from boss/miniboss kills (feature 5): warden 1.0 + 2 × `CHEST_CHANCE_MINIBOSS 0.6` ≤ ~3 chest opens < 6 evolutions. FIX: one §2 sentence — "the WORST-CASE LOADOUT budget legs are DECLARED-pin scripted legs (the sim_boss:215 / SimCombat pinning pattern): the loadout is pinned into `game.weapons`/`game.passives`, play-reachability of the full evolved set by 900 s is NOT claimed (≈30 picks vs ≈54; ≤3 chest rolls vs 6 evolutions)". Without it, feature 4's "900 s dump under the WORST-CASE LOADOUT policy" describes a leg that cannot be constructed by the only channels the doc shows, and the c1-P1 purpose (a verifiable bound) is still unmet at the leg level. | rev 2 :65–75, :125–126, :129–130; sim_boss.gd:215; sim_policy.gd:85–103; levelup.gd:17–36; world.gd:83–92 | **P2 (NEW-B)** |
| N-3 | Carry caps at `levelup.gd:17-36` — implementability vs the 12-card icons suite pins | **Implementable; the cap touches no icon pin; but the passive clause has an off-by-one contradiction.** Mechanically: `build_pool` cleanly separates NEW-weapon offers (`owned.is_empty()` branch :26–28) from upgrades (:29–31) — a 6-slot gate is one condition on the empty branch; the passive loop (:32–35) gates new KINDS the same way. Caps add no keys to any table, so `test_card_icons.py`'s PASSIVES↔PASSIVE_ICONS pins break ONLY from the +10 passives — already listed for retirement. The defect is wording: "drops a passive KIND once it is the 6th distinct carried" (:119–120) read literally caps carries at 5 KINDS (a kind is dropped as it BECOMES the 6th — and would also block its upgrades, contradicting "existing 5-stack cap … unchanged"), while the same doc's loadout says "6/6 passive kinds" and the cap says 6. FIX: mirror the weapon clause verbatim — "drops NEW passive KIND offers when 6 distinct KINDS are carried (carried-kind upgrades stay offerable up to the 5-stack cap)". | levelup.gd:17–36 (read); test_card_icons.py:80–82,109–113; rev 2 :115–126 vs :70–71 | **P2 (NEW-C)** |
| N-4 | dawnwell.json persistence rules (feature 1) | **Load-side failure modes ANSWERED; write-side UNSTATED.** Corrupt save → answered (rename `dawnwell.corrupt.json` + `SAVE_LOAD_FAIL` stderr + defaults, pytest both-sides, :90–93). Version skew → answered both directions (future version refused + quarantined; older migrates field-by-field, :93–94). Delete-while-running → **no rule** (an in-memory re-write at the next save silently resurrects the deleted save; undefined, acceptable only if stated). Write timing/atomicity → **no rule**: nothing says WHEN `dawnwell.json` is written (run-end? per purchase/refund?) or that writes are atomic — a torn write lands in the corrupt path and costs the player their meta ranks with only a quarantine file as the trace. Not build-blocking (the load rules keep it SAFE and no acceptance line contradicts), but the fix is one line: "Dawn Well writes on every rank/gold mutation via temp-file + rename (atomic); delete-while-running is undefined-by-design: the next write re-creates from memory." Marked vague per the DoD; fold into feature 1. | rev 2 :87–99; game_state.gd:44–59 | **P3 (NEW-D)** |
| N-5 | 12–14 seat-days honesty (±3d recompute vs the work-package list) | **PASS at the edge.** Per-package recompute: W-P persistence 2–3; shop+refund 2; carry caps 1; run-length+2 minibosses+horde cap 2; chests+evolutions 1.5–2; 10 weapons (all reuse-named mechanisms) 3–4; 10 passives + suite retirement 1.5; asset integration + re-roll handling 1.5–2 → **Σ ≈ 13.5–17**. Declared 12–14 sits inside the ±3d band (my top ~16 vs declared top 14, diff ≈ 2); the risk mass is the persistence and weapons legs, and the doc already carries the asset re-roll reserve. Honest as stated; no edit demanded — recommend the M1 parent re-estimate after the W-P card closes. | rev 2 :81, :87–189 | **P3 (NEW-E, note)** |
| N-6 | "max-FX-class set" claim for the loadout choice | The 6 named evolutions are asserted to be the max-FX set, but no instance/class table justifies the selection (Rolling Thunder double-strike, Pale Moon gem-rain, Grave Orbit explode-on-bounce are plausibly heavier on INSTANCES; draw is per-class so the art-probe re-tally backstop likely absorbs any shortfall — planned-40 is a class plan). Not wrong, just unsupported prose; the fixture re-tally is the named backstop, so this stays a one-line nit: justify or soften to "the class-covering set (activates the zone MM; fixture re-tally is the gate)". | rev 2 :67–72, :161–162; viz_fx per-class pattern | **P3 (NEW-F)** |

## Carried, unchanged (not re-litigated)

c1's rows that rev 2 did not change stand: S12 board-side confirm is parent-side (leaf here; repo has no S12
trace — grep re-confirmed: gold/XP 3D draw path still absent, so the M1 prereq genuinely rides an in-flight card).
The exclusion list, gap-table citations, reuse map and export spine survived c1 and are untouched by rev 2.

## Summary

- **Adoption: 7/7 ranked edits LANDED (one, the asset budget, in equivalent reserve form) + 6/6 folded P3s present.**
- **Rebuttal: c1-EVIDENCE-ERROR upheld — the producer is right; both-pins-true is the state of the world; the fix
  list survives either ruling.**
- **New findings: 0 P1, 3 P2 (N-1 unlisted card-icon RED pins in the "complete" retire list; N-2 loadout
  construction channel unname­d and play-impossible as written; N-3 carry-cap passive clause off-by-one),
  3 P3.**

The three P2s are exact one-sentence edits to feature 7, §2 (loadout), and feature 3 respectively; none changes the
phase decomposition. Per the gate rule (SHIP only with no P2 in new content), the verdict is FIX.

# VERDICT: FIX
