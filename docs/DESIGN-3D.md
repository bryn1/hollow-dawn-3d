# DESIGN-3D — Hollow Dawn 3D remake (MC 11095, T-P2-2; cycle 3 — final DA-gate rework)

File-level design for the 3D port of v1 `vampire_survivor` (Hollow Dawn). Owner ruling (verbatim):
*"a 3d remake. Same type of viduals, top down, but with chatacter animations, movements. 3090 only
with best possible model doing the word regardless of time taken."* Ground rule: **the data layer is
a verbatim port of v1's numbers** — the v1 acceptance suite must run unchanged against this repo's
`godot/scripts/` (§d). Art is generated ONLY on the fleet 3090 via the MIT stack pinned in v1
`docs/RESEARCH-3D-3090.md` (TRELLIS.2 → UniRig → mocap/procedural; Hunyuan EXCLUDED, EU license).
**Citations:** `path:line` at v1 master **`562e0a1`** — `godot/`, `tests/`, `server/`, `static/` are
byte-identical to the commit cycle 1 pinned (`git diff --name-only aae77d6..562e0a1` → only
LEDGER/README/ARCHITECTURE; VERIFIED this session); EXCEPT `docs/ARCHITECTURE.md`, whose cited
content exists only since its rewrite **`5dc7679`** (57-line file at `aae77d6` — cycle-1 pin was
false for its 4 cites; the 217-line rewrite is the cited content, identical at `562e0a1`).
Cycle-2 applied `DA-verdict-c2.md` (Route A rebuilt, API names binary-VERIFIED); cycle-3 over-cycle
applies `DA-verdict-c3.md`: ONE p2p convention declared (F-1) + gait swing widened, attack
precondition (F-2), wight rest exemption (F-3), conftest cite fixed (F-4). Route A SURVIVES.

## (a) SCENE — top-down Node3D world
- **Camera:** one `Camera3D` on a rig node that follows the player. **Projection = Orthographic**
  (perspective rejected: v1 entities are size-pinned regardless of distance, `render.gd:10`).
  **VERIFIED on the pinned binary `Godot_v4.7.2-stable` (`--doctool` + ClassDB probe, this session):
  `projection = Camera3D.PROJECTION_ORTHOGONAL`, `size = 30.0`, `near`, `far` — `orthographic_size`
  does NOT exist, withdrawn.** `size = 30.0 m` vertical at the 720 px viewport (`project.godot:14-15`)
  ⇒ ground scale **S = 720/30 = 24 px/m**; horizontal span 30·(1280/720) = **53.3 m**.
- **Pitch:** camera pitched **20° off straight-down** (70° below horizontal). Honest anisotropy note
  (P2-2): ortho tilt shrinks camera-forward ground distances by cos 20° = **0.94** (≤ 6 %, accepted);
  a 0° rig is isotropic but hides ALL vertical motion. Visible ground depth = 30/cos 20° = **31.9 m**,
  field ≈ **53.3 × 31.9 m** ≈ v1's 1280×720. Camera at distance 40 m ⇒ offset `Vector3(0, 37.6, 13.7)`
  from the player, `near 0.5 / far 90` (brackets the 5.4 m boss + glow; fixes cycle-1's dangling ref).
- **Entity sizes DERIVED from v1's size table** (`render.gd:10`, SIZES: player 40, enemy 34, boss
  128 px): build target = **size_px / S** ⇒ player **1.67 m** (build 1.7), every non-boss enemy
  **1.42 m** (build 1.45), boss **5.33 m** (build 5.4). Readability parity then holds **by
  construction** — cycle-1's 1.0/0.85/3.2 m sizes (≈ 20 px enemy vs v1's 34) are withdrawn.
- **Ground:** one `MeshInstance3D` quad (80×60 m, re-centred on the camera) + `shaders/ground.gdshader`
  with `UV = world_xz / 42.7` (tile = v1's 1024 px ÷ S = **42.7 m**, repeat ≈ 1.25×0.75 over the
  field) — world-locked exactly like v1's grid-snap tiled draw (`render.gd:215-222`). Band =
  `biome_at(t)` (`render.gd:80-85`) → `albedo_texture` swap; the 4 v1 tiles carried byte-identical;
  band table + t_starts ported verbatim (`render.gd:68-77`, §d).
- **Collision = 2D on the XZ plane (no full 3D physics):** v1 sim `(x,y)` → Godot `(x, 0, y)`; every
  v1 hit-check is already a distance test (`weapons.gd:82-100`, `main.gd:122-128`, `world.gd:146`)
  with no vertical axis — parity + WASM CPU cost (threads off, `export_presets.cfg:23`; the real cost
  is the single-threaded WASM tick, NOT the renderer — cycle-1 wording fixed).
- **Spawn-ring parity (cycle-1 arithmetic fixed):** v1 `hypot(1280,720)/2 + 40 px = 774 px = 32.3 m`
  (`world.gd:59-60` ÷ S); 3D ring = `hypot(53.3, 31.9)/2 + 1.7 m = **32.7 m**` — off-screen both ways.

