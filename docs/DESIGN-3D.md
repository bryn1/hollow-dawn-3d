# DESIGN-3D — Hollow Dawn 3D remake (MC 11095, T-P2-2)

File-level design for the 3D port of v1 `vampire_survivor` (Hollow Dawn). Owner ruling (verbatim):
*"a 3d remake. Same type of viduals, top down, but with chatacter animations, movements. 3090 only
with best possible model doing the word regardless of time taken."* Ground rule: **the data layer is
a verbatim port of v1's numbers** — the v1 acceptance suite must run unchanged against this repo's
`godot/scripts/` (§d). Art is generated ONLY on the fleet 3090 via the MIT stack pinned in
v1 `docs/RESEARCH-3D-3090.md` (TRELLIS.2 → UniRig → mocap/procedural; Hunyuan EXCLUDED, EU license).
Citations below are `v1-file:line` into `/home/claudecode/Games/vampire_survivor` @ `aae77d6`.

## (a) SCENE — top-down Node3D world
- **Camera:** one `Camera3D` under a `Node3D` root that re-parents to the player. **Projection =
  Orthographic** (perspective rejected: breaks v1's pixel-exact field parity — a v1 enemy is a fixed
  34 px regardless of distance, `render.gd:10`). `orthographic_size = 30.0 m` vertical ⇒ at the 720 px
  viewport (`project.godot:15`) **scale S = 720/30 = 24 px/m**, so a 1.0 m player capsule reads ~24 px
  and the horizontal ground span = 30·(1280/720) = **53.3 m × 30 m** — the same play-field as v1's
  1280×720 view (`render.gd:7`, `project.godot:14-15`) at the same enemy-count readability (a
  0.85 m enemy ≈ 20 px, boss ≈ 80 px).
- **Angle:** pitch the camera **60° below horizontal** (30° off straight-down) instead of 90°. Reason:
  pure top-down hides a humanoid's animated front (limbs read as a head-blob); 30° off vertical keeps
  the top-down tactical read while showing enough front to see walk/attack. With an ortho camera
  height is size-independent, so height is chosen only to bracket the volume: camera at
  `player + Vector3(0, 28, 16)` looking at the player, `near=0.5, far=80` so the 3.2 m boss (§c) and
  its glow never clip. Trade-off rejected: free 3D camera (owner asked "top down", not a 3rd-person).
- **Ground:** a single `MeshInstance3D` plane on the XZ axis, one `ShaderMaterial`, **tiled from the
  SAME 4 biome textures** v1 ships (`static/assets/biomes/{grass,desert,snow,tundra}.png`, carried
  byte-identical). Band = `biome_at(t)` (`render.gd:80-85`) → swap `albedo_texture`. Tiling + world-lock
  mirror v1's `_draw_terrain` grid-snap (`render.gd:215-222`): the shader `UV = (world_xz / tile_scale)`
  with the plane centred on the camera so the seam never slides. `tile_scale` = 1024 px / S =
  1024/24 ≈ **42.7 m per tile**; texture repeat = `(53.3/42.7, 30/42.7) ≈ (1.25, 0.70)`. Band switch
  (t_start 0/150/300/450) is identical logic — one table, one lookup (`render.gd:68-77`, §d).
- **Collision = 2D on the XZ plane (no full 3D physics).** Map v1 `(x,y)` sim coords → Godot
  `(x, 0, y)`. All hitboxes are `Area`-on-XZ or plain distance checks, exactly as v1 already does
  (`weapons.gd:82-100`, `main.gd:122-128`, `world.gd:146`). Cited reason: **parity** (the whole v1 sim
  is 2D — homing `world.gd:99-103`, spawn ring `world.gd:59-60`, pickup radius 16 px `world.gd:146`,
  contact radius 17/boss 55 + player 16 `main.gd:122,125` — none needs a vertical axis) + **web perf**
  (300+ rigid-body 3D colliders do not run on the `gl_compatibility` web target `project.godot:19`).
