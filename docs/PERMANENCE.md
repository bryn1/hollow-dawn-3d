# PERMANENCE — generated-asset provenance (Hollow Dawn 3D)

Every file under `assets/glb/` + `assets/concepts/` was generated on the fleet 3090
(vm100) per the owner 3090-only ruling. Generator: **TRELLIS.2** (`microsoft/TRELLIS.2-4B`,
repo main @ `75fbf01`, stack install MC 11096 @ `1962206`, tools MC 11118); rig:
**UniRig** (`VAST-AI-Research/UniRig` @ `6793c66`). fp16 `pipeline_type=1024`, matte =
in-pipeline BiRefNet (MIT substitution, MC 11096). Inputs are v1 sprites
(`/home/claudecode/Games/vampire_survivor/static/assets`, READ-ONLY source @ `562e0a1`).
The `player` row (MC 11132) is the exception: its input is the re-mastered sprite
`assets/art-src/player-remaster.png` — the v1 sprite went to the re-master pass; its
three failed seeds keep their row and reasons below. The `dune-scarab` + `enemy-hound`
rows (MC 11134) are the same exception: inputs are the re-mastered sprites
`assets/art-src/{scarab,hound}-remaster.png`; the old squat rows are KEPT with their
reason (MC 11133 finding, ratio gate tools/vm100/aspect_gate.py, capture
`.tmp/art-qc-s1q.txt`).
DIMS = raw world-space bbox (meters, TRELLIS unit scale); game scale (1.67/1.42/5.33 m
targets, DESIGN-3D §a) is applied at import by S3+, not here. TRIS from headless bpy
`calc_loop_triangles` dump (tools/vm100/dump_render.py). Batch run 2026-10-22 (UTC),
MC 11118; capture `.tmp/art-batch-s1a.txt`.

| asset | source sprite | sha256(sprite)[:16] | model | seed | tris / budget | dims_m | bytes | render |
|---|---|---|---|---|---|---|---|---|
| enemy-wraith | static/assets/enemy-wraith.png | 4ef8438a50392422 | TRELLIS.2-4B | 21 | 1479 / 1500 | 0.585,0.220,0.874 | 7 813 676 | concepts/enemy-wraith-render.png |
| enemy-hound | static/assets/enemy-hound.png | 852868462e354ac0 | TRELLIS.2-4B | 22 | 1480 / 1500 | 0.199,0.953,0.354 | 9 432 988 | concepts/enemy-hound-render.png — **REPLACED by the remaster row below (MC 11134): squat raw mesh, loader-normalization inflation 4.01 (> gate 2.0)** |
| enemy-hound | assets/art-src/hound-remaster.png | 255d3c882b6e1485 | TRELLIS.2-4B | 42 | 1432 / 1500 | 0.339,0.493,0.974 (INFLATION 1.46, aspect 0.51 — gates ≤2.0 PASS) | 6 291 500 | concepts/enemy-hound-render.png |
| enemy-crawler | static/assets/enemy-crawler.png | d6b57b94b9b35011 | TRELLIS.2-4B | 23 | 1429 / 1500 | 0.985,0.510,0.539 | 7 712 592 | concepts/enemy-crawler-render.png |
| enemy-cultist | static/assets/enemy-cultist.png | 9f2365850f4bbdbc | TRELLIS.2-4B | 24 | 1493 / 1500 | 0.564,0.468,0.993 | 7 326 420 | concepts/enemy-cultist-render.png |
| dune-scarab | static/assets/enemies/dune-scarab.png | 5637af66b8318210 | TRELLIS.2-4B | 26 | 1436 / 1500 | 0.769,0.946,0.342 | 7 708 556 | concepts/dune-scarab-render.png — **REPLACED by the remaster row below (MC 11134): squat raw mesh, loader-normalization inflation 4.15 (> gate 2.0)** |
| dune-scarab | assets/art-src/scarab-remaster.png | d79e5634504cee5a | TRELLIS.2-4B | 42 | 1455 / 1500 | 0.510,0.504,0.943 (INFLATION 1.51, aspect 0.54 — gates ≤2.0 PASS) | 6 163 252 | concepts/dune-scarab-render.png |
| rime-ghoul | static/assets/enemies/rime-ghoul.png | a60b8c22e847a5f4 | TRELLIS.2-4B | 27 | 3926 / 4000 | 0.562,0.278,0.995 | 8 092 124 | concepts/rime-ghoul-render.png |
| moor-brute | static/assets/enemies/moor-brute.png | ad1bdd9aaf8670c4 | TRELLIS.2-4B | 25 | 3903 / 4000 | 0.922,0.955,0.858 | 8 904 872 | concepts/moor-brute-render.png |
| pale-wight | static/assets/enemies/pale-wight.png | 4d4603ee02fa486c | TRELLIS.2-4B | 28 | 3723 / 4000 | 0.532,0.332,0.957 | 10 844 464 | concepts/pale-wight-render.png |
| player-alt | static/assets/player-alt.png | be5e635b7abf3297 | TRELLIS.2-4B | 18 | 7647 / 8000 | 0.507,0.484,0.999 | 7 576 224 | concepts/player-alt-render.png |
| boss-warden | static/assets/boss-warden.png | 3972428804ba0991 | TRELLIS.2-4B | 29 | 14849 / 15000 | 0.934,0.738,0.985 | 8 636 736 | concepts/boss-warden-render.png |
| boss-warden-rigged | (rig of boss-warden.glb) | — | UniRig skeleton→skin→merge | — | 14929 / 15000 (post-merge dump) | rig-space bbox larger than mesh (armature nodes) | 8 844 320 | — (visual validator PASS, textures survive) |
| player (v1 sprite) | static/assets/player.png | 08181cf0f0df2ad4 | TRELLIS.2-4B | **SKIPPED** — 3 distinct-seed quality failures | seed17 7668 flat card (y-extent 0.002 m); seed30 7652 solid box (fill 0.80); seed40 7906 flat card (y-extent 0.014 m) | see evidence renders | not committed | .tmp/player-seed{17,30,40}-*-render.png |
| player | assets/art-src/player-remaster.png | 90273440dea128e9 | TRELLIS.2-4B | 42 | 7919 / 8000 | 0.500,0.469,0.997 | 7 957 140 | concepts/player-render.png |
| player-rigged | (rig of player.glb, seed-42 mesh) | — | UniRig skeleton→skin→merge | — | 7999 / 8000 (post-merge dump) | rig-space bbox 1.902,2.000,2.000 (armature nodes; larger than mesh) | 8 112 600 | — (visual validator PASS, textures survive) |

