# M4-SPEC-DA-c3 — Devil's-advocate gate, cycle 3, NARROW (MC 11360, T-M4f3)

- **Target:** `docs/M4-SPEC.md` REV 3 @ `647660b`. Docs-only rev: `git diff bd4a825 647660b --
  godot/ tests/ tools/ assets/` = **0 lines** this session ⇒ the spec reads the same tree it
  cites (verified). History: rev-1 `0bf3acd` → c1 FIX `5695244` (immutable) → rev-2 `60d9811` →
  c2 FIX `bd4a825` (immutable, `docs/M4-SPEC-DA-c2.md`) → rev-3. c2's gate-biter was the one
  F-1 carve row; producer cycles exhausted — this doc does ONLY (1) the carve re-verification,
  (2) adoption of the remaining four c2 rows, (3) the named spot regression. All greps run THIS
  session at `647660b` (worktree `~/Games/hdwt-11360`); none carried from c1/c2.
- **Verdict summary:** **SHIP.** The F-1 carve is real, in both named places, and holds under
  fresh attack: the identity-cone leg IS the shipped default path bit-for-bit (`randf()·TAU`,
  `world.gd:193`), the spawn rate is an RNG-FREE accumulator so green-on-correct-code is
  mechanically reachable, and the planted-`randi` red stays exact and attributable. The four
  remaining c2 rows landed (F-2 with one illustrative-figure typo, P4). The spot regression:
  SEL-A rows, A-E3 and the §7.1/§7.2 sections are byte-untouched by the rev-3 diff; ACCEPT
  count 20. **P1 = 0, P2 = 0, P3 = 1, P4 = 2** (wave-brief notes, none gate-biters).

## 1. F-1 CARVE VERIFICATION — the one row

**The carve text exists where c2 named it — BOTH places.** §1.1 zero-RNG bullet (spec :208-213):
"the zero-RNG fact is proven by a twin that pins the cone to the table's IDENTITY default
`[0.0, TAU]` — a LIVE cone changes spawn GEOMETRY (kill timing ⇒ the kill-time `randf`s at
`kill_enemy :349/:351/:353/:363` consume at different positions), so geometry divergence is
A-E3's instrument, never a digest claim"; and A-E5 (:263): the full carve — "the digest twin pins
the cone to the table's IDENTITY default `[0.0, TAU]` (`0.0 + randf()·TAU ≡ randf()·TAU`),
keeping spawn geometry inert … ⇒ twin digests equal **through t=720 and to run-end, GREEN on
correct code** … the LIVE cone's geometry truth stays A-E3's". The two restatements agree.

