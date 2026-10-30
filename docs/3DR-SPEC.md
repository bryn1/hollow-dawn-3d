# 3DR-SPEC — hollow-dawn-3d "3D REMAKE" milestone (v4.0.0 proposed) — build-depth spec for the DA gate

- **REV 1, 2026-10-30, MC 11720 (`design`).** Base: `origin/master = cb4a95e` (v3.1.0 GA
  `007f04e` + clean-code cycle 4 close — the first clean NEXT-MILESTONE base: the owner's
  clean-code-after-milestone doctrine (2026-10-25) is SATISFIED on this base: audits
  `docs/CLEAN-CODE-AUDIT*.md` + refactor cycle 4, all four cycles closed with MEASURED
  footers; no next-milestone spec on a dirty base — the law holds, stated here so the DA
  can re-check it).
- **Cite convention (DESIGN-3D §Cites precedent, `docs/DESIGN-3D.md:9-13`):** `DESIGN-3D.md`
  and `RESEARCH-3D-3090.md` are the V1-repo (`../vampire_survivor`) docs; citations to them
  are path-relative to THAT repo. Citations `file.gd:NN` without a repo name are THIS repo,
  re-grepped THIS session (all code-truth greps listed in §0 ran on `cb4a95e`).
- **Clean-room stance (inherited, binding):** `docs/VS-FEATURES.md` shapes only; every id,
  name, number, color and threshold below is OURS and pinned by OUR suite.
- **docs/ARCHITECTURE.md:** ABSENT by repo precedent (M6-SPEC:172-173 verbatim — the repo runs
  its own spine: LEDGER + DESIGN-3D + PARITY-ROADMAP + M*-SPEC). Cite, do not rewrite; no
  ARCHITECTURE.md is created by this milestone (§7).
- **Length note (exceeds the ~300 hygiene line, stated why):** one pointable build-depth
  artifact for one milestone (M6-SPEC 1339 L / M5 856 L / M4 782 L precedent); each section is
  self-contained so the DA can gate one at a time. Hard cap 1200 L per the MC 11720 brief.

## OWNER ORDER (verbatim, binding)

1. **The founding ruling (MC 11094, 2026-10-21), verbatim — typos intact, the artifact is quoted, never corrected, the WHOLE quote on ONE line so the pin-greps match it whole (the SD-E6 quote-cell law):** *"a 3d remake. Same type of viduals, top down, but with chatacter animations, movements. 3090 only with best possible model doing the word regardless of time taken."* (Quoted identically at DESIGN-3D:4-5 and RESEARCH-3D-3090:3-5.)
2. **The re-confirmed order (2026-10-30), verbatim:** *"3d remake first then m7"* →
   3DR runs BEFORE M7; the M7 trio (§7) is named, never scheduled here.
3. **The statue-class ruling already on the record (M6 owner package, 2026-10-29), verbatim:**
   *"Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy"* — item 1 → M6-SPEC §1.5 RULED
   option (c) RE-MASTER + RE-RIG for the six statue-class statics, ruled in as the separate
   card T-M6a-STATUE (M6-SPEC REV 4 header; `docs/RELEASE-v3.1.0.md:97-99` names it THE
   promised-not-shipped item, "parked on the owner's vm100" backup window). 3DR is the
   milestone that card rides into (§0.3).

**DECLARED READING (stated, per the stop condition — ambiguity = state the reading):** the
founding ruling's "character animations, movements" is the milestone's contract. The sim,
the data layer, the camera law and the horde law already shipped (v1.0.0→v3.1.0). What is
NOT shipped under that ruling is the last animation gap the repo itself names: the six
statue-class hero pawns that walk as static meshes with procedural bob (owner-"Rec" pin,
`docs/RIG-DEVIATION-SEL-C.md`), the promised-not-shipped row of v3.1.0. 3DR therefore =
(a) the declared scene-arch TRUTH of the 3D path in THIS repo (§1 — the DESIGN-3D fold, incl.
its dated supersession rows), (b) the corpus law that keeps the byte-anchored sim untouched
while the 3D capture corpora re-anchor (§2), (c) the statue re-master + re-rig batch landing
through the ONE existing animation consumer (§3), (d) FX-identity law (§4), (e) the wave
(§5), version + release trio (§6), exclusions (§7), acceptance (§8). Overturning the reading
= re-scoping what the repo's own release notes call unshipped; the DA attacks here first.

## 0. FINDINGS + CODE TRUTH (every claim re-grepped THIS session on cb4a95e — read before the DA opens any section)

- **F-1 ONE animation consumer, verbatim truth:** `CLIP_SOURCE` appears in exactly TWO script
  files — `godot/scripts/roster.gd` (the ONE table, `:161-183`, + the ONE getter `clip_source()`
  `:182-183`) and `godot/scripts/hero_pawn.gd` (the ONE consumer: `Roster.clip_source(
  _player_glb())` at `:174`, the AnimationPlayer seek `:199`, the gait-rate law
  `speed_scale = minf(spd / HordeViz.GAIT_STRIDE_M, GAIT_FREQ_MAX)` at `:231`). No sim file,
  no horde file reads it. THE 3DR LAW: rigged statue rows flip INSIDE that ONE consumer;
  zero new mechanism, zero edit to `hero_pawn.gd` (§1.3).
- **F-2 The six statics pin:** `roster.gd:161-183` — 14 rows: 8 clip rows (`player.glb` with
  the `visual: "player-rigged.glb"` twin + char-emberwright / grave-ward / duskrunner /
  iron-penitent + skin-ash / marrow / relic) and 6 `null` rows — char-coinhound,
  char-tallow-seer, char-shroud-saint, char-hoard-wretch, skin-tide, skin-void — each
  `# statue-class static (owner "Rec")`. The pin doc that tests parse:
  `docs/RIG-DEVIATION-SEL-C.md` (7 rigged / 6 static, owner "Rec" 2026-10-27, MC 11440);
  the parsing tests: `tests/test_characters.py:420-451` (B-E8 family) + `tests/test_skins.py:26,117`.
- **F-3 The gait law (the ONLY transform-gait mechanism):** `horde_viz.gd` — per-class
  `_freqs[key] = minf(def.spd / CameraRig.PX_PER_M / GAIT_STRIDE_M, GAIT_FREQ_MAX)` (`:153`),
  stride 1.2 m / 2.2 Hz cap (`:79-80`), the M6 bob+lean (position-keyed), the hit_cd lunge edge
  with `if e.boss: boss_pulses += 1 # the boss rides THIS edge, no second path` (`:205-206`).
  16 horde/boss/miniboss/reaper classes ride `GLB_FILES` (`:41-63`) — MultiMesh, rest-pose
  mesh, transform gait. MultiMesh cannot skin (DESIGN-3D §c, binary-VERIFIED fact); skinned
  horde = Route B, REFUTED by the §b draw math and SURVIVING the c3 DA gate — stays REFUTED.
- **F-4 Camera truth:** `camera_rig.gd` (33 L) — `PX_PER_M := 24.0` (`:12`),
  `CAM_OFFSET := Vector3(0.0, 37.6, 13.7)` (`:14`), `PROJECTION_ORTHOGONAL` + `size` (`:22-23`),
  pitch `PITCH_DEG` (`:27`), and the XZ follow `position = Vector3(game.player.x / PX_PER_M,
  0.0, game.player.y / PX_PER_M)` (`:33`) — the DESIGN-3D §a law is literally this file.
