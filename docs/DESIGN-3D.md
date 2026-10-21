# DESIGN-3D — Hollow Dawn 3D remake (MC 11095, T-P2-2; cycle-2 rework of the DA FIX)

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
DA cycle-1 findings fixed here: P1 (§c rewrite, Route A), P2-1..P2-5, P3 set, P4 nits.

## (a) SCENE — top-down Node3D world
- **Camera:** one `Camera3D` on a rig node that follows the player. **Projection = Orthographic**
  (perspective rejected: v1 entities are size-pinned regardless of distance, `render.gd:10`).
  `orthographic_size = 30.0 m` vertical at the 720 px viewport (`project.godot:14-15`) ⇒ lateral ground
  scale **S = 720/30 = 24 px/m**; horizontal span 30·(1280/720) = **53.3 m**.
- **Pitch:** camera pitched **20° off straight-down** (70° below horizontal). Honest anisotropy note
  (P2-2): with an ortho tilt, ground distances along camera-forward shrink by cos 20° = **0.94**
  (≤ 6 %, accepted); a 0° rig is isotropic but makes ALL vertical motion invisible. Visible ground
  depth = 30/cos 20° = **31.9 m**, so the field ≈ **53.3 × 31.9 m** ≈ v1's 1280×720. Height: camera at
  distance 40 m ⇒ offset `Vector3(0, 37.6, 13.7)` from the player, `near 0.5 / far 90` (brackets the
  5.4 m boss + glow; boss height here fixes cycle-1's dangling "§c" ref).
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
  player + boss + gem + coin + dawnlight. **Per-instance transforms are rewritten every frame** —
  position, yaw-sway, lean, squash, scale, color (this one mechanism IS the horde animation, §c).
  Per-instance tint (v1 `tint_of`, `render.gd:41-42`; P3-2) = `use_colors` +
  `shaders/instance_tint.gdshader` multiplying `ALBEDO` by `INSTANCE_COLOR` — v1's tint ported, still
  one material per class over the 2048² shared atlas.
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
  8 + halo MM 8 + blobs 1 + hp-bars 1 + gems 1 + coins 1 + dawnlight 1 + dawn-glow 1 + player 1 +
  boss 1 = 25, + FX ≤ 7 (§i batched) ⇒ **planned worst case 32, hard cap 60 (≈ 2× headroom)**.
  **"300+" is a design-time margin, not
  a v1 fact** (no v1 doc measures peak alive; the spawn math — rate cap `min(12, …)/s` from
  t ≈ 508 s, `world.gd:88` — implies ≈ 1800 spawns in the last band alone; budget assumes ≤ 400
  concurrent).

## (c) ANIMATION — ROUTE A: per-instance transform animation for the horde; real skin for player+boss
**Route declared (P1):** horde classes get **per-instance TRANSFORM gait** (MultiMesh instance
transforms are updatable every frame — sway/bob/lean/lunge/squash, no bones); **only player + boss**
are UniRig-rigged + mocap-retargeted and skinned. Cycle-1 silently split these classes across both
routes while rendering them as neither — that split is gone.
- **Reconciliation vs `RESEARCH-3D-3090.md` (explicit — the cycle-1 sin):** the doc's per-class table
  (:113-114) pairs brute/ghoul/scarab with rig + **procedural** motion, and its (b) section itself
  names Godot procedural animation as *"the realistic answer for the non-human enemies … reserve
  baked mocap for the player/boss"* (:92-96). Route A is that prescription taken to its transform
  level. **Why not Route B (skinned horde):** MultiMesh cannot skin (cycle-1 fact, uncontested) ⇒
  every skinned enemy is its own draw + bone upload + `AnimationPlayer` tick: at the ≤ 400-concurrent
  margin that is **≥ 400 skinned draws vs the ≤ 60 cap (≈ 7×)** plus 400 anim ticks on
  single-threaded WASM — outside the web target this design exists for. If the owner later wants a
  skinned horde, that is a desktop-only toggle, not the web product.
- **Owner DoD NOT downgraded:** v1 shipped **zero** character animation (static 34 px sprites,
  `render.gd:163-171`); Route A animates **every on-screen entity** (transform gait at the 34 px
  read) and gives player + boss full skeletal mocap — strictly more "character animations,
  movements" than anything in v1.
- **Skinned (player, boss "Hollow Warden"):** UniRig biped (`RESEARCH:57-66`) → retargeted mocap via
  `AnimationTree` + retarget tracks; **local motion sources (research doc (b)):** MDM
  `GuyTevet/motion-diffusion-model` (`:80`), T2M-GPT `Mael-zys/T2M-GPT` (`:82`), MLD arXiv 2212.04048
  (`:83`). 2 skinned draws total.
- **Gait (all 8 enemy classes, `horde_viz.gd`):** yaw-sway **±6°** about vertical at gait frequency
  `spd_m_per_s / 1.2 m stride` (v1 speeds ÷ S: wraith 55→2.29, hound 95→3.96, crawler 35→1.46,
  cultist 60→2.50, brute 32→1.33, scarab 105→4.38, ghoul 60→2.50, wight 52→2.17 m/s; player
  BASE_SPEED 140→5.83, `game_state.gd:5`), stride pulse **±0.09 m** along velocity, lean toward
  velocity, secondary vertical bob ±0.15 m (reads ±1.2 px at the 20° pitch — kept, NOT the contract).
  **Attack = transform signature:** forward lunge 0.24 m + velocity-axis squash 0.85↔1.15 over 0.2 s.
- **pale-wight (P3-3 closed):** transform **drift-float** (slow yaw wander + 0.1 m sink/breathe) — it
  is a legless mist form ("wispy dissolving lower body", `MANIFEST.md:102`); cycle-1's biped-mocap
  showcase choice withdrawn. Class labels fixed: **moor-brute** is the hunched one, **rime-ghoul** a
  tall humanoid (`MANIFEST.md:99,101`) — which strengthens dropping its "hunched" mislabel, not the
  rig (Route A needs no rig).
- **No buy-and-unused rigs (P2-3 closed):** UniRig runs for **player + boss only**; brute/ghoul/
  scarab/wight ship as decimated static TRELLIS meshes animated by transforms — no GPU window or
  manual-bone-fix spent on rigs nothing consumes.
- **Acceptance — every test satisfiable by the mechanism it tests (captured PNGs + numeric
  frame-diffs):** rest = silhouette bbox delta ≤ 1 px; **walk** = bbox delta ≥ 2 px (predicted: sway
  1.45·sin 6°·24 = **3.6 px**; pulse 0.09·24 = **2.2 px**); **attack** = lunge ≥ 5 px translation
  (predicted 0.24·24 = **5.8 px**) + footprint scale delta ≥ 15 % — a transform signature, and no
  "distinct pose" is asserted for a pose-less class. Player + boss additionally: rest/walk/attack
  pose delta ≥ 2 px (they have poses).

## (d) NUMBERS PORT MAP — v1 suite runs unchanged
**Mechanism:** v1's `test_game_numbers.py` reads `.gd` **source text** by file name
(`test_game_numbers.py:13,17,21-24`) under `conftest.REPO` (`conftest.py:18`). The 3D build keeps the
**same file names + constant spellings** in `godot/scripts/`; the test file is copied verbatim and
imports this repo's vendored `tests/conftest.py` (one port/DB re-stamp, §e) — zero logic edits. A
consolidated `game_data.gd` is **rejected** (§h). Band/signature pins v1 never covered
(`ARCHITECTURE.md:197-200` @ `5dc7679`) land in new **`tests/test_biome_numbers.py`** (same regex style).

| v1 pinned number (source) | 3D location (identical) | test |
|---|---|---|
| WIN_TIME 600.0 (`game_state.gd:7`) | `game_state.gd:7` | `test_game_numbers.py::test_win_threshold_600` |
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
| iframes alpha-flash + player→player-alt at L5 (`render.gd:134-138`) | `hero_pawn.gd` alpha tween + GLB swap | screenshot |
| tint_of per-type (`render.gd:22-42`) | instance color + `instance_tint.gdshader` | `::test_five_enemy_tints_present` + screenshot |

## (e) SERVER / LEADERBOARD — reuse v1 verbatim
v1's server is **stdlib-only Python, language-agnostic** (`ARCHITECTURE.md:168` @ `5dc7679`;
`server.py:1-6`); `/api/health` + `/api/highscores` (`ARCHITECTURE.md:37-42` @ `5dc7679`) are
unaffected by a 3D client. Vendored byte-identical: `server/server.py` (sha `2f973d89…38ee`),
`api.py` (`93f50f75…6650`), `db.py` (`e92d8ead…fa537`), `static_app.py` (`898ee176…7923a`); env
`VS_PORT`/`VS_DB` (`server.py:50-51`; cycle-1's `:49-50` off-by-one fixed) unchanged.
**Tests copy with ONE stated diff (P3-6):** vendored `tests/conftest.py` re-stamps
`MAIN_PORT/MAIN_DB/RESTART_*` (`conftest.py:22-23`) to `8941/8942` + `/tmp/hd3d-*.db` — else the two
repos' suites on this host purge each other's DB. **`test_assets_manifest.py` is dropped, stated:**
its pinned 16-PNG `EXPECTED_FILES` set + v1 PLAN path cannot hold in the 3D tree; the GLB/icon tree
gets its own manifest test at the art phase.

## (f) REPO LAYOUT + named files (file-level — P2-5 closed)
```
godot/Main.tscn                 Node3D root, scripts/main.gd (ported; renderer wiring swapped)
godot/scripts/camera_rig.gd     NEW — ortho Camera3D rig, pitch/height/follow (§a)
godot/scripts/ground.gd         NEW — biome band quad + band-swap logic (§a)
godot/shaders/ground.gdshader   NEW — world-locked tiling (§a)
godot/shaders/instance_tint.gdshader NEW — INSTANCE_COLOR × ALBEDO (§b tint port)
godot/scripts/horde_viz.gd      NEW — per-class MultiMeshes + per-frame transform write (gait §c)
                                + blob-shadow MM + HP-bar MM + instance-color plumbing (§b)
godot/scripts/hero_pawn.gd      NEW — skinned player + boss (AnimationTree, retarget, iframes flash,
                                L5 GLB swap; §c/§d)
godot/scripts/viz_fx.gd         NEW — halo MM passes + weapon-FX emitters (§i/§b)
godot/scripts/hud_3d.gd         NEW — hud.gd ported to a CanvasLayer over 3D + boss bar (§d)
godot/scripts/render.gd         DECIDED — KEEP AS DATA MODULE ONLY: `class_name GameRenderer` +
                                BIOMES/biome_at/SIZES/ENEMY_TINTS/BIOME_TINTS/tint_of/glow consts
                                VERBATIM (world.gd:52 calls biome_at — the compile gate; the suite
                                regexes the tables), ALL Node2D `_draw*` + HaloPass bodies DELETED —
                                no ghost 2D renderer. The file stops being what §a mirrors
                                behaviourally; only its tables stay cited-as-truth.
godot/scripts/{world,game_state,weapons,levelup,bridge,screens}.gd  copied VERBATIM (sim + suite
                                text-reads; screens.gd extended only by §j card icons)
godot/assets/biomes/*.png       4 v1 tiles byte-identical; godot/assets/glb/ NEW; godot/assets/icons/ NEW (§j)
tests/  conftest.py (one-diff §e), test_game_numbers.py verbatim, test_biome_numbers.py NEW,
        test_contract_a_api.py + test_contract_a_validation.py + test_static_contract.py +
        test_tree_hygiene.py copied (test_assets_manifest.py dropped, §e)
server/ vendored verbatim (§e); static/ export target; docs/ + .audits/ per layout v2
```
Hygiene: every script above ≤ 300 lines (`test_tree_hygiene.py:19` gate ships with the copy).

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
  closes the build card; digests recorded on the card — same flow as v1's v1.0.0/v1.1.0
  (`ARCHITECTURE.md:29-31` @ `5dc7679`).

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
| ember (`weapons.gd:116-129`; **straight flight** — vx,vy fixed at fire and integrated straight, `:193-199`; META "seek" is v1's own copy-fiction `:11`; ≤ 1+⌊(L-1)/3⌋ bolts; BOLT_SPEED 300 `:18`) | emissive orb MM + trail ribbon; renders a STRAIGHT shot — no homing invented (P3-1) | 2 |
| cleaver (`weapons.gd:130-144`, THROW_SPEED 260, ≤ 1+⌊(L-1)/4⌋) | spinning bone-axe MM on a parabolic toss (v1 lift `render.gd:155`) | 1 |
| halo (`weapons.gd:172-188`: radius 52+3L px, count 1+⌈L/3⌉ ≤ 4, ω 2.4+0.08L) | orbiting ember MM on one ring | 1 |
| ward (`weapons.gd:145-148`: cd 0.45 at `:146`; the 0.3 s tick is `e.hit_cd` at `:95` — cycle-1 cite fixed) | expanding ring-pulse decal, 0.12 s | 1 |
| spike (`weapons.gd:149-166`, r 56 px, life 0.25) | radial shard particle burst under the densest cluster | 1 |
Colours carried from v1 (MOON/EMBER/ICHOR/BONE, `render.gd:12-18`).

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
The 5 NEW icons close v1's real hole (passive cards ship `icon: ""`, `levelup.gd:35`). **Fallback if a
generation fails:** reuse the weapon icon where one exists, else `coin.png`, else a tinted
`ColorRect` (mirrors v1's never-crash placeholder path `render.gd:170`) — a card is never blank.
Provenance per the imagegen contract (`impeccable embed-prompt`).

---
**Open readings:** (1) the 20° pitch (cycle-1's 60°-off-horizontal = 30°-off-vertical re-derived; the
anisotropy note in §a is the honest fix) is my call within "top down", reversible; (2) icons via the
`imagegen` MCP tool — the brief's `/opt/imagegen` path is absent here; (3) Route A is reconciled in
§c against `RESEARCH:92-96,113-114`; overturning it means a desktop-only skinned-horde build the
owner has not asked for.
