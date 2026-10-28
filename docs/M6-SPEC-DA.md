# M6-SPEC-DA — Devil's-advocate gate, cycle 1 (MC 11647, T-M6da)

- **Target:** `docs/M6-SPEC.md` REV 1 @ `origin/master 6e84ec9` (the spec declares its read-base
  `aca4ea8`; `git diff --stat aca4ea8 6e84ec9` re-run THIS session: **one file, docs/M6-SPEC.md,
  zero product diffs** — every citation below is therefore judged identically at both SHAs and the
  base-vs-ship drift excuse does not exist).
- **Method:** every code/doc/test citation in the spec's Code-truth header, §3, §4.4, §9 and §10
  re-grepped THIS session at `6e84ec9` against the real tree (`godot/scripts/`, `godot/sim/`,
  `tests/`, `tools/`, `docs/`, `LEDGER.md`); the doom-sigil retire ledger independently grepped
  (`grep -rn "doom-sigil"` — full hit-set re-derived, §4.4 compared row-by-row); the §9 shift table
  cross-checked against the REAL byte consumers (`grep -rln "make_offer|LevelUpDeck" godot/sim/` =
  cards_capture, sim_budget, sim_chest_tiers, sim_evolve, sim_limit, sim_union — compared against
  the table's rows and the fixture inventory `tests/fixtures/`, 15 files); the union reserve
  predicate RE-DERIVED against the new L5 trigger per the spec's own D-2 order ("verify the
  predicate, don't trust the paragraph"); the 29 ACCEPT rows walked for instrument existence and
  red-ability; the wave file-ownership matrix checked pairwise against every declared file edit.
- **Prior art honoured:** M5-DA P1-class (a runtime truth cited in the spec's own Code-truth
  paragraph, then a design law that never reconciles with it) recurs here in its exact shape:
  the spec cites `union.gd`'s precedence law and the reserve predicate VERBATIM (§Code-truth, §3.4)
  and then specifies a trigger move that silently voids the precedence. M4/M3's drifted-cite class
  recurs (P4-1).

## 0. Verdict summary

**FIX.** 2 × P1, 5 × P2, 3 × P3, 2 × P4. The milestone SHAPE survives — the owner order is
decomposed without loss (all 12 clauses land on features), F1's load-bearing premise is TRUE, the
consent discipline is clean, and the byte-deviation doctrine is the right mechanism. But two
load-bearing claims are REFUTED against the code: as written, the F3 trigger move **makes the
shipped union `dirge-eternal` unreachable** (P1-1), and the §9 pre-declared shift table **omits a
strict-corpus channel that the pool change forks** while naming it a STAY pair in PS-E3 (P1-2).
These are gate rows; the rest are foldable in REV 2 alongside them.

## 1. Findings

### P1-1 — F3's trigger move voids the union-precedence law: `dirge-eternal` becomes unreachable (F3 §3.1/§3.4; D-2)

The shipped rule is protected by **co-location**: at the chest-open site `UnionSystem.try_union`
runs BEFORE `EvolutionSystem.try_evolve` (world.gd:532-541; `union.gd:14-18` states the precedence
law), and `reserved_for_union` (union.gd:68-76) returns true **exactly while the union's partner
base is carried BELOW MAX_LEVEL** (`test_unions.py:148` pins that wording: "the reserve holds
exactly while the partner is carried below MAX"). Union eligibility (`union.gd:50-51`) requires
BOTH bases AT MAX. So under the shipped game the reserve lifts precisely when the union becomes
eligible — and the same-site precedence makes the union win.

The spec moves evolution to the `apply_offer` tail with gate `level ≥ 5` (§3.1) while union STAYS
chest-only (§3.1: the chest arm becomes `try_union` ONLY). The precedence is gone with the site.
Trace dirge-eternal (censer-of-hours + rot-water + loadstone — the spec's own §3.4 scenario):
player carries loadstone, both bases in the roster; any pick takes censer to MAX (the very pick
leveling it is the trigger site, §3.1 "tail of the upgrade arm") → `reserved_for_union(rot-water)`
is now FALSE (partner at MAX, not below) → rot-water at L5+ with partner carried **evolves to
the-sluice on that pick** → dirge-eternal's second base is gone before any chest can exist.
Worse than "sometimes": a dirge run must carry loadstone and take both bases to MAX, so the
evolution consumes rot-water on the MAX-landing pick **every time** the union would complete.
Shipped `tests/test_unions.py` stays green (its legs construct state directly — sim_union.gd:234
appends MAXed weapons, never drives the new trigger), so NO planted red fires: PS-E4 covers only
"below-MAX ⇒ no evolve" and "union gone (partner removed) ⇒ evolve"; D-2's planted red tests
REMOVING the reserve, not the both-MAX window. The spec's §3.4 claim that the verbatim predicate
"skips a base while its union is REACHABLE" is FALSE at the new trigger — reachable-at-MAX is
exactly where the predicate says NOT to skip.

**Fix (any one, all cheap):** make the level-trigger skip when the union is ELIGIBLE-or-reachable
(extend the predicate with the union's own MAX+passive test, or skip while both bases are carried
and the recipe passive ≥ 1), or move the precedence law with the trigger (check `try_union`
eligibility before evolving — one call, same table). PS-E4 must grow the leg: *both bases at MAX +
passive carried + a pick lands before the chest ⇒ union still achievable.* Without that leg the
hole is uninstrumentable and this gate cannot SHIP a mechanism-monogamy claim.

### P1-2 — §9's shift table omits `chests-tiers-m2` and PS-E3 names it a STAY pair (F-9; §9; PS-E3)

The §9 pre-declared table claims to be complete "honest BEFORE the wave — the brief's exact ask".
It is not: `tests/fixtures/chests-tiers-m2.jsonl` (one of the strict-corpus 12 committed channels,
`test_characters.py:7-9`) is named neither SHIFTS nor STAY. The consumer reads the forked stream:
`sim_chest_tiers.gd:23-30` — "real collect_pickups open per tier — … `_enter_levelup/_pick` seam ==
item_count offers of 3 cards each" and "chest_pick_weights x3: 240 weighted picks per tier" via the
real `make_offer`+`_pick` (grep: sim_chest_tiers.gd uses `make_offer`, `wire_pick`, `run._pick`).
T-M6d's pool change (IDS 16→15, `levelup.gd build_pool` iterates `WeaponSystem.IDS`) changes the
weapon-filtered pool's size → `pool.shuffle()` (`levelup.gd:119`) consumes a different RNG count →
the legs' card streams and weights change → the fixture's bytes move. Meanwhile **PS-E3 names the
chests_tiers fixtures a "STAY pair"** — a green close on a false premise, or a surprise RED
mid-card. **Fix:** add the channel to the §9 table (expected SHIFTS, per-row measured diff),
re-word PS-E3's STAY pair to the union legs only (which the sim constructs, P2-4 aside), and let
the deviation doc carry the measured outcome before that card closes.

### P2-1 — §4.2's reaper-counter claim is CONTRADICTED by the code (F6)

§4.2: "reaper deaths already return before the counter row, so a reaper never advances it."
`kill_enemy` (world.gd:464-500) runs `game.kills += 1` (≈ :468) **BEFORE** the reaper death-guard
`return` (≈ :477-478), whose own comment states the opposite of the spec: "The kill counts; the
drop arrays stay untouched." As written, riding `game.kills` means reaper kills DO advance the
sigil counter. Implementer-trusts-prose vs implementer-reads-code diverge here — the exact class
the spec's own header law ("file:line are the truth") exists to prevent. **Fix:** either own it
(reaper kills advance; SD-E2 wording follows) or count non-reaper kills in `drops.gd` (one named
counter) and cite the guard.

### P2-2 — SD-E2's "EXACTLY every 750th non-boss kill" is unachievable with the chosen counter (F6)

The mechanism is `kills % SIGIL_EVERY_KILLS == 0` on the TOTAL counter, drop-emitting only on a
non-boss/non-reaper kill (boss kills advance `kills` but never drop — spec states this). A boss
kill landing on a multiple consumes it: the next sigil waits a further 750 kills. So the observable
SD-E2 promises ("a scripted kill-run dumps a sigil at EXACTLY every 750th non-boss kill") is not
what the mechanism does; the leg will read RED against its own build. **Fix:** define the counter
over non-boss, non-reaper kills only (same zero-RNG law, honest fork: the counter is no longer
`game.kills`), or re-word the row to "every multiple of 750 total kills that lands on a non-boss
kill". Either way the planted-red pair still holds — but the row must match the mechanism.

### P2-3 — the wave file-ownership matrix contradicts the §4.1/§4.4 retire ledger and T-M6f's file list

Matrix law: "a file has ONE owning card". Contradictions: (a) T-M6d's content column says
retirement greps **"weapon-side"**, yet §4.1 lists `evolutions.gd TABLE :37` (owned by T-M6p),
`godot/sim/sim_evolve.gd:118` (T-M6p) and `tests/test_chests_evolve.py:50,:196` (T-M6p) in the
retire ledger, and `tests/test_roster_m1h.py:112` (owned by NOBODY — the file appears in no card's
set). (b) SD-E5's grep-to-zero "at close" of T-M6d CANNOT read zero while those live-table/live-test
sites retire in T-M6p — as written the row is unexecutable at the named instrument/time; if T-M6d
edits the foreign files instead, the matrix law breaks. (c) T-M6f's §2.2 edits `weapons.gd` (owned
T-M6p — the serial edge is declared but the ownership row is wrong) and the `sim_combat.gd` caps
mirror (owned T-M6d, no serial edge declared for it). **Fix:** scope SD-E5 explicitly to the
weapon-side KEEP set at T-M6d and add a T-M6p "grep-to-zero, evolution-side" row; add
test_roster_m1h.py to T-M6d's owned set; add weapons.gd/sim_combat.gd to T-M6f's row (the serial
ordering already makes it safe).

### P2-4 — §9's STAY "why" for unions-m2u and limit-m4 is contradicted by the sims' own headers

The table's STAY reason "these legs pick scripted cards, not shuffled streams" is false as stated:
`sim_union.gd:15` — "through the real offer funnel (real make_offer cards + real _pick, no …)";
`sim_limit.gd:249` iterates `LevelUpDeck.make_offer`. The cell's fallback hedge ("where a leg DOES
read an offer stream, the F-1 fork applies") saves the bookkeeping but anchors two "expected STAY"
rows on legs that DO read the forked stream — the same false-premise class as P1-2.
**Fix:** re-word the reason per-channel (declared-state legs stay; offer-consuming legs move to
measured-SHIFTS at card time) and pre-mark both as AT-RISK in the deviation doc.

### P2-5 — the owner-ratification gate is consent prose without an instrument: a card CAN close green on unratified shifts (loophole hunt, §9)

Run against the brief's question: YES, as specced. The gate ("no M6 card whose feature shifts a
channel CLOSES until its channel's ratification row is filled") exists only as §9 prose. Of the 29
ACCEPT rows, PS-E6 instruments UN-declared shifts (the leak check); nothing instruments a
DECLARED-but-unratified shift — and the §9 ratification rows say "pasted when the owner's verbatim
answer arrives", with the close gate enforced by nobody in-repo. The fleet's own precedent shows
the missing instrument: the RIG deviation's owner "Rec" is asserted BY a test row (M5 K-E3 doc-pin,
LEDGER T-M5k row: "owner 'Rec' verbatim asserted"), and that leg has a planted red (a doc flip
went RED, capture m5k). **Fix:** one test row in T-M6d's family — parse `docs/BYTE-DEVIATION-M6.md`
and assert each declared channel's footer carries a non-empty owner-ratification row before the
channel's card closes; planted red = a declared channel with an empty ratification cell ⇒ RED.
Without it the doctrine this milestone invents is a rule the spec only *narrates*.

### P3-1 — F-10's split shape is not the SCHEDULED split's named shape

CLEAN-CODE-AUDIT-2 DEFERRALS (verbatim, re-read THIS session at :232-237): "world.gd's
JUSTIFIED-NOT-REDUCED split (**spawn/entity/tabs vs reaper+cone logic**) … the card that grows into
it must carry it". F-10 instead moves the DROPS/PICKUP concern out and leaves reaper+cone in
world.gd. The grower-carries law is honored in substance (a split lands, byte-law stated), but
§10's promise "the audit verifies it SHIPPED, not just planned" will read against the audit's named
partition, not this one. **Fix:** state the re-shape in F-10 (named, one sentence) so the T-M6q
audit measures the right claim.

### P3-2 — TX-E1's "every pool kind … + 3 limit cards" wording collides with the D-7/R3 count law

D-7 (and s8_acceptance.py:262 verbatim: "NOT pool kinds — the pool kinds stay 32") is the spec's
own anti-drift law; TX-E1's phrasing calls the three `LIMIT_CARDS` part of "every pool kind". The
coverage itself is right (they ARE offerable text); the law-vocabulary is wrong in the one row
whose whole point is the count law. **Fix:** re-word to "31 pool kinds + the 3 limit rows (outside
the count, the M4 P3-5 law restated)".

