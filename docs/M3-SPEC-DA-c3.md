# M3-SPEC-DA-c3 — Devil's-advocate gate, cycle 3, NARROW (MC 11279)

- **Target:** `docs/M3-SPEC.md` REV 3 @ `95295f7` (docs-only: `git diff 1d005bc 95295f7 -- godot/
  tests/ tools/ assets/` EMPTY this session ⇒ the spec reads the same v1.3.0-GA tree it cites;
  verified). History: rev-1 `2a19bb1` → c1 FIX `ecfd70c` (immutable) → rev-2 `446c065` → c2 FIX
  `c9dd4cb` (immutable, `docs/M3-SPEC-DA-c2.md`) → rev-3. c2's gate-biter was the one F-1 carve
  row; cycles exhausted — this doc does ONLY (1) the carve re-verification, (2) adoption of the
  remaining four c2 rows, (3) the named spot regression. All greps run THIS session at `95295f7`
  (worktree `.tmp/wt-da11279`); none carried from c1/c2.
- **Verdict summary:** **SHIP.** The F-1 carve is real, in both named places, and holds under
  fresh attack: A-E1 stays non-circular (the one re-minted row is anchored to the PRE-M3
  HAND-DECLARED 7-row `SPEC_MAP`, not to a capture M3 itself mints) and the collision is
  dissolved (T-M3g/T-M3b can close green — the two-stage re-pin is declared and mechanically
  works on the shipped test). All four remaining c2 rows landed; the spot regression (SEL-A header,
  budget, Contract-B) is untouched by the rev-3 diff. **P1 = 0, P2 = 0, P3 = 0, P4 = 3** (all
  wave-brief notes, none gate-biters).

## 1. F-1 CARVE VERIFICATION — the one row

**The carve text exists where c2 named it** — §1.4 A-E1 (spec :237): the chest-file anchor is
"scoped to that file's stage-1 OBSERVABLE rows — `boss_tier`/`mb_tiers`/`cycle_tier`/`checks` …
while its embedded `map` row … is the ONE declared in-M3 re-pin row per §3.1: that row re-mints
with the map-growth commit and is NEVER counted as an anchor flip"; and §9.7 (spec :583-589):
same scope list + "never an anchor flip" + "the other three fixtures + journey are
grep-map-free". Restatements agree (§10 REV-3 F-1 fold :646-653).

