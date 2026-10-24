# M2-SPEC — hollow-dawn-3d "Depth & Cycles" (v1.3.0) — spec for the DA gate

- **REV 2, 2026-10-24, after DA cycle 1** (`docs/M2-SPEC-DA.md` @ `c1cfc12`, MC 11221, immutable).
  The reviewer's fix list is **adopted in full** — P1 (the cycle-clear chest-tier self-
  contradiction) + five P2s (vacuous `MAX_CONTACT_DMG`, `HP_CAP` bound at the wrong cycle, the
  endless throughput/fun break, the false `byte-identical` XP claim, the wave-map parallel
  contradiction) + every P3/P4 folded (all cheap and correct). The reviewer's **attacks F/G/H and
  checklist rows 1/2/3/6/8/9 held as VERIFIED** (endless is greenfield; reuse-first; budget holds;
  Contract B frozen) and are carried unchanged. §10 lists every change by section; **REBUTTAL:
  none** — no DA finding is contradicted by file:line, so all are adopted (the only precision tweak
  is the `sim_boss.gd` DECLARED-pin line, corrected to `:292` per this session's own grep).
- **Purpose:** build-depth spec for M2, authored for the **devils-advocate gate** (fleet law:
  roadmap-gated build cards file ONLY after the DA SHIPs this — MC 11219 / T-M2a, parented on
  `docs/PARITY-ROADMAP.md` rev3 §M2). Same spec-depth the M1 feature sections got before their
  build wave shipped v1.2.0. This document names files, seams, numbers and rejected trade-offs; it
  is not a plan sketch — a build card executes straight from an ACCEPT row.
- **Code truth:** read this session at `origin/master`; base for the pillar greps is `068a51b`
  (T-M1g, the M1 accept + v1.2.0 cut); DA c1 re-ran the greps at the rev-1 spec commit `475a480`. Every
  dependency claim is re-grepped HERE (M1 proved the roadmap's pins drift): roadmap §2/feature-7
  test line numbers are corrected to the live tree where they moved.
- **Clean-room stance (inherited from `docs/PARITY-ROADMAP.md` §1 honesty rule, binding):**
  *their systems, our content* — the Vampire Survivors inventory (`docs/VS-FEATURES.md`, clean-room
  wiki text, MC 11195) is a **shape reference only**; every table below carries OUR numbers, pinned
  by OUR suite. No copied value, asset, or flavor text. "≈their +X%" lines name the shape, not a
  number we ship.
- **docs/ARCHITECTURE.md:** ABSENT in this repo and deliberately not created here — the repo runs a
  three-doc spine (`LEDGER.md` + `docs/DESIGN-3D.md` + `docs/PARITY-ROADMAP.md`) and layout v2's
  ARCHITECTURE.md is not the convention this repo adopted; a second spine beside LEDGER/DESIGN-3D is
  the duplication this repo already refuses. The budget/mechanism truth this doc needs lives in
  DESIGN-3D §b/§i and is cited there, not restated.
- **Length note (exceeds the ~300 hygiene line, stated why):** one pointable build-depth artifact
  for one release, exactly as `docs/PARITY-ROADMAP.md` (368 L) stated; splitting it defeats the
  pointable-artifact DoD. Each feature is self-contained so a DA can gate a single pillar.

## 0. FINDINGS + STATED READINGS (read before the DA opens any pillar)

These are the ambiguities the brief left open; each is resolved with a literal reading, and the
two that are **owner/orchestrator decisions** are flagged, not silently chosen.

- **F-1 (P1, code-vs-roadmap divergence — the "16-roster" does not exist).** `weapons.gd:6`
  ships **6** IDS (`talon,ember,cleaver,halo,ward,spike`) and `levelup.gd:10-16` ships **5**
  PASSIVES — not the roadmap's "16 weapons / 15 passives by M1". Cause, from `LEDGER.md`:
  T-M1c shipped the 10 new weapons + 10 partner-passives as **art only, "NO scene/table wiring
  (later cards…)"**; T-M1d noted "16-weapon IDS rides the M1 weapon cards"; and
  `evolutions.gd:12-15` states outright that `try_evolve` "never matches a base id the pool cannot
  offer". **Consequence, VERIFIED:** the 10-row `evolutions.gd` TABLE (`evolutions.gd:25-36`,
  ids `bone-whip…doom-sigil`) references base weapons that are **not in the level-up pool** — so
  M1's evolution feature is **runtime-dead** today (it only ever fires in sim legs via a
  DECLARED-PIN loadout, `sim_evolve.gd:114-130`, never in play). The pin
  `tests/test_biome_numbers.py:231` still asserts the verbatim **6-ID** IDS regex.
  **Reading (flagged for orchestrator/owner):** the four pillars of this spec do NOT re-scope the
  deferred M1 features 6/7. Pillars A/B/C and Union 1 build on the 6-weapons code as-is. Only
  **Union 2** rides the 16-roster; it carries an explicit prerequisite card `T-M1h-ROSTER`
  (§wave map) that lands the deferred wiring. **Recommendation:** the M2 wave should OPEN by
  absorbing `T-M1h-ROSTER`, because leaving it deferred keeps `evolutions.gd` dead code and blocks
  Union 2. This is the closing seat's decision to make; the spec flags it, it does not assume it.
- **F-2 (v1 reference has nothing to port).** The brief pointed at `/home/claudecode/Games/vampire_survivor`
  (the 2D v1) as the "endless + gem-merge" reference and asked to re-grep. **Result: v1 implements
  NEITHER.** Its `game_state.gd:7` is `WIN_TIME := 600.0` with a terminal win gate at
  `main.gd:134` (`if game.time >= GameState.WIN_TIME`), and its gems collect individually
  (`world.gd:144-147`, one `add_xp` per gem, no merge/threshold). **Reading:** there is no v1 code
  to port "STRUCTURE+FEEL" from; both pillars are greenfield built on hollow-dawn's EXISTING M1
  funnels (spawn loop, drop/collect funnels, save funnel). This is stated so no later reader
  invents a v1 merge to copy. (DA c1 attack F independently confirmed this.)
- **F-3 (Contract B is frozen — 12 fields).** `game_state.gd:121-138` is the exact snapshot the
  bridge ships every physics tick; the phase enum `menu|playing|levelup|gameover|win` is frozen
  (`main.gd`, DA c1 A-2). **Reading:** endless/cycle/chest-tier/gem-merge/union state all live
  OUTSIDE the run snapshot — in the frozen level-up phase, the run-end panel, and the Dawn Well
  save. No pillar adds a snapshot field or a phase value. Any future field is an owner-visible
  contract change, out of this spec. **rev-2 value-domain note (DA c1 P4-6):** the 12-field SHAPE
  stays byte-stable, but the `weapons` field's **value domain** widens — union result ids flow into
  `window.__vsSnapshot.weapons[].id` (via `game_state.gd:122-124,136` + `main.gd:154`). No snapshot
  change, no bridge change; flagged so the web shell is not surprised by a previously-unseen id.
