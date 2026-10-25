# M3-SPEC — hollow-dawn-3d "Stages" (v2.0.0) — spec for the DA gate

- **REV 2, 2026-10-25, after DA cycle 1** (`docs/M3-SPEC-DA.md` @ `ecfd70c`, MC 11271, immutable).
  The reviewer's fix list is **adopted in full** — P1-1 (the §1.2 byte-pin promise vs §3.1's
  schedule generalization: the `test_boss_numbers.py:64-77` shape pin regexes the literal warden
  latch the table loop retires by design — now a DECLARED retire-and-replace row), 3 P2s (P2-1 the
  boss-chest drop-site stamps from the literal key `CHEST_TIER_BY_SOURCE["warden"]` — generalizing
  the seam + re-pinning `tests/test_chests_tiers.py` (SPEC_MAP exact-equality + drop-site literal);
  P2-2 the undeclared mesh dependency on `T-M3a-ASSETS`; P2-3 A-E1's circular fixture anchor
  re-anchored to the EXISTING committed corpus), every P3 (clamp bound re-derived per base — binds
  cycle 3 for 13/14; roadmap `:276` "+ limit Reaper" clause into the T-M3z retire list; the
  `test_biome_numbers.py:41-45` slice-placement risk pinned) and P4 rows (citation fixes `:279`,
  `sim_budget.gd:92`/`sim_boss.gd:292`; the boss spawn-scalars row with effective spawn HPs).
  **REBUTTAL: none** — every finding was re-grepped THIS session and found TRUE at file:line (the
  DA's own pins checked out exactly). The gate's attacks that HELD are carried unchanged: SEL-A ⇒
  **v2.0.0 survived A1** (the version-law attack), the gimmick-composition claim (A5), the
  event-wave deferral (A6), the budget (A9) and the Contract-B zero-delta (A10). §10 lists every
  change by section.
- **Purpose:** build-depth spec for M3 (roadmap gap-rows 4–5: stages + gimmicks, end-bosses),
  authored for the **devils-advocate gate** (fleet law: roadmap-gated build cards file ONLY after
  the DA SHIPs this — MC 11268, parented on `docs/PARITY-ROADMAP.md` rev3 §M3). Same spec depth
  `docs/M2-SPEC.md` rev-2 gave M2 (per-feature mechanism + files + ACCEPT rows naming ONE existing
  seam). A build card executes straight from an ACCEPT row; this is not a plan sketch.
- **VERSION DECISION (in the header, per the brief): v2.0.0.** The roadmap's own version law
  (`PARITY-ROADMAP.md:63-66`: "major = a new player-navigated UI surface (M3 stage select →
  v2.0.0)") is decided **with** a real stage-select surface, not around it — both options and the
  reasoned recommendation are §2; the DA is asked to attack that row first.
- **Code truth:** read this session at `origin/master` base `1d005bc` (T-M2z, v1.3.0 GA — M2
  pillars + full roster live). Every dependency claim re-grepped HERE (M1/M2 proved pins drift):
  the line refs below are this session's greps, e.g. `render.gd BIOMES:68-77` + `biome_at:80-85`,
  `world.gd BOSS_AT:5 / MINIBOSS_AT:9 / GATES:97 / latch loop:164-171 / kill_enemy:263-286 /
  collect_pickups:290-331`, `game_state.gd WIN_TIME:7 / start_run:105 / snapshot_json:181-198`,
  `main.gd MAX_CONTACT_DMG:18 / _step:188-233 / endless hand-in:267 / _end_run:304 /
  _meta_changed:350`, `screens.gd overlay idiom:127-150 + shop overlay:237-327`, `save.gd
  VERSION:23 / flags:28 / best_cycle:34 / load_save:38-61 / as_data:108`. The DA c1 verdict and
  this rev-2 are docs-only commits — the code tree at `ecfd70c` is byte-identical to `1d005bc`, so
  every rev-2 re-grep (the nine DA findings, each independently re-run this session) reads the
  same tree the spec cites.
- **Clean-room stance (inherited from `docs/PARITY-ROADMAP.md` §1 honesty rule, binding):**
  *their systems, our content* — the Vampire Survivors inventory (`docs/VS-FEATURES.md`, clean-room
  wiki text, MC 11195) is a **shape reference only** (S4 stage table ~382-409, S5 boss rules ~419);
  every table below carries OUR numbers, pinned by OUR suite. No copied value, asset, or flavor
  text. "≈their" lines name the shape, not a number we ship.
- **docs/ARCHITECTURE.md:** ABSENT in this repo and deliberately not created here — the repo runs
  its own spine (`LEDGER.md` + `docs/DESIGN-3D.md` + `docs/PARITY-ROADMAP.md` + `docs/M*-SPEC.md`)
  and a second spine beside it is the duplication this repo refuses (M2-SPEC header precedent). The
  budget/mechanism truth this doc needs lives in DESIGN-3D §b/§i/§j and is cited there, restated
  nowhere.
- **Length note (exceeds the ~300 hygiene line, stated why):** one pointable build-depth artifact
  for one release, exactly as M2-SPEC (536 L) stated; splitting defeats the pointable-artifact DoD.
  Each pillar is self-contained so the DA can gate a single one.

## 0. FINDINGS + STATED READINGS (read before the DA opens any pillar)

Each ambiguity the brief/roadmap left open is resolved with a literal reading; flagged decisions
are **named, not silently chosen**.

- **F-1 (roadmap-internal contradiction — the end-boss count).** `PARITY-ROADMAP.md:42` (gap table
  row 5) says "M3: 1 end-boss per stage (**4 total**)"; `PARITY-ROADMAP.md:276` (§M3 item 3) says
  "3 end bosses **incl. warden**; 2 new large miniboss-class meshes". 3 stages × 1 end-boss = 3.
  **Reading adopted:** the §M3 build row (the specific line) beats the gap-table summary (the
  general one): **3 named end-bosses total — the shipped Warden is stage 1's, +2 new** (2 new
  meshes, not 3). The "4th" the gap row (and the brief, which quotes it) counts is the only
  roadmap-named 4th end entity that exists: the limit **Reaper analogue, already tracked deferred**
  as `T-M2r-REAPER` (`PARITY-ROADMAP.md:249`, M2-SPEC §8.3 — roadmap-is-law, no owner artifact
  retires it). Stated so no later reader invents a fourth stage boss. The brief's asset line
  "3 end-boss meshes" follows the `:42` count; §6 lands **2** new boss meshes with this reading.
  Rev-2 note (P3-2 fold): the SAME `:276` row carries a second live clause, "**+ limit Reaper**" —
  resolved in §5's doc-sync row + §8.2 (T-M2r-REAPER is the named deferral of that sub-clause, and
  the T-M3z retire-and-replace list names `:276`, so the retired-claim grep survives the release at
  zero).
- **F-2 (version law is a rule, not a label).** Roadmap §2 (`:63-66`) pre-committed: "Stated so
  M3's major is a rule, not post-hoc", and its spine names M3 = v2.0.0, M4 = v2.1.0 — the M4
  number is only reachable if M3 ships v2.0.0. Both options are presented in §2 with a
  recommendation; choosing v1.4.0 would falsify the roadmap's own release spine (`:268`, `:285`)
  and require a retire-and-replace rewrite of it with no owner artifact.
- **F-3 (Contract B is frozen — 12 fields).** `game_state.gd:181-198` is the exact snapshot the
  bridge ships every physics tick; the phase enum `menu|playing|levelup|gameover|win` is frozen
  (M2-SPEC F-3, unchanged). **M3 impact row (brief §5): ZERO snapshot change.** `stage` and the
  plate-`flare` run vars live OUTSIDE the snapshot like `endless`/`cycle` do
  (`game_state.gd:36-37`, F-4 pattern); no new phase value; the select overlay is menu-phase UI
  riding the shop precedent (`main.gd:173`: menu Enter is inert while an overlay owns input); the
  `weapons` value-domain does NOT widen (M3 adds no weapon ids).
