# M6-SPEC-DA-c2 — Devil's-advocate gate, cycle 2 (MC 11655, T-M6-DA2)

- **Target:** `docs/M6-SPEC.md` REV 2 @ `origin/master 46fed36` (1074 L). Cycle-1 doc
  `docs/M6-SPEC-DA.md` @ `668fee3` is immutable (VERDICT FIX, 2P1/5P2/3P3/2P4); this c2 re-checks
  the DECLARED LINES of the REV-2 fold (the fold ledger's own contract) and hunts NEW failure in
  the REV-2 text (option-(a) predicate, the sigil counter, the footer-parse instrument, the
  re-classed AT-RISK rows, the 11-row §9 table, the 31-row ACCEPT set, the §10 matrix).
- **Method:** every fold claim re-derived THIS session against the tree at `46fed36` (code is
  byte-identical `6e84ec9 → 46fed36` — the deltas are docs+LEDGER only, re-verified via
  `git diff --stat`): the option-(a) predicate walked window-by-window incl. the knotted-chain
  asymmetry the spec never names; PS-E4's planted red traced to RED on the REV-1 design; the §9
  consumer-set claim re-grepped at BOTH depths (direct `make_offer|LevelUpDeck` AND the
  `SimFunnel wire_pick` indirect funnel the spec itself declares for chests-tiers — the depth
  the fold's grep could not see), with the fixture BYTES themselves as the instrument; the
  `test_unions.py:148` pin read in source (it is a source-REGEX pin, and the replacement
  equal-or-stronger judged on that shape); the ACCEPT rows counted per table (5+7+6+3+2+4+4=31);
  the matrix law re-checked file-by-file. Capture `.tmp/m6da2.txt` (55 legs, VERIFY_EXIT=0).
- **Prior art honoured:** the c1 false-premise-STAY class (P1-2/P2-4) recurs as a FOLD HOLE: the
  fold applied its own correct logic (wire/funnel reads ⇒ AT-RISK/SHIFTS) to three channels and
  stopped, leaving the same false "why" on five more — the §9 consumer re-grep used only the
  direct-read pattern, and the fixture bytes refute it.

## 0. Verdict summary

**FIX.** 1 × P1, 2 × P2, 3 × P3, 4 × P4. The two c1 GATE fixes themselves HOLD: P1-1 option (a)
re-derives sound (all reserve windows traced; PS-E4 reds on the REV-1 design; the :148
replacement is equal-or-stronger), and the SD-E6 instrument is red-able and blocks the SHIFTING
card's own close (verified, §3 below). But the REV-2 completeness claims fold WORSE than they
read: §9's five-channel STAY row rests on a "none reads the offer funnel" clause that the
fixtures' own bytes refute (NF-1, P1), a strict corpus channel is still unnamed while the table
is claimed COMPLETE (NF-2, P2), and the matrix's P2-3 fix was applied to T-M6f but not T-M6d,
leaving the ownership law contradicting the SD-E5 grep universe (NF-3, P2). These are one-card
doc fixes; the milestone shape survives untouched.

## 1. Per-fold-row verdicts (the c1 fold map's 12 rows, + the header count claims)

| c1 row | REV-2 fold claims | verdict | what was actually checked |
|---|---|---|---|
| P1-1 → §3.4 option (a) | predicate window EXTENDED, one test; :148 pin falsified-and-replaced equal-or-stronger; PS-E4 grown; planted red RED on the REV-1 design | **VERIFIED** | Re-derived `reserved_for_union` (union.gd:68-76) window-by-window against the new trigger: partner BELOW MAX holds (existing); partner AT MAX + recipe passive ≥ 1 holds (new branch) ⇒ rot-water cannot evolve while dirge is reachable — including the passive-landing pick with both bases already MAX (try_level_evolve scans every weapon at the pick-apply tail, §3.1); at MAX + passive 0 the lift is honest (the union needs that passive anyway); partner GONE lifts ⇒ the `uni_reserve_lifted` twin keeps meaning. Asymmetry the spec never states but does not need: censer's EVO partner is knotted-chain, not loadstone (evolutions.gd:33-34) — its evolution needs its own passive, so the reserve is the only cross-time risk and both branches close it. :148 read in source: it pins the literal source regex (test_unions.py:146-149) — a two-branch assertion is equal-or-stronger on that shape (brittle-source-regex caveat: PS-E4's behavioural leg is the real guarantee — fine, both ride). PS-E4's MAX-window leg traced RED on the REV-1 predicate (below-MAX-only ⇒ `reserved_for_union(rot-water)` FALSE at censer MAX ⇒ rot-water evolves on the trigger pick) — the claim is TRUE, not just stated. Option-(b) rejection sound (a non-firing eligibility fn duplicates the predicate that owns the question). |
| P1-2 → §9 chests-tiers SHIFTS + PS-E3 retract | table now COMPLETE; consumer set re-grepped | **PARTIAL — folded WORSE than declared** | The chest-tiers row itself VERIFIED (sim_chest_tiers.gd:23-30 real `collect_pickups`/`_enter_levelup`/`_pick` drain + 240 weighted picks/tier git-true; PS-E3 STAY-pair retracted in-row, R5 keeper re-worded). But the completeness claim fails twice: **NF-1** (the §9 five-STAY row's "none reads the offer funnel" is REFUTED by the fixtures' own bytes) and **NF-2** (`art-s2i-probe.jsonl` — one of the 12 committed strict channels per M5-SPEC:641-644 — is named in NO §9 row while the SELF-DA checklist claims "the shift table is COMPLETE (11 rows)"). |
| P2-1 → §4.2 counter claim | `game.kills += 1` before the reaper guard; guard comment law restated | **VERIFIED** | git-true: world.gd:468 `game.kills += 1`; :477-478 reaper `return`; the guard's own comment "The kill counts; the drop arrays stay untouched" verbatim in-file. The honest restatement lands. |
| P2-2 → Drops.sigil_kills | dedicated counter ⇒ "EXACTLY every 750th non-boss, non-reaper kill" achievable | **VERIFIED** (NF-5 caveat) | Increment AFTER the guard + `if not enemy.boss` ⇒ every increment is an eligible kill ⇒ observable achievable, zero RNG unchanged, not a snapshot field (the frozen-12 law). Caveat NF-5: `boss` and `miniboss` are SEPARATE fields (world.gd chest-roll arms `if enemy.boss` :495 / `elif enemy.miniboss` :498) — see findings. |
| P2-3 → matrix + side tags | side tags disjoint; roster-m1h owned; T-M6f row fixed; SD-E5/PS-E7 executable | **PARTIAL** | Disjointness VERIFIED (weapon-side {weapons.gd, sim_combat.gd, test_card_icons, test_biome_numbers, test_levelup_caps, test_roster_m1h, s8_acceptance} ∩ evolution-side {evolutions.gd, sim_evolve, test_chests_evolve, chests-evolve-m1e} = ∅); test_roster_m1h.py:112 is the real doom `_fire` stat row and joins T-M6d; T-M6f's row names weapons.gd/sim_combat.gd under the declared edges (sim_combat via T-M6d is transitively ordered T-M6f←T-M6p←T-M6d AND the paragraph names both closes); PS-E7 vs SD-E5 close-points EXECUTABLE (each universe's sites retire in its own card; the spec's own retire rows are KEEP). But **NF-3**: T-M6d's OWN matrix row never lists weapons.gd — the first-editor law the fold just re-worded contradicts the ownership column, and SD-E5's grep universe ("the files T-M6d OWNS (§4.1's weapon-side list)") includes the file the matrix denies. |
| P2-4 → AT-RISK re-class | unions EXPECTS SHIFTS; limit moves only if the loadout pin carries the retired id | **VERIFIED** (NF-6 precision) | sim_union.gd:10-16 header (FULL legs through the real offer funnel) git-true ⇒ SHIFTS honest. limit-m4 verdict holds — the pinned loadout's icons are cleaver/dart-loop/plate (limit-m4.jsonl:1), NO retired id ⇒ bytes stay — but the cited EVIDENCE is wrong (NF-6: :249 calls KINDED offers, which never reach the LIMIT_CARDS arm, levelup.gd:126-128). Conservative AT-RISK either way. |
| P2-5 → SD-E6 instrument | every declared shift row needs a NON-EMPTY OWNER-RATIFICATION cell at the shifting card's close; empty cell ⇒ RED | **VERIFIED** (NF-7 fallout) | Red-able: YES — the parse reads a committed doc; an empty cell is the planted red. Blocks the SHIFTING CARD'S CLOSE specifically: YES — the parse covers "every channel ITS tree shifts", the doc ships empty-cell'd in T-M6d's own first commit, and a card cannot close on a RED suite; the M5 K-E3 precedent (doc flip ⇒ RED, LEDGER T-M5k row) is real. Consequence the fold created: **NF-7** — §10's T-M6z row still lists "ratification rows filled (owner answers pasted)" as T-M6z work, which the instrument makes impossible-after-T-M6d. |
| P3-1 → F-10 RE-SHAPE | named sentence vs audit-2's partition; T-M6q measures the spec's cut | **VERIFIED** | CLEAN-CODE-AUDIT-2.md:232-237 quote verbatim git-true ("spawn/entity/tabs vs reaper+cone"); the re-shape sentence exists and names the measuring instrument. |
| P3-2 → TX-E1 wording | 31 pool kinds + 3 LIMIT rows outside the count | **VERIFIED** | D-7/s8:262 vocabulary now used; 31 = 15+15+1 re-derived (15 passives git-true in levelup.gd PASSIVES; LIMIT arm kind=="" only, out of the count). |
| P3-3 → PS-E3 direct/indirect | direct-arm-only no-evolve; indirect declared by-design; funnel-routed pair | **VERIFIED** | world.gd:539-540 seam git-true; the indirect route is the shipped path (main.gd:291-303/:372 `_current_offer = _next_offer()` riding make_offer — :378's own comment "the SAME make_offer seam"). Both planted legs distinguish the arms as claimed. |
| P4-1 → :152 re-pin | re-pinned at both sites; D-5 = family, nothing to re-pin | **VERIFIED** | §1.1:272-274 and MV-E4:389 now cite `:188+`; the test is real (`test_player_glb_swap_and_live_height` at test_art_integration.py:188; :152 = "coinhound" inside the M5c roster list :148-157); remaining ":152" hits are the fold's own annotation + test_levelup_caps.py:152 (different file); D-5 names no line. |
| P4-2 → KEEP set | art-batch-m1c.tsv:17 + carry-caps named | **VERIFIED** | tools/vm100/art-batch-m1c.tsv:17 = `weapon-doom-sigil` provenance row (git-true); carry-caps-m1b.jsonl carries EXACTLY 64 doom-sigil rows (grep -c); icons-batch-m1c.tsv:11/:21 = doom + pale-moon rows (SD-E5's cite exact). |
| Header counts | 12/12 adopted, 0 rebuttals, ACCEPT 29→31, §9 9→11 rows | **VERIFIED as counts; honesty rows NF-1/2/3** | 31 rows counted per table (MV 5 + PS 7 + SD 6 + MG 3 + TX 2 + FX 4 + CT 4), every row carries a seam + a named planted red; the 12 dispositions are all PRESENT at the named sections. The 2P4/3P3 rows: no silent deferral — each landed its ask. What fails is the "COMPLETE"/reconciled SELF-claim on §9 and the matrix (folded rows 2 and 5 above). |

## 2. NEW findings (independent of c1; P-ranked; every cite re-grepped at 46fed36)

### NF-1 — P1: §9's five-STAY row rests on a refuted "none reads the offer funnel" — the fixtures' OWN bytes prove it (§9 :867)

The row's why: the five legs "construct DECLARED state — none reads the offer funnel (the
consumer set re-grepped THIS session: `make_offer|LevelUpDeck` in `godot/sim/` … — none of these
five)". The re-grep used the DIRECT-read pattern; the funnel reaches these legs INDRECTLY,
through the same `SimFunnel.fresh_run` + `wire_pick` + main.gd `_pick` drain route that THIS REV
declares for sim_chest_tiers (:576) and that the limit-m4 bytes themselves call "the real _pick
seam". The instrument is the fixtures:

- all five wire the pick funnel: sim_endless.gd:95, sim_events.gd:114, sim_stages.gd:111/:521,
  sim_reaper.gd:102/:125/:245, sim_gems.gd:81 (`wire_pick: true`);
- endless-m2.jsonl:1-3 dump `"phase":"levelup"` rows and the declared row states "offers
  declined" — an offer is `make_offer`'d before any decline;
- events-m4.jsonl:6 dumps an RNG-DEPENDENT digest — `"level":2,"phase":"levelup"`, `alive`,
  `gems`, and a 47-entry `types[]` spawn list — the leg's whole purpose is RNG-stream identity;
- stages-m3.jsonl:4 the cairns leg dumps `offer_drew_three_cards` / `offer_cards: 3` — the
  open→drain→pick seam consumed inside the byte-dumped leg.

Mechanism, end to end: doom-sigil out of `IDS` (16→15) ⇒ `build_pool` (levelup.gd:32-66) loses
one new-weapon card in EVERY run with an open slot (these legs carry ≤ 2 weapons) ⇒
`pool.shuffle()` (levelup.gd:119) consumes a DIFFERENT randi count AND `_pick(0)` draws different
cards ⇒ the shared game RNG forks from the first level-up ⇒ every downstream `randf()` (spawn
types/positions, drop rolls) moves ⇒ the dumped digest/state bytes move. This is the exact P1-2
harm the fold itself wrote for chests-tiers — a green close on a false premise, or a surprise
RED mid-card — on FIVE channels, in the table that claims to be "honest BEFORE the wave". It
also poisons the owner ask: the §9 ratification block would present ~4 SHIFTS + 5 STAY while
≥ 9 channels realistically move. **Fix:** re-class endless-m2 / events-m4 / stages-m3 to
AT-RISK→measured-SHIFTS per-channel (reaper-m4 + gem-merge-m2g at minimum AT-RISK — funnel
wired, run-length makes level-ups certain, digest shape unmeasured here), regenerate the §9
ratification ask AFTER the table is honest (rule-2 law: never present the owner a premise the
code refutes).

### NF-2 — P2: a strict-corpus channel is STILL unnamed while the table claims COMPLETE (§9 :856-872, :1031)

M5-SPEC:641-644 names the 12 committed strict fixtures verbatim — the list ends
`… reaper-m4, limit-m4, skinned-clips-s2r-framediff.csv, art-s2i-probe.jsonl`. §9's 11-row table
names 11 of the 12 and the M5 additions; **`art-s2i-probe.jsonl` appears in NO row** (grep: zero
hits in docs/M6-SPEC.md), while SELF-DA :1031 claims "the shift table is COMPLETE (11 rows — the
missed channel named …)". This is the same omission class c1 filed P1 for (P1-2 omitted
chests-tiers); the outcome risk is much lower here — art_probe.gd enumerates
`HordeViz.GLB_FILES` (:80) + `Roster.CHARACTERS` (:135) + `Roster.SKINS` (:159), none of which
M6 re-rows (row-0 mesh stays the `player.glb` literal, the promotion copy is byte-identical, the
heights re-measure the same file bytes) ⇒ expected **STAY** — but a committed channel with no
row cannot carry a measured outcome into the deviation doc. **Fix:** one STAY row, reason per
channel, before T-M6d commits the doc.

