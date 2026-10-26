# CLEAN-CODE AUDIT-2 — bryn1/hollow-dawn-3d @ v2.1.0 (MC 11398, T-M5a)

Author: hygiene (11398) <hygiene@agent-town.local>
Base: origin/master @ c13bbc6 (the v2.1.0 tag commit) — worktree audit
(`hdwt-11398`), tree untouched; this file is the ONLY product-tree change the
card makes (proof: `git diff --name-only v2.1.0..HEAD` after this commit =
`docs/CLEAN-CODE-AUDIT-2.md` alone, restated at the bottom).
Method: findings ONLY, zero refactoring executed; the EXISTING instruments, no
new mechanisms. Raw stdout of every instrument run captured at
`.tmp/cc-audit2.txt` (main checkout, ends `VERIFY_EXIT=0`). Universe rule: the
gate checker's OWN module — `dod_hygiene.is_source` from the one gate home
(`~/.local/bin/dod_hygiene.py`, verkstad-synced) — imported and walked over
`git ls-files` (547 tracked, 108 is_source), same rule-(h) shape as the
precedent MC 11316 (`docs/CLEAN-CODE-AUDIT.md`). The python suite was RUN on
this tree (`pytest tests -q` → **278 passed**, 161 s — matching the LEDGER
T-M4z row 263+15). Every finding row carries its measured before-number
(walk stdout line, LOC, or instrument stdout), severity, and byte-anchors;
the FIX-LIST clusters honor the same-file rule (one file, one cluster) so a
refactor run splits serial/parallel per cluster. BYTE-RISK = the fix touches
an RNG/spawn/render path or a committed byte-anchor corpus (fixtures + journey
5020 byte-identical; strips modulo the declared norm `_ms`-strip + png-dir;
s8 dumps are contract-checked RUNTIME records, never byte-pinned).

Headline: the C1–C5 refactor waves LANDED and landed clean — SimFunnel is
adopted by every dump-driver that took it (the M4 trio included: events 10 /
reaper 10 / limit 7 funnel calls, all wrappers thin delegators, both `_decline`
forks kept named), the conftest v1-server block is gone, the test-helper family
is one home, the `.gitignore`/tracked-`.tmp` law is satisfied (`git ls-files -i
-c --exclude-standard` → 0 rows, measured), the four vm100 one-shots are
deleted, the LIMIT_ICONS dead-row candidate was AVOIDED by design (test-armed,
`test_limit_break.py:121` asserts the dead mapping never appears beside the
inline icon paths), and the M4 mechanisms are replace-not-add (event cone
REPLACES `randf() * TAU` with a negative pin at `test_events.py:96`; the reaper
latch is the schedule-latch shape in the same function `world.gd:336`; the
limit terms ride the existing single-impl functions as zero-identity factors).
What is left IS worth a refactor run: two new M4 sim files crossed/landed over
the 400 line without the reason header, two M4-era carry-overs sit at 591 and
488, four harness sites kept a verbatim copy of the `fresh_run` body beside the
seam, one conftest helper re-copied itself into `test_reaper.py`, and the
leaderboard doc claim survived the deletion of its last vestige — plus a
measured CONTRADICTION against the prior audit's "measured clean" row (§1.5).

## 1. CEILINGS (gate walk: dod_hygiene is_source universe; full stdout in the capture)

Walk findings (non-test source >400 with no `reason` in first 5 lines), and
NO file anywhere in the tree is >600 without a reason (both test and non-test
>600 arms: zero rows). Reasoned-over-400, healthy: sim_stages 583, world 548,
weapons 478, main 472, screens 445.

- [P2] godot/sim/sim_events.gd — **533 LOC, brand-new in M4** (v2.0.0=0 →
  v2.1.0=533), no `reason` in first 5 lines (`head -5 | grep -ci reason` → 0).
  The biggest file M4 landed; the leg table + six legs ARE its contract but
  that is exactly what the header must SAY. Smallest fix: 3-line reason header
  (leg table + cone/surge legs = the one events dump contract, the
  sim_chest_tiers precedent); a legs split is BYTE-RISK and not asked.
  Byte-risk: NO for the header (comments; pck law per precedent C4).
- [P2] godot/sim/sim_budget.gd — **472 LOC, grew 330→472 in the M4 window**
  (diffstat +164/−22) crossing 400 with no `reason` — the exact (h2) growth
  class the gate exists to catch. Smallest fix: reason header (worst-case-draw
  legs share the one pinned loadout). Byte-risk: NO for the header; the file's
  funnel conversion is C2 (below).
