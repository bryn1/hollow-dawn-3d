# Hollow Dawn 3D — v3.0.0 “Roster & Legacy”

The M5 milestone: the roster answers back. Nine selectable characters with a real purchase
screen riding the Dawn Well gold, six achievements with a counter store and a live page, five
skins on the pawn seam, and the death panel itself now opens The Dawn Well — spend your legacy
where you fell. **Major bump per the release law** (owner-ratified, row below): v2.x added
no navigable surface; v3.0.0 lands the character/purchase/achievements screens the M4
tranche promised — a new product surface, not an additive tweak.

## RATIFICATION

- Question asked of the owner (orch web UI single-select, 2026-10-28, answer id `ratify-v300`):
  **"Ratify version 3.0.0 (major bump) for the Roster & Legacy GA release?"**
- Owner selection, verbatim: **"Rec — ship as v3.0.0 (Recommended)"** → gate CLEARED, GA proceeds.

## What shipped

- **Characters roster + purchase screen (T-M5c, MC 11422)** — the SEL-C 9-row roster (owner
  ruling “C”, M5-SPEC §2.5) as a navigable **Characters** page: per-row portrait + title +
  description + one verb button (`Locked — <achievement>` / `Buy <cost>g` / `Select` /
  `Selected`), owned/selected/gold state read from the same save file. Buying spends Dawn Well
  gold through the EXISTING `shop_buy` seam — no second economy. Default selection stays
  **The Vigil**: a default-state save is a byte-identical journey (byte law).
- **Achievements page + counter store (T-M5p, MC 11421)** — six achievements (M5-SPEC §1 rev-2)
  with run counters persisted in the save (R1 rows); an achievement-locked character unlocks
  through the SAME verb, no separate unlock path.
- **Skins (T-M5k, MC 11423)** — five skins (5-mesh table + group law) worn at the ONE pawn
  seam; the skin row joins the save as R1-fifth; chips live inside the character overlay
  (no 8th screen). Default branch verbatim — default-state bytes unchanged.
- **Death-panel shop + back-to-menu (T-P1b, MC 11497)** — owner verbatim ask
  (“…shop is available when you die”): the end panel now exposes **The Dawn Well** and
  **Back to the menu** by REUSING the menu’s own `shop_requested` verb + `show_menu` hand-back
  (zero new overlay/verb/mechanism). A shop opened from death darkens the panel; closing it
  returns to the menu; purchases spend, apply and persist through the same `shop_buy` seam.
  Gold-cash-at-death untouched (the convert leg stays byte-identical).
- **Art (T-M5s/T-M5r)** — 13 new TRELLIS meshes (8 extension characters, the shroud-saint /
  hoard-wretch pair among them) + the rig/clip pass on the EXISTING UniRig + CMU chain
  (seed-fixed 12345, no new rig class); art budget 26 → 31 rows. 6 rows ship STATIC,
  EXCUSED-not-removed — see the honest line below.
- **Byte law holds across the whole cut** — the 5020-row stage-1 journey dump taken on this
  release tree is byte-identical against a fresh dump from the tagged v2.1.0 tree
  (`JOURNEY_CROSS_TAG_BYTE_IDENTICAL`, HD3D_SEED=11101), and every strict M2–M4 fixture set
  re-measured here is byte-identical.

## Checks at this tag (all re-measured on the release tree)

- `pytest tests/` — **315 passed**, exit 0 (278 v2.1.0 base + 37 M5 rows; zero tests deleted —
  replace-not-delete).
- Strict corpus — **11/11 fixture files BYTE-IDENTICAL** (chars 38 rows, achievements 6 rows,
  the events/reaper/limit M4 rows re-cmp’d directly after a harness naming slip, declared).
- `JOURNEY_CROSS_TAG_BYTE_IDENTICAL` — 5020-row stage-1 dump @HD3D_SEED=11101 matches a fresh
  dump from the tagged v2.1.0 tree, byte for byte.
- Roster capture — twice-cmp-identical, **54 rows, excused-static 0**.
- Dawn Well pixel gate — **4/4 PASS** (shop 60855 / stage 52020 / achievements 56802 /
  char_select 65237 non-bg px).
- Strips — fresh capture **75 rows**, gate **19/19 GREEN**, dump NORM-IDENTICAL to committed
  (diff-lines 0).