### NF-3 — P2: the §10 matrix denies T-M6d `weapons.gd` while §4.1/SD-E5 assign it there — the fold fixed the T-M6f half of P2-3(c) only (§10 :891-893, :675, :606-608)

Matrix law (REV-2's own wording): the owning card is the FIRST editor, later cards edit only
after their edge. T-M6d edits weapons.gd FIRST (IDS/META/`_fire` retire, §4.1 :606), and SD-E5
(:675) defines its grep universe as "the files T-M6d OWNS (§4.1's weapon-side list)" — which
STARTS with weapons.gd. Yet the T-M6d matrix row (:893) lists no weapons.gd and the T-M6p row
(:894) owns it (with §3.5 :553's own "SERIAL after T-M6d/F6" acknowledging T-M6d precedes).
At T-M6d's close this is a live contradiction: either SD-E5 reads zero while the retire's
PRIMARY file sits in a foreign universe (grep-to-zero over a list that omits the retired
symbol's home — the fleet's grep-to-zero law reduced to theater), or the matrix law breaks by
the owning card's own hand. T-M6f's row got exactly this fix in the same fold (:895) —
T-M6d's didn't. **Fix:** add `weapons.gd` to T-M6d's owned set; T-M6p edits it under the
declared serial edge, the identical shape T-M6f got two rows below.

### NF-4 — P4: the extended predicate strands two source-law comments the fold never names (§3.4 :534-544, §3.5 :549-552)

union.gd:22-27's header and evolutions.gd:57-61's try_evolve RESERVE comment both state the law
as "must NOT evolve while its union partner is carried BELOW MAX" — the same sentence
`test_unions.py:148` pins, which the fold falsifies-and-replaces. The comment law becomes
CONTRADICTED code at T-M6p's close unless rewritten in the same commit (the fleet retired-claim
law — grep-to-zero — is this spec's OWN §4.1 law). **Fix:** name the two comment rewrites in
§3.4's consequences (union.gd is owned; it is a one-line honesty row, not a file change).

### NF-5 — P4: `if not enemy.boss` makes MINIBOSS kills sigil-eligible while §4.2's own CLEAR carve treats MINIBOSS as a survivor class (§4.2 :634-648, world.gd:495-500)

`kill_enemy` carries SEPARATE `boss` and `miniboss` fields (chest arms `if enemy.boss` :495 /
`elif enemy.miniboss` :498). The sigil increment (`only if not enemy.boss`) therefore counts
miniboss kills — literally consistent with SD-E2's "non-boss, non-reaper" wording (miniboss is
"non-boss"), but the section one paragraph later carves MINIBOSS out of the clear as a survivor
CLASS. The spec must state the miniboss ruling in the increment condition or in SD-E2 (one
word: `and not enemy.miniboss`, or one clause naming miniboss kills eligible). Not a red risk —
an ambiguity risk the two-sites law exists to close.

### NF-6 — P4: the §9 limit-m4 why cites the wrong make_offer site (:866, sim_limit.gd:249, levelup.gd:126-128)

:249 iterates `make_offer(run.game, kind)` for `kind ∈ {gold, weapon, passive}` — the
LIMIT_CARDS arm is `kind == ""` only (levelup.gd:126-128), so at :249 the shuffled array is the
EMPTY kind-filtered pool, never LIMIT_CARDS. The real LIMIT_CARDS bytes come from the unkinded
main-funnel leg (limit-m4.jsonl:1 "half the offers picked through the real _pick seam",
counters arm:16/dmg:14/spd:20 — sequence-sensitive). The verdict survives (loadout icons
cleaver/dart-loop/plate — no retired id; a size-3 LIMIT array consumes the same shuffle RNG
regardless), but cite the leg that produces the bytes.

### NF-7 — P3: SD-E6 makes ratification a PRE-close precondition; §10's T-M6z row still lists "filled" as T-M6z work (§10 :898 vs :676/:880-885)

The instrument gates every shift-card's close on its channels' filled footer; T-M6d commits the
doc and is the first shift-card ⇒ owner answers must land BEFORE T-M6d closes (serializing the
parallel wave's close — intended by §9's gate). But the wave table still describes T-M6z as the
card where rows get "filled (owner answers pasted)". One-line fold slip with real sequencing
teeth. **Fix:** T-M6z VERIFIES the filled rows (its all-channels SD-E6 battery), not fills.

### NF-8 — P3: "10 evolved" collides with the spec's own 10→9 retirement — the FX pin would pin a dead row (§2.1 :397-398, FX-E2 :444 vs §4.1 :592 / R2 :684)

After R2 (`doom-sigil → pale-moon` out, TABLE 10→9) there are 9 live evolved ids; pale-moon is
KEEP-as-file, dead-as-fireable (the `_:` no-op arm stays, weapons.gd:327-330). "15 weapons + 10
evolved + 2 unions" pins a SKILL_FX row for an id that can never fire — and FX-E2's planted red
("a new id appended without a row") cannot catch a dead row (the vacuity class clean-code audit
2/3 walks). **Fix:** 9, or name pale-moon explicitly as a declared fallback row the pin EXCLUDES.

### NF-9 — P3: five sites cite a "§10 re-tally row" / "§10 budget row" that §10 does not contain (MV-E5 :390, §2.1 :403, §4.2 :658, SD-E4 :674, CT-E4 :818)

Grep: every `re-tally|budget row|27 measured` hit in the spec is at lines 390/403/658/674/818 —
none inside §10 (:887-926); §10's GPU paragraph carries no tally. The real numbers (today 27 /
plan 40 / hard 60) live in §12 D-6 (:999-1000) + DESIGN-3D §b. SD-E4's budget leg cites a row
that does not exist; CT-E4's re-pin cite is equally dangling. This is precisely the drifted-cite
class P4-1 was filed and re-pinned for — a REV-1 carry that c1 never opened (flagged under the
c2 hunt law). **Fix:** add the re-tally row to §10 (draws 27→28 pickup-family at T-M6d, glow
conditional) OR re-anchor all five cites to §12 D-6/the `draws` dump row.

