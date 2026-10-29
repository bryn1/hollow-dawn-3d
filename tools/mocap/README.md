# tools/mocap — CMU mocap → skinned humanoid GLB (MC 11108, T-S1b)

Proof toolchain for `docs/DESIGN-3D.md` §c: player/boss are UniRig-rigged +
mocap-skinned; this pipeline proves mocap → retarget → named-animation GLB
end-to-end on the fleet 3090 box (vm100), **CPU-only** (the 3090 window is
never opened by this route; `00-run-all.sh` records its CLOSED status).
No TRELLIS.2 / DINOv3 dependency anywhere in this route.

> **Consumer status (M6 F1, T-M6r, MC 11676):** the runtime animation
> consumer LANDED — the named clips play while the survivor moves, not
> just in capture gates. `Roster.CLIP_SOURCE` is the ONE seam from a mesh
> file to its clip plan; `hero_pawn.gd` plays `"walk"` at the stride-tied
> rate (row 0 rides the promoted byte-identical `player-rigged.glb` copy
> under `godot/assets/glb/`, height-normalised at the root-node scale).
> This pipeline is unchanged — it minted the clips the consumer reads.

## Chosen route (ONE, justified) + license verdicts

| source | what we use | license (verbatim / repo) | verdict for shipped derivative |
|---|---|---|---|
| CMU Graphics Lab Motion Capture Database (mocap.cs.cmu.edu) | clips 07_01 walk, 09_01 run, 02_05 punch→attack (BVH) | "The motion capture data may be copied, modified, or redistributed without permission." (faqs.php, fetched 2026-10-22) | **OK to ship retargeted/baked animations.** Raw clips are NOT committed to this repo. |
| una-dinosauria/cmu-mocap (GitHub) | BVH *format conversion* of the same CMU clips, linked as B. Hahne conversions from CMU's own resources page | no LICENSE file; conversion adds no new grant — CMU grant above is the license of record | OK (data rights flow from CMU) |
| Blender `bpy` 4.2 Python module (venvrig, MC 11096) | headless armature/skin/export tool | bpy module MIT; bundled add-ons: `io_anim_bvh` GPL, `io_scene_gltf2` MIT | OK — GPL is tool-side only; GLB *output* is unencumbered |
| Rejected: KIT Motion-Language subset (HumanML3D/MDM/T2M-GPT benches) | — | CC BY-NC 4.0 (non-commercial) | **REJECTED** — NC restriction would not let the shipped game carry derivative animations; also needs heavy GPU checkpoints |
| Rejected: LAFAN1 | — | CC BY-NC-ND | REJECTED (NC + ND) |
| Rejected: Mixamo | — | cloud + ToS | REJECTED (violates the 3090-only ruling; also in DESIGN-3D §h) |

**Install verdict (least machinery):** no `venvmocap` was created. The route
needs only bpy 4.2.0 + numpy, which already live in `/opt/imagegen/venvrig`
(MC 11096); `01-check-env.sh` asserts that and is the whole install.

## Run (vm100)

```
/opt/imagegen/tools/mocap/00-run-all.sh /opt/imagegen/tmp/mc11108
# out: /opt/imagegen/tmp/mc11108/hd3d_humanoid_animproof.glb
#      (1 file, 3 glTF animations: walk / run / attack)
```

Validate any GLB anywhere (stdlib only): `python3 04-validate-glb.py <glb> expect`.

## Skinned rigs (MC 11138 T-S2r) — CMU → UniRig GLBs

The two skinned classes (assets/glb/player-rigged.glb 34 joints,
boss-warden-rigged.glb 46) got their pose clips through a position-based
transfer step added to this toolchain (same CMU source + license as above,
same CPU/bpy route — no GPU window):

```
# 1) map: rest-pose positions -> bone_N (rules R1..R7 in the script header)
/opt/imagegen/venvrig/bin/python 05-map-rig.py <rig.glb> <ref.bvh> <map.json>
#    committed maps: assets/anim/maps/{player,warden}.json (22 mapped joints
#    each; fingers + LHipJoint/RHipJoint/Neck1 intentionally unmapped, listed)
# 2) retarget walk + attack onto a COPY (the shipped rewrite re-applies the
#    same command onto the repo file as out.glb, skin/textures re-emit):
/opt/imagegen/venvrig/bin/python 06-retarget-rig.py <rig.glb> <map.json> \
    walk=<07_01.bvh> attack=<02_05.bvh> <out.glb>
# 3) validate skinned GLBs: `python3 04-validate-glb.py <glb> rigged`
#    (skips CMU-name expectations, adds >=8 rotation nodes per animation;
#    the pre-clip unanimated copies exit 1 — the red control)
```

Known limitation (declared): the rotation delta rides shared world axes —
per-bone local-axis twist differences between rigs are not corrected
(humanoid→humanoid at this gate, pose-clip use). Proof of motion:
godot/sim/skinned_capture.gd (Xvfb windowed, GLTFDocument runtime load) +
the committed fixture tests/fixtures/skinned-clips-s2r-framediff.csv —
8 motion rows >= 2 px, 4 frozen-control rows at 0 px (the red side: the
gate measures motion, not renderer noise).

## Rollback

- repo: `git revert <sha>` (assets/anim/*.glb + tools/mocap/ are one commit)
- vm100: `rm -rf /opt/imagegen/tmp/mc11108 /opt/imagegen/tools/mocap` (nothing
  else was written; no venv was created; the GPU window was never opened)