- **F-4 (Endless is a run MODE, not a phase; default-off is byte-stable).** Endless is a
  `DawnWell.flags["endless"]` toggle consumed at `start_run()` through the ONE `_dawnwell → start`
  hand-in seam (`main.gd:224`, the meta_ranks pattern). With the flag off (every existing dump and
  the current `sim_headless`/`sim_s8` fixtures) the `t>=WIN_TIME` path stays byte-identical to M1 —
  the same "empty input ⇒ unchanged output" guarantee `meta_ranks` already gives
  (`game_state.gd:55-76`).

## 1. PILLAR A — ENDLESS MODE (post-limit wave cycles)

**Shape ref:** VS-FEATURES §S5 "Endless mode rules" (~465–467, VERIFIED): reaching the limit
restarts the waves ("completing a cycle"); "enemies gain +100% of their base HP, spawn frequency and
quantity +50%, damage +25%"; and the limit's Reaper ends a *non-endless* run. Those are THEIR
numbers; ours are below and bounded by named caps.

**Reuse (zero new subsystem):** one run-time clock (`game.time`, `main.gd:181`); the single spawn
loop and its HP ramp (`world.gd:84-122`); the single contact-damage pipeline
(`main.gd:197-198` → `game_state.gd:47` `damage_taken`, ward reduction kept); the chest drop +
`collect_pickups` funnel (`world.gd:157-210`); the frozen `pending_levels → _enter_levelup` reward
card (`main.gd:209-210`); the `_meta_changed` save funnel (`main.gd:290-291`).

### A.1 Mechanism (our values)
- **Cycle index** `cycle = int(game.time // GameState.WIN_TIME)` — WIN_TIME (900 s,
  `game_state.gd:7`) is reused as the cycle boundary; **no new clock**. At `cycle` crossing, the
  existing win branch (`main.gd:206`) does NOT call `_end_run("win")` when endless is on; it does a
  **cycle clear** and keeps phase `playing`. Non-endless (flag off) keeps the byte-stable win.
- **Cycle-local ramp ("waves restart" — rev-2 P3-1 reading):** within-cycle minute
  `m_c = (game.time - cycle*WIN_TIME)/60` drives the existing per-minute HP term `world.gd:88`
  (`1 + 0.22*m_c`) and the spawn-rate term `world.gd:118` (`1 + 1.3*m_c`). "Waves restart" means the
  **per-minute HP/qty RAMP restarts** at each boundary — NOT the enemy composition: biome bands +
  `GATES` (`world.gd:45`, `render.gd` `BIOMES`) are keyed to absolute `game.time` and `biome_at`
  **saturates on the hardest band** (`render.gd:76`, band 3 `t=6.0`, no band 4) for all `t≥720`.
  So a cycle-2 start spawns the already-hardest composition immediately; the cycle boundary resets
  the RAMP, not the roster. The ceilings `ALIVE_CAP 400` pause (`world.gd:114`) and the
  `minf(12.0, …)` rate ceiling stay **unchanged**.
- **Cycle scaling (three OUR consts, each with its "cannot explode" cap):**
  - HP: `HP_CYC(k) = min(1 + 0.75*k, 6.0)` applied as
    `hp := roundf(def.hp * (1 + 0.22*m_c) * HP_CYC(cycle))`, then a single clamp
    `HP_EFFECTIVE_MULT_CAP := 18.0` (`hp := min(hp, def.hp*18)`). **rev-2 binding point (P2-2):**
    the clamp is the **deep-cycle asymptote guard, NOT a cycle-3 effect** — first binds at cycle 5
    (near cycle-end, `m_c ≥ 12.7`: `HP_CYC(5)=4.75 × (1+0.22·12.7)≈18`); cycles ≤4 never clamp (their
    max product is `4.3×4.0 = 17.2 < 18`). Enemy hp therefore never exceeds `def.hp*18` at any depth
    — that is the "cannot explode" property, distinct from "win every cycle" (§A.1 survival note).
  - Quantity: `QTY_CYC(k) = min(1 + 0.25*k, 2.0)`; effective rate
    `minf(12.0, (1 + 1.3*m_c) * QTY_CYC(cycle))`. **Cannot explode = the two existing ceilings
    (12/s and ALIVE_CAP 400) are untouched** — quantity growth saturates against them.
  - Damage (the real explosion risk): `DMG_CYC(k) = min(1 + 0.20*k, 2.5)` on enemy contact
    (`e.dmg * DMG_CYC(cycle)`), then clamped by **`MAX_CONTACT_DMG := 20.0`** at the contact site
    (`main.gd:198`, before `damage_taken`). **rev-2 provenance (P2-1):** 20.0 is a REACHABLE ceiling
    derived from the max base contact damage **12** (`world.gd:35`, the Warden) — chosen BELOW
    `12 × DMG_CYC-cap(2.5) = 30` so it actually **binds**: the boss class (warden 12, deacon 11,
    knight 10) clamps from `DMG_CYC ≥ 1.7` (cycle ≥ 4, e.g. `12 × 2.0 = 24 > 20`), while normal
    enemies never reach it (worst normal, pale-wight `9 × 2.5 = 22.5`, only touches at cycle ≥7;
    most never do) — so the cap is a **boss/miniboss bound**, red-tripable. `IFRAMES 0.5`
    (`game_state.gd:6`) bounds contact DPS. **We deliberately do NOT clone their "incoming-damage
    cap reduced by 1" spiral** (S5 ~467); a capped multiplier + an absolute per-hit cap is the
    honest bounded analogue.
- **Cycle-clear reward (rides the drop + reward funnels):** each cycle clear drops **one chest via
  `CHEST_TIER_BY_SOURCE`'s cycle-clear entry** and grants one reward card `game.pending_levels += 1`
  (frozen level-up seam). **rev-2 P1 unification:** §A.1 does NOT hardcode a tier — the tier is
  whatever `CHEST_TIER_BY_SOURCE` (§B.1, the single source of truth) maps the cycle-clear source to,
  which is **`dawn` (tier III)**. That choice is an **OUR number** from the §B.1 tier table (the
  cycle clear is the run's biggest recurring milestone → the richest tier, 3 items); A-E4 asserts
  tier III and B-T1 asserts cycle-clear→dawn, so both ACCEPT rows now execute the SAME behaviour
  from the SAME map row. Run gold cashout at run end unchanged (`main.gd:256`).
- **Survival-sim intent + the growth channel (rev-2 P2-3 — fixes the throughput/fun break).**
  Endless here is a **survival-sim in VS semantics — there is no "win": the run continues until the
  player dies, and score = survival depth (this is exactly the VS rule the spec cites, S5 ~467:
  waves restart each cycle "allowing the stage to continue indefinitely"; a deeper run is the goal,
  not a cleared run).** The DoD is therefore **survival to cycle ≥ 2** (roadmap M2 #1 ACCEPT: "sim
  endless leg ≥ 2 cycles"), NOT clearing every cycle. The reviewer's throughput finding is correct
  and accepted: post-cap DPS is flat, the required-DPS-per-spawn ratio `HP_CYC/QTY` rises
  `1.0 → 3.0`, and **there is NO in-run player-growth row** (weapon/passive pools exhaust, leaving
  only `bonus_card` +25 g/+10 hp, `levelup.gd:57,82`), so a single cold run reaches a hard wall.
  The frontier is extended **ACROSS runs** by the **shipped Dawn Well meta** (`powerups.gd`,
  `MAX_RANK 5` × the 4 maxHp ranks → up to **+200 hp** at full ranks, `game_state.gd:63`
  `maxHp = 100 + Σ·10`; xp ranks re-cap faster; gold ranks compound) — the VS-faithful "grind
  PowerUps to go deeper" loop, no new mechanism. **Within-run deep-cycle DPS growth is explicitly
  NOT in M2**: that is the roadmap's **M4 `limit-break-lite`** (their Limit Break, VS-FEATURES S5
  ~473 — the canonical "post-cap keeps growing" mechanic, cited and reserved out of scope). M2
  therefore claims **a few extra survival cycles per run, extended across runs by the well**, and
  nothing more.
- **Reaper analogue at the non-endless limit — DEFERRED, not excluded (rev-2 P3-8).** The roadmap
  names it as an M2 #1 sub-feature ("Reaper analogue at the non-endless limit",
  `PARITY-ROADMAP.md:221-223`); roadmap-is-law, and there is **no owner artifact retiring it**, so
  it is tracked as a **follow-on card `T-M2r-REAPER`** (§8.3) rather than silently dropped. The
  non-endless limit stays the plain `win` screen *within this spec's four pillars*; the Reaper
  pursuer is a named deferred card, not a design-time exclusion.

