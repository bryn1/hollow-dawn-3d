# M4-SPEC — hollow-dawn-3d "Nightfall & Legacy" (v2.1.0) — spec for the DA gate

- **REV 1, 2026-10-26.** Build-depth spec for M4, authored for the **devils-advocate gate**
  (fleet law: roadmap-gated build cards file ONLY after the DA SHIPs this — MC 11334, parented
  on `docs/PARITY-ROADMAP.md` rev3 §M4 + the tracked rows `T-M3e-EVENTWAVE` (M3-SPEC §4) and
  `T-M2r-REAPER` (M2-SPEC §8.3)). Same spec depth M2/M3-SPEC gave their milestones (per-pillar
  mechanism + files + ACCEPT rows naming ONE existing seam). A build card executes straight from
  an ACCEPT row; this is not a plan sketch.
- **VERSION DECISION (in the header, per the brief): v2.1.0 (SEL-A).** The roadmap's own version
  law (`PARITY-ROADMAP.md:63-66`: "major = a new player-navigated UI surface (M3 stage select →
  v2.0.0); new subsystems and changed run numbers ride minor (… M4 → v2.1.0)") is honored
  SIMULTANEOUSLY with the release spine — which is only possible because this milestone ships NO
  new player-navigated surface (F-7). Both options and the reasoned recommendation are §5; the
  DA is asked to attack that section first, because the roadmap's OWN §M4 tranche names two
  surfaces (a character purchase screen, an achievements page) — the collision is real, resolved
  openly, not hidden.
- **Scope authority (Rule-2 artifact, quoted):** MC 11334 dispatch brief, owner order "M4 go"
  (2026-10-26) on the clean post-refactor base, scope seed "T-M3e-EVENTWAVE …, T-M2r-REAPER …,
  biome v2 desert tone, + PARITY-ROADMAP next-tranche gaps … you judge milestone-fitting. ONE
  milestone size (M3 precedent: ~4 serial build cards + parallel assets + release). Excess
  backlog = honest split with tracked rows." The cut of §6 (in: event-waves, reaper,
  limit-break-lite, desert tone; out, tracked: characters, achievements page, skins, + the
  pre-existing deferrals) implements that artifact; the landing-note divergence discipline
  (roadmap's own mechanism, `:243-259`/`:299-303`) carries what waits.
- **Code truth:** read THIS session at `origin/master` base `9a60e40` (T-C3, the last clean-code
  card — MC 11316 audit + MC 11317 refactor both closed per the owner's clean-code doctrine
  MC 11318; base >= 9a60e40 as the brief demands). Every dependency claim re-grepped HERE:
  `world.gd BOSS_AT:8 / MINIBOSS_AT:12 / CHEST_CHANCE_MINIBOSS:19 / ALIVE_CAP:20 / GEM_MERGE:29-30 /
  HP_EFFECTIVE_MULT_CAP:41 / hp_cyc·qty_cyc·dmg_cyc:44-53 / CHEST_TIER_BY_SOURCE:76-78 (7 rows,
  `event` STILL the forward-declared reservation) / SPAWN_SURGE:89 / ENEMY_TYPES:98-125 (miniboss
  rows :117-118, end-boss rows :123-124) / schedule_spawned:142 / seed_stage_props:169 /
  _types_open:179 / _spawn_enemy:191-215 (angle :193, ring :187) / update_spawns:218-263 (latch
  :225-240, flare-decay+plate-surge :245-250, cap early-return :251-253, rate term :262, pick
  :263-266) / cycle_clear:334 / kill_enemy:342-368 (keyed boss site :363-365, miniboss literal
  :366-368)`; `main.gd MAX_CONTACT_DMG:20 / _step contact loop :210-222 (clamp :219) / win branch
  :228-240 (the else leg `_end_run("win")` :239-240, regex-pinned by test_endless.py:147) /
  _start_game hand-ins :276-283 / _end_run:320-356 / _meta_changed:374`; `game_state.gd WIN_TIME:7 /
  phase enum :10 / player_speed:80-81 / damage_taken:84-87 / damage_multiplier:90-93 / start_run
  resets :135-138 / snapshot_json:194-211 (exact 12)`; `levelup.gd build_pool:32-67 / bonus_card
  :70-72 / make_offer:80-95 (fill line :92) / apply_offer` ; `screens.gd icon_path()` assert-per-kind (§j
  structural no-blank law); `render.gd BIOMES:68 / STAGES:104 (BELOW biome_at — the slice law) /
  band_at:169`; `horde_viz.gd MODEL_H_*:32-34 / GLB_FILES:41`; `s8_capture.gd HD3D_STAGE variant
  :26-43`; `SimFunnel` = the sim-leg seam (fresh_run opts / check / decline / take_first_card /
  out_path / r3), `sim_stages.gd:98 _check` delegator kept for the `sim_bosses.gd:90,:133`
  duck-surface — this spec's new sim files ride SimFunnel and MUST NOT touch the delegator.
- **Clean-room stance (inherited from `docs/PARITY-ROADMAP.md` §1 honesty rule, binding):**
  *their systems, our content* — `docs/VS-FEATURES.md` (clean-room wiki inventory, MC 11195) is a
  **shape reference only**: the Reaper law (`:378`, VERIFIED quote at `:423`), the wave/300-alive
  rule (`:421`), the swarm/wall event groups (`:462`), Limit Break (`~:473`), characters
  (S6 ~477), achievement chains (S7 ~613-624). THEIRS are shapes; every table below carries OUR
  ids, names, numbers, pinned by OUR suite. No copied value, asset, or flavor text (the named
  VS entities — Trickster/Stalker/Drowner, Pipeestrello et al. — are NEVER reused as ids/names).
- **docs/ARCHITECTURE.md:** ABSENT in this repo and deliberately not created here — the repo runs
  its own spine (`LEDGER.md` + `docs/DESIGN-3D.md` + `docs/PARITY-ROADMAP.md` + `docs/M*-SPEC.md`);
  a second spine beside it is the duplication this repo refuses (M2/M3-SPEC header precedent).
- **Length note (exceeds the ~300 hygiene line, stated why):** one pointable build-depth artifact
  for one release, exactly as M2-SPEC (536 L) and M3-SPEC (667 L) stated; splitting defeats the
  pointable-artifact DoD. Each pillar is self-contained so the DA can gate a single one.

## 0. FINDINGS + STATED READINGS (read before the DA opens any pillar)

Each ambiguity the brief/roadmap left open is resolved with a literal reading; flagged decisions
are **named, not silently chosen**.

- **F-1 (events are stage DATA; stage 1 stays event-free).** The roadmap's M2 #5 (`:241`) names
  a "first event-wave" ("swarm-wall from one edge") with no stage. M3's byte law (rev-3 F-4:
  stage 1 = the current arena, byte-
  stable to every committed dump) makes an event on the moor-vigil row the single biggest
  corpus-falsifier available. **Reading adopted:** events are rows on the STAGES table (the ONE
  schedule source, `render.gd` — the same generalization law as the bosses lists); stage 1's
  `events` row is `[]` (its rule row remains the shipped warden+miniboss vigil), stages 2/3 each
  carry ONE event window at t ∈ [660, 720] — strictly AFTER the 540 boss window and the
  plates-saturation legs (t ≤ 540), which is what lets `stages-m3.jsonl` re-mint as a NAMED-row
  re-pin with its earlier evidence rows byte-preserved (§7.2 R2).
