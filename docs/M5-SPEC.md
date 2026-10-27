# M5-SPEC — hollow-dawn-3d "Roster & Legacy" (v3.0.0) — spec for the DA gate

- **REV 2, 2026-10-27, after DA cycle 1** (`docs/M5-SPEC-DA.md` @ `9b1d067`, VERDICT FIX,
  1P1/4P2/3P3/4P4 — the DA doc is immutable; THIS doc revises in place, M2/M3/M4-SPEC
  precedent). ALL TWELVE findings ADOPTED, each re-grepped against the tree at `9b1d067`
  BEFORE adoption — the per-row dispositions (adopted / adopted-with-mechanism-correction,
  each with its re-grep evidence) are the §12 REV-2 fold ledger; **0 rebuttals** — the P1 and
  all four P2s are real and their fix clauses adopted AS WRITTEN; only two MECHANISM readings
  inside adopted rows are corrected to measured truth (the spec's own law: the reason must
  state the truth, not the stale story). The P1-1 pawn apply-step (§2.1b + B-E7), the FORCED
  above-the-gold-line landing (§1.1 + P2-1 pin-hold clause), the `duplicate()` law + the
  multi-run aliasing leg (§0 F-5 + B-E2), the zero-DIFF P-E1 leg and the REAL P-E3
  instruments (§1.3) land as named lines; the six drifted header cites, the 18-row fixture
  count and 537 de-staled (P3-1/2/3); the four P4s folded inline. The gate's grounding-
  PASSes ride unchanged (F-1, the version law + the `:336-338` quote re-read verbatim, F-3's
  zero-world.gd proof, the SEL arithmetic + option-independence re-derived per option, R1
  VERBATIM-exact, the green base independently re-reproduced by the gate: 278 passed,
  PYTEST_RC=0; REV-2 re-verified the suite ON THIS REV'S TREE: 278 passed, PYTEST_RC=0 —
  warm-cache run, the canonical cold `--import` timing stays the line below) — **the design
  core is unchanged; SEL and the OWNER-DECISION-PENDING marker
  are UNTOUCHED.** REV 1 stays below as lineage.
