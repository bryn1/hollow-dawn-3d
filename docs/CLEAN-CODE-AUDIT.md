# CLEAN-CODE AUDIT — bryn1/hollow-dawn-3d @ v2.0.0 (MC 11316, T-C1)

Author: devils-advocate (11316) <devils-advocate@agent-town.local>
Base: origin/master @ 6a0bea5 (the v2.0.0 tag commit) — worktree audit, tree untouched.
Method: findings ONLY, zero refactoring executed. Line counts measured `wc -l`
this session; the python suite was RUN on this tree (`pytest tests -q` →
**242 passed**, matching RELEASE-v2.0.0). Every finding is
`[P1|P2|P3] file:line — defect — smallest fix — BYTE-RISK?`, grouped by file in
the FIX-LIST below so MC 11317 can wave-split per the same-file rule.
BYTE-RISK = the fix touches an RNG/spawn/render path or a committed
byte-anchor corpus (the fixtures/journey/pck), so the refactor card must prove
byte-identity after the change; SAFE otherwise.

Headline: the base is healthy — no P1, the game code is ceiling-clean except
one header, and the real debt is concentrated in the HARNESS layer (godot/sim
leg plumbing, tools capture/pixel scaffolding, tests helper sprawl) plus one
dead v1-server block in conftest. This is a FIX, not a RECONSIDER: every
finding is a wave-splittable extraction or deletion; nothing here is a
structural problem a refactor pass cannot fix.

## 1. CEILINGS (source ~250 soft / >400 needs reason line / tests+sim 600 hard)

- [P2] godot/scripts/weapons.gd:1 — 474-line shipped source file with NO
  `reason:` line in its first 5 lines (dod rule (h): >400 without a reason
  header is the gate failure). Every other >400 sibling (screens/main/world/
  sim_stages/sim_chest_tiers) has one; weapons.gd is the lone violator.
  Smallest fix: a 3-line `reason:` header (ONE _fire dispatch = one seam, the
  kill-funnel law) — byte-safe. The alternative split (extract
  `_update_orbit`/`_step_projectiles`/`_step_fx`, :344-474) forks the projectile
  seam beside the fire dispatch — worse, and BYTE-RISK. Prefer the header.
- [P3] godot/sim/sim_stages.gd:600 — EXACTLY at the 600 hard cap (its own
  header reason defends the single ROWS map; accepted for v2.0.0). ANY M4
  growth fails the gate. Nearest honest split line: the A-E4 plates family
  (`_leg_plates_rate`→`_sat_window`, :321-475, ~155 lines) into a `SimPlatesLegs`
  module appended at the `_run_legs` tail exactly like `SimBosses.new().run_boss_legs(self)`
  (:599) already does. BYTE-RISK: yes (dump row order must survive → re-dump +
  cmp stages-m3.jsonl byte-identical before accepting). Deferrable (see §6).
- [P3] godot/sim/strips_capture.gd (591) and godot/sim/sim_union.gd (488) —
  sim-family files >400 with no `reason:` line; under the 600 gate but one
  card's growth from it. Fix: add the reason line (the fleet's own convention,
  e.g. sim_chest_tiers.gd:3-5). BYTE-RISK: no (comment-only).