**Fresh greps at `647660b` (c2's factual base re-derived, not carried):**

| # | claim | fresh evidence |
|---|---|---|
| G1 | the identity cone = the shipped DEFAULT spawn-shape path | `world.gd:193` (inside `_spawn_enemy`) = `var angle := randf() * TAU` — exactly ONE `randf` per spawn, full circle. The planned cone form `center + randf()·width` at `[0.0, TAU]` is `0.0 + randf()·TAU`: `0.0 + x ≡ x` bit-for-bit for every non-negative `x`, and `randf() ∈ [0,1)` makes the product non-negative (never `-0.0`) ⇒ the identity path is the shipped path. **Identity claim TRUE.** |
| G2 | the rate loop cannot fork the stream by itself | `world.gd:259` `spawn_acc += minf(12.0, (1.0+1.3*minute)*qty_cyc*surge) * dt` — an RNG-FREE accumulator; the only per-spawn draws are the roster `randi` (`:263`) + the angle `randf` (`:193`). In the twin window `[660,720)` = minute 11–12: base `(1+1.3·11) = 15.3 × qty_cyc(1.0) ≥ 12.0` ⇒ `minf` clamps BOTH twins to exactly 12.0 ⇒ identical accumulator trajectory ⇒ identical spawn ticks ⇒ same draws at the same stream positions. Cone selection is the clock comparison the §1.1 bullet states (`game.time`-based table read; no RNG site anywhere near it). |
| G3 | kill-time rolls are real and stream-position-bound | `kill_enemy` grepped: `:349` gem `randf() < 0.7` (guarded by `enemy.xp > 0.0` — deterministic per kind), `:351` coin `randf() < 0.06`, `:353` heal `enemy.boss or randf() < HEAL_DROP_CHANCE` (short-circuit = deterministic), `:363` boss chest `enemy.boss and randf() < CHEST_CHANCE_BOSS`. Every guard is enemy-kind-determined ⇒ under an identical horde (G1+G2) the kill multiset, kill timing and roll COUNT are identical ⇒ the SAME stream at the SAME positions. |
| G4 | the digest idiom is a value-compare that can go GREEN | `sim_stages.gd:428` = `"dwell_zero_rng": str(dwell) == str(no_plate)` — shipped, fixture-pinned TRUE (`stages-m3.jsonl` row 9: both digests `{alive:161, kills:199, spawns:360, types:[…]}` byte-equal). The leg comment at `:419-421` states the carve's own premise: "an off-position twin forks kill timing -> the levelup offers' RNG: measured 185/178" — the twin holds precisely BECAUSE the plate touches no spawn geometry. The cite is still true as M3 rev-3 stated it. |
| G5 | A-E3 still owns the live-cone geometry | A-E3 (:261, `cone_share`, position rows) is a CONTEXT line in the rev-3 diff — byte-untouched; the carve re-states the partition in its own text ("never a digest claim"). The planted live-cone-in-table red stays A-E3's position-based instrument. |

**The planted-`randi` red walked (as written):** the mutant consumes a `randi` per in-window
spawn for cone choice REGARDLESS of the cone value (identity twin: the angle is still
`0.0 + randf()·TAU`, unchanged rate — the accumulator never touches RNG, G2). From the first
in-window spawn (≈ t=660, window opens at 660.0 with the cap-pause semantics of §1.1) every
LATER draw sits at a shifted stream position ⇒ roster picks and angles differ ⇒ the digest
dict `{alive, kills, gold, spawned_types}` forks at 660 while the printed rate stays 12/s on
both twins ⇒ `rng_stream` check RED. Reachable, exact, and attributable to the single extra
consumption **precisely because geometry was pinned out** — on a live cone the same fork would
double-attribute (the masking c2 diagnosed).

**JUDGMENT.**

- **The collision is dissolved without weakening either fix.** Fix 1 (P4-4's whole-run digest
  comparison): stands, scoped to the identity leg — the row's OWN subject is the default path,
  which threatens every byte corpus, and on that path green is mechanically reachable (G1+G2+G3
  ⇒ byte-identical twins ⇒ green on correct code). Fix 2 (the live-cone design c1 upheld):
  stands untouched — A-E3 keeps the geometry claim byte-equal (G5). The M3 precedent proves the
  idiom can be green on correct code (G4).
- **Strongest fresh attack (fails, but yields the one P3):** "under the identity twin the 660
  event-miniboss is an ASYMMETRIC extra consumer — its latch spawn draws one `randf` (`:193`)
  and its death draws `:351`/`:353`/`:366` — so a twin pair that differs in the 660 `bosses`
  entry forks the digest on CORRECT CODE, re-importing c2's F-1." The leg survives because the
  twin-composition readings that fail are LOUD (red at build, self-correcting) and at least one
  natural builder reading is green as written: the events FLAG gating the `events` window loop
  with BOTH twins carrying the same re-pinned `bosses` row ⇒ the miniboss consumes symmetrically
  at the same tick on both twins (the shipped saturation leg pre-clears its bosses exactly this
  way, `sim_stages.gd:432-437` "both twins fire their OWN boss on the pre-window tick (the same
  ONE randf each), then it is CLEARED"). A-E6 owns the miniboss schedule separately. The
  surviving duty is the wave brief naming the twin's table scoping — P3-1 below, not a carve
  defect: the carve's two load-bearing claims (identity = default path; geometry-inert ⇒ stream
  holds) are both TRUE as grepped.
- **The §1.1 bullet adds no new obligation** — it states the same carve plus the attribution
  partition, and every number in it (`:349/:351/:353/:363`, `sim_stages.gd:428`) re-grepped
  true above.

## 2. Adoption of the remaining c2 rows (4/4 landed, each re-grepped at 647660b)