- [P3] godot/sim/strips_capture.gd — **591 LOC** (unchanged v2.0.0→v2.1.0), no
  reason line. Deferred TWICE now (prior F3 said "bundle into whichever card
  next touches those files" — M4 never touched it). 9 lines from the 600 hard
  fail; the next card touching this file MUST land the header. Byte-risk: NO.
- [P3] godot/sim/sim_union.gd — **488 LOC** (unchanged), no reason line — same
  deferred carry-over. Fix: header (the header text also has to NAME its
  §2.2 non-adoption). Byte-risk: NO for the header.
- [P3] godot/sim/sim_evolve.gd **435** + godot/sim/sim_headless.gd **402** —
  non-test >400 NO-REASON rows the walk measures and the PRIOR audit did not
  file: both were already 435/402 no-reason AT the v2.0.0 tag (measured at the
  tag this session: `git show v2.0.0:... | head -5 | grep -ci reason` → 0,
  0). Prior §1's "Measured clean otherwise" is **CONTRADICTED** — named here
  so the refactor wave carries it and no future doc re-ships that claim.
  Fix: reason headers (harness-runner and evolve-legs one-concern laws).
  Byte-risk: NO.
- [P4] godot/scripts/world.gd:2-4 — the reason header still says "M1-M3 law"
  while the file grew 419→**548** in M4 (event cone, reaper latch, windows) —
  a versioned-truth wording slip, and concern_check measures it
  `JUSTIFIED-NOT-REDUCED` (defs=12, comps 4, clusters `seed_stage_props;
  update_entities`): per owner ruling MC 10062.242 the reason SCHEDULES the
  split, never absolves it. Smallest fix: one wording line (M1-M4) + keep the
  scheduled split; do NOT grow this file again without the split card.

## 2. DUPLICATE MECHANISMS (replace-not-delete hunt)

- [P3] SimFunnel conversion left **4 verbatim body-sites beside the seam**
  (all pre-existing at v2.0.0, C3 missed them): `sim_budget.gd:258` (s3 leg)
  and `:334` (s4 leg) — byte-shaped copies of
  `fresh_run(root,{wire_pick,stage})`; `sim_union.gd:423` (`_leg_fire`) and
  `sim_combat.gd:84` (`run_leg`) — byte-shaped copies of `fresh_run(root,{})`.
  Order matches the funnel verbatim (instantiate→add→stub→wire start→
  [wire pick]→[stage]→`_start_game`). Divergence is OK; these are not
  divergent — they ARE the donor bodies. Smallest fix: convert the 4 sites to
  `SimFunnel.fresh_run(root, opts)` (sim_budget keeps its two reason lines from
  §1 inside the same card — same-file rule). BYTE-RISK: YES — accept only with
  budget legs re-dumped, unions-29 + combat fixtures + events/reaper/limit
  fixtures byte-identical, journey 5020 cmp unchanged (product scripts
  untouched → pck unchanged, named).
- [P3] tests/test_reaper.py:58-62 — `const()` re-copied **verbatim** (same
  regex, same assert, same return) beside `conftest.const` (conftest.py:79-82):
  the C2 "replaces const x11" family re-grew by 1 the same release it was
  centralized. Smallest fix: `const = conftest.const` — the exact shape
  `test_events.py:38` already uses. Byte-risk: NO (reader only; acceptance =
  suite 278 green + the moved regex byte-compared to its donor).
- [P4] the three new tests each inline the rows filter inside their `leg()`
  helper (`test_events.py:42`, `test_reaper.py:51`, `test_limit_break.py:53`)
  beside `conftest.rows_by_ev` — one-line copies, drift hazard only. Fix:
  delegate. Byte-risk: NO.
- DEFENDED (leave alone, measured/armed):
  the ten `*_capture.gd`/probe one-shots keep their own instantiate+stub-wire
  idiom (prior §2 close pattern — ten one-shot artifacts, each leg table IS its
  contract; a fresh_run with `{}` opts would couple them for ~6 lines each);
  s8_capture.gd's `HD3D_REAPER`/`HD3D_EVENTWAVE` variant flags are the declared
  `HD3D_STAGE` pattern extended (diff shows comment-pinned variant law, default
  shots byte-untouched); LIMIT_CARDS rides INLINE shipped-icon paths with a
  test asserting the dead `LIMIT_ICONS` mapping never returns to screens.gd —
  the brief's icon candidate is RESOLVED, not filed; tile_gate.py /
  tile_post.py are the ONE committed gate + its reproducibility recipe
  (LEDGER:51, PERMANENCE:282-284, DESIGN-3D:262 name them); the mocap
  00–06 chain is the documented manual probe (tools/mocap/README.md +
  PERMANENCE/PARITY refs) — dead_code's DRIVERLESS/ORPHAN stdout on it is the
  name-based limit of the instrument, not a finding.

## 3. DEAD CODE (scripts/dead_code.py run; full stdout in the capture)

- Resolved since the prior audit (replace-not-delete ledger): the four
  driverless vm100 one-shots are DELETED (diffstat: 02-install-unirig,
  make_synth, run-unirig-giraffe-inner, sitecustomize-venvrig all −); the
  conftest v1-server block is DELETED (conftest 91 lines, header names the
  zero-consumers re-proof); `.tmp` tracked-vs-ignored is FIXED (measured 0
  tracked-yet-ignored rows; the three s8 dumps + s8-shots now tracked, the
  S9 table green-from-clone by construction).
- [P4] .tmp/run-player-s1p.sh — the one tracked `.sh`, still **driverless**:
  zero references anywhere outside the prior audit doc that flagged it
  (grep this session). The dead_code law wants it wired, deleted, or a
  PERMANENCE row naming it the kept manual replay probe — smallest fix the
  row. Byte-risk: NO.
- NOT dead: `tools/red_controls/mut_a_invincibility.sh` (LEDGER:40 names the
  committed RED CONTROL with both legs proven — the DRIVERLESS stdout is the
  manual-gate shape); tile_gate/tile_post/art manifests (refs above);
  every M4 constant measured LIVE (`EVENT_SURGE` 11 uses, `CONE_ALL` 8,
  `REAPER_PERIOD` 6; zero uncalled `_leg_*` across the trio; the
  `the-reaper` ENEMY_TYPES row and `reaper_spawned` latch read from
  world.gd:336-339/474).

## 4. STALE / CONTRADICTED DOC CLAIMS

- [P2] **The leaderboard claim survived its mechanism's deletion.** README:13
  lists "global leaderboard" as a shipped feature of the inherited core loop;
  DESIGN-3D:274 claims "Vendored byte-identical: server/server.py (sha
  2f973d89…38ee)" and DESIGN-3D:312 the tree shape "server/ vendored verbatim;
  static/ export target". Measured against the tree: `ls server static` →
  absent, `git log --all -- server/` → ZERO commits ever (never vendored, not
  "vendored then removed"), and the only leaderboard artifact left is the
  no-op JS-bridge comment at main.gd:381 with its own "JS-side existence check
  keeps this a no-op even when the bridge is [absent]". The prior audit folded
  the PARITY row-13 wording as "rides the vendored-v1-server mechanism" — that
  mechanism's last vestige (the conftest harness) was deleted by C2 and the
  README/DESIGN claim stayed. This is the owner's contradicted-claim class;
  smallest fix: ONE honest doc-sync pass — mark leaderboard/server EXCLUDED
  (matching PARITY:50) or file the vendoring card; then grep-to-zero for
  "global leaderboard"/"vendored" outside the PARITY EXCLUDED row + release
  history. Byte-risk: NO (docs only).