### A.2 Files
`game_state.gd` (add `var endless := false`, `var cycle := 0`; reset both in `start_run()` at
`game_state.gd:55-76`; consume `meta_ranks`-style from the flag passed in `_start_game`),
`main.gd:206` (endless branch: cycle-clear vs end_run) + `_start_game` hand-in (`main.gd:224`),
`world.gd:84-122` (cycle scaling + the three capped consts; contact `MAX_CONTACT_DMG` in
`main.gd`), `save.gd` (add `best_cycle` field, §A.3), **`hud_3d.gd`** (rev-2 P3-3: A-E7's cycle text
is not drawn by `game_state`/`main`/`world` — this is where it lands), NEW `godot/sim/sim_endless.gd`
(dump leg on the per-leg `HD3D_<LEG>_DUMP` + `HD3D_SEED` channel — the `sim_evolve.gd:59` /
`sim_budget.gd:53` precedent; **rev-2 P4-3:** the shared `HD3D_OUT` name is only `sim_s8`'s,
`sim_s8.gd:54` — so the new leg declares its own env, **not** a new capture mechanism), NEW
`tests/test_endless.py` + `tests/test_save.py` best-cycle rows.

### A.3 Persistence (best-cycle row, reuse save.gd rules)
Add `best_cycle:int` to `user://dawnwell.json` (`save.gd` `as_data()` :98-99 + a read at
`load_save` :46-51). **No `VERSION` bump** — `save.gd:46-51` migrates field-by-field and defaults a
missing field, so an older save keeps working and a fresh save reads `0`. Update
`best_cycle = max(best_cycle, cycle)` at `_end_run` (both `gameover` and endless clear) through the
ONE `_meta_changed` funnel (`main.gd:290`). Atomic temp+rename write path unchanged (`save.gd:58-70`).

### A.4 ACCEPT (rows → existing channels; planted-red named; no new capture)
| # | observable | seam (the ONE existing channel) | red |
|---|---|---|---|
| A-E1 | endless leg reaches **cycle 2** (dump `cycle_clear` rows at t≈900, ≈1800; phase stays `playing`) | `sim_headless`/`sim_s8` dump, WIN_TIME-relative (`LEDGER` T-M1d) | flag off ⇒ `t≥900` dump ends `kind="win"` (RED if it keeps running) |
| A-E2 | per-cycle scaling rows k=1,2,3: hp-mult/qty-mult/dmg-mult **and a clamp-binding row** | `sim_endless` dump; read off `world.gd:84-122`, no new RNG | set `HP_EFFECTIVE_MULT_CAP` **low (e.g. 6)** so a spawn clamps ⇒ the clamp row goes RED (rev-2 P2-2: this, not cycle-3, is how the HP cap proves it can fail) |
| A-E3 | **caps-bind-at-cycle-5 leg (rev-2 P2-2):** a DECLARED-PIN scaling-EVAL leg (`sim_budget`/`sim_caps` pin channel — NOT a survival leg): pin `cycle=5` at the binding `m_c`, assert BOTH the HP clamp (`def.hp·18`) AND the contact clamp (`20.0` on the boss class) bind | `sim_budget`/`sim_caps` DECLARED-pin (`sim_budget.gd:92`, `sim_boss.gd:292`) — pins the cycle counter + clock, reads the scaling fn | drop either clamp ⇒ RED (at cycle 5 both would otherwise be exceeded) |
| A-E4 | cycle clear drops **a tier-`dawn` (III) chest** (per `CHEST_TIER_BY_SOURCE`) and grants one reward card (`pending_levels` +1) | real `kill_enemy`→`collect_pickups` funnel + level-up seam (`sim_evolve.gd:124-141`) | a non-dawn tier, or reward-count 0 ⇒ RED (rev-2 P1: asserts the SAME tier as B-T1) |
| A-E5 | `dawnwell.best_cycle`: run ending at cycle 3 → `3`; older save (no field) → `0`; never decreases | `save_probe.gd` legs + `tests/test_save.py` roundtrip | corrupt save ⇒ `SAVE_LOAD_FAIL` marker (existing leg stays RED-able) |
| A-E6 | endless **off** ⇒ win dump byte-identical to a NEW committed fixture `tests/fixtures/endless-m2.jsonl`; cycle/endless **absent from the 12-field snapshot** | `sim_headless`/`s8_acceptance.py`; `snapshot_json` 12-field pin | add a snapshot field ⇒ the 12-field pin RED (rev-2 P4-4: s8 dumps live in `.tmp`, so this row lands a committed fixture like §B does) |
| **A-E8** | **cycle-REACHABILITY (rev-2 P2-3):** a sim leg with the **S8-win-leg DECLARED HP-pin** (`game.hp` pinned to max, `sim_s8.gd` `HD3D_HP_PIN`, `sim_boss` kill-leg precedent) **REACHES cycle 2** — dump `cycle_clear` ×2 + `best_cycle=2`, asserting the roadmap M2 #1 "≥2 cycles" DoD. Driver survival is a **scripted-driver artifact** (the s8 header records seeds dying at t 375–467 under the 12/s wall even though the run is playable), NOT a game-balance claim; un-pinned survival DEPTH is explicitly NOT claimed here (it is the between-run Dawn Well frontier, §A.1) | `sim_endless` HP-pinned survival leg (the s8 `HD3D_HP_PIN` declared deviation) | `best_cycle < 2` ⇒ RED (the boundary itself was not reached/cleared) |
| A-E7 (pixel) | cycle HUD text reads on the `playing` frame | existing HUD pixel pattern (`LEDGER` T-S8, crop ≥200 vs hidden-UI baseline; `tools/s8_acceptance.py`) | blank HUD crop ⇒ RED |