- **Field parity number:** v1 spawn ring = `view.length()/2 + 40` = `hypot(1280,720)/2 + 40` ≈ 774 px
  = **32.2 m** (`world.gd:59-60`); spawn ring here = `hypot(53.3,30)/2 + 40/S` ≈ 31.4 m — within one
  tile-band, off-screen as in v1.

## (b) RENDERING BUDGET — web export is the target
gl_compatibility + WASM, threads OFF (`project.godot:19-20`, `export_presets.cfg:23`). Budget the
**300+ enemy horde to ~<40 draw calls**, never 300.
- **Instancing:** one `MultiMeshInstance3D` **per enemy class** (8 enemy classes + 1 boss + 1 player
  + 1 gem + 1 coin + 1 dawnlight = ~13 instanced nodes). A MultiMesh carries static-pose instances;
  per-instance **movement is a transform** (position + Y-bob + yaw-to-velocity), NOT per-instance skin
  (MultiMesh cannot skin-animate — the hard constraint that shapes §c). 8 enemy draws + 8 halo draws.
- **LOD / mesh budget (tris, decimated via TRELLIS.2 `to_glb(decimation_target=…)`):** small swarmers
  (wraith/hound/scarab/crawler/cultist) **≤ 1500 tris** each (instanced, static pose); hunched/tanky
  humanoids (moor-brute/rime-ghoul/pale-wight) **≤ 4000 tris**; boss **≤ 15000 tris** (single skinned);
  player **≤ 8000 tris** (single skinned). Textures packed into **one 2048² atlas** for all instanced
  enemies so all 8 enemy MultiMeshes share one material → batchable.
- **Shadows:** **no real-time shadow for the horde** (a shadow pass over 300 instances is the top web
  killer). Fallback **blob shadow**: one extra MultiMesh of a soft dark quad at y=0.02 under every
  unit (1 draw call). Player + boss get the same blob (they too skip real shadows on web). One
  `DirectionalLight3D` (moon) at low intensity, `shadow_enabled=false`, + one `WorldEnvironment`
  hemisphere ambient — mirrors v1's flat dark look + separate additive halos (`render.gd:44-53`).
- **Glow halos:** port v1's additive `HaloPass` (`render.gd:237-264`, `BLEND_MODE_ADD`) as a second
  additive MultiMesh pass (billboard quads) reusing v1's exact radii/alphas: enemy `(22,12)`px→
  `(0.92,0.50)`m, boss `(40,24)`→`(1.67,1.00)`m, dawn `(14,8)`→`(0.58,0.33)`m at S=24 (`render.gd:49-53`).
- **Numeric ceiling:** 300 enemies → 300 transform writes/frame (CPU, cheap) + 8 instanced draws +
  8 halo draws + ground + player + boss-pool + FX (≤ ~20) ≈ **≤ 45 draws**; target 60 fps on the 3090
  web build. Trade-off rejected: skinned horde (thousands of skinned draws — not viable on WASM).