## Honest notes
- **Bone naming (warden rig):** UniRig's articulation-xl assigns a **46-bone
  generically-named skeleton (`bone_0…bone_45`)** — skinning + rotatable joints are
  glTF-valid (RIG_VALID=PASS, MC 11096 validator) and textures survive the merge
  (VISUAL re-validate PASS), but **semantic bone naming / humanoid retargeting is NOT
  provided**. Game use needs rename/retype or a humanoid reference (PoC precedent,
  capture MC 11096 §honest degradation).
- **Player row SKIPPED (orchestrator ruling 2026-10-22):** the dark front-view robed
  sprite collapsed to flat cards / a solid slab on seeds 17, 30, 40 (tri budgets
  PASSED — the extent+fill quality gates in tools/vm100/player_attempts.py rejected
  all three; concept renders attached as evidence in `.tmp/`). A seed-40 first attempt
  additionally died to a FLEET INTERFERENCE event (VM300 seat `systemctl restart
  llama-swap` inside the open window, vm100 journal 14:30:11Z — OOM, not counted as a
  seed). Sprite goes to a re-master pass (orchestrator-side); do NOT re-roll the
  current sprite. The intermediate 4-joint player rig (from the seed-30 slab) is NOT
  committed per the same ruling (degenerate; repo assets must not invite wiring it in).
- **player (remaster, MC 11132):** ACCEPTED on the FIRST seed (42) once the sprite was
  re-mastered — the volumetric rim-lit 1024×1536 input produced a real full-body mesh
  (extent 0.500×0.469×0.997 m where the flat sprite collapsed to 0.002–0.014 m cards);
  extent+fill gates green, no seed wasted on 43/44. Rig `player-rigged.glb` = UniRig
  **34-joint generic `bone_0…bone_33` skeleton** (names NOT semantic, same state as the
  warden note above): RIG_VALID=PASS (skins=1, 34 rotatable joints), textures survive the
  merge (VISUAL re-validate PASS), post-merge tri dump 7999/8000 PASS. One bounded GPU
  window (OPEN 15:37:25 / CLOSED 15:37:25+7min13s rc=0, drain_barrier PASS before load);
  capture `.tmp/player-s1p.txt`.