## (b) RENDERING BUDGET — web export is the target
gl_compatibility WASM, threads OFF (`project.godot:19`, `export_presets.cfg:23`). Budget is **per
class, never per enemy**: draw count is horde-size-independent.
- **Instancing (`godot/scripts/horde_viz.gd`):** one `MultiMeshInstance3D` per enemy class (8) +
  player + boss + gem + coin + dawnlight (the gem/coin/dawnlight + dawn-glow rows LANDED as their
  own read-only node `pickup_viz.gd`, T-S18 MC 11201, not inside horde_viz — same mechanism, one
  seam per data source); `MultiMesh.transform_array` rewritten every frame —
  position, yaw-sway, lean, squash, scale (this one mechanism IS the horde animation, §c; member
  VERIFIED on the pinned binary). Per-type tint (v1 `tint_of`, `render.gd:41-42`) = **one
  `StandardMaterial3D` per class with `albedo_color = tint_of(type)`** (both VERIFIED by ClassDB
  probe — cycle-2's `INSTANCE_COLOR` claim withdrawn; the v1 modulate mechanism maps 1:1 since every
  class is exactly one type; atlas stays one 2048² texture).
- **Tri budgets** (TRELLIS.2 `to_glb(decimation_target=…)`): swarmers (wraith/hound/crawler/cultist/
  scarab) ≤ 1500; brute/ghoul/wight ≤ 4000; player ≤ 8000 (skinned); boss ≤ 15000 (skinned).
- **Shadows:** none real-time (WASM cost; the 5.4 m boss included). **Blob shadow = ONE MultiMesh**
  (soft quad at y = 0.02) for every unit (1 draw). One `DirectionalLight3D` (moon,
  `shadow_enabled=false`) + `WorldEnvironment` ambient — mirrors v1's flat dark look + separate
  additive halos (`render.gd:44-53`).
- **Glow halos:** port v1's `HaloPass` (`render.gd:237-264`, `BLEND_MODE_ADD`) as per-class additive
  billboard MultiMeshes at the exact px→m radii: enemy (22,12)→(0.92,0.50), boss (40,24)→(1.67,1.00),
  dawn (14,8)→(0.58,0.33) (`render.gd:49-53`).
- **HP bars (P3-2 ported):** v1 draws a bar only when damaged (`render.gd:185-191`) → ONE MultiMesh
  of bar quads, per-instance `scale.x = hp/max_hp` via the instance transform, same fill rule, 1
  draw. Boss bar + name (`render.gd:194-207`) and the HUD (`hud.gd`, `layer = 5`) live on a 2D
  `CanvasLayer` — outside the 3D draw budget.
- **Numeric budget (replaces cycle-1's "≤ 45 exact", which left zero headroom):** ground 1 + enemy MM
  8 + enemy-halo MM 8 + **boss-halo MM 1 (cycle-3 P4: BOSS_GLOW_RADII `render.gd:51` is its own
  radii ⇒ its own instance set)** + blobs 1 + hp-bars 1 + gems 1 + coins 1 + dawnlight 1 + dawn-glow
  1 + player 1 + boss 1 = 26, + FX ≤ 7 (§i batched) ⇒ v1-era plan 33; the M1 re-tally
  (roadmap §2, T-M1g MC 11211: +2 miniboss class MMs + zone/chest FX reserve; measured budget
  draw row 27/60 under the WORST-CASE LOADOUT, sim_budget.gd) ⇒ **planned worst case 40, hard
  cap 60** — plan retired+replaced at `art_probe.gd` / `sim_headless.gd` / the fixture in that commit.
  **"300+" is a design-time margin, not a v1 fact** (no v1 doc measures peak alive; the spawn math —
  rate cap `min(12, …)/s` from t ≈ 508 s, `world.gd:88` — implies ≈ 1800 spawns in the last band
  alone; budget assumes ≤ 400 concurrent).

## (c) ANIMATION — ROUTE A: per-instance transform animation for the horde; real skin for player+boss
**Route declared (P1):** horde classes get **per-instance TRANSFORM gait** (MultiMesh transforms are
updatable every frame — sway/bob/lean/lunge/squash, no bones); **only player + boss** are UniRig-rigged
+ mocap-skinned. Cycle-1 split classes across both routes while rendering them as neither — gone.
- **Reconciliation vs `RESEARCH-3D-3090.md` (explicit — the cycle-1 sin):** the doc's per-class table
  (:113-114) pairs brute/ghoul/scarab with rig + **procedural** motion, and its (b) section names
  Godot procedural animation as *"the realistic answer for the non-human enemies … reserve baked
  mocap for the player/boss"* (:92-96). Route A is that prescription at transform level. **Why not
  Route B (skinned horde):** MultiMesh cannot skin (cycle-1 fact, uncontested) ⇒ every skinned enemy
  is its own draw + bone upload + `AnimationPlayer` tick: at ≤ 400 concurrent that is **≥ 400 skinned
  draws vs the ≤ 60 cap (≈ 7×)** plus 400 anim ticks on single-threaded WASM — outside the web target
  this design exists for; a skinned horde would be a desktop-only toggle, not the web product.
- **Owner DoD NOT downgraded:** v1 shipped **zero** character animation (static 34 px sprites,
  `render.gd:163-171`); Route A animates **every on-screen entity** (transform gait at the 34 px read)
  + full skeletal mocap on player/boss — strictly more "character animations, movements" than v1.
- **Skinned (player, boss "Hollow Warden"):** UniRig biped (`RESEARCH:57-66`) → retargeted mocap via
  `AnimationTree` + retarget tracks; **local motion sources (research (b)):** MDM `GuyTevet/motion-
  diffusion-model` (`:80`), T2M-GPT `Mael-zys/T2M-GPT` (`:82`), MLD arXiv 2212.04048 (`:83`). 2 draws.
- **Convention (declared ONCE; every §c px number uses it): `p2p` := (max − min) of the measured
  series over ≥ 1 full animation cycle — an amplitude is NEVER doubled (F-1: cycle-3 mixed the two
  readings on the same gate; that error class dies here). All swings state their FULL range.**
- **Mechanism per class (`horde_viz.gd`, instance transforms):**
  | classes | mechanism | parameters |
  |---|---|---|
  | wraith, crawler, cultist, moor-brute, rime-ghoul | **gait** | **scissor**: width↔depth scale alternation, FULL RANGE **1.00↔1.24** (scale channels of the instance transform) at freq `f = min(spd_m_per_s / 1.2 m stride, 2.2 Hz)` → wraith 1.91, crawler 1.22, cultist 2.08, brute 1.11, ghoul 2.08 Hz (speeds ÷ S from `world.gd:14-23`, `game_state.gd:5`); + yaw-sway ±15° (look) |
  | hound, dune-scarab | **gait, taper-capped (P2-A)** — raw 3.30 / 3.65 Hz is jitter at a 34 px read | same scissor; **yaw ±12°, f capped at 2.2 Hz** |
  | pale-wight | **drift-float — REPLACES gait** (legless mist form, `MANIFEST.md:102`; P3-A resolved, not ambiguous) | scale-breathe **0.93↔1.15** (range 0.22) over ≈ 3 s + slow yaw wander + ±0.1 m sink (wander/sink NOT gated); the breathe IS its rest state (F-3, see rest row) |
  Common: stride pulse **±0.09 m** along velocity; constant **8° forward lean** (not gated); vertical
  bob ±0.15 m (±1.2 px at the 20° pitch — decoration only, NOT the contract).
- **WALK acceptance — unsatisfiable by a frozen sliding mesh (P1-A; all px under the ONE
  convention):** dump per-instance transforms + projected **bbox WIDTH** series per class strip
  (strip recorder owns capture). Gate asserts BOTH channels: **(i) scale-channel range ≥ 0.24**
  (wight ≥ 0.22) from the dump — exact, shape-independent, unfakeable by any transform that is not
  the scissor; **(ii) projected width p2p ≥ 2 px**, instance translation normalized out. Levers:
  the scale channel for (i); for (ii) the mesh's **horizontal extent min(w,d)** (art floor: BOTH
  extents ≥ 0.5 m) through the 0.24 range ⇒ **width p2p = 0.24·min(w,d)·24 = 2.88 px at floor,
  8.35 px at 1.45** (margin 1.44×); wight breathe 0.22 ⇒ **2.64 px at floor**. Frozen slide: scale
  range 0 → (i) fails; constant width → (ii) fails — gate RED against its own failure mode (the
  crawler-8.8 px false pass excluded). P4-3 honestly, and it HELPS: frozen + yaw-sway (no scissor)
  can dance the width — recomputed p2p **0.37…≈16.6 px** (heading-swept, ±15°, plausible shape
  ratios; c3's "5.10" understated it) — why (i) is in the contract; yaw is look, never promise (the
  c1/c2 HEIGHT-lever math stays withdrawn). Dump rows: **gait freq ≤ 2.2 Hz**, **scale range ≤ 0.24**.
