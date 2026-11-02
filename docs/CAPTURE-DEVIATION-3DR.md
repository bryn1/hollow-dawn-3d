# CAPTURE-DEVIATION — 3DR capture corpora (T-3DR-c, MC 11774, 2026-11-02)

PIN ARTIFACT (deviation-doc-as-pin, the M6 mechanism REUSED not re-invented:
M6-SPEC §9 + the M5 B-E8 planted-red precedent, kb "deviation-doc-as-pin
pattern, VERIFIED via planted-red MC 11440"; docs/3DR-SPEC.md §2.4 REV 4 is
the law this doc carries). Channels per 3DR-SPEC §2.2. THIS doc is the
T-3DR-c FIRST commit (F-9/M6 law: the deviation doc lands with the shifting
card's first commit, BEFORE the flip bytes — replace-not-delete: the M6 doc
`docs/BYTE-DEVIATION-M6.md` is byte-untouched by this card, ZERO bytes to
it, and its SD-E6 leg stays the M6 pin).

CELL OF RECORD = the `class` cell — the shipped instrument tests
`cls = r["class"].upper()` (3DR-SPEC §2.4, declared choice: the M6 prose
said VERDICT, the instrument reads CLASS; 3DR resolves the mismatch toward
the instrument AND carries the keyword in BOTH class and verdict cells by
the §2.4 c2-fold law, so the choice never bites). The shifting-card,
declared-diff and STAY detail ride the BODY sections below; the footer
stays the SHIPPED 5-column parse contract.

## OWNER-RATIFICATION law (carried verbatim from docs/BYTE-DEVIATION-M6.md:38-44)

> **"SD-E6 (the ratification gate's instrument, `tests/test_sigil_drop.py`):
> the footer table parses; every channel row whose VERDICT cell contains
> SHIFTS / REMINT / RE-DERIVE (case-insensitive) must carry a NON-EMPTY
> OWNER-RATIFICATION cell before the shifting card closes. STAY rows carry
> `n/a — no shift` and need nothing. Planted red (named in the row): an
> EMPTY ratification cell on a declared shift ⇒ the leg RED (proved on a
> COPY — this committed doc is never mutated; capture `.tmp/m6d.txt`)."**

**The empty-cell blocks-close rule** (3DR-SPEC §2.4): no card whose channel
row carries an unratified declared shift CLOSES green. The 3DR ask (§2.2
table → owner package) returned the owner's verbatim answer — typos
intact, pasted never corrected — and it rides every shifting row below:
this milestone's package answer (MC 11773, package item 3, owner "Rec"
2026-10-31): **"UniRig seed 12345, TWO-FAIL STOP per char ->
static+procedural fallback, never a broken animation; fallback rows named
in docs"**. HOLD/STAY rows carry `n/a — no shift` and need nothing.

## §2.1 HOLD list — MEASURED byte-unchanged (battery legs, capture .tmp/3drc.txt)

3DR edits ZERO sim bytes (3DR-SPEC §1.1): no RNG consumer, no pool, no drop
order, no schedule moves — an unexplained byte moved is a FAIL exactly as
in M1–M5. Measured on this card (every leg RED-capable — the cmp itself is
the instrument, capture `.tmp/3drc.txt`):