- **F-4 (stage 1 = current arena, byte-stable).** Roadmap §M3 #1 (`:271`): "Stage 1 = current
  arena." The stage=1 path stays **byte-identical to every committed dump** (the
  `endless-m2.jsonl`/`gem-merge-m2g.jsonl`/… corpus): stage 1's STAGES row references the shipped
  consts (`BOSS_AT`, `MINIBOSS_AT`, the 4-row `BIOMES` list) verbatim, its gimmick row is "none",
  and plate/cairn code is gated to stages 2–3 (empty stage rule ⇒ unchanged output — the
  meta_ranks/endless "empty input" guarantee, M2 F-4). The brief's "one gimmick per stage" is
  satisfied across the three stages by: stage 2 gimmick, stage 3 gimmick, and stage 1 whose rule
  row **names the shipped warden+miniboss vigil schedule as its stage rule** — giving stage 1 a NEW
  gimmick would break the byte corpus, and roadmap-is-law says the arena is "current".
- **F-5 (gimmick props ship as billboards, not meshes — no dead art).** The shipped tree has **NO
  in-game prop/weapon mesh consumer** (T-M2u LEDGER row, stated verbatim: the M1c/M2a static-prop
  GLBs have no in-game draw site; horde_viz draws enemy classes only). A TRELLIS "gimmick prop"
  mesh today would be the union-GLB situation again: shipped, unconsumed. Ground props in this
  game are **icon billboards** (chest/gem/coin/heal, the `pickup_viz` MultiMesh idiom), so the
  plate rides that idiom (one new billboard MM + 1 icon) and the cairns are literally chests
  (existing icon, existing MM). §6 states this divergence from the brief's "gimmick props" mesh
  line.
- **F-6 (stage tiles: zero new — bands compose from the shipped set).** Reuse-first: a stage's
  `bands` row references the SAME four `BIOMES` entries (`render.gd:68-77`); a new stage is a new
  *composition* (band subset + re-keyed `t_start`s), not new art. Declared divergence from roadmap
  §M3-assets' "3 seamless 1024² tiles" (`:282`) — the v2 tile recipe + `tools/biome_readability.py`
  gate stay the named route if the owner later orders stage-specific tiles; M3 spends ZERO tile
  rows. The readability gate still runs **per stage** (roadmap ACCEPT names it; §5 A-E7).
- **F-7 (event-waves +2 minibosses: DEFERRED, tracked — decision in §4).** The roadmap's own
  landing note (`:258-259`) already assigns M2 item 5 ("+2 minibosses + first event-wave") to a
  named follow-on card; the brief asks M3 to decide absorb-or-defer. Decision + justification: §4.

## 1. PILLAR A — STAGE TABLE RIDING THE EXISTING BAND MECHANISM

**Shape ref:** VS-FEATURES §S4 (~382-409): 25 stages, each "time-limited (15–30 min)" with a
gimmick + end boss; two gimmick shapes are quoted-VERIFIED there — stage items spawning as ground
pickups (Mad Forest / Inlaid Library rows, `VS-FEATURES.md:384-385`) and "circular pressure plates
on the ground, which upon being stepped on trigger an unavoidable event" (Dairy Plant row,
`:386`). THEIR numbers; roadmap M3 = **3 stages** (`:41`), our ids/names/rows below.

**Reuse (zero new subsystem).** The whole band mechanism today is: `render.gd BIOMES` (the ONE
band table) + `biome_at(t)` (`render.gd:80-85`, saturates on the last band) read by exactly three
call sites — the ground swap (`ground.gd:43-49` `_set_band`), the HUD banner (`hud_3d.gd`
`BIOME_FLASH` row), and the roster merge (`world.gd:124-129 _types_open` = band roster + the minute
`GATES` rotation). The gimmicks compose ONLY from: that band seam, the ONE spawn loop with its
UNTOUCHED ceilings (`minf(12.0, …)` rate + `ALIVE_CAP 400`, `world.gd:172-180`), the ONE chests
array + 16 px collect/open funnel (`world.gd:103, 318-327` + `chest_rewards.gd`), and the
latch-once schedule pattern (`world.gd:164-171`). No new RNG consumption outside existing sites
(plate dwell is a position test; cairn seeding is static — the pinned-RNG dump corpus stays
byte-stable).

### 1.1 The STAGES table (OUR rows, the single stage source)

