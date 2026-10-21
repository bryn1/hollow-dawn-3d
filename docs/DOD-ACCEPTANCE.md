# DOD-ACCEPTANCE — Hollow Dawn 3D (MC 11097, T-P2-3)

Plan against `docs/DESIGN-3D.md` (DESIGN-3D §a–§j cited below as "D§x", @ `10e7fe4`).
Owner mandate (verbatim): *"Make sure architect and planner makes a proper list of dods"*.
Owner DoD (verbatim): *"full playable game with animated player character, enemies, wepon
effects, boss and environment. Upgrade cards with appropriate images per skill."* + rulings:
top-down, 3090-only art, own repo + releases (`bryn1/hollow-dawn-3d`).
Baseline: v1 `/home/claudecode/Games/vampire_survivor` @ `562e0a1` (DESIGN-3D cites `aae77d6`,
an ancestor; every `file:line` below re-read from the working tree this session).
Convention: `file:line` citations are v1-relative. Test rig = Playwright (dsh browser MCP) on
the WASM export + `window.__vsSnapshot` (v1 `game_state.gd:87-104`) + `pytest tests/`.

## (a) OWNER ACCEPTANCE ROWS — checkable

Tester rig for A1–A7: serve `static/`, open `index.html` in Playwright, drive keys via the
v1 key-relay (`export_presets.cfg` head_include per D§g), read `__vsSnapshot` each tick.
Every screenshot artifact lands `.audits/<run>/out/` (never authored here).

| # | Owner ask | Tester types/runs | Output that proves it (artifact) | Numeric threshold |
|---|---|---|---|---|
| A1 | full playable game | Start (Enter), WASD 120 s, then die or win | snapshot.json trace + screenshots t=0/30/120/end + console dump | phase menu→playing→levelup→(playing)→gameover/win all observed in one trace; `time` monotonic; kills>0 by t=60; 0 console errors; fps (rAF counter) ≥ 30 @300+ enemies |
| A2 | animated player character | walk at full speed, attack; capture 3-frame strip of the player bbox | scene dump (`AnimationPlayer` clip list / bob params) + 3-frame PNG strip | skinned: ≥1 walk clip in AnimationPlayer dump; else procedural bob amp ≥ 0.045 m at 5.83 m/s (D§c); frame-diff at player bbox ≥ 2 px peak-to-peak between strip frames; at rest strip is pixel-stable (D§c test 1) |
| A3 | enemies | run t=0→600; screenshot the nearest unit of each type id | 9 per-class PNGs + snapshot kill-log per type | all 9 non-boss types spawn (4 gate types + wraith + 4 band signatures — see gap note under (c)); each per-class PNG passes D§c tests 1–3 (rest stable / walk ≥2 px delta / distinct attack pose) |
| A4 | weapon effects | pick all 6 weapons (drive levelup picks via keys 1-3), screenshot mid-fire of each | 6 FX PNGs + snapshot `weapons[]` row per weapon | each FX visibly painted (non-background pixels in FX area of PNG); live-count caps held (ember ≤8 bolts, cleaver ≤4 throws, spike ≤20 particles — D§i table); total frame draws ≤ 45 (Godot profiler dump row) |
| A5 | boss | survive to t=540 (or fast-forward the clock in a test build) | boss-bar PNG + snapshot enemy-count step + kill screenshot | boss spawns exactly once at time ≥ 540.0 (`world.gd:5,84`); hp 3000 (`world.gd:24`); name bar "THE HOLLOW WARDEN" visible (v1 `render.gd:206`); boss death drops ≥1 Dawnlight guaranteed (`world.gd:137`) + 50 gold (`world.gd:132`); boss mesh ≤15000 tris (bpy dump) with ≥1 attack clip or tween pose ≠ walk (D§c test 3) |
| A6 | environment | watch t=149→151, 299→301, 449→451; screenshot before/after each | 4 ground PNGs + banner PNG per band | ground albedo texture differs per band (pixel-mean ΔE measurable between PNGs); banner text = BIOMES name, alpha-up 3.0 s (`hud.gd:12`); band switch at t 0/150/300/450 exactly (`render.gd:68-77`) |
| A7 | upgrade cards w/ images per skill | force levelups until all 12 pool kinds offered; screenshot each card | 12 card PNGs + `make_offer` dump + icon byte-list | 12/12 skills render a NON-BLANK icon TextureRect (7 reused v1 PNGs + 5 new generated — D§j table); every new icon is 512×512 RGBA PNG with embedded prompt provenance (`impeccable embed-prompt` output row); no card shows the blank-icon path (`levelup.gd:35` gap closed) |
| A8 | rulings: top-down / 3090-only / repo+release | scene dump; provenance grep; `gh release view` | camera dump, PERMANENCE.md provenance table, release page text | camera = Camera3D, projection = Ortho, ortho_size 30.0, pitch 60° (D§a); every GLB/icon in `assets/` has a generation log naming the vm100 3090 tool (TRELLIS.2/imagegen) — 0 assets without provenance; repo `bryn1/hollow-dawn-3d` has a release with web zip + `static/index.*` + `.exe` attached (`gh release view` output) |

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