- `tools/s8_acceptance.py` — **11/11 PASS**; `tools/tile_gate.py` 4/4; icon gate 14 rows, 0 fail.
- Web export boots with **0 console errors**, live canvas 1280×720 at ~16 fps on the
  llvmpipe soft-GL floor (hardware WebGL is the target).
- VM120 (Windows 11 guest, RTX 2060) field test: the shipped `HollowDawn3D.exe`
  hash-verified IN-GUEST against the digest below (boot bytes = the exported exe byte-for-byte),
  booted to the menu on hardware GL, played from the menu to the honest idle-death panel
  (survived 00:32, kills 12) — and the death panel visibly exposes **The Dawn Well** and
  **Back to the menu** on the native build (the MC 11497 surface, live). Save-file round-trip
  against a seeded `%APPDATA%` Dawn Well file completed without corruption. Three native shots
  committed (`v300-field-*`). Declared: the roster/shop legs were NOT clicked in-guest on this
  pass — the in-guest input channel regressed (deep keyboard navigation unreachable via every
  available injection path this run; declared under Known limits). Those surfaces carry the
  capture-channel shots already in-repo (`m5-char-select.png` and siblings), the 54-row
  roster capture, and the sealed suite rows (37 new). Teardown verified twice (game process,
  staged dirs, tasks, in-guest save dir gone).

## Known limits

- **Roster long-description rows clip the verb button** past the scroll viewport’s right edge
  (a horizontal scrollbar appears; the button stays reachable by scroll). Cosmetic on the
  shipped nine rows; named here so the fix isn’t a surprise.
- **In-guest field tests stay keyboard/mouse-limited** — VM120’s injected-input channels
  regressed for DEEP navigation this cut (single press → focus lands; subsequent presses in a
  session drop; SendInput is ACCESS-DENIED from the task context). The click-driven
  character/shop flows are therefore proven by suite + capture channel + the v2.1.0-era
  mouse pass, not by a fresh in-guest click-through. The keyboard leg stays human-eyeballed.
- Web build framerate floor on soft-GL (llvmpipe) hosts — hardware WebGL is the target
  (carried from earlier releases).
- Static statue-class rows below; no skinned rigs beyond the player/Warden pair + the rigged
  SEL-C rows (carried).

## Not in this release (honest line)

- **6 roster/skin meshes ship STATIC (statue-class), not rigged** — deterministic UniRig
  collapse rows (coinhound 4-bone, tallow-seer 3-bone, shroud-saint single-chain, hoard-wretch
  no-legs, skin-tide 3-bone, skin-void 3-bone) per `docs/RIG-DEVIATION-SEL-C.md`; the owner
  ratified shipping them static with the verbatim artifact **"Rec"** (option A, “statue-class
  static”, MC 11440, 2026-10-27). They are purchaseable and select — they simply stand still.
- **Settings screen** — did NOT ship (still on the roadmap; no volume/binding UI).
- **Level-up offers stay exactly three cards** — the M5 spec discussed variable offer counts;
  this cut keeps the pinned three-card funnel (byte law).
- Carried pre-existing deferrals: coin-bag tiers (M2-SPEC §8.1), roster expansion (+8
  weapons/+5 passives, M2-SPEC §8.5), the 16:00 deep-night end-law row.

## Assets

| file | sha256 |
|---|---|
| `HollowDawn3D-win-x64.zip` | `9d9e790ae819fe58aa68ad6c82345dbd7c1f1b4b09290bc63cf9419260168bb4` |
| `HollowDawn3D-web.zip` | `2fdf02f136ec18e39656fdabd76c638ab9a56b3b09f15e0b9f167976bc57b200` |
| `HollowDawn3D.exe` (inside the win zip) | `fd265abd715e6b63e1f7022e7c1987a03d3dc8e1613bf4cfb3186bfab2e9a299` |

Assets are exported FROM the tagged tree (the v2.0.0 GA law): the release-cut checkout
re-imported and re-exported both targets; the win pack and the web `.pck` are
`PCK_CROSS_TARGET_IDENTICAL` and BOTH web export runs produced the same `.pck` digest
(declared cleaner than the v2.1.0 import-state drift — no drift row needed this cut).
The digests above pin the TAGGED export, the shipped bytes. After extracting the win zip,
the exe is also re-verifiable in-guest: the digest above was hash-checked on VM120 before
the field run and matched byte-for-byte.

Win: extract, run `HollowDawn3D.exe` (Windows x64). Web: unzip, serve the directory over
HTTP and open `index.html` (a file:// double-click will not load the .pck).
