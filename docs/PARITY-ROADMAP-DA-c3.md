# PARITY-ROADMAP-DA-c3 — adversarial gate cycle 3 (FINAL, ship gate) over docs/PARITY-ROADMAP.md rev 3 (MC 11204, T-S17d)

- Reviewed target: `docs/PARITY-ROADMAP.md` @ 60a2dd0 (rev 3) — VERIFIED this session: `git pull --rebase` → "Already up to date", HEAD = 60a2dd0.
- Cycle state entering c3: c1 FIX @ 000ba42 (7-edit list, adopted 7/7 per c2); c2 FIX @ d2897da (3 P2 exact-edit asks N-1/N-2/N-3 + 3 P3 folds; producer rebuttal of c1 E-2 UPHELD by c2's own re-greps + pytest). Per the gate rule this cycle admits **SHIP or RECONSIDER only**: SHIP if the three edits landed and introduce nothing new-blocking; RECONSIDER only if the phase decomposition itself is wrong.
- Method: every pin re-grepped HERE (not inherited from c2, not from the producer's summary); pick arithmetic re-derived from `game_state.gd:28-29` by execution; pinned suites re-run green this session. Inputs read: rev 3 (full), c2 doc @ d2897da (immutable), rev-2 doc @ abb4a61 (for the deleted old clause), `tests/test_card_icons.py` (full), `godot/sim/sim_boss.gd`, `godot/sim/sim_policy.gd`, `godot/scripts/levelup.gd`, `godot/scripts/game_state.gd`, `godot/scripts/world.gd`, the rev-3 diff (`git show 60a2dd0`), c1 doc A-1 row.

## 1. N-1 — feature 7 WEAPON-side icon-suite bullet

Bullet present (rev 3 :194–198) naming all three pins + REPLACE semantics. Pins re-grepped myself:

| Doc claim | File reality (VERIFIED this session) | Match |
|---|---|---|
| static `WEAPON_KEYS` 6-ID list (:29) | `test_card_icons.py:29` = `WEAPON_KEYS = ["talon", "ember", "cleaver", "halo", "ward", "spike"]` | EXACT |
| `meta_icons()` equality `sorted(table) == sorted(WEAPON_KEYS)` (:76) | `:76` = `assert sorted(table) == sorted(WEAPON_KEYS), table` | EXACT (assertion quoted verbatim) |
| pool-count pin `assert len(rows) == 12` (:124) | the assert is at **:125**; `:124` is the `rows.append(resolve_icon("bonus", …))` line one above it | OFF-BY-ONE → see P3-nit below |

- The file is untouched since 9115dde (S5) — the off-by-one is inherited verbatim from c2's suggested-fix wording, introduced by the DA (c2), not by the producer. **Non-blocking**: the bullet quotes the assertion TEXT verbatim, so the retire target is unambiguous to any executor grepping the suite (and the doc's own doctrine already forbids delete-by-name-grep); the line number is a locator convenience, the quoted assert is the target. Logged as **P3 accuracy nit (c3-C1)** for the M1 card transcription, not a roadmap edit.
- **Replacement numbers internally consistent:** `16-weapon keys` = 6 shipped (`weapons.gd IDS`) + 10 tabled in feature 6 (counted: 10 rows) = gap-table "16 by M1" ✓. `16+15+1=32-kind` mirrors the test's own row construction (weapon icons + passive keys + 1 bonus): today 6+5+1 = 12 ✓ (`levelup.gd:8-14` grep = exactly 5 PASSIVE keys); after M1: 16 + (5+10=15, gap row 3 "15 by M1" ✓) + 1 bonus = 32 ✓. The 10 evolution forms ride a SEPARATE evolution table pinned by its own row (feature 5 ACCEPT "evolution table pytest pin"), so they do not inflate `WEAPON_KEYS` — consistent.

**N-1 LANDED** (with c3-C1 P3 nit noted, non-blocking).

## 2. N-2 — §2 loadout construction channel

- **DECLARED-pin leg present** (rev 3 :79–86), quoting the pattern. Pattern re-verified at the cited line: `sim_boss.gd:215` = `run.game.weapons = build # DECLARED pin (SimCombat pattern): kill 3000 hp` — the doc's quoted substring matches the live line ✓. Zero-new-mechanism claim TRUE (existing injection precedent in-tree).
- **Disclaimer arithmetic present and right.** Re-derived from code this session, not quoted: `game_state.gd:28-29` is `xp_need = 5 + 4L + L²`; cumulative XP for 28 level-ups = 9,478, for 27 = 8,532, so at c1-A-1's ≈9,000 gem-XP budget the reachable picks ≈ **28** — the doc's "≈ 30 available" is honest-to-player rounding, and even the generous reading cannot approach the need. Needed: 6 acquisitions + 6×7 upgrades (L1→L8) + 6 partner kinds = **54** exact ✓. Chest supply: warden `CHEST_CHANCE_BOSS := 1.0` + 2 × `CHEST_CHANCE_MINIBOSS 0.6` = E[2.2], max 3 rolls vs 6 evolutions ✓ ("≤ ~3 … vs 6"). The disclaimer CONCLUSION (play-reachability not claimed) holds under every reading of the inputs — the numbers are conservative in the safe direction.
- **PLAYED cap-curve is its own acceptance row** (":84–86 … SEPARATE acceptance row") with owner-verifiable checks: named sim-policy-leg owned-set dump rows (harness exists — `sim_policy.gd` with `pick_index` at :89, inventory re-confirmed) + the feature-3 offer-gating both-sides legs (:145–148: 6-owned → 100 dumped offers contain ZERO kind:"weapon" rows; <6 → offers present). Budget legs no longer double as play-reachability claims ✓.
- Ancillary cites in the same block re-grepped: `world.gd:83-92` IS the single spawn loop (`update_spawns`) ✓; `HEAL_DROP_CHANCE := 0.015` at `world.gd:6` ✓ (pattern real); `CHEST_CHANCE_*` grep across godot/+tests/ = **0 hits** ✓ — correctly declared as NEW M1 consts, not mis-cited as existing pins.

**N-2 LANDED.**

## 3. N-3 — feature 3 passive clause vs weapon clause

Side-by-side (rev 3 :137–141):

> weapon: "drops NEW-weapon offers when 6 slots are full (owned-weapon upgrades stay offerable)"
> passive: "drops NEW passive KIND offers when 6 distinct KINDS are already carried — carried-kind upgrades stay offerable up to the 5-stack cap"

- Verbatim mirror ("and identically" names it); the old off-by-one phrasing ("drops a passive KIND once it is the 6th distinct carried") is DELETED in the rev-3 diff ✓ — cap is 6, not 5; upgrades no longer blocked.
- Consistent with the §2 loadout row "(6/6 passive kinds)" ✓; mechanism implementable on the one pool source (`levelup.gd:17-36` span re-read: NEW-weapon branch at :26–28, upgrade branch :29–31, passive loop :32–35 — a gate on the two "new" branches is the stated change, and adds no keys to any table, so no icon pin moves from the caps themselves).
- Both-sides ACCEPT pair for passive kinds present (:146–147) ✓; "evolutions replace in-slot, never add a 7th" retained ✓; `MAX_PASSIVE_STACKS == 5` STAY-GREEN pin re-checked (`test_biome_numbers.py:238` = `assert const("MAX_PASSIVE_STACKS", LEVELUP) == 5.0`) ✓.

**N-3 LANDED.**

## 4. P3 folds (c2 N-4 / N-5 / N-6)

| Fold | Present | Check |
|---|---|---|
| N-4 atomic write path | YES (:111–114) | "every rank/gold/refund mutation writes via temp-file + rename (atomic …)" ✓ |
| N-4 delete-while-running | YES (:113–114) | "UNDEFINED BY DESIGN … (stated, not a bug)" — declared, therefore acceptable per fleet law (the doctrine objection was the UNDETECTED silent-recreation case; stating it closes it) ✓ |
| N-5 re-estimate note | YES (:97 header) | "the M1 parent RE-ESTIMATES after the W-P persistence card closes" ✓ |
| N-6 loadout wording | YES (:75–76) | "class-covering set (activates the zone MM; every weapon-FX class live; fixture re-tally is the gate)" — unsupported "max-FX" claim softened ✓ |

## 5. NO-NEW-BREAKAGE scan

- **New-citation spot-check: 12 file:line cites re-grepped this session, 11 EXACT, 1 off-by-one** (all N-1/N-2/N-3 material — the newest citations): test_card_icons.py:29 ✓, :76 ✓, :124→:125 (nit above); sim_boss.gd:215 ✓; levelup.gd:17-36 ✓; game_state.gd:44-59 ✓ (`start_run` at :44); game_state.gd:28-29 ✓; world.gd:6 ✓; world.gd:83-92 ✓; CHEST_CHANCE consts = 0 hits, correctly slated-new ✓; test_biome_numbers.py:238 ✓; levelup.gd:8-14 = 5 PASSIVES keys ✓. Suite re-run: `pytest test_game_numbers.py test_biome_numbers.py test_boss_numbers.py test_card_icons.py test_art_integration.py` → **62 passed** (c2 ran 58/4 files; the +4 are test_art_integration's rows — suite green, no drift).
- **Older §2/§5 consistency:** each of the six loadout evolution names (Red Wail, Thousand Darts, Rot Spiral, Judgement Cross, Eternal Matins, The Sluice) occurs EXACTLY twice in the doc — §2 loadout + feature 6 table — identical set, nothing renamed by the edits; the six loadout partner passives are the first six table partners ✓. §5 cycle-state rewrite agrees with §4 fleet-law row (cards filed only after cycle-3 SHIP) ✓.
- **Diff purity:** `git show 60a2dd0` touches ONLY the three P2 edits + three P3 folds + header/cycle-state/rebuttal-banner bookkeeping — no silent content change elsewhere ✓.

## 6. Residuals (classified, none blocking)

- **c3-C1 (P3, wording accuracy):** feature-7 bullet's `len(rows)==12` line pin off-by-one (:124 → :125); assertion quoted verbatim so the target is unambiguous. Carry the corrected number into the M1 feature-7 card text; do not reopen the roadmap for it.
- **c3-C2 (P4, coverage note):** the 10 EVOLUTION icons ride the asset row + chest-shot pixel floor + the feature-5 "evolution table pytest pin"; if the M1 design ever puts evolved ids INTO `weapons.gd META`, the c3-verified 16/32 replacement math moves to 26/42 — the bullet's number is pinned to the separate-table reading, which the doc itself names (feature 5). M1 phase-0 should state the table choice on the card. Not a doc edit; decomposition is unaffected.
- Both inherited from DA-side wording (c2), not from the producer; neither is a RED-carry or bound-gap — the c2 classes (unlisted pin, unnamed channel, off-by-one cap) are all CLOSED.

## Final statement — M1 executability (the paragraph the orchestrator cites)

M1 "Evolutions & Dawn Well" as written in rev 3 is EXECUTABLE by a build wave: every acceptance row names an observable check (pytest pin, sim leg with named dump row, shot path with ≥200-px floor vs empty baseline, planted-red pair), the worst-case budget bound is now constructible TODAY via the DECLARED-pin pattern that already exists in-tree (`sim_boss.gd:215`) with play-reachability honestly disclaimed by code-derived arithmetic (≈28–30 reachable picks at 900 s vs 54 needed; ≤3 chest rolls vs 6 evolutions), the carry caps implement on the single pool source with both-sides legs, the retire-and-replace suite list is complete against every pin re-grepped this session (WIN×2, BOSS stay-green×2, IDS, WEAPON_KEYS/meta-equality/pool-count, PASSIVES↔icons×2, planned-33 — suite green 62/62 at the rev-3 tree), persistence has declared load AND write rules with atomicity stated, and the one mechanism that is new (lingering zones) is declared as THE one with reuse into M2+. The two residuals (c3-C1 line-pin off-by-one, c3-C2 evolution-table placement) are card-transcription notes, not plan defects; the c1 P1 (unbounded carry) and all nine c1/c2 P2s are closed on evidence. No P0/P1/P2 remains in the plan or in the three edits; the phase decomposition survived three adversarial cycles unchanged in shape.

**Reading of ambiguity (stated per discipline):** (i) "N-1 landed y/n" — judged LANDED with the c3-C1 nit logged in-doc rather than treated as not-landed, because the edit carried the substance c2 demanded (all three RED pins + REPLACE semantics) and the defect is a DA-inherited locator number, not missing content; (ii) "new-blocking" — read as anything re-introducing a RED-carry class, an unverifiable bound, or an undeclared mechanism; none found.

# VERDICT: SHIP