- **ATTACK acceptance — trigger declared (P1-B):** the verbatim sim has **no enemy attack event**
  (chase `world.gd:99-103`; player contact touches only the player's `iframes`, `main.gd:125-127`).
  **Trigger = rising edge of `e.hit_cd`**: initialised 0.0 at spawn (`world.gd:79`), set to 0.3 by
  ticked sources via `_hit(ticked=true)` — ward (`weapons.gd:147`) and halo (`:188`) are the tickers
  (`:92-95`) — decayed at `world.gd:104-105`. Each edge plays **one engagement lunge: 0.24 m forward
  + velocity-axis squash 0.85↔1.15 over 0.2 s** (bite read; scale RANGE 0.30 under the convention);
  gate = position dump shows **≥ 5 px forward excursion outside the walk envelope** (0.24·24 = 5.76
  px) **+ footprint scale range ≥ 15 %**; the boss rides its own clip. **Precondition (F-2) — the
  attack rows RUN CONDITIONED:** the A3 test build must own Ward or Halo by t ≤ 120 s (scripted
  level-up picks; owning level recorded in the snapshot row) — `hit_cd` rises ONLY via ticked `_hit`
  (talon `:113`, spike `:165`, bolts `:198`, throws `:206` never set it) ⇒ without a ticker the edge
  set is EMPTY and the rows would pass vacuously. Under it coverage is broad: ward r 80 px and halo
  r ≥ 52 px exceed the 33 px contact ring (`main.gd:122,125`). Visual-only; sim untouched.
- **No buy-and-unused rigs (P2-3 closed):** UniRig runs for **player + boss only**; brute/ghoul/
  scarab/wight ship as decimated static TRELLIS meshes animated by transforms — no GPU window or
  manual-bone-fix spent on rigs nothing consumes.
- **Rest + skinned contract:** skinned player/boss keep pose clips, frame-diff ≥ 2 px between each
  rest/walk/attack pair. The rest-stable row binds gait + skinned classes: gait freq f = spd/1.2 ⇒
  0 at rest, sway/pulse/scale are speed-driven ⇒ transforms frozen, bbox stable. **Pale-wight is
  EXEMPT (F-3):** its breathe runs on a fixed ≈ 3 s clock — it oscillates at rest BY DESIGN (that IS
  the mist idle motion, never a defect); the S2 strip acceptor (describe-image visual review) owns
  that look.

## (d) NUMBERS PORT MAP — v1 suite runs unchanged
**Mechanism:** v1's `test_game_numbers.py` reads `.gd` **source text** by file name
(`test_game_numbers.py:13,17,21-24`) under `conftest.REPO` (`conftest.py:18`). The 3D build keeps the
**same file names + constant spellings** in `godot/scripts/`; the test file is copied verbatim and
imports this repo's `tests/conftest.py` (the port/DB re-stamp §e once described rode a
v1-server harness block since DELETED at MC 11317 C2 — conftest is now the repo's own seam
home; the copied-file law itself still holds) — zero logic edits. A
consolidated `game_data.gd` is **rejected** (§h). Band/signature pins v1 never covered
(`ARCHITECTURE.md:197-200` @ `5dc7679`) land in new **`tests/test_biome_numbers.py`** (same regex style).

