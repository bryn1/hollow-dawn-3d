# M3-SPEC-DA — Devil's-advocate gate, cycle 1 (MC 11271)

- **Target:** `docs/M3-SPEC.md` @ `2a19bb1` (docs-only commit; parent `1d005bc` = v1.3.0 GA, so the
  spec's "code truth read at 1d005bc" holds verbatim at this SHA — verified via `git show --stat`).
- **Method:** every acceptance line re-grepped THIS session at 2a19bb1 against the real tree
  (`godot/scripts/`, `godot/sim/`, `tests/`, `docs/`); one attack was machine-tested on the repo's
  OWN pinned engine binary (`tools/VERSIONS.txt:7`, Godot 4.7.2.stable) instead of argued.
- **Prior art honoured:** M2 c1 landed FIX with one P1 self-contradiction + 5 P2s, c2 SHIP. The
  same failure class recurs here (§1.2 vs §3.1, F-1 below). Findings carry severities P1..P4; the
  gate rule is the spec's own §2/§9: SHIP only with no P1/P2.

## 0. Verdict summary

**FIX.** 1 × P1, 3 × P2, 3 × P3, 2 × P4. The architecture survives — the stage table, the two
gimmicks, the boss ladder, the version decision and the budget all hold up against re-grep — but
two mechanism claims are false against the shipped code (`world.gd` boss latch + boss chest tier),
one ACCEPT row is circular at capture time, and the wave map hides two file-set couplings. None is
design-reconsideration material; all are same-document fixes. §7 names the exact section edits.

## 1. The ten self-DA rows (spec §9) — statuses with re-grepped evidence

| # | row | status | evidence (re-grepped at 2a19bb1) |
|---|---|---|---|
| 1 | clean-room | **VERIFIED** | `docs/VS-FEATURES.md:384-386` re-read: stage-items rows (Mad Forest/Inlaid Library :384-385) and the plate quote (:386, "circular pressure plates…unavoidable event") exist verbatim; S5 rules quote at :417-421 ("more health, dealing more damage…chance to drop a Treasure Chest") exists. All shipped numbers are ours (900/4200/5600/12-13-14/1.5/120px/+150s/30s/±260,±150); every "≈their" line names shape only. |
| 2 | F-1 boss count by file:line | **PARTIAL** | Contradiction real: `PARITY-ROADMAP.md:42` ("M3: 1 end-boss per stage (4 total)") vs `:276` ("3 end bosses incl. warden; 2 new large miniboss-class meshes"). The adopted reading (3 total, 2 new meshes) is internally consistent (§6 lands 2). BUT the SAME authoritative row `:276` heads "Per-stage end boss + **limit Reaper**" — the spec's own precedence rule ("the specific line beats the general one") makes limit-Reaper IN-M3 scope, and the spec neither absorbs it nor names a deferral card in the wave map (§5 doc-sync list omits `:276`) → P3-2. |
| 3 | version law argued | **VERIFIED** | `:63-66` ("major = a new player-navigated UI surface (M3 stage select → v2.0.0)… Stated so M3's major is a rule, not post-hoc"), `:268` header "major-version-worthy: stage select exists", `:271` "stage-select menu (screens.gd CanvasLayer reuse)", `:285` "### M4 — v2.1.0" — all cited lines exist exactly as the spec quotes. A1 below attacks the recommendation and it survives. |
| 4 | reuse-first / monogamy | **PARTIAL** | One band table generalized (`render.gd:68-85`), one spawn loop with untouched ceilings (`world.gd:172-180`), one chest funnel (`world.gd:318-327`), one latch pattern (`:164-171`), one save + ONE `_meta_changed` funnel (`main.gd:350`) — all real. Exception named by the gate: §3.1's "ALL shipped seams, zero new code paths" is FALSE for the boss chest tier — the shipped drop site hard-codes the warden key (P2-1). |
| 5 | every ACCEPT row names ONE existing seam, gates go RED | **PARTIAL** | Channels exist as named: `sim_headless`/`sim_boss` (CHEST ROLL LEG, `sim_boss.gd:40,188`), `sim_chest_tiers`, `sim_budget` WORST-CASE-LOADOUT (`sim_budget.gd:1,153`), `sim_caps`, `save_probe.gd`, `tools/dawnwell_pixel_gate.py`, `tools/biome_readability.py`, `tools/s8_acceptance.py` (the 15,586-px boss-bar precedent re-found, LEDGER T-S8 row), table-pin pattern (`test_biome_numbers.py:41`), 12-field pin (`test_endless.py` A-E6 row). But A-E1's byte-stability red is circular at capture time (P2-3), and the planted map-bypass/baseline-vs-baseline red classes are real only after the test-file re-pins of P2-1 are declared. |
| 6 | ceilings unbreached | **VERIFIED** | `world.gd:172` `if enemies.size() >= ALIVE_CAP: return` sits ABOVE the rate term; `:180` `spawn_acc += minf(12.0, (1.0 + 1.3 * minute) * qty_cyc(...)) * dt` — a `* 1.5` surge inside `minf(12.0, …)` structurally cannot exceed 12/s or the cap. Cairn seeding + plate dwell are position/array ops — zero RNG sites (the RNG loop is only `:138` angle + `:184` type pick). Flare never read by sim code (visual call sites are ground/hud only). |
| 7 | byte-stability (F-4) | **MISSING** | The headline claim fails as written: §1.2 moor-vigil row pins "test_game_numbers.py:35 + test_boss_numbers.py:64 stays green", but `tests/test_boss_numbers.py:69-74` regex-pins the LITERAL boss-latch shape that §3.1 generalizes away — P1-1. And A-E1 compares against a fixture minted inside M3 — P2-3. (The engine mechanics themselves hold: `band_at("moor-vigil",t) == biome_at(t)` equality and the def-value const references are sound — the const cycle render.gd→world.gd was machine-tested on the pinned 4.7.2 binary and parses + evaluates `BOSS_AT` = 540.0 correctly; that attack failed cleanly.) |
| 8 | budget re-derived | **VERIFIED** | draws 27 = measured LEDGER row (T-M2z "MEASURED draws 27 <= 60 hard / 40 planned … HORDE 400 binding / TOTAL 403 named"); pins `test_art_integration.py:41` (60), `:42` (40), `:44` (400) re-read. Stage-3 ≤28 is the pessimistic tally (arithmetic gives 27: −2 never-live miniboss classes +1 ossuary +1 plate MM) — an upper bound, safe, pin 40 stays. Chest drops reuse the existing chest MM (`pickup_viz.gd:107`), no new draw class. Plate MM is honestly the 6th `_mm` (5 exist: `:99-107`). |
| 9 | Contract B untouched + honest persistence | **VERIFIED** | `snapshot_json` (`game_state.gd:181-198`) = exactly 12 fields (phase,hp,maxHp,level,xp,xpNext,gold,kills,time,enemies,weapons,runId); `endless`/`cycle` live at `:36-37` outside it and `bridge.gd` exposes NO run-start verb (surface = keys only: `_input/on_key/is_enter/move_vector/drain_presses`), so stage hand-in rides the same non-snapshot channel as endless (`main.gd:267`) — zero-delta holds for a new run-start input. `save.gd:23` VERSION=1, `:28` flags dict, `:29-34` best_cycle additive precedent + field-by-field `load_save` `:38-61`, `as_data :108` — all cited lines exact. |
| 10 | wave-map discipline | **PARTIAL** | Serial spine claim TRUE: T-M3s/T-M3g/T-M3b pairwise share `world.gd` + `render.gd` (and T-M3g/T-M3b additionally share `sim_stages.gd`/`test_stages.py`, so the two cannot parallelize either — the map's "asset batch ONLY" column is right). Asset batch file-set (`assets/`, `tools/vm100/*.tsv`) is disjoint from the spine's — BUT two hidden couplings: T-M3b's GLB_FILES re-pin is gated by a file-exists loop needing the MESHES committed (P2-2), and `tests/test_chests_tiers.py` must change for ANY new map row yet appears in no card (P2-1). Doc-sync rows exist but omit `:276` (P3-2). |

Tally: **5 verified, 4 partial, 1 missing.**

## 2. Independent attacks

### A1 — VERSION-LAW (attack the recommendation, strongest side first)

The strongest v1.4.0 construction: SEL-B(b1) still lets the player navigate to a stage (rows in the
shop panel), so "stage select exists" is satisfied WITHOUT a new nav surface; bumping major for
code-novelty-zero would make the law a label-game in the other direction; and Rule 2 (no owner
artifact) cuts both ways — no owner artifact commands a NEW surface either. This is the whole
anti-SEL-A case, steelmanned.

It loses on the roadmap's literal text, which the spec quotes exactly and I re-grepped:
`PARITY-ROADMAP.md:63-66` pre-commits "(M3 stage select → v2.0.0)"; `:268` "major-version-worthy:
stage select exists"; `:270-271` names the SURFACE BY SHAPE "stage-select menu (screens.gd
CanvasLayer reuse)" — SEL-B(b1)/(b2) are precisely the post-hoc hide that `:66` ("so M3's major is
a rule, not post-hoc") pre-empts; `:279` names the "stage-unchained leg" whose lock line is only an
observable on a visible row. v1.4.0 requires rewriting `:63-66`/`:268`/`:285` with no owner artifact
— a Rule-2 violation the SEL-A route does not commit. (The brief's "no owner artifact choosing
major" reading of Rule-2 does not bite: the owner-ratified roadmap rev3 ALREADY chose the major;
the spec cites an owner decision, it does not manufacture one.) §2's five reasons all stand; one
citation slip: the stage-unchained row is `:279`, not `:278` (P4-1). **Finding: recommendation
justified — no severity; P4-1 citation off-by-one.**

### A2 — STAGE-1 BYTE-STABILITY (cmp scope)

Scope established by re-grep: the committed corpus is SIM-EVENT fixtures (`endless-m2.jsonl` 13 rows
of `cycle_clear`/`endless_reach2` rows etc.) plus the capture-channel journey (5020-row sim_headless
re-run, LEDGER T-M2z) — pytest JUDGES dumps against fixtures; re-run byte-identity "is the capture's
job" (`test_endless.py:1-6` header). So the cmp is SIM-state-only: the biome band PAINT (`ground.gd:43-50`
`_set_band`) and HUD pixels are OUTSIDE it by construction, and the spec adds **no stage HUD row**
(checked — nothing in §1/§3 adds one; the only HUD touch is the per-boss name readout, and §3.1
gives `name` rows to only the 2 NEW bosses, so stage-1's bar keeps the `hud_3d.gd:33`
`BOSS_NAME` const byte — consistent). Pixel risk is covered separately (A-E6/A-E7 + s8 crop).
`band_at("moor-vigil",t) == biome_at(t)` is a total-function wrapper equality and stage-1's boss rows
carry the shipped times/order, so the sim bytes can stay identical.

The flaw is in the ACCEPT row, not the design: **P2-3 — A-E1 as written compares the default-save
journey + win-warp replay "byte-identical vs committed `stages-m3.jsonl`" — a fixture MINTED INSIDE
M3.** A stage-1 leak introduced by M3 itself bakes into that fixture and the cmp stays GREEN; the
row cannot detect what F-4/§9.7 promise ("every committed dump replays identical"). Its red line
("any gimmick/schedule leak ⇒ cmp flips RED") only bites against leaks added AFTER capture. The M2
precedent it cites ("the `endless-m2.jsonl` fixture pattern") was anchored at the OLD corpus —
`test_endless.py:26,42` + the v1.3.0 re-runs (LEDGER: "fixture endless-m2 cmp-IDENTICAL"). Fix: the
row must name re-running the EXISTING corpus legs (endless/gems/chests-tiers/unions + journey) on
the stage-1 default as the red anchor, with `stages-m3.jsonl` only as the forward lock.
Secondary hidden coupling (P3-3): `tests/test_biome_numbers.py:41-45` pins the bands by SLICING
`render.gd` from `const BIOMES` to `static func biome_at` and regexing `t_start` — position-
sensitive. §1.1's justification ":41 stays green (BIOMES table is untouched data)" is only true if
the new `STAGES` const lands OUTSIDE that slice (or its band keys avoid the regex); the spec must
pin the placement or name the re-pin.
Machine-tested sub-attack (clean-fail, no finding): a minimal repro on the pinned Godot 4.7.2
binary had `render.gd`-class `const STAGES := [[GameWorld.BOSS_AT, …]]` cross-referencing `world.gd`
while `world.gd` calls back into the renderer — it PARSES and evaluates `540.0` correctly; the const
cycle the generalization implies is not an engine hazard at this pinned version.

### A3 — BOSS HP UNDER ENDLESS

Neither explosion nor triviality, and the spec's silence is the finding. Re-derived: the boss class
spawns ONLY through the cycle-0 latch (`world.gd:164-171`; `cycle_clear` (`:255-257`, `main.gd:243-248`)
never re-arms it and `reset()` runs only at `_start_game`), so at cycle 5 no boss spawn exists to
scale — HP_CYC/18× clamp can never touch a boss. What ships instead: the boss rides the EXISTING
per-minute ramp at spawn, `_spawn_enemy` (`world.gd:145-146`): `def.hp × (1 + 0.22·m_c) × hp_cyc(0)`,
clamped at `def.hp × 18` — at t=540 (m_c=9) the factor is ×2.98, so the shipped warden is 8,940 HP
and the spec's 5600-row Ossuary Warden spawns at **16,688 HP**, 1.87× the stage-1 fight — the
intended ladder, consistent with `test_boss_numbers.py:79-81`'s stated law ("the spawn-time hp rides
the verbatim time ramp, the boss is not special"). The spec's table def-values are the right
convention, but §3.1 never says which scalars touch bosses. **P4-2:** one §3.1 line naming the seam
(`world.gd:145-146` ramp applies; HP_CYC structurally cannot — latch is cycle-0-only) and the
effective spawn HPs (8,940 / 12,516 / 16,688), so the C-E1/C-E2 kill legs budget against real HP.

### A4 — "MAX_CONTACT_DMG VACUOUS AT CYCLE 0"

Vacuity claim re-derived and TRUE: `main.gd:210` `raw = minf(e.dmg * dmg_cyc(cycle), MAX_CONTACT_DMG)`,
`dmg_cyc(0)=1.0` (`world.gd:49-50`), every base dmg ≤ 14 < 20 → vacuous at cycle 0 on every stage,
stage-1 bytes safe. The reachable-bound tail is WRONG for stage 3: `dmg_cyc(c)=1+0.20c` → ossuary
14×1.4 (cycle 2) = 19.6 ≤ 20; 14×1.6 (cycle 3) = 22.4 > 20 → the clamp binds **cycle 3**, not "cycle
≥4" (§3.1) — the ≥4 figure is copied from the warden-12 law in `main.gd:14-15` (12×1.6=19.2, ×1.8=21.6
→ cycle 4) and never re-derived for 14 (choir-13 also binds at cycle 3). M2's A-E3 clamp leg already
proves the mechanism at cycle 5 ("contact 24→20", LEDGER). **P3-1:** restate §3.1 as
"clamp binds cycle 4 for base-12 (stage 1 law, byte-unchanged), cycle 3 for bases 13/14 — one M3
clamp leg to re-pin the row."