- **F-5 Ground truth:** `ground.gd` (54 L) + `shaders/ground.gdshader` — the single quad
  re-centred on the camera, world-locked tiled UV, band swap through the ONE
  `GameRenderer.band_at(game.stage, game.time + game.flare)` (`ground.gd:37,47-49`).
- **F-6 SKILL_FX truth:** `viz_fx.gd` (571 L) — `const SKILL_FX` (`:71`) = 26 rows, one per
  fireable id (measured: 15 weapons + 11 evolutions incl. requiem-toll / dirge-eternal /
  eternal-matins / red-wail / the-sluice / judgement-cross), the ONE dispatch site (grep
  `SKILL_FX` → 9 sites, all in `viz_fx.gd` + its header comment).
- **F-7 Byte-anchor truth:** `sim_headless.gd:104` `seed(s.to_int() if s != "" else 11101)`;
  the committed journey anchor = 5071 rows md5 `5d863b80…` (post-M6, LEDGER T-M6z row);
  strict fixtures in `tests/fixtures/`: 15 files (13 strict jsonl + art-s2i-probe.jsonl +
  2 framediff CSVs, measured this session: art-s2i 31 rows, roster-clips CSV 55 lines).
- **F-8 LOC truth (measured this session):** sim-side `world.gd` 450, `game_state.gd` 314,
  `drops.gd` 263, `roster.gd` 416 (reason header names the SCHEDULED `roster_clips.gd` split,
  owned by the statue ruling — §3.4); render-side `horde_viz.gd` 392, `hero_pawn.gd` 255,
  `pickup_viz.gd` 351, `viz_fx.gd` 571, `class_mesh.gd` 112, `render.gd` 231 (data module —
  tables + palette + `biome_at/band_at/tint_of`, zero draw calls since M6 §7.2), `hud_3d.gd`
  290, `ground.gd` 54, `camera_rig.gd` 33; `main.gd` 599 (wiring seam — reason header,
  WATCH row); `screens.gd` 601.
- **F-9 The GPU stack + windows truth:** TRELLIS.2 + UniRig installed on vm100 (LEDGER
  T-P2-1 row, "one imagegen spine, no second zoo"); the window laws (drain_barrier,
  single-row, trap-close rc=0, verifier serving at every close, rc-is-not-truth) are LEDGER
  facts from T-S1a/T-S1p/T-M6b — §5.4 carries them as LAW rows.

## 1. SCENE ARCH — the 3D path AS IT LIVES IN THIS REPO (the DESIGN-3D fold)

### 1.1 The split: render side vs sim side (the brief's named files)

**The law: the sim stays the byte-anchored XZ truth; everything 3D is render-side and READS the
sim, never the reverse.** The sim's `(x, y)` plane maps to the 3D world `(x, 0, y)` at
`PX_PER_M = 24.0` (`camera_rig.gd:12,33`) — v1's every-hit-is-a-distance-test law (DESIGN-3D §a)
unchanged; 2D physics on the XZ plane stays the only physics (no 3D physics engine enters the
milestone — rejected, §7.3-R1).

| side | files (godot/) | 3DR touch law |
|---|---|---|
| **SIM (byte-anchored truth)** | `scripts/game_state.gd` 314, `scripts/world.gd` 450, `scripts/drops.gd` 263, `scripts/weapons.gd`, `scripts/levelup.gd`, `scripts/evolutions.gd`, `scripts/union.gd`, `scripts/chest_rewards.gd`, `scripts/powerups.gd`, `scripts/achievements.gd`, `scripts/save.gd`, `scripts/bridge.gd`; rule side of `scripts/roster.gd` (CHARACTERS/SKINS/rules); all of `sim/sim_*.gd` dump drivers + `sim/sim_funnel.gd` (the shared seam, kb MC 11317) | **ZERO BYTES** — the strongest acceptance row (§8 A-1) is the journey + strict corpus `cmp`-identical proof that this stayed true |
| **RENDER (the 3D truth)** | `scripts/camera_rig.gd` 33, `scripts/ground.gd` 54 + `shaders/ground.gdshader`, `scripts/class_mesh.gd` 112, `scripts/horde_viz.gd` 392, `scripts/hero_pawn.gd` 255, `scripts/pickup_viz.gd` 351, `scripts/viz_fx.gd` 571, `scripts/hud_3d.gd` 290, `scripts/render.gd` 231 (data module), `scripts/main.gd` 599 (wiring); UI: `scripts/screens.gd` 601, `roster_select.gd`, `achievements_page.gd` | touched ONLY through §5's card-ownership matrix; `hero_pawn.gd` and `horde_viz.gd` stay ZERO-EDIT (§1.3, §3.5) |
| **ART** | `assets/glb/*.glb` (43 live + superseded archive dirs), `assets/art-src/` (turntable refs), `assets/concepts/`, `assets/anim/maps/*.json`, `assets/biomes/` | §3's coverage table + the art gates |

### 1.2 The declared 3D render path (each line = DESIGN-3D law → the live file this session)

- **Node3D world + ortho rig:** one `Camera3D`, PROJECTION_ORTHOGONAL, size 30.0, pitch 20°,
  offset `Vector3(0, 37.6, 13.7)`, S = 24 px/m, field ≈ 53.3 × 31.9 m — `camera_rig.gd` (F-4)
  IS DESIGN-3D §a; sizes DERIVED from the v1 size table (player 40 px → 1.7 m, enemy 34 px →
  1.45 m, boss 128 px → 5.4 m) via `class_mesh.gd` height-normalisation (`:19-28`).
- **Ground quad + world-locked tiled shader:** `ground.gd` + `shaders/ground.gdshader`, tile
  1024 px ÷ S = 42.7 m world-locked; the 4 biome tiles byte-carried; band = the ONE
  `band_at(stage, t)` (`ground.gd:37,47-49`) — DESIGN-3D §a carried.
- **GLB pawns via the ONE CLIP_SOURCE consumer:** hero pawns (player row 0 + 8 chars + 5 skins)
  through `roster.gd` `CLIP_SOURCE` → `hero_pawn.apply_selection()` (`:84-100`) → the ONE
  `_player_mesh()` seam (`:129`) + the ONE `Roster.clip_source()` read (`:174`); rigged rows
  grow ONE visual child (GLB scene + AnimationPlayer), static rows take the procedural arm
  (the SAME §1.2 gait law — M6-SPEC:135); **no second animation path may be added** (§1.3).
- **The horde/boss law:** 16 classes as GLB MultiMeshes under the ONE transform-gait law
  (F-3); the boss is ONE instance of the per-class swap at MODEL_H_BOSS riding the same lunge
  edge (horde_viz header:2-20, `:205-206`) — DESIGN-3D §b's older "player 1 + boss 1 separate
  draws" row is SUPERSEDED (dated fold, §1.4 row D-3): the S6 law shipped and survives.

### 1.3 THE MECHANISM-MONOGAMY LAW (the brief's "NO second animation path", binding on every card)

