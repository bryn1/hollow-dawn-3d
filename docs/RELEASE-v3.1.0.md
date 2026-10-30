# Hollow Dawn 3D — v3.1.0 “Feel & Fidelity”

The M6 milestone on the owner’s feel-&-fidelity order (verbatim clauses, M6-SPEC header,
MC 11625). Movement is finally *played*, not just shipped: clips drive the pawns, the horde
gait breathes, every fireable id attacks in its own colour, passives show which skills they
feed, and the level-5 evolution — the moment this genre is built around — fires at the
level-up pick. The screen-clear fantasy retired its skill slot and became what the owner
asked for: a rare drop. **Minor bump per the release law** (owner ruling below): M6 adds no
new player-navigated surface — the level-up cards grow IN PLACE on the same overlay.

## RATIFICATION

- Owner reply to the M6 owner package (web UI, 2026-10-29), verbatim — typos intact, the
  artifact is pasted, never corrected:
  **“Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy”**
- Declared reading (M6-SPEC REV 4, MC 11674): 1 → §1.5 option (c) (the statue-class re-rig
  rules in as the separate T-M6a-STATUE card); 2 → §4.2 the sigil-drop carve (bosses,
  MINIBOSSES and the REAPER survive the clear); 3 → §8 **v3.1.0 ships**; “Ratufy” → §9 the
  byte-deviation table is RATIFIED AS-IS (16 rows; the typo is the artifact).
- The §9 footer of docs/BYTE-DEVIATION-M6.md carries the quote VERBATIM in every declared
  SHIFTS/REMINT/RE-DERIVE row’s OWNER-RATIFICATION cell — verified at T-M6z (18 quote cells
  over the 26-row footer + 8 “n/a — no shift” STAY cells, zero empty cells; SD-E6 instrument
  green).

## What shipped

- **F1 Movement animation everywhere (T-M6r, MC 11676)** — the M5-shipped clips, never
  consumed before, now PLAY: the one `CLIP_SOURCE` seam mounts the rig under the pawn and
  plays `walk` at a stride-tied rate; the promoted `player-rigged.glb` is a byte-identical
  file copy; the horde rides a real gait (position-keyed bob+lean while moving, frozen-slide
  control proven); the six statue-class statics + unrigged skins ride the declared
  procedural arm (±0.06 bob/lean, the horde law).
- **F2 Individual attack looks (T-M6f, MC 11705)** — 26 SKILL_FX rows (15 weapons + 9 live
  evolved + 2 unions) at the ONE dispatch site, colours SAMPLED from each skill’s shipped
  icon with a declared readability floor (dark sampled identities are physically invisible
  to the pixel gate — measured, then lifted); per-instance colour on the shipped bulk-gem
  mechanism, zero new draw classes, draws stay 28; evolved ids = bigger/brighter
  same-identity variant + flash on the existing rings.
- **F3 Passives connect; the level-5 evolution (T-M6p, MC 11697)** — the trigger MOVED from
  chest-open to the level-up PICK: weapon MAX + passive partner carried ⇒ the evolved id
  lands in-slot at the chest-less seam; the evolve table 10→9 (the doom-sigil→pale-moon row
  retired WITH the pool entry; pale-moon EXCLUDE-pinned); boosts read ONE `effect()`
  resolution (the `':'` no-op hole closed); the union reserve rides the extended
  eligible-at-MAX window; chest-open keeps the union precedence ALONE.
- **F4 Short skill text (T-M6p)** — every offer card carries a ≤72-char explanation pinned to
  the SPEC bytes (test parses the spec as the copy source), honesty passives included, and a
  Lv5 hint clause naming the evolution iff the partner is carried; passive cards show the
  skills they affect as icon chips (both tables, a pixel leg proves the chips paint).
- **F5 Coins ride the magnet (T-M6d, MC 11675)** — coins join the ONE magnet source
  (grip-line pull, loadstone additive, zero RNG); the sigil stays touch-only by design.
- **F6 DOOM SIGIL retired → the RIVEN SIGIL drop (T-M6d)** — the screen-clear “skill” leaves
  the pool (16→15, grep-to-zero at the ONE IDS/META/`_fire` site; the icon KEEPS its
  permanence row) and returns as what the owner asked for: a rare pickup from a ZERO-RNG
  every-750th-kill counter (non-boss), whose touch clears every non-boss, non-miniboss and
  non-reaper on screen (owner carve “2. Rec.”).