| v1 pinned number (source) | 3D location (identical) | test |
|---|---|---|
| WIN_TIME 900.0 (`game_state.gd:7`; 600.0 RE-PINNED by T-M1d, roadmap M1 feature 4) | `game_state.gd:7` | `test_game_numbers.py::test_win_threshold_900` |
| BOSS_AT 540.0 (`world.gd:5`) | `world.gd:5` | `::test_boss_at_540` |
| HEAL_DROP_CHANCE 0.015 / HEAL_AMOUNT 8.0 + clamp (`world.gd:6-7,158`) | same | `::test_heal_drop_chance`, `::test_heal_amount`, `::test_heal_clamp_path_exists` |
| boss Dawnlight guaranteed (`world.gd:137`) | same | `test_biome_numbers.py` |
| GATES 0/2/4/6 min (`world.gd:28`) | same | `::test_gates_minutes` |
| spawn cap `min(12,1+1.3·min)` (`world.gd:88`) | same | `::test_spawn_rate_capped_12` |
| wraith 8/55/2/1, hound 6/95/3/1, crawler 30/35/5/3, cultist 18/60/6/4 (`world.gd:14-17`) | same | `::test_enemy_base_stats_per_plan` |
| warden 3000/45/12/0 boss (`world.gd:24`) | same | `::test_enemy_base_stats_per_plan` |
| moor-brute 26/32/4/2, scarab 5/105/2/1, ghoul 18/60/5/3, wight 45/52/9/4 (`world.gd:20-23`) | same | `test_biome_numbers.py` |
| xp_need `5+4L+L²` (`game_state.gd:29`) | same | `::test_xp_curve` |
| ENEMY_TINTS exactly 5 (`render.gd:22-28`) | same (data half kept, §f) | `::test_five_enemy_tints_present` |
| BIOMES t_starts 0/150/300/450 + rosters (`render.gd:68-77`) | same (data half kept) | `test_biome_numbers.py` |
| BIOME_FLASH 3.0 (`hud.gd:12`) | same | `test_biome_numbers.py` |
| score `time·10+kills·5+level·25+gold` (`main.gd:193-194`) | same | `test_biome_numbers.py` |
| MAX_HP 100 / BASE_SPEED 140 / IFRAMES 0.5 (`game_state.gd:8,5,6`) | same | `test_biome_numbers.py` |
| pickup 16 px; contact 17/boss 55 + 16 (`world.gd:146`; `main.gd:122,125`) | same | `test_biome_numbers.py` |
| SIZES 40/34/128 px (`render.gd:10`) | same const → §a model math | `test_biome_numbers.py` (px read ≡ §c acceptance) |
| HP bar only when damaged (`render.gd:185-191`) | `horde_viz.gd` bar MM, `scale.x = hp/max` | `test_biome_numbers.py` |
| boss bar + "THE HOLLOW WARDEN" (`render.gd:194-207`) | `hud_3d.gd` CanvasLayer | screenshot |
| Dawnlight cross + glow (`render.gd:18,174-182,252-254`) | dawnlight MM + halo MM | screenshot |
| iframes: v1 is a CONSTANT alpha 0.55 while iframes > 0 (`render.gd:134-138`, modulate at `:137` — cycle-3 says what it is, no "pulse" fiction); player→player-alt at L5 | `hero_pawn.gd` material alpha 0.55 during iframes + L5 GLB swap | screenshot |
| tint_of per-type (`render.gd:22-42`) | per-class `StandardMaterial3D.albedo_color` (VERIFIED member) | `::test_five_enemy_tints_present` + screenshot |

**M1-era additions (not v1 pins, T-M1d):** `MINIBOSS_AT [[600, "hollow-knight"], [780,
"hollow-deacon"]]`, `CHEST_CHANCE_BOSS 1.0`, `CHEST_CHANCE_MINIBOSS 0.6` and `ALIVE_CAP 400`
(all in the `world.gd` constants seam, pinned by `test_boss_numbers.py` +
`test_game_numbers.py::test_alive_cap_400_pauses_the_single_spawn_loop`); miniboss stat rows
900/50/10 and 1400/40/11 (`::test_miniboss_enemy_rows`).