## (c) ANIMATION — per asset class
- **Player, pale-wight, boss "Hollow Warden" (humanoid-ish):** UniRig biped rig
  (`RESEARCH-3D-3090.md:57-66`) → retargeted human mocap walk/run/attack. **Mocap source candidates
  (all local, from the research doc's (b) section):** **MDM** `GuyTevet/motion-diffusion-model`
  (`:80`), **T2M-GPT** `Mael-zys/T2M-GPT` (`:82`), **MLD** arXiv 2212.04048 (`:83`). **Godot retarget
  path:** GLB import → `AnimationTree` + `Animation Library` with a `rootMotion`/retarget track onto
  the UniRig skeleton. **These are the ONLY real-skin-animation instances** (player + boss always;
  pale-wight via a capped pool, below).
- **dune-scarab (6-legged), rime-ghoul (hunched), moor-brute (root-hulk):** UniRig best-effort rig;
  UniRig's own caveat — missing/odd bones degrade skinning (`RESEARCH-3D-3090.md:64-65`) — bites here,
  and human mocap (MDM/T2M/MLD = HumanML3D biped, `:87`) will NOT credibly animate them. **MUST-use
  procedural fallback:** Y-bob + lean + yaw-to-velocity + an attack tween, driven by speed. Formula:
  `bob_freq_hz = spd_m_per_s / STRIDE` (STRIDE ≈ 1.2 m), `bob_amp = 0.045 m` clamped, phase advanced
  by travelled distance (not time), so the bob stops exactly at rest. v1 speeds → m/s at S=24
  (`game_state.gd:5` BASE_SPEED 140 → player 5.83 m/s; `world.gd` rows: wraith 55→2.29, hound
  95→3.96, scarab 105→4.38, brute 32→1.33, ghoul 60→2.50, wight 52→2.17). Godot `Tween` +
  `AnimationPlayer` per `RESEARCH-3D-3090.md:92-96`.
- **Web skin-animation budget:** a skinned mesh cannot ride a MultiMesh (§b), so **pale-wight runs a
  shared pool of ≤ 8 `AnimationPlayer` instances** (nearest-to-player) and the rest render as static-
  pose MultiMesh duplicates; it only spawns in DEAD TUNDRA (`t≥450`, `render.gd:76`).
- **Acceptance test each class MUST pass (captured screenshot + a frame-diff):** (1) at rest the
  skinned/bobbed unit is pixel-stable; (2) walking produces a visible periodic Y/limb delta ≥ 2 px peak;
  (3) attack shows a distinct pose differing from walk. Captured per class, one PNG each in the run dir.

## (d) NUMBERS PORT MAP — v1 suite runs unchanged
**How the v1 suite runs against this build unchanged:** v1's `tests/test_game_numbers.py` reads the
`.gd` **source text** by file name (`test_game_numbers.py:13,17,21-24`) via `conftest.REPO`
(`conftest.py:18`). So the **3D build keeps the SAME file names + constant spellings** in
`godot/scripts/{world,game_state,render,main,hud}.gd`. The ported test file **`tests/test_game_numbers.py`**
is copied verbatim and imports the 3D repo's **`tests/conftest.py`** (vendored; its `REPO` resolves one
level up into THIS tree) — zero edits, the regexes hit the identical constants here. The data module is
therefore **the `godot/scripts/` data layer itself**; a single-file `game_data.gd` consolidation is a
**rejected alternative** (below). New band/signature pins (v1's stated coverage debt,
`ARCHITECTURE.md:197-200`) land in a NEW mirror file **`tests/test_biome_numbers.py`**.

| v1 pinned number (source) | 3D-build location (identical) | ported/added test |
|---|---|---|
| WIN_TIME 600.0 (`game_state.gd:7`) | `game_state.gd:7` | `test_game_numbers.py::test_win_threshold_600` |
| BOSS_AT 540.0 (`world.gd:5`) | `world.gd:5` | `::test_boss_at_540` |
| HEAL_DROP_CHANCE 0.015 (`world.gd:6`) | `world.gd:6` | `::test_heal_drop_chance` |
| HEAL_AMOUNT 8.0, clamp to max_hp (`world.gd:7,158`) | `world.gd:7` | `::test_heal_amount`, `::test_heal_clamp_path_exists` |
| boss Dawnlight guaranteed (`world.gd:137`) | `world.gd:137` | biome-numbers row |
| GATES 0/2/4/6 min (`world.gd:28`) | `world.gd:28` | `::test_gates_minutes` |
| spawn cap `min(12,1+1.3·min)` (`world.gd:88`) | `world.gd:88` | `::test_spawn_rate_capped_12` |
| wraith 8/55/2/1 (`world.gd:14`) | `world.gd:14` | `::test_enemy_base_stats_per_plan` |
| hound 6/95/3/1 (`world.gd:15`) | `world.gd:15` | `::test_enemy_base_stats_per_plan` |
| crawler 30/35/5/3 (`world.gd:16`) | `world.gd:16` | `::test_enemy_base_stats_per_plan` |
| cultist 18/60/6/4 (`world.gd:17`) | `world.gd:17` | `::test_enemy_base_stats_per_plan` |
| warden 3000/45/12/0 boss (`world.gd:24`) | `world.gd:24` | `::test_enemy_base_stats_per_plan` |
| moor-brute 26/32/4/2 (`world.gd:20`) | `world.gd:20` | `test_biome_numbers.py` (new) |
| dune-scarab 5/105/2/1 (`world.gd:21`) | `world.gd:21` | `test_biome_numbers.py` |
| rime-ghoul 18/60/5/3 (`world.gd:22`) | `world.gd:22` | `test_biome_numbers.py` |
| pale-wight 45/52/9/4 (`world.gd:23`) | `world.gd:23` | `test_biome_numbers.py` |
| xp_need `5+4L+L²` (`game_state.gd:29`) | `game_state.gd:29` | `::test_xp_curve` |
| ENEMY_TINTS exactly 5 (`render.gd:22-28`) | `render.gd:22-28` | `::test_five_enemy_tints_present` |
| BIOMES t_starts 0/150/300/450 (`render.gd:68-77`) | `render.gd:68-77` | `test_biome_numbers.py` |
| BIOME_FLASH 3.0 (`hud.gd:12`) | `hud.gd:12` | `test_biome_numbers.py` |
| score `time·10+kills·5+level·25+gold` (`main.gd:193-194`) | `main.gd:193-194` | `test_biome_numbers.py` |
| MAX_HP 100 / BASE_SPEED 140 / IFRAMES 0.5 (`game_state.gd:8,5,6`) | same | `test_biome_numbers.py` |
| pickup 16 px, contact 17/55 +16 (`world.gd:146`; `main.gd:122,125`) | same | `test_biome_numbers.py` |

