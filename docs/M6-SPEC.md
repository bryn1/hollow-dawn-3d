# M6-SPEC — hollow-dawn-3d "Feel & Fidelity" (v3.1.0) — build-depth spec for the DA gate

- **REV 1, 2026-10-28.** Build-depth spec for M6, authored for the **devils-advocate gate**
  (fleet law: roadmap-gated build cards file ONLY after the DA SHIPs this). Same spec depth
  M2/M3/M4/M5-SPEC gave their milestones (M5-SPEC `docs/M5-SPEC.md` is the shape precedent
  this doc mirrors: findings, per-feature design with ACCEPT rows naming ONE existing seam +
  one planted red, version decision, wave map, byte-anchor law + retire ledger). A build card
  executes straight from an ACCEPT row; this is not a plan sketch.
- **Base + suite truth (verified THIS session, the author's worktree at `aca4ea8`):** spec
  authored at `origin/master = aca4ea84` (T-CC3R REFACTOR-3, the v3.0.0-era clean-code close —
  audit-3 `3d4fdf6` measured 0 ceiling findings; the clean-code-after-milestone doctrine is
  satisfied for v3.0.0, so a next-milestone spec is lawful on this base).
- **Code truth (every claim re-grepped THIS session at `aca4ea8`; file:line are the truth):**
  `weapons.gd` (478 L — `IDS :23-25` (16 ids incl. `doom-sigil`), `MAX_LEVEL := 8 :26`,
  `META :28-45` (per-weapon `name/icon/desc` — **desc ALREADY ships for all 16**, doom-sigil
  desc `"Rare screen-clear blast" :44`), ONE `_hit :118-140`, ONE `_fire :143-330`
  (`doom-sigil` branch `:323-326` — ward-ring class + ONE full-screen `_hit` r 760, cd 12 s),
  evolved-id `_:` no-op arm `:327-330` ("fire no-ops unknown ids… the pool never offers an
  evolved id"), `_update_orbit :348-416` (halo + the TWO unions), `_step_projectiles
  :425-470` (the ONE `pierce`/`bounce`/`ret` flag set), `_step_fx :473-478`);
  `viz_fx.gd` (374 L — SIX effect classes batched to `FX_DRAWS_MAX := 7 :19`; `_ready :43-50`
  the per-class materials (orb/trail/halo = EMBER, arcs/rings = MOON, throws = BONE, shards =
  ICHOR — **the per-CLASS color law that makes skills "look roughly the same"**), family caps
  `BOLT_ROSTER :100 / THROW_ROSTER :101 / _cap :117-124`, ward band-by-level `:219`, spike
  shard count `:258-270`, `_mat :290-304` (unshaded+additive+CULL_DISABLED law));
  `world.gd` (551 L — `ENEMY_TYPES :121-183`, `GATES :186`, ONE `update_entities :389-412`
  with the ONE magnet source `:399-402` (`60.0 * (1+0.25·grip)` + the loadstone `+15.0·stack`
  line) and `_magnetize` called for `gems :403` + `heals :404` ONLY — **coins are NOT
  magnetised**, `_magnetize :416-423`, `_merge_gems :435-448`, ONE kill funnel `kill_enemy
  :464-500` (reaper death-guard `:477-478`; gem roll `:481-482` 0.7, coin roll `:483-484`
  0.06, heal roll `:485-486` 0.015, chest rolls `:495-500`), ONE touch funnel
  `collect_pickups :504-545` — gems/coins/heals/chests at 16 px, chest-open arm
  `:532-541` = `UnionSystem.try_union` else `EvolutionSystem.try_evolve` (`:539-540`), the
  ONE `credit_gold` return `:545`);
  `evolutions.gd` (66 L — `GATE_T := 600.0 :21`, the ONE evolution `TABLE :27-38` (10 rows
  `base → {partner, evo}`, incl. `"doom-sigil": {partner: "gilded-skull", evo: "pale-moon"}
  :37`), the ONE rule entry `try_evolve :48-66` (gate `t ≥ 600` + `w.level ≥ MAX_LEVEL 8` +
  partner passive ≥ 1 + the `UnionSystem.reserved_for_union` reserve `:61`; in-slot write
  `w.id = row.evo; w.cd = 0.0 :63-64`));
  `union.gd` (83 L — the §D.1 union rows + `reserved_for_union`; T-M2u header states its rank
  rule **references `EvolutionSystem.GATE_T`** — no second 600 literal; the GATE_T retirement
  in §3 must re-grep this, §4.4 R6);
  `levelup.gd` (151 L — `PASSIVES :10-29` (15 rows, **every passive already carries a desc**;
  card `icon: "" :65` — the screens-side resolver fills it), `build_pool :32-66` (the ONE
  pool seam, caps `MAX_WEAPON_SLOTS/MAX_PASSIVE_KINDS :7-8`), `make_offer :101-123` (the ONE
  offer seam, `pool.shuffle() :119` — **any pool-size change forks every committed offer
  stream**), `apply_offer :126-151` (the ONE pick-apply site));
  `screens.gd` (582 L, dispatcher + core panels post-CC3R — `PASSIVE_ICONS :62-78`,
  `icon_path :89-98` the §j total resolver, `_card :275-312` renders icon + name +
  `card.desc` (`:303`) + Lv row — **the short text already renders for weapon/passive
  cards**); `roster_select.gd` (131) + `achievements_page.gd` (52) the moved builders;
  `hero_pawn.gd` (96 L — `apply_selection :42-53` (mesh + material re-derive), `_player_mesh
  :78-87` the ONE char/skin-guarded mesh seam (row 0 = the literal `"player.glb"`),
  `_process :90-96` — position + iframes alpha ONLY: **the pawn has NO animation playback of
  any kind — no clip, no gait; it slides**);
  `horde_viz.gd` (331 L — `GLB_FILES :41-76` (18 classes), gait law `:147-191`: per-instance
  scissor width/depth `SCISSOR_MIN/MAX 1.00↔1.24` at `f = spd_m/GAIT_STRIDE_M ≤ 2.2 Hz`
  (`:79-82`), the `hit_cd` rising-edge attack lunge `:172-189` (`LUNGE_M 0.24`,
  `SQUASH_LO/HI 0.85/1.15`, `ATK_TIME 0.2`), HP bars + blob MMs, `draw_count :239-247`,
  `gait_probe :265-279`); `class_mesh.gd` (72 L — `_import :35-48` reads
  `surface_get_arrays(0)` and bakes a uniform vertex scale: **the loader STRIPS skinning and
  animation — every in-game GLB draws its rest pose**); `render.gd` (201 L — palette
  `:16-22`, `ENEMY_TINTS :26-32` (the five classics), `BIOME_TINTS :37-42` (the four
  signatures), `tint_of :45-46` the ONE lookup both draw paths use — **classes absent from
  BOTH tables read `Color.WHITE`**: hollow-knight, hollow-deacon, sunken-prelate,
  stair-acolyte, the-reaper, cathedral-choir, ossuary-warden — raw dark baked TRELLIS
  textures on a floor the gate holds at mean luma ≤ 34, the measurable "hard to spot" class);
  `pickup_viz.gd` (323 L — `DRAWS := 5 :84` gem/coin/cross/glow/chest MultiMeshes, the
  bulk-gem COLOR-instance law `GEM_BULK_*`); `game_state.gd` (314 L — the 15-key `passives`
  dict `:96`, the formula seams `:124-170`, the frozen 12-field `snapshot_json`);
  `main.gd` (599 L — `game.gold += world.collect_pickups(game) :261`, the frozen
  `pending_levels → _enter_levelup` seam `:291-303/:370`, `_offer/_pick :385-393` riding
  `make_offer`/`apply_offer`).
- **Animation truth (F-1, the load-bearing finding — stated before anything else).** In the
  SHIPPED game, **no entity plays a skeletal clip**. The clips exist as files —
  `tools/mocap/` maps + the S2r/M5r rewrites bake named glTF `walk`/`attack` animations into
  `assets/glb/player-rigged.glb` + `assets/glb/boss-warden-rigged.glb` (REPO-ROOT provenance
  dir, NOT under `res://`) and into the 7 rigged SEL-C files (`char-emberwright/-grave-ward/
  -duskrunner/-iron-penitent.glb`, `skin-ash/-marrow/-relic.glb`, `godot/assets/glb/`, per
  `docs/RIG-DEVIATION-SEL-C.md`) — but `ClassMesh._import` reduces every GLB to a rest-pose
  ArrayMesh and the ONLY consumers of the clips to date are the CAPTURE harnesses
  (`skinned_capture.gd`, `roster_capture.gd` via `tools/roster_clip_gate.py`) that prove them
  frame-diff at capture time. In-game motion is: hero pawn = position writes only (slides,
  no gait); every horde/boss/miniboss/reaper = the §c transform gait (scissor squash) + the
  hit-edge lunge. So the owner's "hero has animation while moving… same for all creatures"
  reads against a REAL gap for the hero (zero motion cues) and a PARTIAL one for creatures
  (a squash-pulse that does not read as locomotion on solid TRELLIS meshes). The 2D-era horde
  STRIPS (mirrored `static/assets/enemies/` sprites) are NOT a spawn path: what the 3D sim
  spawns TODAY per stage is the band roster + GATES (`render.gd BIOMES` × `world.gd GATES`) =
  the 8 horde classes + each stage's scheduled bosses — all GLB MultiMeshes
  (`horde_viz GLB_FILES`), all rest-pose + scissor.
- **Clean-room stance (inherited, binding):** `docs/VS-FEATURES.md` shapes only; every id,
  name, number, color, and threshold below is OURS and gets pinned by OUR suite.
- **docs/ARCHITECTURE.md:** ABSENT by repo precedent (M2–M5-SPEC note verbatim: the repo runs
  its own spine LEDGER + DESIGN-3D + PARITY-ROADMAP + M*-SPEC).
- **Length note (exceeds the ~300 hygiene line, stated why):** one pointable build-depth
  artifact for one release (M2 536 L / M3 667 L / M4 782 L / M5 856 L precedent). Each feature
  is self-contained so the DA can gate one at a time.

## OWNER ORDER (verbatim, binding — 2026-10-28, MC 11625 dispatch brief)

> file cards for all of them. i also want to make sure that the hero has animation while
> moving, to make sure the moves look animated, same for all creatures. Also, the naimations
> for attacks all look roughly the same and should have individual looks that correspond with
> the icon of the skills. a part of a type of game like this the passives are connected to the
> skills where a passive makes a certain skill better. when skill is lvl 5 and the correct
> passive is chosen the skill gets a new look and get a big boost in its visuals, damage, area
> and functionality. The pickup radius for exp chould also include coins. There is a skill
> that i cant remember the name of that kills everything on screen, this should not be skill
> but something that drops from mobs like coins and exp that when picked up clears the screen
> instead.
>
> so:
> Everything above, connect skills and passives (passives should show small icons on what
> skills they affect) a small explination of what each skill does as a short text when skills
> are choosen, the clear screen skill is now a rare drop instead. improve visuals for
> movements and attacks for everything. Some mobs are very hard to spot due to low contrast.

**Clause decomposition (every clause → one feature section; the "so:" restatement rows ride
the same features):**

| # | owner clause (short) | feature |
|---|---|---|
| 1 | hero animates while moving | F1 §1 |
| 2 | same for all creatures | F1 §1 |
| 3 | attack looks individual per skill, matching the skill ICON | F2 §2 |
| 4 | passives connected to skills (a passive makes a skill better) | F3 §3 |
| 5 | skill lvl 5 + correct passive → new look + big boost (visuals/damage/area/functionality) | F3 §3 |
| 6 | XP pickup radius includes COINS | F5 §5 |
| 7 | the screen-clear skill is NOT a skill — a rare mob drop that clears the screen on pickup | F6 §4 |
| 8 | passives show small icons of the skills they affect | F3 §3 (UI rows) |
| 9 | short explanation text when skills are chosen | F4 §6 |
| 10 | clear-screen = rare drop (restatement) | F6 §4 |
| 11 | improve movement + attack visuals for everything (restatement) | F1 §1 + F2 §2 |
| 12 | some mobs hard to spot — low contrast | F7 §7 |

The screen-clear skill the owner could not recall is named here: **Doom Sigil**
(`weapons.gd:44` `"Doom Sigil" … "Rare screen-clear blast"`, `_fire :323-326`; its evolution
row `doom-sigil → pale-moon` at `evolutions.gd:37`).

## 0. FINDINGS + STATED READINGS (read before the DA opens any feature)

- **F-1 (nothing is animated in-game; the clips are proven, the consumer is missing).** As
  inventoried in the header (Animation truth row). Consequence for the design: F1 is NOT an
  asset milestone — the rigged content already shipped and is frame-diff-proven
  (`roster-clips-m5-framediff.csv`, `skinned-clips-s2r-framediff.csv`); what M6 ships is the
  RUNTIME CONSUMER (clips for the pawn path, better procedural motion for everything the
  MultiMesh draws) and the honest re-pin that the shipped game, not the capture harness,
  animates. The rig-yield law is untouched (no rig attempts in this spec, §1.5).
- **F-2 (attack looks are per-CLASS, not per-skill — the owner's complaint is exactly true).**
  Six classes, seven materials (`viz_fx.gd:43-50`): all five bolt-skills draw the same EMBER
  orb+trail, both throw-skills the same BONE axe, ward/rot-water/doom-sigil/dirge all the same
  MOON ring, spike/storm-peal/requiem-toll the same ICHOR shards. F2 adds a per-skill LOOK
  table read at the ONE write sites — color-first (the shipped COLOR-instance mechanism is
  the bulk-gem precedent `pickup_viz` T-M2g: `use_colors` + `vertex_color_use_as_albedo`,
  measured on the pinned 4.7.2), zero new draw classes, icons as the color source (the icons
  ARE the owner's specified reference: "correspond with the icon of the skills").
- **F-3 (the level-5 evolution and the chest evolution are ONE mechanism — the trigger
  MOVES, it does not sit beside).** The existing rule (`evolutions.gd try_evolve`) already
  owns the table, the partner-passive law, the union reserve and the in-slot write. M6
  RETIRES the chest-open trigger and RE-HOMES the same rule at the ONE pick-apply seam with
  the owner's gate (`level ≥ 5` + partner ≥ 1): `try_evolve` becomes
  `try_level_evolve` — same TABLE, same skip-conditions (GATE_T and MAX_LEVEL replaced by
  `EVO_LEVEL := 5`), same in-slot write, same `UnionSystem.reserved_for_union` skip VERBATIM.
  One mechanism, one trigger. Consequence the spec does not hide: evolved ids currently
  fire as `_:` no-ops (`weapons.gd:327-330`) — a boosted evolved skill (the owner's "big
  boost in damage, area and functionality") REQUIRES the evolved behaviour rows (§3.3). And
  the union collision is real (§3.4): `dirge-eternal` needs censer-of-hours + rot-water at
  MAX 8, but both are level-5 evolution bases with a shared partner (loadstone). The shipped
  reserve function is the reuse answer (§3.4), not a new one.
- **F-4 (the short text and the descriptions ALREADY ship — F4 is an audit + rewrite, not a
  new UI row).** `META.desc` covers 16 weapons, `PASSIVES.desc` covers 15, and `_card()`
  renders `card.desc` unconditionally (`screens.gd:303`). What is MISSING per the owner's
  wording "what each skill DOES": several descs name the flavour, not the function (e.g.
  ward "Sears all who come close" — true — vs talon missing tick/arc numbers a player
  cannot see elsewhere), the evolved/union mechanics are invisible on cards, and F6 falsifies
  one desc outright (`doom-sigil` leaves the pool). F4 = the one-desc-source law restated +
  the per-skill replacement table (§6.1) + the Lv4→5 upgrade card naming its evolution when
  the partner is carried — all riding the SAME desc string, no second text mechanism.
- **F-5 (coins are the ONE pickup kind not magnetised).** `update_entities` calls `_magnetize`
  for gems + heals (`world.gd:403-404`); coins ride touch only. The magnet source is already
  ONE (grip line + loadstone line, `:399-402`) — "one radius source" is satisfied by adding
  the coins call, NOT a new const. Touch radius (16 px) already collects coins (`:511-515`);
  the owner's ask is the MAGNET radius including coins. Byte impact: zero RNG consumed, but
  coin positions/gold-at-time move in dump steps — declared deviation (§9).
- **F-6 (the drop is a deterministic counter, not an RNG roll — chosen FOR the byte corpus).**
  A rare `randf()` roll in `kill_enemy` would shift EVERY committed dump's RNG stream at the
  first extra draw. The kill-counter law (drop on every `SIGIL_EVERY_KILLS`-th kill) consumes
  ZERO RNG: the corpus byte-identical stays enforceable up to the pickup moment, and forks
  only where a sigil is actually picked and clears the field (each kill riding `kill_enemy`
  consumes the drop rolls). This is the honest floor: with ~2.5 k journey kills at
  `SIGIL_EVERY_KILLS = 750` the journey WILL contain sigil drops, and diverges iff a drop is
  touched — card time re-dump decides, deviation doc records (§9).
- **F-7 (the contrast complaint has a named, measurable candidate set).** Seven classes read
  `Color.WHITE` through `tint_of` (§ Code truth) — every late boss/miniboss/reaper — and the
  biome bands are gate-dark (`floor_lum ≤ 34`, `biome_readability.py:85`), so dark baked
  textures on dark ground is the exact mechanism. Fix rides the ONE tint lookup (§7), floor
  rides the EXISTING hero-vs-floor ratio law (`RATIO_MIN 2.0`, same file `:87`) per mob class
  over a per-band screenshot grid.
- **F-8 (the six statue-class statics are OWNER-PIN territory — this spec does NOT manufacture
  consent).** The standing ruling (quoted verbatim in §1.5) ratified option A "statue-class
  static". F1's procedural secondary motion is VISUAL MOTION ON TOP of the static meshes — it
  does not re-rig anything and does not re-open the ruling; whether the six statics
  ALSO get their own re-master/rig attempts is priced in §1.5 as OWNER-DECISION, with the
  fleet rig-yield law stated honestly.
- **F-9 (byte corpus: M6 is the first milestone that DELIBERATELY shifts committed dumps —
  deviation-doc-as-pin BEFORE the wave, owner-ratified).** M1–M5 all shipped on the
  byte-identical corpus law. F3 (pool-size change → offer-shuffle fork; F6 removes a pool
  weapon), F5 (coin magnet timing → gold-at-step), F6 (sigil drops/clears) and F1 (gait
  amplitude re-pin) legitimately move rows. The pattern to copy is `docs/RIG-DEVIATION-SEL-C.md`
  (the pinned-deviation doc owner-ratified "Rec", B-E8/K-E3 judges re-measuring every row):
  M6 files `docs/BYTE-DEVIATION-M6.md` FIRST (T-M6d, §9), owner-ratification rows appended
  when the owner's verbatim answer arrives, and every shift card carries the re-anchor leg
  ("journey-M6 re-anchor @HD3D_SEED=11101, N rows, per-fixture row-level diff recorded in
  the capture"). NO card closes green on a shifted corpus without the deviation doc's row for
  that channel.
- **F-10 (world.gd SCHEDULED split — TRIGGERED by M6, carried, not dodged).** The header
  says "the next card growing this file carries it" (CLEAN-CODE-AUDIT-2 §5, re-declared at
  M5 §6 because M5 stayed off it). F5+F6 grow `world.gd` ⇒ **T-M6d carries the split**: the
  drop/pickup concern (`kill_enemy` rolls + drop consts + the sigil array/touch/consume +
  `_magnetize` + `_merge_gems`) moves to NEW `godot/scripts/drops.gd` (class `Drops`, the
  rule-module convention: powerups/evolutions/union/achievements), the spawn/entity law
  stays in `world.gd`. `world.gd` keeps the call-through (`world.gd:464 kill_enemy` stays the
  ONE funnel entry — every caller unchanged, the both-sites rule of the owner law), byte law
  = the moved code is MOVED VERBATIM (zero logic edit in the split commit), the split's own
  pins ride T-M6d's ACCEPT (§5.3 M-E5).

## 1. F1 — MOVEMENT ANIMATION EVERYWHERE (T-M6r)

### 1.1 The pawn path: clips while moving, procedural bob when there is no rig (clips-only)

The survivor (and every selected character/skin) rides `hero_pawn.gd` — ONE node, ONE
`apply_selection()` (§2.1b M5), ONE `_player_mesh()` seam. M6 grows it to the ONE **skinned
consumer** in the game, promoting the pattern the capture harnesses already prove
(`skinned_capture.gd`: GLTFDocument runtime load + AnimationPlayer seek + frame-diff ≥ 2 px,
the committed S2r/M5r law):

- **`CLIP_SOURCE` const (`hero_pawn.gd` or `roster.gd` — the roster owns data ⇒ `roster.gd`
  gains the field):** per mesh file, `{clip_node, walk: "walk"}` or `null` (static).
  Rigged sources (files under `res://assets/glb/`): the 4 chars + 3 skins listed in
  `docs/RIG-DEVIATION-SEL-C.md`. **Row 0 (`player.glb`) ships STATIC at `res://` — its rigged
  twin exists ONLY at the repo-root provenance dir** (`assets/glb/player-rigged.glb`, the
  S2r rewrite). T-M6r copies `player-rigged.glb` into `godot/assets/glb/` (byte-identical
  copy + `.import` sidecar, PERMANENCE row, the T-M5s law) and row 0's PAWN VISUAL reads it;
  `Roster.CHARACTERS[0].mesh` stays the literal `"player.glb"` for every non-visual consumer
  (the art fixture heights, the seam-pin literal `test_art_integration.py:152`) — the pawn's
  visual-source read rides the SAME `CLIP_SOURCE` map, so the ONE seam keeps the choice
  ("Applying a skin = the SAME seam" law restated, no second mesh path).
- **`apply_selection()` grows the visual child, idempotently:** after the existing mesh +
  material block (kept verbatim), a single child node: rigged source → instantiate the
  imported GLB scene (`load(GLB_DIR + f)` PackedScene — the import pass ships the
  AnimationPlayer; the runtime-GLTFDocument route stays harness-side), height-normalise by
  ROOT-NODE SCALE (measured rest height / `MODEL_H_PLAYER` — `ClassMesh.measured_height`
  shape, the skinning survives because NOTHING re-frees it), hide the MeshInstance's own
  surface (`visible = false` on self's mesh draw; the child draws ⇒ draw count stays ONE at
  the pawn row, the §b law); static source → no child (the MeshInstance + the procedural
  motion of §1.3 below). The material law carries onto the child surfaces (duplicate-first,
  UNSHADED, `PLAYER_TINT`, iframes-alpha — read through the SAME `_mat`; iframes alpha writes
  route to the visible node's override — one `_mat`, §b multiplier law).
- **`_process` plays motion, zero sim-state writes:** `speed := length of the player's
  per-tick displacement / dt`; rigged → `speed > ε ⇒ anim.speed_scale =
  minf(speed / GAIT_STRIDE_M, GAIT_FREQ_MAX)` and `play("walk")`; `speed ≤ ε ⇒ pause()` +
  `seek(0)` (rest = the static-era frame, the byte story of captures). The gait constants are
  READ from `HordeViz` (one stride/freq law for the whole game — no second gait table).
  Attack clip: NOT played (stated reading, §0/F-1: the auto-fire FX is the hero's attack
  read; the `attack` clips stay capture-proven — the owner clause is "animation while
  MOVING", the attack-look clause is F2).
- **Byte law:** the pawn's `position` row (`hero_pawn.gd:94-95`) stays verbatim (sim px →
  metres off `game.player`), the child node NEVER writes sim state — capture streams move by
  design (the animation IS the feature) under the §9 declared rows; the SIM dumps cannot
  move (no sim value touched; the M5 P-E7 "counter path RNG" instrument restates this as a
  leg).

### 1.2 The MultiMesh path: real secondary motion for every creature (procedural, no rig)

Every horde class, every boss, miniboss and the reaper is drawn by `horde_viz.refresh`
(`:147-191`) — ONE transform rewrite per class per frame; the transform IS the mechanism
(DESIGN-3D §c Route A — kept, not overturned). M6 upgrades the transform law from
scissor-only to the shipped §c row + **locomotion cues**: Y-bob (step height), forward lean,
and a stride-length tie so the bob frequency IS the gait frequency (the same `f` the scissor
already computes — instances that beat as one are already phase-spread by `e.gait_p :161`,
reused). New named consts beside the old (`BOB_M`, `LEAN_RAD`, applied only while the unit
has velocity — the chase loop `update_entities :391-398` is the velocity source, read, never
written): the scissor law STAYS (the dump acceptance rows `freq ≤ 2.2 Hz / scale range ≤
0.24` pin the scissor channels; the bob/lean add their OWN pinned rows, §1.4 MV-E2, and the
gait_probe dump grows its shape under a forward-lock, the T-M3b growth precedent). The hit-
edge lunge (`:172-189`) stays verbatim. Bosses/miniboss/reaper ride the same loop
(`_sched_on_stage` untouched) — "same for all creatures" lands HERE, one loop, all 18
classes, zero new draw classes, zero GPU, deterministic (the phase law `e.gait_p =
fmod(e.x*0.017 + e.y*0.031, TAU)` is position-keyed → the same seed, the same instances, the
same transforms: the strips/s8 capture streams re-derive, they do not shift by RNG).

### 1.3 The static pawns (the six statue-class rows + row-0 pre-pin truth): procedural
secondary motion, priced options §1.5

`apply_selection` static arm: `_process` adds the SAME bob/lean family at pawn amplitude
(ONE function shared with the horde law — `Roster`-side motion consts named in `hero_pawn`,
the values OURS) so every selected character visibly walks-bobs while moving, rigged or not.
No mesh data changes, no rig, ships without GPU.

### 1.4 Files (F1)

`roster.gd` (`CLIP_SOURCE` const — data), `hero_pawn.gd` (the child-node visual + clip play +
static bob; the `_ready`/`apply_selection` idempotency law kept — re-derive rebuilds the
child, never a second), `horde_viz.gd` (the gait law grows; `_sched_on_stage`/draw law/HP
bar/blob untouched), NEW `godot/sim/motion_capture.gd` (the LIVE game: Xvfb opengl3 run,
two sample frames of a MOVING pawn + a FROZEN control — the skinned_capture frame-diff
mechanism + the pixel_lib abs-diff, the S2r floors: motion rows ≥ 2 px, frozen 0 px) +
`tools/motion_gate.py` (the committed driver riding the ONE `tools/capture_lib.py` launcher —
the roster_clip_gate pattern, the T-CC3R law), `tools/strips_gate_check.py` expectation table
re-derived for the new gait shape (T-S20 pattern: measured values move, thresholds stay, the
row's own contract wording governs), `tests/test_motion.py` NEW (source pins + dump legs),
`tests/test_skinned_clips.py` + `tools/roster_clip_gate.py` STAY byte-locked (their files did
not move — their CSVs must re-mint to the SAME bytes, a named STAY row), `tests/
test_art_integration.py` (CLIP_SOURCE existence pins: every rigged row's file has the named
animation — bpy/gltf validator read at card time, the S2r validator reused), PERMANENCE
(the player-rigged promotion row), the gait rows of the strips dump (declared §9).

### 1.5 THE TENSION ROW — the six statue-class statics (⚠ OWNER-DECISION, recommendation first)

The pin, verbatim from `docs/RIG-DEVIATION-SEL-C.md` (owner artifact MC 11440): owner
ratification verbatim **"Rec"** (2026-10-27) to the recorded recommendation — *"OPTION A —
the five rig-inference failures SHIP STATIC … (option A, statue-class static)"* (the
owner's verbatim wording; the doc's own final table is the authority — **7 rigged / 6
static**: static = char-coinhound (4-bone collapse ×2 incl. a
ratified re-master), char-tallow-seer (3-bone ×2 incl. a ratified re-master),
char-shroud-saint (9-bone single chain), char-hoard-wretch (41-bone, no leg chains),
skin-tide + skin-void (3-bone + skin-stage crash)). The law this pins (fleet rig-yield):
UniRig inference on sculpture-class meshes collapses DETERMINISTICALLY — seed-fixed 12345,
retries do not change the result (the doc's stop-clause wording); two re-masters were
ratified and both collapsed at the rig stage with GREEN meshes.

**What F1 ships for them (already decided, no consent needed):** §1.3 procedural walk-bob +
lean + the §1.2 gait law where they ever ride the MultiMesh (they don't — characters are
pawn-class) — visible motion WITHOUT any rig. This does NOT re-open option A: the meshes
stay static, nothing is re-rolled.

**The decision the spec must not manufacture:** whether M6 ALSO attempts rigged motion FOR
THE SIX (beyond procedural). Priced options:

| option | what it is | cost / odds (honest, from the ledger's own history) |
|---|---|---|
| **(a) Procedural secondary motion ONLY (RECOMMENDED)** | §1.1/§1.2/§1.3 as designed — bob/lean/sway/displacement-driven motion, NO rig, NO GPU window | zero windows; ships in T-M6r; every claim instrumented (frame-diff ≥ 2 px on a MOVING static pawn — the bob itself passes the S2r floor); honest limit: it is a walking statue, not a striding one |
| (b) Re-rig attempts | re-run UniRig on the six | **violates the fleet rig-yield law**: the collapses are deterministic + seed-fixed (the doc, per-asset); a window burns, the same 3/4/9/41-bone skeleton returns. NOT offered as viable — named so the option list is complete |
| (c) Re-MASTER + re-rig (new reference art per failure class, then the same chain) | TRELLIS re-generation with pose/silhouette re-refs (the coinhound/tallow-seer v2 lesson: a GREEN mesh does NOT survive the rig stage — both double-failed) | 6 × (~1 mesh window + 1 rig window ≈ 12 windows) + owner's mesh-reserve law (1/3 held); odds: 2/2 ratified re-masters then failed the rig stage — the failure classes (sealed robes, wings-as-arms, quadrupeds) are structural against the humanoid CMU chain. Honest read: LOW probability the humanoid-chain class ever accepts these six |
| (d) Owner scope-exempts the six AGAIN (status quo, procedural only) | no attempt, procedural motion, deviation doc row re-affirmed | zero cost; re-quotes option A with the six named; the cheapest honest landing |

**RECOMMENDATION: (a) now (it is what T-M6r ships), and (d) as the ruling on (b)/(c) — i.e.
keep the static ruling, accept procedural motion, spend no windows on sculpture-class rigs.**
Every decision row carries the recommendation per the owner's standing rule; the wave ships
(a) regardless, because (a) is required by clause 1-2 for the HERO and every rigged row
ANYWAY — the mechanism is one consumer, not a per-row fork.

### 1.6 ACCEPT (MV-E1..MV-E5; each names ONE seam + its planted red)

| # | observable | seam (the ONE existing channel) | red |
|---|---|---|---|
| MV-E1 | the LIVE game's pawn animates while moving: `motion_capture` frame-diff on the pawn bbox ≥ 2 px between two frames with input driving movement; ≤ ε px between two frames of the FROZEN (no-input) control; the same pair for one rigged char (emberwright via the `SimFunnel` opts `char` hand-in) and one static char (coinhound) — 4 motion legs + their frozen controls | the S2r frame-diff mechanism (skinned_capture pattern, committed floors) through the ONE `capture_lib` launcher, new `motion_gate.py` driver | planted: child node never plays (`speed_scale` pinned 0) ⇒ the moving legs read 0 px ⇒ RED while the frozen legs "pass" — the tell is the pair, not the row |
| MV-E2 | horde gait law rows: the journey gait dump grows per-class rows `{freq, scissor_range, bob_range, lean_range}` — scissor row STAYS the pinned `≤ 0.24 / freq ≤ 2.2`, bob/lean rows pinned to their own named caps, phase law deterministic (same seed twice ⇒ identical dump, the twice-cmp law) | the existing `gait_probe` dump leg (`horde_viz.gd:265-279`) — shape growth only | planted: bob keyed on `randf()` ⇒ the determinism twin forks ⇒ RED (the P-E7 leak instrument, restated); planted: bob keyed on `game.time` without `e.gait_p` ⇒ the phase-spread leg RED (instances beat as one) |
| MV-E3 | byte law: the SIM journey + all strict fixture channels are untouched by T-M6r (visual-only change — the pos rows read `game.player/e.x/e.y`, never the viz); strips/s8 capture dumps re-dump with the NEW gait values, expectation table re-derived T-S20-style, gate 19/19 GREEN on the fresh dump | the §9 corpus re-run pattern (`cmp` vs committed for strict; norm-compare for strips; table for s8) | planted: gait write lands in `update_entities` (sim x/y touched) ⇒ the journey pos rows RED — the both-sides pair with MV-E2 |
| MV-E4 | rig-row honesty pins: `CLIP_SOURCE` rigged rows name files whose GLB JSON carries the named animation (validator read, S2r validator reused); static rows name NO clip and the pawn takes the procedural arm; `player.glb` stays the `Roster` row-0 mesh literal AND the art fixture's player row is untouched (the seam-pin `test_art_integration.py:152` EXTENDED like M5 §2.1b, substring law kept) | the art-integration pin family + the validator | planted: `CLIP_SOURCE` names "walk" on `char-coinhound.glb` (no clip) ⇒ the validator leg RED (the drift class the row exists for) |
| MV-E5 | draw budget: pawn stays 1 draw (child OR self, never both — `visible` mutual-exclusion pinned), horde/FX draw tally unchanged (27 measured baseline; §10 re-tally row) | the `draw_count` rows (horde_viz + sim_budget leg) | planted: both pawn draws live ⇒ the pawn row reads 2 ⇒ RED |

## 2. F2 — INDIVIDUAL ATTACK LOOKS PER SKILL, keyed to the skill ICON (T-M6f)

### 2.1 Mechanism — the SKILL_FX table, color-first, at the ONE write sites

New const `SKILL_FX` (`viz_fx.gd`, data in the file that consumes it — the §i pattern): per
weapon id (15 after F6 + the 10 evolved + 2 union ids — every fireable id) `{color, scale,
trail, ring_band}`. Colors are SAMPLED from the shipped icon PNGs (`icon-<id>.png` — the
owner's stated reference) at card time with the sampling row printed into the capture
(centre-weighted mean of the icon's dominant non-bg pixel, OUR method, the values pinned in
the table); no new assets, no GPU. The write sites already carry the firing weapon in hand
(`_fire(w, …)`): each append dict gains `wid: String` (additive field, arrays' counts/caps
untouched — §10 re-tally proves the sim caps are family-sums of the SAME levels; evolved
ids add their own term through `EvolutionSystem.effect`'s family map, §3.3, so the cap
family of the evolved weapon is its BASE family — the render cap table grows its per-id term
in the same commit, the both-sites rule: `sim_combat.caps` mirrors it).
- `_write_orbs/_write_trails/_write_throws/_write_rings/_write_bursts` switch their MMs to
  `USE_PER_INSTANCE_COLORS` (the shipped bulk-gem mechanism — `use_colors` +
  `vertex_color_use_as_albedo` on the pinned 4.7.2, the T-M2g finding restated) and color
  each instance from `SKILL_FX[item.wid]`; the material's `albedo_color` becomes WHITE ×
  the existing per-class alpha law (the alpha fade rows stay verbatim — they are the v1
  parity terms). Constant-color classes with the alpha law = the SAME visual for any build
  carrying ONE skill per family (the byte story: the default 2D-fx era corpora do not read
  pixels; the strips/visual captures RE-DERIVE, §9).
- `scale` rides the existing instance scale (the orb `r` is sim truth — the LOOK scale is
  the render-only multiplier on the transform, NOT the sim radius; the ward/spike
  sim-truth law (`:211-219` "a larger visible ring would LIE") holds: area LOOK changes ride
  the F3 area boost ONLY where the sim area actually grows, declared at each evolved row).
- `ring_band` gives each ring-class skill its own annulus inner-ratio row (the ward-band
  mechanism `:219` extended from per-level to per-skill, the mesh cache keyed wid×level).
- **Flash rows for evolutions ("new look" + "big boost visuals"):** evolved ids ride
  `SKILL_FX` rows with `scale+trail` and a second ring pulse via the EXISTING rings class
  (counted in the existing `rings.size()` cap read `:207` — `mini(size,1)` keeps the ONE
  draw; the evolved flash IS the ring, stated) — zero new draw classes.

### 2.2 Files (F2)

`viz_fx.gd` (SKILL_FX + the five writer sites + the color-format switch), `weapons.gd`
(`wid` stamped at every append — a T-M6p→T-M6f serial edge, the file is shared; stamp
lines are additive dict fields), `sim_combat.gd` caps mirror (both-sites rule),
`tools/strips_gate_check.py` + the strips dump (per-family color values move; expectation
table re-derived measured-not-guessed, T-S20 verbatim), NEW `tests/test_skill_fx.py` (the
table pin: every fireable id present, colors equal the capture-time sampled constants,
`icon-<id>.png` exists for every row id — the §j law re-armed for the FX family),
`godot/sim/upgrades_visual_capture.gd` (the existing per-family visual probe gains per-SKILL
windows — the ONE probe harness extended, its palette method DEFENDED per audit-2 stays
unchanged).

### 2.3 ACCEPT (FX-E1..FX-E4)

| # | observable | seam | red |
|---|---|---|---|
| FX-E1 | per-skill look: two bolt-skills fired in the same sample frame (ember + dart-loop) produce ≥ 2 distinct instance colors ≥ Δ-channel apart (the table pins the pairs); the strips/visual probe windows show per-skill palette rows where master showed one shared EMBER row | the upgrades_visual probe's palette method (extended windows) + the `fx` dump counts UNTOUCHED (the RED/both-sides pair) | planted: two ids share a color ⇒ the distinctness leg RED; planted: writer ignores `wid` ⇒ every color = the family default ⇒ RED while every sim leg stays GREEN — the visual-dead class instrumented |
| FX-E2 | table pin: `SKILL_FX` covers every fireable id (15 weapons + 10 evolved + 2 unions + the base-fallback), `icon-<id>.png` assert for every row, sampled constants equal the capture-printed values (the drift class), NO icon file added (reuse law) | the pytest table pin + `ResourceLoader.exists` | planted: a new id appended without a row ⇒ pin RED; planted: hand-typed color drifts from the sampled value ⇒ value-compare RED |
| FX-E3 | caps/budget: the §i family caps re-derive byte-equal for the family-sum counts (the `fx_caps` journey row stays 0 violations), draws row unchanged 27→27 (§10), no new draw class | the existing `fx_caps` + `draws` dump rows + sim_budget | planted: per-id cap replaces the family sum ⇒ the 600-sample cap row RED |
| FX-E4 | evolved look leg: an evolved weapon's fire (T-M6p's §3.3 behaviour, declared-pin construction the sim_boss way) paints its own SKILL_FX color + the flash ring (counted, never a second ring draw) | the rings `mini(…,1)` cap row + the visual probe window | planted: flash adds a 2nd MM ⇒ live_draws RED |

## 3. F3 — PASSIVES CONNECT TO SKILLS; THE LEVEL-5 EVOLUTION (T-M6p)

### 3.1 The rule (ONE mechanism — the trigger MOVES)

`evolutions.gd` becomes (replace-not-delete IN the same file, the same class_name, the same
TABLE):
- `TABLE` rows grow `{partner, evo}` + **`{at: 5, dmg: 1.6, area: 1.35, cd: 0.75, feat: [...]}`**
  (OUR boost numbers, one row per base weapon, pinned; `feat` = named flags from the SHIPPED
  flag set — `pierce`/`bounce`/`ret`/extra-target — the "functionality" clause rides EXISTING
  projectile flags, never a new one; the per-row feat picks are §3.2's table).
- `EVO_LEVEL := 5` replaces `GATE_T` as the gate (GATE_T's retirement: re-grep — `union.gd`
  references it per its T-M2u header row; if union still reads it, the CONST stays for the
  union, the evolution gate line moves — §4.4 R6, card-time re-grep duty).
- `try_evolve` (the ONE entry, same signature shape, call site MOVED): reads `game.weapons`
  for a TABLE row with `w.level ≥ at` + `passives[partner] ≥ 1` + NOT
  `UnionSystem.reserved_for_union` (verbatim skip, §3.4) → in-slot write VERBATIM (`w.id =
  row.evo; w.cd = 0.0`) + returns the id. The `t ≥ 600` term is GONE (replaced by `at`).
- **The ONE call site: `levelup.apply_offer`, at the tail of the "upgrade" and "passive"
  arms** (the two arms that can newly satisfy the condition; the "weapon"-pick arm cannot —
  level 1 — stated). Zero RNG, zero phase change, zero snapshot field; main.gd's
  `hide_all → show_levelup` drain (`:388-393`) is untouched. `world.gd` chest-open arm
  becomes `UnionSystem.try_union(game)` ONLY (the `else try_evolve` line is retired —
  replace-not-delete, the §4.4 R5 row; chests keep union precedence + tier cards + gold — the
  M2 §B.1 three-line order survives with one line retired, stated).
- Chest rewards/`chest_rewards.gd`/`pending_levels`/`reward_kinds`: ZERO touched.

### 3.2 The evolved BEHAVIOUR (the "big boost in damage, area and functionality" — F-3's
forced consequence: evolved ids must FIRE)

`weapons.gd _fire` gains, at its head, ONE resolution line: `var eff :=
EvolutionSystem.effect(w.id)` → `{base: <family weapon id>, dmg, area, cd, feat}` (`base =
w.id` for un-evolved — the identity that keeps every existing byte: the same branch, ×1.0
multipliers, no flags); the match runs on `eff.base`; `mul`, radii/`range_px`, and `rate()`
consume `eff.dmg/eff.area/eff.cd` at the existing sites; `eff.feat` ORs onto the appended
dicts through the EXISTING flags. `_update_orbit`'s halo branch keys halo-family ids the same
way (the `:93` branch list grows through `effect().base`, one expression). Union ids ride
`effect()` identity (their behaviour already lives in the orbit branches). Every
non-evolved weapon's math is IEEE-identical (×1.0/+0.0 identity — the limit-break precedent,
the corpus can stay byte-true where it does not fork). The evolved LOOK side (icon/HUD):
rides the shipped `icon-<evo>.png` fallback (T-M1c evo icons already exist, the HUD
convention consumes them — zero new code).

### 3.3 The connective UI (owner clause 8 — passive cards show the SKILLS they affect)

- Data: `EvolutionSystem.affects_by_passive()` (ONE read over the ONE TABLE) + union.gd's
  rows (loadstone/insight chip their union too — the partner column of BOTH tables, no
  second copy). `levelup.build_pool` stamps the passive card `chips: [icon names]`;
  generic passives (ferocity/haste/ward/grip/insight — insight also partners nothing? re-grep:
  the five v1 passives have no TABLE row) get `chips: []` + their desc already names the
  global effect (stated reading: no fake chips on global passives; the ALL-skills chip set
  was weighed — noise, rejected).
- Render: `_card` grows a chip row (small TextureRects, 28 px, under the desc label — the
  ONE panel idiom, the assert-before-load §j law, `icon_path` catch-all resolves the names —
  every chip file ships since T-M1c). The Lv4→5 UPGRADE card names its evolution when the
  partner is carried: desc extended ONE clause from the table (e.g. `"Bursts under the
  densest cluster — Lv5 + Twin Runes → Rolling Thunder"`), no second text source (F-4).

### 3.4 The union collision (named, priced, reuse-answered)

`dirge-eternal` (censer-of-hours + rot-water + loadstone, both bases at MAX 8) vs the level-5
rule (both bases evolve at 5 with loadstone carried). ANSWER (recommended): the level trigger
skips a base while its union is REACHABLE — the EXISTING `UnionSystem.reserved_for_union`
predicate, verbatim, is already the shipped skip for exactly this family (its T-M2u reserve
row names rot-water/censer as exactly the double-duty pair); when the union has become
unreachable the reserve lifts (its own shipped leg `uni_reserve_lifted`) and the level-evolve
fires on the next eligible pick. Mechanically monogamous (one predicate, one table), and the
player choice reads honestly: union OR the base's evolution, never silently both — the same
law the chest-era rule already shipped, re-pinned at the new trigger.

### 3.5 Files (F3)

`evolutions.gd` (the moved trigger + grown table + `effect()` + `affects_by_passive()`),
`union.gd` (re-grep GATE_T/`reserved_for_union` — expected ZERO edits, else the R6 row),
`weapons.gd` (`effect()` head + flags OR + orbit-key — SERIAL after T-M6d/F6, same file),
`levelup.gd` (the call site + card chips + the Lv4→5 desc clause), `screens.gd` (`_card`
chip row — the ONLY screens.gd edit; reason header row counts re-worded same-commit if they
cross a band, the audit law), `world.gd` (the `else try_evolve` line retired — F6 card owns
world.gd, the line move rides T-M6d's split commit with T-M6p's semantic; the cross-card
honesty row: T-M6d moves world.gd VERBATIM, T-M6p removes the line — both rows in both
LEDGER lines), tests: `tests/test_chests_evolve.py` (the table pin moves to the level trigger
— falsified-and-replaced, equal-or-stronger: BOTH sides (before-5/no-partner do NOT evolve;
at-5+partner DO, in-slot, cd reset) + the union-reserve leg re-homed + `evo_full_*` legs
rewired to the `_pick` funnel (the `sim_funnel.wire_pick/take_first_card/decline` channels,
the shipped end-to-end shape)), `godot/sim/sim_evolve.gd` (legs grow), NEW
`tests/test_evolve_level.py` (chips + desc-clause + effect()-identity pins),
`tests/fixtures/chests-evolve-m1e.jsonl` re-mint (declared, §9 — the trigger move is exactly
the rule this fixture pins), `tests/test_unions.py` (reserve-at-new-trigger legs). The s8 A7 text row belongs to T-M6d (§4.4 R4; §10 file matrix).

### 3.6 ACCEPT (PS-E1..PS-E6)

| # | observable | seam | red |
|---|---|---|---|
| PS-E1 | level-evolution both sides (the shipped BOTH-SIDES law): `sim_evolve` legs — weapon at L4 + partner ⇒ NO evolve; L5 + partner ⇒ evolve IN-SLOT (same index, id ∈ TABLE, cd 0, slots ≤ 6); L5 WITHOUT partner ⇒ no evolve; a second TABLE weapon later ⇒ evolves on its own pick-apply (the trigger is per-pick, zero RNG — dump twins prove it) | the `_pick`-funnel end-to-end (sim_funnel wire_pick + take_first_card, the T-M1h evo_full shape) | planted: trigger on the "weapon" arm ⇒ the no-early-evolve leg RED; planted: partner check dropped ⇒ the no-partner leg RED |
| PS-E2 | the boost math, formula rows (the C-E3/B-E3 exact-formula precedent): an evolved fire dumps dmg/area/cd rows equal `base_row × table constants` EXACTLY (the sim_combat spec-channel twins), `feat` flags observable on the projectile dict (pierce leg reuses the shipped tick-through leg), and the UN-evolved twin of every formula EQUALS the shipped byte value (the zero-identity leg — the corpus's own guard) | the existing sim_combat spec channel + the effect()-identity dump row | planted: dmg 1.6 → 1.05 (a quiet nerf) ⇒ the formula row RED while the un-evolved twins stay GREEN (the both-sides attribution pair) |
| PS-E3 | chest arm law: a chest open at the OLD gate (t ≥ 600, L8, partner) performs NO evolution (the line is retired — union/tier/gold all byte-true), AND the union still holds precedence at the chest | the chests_tiers + union fixtures' existing legs (STAY pair) + the new no-evolve-at-chest dump leg | planted: the `else try_evolve` line restored ⇒ the no-evolve-at-chest leg RED + the committed evolve-at-chest era fixture differs — RED by construction |
| PS-E4 | union reserve at the new trigger: rot-water at L5 + loadstone carried + censer also carried below MAX ⇒ NO evolve (dirge reachable); union gone from reach ⇒ next eligible pick EVOLVEs (the shipped `uni_reserve_lifted` leg's twin) | union.gd's existing predicate + the union fixture channels | planted: reserve skipped at the new trigger ⇒ dirge-eternal becomes unreachable cross-time ⇒ the reserve leg RED |
| PS-E5 | connective UI: every passive card with a TABLE/union partner carries `chips` == that partner set (ids resolve via the shipped icon files, assert-before-load); no-partner passives carry `[]`; the Lv4→5 upgrade card desc names its evolution iff partner ≥ 1 | `build_pool`/`make_offer` dump (the s5 cards capture rides the same seam) + the pixel row via `dawnwell_pixel_gate` LEVELUP leg (floor 200, the existing row) | planted: chips read the wrong table key ⇒ every chip set RED; planted: chips on a global passive ⇒ the `[]` leg RED; baseline-vs-baseline RED for the pixel row (the shipped planted-fake idiom re-proven) |
| PS-E6 | byte/deviation bookkeeping: this card's channel shifts are EXACTLY the deviation-doc rows it names (offer streams via F6's pool-size change, the evolve re-mint row) — per-fixture row-level diff recorded in the capture; NOTHING else moved | the §9 re-run pattern + `docs/BYTE-DEVIATION-M6.md` rows | planted: an unregistered shift (e.g. an accidental RNG tap in `effect()`) ⇒ the un-declared channel forks ⇒ capture audit leg RED (the leak instrument F-9 names) |

## 4. F6 — RETIRE DOOM SIGIL → THE RARE RIVEN SIGIL DROP (T-M6d, second half)

### 4.1 The retirement (the named skill; grep-to-zero law)

Doom Sigil leaves the POOL; the id family RETIRES as a weapon and RE-EMERGES as the pickup
(`doom-sigil.png` art reused for the pickup — the one name family, stated, so no orphan icon
and no blank path: the §j law stays armed). The full retire ledger (replace-not-delete, same
commit, §4.4 R1–R8) — every site grepped THIS session:
`weapons.gd IDS :25` (16→15) + `META :44` + `_fire :323-326` + header comment `:8`;
`evolutions.gd TABLE :37` (10→9 rows); `tests/test_card_icons.py:37` (WEAPON_KEYS) + `:138`
(`== 32` ⇒ `== 31`); `tests/test_biome_numbers.py:249` (IDS pin 16→15);
`tests/test_levelup_caps.py:152` (below-cap set); `tests/test_roster_m1h.py:112` (the
doom `_fire` stat row — RETIRED row note at its site); `tests/test_chests_evolve.py:50,:196`;
`godot/sim/sim_combat.gd:32` (SPECS leg — the journey weapon-attribution legs 16→15);
`godot/sim/sim_evolve.gd:118` (`_leg_full_evolve("doom-sigil")` — the leg retires WITH its
table row, the honest count); `tools/s8_acceptance.py` A7 text (32→31, the M4 T-M4l R7 wording precedent —
pattern — pool kinds 15 weapons + 15 passives + 1 bonus); `tools/vm100/icons-batch-m1c.tsv`
+ `docs/PERMANENCE.md` rows KEPT (provenance is history, replace-not-delete); PARITY-ROADMAP
M1 feature-6 row + `docs/M2-SPEC`-era doc rows get the dated LANDED→SUPERSEDED-at-M6
annotation (doc-sync sweep at T-M6z grep-to-zero: the retired claim "16 weapons" must read
0 LIVE hits at tag). `icon-doom-sigil.png` + `icon-pale-moon.png` STAY (the pickup art + the
PERMANENCE ledger); `pale-moon` retires as an evolution target (its icon file stays on disk
with its provenance row, asserted ABSENT from every live table).

### 4.2 The drop (rides F5's pickup seams; §5's file law)

- **Drop law (zero RNG, F-6 finding):** `Drops.SIGIL_EVERY_KILLS := 750` (OUR value: a run at
  the ~2.5 k–26 k kill spread gets 3–35 drops, i.e. rare-but-findable; pinned + testable
  against the kill counter, no `randf`). Counter = the ONE kill funnel's own counter
  (`game.kills` at `kill_enemy` — reaper deaths already return before the counter row, so a
  reaper never advances it; boss/miniboss kills ADVANCE the counter but NEVER drop — the
  drop emits only on a non-boss, non-reaper kill landing on `kills % SIGIL_EVERY_KILLS == 0`,
  placed at the enemy's position on the NEW `sigils` array).
- **Touch/consume (the ONE funnel, 5th kind):** beside heals (`:516-520`): sigil inside the
  16 px touch ⇒ remove + CLEAR (below). No magnet call on sigils (stated reading: a screen-
  clear pickup the horde can drag to you would clear on accident — the owner's design word
  is "when picked up"; touch-only, the chest precedent's spirit).
- **The CLEAR (design decision, ⚠ OWNER-DECISION, recommendation):** clear = kill every
  non-BOSS, non-MINIBOSS, non-REAPER enemy on the field, each through the ONE `kill_enemy`
  funnel (so gems/coins/heals/chest-rolls ride — the clear pays out, the kill counters
  advance); **bosses + minibosses + the reaper SURVIVE** (recommendation). Why: the bosses
  are the encounter law (their 1.0/0.6 chest roll is the M1 drop economy's spine; a screen-
  clear that one-shots the Warden deletes the milestone's endgame moment); the reaper is the
  run's END LAW (T-M4r F-6: its contact ends the run — a pickup that kills it would fork the
  end law itself). One big ring FX (the existing rings class) marks the moment. Alternative
  offered: "kills everything" reads literal — priced: the reaper row is the run-end rule
  (would need its OWN carve anyway — the death-guard precedent `:477-478`), and bosses-to-
  one-shot trivializes three scheduled fights. If the owner rules boss-kill, the carve line
  moves (one term) and the boss chest law needs its own ruling — stated so no reader thinks
  the spec chose silently.
- **Viz:** `pickup_viz` gains the sigil MM (5→6 draws — the §10 re-tally row, ≤ plan 40
  holds): billboard quad on the SHIPPED `icon-doom-sigil.png` (the coin/gem billboard
  mechanism verbatim), DRAWS const re-pin row, assert-exists law.
- **Byte/deviation:** the drop consumes ZERO RNG; the corpus forks ONLY at a sigil pickup
  (clear ⇒ N kill-funnel RNG taps). Which committed channels touch a sigil is a card-time
  re-dump fact (the journey at seed 11101 has a counter-firing schedule; whether the moving
  sim-pawn path touches a field drop is measured, not guessed) — every moved channel lands in
  `docs/BYTE-DEVIATION-M6.md` with a row-level diff before the close (F-9 law).

### 4.3 ACCEPT (SD-E1..SD-E5)

| # | observable | seam | red |
|---|---|---|---|
| SD-E1 | pool retirement: `make_offer` never yields a doom-sigil card at ANY level state (offer-stream leg over the full pool); `len(IDS) == 15`; the 31-kind icon pin green; WEAPON-side card-icons green; journey weapon-attribution legs 15/15 | the offer funnel + the re-pinned `test_card_icons.py:138` | planted: id restored to IDS without table/meta ⇒ the 31-kind pin RED; planted: IDS row removed but `_fire` branch kept ⇒ the dead-code concern check RED (coding-discipline concern_check, the fleet walk) |
| SD-E2 | drop law determinism: a scripted kill-run dumps a sigil at EXACTLY every 750th non-boss kill (counter rows in the dump), zero drops at boss/reaper kills, ZERO extra RNG — the RNG-tap-free leg: same seed, drop-array removed from the comparison ⇒ the ENTIRE drop stream byte-identical (the corpus's own both-sides guard) | the sim drop-stream channel (the sim_boss CHEST ROLL LEG pattern verbatim) | planted: roll on `randf() < 0.001` ⇒ the tap-free leg forks ⇒ RED (the class this law exists to catch — every committed dump shifting for a drop that was never picked) |
| SD-E3 | clear both sides: picking a sigil kills every non-boss/miniboss/reaper (alive-set dump before/after; each kill rode `kill_enemy` — the gems/gold/kills deltas prove it), bosses+miniboss+reaper counts UNCHANGED, ONE ring FX counted; touch-only (a magnet-widened build never auto-clears) | the collect funnel + the alive-set dump legs | planted: the clear loop includes the reaper ⇒ the end-law twin RED (the run that should end-by-reaper doesn't); planted: the carve term dropped ⇒ the boss survives-leg RED |
| SD-E4 | viz row: the sigil draws via the ONE pickup_viz idiom, `icon-doom-sigil.png` assert-exists, draws tally row 6 (pickup family), budget row green | the existing pickup_viz rows + `draws` dump | baseline-vs-baseline pixel RED (the gate's own planted-red class re-proven on the new row); planted: second MM for the sigil ⇒ 7 draws ⇒ the tally RED |
| SD-E5 | retire-ledger completeness: `grep -rn "doom-sigil"` outside its KEEP set (the two PNGs' provenance rows, PERMANENCE/manifest history rows, this spec's own retire rows, the pickup id) returns ZERO live-code/live-table/live-test hits at close | the grep-to-zero idiom (fleet doctrine, replace-not-delete ledger rows named) | planted: one live site left (`sim_combat SPECS`) ⇒ the grep row RED (a self-example named in §12) |

### 4.4 THE RETIRE LEDGER (doom-sigil → the riven sigil drop; replace-not-delete, same
commits; the M2 feature-7 replace-not-delete suite obligations restated)

| row | site | disposition | keeper (what STAYS + its judge) |
|---|---|---|---|
| R1 | `weapons.gd` — `IDS :25` (`doom-sigil` out, 16→15), `META :44`, `_fire` branch `:323-326`, header comment `:8` | RETIRED (pool + fire law); `_fire`'s unknown-id no-op arm STAYS (unknown-id semantics unchanged) | the `_:`-arm STAY leg (`test_roster_m1h` fallback row); the 15-id IDS pin re-armed `test_biome_numbers.py:249` (equal-or-stronger) |
| R2 | `evolutions.gd TABLE :37` (`doom-sigil → pale-moon` out, 10→9) | RETIRED; `pale-moon` retires as a live evolution target | the two PNGs STAY on disk (§4.4 R8); the 9-row TABLE pin `test_chests_evolve.py:50` falsified-and-replaced at T-M6p; assert-per-row `pale-moon ∉ live tables` |
| R3 | test family: `test_card_icons.py:37` WEAPON_KEYS + `:38-39` the hyphen-safe regex rows + `:138` (`== 32` ⇒ `== 31`), `test_levelup_caps.py:152` below-cap set | FALSIFIED-AND-REPLACED (31-kind math 15 weapons + 15 passives + 1 bonus; `LIMIT_CARDS` ride the catch-all, OUTSIDE the count — the M4 P3-5 law) | the icon-coverage + provenance legs STAY (D-7: re-read the `make_offer` LIMIT arm before believing 31) |
| R4 | `tools/s8_acceptance.py` A7 text row | RE-WORDed 32→31 (M4 T-M4l R7 wording precedent — the trio named beside it) | the A7 pixel legs unchanged |
| R5 | `world.gd` chest-open arm `else EvolutionSystem.try_evolve(game)` (`:540`) | RETIRED at T-M6p (union-only; T-M6d's split moves the line VERBATIM first, T-M6p removes it) | union precedence + tier cards + `credit_gold` STAY byte-true (PS-E3's STAY pair, the chests_tiers fixtures) |
| R6 | `evolutions.gd GATE_T :21` | RETIRED as the evolution gate (replaced by `EVO_LEVEL := 5`); re-grep `union.gd` (its T-M2u header row says the rank rule READS GATE_T — "no second 600 literal") — if union still reads it, the CONST STAYS union-side and the row is annotated, not deleted | `union.gd`'s own GATE_T leg (card-time re-grep duty, expected ZERO edits) |
| R7 | sim + fixtures: `sim_combat.gd:32` SPECS leg (weapon-attribution 16→15 legs), `sim_evolve.gd:118` `_leg_full_evolve("doom-sigil")`, `tests/fixtures/chests-evolve-m1e.jsonl` | RETIRED WITH THEIR TABLE ROWS (the honest count — the leg retires because the SUBJECT retired, per the T-M1h evo_full precedent that named it); the fixture REMINTS at T-M6p (§9) | the 15-weapon attribution legs STAY green (the journey dump row re-anchors, §9); `evo_full_{bone-whip,rot-water}` twins STAY (the leg-shape's own proof it was not vacuous) |
| R8 | provenance: `tools/vm100/icons-batch-m1c.tsv` rows `:11/:21`, `docs/PERMANENCE.md` rows, `icon-doom-sigil.png`, `icon-pale-moon.png` | KEPT VERBATIM (provenance is history — replace-not-delete; batch manifests never get edited at retire time) | `icon-doom-sigil.png` gains a CONSUMER row (the sigil billboard, SD-E4 — assert-exists armed); SD-E5's grep-to-zero defines the KEEP set precisely |

## 5. F5 — THE MAGNET RADIUS INCLUDES COINS (T-M6d, first half)

### 5.1 Mechanism

ONE line at the ONE source: beside `:403-404`, `_magnetize(coins, p, magnet, dt)` — the same
`magnet` value (grip 60 × (1+0.25·grip) + loadstone 15·stack, `:399-402`): one radius, one
law, coins included. (Grip's card desc "+25% pickup radius" becomes TRUE for coins — today
it reads as a silent half-truth; the F4 table wording row restates "all pickups".)
The touch funnel already eats coins at 16 px (`:511-515`). The gem-merge law is coin-free
and stays (coins are gold, not XP). Rides T-M6d's `drops.gd` split (§0 F-10): the magnet
loop MOVES with the pickup concern, call-through unchanged at `update_entities`.

### 5.2 Deviation (the F-5 finding, stated before the wave)

Zero RNG consumed; what moves: coin positions at dump-step time (magnet pull begins earlier)
⇒ any committed channel whose rows carry gold-at-time or coin rows shifts where a coin was
in flight. Channel list judged at card time by re-dump + row-level diff into the deviation
doc (the journey `progress` rows are the named suspect; the fixtures are pick-recipe-driven
and mostly coin-blind — measured, not asserted).

### 5.3 ACCEPT (MG-E1..MG-E3)

| # | observable | seam | red |
|---|---|---|---|
| MG-E1 | both sides: a coin inside the magnet ring but outside touch MOVES toward the player (position delta rows, pinned pull speed 220 px/s the shipped `_magnetize` law) and a coin inside the grip-scaled ring at grip-2 reads a WIDER ring than grip-0 (the passive actually does what its card says); a coin OUTSIDE the ring is static | the sim drop/pickup stream (a new small leg in the T-M6d sim channel, the sim_boss DECLARED-pin shape) | planted: the call added for a kind already magnetised (double-pull heals) ⇒ the heals position twin RED; planted: the magnet value read from a NEW const ⇒ the one-source pin (the grip line regex, the shipped loadstone pin's family) RED |
| MG-E2 | the 16 px touch pin grows kind-set 4→5 (sigils) in the SAME commit family; the magnet-set = {gems, heals, coins} (sigils absent, the touch-only leg MG of SD-E3) | `tests/test_biome_numbers.py:144` re-pin (equal-or-stronger, the on-touch legs kept verbatim) | planted: the pin moved to 6 ⇒ the kind-set leg RED (drift class) |
| MG-E3 | the corpus: channels the deviation doc did NOT declare stay cmp-IDENTICAL; the declared ones re-anchor with row-level diffs recorded (the R1-of-bytes law) | the §9 re-run pattern | an undeclared fork ⇒ RED (the standing leak instrument) |

## 6. F4 — SHORT SKILL TEXT ON EVERY OFFER (T-M6p)

### 6.1 The reading + the table (audit, then rewrite at the ONE desc source)

The mechanism already ships (F-4 finding): `_card` renders `card.desc` for every kind
(`screens.gd:303`); `META.desc` + `PASSIVES.desc` are the two desc sources; the s8 A7 +
`test_card_icons` pins already assert every pool kind resolves an icon — M6 arms the SAME
pattern for TEXT: a pinned, non-empty, unique, ≤ 72-char desc per pool kind (a card-fitting
"short text" — the card column is 220 px wide, the 12 px label autowrap, OUR bound). The
M6 rewrite pass replaces every weapon desc with its FUNCTION line (state what it does —
shape + seeking/targeting + the class the player sees), and every passive desc keeps its
number line (`"+10% weapon damage"` style) + the F3 chips beside it. The table lands in this
spec's own commit-series at card time as the `weapons.gd META` desc column + the
`PASSIVES.desc` column rewritten in place — **the per-row descs below are the SPEC's pinned
copy (they are the bytes the pin compares)**; evolved ids need no desc (never offered — the
pool law restated), union ids carry the union row's own name/desc from union.gd (re-grep
duty: the HUD fallback already names them; if a card can ever show one, its desc rides the
same table row — stated fallback leg).

`talon` "Arc in front of you — hits everything you face" ·
`ember` "Seeking bolts — nearest foe first, more at higher Lv" ·
`cleaver` "Heavy arcing throw, one hit per landing" ·
`halo` "Cinders orbit you — tick-damage on contact" ·
`ward` "Aura at your feet — continuous tick on everything close" ·
`spike` "Ground burst under the DENSEST cluster" ·
`bone-whip` "Piercing line ahead — passes through with a tick cadence" ·
`dart-loop` "Rapid facing darts — +1 per Twin Runes" ·
`hewn-axe` "Heavy returning-free axe throw — pierces, ticking" ·
`pilgrim-cross` "Throw that curves back home" ·
`censer-of-hours` "Cross volley — 4 bolts turning with you" ·
`rot-water` "Rot ring at your feet — ticking zone" ·
`spectral-disc` "Piercing disc — bounces off the playfield edge" ·
`storm-peal` "Lightning at a RANDOM foe in the field" ·
`fire-lash` "Heavy bolt at a random foe — +1 per Twin Runes" ·
passives keep their shipped desc (they already read function-first).

### 6.2 ACCEPT (TX-E1..TX-E2)

| # | observable | seam | red |
|---|---|---|---|
| TX-E1 | text law: every pool kind (15 weapons + 15 passives + bonus + 3 limit cards) carries a NON-EMPTY, UNIQUE, ≤72-char desc — pinned over the LIVE tables; the offer dump shows the desc string on every card the player can pick | the `test_card_icons` family grows its sibling: NEW `test_card_text.py` (the same table-pin shape, replace-not-delete on A7's text row) | planted: a desc copied to two weapons ⇒ uniqueness RED; planted: an id with no desc ⇒ the coverage leg RED |
| TX-E2 | the card renders the text (pixel): the level-up window's `_center_box` crop shows the desc label rows (the S5 cards capture rides the same seam), floor 200 px vs the hidden baseline, the existing gate row idiom | the cards-capture + dawnwell_pixel_gate rows | baseline-vs-baseline RED (re-proven on the leg) |

## 7. F7 — MOB CONTRAST: EVERY CLASS FINDABLE ON ITS OWN GROUND (T-M6c)

### 7.1 The measurable floor + the fix seam

The owner's complaint has a named mechanism (§0 F-7): `tint_of` reads WHITE for the seven
boss/miniboss/reaper classes, the bands are gate-dark (`floor_lum ≤ 34`), and the hero's
readability law (`ratio ≥ 2.0`, planted-fake RED-proven) never existed for mobs. M6 extends
THE METRIC, not a new one:
- **Capture:** `godot/sim/biome_readability_capture.gd` gains a DECLARED mob-grid variant
  (`HD3D_MOB_GRID`, the s8_capture declared-variant law: a separate run, own shots dir, the
  default windows byte-invariant): for each band window of the stage's rows, one mob of
  each class the stage can spawn is placed at a FIXED position (the seed-law injection
  idiom the art/readability captures already use), the pawn elsewhere; shots per
  (band × class).
- **Gate:** `tools/biome_readability.py` gains the mob-grid leg beside the shipped three
  (`floor_lum ≤ 34 / block_px ≤ 48 / hero ratio ≥ 2.0` — the three rows untouched, new leg):
  per shot, the MOB bbox = the instance-pixel bbox (the hero-bbox mechanism — pixels differing
  from the band's own ground crop), `mob_luma` = mean luma of that bbox RECT (rect law, the
  S10 lesson restated), `mob_ratio` = mob vs annulus floor, gate `≥ 2.0` — THE SAME
  `RATIO_MIN` const (one readability law for pawn and mobs; a second floor const is the
  mechanism-monogamy violation this spec exists to catch). Planted-RED idiom kept: the gate
  runs against a planted fake dir (the shipped `--gate DIR` hook) with a dark-class copy.
- **Fix seam (measured lift, no per-mob shader zoo):** `render.gd` — the seven WHITE classes
  get real rows in the tint family (BIOME_TINTS grows, or a named `BOSS_TINTS` ride on the
  SAME `tint_of` lookup — one function, the M5 §2.3 table-shape lesson: the card names the
  table, this names the law), values MEASURED per class until the grid passes (lift-first:
  the hero's own `BONE × 3.6` unshaded-multiplier precedent, `hero_pawn.gd:31`, is the
  shipped proof that a multiplier clears the floor against these exact dark bands). Declared
  fallback if a lift cannot clear a class without wrecking its identity: the additive rim on
  the EXISTING `GLOW_ALPHAS/ENEMY_GLOW_RADII` law (render.gd:49-56 — glow radii/alphas are
  already the single source of truth; glow MM ships per §b's planned rows at card time as
  the ONE new draw if needed — budget headroom in §10). No new shading mode anywhere (the
  unshaded-read law: "the 3D port is NOT unshaded" is §b's rule FOR entities; FX stay
  additive).
- **Owner-visible row (not ours to run):** the final eyeball pass is describe-image on the
  mob-grid PNGs (orchestrator-side, the standing visual law) — this spec ships the
  MEASURABLE floor, the harness, and the fix seam; the grid shots are the artifact that
  gets seen.

### 7.2 Files (F7)

`render.gd` (tint rows — the ONLY script edit; `tint_of` stays the single lookup),
`godot/sim/biome_readability_capture.gd` (the declared `HD3D_MOB_GRID` variant — default
windows byte-invariant), `tools/biome_readability.py` (the mob-grid leg + planted-fake
pair), NEW shots dir family, `tests/` (the tint-table pins: the five-class `ENEMY_TINTS`
pin STAYS VERBATIM (the suite's own law, `render.gd:35-36` — the growth rides the OTHER
table), the grid-run gate leg), PERMANENCE untouched (no generated art).

### 7.3 ACCEPT (CT-E1..CT-E4)

| # | observable | seam | red |
|---|---|---|---|
| CT-E1 | the floor: every (band × spawnable-class) grid shot reads `mob_ratio ≥ 2.0` (the full grid: stage-1 four bands × 6 horde classes + each stage's boss/miniboss windows — the spawnable set read from `BIOMES/STAGES` rows, not typed); the planted dark copy (a copy of the shots dir with one mob lift REMOVED) FAILS the gate (rc 1, row named) | the extended readability gate + its planted-fake idiom | planted: revert one class to WHITE ⇒ its rows RED; planted: floor lowered to 1.5 to "pass" ⇒ the planted-fake row goes GREEN ⇒ the gate-integrity leg RED (a gate that never fails is not a gate — fleet law) |
| CT-E2 | the three shipped readability rows byte-INARIANT (the pawn + band windows unchanged — the lift table's identity rows read 1.0× where nothing moved) AND the default capture dir byte-invariant (the declared-variant law, s8 precedent) | the shipped gate legs re-run on the default dir | planted: a lift applied to the pawn ⇒ its row moves ⇒ the byte-invariant leg RED |
| CT-E3 | one-lookup law: `tint_of` is the only class-color read site (grep: horde material + any new glow read it; zero second `albedo_color = <class literal>` sites), `ENEMY_TINTS` still exactly five classic rows | the grep/pin family | planted: a per-class material color literal in `horde_viz._make_class` ⇒ the one-lookup grep RED |
| CT-E4 | (only if the glow fallback fires) the glow MM rides the §b radii/alphas consts verbatim and the draw row re-pins 27→28 with the §10 budget row (not the §b ≤33 pickup budget — named correctly) | the `draws` dump + the sim_budget leg | planted: glow radii typed at the draw site ⇒ the single-source pin RED |

## 8. VERSION DECISION (⚠ OWNER-DECISION — recommendation first)

The version law (`docs/PARITY-ROADMAP.md` — "major = a new player-navigated UI surface (M3
stage select → v2.0.0)"; M5 read the same law to v3.0.0 on TWO new surfaces). **M6 adds NO
new player-navigated surface**: the level-up cards GROW IN PLACE (chips + text — same
overlay), the sigil is an in-game pickup entity, the evolution is run state, contrast is
pixels. **RECOMMENDATION: v3.1.0 (MINOR)** — the law's literal trigger does not fire, and
calling this v4.0.0 on vibes dilutes the law the roadmap wrote. Honest counter recorded for
the owner (he counts what the game IS): M6 REPLACES a core mechanic (chest-evolution →
level-5 evolution), RETIRES a weapon id from the pool, and adds the screen-clear drop — a
ruleset change, not just polish. If the owner rules MAJOR anyway (v4.0.0), the only build
difference is the tag + notes header — every card, row and gate reads the same; the spec
ships v3.1.0 as the default reading and names this row so the ruling exists before T-M6z
tags (release-trio law: notes are committed AT the tag, the version is settled BEFORE it).

## 9. THE BYTE-ANCHOR LAW — the re-anchor ledger (M6's honest break; deviation doc FIRST)

**The law (restated from the M5 §7 corpus with the M6 amendment).** M1–M5 shipped byte-
identical: journey-5020 @`HD3D_SEED=11101` (`sim_headless.gd:104`) + the strict-class
fixtures (`test_characters.py:7-8` names the corpus) + strips (modulo-norm) + s8 (row-by-
row table) — falsified only by the FALSIFICATION PROTOCOL. **M6 legitimately shifts committed
channels by DESIGN** (pool math §4.4 R1, the trigger move F3, coin magnet F5, sigil drops
F6, the gait/colour visual law F1/F2). The amendment, one paragraph, binding on every M6
card: a shift CLOSES green only against a ROW of `docs/BYTE-DEVIATION-M6.md`; an unregistered
shift is a FAIL, exactly as an unexplained byte moved in M1–M5. The instrument: each card's
capture records the per-channel before/after digest + a row-level diff for the shifted
channels, and the standing leak check re-runs the WHOLE corpus — channels the doc does not
name must still `cmp` identical.

**The precedent this copies (named per the brief):** `docs/RIG-DEVIATION-SEL-C.md` — the
pinned-deviation artifact (per-row state + reason + owner "Rec" artifact + B-E8/K-E3 judge
re-measuring every row twice-cmp green). M6's file: **`docs/BYTE-DEVIATION-M6.md`**, T-M6d
first commit, structure per-channel: `{channel, shifting card, mechanism (one line, cites
the spec section), declared diff (row counts + sample rows), STAY rows (channels measured
unchanged), owner-ratification row (verbatim answer, pasted when it arrives)}`.

**Pre-declared channel table (honest BEFORE the wave — the brief's exact ask):**

| channel | expected | why |
|---|---|---|
| journey-5020 @11101 | **SHIFTS** | T-M6d removes a pool id ⇒ `make_offer`'s `pool.shuffle() :119` forks every offer stream (card order/descend); F5 coin-magnet moves gold-at-step rows; F6 sigil drop (zero-RNG) + any touch CLEAR forks the kill stream after that step; F3 level-evolves fire the first time the scripted build hits L5+partner (measured at card time, not asserted). Re-anchor: NEW committed journey digest @11101, row count re-pinned (the 5020 name becomes "journey-M6 N rows"), old digest archived as the deviation doc's before-row |
| `carry-caps-m1b.jsonl` | **SHIFTS** (offer-stream channels) | pool-size change forks the shuffle wherever the leg draws offers; re-anchor where the leg reads offers, STAY where it reads caps dumps — per-ROW measured diff in the doc |
| `chests-evolve-m1e.jsonl` | **REMINT** | the fixture's own subject moves (chest trigger → level trigger, table 10→9, GATE_T retired); the 9-row both-sides truth re-mints, the union/precedence rows keep their legs (PS-E3's STAY pair proves the UNtouched lines byte-true) |
| `endless-m2 / events-m4 / limit-m4 / stages-m3 / unions-m2u / gem-merge-m2g / reaper-m4` | expected **STAY** — measured | the sigil counter consumes ZERO RNG (F-6), magnet consumes ZERO, `effect()` is ×1.0 identity un-evolved, the level-evolve trigger is zero-RNG; these legs pick scripted cards, not shuffled streams — where a leg DOES read an offer stream, the F-1 fork applies and the doc row says so (card time: per-channel cmp decides, the doc records both outcomes) |
| strips dumps (`strips-m1f/stage2/stage3` + gate table) | **RE-DERIVE** | F1 gait shape + F2 per-skill colour change MEASURED values; thresholds stay, expectation table re-derived T-S20-verbatim; the gate's 19/19 legs stay GREEN on the fresh dumps (a red gate is a bug, not a deviation) |
| s8 capture tables (gameover 11104 / win 11103) | expected STAY, seeds **re-selectable** | the offer-stream fork can flip a seed's class (the M2z seed-scan lesson: "seeds 11101-11106 die t=375..467, scan in the card") — if a seed flips, the doc row names the replacement + the scan |
| `skinned-clips-s2r-framediff.csv`, `roster-clips-m5-framediff.csv` | **STAY byte-locked** | no rigged source mesh changes (F1 animates files as shipped; the `player-rigged.glb` COPY is byte-identical to its root-assets source) — STAY pair with the MV-E4 drift leg |
| `dawnwell_pixel_gate` rows | **STAY + NEW legs** | the 4/5/7/6 shipped rows byte-true (chips/text/levelup grow inside the panel boxes the baselines crop — the M5 §4.2 both-sides rule: a baseline crop that would shift gets a NEW row id beside, the char-pick-row precedent verbatim); the level-up CHIPS row is new |
| `achv-m5 / chars-m5 / skins-m5` | **STAY** | roster/skins/achievements tables untouched by M6 |

**Owner-ratification rows:** the doc's footer carries the ratification block (the rule-2
discipline): per shifted channel a one-line ask + the owner's verbatim answer pasted when
it arrives. **GATE: no M6 card whose feature shifts a channel CLOSES until its channel's
ratification row is filled** — the spec files the ask in the release notes draft and the
orchestrator presents the decision with the recommendation ("re-anchor as designed, the old
digest archived"), because shipping on unratified corpus shifts is exactly what this doc's
footer exists to make impossible.

## 10. THE WAVE PLAN — file-ownership matrix, serial/parallel, GPU rows

**Cards (roadmap-gated after the DA SHIPs; each runs the §9 corpus battery on its tree):**

| card | content | files it OWNS (matrix: a file has ONE owning card) |
|---|---|---|
| **T-M6d** (F5+F6, drops & pickups) | world.gd SCHEDULED split (drops.gd out), coin magnet, sigil counter-drop + clear + touch, retirement greps (weapon-side), `docs/BYTE-DEVIATION-M6.md` FIRST | `godot/scripts/drops.gd` NEW, `godot/scripts/world.gd`, `godot/scripts/pickup_viz.gd`, `tests/test_biome_numbers.py`, `tests/test_sigil_drop.py` NEW, `tests/test_card_icons.py`, `tests/test_levelup_caps.py`, `godot/sim/sim_combat.gd`, `docs/BYTE-DEVIATION-M6.md` NEW, `tools/s8_acceptance.py` |
| **T-M6p** (F3+F4, the connective rules) | evolution trigger move + grown table + `effect()` + union reserve at the new trigger + chest-arm line retirement + card chips + Lv4→5 desc clause + desc rewrite table | `godot/scripts/evolutions.gd`, `godot/scripts/union.gd`, `godot/scripts/weapons.gd`, `godot/scripts/levelup.gd`, `godot/scripts/screens.gd`, `godot/scripts/roster_select.gd` (re-pin reads only — owner if it moves), `godot/sim/sim_evolve.gd`, `tests/test_chests_evolve.py`, `tests/test_evolve_level.py` NEW, `tests/test_card_text.py` NEW, `tests/test_unions.py`, `tests/fixtures/chests-evolve-m1e.jsonl` re-mint |
| **T-M6f** (F2, the per-skill FX) | `SKILL_FX` + color-instance switch + `wid` stamps + evolved look/flash + visual-probe windows | `godot/scripts/viz_fx.gd`, `tools/strips_gate_check.py` (+ expectation table — F1's gait rows re-derive HERE too: the table is this card's), `godot/sim/upgrades_visual_capture.gd` (grows), `tests/test_skill_fx.py` NEW, strips fixture re-mint |
| **T-M6r** (F1, motion) | pawn skinned consumer + clip play + static bob, horde gait law (bob+lean), `CLIP_SOURCE`, motion capture/gate, the `player-rigged.glb` promotion copy | `godot/scripts/hero_pawn.gd`, `godot/scripts/horde_viz.gd`, `godot/scripts/roster.gd` (CLIP_SOURCE const), `godot/sim/motion_capture.gd` NEW, `tools/motion_gate.py` NEW, `tests/test_motion.py` NEW, `godot/assets/glb/player-rigged.glb` (+`.import`) COPY, `docs/PERMANENCE.md`, `tests/test_art_integration.py`, `tests/test_skinned_clips.py` (STAY leg grows), `tools/roster_clip_gate.py` (STAY) |
| **T-M6c** (F7, contrast) | tint rows + mob-grid capture leg + gate leg + planted pair | `godot/scripts/render.gd`, `godot/sim/biome_readability_capture.gd`, `tools/biome_readability.py`, its `tests/` pins |
| **T-M6z** (acceptance) | full §9 re-run on the re-anchored corpus, deviation-doc ratification rows filled (owner answers pasted), release trio per the GitHub-Release doctrine (committed notes artifact `docs/RELEASE-v3.1.0.md` with the not-shipped honesty rows + the RATIFICATION rows, README truthful AT the tag, doc-sync grep-to-zero on "16 weapons"/"chest evolution"/"doom sigil is a skill"), version tag per §8's ruling | `LEDGER.md`, `README.md`, `docs/RELEASE-v3.1.0.md`, `docs/PARITY-ROADMAP.md`, `docs/BYTE-DEVIATION-M6.md` (footer) |

**Serial edges (shared file or shared truth; ordering DECLARED, never inferred):**
T-M6r ∥ T-M6c ∥ T-M6d may all start in parallel (disjoint file sets — verified pairwise
above: hero_pawn/horde_viz/roster ∩ render ∩ world/drops/pickup = ∅).
T-M6p follows T-M6d (weapons.gd pool math must be 15 before the table rewrite; world.gd's
chest-arm line lives INSIDE T-M6d's split — T-M6p removes it after the move landed, the
§3.1 cross-card honesty row). T-M6f follows BOTH T-M6p (evolved-id SKILL_FX rows need the
§3.2 table) and T-M6r (the strips expectation table is ONE file: F1's gait re-derive and
F2's colour re-derive land in the SAME table edit, owning card T-M6f, with T-M6r's capture
as its input — the strips dump is re-minted ONCE). T-M6z last, serial.
**GPU / vm100 rows:** T-M6 v1 ships **zero GPU art** — colors sample shipped icons, the
`player-rigged.glb` promotion is a file copy, contrast is a multiplier, F7 glow (fallback)
is code. The conditional asset card **T-M6a-SKILLART** (per-skill FX prop meshes / mob rim
texture cards) exists ONLY if the owner rules against color-first (§12 D-6) — its earliest
window: AFTER the vm100 backup window clears (owner's backup; today's brief: "builds later,
not you") + the windows-closed law (drain_barrier, trap-close rc=0, llama-swap serving
verified at every close, single-row windows). No M6 build card waits on it by default.
**Clean-code cycle after GA (owner doctrine, named here so T-M6z files it):**
**T-M6q-AUDIT** (findings-only: the EXISTING gate-instrument walk over the tag tree —
audit-3's shape: LOC bands + header-reason lines + both-sides dupes + vacuity audit) then
**T-M6q-REFACTOR** (byte corpus unchanged, full suite green, zero behavior change) — BEFORE
any M7-SPEC files (no next-milestone spec on a dirty base). `world.gd` enters M6 already
SCHEDULED (F-10) — the audit verifies it SHIPPED, not just planned.

## 11. WHAT M6 IS NOT (exclusions the DA should hold me to)

- NOT a re-rig milestone: zero UniRig attempts, zero mesh windows (§1.5's ruling stands; the
  procedural arm ships without any of them). If the owner rules option (c) in §1.5, that is
  a SEPARATE card filed later with its own windows, not this wave.
- NOT new weapon ids or new effect classes (15 weapons after the retirement; SIX classes +
  per-skill looks INSIDE them; the `_cap` family math re-derives, no cap becomes per-id
  alone — FX-E3).
- NOT new save fields, NOT Contract B / `snapshot_json` growth (evolution/sigil are run-
  internal state like chests/gems; the frozen 12-field law holds; NO version bump on the
  save file).
- NOT a new overlay: chips + text ride the EXISTING level-up card panel (the §5.3 "no
  new overlay" law restated; the panel count stays seven).
- NOT a new pickup mechanism beyond the sigil: one array, one touch arm, one viz MM; the
  magnet law GROWS (coins), it is not re-invented (one `magnet` value, one `_magnetize`).
- NOT a shader rewrite: contrast is the shipped tint-multiplier + (fallback) the planned
  glow rows; no per-mob materials, no post-processing.
- NOT GPU art in v1 (§10); NOT an icon batch (every chip/FX color reuses shipped files — the
  reuse row; `icon-doom-sigil.png` RETIRES from the pool but STAYS as the pickup billboard,
  so even the retirement adds zero files and deletes zero files).
- NOT touching: `sim_funnel.gd` (channels reused as-is), `save.gd`, `achievements*.gd`,
  `chest_rewards.gd`, the roster/skins tables (no new chars this milestone), the stage
  tables, the event law, `main.gd` beyond NOTHING (main is untouched in every card above —
  stated loudly: the pick drain, the phase law, `_pick` ride the shipped seams unchanged).

## 12. DA PRE-EMPTION BRIEF (attack here)

- **D-1 byte doctrine break (§9):** the fleet's strongest invariant is deliberately bent.
  Attack: "the deviation doc is consent theater; a card will re-anchor first and file the
  doc after." Defense: T-M6d commits the doc FIRST (its own ACCEPT row), and the leak check
  (undeclared channel moved ⇒ RED) runs on EVERY M6 card's tree, not just T-M6z. If the DA
  finds a cheaper way to keep F5 (zero-RNG magnet) byte-clean than declaring the gold-at-
  step rows, take it — the doc row is a floor, not a wish.
- **D-2 mechanism-monogamy at F3 (§3.1):** "you MOVED a trigger — is a retired chest
  trigger + a new level trigger one mechanism or two?" Answer: one TABLE, one entry fn, one
  in-slot write, one skip-predicate; the chest-open call site loses a line (R5). The honest
  price named up front: `chests-evolve-m1e.jsonl` REMINTS (the fixture's subject moved) +
  `test_chests_evolve`'s table pin falsifies-and-replaces. Attack the reserve answer (§3.4)
  hardest: `reserved_for_union` was written for the chest gate; re-derive its predicate
  against the level trigger at card time — if it skips when the union is DEAD-but-
  partner-carried, the loadstone partner both evolves nothing AND unions nothing = the
  dead-loadstone trap; the spec's claim is the reserve LIFTS when the union is unreachable
  (its shipped `uni_reserve_lifted` leg is the twin PS-E4 runs) — verify the predicate,
  don't trust the paragraph.
- **D-3 the clear scope (§4.2):** "kills everything on screen" per the owner vs the boss/
  reaper carve. The carve is an OWNER-DECISION row with a priced alternative — the spec does
  not choose silently; the reaper carve cites the run-end law (T-M4r F-6), the boss carve
  cites the chest economy. A DA ruling the bosses die forces its own follow-up ruling on
  the chest law — priced in §4.2.
- **D-4 the zero-RNG drop (§0 F-6):** "every 750th kill is not 'rare like coins/exp'."
  Honest: it is rare ON AVERAGE (3–35 per run at the kill spread), deterministic — the law
  chosen BECAUSE an `randf` roll shifts the entire committed corpus at the first draw for a
  drop that may never be touched. Both-sides leg SD-E2 proves the tap-free property. If the
  DA wants true randomness, the cost is one extra deviation-doc paragraph — the doc already
  exists; the mechanism-monogamy answer is that RNG rarity is the SHIPPED law (chest rolls)
  and the tap-free counter is the deviation — argue the trade, not the vibe.
- **D-5 the `player.glb` row-0 swap (§1.1):** the pawn VISUAL changes for the DEFAULT hero
  (byte law F-2's spirit: default identity). The M5-P1-1-era pins already survived a
  guarded-seam swap (T-M5c's substring pin extension, DA-SHIPped) — MV-E4 extends the same
  pin family; the art fixture's player row (height 1.67 m) is proven untouched (the
  promotion copy is byte-identical source, the Roster literal stays). The visual change IS
  the owner's clause 1; a capture re-baseline is declared, a sim-byte change is not.
- **D-6 color-first (§2):** "five bolt-skills in five colors is not 'individual looks'."
  Correct — it is the honest floor, keyed to the icons AS the owner asked; shape variance
  costs a draw per new mesh class against the §b budget (headroom: plan 40 / hard 60 /
  today 27, one new class fits, five don't ship without the T-M6a conversation). The
  visual-probe per-skill rows (FX-E1) are the falsifiable artifact — if the grid says the
  skills still read same-y, that IS the T-M6a filing trigger, pre-named.
- **D-7 the 31-kind math (§4.1):** 15 weapons + 15 passives + 1 bonus = 31 (the pin
  `test_card_icons.py:138` falsified-and-replaced; limit cards ride the catch-all, the M4
  P3-5 law keeps them OUT of the count — re-read `make_offer`'s LIMIT_CARDS arm before
  believing 31; the DA c2 precedent F-13 named this exact drift class).
- **D-8 every gate proves it can go red (fleet law):** named planted-reds exist for EVERY
  ACCEPT row in this spec (MV 5, PS 6, SD 5, MG 3, TX 2, FX 4, CT 4 = 29 rows); the pixel
  legs carry the baseline-vs-baseline RED idiom (the shipped planted-fake idiom), the corpus legs carry the planted-
  fork leak check, the motion legs carry the frozen-control pair.
- **D-9 §1.5 consent discipline:** the spec ships procedural motion for the statics (clause
  1-2 duty, no ruling needed — it is visual motion, not a re-rig) and prices the re-rig as
  OWNER-DECISION with the rig-yield law + the 2/2 re-master-failed history honestly stated.
  If the DA reads the §1.3 arm as smuggling option B back in, the rebuttal is the rig-yield
  quote: the meshes stay static; only transforms move.

## SELF-DA CHECKLIST (what the author ran before filing)

- Every file:line in the Code truth re-grepped THIS session at `aca4ea8` (the pruning this
  doc cites is the read-tool's own, none of the citations came from memory; the two
  header-comment line-count claims carry their measured deltas).
- Mechanism-monogamy per feature: F1 one consumer + one gait law; F2 one table at the
  shipped writers + the shipped COLOR-instance mechanism (no new draw class v1); F3 one
  TABLE, one entry, one call site, one reserve predicate; F4 one desc field (audit +
  rewrite, no new render path); F5 one magnet value + one call added; F6 zero RNG + one
  funnel + the shipped icon; F7 one tint lookup + one ratio const.
- Replace-not-delete ledgers written for every retirement (§4.4 R1–R8).
- Both-sides tests written for every rule row (the shipped C-E3/PS-*/SD-E2/CT-E1 pattern).
- Byte anchors + the deviation amendment + the ratification gate BEFORE the wave (§9).
- Decision rows each carry a RECOMMENDATION (§1.5 a, §4.2 bosses/reapers survive, §8 v3.1.0).
- Known limit disclosed up front: the clips shipped in M5 were never consumed by the game;
  the spec says so in the first finding instead of letting the owner discover it at GA.

## DA GATE

This doc ships to `docs/M6-SPEC.md` for the devils-advocate gate (fleet law: roadmap-gated
build cards file ONLY after the DA SHIPs it; the DA doc lands as `docs/M6-SPEC-DA.md` beside
it, immutable; this spec then revises in place as REV 2 with the §12-style fold ledger —
M2/M3/M4/M5 precedent). After DA SHIP + owner ruling on §1.5/§4.2/§8 + the deviation-doc
ratifications: T-M6d ∥ T-M6r ∥ T-M6c open; T-M6p → T-M6f → T-M6z serial behind them.