### P3-3 — PS-E3 overclaims: a chest still evolves INDIRECTLY through its tier cards

`ChestRewards.grant` → `pending_levels` → the levelup seam → `apply_offer` is the shipped path
(sim_chest_tiers.gd:23-25 names it; main.gd:385-393 rides it). PS-E3's observable "a chest open at
the OLD gate performs NO evolution" holds only for the direct arm; after T-M6p a chest's tier-card
pick CAN satisfy the L5+partner condition — fine by design, wrong as an absolute row, and it is
exactly the indirect route P1-1 travels. **Fix:** re-word PS-E3 ("the chest OPEN performs no
evolution; tier-card picks ride the level trigger, per the new law") and route its planted pair
through the `_pick` funnel so the leg means the direct arm.

### P4-1 — `test_art_integration.py:152` cite is wrong (drift class; cited three times)

The spec's §1.1, MV-E4 and D-5 name `test_art_integration.py:152` as "the seam-pin literal
`player.glb`". At the cited line sits the M5c ROSTER-rows list (:148-157); the player.glb seam-pin
is `test_player_glb_swap_and_live_height` at :188+ (:18, :188, :190). Re-pin the cite in REV 2
(the M5-DA P3 class: drifted cites fold silently unless named).

### P4-2 — the retire ledger's KEEP set misses two grep sites

`grep -rn "doom-sigil"` hits `tools/vm100/art-batch-m1c.tsv:17` (`weapon-doom-sigil` provenance —
R8 names only icons-batch-m1c.tsv) and `tests/fixtures/carry-caps-m1b.jsonl` (64 rows — covered by
the §9 offer-stream re-anchor but not named in §4.1's "every site grepped THIS session"). SD-E5
says the KEEP set is "defined precisely"; define these two too (provenance-KEEP + re-anchor row),
so the grep-to-zero can actually go green at close.

## 2. What SURVIVED the attack (stated, per the seat's law — not a clean sheet)

- **F1's load-bearing claim is TRUE:** no clip is consumed in-game. `class_mesh.gd:_import`
  (:35-48) bakes `surface_get_arrays(0)` into an ArrayMesh (skinning and animation stripped);
  `hero_pawn.gd:_process` (:90-96) writes position + iframes alpha ONLY — the pawn slides;
  `player-rigged.glb` exists ONLY at the repo-root provenance dir (8.2 MB, re-listed THIS session;
  `godot/assets/glb/` has no rigged copies). The capture-harness-only-consumer story holds.
- **§1.5 consent discipline holds:** the RIG-DEVIATION-SEL-C quotes re-read verbatim at target —
  owner **"Rec"** (2026-10-27), "OPTION A — the five rig-inference failures SHIP STATIC …
  (option A, statue-class static)", final table **7 rigged / 6 static**, deterministic seed-fixed
  (12345) collapses, the two ratified re-masters both rig-stage-failed (coinhound 4-bone,
  tallow-seer 3-bone). Options (b)/(c) are priced honestly against that history; the procedural
  arm does not re-open the ruling (transforms, not meshes). No manufactured consent found anywhere
  in the doc — §4.2 and §8 carry real priced alternatives with recommendations.
- **F5's claim is TRUE and one-mechanism:** `_magnetize` is called for gems + heals ONLY
  (world.gd:403-404), one `magnet` value (:399-402, grip + loadstone lines), pull speed 220 px/s
  confirmed (:420-421); the MG-E1/MG-E2 pins exist where cited (test_biome_numbers.py:144 area,
  :249 IDS pin).
- **F7's candidate set is TRUE:** all seven named classes read WHITE — `ENEMY_TINTS` is exactly the
  five classics, `BIOME_TINTS` exactly the four signatures (`tint_of`'s fallback, render.gd:45-46
  re-read); the four "hits" (cathedral-choir, sunken-prelate, ossuary-warden, stair-acolyte) are
  STAGES boss rows at render.gd:124-135, NOT tint rows. The hero's `BONE × 3.6` lift precedent is
  real (hero_pawn.gd:31) and biome_readability's RATIO_MIN=2.0 leg exists.
- **F2's mechanism claims are TRUE:** six effect classes / seven materials per the EMBER/MOON/BONE/
  ICHOR law (viz_fx.gd:43-50 re-read), the bulk-gem COLOR-instance mechanism ships (pickup_viz.gd
  :113/:284/:292 `use_colors` + `vertex_color_use_as_albedo`), the "would LIE" sim-truth law is at
  viz_fx.gd:214, the draw tally instrument exists (`budget_draws`, sim_budget.gd:27/:125/:135,
  pawn counted at :311). F3's `_:` no-op hole is real (weapons.gd:327-330) and the `effect()`
  identity-fix shape is byte-sound for un-evolved weapons.
- **F6's zero-RNG counter choice is defensible** (the D-4 argument stands as argued — RNG rarity
  IS the shipped law; the counter is the deviation-minimizing mechanism) subject to P2-1/P2-2;
  the s8 A7 32→31 math re-derives (s8_acceptance.py:262; LIMIT_CARDS ride the catch-all,
  levelup.gd:85-92/:117-118 re-read — D-7's warning honored, the count is 31 = 15+15+1).
- **The §10 ordering spine is sound modulo P2-3:** the parallel set (T-M6d/T-M6r/T-M6c) is file-
  disjoint as far as the matrix shows, the strips-table single-owning (T-M6f, T-M6r's capture as
  input) is the correct dedupe, and the GPU-zero v1 claim is true as designed.

## 3. Dissent / residual risk

Even after the P1 fixes, M6 makes byte-monogamy permanently conditional — the deviation doc becomes
the corpus's second authority. That is the owner's ratification call (correctly escalated, §9) and
this gate accepts it WITH P2-5's instrument; without the instrument it is not a gate, it is a hope.

## 4. Fold map (what REV 2 must touch — each finding → its spec line)

1. §3.1/§3.4 + PS-E4 (grow the leg) — P1-1; 2. §9 table + PS-E3 — P1-2; 3. §4.2/SD-E2 — P2-1,
P2-2; 4. §10 matrix rows + SD-E5 scoping — P2-3; 5. §9 STAY reasons (unions/limit) — P2-4;
6. new ACCEPT row in T-M6d's family (ratification doc parse + planted empty-cell RED) — P2-5;
7. F-10 shape sentence — P3-1; 8. TX-E1 wording — P3-2; 9. PS-E3 wording + funnel-routed red —
P3-3; 10. :152 re-pin ×3 — P4-1; 11. §4.1/R8/SD-E5 KEEP-set completion — P4-2.

Rows 1-2 are the gate; rows 3-6 must land beside them (they are the same claims in their second
and third appearance — folding one and not the other is the M3/M4 fold-collision class). After the
declared lines land, c2 can SHIP on re-check.

# VERDICT: FIX
