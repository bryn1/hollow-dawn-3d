# M3-SPEC — hollow-dawn-3d "Stages" (v2.0.0) — spec for the DA gate

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
  VERSION:23 / flags:28 / best_cycle:34 / load_save:38-61 / as_data:108`.
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
  (:41) stays green (the BIOMES table is untouched data); any pin the generalization falsifies is
  retired+replaced in the same commit (suite-posture law, roadmap §2).
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
| `moor-vigil` | — (F-4 baseline) | the shipped vigil itself: warden@540 + 2 minibosses@600/780 on the latch schedule (`world.gd:164-171`) IS the stage rule row; byte-pinned pair `test_game_numbers.py:35` + `test_boss_numbers.py:64` stays green | as shipped |

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
`tests/fixtures/stages-m3.jsonl`.

### 1.4 ACCEPT (rows → ONE existing seam each; planted-red named; no new capture)

| # | observable | seam (the ONE existing channel) | red |
|---|---|---|---|
| A-E1 | stage-1 **byte-stability**: default-save journey + win-warp replay cmp byte-identical vs committed `stages-m3.jsonl` | `sim_headless` dump cmp (the `endless-m2.jsonl` fixture pattern, A-E6 rev-2) | any gimmick/schedule leak into stage 1 ⇒ cmp flips RED |
| A-E2 | STAGES table pytest pin: ids/names/band `t_start`s/boss rows/limits/unlock levels regex-pinned (OUR numbers); `band_at("moor-vigil", t) == biome_at(t)` at t = 0/150/300/450/900 | the existing table-pin pattern (`test_biome_numbers.py::test_band_t_starts…` :41) | a re-keyed band order ⇒ pin RED |
| A-E3 | stage 2 cairns: 2 ember chests live at t≈0 from the FIXED coords (no RNG — position rows), one walked-into ⇒ open rides the funnel (`pending_levels` +1, weighted pick, gold in tier range); tier byte == the `stage-item` map row (the A-E4/B-T1 single-source law, M2 rev-2 P1) | real drop→`collect_pickups` funnel dump (`sim_chest_tiers` B-T1/B-T2 leg shape) | cairn tier ≠ map row, or a cairn that never opens ⇒ RED |
| A-E4 | stage 3 plate legs (DECLARED-PIN walk, `sim_caps.gd:88`/`sim_budget.gd:92` pin pattern): inside ⇒ rate row ×1.5 AND the `minf(12.0)` cap row still binding; outside ⇒ baseline byte; flare: banner/ground band name = shifted band, decays to base; **RNG-stream row: dwell consumes zero `randf`/`randi`** | `sim_stages` dump (same `HD3D_SEED` + per-leg env channel) | surge that bypasses `minf` (13/s) ⇒ RED; a dwell that draws RNG ⇒ RNG-stream RED |
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
   (fresh save: stage 2 locked)" (`:278`) — a lock is only an observable if the player can SEE the locked
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
  `MAX_CONTACT_DMG 20` at cycle 0, so the existing contact clamp stays vacuous on stage-1 bytes
  and stays a reachable cycle-≥4 bound on stage 3 (M2 §A.1 unchanged — no new cap). Speed drops
  with size (shape consistent with warden 45 / deacon 40). `xp: 0` rides the boss no-gem-rain rule
  (`world.gd:89-93` stated). Spawn at **540 = the shipped BOSS_AT slot** on every stage — the
  limit/540 ratio is the shipped vigil shape; one timing, zero new schedule variety to budget.
- **Enemy rows:** two `ENEMY_TYPES` rows with `"boss": true` + a `name` row (the boss-bar label —
  `hud_3d.gd:33`'s `BOSS_NAME` const becomes a per-boss readout of the row, the ONE bar seam
  unchanged; the bar hides exactly as shipped when no boss exists).
- **The schedule loop, one latch:** `update_spawns`' boss block
  (`world.gd:164-171: `boss_spawned` + `minibosses_spawned` latches) generalizes to iterate the
  stage row's `bosses` list with the same latch-index pattern (the comment "latch first: the
  schedule fires once each" is the mechanism). Stage 1's list IS the const-referenced shipped
  schedule (§1.1 table) ⇒ byte-pins stay green; stage 2/3 spawn ONLY their own end boss (their
  lists contain no warden/miniboss — the both-sides RED is C-E1).