- **F-2 (the Reaper's law is VERIFIED; its switch is our endless precedent).** VS-FEATURES
  `:423` (VERIFIED quote): "If the player survives until the stage's time limit, the stage is
  considered complete, at which point one Reaper will arrive every minute to slay the player and
  end their run, unless Endless mode is enabled." That maps 1:1 onto OUR seams: the limit already
  exists (WIN_TIME, the ONE clock), the "unless Endless" precedence is the existing endless-first
  branch (`main.gd:233`), and the hidden `DawnWell.flags` dict (`save.gd:29`) is the proven night-
  flag channel (endless itself has NO UI — it is seeded via dawnwell.json, LEDGER T-M1g/v2.0.0
  field-test rows). **Design:** `flags["reaper"] = 1` (hidden well flag, same law as endless):
  flag ON and endless OFF ⇒ at 900 the run does NOT end; one reaper arrives at 900, another every
  60 s; a reaper's touch ends the run (gameover, the frozen phase — no 6th phase value). Flag OFF
  (every committed dump) ⇒ `_end_run("win")` byte-identical. **Rejected: making the reaper the
  DEFAULT limit** — that falsifies README's win promise, s8's WIN records (kind="win"), the
  endless A-E1 flag-off-still-wins law (`test_endless.py:244` + `:147`) and the journey win legs —
  a product-identity change with **no owner artifact** (Rule 2). "M4 go" names the deferred
  `T-M2r-REAPER`; it does not name replacing the win screen. If the owner ever rules the reaper
  default, the move is one branch flip at the cap seam — the seam this card lands.
- **F-3 (the `event` chest row stays the reservation; event minibosses ride `miniboss`).**
  `CHEST_TIER_BY_SOURCE` (`world.gd:76-78`) ships 7 rows with `"event": "dawn"` forward-declared
  (M2 §B.1 P4-1). An event-spawned miniboss IS the shipped miniboss CLASS (the hollow-knight/
  deacon law: source-kind literal `"miniboss"` → ember @ 0.6, both share it BY DESIGN — M3 §3.1
  refused per-type miniboss keys for zero observable). Keying event bosses to `event → dawn`
  would make a miniboss kill the richest drop in the game (tier III, 3 cards) — economy
  inversion. **Reading adopted:** the two event minibosses ride the `"miniboss"` literal
  (`kill_enemy:366-368` UNTOUCHED); the map is UNTOUCHED (7 rows) — so `tests/test_chests_tiers.py`
  `SPEC_MAP` exact-equality and the `chests-tiers-m2` embedded map row stay GREEN by
  construction, and `event` remains the named reservation for a future event-DROPS-CHEST mechanic
  (no such mechanic ships here). The DA should attack this row if it disagrees.
- **F-4 (event spawns do NOT bypass ALIVE_CAP — declared divergence from THEIRS).** Their rule
  (`VS-FEATURES:421`, VERIFIED): above 300 alive "only bosses and enemies from map events can
  spawn" — event spawns bypass their pause. OURS: the `ALIVE_CAP 400` early-return
  (`world.gd:251-253`) sits ABOVE the rate term and stays UNTOUCHED; the event surge multiplies
  INSIDE the untouched `minf(12.0)` ceiling exactly like the plate surge (M3 §1.2, the pressure
  stair proved the shape). Reason: the roadmap's budget law (§2: 400-alive is the M1 hard rule;
  every addition re-tallies) — an above-cap channel is a second spawn mechanism beside the pause,
  the duplication this repo refuses. Stated so no later reader "fixes" it toward their behavior.
- **F-5 ("biome v2 desert tone" = re-tone the v2 BURNING DUNES tile).** The brief names it
  without a tracked row behind it. Repo truth: the v2 tiles (T-S15 `fcfde6f`) are "dark gothic
  moonlit family — one anchor material per tile + per-biome hue cast", flattened to an identical
  mean-luma band (measured 30.5–31.1 across all four), which erased the desert band's identity:
  BURNING DUNES (band 2, `render.gd:71-72`, tile `assets/biomes/desert.png`) is the only band
  whose NAME promises warmth the pixel does not deliver. **Reading adopted:** a deterministic
  re-tone of THAT tile — warm dune family inside the SAME measured envelope (§4). Alternative
  readings named and rejected: a NEW desert tile for new stages (no stage needs one — F-1 adds no
  stage); a re-band of t_starts (byte-pinned, `test_biome_numbers.py` N21). If the owner meant
  something else, §4's card is the named point of contact.
- **F-6 (reaper contact is an END, not damage).** `MAX_CONTACT_DMG 20` (`main.gd:20`) is a
  damage-cap law; the Reaper doesn't wound, it ends. The contact loop gains ONE named read
  (the row's `reaper` flag mirrors the `boss`/`miniboss` dict-flag idiom, `world.gd:211-212`):
  reaper inside the existing 55+16 boss radius ⇒ run ends (`_end_run("gameover")`, the frozen
  phase), no HP math, no clamp interaction. The clamp table stays byte-true (no new damage base
  exceeds 13 — §1.2's ladder deliberately REUSES the warden-12/choir-13 bases, so the C-E5
  clamp-bind table M3 shipped (`cycle 3 at 13/14, cycle 4 at 12`) cannot gain a row).
- **F-7 (M4 ships NO new player-navigated surface — the version-law lever).** Event waves are
  spawn-loop behavior; the Reaper rides the hidden flag channel + the EXISTING end screen (a new
  conditional line in the same panel, not a new panel; the boss bar already paints any live boss
  row's `name` — hud_3d's live readout, M3 law); limit-break cards ride the FROZEN level-up
  overlay (`pending_levels → _enter_levelup`, the frozen seam every reward since M1 rides); the
  tile re-tone is a pixel swap at a shipped path. The version law's MAJOR trigger (a new
  player-navigated UI surface) therefore never fires and v2.1.0 is the law's OWN verdict, not an
  avoidance (§5).