- [P4] DESIGN-3D:314 — "every script above ≤ 300 lines
  (`test_tree_hygiene.py:19` gate ships with the copy)": the gate file does
  not exist in this repo (git-measured) and the 300 law is not the fleet law
  (250/400/600, dod_hygiene rule (h)). Fix: point the row at rule (h).
- [P4-note] DESIGN-3D:278's `conftest.py:22-23` MAIN_PORT cite and the DOD
  v1-relative pins are DEFENDED by the docs' own declared convention
  (DESIGN-3D:9 / DOD-ACCEPTANCE:11-12 "citations are v1-relative") — the
  T-M4z punted backlog line is honest but the convention covers the pins;
  only the :314 gate row and the §4.1 vendored claims actually mis-describe
  THIS tree. Spot-truth VERIFIED GREEN this session: PARITY:44 re-pinned to
  game_state.gd:173 "old pins :56, :139; re-grepped at the v2.1.0 cut"
  (prior §4.1 RESOLVED); conftest REPO/SCRIPTS constants land where cited.

## 5. TEST QUALITY (new M4 tests)

- Planted-red history: all three new test files have NAMED reds in the LEDGER
  (T-M4e row :52 — cone share / saturation / RNG-twin fork "proven RED",
  capture `.tmp/m4e-events.txt`; T-M4r row :53 — default-flag-true,
  spawn-at-840, contact-law, once-latch, cap-fork-reorder, 13th-snapshot-field,
  pixel n=0, all "proven RED then byte-exact restored (cp+cmp) ON THE FINAL
  TREE"; T-M4l row :54 — fallback-removed, bad-icon, fury_math,
  zero-bytes-exact + journey-corpus RED, limit-into-gold double-pin). No
  un-named-red rows.
- Vacuity scan (the rename-the-code thought experiment + the 2026-10-24
  arm-scoping lesson): the new source-regex pins are BLOCK-/FUNC-SCOPED —
  `test_events.py:80` anchors `cone…ALIVE_CAP` inside the spawn body and
  :96 scopes the negative pin to `func _spawn_enemy`'s slice;
  `test_reaper.py:147` pins the gate regex to the two-line while-condition and
  :148 the WIN_TIME+ leg body; `test_limit_break.py:76/:79` search INSIDE
  block captures (`LIMIT_CARDS`/`PASSIVES` const blocks), :86/:98 pin arm
  bodies. No un-scoped shared-word or-regex found. Fixture-trust rows are the
  declared byte-anchor design (dump-row checks re-proved by card-time re-dump
  cmp), named as such in the test headers. The exact-12 snapshot key list is
  NOT re-literalized in test_reaper (it reads the dumped `exact_12` check) —
  SNAPSHOT_KEYS stays one copy (conftest + test_endless users, measured).