Pipeline shorthand (D§c, RESEARCH-3D-3090 §c): **T2** = TRELLIS.2 1024³ (fallback TRELLIS-v1/TripoSG
on OOM); **UR** = UniRig rig; **MC** = retargeted human mocap (MDM/T2M/MLD); **PROC** = procedural
bob/lean/yaw + attack tween (formula D§c); **IG** = imagegen MCP (Qwen-Image t2i, 512² transparent).
Every GLB lands `godot/assets/glb/`, every icon `godot/assets/icons/`; tri budget verified by a
headless `bpy` dump (bytes + tris printed, gate S1). Enemy instancing shares ONE 2048² atlas (D§b).

**GAP vs dispatch brief (stated reading):** the brief names "player, 4 band enemies, wraith, boss"
but v1 also spawns hound/crawler/cultist through the gate rotation (`world.gd:15-17,28`) — 9 enemy
models are required for A3 to pass; the manifest below carries all 9. If the orchestrator rules
only 5, A3's threshold drops to 6/9 types and the 3 gate types render as tinted wraith-mesh
placeholders (v1's placeholder principle, `render.gd:170-171`) — flag before art spend.

| asset | source v1 sprite | pipeline | size/tri budget | acceptance test |
|---|---|---|---|---|
| player | static/assets/player.png (MANIFEST.md:21) | T2→UR biped→MC walk/attack (else PROC) | ≤8000 tris; 1.0 m | A2 + D§c 3 tests; GLB dump ≤8000 tris |
| player-alt (Lv≥5 skin) | static/assets/player-alt.png (MANIFEST.md:22) | same rig, retextured albedo (no 2nd rig) | +0 tris (material swap) | swap visible in screenshot at level ≥5 (`render.gd:136` rule ported) |
| enemy-wraith | static/assets/enemy-wraith.png (:23) | T2→UR best-effort→PROC | ≤1500 tris; 0.85 m | D§c tests 1–3, PNG in run dir |
| enemy-hound | static/assets/enemy-hound.png (:24) | T2→PROC | ≤1500 tris | D§c tests 1–3 |
| enemy-crawler | static/assets/enemy-crawler.png (:25) | T2→PROC | ≤1500 tris | D§c tests 1–3 |
| enemy-cultist | static/assets/enemy-cultist.png (:26) | T2→UR biped→PROC | ≤1500 tris | D§c tests 1–3 |
| moor-brute | static/assets/enemies/moor-brute.png (:36 dir) | T2→UR+manual bone fix→PROC | ≤4000 tris | D§c tests 1–3 |
| dune-scarab | static/assets/enemies/dune-scarab.png | T2→UR general→PROC scuttle | ≤1500 tris | D§c tests 1–3 |
| rime-ghoul | static/assets/enemies/rime-ghoul.png | T2→UR+bone fix→PROC | ≤4000 tris | D§c tests 1–3 |
| pale-wight | static/assets/enemies/pale-wight.png | T2→UR+bone fix→MC pool ≤8 skinned (D§c) | ≤4000 tris | D§c tests 1–3 + pool dump ≤8 AnimationPlayers |
| boss-warden | static/assets/boss-warden.png (:27) | T2 1024³ (1536³ only if VRAM probe passes)→UR→MC+attack clip | ≤15000 tris; 3.2 m | A5 + D§c test 3 |
| gem pickup | static/assets/gem.png (:36) | T2 small prop | ≤300 tris, instanced | visible at 14 px-equiv (N42) |
| coin pickup | static/assets/coin.png (:35) | T2 small prop | ≤300 tris, instanced | visible at 14 px-equiv |
| dawnlight | (v1 procedural draw, render.gd:175-182) | PROC additive billboard quad, DAWNLIGHT colour (render.gd:18) | 0 GLB | A5 heal-drop screenshot glow ≥ v1 alpha 0.25/0.40 (render.gd:53) |
| blob shadow | (new, D§b) | PROC quad | ≤6 tris ×1 MultiMesh | 1 draw call in profiler dump |
| talon FX mesh | arc poly (render.gd:143-148) | T2 prop (whip/talon arc) + ground decal | ≤500 tris, 1 mesh+decal | A4 row 1 |
| ember bolt FX | circle fx (render.gd:151-152) | emissive orb mesh + CPUParticles trail | ≤200 tris ×≤8 live | A4 row 2 |
| cleaver FX mesh | throw rect fx (render.gd:153-157) | T2 bone-axe prop, spin+parabola (lift render.gd:155) | ≤500 tris ×≤4 | A4 row 3 |
| halo FX mesh | halo circles (render.gd:149-150) | PROC orbiting ember quads MultiMesh | ≤4 quads | A4 row 4 |
| ward FX | ring fx (render.gd:123-124,145-148) | PROC ground ring-pulse decal | 1 decal | A4 row 5 |
| spike FX | burst fx (render.gd:158-160) | PROC shard particles under cluster | ≤20 particles 1 emitter | A4 row 6 |
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
| S0 stack install (running, MC 11096) | `tools/VERSIONS.txt` pins godot/TRELLIS.2/UniRig/blender versions; `godot --headless --version` + 1 smoke GLB from a TRELLIS.2 512³ test run on vm100, byte-counted | infra | (already running) | smoke GLB exists → S1 |
| S1 art batch (models) | every GLB row of (c) exists in `assets/glb/` + bpy dump prints tris ≤ budget + 1 concept render per asset; PERMANENCE.md provenance row per asset | code/design | S3, S5-icons | tri-budget dump all-green → S2 |
| S2 rig/anim | player+boss GLBs import with AnimationPlayer ≥1 clip (scene dump); wight pool ≤8 skinned (dump); per-class 3-frame strips pass D§c tests 1–3 | code/design | S4 | 10 per-class strip PNGs accepted → S6 may start |
| S3 scene + core loop (first green build) | Main.tscn per D§a (ortho 30, 60° pitch); placeholder meshes OK; **ported `tests/test_game_numbers.py` runs VERBATIM green** + `test_biome_numbers.py` (new pins N14–N45) green; a full sim run (headless, seeded) reaches win/gameover | code + test | S1, S5 | verbatim suite green → S4/S5/S6 |
| S4 combat + effects | 6 FX screenshots (A4) + profiler draw-call dump ≤45 with 300 enemies + fps ≥30 on web build | code/frontend + test | S5, S6 | A4+A1 fps rows pass → S7 |
| S5 upgrade UI + icons | 5 new icons generated + provenance; 12/12 cards non-blank (A7); levelup overlay on CanvasLayer (screens.gd:22 pattern) | frontend/design | S4, S6 | A7 row passes → S7 |
| S6 boss | A5 row passes end-to-end (spawn, bar, attack pose, guaranteed Dawnlight) | code + test | S4, S5 | A5 passes → S7 |
| S7 export + release | web double-export rule (D§g) committed `static/index.*`; Windows `.exe` field-tested on VM120; `gh release` with assets on bryn1/hollow-dawn-3d (A8) | infra | — | A8 release row green → S8 |
| S8 final gates | full real-clock A1 (10-min run) + A2–A8 re-checked against THIS table with evidence level per row; LEDGER done line in same commit | test | — | all rows ≥ TESTED = project DONE |

Sequence rules: S4/S5/S6 never before S3's green suite (they'd fight a moving data layer); S6
never before S2's boss clip; S7 never before S4∧S5∧S6; two children never share a file (S1 owns
`assets/glb/`, S3 owns `godot/scripts/`, S5 owns `screens`+icons).