**M1-era additions (not v1 pins, T-M1e, MC 11209):** chest OPENING rides the ONE
`collect_pickups` 16 px touch funnel (`world.gd`); the evolution rule is the ONE entry
`EvolutionSystem.try_evolve` (`evolutions.gd`: `GATE_T 600` — our own v1 WIN_TIME, DA c1 G-1 —
plus the 10-row partner TABLE; DA c3 C-2: a SEPARATE table, never `WeaponSystem.META`); the
reward card rides the frozen `pending_levels -> _enter_levelup` seam (DA c1 A-2, enum
untouched); the chest pickup billboard (`icon-chest.png`, `CHEST_PX 28` OUR row) is
`pickup_viz`'s 5th MM slot — §b's plan note was RAISED to 40 by T-M1g's budget re-tally
(measured draw row 27/60 under the WORST-CASE LOADOUT, sim_budget.gd; the zones MM +1 the
feature-6 plan carried was NOT shipped by T-M1h — the MC 11220 dispatch ruling maps
rot-water's lingering zone onto the ward ring-tick class, NO new viz mechanism, so the +1
stays an UNCONSUMED plan-40 reserve and the measured row re-runs unchanged; the 60 hard cap
is the gate and holds);
the HUD weapon
row falls back to the `icon-<id>.png` naming convention for evolved ids. Pinned by
`test_chests_evolve.py` + the committed `chests-evolve-m1e.jsonl` dump.

**M2-era additions (not v1 pins, T-M2e/T-M2g/T-M2t/T-M2u, MC 11237-11240):** endless mode
is a `DawnWell.flags["endless"]` hand-in consumed at the ONE `_dawnwell -> start` seam
(`main.gd`), with `cycle = int(time // WIN_TIME)` as the crossing, the three capped scalars
`HP_CYC = min(1+0.75k, 6)` / `QTY_CYC = min(1+0.25k, 2)` / `DMG_CYC = min(1+0.20k, 2.5)` and
the two clamps `HP_EFFECTIVE_MULT_CAP 18` + `MAX_CONTACT_DMG 20` all in the ONE spawn/damage
seams (`world.gd`, `main.gd`), and a `best_cycle` save field (no VERSION bump); chest
`tier` is stamped at DROP from the ONE `CHEST_TIER_BY_SOURCE` map (`world.gd`) and the tier
table + weighted picker live in the ONE new rule module `chest_rewards.gd`; ground gems
merge at `GEM_MERGE_THRESHOLD 200` / `GEM_MERGE_BATCH 100` in the ONE entity update
(`world.gd`), bulk gem on the ONE gem MM (color-instance format, rev-2 P4-5); unions are the
ONE `union.gd` TABLE (`:33`, 2 rows) with ~~precedence over evolution at the ONE chest-open
funnel~~ and a cross-time reserve rule for shared bases. **M6 v3.1.0 SUPERSESSION (dated
2026-10-30, T-M6z MC 11709): the chest-open funnel is UNION-ONLY now — the evolution
trigger moved to the level-up PICK (no time term; M6-SPEC §3.1/§4.4 R5, the dated cells at
PARITY gap rows 1/2 are the truth); the `:33` cite rides M6's re-greps. This paragraph is
the M2 plan-of-record text, kept as written per the dated-review-record precedent.** §b draw budget: **0 new draw classes
in all of M2** — tiers ride the chest MM, the bulk gem the gem MM, union FX `halos`/`bursts`
/the ward ring-tick class; the measured 27 / plan 40 / hard 60 row re-ran UNCHANGED
(`sim_budget` unions leg, D-U6). Contract B (12 fields) untouched by every pillar (F-3).
Pinned by `test_endless.py` / `test_gem_merge.py` / `test_chests_tiers.py` /
`test_unions.py` + the committed `endless-m2` / `gem-merge-m2g` / `chests-tiers-m2` /
`unions-m2u` dumps.

**M3-era additions (not v1 pins, T-M3s/T-M3g/T-M3b, MC 11282-11284):** stages are the ONE
`STAGES` table (`render.gd:110` — old pin :104, re-grepped at the v2.1.0 cut; placed BELOW
`biome_at` — the slice law) read through the
ONE band mechanism `band_at(stage, t)` (`:188` — old pin :169); `biome_at` stays the stage-1 wrapper
(row identity at 0/150/300/450/900 byte-pinned). Stage + flare are run vars OUTSIDE the
frozen 12-field snapshot (Contract B zero-delta kept, A-E8 leg); the boss schedule is the
unified `schedule_spawned` latch (retire-and-replace of the two per-name latches) and the
drop site reads `CHEST_TIER_BY_SOURCE[String(enemy.type)]` — keyed, strict. Gimmicks
compose INSIDE existing ceilings: cairns ARE chests (stage-item map row, fixed coords,
zero RNG — identical-stream leg); the pressure-plate surge multiplies the spawn rate
BEFORE `minf(12.0)` so the clamp still binds (saturation leg), the flare shifts band
NAMES only. §b draw budget: **0 new draw classes in all of M3** — the plate billboard
rides the pickup MM row (MEASURED DOWN to 40 px after the 96 px first build RED the
readability block-knee), scheduled classes count in the horde draw/gait tally ONLY on the
run's stage row (stage 1 keeps the byte-pinned 13; stages 2/3 run 11); the worst-case
re-tally stays 25-27 / plan 40 / hard 60 with the stage boss + horde 400 + named 1
(`sim_budget` budget_draws + budget_stage3 legs, C-E4). Contract B (12 fields) untouched
(A-E8, stage+flare SET ⇒ snapshot absent). Pinned by `test_stages.py` /
`test_boss_numbers.py` / `test_chests_tiers.py` + the committed `stages-m3` dump (seed
11284, twice-cmp) and the byte-anchored M2 corpus (journey 5020 rows + the four M2
fixtures, A-E1 carve judged on observable rows, map row the declared re-pin).

