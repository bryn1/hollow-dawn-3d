# Hollow Dawn 3D — v4.0.0 “3D Remake Wave 1”

The 3DR milestone: the owner’s FOUNDING 3D-remake order (MC 11094) gets the line it was
written for — “chatacter animations, movements” — CLOSED with measured facts. The six
statue-class heroes that v3.1.0’s notes named as THE promised-not-shipped item went
through the owner-ruled option-(c) wave: six re-MASTERED meshes (TRELLIS.2, every row
FIRST SEED, zero reserve burns), a rig+clip pass at the fixed UniRig seed 12345 with the
per-class TWO-FAIL STOP, three heroes FLIPPED onto real walk clips through the ONE
`CLIP_SOURCE` consumer, and three that stay static under the owner-ratified procedural
fallback. **MAJOR v4.0.0 per the owner’s RULING** — the stamp ratifies the closing of the
founding milestone (spec §6.1: the surface law does not fire on its own terms for 3DR;
the stamp is the ruling).

## RATIFICATION

All quotes are the recorded artifacts pasted VERBATIM — typos intact, never corrected:

- Founding ruling (web UI, 2026-10-21, MC 11094), verbatim:
  **“I want the 2d version completed and tested and working, then a 3d remake. Same type
  of viduals, top down, but with chatacter animations, movements. 3090 only with best
  possible model doing the word regardless of time taken.”**
- M6-package reply (web UI, 2026-10-29), verbatim:
  **“Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy”**
  — clause 1 rules the statue classes into this re-master + re-rig line (M6-SPEC §1.5
  option (c); the §11 re-rig exclusion retired as a dated LANDED-M6 cell).
- **The 3DR package answer (web UI, 2026-10-31): the owner artifact is the single word
  “Rec”, covering the 4-item package presented 2026-10-31 ~01:15Z** — recorded item by
  item on the board trail (verbatim trail rows):
  1. VERSION: v4.0.0 (MAJOR) RULED.
  2. BYTE-CAPTURE RATIFICATION for shifting rows roster-clips-m5-framediff.csv +
     art-s2i-probe.jsonl: cell text = owner verbatim “Rec” + date 2026-10-31 (pasted
     never corrected, per SD-E6 law).
  3. STATUE RE-RIG PLAN + two-fail static fallback RULED IN — the binding cell text,
     verbatim: **“UniRig seed 12345, TWO-FAIL STOP per char -> static+procedural
     fallback, never a broken animation; fallback rows named in docs”** (this is the
     OWNER-RATIFIED STATIC FALLBACK the static rows below land under).
  4. WAVE START AUTHORIZED (serial GATE→a→r→c→z, GPU behind owner-backup LAW-GATE).
- LAW-GATE OVERRIDE (web UI, 2026-11-01), verbatim:
  **“Iv vm100, 400 and 350 is not beting backend up, just go”** — the owner-backup gate
  cleared for the GPU wave on his stated ground (the nightly covers vmids 102/103/106/500/
  600 only, journal-verified); LAW-SINGLE-ROW, drain_barrier, trap-close and the
  verifier-serving-at-close rows STAND (all honored, captures `.tmp/3dra.txt`/`.tmp/3dr.txt`).

## What shipped (the 3DR wave, serial a→r→c→z)

- **Six re-mastered meshes (T-3DR-a, MC 11772)** — the six statue classes (char-coinhound,
  char-tallow-seer, char-shroud-saint, char-hoard-wretch, skin-tide, skin-void) re-mastered
  to riggable wording with identities kept (portrait law), then TRELLIS.2 mesh gen: **6/6
  ACCEPTED FIRST SEED** (zero mesh-reserve burns, contention clause never fired); v2/v3
  files annotated + archived under `assets/glb/superseded/` (versioned-truth), PERMANENCE
  rows written.
- **Rig + clip pass (T-3DR-r, MC 11773)** — UniRig-2D at FIXED seed 12345, per-class
  TWO-FAIL STOP, the CMU walk/attack retarget through the ONE `tools/mocap` chain:
  **rig-yield 3/6 on FIRST SEED** — `char-tallow-seer-rigged.glb`, `skin-tide-rigged.glb`,
  `skin-void-rigged.glb` ship named walk+attack animations with textures surviving merge
  (all post-merge TRIS ≤ budget; VISUAL PASS per mesh). THREE double-fails fired the STOP
  and take the ratified fallback (see Known limits). Pin table: `docs/RIG-DEVIATION-3DR.md`
  (per-asset states + reasons; `docs/RIG-DEVIATION-SEL-C.md` keeps its dated supersession
  row as lineage).
- **The flip + the clip-seam split (T-3DR-c, MC 11774)** — `CLIP_SOURCE` flipped EXACTLY
  the three rigged rows null→clip (row-0 pattern: the map key stays the v3 mesh literal,
  the runtime visual is the rigged twin); `roster.gd`’s OWN SCHEDULED clause executed: the
  table + getter moved to `godot/scripts/roster_clips.gd` (ONE table home, ONE consumer —
  both named greps return exactly one file); `hero_pawn.gd` :22 got the dated comment-only
  reword (the pin leg proves comment-only).
- **Corpus REMINTs (T-3DR-c, rider rows — already on master at dc42bb3, noted here, no
  re-work)** — `roster-clips-m5-framediff.csv` re-minted through the committed driver
  54→66 rows (18 rig rows in, 6 EXCUSED rows out; twice-cmp BYTE-STABLE across independent
  renders; the old copy archived under `tests/fixtures/superseded/` with a DO-NOT-USE
  README); `art-s2i-probe.jsonl` REMINT re-measured **byte-IDENTICAL** (md5 ca71f16… — an
  honest zero-diff, declared); `test_skins` tri-budget re-pin moved the constants to the
  live v3 files (constant move, law unchanged).
