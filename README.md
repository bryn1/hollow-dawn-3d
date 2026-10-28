# Hollow Dawn 3D

The 3D remake of [Hollow Dawn](https://github.com/bryn1/vampire-survivor) (the 2D original,
shipped at v1.1.0 — it stays maintained at its own repo and releases).

Owner ruling (verbatim, 2026-10-21): *"I want the 2d version completed and tested and working,
then a 3d remake. Same type of viduals, top down, but with chatacter animations, movements.
3090 only with best possible model doing the word regardless of time taken."* — followed by
*"Go, make this its own github repo with its own releases"*.

## What it is
Top-down survivor arena (core loop and tuned numbers inherited from v1: 4 biome bands,
per-band enemy rosters, weapons, boss; a leaderboard claim this line once carried
was retired at MC 11401 — it described no mechanism of this repo: no leaderboard
server exists here and none ever did, zero commits ever touched `server/`
(measured, MC 11398 §4.1); the v1 leaderboard stays a v1-server feature, EXCLUDED
here per [PARITY-ROADMAP row 13](docs/PARITY-ROADMAP.md)) rebuilt with **real 3D
models and animated movement** under a top-down camera, in the same dark-gothic art
direction. As of v2.1.0 there are **THREE selectable stages** — Moor Vigil, Sunken Chapel
and Ossuary Stair — chosen from a stage-select overlay ("Choose your night") and persisted
in the Dawn Well save, unlocked by OUR level chain (reach level 10 in stage 1 → stage 2;
level 14 in stage 2 → stage 3; stages stay locked until then). As of v3.0.0 the player
also picks a **character** from a 9-row roster (select/purchase overlay, per-character
start weapon + one signature stat rule) and may wear one of **5 Vigil skins** — with an
**achievements page** (20 rows over 9 run-end counters) tracking the gates. Each stage is **15 minutes —
a 900-second win** (the 2D original keeps its own shorter run) with its own end-boss at
9:00 and its own name bar (THE HOLLOW WARDEN / THE CATHEDRAL CHOIR / THE OSSUARY WARDEN),
its own end-boss chest tier (the keyed source→tier map: choir drops a Warden-tier chest,
the Ossuary Warden a Dawn-tier one), and its own gimmick: the Sunken Chapel seeds two
ember-tier **drowned cairns** (chests at fixed coords, zero RNG) and the Ossuary Stair
carries **pressure plates** — dwelling on one surges the spawn rate ×1.5 INSIDE the
unchanged 12/s clamp and flares the biome banner one band ahead for 30 s (names only —
difficulty reads the clock). Stages 2 and 3 also carry an **event wave** at 11:00–12:00
(Sunken Tide / Stair Wall): a ×2 spawn surge strictly INSIDE the same unchanged 12/s
clamp and a fixed directional spawn cone (from the west / from the east — stage 1 is
event-free by the byte law), plus one dedicated event miniboss each (SUNKEN PRELATE,
STAIR ACOLYTE) latched onto the same schedule at 11:00. A **Reaper night flag** (a hidden
Dawn Well flag, the endless precedent) rewrites the end of a night: survive to 15:00
without endless and THE REAPER arrives, one more every minute, and its touch ENDS the
run — with the flag off, the 900-second win stays byte-identical. When the 16+15+gold
level-up pool is exhausted, **limit-break-lite** hands out three repeatable stat cards
(LIMIT · FURY / HASTE / BULWARK) riding the existing stat seams — a zero-identity
fallback at the offer funnel, never a new pool. The BURNING DUNES band carries its
promised **warm dune hue** now (a deterministic re-tone of the v2 tile inside the same
luma envelope). Everything else rides the same spine as v1.3.0: two minibosses
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
v3.0.0 ("Roster & Legacy") is the current release; releases live on this repo. The
M4-deferred roster tranche LANDED with it — v2.1.0's honest not-shipped line retires
into this dated statement, replace-not-delete: **9 selectable characters** (SEL-C,
owner ruling "C" 2026-10-27; row 0 THE VIGIL is the shipped identity byte-law; gold
purchase 0…2400 on the additive curve, five characters achievement-gated) on a
roster select/purchase overlay (the SIXTH overlay in the one panel style), an
**achievements page** (20 rows over 9 run-end counters; the SEVENTH overlay) and
**5 player skins** (Dawn Well purchases at 200…1000, wear-chips riding INSIDE the
character overlay — no eighth surface). v3.0.0 is MAJOR per the roadmap's own
version law (two new player-navigated surfaces; the owner's ratification rides the
v3.0.0 release notes). The end-of-run panel now exposes **The Dawn Well +
Back to the menu** (MC 11497) — spend your run's gold where you died, then hand
back to the menu. Still tracked, not silent (docs/PARITY-ROADMAP.md): coin-bag
tiers (M2-SPEC §8.1), roster expansion +8/+5 (M2-SPEC §8.5), the unlock-flag store
gating the LEVEL-UP POOL, a settings/options screen (Esc-pause + M-mute is all
this build carries — no audio yet), and the VS 4th level-up option (our level-up
overlay offers exactly THREE cards; the special-conditions fourth is not a
mechanism here). Of the 13 SEL-C meshes **7 ship rigged+clipped and 6 ship
STATIC** (statue-class deterministic rig failures — owner ratification verbatim
"Rec" to OPTION A, MC 11440; the per-asset table is docs/RIG-DEVIATION-SEL-C.md).
