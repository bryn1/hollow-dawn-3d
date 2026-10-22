# PERMANENCE — generated-asset provenance (Hollow Dawn 3D)

Every file under `assets/glb/` + `assets/concepts/` was generated on the fleet 3090
(vm100) per the owner 3090-only ruling. Generator: **TRELLIS.2** (`microsoft/TRELLIS.2-4B`,
repo main @ `75fbf01`, stack install MC 11096 @ `1962206`, tools MC 11118); rig:
**UniRig** (`VAST-AI-Research/UniRig` @ `6793c66`). fp16 `pipeline_type=1024`, matte =
in-pipeline BiRefNet (MIT substitution, MC 11096). Inputs are v1 sprites
(`/home/claudecode/Games/vampire_survivor/static/assets`, READ-ONLY source @ `562e0a1`).
DIMS = raw world-space bbox (meters, TRELLIS unit scale); game scale (1.67/1.42/5.33 m
targets, DESIGN-3D §a) is applied at import by S3+, not here. TRIS from headless bpy
`calc_loop_triangles` dump (tools/vm100/dump_render.py). Batch run 2026-10-22 (UTC),
MC 11118; capture `.tmp/art-batch-s1a.txt`.

| asset | source sprite | sha256(sprite)[:16] | model | seed | tris / budget | dims_m | bytes | render |
|---|---|---|---|---|---|---|---|---|
| enemy-wraith | static/assets/enemy-wraith.png | 4ef8438a50392422 | TRELLIS.2-4B | 21 | 1479 / 1500 | 0.585,0.220,0.874 | 7 813 676 | concepts/enemy-wraith-render.png |
| enemy-hound | static/assets/enemy-hound.png | 852868462e354ac0 | TRELLIS.2-4B | 22 | 1480 / 1500 | 0.199,0.953,0.354 | 9 432 988 | concepts/enemy-hound-render.png |
| enemy-crawler | static/assets/enemy-crawler.png | d6b57b94b9b35011 | TRELLIS.2-4B | 23 | 1429 / 1500 | 0.985,0.510,0.539 | 7 712 592 | concepts/enemy-crawler-render.png |
| enemy-cultist | static/assets/enemy-cultist.png | 9f2365850f4bbdbc | TRELLIS.2-4B | 24 | 1493 / 1500 | 0.564,0.468,0.993 | 7 326 420 | concepts/enemy-cultist-render.png |
| dune-scarab | static/assets/enemies/dune-scarab.png | 5637af66b8318210 | TRELLIS.2-4B | 26 | 1436 / 1500 | 0.769,0.946,0.342 | 7 708 556 | concepts/dune-scarab-render.png |
| rime-ghoul | static/assets/enemies/rime-ghoul.png | a60b8c22e847a5f4 | TRELLIS.2-4B | 27 | 3926 / 4000 | 0.562,0.278,0.995 | 8 092 124 | concepts/rime-ghoul-render.png |
| moor-brute | static/assets/enemies/moor-brute.png | ad1bdd9aaf8670c4 | TRELLIS.2-4B | 25 | 3903 / 4000 | 0.922,0.955,0.858 | 8 904 872 | concepts/moor-brute-render.png |
| pale-wight | static/assets/enemies/pale-wight.png | 4d4603ee02fa486c | TRELLIS.2-4B | 28 | 3723 / 4000 | 0.532,0.332,0.957 | 10 844 464 | concepts/pale-wight-render.png |
| player-alt | static/assets/player-alt.png | be5e635b7abf3297 | TRELLIS.2-4B | 18 | 7647 / 8000 | 0.507,0.484,0.999 | 7 576 224 | concepts/player-alt-render.png |
| boss-warden | static/assets/boss-warden.png | 3972428804ba0991 | TRELLIS.2-4B | 29 | 14849 / 15000 | 0.934,0.738,0.985 | 8 636 736 | concepts/boss-warden-render.png |
| boss-warden-rigged | (rig of boss-warden.glb) | — | UniRig skeleton→skin→merge | — | 14929 / 15000 (post-merge dump) | rig-space bbox larger than mesh (armature nodes) | 8 844 320 | — (visual validator PASS, textures survive) |
| player | static/assets/player.png | 08181cf0f0df2ad4 | TRELLIS.2-4B | **SKIPPED** — 3 distinct-seed quality failures | seed17 7668 flat card (y-extent 0.002 m); seed30 7652 solid box (fill 0.80); seed40 7906 flat card (y-extent 0.014 m) | see evidence renders | not committed | .tmp/player-seed{17,30,40}-*-render.png |

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
- `player-alt` is its own TRELLIS mesh (DOD-ACCEPTANCE §c lists it as same-rig
  retexture; as an unrigged static GLB the honest read is a separately generated
  variant — S5/S3 decide material-swap vs this mesh at integration).
- All seeds recorded per row in `tools/vm100/art-batch-s1a.tsv`; tri gate =
  `to_glb(decimation_target=budget)` then bpy re-count (gate can go red: it did, on
  planted-bad runs MC 11096; the player row is a real observed gate-red case).