### A5 — GIMMICKS EXISTING-ONLY

Both seams re-grepped and the composition claim HOLDS. Cairns: `world.chests` array exists
(`world.gd:103`), the 16-px collect/open funnel is 4 sites counting `< 16.0` (pin
`test_biome_numbers.py:144-149` — a plate at radius 120 via `_dist` (`world.gd:334-337`) adds no
`< 16.0` compare, so the pin survives), the tier stamp rides the map (`:69-70`), chest icon/MM
reused (`pickup_viz.gd:107`). Pressure-stair: the surge is ONE `×1.5` term inside the UNTOUCHED
`minf(12.0, …)` (`world.gd:180`) with the `ALIVE_CAP` early-return above it (`:172`); the flare reads
only the band-swap seam (`ground.gd:43-50` + `hud_3d.gd:25` BIOME_FLASH) — zero new subsystem in
either gimmick, zero RNG consumed. NO new-subsystem P1 exists. The one real crack is the map ROW
itself: any added `CHEST_TIER_BY_SOURCE` row (including `"stage-item"`) breaks `test_chests_tiers.py`
— counted in P2-1, not A5's composition claim.

### A6 — EVENT-WAVE DEFERRAL

Rows checked by name: `PARITY-ROADMAP.md:42` (plan cell "event swarm waves M2+" — a window, not an
M3 compulsion), `:241` (M2 item 5), `:258-259` (landing note "NOT LANDED — named follow-on M2
cards"), §M3's item list `:268-283` — which contains NO event-wave item. The roadmap compels
nothing in M3; the DEFER + tracked `T-M3e-EVENTWAVE` row satisfies the roadmap-is-law discipline the
same way T-M2r-REAPER does (`:249`). M3 even lands the surge half of the wave math first (§4.3), and
the `event` map row stays the forward reservation (`world.gd:70`). **No finding — the deferral is
roadmap-compliant.**

### A7 — CHEST-TIER P1-LAW

The spec's "2 strict CHEST_TIER_BY_SOURCE rows" (§3.1) + the §1.2 "stage-item" row are additive and
the existing four rows (`miniboss/warden/endless-cycle/event`, `world.gd:69-70`) stay untouched —
and the cycle-clear leg (`cycle_clear :255-257`) is untouched too. BUT the surrounding test law
does NOT survive unedited: `tests/test_chests_tiers.py:100-101` defines `SPEC_MAP` as the EXACT 4-row
dict and `:139` asserts `entries == SPEC_MAP` (plus `:201` asserts the dump's map row equals it) —
ANY added row (stage-item, cathedral-choir, ossuary-warden) turns those rows RED. The named
UNIFIED-TIER row itself (`:263` `test_unified_tier_ae4_bt1_same_row`) reads only the endless-cycle
leg and DOES survive. So: cycle-clear ✓, existing rows ✓, UNIFIED-TIER row ✓ — but the same file's
single-source law rows die silently. **P2-1** (combined below with the drop-site finding, same fix).

### A8 — WAVE MAP vs REAL FILE SETS

Serial-spine claim TRUE (pairwise `world.gd`+`render.gd` overlap; T-M3g/T-M3b additionally share
`sim_stages.gd` + `test_stages.py`, so "asset batch ONLY" is correct for every spine card). Asset-
track file sets ARE disjoint (`assets/`, `tools/vm100/*.tsv` vs `godot/`, `tests/`). Zero-overlap
breaks at the ARTIFACT seam, not the file seam: **P2-2 — `tests/test_art_integration.py:83-88`
requires a real committed `.glb` for EVERY `GLB_FILES` key** (the file-exists loop, comment at `:82`
verbatim: "the file-exists loop below still requires a real committed glb"; the coverage assert at
`:84-86` re-reads the key set). T-M3b's `GLB_FILES +2` therefore REDS the suite unless the two boss
meshes are already committed, i.e. T-M3b depends on T-M3a's mesh rows — its `depends on` column
names only `T-M3s-STAGES`. Either add the asset-batch dependency (per the 2 boss-mesh rows) or
sequence the coverage re-pin into the mesh-landing commit. (The second undeclared file-set member,
`tests/test_chests_tiers.py`, is P2-1.) Also: the spec's DECLARED-PIN pattern cite `sim_caps.gd:88`
is the leg's `print` line — the pin pattern itself is at `sim_budget.gd:92`/`sim_boss.gd:292`
(cosmetic, folded into P4-1). No two cards run parallel on one file as the map is drawn — but as
drawn, one serial card cannot close green before a parallel card lands.

### A9 — BUDGET

Recomputed under the named §2 loadout: measured-now 27 draws stands (LEDGER T-M2z/T-M1g rows; pins
`test_art_integration.py:41-44`). Stage 1 = 27 (no new class can go live; boss list shipped).
Stage 2 ≤ 27 (choir replaces the warden class 1:1 — horde draws are per-CLASS `horde_viz.gd:41-59`
+ClassMesh, one MultiMesh each — band rosters are ⊆ the shipped set, zero plates; cairns ride the
EXISTING chest MM). Stage 3 ≤ 28: the honest live tally is 26–27 (−2 never-spawning miniboss classes,
+1 ossuary, +1 plate MM); 28 is a safe pessimistic bound — ≤ 40 planned ≤ 60 hard holds with margin,
`DRAWS_PLANNED` stays 40, the same-commit re-tally rule is restated. Horde: surge inside `minf(12.0)`
+ the `ALIVE_CAP` early-return (`world.gd:172`) ⇒ ≤400 unbreached; the 403/401/401 named-spawn
readings are right (stage 2/3 lists contain no warden/miniboss pair). Stage-3 boss chest = more
instances on the existing chest MM, no draw-class change. Gems ≤200 by the merge invariant
(`world.gd:26-27,234-247`). **No budget finding** (the ≤28 bound being 1 loose is stated, not a defect).

### A10 — CONTRACT B / PER-PILLAR ZERO-DELTA

The 12-field snapshot (`game_state.gd:185-198`) is untouched by every §1–§3 mechanism; `stage`/`flare`
ride the endless/cycle out-of-snapshot pattern (`:36-37`, hand-in at `main.gd:267` AFTER `start_run`).
The per-pillar attack — "stage select is a NEW run-start input, doesn't it widen the contract?" —
fails: `bridge.gd` exposes keys only (`_input/on_key/is_enter/move_vector/drain_presses`, `:28-76`),
no start/verb channel at all, so the stage arrives via UI + save exactly like the endless flag did in
M2 (whose zero-delta was gated). Phase enum unchanged; `weapons` value-domain unchanged (M3 adds no
weapon ids); the select overlay is menu-phase CanvasLayer riding the shop precedent, and the
`main.gd:173` Enter-guard extension is declared in §1.3. A-E8 (exact-12 pin + "menu Enter inert")
names the real instruments. **No finding — zero-delta claim survives.**

## 3. Findings register

| id | sev | one-liner | where to fix |
|---|---|---|---|
| P1-1 | **P1** | §1.2 moor-vigil row promises "test_game_numbers.py:35 + test_boss_numbers.py:64 stays green", but `tests/test_boss_numbers.py:69-74` regex-pins the literal shipped latch (`if not boss_spawned and game\.time >= BOSS_AT:`, `boss_spawned = true\n\s*_spawn_enemy("warden", game, view)`, `_spawn_enemy("warden"` counts ==1); §3.1's schedule generalization ("iterate the stage row's `bosses` list") removes that literal by construction ⇒ the pinned row CANNOT stay green — a same-document self-contradiction (the M2 c1 P1 class). Dump/byte pins stay green; it is the implementation-shape regex that dies. | §1.2 moor-vigil row + §3.1 bullet 3 + §9.7: replace "stays green" with the DECLARED RETIRE-AND-REPLACE row (suite-posture law, roadmap §2): test_boss_numbers.py:64-77 retires to the stage-table pin + per-stage C-E1 legs in the SAME commit as the loop generalization (T-M3s/T-M3b already list the file). |
| P2-1 | **P2** | §3.1 "boss death → reward law (ALL shipped seams, zero new code paths)" is false at the tier seam: `world.gd:281-283` stamps EVERY `boss:true` drop from the literal key `CHEST_TIER_BY_SOURCE["warden"]` — the shipped code cannot deliver `ossuary-warden → "dawn"` (it would drop tier "warden"); the lookup must generalize to the enemy's own source key (which keeps stage-1's byte = the same row), and that breaks `tests/test_chests_tiers.py:145` (literal drop-site regex the map-bypass planted-red rides) + `:139/:201` (`SPEC_MAP` exact-equality dies on ANY added row, incl. §1.2's `stage-item`) — a test file named in NO wave-map card. | §3.1 bullet 4: state the drop-site generalization (`CHEST_TIER_BY_SOURCE[String(enemy.type)]`, warden byte preserved) + add `tests/test_chests_tiers.py` (SPEC_MAP re-pin + drop-site re-pin) to T-M3b's files and T-M3g's map-row commit; §5 table + §9.5 row. |
| P2-2 | **P2** | Wave-map hidden coupling: `tests/test_art_integration.py:83-88` demands a committed `.glb` per `GLB_FILES` key, so T-M3b's `GLB_FILES +2` cannot close green before the 2 TRELLIS boss meshes exist — but T-M3b's `depends on` is `T-M3s-STAGES` only while the meshes ride the "parallel" T-M3a. | §5: T-M3b `depends on` += `T-M3a-ASSETS (2 boss-mesh rows)` (or move the GLB_FILES + coverage re-pin into the mesh-landing commit); state which. |
| P2-3 | **P2** | A-E1 is circular at capture time: stage-1 byte-stability is asserted against `stages-m3.jsonl`, a fixture MINTED inside M3 — a stage-1 leak introduced by M3 itself bakes in and the cmp stays GREEN; the F-4 promise "every committed dump replays identical" is asserted against nothing at gate time. (Pixels/HUD: no stage HUD row is added by the spec, boss-bar const byte preserved — that half is clean.) | §1.4 A-E1: anchor the red on re-running the EXISTING corpus legs (`endless-m2.jsonl`, `gem-merge-m2g.jsonl`, `chests-tiers-m2.jsonl`, `unions-m2u.jsonl`, sim_headless journey) on the stage-1 default, with `stages-m3.jsonl` demoted to the forward lock (mirror `test_endless.py:26,42` + the v1.3.0 re-run precedent). |
| P3-1 | P3 | §3.1's "stays a reachable cycle-≥4 bound on stage 3" is copied from the base-12 law (`main.gd:14-15`); re-derived: base 14 → 14×dmg_cyc(2)=19.6 ≤20, 14×1.6 (cycle 3)=22.4 >20 → binds cycle 3 (base 13 likewise). | §3.1 ladder-provenance bullet: restate the bound per base (12→c4, 13/14→c3) and name one M3 clamp re-pin leg. |
| P3-2 | P3 | F-1 resolves the :42-vs-:276 COUNT contradiction but leaves a second live contradiction in the SAME row: `PARITY-ROADMAP.md:276` heads "Per-stage end boss + limit Reaper" — under the spec's own "build row beats gap table" rule, limit-Reaper is M3 scope; the spec ships none, defers silently to T-M2r (roadmap `:43` DEFERRED note, OK) but §5's doc-sync list ("roadmap `:42`'s '4 total' claim per F-1") never names `:276` → the retired-claim grep survives M3's close. | §5 doc-sync row + §8.2: add `:276`'s "+ limit Reaper" clause to the T-M3z retire-and-replace list (rewrite mirroring the M2 landing-note pattern), and mark T-M2r as the named deferral of the §M3 item-3 sub-clause. |
| P3-3 | P3 | `test_biome_numbers.py:41-45` pins the band table by SLICING `render.gd` (`const BIOMES` → `static func biome_at`) and regexing `t_start` — position-sensitive; §1.1's ":41 stays green because BIOMES data is untouched" holds only if `const STAGES` lands OUTSIDE that slice (or uses non-`t_start` keys). | §1.1: pin the STAGES placement (after `biome_at`) or name the slice re-pin; one sentence. |
| P4-1 | P4 | citation slips: stage-unchained leg is `:279` not `:278` (§2 reason 4); `sim_caps.gd:88` is the leg's print line, pin pattern is `sim_budget.gd:92`/`sim_boss.gd:292` (A-E4 cite). | §2, §1.4 A-E4. |
| P4-2 | P4 | §3.1 silent on which scalars touch bosses: they inherit the per-minute ramp at spawn (`world.gd:145-146`, ×2.98 at t=540) so rows' def HP ≠ spawn HP (warden 8,940; choir 12,516; ossuary 16,688), while HP_CYC/18× clamp structurally cannot touch them (latch is cycle-0-only; `cycle_clear` never re-arms). | §3.1: one line naming the seam + the effective spawn HPs. |

**Counts: P1 = 1, P2 = 3, P3 = 3, P4 = 2.**

## 4. What survived the attack (for the record)

The design core holds: stage table on the one band seam; both gimmicks are composites of shipped
mechanisms (chest funnel / one rate term / band-swap look) with the ceilings provably unbreached and
zero RNG consumed; the boss ladder is a consistent def-value row set riding the shipped kill funnel;
SEL-A ⇒ v2.0.0 is the roadmap-lawful call and the v1.4.0 counter-case loses on the quoted lines; the
event-wave DEFER is roadmap-compliant (no row compels absorption); the Contract-B zero-delta row
survives the new-run-start-input attack (no bridge verb exists); the budget verdict holds with
margin; and the pinned engine resolves the render.gd→world.gd const reference cleanly (machine-test,
not prose). The spec's own code-truth pins (file:line) checked out EXACTLY at this SHA — the M1/M2
"pins drift" lesson was actually applied.

## 5. Strongest finding, one line

The spec's §1.2 byte-pin promise ("test_boss_numbers.py:64 stays green") contradicts its own §3.1
schedule generalization — the pin regexes the literal `_spawn_enemy("warden", …)` latch line that
§3.1 removes by design — so the build spine as specified cannot keep the suite green (P1-1).

## 6. Reading-of-ambiguity statement

F-1's precedence rule, the "one gimmick per stage" resolution (stage 1 = shipped vigil as the rule
row), and the limit-field-uniform-at-900 reading are all STATED choices, not silent ones, and I
found no roadmap text that compels a different reading of any of them. Where the spec's choice now
contradicts itself (P1-1, P2-1) or its own §9 self-check overstates a gate (P2-3), the fix is
declaration, not redesign.

## 7. Fix list for cycle 2 (exact sections)

1. **§1.2 moor-vigil row + §3.1 bullet 3 + §9.7** — P1-1 declared retire-and-replace of
   `test_boss_numbers.py:64-77` (keep the `:35` const pin; the replacement pin is the STAGES table
   row + C-E1 per-stage legs, same commit).
2. **§3.1 bullet 4 + §5 (T-M3b/T-M3g rows) + §9.5** — P2-1 drop-site generalization +
   `tests/test_chests_tiers.py` (SPEC_MAP + drop-site re-pins) added to the file sets.
3. **§5 wave map** — P2-2 T-M3b dependency on T-M3a's 2 mesh rows (or re-pin in the mesh commit).
4. **§1.4 A-E1** — P2-3 re-anchor to the existing committed corpus + journey.
5. **§3.1** — P3-1 clamp-bound re-derivation per base; P4-2 scalar line.
6. **§5 doc-sync row + §8.2** — P3-2 `:276` "+ limit Reaper" clause into T-M3z's retired-claim list.
7. **§1.1** — P3-3 STAGES placement sentence; **§2/§1.4** — P4-1 citation fixes.

After rows 1–4 (the P1 + P2s) land as declared lines in the spec, c2 can SHIP on the re-check; the
P3/P4 rows ride the same commit at the author's call.

# VERDICT: FIX