**Fresh greps at `95295f7` (c2's factual base re-derived, not carried):**

| # | claim | fresh evidence |
|---|---|---|
| G1 | fixture row 1 embeds the map | `tests/fixtures/chests-tiers-m2.jsonl` row 1 verbatim: `"map":{"endless-cycle":"dawn","event":"dawn","miniboss":"ember","warden":"warden"}` — and `grep -c '"map"'` on the file = **1** (row 1 is the only map-carrying row; rows 2-15 clean). |
| G2 | `:201` asserts fixture-map == SPEC_MAP | `tests/test_chests_tiers.py:201` = `assert r["map"] == SPEC_MAP` (inside `test_bt1_drop_funnel_rows_and_planted_red_instruments` :198); the other SPEC_MAP legs re-grepped: `SPEC_MAP` def :100-101 (4 shipped rows), `assert entries == SPEC_MAP` :139 (source-regex leg), drop-site regexes :142-147, UNIFIED-TIER :265-272 (reads the `endless-cycle` row of world.gd + `cycle_tier` — survives a 7-row map). |
| G3 | the other three anchors + journey are map-free | `grep -c '"map"'` = **0** on `endless-m2.jsonl`, `gem-merge-m2g.jsonl`, `unions-m2u.jsonl`; **0** `GameRenderer` map-dump row in `godot/sim/sim_headless.gd`. Exactly one fixture in the corpus is map-carrying, and it is the one the carve names. |
| G4 | the observable rows keep their bytes under the keyed site + growth | `_leg_drop_map` (`sim_chest_tiers.gd:120-150`) grepped: every `checks` comparator reads an **unchanged** map key at dump time — `boss_ok: boss_tier == map["warden"]`, `mb_ok: mb_tiers == [map["miniboss"]]`, `cycle_ok`/`unified_ok` on the endless-cycle row (`"dawn"`). The three §3.1 rows are pure ADDS; values under the old keys never move. The keyed drop site returns the same tier **by key identity**: spawn dict stamps `"type": type_key` (`world.gd:148`, grepped) and the warden's type IS the `"warden"` map key (`CHEST_TIER_BY_SOURCE` `world.gd:69-70` grepped verbatim; the warden spawn site is the literal `_spawn_enemy("warden", …)` `:166`). No new RNG on the drop path (a keyed map read consumes none) ⇒ the pinned `mb_chests 115/mb_kills 200` bytes stand too. |

**JUDGMENT.**

- **A-E1 stays non-circular.** The P2-3 circularity was "a leak introduced BY M3 bakes into its
  own capture". Under the carve the anchor claim is: (i) three PRE-M3 fixtures + the journey,
  byte-for-byte, map-free (G3); (ii) the chest file's observable rows, PRE-M3 bytes (G4); and
  (iii) the ONE re-minted row is compared against the **hand-declared, PRE-M3-`SPEC_MAP`
  replacement the §3.1 table itself fixes** — all seven key→tier values (the three new ones
  `stage-item→ember`, `cathedral-choir→warden`, `ossuary-warden→dawn`) are stated in the spec,
  not minted by a runtime capture. Re-minting a row toward a value the spec already declares is
  re-anchoring, not self-assertion. A stage-1 leak has nowhere to hide: any behavioral leak
  moves a byte in (i)/(ii) ⇒ RED.
- **T-M3g/T-M3b can close green — the collision is dissolved.** `:201` reds only while
  fixture-map ≠ SPEC_MAP; the carve makes both flip together in the map-growth commits, and the
  two-stage growth is DECLARED per card (T-M3g cell: "SPEC_MAP re-pin for the added `stage-item`
  row" — the 5-row state; T-M3b cell: "SPEC_MAP 7-row re-pin + drop-site re-pin"). The
  source-regex leg re-grepped mechanically works at 7 rows: `\{([\s\S]*?)\}` stops at the const's
  own close (string-valued rows, no nested braces) and the entry regex
  `"([a-z-]+)": "([a-z]+)"` (:138) matches all three new keys (`stage-item`,
  `cathedral-choir`, `ossuary-warden` all `[a-z-]` with `[a-z]` values). The planted-red
  map-bypass leg survives too (`test_drop_sites_stamp_tier_from_the_map` re-pins to the keyed
  form, declared §3.1/C-E2).
- **Green control run this session:** `python3 -m pytest tests/test_chests_tiers.py
  tests/test_biome_numbers.py -q` at `95295f7` → **43 passed**, VERIFY_EXIT=0 (the suite the
  carve governs is green PRE-change, so any post-change red is attributable).
- **Strongest remaining attack (fails):** "the carve shrinks A-E1 — the chest file's row-1 bytes
  are no longer wholly anchored." True and intended: the claim narrows to the observable rows
  (which excludes `map`, and also `mb_chests`/`mb_kills`/`ok`/`ev` — see §4). A narrower claim
  can only cause false GREEN on bytes it no longer claims, and every byte it drops either keeps
  its value by construction (G4) or is the one row §3.1 re-pins to a declared target. Fails-safe
  by construction.

## 2. Adoption of the remaining c2 rows (4/4 landed, each re-grepped at 95295f7)

| c2 id | status | fresh evidence |
|---|---|---|
| **F-2** Enemy-rows dedup | **LANDED** | `grep -c 'Enemy rows' docs/M3-SPEC.md` = **1** (:334, the surviving bullet, marked "(one bullet — rev-2 shipped this as a duplicated pair… F-2 de-dup)"); the rev-3 diff (`c9dd4cb 95295f7`) hunk `@@ -303,13 +325,14 @@` shows the `-`-pair deletion. |
| **F-3** call-sites 4+4 restated true + readability pair | **LANDED** | Both classes re-grepped tree-wide MYSELF: 4 executable GAME reads — `world.gd:125`, `ground.gd:35`, `ground.gd:43`, `hud_3d.gd:127` (comment/def lines excluded) — and 4 CAPTURE reads — `sim_headless.gd:118`, `:257`, `biome_readability_capture.gd:162`, `art_capture.gd:116`. The spec's dual phrasing (§1.1 :135-139) is true on BOTH readings: three GAME *consumers* (ground/hud/world) = four game *call sites* (ground has two). §1.1 :176-178 adds the wrapper clause + the single named exception (A-E7 readability, T-M3s). T-M3s file-set cell (§5 :450) names `tools/biome_readability.py` + `godot/sim/biome_readability_capture.gd` — both files EXIST (ls). |
| **F-4** A-E2 placement-RED cell | **LANDED** | A-E2 red column (:238) now carries "`STAGES`/`band_at` placed BEFORE `biome_at` in render.gd ⇒ the slice swallows the new table's `t_start`s ⇒ RED (P3-3 placement, §1.1)"; §1.1 :184 states the same pin ("A-E2 pins the placement"). The §10 P3-3 ledger claim is now true as written. |
| **F-5** scalars/re-arm wording | **LANDED** | Scalars bullet (:327-331): the loose "at cycle ≥ 1 no boss exists to scale" is replaced by the exact pair — HP stamped ONCE (schedule never re-fires: latch `world.gd:164-171` + `cycle_clear` never re-arms, both re-grepped) AND an uncleared boss's contact dmg scales LIVE at `main.gd:210` (`minf(e.dmg * GameWorld.dmg_cyc(game.cycle), MAX_CONTACT_DMG)` grepped verbatim; `MAX_CONTACT_DMG := 20.0` :18). Re-arm bullet (:361-364): now "the SAME world through `reset()` … a fresh process would prove nothing" — `reset()` grepped (`world.gd:109-117`: `boss_spawned = false`, `minibosses_spawned = 0`) — the re-arm is real; `grep 'fresh sim'` = 0 hits (old wording gone). |
| (F-1) | **LANDED — §1 above.** | |

**Adoption tally: 5/5 (carve + four rows).** Rev-3's §10 REV-3 ledger claims match the actual
`c9dd4cb→95295f7` diff hunk-for-hunk (header block, §1.1 ×2, A-E1/A-E2, §3.1 ×3, T-M3s row,
§9.7, §10) — no undeclared change anywhere in the diff.

## 3. Spot regression (the named rows, unchanged)

- **SEL-A v2.0.0 header rows:** title `:1` "(v2.0.0)", VERSION-DECISION row `:40-43`, §2
  recommendation `:268` + "`Version decision as shipped in this spec's header: v2.0.0`" `:294` —
  all present; the rev-3 diff touches ZERO lines in §2 (`:246-294`).
- **Budget lines:** §7 — measured-now `draws 27 / plan 40 (`test_art_integration.py:42`) / hard 60
  (`:41`) / ALIVE_TARGET 400 (`:44`)` (:498-500), per-stage `27/≤27/≤28 ≤ plan 40 ≤ hard 60`
  (:509-512), horde ≤ 400, named spawns 3/1/1 with the `403/401/401` reading (:516-519, §9.8
  :594-595) — all present; §7 unmodified by rev-3.
- **Contract-B row:** §7 `:520-522` "Contract-B snapshot 12-field impact row … ZERO delta …
  `stage`/`flare` ride outside … no phase value added" + §0 F-3's 12-field/`game_state.gd:181-198`
  anchor — present; unmodified by rev-3.

## 4. Findings register (P4 only — wave-brief notes, nothing gate-blocking)

| id | sev | one-liner |
|---|---|---|
| c3-P4-1 | P4 | T-M3g/T-M3b file-set cells name `test_chests_tiers.py` but not the fixture `tests/fixtures/chests-tiers-m2.jsonl` whose `map` row must re-mint in those same commits (the obligation IS carried by the A-E1 carve sentence, and the repo's own precedent — `stages-m3.jsonl` is likewise not listed in T-M3s's cell — treats fixtures as implicit capture outputs). Wave briefs: one word each, next to the re-pin parentheticals. |
| c3-P4-2 | P4 | A-E1's red column in isolation reads ambiguous ("…its `map` row re-mints by design per the §3.1 carve ⇒ RED" — the em-dash clause can be mis-scanned as making the RE-MINT red). §9.7's "never an anchor flip" + §3.1 disambiguate; reflow the clause when the file is next edited. |
| c3-P4-3 | P4 | The carve's observable-row list omits `mb_chests`/`mb_kills`/`ok`/`ev` (row-1 keys that DO keep their bytes — pinned RNG, G4). Narrower than achievable, never wrong-red; harmless. Stated as a reading, not a fix demand. |

## 5. Stated readings of ambiguity

- "grep 1" (F-2 row) read as: exactly one `Enemy rows` bullet in rev-3 → measured 1.
- "call-sites 4+4 restated true" read as a count of EXECUTABLE `biome_at` reads per class
  (comments and the def excluded) → 4 game + 4 capture, matching both the spec's "three GAME
  consumers" (module reading) and "4 game call sites" (call-site reading) — both true, the spec
  states the reconciliation itself.
- The carve read as a strict byte-identity claim on the named rows (A-E1's own word
  "byte-stability" preserved) and a permissive exclusion of exactly one named row; under this
  reading §1.4 and §9.7 agree and no third reading changes the verdict (the narrower-claim
  attack in §1 fails safe).
- The fixture-path omission (c3-P4-1) judged against repo practice, not against the same-file
  law's letter: the law governs which CARD may touch a file; here the same card that re-pins the
  test owns the fixture re-mint in the same commit — declared, just not cell-listed. P4, not P3.

## 6. Verdict rationale against the gate rule

The brief: FIX only if the carve itself is broken (P1/P2). The carve was attacked at its two
load-bearing claims — byte-stability of the claimed observable rows (holds: G4, every check
comparator keys an unchanged map row, keyed-site identity, zero new RNG) and green-closability of
T-M3g/T-M3b (holds: the two-stage re-pin is declared, the :138/:139/:201 legs mechanically work
at 5 then 7 rows, and the named test files are green at `95295f7` — 43 passed). The remaining c2
rows landed 4/4; the named regression rows are byte-untouched. Nothing outside (1)-(3) reached
P1. **The M3 wave is authorized.**

# VERDICT: SHIP