**M4-era additions (not v1 pins, T-M4e/T-M4r/T-M4l, MC 11362-11365):** event waves are
STAGES-table DATA (the `events` column): fixed windows + fixed cones read beside the
plate loop, the surge takes `maxf(surge, EVENT_SURGE)` INSIDE the same `minf(12.0)` term
(F-4: the `ALIVE_CAP` early-return stays ABOVE the rate — no cap-bypass, declared
divergence from THEIR rule), window selection consumes ZERO randf/randi (the A-E5
identity-twin law: geometry inert on the table's `[0,TAU]` identity cone), and the two
event minibosses ride the ONE `schedule_spawned` latch as 660 entries + the ONE
`miniboss` chest literal (map stays 7 rows, F-3). The reaper is the ONE cap-branch
`elif` (endless precedence source-pinned, R9), the ONE hidden well-flag dict, and an
END law in the contact loop — NOT a damage path (F-6: the `MAX_CONTACT_DMG` table gains
no row); its `kill_enemy` death guard pays zero (B-E6). Limit-break-lite is the ONE
offer funnel: the fallback fires ONLY at exhausted-pool `kind == ""` (the two committed
bonus rows are the living probe, C-E4), three repeatable cards landing as additive
terms on THREE existing stat seams (fury/haste/intake formulas exact-pinned, C-E3;
zero-picks twin = identity exact). §b draw budget: +2 scheduled classes ride stage-2/3
runs inside the event window (sunken-prelate/stair-acolyte), the-reaper only on a
night-flag run — `sim_budget` 8 legs green at this cut (committed dump: draw total
27 ≤ plan 40 ≤ hard 60; budget_reaper worst leg alive 405 / horde 400 / named 5 /
reapers 2 / total 27 ≤ 60). The desert retone is a pixel swap at a shipped path
(`tools/tile_gate.py` is the ONE committed tile gate, luma 26–36 envelope, measured
32.9 at this cut). Contract B (12 fields) stays frozen through all three pillars (B-E5/
C-E4 snapshot-absent legs). Pinned by `test_events.py` / `test_reaper.py` /
`test_limit_break.py` + the committed `events-m4`/`reaper-m4`/`limit-m4` dumps
(per-pillar seeds = build-card ids 11362/11334/11365 — the spec's single-seed line
superseded, declared in LEDGER; each twice-cmp-identical) and the byte-anchored corpus
(journey 5020 rows + every strict fixture re-measured byte-identical at the v2.1.0 cut,
A-E1).

## (e) SERVER / LEADERBOARD — EXCLUDED: never carried into this repo (MC 11398 §4.1 honest pass, MC 11401)
This section originally read "reuse v1 verbatim" and listed the `server/` files — `server.py`
(sha `2f973d89…38ee`), `api.py`, `db.py`, `static_app.py` — as copied into this repo
byte-identical. Measured against this tree at the v2.1.0 cut: no `server/` and no `static/`
dir exist, and `git log --all -- server/` returns ZERO commits — the copy was never executed.
A claim that was never true is retired like one that died: the old claim stands named in the
previous sentence; the truth stands here. The leaderboard itself is **EXCLUDED**
(PARITY-ROADMAP row 13 — a v1-server platform feature, see §3). v1 server facts stay cited
v1-relative by this doc's declared convention (`:9`): stdlib-only Python + `/api/health` +
`/api/highscores` (`ARCHITECTURE.md:37-42` @ `5dc7679`) — v1's server is unaffected by a 3D
client, it just never moved here. The one vestige of the original plan — the v1-server harness
block inside `tests/conftest.py` — was DELETED at MC 11317 C2 (zero consumers re-proved there);
the stated-diff port re-stamps of §e (`MAIN_PORT`/`MAIN_DB` + `RESTART_PORT`/`RESTART_DB`,
cited `conftest.py:22-25` v1-relative per `:9`, F-4) died with that block — the DB-purge
collision they guarded cannot occur in this repo. `tests/conftest.py` today is this repo's own
seam home (loaders/const/block, MC 11317 C2), not a v1 copy. The test-copy law that DID
execute is `tests/test_game_numbers.py` verbatim (§c). **`test_assets_manifest.py` is dropped, stated:**
its pinned 16-PNG `EXPECTED_FILES` set + v1 PLAN path cannot hold in the 3D tree; the GLB/icon tree
gets its own manifest test at the art phase.

## (f) REPO LAYOUT + named files (file-level — P2-5 closed)
```
godot/Main.tscn                 Node3D root, scripts/main.gd (ported; renderer wiring swapped)
godot/scripts/camera_rig.gd     NEW — ortho Camera3D rig, pitch/height/follow (§a)
godot/scripts/ground.gd         NEW — biome band quad + band-swap logic (§a)
godot/shaders/ground.gdshader   NEW — world-locked tiling (§a)
godot/scripts/horde_viz.gd      NEW — per-class MultiMeshes + per-frame transform_array write (gait
                                §c) + blob-shadow MM + HP-bar MM + per-class material factory (§b)
godot/scripts/hero_pawn.gd      NEW — skinned player + boss (AnimationTree, retarget, iframes
                                alpha 0.55, L5 GLB swap; §c/§d)
godot/scripts/viz_fx.gd         NEW — halo MM passes + weapon-FX emitters (§i/§b)
godot/scripts/pickup_viz.gd     NEW (T-S18 MC 11201) — coin/gem/Dawnlight-cross billboards +
                                Dawnlight glow MM reading world.coins/gems/heals ONLY (the §b
                                gem/coin/dawnlight/dawn-glow rows finally landed; v1 sizes/glow,
                                no spawn-pop, zero gameplay change)
godot/scripts/hud_3d.gd         NEW — hud.gd ported to a CanvasLayer over 3D + boss bar (§d)
godot/scripts/render.gd         DECIDED — KEEP AS DATA MODULE ONLY: `class_name GameRenderer` +
                                BIOMES/biome_at/SIZES/ENEMY_TINTS/BIOME_TINTS/tint_of/glow consts
                                VERBATIM (world.gd:52 calls biome_at — the compile gate; the suite
                                regexes the tables), ALL Node2D `_draw*` + HaloPass bodies DELETED —
                                no ghost 2D renderer; only its tables stay cited-as-truth.
godot/scripts/{world,game_state,weapons,levelup,bridge,screens}.gd  copied VERBATIM (sim + suite
                                text-reads; screens.gd extended only by §j card icons)
godot/assets/biomes/*.png       4 v1 tiles byte-identical; godot/assets/glb/ NEW; godot/assets/icons/ NEW (§j)
tests/  conftest.py (the repo's OWN seam home since MC 11317 C2 — the §e v1-server
        re-stamp block died there; §e honest pass), test_game_numbers.py verbatim,
        test_biome_numbers.py NEW. The §e block that once listed
        test_contract_a_api.py + test_contract_a_validation.py +
        test_static_contract.py + a tree-hygiene copy test as copied never
        executed: the contract-A/server tests ride the server that never came
        (§e) and the tree-hygiene gate test never existed here (measured
        MC 11398 §4.2);
        test_assets_manifest.py dropped (§e)
server/ never carried — EXCLUDED (§e honest pass, MC 11398 §4.1); static/ export target; docs/ + .audits/ per layout v2
```
Hygiene: the fleet file law is dod_hygiene rule (h) (~250 aim / >400 needs a
`reason` line in the first 5 / >600 hard fail) — the ≤300-line gate this row once
cited (the phantom tree-hygiene test, `:19`) never shipped with the copy: no such
file exists in this repo, measured at MC 11398 §4.2; replace-not-delete, the old
claim named.

## (g) EXPORT CHAIN + releases (owner "own releases" row — P2-4 closed)
- **Web double-export** (`ARCHITECTURE.md:25-27` @ `5dc7679`): `--import`, then
  `--export-release "Web" ../static/index.html` **twice**, commit the regenerated `static/index.*`
  (first export under-produces; every v1 LEDGER row says "web export x2"). Mirror preset.0
  (`export_presets.cfg:1-38`): threads off (`:23`), `canvas_resize_mode=1`, `html/head_include` JS +
  markers vs-fix-11075/11083 (`:28`). Keep `gl_compatibility` (`project.godot:19`).
- **Windows** preset.1 (`export_presets.cfg:40-92`): `embed_pck=true`, `s3tc_bptc=true` (`:62-63`) →
  `.tmp/win/HollowDawn3D.exe` (gitignored), field-tested on VM120.
- **Releases (owner ruling verbatim, v1 `README.md:47`):** *"Go, make this its own github repo with
  its own releases"* → `gh release create v<m.m.p>` on **bryn1/hollow-dawn-3d** per accepted build,
  carrying **{web zip: index.html + .js + .wasm + .pck, `HollowDawn3D.exe`}**; filed by the seat that
  closes the build card — same flow as v1's v1.0.0/v1.1.0 (`ARCHITECTURE.md:29-31` @ `5dc7679`).

## (h) REJECTED ALTERNATIVES
- **Mixamo** — cloud + humanoid-only; violates the 3090-only ruling; cannot rig scarab/ghoul/wight
  (`RESEARCH:68-71`).
- **Route B — skinned horde** — the P1 route NOT taken: math in §c (≈ 7× the draw cap at the
  concurrency margin + per-instance ticks on single-thread WASM).
- **Full 3D physics** — no vertical axis anywhere in the sim; WASM CPU cost; a second collision
  mechanism beside v1's proven 2D one.
- **Heightmap terrain** — v1 ground is a flat tiled layer (`render.gd:215-222`); not asked for.
- **2.5D pre-rendered sprites** — not the ruling (owner asked models + animations, not flat).
- **Hunyuan3D** — EU/UK/SK license exclusion including outputs (`RESEARCH:134-142`); 29 GB > 24 GB.
- **`game_data.gd` consolidation** — breaks the suite's cross-file wiring asserts
  (`test_game_numbers.py:43-44,47-48`: WIN gate asserted in MAIN, boss gate in WORLD).
- **TRELLIS.2-only art pass (hedges restored, P3-5):** ≥ 24 GB is *"right at the ceiling"* — run
  **≤ 1024³ fp16** + `expandable_segments:True`, **expect OOM at 1536³** (`RESEARCH:33,47-49,
  152-156`); on OOM fall back **TRELLIS-v1 (16 GB) / TripoSG (8 GB)** (`RESEARCH:100-104,155-156`);
  exclusive-window batches off-peak, window never left open idle (`RESEARCH:147-151`).

## (i) WEAPON EFFECTS (3D VFX)
Six weapons from v1 (`weapons.gd:9-16` META; `_fire` `:103-188`); DAMAGE numbers port unchanged (§d) —
only the visible layer is new. All FX additive, unlit, **no shadows**, batched into MMs (the draw
column below IS the "FX ≤ 7" of §b):
| weapon (source) | 3D visible effect (v1 sim truth preserved) | draws |
|---|---|---|
| talon (`weapons.gd:108-115`: cd 0.55·0.96^(L-1), half 0.62 rad, range 90+4L px, arc life 0.15 `:115`) | ground quarter-disc glow decal + talon mesh arc, 0.15 s fade | 1 |
| ember (`weapons.gd:116-129`; **straight flight** — vx,vy fixed at fire and integrated straight, `:193-199`; META "seek" (`:11`) is HALF-true, P4-1: aimed at the nearest 1+⌊(L-1)/3⌋ foes at fire time (`_nearest`, `:117`), then flies straight — aim-at-fire, not homing; BOLT_SPEED 300 `:18`) | emissive orb MM + trail ribbon; renders a STRAIGHT shot — no homing invented | 2 |
| cleaver (`weapons.gd:130-144`, THROW_SPEED 260, ≤ 1+⌊(L-1)/4⌋) | spinning bone-axe MM on a parabolic toss (v1 lift `render.gd:155`) | 1 |
| halo (`weapons.gd:172-188`: radius 52+3L px, count 1+⌈L/3⌉ ≤ 4, ω 2.4+0.08L) | orbiting ember MM on one ring | 1 |
| ward (`weapons.gd:145-148`: cd 0.45 at `:146`; the 0.3 s tick is `e.hit_cd` at `:95` — cycle-1 cite fixed) | expanding ring-pulse decal, 0.12 s | 1 |
| spike (`weapons.gd:149-166`, r 56 px, life 0.25) | radial shard particle burst under the densest cluster | 1 |
Colours carried from v1 (MOON/EMBER/ICHOR/BONE, `render.gd:12-18`).
**T-S18 (MC 11201) — upgrades must be VISIBLE:** ward and spike are the two families whose
per-level sim quantity is DAMAGE ONLY (`weapons.gd:145-166` — tick r 80 and burst r 56 px are
level constants), so their radii stay sim-truth and the level reads as **intensity**: ward ring
band widens (annulus inner 0.82 → 0.61 at Lv8, band area ≈ ×1.9, one cached mesh per level) and
spike shard COUNT rides 8 → 20 inside this table's ≤ 20 cap. Measured per family (Lv1 vs Lv8
effect-zone pixels; halo additionally blob-counted via connected components) by
`tools/upgrades_visual_probe.py`.