- **REV 1, 2026-10-27.** Build-depth spec for M5, authored for the **devils-advocate gate**
  (fleet law: roadmap-gated build cards file ONLY after the DA SHIPs this). Parented on
  `docs/PARITY-ROADMAP.md` rev-3 §M4 (the tranche whose roster half M4 deliberately deferred)
  + the tracked rows `T-M4c-CHARACTERS`, `T-M4p-ACHIEVEMENTS`, `T-M4k-SKINS` (M4-SPEC §6 /
  the roadmap's own M4 landing note `:336-339`). Same spec depth M2/M3/M4-SPEC gave their
  milestones: per-pillar mechanism + files + ACCEPT rows naming ONE existing seam. A build
  card executes straight from an ACCEPT row; this is not a plan sketch.
- **MILESTONE + VERSION (header decision, per the brief): v3.0.0.** The version law
  (`PARITY-ROADMAP.md:63-66`: "major = a new player-navigated UI surface (M3 stage select →
  v2.0.0)") fires HERE: M5 ships TWO player-navigated surfaces — the character-select/purchase
  screen and the achievements page (§1/§2). The law's MAJOR trigger and the release are true
  simultaneously, exactly as M3's stage-select earned v2.0.0. §5 states the decision + the
  owner-ratification line the roadmap's own landing note promised this release would carry.
- **⚠ OWNER-DECISION-PENDING — THE ROSTER SIZE (the §2 SEL table).** No owner artifact chooses
  the roster size (Rule 2: no artifact = no decision). The roadmap row 7 names "6 selectable"
  (roadmap REV 3, 2026-10-23, unchanged); the brief forbids assuming it. **RECOMMENDATION: SEL-A = 6
  characters (the roadmap's own number)** — the full SEL table with per-option mesh counts,
  3090-window estimates, test-row counts and byte-anchor risk is §2.5; every non-default
  number in this spec is written so the build wave can shrink or grow to B/C WITHOUT
  re-basing the mechanism (§2.5's law). The build cards file after BOTH this spec's DA gate
  AND the owner's roster ruling.
- **Base + suite truth (verified THIS session, the author's own worktree):** spec authored at
  `origin/master = 48f5b33` (T-M5b C4, the v2.1.0-era clean-code close; the clean-code-after-
  milestone doctrine is satisfied — MC 11316/11317 audit+refactor-1 AND MC 11398/11401
  audit+refactor-2 all closed). Fresh worktree, Godot 4.7.2 `--import` first, full suite:
  **`278 passed in 157.24s (0:02:37)`, PYTEST_RC=0** — the base is GREEN at the spec's base
  commit, the DoD's first line, pasted verbatim.
- **Scope authority (Rule-2 artifact, quoted):** the owner's standing objective (verbatim in
  the run goal, carried since MC 11094): *"find the game vampire survivor and make our own
  version of the dame game. Own graphics with 3090 gpu comfyui for art… DoD is full playable
  game… I want the 2d version completed and tested and working, then a 3d remake…"* The 2D v1
  (`vampire_survivor`, untouched per every brief) is the completed-and-tested half; THIS repo
  IS the 3D remake (DESIGN-3D §a-§d, fully executed — F-1). The M5 tranche implements the
  roadmap's OWN named deferrals (§6); the MC 11402 brief orders exactly this: "propose the
  NEXT milestone that moves toward '2D completed and tested, then 3D remake' — characters /
  achievements / skins / endless-depth / evolutions / stages / or a 3D pivot — recommendation
  required, with WHY now" (paraphrase; the verbatim dispatch rides the MC card).
- **Code truth (every claim re-grepped THIS session at `48f5b33`; six cites REV-2-corrected at
  `9b1d067` per DA P3-3 — the tree is byte-identical between them, docs-only parent, so the
  drift was in MY cites, re-measured once and the numbers below are the truth):**
  `game_state.gd` (254 L —
  `BASE_SPEED:5 / MAX_HP:8 / run vars endless:36 cycle:37 stage:47 reaper:57 limit:66 /
  player_speed():98-101 / damage_taken():104 / damage_multiplier():114 / start_run():144-180
  (ends before `set_phase:182`; the talon-start row :173; meta-rank consumption :150-159;
  run-var resets :163-172) /
  end_run():187-194 (stats = {time,kills,level,gold}) / snapshot_json():228-244 (exact 12)`);
  `main.gd` (472 L — cap fork `elif game.reaper: :266` + `else: _end_run("win") :268-269`
  (the R9 source-pinned fork — UNTOUCHED by M5) / `_start_game():290` (the ONE hand-in seam:
  `meta_ranks.duplicate() :300-301 → game.start_run() :302 → endless :306 → reaper :311 →
  stage :317 → seed_stage_props :318`) /
  `_end_run():355` (the run-end funnel: best_cycle max-rule :365-366, the stage-chain SET-only
  flag block :367-374, `gold += stats.gold :375` + the ONE `_meta_changed()` at `:376` —
  adjacency PINNED, the P2-1 law, the show_end lines follow) /
  `_meta_changed():420-421` / `_open_shop():431`, `_open_stages():461`); `screens.gd` (445 L,
  reason header :2-7 "one overlay idiom per file IS the concern" — menu/levelup/end/shop/
  stages = the FIVE overlays at :98-107, `icon_path():65-72` with the PASSIVES key-set leg +
  the `_:` catch-all + assert-exists, `show_stages():381` the DISABLED-not-hidden lock rows);
  `save.gd` (128 L — `VERSION := 1 :24`, fields `gold/ranks/flags/best_cycle/stage :27-42`,
  field-by-field migration `:49-75`, temp+rename `save()` :76); `powerups.gd` (148 L — OUR
  cost curve `cost(base,rank) = base*(rank+1) :62-65`, the buy/refund pure funcs);
  `hero_pawn.gd` (63 L — `mesh = _player_mesh() :35` set ONCE at ready; `_player_mesh():53-54`
  = `ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER)` — the ONE player-mesh seam,
  T-S2p law); `render.gd` (201 L — `STAGES :110` below `biome_at`, the slice law); `world.gd`
  (551 L — SCHEDULED-split clause in its reason header, F-9); `sim_funnel.gd` (74 L —
  `SimFunnel.fresh_run(root, opts)/check/decline/take_first_card/out_path/r3`, opts =
  `[wipe_well]+[wire_pick]+[flags]+[stage]`); `s8_capture.gd` (217 L — THREE DECLARED capture
  variants `HD3D_STAGE :26 / HD3D_REAPER :32 / HD3D_EVENTWAVE :50`, each a separate run with
  its own `HD3D_SHOTS_DIR`, default shots byte-invariant); `tools/dawnwell_pixel_gate.py`
  (`PX_MIN = 200 :44`, rows `{shop_shot, stage_select_shot}` :69-70); `tools/s8_acceptance.py`
  (11-row table, A1 = real-clock contract checks); tests — `test_save.py:184-186` (the
  exact on-disk key-set pin, verbatim literal quoted in R1), `test_endless.py:123-127` (the
  run-mode-var reset pin) + `:130-135` (the hand-in seam regex) + `:138-148`-era R9 re-pin on
  the cap fork, `test_card_icons.py:138` (`len(rows) == 32`), `test_art_integration.py:42`
  (`DRAWS_PLANNED = 40`) + `:95` (the GLB_FILES coverage law) + `:152` (the player-swap seam
  pin), `test_dawnwell_shop.py:136-157` (the start_run-consumption pin `:136-139` + the
  main-wiring pins `:153-157` — the GOLD→FUNNEL adjacency regex `:156-157` NAMED: the
  P2-1 forced landing, §1.1).
- **Clean-room stance (inherited from `docs/PARITY-ROADMAP.md` §1 honesty rule, binding):**
  *their systems, our content* — `docs/VS-FEATURES.md` (clean-room wiki inventory) is a SHAPE
  reference only: characters + additive price scaling (S6 ~477-483), achievement chains (S7
  ~613-624), skins (the roadmap's own DA P2-6 reading: real distinct meshes). THEIRS are
  shapes; every table below carries OUR ids, names, numbers, pinned by OUR suite. No copied
  value, asset, or flavor text; their 165-character roster is not a cloning target (roadmap
  row 7's own words).
- **docs/ARCHITECTURE.md:** ABSENT in this repo and deliberately not created (M2/M3/M4-SPEC
  precedent — the repo runs its own spine: LEDGER + DESIGN-3D + PARITY-ROADMAP + M*-SPEC).
- **Length note (exceeds the ~300 hygiene line, stated why):** one pointable build-depth
  artifact for one release, exactly as M2-SPEC (536 L), M3-SPEC (667 L), M4-SPEC (782 L)
  stated; splitting defeats the pointable-artifact DoD. Each pillar is self-contained so the
  DA can gate a single one.

## 0. FINDINGS + STATED READINGS (read before the DA opens any pillar)

Each ambiguity the brief/roadmap left open is resolved with a literal reading; flagged
decisions are **named, not silently chosen**.

- **F-1 (the 3D endgame is NOT a future pivot — this repo already IS the 3D remake; the
  recommendation follows).** The brief asks whether M5 should "pivot the 3D remake forward",
  and the DESIGN-3D maturity is the instrument. READ: `docs/DESIGN-3D.md` is not a plan
  waiting to run — it is the fully-executed spine of what already shipped. §a (ortho rig,
  20° pitch, px→m size table) = LEDGER S3; §b (per-class MultiMeshes, ≤60 draw cap) = T-S2i
  live-table; §c Route A (transform gait + skinned player/boss) = T-S2r mocap; §d (v1 verbatim
  numbers, the copied `test_game_numbers.py`) = the suite since the first commit; §e = the
  honest EXCLUDED pass (MC 11398/11401); the "more 3D" alternatives are rejected WHERE THE
  DOC PUTS THEM (REV-2/P4-1 attribution fix): the perspective camera at §a's camera line
  `:19-20` ("perspective rejected: v1 entities are size-pinned regardless of distance,
  render.gd:10"), full 3D physics at §a's collision law, skinned horde + heightmap terrain
  at §h's REJECTS list — all with measured reasons, under the owner's own verbatim ruling
  at `DESIGN-3D.md:4`: *"a 3d remake. Same type of viduals, top down…"*. A "pivot
  forward" (perspective/true-3D play) would OVERTURN a DA-gated design and the owner's top-
  down ruling — an owner decision with NO artifact on the table (Rule 2). **Reading adopted:**
  M5 continues the endgame the way the repo has always run it — the owner's DoD is a *full
  playable game*; the open parity families (gap rows 7/10 + the skins line) are exactly the
  roster half the M4 landing note names as NOT LANDED. "Why now": (1) the clean-code base
  law is satisfied (two full audit+refactor cycles closed, `48f5b33`); (2) three tracked
  cards (`T-M4c/T-M4p/T-M4k`) hold this exact tranche and their acceptance is stable under
  everything v2.1.0 shipped; (3) the version law already pre-decides the bump a surface
  release takes (v3.0.0), so no decision is manufactured; (4) the achievement-gated characters
  need the counter store the roadmap has carried since M2 #4 — the two halves land as ONE
  coherent release. Alternatives weighed and left tracked (not built): endless-depth (the
  cycle scalars already cap), more weapon evolutions (the +8/+5 roster-expansion stays
  tracked — it is breadth-on-the-pool, and the pool's own 6/6 carry caps make its marginal
  depth small), a 4th stage (Stretch, no DoD — F-10), the pivot itself (no artifact — stated).
- **F-2 (default identity is the byte law: the default character and default skin reproduce
  the shipped game EXACTLY).** New save rows (`char:int`, `skin:int`) default to the current
  behavior (an older save reads 0 = the base row, the `best_cycle`/`stage` migration proof);
  the roster's row 0 IS the shipped identity (talon start at `game_state.gd:173`, zero rule
  fields, mesh `player.glb`). At row 0 every consumed term is an IEEE identity (`+ 0.0`,
  `* 1.0`, the literal `[{"id": "talon", "level": 1, "cd": 0.0}]` returned from the table),
  the limit-break zero-identity precedent (`test_limit_break` C-E3's twin). **Every committed
  dump runs the default row ⇒ journey 5020 + the 12 committed fixtures re-dump byte-identical
  as a row of every M5 card, never an assumption.**
- **F-3 (achievement counters are RUN-END observable — zero world.gd touch).** The roadmap's
  M2 #4 store named mid-run counters (kills/minutes/levels/pickups); an honest instrument
  check: `game.stats` (`end_run :187-194`) carries time/kills/level/gold, `game.weapons` is
  live at `_end_run`, `best_cycle` already exists — every achievement this spec ships is
  computable at the ONE `_end_run` funnel from those rows + the well, WITHOUT a single line
  in `world.gd` (chest-count achievements would need a world-side tick — NOT shipped,
  named in §9). This keeps the CLEAN-CODE-AUDIT-2 §5 deferral (world.gd's SCHEDULED split,
  "the M5 growth card that grows it must carry it") UNTRIGGERED: no M5 card grows world.gd
  (§6's file-set table proves it) — the debt is re-declared, not silently inherited (the
  M4-SPEC F-9 pattern verbatim).
- **F-4 (the counter SET law = the stage-chain law).** Achievement flags ride the EXISTING
  `well.flags` dict (`{unlock_id: 1}` — the format's own meaning) as `achv:<id>`; SET-only
  at run end, death never unsets anything (the `stage2/stage3` precedent, main.gd :372-376),
  persisted by the ONE `_meta_changed` funnel (the call-count-per-end pin stays 1 — the
  A-E5 red instrument from M3 rides unchanged). Character PURCHASE flags ride the same dict
  as `char:<id>` (`flags:{unlock_id:1}` verbatim); the `counters` dict is the save's ONE new
  field of its own (R1). No second persistence path, no new funnel.
- **F-5 (character rules are additive terms at EXISTING seams; the roster is DATA).** A
  character = row in the NEW `roster.gd` TABLE: start weapon + rule fields (hp_add / dmg_pct
  / spd_pct / xp_pct / gold_add / armor_add) + price + gate + portrait + mesh. Consumption
  lands where the game already consumes stats: `start_run()` (weapons row, `gold =
  Roster.gold_start(...)`, `max_hp += rule.hp_add` as an additive line AFTER the T-M1f
  PowerUps line, starting passive stacks written into the SAME passives dict) + the three
  formula seams `player_speed()/damage_multiplier()/damage_taken()` gain ONE char term each
  (the exact LIMIT_BREAK arm shapes, `game_state.gd:98-114` — additive, zero-identity at 0)
  + the xp fold rides `meta_xp_mult` (start_run :158). NO new stat family, no second
  multiplier — the C-E3 formula-row shape repeats, the default row reads the shipped bytes.
  **THE `duplicate()` LAW (REV-2, DA P2-2 — adopted): every roster hand-off to run state
  copies — `Roster.start_weapons/start_passives` return deep `duplicate()`s of the table
  rows, never row references — the repo's own aliasing law restated (`meta_ranks` is
  duplicated at `main.gd:300-301` precisely against this class, pinned at
  `test_dawnwell_shop.py:153-155`); row 0's duplicate EQUALS the shipped `:173` row BY
  VALUE (the equality pinned, never identity). Mechanism at measured truth (the one honest
  correction inside an adopted row, §12 F-3): at the pinned Godot 4.7.2 the const TABLE's nested
  containers are DEEPLY READ-ONLY (binary probe THIS session: `Invalid assignment on
  read-only value (on base: 'Dictionary')` at the first in-place mutation) — so the naive
  hand-off is a LOUD runtime failure on the run's first weapon mutation, not the silent
  run-2 poisoning the gate described; the `duplicate()` clause and the B-E2 multi-run leg
  are adopted regardless (the fix for the loud failure AND the lifecycle guard for any
  future mutable-shape table — the shape the leg can actually see green-falsify).**
- **F-6 (purchase = the PowerUps law restated; selection persists like `stage`).** Prices
  are a flat OUR curve over the roster index (`0/300/600/900/1200/1500` well-gold — the
  roadmap row 7 "additive price curve OURS", the `base*(rank+1)` precedent `powerups.gd:62-65`
  restated for a buy-once row); a no-op mutation (unaffordable / already owned / gate
  missing) does NOT write (the shop's own law); the SELECTED char/skin are save rows written
  through the same funnel (the `well.stage` select precedent — choice persists, run state
  never writes the save). Achievement-GATED rows: buy disabled until the `achv:<id>` flag
  (the DISABLED-not-hidden lock law, `show_stages:381` era).
- **F-7 (the hand-in placement law — the `test_endless.py:130-135` pin STAYS GREEN by
  construction).** That regex pins `game.start_run()` followed (comments-only) by the endless
  assignment; the char/skin hand-ins land at the END of the existing hand-in block (after
  `world.seed_stage_props` at `main.gd:318`), so the pinned literal is untouched — a named
  STAY probe, and B-E4 is the leg that re-proves it green on the final tree. The char/skin
  hand-ins follow the F-4 law (`_dawnwell → start`, AFTER `start_run` reset — the endless
  pattern's own wording). **REV-2/P1-1: the pawn `_pawn.apply_selection()` call rides the
  SAME position, as the block's last line (§2.1b) — both hand-in pins are MEMBERSHIP regexes
  on literals the new lines never touch, so the STAY reading survives the addition.**
- **F-8 (TWO new surfaces, ONE major — the version math).** Character select (§2) and the
  achievements page (§1) are the release's two navigated overlays (6th + 7th in the ONE
  panel style). The law keys on the trigger, not the count (M3 precedent: stage-select made
  v2.0.0 — one major per release, whenever the trigger fires). The skin picker is NOT a 3rd
  surface: it is a row-set INSIDE the character overlay (like the shop's refund row), stated
  so no later reader counts it.
- **F-9 (the deferred-carry rows, re-declared not inherited).** CLEAN-CODE-AUDIT-2 §5:
  **world.gd split** — untriggered (F-3; §6 file-set table); **sim_stages.gd 583** — M5 adds
  no legs there (new per-pillar files, the standing convention); **strips_capture.gd 596
  (four lines under the 600 hard fail)** — M5 ships NO strips re-shoot (skin/character visual
  proof rides the `skinned_capture.gd` frame-diff pattern, §3), so the twice-deferred row is
  NOT carried here and is re-named for the first card that actually touches that file;
  **sim_events 537** — untouched (REV-2/P3-2: re-measured at base — the audit's 533 was
  already stale at `48f5b33`; world/sim_stages/strips_capture 551/583/596 re-measured too).
  Each card closes with the walk re-run (0 new findings).
- **F-10 (no 4th stage, no roster expansion, no coin bags — tracked, named).** M3-SPEC F-8's
  reading stands (Stretch, no DoD); the +8/+5 roster-expansion (M2-SPEC §8.5), coin-bag tiers
  (§8.1) and the pool-GATING half of the unlock store stay tracked — M5 lands the COUNTER +
  flag half (which the gates need, F-3/F-4) and the pool-gating table stays a named follow-on
  (§9.3). The release that grows the weapon pool rides the same §8 asset-batch discipline.

## 1. PILLAR A — ACHIEVEMENTS + THE COUNTER STORE (T-M5p)

**Shape ref:** VS-FEATURES S7 ~613-624 (VERIFIED shapes): unlock chains gated by play
counters, an achievements surfacing them. THEIRS are names and chains; OURS below — no copied
condition text. Roadmap gap row 10 (`:47`) is the tracked row; roadmap M2 #4 (`:238-240`) is
the counter-store half F-3/F-4 close.

### 1.1 Mechanism (the run-end law — F-3)

- **Save field:** `DawnWell.counters: Dictionary = {}` (`counter_name -> int`) — another
  field-by-field ADDED row, VERSION unchanged at 1 (the `best_cycle`/`stage` proof verbatim:
  a missing field defaults `{}`, a HIGHER-version save still quarantines, the write path is
  the shipped temp+rename). The disk key-set pin `test_save.py:184-186` RETIRES-AND-RE-PINS
  with it (ledger **R1**) — replace-not-delete, same commit.
- **The ONE update site — landing FORCED by a shipped pin (REV-2, DA P2-1):** `main._end_run`
  gains the block **ABOVE the `_dawnwell.gold += game.stats.gold` line (`:375`), directly
  below the best_cycle max-rule write (`:365-366` — beside it in every sense but the pinned
  one)**. The landing is not stylistic: `test_dawnwell_shop.py:156-157` pins
  `_dawnwell.gold += game.stats.gold` followed by `_meta_changed()` with **whitespace only
  between** (`\s*\n\s*` — comments do NOT qualify), so the block may never land between the
  gold line and the funnel (suite RED), and never BELOW the funnel (counters/flags would
  persist one mutation late — P-E2's roundtrip-on-disk legs RED). PIN-HOLD CLAUSE (the pin
  named in §7.2's STAY list, cite extended to `:136-157`): the block adds NO `_meta_changed`
  call and NO `.save()` and touches neither pinned literal — the adjacency regex stays green
  BY CONSTRUCTION. The block body: `Achievements.update(_dawnwell, game, world)` reads ONLY
  `game.stats` (:187-194), `game.weapons`, `game.stage`, `world.reaper_spawned` (`world.gd:216`
  — a READ of the field, zero world.gd growth), `game.cycle` and the well — updates the
  counters (Σ-add rows + max-rule rows, the best_cycle max-law shape), SETS
  `flags["achv:<id>"] = 1` for every table row whose target the new counter values satisfy,
  and NOTHING ELSE. The ONE `_meta_changed()` at `:376` below persists it (the
  `test_stages.py:296` end_run-scoped count pin stays 1 — the block calls neither); unlike a
  shop verb a run end is NEVER a no-op (`runs_total += 1` always moves — the zero-write
  claim was false; P-E1 carries the corrected zero-DIFF leg).
- **The table (`godot/scripts/achievements.gd`, class_name Achievements — new rule module,
  the `powerups.gd`/`evolutions.gd`/`union.gd` precedent for every rule module since M1):**
  `TABLE` = 20 OUR rows `{id, name, counter, target}` + `update(well, game, world)` +
  `progress(well, row)`; `ACHV_PREFIX := "achv:"` one named const. Counters (all run-end
  observable, F-3):

  | counter | law (at run end) | achievements riding it |
  |---|---|---|
  | `kills_total` | += stats.kills | kills-1k / kills-10k / kills-50k / kills-200k (1k/10k/50k/200k) |
  | `gold_earned` | += stats.gold | gold-500 / gold-2500 / gold-10000 |
  | `runs_total` | += 1 | runs-10 / runs-50 / runs-150 |
  | `wins_total` | += 1 when phase == "win" | win-1 / win-5 |
  | `max_level` | max(existing, stats.level) | level-12 / level-18 / level-25 |
  | `minutes_total` | += floor(stats.time/60) | minutes-60 / minutes-300 |
  | `best_cycle` | (EXISTS — this store READS it, never re-homes it) | cycle-1 |
  | `evolutions_seen` | max(existing, distinct evolved ids in game.weapons — read through `EvolutionSystem.TABLE`, the ONE evolution table, no second copy) | evo-1 |
  | `unions_seen` | max(existing, distinct union ids in game.weapons — `UnionSystem.TABLE`) | union-1 |

  (20 rows exactly: 4+3+3+2+3+2+1+1+1. OUR numbers; the counter names are this module's own;
  reaper-achievements were weighed and REJECTED — a hidden-flag feature gating a purchase
  screen is unplayable UX, stated §9.5.)
- **The achievements page (SEVENTH overlay, screens.gd, the ONE panel style):** rows rebuilt
  per open from `TABLE` + the well (name, target, progress `min(count, target)/target`,
  achieved rows in EMBER — the stage-select law); NO mutation (display-only; no verb writes
  here); menu gains the "Achievements" button (same idiom as Stages/Shop; mouse verbs ride
  thin `main._open_achievements/_close_achievements` wrappers over the existing menu funnel).
- **Byte preservation:** flag-off = every committed dump — the block adds zero RNG (int math
  over stats; `update` never touches the sim) and runs ONLY at run end, which no dump stream
  reads. Journey + 12 fixtures re-dump byte-identical (A-E1).

### 1.2 Files (Pillar A)

`save.gd` (counters field + migration row + as_data key), `main.gd` (the `_end_run` update
block + the two menu verbs), NEW `godot/scripts/achievements.gd`, `screens.gd` (7th overlay
+ menu button; reason header row count re-worded to SEVEN overlays), NEW
`godot/sim/achv_probe.gd` (the `save_probe.gd` throwaway-`user://` probe pattern — legs run
for real; own env `HD3D_ACHV_OUT`; seed-pinned `HD3D_SEED` default = its build-card id, the
v2.1.0 seed law), NEW `tests/test_achievements.py`, re-pinned `tests/test_save.py` (R1, same
commit), `tools/dawnwell_pixel_gate.py` (+`achievements_shot` row, R3).

### 1.3 ACCEPT (each row names ONE existing seam + its planted red)

| # | observable | seam (the ONE existing channel) | red |
|---|---|---|---|
| P-E1 | counters law, BOTH sides: a scripted run-end leg (probe, the save_probe shape) on a known stats dict shows the Σ-add rows add EXACTLY, the max-rule rows max EXACTLY (`max_level` never decreases, `minutes_total` floor law), AND the zero-DIFF leg (REV-2/P2-3, replacing the false zero-write claim): a run whose stats move ONLY Σ-add rows SETS no new flag and moves NO max-rule counter, the Σ-add rows move by the EXACT deltas and NOTHING else moves — the disk-write itself is the shipped always-write funnel law (`runs_total += 1` makes every end a write; the shop VERB no-op does not govern run end) | the `achv_probe.gd` legs against a throwaway `user://` (XDG_DATA_HOME, the save_probe pattern verbatim) | planted: `max_level = stats.level` (replace not max) ⇒ the run-2-lower-level leg goes RED (`max_rule` check); planted: Σ-add flipped to max ⇒ `kills_total` RED; planted: a max-rule row added for `kills_total` ⇒ its delta row reads 0-after-run-1 ⇒ RED |
| P-E2 | flag law: reaching a target SETS `flags["achv:<id>"] = 1` exactly once; a later WORSE run never unsets (the stage-chain both-side leg verbatim shape); `flags` stays `{unlock_id: 1}` int-valued (key-set includes the prefix) | the same probe legs reading the on-disk JSON (the roundtrip-on-disk pin shape, `test_save.py` reload legs) | planted: SET moved to run START ⇒ the worse-later-run leg RED; planted: unset added on death ⇒ RED |
| P-E3 | funnel law, REAL instruments (REV-2/P2-4 — the "call count == 2" cite was PHANTOM, re-grepped: `test_save.py:133` counts `_dawnwell.save()` in MAIN == 1, MAIN-scoped; `test_stages.py:296` counts `_meta_changed()` inside the `end_run` block == 1 + `func _meta_changed` definition == 1; there is NO marker-count==2 funnel pin): the shipped pins STAY green by construction (the block calls neither save() nor the funnel), AND the card lands the named NEW whole-scripts pin: across ALL of `godot/scripts/`, zero `.save(` call sites outside `save.gd` and `main._meta_changed`'s own body (measured at `9b1d067`: exactly one outside site exists, `main.gd:421` — the funnel), and main.gd's `_meta_changed(` occurrences equal the shipped set (calls `:287/:376/:437/:443/:449/:471` + definition `:420` = 7, re-counted at card) — the block adds ZERO to both | the existing source pins above + the named NEW grep pin (SAME commit as the block; scope NAMED: all of `godot/scripts/` — no cross-file blind spot) | planted: a direct `_dawnwell.save()` in achievements.gd ⇒ the whole-scripts grep pin REDS (file scope named, the phantom class closed); planted: the block moved BETWEEN the gold line and the funnel ⇒ `test_dawnwell_shop.py:156-157` adjacency REDS — the P2-1 forced landing is itself red-proven |
| P-E4 | the save shape: on-disk key set EXACTLY `{version, gold, ranks, flags, best_cycle, stage, counters}` (R1's replacement pin, equal-or-stronger: the OLD six still roundtrip byte-true, `counters` migrates `{}` on an older save, VERSION still 1) | `test_save.py`'s exact-set legs (the T-M2e/T-M3s falsified-and-replaced lineage, third honest move named in the row comment) | planted: VERSION bumped ⇒ version-skew legs RED (the no-bump law instrument); planted: `counters` NOT written ⇒ set pin RED |
| P-E5 | achievements page pixel row: `dawnwell_pixel_gate.py` gains `achievements_shot` — `_center_box` crop non-bg ≥ 200 px vs the hidden-UI baseline (the shop/stage rows' own floor), 20 rows + progress text rendered | the EXISTING gate + capture idiom (`tools/capture_lib.py` — the ONE capture launcher), new row same floors | baseline-vs-baseline copy scores 0 px + exit 1 (the gates' own planted-red shape re-proven on the NEW row, R3) |
| P-E6 | table + display pins: `TABLE` is 20 rows, ids unique, every row's counter ∈ the named counter set (no orphan), `ACHV_PREFIX` one const; every id resolves to a name/progress line (no-blank law) | pytest table pin (the LIMIT_CARDS table-pin shape) + the probe's `progress` rows | planted: a row naming `chests_total` (no producer) ⇒ orphan-counter pin RED; planted: progress on an unknown counter ⇒ probe leg RED |
| P-E7 | byte corpus untouched: journey 5020 + every committed fixture re-dumped byte-identical on the T-M5p tree (F-2/F-3 law); the s8 11-row table PASSes from the committed GA records; strips dump identical modulo the §7.1 norm | the existing re-run pattern (fresh dump vs committed corpus, `cmp`) — the T-C3 gate idiom | any RNG touched by the counter path flips the journey digest ⇒ RED — the standing leak instrument |

## 2. PILLAR B — CHARACTERS: THE ROSTER + SELECT/PURCHASE SCREEN (T-M5c)

**Shape ref:** VS-FEATURES S6 ~477-483 (VERIFIED shapes): selectable characters, each with a
start weapon + unlock condition; gold purchase with additive price scaling; secret unlocks.
THEIRS are shapes (165 of them, names theirs); OURS is the roster below — 6 by the roadmap's
own row-7 number, sizes per the SEL decision (§2.5, OWNER-DECISION-PENDING).

### 2.1 The roster (OUR table, `godot/scripts/roster.gd` `const CHARACTERS`)

Row 0 IS the shipped identity (F-2); one signature rule per new row, every rule field
additive-zero at 0 (F-5). `mesh` names the GLB through the ONE `_player_mesh()` seam
(`hero_pawn.gd:53-54`, extended to read the SELECTED row — default row = the literal
`"player.glb"`, byte law); `portrait` rides the `icon-<file>.png` convention + assert-exists
(the §j total-resolver law restated for the new file family `icon-portrait-<id>.png`).

| # | id | name | mesh | start weapon | signature rule (OUR numbers) | cost | gate |
|---|---|---|---|---|---|---|---|
| 0 | `the-vigil` | THE VIGIL | `player.glb` (shipped) | talon | — (every field 0 = the byte law) | 0 | always |
| 1 | `emberwright` | THE EMBERWRIGHT | `char-emberwright.glb` NEW | ember | `dmg_pct +8` | 300 | — |
| 2 | `grave-ward` | THE GRAVE-WARD | `char-grave-ward.glb` NEW | ward | `hp_add +12` | 600 | — |
| 3 | `coinhound` | THE COINHOUND | `char-coinhound.glb` NEW | talon | `gold_add +40` | 900 | — |
| 4 | `duskrunner` | THE DUSKRUNNER | `char-duskrunner.glb` NEW | dart-loop | `spd_pct +6` | 1200 | `achv:kills-50k` |
| 5 | `tallow-seer` | THE TALLOW-SEER | `char-tallow-seer.glb` NEW | censer-of-hours | `xp_pct +10` | 1500 | `achv:cycle-1` |

- **SEL-B trims rows 4-5 + 3 (roster = 0,1,2); SEL-C extends with 3 more rows (7-9: rule
  fields from the SAME field set — `armor_add +1`, `hp_add +20/dmg_pct −4`, `gold_add +80/
  spd_pct −3`, gates `achv:level-25` / `achv:runs-150` / `achv:gold-10000`); the TABLE shape
  is identical, only its length and the §2.5 batch numbers change.** Every number OURS; the
  gates ride PILLAR A's flags (roadmap item 1: "2 characters achievement-gated"), prices the
  F-6 flat additive curve; start weapons are shipped pool ids (roster-m1h IDS — zero new
  weapon code).
- **Stat-rule consumption (F-5, exact seams):** `start_run()` — weapons row = `Roster.
  start_weapons(char_id)` **returning a deep `duplicate()` (F-5's law; row 0's duplicate
  EQUALS the literal talon row `:173` by value, never a shared reference)**,
  `gold = Roster.rule(char_id).gold_add` (0 = byte-identical `gold = 0` at :156), the
  `max_hp` line becomes `max_hp = MAX_HP + PowerUps.max_hp_bonus(...) + Roster.rule(...).hp_add`
  (one additive term, +0 = IEEE identity), passives dict gains `Roster.start_passives(...)`
  (empty at row 0); the three formula seams gain the char term `* (1.0 + 0.01 * rule.spd_pct)`
  / `+ 0.01 * rule.dmg_pct` / `− 1.0 * rule.armor_add` (inside the existing `maxf(0.0, …)` —
  armor cannot heal, the Bulwark law repeated); `meta_xp_mult` line gains `+ 0.01 *
  rule.xp_pct`. The `char_id` run var joins the reset block (`start_run`, the B-E pattern
  `test_endless.py:123-127` STAYS green — it names endless/cycle only) and is set by the
  hand-in at the END of the block (F-7).
- **Snapshot law:** `char_id` (and `skin_id`) are run state OUTSIDE the frozen 12-field
  snapshot (the `stage/flare/reaper/limit` precedent); the exact-12 pin stays by construction
  + a named 13th-field instrument leg (the `limit_snapshot` shape).

### 2.1b THE PAWN APPLY-STEP (REV-2, DA P1-1 — adopted: selection applies AT the F-7 hand-in)

The Code-truth read-once fact becomes the law here: `hero_pawn.gd` sets `mesh =
_player_mesh()` **ONCE at `_ready()` (:34-43)** and the pawn is instantiated ONCE at boot
(`main.gd:32/:89-91` — re-grepped: `_pawn` appears nowhere else in the file), so boot
`_ready` fires before even the FIRST `_start_game` hand-in: a selection law that only sets
run state ships a feature that NEVER shows in-session (the gate's P1-1, adopted). Fix, at
file/function depth:

- **`hero_pawn.gd` gains `func apply_selection() -> void` — the EXISTING `_ready` body
  (:35-43) MOVED verbatim:** `mesh = _player_mesh()` re-derivation, then the material idiom
  unchanged — `src := mesh.surface_get_material(0)`, `duplicate()` FIRST (the ClassMesh
  cache is shared, the imported material never mutated — the T-S2i law), `TRANSPARENCY_ALPHA`
  + `SHADING_MODE_UNSHADED` + `albedo_color = PLAYER_TINT` (`:31`, the BONE×3.6 tone-0.62
  readability law — the hero/floor luma ≥2.0 gate), `material_override = _mat`. `_ready()`
  shrinks to ONE call of `apply_selection()`. The method is IDEMPOTENT: each call
  re-derives mesh + a fresh material duplicate from the NEW surface; the old `_mat` dies
  with the old override. No second mesh path anywhere.
- **Call site — ONE line at the F-7 hand-in tail:** `main._start_game` gains, after
  `world.seed_stage_props(game)` (`:318`), in order: `game.char_id = …`, `game.skin_id = …`
  (the `int(_dawnwell.…)` reads), then **`_pawn.apply_selection()`** — mesh re-read LAST,
  both run vars landed. Both source pins survive because they are MEMBERSHIP regexes, not
  adjacency: `test_endless.py:130-135` (pins `start_run()` → endless), `test_stages.py:318`
  (`hand[hi:]` membership) — re-read at `9b1d067`.
- **Mid-run/pause lifecycle (the gate's own question, answered):** NOTHING re-instantiates
  the pawn — one creation site (above), `world.reset()` never touches it, and the select
  overlay is MENU-phase-only (overlays are exclusive: a mid-`playing` selection change is
  UNREACHABLE BY CONSTRUCTION). `apply_selection` runs boot `_ready` + every run start,
  nothing else. Zero new mechanism: same loader, cache, material law — a re-derivation.
- **Byte/pin preservation:** for the DEFAULT row `apply_selection()` recomputes
  `_player_mesh()` whose default branch keeps the pinned literal
  `ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER)` — the cache returns the SAME
  mesh + identical tint ⇒ capture streams pixel-invariant (B-E1's strips/s8 legs); the
  seam-pin `test_art_integration.py:152-162` asserts the literal as a SUBSTRING in the
  function body (re-read) — the extension passes it VERBATIM, `"CapsuleMesh" not in HERO`
  stays green.

### 2.2 The select screen (SIXTH overlay; roadmap item 1's "purchase screen")

Same construction law as `show_stages` (`:381-412`): rows rebuilt per open from `Roster.
CHARACTERS` + the well; portrait TextureRect (assert-exists resolver, no-blank law), name,
rule blurb, price line; per-row button in ONE of FOUR states — **Locked** (gate flag missing,
DISABLED, names the achievement — S7 ~610 disable law), **Buy N** (affordable check server-
side in main's verb, disabled at UI side too — the shop's both-side rule), **Owned** (Select
enabled; chosen row titles in EMBER — the stage law), **Selected**. The skin row (§3) renders
under the selected row when that character's skin group is non-empty (F-8: an inner row-set,
not a surface). Menu gains "Characters" (`main._open_characters/_char_buy/_char_select/
_char_buy_skin/_char_select_skin` thin verbs over the ONE funnel — no verb calls `save()`).
Selection persistence = `DawnWell.char` / `DawnWell.skin` (int rows, R1's same field-set
pin moves again in T-M5c/T-M5k, each same-commit replace-and-re-pin — the honest lineage
`test_save.py:181-183` already narrates).

### 2.3 The mesh + rig rows (asset-coupled, §4 batch)

Each new character = a DISTINCT TRELLIS mesh (player class **≤ 8000 tris**, the §b tri row)
→ UniRig rig → the tools/mocap `05-map-rig.py`/`06-retarget-rig.py` walk+attack rewrite
(CMU 07_01/02_05 sources — the S2r pipeline, CPU bpy, NO GPU window) → `ClassMesh` height-
normalises to `MODEL_H_PLAYER 1.67 m`. The M1c2 blind-spot law BINDS: bpy turntable-solid
eyeball (yaws 0/90/180/270) + extent/fill + aspect gates on every mesh; the skinned player-
class meshes additionally take the S2r frame-diff proof (walk/attack rows ≥ 2 px + FROZEN
0-px controls) through a NEW capture riding the `skinned_capture.gd` pattern —
`godot/sim/roster_capture.gd`, committed `tests/fixtures/roster-clips-m5-framediff.csv`
(twice-cmp-identical, a NEW fixture — the S2r file stays byte-locked, no carve needed).

### 2.4 Files (Pillar B)

`roster.gd` NEW (CHARACTERS + SKINS tables + pure fns `rule/start_weapons/start_passives/
start_weapons/skin_for/cost/is_locked/is_owned` — ALL rules here, the powerups.gd contract),
`game_state.gd` (char_id/skin_id vars + resets + the F-5 additive terms + `start_run`
consumption), `main.gd` (hand-in lines at the F-7 position INCLUDING `_pawn.apply_selection()`
as the block tail (§2.1b) + the five screen verbs),
`save.gd` (`char`/`skin` int rows), `screens.gd` (SIXTH overlay + menu button; reason header
re-worded), `hero_pawn.gd` (`apply_selection()` = the `_ready` body moved, §2.1b; `_player_mesh()`
extended: the ONE seam, its doc line updated to
name the selection read + the T-S2p seam-pin test EXTENDED not replaced), NEW
`godot/sim/sim_chars.gd` (rides `SimFunnel` — `fresh_run` opts gains the `char` key, a
DECLARED opts growth in the 74-L funnel, default absent = row 0; own env `HD3D_CHARS_DUMP`;
seed = card id; committed `tests/fixtures/chars-m5.jsonl`), NEW `godot/sim/roster_capture.gd`
+ `tests/fixtures/roster-clips-m5-framediff.csv`, NEW `tests/test_characters.py`, re-pinned
`tests/test_save.py` (R1 again) + `tests/test_art_integration.py` coverage rows (R2) +
`tools/dawnwell_pixel_gate.py` (+`char_select_shot`, R3).

### 2.5 THE ROSTER DECISION — SEL OPTIONS (⚠ OWNER-DECISION-PENDING; nobody may assume)

RULING 2026-10-27: owner "C" (SEL-C, 9 chars) — wave executing; DA docs immutable. Carried verbatim by MC 11421 (T-M5p): this Pillar A card is option-independent and lands under any roster; the ruling line is append-only, every paragraph below is untouched DA history.

Prior artifact: roadmap row 7 (`:44`, rev-3, DA-gated) names **"M4: 6 selectable, each
start-weapon + one signature stat rule; purchase price curve OURS"** — a PLAN artifact, not
an owner choice among sizes. The MC 11402 brief forbids treating it as one. Window estimates
are grounded on the repo's OWN yield history (T-M1c2: 4 meshes consumed 12 windows = ~3/
mesh incl. remaster+regen; T-S1p: player mesh+rig acceptance in ONE bounded window
(15:37→15:44, the LEDGER row as measured — REV-2/P4-2 cite fix; the ~3/mesh stays the
RESERVED estimate, reserved upward against the newer yields, never downward); the
~30 % reserve law, roadmap §4). **Fixed across all options:** 5 skins (§3, ~10-14 windows),
achievement pillar (~0 windows — 0 icons, badges reuse shipped files via the catch-all).

| option | roster (new meshes) | new GLBs total (chars+skins) | est. 3090 windows (whole milestone) | new test rows (chars part) | suite ≈ | byte-anchor risk |
|---|---|---|---|---|---|---|
| **SEL-A (RECOMMENDED — the roadmap's number)** | 6 (rows 1-5 NEW, **5 meshes**) | 10 | **38-44** | ~25 | ~345 | LOW — the F-2 identity carve is option-independent; 5 rule rows = 5 formula-leg twins (B-E3) |
| SEL-B (lean, cheap end) | 3 (rows 1-2 NEW, **2 meshes**) | 7 | **25-30** | ~16 | ~330 | LOW — fewer seams, same carve |
| SEL-C (deep, rich end) | 9 (rows 1-8 NEW, **8 meshes**) | 13 | **46-54** | ~34 | ~355 | LOW-MED — more rule rows (mechanical, same shape) + MILESTONE-SIZE risk (the windows alone run ~2 weeks of off-peak slots; screens.gd growth is a watch row §6) |

- **Why SEL-A:** it is the roadmap's own, DA-gated number (choosing B or C without an owner
  word edits a rev-3 plan row — the same Rule-2 discipline); the 2 gated characters (§2.1's
  rows 4-5) are what make pillar A's flags OBSERVABLE where the player can see them (M3-SPEC
  §2's anti-surface-stretching law — an achievements page with no gated payoff is the same
  dead-weight the M4 §5 SEL-C rejected for characters-without-surface); and the yield math
  (SEL-B saves ~14 windows but ships a page nothing gates against). If the owner rules B,
  rows 3-5 simply never land (the table is DATA; every pin below counts rows at card time);
  if C, the wave splits the asset batch into TWO cards (T-M5a-1/T-M5a-2) and the size law is
  restated honestly on the MC parent.
- **Costs stated per option so the owner rules with numbers, not vibes.** The window totals
  assume the same trap-close/drain-barrier law per window (ledger history); a co-tenant OOM
  attempt does NOT count against the estimate (it does not consume a window, per S1a law).

### 2.6 ACCEPT (B-E1..B-E9; each names ONE seam + planted red)

| # | observable | seam | red |
|---|---|---|---|
| B-E1 | default identity byte law: journey 5020 + the 12 committed fixtures + the strips dump (modulo §7.1 norm) re-dump IDENTICAL on the T-M5c tree (row 0 = the shipped game; F-2) | the §7.1 re-run pattern (fresh dump vs committed, `cmp`) | planted: `start_weapons` returns the ember row for row 0 ⇒ the journey spawn/kills digest forks ⇒ RED |
| B-E2 | per-character start weapon: for EACH table row a `sim_chars` leg (fresh_run opts `char`) dumps the FIRST offer/owned rows — `game.weapons[0].id ==` the row's weapon at t=0, slot count 1, row 0 exactly the talon literal — **AND the REV-2/P2-2 aliasing twin-leg: TWO `fresh_run()`s INSIDE ONE process start with byte-equal weapons rows (the multi-run lifecycle leg — twice-cmp fixture generation is blind to same-process poisoning, so the leg runs twice-in-one-process; the `duplicate()` law's observable guard)** | the `sim_chars.gd` dump (SimFunnel; the sim_boss DECLARED-pin idiom for the pinned char_id) | planted: table key drift (`"ember-bolt"` for the shipped `"ember"` — the REV-2 self-caught id, §12 F-13 row: this exact typo sat in the REV-1 table) ⇒ the kill-attribution leg never sees the weapon ⇒ RED (roadmap M1 ACCEPT's planted cooldown-never-fires class, restated); planted: `duplicate()` removed with run 1 upgrading its weapon ⇒ run 2's dump row carries the upgrade ⇒ the twin-leg RED |
| B-E3 | rule math, formula rows (the C-E3 exact-formula precedent): each new row dumps `max_hp == 100 + Σmeta·10 + hp_add`, `player_speed == 140·(1+0.08haste)·(1+0.03limit)·(1+0.01·spd_pct)`, `damage_multiplier == 1+0.1·ferocity+0.08·gall+0.04·limit+0.01·dmg_pct`, intake `raw−ward−rotten−1·armor ≥ 0`, `meta_xp_mult` row, start `gold ==` row — and the ROW-0 twin of every row EQUALS the shipped byte value exactly | the same dump channel (formula rows, the shop_probe/maxhp shape) | planted: `spd_pct +6` mis-scaled as ×0.1 ⇒ the speed formula row RED while the byte corpora (row-0 twin) stay GREEN — the both-sides law: a rule that leaks into row 0 flips B-E1 instead |
| B-E4 | hand-in + reset law: `char`/`skin` are set at the ONE `_dawnwell → start` seam AFTER `start_run` (regex pin beside the F-7 STAY probes), reset in `start_run`, absent from the exact-12 snapshot (the 13th-field instrument leg, the `limit_snapshot` shape) | the existing source-pin pattern (`test_endless.py:130-135` STAYS green by construction — named) + a new snapshot-absent leg | planted: default in `start_run` from a global ⇒ the hand-in regex leg + the planted-flag-true twin RED (the M4-SPEC B-E1 endless-pattern red restated — P4-3 namespace fix) |
| B-E5 | purchase law (the shop both-sides): buy at affordable+unlocked+unowned writes flag `char:<id>` + spends EXACTLY the table price through the ONE funnel; unaffordable/owned/gate-missing ⇒ NO write (the shop's no-op law); gate check reads `flags["achv:<id>"]` verbatim (a gate naming no shipped achievement is a PIN FAILURE, not a runtime surprise); refund NEVER (buy-once stated) | `main._char_buy` verb legs through the save_probe-style probe (the shop_probe pattern, throwaway well) — the price rows value-compare the F-6 table | planted: gate read before the flag exists in PILLAR A (wrong prefix) ⇒ every gate leg "owned" ⇒ RED; planted: price off-by-curve ⇒ spend row RED |
| B-E6 | select screen pixel row (`dawnwell_pixel_gate.py` +`char_select_shot` ≥ 200 px vs hidden-UI baseline) + the FOUR-state rows leg (Locked names its achievement / Buy N / Owned / Selected in EMBER; DISABLED never hidden — the S7 ~610 law) | the existing gate + capture idiom; a state-leg dump (rows.json state rows, the stage-select precedent) | baseline-vs-baseline RED (R3 re-proven on the new row); planted: hidden-when-locked ⇒ the state-dump row-count leg RED (a locked row must RENDER) |
| B-E7 | mesh truth per new row: file exists, tris ≤ 8000, turntable-solid eyeball rows PASS, live height at the ClassMesh seam 1.67 m rel_err 0.0 (art-fixture forward-lock, R2), `_player_mesh()` renders the SELECTED row's mesh — the T-S2p seam-pin test EXTENDED (default asserts the literal player.glb path, the substring law `test_art_integration.py:152-162` kept); **PLUS the pawn-lifecycle twin-leg (P1-1): after a run-start with a planted selection (`sim_chars` opts `char` — the pawn the SIM actually shows), the pawn's live `mesh` IS the row's `ClassMesh` mesh and `material_override` is a duplicate carrying the NEW surface's material with the UNSHADED+PLAYER_TINT law (a re-derivation check, not a leftover from boot); the row-0 twin asserts the shipped mesh object (cache identity — the observable B-E7's old self could not see)** | the art-integration fixture/pins (R2 growth, prior 18 rows byte-preserved) + the seam-pin pattern + the live-pawn read through the sim root (`_pawn` reachable — the P1-1 instrument) | planted: 2× height (the S2p red pair) ⇒ live-height leg RED; planted: default-row mesh drift ⇒ the seam-pin RED; planted: apply-step DELETED (the P1-1 regression — selection set but pawn never re-derived) ⇒ the twin-leg RED while every other row stays green — the feature-dead class is now instrumented |
| B-E8 | skinned clips per new mesh: `roster_capture` frame-diff rows walk/attack ≥ 2 px per mesh + FROZEN same-time controls 0 px, committed fixture twice-cmp-identical | the S2r capture+validator pattern (new file, NEW fixture — the S2r CSV stays byte-locked) | planted: unanimated copy ⇒ its rows 0 px ⇒ RED (the S2r red control shape) |
| B-E9 | roster table pin: CHARACTERS rows verbatim (ids/mesh names/start weapon ids ∈ shipped IDS/`weapons.gd` — a grep pin, rule fields/price curve/gate ids ∈ PILLAR A's table — the cross-pillar SAME-commit law), portraits resolve + assert-exists, `len(CHARACTERS)` == the OPTION the owner ruled (the pin reads the ruling's number — the card's brief carries it) | pytest table pin (the LIMIT_CARDS shape) | planted: gate id `achv:kills-999k` (no row) ⇒ the cross-pillar pin RED — the gate-vs-table drift class |

## 3. PILLAR C — SKINS: 5 MESHES ON THE EXISTING PLAYER-RIG SHAPE (T-M5k)

**Shape ref:** the roadmap's own DA-c1 P2-6 fix (M4 assets line, `:365-369`): skins are REAL
distinct meshes on the existing rig shape, not re-tints; ship as their own GLB + tri rows.
M4 item 4 deferred them here, unchanged.

### 3.1 Mechanism

- `Roster.SKINS` (same module, ONE table law): 5 rows `skin-ash / skin-marrow / skin-tide /
  skin-relic / skin-void`, prices `200/400/600/800/1000`, NO gates (roadmap item 4 names
  none), each a distinct TRELLIS mesh (≤ 8000 tri) + UniRig rig + the same walk/attack
  rewrite (§2.3 pipeline, law-for-law identical — the roadmap's "retargeted onto the EXISTING
  … rig + clips (same 34-joint skeleton, no new rig class)" reads HONEST at pipeline level:
  the same tools/mocap chain, the same two CMU sources, no new rig CLASS; the generic bone
  COUNT is per-asset (player 34, warden 46 — the S2r honest rows), stated so no card claims
  an identical bone list it cannot promise).
- **Skin group law:** skins ship for `the-vigil` (row 0) only this release (roadmap scope);
  other characters' rows carry `skins: []` (the row exists, empty — a per-character skin
  set is the named follow-on, §9.4). Applying a skin = the SAME `_player_mesh()` seam reading
  `well.skin` through the selected character's skin group; `skin 0` (default) = the literal
  `player.glb` — byte law F-2 again; animations play the skin's own embedded clips through
  the existing hero_pawn AnimationPlayer path (zero new animation mechanism).
- Purchase/select verbs: the F-6 law verbatim (`skin:<id>` flags, the skin chips INSIDE the
  character overlay — F-8's "not a third surface" reading).

### 3.2 Files (Pillar C)

`roster.gd` (SKINS rows — same file as B ⇒ SERIAL, §6), `save.gd` (`skin` row, R1 again),
`main.gd` (two verbs), `screens.gd` (the skin chip row), `hero_pawn.gd` (the seam's skin
read — one expression), `roster_capture.gd` (its rows grow for skins — same NEW fixture),
`tests/test_skins.py` NEW, art-integration coverage rows (R2 again), PERMANENCE rows for all
10-13 meshes (asset card owns them; §4).

### 3.3 ACCEPT

| # | observable | seam | red |
|---|---|---|---|
| K-E1 | default skin byte law: with `skin` unset/0 the journey+fixtures+strips stay byte-identical AND the art-fixture PLAYER row (1.67 m) is untouched (only forward-lock growth moves, R2) | §7.1 re-run | planted: the seam reads skin 1 by default ⇒ strips/art RED where B-E1 stays green — the independent-attribution pair |
| K-E2 | mesh gates per skin: file+tris+turntable+height rows (the §2.3 law, 5/5) | art fixture (R2) | planted flat-collapse (the M1c fragment class) ⇒ extent/fill + eyeball RED |
| K-E3 | clips per skin: frame-diff ≥ 2 px walk/attack + frozen 0 px (the same fixture, 5 more mesh pairs) | `roster_capture` (B-E8's pattern) | unanimated copy RED (same control) |
| K-E4 | skin verbs: purchase flag `skin:<id>` + spend table price through the ONE funnel; selecting a skin the char cannot wear (group empty) is a NO-OP write-side AND chip-disabled UI-side | the probe verbs (shop law shape) | planted: wear-check bypass ⇒ the no-skins char dumps a skin row ⇒ RED |
| K-E5 | roster SKINS pin: 5 rows, prices verbatim, ids ∈ files on disk, group law (only row 0 non-empty) | pytest table pin | planted 6th id with no file ⇒ pin RED |

## 4. PILLAR D — THE ASSET BATCH (the 3090 = vm100; SEL-A counts)

- **TRELLIS character-class meshes — n = 10** (5 roster + 5 skins): the §2.3/§3.1 pipeline
  per mesh (remaster sprite → TRELLIS (≤ 8000 tri, extent+fill+aspect gates) → validate_glb
  VISUAL → **bpy turntable-solid eyeball BINDS** (the §M1c2 blind-spot rule followed, not
  re-litigated) → UniRig → tools/mocap 05/06 walk+attack rewrite (CPU) → roster_capture
  frame-diff). Pose-class lesson APPLIED pre-commit (coil/helix shatter classes rejected —
  the M1c2/T-M2a rule; capes/robes ship as welded-block volumes, the player's own robe
  history is the ref). Manifests `tools/vm100/roster-batch-m5.tsv` (+regen spec) with seeds +
  prompt-sha16 per row; PERMANENCE rows for every shipped AND rejected variant (replace-not-
  delete).
- **imagegen icons — n = 11** (6 portraits at SEL-A + 5 skin chips; 512² RGBA, the §j style
  family, tEXt `imperfect`-prompt provenance per the existing convention, `tools/vm100/
  icons-batch-m5.tsv`, the icon_gate legs PROV+TRANSP re-run 11/11 + planted-red pairs).
  **Achievement badges n = 0** — rows ride INLINE names of shipped files via the
  `icon_path()` `_:` catch-all (the M4 P3-5 law verbatim: reuse, not a second badge family).
- **Re-roll reserve (~30 % law):** **+3 meshes, +2 icons** held; burned only on gate-RED
  rows; an unburned reserve is stated.
- **Windows-closed law (restated because every card loses one to it):** single-row windows
  (the MC 11236 lesson), drain_barrier before load, trap-close rc=0, llama-swap serving
  verified at EVERY close, windows ledger inside the capture; the imagegen window never
  joins a TRELLIS window (the regen2 lesson, §M1c2).

### 4.1 ACCEPT

| # | observable | seam (the ONE existing channel) | red |
|---|---|---|---|
| D-E1 | meshes: 10/10 shipped files exist, `validate_glb` VISUAL + tri ≤ 8000 + extent/fill/aspect gates + turntable-solid eyeball rows PASS (manifest rows per asset: seed + prompt-sha16 + gates + rejected variants with reasons); PERMANENCE rows written replace-not-delete (the S1p law: failures keep their rows) | the §M1c2 gate set (`validate_glb`, extent/fill/aspect — the `tools/vm100/` gates UNCHANGED, new rows) | planted: a flat-card copy (0.01 m extent, the seed-17 class) ⇒ the extent gate exits 1 on the manifest row — committed RED pair in the capture |
| D-E2 | icons: 11/11 icon-gate legs PROV+TRANSP + the new family pins (`icon-portrait-*`/`icon-skin-*` files exist for every roster row + skin; badges absent n=0 asserted) | the EXISTING icon-gate (15→11-row copy of the same two legs, `tools/`-pattern — the §M2a discipline, no new gate tool) | planted: a stripped-tEXt copy ⇒ PROV FAILS (exit 1); planted: a black-corner copy ⇒ TRANSP FAILS |
| D-E3 | the windows ledger closes: capture ends with the windows table (open/close timestamps + rc=0 + verifier-serving-after-close per window) and every window trap-CLOSED (the standing trap); reserve accounted (burned vs unburned named) | the capture idiom (`tools/capture_lib.py` pattern, `.tmp/` capture + `VERIFY_EXIT`) | any window open at capture end ⇒ capture FAILS to reach VERIFY_EXIT=0 (the ledger is the gate) |


## 5. THE VERSION DECISION (v3.0.0) + THE OWNER LINES

The law (`PARITY-ROADMAP.md:63-66`): **"major = a new player-navigated UI surface"**. M5
ships TWO (F-8): the character screen (a purchase screen — roadmap M4 item 1's own words) and
the achievements page (item 2's "page"). The trigger is not arguable under the law's wording,
and the law was stated to be a rule, not post-hoc (`:66`). **v3.0.0 is the law's verdict.**
Two owner lines ride, both pointed at T-M5z:
1. **Ratification (not invention):** the M4 landing note (`:336-338`) promised "the release
   that lands that surface carries the SEL version decision to the owner". T-M5z's brief
   presents v3.0.0-with-the-law-quote for the owner's word (his ratification is the artifact;
   the spec does not manufacture consent — it files the decision with the recommendation).
2. **The roster SEL (§2.5)** — OWNER-DECISION-PENDING verbatim marker; the build cards for
   T-M5c file only after BOTH the DA gate and his option word (his option changes ONLY
   table rows + batch counts, never the mechanism — that was the §2.5 design goal).

Rejected alternative (named for the DA): shipping the roster via the Dawn Well shop sub-
section to "keep v2.x" — the M4 §5 SEL-C rejection applies verbatim (a purchase surface
inside another purchase surface is still what the player navigates; gaming the bump is the
post-hoc move the law exists to prevent).

## 6. WAVE MAP (same-file serial law; GPU assets parallel)

`save.gd + main.gd + screens.gd + game_state.gd + roster.gd` are shared pairwise across the
pillars ⇒ the feature spine is **serial** (N3 law: parallel ONLY where file-sets are provably
disjoint). The asset batch touches only `assets/` + `tools/vm100/` + PERMANENCE ⇒ parallel,
with the standing ARTIFACT coupling (a mesh + its clips land before the roster row's B-E7/
B-E8 legs can close green — the M3 P2-2 precedent).

| card | one-line scope | files touched | depends on | can run parallel with |
|---|---|---|---|---|
| `T-M5p-ACHIEVEMENTS` | counters + table + page + Pillar A ACCEPT (P-E1..7) + R1(first move) + R3(first move) | save.gd, main.gd, achievements.gd NEW, screens.gd, achv_probe.gd NEW, tests/test_achievements.py NEW, test_save.py, tools/dawnwell_pixel_gate.py | — | asset batch ONLY |
| `T-M5c-CHARACTERS` | roster + select screen + seams + Pillar B ACCEPT (B-E1..9) + R1/R2/R3 moves + chars-m5 fixture + roster-clips fixture | roster.gd NEW, game_state.gd, main.gd, save.gd, screens.gd, hero_pawn.gd, sim_chars.gd NEW, roster_capture.gd NEW, sim_funnel.gd (opts growth), test_characters.py NEW, test_save.py, test_art_integration.py, test_hero seams, dawnwell_pixel_gate.py | `T-M5p` (the gate flags it consumes + shared files); **`T-M5a` — the mesh rows (B-E7/B-E8 coupling)** | asset batch ONLY |
| `T-M5k-SKINS` | SKINS rows + chips + seam read + Pillar C ACCEPT (K-E1..5) + R1/R2 moves | roster.gd, save.gd, main.gd, screens.gd, hero_pawn.gd, roster_capture.gd, test_skins.py NEW, test_art_integration.py | `T-M5c` (roster.gd, screens.gd, hero_pawn.gd shared) | asset batch ONLY |
| `T-M5a-ASSETS` | §4 batch: 10 meshes + rigs + clips + 11 icons + manifests + gates + PERMANENCE + Pillar D ACCEPT (D-E1..3) | assets/glb +10 (+sidecars), assets/icons +11, tools/vm100/*.tsv, PERMANENCE.md | — | **everything** (disjoint files; artifact coupling names the T-M5c rows) |
| `T-M5z-ACCEPT` | v3.0.0 release cut on the S9/S11 spine + full ACCEPT re-run (P/B/K/D rows) + **the GitHub-Release doctrine trio as DoD rows** (MC 11277: (1) release notes COMMITTED as `docs/RELEASE-v3.0.0.md` — shipped + known limits + the honest not-shipped line (per-char skins, pool gating, roster-expansion); (2) README current AT the tag; (3) doc-sync grep-to-zero) + the version RATIFICATION line + the roster-option quote on the card + GA | release spine, LEDGER, README, docs/ | all | — |

**Execution order:** `T-M5p → T-M5c → T-M5k → T-M5z` — ONE serial spine (every pairwise edge
named); `T-M5a` runs off-peak 3090 windows throughout and must land each row before the
consumer's legs close. SEL-C splits T-M5a into two window-sized cards (same file law —
PERMANENCE is append-serial, meshes are disjoint files).
**Doc-sync rows (retired-claim doctrine):** T-M5z rewrites the roadmap gap rows 7/10 CURRENT
cells (LANDED named: roster 6 + achievements page + skins 5 — with the SEL ruling quoted),
**AND the roadmap's OWN M2 #4 feature row `:238-240` (REV-2/P4-4: its ACCEPT text "fresh-save
leg shows gated card ABSENT" is the pool-GATING half M5 does NOT ship — the row gets
"counter+flag store LANDED-M5 (named); pool-gating NOT LANDED, tracked as the §9.2
follow-on", replace-not-delete, so no post-v3.0.0 reader finds it looking shipped-or-stale)**,
the M5 landing note (LANDED named / NOT LANDED named: pool-gating store, coin bags, roster
expansion, per-char skins, the 4th stage — the same replace-not-delete wording discipline),
DESIGN-3D §(f) layout lines for `roster.gd`/`achievements.gd`, README feature list + version
line, DOD-ACCEPTANCE N-table re-pins this wave falsifies. Every card appends its LEDGER row
in its closing commit (one-ledger law).

**Deferred-carry rows (CLEAN-CODE-AUDIT-2 §5) — each NAMED, none silently inherited:**
`world.gd` split SCHEDULED — **UNTRIGGERED: zero M5 card touches world.gd** (the file-set
column above is the proof; F-3); `sim_stages.gd` 583 plates-split — no M5 legs land there;
`strips_capture.gd` 596 — not touched (skin/char visual law rides roster_capture, F-9) — the
deferral re-named for its next touching card; `sim_events.gd` 537 — untouched. WATCH ROW:
`screens.gd` 445 + two overlays ≈ +130 lands ~575, UNDER the 600 hard fail but within
walking distance — each screen card carries the walk re-run; if a card crosses 400→600 the
reason header row count (FIFTH→SEVENTH overlay) moves IN THE SAME COMMIT (the audit law:
the reason must state the truth, not stale); if any card actually crosses 600 the overlay-
builder split rides THAT card byte-risk-free (screens.gd is pure UI — no dump stream reads
it; the §7.1 corpus cannot move).

## 7. BYTE ANCHORS, NORMS, AND THE RETIRE LEDGER (current post-refactor reality)

### 7.1 The corpus law (restated for M5 at the `48f5b33` reality — the three classes)

1. **STRICT, byte-identical (`cmp`)**: the 12 committed fixtures — `endless-m2`,
   `gem-merge-m2g`, `unions-m2u`, `chests-tiers-m2`, `chests-evolve-m1e`, `carry-caps-m1b`,
   `stages-m3`, `events-m4`, `reaper-m4`, `limit-m4`, `skinned-clips-s2r-framediff.csv`,
   `art-s2i-probe.jsonl` (carve: FORWARD-LOCK growth under R2 — **18 rows at this base,
   REV-2/P3-1 de-staled from the git-measured history: 13 base rows → 15 at T-M3b → 17 at
   T-M4e → 18 at T-M4r; M5's growth is the FOURTH, prior 18 rows byte-preserved**) — plus the `sim_headless`
   **journey re-dump: 5020 rows @ HD3D_SEED=11101**, re-dumped FRESH on the card's tree vs
   the committed records (the T-C3 gate idiom; fresh worktree, `--import` first, `cmp`).
   New M5 fixtures (`chars-m5`, `roster-clips-m5-framediff`, `achv` probe rows) are
   generated TWICE cmp-identical before commit and are forward-locks for M6, never this
   milestone's anchors (the M4 §7.1(c) law verbatim).
2. **MODULO the declared mechanical norm**: the strips dump (`HD3D_ATK_SEED=11114` lineage)
   compares after removing engine `_ms` fields and rewriting capture-dir `png`/`png_path`
   prefixes to `CAPDIR`; every measured value byte-equal otherwise (the exact C3/C2 wording
   governs; gate 19/19 GREEN on the fresh post dump).
3. **RUNTIME RECORDS, contract checks (NOT byte identity)**: the `.tmp` s8 gameover/win dumps
   (s8-gameover seed 11104 / s8-win seed 11103 hp-pin / the 5020-row journey file) pass the
   A1 contract checks (kind / hp-pin / monotonicity / t_sim / kills) on fresh runs; the
   committed GA records keep `tools/s8_acceptance.py` **11/11** green from a clean checkout;
   the planted kind-flip red control stays the file's law.
4. **The `s8_capture.gd` DECLARED-capture-variant pattern** (the file's own post-refactor
   reality: THREE variants chained — `HD3D_STAGE :26 → HD3D_REAPER :32 → HD3D_EVENTWAVE :50`,
   each a SEPARATE run with its own `HD3D_SHOTS_DIR`, default shots byte-invariant, capture
   pins NAMED at the shot): M5 needs no new variant (the pixel law rides
   `dawnwell_pixel_gate`'s overlay rows, which is the shop/stage capture idiom, not the s8
   one) — stated so no card invents a 4th variant where an existing gate row fits. The
   `SimFunnel` seam (fresh_run/check/decline/take_first_card/out_path/r3; `sim_stages.gd:98`
   `_check` delegator kept for the `sim_bosses.gd:90,:133` duck-surface) carries the new
   `sim_chars` legs through its DECLARED opts growth; the delegator stays UNTOUCHED (the M4
   F-9 law survives). Every planted-red leaves the tree byte-exact-restored (git clean/`cmp`)
   and the suite green after.

### 7.2 RETIRE LEDGER (every pinned row this milestone moves; REPLACE-NOT-DELETE, SAME COMMIT)

| # | row moved (verbatim pin cite) | falsified by | replacement (equal-or-stronger, named) |
|---|---|---|---|
| R1 | `tests/test_save.py:184-186` — `assert set(disk) == {"version", "gold", "ranks", "flags", "best_cycle", "stage"}, "on-disk keys must be exactly the roadmap's four + best_cycle + stage"` (the row's own comment already narrates its two earlier honest moves) | T-M5p (`counters`), T-M5c (`char`), T-M5k (`skin`) — three same-commit re-pins, in series | each re-pin names the EXACT grown set (`+counters` → `+char` → `+skin`) and keeps the older-fields-roundtrip-true legs + the VERSION==1 no-bump leg + the migration-default leg (`{}`/`0` on an older save — the `best_cycle` proof shape); equal-or-stronger: each pin adds the new field's DEFAULT assertion, none weakens an old one |
| R2 | `tests/fixtures/art-s2i-probe.jsonl` (**18 rows at this base** — REV-2/P3-1: 13→15→17→18 measured through T-M3b/T-M4e/T-M4r) + `tests/test_art_integration.py` coverage/file-exists rows (`:73-95` GLB_FILES law — ENEMY-scoped, and `:152` the player-seam pin) | T-M5c (+≤5 char meshes), T-M5k (+5 skins) — PLAYER-class rows join | forward-lock growth again (**prior 18 rows byte-preserved — the T-M3b precedent's FOURTH growth**); coverage rows re-pin IN BOTH consuming commits (the standing rule); the `:152` seam-pin test is EXTENDED to the selection read, its default-mesh assertion KEPT verbatim; card-time re-grep duty: any set-equality row over the GLB dir listing found at card time retires HERE, same commit (the M4 R-rows' standing clause) |
| R3 | `tools/dawnwell_pixel_gate.py` row set `{"shop_shot", "stage_select_shot"}` (`:47-49, :69-70`) + the capture's rows.json contract | T-M5p (+achievements shot), T-M5c (+char-select shot) | ADDITIVE rows, SAME floor `PX_MIN = 200`, same hidden-UI baseline idiom (the ONE capture launcher `tools/capture_lib.py`); each new row carries its own baseline-vs-baseline planted red re-proven at the card |
| R4 | `docs/PERMANENCE.md` asset rows' coverage ("every file under `assets/glb/`… provenance") + the `tools/vm100/` manifest set | T-M5a ships 10 character-class GLBs + 11 icons | new §M5a provenance sections (seeds, prompt-sha16, turntable rows, rejected-variant rows KEPT with reasons) — replace-not-delete, the S1p/S1q era rows untouched |

**Named STAY probes (green by construction — the DA should verify each stays green, not
re-litigate them):** `test_endless.py:130-135` (hand-in regex — F-7 placement law),
`test_endless.py:138-148`-era R9 cap-fork pin (main.gd:266-269 untouched by M5),
`test_endless.py:123-127` (run-mode reset pin — names endless/cycle only),
`test_card_icons.py:138` (`== 32` pool kinds — characters/skins/achievements are NOT pool
kinds, the M4 R7 wording still says exactly the truth), the exact-12 snapshot pin
(`snapshot_json` field list untouched; the 13th-field instrument legs are B-E4's),
`test_dawnwell_shop.py:136-157` (start_run consumption :136-139 + main wiring :153-157,
incl. the GOLD→FUNNEL adjacency `:156-157` — additive lines keep
every pinned regex matching), the phase enum, `SPEC_MAP` 7-row chest map, BIOMES/STAGES
tables (F-1 adds no stage/event), `test_art_integration.py:42` (`DRAWS_PLANNED = 40` —
consumed or not is §8's re-tally), the `sim_stages.gd:98` delegator (F-9).

## 8. BUDGET — re-derived under the roadmap §2 WORST-CASE LOADOUT

The NAMED loadout is unchanged (Red Wail / Thousand Darts / Rot Spiral / Judgement Cross /
Eternal Matins / The Sluice, L8/evolved + the 6 partners; the `sim_budget` DECLARED-PIN
construction channel; play-reachability NOT claimed — roadmap §2). Measured-now truth
(v2.1.0 cut): draws **27** ≤ plan **40** ≤ hard **60**; horde **≤ 400**; gems ≤ 200.

- **Draws: ZERO new draw classes.** A character/skin is the SAME one player draw at the SAME
  ONE seam (`_player_mesh()` returns a different ArrayMesh, one draw either way — the T-S2p/
  S2i height-normalised loader law); achievements page/select overlay = CanvasLayer (outside
  the 3D budget by §b's own law). `DRAWS_PLANNED` stays 40; `budget_chars` leg added to
  `sim_budget.gd` IN PLACE (the P3-4 M4 precedent): a row-0 run re-measures the byte-true
  27/400/≤60 row; a per-new-character run CANNOT co-exist (one player per run — stated, so
  no card invents a 2-hero leg).
- **Alive/RNG: zero new spawn channels, zero new RNG sites** (roster/achievements consume
  none — B-E1/P-E7's leak instruments).
- **Persistence row: THREE new save fields (`counters`/`char`/`skin`), VERSION stays 1** (the
  additive-default law, R1's legs; a bump exists to quarantine what a loader cannot migrate —
  none here).
- **Contract-B snapshot: ZERO delta** (char/skin ride outside — the exact-12 pin + B-E4's
  instrument leg; no phase value; no new bridge field).
- **CPU:** the counter block is int math at run end (once per run, off the hot loop); the
  roster rule terms are per-frame float multiplies at THREE existing call sites (the limit
  terms already proved the cost shape). No budget row moves.

## 9. EXCLUSIONS (reasons, not silence)

1. **The 3D "pivot" (perspective camera / full 3D physics / skinned horde / heightmap)** —
   DESIGN-3D rejects each where the doc puts it (perspective + 3D physics at §a, skinned
   horde + heightmap at §h — REV-2/P4-1) under the owner's verbatim top-down ruling;
   overturning a DA-
   gated design + an owner ruling is an OWNER decision with no artifact on the table (F-1,
   Rule 2). This milestone IS the endgame's next step.
2. **The pool-GATING half of the unlock store** (roadmap M2 #4's second clause: gated cards
   ABSENT from the level-up pool until a flag) — the counter/flag half lands (its gates NEED
   it, F-3/F-4); pool gating is a `build_pool` change with its own cap-interaction analysis
   (the M1 feature-3 carry caps) — named+tracked as `T-M5q-POOLGATE`-shaped follow-on, not
   absorbed (size law).
3. **Roster expansion (+8 weapons/+5 passives; M2-SPEC §8.5) + coin bags (§8.1)** — pre-
   existing tracked deferrals, re-named in the landing note, unchanged.
4. **Per-character skins** (skins for the 5 new heroes) — roadmap item 4 scoped skins to the
   existing rig/player (F-9's honest group law, §3.1); the row shape already supports it.
5. **Reaper-gated achievements** — a hidden-flag feature cannot gate a visible purchase
   surface a player can find (§1.1's named rejection).
6. **Their 165-character roster / their achievement text** — clean-room: shapes cited to
   VS-FEATURES VERIFIED lines; every id/name/number/condition OURS, pinned by OUR suite.
7. **Any new pickup kind, drop funnel, spawn loop, overlay STYLE, capture mechanism, sim-side
   RNG, animation mechanism, or stat family** — every pillar composed from shipped seams;
   new overlays ride the ONE panel style; new sims ride SimFunnel; new pixels ride the ONE
   pixel gate.
8. **Roadmap §3 standing exclusions unchanged** — co-op, cloud saves, mobile, DLC-flagged
   inventory, counterparts/Inverse, arcana/secrets/spells.
9. **The 4th stage** — Stretch, no DoD (F-10, M3 F-8 lineage).

## 10. DA-ATTACK PREEMPTIONS (the tail — attacks I expect and the row that answers)

- *"Characters change every run — the byte corpus is dead."* — They change ONLY a
  non-default selection (F-2); every committed dump runs row 0, whose weapons line is the
  literal `:173` row and whose rule terms are IEEE identities (`+0.0`/`×1.0`, the
  limit-break precedent); B-E1/K-E1/P-E7 are the leak instruments with the planted swaps
  named, and the both-sides design (a leak flips B-E1, a wrong rule flips B-E3) makes the
  pair independent (the T-M3g attribution pattern).
- *"The counter store is mid-run eventing you papered over."* — F-3 named exactly which
  achievements need world sites (chest counts) and DID NOT SHIP them; the 20 shipped rows
  are each computable at `_end_run` from the named rows; P-E3's whole-scripts grep pin
  (REV-2 — the named instrument, §12 F-5) is the mechanism proof.
- *"v3.0.0 games nothing — but did you HIDE a third surface?"* — F-8 counts the overlays
  (6th/7th) and names why the skin chips are not one; the menu gains exactly two buttons;
  a fresh save shows both reachable (the state rows in B-E6's dump).
- *"UniRig gives per-mesh generic skeletons — 'same 34-joint rig' is false in your own
  table."* — §3.1 states the honest reading at pipeline level (same tools, same CMU sources,
  no new rig CLASS; bone counts are per-asset — the S2r rows are the evidence) and B-E8/
  K-E3 gate the observable (frame-diff), not the claim.
- *"596/583/551/537 — you grew the >400 files and dodged the splits."* — F-9 + §6's
  deferred-carry rows: world.gd/sim_stages/strips_capture/sim_events are each NAMED
  untouched with the proof (the file-set column / no-legs / no-capture / no-rows); the new
  rules live in two NEW small modules and the watch row (screens.gd) carries its own
  crossing plan; the suite walk re-run closes every card (0 findings, the C1 discipline).
- *"Six is a made-up number."* — It is the roadmap rev-3 row-7's OWN number, quoted; and it
  is exactly why the SEL table is OWNER-DECISION-PENDING — the spec refuses to choose for
  him and prices all three answers (the brief's own law).
- *"Portraits/badges are new assets with no provenance."* — §4: every mesh/icon row rides the
  manifests + PERMANENCE + turntable/legendibility gates already in force; badges are reuse
  (n=0), stated, not invented.
- *"The purchase screen is the shop you already have."* — The shop mutates RANKS (repeatable
  upgrades, refunds); the roster mutates IDENTITY (buy-once unlock + selection, no refund —
  F-6); one mechanism per concern holds: the RULES module differs because the concern
  differs, the FUNNEL (one save path), the STYLE (one panel idiom) and the LAWS (disabled-
  not-hidden, no-op-no-write) are REUSED verbatim.

## 11. THE 10-POINT SELF-DA CHECKLIST

1. **Clean-room:** every number OURS and pinned by OUR suite; every "their" line cites
   VS-FEATURES shape quotes (S6 ~477-483, S7 ~613-624) or the roadmap's own DA-fix wording;
   zero copied value/asset/name/condition-text.
2. **F-1 grounded on DESIGN-3D's actual maturity** (the pivot question answered from the
   doc's §§ + the owner's verbatim top-down ruling, not vibes); a pivot outcome REQUIRES the
   owner artifact the spec names.
3. **Version law (§5):** v3.0.0 argued from the law's wording (`:63-66`) + the M4 landing
   note's promised ratification line; the roster SEL is the ONLY pending choice and it is
   priced, not pushed.
4. **Reuse-first / monogamy:** achievements = the ONE `_end_run` funnel + the ONE flags dict
   + the ONE panel style; roster = the ONE `_player_mesh()` seam + the ONE hand-in seam +
   the THREE existing stat seams (limit-shaped) + the ONE save funnel; skins = the same seam
   read. Declared exceptions: NONE beyond new data modules (`roster.gd`/`achievements.gd` —
   the repo's own rule-module convention) + `SimFunnel`'s DECLARED opts growth (an option,
   not a fork).
5. **Every ACCEPT row names ONE existing seam + a planted red naming its check** (24 rows:
   P-E1..7, B-E1..9, K-E1..5, D-E1..3); the new sim file rides SimFunnel and the
   `sim_stages.gd:98` delegator survives (F-9).
6. **Ceilings unbreached:** zero new spawn/RNG sites; the roster consumes stats at the same
   three formula lines the caps already govern; the draw table is byte-true 27/40/60 (§8);
   the exact-12 snapshot stays.
7. **Byte-stability:** §7.1's three classes at the CURRENT post-refactor reality (journey
   5020 @11101; strips modulo `_ms`/CAPDIR; s8 = A1 contract checks not bytes; the
   s8_capture variant pattern stated as the pattern M5 does NOT need to extend); R2's
   forward-lock is the only growth carve; planted-reds byte-exact-restored.
8. **Budget re-derived under the NAMED loadout** with the zero-new-classes argument + the
   same-commit re-tally rule standing.
9. **Contract B untouched + persistence honest:** zero snapshot delta; THREE additive save
   fields, VERSION 1, R1's three-dated-move lineage; the F-7 pin-placement law keeps the
   endless source pins byte-true (the M4 R9 lesson applied PROACTIVELY — the pin was read
   before choosing where the new lines go; REV-2 keeps the score honest: the gate caught a
   pin I had NAMED but not obeyed — the gold→funnel adjacency — and §1.1 now OBEYS it,
   §12 F-2).
10. **Wave-map discipline:** ONE serial spine with every pairwise edge named; the asset
    batch the only parallel row with the mesh coupling; the deferred-carry rows named not
    inherited; the release row carries the GitHub-Release trio + the version ratification +
    the roster-option quote as DoD rows; every card's LEDGER row in its closing commit.

---

## 12. REV-2 FOLD LEDGER (DA cycle 1 dispositions — the M4 §13-style ledger)

The DA doc (`docs/M5-SPEC-DA.md` @ `9b1d067`) is immutable; this is the author's disposition
record, every row re-grepped against the tree at `9b1d067` BEFORE adoption. **Dispositions:
12 ADOPTED, 0 rebutted; 2 mechanism readings inside adopted rows corrected to measured truth
(F-12/F-13 rows) — corrections to the spec's OWN reason-text, not to the gate's fix clauses.**

| # | finding | disposition | REV-2 landing + the re-grep evidence |
|---|---|---|---|
| F-1 | P1-1 pawn never receives the selection | **ADOPTED** (the strongest finding; re-grepped: `hero_pawn.gd:35` sets `mesh` ONCE at `_ready`; `_pawn` at `main.gd:32/:89-91`, nowhere else — boot-once confirmed) | §2.1b `apply_selection()` (the `_ready` body MOVED, material law `:36-43` rides verbatim) + call as F-7 block tail + B-E7 pawn-lifecycle twin-leg + §2.4 file rows; the seam-pin substring form re-read (`test_art_integration.py:152-162`) makes the extension legal as written |
| F-2 | P2-1 block placement vs the gold→funnel adjacency pin | **ADOPTED** (regex re-read verbatim: `gold += …\s*\n\s*_meta_changed()` — whitespace only; "BESIDE :372-376" is ambiguous and two of its three readings fail) | §1.1 rewritten: landing FORCED ABOVE the `gold +=` line, below the best_cycle write; PIN-HOLD clause; §7.2 STAY cite extended to `:136-157` naming `:156-157`. Precision note (gate-internal, harmless to its verdict): its "between :374/:375 breaks the pin" example is WRONG — the regex STARTS at the gold line, an insert before it would not have broken `:156-157` — the finding stands because BESIDE still licensed the two readings that DO fail and the landing was never named |
| F-3 | P2-2 table rows into run state without the aliasing law | **ADOPTED with mechanism correction** | §0 F-5 duplicate() law + §2.1 consumption + B-E2 multi-run leg, as the gate's fix clause has them. Correction to measured truth: at the pinned Godot 4.7.2 a const container's nested rows are DEEPLY READ-ONLY (binary probe THIS session: `Invalid assignment on read-only value (on base: 'Dictionary')`), so the naive hand-off FAILS LOUD at run 1's first weapon mutation, not silently poisons run 2 as the gate's Godot-3-style mechanism read said; the fix and the leg are adopted regardless (loud failure is still a shipped-milestone failure; the leg guards the mutable-shape future) |
| F-4 | P2-3 zero-write leg contradicts the Σ-add table | **ADOPTED** (re-grepped: `runs_total += 1` unconditional in the §1.1 table; the shop no-op is a VERB law) | P-E1 rewritten to the zero-DIFF shape verbatim from the gate's fix clause; §1.1's "writes nothing new" sentence replaced by the honest always-write law |
| F-5 | P2-4 phantom instrument on P-E3 | **ADOPTED** (re-grepped: the "marker-count == 2" pin DOES NOT EXIST — `test_save.py` markers are QUARANTINE markers; real instruments `test_save.py:133` MAIN-scoped + `test_stages.py:296` block-scoped) | P-E3 rewritten: real cites, the named NEW whole-`godot/scripts/` grep pin (`main.gd:421` the one legal outside site, measured), `_meta_changed(` shipped-set count (6 calls + def = 7, measured), reds re-pointed at instruments that FIRE (the whole-scripts pin + the adjacency pin the P2-1 landing now owns) |
| F-6 | P3-1 stale 17-row fixture count | **ADOPTED** | §7.1 + R2: 18 rows at base, growth history 13→15→17→18 MEASURED from the git objects (`9efcf6e`=15, `1e6d366`=17, `48fad4b`=18), M5 grows the fourth; B-E7 already says prior 18 |
| F-7 | P3-2 stale `sim_events 533` | **ADOPTED** | F-9 + §6: 537 (measured at `48f5b33` AND `9b1d067`; world/sim_stages/strips 551/583/596 re-confirmed same walk) |
| F-8 | P3-3 six drifted header cites | **ADOPTED** (all six re-measured at `9b1d067`: `start_run() :302`, `VERSION :24`, `save() :76`, fields `:27-42`, overlays `:98-107`, `start_run():144-180`/`set_phase:182`) | Header Code-truth rewritten at the truth; the REV-2 header says plainly the drift was in MY cites, the tree was identical |
| F-9 | P4-1 §h/§a attribution crack in F-1 | **ADOPTED** | F-1 + §9.1 re-pointed: perspective at §a `:19-20` (re-read), the rest at §h; substance (the rejection exists, the ruling is verbatim at `DESIGN-3D.md:4`) unchanged, exactly as the gate said |
| F-10 | P4-2 T-S1p window over-count | **ADOPTED** | §2.5: ONE bounded window quoted as measured (15:37→15:44), ~3/mesh kept as the RESERVED estimate — the gate's own note: the error direction was safe, the honesty row still had to move |
| F-11 | P4-3 cross-milestone B-E1 collision | **ADOPTED** | B-E4 red column: "the M4-SPEC B-E1 endless-pattern red" |
| F-12 | P4-4 roadmap `:238-240` doc-sync | **ADOPTED** | §6 doc-sync list: the M2 #4 row re-worded LANDED/NOT-LANDED named, replace-not-delete (row text re-read: its ACCEPT names the pool-GATING half §9.2 excludes) |
| F-13 | **self-caught at re-grep** (not the gate's): REV-1 §2.1 row-1 start weapon `"ember-bolt"` is not a shipped id (`weapons.gd IDS`: `"ember"` — the B-E9 rule's own list) | **ADOPTED** (self-disclosure row) | Table fixed to `ember`; the typo becomes B-E2's PLANTED red example — the drift class that row exists to catch, armed with the real near-miss |
| F-14 | self-check: SEL table, the owner marker, the version decision, the byte-anchor classes, F-3's zero-world.gd file-set | **UNTOUCHED — the gate PASSED them** (per-option arithmetic re-derived by the gate independently; the base suite re-reproduced green there: 278 passed, RC=0) | No change; the REV-2 header records the PASS list so c2 need not re-attack it |

**Fold arithmetic: 20 + 4 = 24 ACCEPT rows unchanged (legs strengthened, no row added —
the gate's rows-1-5 fix clauses were leg/section rewrites); 0 new mechanism; the wave map,
version decision, SEL table and owner lines are byte-identical to REV 1's decisions.**

--- END M5-SPEC ---
