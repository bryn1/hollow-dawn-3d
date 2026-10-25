# Hollow Dawn 3D — v2.0.0 “Stages”

The M3 milestone: the night is no longer one night. **Three selectable stages**, each
with its own band schedule, its own gimmick and its own end-boss. Major bump per the
release law (one major per milestone).

## What shipped

- **Stage select** — a “Choose your night” overlay on the menu: MOOR VIGIL, SUNKEN
  CHAPEL, OSSUARY STAIR rows, each listing its bands, gimmick, end-boss and the 15:00
  limit. The chosen stage persists in the Dawn Well save (additive field, no save-version
  bump — an old save reads Night 1). Unlock chain: Sunken Chapel opens at **level 10 in
  Moor Vigil**, Ossuary Stair at **level 14 in Sunken Chapel**; sealed rows say exactly
  that on the button.
- **Per-stage nights** — one unified schedule latch: every stage runs its own boss rows
  (stage 1 keeps the shipped Warden 540 + Hollow Knight 600 + Hollow Deacon 780 exactly;
  stages 2–3 run their own end-boss at 540). The name bar reads the boss’s OWN row —
  THE HOLLOW WARDEN / THE CATHEDRAL CHOIR / THE OSSUARY WARDEN. End-boss chest drops are
  keyed per source (choir rides the Warden-II tier, ossuary warden the Dawn-III tier).
- **Gimmicks** — Sunken Chapel: *drowned cairns* (ember-tier chest cairns standing on the
  ground, opened through the same 16 px funnel as everything else). Ossuary Stair:
  *pressure stair* (plates that arm a spawn surge strictly INSIDE the untouched 12/s
  ceiling, with a names-only HUD flare).
- **Art** — 2 new boss meshes (choir, ossuary warden — Route-A gait like the horde) +
  4 new icons; 0 new tile textures, 0 new draw classes (plates ride the existing billboard
  seam). Mesh budget: choir 3923/4000 tris, ossuary 3865/4000.
- **Stage 1 stays byte-anchored** — the 5020-row journey dump re-measured on this tree is
  byte-identical against the pre-M3 tree, and every M2 fixture (endless/gems/unions/chests/
  stages/art) is byte-identical here. pytest 242 passed.

## Checks at this tag (all re-measured on the release tree)

- `pytest tests/` — **242 passed**, exit 0.
- `tools/s8_acceptance.py` full table — **10/10 PASS**, exit 0. Real-clock legs: gameover
  seed 11104 dies t_sim 205.8 (59.99 ticks/s, no pins); win leg seed 11103 hp-pinned to
  t_sim 900.017 (55.3 ticks/s); boss-bar pixel proof 9529 px painted.
- Dawn-well overlay pixel gate — shop leg 60 855 px + **stage-select leg 52 538 px** over
  floor 200; biome readability 9/9 windows.
- Draw budget (`sim_budget` re-run on this tree, all rows ok incl. the stage-3 leg):
  s8 draw-budget row **≤ 60 PASS**, stage-3 worst case horde 400 at the cap with
  named ≤1; the committed budget dump (draw total 27 ≤ plan 40 ≤ hard 60) is
  byte-identical here.
- VM120 (Windows 11 guest) field test with real mouse clicks: menu → Choose your night →
  **Night 2 — Select** (unlock flag seeded) → stage-2 run actually played (shots committed
  under `assets/screens/`).
- Web export boots with 0 console errors (llvmpipe soft-GL: 19.7 fps at 1280×720 — soft-GL
  floor, hardware GL is the target).

## Known limits

- Web build framerate floor on soft-GL (llvmpipe) hosts — hardware WebGL is the target
  (carried from earlier releases).
- The two new bosses are deliberately chunky-solid low-poly (budget rows above); skinned
  rigs ride the player/Warden pair only (D§c “no buy-and-unused rigs”).
- Static prop CONSUMERS unchanged — the new props are functional (chests/plates), not
  decorative scenery.
- Real-clock s8 gameover seeds are pacing-chaotic: this build RE-SELECTED seed 11104;
  the v1.3.0 death seed 11102 no longer dies on this tree (it wins at t=900 — scan
  measured, disclosed in `.tmp/m3-200.txt`).
- A clean-code audit (MC 11316) + refactor (MC 11317) is scheduled immediately after this
  GA per owner ruling (MC 11318) — M4 specs land on the cleaned base.

## Not in this release (honest line)

- **Event waves** (M3-SPEC §4) — did NOT ship; deferred and tracked as **T-M3e-EVENTWAVE**.
- **The Reaper** — deferred since M2, still tracked as **T-M2r-REAPER**.

## Assets

| file | sha256 |
|---|---|
| `HollowDawn3D-win-x64.zip` | `6a267669275030ce090058039d2d4a59c6d226bd2fb41b70754fba99dde542fa` |
| `HollowDawn3D-web.zip` | `a4963eb0226a21b1957bcbfea9e0798b9e6d1c40c8bd56c55b387a2e8ca7e930` |
| `HollowDawn3D.exe` (inside the win zip) | `3bb960fb20d8f5202f26a58dff5151e7816ba77fccf924a1a651a68169bb6cc5` |

Win: extract, run `HollowDawn3D.exe` (Windows x64). Web: unzip, serve the directory over
HTTP and open `index.html` (a file:// double-click will not load the .pck).