## 2. PILLAR B — CHEST TIERS

**Shape ref:** VS-FEATURES §S8 "Treasure Chests" (~651–656): tiers Bronze/Silver/Gold, contents
"level up a carried weapon/passive + a random amount of gold", first-six fixed `1-1-3-1-1-5`. The
**fixed sequence is theirs and is NOT cloned** (§8); we use weighted rolls and OUR item counts.

**Reuse:** the single chest drop array (`world.gd:51`, `chests.append` :170-173), the single
16 px open funnel (`world.gd:201-206`, already the 4th pickup kind — pin `test_biome_numbers.py:149`
asserts `< 16.0` count == 4), `EvolutionSystem.try_evolve` at open (`world.gd:205`), the frozen
reward seam `pending_levels` (`main.gd:209`), the pool + card + gold fallback
`build_pool`/`apply_offer`/`bonus_card` (`levelup.gd:19,70,57`), and `credit_gold`
(`game_state.gd:111`). The chest stays an **icon billboard in the existing `pickup_viz` chest
MultiMesh slot** (`LEDGER` T-M1e, `pickup_viz.gd`) — tier is per-instance scale/tint, **no new MM
class**.

### B.1 Mechanism (our table)
Chest dicts gain a `tier` key at the drop site (`world.gd:170-173`); the source→tier map is
**`CHEST_TIER_BY_SOURCE`** (a `world.gd` const, OUR mapping) and is the **single source of truth for
the cycle-clear tier** (§A.1 defers to it — the P1 fix): `miniboss → "ember"`, `boss(warden) →
"warden"`, **`endless-cycle → "dawn"`, `event → "dawn"`**. Contents (OUR counts, **not** their
`1-1-3-1-1-5`):

| tier | item_count | pick weights (weapon/passive/gold) | gold roll (g) |
|---|---|---|---|
| ember (I) | 1 | 50 / 30 / 20 | 5–15 |
| warden (II) | 2 | 40 / 40 / 20 | 15–40 |
| dawn (III) | 3 | 35 / 45 / 20 | 40–90 |

Open order at the ONE chest-open funnel (`world.gd:201-206`): **`try_union` → else `try_evolve` →
tier cards → gold.** Tier cards raise `pending_levels += item_count` (rides the frozen level-up
seam; each is one 3-card offer, so a bigger chest = more offers). The gold line runs
`game.credit_gold(roll)`. A **new module `chest_rewards.gd`** owns the tier table + a
seed-pinned weighted chooser (`RandomNumberGenerator`, the pattern already at `game_state.gd:141-147`)
that resolves each pick by delegating to `build_pool`/`apply_offer`/`bonus_card` — **the only new
rule entry; every mechanic it grants is an existing one.** Seed-pinned ⇒ byte-stable dump (their
fixed-sequence behaviour is *replaced* by a deterministic weighted roll, not copied).

**rev-2 source-map readings (P3/P4 folds):**
- **`endless-cycle` is a declared divergence (P4-2):** the roadmap M2 #2 source list is
  "miniboss/boss/event" (`PARITY-ROADMAP.md:224`); this pillar adds **`endless-cycle`** as a fourth
  chest source (the cycle clear, §A.1). Declared divergence, OUR reading.
- **`event` is forward-declared (P4-1):** the event-wave is an EXCLUDED pillar (§8.5), so the
  `event → "dawn"` row is **reserved, not live** — the chest source cannot fire until event-waves
  exist. Named so no build card reads `event` as a present drop path.
- **boss/miniboss entries apply CYCLE 1 only (P3-2):** the boss + miniboss latches fire **once
  ever** (`world.gd:53-54,106-112` — `boss_spawned`/`minibosses_spawned` are one-shot), so cycles
  **≥ 2 spawn NO boss and NO miniboss**; their chests come only from the cycle clear (`dawn`). A
  long endless run sees no `hollow-deacon` past the 780 s mark. Named consequence, not a gap.

### B.2 Files
`world.gd` (chest dict `tier` + `CHEST_TIER_BY_SOURCE` + the open call), NEW
`godot/scripts/chest_rewards.gd`, `pickup_viz.gd` (chest tier scale/tint, existing chest MM), NEW
`godot/sim/sim_chest_tiers.gd` dump leg, **reuse the existing `tools/chest_pixel_gate.py` +
`godot/sim/chest_capture.gd`** (rev-2 P3-4 — both SHIPPED in M1e at `475a480`; this card is NOT new
capture, it adds a **per-tier window** + a committed `tests/fixtures/chests-tiers-m2.jsonl`, mirroring
`chests-evolve-m1e.jsonl`), NEW `tests/test_chests_tiers.py`. `test_biome_numbers.py:149`
(`< 16.0` count == 4) **stays 4** — a tier is not a new pickup kind (rides the chest funnel).

### B.3 ACCEPT
| # | observable | seam | red |
|---|---|---|---|
| B-T1 | `chest.tier` == source map: boss→warden, miniboss→ember, **cycle-clear/event→dawn** | real `kill_enemy` drop funnel dump (`sim_boss` chest-roll leg / `sim_evolve` drop shape) | a boss dropping ember, or the cycle-clear dropping a non-dawn ⇒ RED (rev-2 P1: same assertion as A-E4) |
| B-T2 | open grants exactly `item_count` offers (`pending_levels` +N) **and** a gold roll in the tier range | real `collect_pickups` open + `make_offer` count + `credit_gold` delta | tier I granting 2 ⇒ RED |
| B-T3 | weighted pick sequence is **seed-deterministic** (byte-stable fixture) | `HD3D_SEED` + `tests/fixtures/chests-tiers-m2.jsonl` (`chests-evolve-m1e.jsonl` precedent) | shuffle seed un-pinned ⇒ dump unstable ⇒ gate RED |
| B-T4 | evolve/union precedence: an eligible chest does the transform **then** the tier cards | `sim_evolve` precedence + Pillar D union precedence | two transforms in one chest ⇒ RED (violates one-transform-per-chest) |
| B-T5 (pixel) | tier II / tier III chest renders, non-bg ≥ 200 vs empty baseline | `tools/chest_pixel_gate.py` (tick-deterministic `chest_capture.gd`; per-tier window) | baseline-vs-baseline copy ⇒ 0 px ⇒ RED (planted) |

## 3. PILLAR C — GEM-MERGE

**Shape ref:** VS-FEATURES §S8 "XP gems" (~644–645, VERIFIED): ">400 gems on the ground ⇒ no more
drop, XP accumulates into a single red gem"; gem value tiers by colour. OUR threshold and OUR merge
granularity below; we **never lose XP** (their wording could drop drops; ours folds every gem's XP
into the bulk gem — see the invariant).

**Reuse:** the gems array + its 70% drop (`world.gd:164`) + the 16 px collect + `add_xp`
(`world.gd:179-183`) + the magnetise path (`world.gd:136-137`); `pickup_viz.gd`'s existing gem
MultiMesh (T-S18) — a bulk gem is a per-instance larger draw, **no new capture or MM class**.