| c2 id | status | fresh evidence |
|---|---|---|
| **F-2** outrun bound | **LANDED — bound TRUE as written; one illustrative figure off (P4)** | `BASE_SPEED := 140.0` = `game_state.gd:5` ✓; `player_speed() = BASE_SPEED * (1.0 + 0.08*passives.haste)` = `:80-81` ✓; the 5-stack cap is real (`levelup.gd:38`/`:61` "the 5-stack cap" — cite `:81` names the seam where ×1.4 lands ✓). spd-200 reaper > 196 ⇒ "UN-outrunnable … for every run at or below the shipped passive cap" is TRUE (≤196 < 200). "checked by test" removed — my grep: no ACCEPT row names outrunnability ✓. §9 hedge present verbatim: "NEVER reachable inside a flag-off 900 s run" ✓ + scope line "the +3% repeatable HASTE passing 200 spd at m ≥ 2 is a reaper-ON interaction by construction". The stated figure `196·(1+0.03m) = 207.84` (at m ≥ 2) does not reproduce: the spec's OWN additive law (C-E3) gives **207.76**; the compound reading gives 207.94 — neither is 207.84. And additive m = 1 already gives 201.88 > 200, so "at m ≥ 2" is a conservative-true threshold. P4-2. |
| **F-3** B-E6 instrument | **LANDED** | B-E6 (:360) now names "the leg's ZERO-DROP-ARRAY-DELTA check, the SAME value-compare red shape the repo already executes" + soft-error semantics ("error printed, evaluation continues, null returns — no abort") + the green-first-run-as-first-executed-`world.gd:358`-evidence sentence. Both cites re-grepped EXIST AS CITED: `sim_chest_tiers.gd:20-24` = "the map-bypass planted-red (a drop site hardcoding a tier) reddens boss_ok: the check compares the DUMPED map value, never a second literal" ✓; `test_chests_tiers.py:144-158` = `test_drop_sites_stamp_tier_from_the_map` def :144 with the keyed-site regex asserts through :158 ✓. The law comment at `world.gd:358` ("a bypassed source crashes at the drop, never silently de-tiered") exists and is a COMMENT — the row no longer asserts it as an executed red ✓. |
| **F-4** saturation sub-window | **LANDED — numbers re-derived by me** | Off the rate term `:259` + cycle-0 `minute = t/60`: leg window `[480,510]` ⇒ minute 8.0–8.5 ⇒ base `1+1.3·minute` = **11.40–12.05** ✓; planted outside-`minf` ×2.0 ⇒ **22.80–24.10/s** ✓ vs green `minf`-clamped ≤ 12.0. Cap hit: cleared start (the shipped `_plate_window` shape clears at start), growth ≈ spawn-rate minus early kills; ∫₄₈₀⁴⁹⁷ ≈ 23.2/s·17 s ≈ 394 ⇒ `ALIVE_CAP := 400` (`:20`) with the early-return `:249-250` ⇒ **≈ t≈497, ≈ 17 s measurable** — the row's numbers, reachable. The false-green risk is real: the FULL-window mean dilutes toward ≈13/s against a ≤12 check; the row now measures the named pre-cap sub-window, closing it ✓. |
| **F-5** latch/flare cites | **LANDED** | Header (:53) + inherited spots (`:128`, `:188-190`, `:195`, `:288-289`, `:738`) now cite `:225-238` / `:243-248`. Code re-grepped: latch = `while schedule_spawned…` :225 through `_spawn_enemy(b[1], …)` :238 EXACT; flare-decay `game.flare = maxf(…)` :243 + plate-surge var/loop :244-248 EXACT; the accompanying cap `:249-250`, rate `:259`, pick `:260-263` all EXACT (the spots that share the parenthetical). |
| (F-1) | **LANDED — §1 above.** | |

**Adoption tally: 5/5 (carve + four rows).** Rev-3's §14 ledger claims match the actual
`bd4a825 → 647660b` diff hunk-for-hunk (header, §1.1 bullet, A-E4, A-E5, §2.1 outrun, §9
hedge, §13/§14 ledgers — 10 hunks, +53/−13) — no undeclared change anywhere in the diff.

## 3. Spot regression (the named rows, unchanged)

- **SEL-A v2.1.0 rows:** §5 (":451 `THE VERSION-LAW DECISION (SEL-A ⇒ v2.1.0)`", `:460` option
  row, `:483` RECOMMENDATION) and the header VERSION-DECISION row `:28` — the rev-3 diff's
  hunks cover old `1-5, 41-47, 176-189, 197-203, 246-253, 272, 283-290, 338, 601-608, 714,
  739-742`; none touches `442-474` or the `:28` region ✓. Header claims "SEL-A v2.1.0
  untouched" — true.