- **scarab + hound regeneration (MC 11134, T-S1q):** MC 11133 found the old pair
  squat — at the 1.42 m uniform height normalization (ClassMesh) their horizontal
  extent inflated **4.15 / 4.01×** (~3.9 m wide at 1.42 m tall in game). New gate
  `tools/vm100/aspect_gate.py` (INFLATION ≤ 2.0 AND aspect ≤ 2.0; RED-proven on the
  old assets, GREEN sanity on player.glb 1.42/0.50). Both re-mastered inputs
  produced ACCEPTED meshes on the FIRST seed (42): scarab INFLATION 1.51 / aspect
  0.54, hound 1.46 / 0.51 — extent+fill gates green, seeds 43/44 never burned.
  Same pipeline reuse as MC 11132 (batch_trellis fp16@1024 + player_attempts
  barrier/quality gates imported). ONE window (OPEN 18:31:47 / CLOSED 18:37:30
  rc=0, drain_barrier PASS before load); tri re-count + renders OUTSIDE the window
  (bpy Cycles CPU); loaders see the same filenames (godot/assets/glb/ in-place
  replace; art-probe re-run measured the NEW meshes at the SAME 1.420 m — the
  committed fixture regenerated byte-identical). Rollback: `git revert` of the
  deliverables commit restores the old glbs
  (sha256 dune-scarab 0d716b72…, enemy-hound 7f8be415… full shas in the capture).
- `player-alt` is its own TRELLIS mesh (DOD-ACCEPTANCE §c lists it as same-rig
  retexture; as an unrigged static GLB the honest read is a separately generated
  variant — S5/S3 decide material-swap vs this mesh at integration).
- All seeds recorded per row in `tools/vm100/art-batch-s1a.tsv`; tri gate =
  `to_glb(decimation_target=budget)` then bpy re-count (gate can go red: it did, on
  planted-bad runs MC 11096; the player row is a real observed gate-red case).

## Integration move (T-S2i, MC 11133)

The nine game-use glbs (8 swarm classes + boss-warden) MOVED to
`godot/assets/glb/` at art-integration import (DESIGN-3D §f project-tree
row; provenance rows above are unchanged). `player-alt.glb` and
`boss-warden-rigged.glb` stay in `assets/glb/` — neither is wired: the
rigged variant waits for the mocap card, player-alt for MC 11132.

## M1c art batch (T-M1c, MC 11207, 2026-10-23)

**31 icons** (10 weapon + 10 evolution + 10 partner-passive + 1 chest, PARITY-ROADMAP
rev3 M1 asset row — the DOC is the manifest: 10+10+10+1=31, no Dawn-Well icon rows in
it). Generator: the harness `imagegen` MCP tool (Qwen-Image t2i, transparent cutout,
512×512 RGBA, fast quality), ONE window session 20:56→21:31:10Z. Style anchor = the
verbatim §j family (palette of pale moonlight blue-grey, bone white, ember crimson
and ichor green; centered, thick outline, no frame). Provenance = the existing
convention: the full prompt embedded as PNG tEXt `impeccable:prompt` (the key
test_card_icons.py reads; the `impeccable` CLI is not installed on this host, PIL
wrote the same key). Variant manifest: `tools/vm100/icons-batch-m1c.tsv`
(id, dest, seed, prompt-sha256[:16]). Legibility gate: `tools/vm100/icon_gate.py`
(aspect_gate.py pattern reused: DIMS/TRANSP/FILL/PROV rows, 31/31 PASS, red-proved
on planted PROV + TRANSP legs). Declared re-roll reserve burned: evo-rot-spiral (73→
173), evo-judgement-cross (74→274), passive-cracked-heart (81→281), passive-loadstone
(86→186) — firsts framed as cards / too sparse; captures `.tmp/m1c-art.txt`.