### C.1 Mechanism (our rule + threshold)
- `GEM_MERGE_THRESHOLD := 200` (our value — a draw-budget tie, well under the horde),
  `GEM_MERGE_BATCH := 100` (our value).
- **Field-merge rule** (`world.gd`, in the entity/collect update, after a drop): when
  `gems.size() >= GEM_MERGE_THRESHOLD`, remove the oldest `GEM_MERGE_BATCH` gems and push ONE bulk
  gem `{x: centroid, y: centroid, xp: SUM(merged.xp), big: true}`. The array is then bounded
  `≤ GEM_MERGE_THRESHOLD` — a **representation change, bounded**, not a spawn of a new object class.
- **XP-neutrality — restated correctly (rev-2 P2-4; the "byte-identical" wording was FALSE).** The
  invariant that holds **UNCONDITIONALLY** is the **gem-layer XP-sum conservation**: merging replaces
  a set of gems whose `xp` fields sum to `S` with ONE gem whose `xp = S`, so the array's
  `Σ world.gems[i].xp` is **unchanged across the merge event** — no XP is created or lost by
  merging, regardless of multiplier. **What does NOT hold unconditionally** is end-to-end
  `game.xp`/level **byte-equality** merge-on vs merge-off: `add_xp` multiplies each call by
  `m = (1 + 0.15*passives.insight) * meta_xp_mult` (`game_state.gd:98`), and IEEE
  `Σ(xp_i * m_i) ≠ (Σ xp_i) * m` when `m` is not constant (it changes as `insight` stacks across the
  collection window, and the bulk collect applies one `m` at a different instant than per-gem
  collects would) — **and even at constant `m ≠ 1.0` the float sums can differ.** So the honest
  claim is: *the XP VALUE POOL is conserved at the gem layer (unconditional); the final XP/level
  trajectory is byte-equal ONLY under a fixed multiplier `m = 1.0` (insight-0, meta-1.0 — the
  committed-dump default), and that is exactly what the sim leg pins.* The DA c1 attack E is
  accepted in full; the original wording is corrected, not defended.
- **Visual (rev-2 P4-5):** `pickup_viz.gd` draws `big:true` gems LARGER via the existing
  `scale_instance` — **and brighter via a per-instance COLOR**, which means the gem MultiMesh moves
  from its current **transform-only format** (`pickup_viz.gd:158-163`) to a **color-instance
  format**. That is **still ONE MM class** (draw budget unchanged), but the format change is named
  here, not glossed. The bulk gem rides the `gems` array ⇒ `test_biome_numbers.py:149` pickup-funnel
  count stays 4.

### C.2 Files
`world.gd` (merge rule + the two consts in the gems handling), `pickup_viz.gd` (bulk-gem scale +
**gem MM transform→color instance format**, existing gem MM class), NEW `godot/sim/sim_gems.gd`
dump leg, NEW `tests/test_gem_merge.py`. (No new pickup kind ⇒ `test_biome_numbers.py:149` untouched.)

### C.3 ACCEPT
| # | observable | seam | red |
|---|---|---|---|
| C-G1 | threshold boundary **cap±1**: 199→no merge (count held), 200→one bulk gem (count drops), 201→bounded | `sim_gems` DECLARED-pin gem array (`sim_caps.gd:88` synthetic-slot pattern) | merge at 199 (or none at 200) ⇒ RED |
| **C-G2** | **XP-neutrality, TWO legs (rev-2 P2-4):** (a) **unconditional** — the gem-array `Σxp` is conserved across the merge (pre-merge Σ == post-merge Σ incl the bulk gem's `xp=S`), independent of any multiplier; (b) **byte-equal `game.xp`/level trajectory merge-on vs merge-off, DECLARED-PINNED to `insight=0` + `meta_xp_mult=1.0`** (m=1.0), stated so | (a) `sim_gems` gem-array Σxp dump row; (b) `sim_headless`/`sim_gems` level/xp trace under the pinned multiplier | (a) a merge that drops one gem's `xp` ⇒ Σ drifts ⇒ RED (this is the "cannot lose XP" row); (b) run (b) at `m≠1.0` and the byte-equal would flip — the leg pins `m=1.0` to be honest |
| C-G3 | gem array never exceeds `GEM_MERGE_THRESHOLD` under a spam leg | `sim_gems` dump gem-count row | unbounded growth ⇒ RED |
| C-G4 (pixel) | bulk gem renders larger + brighter vs baseline with bulk cleared | `tools/upgrades_visual_probe.py` + `upgrades_visual_capture.gd` (tick-deterministic, S8 hidden-UI pattern) | bulk suppressed ⇒ crop ≤ floor ⇒ RED |

## 4. PILLAR D — TWO UNIONS

**Shape ref:** VS-FEATURES §S3 (~354–363) + §S1.3 Unions (~266–276, VERIFIED): "two max-level
weapons … combined in a chest", "only one weapon can be evolved per chest". OUR names, OUR gate and
passive rule. (Their unions sometimes need a stage-only item; **we use a carried passive** — our rule.)

**Reuse:** the ONE chest-open funnel (`world.gd:205`, where `try_evolve` already fires); the
evolution rule pattern (`evolutions.gd:46-57`: MAX check, `.get(partner,0)` carried check,
in-slot replace, `cd` reset); `WeaponSystem.MAX_LEVEL` (8, `weapons.gd:7`); existing FX classes.
**Union precedence > evolution** at the chest-open site (one weapon-transform per chest — the stated
reading at `evolutions.gd:22-24`). NEW module `union.gd` (`UnionSystem`, mirrors `evolutions.gd`'s
"separate table, never enter `WeaponSystem.META`" choice, DA c3 C-2 — so `test_card_icons.py` and the
16/32 icon math stay green; a union weapon's icon resolves via the `icon-<id>.png` naming convention
HUD fallback, `evolutions.gd:11-13`).

### D.1 Recipe table (rank req = both bases at `MAX_LEVEL`; passive carried ≥1; chest at
`t ≥ GATE_T` — **rev-2 P4-7: `union.gd` REFERENCES `EvolutionSystem.GATE_T` (`evolutions.gd:19`),
it is NOT a second literal `600`**)

| union (OUR name) | base A (max) | base B (max) | passive | result behaviour (reuses) | base exists in code today? |
|---|---|---|---|---|---|
| **Requiem Toll** (`requiem-toll`) | Cinder Halo (`halo`) | Grave Spike (`spike`) | Insight (`insight`) | orbiting homing burst-cinders — **reuses `halos` + `bursts`** FX | **YES / YES** — `halo`, `spike` in `weapons.gd:6`; `insight` in `levelup.gd:15` → **buildable now, zero roster dependency** |
| **Dirge Eternal** (`dirge-eternal`) | Censer of Hours (`censer-of-hours`) | Rot Water (`rot-water`) | Loadstone (`loadstone`) | lingering orbiting zone — **reuses the zones MM + `halos`** | **NO / NO** — only referenced in `evolutions.gd:30-31` TABLE; not in `weapons.gd:6`/`levelup.gd:10-16`; `loadstone` not in PASSIVES → **depends on `T-M1h-ROSTER`** (their art already shipped in T-M1c `icons-batch-m1c.tsv`; the gap is pool wiring, not assets) |