## (e) SERVER / LEADERBOARD — reuse v1 verbatim
The v1 server is **stdlib-only Python and language-agnostic** (`ARCHITECTURE.md:168`, `server.py:1-6`);
the `/api/highscores` + `/api/health` contract (`ARCHITECTURE.md:37-42`) is unaffected by the client
becoming 3D. **Vendored verbatim** — the four files copied byte-identical: `server/server.py`
(sha256 `2f973d89…38ee`), `api.py` (`93f50f75…6650`), `db.py` (`e92d8ead…fa537`), `static_app.py`
(`898ee176…7923a`) from v1 `server/`. **Single config diff:** none required — `VS_PORT`/`VS_DB` env
(`server.py:49-50`), docroot `static/` and the sqlite `highscores` table all stay. The 3D build just
exports its WASM into `static/index.html` like v1. The three contract tests copy unchanged.

## (f) REPO LAYOUT (layout v2)
```
hollow-dawn-3d/
  docs/            ARCHITECTURE.md (kept true), DESIGN-3D.md (this), RESEARCH (pointer to v1)
  godot/           Main.tscn, project.godot, export_presets.cfg, scripts/, assets/{biomes,glb}
  assets/glb/      generated GLBs (source of truth for the art pass)
  server/          vendored v1 copy (server/api/db/static_app, shas in §e)
  static/          web export target (index.html/.pck) + mirrored assets
  tests/           conftest.py, test_game_numbers.py (verbatim), test_biome_numbers.py (new),
                   + the 4 copied v1 contract/hygiene suites
  data/  .tmp/     gitignored (already in .gitignore:1-2)
```
Assets: the 4 biome tiles + (fallback) the 6 weapon icons carried byte-identical from v1
`static/assets/`; new GLB models land `godot/assets/glb/`. `.audits/` run dir already at
`Games/.audits/202610211917-hd3d/` (out/ for verdicts, never authored by design).

## (g) EXPORT CHAIN — mirror v1's preset lessons
- **Web double-export rule** (`ARCHITECTURE.md:25-27`): `godot --headless --path godot --import &&
  --export-release "Web" ../static/index.html` **twice**, commit the regenerated `static/index.*` —
  the first export under-produces; v1's LEDGER records "web export x2" every row. Mirror preset.0
  (`export_presets.cfg:1-38`): `thread_support=false`, `vram_texture_compression/for_desktop=true`,
  `canvas_resize_mode=1`, and the **`html/head_include` string** (`export_presets.cfg:28`) carrying the
  `__vsSnapshot`/`VS_STATE`/key-relay/`vsShowSubmit` JS + markers `vs-fix-11075`/`vs-fix-11083`.