- **journey-5071 @`HD3D_SEED=11101`**: re-dumped on the PRE-EDIT pristine
  base worktree (anchor capture, BEFORE the flip) = 5071 rows md5
  `5d863b8034018116a00a1015bf7ac1f6` — reproduces the RECORDED digest
  (`docs/BYTE-DEVIATION-M6.md` journey-5061 row / RELEASE-v3.1.0.md, the
  T-M6z re-dump-vs-recorded-digest practice, §2.1's honest instrument).
  POST-FLIP re-dump on the final tree: `cmp` BYTE-IDENTICAL to the anchor
  (md5 equal, 5071 rows) — the flip moved ZERO journey bytes: the honest
  post-flip truth stated here is HOLD, no fork to forgive.
- **12 strict jsonl** (carry-caps-m1b, chests-evolve-m1e, chests-tiers-m2,
  endless-m2, events-m4, gem-merge-m2g, limit-m4, reaper-m4, stages-m3,
  unions-m2u, achv-m5, chars-m5): `md5sum`/`cmp` vs the committed files —
  ALL 12 BYTE-IDENTICAL (the BYTE-DEVIATION-M6 leak-check idiom: channels
  this doc does NOT name must still cmp identical).
- **skinned-clips-s2r-framediff.csv**: BYTE-IDENTICAL (its sources are the
  player + warden rigged twins — untouched by 3DR; the statue twins are NEW
  files, §3.2's HOLD row).

## §2.2 RE-ANCHOR rows — measured under the flipped meshes

- **`roster-clips-m5-framediff.csv` — REMINT (the shifting card: T-3DR-c).**
  DECLARED DIFF: the six M5-era EXCUSED 0-px statue rows split — the THREE
  flipped classes (char-tallow-seer, skin-tide, skin-void;
  docs/RIG-DEVIATION-3DR.md rigged rows) move EXCUSED-0px → 2 motion + 1
  frozen per clip (18 rows: 6 excused -> 18 rig rows), the THREE
  double-fail statics (char-coinhound, char-shroud-saint,
  char-hoard-wretch; owner-ratified fallback rows in the same doc) STAY
  EXCUSED 0-px. MEASURED (the committed driver `tools/roster_clip_gate.py
  --write`, fresh windowed GL capture through the seam — the capture now
  follows `Roster.clip_source`'s `visual` twin so it measures what the pawn
  draws): flipped motion floors walk 117183–150212 px / attack 60877–85519
  px (B-E8/K-E3 floor >= 2 px, 30k× headroom), every frozen control 0 px;
  the fresh capture ran TWICE — converted CSVs cmp BYTE-IDENTICAL
  (twice-cmp law); committed-vs-fresh after the write: 66 fresh vs 66
  committed rows, `ROSTER_CLIP_GATE GREEN` rc=0. Row count moved 55 -> 67
  lines (54 -> 66 data rows, 18 added / 6 replaced).
  SUPERSEDED: the old committed copy (md5 `040ecfa6d46d6d911b6a57e90c1f84de`)
  is archived at `tests/fixtures/superseded/roster-clips-m5-framediff-2026-11-02.csv`
  with a `SUPERSEDED — DO NOT USE` README (versioned-truth doctrine, owner
  ruling 2026-10-22).
- **`art-s2i-probe.jsonl` — REMINT (heights only), MEASURED byte-IDENTICAL.**
  The §2.2 P1-1 fold predicted the file WOULD byte-change; MEASUREMENT
  says otherwise and the measurement wins: a fresh `sim/art_probe.gd` dump
  on the flipped tree is 31 rows md5 `ca71f16dbbc0d0a02abc5ee9c2d59655` —
  cmp BYTE-IDENTICAL to the committed file. Mechanism (honest row): the
  probe's CHARACTERS/SKINS height rows enumerate the mesh LITERALS through
  the ONE ClassMesh seam, which height-normalises EVERY pawn row to
  MODEL_H_PLAYER 1.67 m (rel_err 0.0 by construction) — the re-mastered v3
  meshes land on the SAME pinned row; row-0 player + all horde rows
  byte-preserved (forward-lock law). REMINT here = the channel was
  RE-MEASURED live, and its honest measured diff is ZERO — the footer's
  verdict cell says exactly that.
- **roster-capture + dawnwell pixel-gate character shots — RE-MEASURE,
  expect STAY.** `tools/dawnwell_pixel_gate.py` re-ran GREEN rc=0 on the
  flipped tree, all 5 legs PASS (char_select non-bg 65237 px vs floor 200;
  the portraits/silhouettes ride untouched icons); no committed PNG moved —
  a diff would be a finding, not a re-anchor (§2.2).
- **motion-capture shots (bob/lean) — RE-MEASURE, expect STAY.**
  `tools/motion_gate.py` GREEN on the flipped tree (static-arm bob/lean vs
  the ground floor; the flipped pawns' walk frames ride the CLIPS through
  the B-E8/K-E3 CSV rows above — the s8-style contract row, shot PNGs are
  not a committed-corpus channel).

## §2.4 parse instrument (T-3DR-c owns the seven parameterisation edits)

`tests/test_sigil_drop.py` carries ONE parse function + a per-doc
PARAMETERS MATRIX (path / verbatim / ruling-date / row-count / shifting
threshold / channel universe + the independent empty-cell assert BEFORE
the verbatim on the shifting branch — the EMPTY-cell planted-red REDS for
the EMPTY-CELL reason, not via the M6-quote side effect). M6's entry keeps
its literals byte-true (26 rows, the verbatim quote, 2026-10-29, ≥5,
journey/strips/s8-capture); the 3DR entry pins THIS footer: 5 rows,
threshold ≥2, channels `roster-clips` + `art-s2i`, verbatim `"Rec"`, date
`2026-10-31`. The committed M6 doc is never mutated; the empty-cell leg
re-runs on a COPY (capture `.tmp/3drc.txt`).

## OWNER-RATIFICATION FOOTER (the SD-E6 instrument parses THIS table)

| channel | class | verdict | mechanism | owner-ratification |
|---|---|---|---|---|
| roster-clips-m5-framediff.csv | REMINT | REMINT — MEASURED: 6 EXCUSED rows -> 18 rig rows (walk floors 117183–150212 px, attack floors 60877–85519 px, frozen 0 px); twice-cmp BYTE-STABLE; gate GREEN 66/66 | tools/roster_clip_gate.py --write, capture follows the seam's visual twin (T-3DR-c); old copy superseded-annotated, 3 flipped / 3 double-fail statics per docs/RIG-DEVIATION-3DR.md | "UniRig seed 12345, TWO-FAIL STOP per char -> static+procedural fallback, never a broken animation; fallback rows named in docs" (owner "Rec" 2026-10-31 — MC 11773 package item 3, the 3DR binding cell) |
| art-s2i-probe.jsonl | REMINT | REMINT (heights only) — MEASURED BYTE-IDENTICAL re-measure (31 rows, md5 ca71f16…, cmp vs committed): the ClassMesh normalization pins every pawn height row at 1.67 m rel_err 0.0 | sim/art_probe.gd fresh HD3D_ART_DUMP run on the flipped tree + cmp; the §2.2 will-byte-change premise refuted by measurement — honest diff ZERO, row-0 + horde rows byte-preserved | "UniRig seed 12345, TWO-FAIL STOP per char -> static+procedural fallback, never a broken animation; fallback rows named in docs" (owner "Rec" 2026-10-31 — MC 11773 package item 3, the 3DR binding cell) |
| dawnwell pixel-gate character shots | RE-MEASURE | STAY — MEASURED GREEN rc=0 (5/5 legs, char_select 65237 px vs floor 200); no committed PNG moved | tools/dawnwell_pixel_gate.py re-run on the flipped tree (§2.2 expect-STAY row; a diff = finding) | n/a — no shift |
| motion-capture shots (bob/lean) | RE-MEASURE | STAY — MEASURED MOTION_GATE GREEN on the flipped tree; flipped walk frames ride the CLIPS (CSV row above), the static arm keeps the ONE gait_wave law | tools/motion_gate.py re-run (§2.2 shot-contract row, s8-style — not a byte corpus) | n/a — no shift |
| journey-5071@11101 + 12 strict jsonl + skinned-s2r CSV | HOLD | HOLD — MEASURED byte-IDENTICAL both anchor (pre-flip, md5 5d863b80…) AND post-flip (cmp vs the anchor; 12/12 jsonl cmp; skinned cmp) | sim_headless + per-channel re-dump/cmp battery, capture .tmp/3drc.txt (§2.1 — the channels this doc does NOT shift must cmp identical) | n/a — no shift |
