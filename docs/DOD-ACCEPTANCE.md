# DOD-ACCEPTANCE — Hollow Dawn 3D (MC 11097, T-P2-3)

Plan against `docs/DESIGN-3D.md` (DESIGN-3D §a–§j cited below as "D§x", @ `2fdc086` — cycle 3,
Route A; this doc re-synced per DA-verdict-c2 rows PD-1…PD-10, each re-verified against the text).
Owner mandate (verbatim): *"Make sure architect and planner makes a proper list of dods"*.
Owner DoD (verbatim): *"full playable game with animated player character, enemies, wepon
effects, boss and environment. Upgrade cards with appropriate images per skill."* + rulings:
top-down, 3090-only art, own repo + releases (`bryn1/hollow-dawn-3d`).
Baseline: v1 `/home/claudecode/Games/vampire_survivor` @ `562e0a1` (master — every `file:line`
below re-read from that tree; ARCHITECTURE.md cites valid only since its 217-line rewrite `5dc7679`, D header).
Convention: `file:line` citations are v1-relative. Test rig = Playwright (dsh browser MCP) on
the WASM export + `window.__vsSnapshot` (v1 `game_state.gd:87-104`) + `pytest tests/`.

## (a) OWNER ACCEPTANCE ROWS — checkable

Tester rig for A1–A7: serve `static/`, open `index.html` in Playwright, drive keys via the
v1 key-relay (`export_presets.cfg` head_include per D§g), read `__vsSnapshot` each tick.
Every screenshot artifact lands `.audits/<run>/out/` (never authored here).

| # | Owner ask | Tester types/runs | Output that proves it (artifact) | Numeric threshold |
|---|---|---|---|---|
| A1 | full playable game | Start (Enter), WASD 120 s, then die or win | snapshot.json trace + screenshots t=0/30/120/end + console dump | phase menu→playing→levelup→(playing)→gameover/win all observed in one trace; `time` monotonic; kills>0 by t=60; 0 console errors; fps (rAF counter) ≥ 30 at peak horde density (budget margin ≤ 400 concurrent, D§b) |
| A2 | animated player character | walk at full speed, attack; capture 3-frame strip of the player bbox | scene dump (`AnimationPlayer` clip list / transform dump) + 3-frame PNG strip | player is one of the TWO skinned UniRig classes (D§c): ≥1 walk clip in AnimationPlayer dump + rest/walk/attack frame-diff ≥ 2 px per pair (pose contract). Rig-failure fallback = transform gait: bbox-WIDTH p2p ≥ 2 px with instance translation normalized out (scissor 1.00↔1.12 ⇒ 2.88 px predicted at the art floor w ≥ 0.5 m, D§c; the withdrawn 0.045 m bob is NOT the contract — vertical bob is decoration only). At rest the strip is pixel-stable (scale-constant) |
| A3 | enemies | run t=0→600; strip-record the nearest unit of each type id | 8 per-class PNG strips + per-instance transform dumps + snapshot kill-log per type | all 8 non-boss types spawn — GATES = [0 wraith, 2 hound, 4 crawler, 6 cultist] (`world.gd:28`; wraith IS a gate type) + the 4 band signatures; see gap note under (c). Per-class Route-A acceptance (D§c): rest stable; walk = bbox-WIDTH p2p ≥ 2 px with instance translation normalized out (wight: breathe 0.93↔1.15 → 2.64 px at w ≥ 0.5, drift-float REPLACES gait); attack = transform-signature lunge on the `e.hit_cd` rising edge (D§c trigger; ≥ 5 px forward excursion + footprint scale delta ≥ 15 %) — NO distinct-pose claim for pose-less classes; gait freq ≤ 2.2 Hz (transform dump row, D§c P2-A cap) |
| A4 | weapon effects | pick all 6 weapons (drive levelup picks via keys 1-3), screenshot mid-fire of each | 6 FX PNGs + snapshot `weapons[]` row per weapon | each FX visibly painted (non-background pixels in FX area of PNG); live-count caps per the current D§i table: ember ≤ 1+⌊(L−1)/3⌋ (= 3 at L8) straight-flight bolts, cleaver ≤ 1+⌊(L−1)/4⌋ (= 2), halo count 1+⌈L/3⌉ ≤ 4, FX draws ≤ 7 batched; frame draws planned worst case 33 / hard cap 60 (Godot profiler dump row ≤ 60, D§b) |
| A5 | boss | survive to t=540 (or fast-forward the clock in a test build) | boss-bar PNG + snapshot enemy-count step + kill screenshot | boss spawns exactly once at time ≥ 540.0 (`world.gd:5,84`); hp 3000 (`world.gd:24`); name bar "THE HOLLOW WARDEN" visible (v1 `render.gd:206`); boss death drops ≥1 Dawnlight guaranteed (`world.gd:137`) + 50 gold (`world.gd:132`); boss mesh ≤15000 tris (bpy dump), 5.33 m (D§a); boss is skinned (D§c): rest/walk/attack frame-diff ≥ 2 px + attack clip fires on the same `e.hit_cd` rising-edge trigger as the horde |
| A6 | environment | watch t=149→151, 299→301, 449→451; screenshot before/after each | 4 ground PNGs + banner PNG per band | ground albedo texture differs per band (pixel-mean ΔE measurable between PNGs); banner text = BIOMES name, alpha-up 3.0 s (`hud.gd:12`); band switch at t 0/150/300/450 exactly (`render.gd:68-77`) |
| A7 | upgrade cards w/ images per skill | force levelups until all 12 pool kinds offered; screenshot each card | 12 card PNGs + `make_offer` dump + icon byte-list | 12/12 skills render a NON-BLANK icon TextureRect (7 reused v1 PNGs + 5 new generated — D§j table); every new icon is 512×512 RGBA PNG with embedded prompt provenance (`impeccable embed-prompt` output row); no card shows the blank-icon path (`levelup.gd:35` gap closed) |
| A8 | rulings: top-down / 3090-only / repo+release | scene dump; provenance grep; `gh release view` | camera dump, PERMANENCE.md provenance table, release page text | camera = Camera3D, `projection = Camera3D.PROJECTION_ORTHOGONAL`, `size = 30.0`, pitch 20° off straight-down, offset (0, 37.6, 13.7), near 0.5 / far 90 — names VERIFIED on pinned Godot_v4.7.2 (D§a; `orthographic_size` withdrawn); every GLB/icon in `assets/` has a generation log naming the vm100 3090 tool (TRELLIS.2/imagegen) — 0 assets without provenance; repo `bryn1/hollow-dawn-3d` has a release with web zip + `static/index.*` + `.exe` attached (`gh release view` output) |