- **Windows preset.1** (`export_presets.cfg:40-92`): name "Windows Desktop" → `../.tmp/win/…`,
  `embed_pck=true`, `s3tc_bptc=true` (`:62-63`); `.tmp/` gitignored. `.exe` field-tested on VM120.
- 3D-specific: keep `gl_compatibility` renderer (`project.godot:19`) — the WebGL2-forward path is not
  guaranteed on the web target; blob shadows (§b) instead of a forward shadow pass.

## (h) REJECTED ALTERNATIVES
- **Mixamo** — cloud upload + humanoid-only; violates the owner's **3090-only / local** ruling and
  cannot rig scarab/ghoul/wight (`RESEARCH-3D-3090.md:68-71`).
- **Full 3D physics** — nothing in the v1 sim uses a vertical axis; 300 3D colliders won't run on the
  web target; a second (3D) collision mechanism beside v1's proven 2D one violates mechanism-monogamy.
- **Heightmap terrain** — v1 ground is a flat world-locked tile layer (`render.gd:215-222`); height
  adds a collision + LOD surface the ruling ("same type of visuals, top down") did not ask for.
- **2.5D pre-rendered sprites** — rejected as NOT the ruling: the owner asked for **models +
  animations + movements**, not flat sprites re-skinned; that keeps the v1 look, not the 3D ask.
- **Hunyuan3D-2.0/2.1** — its Community License **does not apply in the EU/UK/SK** including outputs
  (`RESEARCH-3D-3090.md:134-142`); this game ships in the EU. 2.1 combined VRAM 29 GB > 24 GB anyway.
- **Single-file `game_data.gd` consolidation** (§d) — rejected: it breaks the v1 suite's **cross-file
  wiring assertions** (`test_game_numbers.py:43-44,47-48` expect `BOSS_AT`/`WIN_TIME` gates in
  `world.gd`/`main.gd` specifically), so the suite could NOT run unchanged.

## (i) WEAPON EFFECTS (3D VFX) — owner DoD
Six weapons from v1 `weapons.gd` `META`/`_fire` (`weapons.gd:9-16,103-188`); the DAMAGE numbers are
ported unchanged (§d) — only the *visible* layer is redesigned for 3D. Web budget: everything is
**additive, unlit, no per-effect shadow**; particles capped per effect.
| v1 weapon (source) | 3D visible effect | web cap |
|---|---|---|
| talon raking arc, range 90+4L, half 0.62 rad (`weapons.gd:108-115`) | quarter-disc **glow decal** on the ground + a 3D whip/talon mesh arc, 0.15 s fade (v1 arc life `:115`) | 1 mesh + decal, no particle |
| ember seeking bolt, spd 300, r 9 (`weapons.gd:18,116-129`) | emissive **orb mesh + short GPU trail** (CPUParticles trail), homing | ≤ 8 live bolts (v1 targets `1+⌊(L-1)/3⌋`) |
| cleaver arcing throw, spd 260, r 12 (`weapons.gd:19,130-144`) | spinning bone-axe mesh on a parabolic toss (v1 lift `render.gd:155`) | ≤ 4 throws |
| halo orbiting cinders, radius 52+3L, count `1+⌈L/3⌉` (`weapons.gd:172-188`) | **orbiting ember meshes** on one ring, additive glow | ≤ 4 orbit quads (MultiMesh) |
| ward aura, r 80, tick 0.3 s (`weapons.gd:145-148`) | **ground ring-pulse decal**, expands+fade 0.12 s (v1 ring life `:148`) | 1 decal, no mesh |
| spike ground burst, r 56 (`weapons.gd:149-166`) | radial **shard particle burst** under densest cluster, 0.25 s (v1 burst `:166`) | ≤ 20 particles, 1 emitter |
Total FX ceiling ≈ 25 live meshes + ≤ 40 particles + 3 decals = **additive, unshadowed, ~15 extra
draws** — inside the §b ≤ 45 budget. v1 FX colours (MOON/EMBER/ICHOR/BONE) carried (`render.gd:12-18`).