- **Boss death → reward law (ALL shipped seams, zero new code paths):** a `boss:true` death at
  `kill_enemy` (`world.gd:263-286`) already gives: +50 gold (`:269`), guaranteed Dawnlight
  (`:274`), guaranteed chest `CHEST_CHANCE_BOSS 1.0` (`:15, :281-283`) **tiered from
  `CHEST_TIER_BY_SOURCE`** — the single-source map grows two strict rows:
  `"cathedral-choir" → "warden"` (tier II, 2 cards) and `"ossuary-warden" → "dawn"` (tier III,
  3 cards — richest stage ⇒ richest tier, the same provenance as `endless-cycle → dawn`); the
  open rides `try_union → try_evolve → tier cards → gold` (`world.gd:318-327`) and
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
| C-E1 | per-stage boss schedule: stage 2 leg ⇒ `boss_spawn` t=540.017 choir + `boss_once` = 1 + **warden/knight/deacon never appear**; stage 3 analogous; stage 1 legs byte-identical (warden first-seen 540.017 pair stays green) | `sim_boss.gd` schedule/first-seen legs (T-M1d leg shapes), stage-param pins | a stage-2 run that spawns the warden ⇒ RED (both sides per stage) |
| C-E2 | reward law: choir/ossuary kill ⇒ chest 1/1 @1.0, tier byte == the map row (choir→`warden` II, ossuary→`dawn` III), guaranteed heal row, +50 g row, open grants exactly `item_count` cards + in-range gold | `sim_boss` CHEST ROLL LEG + the `sim_chest_tiers` drop-map leg (B-T1 single-source assertion extended to the new map rows) | a boss bypassing the map (strict lookup: a bypassed source crashes at the drop — the planted map-bypass RED from T-M2t rides this) |
| C-E3 (pixel) | the boss bar paints the STAGE's boss name ("THE CATHEDRAL CHOIR" on a stage-2 shot), non-bg ≥ 200 px vs hidden baseline | `tools/s8_acceptance.py` boss-bar crop pattern (the 15,586-px precedent; tick-warp capture reading is the file's stated one) | per-boss name wiring removed ⇒ old const paints ⇒ name-row RED (planted) |
| C-E4 (budget) | stage-3 worst-case re-tally: ossuary live + full stage-3 band roster + plate billboard ⇒ draws ≤ 60 hard, planned-40 pin kept; horde ≤ 400 + named spawns row re-asserted | `sim_budget` WORST-CASE-LOADOUT leg (the §2 construction channel, DECLARED pins) | a new MM class un-retallied ⇒ the coverage/draws pin RED (same-commit rule, DA c1 A-1) |

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
| `T-M3g-GIMMICKS` | drowned-cairns (stage-item map row + seeding) + pressure-stair (surge/flare/plate billboard) + Pillar A gimmick ACCEPT rows | world.gd, render.gd (STAGES rows fill), pickup_viz.gd, sim_stages.gd, test_stages.py | `T-M3s-STAGES` (needs the table + run vars) | asset batch ONLY |
| `T-M3b-BOSSES` | 2 ENEMY_TYPES boss rows + boss-name HUD readout + kill-map rows + GLB_FILES +2 + Pillar C ACCEPT rows | world.gd, render.gd (STAGES boss rows fill), hud_3d.gd, horde_viz.gd, sim_boss.gd, sim_stages.gd, test_boss_numbers.py, test_art_integration.py (coverage re-pin) | `T-M3s-STAGES` | asset batch ONLY |
| `T-M3a-ASSETS` | the 3090 batch (§6): icons + 2 boss meshes, manifests + gates only | assets/, tools/vm100/*.tsv | — | **everything** |
| `T-M3z-ACCEPT` | v2.0.0 release cut on the S9/S11 spine + full ACCEPT re-run + doc-sync (this spec's rows) | release spine, LEDGER | all three | — |
| `T-M3e-EVENTWAVE` | **DEFERRED TRACKED ROW (§4):** event-wave + 2 miniboss classes on the surge mechanism + its own DA-gated cards | (post-M3 card) | after M3 ships | — |

**Execution order:** `T-M3s-STAGES` → `T-M3g-GIMMICKS` → `T-M3b-BOSSES` → `T-M3z-ACCEPT` — ONE
serial spine (world.gd + render.gd shared pairwise; the loop-generalization in the STAGES card is
why BOSSES cannot precede STAGES either). `T-M3a-ASSETS` runs off-peak 3090 windows throughout.
**Doc-sync row (retired-claim doctrine, same commits):** the T-M3z commit rewrites the roadmap M3
landing note (LANDED/DEFERRED per this spec, mirroring the M2 note at `:243-266`), README's feature
list, DESIGN-3D §b if the plate billboard row needs it, and `PARITY-ROADMAP.md:42`'s "4 total"
claim per the F-1 resolution — the retired-claim greps return zero. Every card appends its LEDGER
row in its closing commit.

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
   (`T-M2r-REAPER`, already tracked, M2-SPEC §8.3 — no owner artifact retires it).
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
   (`sim_endless`/`sim_gems` per-leg-env precedent), with committed fixtures (the
   `stages-m3.jsonl` row).

## 9. THE 10-POINT SELF-DA CHECKLIST (what DA cycle-1 must verify)

1. **Clean-room:** every number OURS and pinned by OUR suite; every "≈their" line cites
   VS-FEATURES as shape only (S4 `:384-386` quotes, S5 `~419`); zero copied value/asset/flavor.
2. **F-1 boss count resolved by file:line,** not taste: the roadmap contradicts itself (`:42` vs
   `:276`); the spec adopts the build row (3 incl. Warden, 2 new meshes) and routes the 4th to the
   already-tracked Reaper card. Contradict it with evidence or adopt it.
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
   **and no new capture** exists; **every gate can go RED** (byte-stability cmp, cap-bypass 13/s,
   map-bypass crash, stage-2-warden both-side, funnel call-count, baseline-vs-baseline pixel).
6. **Ceilings unbreached:** plate surge multiplies INSIDE the untouched `minf(12.0)` + ALIVE_CAP
   early-return; dwell/seed consume zero RNG (the pinned-stream corpus is loadable proof); flare is
   VISUAL-only (the sim never reads it).
7. **Byte-stability (F-4):** stage 1 references the shipped consts (`BOSS_AT`/`MINIBOSS_AT`/
   BIOMES rows), every committed dump replays identical (A-E1); the schedule-loop generalization
   is the riskiest line — verify its stage-1 leg, not its prose.
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

--- END M3-SPEC ---
