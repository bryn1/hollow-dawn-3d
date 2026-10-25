# M3-SPEC-DA-c2 — Devil's-advocate gate, cycle 2 (MC 11273)

- **Target:** `docs/M3-SPEC.md` REV 2 @ `446c065` (docs-only; `git diff 1d005bc 446c065 --
  godot/ tests/ tools/ assets/` = EMPTY this session ⇒ the spec's "code truth at 1d005bc" reads
  the same tree; verified). History: rev-1 @ `2a19bb1`, c1 verdict FIX @ `ecfd70c` (P1×1 P2×3
  P3×3 P4×2, `docs/M3-SPEC-DA.md`, immutable). Rev-2 claims adoption 9/9, rebuttal none.
- **Method:** PASS 1 — every c1 finding re-grepped THIS session at 446c065 (file:line evidence
  below, none carried from c1). PASS 2 — attacks on rev-2-only material (the two folds'
  INTERACTION, the arithmetic re-run, the re-arm leg's reality, §9 honesty). PASS 3 — regression
  scan of the c1-verified rows.
- **Verdict summary:** **FIX.** Adoption is real — 9/9 landed with the right mechanisms — but the
  P2-3 re-anchor and the P2-1 re-pin, adopted independently, COLLIDE on one fixture row (F-1,
  P2): the anchor list includes `chests-tiers-m2.jsonl` as a never-re-minted PRE-M3 byte anchor,
  while §3.1/§10 declare its dumped `map` row re-pinned to 7 rows in-M3. One sentence carves the
  exception. No P1; the design core is unchanged from c1's surviving state.

## 1. PASS 1 — Adoption audit (9/9, each evidence line re-grepped at 446c065)

| c1 id | status | fresh evidence (rev-2 section + tree grep THIS session) |
|---|---|---|
| **P1-1** latch-pin vs loop | **LANDED** | §1.2 moor-vigil row (spec :187) states const pin `test_game_numbers.py:35` survives — grepped: `def test_boss_at_540()` :35, `assert const("BOSS_AT", WORLD) == 540.0` :36, file untouched by any M3 file set. §3.1 bullet (spec :318-341) is the DECLARED RETIRE-AND-REPLACE ledger of `test_boss_numbers.py::test_boss_spawns_exactly_once_at_540` — grepped the pin's own body: latch regex :69-74, `WORLD.count("_spawn_enemy(\"warden\"") == 1` :75, reset re-arm regex :76 — exactly the shape the table loop removes; "stays green" is gone from the doc (grep: only in quoted-rev-1 context). Retirement declared SAME-COMMIT with the loop generalization (:329) + REPLACE-NOT-DELETE ledger. Run-2 re-arm leg in text: :338-339 + C-E1 row (:386, red "a dropped re-arm ⇒ run-2 leg RED"). |
| **P2-1** drop-site law | **LANDED** | §3.1 (:342-367): names `CHEST_TIER_BY_SOURCE[String(enemy.type)]`; grepped the shipped literal `world.gd:281-283` (`"tier": CHEST_TIER_BY_SOURCE["warden"]`) — TRUE; warden byte-identity holds — spawn dict carries `"type": type_key` (`world.gd:148`) and the warden's type IS the map key (`"warden"` :87/:69); miniboss branch stays literal (`:146` regex survives). UNIFIED-TIER alive: grepped `test_chests_tiers.py:263-270` — the law row reads the endless-cycle leg + `'"endless-cycle": "([a-z]+)"'` src regex only ⇒ survives a 7-row map; spec's claim TRUE. Map arithmetic: 4 shipped rows (`world.gd:69-70` grepped verbatim) + stage-item + cathedral-choir + ossuary-warden = 7 = the §5 "7-row" re-pin; the `SPEC_MAP` entry regex `"([a-z-]+)": "([a-z]+)"` (:138) matches all three new keys — re-pin mechanically works. File joined wave-map file sets: T-M3g AND T-M3b rows (§5 :425-426). |
| **P2-2** mesh dependency | **LANDED** | §5 T-M3b `depends on` now names `T-M3a-ASSETS` — the 2 committed boss-mesh rows, citing the evidence; grepped `test_art_integration.py`: coverage assert :84-87 + file-exists loop `assert os.path.isfile(...)` :88-90 with the quoted comment :82 — dependency is real and now declared; execution-order row states it (spec :434-435). |
| **P2-3** A-E1 anchor | **LANDED — but see F-1 (P2)** | §1.4 A-E1 rewritten (:215): anchor = `endless-m2.jsonl` + `gem-merge-m2g.jsonl` + `chests-tiers-m2.jsonl` + `unions-m2u.jsonl` + the sim_headless journey re-run; all four fixtures exist (ls `tests/fixtures/`), journey channel exists (no map row in `sim_headless.gd` — grepped). `stages-m3.jsonl` demoted to forward lock in A-E1, §1.3 (:208-209), §8.8 (:527-528), §9.7 (:557-559). The precedent cite checks: `test_endless.py:24-26` ("byte-identity vs this committed fixture … is capture"). **The anchor list, however, collides with the P2-1 re-pin — F-1 below.** |
| **P3-1** clamp per base | **LANDED** | §3.1 (:293-297) re-derived: grepped `world.gd:49-50` `dmg_cyc = minf(1+0.20c, 2.5)`, `main.gd:18` MAX=20, :210 clamp — 12: ×1.6=19.2≤20, ×1.8=21.6>20 ⇒ c4 ✓; 13: 18.2/20.8 ⇒ c3 ✓; 14: 19.6/22.4 ⇒ c3 ✓ (spec's printed arithmetic matches mine exactly). C-E5 leg added (§3.3 :390, red "22.4 unclamped ⇒ RED"). |
| **P3-2** `:276` Reaper clause | **LANDED** | §0 F-1 rev-2 note (:68-71), §8.2 (:509-512), §5 doc-sync row (:438-442) all name roadmap `:276`'s "+ limit Reaper" + the T-M2r-REAPER deferral + the retired-claim-grep-zero target; grepped roadmap :276 — the clause is verbatim there. |
| **P3-3** slice placement | **LANDED (P4 tail: F-4)** | §1.1 (:158-162): placement constraint `STAGES`/`band_at` land AFTER `static func biome_at`; grepped `test_biome_numbers.py:41-45` — slice `RENDER[index("const BIOMES"):]` then `[:index("static func biome_at")]`, position-sensitive as stated; the constraint genuinely protects it. A-E2's RED leg is prose-only — F-4. |
| **P4-1** citations | **LANDED** | §2 reason 4 now `:279` (roadmap :279 grepped: "stage-unchained leg (fresh save: stage 2 locked)"); A-E4 cites `sim_budget.gd:92`/`sim_boss.gd:292` — grepped: :92 the DECLARED build row / :292 `# DECLARED pin (SimCombat pattern)` — correct lines. |
| **P4-2** spawn scalars | **LANDED (P4 tail: F-5)** | §3.1 new bullet (:301-308): seam `world.gd:145-146` grepped (`roundf(def.hp * (1+0.22*cycle_minute) * hp_cyc(cycle))`, `minf(hp, def.hp*HP_EFFECTIVE_MULT_CAP)`, CAP=18.0 :38); arithmetic RE-RUN: `cycle_minute` (:58-59) at t=540 cycle-0 = 9 ⇒ ×2.98; `hp_cyc(0)=1.0` ⇒ **8,940 / 12,516 / 16,688** — matches the spec's numbers exactly; "cycle_clear never re-arms" verified: `world.gd:255-257` + `main.gd:243-248` touch neither latch (grepped). |

**Adoption tally: 9/9 landed; 0 missing, 0 partial-as-adopted** (P3-3/P4-2 land with P4 tails
F-4/F-5). §10's change ledger spot-checked against the actual `2a19bb1→446c065` diff on 5 rows
(P1-1/P2-1/P2-2/P2-3/P3-1) — every claimed fold is present where the ledger says; the ledger's
one overclaim is F-4.

## 2. PASS 2 — New-material attacks (rev-2 content)

### A1 — THE FOLD COLLISION (strongest finding; F-1, P2)

The P2-3 fold and the P2-1 fold were adopted independently and each is true alone; together they
contradict on one line of one fixture:

- Grepped `tests/fixtures/chests-tiers-m2.jsonl` row 1: it EMBEDS the map verbatim —
  `"map":{"endless-cycle":"dawn","event":"dawn","miniboss":"ember","warden":"warden"}` — and
  `test_chests_tiers.py:201` asserts the FIXTURE's map `== SPEC_MAP`.
- §3.1/§10 (P2-1 fold) declare the re-pin of `:201` to the 7-row map. Since the map is a global
  const (`_leg_drop_map` dumps `GameWorld.CHEST_TIER_BY_SOURCE`, `sim_chest_tiers.gd:120-123`),
  a STAGE-1-default re-run after T-M3g lands dumps the 5- (then 7-) row map ⇒ the committed
  4-row fixture row FLIPS by the spec's own declared design — not by a leak.
- §1.4 A-E1 + §9.7 (P2-3 fold) list that same fixture among the FOUR PRE-M3 byte anchors: "any of
  the FOUR existing fixtures flips … ⇒ RED (a leak vs PRE-M3 truth, not vs M3's own capture)" +
  "never an M3-minted fixture".

No build card can satisfy both readings: re-mint the fixture (silently re-mints an anchor — the
circularity P2-3 just removed, scoped to the chest file) or keep it (T-M3g/T-M3b cannot close
green — `:201` reds). Same-document self-contradiction, the c1 P1 CLASS but narrower reach: one
leg of one anchor, one sentence to carve. **Fix (exact):** in §1.4 A-E1 (and the §9.7 restatement),
scope the chests-tiers anchor to its stage-1 observable rows (`boss_tier`/`mb_tiers`/`cycle_tier`/
`checks` — grepped: those keep their bytes under the keyed site + map growth) and name the `map`
row as the one declared in-M3 re-pin per §3.1; or drop `chests-tiers-m2.jsonl` from the byte-list
and anchor leak-detection on the three map-free fixtures + the journey (all grepped map-free).
The other three anchors are unaffected: `endless-m2.jsonl`/`gem-merge-m2g.jsonl`/`unions-m2u.jsonl`
contain no map row (grep: zero `"map"`), `sim_headless.gd` dumps none.

### A2 — Clamp-per-base re-run (holds; no finding, one tail)

Arithmetic re-derived independently (§1 P3-1 row): bases 12/13/14 bind c4/c3/c3; spec's printed
figures exact. "Who binds when" — contact dmg is `e.dmg` (spawn-stamped, `world.gd:154`) ×
`dmg_cyc(game.cycle)` evaluated per-tick at `main.gd:210`, so the clamp binds on the cycle
crossing. The shipped `main.gd:14-15` law comment states the same method for base 12. C-E5's
leg is DECLARED-synthetic — consistent with §7's "play-reachability explicitly NOT claimed"
pattern and needed precisely because 13/14 exist only on boss rows (grepped ENEMY_TYPES: max
normal-enemy dmg 9 pale-wight; minibosses 10/11). Tail wording → F-5.

### A3 — Spawn-scalars row (holds; attacks fail)

Steelman "bosses DO take cycle scalars": (i) HP — refuted: `hp_cyc` is applied only at spawn
(`world.gd:145`), the latch never fires at cycle ≥ 1 (`cycle_clear` grepped clean), surviving
boss HP is stamped — the 18×/HP_CYC row is TRUE for HP. (ii) contact dmg — a boss the player
never killed DOES persist past t=900 and its contact dmg scales live — this is exactly what
C-E5 pins, and the scalars bullet's subject is HP; wording tail → F-5. (iii) the row vs the
spec's own seam claims: §1.1 "Endless rides stages unchanged" + cycle-clear-not-re-arm are
consistent (grepped both seams). Effective spawn HPs re-derived: 8,940/12,516/16,688 exact —
the ladder stays monotone (×1.4) on fight HP too. **No finding.**

### A4 — Run-2 re-arm leg — real, not a wish

`world.gd::reset()` (:109-117) grepped: sets `boss_spawned = false`, `minibosses_spawned = 0` —
the re-arm the retiring regex (:76) pins is real in the shipped tree. The C-E1 leg's channel:
`sim_boss.gd` header grepped — "Every leg runs through the REAL `_start_game` funnel and the
REAL main.gd `_step` loop" ⇒ a run-2 leg exercises `reset()` through the funnel; the generaliza-
tion's latch-index var must re-zero in `reset()` and the leg's named RED ("dropped re-arm ⇒
run-2 leg RED") is executable on the named channel. One wording nit (fold into F-5's one-line
edit): §3.1 says "fresh sim over the same latch var" — the leg must be the SAME world through
`reset()`, not a fresh process (a fresh process would prove nothing about re-arm).

### A5 — §9 checklist honesty (items 2/5/7)

Item 2: the `:276`-clause resolution it claims EXISTS (§0/§5/§8.2 grepped) — honest. Item 5: the
RED instruments it lists all exist in-document (C-E5 clamp row, keyed-site map-bypass, funnel
call-count, baseline-vs-baseline pixel) — honest. Item 7: "the anchor is the EXISTING committed
corpus … never an M3-minted fixture" — **dishonest by the F-1 collision** (one listed anchor is
declared to change). Items 8/9/10 re-checked against their rows: present and true.

### A6 — §3.1 editorial duplication (F-2, P3)

The "**Enemy rows:**" bullet ships TWICE (spec :309-311 and :312-317): rev-1 had one (:264 in
`2a19bb1`); the P4 fold appended the shape note as a NEW copy instead of extending the original.
Content is identical-prefix/superset so there is no contradiction — but duplicated normative
text in a build-depth spec is where rows later diverge. Delete the first copy.

## 3. PASS 3 — Regression scan (c1-verified rows vs the rev-2 edits)

- **SEL-A law rows:** §2 intact; roadmap `:63-66`/:268/:270-271/:285 re-grepped at 446c065 — every
  quoted string matches the roadmap verbatim; v2.0.0 decision unchanged. **Survives.**
- **Gimmick existing-only seams:** grepped all named seams at 446c065 — latch loop `world.gd:164-171`,
  `ALIVE_CAP` early-return :172, rate term :180 inside `minf(12.0,…)`, chests array :103, funnel
  :318-327 (`_dist < 16.0` chest branch :320 + union→evolve→grant), band swap `ground.gd:43-49` +
  `hud_3d.gd:25/:127`, `BOSS_NAME` const :33. **Survives.**
- **Event-wave deferral tracked:** §4 + T-M3e wave-map row + roadmap :42's "M2's +2 NOT LANDED —
  rides the deferred event-wave card" grepped. **Survives.**
- **Budget rows:** 27 / ≤27 / ≤28 ≤ 40 ≤ 60, horde ≤ 400, 403/401/401 all present (§7); pins
  `test_art_integration.py:41`(60) / `:42`(40) / `:44`(400) grepped. **Survives.**
- **Contract-B zero-delta:** `snapshot_json` grepped = exactly the 12 fields; `endless`/`cycle`
  outside at :36-37; `bridge.gd` funcs grepped = `_ready/_input/on_key/is_enter/move_vector/
  drain_presses` — still no run-start verb. **Survives.**
- **Hygiene 613 L:** header states the exception (spec :49-51, "Length note … M2-SPEC (536 L)") —
  and M2-SPEC measured THIS session is exactly 536 L. Reason stated ⇒ no P4 per the brief's rule.
- **New coupling the scan caught (F-3, P3):** §1.1's "read by exactly three call sites" — a
  tree-wide grep finds the three GAME consumers (world.gd:125, ground.gd:43 + its init :35,
  hud_3d.gd:127) PLUS four capture-channel readers: `sim_headless.gd:118/:257`,
  `biome_readability_capture.gd:162`, `art_capture.gd:116`. The byte-anchored legs WANT those
  readers left on the stage-1 wrapper (they are — fine, and A-E1 needs exactly that). But the
  stage-keyed form instruction + A-E7 ("readability extended per stage", roadmap §M3 ACCEPT) mean
  `biome_readability_capture.gd` must key its band read by stage for the per-stage windows — and
  neither that file nor `tools/biome_readability.py` (whose extension A-E7 itself names) appears
  in ANY §5 file set or §1.3. The builder will hit this at the red gate; per the same-file law's
  own clause it should be DECLARED: add both to T-M3s (or T-M3z's ACCEPT re-run row) and read the
  claim as "three game consumers + the capture channels stay on the wrapper".

## 4. Findings register

| id | sev | one-liner | fix |
|---|---|---|---|
| F-1 | **P2** | A-E1/§9.7's byte anchor includes `chests-tiers-m2.jsonl` — whose row 1 EMBEDS the 4-row map and whose leg `test_chests_tiers.py:201` §3.1/§10 declare re-pinned to the 7-row map IN-M3 ⇒ the anchor either re-mints (the removed circularity, chest-scoped) or T-M3g/T-M3b can't close green. | §1.4 A-E1 + §9.7: scope the chest-file anchor to its stage-1 observable rows and name the `map` row as the declared §3.1 re-pin (or move that fixture out of the byte-list — the other three anchors + journey are grepped map-free). |
| F-2 | P3 | §3.1 ships the "Enemy rows" bullet twice (:309-311 / :312-317; rev-1 had one) — fold-by-append artifact; duplicated normative text. | delete the first copy. |
| F-3 | P3 | A-E7's per-stage readability ride `tools/biome_readability.py` (named, unfiled) + `biome_readability_capture.gd:162` (unnamed, must go stage-keyed); §1.1's "exactly three call sites" counts only the game consumers (grep: 4 game + 4 capture sites). | name both files in the wave map (T-M3s) + one clause restating the count honestly and leaving the byte-anchored capture readers on the wrapper. |
| F-4 | P4 | §10 claims an "A-E2 RED extension" for the P3-3 fold; §1.4 A-E2's observable/red columns are unchanged ("a re-keyed band order ⇒ pin RED") — the placement RED exists only as §1.1 prose. | add "STAGES placed before `biome_at` ⇒ RED" to the A-E2 row (one cell edit) or drop the ledger claim. |
| F-5 | P4 | scalars bullet's "at cycle ≥ 1 no boss exists to scale" is loose (no boss SPAWN exists; an uncleared boss persists and its contact dmg scales live at `main.gd:210` — the HP claim itself is exact); §3.1's "fresh sim over the same latch var" should read "same world through `reset()`". | two wording touches in §3.1 / §3.1-retire bullet. |

**Counts: P1 = 0, P2 = 1, P3 = 2, P4 = 2.**

## 5. What survived (for the record)

All nine c1 fixes landed with TRUE mechanisms (each re-grepped at 446c065; the code tree is
byte-identical to the v1.3.0 GA the spec reads). The clamp arithmetic, the spawn-HP ladder, the
re-arm channel (sim_boss legs ride the real `_start_game` funnel), the keyed drop-site (byte by
key identity; the `[a-z-]+` SPEC_MAP regex takes the new keys), the UNIFIED-TIER survival, the
mesh dependency, the `:276` Reaper clause, the slice placement, the SEL-A/deferral/budget/
Contract-B survivals, and the length-note accuracy (536 L measured) all held under re-attack.
The only NEW defect is an interaction between two adopted folds — F-1 — and it is one sentence.

## 6. Reading-of-ambiguity statement

- The brief's "9/9 adoption, zero rebuttals" was verified as CLAIM (rev-2 header) and as FACT
  (§10 ledger vs diff, 5-row spot check) — both held; my 9/9 tally counts landed-in-text; P3-3
  and P4-2 land with P4 tails (F-4/F-5), counted LANDED because the operative constraint is in
  the doc where the builder reads it.
- A-E1's byte-anchor list is read as a strict byte-identity claim (the row's own "byte-stability"
  word + "any of the FOUR … flips ⇒ RED"); under any weaker reading (row-subset comparison) the
  spec still never states the subset — F-1 stands either way, only the fix width changes.
- "the FOUR EXISTING fixtures" is treated as exactly the four named files; if the producer reads
  it as "the corpus minus the chest map row", that sentence must say so — that IS the F-1 fix.

## 7. Fix list for cycle 3 (exact sections)

1. **§1.4 A-E1 + §9.7** — F-1 anchor carve (P2; the gate's one blocking row).
2. **§3.1** — delete the duplicated Enemy-rows bullet (F-2); F-5's two wording touches.
3. **§5 + §1.1** — F-3 file-set rows + call-site-count restatement.
4. **§1.4 A-E2 / §10** — F-4 one-cell RED leg (or ledger de-claim).

Row 1 is the only gate-biter; rows 2-4 ride the same commit. c3 re-checks row 1's carve text and
the regression it must not reopen (the three map-free anchors stay listed).

# VERDICT: FIX