A union **removes both base weapons and writes the union weapon in-slot** (net slot count −1,
level reset to 1, `cd` 0) — consumes a slot, never adds a 7th (feature 3 "never add a 7th",
`evolutions.gd` header). The `_fire` match (`weapons.gd:103-168`) gains two cases that are
**compositions of existing branches** (Requiem Toll = halo-orbit ∩ spike-burst; Dirge Eternal =
zone ∩ orbit); the single damage entry `_hit` (`weapons.gd:78`) is unchanged.

**rev-2 union-base RESERVE rule (P3-6 — cross-time foreclosure).** Union bases overlap evolution
bases: `rot-water` is BOTH a `dirge-eternal` base AND an `evolutions.gd` evolution base
(`rot-water → the-sluice`, `evolutions.gd:31`). So opening a chest with `rot-water` MAX + `loadstone`
carried but `censer-of-hours` NOT yet MAX would `try_evolve` it to `the-sluice` and **permanently
foreclose `dirge-eternal` cross-time**. Rule (stated; build card implements in `union.gd`): at the
chest, `try_union` runs BEFORE `try_evolve` (D-U3, same-chest), **AND `try_evolve` MUST skip a TABLE
weapon that is a union base while its union partner is not yet `MAX`** — the union bases are
"reserved" until the union is unreachable (partner gone/changed). Same for `censer-of-hours`
(`eternal-matins`). This keeps both unions reachable.

### D.2 Files
NEW `godot/scripts/union.gd` (TABLE + `try_union(game)` + the reserve rule), `world.gd:205` (call
`try_union` before `try_evolve`), `weapons.gd` (`_fire` cases for the two union ids + behaviour), NEW
`godot/sim/sim_union.gd` dump leg, NEW `tests/test_unions.py`, asset rows (2 union icons + 2 union
meshes, §6). **`weapons.gd` is shared with `T-M1h-ROSTER`** → sequenced in the wave map.

### D.3 ACCEPT
| # | observable | seam | red |
|---|---|---|---|
| D-U1 | union TABLE pinned + each base id ∈ `WeaponSystem.IDS` (union1 passes; union2 flagged with the `T-M1h-ROSTER` dependency, not silently skipped) | NEW `tests/test_unions.py` (a `test_chests_evolve.py`-style source pin) | a base id silently absent ⇒ pin RED (forces the dependency to be named) |
| D-U2 | scripted: two MAX bases + passive → chest at gate → union in-slot, both bases gone, `weapons.size()` −1, `cd` 0 | `sim_union` real open funnel + DECLARED-PIN loadout (`sim_boss.gd:292` / `sim_budget.gd:92`) | one base at `MAX_LEVEL-1` ⇒ does NOT unite (RED side) |
| D-U3 | precedence: state eligible for BOTH union and evolution → the chest performs the **union**, not the evolution | `sim_evolve` one-per-chest pattern, extended | evolution steals the chest ⇒ RED |
| D-U4 | passive requirement: missing/non-carried passive → does NOT unite (both sides) | `sim_evolve` wrong-passive leg shape | unites with 0 passive ⇒ RED |
| D-U5 | **reserve rule (rev-2 P3-6):** `rot-water` MAX + `loadstone`, partner `censer-of-hours` NOT maxed, chest open ⇒ `try_evolve` does NOT evolve `rot-water` (union base reserved) — `dirge-eternal` stays reachable | `sim_union` DECLARED-pin leg | `rot-water` evolves under a reserved partner ⇒ RED |
| D-U6 (budget) | union FX draws ≤ cap under the §2 WORST-CASE LOADOUT (union classes reused) | `sim_budget` re-tally (`sim_budget.gd`, `test_art_integration.py:42` DRAWS_PLANNED pin) | a new MM class un-retallied ⇒ budget pin RED |
| D-U7 (pixel) | union icon renders on a level-up/end card, no-blank | `cards_capture.gd` (existing card capture); union ids ride `icon-<id>.png` naming (NOT `WeaponSystem.META`) so `test_card_icons.py:29/76/125` stay green | blank union icon ⇒ no-blank rule RED |

## 5. WAVE MAP (cards a build wave files; dependency order; SAME-FILE rule)

**The mechanism-monogamy consequence:** the whole simulation lives in **one `world.gd`** plus
`main.gd`/`game_state.gd`, so **all four pillars edit `world.gd`** — under the fleet same-file rule
they are **sequential on that file**, even though only Union 2 has a data dependency. The one
genuinely parallel track is the asset batch (separate `assets/` files + manifest).

Cards (parent MC 11219 → build parent, then these children):

| card | one-line scope | files touched | depends on | can run parallel with |
|---|---|---|---|---|
| `T-M1h-ROSTER` *(prereq — orchestrator decision, F-1)* | wire the 10 new weapons (`weapons.gd` IDS/META/`_fire`) + 10 partner passives (`levelup.gd` PASSIVES + `game_state.gd` init); retire+replace `test_biome_numbers.py:231` 6-ID pin + `test_card_icons.py:29/76/112/113` | weapons.gd, levelup.gd, game_state.gd, tests | — | **asset batch ONLY** (shares `game_state.gd` w/ ENDLESS and `weapons.gd` w/ UNIONS — rev-2 P2-5) |
| `T-M2e-ENDLESS` | endless flag+cycle clear, capped scaling, best_cycle, cycle HUD | game_state.gd, main.gd, world.gd, save.gd, **hud_3d.gd**, sim_endless.gd, tests | — | **asset batch ONLY** (shares `world.gd` w/ every other card — rev-2 P2-5) |
| `T-M2g-GEM-MERGE` | merge rule + threshold + bulk gem viz (gem MM color format) | world.gd, pickup_viz.gd, sim_gems.gd, tests | — | asset batch ONLY (shares `world.gd` w/ ENDLESS+CHEST, `pickup_viz.gd` w/ CHEST) |
| `T-M2t-CHEST-TIERS` | chest `tier` + `chest_rewards.gd` weighted picks + tier icons | world.gd, chest_rewards.gd, pickup_viz.gd, chest fixtures, tests | — | asset batch ONLY (shares `world.gd`+`pickup_viz.gd`) |
| `T-M2u-UNIONS` | `union.gd` + `try_union` at open + 2 union `_fire`/icons/meshes + reserve rule | world.gd, weapons.gd, union.gd, assets, tests | Union1: —; **Union2: `T-M1h-ROSTER`** | (world.gd ⇒ after chest-tiers; weapons.gd ⇒ after ROSTER) |
| `T-M2a-ASSETS` | 3090 imagegen+TRELLIS batch (§6), `assets/` + manifest only | assets/, `tools/vm100/icons-batch-m2*.tsv` | — | **everything** |