Repo-wide today `CLIP_SOURCE` has TWO script homes (F-1). The 3DR law, one sentence: **every
rigged asset 3DR ships becomes a row FLIPPING from `null` to a clip row inside the ONE
`CLIP_SOURCE` table and plays through the ONE `hero_pawn` consumer — a card that adds any
other clip source, other AnimationPlayer site, other gait mechanism or per-mob skinned path is
a P0 by this spec's law.** Corollaries, each = reuse of a shipped mechanism:
- rig flips change `roster.gd` rows ONLY + the scheduled seam file (§3.4) — `hero_pawn.gd`
  ZERO edits (it already branches on the map at `:174`; a rigged statue is a data change);
- the procedural arm (M6 §1.3) stays the fallback for any double-fail (§3.3) — reuse, not a
  new mechanism;
- the skinned boss twin (M5 `boss-warden-rigged.glb`, 46 joints, RIG_VALID) stays
  CAPTURE-ONLY provenance; an in-game skinned boss would need a second consumer (Route B
  shape) — declared NOT-in-scope (§7.3-R2) with the §b draw math as the price.

### 1.4 DESIGN-3D CITATION TABLE (fold, do not re-litigate — dated supersession rows included)

| row | DESIGN-3D (v1 repo) | status in THIS repo at cb4a95e |
|---|---|---|
| D-1 | §a scene (ortho 20° rig, S=24, derived sizes, ground quad, 2D-on-XZ) | LIVE as §1.1-1.2 (camera_rig.gd / ground.gd / class_mesh.gd, F-4/F-5); cycle-1's 1.0/0.85/3.2 m sizes + `orthographic_size` were WITHDRAWN pre-port (DESIGN-3D:33, :22) — stay withdrawn |
| D-2 | §b draw budget (plan 40, hard cap 60; measured 28 at M6 re-tally, LEDGER T-M6r) | LIVE — the budget law; §8 A-9 re-runs the tally |
| D-3 | §b "player 1 + boss 1 separate draws" | **SUPERSEDED (dated: S6 shipped 2026-10-23)** — the boss rides the horde per-class swap + same lunge edge (F-3); folded, not re-litigated |
| D-4 | §c Route A (transform gait; skinned = player + boss only) + gait law | **LIVE-as-Amended (dated: M5/M6)** — Route A + lunge shipped; skinned live for the HERO/pawn universe through CLIP_SOURCE (M6 §1.1); gait law horde_viz:153,183 (F-3); "boss skinned in-game" rides D-3 |
| D-5 | §d numbers = verbatim v1 data port; `tests/acceptance_suite.js` 29 checks ported | LIVE (sim side, §1.1) — 3DR touches ZERO data-layer bytes; the suite stays green (§8 A-1) |
| D-6 | §e server NOT ported (leaderboard deferred) | LIVE — the leaderboard rejoins the M7 trio by name (§7.1), nothing scheduled |
| D-7 | §f file layout (the ported spine) | SUPERSEDED BY §1.1 (dated: this milestone restates the split against THIS tree — layout v2 shape, no ARCHITECTURE.md, repo precedent) |
| D-8 | §g export chain (WASM + Windows, rAF software floor) | LIVE — both targets ship from the tagged tree (§6.2); VM120 field-test row declared (§8 B-3) |
| D-9 | §h rejected alternatives (Meshy; skinned horde Route B; perspective; Mixamo) | LIVE as REJECTED (§7.3) — Route B REFUTED by the §b math, DA c3 upheld; Hunyuan rides the §3.1 stack exclusion row |
| D-10 | §i weapon FX one-row-per-skill table → §j card icons | LIVE-as-Amended (dated: M6 F2) — the §i table IS `viz_fx.gd SKILL_FX` (F-6), 26 rows; §4 carries the identity law |

## 2. THE CORPUS LAW — HOLD vs RE-ANCHOR (the deviation-doc-as-pin mechanism, REUSED not re-invented)

### 2.1 The HOLD list — byte-unchanged, this milestone (sim unchanged → no fork to forgive)