- **A-E3 + §7.1/§7.2 byte sections:** A-E3 :261 context in-diff ✓ (verified verbatim in §1 G5);
  §7.1 `:532-555` + §7.2 retire ledger `:556-577` fall between hunks (diff jumps old 338 → old
  601, the latter landing inside §9) — ZERO lines touched ✓.
- **ACCEPT count:** table rows `A-E1..A-E7` (7) + `B-E1..B-E6` (6) + `C-E1..C-E4` (4) = 17 plus
  the D-E1..D-E3 bullet rows (`:446`, Pillar D) = **20** — identical at `bd4a825` (17 table rows
  there too); §14 "ACCEPT rows stay 20" ✓.

## 4. Findings register (P3/P4 only — wave-brief notes, nothing gate-blocking)

| id | sev | one-liner |
|---|---|---|
| c3-P3-1 | P3 | A-E5's twin-composition should NAME the `bosses`-row handling: the 660 event-miniboss entry must be carried SYMMETRICALLY by both twins (flag gates the `events` window loop, per the shipped pre-clear idiom `sim_stages.gd:432-437`) or be excluded from the `rng_twin_identity` leg's table (A-E6 owns the miniboss). One line in the T-M4e brief; the failing reading goes RED at build, not silently green. |
| c3-P4-1 | P4 | `196·(1+0.03m) = 207.84` at m ≥ 2 is off: the spec's own additive law gives 207.76. Recompute on next touch (the bound and the m ≥ 2 threshold-claim stay true; the true crossing is m ≥ 1, 201.88 — "m ≥ 2" is conservative, may keep). §14 F-2 line carries the same figure. |
| c3-P4-2 | P4 | A-E5's red wording "digests fork at 660 on the identity twin" reads slightly ambiguous (one twin vs the pair) — the check is the PAIR comparison (str(a)==str(b)); A-E5's seam cell disambiguates ("digest rows … leg named `rng_twin_identity`"). Reflow when next edited. |

## 5. Stated readings of ambiguity

- "identity cone [0.0, TAU] equals the shipped DEFAULT spawn-shape path" read as: the planned
  parameter form `center + randf()·width` at `(0.0, TAU)` yields a bit-identical angle draw to
  `world.gd:193` — TRUE (G1); the `-0.0` edge is unreachable (`randf() ∈ [0,1)`).
- "GREEN on correct code" read per the dwell_zero_rng idiom as the PAIR of twin digests being
  equal, twin = event-mechanism run vs the same run mechanism-off, cone pinned to identity —
  reachable under the G1+G2+G3 chain once P3-1's table scoping is named.
- F-2's "m ≥ 2" read as a sufficient-condition claim (true), not an exact threshold — the
  P4-1 note is the figure, not the bound.
- The rev-3 diff read as the 10 hunks enumerated in §2's tally — every hunk maps to a declared
  §14 row; nothing else moved.

## 6. Verdict rationale against the gate rule

The brief: FIX only if a P1-breaking defect sits IN THE CARVE. The carve was attacked at its
load-bearing claims: (i) identity = shipped default path — holds, bit-for-bit (G1); (ii) geometry
inert ⇒ kill-timing and kill-time rolls hold stream position — holds (G2+G3, RNG-free
accumulator + kind-deterministic guards); (iii) green is mechanically achievable in the idiom —
holds (G4, the shipped pair is byte-equal today); (iv) the planted red is reachable and
attributable — holds (§1 walk). The asymmetry attack (the 660 miniboss) lands on twin
COMPOSITION, not on the carve's claims, has a natural green-as-written reading plus the shipped
pre-clear idiom, and fails LOUD otherwise — logged c3-P3-1 for the T-M4e brief. All five c2 rows
landed (F-2's illustrative figure off, P4); the named regression rows are byte-untouched; the
ACCEPT corpus stands at 20. **The M4 wave is authorized:** asset card (T-M4a) + serial spine
T-M4e → T-M4r → T-M4l + release card (T-M4z) under the GitHub-Release doctrine trio, with the
c3-P3-1 line and the c3-P4-1 figure fix riding the wave briefs.

# VERDICT: SHIP