**10 weapon meshes** (static props; the 2 miniboss rows are DECLARED-DEFER — character-
class items, own card, designs not in the doc yet). Generator: TRELLIS.2 batch
(`tools/vm100/art-batch-m1c.tsv`), inputs = this card's weapon icons (BiRefNet matte
in-pipeline), prop tri budget 1500 (swarmer-class row, OUR prop row — stated), batch +
regen spec `art-batch-m1c-regen.tsv`. The batch ran WITH the extent+fill quality gate
enabled (MC 11207 extension of `batch_trellis.py` reusing `player_attempts.quality`;
drain_barrier moved into the driver). Batch a (window 21:44:26→22:02:54Z): 6/10 OK,
4 SKIPPED on flat-card collapse (all 12 seeds burned per row). Remaster inputs (3/4
prop renders, imagegen window 22:05→22:08:21Z, committed at
`assets/art-src/weapon-*-remaster.png`) + regen window (22:09:17→22:24:30Z): 4/4 OK.
TRIS are the headless bpy dumps (dump_render.py, CPU, outside windows); VISUAL_VALID
PASS 10/10 (validate_glb.py visual = the static-prop expect-mode; rigged mode NOT
applicable — nothing skinned). ASPECT rows below are the character-era 1.42 m
normalization printout — weapon props have no §a height row yet (a later card pins it);
the aspect_gate exits RED for THREE rows at that (non-applicable) target: bone-whip
(17.35, flat planar coil) and fire-lash (4.61, long coiled whip) on the scale-invariant
ASPECT leg, hewn-axe (INFLATION 2.03, ASPECT 1.31 PASS) on the 1.42 m leg only — all
three FLAGGED for that future card, not re-rolled here against an invented target.

| asset | source | seed | tris / budget | dims_m (x,y,z) | aspect | sha256[:16] | render |
|---|---|---|---|---|---|---|---|
| weapon-bone-whip | icons/weapon-bone-whip.png | 93 | 1296 / 1500 | 0.713,0.057,0.984 | 17.35 FLAG | fff152fb776b2d17 | concepts/weapon-bone-whip-render.png |
| weapon-dart-loop | icons/weapon-dart-loop.png | 95 | 1483 / 1500 | 0.972,0.991,0.968 | 0.98 | ece41bd85d779154 | concepts/weapon-dart-loop-render.png |
| weapon-hewn-axe | icons/weapon-hewn-axe.png | 94 | 1470 / 1500 | 0.913,0.699,0.080 | 1.31 | a21954ebc53a3ba4 | concepts/weapon-hewn-axe-render.png |
| weapon-pilgrim-cross | icons/weapon-pilgrim-cross.png | 95 | 1461 / 1500 | 0.810,0.988,0.910 | 0.92 | 2f505a43fd57dfbf | concepts/weapon-pilgrim-cross-render.png |
| weapon-censer-of-hours | art-src/weapon-censer-of-hours-remaster.png | 112 | 1384 / 1500 | 0.723,0.878,0.567 | 0.82 | 947cae29ec5ee4e7 | concepts/weapon-censer-of-hours-render.png |
| weapon-rot-water | art-src/weapon-rot-water-remaster.png | 115 | 1489 / 1500 | 0.833,0.999,0.831 | 0.83 | 874540d1237f17f4 | concepts/weapon-rot-water-render.png |
| weapon-spectral-disc | icons/weapon-spectral-disc.png | 98 | 1444 / 1500 | 0.996,0.987,0.955 | 1.01 | bf8dfd2ecd025255 | concepts/weapon-spectral-disc-render.png |
| weapon-storm-peal | art-src/weapon-storm-peal-remaster.png | 114 | 1479 / 1500 | 0.790,0.903,0.795 | 0.88 | bdf233122b7dbdae | concepts/weapon-storm-peal-render.png |
| weapon-fire-lash | art-src/weapon-fire-lash-remaster.png | 115 | 1447 / 1500 | 0.753,0.177,0.815 | 4.61 FLAG | 25a542e68dafcf7e | concepts/weapon-fire-lash-render.png |
| weapon-doom-sigil | icons/weapon-doom-sigil.png | 101 | 1467 / 1500 | 0.967,0.827,0.972 | 1.18 | def5f16ce9722272 | concepts/weapon-doom-sigil-render.png |

Notes: `weapon-rot-water` regen seeds 113/114 died to a CUDA OOM mid-window (fleet
co-tenant, not counted as quality seeds; 115 accepted — honest ledger per MC 11118
window-4 precedent). Seeds 92, 96–99, 100–103 burned on flat-card collapse (QUALITY
rows in `.tmp/m1c-batch-a.log` / regen log excerpts in the capture). The rejected flat
exports stayed on vm100; repo carries only accepted rows.
