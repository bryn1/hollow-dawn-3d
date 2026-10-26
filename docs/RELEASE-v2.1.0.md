# Hollow Dawn 3D — v2.1.0 “Nightfall & Legacy”

The M4 milestone: the night answers back. Event waves flood the fixed cones inside the
untouched spawn ceilings, a hidden night summons the Reaper, an exhausted upgrade pool
degrades into repeatable power instead of blank cards, and the Burning Dunes finally read
like fire-bleached sand. **Minor bump per the release law**: nothing new became a screen
you navigate (no characters/purchase screen in this cut), so v2.0.0 → v2.1.0 is additive.

## What shipped

- **Event waves** — the sunken tide and the stair wall: two fixed windows at 11:00–12:00
  on stages 2–3, each a fixed 90° cone (west and east), doubling the spawn rate strictly
  INSIDE the untouched 12/s clamp and the 400-alive cap (no cap bypass). Both windows
  also latch their own minibosses at 11:00: **SUNKEN PRELATE** and **STAIR ACOLYTE** —
  real schedule-latch bosses with their own keyed chest tiers, riding the existing
  `miniboss` drop row (the chest map stays 7 rows). Stage 1 runs no windows (byte law).
- **The Reaper night (hidden)** — set the `reaper` flag in the Dawn Well save file and
  one **THE REAPER** arrives at 15:00, one more every 60 s. Its touch ENDS the run — no
  HP, no contact-dmg path, an end law beside the boss. Flag-off runs are byte-identical
  to before (the endless cycle keeps precedence; the reaper never fires in a flag-off
  run). It is an opt-in easter-egg channel for now — there is no menu UI for the flag.
- **Limit-break-lite** — when the 32 upgrade pool is fully capped, level-ups now offer
  three repeatable cards (LIMIT · FURY / HASTE / BULWARK: +weapon damage / +move speed /
  +intake radius) at the one offer funnel, with honest repeat counters — never a blank
  card again. Zero picks of them leave every stat formula exactly as pinned.
- **Burning Dunes re-tone** — the desert tile is re-generated warm (measured luma 32.9,
  inside the 26–36 gate), and the hero/floor readability window improved with it.
  Superseded v2 tile archived; a pixel swap at the shipped path, not a new tile.
- **Art** — 3 new TRELLIS meshes (sunken prelate 3834/4000, stair acolyte 3851/4000,
  the reaper 3866/4000 tris, all @1.42 gate rows, the reaper on the 5.33 m boss class);
  0 new icons (the limit cards ride the inline-icon seam).
- **Stage 1 and the whole corpus stay byte-anchored** — the 5020-row stage-1 journey dump
  and every strict M2/M3 fixture re-measured on this release tree are byte-identical
  against fresh dumps taken on the tagged v2.0.0 tree (declared carves only: the 3
  re-minted stage rows and the 3 forward-locked art-probe rows, prior rows preserved).
  `events-m4` / `reaper-m4` / `limit-m4` fixtures are committed twice-cmp-identical.

## Checks at this tag (all re-measured on the release tree)

- `pytest tests/` — **278 passed**, exit 0.
- `tools/s8_acceptance.py` full table — **11/11 PASS**, exit 0 (the reaper-bar row joins
  the v2.0.0 ten; boss-bar pixel proof ≥ 200 px painted).
- `tools/tile_gate.py` — 4/4 tiles PASS, desert LUMA 32.9 inside 26–36; a planted +20-luma
  desert copy goes RED (exit 1) — the gate demonstrably bites.
- Biome readability — **9/9 windows GREEN** on fresh capture (desert floor 17.8, hero/floor
  3.93); the same shots byte-reproduced the committed ones; a brightened floor copy goes RED.
- Strips gate (`tools/strips_gate_check.py`) — **19/19 GREEN** on a fresh capture, and that
  fresh dump is identical to the committed one modulo the declared `_ms`/path norm.
- Draw budget (`sim_budget`, 8 legs) — all rows ok: draw total **27 ≤ plan 40 ≤ hard 60**;
  night-flag worst case alive 405 / horde 400 / 2 reapers / draws 27 (budget_reaper leg).