Measured clean otherwise: every tests/*.py ≤ 399; all other >400 files carry
valid reason headers (screens.gd:2, main.gd:4, world.gd:2, sim_stages.gd:2,
sim_chest_tiers.gd:3).

## 2. DUPLICATE MECHANISMS

- [P2] Sim leg plumbing — the biggest one. Verbatim `_check` ×4
  (sim_chest_tiers.gd:102 / sim_endless.gd:125 / sim_gems.gd:93 /
  sim_stages.gd:99 — byte-identical 11-line function); `_fresh_run` ×6 with
  one declared variant each (sim_boss.gd:278, sim_budget.gd:78,
  sim_chest_tiers.gd:90, sim_endless.gd:93, sim_gems.gd:81, sim_stages.gd:116
  + the no_wipe twin :527); `_decline` ×4 (sim_boss.gd:296, sim_budget.gd:100,
  sim_endless.gd:108, sim_stages.gd:111); `_out_path` ×6; `_r3` ×3
  (sim_boss.gd:322, sim_endless.gd:137, sim_s8.gd:171); the
  Main.tscn-instantiate + SimStubScreens-wire idiom at ~25 sites in 21 files
  (grep `load("res://Main.tscn").instantiate()` + `SimStubScreens.new()`).
  Smallest shared seam: ONE `godot/sim/sim_funnel.gd` (`class_name SimFunnel`,
  the stub_screens.gd precedent): `fresh_run(root, opts)`, `check/ok/rows`,
  `decline`, `out_path(env, default)`, `r3`. HAZARD the refactor card MUST
  keep: sim_stages._decline is NOT the siblings' decline — it PICKS card 0
  (its comment claims "the sim_budget/sim_endless pattern", which it is not);
  both semantics (decline = zero pending + set phase; accept-first = _pick(0))
  need distinct named helpers or the merge changes leg behavior.
  BYTE-RISK: YES — every committed dump (endless 13, gems 6, unions 29,
  chests-tiers 16, stages-m3 17, art 15, journey 5020) is byte-pinned; the
  extraction is accepted only with fresh re-dumps cmp BYTE-IDENTICAL, the LEDGA
  byte-anchor rows in the LEDGER are the acceptance instrument.
- [P2] Python tool capture-launcher ×4 — chest_pixel_gate.py:39-66 /
  dawnwell_pixel_gate.py:34-61 / biome_readability.py:60-104 /
  upgrades_visual_probe.py:65-140: identical `GODOT = os.environ.get(
  "HD3D_GODOT", <same literal path>)` + `xvfb-run -a … -s SCRIPT` + CAPTURE_OK
  grep; the engine path is ALSO pinned in tools/VERSIONS.txt:8 (a third home).
  Smallest seam: `tools/capture_lib.py` `run_capture(script, env_extra,
  timeout)` + one binary resolution. BYTE-RISK: no (launcher only; capture
  outputs unchanged).
- [P2] Pixel-compare seams ×3 — chest_pixel_gate.py:92-96 and
  dawnwell_pixel_gate.py:91-95 are VERBATIM (window clamp + `np.abs(shot-base
  ).max(axis=2)` + `> DELTA` window/total counts, DELTA=12 both);
  s8_acceptance.py:56-64 `crop_nonbg` is a third same-contract impl (PIL,
  DIFF_MIN=24 per-channel). biome_readability.py `metrics` is a DIFFERENT
  contract (luma/readability) — defended, do not fold. Smallest seam:
  `tools/pixel_lib.py::window_delta_counts(shot, base, cx, cy, half, delta)`.
  BYTE-RISK: no (offline gates; the planted-red controls ride the gate files —
  move them WITH the seam or prove them again).
- [P2] tests/ dump-loader family ×10 — conftest.py:141 `stages_row` (declared
  "the ONE reader" of stages-m3) plus `rows_of` copies at
  test_endless.py:72, test_gem_merge.py:69, test_chests_tiers.py:118 and inline
  loaders at test_boss_numbers.py:177-180 (which opens chests-tiers-m2.jsonl
  while its own comment says "never a second loader class" — it is one),
  test_stages.py:387-388, test_chests_evolve.py:179, test_levelup_caps.py:98,
  test_unions.py:69, test_art_integration.py:65. Smallest seam:
  `conftest.jsonl_rows(path)` + `conftest.rows_by_ev(path, ev)`; `stages_row`
  becomes a wrapper. BYTE-RISK: no (readers only).
- [P2] tests/ source-pin helper family — `read()` ×16 copies,
  `const(name, source)` ×11 verbatim copies (first-line-identical across
  test_biome_numbers/boss_numbers/chests_evolve/combat_numbers/dawnwell_shop/
  endless/game_numbers/gem_merge/levelup_caps/save/stages), `block()` ×2
  (test_boss_numbers.py, test_stages.py). Smallest seam: move the three
  helpers into conftest.py (they already `import conftest`). BYTE-RISK: no.
- Defended duplication (leave alone): the nine GD `*_capture.gd` scripts each
  carry their own `_save_png`/CAPTURE_OK tail — the capture files document
  "the pattern reused verbatim" and each leg table IS its contract; a shared
  CaptureKit would couple nine one-shot artifacts for ~10 lines each. GD
  `_out_path` env-name variety (HD3D_ENDLESS…/HD3D_OUT) is documented
  (rev-2 P4-3 naming note, sim_endless.gd:10). Seed-scan loops: none
  committed — the scans were card-local (LEDGER T-S8/T-M3z rows), so there is
  nothing to dedupe.

## 3. DEAD CODE

- [P2] tests/conftest.py:29-139 — the ENTIRE v1-server harness is orphaned in
  THIS repo: `purge_db`/`http_request`/`get_json`/`post_json`/`class Server`/
  `server` fixture/`clean_leaderboard` autouse target `server/server.py`,
  `static/`, VS_DB, port 8941/8942 — none of which exist in the 3D tree
  (`ls server static` → absent), and NO test requests the `server` fixture
  (grep: zero users; the autouse guard short-circuits for all 242 tests). It is
  the 2D repo's leaderboard-server scaffolding (MC 11026 lineage) carried into
  the remake. Smallest fix: delete conftest.py:1-30,36-139 (keep `REPO` :18
  and `stages_row` :141-153 — both live and widely used). BYTE-RISK: no.
- [P3] Driverless one-shot tools with ZERO references anywhere (tree, docs,
  LEDGER, other tools): tools/vm100/make_synth.py, tools/vm100/
  sitecustomize-venvrig.py, tools/vm100/run-unirig-giraffe-inner.sh,
  tools/vm100/02-install-unirig.sh. (Wired siblings for contrast:
  01-check-env/00-run-all chain, run-trellis-inner→poc_trellis,
  run-batch-inner←player_attempts+LEDGER.) Fix: one PERMANENCE/LEDGER row
  naming each as a kept manual probe (the dead_code --allow discipline) or
  delete. BYTE-RISK: no.
- [P3] .gitignore law vs tree: `.gitignore:2` ignores `.tmp/` while 38 files
  are TRACKED under `.tmp/` (acceptance dumps, fx shots,
  .tmp/run-player-s1p.sh — itself driverless). The tracked/untracked split is
  also load-bearing-inconsistent: tools/s8_acceptance.py:31-38 reads
  .tmp/hd3d-strips-s2p-dump.jsonl (tracked, works) AND .tmp/hd3d-boss-s6-
  dump.jsonl / .tmp/s8-gameover.jsonl / .tmp/s8-win.jsonl (NOT tracked) — on a
  clean checkout those rows honestly print BLOCKED, so the S9 acceptance table
  is not green-from-clone without re-runs of the real-clock legs (~20 min GPU
  sim each). Smallest fix: negate the tracked rows in .gitignore (or move
  pinned inputs to tests/fixtures/) and carry the three s8 dumps as tracked
  inputs like the strips dump already is; evidence-only txt stays OUT.
  BYTE-RISK: no (s8_acceptance edit = TESTED-class).
- NOT dead (defended, do-not-touch list): stub_screens/sim_policy/sim_combat/
  strips_attack/strips_fx_leg/strips_probe are all `class_name`-live
  (SimStubScreens ×24, SimPolicy ×4, SimCombat ×2, Strips* ×strips_capture);
  FALSIFIED-AND-REPLACED / retire-ledger / UNIFIED-TIER / STAY-GREEN
  (game_state.gd:56) rows and the stage-1 byte corpus are DOCUMENTED-RETAINED;
  docs/{M2,M3}-SPEC-DA*, PARITY-ROADMAP-DA* are immutable review-round
  provenance (c3 cites c2 "immutable") — history, not debt.

## 4. STALE COMMENTS / DOCS

- [P3] docs/PARITY-ROADMAP.md:44 — row 7 pins "talon start
  (`game_state.gd:56`)": :56 is the passives STAY-GREEN byte-pin comment; the
  talon start is game_state.gd:139 (`weapons = [{"id": "talon", …}]`). The GA
  doc-sync card re-grepped the N-table but this one row ref slipped. Fix: the
  line ref. BYTE-RISK: no.
- [P2-folded] tests/conftest.py:1 — docstring "the REAL server as a
  subprocess on seat-owned ports … 8941 … VS_DB" asserts a mechanism THIS repo
  has none of (see §3 first finding); the stale doc is part of that deletion.
- Spot-truth VERIFIED GREEN (measured, not assumed): doc line-refs
  render.gd:104 STAGES / screens.gd:381 show_stages / world.gd:8,12,29,76,365 /
  game_state.gd:7 / levelup.gd:10 all land on the claimed construct; README
  feature claims (3 stages, unlock levels 10/14, 900 s win, 400 cap, 3 chest
  tiers 7 map rows, 200/100 merge, 24 shop rows, 16 weapons/15 passives)
  match the source; RELEASE-v2.0.0.md "pytest 242 passed" == this audit's
  run; the "leaderboard" claim rides the declared vendored-v1-server
  mechanism (PARITY-ROADMAP row 13) and is not a 3D-tree claim.

## 5. TEST QUALITY

- [P2] Cross-file duplicated pins that can drift apart: WIN_TIME asserted in 5
  files (test_biome_numbers, test_chests_evolve, test_endless,
  test_game_numbers, test_stages), ALIVE_CAP in 3 (test_endless,
  test_game_numbers, test_stages), HP_EFFECTIVE_MULT_CAP in 2 (test_biome_
  numbers, test_endless); the frozen Contract-B 12-field key list exists TWICE
  — tests/test_endless.py:61 SNAPSHOT_KEYS and godot/sim/sim_stages.gd:573
  (the sim's `expected`). If M4 moves a value, five files must move in
  lockstep. Defended as intentional re-pin doctrine — but the SNAPSHOT_KEYS
  twin is pure drift hazard (tests↔sim, byte corpus behind both): smallest fix
  one conftest constant + import. BYTE-RISK: no.
- [P3] Vacuity arm on source-regex pins (the rename-the-code thought
  experiment): name-substring pins like test_stages.py:375
  `assert "DRAWS" in body and "_plate" in body` and the 11× `const(NAME)`
  regexes GO RED on a pure rename that preserves behavior — they are the
  declared ONE-seam/verbatim-port contract, not vacuous pins; the honest risk
  is brittleness, not false green. The fixture-trust assertions
  (`assert v["ok"] is True and v["rows"] == 15`, test_chests_tiers.py:279-283
  class) freeze engine-computed checks in committed dumps — that IS the
  byte-anchor design (the sim-side half is re-proved by the card-time fresh
  re-dump cmp, not by pytest); no change asked, just name it so nobody later
  mistakes the verdict-row assertions for live-game proof. BYTE-RISK: no.
- Suite RUN green here (242 passed, 135 s) — the audit does not report a red
  tree; everything above is harness quality, not correctness.

## FIX-LIST (grouped by file cluster; one cluster = one wave, same-file rule:
a file appears in exactly ONE cluster; clusters are independent of each other)

- **C1 tools/ (SAFE)** — F: capture_lib seam (chest_pixel_gate.py,
  dawnwell_pixel_gate.py, biome_readability.py, upgrades_visual_probe.py,
  s8_acceptance.py's GODOT resolution), pixel_lib seam (chest:92-96,
  dawnwell:91-95, s8 crop_nonbg), orphan row/delete for the four vm100
  one-shots (§3.2), .tmp tracked-row negation in .gitignore + track the three
  s8 dumps (§3.3). Byte-risk verdict: NONE (launcher/gate/ignore only; re-run
  both pixel gates green + their planted-red controls after the move).
- **C2 tests/ (SAFE)** — conftest gains jsonl_rows/rows_by_ev + read/const/
  block + SNAPSHOT_KEYS (one copy); replace the 10 loader copies, 16 read
  copies, 11 const copies, 2 block copies; DELETE the v1-server block
  conftest.py:29-139; test_boss_numbers' inline chests-tiers loader →
  rows_by_ev. Byte-risk verdict: NONE (readers/helpers; acceptance = pytest
  242 green + every moved regex byte-compared to its donor).
- **C3 godot/sim/ harness kit (BYTE-RISK)** — sim_funnel.gd extraction of
  _check/_fresh_run/_decline(_out_path/_r3) across the 6+4× copies, KEEPING
  both _decline semantics as separate named helpers (§2.1 hazard); optionally
  the sim_stages SimPlatesLegs split THEN (F2) since the cluster is already
  open. Byte-risk verdict: HIGH CARE — commit only with fresh re-dumps of ALL
  committed jsonl cmp BYTE-IDENTICAL (journey 5020, endless 13, gems 6,
  unions 29, chests-tiers 16, stages-m3 17, art 15) + sim_stages determinism
  twin + strips gate green; any fixture that changes bytes without a declared
  re-mint row = reject.
- **C4 godot/scripts/ (SAFE as scoped)** — weapons.gd 3-line `reason:` header
  ONLY (§1.1). Byte-risk verdict: NONE for the header (comment lines do not
  change the dump corpora or the pck). The projectile-split alternative is
  BYTE-RISK (fires on the RNG/spawn path) and is NOT recommended.
- **C5 docs/ (SAFE)** — PARITY-ROADMAP.md:44 line-ref fix (§4.1). Byte-risk
  verdict: NONE.

## DEFERRALS (with reason)

- F2 sim_stages 600-cap split → folded into C3 *if* C3 opens the file; as a
  standalone it is P3 (at-cap, header-reasoned, no gate failure today) — if
  the refactor wave is cut for size, defer it and let the FIRST M4 card that
  grows the file carry the split with the same byte-anchor proof.
- F3 reason-header adds (strips_capture, sim_union) → P3 comment-only,
  bundle into whichever card next touches those files; no separate wave.
- F17 test-quality "name it only" rows → P3, ledger note only: write
  "fixture-trust pins = byte-anchor design, declared" into the LEDGER instead
  of touching 8 test files for prose.
- The four vm100 orphans' DELETION (vs --allow row): deletion is owner-visible
  (GPU-era one-shot tooling provenance); C1 should land the PERMANENCE row
  first; actual removal rides an owner word.
- Nine GD capture scripts' _save_png tails, HD3D_OUT naming, seed-scan loops:
  DEFENDED duplication (§2 close) — extraction judged worse than the copy.

# VERDICT: FIX