**Execution order (ONE serial spine + ONE parallel asset track — rev-2 P2-5 applied).** The
same-file graph is: `world.gd` ← ENDLESS, GEM-MERGE, CHEST-TIERS, UNIONS; `game_state.gd` ← ROSTER,
ENDLESS; `weapons.gd` ← ROSTER, UNIONS; `pickup_viz.gd` ← GEM-MERGE, CHEST-TIERS. Every pair shares
≥1 file, so the whole feature spine is **serial** — **no two build cards are parallel**; only the
asset batch (disjoint `assets/` files) runs concurrently. Order:
`T-M1h-ROSTER` *(if absorbed)* → `T-M2e-ENDLESS` → `T-M2g-GEM-MERGE` → `T-M2t-CHEST-TIERS` →
`T-M2u-UNIONS`; `T-M2a-ASSETS` runs on off-peak 3090 windows throughout. Chest-tiers precedes unions
so the chest-open funnel edit (`world.gd:205`) lands before Union's `try_union`-at-open edit.

**Doc-sync row (retired-claim doctrine, same commit as each card):** DESIGN-3D §b draw-plan note is
re-checked if a card adds an MM class; `LEDGER.md` gains each card's row in its closing commit; a
retired pin's name greps to zero.

## 6. ASSET BATCHES (the 3090 = vm100 RTX 3090; imagegen + TRELLIS, off-peak windows, drain_barrier + trap-close per the LEDGER GPU-window pattern)

Scoped to the **four pillars only**:

- **imagegen 2D icons — n = 5:** chest tier II, chest tier III, bulk gem, union `requiem-toll`,
  union `dirge-eternal` (512² RGBA transparent, DESIGN-3D §j style family, provenance = embedded PNG
  `tEXt` per the `tools/vm100/icons-batch-m1c.tsv` convention — **no new provenance file**, and
  gate `tools/vm100/icon_gate.py`).
- **TRELLIS 3D meshes — n = 2:** `requiem-toll` + `dirge-eternal` static weapon props (budget
  1500 tri/row, prop row; `tools/vm100/aspect_gate.py` @ 1.42, prop-turntable VISUAL gate per the
  LEDGER §M1c2 finding that automated gates no-op non-watertight props).
- **Re-roll reserve (roadmap convention ~30% of rows held):** **+2 icons, +1 mesh** (LEDGER yield
  history: T-S1a 10/11, T-M1c 6/10 batch-a, T-M1c2 remasters — first-pass acceptance < 100%).