- **F-8 (no 4th stage; the roadmap's "their further stages ride M4+" stays open).** Gap row
  `:41` names further stages as M4+ POSSIBLE; the brief's size law (ONE milestone) and the
  roadmap's own Stretch list ("more stages toward 5+", no DoD) keep the stage count at 3 here.
  The event mechanism §1 is exactly the machinery a 4th stage would ride — stated, not built.
- **F-9 (sim_stages.gd stays at 578 L).** MC 11317's DEFERRALS clause assigned the plates-family
  split to "the FIRST M4 card that grows the file". Every new leg in this spec lands in NEW
  per-pillar sim files (`sim_events/sim_reaper/sim_limit`, the per-file-per-pillar convention the
  sim_stages header itself states), so no card grows `sim_stages.gd` and the debt is NOT silently
  inherited — it is re-declared open here for the first card that actually grows the file. The
  `sim_stages.gd:98 _check` delegator (the `sim_bosses.gd:90,:133` duck-surface, MC 11317 C3's
  canary fix) survives untouched: M4 changes no driver surface.

## 1. PILLAR A — EVENT WAVES: A SURGE WINDOW ON THE ONE SPAWN LOOP (+2 miniboss classes)

**Shape ref:** VS-FEATURES §S5 "Special event entities & event 'swarm' groups" (~459–462,
VERIFIED names): "swarm/wall/circle/pile" events are timed map events whose spawns arrive as a
directional group; the wave law (~421) is "one wave every minute" with the 300-alive pause.
THEIRS are names and shapes; OURS below. The M3 §4 DoD for this exact card stated verbatim: "a
directional swarm-wall leg off the single spawn loop (an angle-cone parameter on `_spawn_enemy`,
not a second loop) + 2 miniboss rows + their ACCEPT family" — this pillar is that DoD executed;
the roadmap's own `:241` ACCEPT wording ("swarm-wall from one edge", alive-cap holds) is taken
literally: ONE cone per event, the cap untouched (F-4).

**Reuse (zero new subsystem).** The event window touches only the ONE spawn loop
(`update_spawns:218-263`): while `t ∈ [t0, t1)` on a stage-row `events` entry, (a) the rate term's
`surge` (already a live variable from the plate law, `world.gd:245-250`) takes
`maxf(surge, ev.surge)` — INSIDE the untouched `minf(12.0)` ceiling (`:262`), below the untouched
ALIVE_CAP early-return (`:251-253`); (b) `_spawn_enemy` gains an optional cone parameter —
default `[0.0, TAU]` so the shipped call `angle := randf() * TAU` becomes
`cone[0] + randf() * (cone[1] - cone[0])`, IEEE-exact at the default (0.0 + x ≡ x; TAU − 0.0 ≡
TAU; the RNG consumption COUNT and order are unchanged — the pinned-stream law). Spawn TYPES keep
drawing from the ONE `_types_open` set (`:263-266`) — no swarm-only enemy, no second pool. The
event minibosses ride the ONE schedule latch (`schedule_spawned:225-240` + the defer guard) as
new 660.0 entries on the stage-2/3 `bosses` rows. The ONE chest map is untouched (F-3).

### 1.1 The event rows (OUR numbers, STAGES-table data)

| stage | event id | window | cone (deg) | surge | what arrives |
|---|---|---|---|---|---|
| `moor-vigil` | — (F-1 byte law) | `[]` | — | 1.0 identity | — |
| `sunken-chapel` | **sunken-tide** | [660.0, 720.0] | [135°, 225°] (90° wide, from the west) | **2.0** | the stage's OPEN roster, cone-side + the **sunken-prelate** at 660 (bosses row) |
| `ossuary-stair` | **stair-wall** | [660.0, 720.0] | [315°, 45°] (90° wide, from the east) | **2.0** | the stage's OPEN roster, cone-side + the **stair-acolyte** at 660 (bosses row) |

- `EVENT_SURGE := 2.0` (`world.gd`, next to `SPAWN_SURGE:89`, OUR value: the event is the bigger
  moment of the night than a plate's 1.5). Windows 60 s, fixed cones — the table row is the whole
  mechanism (fixed geometry = **ZERO new RNG consumption**: cone angle still costs exactly one
  `randf()` per spawn; cone selection is a clock comparison, like the plate dwell).
- The row shape extends the STAGES dict exactly as cairns/plates did (`"events": [[t0, t1,
  center_deg, width_deg], …]`); `render.gd` stays the ONE data module, and the slice law
  (STAGES/band_at BELOW `biome_at`, `test_biome_numbers.py:41-45`) is honored — no new const
  above the slice.
- Why 660: strictly after the 540 boss (the night keeps one crescendo order: boss → event wall →
  the two minibosses' own vigil slots stay stage-1-only), after every stages-m3 leg that must
  byte-stay (R2), and 240 s before the win — the wall is the late-night's second act.

### 1.2 The two miniboss rows (OUR ladder; the class law of `:117-118` reused)

| id | stage | hp | dmg | spd | xp | spawn | mesh |
|---|---|---|---|---|---|---|---|
| `sunken-prelate` | 2 | **1500** | **12** | **44** | 0 | 660 (bosses-row latch) | NEW TRELLIS row, 4000-tri class, `MODEL_H_ENEMY 1.42 m` |
| `stair-acolyte` | 3 | **2100** | **13** | **42** | 0 | 660 (bosses-row latch) | NEW TRELLIS row, 4000-tri class, `MODEL_H_ENEMY 1.42 m` |

- **Ladder provenance (ours, stated):** the stage-1 miniboss pair is 900/1400 @600/780; the ramp
  at 660 is ×3.42, so 1500/2100 puts the event minibosses above the stage-1 pair (stage 2/3
  nights are harder — same direction as the end-boss ladder 3000/4200/5600) and an order below
  the end-bosses. **dmg bases REUSE 12/13 on purpose (F-6):** they cannot add a row to the
  contact-clamp bind table. spd 44/42 between deacon 40 and knight 50. `xp: 0` = the boss/miniboss
  no-gem-rain law (`:114-118` precedent).
- **Class law:** `"miniboss": true` dict rows like `:117-118`; drops ride the untouched source-
  kind branch `CHEST_TIER_BY_SOURCE["miniboss"]` @ `CHEST_CHANCE_MINIBOSS 0.6` (F-3); the spawn
  dict already carries the flag (`world.gd:212`). Viz: `horde_viz.gd GLB_FILES` +2 keys, the ONE
  `ClassMesh` loader, per-class MultiMesh, Route-A gait — the exact T-M1g miniboss precedent
  (height row `MODEL_H_ENEMY`, rel_err 0.0 legs).

### 1.3 Files (Pillar A)

`render.gd` (STAGES: stage-2/3 `bosses` entries + the new `events` field on all three rows,
row comments updated), `world.gd` (ENEMY_TYPES +2 rows; `EVENT_SURGE` const; the event-window
loop beside the plate loop; `_spawn_enemy` cone parameter), `horde_viz.gd` (GLB_FILES +2), NEW
`godot/sim/sim_events.gd` (class rides SimFunnel; own env `HD3D_EVENTS_DUMP`; seed-pinned
`HD3D_SEED` default **11334**; committed `tests/fixtures/events-m4.jsonl`), `godot/sim/sim_stages.gd`
(NAMED expectation edits ONLY: the `plates_cap` named-count expectation 1→2 on stages 2/3 — no
leg call-site changes, no surface changes, file NOT grown), `sim_budget.gd` (new
`budget_stage4` legs + `budget_stage3` named-count re-pin), NEW `tests/test_events.py`,
re-pinned rows in `tests/test_stages.py` + `tests/test_art_integration.py`, fixtures
`stages-m3.jsonl` (named-row re-mint) + `art-s2i-probe.jsonl` (forward-lock +2) — all per §7.2.

### 1.4 ACCEPT (rows → ONE existing seam each; planted-red named; no new capture)

| # | observable | seam (the ONE existing channel) | red |
|---|---|---|---|
| A-E1 | **byte corpus untouched on the stage-1 default**: the strict corpus (§7.1: every committed fixture file + the journey re-dump) byte-identical on the T-M4e tree — the stage-1 `events` row is `[]` and the cone default is the IEEE identity | the existing re-run pattern (fresh dump vs committed corpus, `cmp`; the T-C3 gate idiom) | ANY event-window leak into stage 1 flips the journey's spawn digest ⇒ RED (planted: an event row on the moor-vigil table row) |
| A-E2 | STAGES table pin: `events` rows verbatim (stage 1 `[]`; windows/cones per §1.1), the stage-2/3 `bosses` rows RE-PINNED with their 660 entries, stage-1 bosses row STAYS byte-equal to `[[BOSS_AT,"warden"]]+MINIBOSS_AT` | the existing table-pin pattern (`tests/test_stages.py:79-97`) | a re-keyed window/cone value ⇒ pin RED; a stage-1 bosses/`events` edit ⇒ STAY rows RED |
| A-E3 | cone truth: on a stage-2 leg, EVERY spawn during [660,720) has an angle inside the cone (position rows vs the player, same numeric space as the shipped funnel — no px/m bridge, T-M3g law), and OUTSIDE the window spawns return to full circle | new `sim_events.gd` dump (seeded channel, per-leg env), position rows | planted cone `[0, TAU]` in the table ⇒ inside-cone share ≈25 % not 100 % ⇒ RED (named check `cone_share`) |
| A-E4 | surge truth, two legs: (cap leg, shipped rows) during the window the rate is `minf(12.0, …·2.0)` — at minute 11+ BOTH twins run 12/s (the ceiling stays binding, ALIVE_CAP pause intact); (mechanism leg, DECLARED-PIN per the sim_boss/sim_budget pattern) pinning the window to [180,210] ⇒ observed ratio == 2.0 ±acc-tolerance, and planting the surge OUTSIDE `minf` ⇒ 22.2/s | the same `sim_events.gd` channel (DECLARED-PIN leg idiom) | surge outside the ceiling ⇒ ratio 2.0 becomes 22.2/s on the mechanism leg ⇒ RED (`surge_capped` check) — the exact M3 `minf_clamps_surge` precedent |
| A-E5 | zero-RNG law: cone selection consumes ZERO `randf`/`randi` beyond the shipped per-spawn one — twin runs (event window vs the same run pre-window) digest the RNG stream identically through t=660 | dump rows on the same channel (digest rows per the `dwell_zero_rng` idiom) | a `randi()` planted for cone choice ⇒ digests fork at 660 while rates stay identical ⇒ RED (`rng_stream` check), the independent-attribution pattern from T-M3g |
| A-E6 | event-miniboss schedule: sunken-prelate first-seen 660.017 on stage 2 (and stair-acolyte on stage 3), ONCE (latch), NEVER on the other stage and NEVER on stage 1; run-2 `reset()` re-arm leg; chest leg: kill roll rides `0.6` and the tier byte == the MAP's `miniboss` row dumped, not a literal | `sim_events.gd` legs (the `sim_bosses` first-seen/boss_once leg shapes through SimFunnel) + the `sim_chest_tiers` drop-map leg shape | a cross-stage spawn ⇒ both-side leg RED; a tier literal bypass ⇒ map-compare RED (T-M2t planted law re-used) |
| A-E7 | budget: `budget_stage4` leg (the §2 construction channel, DECLARED pins) — stage-2/3 event runs: draws ≤ plan 40 ≤ hard 60, horde ≤ 400 with the named-count reading 402 re-asserted (cap + 2 named once-each) | `sim_budget.gd` WORST-CASE-LOADOUT leg, extended in place (no second budget harness) | a new MM class un-retallied ⇒ the coverage/draws pin RED (standing DA-c1 A-1 same-commit rule) |

## 2. PILLAR B — THE REAPER (T-M2r, landed as the night-flag pursuer)

**Shape ref:** `VS-FEATURES:378/:423` (VERIFIED): stage complete at the limit ⇒ "one Reaper will
arrive every minute to slay the player and end their run, unless Endless mode is enabled."
Their 72 named wave-bosses and their Reaper's name ARE theirs; ours is `the-reaper` with OUR
mesh — the archetype (limit-pursuer), not a clone (roadmap §3 discipline).

### 2.1 Mechanism (F-2's reading, made executable)

- **Flag:** `DawnWell.flags["reaper"]` — the hidden well-flag channel, the ENDLESS precedent
  verbatim (`main.gd:276` hand-in pattern; seeded via dawnwell.json in every endless field test;
  NO UI row ⇒ F-7 holds). `GameState.reaper : bool` joins `endless/cycle/stage` OUTSIDE the
  frozen 12-field snapshot (`game_state.gd:36-47` pattern), reset in `start_run` (`:135-138`),
  handed in at the ONE `_dawnwell → start` seam AFTER `start_run` (`:276-283`).
- **Spawns:** the cap branch (`main.gd:228-240`) gains one named inner fork in the flag-off-
  endless leg: `if game.reaper:` the `_end_run("win")` line does NOT fire; the run keeps
  ticking. The arrival law is a second latch beside `schedule_spawned` (a `reaper_spawned` int on
  `GameWorld`, reset in `world.reset()`): one reaper at `WIN_TIME + 60·n` through the SAME
  `_spawn_enemy` (full circle, default cone). `REAPER_PERIOD := 60.0` (`world.gd`, OUR value —
  their per-minute cadence is the shape; one named const).
- **End law (F-6):** the contact loop (`main.gd:210-222`) checks the row's `reaper` dict flag
  FIRST (the spawn dict gains `"reaper": def.get("reaper", false)` beside the boss/miniboss
  flags, `:211-212` idiom): inside the existing boss-radius test ⇒ `_end_run("gameover")` +
  return — no damage, no clamp, the phase enum untouched.
- **Enemy row:** `"the-reaper": {hp 50000, spd 200, dmg 30, xp 0, boss: true, reaper: true,
  name "THE REAPER"}` (spd 200 > BASE_SPEED 140 + every measured haste build at the 5-stack cap
  (140·1.4 = 196) — the pursuer CANNOT be outrun forever, OUR pin, checked by test; hp is
  "unkillable within the night" (a DECLARED reading: no dps ceiling in the budget doc kills
  50 000 before the speed closes); `xp 0` no gem rain; `boss: true` buys the boss bar (the live
  `ENEMY_TYPES[boss.type].name` readout paints THE REAPER for free, M3's hud law) and the 55 px
  contact radius. Contact `dmg` never reaches the clamp (F-6).
- **End screen (no new surface):** `_end_run` assembles its lines in `main.gd`; with a reaper
  having been live this run it prepends ONE line "The Reaper took you at %s" — the same panel,
  the same `show_end(win=false, lines)` call, the score/time/level/gold rows verbatim (the
  leaderboard JS payload unchanged). Stats read `time > 900` naturally — "stage complete, then
  hunted" is what the numbers say.
- **Precedence:** endless-first, verbatim branch order (`main.gd:233`): reaper flag + endless
  flag ON ⇒ cycle clear fires, NO reaper ever spawns (the "unless Endless" law, an ACCEPT leg).
- **Byte preservation:** flag OFF (every committed dump, s8 WIN records, journey win legs,
  `test_endless.py:147/:244`) the touched code path is one bool test consuming zero RNG, then
  `_end_run("win")` byte-identical. The `the-reaper` ENEMY_TYPES row cannot spawn without the
  flag (its ONLY site is the cap fork).

### 2.2 Files (Pillar B)

`world.gd` (ENEMY_TYPES row + `REAPER_PERIOD` + `reaper_spawned` latch + reset + the spawn-dict
`reaper` flag), `game_state.gd` (`reaper` var + reset; OUTSIDE the snapshot), `main.gd` (hand-in,
cap fork, arrival loop, contact end, end line), `horde_viz.gd` (GLB_FILES +1), NEW
`godot/sim/sim_reaper.gd` (SimFunnel; env `HD3D_REAPER_DUMP`; seed 11334; committed
`tests/fixtures/reaper-m4.jsonl`), `godot/sim/s8_capture.gd` (`HD3D_REAPER=1` DECLARED variant —
the `HD3D_STAGE` variant pattern, `:26-43`) + `tools/s8_acceptance.py` (boss-bar table gains the
reaper-variant row: "THE REAPER" READ, non-bg ≥ 200 px vs hidden baseline), NEW
`tests/test_reaper.py` (+ a `test_save.py` flags-shape STAY row expected untouched — flags dict
already ships).

### 2.3 ACCEPT

| # | observable | seam | red |
|---|---|---|---|
| B-E1 | flag-off byte law: journey + s8 WIN contract-checks + `test_endless` A-E1 rows STAY green on the T-M4r tree (win at 900, kind "win") | the strict-corpus re-run (§7.1) + `s8_acceptance.py` committed records | reaper branch reached on a flag-off path (planted: default the flag true) ⇒ win legs RED everywhere |
| B-E2 | limit behavior, flag ON: at 900.017 kind ≠ win, `the-reaper` first-seen 900.017, boss bar reads THE REAPER (pixel leg), stationary-policy contact ends the run kind="gameover" with `stats.time ∈ (900, 930)` and the end line present | `sim_reaper.gd` dump (stationary scripted policy = the s8 auto-run truth, DECLARED scripted-survival, never a balance claim) | planted: reaper spawns at 840 ⇒ first-seen RED; planted: contact deals 20 instead of ending ⇒ run survives 930+ ⇒ `ends_by_contact` RED (F-6 instrument) |
| B-E3 | arrival law: every 60 s one more reaper — DECLARED-PIN leg (reaper spd pinned 1.0 so the run lives past 960): rows show spawns at 900.017 AND 960.017, count 2 | the same channel, DECLARED-PIN idiom | latch planted once-only ⇒ the 960 row missing ⇒ RED |
| B-E4 | endless precedence: flags endless+reaper ON ⇒ cycle clear at 900/1800 fires, ZERO `the-reaper` spawn rows, kind never gameover-by-reaper | the existing `sim_endless` flag-channel pattern extended (`fresh_run` opts `flags`, both keys) | reaper arriving in endless (planted: check reaper before endless in the cap fork) ⇒ RED — the `:423` "unless Endless" law |
| B-E5 | budget + contract: `budget_reaper` leg (flag-ON stage-1 construction run): draws ≤ 40 ≤ 60, horde ≤ 400, named-above-guard 3 schedule + reapers stated; snapshot exact-12 with `reaper` ABSENT | `sim_budget.gd` leg + the frozen exact-12 pin | a 13th snapshot field ⇒ RED; a new MM class un-retallied ⇒ coverage RED |

## 3. PILLAR C — LIMIT-BREAK-LITE (roadmap M4 item 3)

**Shape ref:** `VS-FEATURES ~:473` (VERIFIED): "upon maxing out all equipped weapon and passive
items … Limit Break upgrades, with each level-up providing an upgrade to a specific stat". THEIRS
is per-weapon-limit-levels (a whole second upgrade system whose quote itself warns evolved
weapons lose the stats); OURS is the roadmap's own lite reading (`:322-324`): a repeatable
all-maxed stat card, our stat-per-card rule. The M2-SPEC reserved it: "that is the roadmap's M4
limit-break-lite" (§A.1, verbatim) — landing it here closes that reservation.

### 3.1 Mechanism (the pool-exhaustion fallback, three rows)

- **Trigger:** `make_offer(game, kind)` (`levelup.gd:80-95`) after the build_pool + the kind
  match: `if kind == "" and pool.is_empty(): pool = LIMIT_CARDS` — the offer funnel unchanged
  otherwise. The exhaustion state = the §2 loadout ITSELF (6/6 slots at MAX_LEVEL, 6/6 carried
  kinds at 5 stacks ⇒ `build_pool` returns empty — `build_pool` UNTOUCHED, caps UNTOUCHED, the
  3-card shuffle UNTOUCHED).
- **Rows (OUR table, `levelup.gd` `const LIMIT_CARDS`):** `LIMIT · FURY` +4% weapon damage /
  `LIMIT · HASTE` +3% move speed / `LIMIT · BULWARK` −1 damage taken — repeatable forever (each
  pick increments the run's `limit` counter row). Icons REUSE shipped files via a new
  `screens.gd LIMIT_ICONS` mapping (the §j total-resolver law runs an `assert` per kind —
  `icon_path()` MUST gain the leg; zero new asset rows, reuse-stated).
- **State + seams:** `GameState.limit := {"dmg": 0, "spd": 0, "arm": 0}`, OUTSIDE the snapshot,
  reset in `start_run`; read at exactly THREE existing seams, each as an ADDITIVE ZERO-IDENTITY
  term (the T-M1h gilded-skull/rotten-plate precedent — shipped terms byte-intact):
  `damage_multiplier()` `+ 0.04 * limit.dmg`; `player_speed()` `* (1.0 + 0.03 * limit.spd)`;
  `damage_taken()` `− 1.0 * limit.arm` (inside the existing `maxf(0.0, …)`, clamped ≥ 0 —
  Bulwark cannot heal damage, checked).
- **What stays byte-identical:** every committed dump (none ever exhausts the pool — grep proof:
  the caps fixture carries ZERO `bonus` rows), the tier/gold paths (`kind != ""` never touches
  LIMIT_CARDS ⇒ the shipped `bonus_card` Coin Cache fill at `:92` stays the ONLY fallback for
  `gold` offers — the TWO committed bonus rows in `chests-tiers-m2`/`chests-evolve-m1e` are the
  living RED probe if this law moves), `PASSIVES` (15) — LIMIT_CARDS is a SEPARATE const so the
  `PASSIVES↔PASSIVE_ICONS` key-set pins (`test_card_icons.py`) cannot read the new rows.

### 3.2 Files (Pillar C)

`levelup.gd` (LIMIT_CARDS const + the make_offer fill + the apply_offer `"limit"` branch),
`game_state.gd` (`limit` dict + reset + the three additive terms), `screens.gd` (LIMIT_ICONS +
the `icon_path` leg), NEW `godot/sim/sim_limit.gd` (SimFunnel; env `HD3D_LIMIT_DUMP`; seed 11334;
committed `tests/fixtures/limit-m4.jsonl`), NEW `tests/test_limit_break.py`, `tests/test_card_icons.py`
resolver/count rows re-grepped + re-pinned same-commit (§7.2 R7).

### 3.3 ACCEPT

| # | observable | seam | red |
|---|---|---|---|
| C-E1 | all-maxed scripted leg (DECLARED-PIN the §2 loadout at caps/L8): every subsequent offer is 3 LIMIT cards, kind "" — and the OFFER never contains `bonus` in that state | `sim_limit.gd` dump; the all-max state built exactly as `sim_budget` constructs the loadout (zero new mechanism) | planted: fallback removed ⇒ offer rows come back kind:"bonus" ⇒ `all_limit` RED |
| C-E2 | both-sides: a NEAR-cap policy run (5 slots full, 5 kinds) shows ZERO limit cards; the caps-pool legs of `sim_caps` stay green | the same channel + the committed `carry-caps-m1b` fixture re-run byte-identical | planted: limit injected on non-empty pool ⇒ near-cap offers contain `limit` ⇒ RED |
| C-E3 | stat math: after k fury / m haste / n bulwark picks the formula rows read `1 + 0.1·ferocity + 0.08·gall + 0.04·k` / `140·(1+0.08·haste)·(1+0.03·m)` / intake `raw − ward − rotten − 1·n ≥ 0` — at 0 picks every row equals the shipped byte values | dump formula rows (the shop_probe/maxhp exact-formula precedent) | a planted 0.05 fury coefficient ⇒ row RED; the zero-picks twin ⇒ byte corpora RED if the identity is not exact |
| C-E4 | gold/tier law intact: `kind "gold"` still yields the untouched bonus fill — the two committed fixture bonus rows (`chests-tiers-m2`, `chests-evolve-m1e`) byte-identical + the `test_chests_tiers.py:231-233` allowed-set rows green | the existing fixture + pin files, UNTOUCHED by design | limit leaking into a gold offer ⇒ the allowed-set rows RED (`"gold": {"bonus"}`) |

## 4. PILLAR D — BIOME v2 DESERT TONE (asset-track; F-5's reading)

- **The change:** regenerate `godot/assets/biomes/desert.png` — same path, same 1024² seamless
  v2 recipe (T-S15: one anchor material + hue cast, deterministic post: multiplicative luma LF
  flatten + luma scale + quarter-band blend), WARM dune identity inside the shipped envelope:
  the T-S15 measured set recomputed on the new tile — wrap-diff ≤ 1.6× the interior strip
  baseline, mean luma 26–36, 8-band delta ≤ 8 (all three named on `fcfde6f`; no committed gate
  script exists for them — grep `tools/` at card time; if still absent, this card LANDS the one
  gate `tools/tile_gate.py` with those thresholds + a planted out-of-band red, the same move §j
  made for icons).
- **Readability stays law:** `tools/biome_readability.py` full 9-window run GREEN (the retone's
  only moved window is stage-1 BURNING DUNES; floors ≤ 34 / blocks ≤ 48 / hero ratio ≥ 2.0, the
  A-E7 bar) + the gate's existing planted-bright-red leg re-proven; the retone that brightens
  the floor past the bar is REJECTED at the gate, not merged.
- **Footprint truth (T-S20 lesson named):** the strips-gate FX footprints compare against the
  MOORLAND-band ground (capture windows ≤ t≈120) — a desert-only retone touches NO compared
  footprint; the card PROVES it (strips gate 19/19 GREEN on a fresh capture, committed dump
  byte-identical modulo the declared norm §7.1) instead of asserting it. If the fresh capture
  disagrees, the T-S20 expectation re-pin (replace-not-delete, measured floor) rides the SAME
  commit — the named fallback, not a hope.
- **Sim truth:** tiles are draw-side only (sim dumps never read pixels; `render.gd` carries the
  PATH strings unchanged) — the strict corpora re-run byte-identical is a row of this card, not
  a §5 assumption.
- **Versioned truth:** the superseded tile is archived (the `assets/biomes/superseded-v1/`
  precedent dir naming + SUPERSEDED note — the fleet versioned-truth law, MC 202610221908), the
  new tile gets PERMANENCE rows (seed, prompt-sha16, window ledger) and a preview shot.
- **ACCEPT (D-E1..D-E3):** D-E1 tile_gate GREEN (planted +20-luma variant RED at the named
  check); D-E2 readability 9/9 GREEN + planted bright RED + byte-exact restore; D-E3 strict
  corpora + strips dump GREEN per §7.1 norms. (Mesh/manifest rows for the three NEW meshes ride
  §8; they are Pillar A/B asset dependencies, not this pillar's subject.)

## 5. THE VERSION-LAW DECISION (SEL-A ⇒ v2.1.0)

The law (`PARITY-ROADMAP.md:63-66`, same revision that also planned §M4): **"major = a new
player-navigated UI surface (M3 stage select → v2.0.0); new subsystems and changed run numbers
ride minor (M1 → v1.2.0, M2 → v1.3.0, M4 → v2.1.0)"**. The collision the DA WILL open: the
roadmap's OWN §M4 tranche (`:315-332`) names a character "purchase screen" and an achievements
"page" — surfaces that would fire the major trigger and falsify the spine's v2.1.0. Both options,
head-on:

**Option SEL-A — M4 as scoped in §6: no new player-navigated surface ⇒ v2.1.0.**
All four shipped items are exactly the law's minor class: new subsystems (event windows on the
spawn loop; the reaper branch; the limit-break fallback) + changed run numbers + an asset retone.
No new overlay, no new menu verb, no new screen (F-7 names the four near-misses and why each is
NOT a surface: hidden flag channel = the endless precedent; end-screen line = same panel; limit
cards = the frozen level-up overlay; tile = a path-swap). The spine number and the law's trigger
are true SIMULTANEOUSLY, with zero doc rewrites beyond the ordinary landing note.

**Option SEL-B — ship the roadmap's surfaces inside this milestone ⇒ the law fires ⇒ v3.0.0.**
Character select + achievements page are player-navigated by their own definitions; the trigger
fires; `:66`'s "M4 → v2.1.0" becomes false and its rewrite needs an owner artifact (Rule 2: none
exists — the only artifact on the table is the MC 11334 brief, which ORDERS the one-milestone
size). It also breaks the size law on measurement, not vibes: the roadmap prices the deferred
items at **11 TRELLIS-class items + 6 rig-retarget runs** (`:328-331`) vs this spec's 3 meshes +
1 tile, on top of ~20 achievement rows and a 6-character stat table.

**Option SEL-C — ship characters WITHOUT a surface (a Dawn Well sub-section / menu cycle).**
Rejected for the reasons M3 §2 already wrote down (surface-stretching: a shop that also picks
nights/characters carries two meanings; a lock/price is only observable where the player can see
it) AND because it still cannot fit the size law — the characters are the 11-mesh + retarget +
stat-table package regardless of which panel hosts their picker; the version would gain nothing
over SEL-A while the milestone doubles.

**RECOMMENDATION: SEL-A ⇒ v2.1.0.** The DA-attack preempt, answered once: *"SEL-A games the law
by hiding the surfaces."* — The law keys on what the RELEASE ships, not on what a later release
may ship; deferral here is not concealment but the roadmap's OWN documented mechanism (its M2
landing note named its NOT-LANDED items — Reaper analogue, event-waves + 2 minibosses, coin-bags,
the roster expansion, the unlock store; its M3 note deferred the whole event-wave pillar —
`:243-259`, `:299-303` — every one named and tracked, which is precisely the state that let MC
11334 order those deferrals INTO M4). The later release that ships a character picker faces the
major decision WITH an owner ruling, and its tracked row (§6) says so; manufacturing v3.0.0 now
to avoid that future conversation would itself be the post-hoc move the law's own wording ("Stated
so M3's major is a rule, not post-hoc", `:66`) exists to prevent.

## 6. WAVE MAP (cards the build wave files; same-file rule ⇒ ONE serial spine)

`world.gd` + `game_state.gd`/`main.gd` + `render.gd` are shared pairwise across the pillars, so
the feature spine is **serial** (N3 law: parallel ONLY where file-sets are provably disjoint);
the asset batch runs parallel in disjoint `assets/` + `tools/vm100/` files, with a stated
ARTIFACT coupling (meshes land before their consumers close green — the M3 P2-2 precedent).

| card | one-line scope | files touched | depends on | can run parallel with |
|---|---|---|---|---|
| `T-M4e-EVENTWAVE` | events + 2 miniboss classes + Pillar A ACCEPT (A-E1..A-E7) + the stages-m3 named-row re-mint | render.gd, world.gd, horde_viz.gd, sim_events.gd NEW, sim_stages.gd (expectation edits only), sim_budget.gd, tests/test_events.py NEW, test_stages.py, test_art_integration.py, fixtures events-m4 + stages-m3 + art-s2i-probe | — | **asset batch ONLY** |
| `T-M4r-REAPER` | the-reaper row + flag hand-in + cap fork + arrival latch + contact end + end line + Pillar B ACCEPT (B-E1..B-E5) + s8 variant | world.gd, game_state.gd, main.gd, horde_viz.gd, s8_capture.gd, tools/s8_acceptance.py, sim_reaper.gd NEW, tests/test_reaper.py NEW, fixtures reaper-m4, test_art_integration.py | `T-M4e` (world.gd, horde_viz.gd); **`T-M4a` — the reaper mesh** | asset batch ONLY |
| `T-M4l-LIMITBREAK` | LIMIT_CARDS + exhaustion fallback + three seams + Pillar C ACCEPT (C-E1..C-E4) | levelup.gd, game_state.gd, screens.gd, sim_limit.gd NEW, tests/test_limit_break.py NEW, test_card_icons.py, fixture limit-m4 | `T-M4r` (game_state.gd shared) | asset batch ONLY |
| `T-M4a-ASSETS` | §8 batch: 3 TRELLIS meshes (sunken-prelate, stair-acolyte, the-reaper) + the desert retone + manifests + gates + D-E1..D-E3 | assets/glb/ +3 (+sidecars), assets/biomes/desert.png + superseded archive, PERMANENCE.md, tools/vm100/art-batch-m4.tsv (+regen), tools/tile_gate.py (if absent), preview shots | — | **everything** (disjoint files; artifact coupling: its mesh rows gate T-M4e/T-M4r closes) |
| `T-M4z-ACCEPT` | v2.1.0 release cut on the S9/S11 spine + full ACCEPT re-run + doc-sync + the **GitHub-Release doctrine trio** (MC 11277, owner 2026-10-25, as rows: (1) release-notes body COMMITTED as `docs/RELEASE-v2.1.0.md` — what shipped + known limits + the honest not-shipped line; (2) README current AT the tag; (3) doc-sync grep-to-zero sweep) + GA (`gh release create`, both zips, digests re-checked live) | release spine, LEDGER, README, docs/ | all four | — |

**Execution order:** `T-M4e → T-M4r → T-M4l → T-M4z` — ONE serial spine (pairwise shared files,
each edge named in the table); `T-M4a` runs off-peak 3090 windows throughout and MUST land its
two event-miniboss mesh rows before T-M4e closes green and its reaper row before T-M4r's.
**Doc-sync row (retired-claim doctrine, same commits):** T-M4z rewrites the roadmap M4 landing
note (LANDED: event-wave + reaper + limit-break-lite + desert tone, each named with its cards;
NOT LANDED named-tracked: characters, achievements page, skins, coin-bags, roster-expansion,
unlock-flag store — the same wording discipline as the M2/M3 notes), roadmap gap rows 5/6/10
CURRENT cells re-grepped, README feature list + version line, DESIGN-3D §b if the draw re-tally
moves its arithmetic, DOD-ACCEPTANCE N-table re-pins this wave falsifies. Every card appends its
LEDGER row in its closing commit (one-ledger law).

**Tracked deferrals this spec OWNS or re-names (not silence — roadmap-is-law rows):**
`T-M4c-CHARACTERS` (roadmap M4 item 1: 6 characters + purchase screen — **the release that lands
it carries the SEL version decision to the owner: a real surface fires the major trigger**; its
ACCEPT family re-pins this spec's `test_endless` A-E1 law as-is), `T-M4p-ACHIEVEMENTS` (page,
roadmap item 2, ~20 rows; same surface law), `T-M4k-SKINS` (item 4, 5 skins on the existing rig),
`T-M2c-COINBAG` (M2-SPEC §8.1), roster-expansion (+8/+5, M2-SPEC §8.5), unlock-flag store
(roadmap M2 #4). Consumed and CLOSED by this milestone: `T-M3e-EVENTWAVE` (T-M4e) and
`T-M2r-REAPER` (T-M4r) — the T-M4z landing note retires both names grep-to-zero, replace-not-
delete (the retired rows' claims re-appear as the LANDED cells).

## 7. BYTE ANCHORS, NORMS, AND THE RETIRE LEDGER

### 7.1 The corpus law (post-MC-11317, restated for this milestone — the three classes)

1. **STRICT, byte-identical (`cmp`)**: the committed fixture corpus — ALL files under
   `tests/fixtures/` (`endless-m2` / `gem-merge-m2g` / `unions-m2u` / `chests-tiers-m2` /
   `chests-evolve-m1e` / `carry-caps-m1b` / `skinned-clips-s2r-framediff.csv` / `stages-m3`
   (carve (a)) / `art-s2i-probe` (carve (b))) — plus the `sim_headless` **journey re-dump**
   (5020 rows) re-dumped FRESH on the card's tree with the channel's own pinned seed vs the
   committed records (the T-C3 gate idiom: fresh worktree, fresh dump, `cmp`).
2. **MODULO the declared mechanical norm**: the strips dump (`hd3d-strips-s2h`-lineage, the
   committed acceptance dump) compares after removing engine `_ms` fields and rewriting capture-
   dir `png`/`png_path` prefixes to `CAPDIR`; every measured value byte-equal otherwise (the exact
   C3 wording governs).
3. **RUNTIME RECORDS, contract checks (NOT byte identity)**: the `.tmp` s8 `gameover/win` dumps —
   declared pacing-chaotic runtime records; fresh re-runs pass the A1 contract checks
   (kind/hp-pin/monotonicity/t_sim/kills); the committed GA records keep `s8_acceptance.py` 10/10
   green from a clean checkout (proven at 1478259) and the table's own planted kind-flip red
   control stays the file's law.
- **M4 carves (declared IN this spec, so no card re-litigates them):** (a) `stages-m3` re-mints
  under R2 (named rows only move); (b) `art-s2i-probe` grows as a FORWARD LOCK under R4 (prior
  rows byte-preserved — the T-M3b "13 base rows byte-preserved" precedent, grown twice);
  (c) the three NEW fixtures (events/reaper/limit) are generated TWICE cmp-identical before
  commit and are forward-locks for M5, never this milestone's anchors. Every planted-red leaves
  the tree byte-exact-restored (`git` clean / `cmp`) and the suite green after.

### 7.2 RETIRE LEDGER (every pinned row this milestone moves; REPLACE-NOT-DELETE, SAME COMMIT)

| # | row moved | falsified by | replacement (equal-or-stronger, named) |
|---|---|---|---|
| R1 | `tests/test_stages.py:81-82` stage-2/3 `bosses` exact rows | T-M4e (660 miniboss entries) | re-pinned exact rows WITH the new entries + NEW `events` field pins (A-E2) + the stage-1 rows stay pinned byte-equal (the STAY probe) |
| R2 | `stages-m3.jsonl`: `stage2_schedule`/`stage3_schedule` spawn lists, `plates_cap` named count, verdict rows | T-M4e (660 spawns exist; named-each now 2 per stage) | re-minted named rows (fired-schedule WITH the 660 entry at 660.017, named 2); **all other evidence rows — stage1_schedule, schedule_rearm, cairns, rng_stream, plates_rate, plates_saturation twins — asserted BYTE-PRESERVED in the re-mint** (window ≥660 > their legs' t ≤ 540; twice-cmp-identical regeneration) |
| R3 | `sim_stages.gd` `plates_cap` expectation line (named ≤ 1 → ≤ 2) | T-M4e (same truth R2 names) | edited expectation line + its comment names R2 (no leg call-sites, no file growth — F-9) |
| R4 | `tests/fixtures/art-s2i-probe.jsonl` (15 rows) + `test_art_integration.py` coverage/file-exists rows | T-M4e +2 classes; T-M4r +1 | forward-lock growth 15→17→18, every prior row byte-preserved; coverage re-pin in BOTH commits (the T-M1g/T-M3b precedent) |
| R5 | `sim_budget.gd` `budget_stage3` named-count reading + test row | T-M4e (402, not 401) | re-pinned reading + new `budget_stage4`/`budget_reaper` legs (A-E7/B-E5) |
| R6 | `tools/s8_acceptance.py` table (10 rows) | T-M4r adds a row | ADDITIVE: the reaper-variant boss-bar row joins with its own planted red; the 10 existing rows UNTOUCHED |
| R7 | `tests/test_card_icons.py` resolver-coverage/count rows that enumerate card kinds | T-M4l (3 new card kinds) | LIMIT_ICONS mapping rows join the resolver pin; any kind-COUNT row is retired-and-replaced with a note; the `PASSIVES↔PASSIVE_ICONS` key-set pins stay untouched BY DESIGN (LIMIT_CARDS is a separate const) |
| R8 | source-regex pins that read `player_speed`/`damage_taken`/`damage_multiplier` expressions verbatim | T-M4l (appended zero-identity terms) | re-grep at card time; the terms APPEND (shipped sub-terms byte-intact); any regex that reads the WHOLE expression retires to the dump-formula rows (C-E3) in the same commit — the M3 §3.1 replace-to-dump-leg pattern |

Nothing else is touched by design: `SPEC_MAP`/the 7-row chest map (F-3), `BIOMES` t_starts/rosters
(N21), `WIN_TIME`/`BOSS_AT`/`MINIBOSS_AT` pins, the phase enum, the exact-12 snapshot pin, the
`test_endless` byte laws, `test_chests_tiers` :231-233 allowed sets (C-E4), and the
`sim_stages.gd:98` `_check` delegator (F-9) all STAY GREEN — each is a named STAY-probe in the
ACCEPT tables above.

## 8. ASSET BATCH (the 3090 = vm100; imagegen + TRELLIS, off-peak windows, drain_barrier +
trap-close + per-close llama-swap-serving check; windows ledger inside the capture; single-row
windows after the MC 11236 lesson)

- **TRELLIS meshes — n = 3:** `sunken-prelate`, `stair-acolyte` (4000-tri character class,
  height-normalised to `MODEL_H_ENEMY 1.42 m` at the ClassMesh seam — the T-M1g miniboss
  precedent) + `the-reaper` (4000-tri class at `MODEL_H_BOSS 5.33 m`, the T-M3a/T-M3b boss-class
  precedent). Gates EXACTLY as the M3 batch: `validate_glb` VISUAL, the height/art-s2i rows
  (rel_err 0.0), and the **bpy turntable-solid eyeball (yaws 0/90/180/270) as the BINDING prop
  gate** (automated extent/fill gates no-op non-watertight meshes — the recorded blind spot,
  followed not re-litigated); **pose-class lesson APPLIED**: coil/helix shatter classes rejected
  pre-commit (the §M1c2/T-M2a rule), solid/armored poses ship. Manifest `tools/vm100/art-batch-m4.tsv`
  (seeds + prompt-sha16 per row) + PERMANENCE provenance rows.
- **imagegen tile — n = 1:** the desert retone (§4; the v2 recipe's deterministic post chain is
  part of the contract, so the tile is reproducible from the manifest + the recipe commit).
- **Re-roll reserve (~30 % law, the S1a/§M1c/T-M2a yield history):** **+1 mesh, +1 tile**, burned
  only on gate-RED rows; an unburned reserve is stated.
- **Icons — n = 0 (stated divergence from the roadmap's ~6-badge M4 line):** limit cards REUSE
  shipped icon files (LIMIT_ICONS, the §j total-resolver law met with reuse); portraits/badges
  ride the deferred character/achievement cards. No new icon rows, so no icon-gate rows.
- **Windows-closed law (every card restates it because every card loses one to it):** per-row
  window, drained barrier before close, trap-close rc=0, llama-swap serving verified at each
  close; an un-closed window is an honest deviation NAMED in the capture.

## 9. BUDGET — re-derived under the roadmap §2 WORST-CASE LOADOUT

The NAMED loadout is unchanged (Red Wail / Thousand Darts / Rot Spiral / Judgement Cross /
Eternal Matins / The Sluice, L8/evolved + the 6 partners; the `sim_boss`/`sim_budget`
DECLARED-PIN construction channel; play-reachability explicitly NOT claimed — roadmap §2).
Measured-now truth (T-M3b/T-C3): draws **27** ≤ plan **40** (`test_art_integration.py:42`) ≤ hard
**60**; horde **≤ 400** with the 403-total reading on stage 1; gems ≤ 200 (merge invariant).

- **New live classes per run:** stage 2 + sunken-prelate (event), stage 3 + stair-acolyte
  (event), flag-ON stage-1 runs + the-reaper. Worst-case per-run tallies (same construction
  channel): stage 1 **byte-identical 27**; stage 2 ≤ 28; stage 3 ≤ 28→29 (acolyte + plate
  billboard + own boss; the named budget leg MEASURES, this line bounds); reaper run ≤ 28.
  **All ≤ 40 ≤ 60 ⇒ the ceilings HOLD; `DRAWS_PLANNED` stays 40 (no retire); no exception, no
  silent raise.** Anything adding a class outside this list re-tallies + re-pins in the SAME
  commit (standing DA-c1 A-1 rule).
- **Alive:** horde ≤ 400 UNCHANGED — the event surge multiplies INSIDE `minf(12.0)` and the
  ALIVE_CAP early-return sits above it (F-4: no above-cap channel, unlike THEIRS, stated);
  named once-each spawns: stage 1 = 3 (403 reading), stages 2/3 = **2** (402 readings — R5's
  re-pin), reaper runs: 3 + one reaper per 60 s above the guard **BY DESIGN** while flag ON (the
  pursuer is the design; budget leg states both readings).
- **Limit-break deep growth:** endless-only reachable (the pool cannot exhaust before ~54 picks;
  the journey legs exhaust nothing — zero-identity proof C-E3's twin); stat growth is additive
  and small (4%/3%/−1), NOT a second scaling ramp beside the cycle scalars — it is their lite
  shape and it lives INSIDE the run-state the caps govern.
- **Contract-B snapshot 12-field impact row: ZERO delta.** `reaper`/`limit` ride outside
  (endless/cycle/stage/flare precedent); no phase value; no weapon-id widening.
- **Persistence row: NO new save field.** reaper rides the existing `flags` dict (the endless
  and stage-flag precedents); `VERSION` stays 1 (the bump law, M3 §7: additive-default fields
  only, and there are none this milestone).

## 10. EXCLUSIONS (reasons, not silence)

1. **Characters, achievements page, skins** (roadmap M4 items 1/2/4) — the MC 11334 size law;
   tracked `T-M4c/T-M4p/T-M4k` (§6) with the future surface's version decision named for the
   owner there. Not silently dropped: this milestone's landing note carries them.
2. **The 72 named wave-bosses / event swarms** (`VS-FEATURES` ~441-462) — not cloned; M4 ships 2
   OUR miniboss classes + 1 OUR pursuer riding the event shape; their names never ship.
3. **Event spawns above the alive cap** — THEIR pause-exemption (`:421`) is rejected (F-4, the
   budget law).
4. **The reaper as the DEFAULT limit** — no owner artifact (F-2, Rule 2); the flip stays a
   one-branch, one-ruling distance away.
5. **Their per-weapon Limit Break levels** (~473 full shape) — the roadmap itself scoped M4 to
   limit-break-lite; per-weapon LB levels + the evolution-interaction the quote warns about are
   out.
6. **New stages / a 4th stage** — F-8 (Stretch, no DoD); the event + STAGES machinery is exactly
   what one would ride.
7. **Any NEW pickup kind, drop funnel, spawn loop, overlay, capture mechanism, or sim-side RNG**
   — every pillar composed from shipped seams (§1-§4); new sim legs are new files on the
   EXISTING seeded dump channel; every pixel row reuses `s8_acceptance.py`/`biome_readability.py`
   (+ the one named `tile_gate.py` IF the §4 grep finds the T-S15 measurements still scriptless —
   then it lands as THE committed tile gate, planted-red included).
8. **Roadmap §3 standing exclusions unchanged** — co-op, cloud saves, mobile, DLC-flagged
   inventory, counterparts/Inverse, arcana/secrets/spells.
9. **Coin-bags, the roster expansion, the unlock-flag store** — pre-existing tracked deferrals
   (M2-SPEC §8.1/§8.5, roadmap M2 #4); named again in the landing note, not absorbed.

## 11. DA-ATTACK PREEMPTIONS (the tail — attacks I expect and the row that answers)

- *"Your event waves change every run — the byte corpus is dead."* — They change stage-2/3 runs
  only, after t=540, and stage 1 carries `events: []` (F-1); the strict corpus list + the three
  declared norms are §7.1, and A-E1 is the leak instrument (a planted stage-1 event row IS the
  red). The rows that legitimately move are R1-R5, each with its equal-or-stronger replacement.
- *"v2.1.0 games the version law."* — §5 SEL-A/SEL-B/SEL-C: the shipped milestone contains no
  navigated surface (F-7 names each near-miss); the spine and the law are simultaneously true;
  the roadmap's own landing-note discipline is the deferral mechanism the roadmap itself uses.
- *"A hidden-flag reaper is a feature nobody can play — is it even shipped?"* — It is the
  endless mode's own law (no UI since v1.3.0, owner-field-tested via seeded flags); B-E2/B-E3/
  B-E4 prove behavior on the seeded channel and the pixel leg proves the bar; shipping the UI
  toggle is a one-row card the owner can order any time (display-only, like the cycle-HUD glyph
  note in M2).
- *"Limit-break breaks the gold/bonus law."* — The fallback fires ONLY at `kind == ""` with an
  empty pool; the two committed bonus rows are the living probe (C-E4); `build_pool` is untouched.
- *"The reaper bypasses MAX_CONTACT_DMG, a second damage path."* — F-6: it is an END condition,
  not damage; the clamp law's table is byte-true and cannot gain a row (dmg bases reused 12/13).
- *"Two new enemy classes must break the draw budget."* — §9: ≤2 live new classes per run at the
  worst, measured on the §2 construction channel (A-E7/B-E5), `DRAWS_PLANNED` 40 unconsumed.
- *"You grew sim_stages and dodged the plates-split debt."* — F-9: it is not grown; new files
  carry new legs; the debt is re-declared, not inherited silently.
- *"This is a clone of the Reaper/event names."* — clean-room header + §10.2: shapes cited to
  VERIFIED lines, every shipped id/name/stat OURS, pinned by OUR suite.

## 12. THE 10-POINT SELF-DA CHECKLIST (what DA cycle-1 must verify)

1. **Clean-room:** every number OURS and pinned by OUR suite; every "their" line cites
   VS-FEATURES shape quotes (`:421`, `:423`, `:462`, ~`:473`); zero copied value/asset/name.
2. **F-1 stage-gating resolved by file:line** (the stage-1 byte law vs the roadmap's unlocated
   "first event-wave"): adopt or contradict with evidence; the cone-default IEEE identity claim
   (`0.0 + randf()·TAU ≡ randf()·TAU`) is mechanically checkable.
3. **Version law (§5):** the SEL-A recommendation argues from roadmap wording (`:63-66` vs
   `:315-332`) + Rule 2; a v3.0.0 outcome REQUIRES the owner artifact the spec names; attack the
   collision, not a strawman.
4. **Reuse-first / monogamy:** events = the ONE rate term + the ONE schedule latch + the ONE
   `_types_open`; reaper = the ONE cap branch + the ONE contact loop + the ONE flags dict;
   limit-break = the ONE offer funnel + THREE existing stat seams; tile = a path-swap. Name any
   exception (the reaper contact-check and the tile-gate-if-absent are the two declared ones).
5. **Every ACCEPT row names ONE existing seam + a planted red that names its check**; the
   new sim files ride SimFunnel (no new leg plumbing) and the `sim_bosses.gd:90/:133` duck-
   surface via `sim_stages.gd:98` survives untouched (F-9).
6. **Ceilings unbreached:** surge inside `minf(12.0)`, cap return above it (F-4); zero new RNG
   consumption outside shipped sites (A-E5); reaper spawns cannot exist without the flag (its
   ONLY construction site is the cap fork — verify the grep yourself).
7. **Byte-stability:** §7.1's three classes + the two declared growth carves (R2/R4); anchors are
   the EXISTING committed corpus re-dumped fresh, never an M4-minted fixture; planted-reds
   byte-exact-restored; the strict list is the committed fixture corpus + the journey re-dump,
   and this spec's OWN tree claims
   they are GREEN as of `9a60e40` — re-run, don't trust.
8. **Budget re-derived under the NAMED loadout** with per-stage/reaper tallies (27/≤28/≤29/≤28 ≤
   40 ≤ 60), named counts (3/2/2 + pursuers-by-design), `DRAWS_PLANNED` stays 40, and the
   same-commit re-tally rule.
9. **Contract B untouched and persistence honest:** zero snapshot delta; NO new save field
   (flags dict reuse); the frozen `win`-branch regex pin (`test_endless.py:147`) stays byte-true
   on the flag-off path — A-E1's corpus is the instrument.
10. **Wave-map discipline:** ONE serial spine with the pairwise file edges NAMED (verify them);
    asset batch the only parallel row with the mesh artifact coupling; the tracked deferrals
    (incl. the surface-release version decision handed forward to the owner) named, not silent;
    the T-M4z release row carries the GitHub-Release doctrine trio as DoD; every card's LEDGER
    row in its closing commit.

--- END M4-SPEC ---