### NF-10 — P4: §3.3's generic-passive list contradicts its own union-chip law and ships an unresolved "?" (:493-498 vs :578)

`insight` is listed among the five generic passives that "get chips: []" with the parenthetical
"insight also partners nothing? re-grep: the five v1 passives have no TABLE row" — true of the
EVOLUTIONS table (grep: zero `insight` in evolutions.gd) and FALSE for the union table
(union.gd:37 `"passive": "insight"`), which the SAME bullet list chips ("loadstone/insight chip
their union too"). PS-E5 (:578) governs `chips == partner set`, so insight MUST carry a chip —
the `[]` sentence, if executed literally, falsifies PS-E5's own leg. A build card executing from
the section head meets a question mark where the law should be. **Fix:** generic set =
{ferocity, haste, ward, grip}; insight carries the requiem-toll chip; delete the "?".

## 3. What SURVIVED the c2 attack (stated, per the seat's law — not a clean sheet)

- **The P1-1 gate fix is SOUND as adopted** — the brief's ask, re-derived not trusted: the
  extended predicate closes every dirge/requiem foreclose window at the new trigger (below-MAX,
  eligible-at-MAX, passive-landing pick), lifts exactly when the union is unreachable (partner
  gone / recipe passive 0 at MAX — the union needs it anyway), and the `uni_reserve_lifted` twin
  keeps its meaning. PS-E4's grown leg is EXECUTABLE (the trigger scans all weapons at any
  pick-apply tail, so a third-weapon or passive pick fires it with both bases at MAX) and its
  planted red traces RED on the REV-1 design (traced line-by-line, §1 row 1). A pre-600s
  hold-state (eligible union, chest time-gated by `GATE_T` which union.gd:46 still reads — the
  R6 hedge is git-true) blocks nothing wrongly: evolution would equally wait in the chest era.
