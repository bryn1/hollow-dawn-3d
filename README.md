# Hollow Dawn 3D

The 3D remake of [Hollow Dawn](https://github.com/bryn1/vampire-survivor) (the 2D original,
shipped at v1.1.0 — it stays maintained at its own repo and releases).

Owner ruling (verbatim, 2026-10-21): *"I want the 2d version completed and tested and working,
then a 3d remake. Same type of viduals, top down, but with chatacter animations, movements.
3090 only with best possible model doing the word regardless of time taken."* — followed by
*"Go, make this its own github repo with its own releases"*.

## What it is
Top-down survivor arena (core loop and tuned numbers inherited from v1: 4 biome bands,
per-band enemy rosters, weapons, boss, global leaderboard) rebuilt with **real 3D
models and animated movement** under a top-down camera, in the same dark-gothic art
direction. As of v1.3.0 the run is **15 minutes — a 900-second win** (the 2D original
keeps its own shorter run), with two minibosses at 10:00 and 13:00, a 400-alive spawn
cap, chests in THREE tiers (ember/warden/dawn stamped by source, weighted reward rolls),
chest-driven weapon evolutions and TWO weapon unions (Requiem Toll, Dirge Eternal), a
16-weapon + 15-passive level-up pool under carry caps (6 weapon slots + 6 passive kinds),
ground-gem auto-merge (a 200-gem cap folds the oldest 100 into one bulk gem, never losing
XP), ENDLESS mode — a Dawn Well flag that turns the 15-minute limit into wave cycles with
capped per-cycle scaling and a persisted best-cycle — and the Dawn Well: a persistent meta
shop of 24 power-up rows (12 live effects, 12 sealed pending the M2 probe) with rank
refunds — all OUR numbers, pinned by the repo's own suite.

## Art pipeline (fleet-mandated, local-only)
All models generated on the fleet's RTX 3090 — no cloud generators.
Stack pinned by cited research (vampire-survivor@docs/RESEARCH-3D-3090.md):
**TRELLIS.2** (image→3D, MIT) → **UniRig** (auto-rig, MIT) → mocap-retargeted walk cycles
for humanoids + credible procedural animation for the stylized creatures → GLB → Godot 4.
Hunyuan3D models are EXCLUDED (their license terms do not apply in the EU/UK/SK — this game
ships in the EU).

## Status
Phase 2 kickoff — engine, assets and acceptance gates follow; releases live on this repo.