- Event-wave render proof — the `HD3D_EVENTWAVE` capture variant (separate run, declared
  pins) shows the stage’s own 11:00 event miniboss with the live window crowd on one
  frame (stage 2; the acolyte is stage 3’s row — one class per stage, by design).
- Web export boots with **0 console errors** and a live canvas at 12.6 fps on the
  llvmpipe soft-GL floor (hardware WebGL is the target).
- VM120 (Windows 11 guest, RTX 2060) field test with the real mouse: a build from the
  packed-identical pre-tag tree hash-verified in-guest and played end to end (declared:
  the shipped exe re-verified in-guest by hash against the digest below and boot-checked
  to the menu from those shipped bytes — the drift between the two builds is the
  import-state pck-index drift noted under Assets, no logic change); menu, the
  select screen shows Night 2 — the row itself names the drowned-cairns gimmick and the
  sunken-prelate event boss — a stage-2 run actually played to the honest idle-death
  panel (survived 00:32, kills 7; mouse-only, no movement channel in-guest). The
  11:00 event window was not personally watched in-guest (an idle run dies long before
  it) — that window's render proof is the capture-channel shot above, declared.
  Five shots committed under `assets/screens/` (`v210-field-*`), teardown verified twice
  (dir / task / processes / save gone in-guest).

## Known limits

- **The Reaper is flag-only** — no unlock UI, no roster of night modes; and its deep-limit
  end-law (what happens after the 16:00 win in a live multi-reaper run) has no acceptance
  row — the sim leg proves arrival + end-on-touch, not a scripted deep-night.
- VM120 field tests are MOUSE-only (the guest bridge maps physical keys; movement keys are
  unreachable in-guest) — the keyboard leg stays human-eyeballed.
- Web build framerate floor on soft-GL (llvmpipe) hosts — hardware WebGL is the target
  (carried from earlier releases).
- The three new meshes are deliberately chunky-solid low-poly (budget rows above); no
  skinned rigs beyond the player/Warden pair (carried).

## Not in this release (honest line)

The M4 tranche promised more than this cut ships; what did NOT ship stays tracked, named:

- **6 selectable characters + purchase screen** — did NOT ship; tracked as
  **T-M4c-CHARACTERS** (the release that lands that surface carries the version decision).
- **Achievements page** — did NOT ship; tracked as **T-M4p-ACHIEVEMENTS**.
- **Player skins** — did NOT ship; tracked as **T-M4k-SKINS**.
- Carried pre-existing deferrals: coin-bag tiers (M2-SPEC §8.1), roster expansion (+8
  weapons/+5 passives, M2-SPEC §8.5), the unlock-flag store (roadmap M2 #4).

## Assets

| file | sha256 |
|---|---|
| `HollowDawn3D-win-x64.zip` | `a54a8b2e0b757b214f49e71c55b46d0bbe533da9875d2a555e89b5d4c6fc3d5b` |
| `HollowDawn3D-web.zip` | `354e5fd57db62f65c6469994ab9d1e2b6182cb04360a5c87e29069b8727f2607` |
| `HollowDawn3D.exe` (inside the win zip) | `97de42f9a96726121d17d984db85970edb46ec4600077063e92af9b36b687a1f` |

Assets are exported FROM the tagged tree (the v2.0.0 GA law): the release-cut
checkout re-imported and re-exported both targets — `PCK_CROSS_TARGET_IDENTICAL`
(pck `256ece659bd8886b67bdd234b4459ac2ecc3928d731082a563dddf2402ae2766`). Declared:
a pck is NOT byte-stable across separate import states of an identical packed tree
(16-byte index drift observed between the pre-tag and tagged exports, same entry
set and same game logic) — the digests above pin the TAGGED export, the shipped bytes.

Win: extract, run `HollowDawn3D.exe` (Windows x64). Web: unzip, serve the directory over
HTTP and open `index.html` (a file:// double-click will not load the .pck).