- **SD-E6 answers the brief's exact question YES:** red-able (empty cell ⇒ RED over a committed
  doc), and it blocks the SHIFTING card's close specifically — not "some test": T-M6d commits
  the empty-celled doc itself and a card cannot close on a red battery (M5 K-E3 precedent real
  per LEDGER T-M5k).
- **P2-1/P2-2 mechanism:** counter-after-guard is git-true and the dedicated counter makes the
  exact-750th observable ACHIEVABLE (every increment eligible by construction); the clear
  advancing the counter through `kill_enemy` is deterministic and spec-stated, not a hole.
- **Fold arithmetic honest:** 12/12 dispositions PRESENT (no silent deferral; the 3P3/2P4 rows
  all landed their asks), ACCEPT = 31 real rows counted per table, each with seam + named red;
  §9 = 11 rows; KEEP cites (:11/:21/:17, the 64 carry-caps rows) exact.
- **Disjointness + close-points:** side-tag file sets are pairwise disjoint; test_roster_m1h.py
  is really the doom `_fire` stat row (:112) and now owned; PS-E7/SD-E5 are each executable at
  their named card; the T-M6f serial set is transitively ordered and paragraph-named.
- **c1's survivals re-touched, unchanged:** the P3-3 seam map is git-true (world.gd:539-540,
  main.gd:291-303/:372/:378), the F-10 audit-2 quote verbatim, the D-7 31-math, P4-1/P4-2's
  real-file evidence.