- The §2.2 const copy is the only test-quality defect filed; verdict on the
  new tests as a set: meaningful.
- Suite RUN green here (278 passed) — nothing above is a correctness finding.

## FIX-LIST (cluster = one wave; same-file rule holds: a file appears in
exactly ONE cluster; C1/C3/C4 are mutually independent and parallel-safe,
C2 is independent of all three but runs serial inside itself)

- **C1 godot/sim + world headers (SAFE, comment-only)** — sim_events.gd,
  strips_capture.gd, sim_evolve.gd, sim_headless.gd reason headers (§1 rows
  1, 4, 5, 6) + world.gd header wording M1-M3→M1-M4 (§1.6).
  Verification recipe: suite 278 green + the §1 walk re-run returns 0 findings
  for these files; comments are stripped at GD compile (prior C4 precedent:
  header adds shipped pck-neutral, the weapons.gd row is the live proof).
- **C2 godot/sim funnel completion (BYTE-RISK)** — convert the 4 verbatim
  sites (§2.1: sim_budget:258/:334, sim_union:423, sim_combat:84) to
  `SimFunnel.fresh_run(root, opts)`; sim_budget + sim_union reason headers
  (§1.2, §1.4) ride THIS cluster (same-file rule). MUST-HOLD byte-anchors:
  journey 5020 rows byte-identical, every committed fixture jsonl
  (unions 29, events/reaper/limit-m4, endless 13, gems 6, stages-m3 17,
  chests-tiers 16, art 15 + 3) byte-identical, strips modulo the declared
  norm, s8 dumps contract-checks (NOT byte), budget legs re-dumped twice-cmp.
  Reject on any fixture byte move without a declared re-mint row.
- **C3 tests/ (SAFE)** — kill the `const` re-copy in test_reaper.py (§2.2) +
  delegate the three inline rows filters to `conftest.rows_by_ev` (§2.3).
  Verification: suite 278 green + moved helper byte-compared to donor.
- **C4 docs/ (SAFE)** — the leaderboard/vendored-server honest pass (§4.1)
  across README:13 + DESIGN-3D:272-276/312 + PARITY:50 wording; the :314
  gate-law row (§4.2); PERMANENCE row for .tmp/run-player-s1p.sh (§3.2).
  Verification: named grep-to-zero rows written in the card's evidence.

## DEFERRALS (with reason)

- world.gd's JUSTIFIED-NOT-REDUCED split (spawn/entity/tabs vs reaper+cone
  logic) — stays SCHEDULED per MC 10062.242, not a C1-C4 wave: the split is
  BYTE-RISK on the live spawn/RNG path and M5 growth into world.gd is the
  card that must carry it (prior audit's sim_stages deferral pattern, which
  worked: 600→583 when C3 opened the file).
- sim_events 533 LOC split (legs vs harness) — the reason header is the honest
  ceiling fix; a split forks the events dump contract for no gate win (583's
  sim_stages is the accepted size shape).
- Capture one-shots' inline wire idiom — DEFENDED (§2); ten one-shot
  artifacts, coupling cost > copy cost, prior audit's law.
- Mocap chain `--allow` — a PERMANENCE/doc row already names the chain; a
  literal dead_code `--allow` file is seat-local, not tree debt.
- DESIGN-3D v1-relative `path:line` sweep — convention DEFENDED at DESIGN-3D:9
  and DOD-ACCEPTANCE:11; a re-pin pass over v1 cites would rewrite history-
  pinned design text for zero truth gain (only the two rows §4.1/§4.2 describe
  THIS tree wrongly and they are filed).

CAPTURE: `.tmp/cc-audit2.txt` (main checkout, gitignored) — raw stdout of the
dod_hygiene-universe walk, concern_check, dead_code, the tracked-yet-ignored
proof, the LOC measurements at both tags, and the suite run; ends
`VERIFY_EXIT=0`. Instruments run: 6 (walk, concern_check, dead_code,
git ls-files -i, LOC-at-tag pairs, pytest).

GIT-DIFF UNIVERSE PROOF: `git diff --name-only v2.1.0..HEAD` on master after
this commit lists exactly `docs/CLEAN-CODE-AUDIT-2.md` — docs-only, zero
product diff (the card's own gate-run of the §(h) universe, over the untouched
v2.1.0 tree).

# VERDICT: FIX