## (e) RISKS — the 3 ways this project most likely dies

| # | Death | Mitigation row |
|---|---|---|
| R1 | **Art pipeline stall** — TRELLIS.2 sits at the exact 24 GB ceiling (RESEARCH-3D-3090:33,154: OOM at 1536³) and UniRig skinning degrades on non-humanoids (RESEARCH:64-65, scarab legs/hunched ghoul/wight). A blocked asset class blocks S1 and everything downstream. | Per-asset gate at S1 (dump, not batch-blocking): ≤1024³ + fp16 + expandable_segments; TripoSG/TRELLIS-v1 fallbacks already researched (RESEARCH:101-103); every non-player/boss class has the PROC fallback designed into D§c, so a failed rig degrades to bob/lean/tween, never to a missing enemy. Batch off-peak (GPU is shared with the verifier, RESEARCH:147-151). |
| R2 | **Web perf wall** — the export target is gl_compatibility WASM, threads off (`project.godot:19-20`); a skinned 300-enemy horde is impossible (D§b), and the first web build that ships without the instancing rules will hit ~300 draw calls. | The ≤45-draw / ≥30 fps gate is S4's exit (measured with the profiler dump + rAF fps, not asserted); wight skinned pool ≤8 is the first lever to cut when the dump runs hot; blob shadows instead of a shadow pass are mandatory (D§b). |
| R3 | **Parity rot** — the spine is the v1 suite run VERBATIM against renamed/moved constants (D§d); a code child "tidying" `ENEMY_TYPES` or consolidating files (the rejected D§h option) silently turns the suite green-by-edit, and the 3D ship then carries *different numbers* than v1 — the exact contract the owner's "same game in 3D" ruling forbids. | S3 gate = the suite copied unedited (`git diff` against the v1 copy must be empty) BEFORE any refactor; biome-new rows N14–N45 are authored ONCE by the planner (this file) so no child invents thresholds; A8 provenance grep (0 assets without a 3090 log) closes the parallel risk of off-pipeline art. |

Open readings (planner, escalate not block): (1) the (c) gap note re hound/crawler/cultist models —
recommend building all 9; (2) player-alt as material-swap not 2nd model; (3) camera 60° pitch is
D§'s call, reversible, A2 strip is the check either way; (4) A1's 600 s win path may be verified
once by a real-clock test run, otherwise win-gate proven by N2/N3 source pins + gameover journey.