## 4. Dissent / residual risk

- NF-1 makes the wave's OWNER-facing ratification ask a live consent hazard until the table is
  fixed: pasting the owner a "~4 SHIFTS, 5 STAY" premise the code refutes is manufacturing
  consent on a false premise even with SD-E6 green. The ask must be regenerated after the §9
  re-class — the instrument alone does not protect the owner from a wrong table.
- The §9 "per-channel cmp still decides" hedge means NF-1/NF-2 produce surprise REDs and a
  wrong owner-ask, not false-green closes; the gate spine holds, the pre-declaration honesty —
  the one thing M6's amendment buys the owner — is what leaks.
- The source-regex pin shape (`test_unions.py:148`) is inherently brittle to any predicate
  formulation; the behavioural PS-E4 leg is the guarantee and the spec correctly ships both.

## 5. Fold map for REV 3 (each finding → its spec line)

1. §9 five-STAY row re-classed per-channel + owner ask regenerated — NF-1;
2. §9 `art-s2i-probe.jsonl` STAY row + SELF-DA "COMPLETE" de-staled — NF-2;
3. §10 T-M6d row += `weapons.gd` — NF-3;
4. §3.4 consequences += the two comment rewrites (union.gd header, evolutions.gd reserve
   comment) — NF-4;
5. §4.2/SD-E2 miniboss ruling named — NF-5;
6. §9 limit-m4 cite → the limit_all_maxed leg — NF-6;
7. §10 T-M6z row: filled → verified — NF-7;
8. §2.1/FX-E2 "10 evolved" → 9 — NF-8;
9. §10 re-tally row added OR five cites re-anchored — NF-9;
10. §3.3 insight row resolved — NF-10.

Rows 1-2 are the gate; 3 is the same class as the fold's own P2-3 fix; 4-10 are one-liners. The
two c1 gate mechanisms (option (a), SD-E6) need NO change — after this list lands, c3 SHIPs.

# VERDICT: FIX