- **Divergence from roadmap §M2-assets (26 icons / 12 meshes), stated:** that count assumed the
  "8 more weapons + 5 more passives" expansion (roadmap M2 #3), which is **not a pillar of this
  spec**. Those weapons' icons/meshes already shipped in T-M1c. If `T-M1h-ROSTER` is absorbed it
  wires existing art and adds **no** new asset rows. The pillar-only batch is therefore genuinely
  **5 icons + 2 meshes** (+3 reserve).

## 7. BUDGET (re-derived under the §2 WORST-CASE LOADOUT, incl unions)

Named loadout (roadmap §2): six slots at MAX/evolved + the six evolution partners carried.
**Current measured draw** on that channel = **27 / plan 40 / hard 60** (LEDGER T-M1g `sim_budget`;
pins `test_art_integration.py:42 DRAWS_PLANNED = 40`, `:21-22` ≤ 60 hard, `ALIVE_TARGET 400`).

- **Pillar additions to draw CLASSES = 0.** Chest tiers reuse the chest MultiMesh (per-instance
  tier); bulk gem reuses the gem MultiMesh (per-instance scale/tint — a format change, still ONE
  class, §C.1); union FX reuse `halos` + `bursts` (Requiem Toll) and the zones MultiMesh + `halos`
  (Dirge Eternal) — the zones MM is the ONE new mechanism already counted in the roadmap §2 estimate
  via The Sluice. **No new MM class, no new capture mechanism anywhere in this spec.**
- **Worst-case draw incl unions under the named loadout:** unchanged — ≈ **27** in the roster-gap era,
  ≈ **37–40** once `T-M1h-ROSTER` lands (roadmap §2's own figure). **≤ 40 planned, ≤ 60 hard ⇒
  VERDICT: the 60 ceiling HOLDS; no re-tally required.** Declared rule: if any build card DOES add
  an FX class, it re-tallies and re-pins `DRAWS_PLANNED`/`GLB_FILES` in the same commit
  (retire-and-replace, T-M1g precedent), and gets no budget credit otherwise (DA c1 A-1).
- **Alive ceiling (rev-2 P3-5 wording):** the `ALIVE_CAP 400` **horde** bound is unchanged and
  endless is bounded by it **and** the `minf(12.0, …)` rate ceiling — the worst-case cycle-5 leg
  re-asserts **horde ≤ 400**. Precise: the shipped worst-case is **403** = the 400 horde cap + the
  **3 named once-each schedule spawns** taken above the guard (Warden + 2 minibosses, `LEDGER`
  T-M1g) — 400 horde + 3 named bosses, both readings stated. Gem array is additionally bounded
  `≤ 200` (C.1), strictly reducing draws.
- **Verdict line:** draws ≤ 60 and horde ≤ 400 **both hold** with OUR numbers; no exception, no
  silent ceiling raise.

## 8. EXCLUSIONS (reasons, not silence)

1. **Coin-bag tiers** — the roadmap bundled coin-bags with chest-tiers (M2 #2); this spec's CHEST
   TIERS pillar (per the brief) does **not** include them → **deferred** to a follow-on card.
2. **Their fixed first-six chest sequence `1-1-3-1-1-5`** (VS-FEATURES S8 ~656) — THEIRS; replaced by
   seed-deterministic weighted rolls (clean-room). Not cloned.
3. **Reaper pursuer / limit-death** — **DEFERRED to follow-on card `T-M2r-REAPER`, NOT excluded**
   (rev-2 P3-8). The roadmap names "Reaper analogue at the non-endless limit" as an M2 #1
   sub-feature (`PARITY-ROADMAP.md:221-223`); roadmap-is-law and there is no owner artifact retiring
   it, so it is a tracked deferred card, not a design-time exclusion. (Within this spec the
   non-endless limit remains the `win` screen; §A.1.)
4. **Their incoming-damage-cap-minus-1 spiral** (S5 ~467) — not cloned; bounded `DMG_CYC` cap +
   `MAX_CONTACT_DMG = 20.0` floor instead (A.1).
5. **Non-pillar roadmap M2 items** — unlock-flag store (M2 #4), event-wave + 2 more minibosses
   (M2 #5), knockback-lite + the 8-weapons/5-passives roster expansion (M2 #3) — **out of this
   spec's four pillars**; named as follow-on M2 cards. (Their art already shipped in T-M1c where it
   exists; the ROSTER card wires it.)
6. **Roadmap §3 standing exclusions unchanged** — co-op, cloud saves, mobile, DLC-flagged inventory,
   counterparts/Inverse, arcana/secrets/spells.
7. **No new capture mechanism** anywhere — pixel gates reuse `chest_capture.gd`,
   `upgrades_visual_capture.gd`, `cards_capture.gd`, `s8_acceptance.py`; sim legs are new
   `HD3D_<LEG>_DUMP` SceneTree dump legs on the existing channel (the `sim_evolve.gd` precedent), not
   new capture.

## 9. THE 10-POINT SELF-DA CHECKLIST (what DA cycle-1 must verify — M1 law; DA c1 VERIFIED rows
1/2/3/6/8/9 and CONTRADICTED rows 4/5, which are exactly the P2-1/2/3/4 fixes rev-2 lands)

1. **Clean-room:** every number is OURS and pinned by OUR tests; every "≈their" line cites a
   VS-FEATURES section as *shape only*, no copied value/asset/flavor.
2. **Drift honesty (F-1):** the 6-weapon/5-passive code truth vs roadmap "16/15" is stated; the
   runtime-dead `evolutions.gd` table is named; Union 2's `T-M1h-ROSTER` dependency is surfaced as an
   orchestrator/owner decision, **not assumed away**.
3. **Reuse-first / no second mechanism beside an existing one:** endless = WIN_TIME clock + spawn
   loop + collect funnel + level-up phase + save funnel; chest tiers = `build_pool`/`apply_offer`/
   `credit_gold`; gem-merge = gems array + pickup viz + collect funnel; unions = chest-open funnel +
   existing FX classes. Name any exception.
4. **Endless damage-growth cannot explode:** the three capped formulas + named caps
   (`HP_EFFECTIVE_MULT_CAP 18` — binds at cycle 5, A-E3 + A-E2 low-cap red; `DMG_CYC` 2.5 +
   `MAX_CONTACT_DMG 20` — a reachable boss-class bound, A-E3 red; `minf(12.0)` + `ALIVE_CAP 400`)
   all present, and **each clamp has a red row that actually trips it** (rev-2 P2-1/P2-2 fix).
5. **Gem-merge XP-neutrality** restated as the **unconditional gem-layer `Σxp` conservation**
   (C-G2(a)) + a byte-equal end-to-end claim **pinned to `m=1.0`** (C-G2(b)) + the array-boundedness
   row (C-G3) (rev-2 P2-4 fix).
6. **Every ACCEPT row names ONE existing seam/channel** (`sim_*` dump, `save_probe`,
   `chest_pixel_gate`, `upgrades_visual_probe`, `card_icons`, `s8_acceptance`) and **no new capture
   mechanism** is introduced (`chest_capture.gd` etc. REUSED, not new — P3-4).
7. **Every gate can go RED:** each row has a named planted-red (threshold cap±1, before/after gate,
   XP-drop, union-at-`MAX_LEVEL-1`, reserved-union-base, endless-off win, low-cap clamp, baseline-vs-
   baseline pixel).
8. **Budget re-derived under the §2 WORST-CASE LOADOUT incl unions;** the ≤ 60 verdict is stated with
   the "0 new draw classes" reasoning + horde ≤ 400 (total 403 named, P3-5) and the same-commit
   re-tally rule if a class is added.
9. **Contract B untouched:** cycle/endless/tier/merge/union state stays OUT of the 12-field snapshot
   (`game_state.gd:121`); no new phase value; the endless-off win dump stays byte-identical; the
   `weapons` field VALUE-domain widening is flagged (F-3 rev-2 note, P4-6).
10. **Wave-map discipline (rev-2 P2-5 fix):** the `world.gd`/`game_state.gd`/`weapons.gd`/
    `pickup_viz.gd` same-file graph forces **ONE serial feature spine** — **no two build cards are
    parallel**; only the asset batch is parallel; version bump v1.3.0; doc-sync rows (DESIGN-3D §b,
    LEDGER) named; deferred M1 features 6/7 + `test_biome_numbers.py:231` retirement + `T-M2r-REAPER`
    deferred card are flagged **for the closing seat** — the closing seat owns the result.

## 10. REVISION-2 CHANGELOG (what changed vs rev-1 @ 475a480; DA c1 @ c1cfc12 fix list)

- **P1 (unified):** cycle-clear chest tier — §A.1 no longer hardcodes `warden`/II; it DEFERS to
  `CHEST_TIER_BY_SOURCE` (§B.1), whose cycle-clear entry is **`dawn` (tier III)**; **A-E4** and
  **B-T1** now assert the SAME tier (III) from the SAME map row. Provenance: OUR number from the
  §B.1 tier table (biggest recurring milestone ⇒ richest tier).
- **P2-1:** `MAX_CONTACT_DMG` **40.0 → 20.0** (reachable boss-class bound from max base dmg 12,
  `world.gd:35`; binds cycle ≥4; red-tripable) — §A.1, checklist 4.
- **P2-2:** HP-cap test re-anchored — **A-E3** is now a **cycle-5** DECLARED-PIN scaling-eval leg
  (both clamps bind there); **A-E2** carries the low-cap (`6`) clamp-binding red; §A.1 states the
  18× clamp binds at cycle 5, not 3.
- **P2-3 (fun/throughput):** §A.1 adds the **survival-sim intent + growth channel** (Dawn Well ranks
  across-runs, +200 hp full; no in-run growth; M4 `limit-break-lite` reserved) and **adds A-E8
  CYCLE-REACHABILITY** (HP-pinned sim leg reaching cycle 2, `best_cycle=2`, s8 declared HP-pin;
  un-pinned depth NOT claimed).
- **P2-4:** §C.1 + **C-G2** restate XP-neutrality as the unconditional **gem-layer `Σxp`
  conservation** + byte-equal ONLY at pinned `m=1.0`; drop the false unconditional "byte-identical".
- **P2-5:** §5 wave-map "can run parallel with" fixed to **asset-batch-ONLY** for every build card
  (all share `world.gd`/`game_state.gd`/`weapons.gd`/`pickup_viz.gd`); one serial spine declared.
- **P3 folds (all adopted):** P3-1 waves-restart = ramp not roster (§A.1, `render.gd` saturation);
  P3-2 boss/miniboss once-ever ⇒ cycles ≥2 have none (§B.1); P3-3 `hud_3d.gd` added to A.2/card;
  P3-4 `chest_pixel_gate`/`chest_capture` relabelled **reuse** not NEW (§B.2, aligns §8.7);
  P3-5 budget "max-alive ≤400" → **horde ≤400, total 403** named (§7); P3-6 **union-base reserve
  rule** + D-U5 row (§D.1); P3-7 `sim_boss.gd:215 → :292` (own grep) (§D.2/D.3).
- **P4 folds (all adopted):** P4-1 `event` forward-declared (§B.1); P4-2 `endless-cycle` divergence
  row (§B.1); P4-3 per-leg `HD3D_<LEG>_DUMP` wording (§A.2/§8.7); P4-4 committed
  `tests/fixtures/endless-m2.jsonl` named (A-E6); P4-5 bulk-gem color-MM format named (§C.1/C.2);
  P4-6 `weapons` value-domain note (§0 F-3); P4-7 `GATE_T` references `EvolutionSystem.GATE_T`
  (§D.1).
- **REBUTTAL: none.** No DA finding is contradicted by file:line; the full list is adopted. The only
  precision tweak is the `sim_boss.gd` DECLARED-pin line (`:292`, per this session's own grep — the
  roadmap §2's `:215` was a drifted pin).