## (j) UPGRADE CARDS (level-up UI) — owner DoD
**UI:** level-up stays a **2D `CanvasLayer` overlay on the 3D world** (Godot standard; v1 already runs
its screens on `layer=10` `screens.gd:22`). The card frame + layout are reused from v1 `screens.gd:118-148`
(`card-frame.png` + an icon `TextureRect` at `:134-139`). Each card gains a **skill image generated on
the SAME 3090 imagegen MCP pipeline** (Qwen-Image t2i — the tool v1 already used, `MANIFEST.md:3`; NOTE:
the parent's "`/opt/imagegen`" path does not exist here — the generator is the `imagegen` MCP tool,
out-root `/home/claudecode/design-lab`, class = 512×512 transparent-alpha icon). **Style anchor =
v1's sprite palette** quoted verbatim in `MANIFEST.md:10-14` (ink/slate/moonlight/bone/blood/ichor/ember).
**The 12-skill set from v1's upgrade pool** (`levelup.gd:8-14` passives + `weapons.gd:6` weapons +
`levelup.gd:40-41` bonus), with per-skill icon source/prompt:
| skill card (source) | icon: reuse or new prompt |
|---|---|
| Talon Lash (`weapons.gd:10`, `icon-talon`) | **reuse** v1 `icon-talon.png` (`MANIFEST.md:28`) |
| Ember Bolt (`weapons.gd:11`, `icon-ember`) | **reuse** `icon-ember.png` (`MANIFEST.md:29`) |
| Bone Cleaver (`weapons.gd:12`, `icon-cleaver`) | **reuse** `icon-cleaver.png` (`MANIFEST.md:30`) |
| Cinder Halo (`weapons.gd:13`, `icon-halo`) | **reuse** `icon-halo.png` (`MANIFEST.md:31`) |
| Warding Aura (`weapons.gd:14`, `icon-ward`) | **reuse** `icon-ward.png` (`MANIFEST.md:32`) |
| Grave Spike (`weapons.gd:15`, `icon-spike`) | **reuse** `icon-spike.png` (`MANIFEST.md:33`) |
| Ferocity +10% dmg (`levelup.gd:9`) | **NEW** "single crimson blood-drop gauntlet icon, +10% dmg, centered, bold shape, no frame" |
| Haste +8% speed (`levelup.gd:10`) | **NEW** "single moonlit winged boot icon, motion blur lines, centered, bold, no frame" |
| Warding −1 dmg (`levelup.gd:11`) | **NEW** "single pale moonlight shield icon with a bone boss, centered, bold, no frame" |
| Grip +25% magnet (`levelup.gd:12`) | **NEW** "single bone claw-grip / magnet hook icon, ichor-green spark, centered, no frame" |
| Insight +15% xp (`levelup.gd:13`) | **NEW** "single glowing soul-gem eye icon, ichor-green inner light, centered, no frame" |
| Coin Cache +25g/+10hp (`levelup.gd:41`) | **reuse** `coin.png` (`MANIFEST.md:35`) |
**Gap closed:** v1 passive cards render with `icon:""` (no image, `levelup.gd:35`) — this is exactly
the owner's "images per skill" ask; the 5 NEW passive icons fill it. **Fallback if generation fails:**
use the v1 weapon-icon PNG where one exists (`static/assets/icon-*.png`), else the `coin.png` / a solid
`ColorRect` placeholder so a card is never blank (mirrors v1's never-crash placeholder path `render.gd:170`).
Every prompt carries the `MANIFEST.md:10-14` anchor. Provenance recorded per imagegen contract
(`impeccable embed-prompt`).

---
Trade-offs stated inline (§a ortho/angle/2D-collision, §b instancing + pool, §d data-module, §h list).
Open readings flagged: (1) camera 60° vs 90° is my call within "top down" — reversible, cheap.
(2) the parent's `/opt/imagegen` path is absent; I used the live `imagegen` MCP generator — confirm
this is the intended icon generator before the art pass.