3DR edits ZERO sim bytes (§1.1's law) ⇒ no RNG consumer, no pool, no drop order, no schedule
moves ⇒ unlike M6 (which legitimately shifted channels BY DESIGN and paid the full §9 ledger
+ 16-row ratified doc), **3DR's committed sim corpora HOLD byte-identical — no shift is
declared and an unexplained byte moved is a FAIL exactly as in M1–M5.** The HOLD list, named
per the brief (each row = the instrument `cmp` + the owner-ratification row that CANNOT exist
for it — a HOLD channel needs no ratification, "n/a — no shift"):

| channel | 3DR verdict | instrument |
|---|---|---|
| journey-5071 @`HD3D_SEED=11101` (F-7) | **HOLD byte-identical** | `sim_headless` dump `cmp` vs the committed anchor (md5 `5d863b80…`), every 3DR card's battery |
| 13 strict fixtures: `carry-caps-m1b, chests-evolve-m1e, chests-tiers-m2, endless-m2, events-m4, gem-merge-m2g, limit-m4, reaper-m4, stages-m3, unions-m2u, achv-m5, chars-m5` (.jsonl) | **HOLD byte-identical** | `cmp` per channel (the BYTE-DEVIATION-M6 leak-check idiom: channels the deviation doc does NOT name must still `cmp` identical — here ALL 12 + journey do) |
| `skinned-clips-s2r-framediff.csv` | **HOLD** | its sources are player + warden rigged twins — untouched by 3DR (statue twins are NEW files, §3.2) |
| strips dumps (75) + strips gate 19 checks + `SKILL_FX` probe Tables 3/3, 6/6, 26/26 | **HOLD** (horde + FX-side byte-identical sources; the pawn flip cannot move them — §4) | the shipped gates re-run green, twice-cmp |
| biome-readability grid (9/9 anchor + 44-window mob grid, F7 floors) | **HOLD** (mob side + default-pawn captures unaffected; the readability floors CARRY, §2.3) | shipped gate re-run |
| s8 gameover/win dumps | **HOLD contract-checked** (the standing declaration, BYTE-DEVIATION-M6:21 — runtime records, contract checks, not byte) | `tools/s8_acceptance.py` |

### 2.2 The RE-ANCHOR list — the NEW 3D capture corpora (re-measured under the flipped meshes)

The channels whose SUBJECT 3DR legitimately moves (the pawn rigs + their meshes). Format =
the M6-SPEC §9 pre-declared table, reused; per-row measured diff lands in the new pin doc
(§2.4) by the shifting card's FIRST commit, per F-9/M6 law (deviation doc FIRST).

| channel | 3DR verdict | why (mechanism + cite) |
|---|---|---|
| `roster-clips-m5-framediff.csv` (55 lines) | **REMINT** | the six statue rows' motion IS 3DR's subject: a flipped row flips from EXCUSED-0px to a >=2px motion row (or stays EXCUSED under a double-fail §3.3 — the REMINT records whichever outcome the pin doc carries); driver `tools/roster_clip_gate.py` re-measures, twice-cmp |
| `art-s2i-probe.jsonl` (31 rows) | **REMINT (heights only)** | six `CHARACTERS/SKINS` mesh-literal rows RE-MEASURE live heights on the re-mastered v3 files (the probe enumerates `Roster.CHARACTERS` + `SKINS` + `HordeViz.GLB_FILES`, art_probe.gd — M6 §9 NF-2's honest row); row-0 player + all horde rows byte-PRESERVED (the forward-lock law: prior rows byte-preserved, subject rows carry the measured diff) |
| roster-capture + dawnwell pixel-gate character shots | **RE-MEASURE, expect STAY** | portraits/silhouettes unchanged (icons untouched); legs re-run green, committed PNGs STAY; a diff = a finding, not a re-anchor |
| motion-capture shots (bob/lean) | **RE-MEASURE, expect STAY** for rigless arms; the flipped pawns' walk frames ride the CLIPS now — new shots, fresh baselines recorded into the pin doc (not a committed-corpus channel — shot PNGs, the s8-style contract row) |

### 2.3 Readability floors CARRY, F7-style (the brief's "floors carried")

The two shipped floors stay the acceptance instrument for the flipped pawns, with their
committed constants UNCHANGED: the MOB CONTRAST law (F7 — RATIO_MIN 2.0 as the ONE const,
`tools/biome_readability.py`, all 8 mob classes findable) and the SKILL_FX readability floor
(alpha × luma >= 0.22 — the T-M6c measured floor, BYTE-DEVIATION-M6 §table row) stay verbatim;
the flipped statues must pass them WITHOUT floor edits — a flipped pawn that muddies its
concept shot is a re-master finding (§3.3's VISUAL gate is the first line of defence, the F7
grid the second). Pure-red ceiling-clamp honesty + the twice-cmp crop-anchor determinism law
carry verbatim (kb VERIFIED 2026-10-29).

### 2.4 The deviation-doc-as-pin, with the OWNER-RATIFICATION law CARRIED VERBATIM

Mechanism REUSED, not re-invented (M6-SPEC §9 + the M5 B-E8 planted-red precedent, kb
"deviation-doc-as-pin pattern, VERIFIED via planted-red MC 11440"). The new pin artifact:
**`docs/CAPTURE-DEVIATION-3DR.md`** — T-3DR-c's FIRST commit, structure per §2.2's channels:
`{channel, shifting card, mechanism (one line, cites this spec's section), declared diff,
STAY rows, OWNER-RATIFICATION cell}`. The M6 law carried VERBATIM into the doc's header
(the SD-E6 contract, BYTE-DEVIATION-M6:38-44): *"every declared SHIFTS / REMINT / RE-DERIVE
channel's OWNER-RATIFICATION cell carries the verbatim quote + the date … a NON-EMPTY cell is
the gate contract … **an EMPTY ratification cell on a declared shift ⇒ the leg RED**"* —
**the empty-cell blocks-close rule**: no card whose channel row carries an unratified declared
shift CLOSES green; the ask text (§2.2 table → owner package, web UI) must return the owner's
verbatim answer (typos intact, pasted never corrected) into every shifting row before close;
HOLD/STAY rows carry `n/a — no shift` and need nothing. The parse-instrument = the shipped
SD-E6 idiom extended to parse the new doc (one mechanism, new doc path — the leg parameterised
by doc path, NO second table parser), with the shipped planted-red: empty cell on a REMINT
row on a COPY ⇒ RED (the committed doc is never mutated).

## 3. ART LAW — the 3090-only MIT stack; coverage; rig-yield; the statue batch

### 3.1 THE STACK (RESEARCH-3D-3090 pinned law — v1 repo `docs/RESEARCH-3D-3090.md` §a/§d, cited)

Owner's "3090 only with best possible model … regardless of time taken" is READ as the
research doc read it: batch-offline exclusive-window generation on the fleet 3090 (RESEARCH
header: the GPU window is shared with the verifier, which is PAUSED while open), MIT-clean
models only, slow-accept beats fast-reject.

| slot | CHOSEN (MIT) | runner-up / fallback | REJECTED — why (dated law) |
|---|---|---|---|
| image→3D | **TRELLIS.2 (4B)** — SOTA, MIT, 24 GB = the 3090 ceiling exactly; installed on vm100 (LEDGER T-P2-1) | TRELLIS v1 / TripoSG (MIT, comfortable at 24 GB) | **Hunyuan3D-2.1 / 2.0 — EXCLUDED: the Tencent Community License carves out EU/UK/SK (no EU distribution) AND 2.1 wants 29 GB > 24 GB** (RESEARCH §a/§d; the owner ships browser+desktop builds — a license-excluded generator's outputs are a distribution risk, not a maybe); Meshy/Tripo API — CLOUD, contradicts "3090 only" |
| auto-rig | **UniRig-2D** (MIT) — the shipped consumer (13 M5 meshes: 7 rigs, 28-53 joints) | TripoSG-rig / manual | Mixamo — upload-based EULA, no commercial redistribution certainty (RESEARCH §b) |
| motion | **CMU mocap via `tools/mocap/` 05/06 (MIT)** + procedural arm | hand-keyed | text→motion (MDM/T2M-GPT) — **overkill: the game needs WALK+ATTACK, mocap already ships it** (RESEARCH §c verbatim "overkill … if mocap + procedural covers all needs, T2M adds risk") |
| textures | TRELLIS-painted, carried through UniRig merge (PROVEN: the M5 rigs keep texture refs through the merge, LEDGER T-M5r row) | — | — |

### 3.2 COVERAGE TABLE — per mob/hero class (the brief's ask), states AS OF cb4a95e → 3DR target

| universe | classes | state @cb4a95e | 3DR target | mechanism |
|---|---|---|---|---|
| hero row 0 (player) | `player.glb` + `player-rigged.glb` twin | RIGGED (walk clip live, byte-identical promotion) | HOLD | the ONE consumer |
| hero chars (8) | emberwright, grave-ward, duskrunner, iron-penitent | RIGGED walk+attack | HOLD | ONE consumer |
| | coinhound, tallow-seer, shroud-saint, hoard-wretch | **STATIC (owner "Rec")** | **RE-MASTER + RE-RIG (ruled: "Ibwant skeletons with movements.")** | ONE consumer — rows flip `null`→clip (§3.4) |
| skins (5) | ash, marrow, relic | RIGGED | HOLD | ONE consumer |
| | skin-tide, skin-void | **STATIC (owner "Rec")** | **RE-MASTER + RE-RIG** | same |
| boss twins | player-rigged + boss-warden-rigged (M5) | capture-proven (framediff CSV) | HOLD (capture-only provenance — §1.3 corollary) | n/a |
| mobs (16 horde/boss/miniboss/reaper) | wraith…the-reaper (`GLB_FILES`) | ROUTE-A transform gait + lunge | **HOLD — BY LAW** (MultiMesh cannot skin; Route B REFUTED §7.3-R1) | the ONE gait law |

"Rigged already" = 8 pawns; "statue batch" = 6 rows (4 chars + 2 skins), the ruled re-rig
(T-M6a-STATUE's subject); "new masters" = the six NEW reference artworks the re-rig requires —
option (c) changes the INPUT (M6-SPEC §1.5 REV-4 scope note: the rig-yield law is a law about
RETRIES on the same mesh + seed-fixed 12345, not about new inputs), so each failed class gets
a NEW ref carrying the riggable wording family.

### 3.3 RIG-YIELD LAW + TWO-FAIL STOP + THE OWNER-VETOABLE STATIC FALLBACK (all REUSED)

Carried verbatim from the shipped law (RIG-DEVIATION-SEL-C + M6-SPEC §1.5 + kb fleet fact,
VERIFIED across 13 meshes): UniRig inference collapses DETERMINISTICALLY on sculpture-class
geometry (seed-fixed 12345 — retries do not change the result); the ref wording that yields
riggable skeletons (kb, the emberwright/grave-ward family): *"arms flat at sides, two legs
visible (robe opening), censer/props carved flush as relief"* + the fused-lantern bell-robe
line for skins. Honest odds stay stated: LOW-TO-MODERATE, LOW for the shroud/quadruped/wing
classes (tallow-seer-v2 carried the fused-arms wording and still collapsed — the wording is a
LEAD, not a promise). THE LAWS:
- **TWO-FAIL STOP (per character):** mesh stage 2 fails OR rig stage 2 fails ⇒ the class
  STOPS, no further burns; mesh reserve law CARRIED: **1/3 reserve HELD — a fourth burn needs
  a new owner word** (RIG-DEVIATION-SEL-C:11).
- **STATIC FALLBACK REUSED, owner-vetoable:** a stopped class ships the shipped procedural arm
  (M6 §1.3: walk-bob + lean on the static mesh — visible motion, zero rig) exactly as it does
  today; this is the M6-SPEC §1.5 declared reading the owner can veto, and the veto costs
  nothing because it is the SHIPPED state, not new work.
- **ART GATES (each REUSED, no new validator):** TRELLIS tri budget (player 8000 / char 9500),
  extent+fill gates (`tools/vm100/player_attempts.py` precedent — the collapse tell), 4-yaw
  SOLID, UniRig RIG_VALID (skins=1), post-merge tri dump, VISUAL validate, aspect gates,
  `tools/mocap/04_validate_glb.py`; PERMANENCE rows per asset (the imagegen/art permanence
  law), `assets/art-src/` refs committed.
- **New files land NEW:** re-mastered meshes `assets/glb/<class>.glb` (v3, the live literal —
  prior versions move to the superseded archive dirs, the shipped convention) + rig twins
  `assets/glb/<class>-rigged.glb` + `assets/anim/maps/<class>.json` (the ONE maps dir) —
  CLIP_SOURCE rows gain the `visual` twin key per the player-row pattern (`roster.gd:162-163`).

### 3.4 The flip + the SCHEDULED seam (file-level)

`roster.gd`'s own reason header (read this session, :1-12) SCHEDULES the clip seam
(`CLIP_SOURCE` + `clip_source()` → `roster_clips.gd`) to the statue ruling's card, per audit-4
§1.4 and the CC3R data-table precedent. 3DR lands it: T-3DR-c creates
**`godot/scripts/roster_clips.gd`** (the seam file — the SAME map, the SAME getter, moved
byte-faithfully), `roster.gd` keeps a delegating call (its rule side untouched), and the six
rows flip per the §3.3 outcomes INSIDE the moved table. `hero_pawn.gd` ZERO edits (F-1's
consumer reads the getter either way); the B-E8/SKINS test family re-pins to
`docs/RIG-DEVIATION-3DR.md` (the new pin doc — the SEL-C doc gets a dated supersession row,
replace-not-delete: struck "7 rigged / 6 static" + the new state line, its rows STAY as
lineage), the art-integration seam-pin (`test_art_integration.py:188+` law) EXTENDED per the
M5 §2.1b precedent (substring law kept; the flip must not touch the art fixture's player row).

### 3.5 What does NOT move (art-side)

`horde_viz.gd` (all 16 mob rows byte-unchanged — §3.2 HOLD-BY-LAW); `hero_pawn.gd`,
`class_mesh.gd`, `camera_rig.gd`, `ground.gd`, the shaders, the biome tiles; the 7+1 rigged
twins; the icons (the one-icon-per-id law); PERMANENCE stays ONE file.

## 4. FX LAW — SKILL_FX identity survives into 3D (the brief's clause 4)

The 26-row `SKILL_FX` table (F-6) IS the 3D skill-look law already (M6 F2 shipped it INTO the
3D tree — color-first on the shipped COLOR-instance mechanism, per-weapon `wid` stamps, the
`SKILL_CLASS_ALPHA` pin). 3DR adds ZERO FX bytes: the identity law is one sentence — **every
fireable id keeps its SKILL_FX row's color + shape identity; a re-mastered statue pawn cannot
touch an FX row, and a card that re-keys a color to pass the §2.3 floors is a P0** (the FX
side re-keys nothing; if a flipped pawn's silhouette ever made an FX unreadable at the pickup/
halo seams, the fix is the pawn art, never the FX table). ACCEPTANCE rides the shipped
instrument: probe Tables 3/3 + 6/6 + **26/26 per-skill distinctness** re-run GREEN on the final
3DR tree (§8 A-7), plus the alpha-law pin leg (the cross-language PIN + planted-red, T-M6q2
row) byte-true. The Doom-Sigil riven-drop look and the F4 descs ride untouched.

## 5. THE WAVE PLAN — file-ownership matrix, serial edges, per-card DoD, GPU LAW rows

### 5.1 The cards (T-* = card ids; every file ONE card; LEDGER append-line exempt — fleet law,
the closing commit appends its own LEDGER row; disjointness is proven over ALL other files)

| card | subject / windows | OWNS (exclusive) |
|---|---|---|
| **T-3DR-a** (GPU, art) | six re-MASTER refs (imagegen, the riggable-wording family §3.3) + TRELLIS.2 mesh gen, one single-row window per attempt, per-character TWO-FAIL STOP, reserve law | `assets/art-src/*` (the six refs + rejected shots), `assets/concepts/*` (six), `assets/glb/char-coinhound.glb`, `char-tallow-seer.glb`, `char-shroud-saint.glb`, `char-hoard-wretch.glb`, `skin-tide.glb`, `skin-void.glb` (+ their superseded moves), `tools/vm100/art-batch-3dr.tsv` (manifest), `.tmp/3dra.txt` capture |
| **T-3DR-r** (GPU, rig) | UniRig-2D rig + skin-merge + `tools/mocap/05/06` CMU retarget walk+attack per ACCEPTED mesh, single-row windows, same STOP; mesh-side permanence rows included here (last art-side card, serial after a) | `assets/glb/*-rigged.glb` (six NEW twins), `assets/anim/maps/*.json` (six NEW), `docs/RIG-DEVIATION-3DR.md` NEW, `docs/RIG-DEVIATION-SEL-C.md` (dated supersession row only), `docs/PERMANENCE.md`, `.tmp/3drr.txt` capture |
| **T-3DR-c** (ZERO GPU, repo) | the flip + the seam + the corpus: `docs/CAPTURE-DEVIATION-3DR.md` FIRST commit (§2.4), seam split, row flips per the pin doc, CSV REMINT, test re-pins | `docs/CAPTURE-DEVIATION-3DR.md` NEW, `godot/scripts/roster_clips.gd` NEW, `godot/scripts/roster.gd` (seam only), `tests/test_characters.py`, `tests/test_skins.py`, `tests/test_art_integration.py`, `tests/fixtures/roster-clips-m5-framediff.csv`, `tests/fixtures/art-s2i-probe.jsonl`, `.tmp/3drc.txt` capture |
| **T-3DR-z** (ZERO GPU, release) | the full battery, VM120 + browser + describe-image rows (§8 B), version per §6 RULED value, the Release Trio, README/roadmap de-stale | `docs/RELEASE-v<VER>.md` NEW, `README.md`, `docs/PARITY-ROADMAP.md`, `godot/project.godot` (+version), `godot/export/**` rebuilt artifacts, `.tmp/3drz.txt` capture |
| **T-3DR-q pair** (after GA, NOT wave-gating) | the clean-code pair the doctrine requires BEFORE any M7 spec (owner 2026-10-25; the MC 11316/11317 pattern): T-3DR-q-AUDIT findings-only → T-3DR-q-REFACTOR (byte-anchor corpora unchanged, suite green, zero behavior, before/after measurements) | filed at GA; ownership matrix at filing (the T-M6q pattern) |

### 5.2 Serial edges (named; the only ordering)

**GATE(owner vm100 backup clears) → T-3DR-a → T-3DR-r → T-3DR-c → T-3DR-z → (GA) → T-3DR-q
pair → [M7 spec opens, §7.1]**. a→r: the rig consumes accepted meshes; r→c: the flip consumes
the pin doc's measured outcomes (a flipped row names its rigged twin — the MV-E4 planted-red:
`CLIP_SOURCE` naming "walk" on a clip-less file ⇒ the validator leg RED, the M6 §1.6 leg
reused verbatim); c→z: the battery needs the final tree. a ∥ nothing (the art windows are one
serial lane — single-row law §5.4). No two cards share a file ⇒ within-wave parallelism is
DISALLOWED by the serial chain itself; the matrix disjointness is the DA-checkable proof the
wave cannot collide even if steering loosens (the proof instrument the capture re-runs: §5.5).

### 5.3 Per-card DoD (each: what CLOSES it + its byte-law channel rows)

- **T-3DR-a DoD:** per class: ref committed (riggable wording + identity kept — the M5
  portrait-identity law: keep unless CLEAR mismatch), mesh passes the §3.3 gate battery or the
  class carries a dated STOP row; capture `.tmp/3dra.txt` ends VERIFY_EXIT=0 with the per-
  window rows (open/close timestamps, drain_barrier PASS, rc, verifier-serving-at-close, per
  §5.4); channel rows: none touch bytes yet — states the mesh inventory delta.
- **T-3DR-r DoD:** `docs/RIG-DEVIATION-3DR.md` complete (per-row rigged/static state + reason
  cells on statics + the owner-ratification chain: the 2026-10-29 quote + this milestone's
  package answer where a NEW ask arises), every RIGGED row = walk+attack named animations +
  skins=1 + textures survive + post-merge tri dump; framediff-measured motion on each rigged
  twin; capture VERIFY_EXIT=0; channels: skinned s2r CSV HOLD-confirmed.
- **T-3DR-c DoD:** deviation doc FIRST commit; seam split (ONE table, ONE getter — the
  duplicate-table grep: `CLIP_SOURCE` still TWO script homes at close — roster_clips.gd +
  hero_pawn.gd, NEVER three; roster.gd's delegator keeps the ONE read path); flips land per the
  pin doc; **byte-law channel battery: the §2.1 HOLD table `cmp`-identical (journey + 13), the
  §2.2 REMINTs measured + row-diffed into the doc, empty-cell RED leg re-runs, suite green**
  (380+ at T-M6q2 + legs this card adds), MV-E4/validator planted-red GREEN-on-red; capture
  VERIFY_EXIT=0.
- **T-3DR-z DoD:** the §8 acceptance battery on the tagged tree; the Release Trio (§6.2) in
  the same push; ratification quoted VERBATIM into RELEASE notes + the deviation-doc footer
  cells (the empty-cell rule bites z's close if any cell is empty); capture VERIFY_EXIT=0.

### 5.4 GPU WINDOW LAW ROWS (binding on a/r; the LEDGER-shipped facts, restated as LAW —
every 3DR capture carries these as greppable rows)

| law | content (source) |
|---|---|
| **LAW-GATE** | **OWNER-BACKUP GATE FIRST: no 3DR GPU window opens before the owner's vm100 backup window CLEARS** — the parking condition the v3.1.0 release notes name (RELEASE-v3.1.0.md:97-99 "parked on the owner's vm100 backup"); T-3DR-a's first window is the FIRST thing behind the gate; the spec authors zero windows (this is a read/author job — MC 11720 brief) |
| **LAW-BARRIER** | `tools/vm100/drain_barrier` PASS before ANY model load (the consumer-side mitigation committed after the window-4 OOM: a `systemctl restart llama-swap` inside an open window root-caused, LEDGER T-S1a) |
| **LAW-SINGLE-ROW** | one asset per window, no accumulation (the M5 batch lesson; the T-M6a-SKILLART precedent "single-row windows only, no accumulation") |
| **LAW-TRAP-CLOSE** | every window trap-CLOSES with rc=0 recorded; no idle-open window, ever; the generator window closes so the verifier resumes (imagegen window law) |
| **LAW-VERIFIER-AT-CLOSE** | llama-swap / verifier serving PROVEN after every close (every M5/M6 GPU card's capture line: "verifier serves after every close") |
| **LAW-ARTIFACTS** | rc IS NOT TRUTH: assert ARTIFACTS exist after UniRig (its launchers exit 0 producing nothing — kb VERIFIED 2026-10-22); the validators are the truth |

### 5.5 Disjointness proof (the §5.1 matrix, pairwise — the capture re-runs the instrument)

Cards (files sets): A={a-src/concepts/six glbs, tools/vm100 tsv}, R={six rigged glbs, six anim
maps, RIG-DEVIATION-3DR, SEL-C supersession row, PERMANENCE}, C={CAPTURE-DEVIATION-3DR,
roster_clips.gd, roster.gd seam, 3 tests, 2 fixtures}, Z={RELEASE, README, ROADMAP,
project.godot, export/**}. A∩R=∅ (mesh vs -rigged twin, distinct names — §3.3's new-file
law); A∩C=∅; A∩Z=∅; R∩C=∅ (R owns no roster/tests; the SEL-C doc vs the tests that parse
it: the tests are C's, the doc is R's, and r→c SERIAL means C reads the doc only AFTER r
closed — the one cross-file READ, no shared WRITE); R∩Z=∅; C∩Z=∅. LEDGER.md exempt-append per
§5.1. Proof rows computed by grepping the OWNED columns of §5.1 into a pairwise ∅ table —
`.tmp/3drspec.txt` leg 4 re-computes it from THIS table (a spec edit that breaks disjointness
breaks the proof leg).

## 6. VERSION DECISION + THE RELEASE TRIO

### 6.1 The stamp (⚠ OWNER-DECISION — recommendation first, no manufactured consent)

**RECOMMENDATION: v4.0.0 (MAJOR).** The mechanical surface law (roadmap §2: major = a new
player-navigated UI surface) does NOT fire on its own terms — 3DR adds no surface (the honest
MINOR reading, v3.2.0, stays on this row). The case for v4.0.0: the surface law was written
for feature milestones; 3DR CLOSES the founding milestone — the owner ruling that says the
product IS a 3D remake with character animations — and the M6 §8 row already recorded a
dated "MAJOR-v4 candidate (OWNER-DECISION)" for the statue ruling's landing, which is
exactly what ships here. Alternative: v3.2.0 (pure surface law). The value settles BEFORE any
annotated tag ships bytes (the v2.0.0 lesson, roadmap §2) — the T-3DR-z card tags the RULED
value only.

### 6.2 The GitHub-Release trio (owner doctrine 2026-10-25 — release-card DoD rows)

1. **Release notes committed AT the tag:** `docs/RELEASE-v<VER>.md` — what shipped (the flipped
   classes + the seam + the battery numbers), known limits honest (any double-fail class
   shipping the §3.3 fallback named as such — the promised-not-shipped row is CLOSED or
   EXPLICITLY re-parked, never silently dropped), the RATIFICATION block verbatim (typos
   intact);
2. **README current AT the tag** (no stale claim survives — the retired-claim grep-to-zero law;
   the v3.1.0 notes' "rides procedural until T-M6a-STATUE lands" claim becomes a dated
   supersession row);
3. **Doc-sync sweep grep-to-zero** (LEDGER/ROADMAP/M6-SPEC §1.5/§11 lines carry their dated
   supersession notes; the RIG-DEVIATION-SEL-C "6 static" claim retires per §3.4's
   replace-not-delete row — grep `6 static|statue-class static` to zero live-reading hits).
Tag law carries: annotated tag on a tagged-tree commit; both export targets (WASM `64f301f3…`
+ Windows `a9c058a2…` — the v3.1.0 pinned pair, tools/VERSIONS.txt) re-exported FROM the
tagged tree; gh release assets = both zips + sha256sums, draft=false prerelease=false;
capture `.tmp/3drz.txt` ends VERIFY_EXIT=0.

## 7. WHAT 3DR IS NOT — exclusions with dated-supersession discipline

### 7.1 The M7 trio — NAMED, explicitly AFTER 3DR per the owner's pick, NOT scheduled here

Owner re-confirmation (2026-10-30), verbatim: *"3d remake first then m7"*. The trio this
names-but-does-not-schedule, each with where it already lives (deferred/excluded rows, NOT
re-decided): **(1) the settings/options screen** (deferred in the roadmap's settings row;
today = Esc-pause + M-mute only, the v1.2.0 landing row); **(2) mobile touch controls**
(roadmap §3.3 EXCLUDED row, "no mobile scope"); **(3) the leaderboard/cloud-save server**
(DESIGN-3D §e "Server: NOT ported"; roadmap gap row 13 — the former "rides the v1 server"
claim was RETIRED CONTRADICTED, MC 11398/11401: zero commits ever touched `server/`). When
M7 opens, ITS spec carries the dated supersession rows for these exclusion lines; until then
each line stays true and 3DR files nothing against them (naming ≠ scheduling).

### 7.2 In-milestone exclusions (the wave must not smuggle these)

No new ids/weapons/classes (the pool stays 15/15 + unions); no roster CHANGES of IDENTITY
(flips are rig-state, never new rows — the IEEE row-0 law); no new HUD/skill overlays (§2's
surface law's own guard); no new save fields (Contract B frozen); no audio (polish tier
untouched); no new GLBs beyond the six+six (§3.2's coverage table is the closed universe);
no floor-constant edits (§2.3); no FX re-keys (§4).

### 7.3 REJECTED-ALTERNATIVES LEDGER (fleet law: weigh in the SPEC, never at implementation time)

- **R1 skinned horde (Route B)** — REFUTED pre-port and DA-upheld (DESIGN-3D §c: MultiMesh
  cannot skin; 50-300 skinned surfaces vs plan 40 / hard 60; WASM single-thread cost); stays
  REFUTED, dated (c3 verdict SURVIVES).
- **R2 in-game skinned boss** — a SECOND consumer shape (§1.3); the S6 one-instance-on-the-
  horde-path law shipped and survives (D-3); the rigged twin stays capture-proven.
- **R3 3D physics engine** — DESIGN-3D §a rejected: every v1 hit-check is a distance test;
  parity + WASM cost (the sim byte-anchor law makes it structurally impossible anyway).
- **R4 perspective camera** — rejected (DESIGN-3D §a: v1 entities are size-pinned regardless
  of distance); the ortho law is `camera_rig.gd` literally (F-4).
- **R5 Hunyuan3D (any version)** — the §3.1 EXCLUSION row (EU/UK/SK license carve + 29 GB);
  carried per the brief — do NOT re-litigate.
- **R6 text-to-motion models** — overkill, RESEARCH §c; mocap + procedural ships it today.
- **R7 new capture/validator zoo** — every gate 3DR uses is shipped (§3.3, §5.4 LAW-ARTIFACTS);
  a card adding a parallel mechanism where a shipped one answers is a P0 (replace-do-not-add).

## 8. ACCEPTANCE — executable rows where stable; honest non-executable declarations where not

The owner's D3 cap (ratified 2026-10-27, MC 11509 D3): executable acceptance layers exist
ONLY where a stable behavioural contract exists; **GAME VISUALS are explicitly OUT —
"browser + describe-image verification stays"** — the visual rows below are therefore
DECLARED, with their declared instrument, never faked as executable.

### 8.1 EXECUTABLE rows (runnable, deterministic, red-capable)

| # | row | instrument |
|---|---|---|
| A-1 | **sim unchanged, byte-proof:** journey-5071 @11101 + the 13 strict fixtures `cmp` IDENTICAL on every card's battery (the §2.1 HOLD list, verbatim) | `sim_headless` dump cmp + the leak-check idiom |
| A-2 | suite green: pytest 380+ (count at base: 380 at T-M6z; the exact number re-measured at T-3DR-c) on the pinned engine (tools/VERSIONS.txt pins) | pytest, `HD3D_GODOT` seat path |
| A-3 | the B-E8-family pin parses `docs/RIG-DEVIATION-3DR.md`: ratification line asserted, reason cells on every static row, rigged rows measured >= 2px framediff, static rows EXCUSED-0 — PLANTED RED (doc flip ⇒ test RED, the MC 11440 planted-red pattern) | `tests/test_characters.py` (C's edits) |
| A-4 | the MV-E4-family validator leg: a CLIP_SOURCE row naming "walk" on a clip-less file ⇒ RED | shipped validator, reused verbatim |
| A-5 | the §2.4 ratification gate: empty OWNER-RATIFICATION cell on a declared REMINT row ⇒ RED (proved on a COPY) | the SD-E6 parse, doc-path parameterised |
| A-6 | roster-clips driver: twice-cmp across independent xvfb runs, all 55 rows gate (rigged >= 2px, static EXCUSED), laws green; PLANTED RED (frame-clone ⇒ motion min = 0 ⇒ rc 1) | `tools/roster_clip_gate.py` |
| A-7 | FX distinctness: probe Tables 3/3 + 6/6 + 26/26 GREEN on the final tree; alpha-law pin leg byte-true | `tools/upgrades_visual_*.py` trio |
| A-8 | readability: mob grid 44 windows >= RATIO_MIN 2.0 (ONE const, unchanged); 9/9 anchor grid | `tools/biome_readability.py` |
| A-9 | draw-budget tally re-run: measured <= plan 40 (baseline 28; the flipped pawns add ZERO draws — the pawn stays 1 draw, visible mutual-exclusion law MV-E5 reused) | horde_viz `draw_count` + sim_budget legs |
| A-10 | art gates per shipped validator: tri budgets, extent/fill, 4-yaw SOLID, RIG_VALID skins=1, post-merge tri, aspect, mocap validate | the §3.3 battery (LAW-ARTIFACTS) |
| A-11 | clean-room: VS corpus zero-hits law unchanged | the shipped grep gate |
| A-12 | boot smoke both targets from the tagged tree + VM350 playwright 0 console errors + 0 failed requests (the v2.0.0/v3.1.0 rows, one-click autopilot leg reused) | playwright probe on the shipped build |

### 8.2 DECLARED (non-executable per D3 — the owner's eyes are the instrument)

| # | row | declared instrument + honest note |
|---|---|---|
| B-1 | "Same type of viduals, top down" — the LOOK of the owner's ruling | browser + describe-image (Lane E sees natively): per-class turntable shots + in-game shots at the shipped camera; describe-image verdict per flipped class (blank/garbled/overlapping check); **declared, not a gate script — this is the cap, stated** |
| B-2 | "chatacter animations, movements" — a flipped pawn VISIBLY walks | A-6's framediff is the EXECUTABLE proxy; the human/describe read of the walk shot is the declared row (the M6 precedent: MV-E legs measured proxies + declared the human read) |
| B-3 | real-browser field test (the v1.0.0 10-minute test class) | VM120 (the shared Windows seat, fleet skill) browser run on the WASM tag: 0 console errors (executable) + play-feels honest note (declared); rAF software floor DECLARED, not a bug (v1.0.0 law) |
| B-4 | per-skill attack looks "feel individual" | A-7's 26/26 distinctness is the executable floor; the feel read is declared (B-1's instrument) |
| B-5 | the statue classes' IDENTITY survived the re-master (it is still coinhound/tallow-seer/…) | describe-image vs the portrait-icon law; the M5 "keep unless clear mismatch" ruling reused |

### 8.3 Milestone close

GA = every §8.1 row green + the §8.2 rows delivered with captures + the §6.2 trio in the same
push + LEDGER STATUS row. Any double-failed class shipping the §3.3 fallback CLOSES the
milestone HONESTLY (ruled law: two-fail STOP ships static-procedural; the release notes name
it, the promised-not-shipped row re-parks with the owner's next word) — the milestone is not
held hostage to a model the rig-yield law predicts; the owner's veto to keep trying rides the
reserve law (§3.3).

## 9. DA PRE-EMPTION BRIEF (attack here)

1. **The §0 declared reading** — is 3DR = "the completion of the founding ruling via the six"
   the right scope, or does the owner's 2026-10-30 line re-open more? The repo's OWN release
   notes call the six THE promised-not-shipped item — the reading is the repo's, not the
   author's convenience. If the DA finds a second unshipped thread of the founding ruling
   inside THIS repo's docs, it is a P1 finding and it folds.
2. **The HOLD-by-zero-bytes claim (§2.1)** — the strongest row in the spec and the easiest to
   falsify: any 3DR card that touches a sim byte forks the corpus; the `cmp` battery is the
   red-capable proof; check the §5.1 matrix truly contains no sim file (it must, or the HOLD
   list is a lie).
3. **The ONE-consumer claim (F-1/§1.3)** — re-grep `CLIP_SOURCE` (two script homes at base;
   roster_clips.gd after C; hero_pawn stays; NEVER three — the duplicate-table grep at A/C).
4. **The seam ownership (§3.4)** — the split is SCHEDULED by roster.gd's own header to the
   statue ruling; 3DR-C owning it is the dated plan, not scope creep; `hero_pawn.gd` zero-edit
   is the load-bearing check.
5. **The version row (§6.1)** — v4.0.0 vs v3.2.0 is a REAL OWNER-DECISION; no consent is
   manufactured (the recommendation + the honest MINOR reading both stand on the row).
6. **§3.3 honesty** — LOW odds on some classes are STATED, the fallback is the shipped state,
   and the reserve law caps the burns; a DA that reads option (c) as a promise misreads the
   law — quote: the wording family is "a LEAD, not a promise" (M6-SPEC §1.5, re-grepped).
7. **GPU gates** — LAW-GATE is not decoration: the vm100 backup is the owner's; a window before
   the gate is a P0 by this spec.

## 10. SELF-DA CHECKLIST (what the author ran before filing — this session, on cb4a95e)

- [x] every `file:line` cite re-grepped this session (F-1..F-9; camera_rig/hero_pawn/roster/
  horde_viz/sim_headless greps shown in the capture); DESIGN-3D/RESEARCH/M6-SPEC/roadmap/
  LEDGER/RIG-DEVIATION/BYTE-DEVIATION/RELEASE-v3.1.0 read in full or at named lines.
- [x] mechanism-monogamy: one animation consumer (F-1), one gait law, one SKILL_FX table, one
  deviation-doc mechanism (SD-E6 parse extended by doc-path), one seam (the scheduled split
  moves files, not mechanisms), one PERMANENCE, one maps dir, one icon key.
- [x] reuse inventory: every gate/validator/window law 3DR uses is NAMED with its shipped
  source (no new zoo — R7); the rejected list is weighed here, not at build time.
- [x] byte-law: HOLD list explicit (14 channels incl. journey), REMINT list explicit with
  measured-diff law, empty-cell blocks-close CARRIED verbatim, deviation doc FIRST-commit law.
- [x] consent artifacts: every owner word quoted verbatim (founding ruling, 2026-10-30 line,
  "Ibwant skeletons…", "Rec"), typos intact; the version row leaves the decision WITH the
  owner; the fallback veto costs the owner nothing.
- [x] the DA-checkable disjointness proof (§5.5) is re-computed by the capture from this table.
- [x] NOISE: nothing under `.audits/*/out` written (this job writes only docs/3DR-SPEC.md +
  the LEDGER row + `.tmp/3drspec.txt`); GPU untouched (:8123 untouched; zero windows opened);
  NO SPAWNING (this is one design-profile leaf).

## DA GATE (this doc's own cycle ledger)

REV 1 filed 2026-10-30 for the DA gate (the M2–M6 precedent: this doc revises IN PLACE per
verdict; `docs/3DR-SPEC-DA.md` stays immutable at its own commit). c1 verdict lands → REV 2
with a dated fold ledger (finding → change → section); resolved/retired labels dated;
lineage never deleted. After DA SHIP: the owner package (§2.4 ask text + §6.1 version row) →
re-confirmed spec → T-3DR-a behind the LAW-GATE.