- **F7 Mob contrast floor (T-M6c, MC 11677)** — every mob class is findable on its own
  ground: a 44-row (band × class) readability grid at the ONE ratio floor; measured tint
  lifts on the ONE `tint_of` lookup (the hound needed ×5.5 — black baked texels do not
  multiply); the glow fallback never fired.
- **Harness hygiene (T-M6H-XDG, MC 11706)** — every pytest boot runs in a throwaway save
  well (the HOME-well contamination class closed at the ONE harness seam; the class was
  measured live: an unreset boot inherits real play history as meta-power).

## Checks at this tag (all re-measured on the release tree, T-M6z, MC 11709)

- `pytest tests/` — **380 passed**, exit 0 (replace-not-delete through the whole milestone).
- **§9 byte battery, every ratified row re-derived from a fresh run**: a pristine base
  worktree @ `acd00f1` re-dumped beside the release tree, both under throwaway wells.
  Journey base = 5020 rows md5 `c7ddab89…` (the archived pre-M6 digest, reproduced);
  release = **5071 rows md5 `5d863b80…`** — byte-identical to the committed anchor; first
  divergence row 2 = the declared draws re-tally 27→28; the +41 additive legs and the
  9+1-row instrument tail carry their declared keys.
  All **13 strict fixtures re-dumped BYTE-IDENTICAL** on the release tree; all 13 base
  re-dumps BYTE-IDENTICAL vs their committed bytes at `acd00f1`; the declared per-row
  shifts re-measured (carry-caps 500/715, doom 64→0; chests-evolve 29→27; chests-tiers
  4; unions 6; events 4; stages 5) and every STAY row 0 (limit, endless, reaper,
  gem-merge, chars, achv, art-s2i).
- Strips — fresh capture 75 rows, gate **19/19 GREEN**, dump NORM-IDENTICAL to committed
  (diff-rows 0 under the declared norm); the base control re-fires the declared ATK-seed
  row live (base aborts F-2 at the shipped seed, passes at 11114 — named in the doc,
  re-derived here).
- Upgrades-visual probe — **all three tables GREEN** on fresh captures: pickups 3/3,
  families 6/6 scale, per-skill 26/26 painted (weakest row 4.6× the floor).
- `tools/s8_acceptance.py` — **11/11 PASS** (A1 real-clock contract holds; A3 green on the
  committed s2p dump).
- `tools/roster_clip_gate.py` — **GREEN** (54 rows; statics excused-not-removed);
  skinned re-capture 12/12 rows, key set == committed CSV, motion ≥ 2 px, frozen 0 px.
- `tools/dawnwell_pixel_gate.py` — **5/5 PASS** (shipped crops at the pinned counts;
  the v3.1.0 CHIPS row lands beside them).
- `tools/tile_gate.py` — 4/4 PASS; icon kinds **31** resolve (test_card_icons).
- Union/evolve/sigil legs — **55 passed** across the four owning test files.

## Known limits (honest)

- **The six statue-class heroes ride procedural motion, not clips.** The owner ruled the
  re-rig (option (c), “Ibwant skeletons with movements.”) — it ships as the SEPARATE card
  **T-M6a-STATUE** (TRELLIS re-master + UniRig per asset), parked on the owner’s vm100
  backup window per the wave law; every rigged row will land through the SAME consumer,
  zero rework. This is the one promised-not-shipped item of M6, named here per the release
  law. (docs/RIG-DEVIATION-SEL-C.md keeps the per-asset truth table.)
- F1 s8 pick-row drift: the re-selected gameover/win seeds (11102/11105) are runtime
  records, contract-gated not byte-pinned — the §9.12 seed-scan law anticipated the
  offer-fork flip; the scan law re-selected them at T-M6p with the class named.
- Conditional card **T-M6a-SKILLART** (per-skill FX prop meshes) never fired — it existed
  only if the owner ruled against color-first; the 2026-10-29 package answered the color-
  first default (v1 ships zero GPU art by design).

## Next (filed, not silent)

Per the owner’s clean-code doctrine (MC 11316/11317 precedent): **T-M6q-AUDIT** then
**T-M6q-REFACTOR** on this tag BEFORE any M7 spec files — no next-milestone spec on a dirty
base. The audit verifies `world.gd` actually shipped its SCHEDULED split (it did: 551→450,
drops.gd out).
