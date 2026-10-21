# Hollow Dawn 3D

The 3D remake of [Hollow Dawn](https://github.com/bryn1/vampire-survivor) (the 2D original,
shipped at v1.1.0 — it stays maintained at its own repo and releases).

Owner ruling (verbatim, 2026-10-21): *"I want the 2d version completed and tested and working,
then a 3d remake. Same type of viduals, top down, but with chatacter animations, movements.
3090 only with best possible model doing the word regardless of time taken."* — followed by
*"Go, make this its own github repo with its own releases"*.

## What it is
Top-down survivor arena (same core loop and tuned numbers as v1: 4 biome bands, per-band
enemy rosters, weapons, boss, 10-minute win, global leaderboard) rebuilt with **real 3D
models and animated movement** under a top-down camera, in the same dark-gothic art direction.

## Art pipeline (fleet-mandated, local-only)
All models generated on the fleet's RTX 3090 — no cloud generators.
Stack pinned by cited research (vampire-survivor@docs/RESEARCH-3D-3090.md):
**TRELLIS.2** (image→3D, MIT) → **UniRig** (auto-rig, MIT) → mocap-retargeted walk cycles
for humanoids + credible procedural animation for the stylized creatures → GLB → Godot 4.
Hunyuan3D models are EXCLUDED (their license terms do not apply in the EU/UK/SK — this game
ships in the EU).

## Status
Phase 2 kickoff — engine, assets and acceptance gates follow; releases live on this repo.