- **Parse-pin corpus-law extension (T-3DR-c)** — the SD-E6 pin extended to the 3DR corpus
  with SEVEN parameterisation edits to `tests/test_sigil_drop.py` (ONE parse function, a
  per-doc table matrix; docs parametrisation, no copy-paste leg) — and
  `docs/BYTE-DEVIATION-M6.md` stays the M6 pin BYTE-UNTOUCHED with its regression leg
  GREEN in the same run. The 3DR deviation doc `docs/CAPTURE-DEVIATION-3DR.md` landed as
  the flipping card’s FIRST commit (deviation-doc-first law); the empty-cell rule is
  verified closed at this release (zero empty ratification cells).
- **The sim did not move (byte law, every card)** — journey-5071 @`HD3D_SEED=11101`
  md5 `5d863b8034018116a00a1015bf7ac1f6` reproduces the RECORDED digest across the whole
  wave; the 12 strict jsonl + the skinned-s2r CSV are byte-invariant since the wave base;
  no RNG consumer, no pool, no drop order, no schedule moved.

## PROMISED vs SHIPPED — the line, CLOSED with measured facts

The founding promise (verbatim above, 2026-10-21) named **“chatacter animations,
movements.”** v3.1.0 shipped movement for the riggable classes and stated, under
Known limits, that “the promised character animations the founding ruling names are NOT
shipped for the six statue-class heroes”. That line is CLOSED at this tag — measured:

- `CLIP_SOURCE` (`godot/scripts/roster_clips.gd`) carries **14 rows: 11 clip rows**
  (row-0 the Vigil + 10 of the 13 SEL-C meshes) **and exactly 3 null statics**
  (asserted by `tests/test_motion.py`: statics == 3 — the roster-clips CSV agrees:
  60 rig rows + 6 excused rows = 66).
- The flipped rows pass the frame-diff law through the ONE capture path: walk-pair motion
  ≥ **117183 px**, attack-pair motion ≥ **60877 px** (committed CSV, all 40 motion rows;
  floor is 2 px), every frozen control **0 px**; the roster clip gate is **GREEN 66/66**.
- Honest remainder: THREE heroes (char-coinhound, char-shroud-saint, char-hoard-wretch)
  are NOT animated by clips — they keep the shipped procedural motion under the
  owner-ratified fallback (package item 3, verbatim above). The founding line is closed
  FOR THE RIGGABLE CLASSES; these three are named open, never silent.

## Checks at this tag (T-3DR-z battery, MC 11775, capture `.tmp/3drz.txt`)

- full pytest suite: **382 passed, 0 failed** (engine per conftest/VERSIONS pin, throwaway
  XDG well per conftest law);
- roster clip gate GREEN **66/66** (`tools/roster_clip_gate.py`, fresh capture through the
  ONE launcher);
- journey-5071 @11101 md5 == `5d863b8034018116a00a1015bf7ac1f6` (re-dump vs RECORDED digest,
  the T-M6z instrument);
- dawnwell pixel gate **5/5**; motion gate GREEN (laws + twice-cmp determinism);
- HOLD sweep: 12 strict jsonl + skinned-s2r CSV byte-invariant vs the wave base
  (`cb4a95e`); roster-clips CSV byte-invariant since its declared REMINT (`4f3e166`);
- the tag sits ON the release commit (`v4.0.0^{commit}` == pushed master tip); this notes
  file is the gh-release body byte-for-byte (`--notes-file`).

## Known limits (honest)

- **3 heroes stay static-procedural** (char-coinhound, char-shroud-saint, char-hoard-wretch)
  — the UniRig deterministic mis-reads, named per §3.3’s honest-odds row: a **quadruped-
  topology mis-read** on the hound (30-joint quad skeleton undrivable by the humanoid CMU
  ruleset), a **bell-slab collapse** on the shroud (15 joints, single chain), a claw-fan
  mis-read on the wretch. All mis-read classes were the profiled LOW candidates. A re-rig
  needs a NEW owner word (TWO-FAIL STOP + reserve law); the ratified fallback is the shipped
  state.
- The rig pin doc’s header line says “9 RIGGED / 4 STATIC” (MC 11773); its OWN table,
  `CLIP_SOURCE` and the tests measure **10 rigged / 3 static** — the header is off-by-one
  arithmetic against them. The doc is byte-frozen for this card (deviation-doc law); the
  correction rides its next supersession. Recorded as a P3 finding in the release capture.
- Attack clips are capture-proven but NOT played in-game — the auto-fire FX is the hero’s
  attack read (M6-SPEC §0/F-1, verbatim law); this is design, not debt.
- **Playable exports are NOT shipped with this tag**: the WASM + Windows pair is pinned to
  the v3.1.0 tree (`tools/VERSIONS.txt`); a re-export from this tagged tree is the named
  follow-up (§6.2 tag-law row, outside this zero-GPU dispatch’s DoD). Downloading v3.1.0
  zips today gets the PRE-3DR build — that is why this line is in the notes and on the
  board, not silent.
- The horde remains MultiMesh (Route B refuted; the skinned-horde physics is a
  DESIGN-3D rejection, not debt).

## Next (filed, not silent)

Per the owner’s clean-code doctrine: **T-3DR-q-AUDIT** then **T-3DR-q-REFACTOR** on this
tag BEFORE any M7 spec files — no next-milestone spec on a dirty base. The M7 trio (the
settings/options screen, mobile touch, the leaderboard/cloud-save server) is named in
3DR-SPEC §7.1, explicitly AFTER 3DR, NOT scheduled here. The statue re-rig of the three
fallback heroes needs a fresh owner ruling (package item 3’s STOP is consumed); the mesh
reserve is 3/3 intact.