## (b) PINNED v1 NUMBERS — every one that must survive, each proven by a ported test

Mechanism (D§d): v1 `tests/test_game_numbers.py` greps `.gd` SOURCE TEXT (`test_game_numbers.py:13,16-24`)
resolved via `conftest.py:18`; the 3D build keeps identical file names + constant spellings and
runs the suite VERBATIM. "v1-suite" = existing test; "biome-new" = row added to
`tests/test_biome_numbers.py` (D§d).

| # | Number | Source file:line | Proven by |
|---|---|---|---|
| N1 | BOSS_AT = 540.0 | world.gd:5 | v1-suite `test_boss_at_540` |
| N2 | WIN_TIME = 600.0 | game_state.gd:7 | v1-suite `test_win_threshold_600` |
| N3 | win gate reads shared WIN_TIME | main.gd:134 | v1-suite (regex in `test_win_threshold_600`, test_game_numbers.py:43-44) |
| N4 | boss gate compares BOSS_AT | world.gd:84 | v1-suite `test_boss_gate_wired` (:47-48) |
| N5 | HEAL_DROP_CHANCE = 0.015 | world.gd:6 | v1-suite `test_heal_drop_chance` |
| N6 | HEAL_AMOUNT = 8.0 | world.gd:7 | v1-suite `test_heal_amount` |
| N7 | heal clamp `minf(max_hp, hp+HEAL_AMOUNT)` | world.gd:158 | v1-suite `test_heal_clamp_path_exists` |
| N8 | GATES 0/2/4/6 min → wraith/hound/crawler/cultist | world.gd:28 | v1-suite `test_gates_minutes` |
| N9 | spawn rate min(12, 1+1.3·minute) | world.gd:88 | v1-suite `test_spawn_rate_capped_12` |
| N10 | wraith 8/55/2/1 | world.gd:14 | v1-suite `test_enemy_base_stats_per_plan` |
| N11 | hound 6/95/3/1 | world.gd:15 | v1-suite same |
| N12 | crawler 30/35/5/3 | world.gd:16 | v1-suite same |
| N13 | cultist 18/60/6/4 | world.gd:17 | v1-suite same |
| N14 | moor-brute 26/32/4/2 | world.gd:20 | biome-new |
| N15 | dune-scarab 5/105/2/1 | world.gd:21 | biome-new |
| N16 | rime-ghoul 18/60/5/3 | world.gd:22 | biome-new |
| N17 | pale-wight 45/52/9/4 | world.gd:23 | biome-new |
| N18 | warden 3000/45/12/0 boss | world.gd:24 | v1-suite same |
| N19 | xp_need = 5+4L+L² | game_state.gd:29 | v1-suite `test_xp_curve` |
| N20 | ENEMY_TINTS exactly the 5 classic keys | render.gd:22-28 | v1-suite `test_five_enemy_tints_present` |
| N21 | BIOMES t_starts 0/150/300/450 + rosters | render.gd:68-77 | biome-new |
| N22 | BIOME_FLASH = 3.0 s | hud.gd:12 | biome-new |
| N23 | score = time·10 + kills·5 + level·25 + gold | main.gd:193-194 | biome-new |
| N24 | MAX_HP = 100.0 | game_state.gd:8 | biome-new |
| N25 | BASE_SPEED = 140.0 | game_state.gd:5 | biome-new |
| N26 | IFRAMES = 0.5 | game_state.gd:6 | biome-new |
| N27 | pickup radius 16 px | world.gd:146 | biome-new |
| N28 | contact radii 17 / boss 55, + player 16 | main.gd:122,125 | biome-new |
| N29 | boss Dawnlight guaranteed on death | world.gd:137 | biome-new |
| N30 | gem drop 70% / coin drop 6% (1–3 g) | world.gd:133,135-136 | biome-new |
| N31 | boss death +50 gold | world.gd:132 | biome-new |
| N32 | enemy HP scaling ×(1+0.22·min) | world.gd:67 | biome-new |
| N33 | magnet base 60 px, +25%/Grip stack; pull 220 px/s | world.gd:106,120 | biome-new |
| N34 | BOLT_SPEED 300 / THROW_SPEED 260 | weapons.gd:18-19 | biome-new |
| N35 | weapon MAX_LEVEL 8; fire rate base·0.96^(L−1) | weapons.gd:7,48 | biome-new |
| N36 | talon range 90+4L, half 0.62, cd 0.55, dmg 6+3L | weapons.gd:109-114 | biome-new |
| N37 | ward r 80, cd 0.45, dmg 4+2L, ring life 0.12 | weapons.gd:145-148 | biome-new |
| N38 | spike r 56, cd 2.6, dmg 18+7L, burst 0.25 s | weapons.gd:150,164-166 | biome-new |
| N39 | halo radius 52+3L, count 1+⌈L/3⌉, orbit hit r 17 | weapons.gd:175-176,188 | biome-new |
| N40 | passive stacks cap 5; Coin Cache +25g/+10hp | levelup.gd:6,41,65-66 | biome-new |
| N41 | VIEW 1280×720 | main.gd:5; project.godot:14-15 | biome-new |
| N42 | draw sizes player 40 / enemy 34 / boss 128 / coin·gem 14 | render.gd:10 | biome-new (3D parity check: size_px/S ≈ v1 px at S=24, D§a) |
| N43 | hit radius er 17/boss 55 in weapon `_hit` | weapons.gd:82 | biome-new |
| N44 | halo tick immunity 0.3 s (hit_cd) | weapons.gd:95 | biome-new |
| N45 | 6 weapon IDS + META names/icons table | weapons.gd:6,9-16 | biome-new + A7 icon test |

