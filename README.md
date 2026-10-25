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
direction. As of v2.0.0 there are **THREE selectable stages** — Moor Vigil, Sunken Chapel
and Ossuary Stair — chosen from a stage-select overlay ("Choose your night") and persisted
in the Dawn Well save, unlocked by OUR level chain (reach level 10 in stage 1 → stage 2;
level 14 in stage 2 → stage 3; stages stay locked until then). Each stage is **15 minutes —
a 900-second win** (the 2D original keeps its own shorter run) with its own end-boss at
9:00 and its own name bar (THE HOLLOW WARDEN / THE CATHEDRAL CHOIR / THE OSSUARY WARDEN),
its own end-boss chest tier (the keyed source→tier map: choir drops a Warden-tier chest,
the Ossuary Warden a Dawn-tier one), and its own gimmick: the Sunken Chapel seeds two
ember-tier **drowned cairns** (chests at fixed coords, zero RNG) and the Ossuary Stair
carries **pressure plates** — dwelling on one surges the spawn rate ×1.5 INSIDE the
unchanged 12/s clamp and flares the biome banner one band ahead for 30 s (names only —
difficulty reads the clock). Everything else rides the same spine as v1.3.0: two minibosses
at 10:00 and 13:00, a 400-alive spawn cap, chests in THREE tiers (ember/warden/dawn
stamped by source, weighted reward rolls), chest-driven weapon evolutions and TWO weapon
unions (Requiem Toll, Dirge Eternal), a 16-weapon + 15-passive level-up pool under carry
caps (6 weapon slots + 6 passive kinds), ground-gem auto-merge (a 200-gem cap folds the
oldest 100 into one bulk gem, never losing XP), ENDLESS mode — a Dawn Well flag that turns
the 15-minute limit into wave cycles with capped per-cycle scaling and a persisted
best-cycle — and the Dawn Well: a persistent meta shop of 24 power-up rows (12 live
effects, 12 sealed pending the M2 probe) with rank refunds — all OUR numbers, pinned by
the repo's own suite.

## Art pipeline (fleet-mandated, local-only)
All models generated on the fleet's RTX 3090 — no cloud generators.
Stack pinned by cited research (vampire-survivor@docs/RESEARCH-3D-3090.md):
**TRELLIS.2** (image→3D, MIT) → **UniRig** (auto-rig, MIT) → mocap-retargeted walk cycles
for humanoids + credible procedural animation for the stylized creatures → GLB → Godot 4.
Hunyuan3D models are EXCLUDED (their license terms do not apply in the EU/UK/SK — this game
ships in the EU).

## Status
v2.0.0 ("Stages") is the current release; releases live on this repo. Next on the roadmap:
M4 "Roster & Legacy" (v2.1.0) — see docs/PARITY-ROADMAP.md.