## (j) UPGRADE CARDS (level-up UI) — owner DoD
Level-up stays a **2D `CanvasLayer` overlay** over the 3D world (`screens.gd:22` layer 10; cards
`:118-148`; `card-frame.png` + icon `TextureRect` `:121-139` reused). Each card carries a **skill
image from the SAME 3090 pipeline** — the fleet `imagegen` MCP tool (Qwen-Image t2i, the tool v1
itself used, `MANIFEST.md:3`; the parent brief's `/opt/imagegen` path does not exist on this host —
flagged, cycle 1) — 512×512 transparent RGBA, **style anchor = v1's sprite palette quoted verbatim**
(`MANIFEST.md:10-14`). The 12-skill set (`levelup.gd:8-14` passives + `weapons.gd:6` weapons +
`levelup.gd:40-41` bonus), icons → `godot/assets/icons/`:
| skill (source) | icon |
|---|---|
| Talon Lash / Ember Bolt / Bone Cleaver / Cinder Halo / Warding Aura / Grave Spike (`weapons.gd:10-15`) | **reuse** v1 `icon-{talon,ember,cleaver,halo,ward,spike}.png` (`MANIFEST.md:28-33`) |
| Ferocity +10 % dmg (`levelup.gd:9`) | NEW: "single crimson blood-drop gauntlet icon, centered, clean bold shape readable at very small size, no frame, no background decoration" |
| Haste +8 % speed (`levelup.gd:10`) | NEW: "single moonlit winged boot icon, faint motion lines, centered, … no frame" |
| Warding −1 dmg (`levelup.gd:11`) | NEW: "single pale moonlight shield icon with a bone boss, centered, … no frame" |
| Grip +25 % pickup radius (`levelup.gd:12`) | NEW: "single bone-hook grapple icon with ichor-green spark, centered, … no frame" |
| Insight +15 % xp (`levelup.gd:13`) | NEW: "single glowing soul-gem eye icon, ichor-green inner light, centered, … no frame" |
| Coin Cache +25 g / +10 hp (`levelup.gd:41`) | **reuse** `coin.png` (`MANIFEST.md:35`) |
The 5 NEW icons close v1's real hole (passive cards ship `icon: ""`, `levelup.gd:35`). **Fallback:**
reuse the weapon icon where one exists, else `coin.png`, else a tinted `ColorRect` (v1's never-crash
placeholder path `render.gd:170`) — a card is never blank; provenance per the imagegen contract.

---
**Open readings:** (1) the 20° pitch (re-derived from cycle-1's 30°-off-vertical; §a anisotropy note
is the honest fix) is my call within "top down", reversible; (2) icons via the `imagegen` MCP tool —
the brief's `/opt/imagegen` path is absent here; (3) Route A is reconciled in §c against
`RESEARCH:92-96,113-114`; overturning = a desktop-only skinned-horde build the owner has not asked for.