## (c) ART-ASSET MANIFEST

Pipeline shorthand (D§c/§h, RESEARCH-3D-3090 §c): **T2** = TRELLIS.2 ≤1024³ fp16 (OOM →
TRELLIS-v1/TripoSG, D§h); **UR** = UniRig rig — **player + boss ONLY** (D§c "no buy-and-unused
rigs"); **MC** = retargeted human mocap (MDM/T2M/MLD); **GAIT** = per-instance transform gait in
`horde_viz.gd` — scissor 1.00↔1.12, freq `min(spd/1.2, 2.2 Hz)`, pulse ±0.09 m, lean 8°, sway,
lunge on the `e.hit_cd` edge (D§c); **IG** = imagegen MCP (Qwen-Image t2i, 512² transparent).
Every GLB lands `godot/assets/glb/`, every icon `godot/assets/icons/`; tri budget verified by a
headless `bpy` dump (bytes + tris printed, gate S1). Enemy instancing shares ONE 2048² atlas (D§b).

**GAP vs dispatch brief (stated reading):** the brief names "player, 4 band enemies, wraith, boss"
but v1 also spawns hound/crawler/cultist through the gate rotation (`world.gd:15-17,28`) — **8**
enemy models are required for A3 to pass; the manifest below carries all 8. If the orchestrator
rules only the brief's 5, A3's threshold drops to 5/8 types and hound/crawler/cultist render as
tinted wraith-mesh GAIT placeholders (v1's placeholder principle, `render.gd:170-171`) — flag
before art spend.

| asset | source v1 sprite | pipeline | size/tri budget | acceptance test |
|---|---|---|---|---|
| player | static/assets/player.png (MANIFEST.md:21) | T2→UR biped→MC walk/attack (rig-failure fallback: GAIT, A2) | ≤8000 tris; 1.67 m (build 1.7, D§a) | A2 pose frame-diff contract; GLB dump ≤8000 tris |
| player-alt (Lv≥5 skin) | static/assets/player-alt.png (MANIFEST.md:22) | same rig, retextured albedo (no 2nd rig) | +0 tris (material swap) | swap visible in screenshot at level ≥5 (`render.gd:136` rule ported) |
| enemy-wraith | static/assets/enemy-wraith.png (:23) | T2 static decimated mesh → GAIT (scissor 1.91 Hz, no rig, D§c) | ≤1500 tris; 1.42 m (build 1.45 — all non-boss sizes D§a) | Route-A acceptance rows (A3): width-p2p walk / hit_cd lunge / freq ≤2.2 Hz |
| enemy-hound | static/assets/enemy-hound.png (:24) | T2 → GAIT, taper-capped (raw 3.30 → 2.2 Hz, ±12° sway, D§c) | ≤1500 tris | Route-A acceptance rows (A3) |
| enemy-crawler | static/assets/enemy-crawler.png (:25) | T2 → GAIT (scissor 1.22 Hz) | ≤1500 tris | Route-A acceptance rows (A3) |
| enemy-cultist | static/assets/enemy-cultist.png (:26) | T2 → GAIT (scissor 2.08 Hz) | ≤1500 tris | Route-A acceptance rows (A3) |
| moor-brute | static/assets/enemies/moor-brute.png (:36 dir) | T2 → GAIT (scissor 1.11 Hz) | ≤4000 tris | Route-A acceptance rows (A3) |
| dune-scarab | static/assets/enemies/dune-scarab.png | T2 → GAIT, taper-capped (raw 3.65 → 2.2 Hz, ±12° sway — jitter cap, D§c) | ≤1500 tris | Route-A acceptance rows (A3) |
| rime-ghoul | static/assets/enemies/rime-ghoul.png | T2 → GAIT (scissor 2.08 Hz) | ≤4000 tris | Route-A acceptance rows (A3) |
| pale-wight | static/assets/enemies/pale-wight.png | T2 static mesh → **drift-float, REPLACES gait** (breathe 0.93↔1.15 ≈3 s + yaw wander + ±0.1 m sink; zero skinning, D§c) | ≤4000 tris | own D§c row: breathe width-p2p = 0.22·w·24 = 2.64 px at w ≥ 0.5 + lunge trigger + rest stable |
| boss-warden | static/assets/boss-warden.png (:27) | T2 ≤1024³ fp16 (expect OOM at 1536³ → TRELLIS-v1/TripoSG, D§h) →UR→MC+attack clip | ≤15000 tris; 5.33 m (build 5.4, D§a) | A5 + skinned pose frame-diff ≥2 px + trigger-fired own clip |
| gem pickup | static/assets/gem.png (:36) | T2 small prop | ≤300 tris, instanced | visible at 14 px-equiv (N42) |
| coin pickup | static/assets/coin.png (:35) | T2 small prop | ≤300 tris, instanced | visible at 14 px-equiv |
| dawnlight | (v1 procedural draw, render.gd:175-182) | dawnlight MM + additive halo MM, DAWNLIGHT colour (render.gd:18; D§b/§d) | 0 GLB | A5 heal-drop screenshot glow ≥ v1 alpha 0.25/0.40 (render.gd:53) |
| blob shadow | (new, D§b) | soft-quad MultiMesh at y = 0.02, all units | ≤6 tris ×1 MultiMesh | 1 draw call in profiler dump |
| talon FX mesh | arc poly (render.gd:143-148) | T2 prop (whip/talon arc) + ground decal | ≤500 tris, 1 mesh+decal | A4 row 1 |
| ember bolt FX | circle fx (render.gd:151-152) | emissive orb MM + trail ribbon; STRAIGHT flight (no homing invented, D§i) | ≤200 tris ×≤ 1+⌊(L−1)/3⌋ live (=3 max) | A4 row 2 |
| cleaver FX mesh | throw rect fx (render.gd:153-157) | T2 bone-axe prop MM, spin+parabola (lift render.gd:155) | ≤500 tris ×≤ 1+⌊(L−1)/4⌋ live (=2 max) | A4 row 3 |
| halo FX mesh | halo circles (render.gd:149-150) | orbiting ember quads on one ring MM (D§i) | count 1+⌈L/3⌉ ≤ 4 quads | A4 row 4 |
| ward FX | ring fx (render.gd:123-124,145-148) | expanding ground ring-pulse decal, 0.12 s (D§i) | 1 decal | A4 row 5 |
| spike FX | burst fx (render.gd:158-160) | radial shard particle burst under the densest cluster (real v1 targeting, weapons.gd:149-166) | 1 emitter, 1 FX draw (no numeric particle cap in D§i) | A4 row 6 |
| card-frame | static/assets/card-frame.png (:34) | REUSE byte-identical | n/a | A7 frame renders on card |
| icons ×6 weapons | static/assets/icon-{talon,ember,cleaver,halo,ward,spike}.png (:28-33) | REUSE byte-identical | n/a | A7 (6 cards with icon) |
| icon Coin Cache | static/assets/coin.png (:35) | REUSE | n/a | A7 |
| icons ×5 passives | (none in v1 — the gap, levelup.gd:35) | NEW via IG, prompts = D§j rows 7–11, style anchor MANIFEST.md:12-14 verbatim in every prompt | 512×512 RGBA | A7 (5 new icons non-blank, provenance embedded) |
| biome ground ×4 | static/assets/biomes/{grass,desert,snow,tundra}.png | REUSE byte-identical as tiled albedo (D§a) | n/a | A6 |

## (d) STAGE PLAN

Order: S0 → S1/S2 (art chain) and S3 (code chain) run PARALLEL → S4/S5/S6 (each needs S3; S6
also needs S2) → S7 → S8. Profile children per fleet profiles; every gate is the named check.

| stage | DoD (checkable) | profile | parallelizes with | gate before next |
|---|---|---|---|---|
| S0 stack install (running, MC 11096) | `tools/VERSIONS.txt` pins godot **4.7.2** (the binary D§a/§b member names are VERIFIED on)/TRELLIS.2/UniRig/blender versions; `godot --headless --version` + 1 smoke GLB from a TRELLIS.2 512³ test run on vm100, byte-counted | infra | (already running) | smoke GLB exists → S1 |
| S1 art batch (models) | every GLB row of (c) exists in `assets/glb/` + bpy dump prints tris ≤ budget + 1 concept render per asset; PERMANENCE.md provenance row per asset | code/design | S3, S5-icons | tri-budget dump all-green → S2 |
| S2 rig/anim | player+boss GLBs import with AnimationPlayer ≥1 clip + pose frame-diff ≥2 px per pair (scene dump, D§c skinned contract); 8 per-class transform strips pass the Route-A gates (width-p2p walk / `hit_cd`-lunge attack / gait-freq ≤2.2 Hz dump row) | code/design | S4 | 8 strip PNGs + 2 pose captures accepted — visual acceptor named: orchestrator pass via describe-image (the only veto against the jitter look, DA-c2 P2-A) → S6 may start |
| S3 scene + core loop (first green build) | Main.tscn per D§a (ortho `size = 30.0`, pitch 20° off straight-down); placeholder meshes OK; **ported `tests/test_game_numbers.py` runs VERBATIM green** + `test_biome_numbers.py` (new pins N14–N45) green; a full sim run (headless, seeded) reaches win/gameover | code + test | S1, S5 | verbatim suite green → S4/S5/S6 |
| S4 combat + effects | 6 FX screenshots (A4) + profiler draw-call dump ≤ 60 (planned worst case 33, D§b) at the ≤ 400-concurrent margin + fps ≥30 on web build | code/frontend + test | S5, S6 | A4+A1 fps rows pass → S7 |
| S5 upgrade UI + icons | 5 new icons generated + provenance; 12/12 cards non-blank (A7); levelup overlay on CanvasLayer (screens.gd:22 pattern) | frontend/design | S4, S6 | A7 row passes → S7 |
| S6 boss | A5 row passes end-to-end (spawn, bar, trigger-fired attack clip, guaranteed Dawnlight) | code + test | S4, S5 | A5 passes → S7 |
| S7 export + release | web double-export rule (D§g) committed `static/index.*`; Windows `.exe` field-tested on VM120; `gh release` with assets on bryn1/hollow-dawn-3d (A8) | infra | — | A8 release row green → S8 |
| S8 final gates | full real-clock A1 (10-min run) + A2–A8 re-checked against THIS table with evidence level per row; LEDGER done line in same commit | test | — | all rows ≥ TESTED = project DONE |

Sequence rules: S4/S5/S6 never before S3's green suite (they'd fight a moving data layer); S6
never before S2's boss clip; S7 never before S4∧S5∧S6; two children never share a file (S1 owns
`assets/glb/`, S3 owns `godot/scripts/`, S5 owns `screens`+icons).