New `const STAGES` in `render.gd` (it IS the repo's data module — "the acceptance suite regexes the
tables below VERBATIM", `render.gd:5-6`), and `band_at(stage_id, t)` = the ONE generalized lookup
(`biome_at(t)` stays as the stage-1 wrapper `band_at("moor-vigil", t)` so every existing pin and
call site keeps a total function). Each row:

| stage id | name | bands (existing BIOMES rows, re-keyed) | gimmick | bosses (latch schedule) | limit | unlock |
|---|---|---|---|---|---|---|
| `moor-vigil` | MOOR VIGIL | all 4 rows @ `t_start` 0/150/300/450 **verbatim** | none — F-4 baseline | `[[BOSS_AT,"warden"], [600,"hollow-knight"], [780,"hollow-deacon"]]` (const reference, byte-stay) | WIN_TIME 900 | — (start) |
| `sunken-chapel` | SUNKEN CHAPEL | MOORLAND @0, THE FROZEN WASTE @300, DEAD TUNDRA @600 | drowned-cairns (§1.2) | `[[540,"cathedral-choir"]]` | 900 | level ≥ 10 in stage 1 |
| `ossuary-stair` | OSSUARY STAIR | DEAD TUNDRA @0, THE FROZEN WASTE @450 | pressure-stair (§1.2) | `[[540,"ossuary-warden"]]` | 900 | level ≥ 14 in stage 2 |

- **One clock, unchanged.** `limit` ships **900 s on every stage = `GameState.WIN_TIME`**
  (`game_state.gd:7`, byte-pinned twice: `test_game_numbers.py::test_win_threshold_900` +
  `test_biome_numbers.py::test_win_time_900`): the endless cycle math reads WIN_TIME
  (`world.gd:58-59`, `main.gd:219-231`) and the one-clock law (M2 §A.1, "no new clock") says the
  stage limit is THAT constant. The `limit` field is the roadmap's named shape (`:270-271` "stage →
  band list, gimmick id, end boss, limit"); shipping it uniform at 900 keeps every pin green and
  the field is where a later owner-ruled per-stage limit lands. Their 15–30 min limits are the
  shape ref, not our numbers (`VS-FEATURES` S4).
- **Endless rides stages unchanged:** `DawnWell.flags["endless"]` + cycle-clear stay global
  mechanics; a cycle clear on any stage is the same `main.gd:243-248` seam (cycle clock = WIN_TIME
  = the stage limit — consistent by construction).
- **The generalized lookup, byte-true:** `band_at(stage_id, t)` walks the stage's band list with
  the same saturating loop (`render.gd:80-85` verbatim shape). Stage 1's list IS the current
  `BIOMES` array, so `band_at("moor-vigil", t) == biome_at(t)` for all t — pinned (A-E2). The
  three call sites take the stage-keyed form; `test_biome_numbers.py::test_band_t_starts_names_and_rosters`
  (:41) stays green — **with a declared placement constraint (P3-3 fold):** that pin SLICES
  `render.gd` from `const BIOMES` to `static func biome_at` and regexes `t_start` inside the slice
  (`test_biome_numbers.py:41-45`, position-sensitive), so **`const STAGES` + `band_at` land AFTER
  `static func biome_at`** in `render.gd` — the slice then still ends at `biome_at` and reads only
  the untouched BIOMES table; A-E2 pins the placement (RED: STAGES before `biome_at`). The cross-
  class const reference this implies (STAGES rows referencing `GameWorld.BOSS_AT` while `world.gd`
  reads the renderer) is not an engine hazard at the pinned version — machine-tested by DA c1 on
  `tools/VERSIONS.txt:7` (parses + evaluates `540.0`); any other pin the generalization falsifies is
  retired+replaced in the same commit (suite-posture law, roadmap §2; the boss-shape pin's
  retire-row is §1.2/§3.1, P1-1 fold — "stays green" was the rev-1 overstatement).
- **Run plumbing:** `GameState.stage : String` (+ `flare : float` for the stage-3 visual, §1.2),
  reset in `start_run()` (`game_state.gd:105-132`), OUTSIDE the 12-field snapshot (F-3);
  `main._start_game()` hands the chosen stage in through the ONE `_dawnwell → start` seam —
  the exact endless pattern (`main.gd:267`), AFTER `start_run` — so an unset stage reads
  `"moor-vigil"` and every committed dump is the stage-1 default case.
- **Stage persistence (brief §5 row, reuse save.gd rules):** `stage:int` joins `dawnwell.json` as
  a field-by-field ADDED row — **`VERSION` stays 1, no bump** (`save.gd:23`; the `best_cycle`
  precedent `save.gd:29-34` proved the rule: field-by-field migration defaults a missing field, so
  an older save reads stage 1 and keeps working). Chosen stage = `DawnWell.stage`, written only
  through the ONE `_meta_changed` funnel (`main.gd:350`); atomic temp+rename unchanged
  (`save.gd:67-79`). Unlock state rides the **existing `flags` dict** (`save.gd:28`, format
  `flags:{unlock_id:1}` from roadmap M1 f1): `flags["stage2"]=1` / `flags["stage3"]=1`.

### 1.2 Gimmicks — one per new stage, composed ONLY from shipped mechanisms

| stage | gimmick (our name) | composes from — the existing mechanism, named | our numbers |
|---|---|---|---|
| `sunken-chapel` | **Drowned Cairns** (their stage-items shape, `VS-FEATURES:384-385`) | **the ONE chest funnel**: 2 ember chests seeded into `world.chests` (`world.gd:103`) at fixed map points by a `stage-item` source row in `CHEST_TIER_BY_SOURCE` (`world.gd:69-70` — the SINGLE source of truth, strict-lookup law from T-M2t: an unstamped source crashes, never de-tiers); opening is the untouched 16 px collect funnel + union→evolve→tier-cards→gold order (`world.gd:318-327`) + `chest_rewards.gd` weighted grants. ZERO new pickup kind (`test_biome_numbers.py::test_pickup_radius_16px` stays 4). | 2 cairns at FIXED coords (table row, e.g. `(±260, ±150)` px), seeded at run start, no RNG; tier **ember (I)** = 1 weighted card |
| `ossuary-stair` | **Pressure Stair** (their plate shape, VERIFIED quote `VS-FEATURES:386`; roadmap `:274-275` names the reuse: "reuses spawn surge + band swap — no new geometry") | **the ONE spawn rate term** — while the player dwells inside a plate radius, the existing rate term gains × SURGE (`world.gd:179-180`): `minf(12.0, (1 + 1.3*m_c) * qty_cyc * surge)` — the `minf(12.0)` ceiling and the `ALIVE_CAP 400` early-return (`world.gd:172`) are UNTOUCHED, so the surge **cannot explode** (it saturates against the same two ceilings endless saturates against). **Band flare** = a VISUAL band override (the ground `_set_band` + HUD banner read `band_at(stage, t + flare_shift)`; flare_shift decays) — the band-swap seam is reused for look; the difficulty key stays the pure clock, so **sim dumps are render-independent** and the surge is the difficulty half. | 2 plates at fixed coords, radius **120 px**, `SPAWN_SURGE := 1.5` (×rate, capped), flare shift **+150 s**, decay **30 s**; dwell test = the existing `_dist` pattern (`world.gd:294, 334-337`); zero RNG consumed |
| `moor-vigil` | — (F-4 baseline) | the shipped vigil itself: warden@540 + 2 minibosses@600/780 on the latch schedule (`world.gd:164-171`) IS the stage rule row. **REV-2 (P1-1): the const pin `test_game_numbers.py:35` (`BOSS_AT == 540.0`) stays green — the const survives, referenced by the STAGES row — but `test_boss_numbers.py::test_boss_spawns_exactly_once_at_540` (:64-77) regex-pins the LITERAL latch (`if not boss_spawned and game\.time >= BOSS_AT:` + the single `_spawn_enemy("warden", game, view)` site) that §3.1's table loop removes BY CONSTRUCTION: rev-1's "stays green" was a self-contradiction; the declared fix is a RETIRE-AND-REPLACE row (§3.1 bullet 3, replace-not-delete ledger, same commit).** | as shipped |

Rejected trade-offs (stated, not silent): *stage-item as a new pickup kind* (would violate the
4-kind pin `test_biome_numbers.py:149` and add a 5th collect branch — the chest funnel already IS
the upgrade-granting ground item); *plates as one-shot latches* (latched state adds a per-run var
per plate for no observable gain — dwell is stateless and equally deterministic); *flare shifting
the difficulty key too* (would make render state feed the sim and threaten dump byte-stability —
rejected by F-4); *reaper waves on a stage* (T-M2r, deferred, §8).

### 1.3 Files (Pillar A)

`render.gd` (STAGES + `band_at`, `biome_at` kept as wrapper), `game_state.gd` (`stage`, `flare`;
reset in `start_run`; both outside the snapshot), `main.gd` (`_start_game` stage hand-in at the
endless seam; overlay Enter-guard extension `main.gd:173`; `_end_run` unlock check + the same ONE
`_meta_changed()` call site), `world.gd` (stage-aware schedule loop §3.2 + `seed_stage_props` +
plate logic + `CHEST_TIER_BY_SOURCE` gains `"stage-item": "ember"`), `ground.gd` + `hud_3d.gd`
(band-key call sites → `band_at`), `pickup_viz.gd` (plate billboard MM — the 6th `_mm` node in the
file's OWN idiom, drawn only when the stage row has plates), `screens.gd` (Pillar B), `save.gd`
(`stage` row), NEW `godot/sim/sim_stages.gd` (own env `HD3D_STAGES_DUMP`, seed-pinned — the
`sim_endless.gd`/`sim_gems.gd` per-leg-env precedent, **not** a new capture mechanism), NEW
`tests/test_stages.py` + `tests/test_save.py` stage/unlock rows + committed
`tests/fixtures/stages-m3.jsonl` (rev-2: **forward lock only** — A-E1's gate anchor is the existing
corpus, P2-3).

### 1.4 ACCEPT (rows → ONE existing seam each; planted-red named; no new capture)

| # | observable | seam (the ONE existing channel) | red |
|---|---|---|---|
| A-E1 | stage-1 **byte-stability** — **REV-2 re-anchor (P2-3: rev-1 asserted against `stages-m3.jsonl`, a fixture MINTED inside M3 — circular at gate time; a stage-1 leak introduced BY M3 bakes into its own anchor).** The anchor is the **EXISTING committed corpus re-run on the stage-1 default**: `tests/fixtures/endless-m2.jsonl` (`test_endless.py` legs), `gem-merge-m2g.jsonl` (`test_gems.py`), `chests-tiers-m2.jsonl` (`test_chests_tiers.py`), `unions-m2u.jsonl` (`test_unions.py`) + the `sim_headless` journey re-run byte-identity (the 5020-row capture pattern, LEDGER TQ-01/T-M2z rows) — the exact M2 precedent (`test_endless.py:26,42` + the v1.3.0 "fixture endless-m2 cmp-IDENTICAL" re-runs). `stages-m3.jsonl` is demoted to the **forward lock only** (it detects leaks added AFTER M3), never the gate anchor. | the existing fixture-judged legs of the four pytest files + the `sim_headless` capture re-run | any of the FOUR existing fixtures flips on a stage-1 default run ⇒ RED (a leak vs PRE-M3 truth, not vs M3's own capture) |
| A-E2 | STAGES table pytest pin: ids/names/band `t_start`s/boss rows/limits/unlock levels regex-pinned (OUR numbers); `band_at("moor-vigil", t) == biome_at(t)` at t = 0/150/300/450/900 | the existing table-pin pattern (`test_biome_numbers.py::test_band_t_starts…` :41) | a re-keyed band order ⇒ pin RED |
| A-E3 | stage 2 cairns: 2 ember chests live at t≈0 from the FIXED coords (no RNG — position rows), one walked-into ⇒ open rides the funnel (`pending_levels` +1, weighted pick, gold in tier range); tier byte == the `stage-item` map row (the A-E4/B-T1 single-source law, M2 rev-2 P1) | real drop→`collect_pickups` funnel dump (`sim_chest_tiers` B-T1/B-T2 leg shape) | cairn tier ≠ map row, or a cairn that never opens ⇒ RED |
| A-E4 | stage 3 plate legs (DECLARED-PIN walk, the `sim_budget.gd:92`/`sim_boss.gd:292` pin pattern — rev-1's `sim_caps.gd:88` cite was that leg's print line, P4-1 fold): inside ⇒ rate row ×1.5 AND the `minf(12.0)` cap row still binding; outside ⇒ baseline byte; flare: banner/ground band name = shifted band, decays to base; **RNG-stream row: dwell consumes zero `randf`/`randi`** | `sim_stages` dump (same `HD3D_SEED` + per-leg env channel) | surge that bypasses `minf` (13/s) ⇒ RED; a dwell that draws RNG ⇒ RNG-stream RED |
| A-E5 | persistence: `stage` roundtrip on disk; OLD save (no field) ⇒ 1/`moor-vigil`; fresh save ⇒ `flags["stage2"]` ABSENT (roadmap's "stage-unchained leg"); a stage-1 run ending at level ≥ 10 ⇒ flag written ONCE through the ONE funnel; never unset by a later death | `save_probe.gd` legs + `tests/test_save.py` roundtrip (the `best_cycle` row :231 precedent) | level-9 run setting the flag, or funnel call-count > 1 ⇒ RED |
| A-E6 (pixel) | select overlay renders (rows + lock lines), non-bg ≥ 200 px vs hidden-UI empty baseline | `tools/dawnwell_pixel_gate.py` REUSED + per-overlay window (the T-M2t P3-4 per-tier-window precedent — NOT new capture) | baseline-vs-baseline ⇒ 0 px RED (planted) |
| A-E7 (pixel) | per-stage readability: floor_lum ≤ 34 / block_px ≤ 48 / hero ratio ≥ 2.0 per stage band window | `tools/biome_readability.py` extended per stage (roadmap §M3 ACCEPT names this exact extension; tick-determinism kept) | planted bright tile ⇒ its ratio row RED (gate's existing red leg) |
| A-E8 | contract: `snapshot_json` exact 12 fields, `stage`/`flare` ABSENT; phase enum byte-unchanged; menu Enter inert while the overlay is open (shop-guard parity) | the existing exact-12-field pin (`sim_headless`/`sim_endless` snapshot rows, endless F-3) | a 13th field ⇒ pin RED |

## 2. PILLAR B — STAGE SELECT: THE VERSION-LAW DECISION

The law (`PARITY-ROADMAP.md:63-66`): **"major = a new player-navigated UI surface (M3 stage
select → v2.0.0); new subsystems and changed run numbers ride minor."** Both readings of "stage
select for M3" are presented; the DA will attack this row — it is the one owner-visible call.

**Option SEL-A — a real stage-select overlay (screens.gd CanvasLayer reuse) ⇒ v2.0.0.**
A fifth overlay in the ONE panel style (`screens.gd:127-150` `_overlay/_center_box/_label/_button`
idiom — the shop proved a whole 24-row table rides it, `:237-327`): menu gains one button ("Choose
your night", beside "Enter the night"/"The Dawn Well", `:160-161`); the overlay lists the 3 stages
with OUR flavour name, band preview line ("Moor → Frozen Waste → Dead Tundra"), gimmick line, boss
name, and lock state ("Sealed — reach level 10 in Moor Vigil"); Select emits a verb, `main` writes
`_dawnwell.stage` (+ save) through the ONE `_meta_changed` funnel and refreshes; the Enter-guard
extends the shop rule (`main.gd:173`). Mechanically it is 100 % existing overlay idiom; it is a
new *surface* in the law's own sense — what the player navigates.

**Option SEL-B — stage selection WITHOUT a new nav surface ⇒ stays v1.4.0.** Two shapes:
(b1) a "Stages" section inside the existing Dawn Well shop overlay (the shop panel grows stage
rows beside power-up rows — same verbs, same funnel), or (b2) an endless-flag-style toggle on the
existing menu (a second menu button cycling "Stage: I → II → III", lock states skipped). No new
overlay, so the law's trigger never fires and M3 rides minor as v1.4.0.

**RECOMMENDATION: SEL-A ⇒ v2.0.0.** Reasons:
1. **Roadmap-is-law, twice.** §M3 item 1 names it literally: "stage-select menu (screens.gd
   CanvasLayer reuse)" (`:270-271`); §M3's own header (`:268`) reads "major-version-worthy: stage
   select exists". SEL-B is an unratified roadmap divergence (no owner artifact — Rule 2).
2. **The version spine is a contract.** The roadmap names M4 → v2.1.0 (`:285`); cutting M3 at
   v1.4.0 makes its own spine false and forces a retired-claim rewrite of `:63-66`/`:268`/`:285`
   with nothing gained.
3. **Gaming the law is the failure mode the law pre-empts.** §2 says the wording exists "so M3's
   major is a rule, not post-hoc". Deliberately hiding the stage picker inside the meta shop to
   dodge a major is exactly the post-hoc move. The major bump costs only a label on the automated
   S9/S11 release spine; SEL-B saves no seat-day that appears anywhere in the wave map.
4. **The unlock chain needs a surface.** Roadmap §M3 #3 ACCEPT names the "stage-unchained leg
   (fresh save: stage 2 locked)" (`:279` — rev-1's `:278` was a citation slip, P4-1 fold) — a lock
   is only an observable if the player can SEE the locked
   row and its requirement; a shop sub-section or a blind cycle-toggle makes A-E5/A-E6
   unprovable as pixels and undiscoverable as UX.
5. Mechanism monogamy is NOT violated by SEL-A: the mechanism (overlay idiom) is reused; the law
   keys on the player-navigated surface, not on node counts. SEL-B would instead *stretch a surface
   beyond its purpose* (a gold-shop that also navigates stages) — two meanings in one surface is
   its own monogamy smell.

DA-attack preemptions: *"a fifth overlay is not new mechanism, so the law doesn't fire"* — the law
names player navigation, not code novelty (§2 wording quoted above; the shop itself is evidence a
whole surface rides one idiom, which is about cost, not about whether the player navigates
somewhere new). *"b1 still shows locks"* — a stage picker inside a purchase list buries the ladder
the unlock chain is built around and re-mints the shop's meaning; and the roadmap still names the
select menu by shape. **Version decision as shipped in this spec's header: v2.0.0.**

## 3. PILLAR C — END-BOSSES (1 per stage; 3 total incl. the shipped Warden — F-1)

**Shape ref:** VS-FEATURES §S5 (~419): bosses are "stronger… more health, dealing more damage…
have a chance to drop a Treasure Chest when they are killed"; S5's named end-of-stage-bosses table
lists one per stage (~427-439). THEIR numbers; ours below, OUR owned drop-rule numbers per the
roadmap gap row `:42` ("boss chest-drop rule (S5 ~419)" — OUR owned numbers: `CHEST_CHANCE_BOSS
1.0` + the tier map rows).

### 3.1 The boss rows (OUR hp/timings; one ladder, existing classes only)

| id | name (stage) | hp | dmg | spd | spawn t | xp | mesh |
|---|---|---|---|---|---|---|---|
| `warden` (SHIPPED) | The Hollow Warden (stage 1) | 3000 | 12 | 45 | 540 | 0 | `boss-warden.glb` (shipped) |
| `cathedral-choir` | The Cathedral Choir (stage 2) | **4200** | **13** | **42** | **540** | 0 | NEW TRELLIS row (§6) |
| `ossuary-warden` | The Ossuary Warden (stage 3) | **5600** | **14** | **38** | **540** | 0 | NEW TRELLIS row (§6) |

- **Ladder provenance (ours, stated):** hp ×1.4 → ×1.33 (≈ the stage's band-difficulty step; the
  hardest normal enemy `pale-wight` 45 hp stays an order below); damage 12→13→14 stays BELOW
  `MAX_CONTACT_DMG 20` at cycle 0, so the existing contact clamp stays vacuous on stage-1 bytes on
  every stage. **REV-1's "reachable cycle-≥4 bound on stage 3" was a copied figure — re-derived
  per base (P3-1 fold):** the clamp binds **cycle 4 for base 12** (stage-1 law, `main.gd:14-15`,
  byte-unchanged: 12×1.6=19.2 ≤ 20 < 12×1.8=21.6) and **cycle 3 for bases 13/14** (13×1.4=18.2 /
  13×1.6=20.8 > 20; 14×1.4=19.6 / 14×1.6=22.4 > 20) — one M3 clamp re-pin leg rides this (C-E5,
  M2's A-E3 "contact 24→20" mechanism leg is the pattern). Speed drops
  with size (shape consistent with warden 45 / deacon 40). `xp: 0` rides the boss no-gem-rain rule
  (`world.gd:89-93` stated). Spawn at **540 = the shipped BOSS_AT slot** on every stage — the
  limit/540 ratio is the shipped vigil shape; one timing, zero new schedule variety to budget.
- **Spawn-time scalars (P4-2 fold — the def HP above is NOT the fight HP):** bosses ride the EXISTING
  per-minute ramp at spawn (`world.gd:145-146`: `def.hp × (1 + 0.22·m_c) × hp_cyc(cycle)`, clamped at
  `def.hp × 18`), exactly the shipped law stated at `test_boss_numbers.py:82-83` ("the spawn-time hp
  rides the verbatim time ramp, the boss is not special"). `HP_CYC`/the 18× clamp structurally CANNOT touch a
  boss: the schedule latch is cycle-0-only (`world.gd:164-171`) and `cycle_clear` never re-arms it
  (`world.gd:255-257`, `main.gd:243-248`) — at cycle ≥ 1 no boss exists to scale. At t=540 (m_c=9,
  factor ×2.98) the **effective spawn HPs are: warden 8,940 / cathedral-choir 12,516 / ossuary-warden
  16,688** — the C-E1/C-E2 kill legs budget against these, not the def values.
- **Enemy rows:** two `ENEMY_TYPES` rows with `"boss": true` + a `name` row (the boss-bar label —
  `hud_3d.gd:33`'s `BOSS_NAME` const becomes a per-boss readout of the row, the ONE bar seam
  unchanged; the bar hides exactly as shipped when no boss exists).
- **Enemy rows:** two `ENEMY_TYPES` rows with `"boss": true` + a `name` row (the boss-bar label —
  `hud_3d.gd:33`'s `BOSS_NAME` const becomes a per-boss readout of the row, the ONE bar seam
  unchanged; the bar hides exactly as shipped when no boss exists). Rows ride the shipped entry
  shape (`"hp"/"spd"/"dmg"/"xp"/"boss"` — the warden's regex-pin `test_boss_numbers.py:84-89` reads
  only the warden row, so added rows go green; the spawn dict already carries `"boss": def.get(...)`,
  `:90-91` — no new field touches it).
- **The schedule loop, one latch — and the DECLARED RETIRE-AND-REPLACE row (P1-1 fold):**
  `update_spawns`' boss block (`world.gd:164-171`: `boss_spawned` + `minibosses_spawned` latches)
  generalizes to iterate the stage row's `bosses` list with the same latch-index pattern (the comment
  "latch first: the schedule fires once each" is the mechanism). Stage 1's list IS the
  const-referenced shipped schedule (§1.1 table); stage 2/3 spawn ONLY their own end boss (their
  lists contain no warden/miniboss — the both-sides RED is C-E1). **Consequence, declared:**
  `tests/test_boss_numbers.py::test_boss_spawns_exactly_once_at_540` (:64-77) regex-pins the literal
  implementation shape — the `if not boss_spawned and game\.time >= BOSS_AT:` gate, the
  `boss_spawned = true` + single `_spawn_enemy("warden", game, view)` site, the `boss_spawned = false`
  reset line — all of which the table loop removes BY DESIGN (one latch-index var replaces the
  bool). **It cannot "stay green"; rev-1's promise was a same-document self-contradiction.** Fix =
  the suite-posture retire-and-replace, REPLACE-NOT-DELETE ledger, SAME commit as the loop
  generalization (the roadmap M1 feature-7 replace-row discipline the chest-pin retirement followed):
  every assertion the old row proved moves to an equal-or-stronger form —
  *`BOSS_AT == 540.0` const* → survives verbatim (`test_game_numbers.py:35` + the surviving first
  asserts of the retires row: the const and the STAGES table row pin, A-E2);
  *"gate = the v1 latch, one spawn site only, no other warden spawn anywhere"* → dump-level
  C-E1 stage-1 legs: warden `first-seen 540.017` + `boss_once = 1` + no second warden spawn anywhere
  (byte/dump pins, which pin BEHAVIOR not code shape — the stronger form the M1-era dump suite was
  built for);
  *"reset() re-arms the latch so the NEXT run gets its one Warden"* → the C-E1 run-2 re-arm leg
  (fresh sim over the same latch var ⇒ first-seen row again exactly once). The dump corpus itself
  (first-seen/boss_once rows, T-M1d leg shapes) is UNTOUCHED green — it is only the regex-shape row
  that retires.
- **Boss death → reward law (rev-1's "ALL shipped seams, zero new code paths" was false at the tier
  seam — P2-1 fold, the ONE named seam edit):** a `boss:true` death at `kill_enemy`
  (`world.gd:263-286`) already gives: +50 gold (`:269`), guaranteed Dawnlight (`:274`), guaranteed
  chest `CHEST_CHANCE_BOSS 1.0` (`:15`) **tiered from `CHEST_TIER_BY_SOURCE`** — BUT the shipped
  drop-site stamps EVERY boss chest from the LITERAL key (`world.gd:281-283`:
  `"tier": CHEST_TIER_BY_SOURCE["warden"]`), which cannot deliver `ossuary-warden → "dawn"` (it
  would drop tier "warden"). **The seam edit:** the boss branch keys the map off the enemy's OWN
  row — `"tier": CHEST_TIER_BY_SOURCE[String(enemy.type)]` — same ONE map, same strict-lookup law
  (a bypassed source still crashes at the drop, never de-tiers), **stage-1 byte preserved by
  identity** (the warden's type IS the `"warden"` key — the same row value). The miniboss branch
  stays on its source-kind literal `"miniboss"` (both minibosses share ember; keying them by type
  would need two new rows for zero observable). The map grows three strict rows:
  `"stage-item" → "ember"` (§1.2 cairns), `"cathedral-choir" → "warden"` (tier II, 2 cards),
  `"ossuary-warden" → "dawn"` (tier III, 3 cards — richest stage ⇒ richest tier, same provenance as
  `endless-cycle → dawn`). **Test consequence, declared:** `tests/test_chests_tiers.py` dies silently
  on ANY added row unless re-pinned in the same commits — `SPEC_MAP` exact-equality (`:100-101`,
  asserted at `:139` `entries == SPEC_MAP` and again at the dump leg `:201`) retires-and-replaces to
  the 7-row map, and the drop-site literal regex (`:145`, the one the map-bypass planted-red rides)
  re-pins to the keyed form. The file's UNIFIED-TIER row (`:263` `test_unified_tier_ae4_bt1_same_row`,
  rev-2-P1 law) reads only the endless-cycle leg and survives UNTOUCHED — it stays alive by
  construction. The file joins the wave-map file sets (T-M3g map-row commit + T-M3b).
  The open rides `try_union → try_evolve → tier cards → gold` (`world.gd:318-327`) and
  `ChestRewards.TIERS` unchanged. The T-M1d/e/miniboss seams are the reused T's: T-M1d's
  CHEST ROLL LEG (guaranteed-boss + 0.6-miniboss roll rows), T-M1e's single-transform open, and
  the miniboss latch class (the new bosses are the same class-mechanism, just `boss:true`).
  Chests stay an icon billboard (tier MM, `pickup_viz.gd:62-68`), never a new kind.

### 3.2 Meshes + viz (the horde mechanism, reused)

- 2 new entries in `horde_viz.gd GLB_FILES` (`:41-59`) → the ONE `ClassMesh` loader, ONE
  MultiMesh draw per class, boss size `MODEL_H_BOSS 5.33 m` rest pose + the same scissor/gait
  Route-A mechanism (DESIGN-3D §c; the T-M1c2 miniboss precedent — static + gait, NO new UniRig
  run). `test_art_integration.py` GLB_FILES coverage row (`:85`) re-pins +2 classes in the same
  commit (the T-M1d re-pin precedent).
- Gates per the LEDGER §M1c2/T-M2a convention: `validate_glb` VISUAL + `aspect_gate.py` rows +
  the **bpy turntable-solid eyeball (yaws 0/90/180/270) as the BINDING prop gate** (automated
  extent/fill gates no-op non-watertight meshes — recorded blind spot, followed, not re-litigated);
  pose-class lesson APPLIED: ball/solid poses fill, coil/helix shatter classes rejected pre-commit
  (T-M2a's dirge lesson).

### 3.3 ACCEPT (Pillar C)

| # | observable | seam (the ONE existing channel) | red |
|---|---|---|---|
| C-E1 | per-stage boss schedule: stage 2 leg ⇒ `boss_spawn` t=540.017 choir + `boss_once` = 1 + **warden/knight/deacon never appear**; stage 3 analogous; stage 1 legs byte-identical — warden first-seen 540.017 + `boss_once = 1` DUMP rows green (the code-shape regex `test_boss_numbers.py:64-77` retires to these legs per §3.1's replace-not-delete ledger, incl. the run-2 re-arm leg) | `sim_boss.gd` schedule/first-seen legs (T-M1d leg shapes), stage-param pins | a stage-2 run that spawns the warden ⇒ RED (both sides per stage); a dropped re-arm ⇒ run-2 leg RED |
| C-E2 | reward law: choir/ossuary kill ⇒ chest 1/1 @1.0, tier byte == the map row READ VIA THE KEYED SITE (`CHEST_TIER_BY_SOURCE[String(enemy.type)]`, §3.1 — choir→`warden` II, ossuary→`dawn` III, warden byte-identity leg included), guaranteed heal row, +50 g row, open grants exactly `item_count` cards + in-range gold; `SPEC_MAP` re-pinned to the 7-row map + drop-site regex re-pinned (rev-1's literal dies with the seam edit — declared) | `sim_boss` CHEST ROLL LEG + the `sim_chest_tiers` drop-map leg (B-T1 single-source assertion extended to the new map rows; `tests/test_chests_tiers.py` re-pin rides the same commit) | a boss bypassing the map (strict lookup: a bypassed source crashes at the drop — the planted map-bypass RED from T-M2t re-pinned to the keyed form); map row missing ⇒ drop crashes ⇒ RED |
| C-E3 (pixel) | the boss bar paints the STAGE's boss name ("THE CATHEDRAL CHOIR" on a stage-2 shot), non-bg ≥ 200 px vs hidden baseline | `tools/s8_acceptance.py` boss-bar crop pattern (the 15,586-px precedent; tick-warp capture reading is the file's stated one) | per-boss name wiring removed ⇒ old const paints ⇒ name-row RED (planted) |
| C-E4 (budget) | stage-3 worst-case re-tally: ossuary live + full stage-3 band roster + plate billboard ⇒ draws ≤ 60 hard, planned-40 pin kept; horde ≤ 400 + named spawns row re-asserted | `sim_budget` WORST-CASE-LOADOUT leg (the §2 construction channel, DECLARED pins) | a new MM class un-retallied ⇒ the coverage/draws pin RED (same-commit rule, DA c1 A-1) |
| C-E5 (clamp re-pin, P3-1 fold) | the contact clamp re-derived per base binds where stated: a stage-3 DECLARED cycle-3 leg through `main.gd`'s OWN pipeline shows ossuary contact 22.4→**20** (base-14 binds c3; the base-12/c4 stage-1 row stays byte — M2's A-E3 "contact 24→20" cycle-5 mechanism is the pattern), HP-pin declared per the s8 precedent | the existing `sim_endless`-style scaling-eval leg channel (A-E3 pattern), stage-3 boss-contact row | clamp moved/raised (row shows 22.4 unclamped) ⇒ RED |

## 4. PILLAR D — THE DEFERRED EVENT-WAVES GAP: DECISION = DEFER, TRACKED

The M2 residue (roadmap M2 item 5 "+2 minibosses + first event-wave", `:241`, landing note
"NOT LANDED — named follow-on M2 cards", `:258-259`; M2-SPEC §8.5) is the open +2-miniboss gap.
**Decision: it stays OUT of M3 and lands as an explicit tracked card `T-M3e-EVENTWAVE` in this
wave map (§5), not as silent scope.** Justification:
1. **No owner artifact moves it in.** The roadmap already routed it to a named follow-on; pulling
   it into M3 would rewrite the M2 landing note unratified (Rule 2), and the roadmap-is-law that
   keeps T-M2r tracked (M2 §8.3) keeps this tracked the same way.
2. **Sizing honesty.** Roadmap M3 is ~8 seat-days with the stage table, a new UI surface, and 2
   new boss classes. The event-wave adds 2 MORE new enemy classes (stat rows + TRELLIS rows +
   height/aspect gates + budget re-tally + a swarm-wall spawn leg) — M1's own DA (c1 A-2) is the
   precedent that silently absorbing a work package into a parent's estimate is the defect, not
   the savings.
3. **Ordering makes it cheaper later.** M3 ships the *spawn-surge* half of the event-wave math (a
   wave surge IS a rate-term bump against the same untouched `minf`/`ALIVE_CAP` ceilings — the
   Pressure Stair row proves it); the follow-on card lands on that mechanism instead of minting
   it. Its one-line DoD: a directional swarm-wall leg off the single spawn loop (an angle-cone
   parameter on `_spawn_enemy`, not a second loop) + 2 miniboss rows + their ACCEPT family.
4. The `event` chest-source row stays the forward-declared reservation (M2-SPEC §B.1 P4-1) — it
   consumes nothing until T-M3e lands.

## 5. WAVE MAP (cards the build wave files; same-file rule ⇒ ONE serial spine)

**The mechanism-monogamy consequence again:** the sim lives in `world.gd` + `main.gd`/`game_state.gd`
+ the one data module `render.gd`, so STAGES / GIMMICKS / BOSSES all touch `world.gd` AND
`render.gd` — under the same-file rule the whole feature spine is **serial**; only the asset batch
(disjoint `assets/` + `tools/vm100/` manifest files) runs parallel (the N3/M2-rev-2-P2-5 law:
parallel ONLY where file-sets are provably disjoint).

| card | one-line scope | files touched | depends on | can run parallel with |
|---|---|---|---|---|
| `T-M3s-STAGES` | STAGES + `band_at` + run vars + hand-in + persistence + select overlay + unlock check + all Pillar A/B ACCEPT rows | render.gd, game_state.gd, main.gd, save.gd, screens.gd, world.gd (band key + schedule-loop generalization), ground.gd, hud_3d.gd, sim_stages.gd, test_stages.py, test_save.py | — | **asset batch ONLY** |
| `T-M3g-GIMMICKS` | drowned-cairns (stage-item map row + seeding) + pressure-stair (surge/flare/plate billboard) + Pillar A gimmick ACCEPT rows | world.gd, render.gd (STAGES rows fill), pickup_viz.gd, sim_stages.gd, test_stages.py, **test_chests_tiers.py (`SPEC_MAP` re-pin for the added `stage-item` row — the exact-equality law dies on ANY added row, P2-1)** | `T-M3s-STAGES` (needs the table + run vars) | asset batch ONLY |
| `T-M3b-BOSSES` | 2 ENEMY_TYPES boss rows + boss-name HUD readout + drop-site keying + kill-map rows + GLB_FILES +2 + Pillar C ACCEPT rows | world.gd (incl. the §3.1 drop-site keying + the schedule-loop retire-and-replace), render.gd (STAGES boss rows fill), hud_3d.gd, horde_viz.gd, sim_boss.gd, sim_stages.gd, test_boss_numbers.py (the P1-1 retire-and-replace), test_chests_tiers.py (SPEC_MAP 7-row re-pin + drop-site re-pin), test_art_integration.py (coverage re-pin) | `T-M3s-STAGES` (table/loop); **`T-M3a-ASSETS` — the 2 committed boss-mesh rows (P2-2 fold: `test_art_integration.py:83-88`'s file-exists loop requires a real committed `.glb` for every `GLB_FILES` key, so the +2 cannot close green before the meshes land; spine order keeps the asset track first in its windows)** | asset batch ONLY (file-sets disjoint; the ARTIFACT coupling is a real dependency — stated) |
| `T-M3a-ASSETS` | the 3090 batch (§6): icons + 2 boss meshes, manifests + gates only | assets/, tools/vm100/*.tsv | — | **everything** |
| `T-M3z-ACCEPT` | v2.0.0 release cut on the S9/S11 spine + full ACCEPT re-run + doc-sync (this spec's rows) | release spine, LEDGER | all three | — |
| `T-M3e-EVENTWAVE` | **DEFERRED TRACKED ROW (§4):** event-wave + 2 miniboss classes on the surge mechanism + its own DA-gated cards | (post-M3 card) | after M3 ships | — |

**Execution order:** `T-M3s-STAGES` → `T-M3g-GIMMICKS` → `T-M3b-BOSSES` → `T-M3z-ACCEPT` — ONE
serial spine (world.gd + render.gd shared pairwise; the loop-generalization in the STAGES card is
why BOSSES cannot precede STAGES either). `T-M3a-ASSETS` runs off-peak 3090 windows throughout and
**must land its 2 boss-mesh rows before T-M3b closes green** (the P2-2 artifact dependency stated in
the table; icons have no such coupling).
**Doc-sync row (retired-claim doctrine, same commits):** the T-M3z commit rewrites the roadmap M3
landing note (LANDED/DEFERRED per this spec, mirroring the M2 note at `:243-266`), README's feature
list, DESIGN-3D §b if the plate billboard row needs it, `PARITY-ROADMAP.md:42`'s "4 total" claim per
the F-1 resolution, AND (P3-2 fold) `PARITY-ROADMAP.md:276`'s "**+ limit Reaper**" sub-clause —
rewritten to name its deferral exactly as the M2 landing note does ("limit Reaper NOT LANDED —
deferred as card T-M2r-REAPER, roadmap-is-law") — the retired-claim greps return zero for BOTH
rows. Every card appends its LEDGER row in its closing commit.

## 6. ASSET BATCHES (the 3090 = vm100; imagegen + TRELLIS, off-peak windows, drain_barrier +
trap-close per the LEDGER GPU-window pattern; per-row seeds in the manifests)

- **imagegen 2D icons — n = 4:** stage-select thumbnails ×3 (stage 1/2/3, 512² RGBA, §j style
  family) + `icon-plate.png` ×1 (the Pressure-Stair billboard; the cairns REUSE the shipped chest
  icons — zero rows). Provenance = embedded PNG `tEXt` `impeccable:prompt` +
  `tools/vm100/icons-batch-m3.tsv` (the m1c/m2 convention — **no new provenance file**); gate
  `tools/vm100/icon_gate.py` legs apply as shipped.
- **TRELLIS 3D meshes — n = 2:** `cathedral-choir` + `ossuary-warden` boss-class rows,
  4000-tri character budget (the §M1c2 miniboss precedent: knight 3830/4000, deacon 3960/4000),
  height-normalised to `MODEL_H_BOSS 5.33 m` at the ClassMesh seam; `validate_glb` VISUAL +
  `aspect_gate.py` + the **turntable-solid eyeball (yaws 0/90/180/270) as the binding gate**;
  `tools/vm100/art-batch-m3.tsv` manifest.
- **Re-roll reserve (roadmap ~30 % convention, LEDGER yield history T-S1a 10/11, T-M1c 6/10,
  §M1c2 remasters):** **+2 icons, +1 mesh** held, burned only on gate-RED rows.
- **Stated divergences (reasons, not silence):** roadmap §M3-assets (`:282-283`) says 3 tiles +
  2 end-boss + 2 miniboss meshes + ~7 icons. **0 tiles** (F-6: bands compose from shipped BIOMES —
  reuse-first; the v2 tile recipe + readability gate stay the named later route if the owner
  orders new art); **0 miniboss meshes** (they ride `T-M3e-EVENTWAVE`, §4); **3 boss meshes → 2**
  (F-1: the Warden's mesh is shipped); **prop meshes 0** (F-5: the tree has no prop-mesh consumer
  — plates are billboards, cairns ARE chests); thumbnails 3 stay (the select surface is the
  reason SEL-A earns its surface). Pillar batch totals: **4 icons + 2 meshes (+3 reserve rows).**

## 7. BUDGET — re-derived under the roadmap §2 WORST-CASE LOADOUT, incl. end-bosses + gimmick draws

The NAMED loadout is unchanged (roadmap §2: Red Wail / Thousand Darts / Rot Spiral / Judgement
Cross / Eternal Matins / The Sluice, all L8/evolved + the 6 evolution partners; the
`sim_boss.gd:292`/`sim_budget.gd:92` DECLARED-PIN construction channel; play-reachability
explicitly NOT claimed there). **Measured-now values this session: draws 27 / plan 40
(`test_art_integration.py:42`) / hard 60 (`:41`), ALIVE_TARGET 400 (`:44`); horde ≤ 400 with the
403 total reading (400 horde + 3 named once-each spawns) already stated (M2 §7, P3-5).**

- **New draw CLASSES M3 adds: 3, of which at most 2 are ever live at once in a run:**
  (i) 2 boss-class MultiMeshes — a stage run spawns ONLY its own boss (stage 2/3 lists exclude the
  warden/miniboss pair), so a run's live boss-class count stays **1**, exactly as today; the two
  replaced classes are simply idle; (ii) 1 plate billboard MM in `pickup_viz` (the file's own
  `_mm` idiom, drawn only on `ossuary-stair`). Thumbnails/menu UI is CanvasLayer, outside the run
  draw budget like every shipped overlay.
- **Per-stage worst-case tallies (same construction channel, sim_budget leg re-run):**
  stage 1 = **byte-identical 27** (no new class can go live — F-4, and the stage-1 boss list is
  the shipped one); stage 2 ≤ 27 (band classes ⊆ shipped set + choir replaces warden 1:1, zero
  plates); stage 3 ≤ 28 (worst: ossuary + full stage-3 band roster + plate billboard +1 — the
  live 403-era minus the 2 never-live miniboss classes plus 1). **All ≤ plan 40 ≤ hard 60 ⇒
  VERDICT: the ceilings HOLD; `DRAWS_PLANNED` stays 40 (no retire); no exception, no silent
  raise.** Any build card that adds a class outside this list re-tallies + re-pins
  `DRAWS_PLANNED`/`GLB_FILES` in the SAME commit (the standing T-M1g/DA-c1-A-1 rule).
- **Alive:** horde ≤ 400 unchanged (`ALIVE_CAP` pause untouched — the plate surge multiplies the
  rate term INSIDE the untouched `minf(12.0)` ceiling and the cap early-return sits above it: the
  surge structurally cannot breach it); named once-each spawns per stage: 3 (stage 1, 403-total
  reading) / 1 (stages 2–3, 401). Gems bounded ≤ 200 by the merge invariant (unchanged).
- **Contract-B snapshot 12-field impact row (brief §5): ZERO delta.** `stage`/`flare` ride outside
  (`endless`/`cycle` precedent); no phase value added; no weapon-id widening; the endless-off win
  dump stays byte-identical on stage 1 (A-E1).
- **STAGE-persistence row (brief §5):** `stage:int` in `dawnwell.json`, field-by-field ADDED,
  **`VERSION` stays 1** — the version-bump law read: a bump exists to quarantine a shape a loader
  can't migrate; every M3 field is an additive default (the `best_cycle` proof, `save.gd:29-34` +
  `test_save.py:221,231`), and a HIGHER-version save still quarantines (existing rule, untouched).

## 8. EXCLUSIONS (reasons, not silence)

1. **The 25-stage campaign and their 15–30 min limits** (VS-FEATURES S4 ~382-409) — roadmap M3 =
   3 stages (`:41`); our limit is WIN_TIME 900 on all stages (§1.1, one-clock law). Not a
   cloning target.
2. **The 72 named wave bosses** (S5 ~441-457) — not cloned; M3 ships 2 new end-bosses (3 named
   end-bosses total incl. the Warden, F-1); the gap row's "4 total" resolves to the deferred Reaper
   (`T-M2r-REAPER`, already tracked, M2-SPEC §8.3 — no owner artifact retires it). **P3-2 fold:**
   the deferral is named for BOTH live claims — the gap row's "4 total" AND §M3 item 3's
   "+ limit Reaper" sub-clause (`:276`) — T-M2r-REAPER is the deferral card for that sub-clause and
   the T-M3z doc-sync rewrite names `:276` (the retired-claim grep returns zero for both).
3. **Any NEW stage-item / trap / wave SUBSYSTEM** — the gimmicks are composites of the chest
   funnel + spawn loop + band swap (§1.2); no 5th pickup kind (the 4-kind pin), no second spawn
   loop, no new geometry (roadmap's own wording, `:275`).
4. **Event-waves + 2 minibosses** — DEFERRED tracked `T-M3e-EVENTWAVE` (§4, decision + reasons).
5. **Unlock-flag store (roadmap M2 #4) NOT built** — the stage chain rides the EXISTING
   `DawnWell.flags` dict + one `_end_run` check; the 4-sample-chain store + pool-gating table stay
   the named M2 follow-on (roadmap `:238-240, :258`).
6. **New biome tiles / stage-specific prop meshes** — F-5/F-6 (reuse-first + no mesh consumer);
   the v2 tile recipe + `biome_readability` gate remain the named route on an owner art order.
7. **Roadmap §3 standing exclusions unchanged** — co-op, cloud saves, mobile, DLC-flagged
   inventory, counterparts/Inverse, arcana/secrets/spells.
8. **No new capture mechanism anywhere** — every pixel row reuses `dawnwell_pixel_gate.py` (extra
   window), `s8_acceptance.py`, `biome_readability.py` (per-stage windows), `icon_gate.py`,
   `aspect_gate.py`; every sim leg is a new `HD3D_<LEG>_DUMP` SceneTree leg on the existing channel
   (`sim_endless`/`sim_gems` per-leg-env precedent), with committed fixtures — the EXISTING corpus
   as the A-E1 anchor + the forward-lock `stages-m3.jsonl` row).

## 9. THE 10-POINT SELF-DA CHECKLIST (what DA cycle-1 must verify)

1. **Clean-room:** every number OURS and pinned by OUR suite; every "≈their" line cites
   VS-FEATURES as shape only (S4 `:384-386` quotes, S5 `~419`); zero copied value/asset/flavor.
2. **F-1 boss count resolved by file:line,** not taste: the roadmap contradicts itself (`:42` vs
   `:276`); the spec adopts the build row (3 incl. Warden, 2 new meshes) and routes the 4th to the
   already-tracked Reaper card. Contradict it with evidence or adopt it. Rev-2: DA c1 found the
   SAME row's second clause ("+ limit Reaper") and it is now resolved too — named deferral via
   T-M2r-REAPER + the T-M3z doc-sync rewrite of `:276` (§8.2, P3-2 fold).
3. **Version law (§2):** the recommendation (SEL-A ⇒ v2.0.0) is argued from roadmap wording
   (`:63-66`, `:268`, `:270`, `:285`), the unlock-chain observability row, and Rule 2 (no owner
   artifact exists for SEL-B). Attacking the recommendation is welcome; a v1.4.0 outcome REQUIRES
   the roadmap's release spine to be rewritten in the same commit.
4. **Reuse-first / monogamy:** stage = ONE band table generalized (no second biome source);
   gimmicks = chest funnel + ONE rate term + band-swap seam; bosses = latch loop + kill-funnel
   reward law + per-class MM; persistence = ONE save + ONE funnel. Name any exception.
5. **Every ACCEPT row names ONE existing seam** (`sim_headless`/`sim_boss`/`sim_chest_tiers`/
   `sim_budget`/`sim_caps`/`sim_stages`(per-leg env on the existing channel)/`save_probe`/
   `s8_acceptance`/`dawnwell_pixel_gate`/`biome_readability`/`icon_gate`/the table-pin pattern)
   **and no new capture** exists; **every gate can go RED** (existing-corpus byte-stability flip,
   cap-bypass 13/s, map-bypass crash on the KEYED site, stage-2-warden both-side, funnel
   call-count, clamp-row unclamped 22.4 (C-E5), baseline-vs-baseline pixel); the re-pin obligations
   the generalizations create (`test_boss_numbers.py` shape row → dump legs;
   `test_chests_tiers.py` SPEC_MAP + drop-site literal) are declared REPLACE rows, same commits.
6. **Ceilings unbreached:** plate surge multiplies INSIDE the untouched `minf(12.0)` + ALIVE_CAP
   early-return; dwell/seed consume zero RNG (the pinned-stream corpus is loadable proof); flare is
   VISUAL-only (the sim never reads it).
7. **Byte-stability (F-4, re-anchored rev-2):** stage 1 references the shipped consts
   (`BOSS_AT`/`MINIBOSS_AT`/BIOMES rows); the anchor is the **EXISTING committed corpus**
   (`endless-m2`/`gem-merge-m2g`/`chests-tiers-m2`/`unions-m2u` + the journey re-run), never an
   M3-minted fixture (P2-3); the schedule-loop generalization is the riskiest line — verify its
   stage-1 dump legs AND the declared retire-and-replace ledger of
   `test_boss_numbers.py::test_boss_spawns_exactly_once_at_540` (§3.1/P1-1: replace-not-delete,
   same commit), not its prose.
8. **Budget re-derived under the NAMED §2 loadout** with the per-stage tallies (27/≤27/≤28 ≤ 40 ≤
   60), horde ≤ 400 + named spawns (403/401/401), 3 new classes ≤ 2 live at once, DRAWS_PLANNED
   stays 40, and the same-commit re-tally rule for anything else.
9. **Contract B untouched** (F-3 zero-delta row) **and persistence honest:** `VERSION` stays 1 per
   the stated bump law; unlock flags ride `flags` (no new store); chosen stage persists through the
   ONE funnel; fresh-save-locked leg exists (roadmap's own ACCEPT).
10. **Wave-map discipline:** ONE serial spine (world.gd + render.gd shared — verify the file-set
    claims yourself), asset batch the only parallel row; T-M3e-EVENTWAVE is a TRACKED card (defer
    ≠ silence); doc-sync/retired-claim rows (roadmap `:42`, landing note, README, DESIGN-3D §b)
    named for T-M3z; version bump v2.0.0 rides the release card.

## 10. REV-2 CHANGE LEDGER (every rev-1 → rev-2 change by section; DA rows → spec sections)

- **P1-1 fold (the cycle's strongest finding, spec §5):** §1.2 moor-vigil row — the "byte-pinned
  pair stays green" promise replaced by the declared RETIRE-AND-REPLACE row; §3.1 "The schedule loop"
  bullet rewritten as the replace-not-delete ledger (const pin survives verbatim; latch-shape regex
  → C-E1 dump legs incl. a NEW named run-2 re-arm leg; the dump corpus itself untouched green);
  §1.1 closing sentence names it as the exception to the generalization's green-promise; §9.7
  rewritten. Mechanically verified true this session: `test_boss_numbers.py:69-74` regexes
  `if not boss_spawned and game\.time >= BOSS_AT:` and the literal
  `boss_spawned = true … _spawn_enemy("warden", game, view)` site.
- **P2-1 fold:** §3.1 reward-law bullet now names the drop-site seam edit
  (`CHEST_TIER_BY_SOURCE[String(enemy.type)]`, `world.gd:281-283` literal retired, warden
  byte-identity by key), the three added map rows (`stage-item`/`cathedral-choir`/`ossuary-warden`),
  and the `tests/test_chests_tiers.py` re-pin obligations (`SPEC_MAP :100-101/:139/:201`,
  drop-site literal `:145` — UNIFIED-TIER `:263` survives untouched); C-E2 reworded to the keyed
  site; the file joined T-M3g + T-M3b file-sets (§5).
- **P2-2 fold:** §5 wave map — T-M3b `depends on` += `T-M3a-ASSETS` (the 2 committed boss-mesh
  rows; `test_art_integration.py:83-88` file-exists loop evidence cited); execution-order row states
  the artifact coupling (meshes land before T-M3b closes green; icons uncoupled).
- **P2-3 fold:** §1.4 A-E1 re-anchored to the EXISTING committed corpus
  (`endless-m2`/`gem-merge-m2g`/`chests-tiers-m2`/`unions-m2u` + the journey re-run; the
  `test_endless.py:26,42` precedent), `stages-m3.jsonl` demoted to forward lock in A-E1, §1.3 and
  §8.8; §9.7 red-claim reworded; red column = "any of the FOUR existing fixtures flips".
- **P3 folds:** P3-1 §3.1 clamp bound re-derived per base (12→c4 byte-unchanged; 13/14→c3, with the
  19.6/20.8/22.4 arithmetic) + new C-E5 re-pin leg; P3-2 §0 F-1 note + §8.2 + §5 doc-sync row now
  name roadmap `:276`'s "+ limit Reaper" clause and its T-M2r deferral; P3-3 §1.1 placement
  constraint (`STAGES`/`band_at` land AFTER `biome_at`; `test_biome_numbers.py:41-45` slice evidence)
  + A-E2 red extension + the DA machine-test citation for the cross-class const.
- **P4 folds:** P4-1 `:279` citation fix (§2 reason 4) + DECLARED-PIN pattern cites corrected to
  `sim_budget.gd:92`/`sim_boss.gd:292` (A-E4); P4-2 §3.1 NEW spawn-time-scalars bullet
  (`world.gd:145-146` ramp applies, ×2.98 at t=540; HP_CYC/18× structurally cannot touch bosses —
  cycle-0-only latch, `cycle_clear` never re-arms; effective spawn HPs 8,940/12,516/16,688) + the
  enemy-row shape note (`test_boss_numbers.py:84-91`).
- **REBUTTAL: none.** All nine DA rows were independently re-grepped THIS session before adoption
  and found TRUE at the cited file:line; nothing in the fix list is contradicted by the tree. The
  A1/A5/A6/A9/A10 survivals (version law, gimmick composition, deferral, budget, Contract-B) are
  carried unchanged per the DA's own record.

--- END M3-SPEC ---