## (e) RISKS — the 3 ways this project most likely dies

| # | Death | Mitigation row |
|---|---|---|
| R1 | **Art pipeline stall** — TRELLIS.2 sits at the exact 24 GB ceiling (`RESEARCH-3D-3090.md:33,152-156`: expect OOM at 1536³) and UniRig skinning degrades on odd skeletons (`RESEARCH:64-65`) — post Route A that rig-risk lands on the TWO skinned classes only (player + boss); the horde classes ship as static decimated meshes and no rig is consumed for them (D§c). A blocked asset class still blocks S1 and everything downstream. | Per-asset gate at S1 (dump, not batch-blocking): ≤1024³ fp16 + `expandable_segments:True`, on OOM fall back TRELLIS-v1 (16 GB)/TripoSG (8 GB) (D§h); if the player OR boss rig degrades, that class drops to the transform row (A2 GAIT fallback / boss lunge-only) instead of a manual-bone-fix spiral; no other class depends on a rig at all. Batch off-peak, window never idle-open (GPU shared with the verifier, RESEARCH:147-151). |
| R2 | **Web perf wall** — the export target is gl_compatibility WASM, threads off (`project.godot:19-20`), and the real cost is the single-threaded tick (D§a); a build that ships without the per-class instancing rules hits ~300+ draw calls, and Route B (skinned horde) is ≈ 7× the draw cap at the concurrency margin (D§c). | The planned-33 / hard-cap-60 draw dump + ≥30 fps is S4's exit (measured with the profiler dump + rAF fps, not asserted); if the dump runs hot the levers are FX-draw trims (§i batches ≤ 7) and halo-MM merges — Route A ships ZERO enemy skinning, so no skinning lever exists (the old wight-pool lever is retired with it); blob shadows instead of a shadow pass are mandatory (D§b). |
| R3 | **Parity rot** — the spine is the v1 suite run VERBATIM against renamed/moved constants (D§d); a code child "tidying" `ENEMY_TYPES` or consolidating files (the rejected D§h option) silently turns the suite green-by-edit, and the 3D ship then carries *different numbers* than v1 — the exact contract the owner's "same game in 3D" ruling forbids. | S3 gate = the suite copied unedited (`git diff` against the v1 copy must be empty) BEFORE any refactor; biome-new rows N14–N45 are authored ONCE by the planner (this file) so no child invents thresholds; A8 provenance grep (0 assets without a 3090 log) closes the parallel risk of off-pipeline art. |

Open readings (planner, escalate not block): (1) the (c) gap note re hound/crawler/cultist models —
recommend building all 8; (2) player-alt as material-swap not 2nd model; (3) camera 20°-off-
straight-down pitch is D§'s call (D open readings), reversible, A2 strip is the check either way;
(4) A1's 600 s win path may be verified once by a real-clock test run, otherwise win-gate proven
by N2/N3 source pins + gameover journey.
