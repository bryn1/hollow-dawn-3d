# M6-SPEC-DA-c3 — Devil's-advocate gate, cycle 3 (MC 11659, T-M6-DA3)

- **Target:** `docs/M6-SPEC.md` REV 3 @ `origin/master 3bbfd57` (1179 L). `git diff 46fed36..3bbfd57
  --stat` = `LEDGER.md + docs/M6-SPEC-DA-c2.md + docs/M6-SPEC.md` ONLY — code bytes unchanged since
  `6e84ec9` (re-verified this session), so every tree claim is judged at the same bytes c1/c2 measured.
  Cycle-1 `docs/M6-SPEC-DA.md` @ `668fee3` and cycle-2 `docs/M6-SPEC-DA-c2.md` @ `34156ea` are
  immutable (the latter re-confirmed: `git diff 34156ea..3bbfd57 -- docs/M6-SPEC-DA-c2.md` = 0 lines).
  This c3 verifies the DECLARED LINES of the REV-3 fold (the REV-3 FOLD LEDGER's own contract) and
  hunts NEW failure in the REV-3 text only (the 16-row table, the cmp-decides protocol, the NF-5
  carve wording, the RE-TALLY row).
- **Method:** every one of the ten c2 fold rows re-derived THIS session from the tree and the
  FIXTURE BYTES myself (no evidence carried from c2): the five `wire_pick` sites sed'd at the cited
  lines; `endless-m2.jsonl`/`events-m4.jsonl`/`stages-m4`-class bytes parsed with json; the reaper
  legs read in full (walk-vs-warp); `_pin_gems`/`update_entities` read in source; `levelup.gd`
  :110-132 read line-by-line; the three stranded comments sed'd at the spec's NEW cites;
  `art_probe.gd` :80/:135/:159 sed'd; `weapons.gd` :327-330 sed'd; the §9 table enumerated from
  the file; the ACCEPT rows counted per table; the budget number chased to its measurement home.
  Capture `.tmp/m6da3.txt` (30 legs, VERIFY_EXIT=0).
- **Precedent honoured:** M5-c2 (`docs/M5-SPEC-DA-c2.md`) — a cycle-3/late gate SHIPs on real
  adoption + P4 tails as wave-brief material; the cycle-class hunted here is **an adopted fix whose
  own byte-cites drift** (the fold's declared instrument was "re-derived THIS session from the
  fixture BYTES" — so its byte-cites are held to the byte).

## 0. Verdict summary

**SHIP.** All ten c2 fold rows LANDED AS DECLARED, each re-verified from the bytes myself: the
five-STAY row is gone (the §9 table enumerates 16 rows at :907-922; the header's classification
re-derives exactly — SHIFTS-class 5 = journey-5020 + carry-caps + chests-tiers SHIFTS + chests-evolve
REMINT + strips RE-DERIVE; AT-RISK 6 rows / 7 channels; STAY 5); the three EXPECTS-SHIFTS verdicts
are byte-true; the reaper/gem-merge rows are honest-not-hopeful (verified against the leg bodies,
§1 row 1); the ask-text law is actually stated (§9 :926-929); the strict-12 list is now 12-of-12
named in §9 and no live "COMPLETE" claim survives; the matrix, the carve, the T-M6z truth, the 9-count,
the RE-TALLY row and the insight law all landed and resolve. The two c1 gate mechanisms (option (a),
SD-E6) are untouched and still sound (SD-E6's row is byte-identical to REV-2, and the AT-RISK→SHIFTS
card-time outcome flows through it exactly as c2 verified for the REV-2 union/limit rows). NO P1,
no P2, no P3. Three P4 tails — two byte-cites the fold restated without re-measuring (the "47-entry"
count is 45; `union.gd:37` sits three lines off) and two stale shorthand cells the fixes moved past
(§10 matrix rows) — all verdict-neutral, wave-brief material (M5-c2 precedent). The gate holds and
the owner package can be built exactly as §4 states it.

## 1. Per-fold-row verdicts (the c2 §5 fold map's 10 rows, each re-derived at 3bbfd57)

| c2 fold row | REV-3 claim | verdict | what I checked THIS session (bytes, not prose) |
|---|---|---|---|
| **1. §9 five-STAY re-class + ask regenerated (NF-1, P1 — the gate)** | five honest per-channel rows, no STAY left on a refuted why; ask text derives from THIS table | **VERIFIED** | Five-STAY row GONE (grep "none reads" = 2 hits, both quoting-the-retirement: §9 :912, fold ledger :1146). All five funnel wires byte-exact at the cited lines: `sim_endless.gd:95`, `sim_events.gd:114`, `sim_stages.gd:111`+`:521`, `sim_reaper.gd:102`+`:125`+`:245`, `sim_gems.gd:81` (all sed'd). endless-m2.jsonl:1-2 DUMP `"phase":"levelup"` (t 900.017/1800.017) and :3 DECLARES "offers declined" — an offer is made + shuffle consumed before any decline ⇒ EXPECTS SHIFTS true. events-m4.jsonl:6 `digest_off_end` = {alive:45, gems:3, gold:0, kills:19, level:2, phase:"levelup"} + `checks.rng_stream` (every field re-read with json; the types[] COUNT is 45 not the row's 47 — NF3-1, verdict-neutral). stages-m3.jsonl:4 `checks.offer_drew_three_cards:true` + `offer_cards:3`; `sim_stages.gd:104-107` `_decline` = `SimFunnel.take_first_card` = `run._pick(0)` while levelup (`sim_funnel.gd:72-77`) ⇒ "ACCEPTS card 0 — the stages donor's fork" is LITERAL. **reaper-m4 = honest, not hopeful:** `_leg_limit` (:152-190) and `_leg_latch` (:213-235) are REAL-TIME WALK loops (STEPS_MAX/LATCH_STEPS at DT, hp-pinned) surviving past 900-960 s calling `SimFunnel.decline(run)` EVERY TICK — the every-tick decline is itself the shipped evidence that level-up phases arise during the leg (offer made, drained; the same shape the endless row's "offers declined" proves) ⇒ "level-ups CERTAIN at run length" is code-true; arrivals 900.017 ×2 / 960.017 ×1 byte-true in reaper-m4.jsonl; the row concedes the dumped fields' dependence unmeasured ⇒ cmp decides. **gem-merge-m2g = honest:** `_pin_gems` (`sim_gems.gd:86`) constructs the arrays and `update_entities` is called DIRECTLY (:125/:131/:146 legs) exactly as the row's "SYNTHETIC-PINNED" says, and the unmeasured window is named as unmeasured. Ratification law ACTUALLY STATED :926-929 ("DERIVES FROM THIS REV-3 TABLE AND SUPERSEDES EVERY EARLIER DRAFT" + the "~4 SHIFTS, 5 STAY" premise RETIRED with the rule-2 reason); the retired phrase survives only inside that retirement sentence (:927). |
| **2. art-s2i-probe enters + COMPLETE de-staled (NF-2, P2)** | STAY row with byte-derived reason; claim retracted | **VERIFIED** | Row at :920. Reason byte-true: `art_probe.gd:80` `for key in HordeViz.GLB_FILES`, `:135` `for row in Roster.CHARACTERS`, `:159` `for srow in Roster.SKINS` (sed'd); fixture player row at :18 `"glb":"player.glb"` and §1.1 (:288-295) makes the art-fixture heights an explicitly-named `Roster.CHARACTERS[0].mesh` literal consumer ("row-0" is the spec's OWN established name — :90/:292/D-5 :1057 — not a fixture-line claim; checked before filing, cleared). The M5-SPEC:641-644 strict-12 list re-read VERBATIM and ALL 12 now named in §9 (:908-:920 enumerated). "COMPLETE" grep = 4 hits, every one inside the RETRACTION sentence (:13, :920, :1099, :1147) — no live completeness claim survives. |
| **3. T-M6d += weapons.gd (NF-3, P2)** | first-editor law and SD-E5's universe agree; T-M6p EDITED-UNDER-SERIAL | **VERIFIED** | T-M6d row (:948) lists `weapons.gd` with the NF-3 reason; T-M6p row (:949) re-tags its weapons.gd entry EDITED UNDER SERIAL citing the §3.5 edge, which exists at source (:589 "SERIAL after T-M6d/"). §4.1's retire ledger re-read: it STARTS with `weapons.gd IDS :25` — the row's "which STARTS with this file" is true. Disjointness holds: PS-E7's evolution-side universe (PS-E7 cell :632: evolutions.gd, sim_evolve.gd, test_chests_evolve.py, chests-evolve-m1e.jsonl, chips/desc rows) contains no weapons.gd. Residual stale cell on the ADJACENT T-M6f row → NF3-3(b). |
| **4. three stranded comments named (NF-4, P4)** | §3.4 consequence (2) grows; same-commit rewrite law | **VERIFIED** | All three byte-true at the spec's NEW cites: `union.gd:21-25` header carries "must NOT evolve while its union partner is carried below MAX" (inside the cited :21-27); `union.gd:64-67` doc-comment reads "True exactly when … that row's partner base is carried below MAX_LEVEL"; `evolutions.gd:52-58` RESERVE comment "skipped while its union partner is carried below MAX". The fold CORRECTED c2's two drifted cites (`union.gd:22-27`→`:21-27`, `evolutions.gd:57-61`→`:52-58`) — both sites moved, both new cites exact; the count also grew c2's "two" to the true three (c2 had missed the doc-comment). |
| **5. miniboss ruling named (NF-5, P4)** | increment `and not enemy.miniboss`, riding the §4.2 OWNER-DECISION — no manufactured ask | **VERIFIED** | §4.2 (:672-679) states the increment `if not enemy.boss and not enemy.miniboss` with the separate-fields evidence at the TRUE cites (`world.gd:495` `if enemy.boss and randf()…` / `:498` `elif enemy.miniboss…`, sed'd). NO new owner-ask was manufactured: grep OWNER-DECISION = :247/:369(§1.5)/:677(rider)/:689(§4.2 CLEAR)/:864(§8)/:1046/:1080 — the carve RIDES the pre-existing §4.2 CLEAR row (:689-691, "bosses + minibosses + the reaper SURVIVE (recommendation)", alternative priced), and "if the owner rules a class dies instead, BOTH terms move together, one ruling" is stated. Wording consistent across §0 F-6 (:229-230), §4.2 law, SD-E2 (leg grew the interleaved-miniboss twin + planted red) and SD-E3 (already carved). Stale shorthand in the §10 matrix → NF3-3(a). |
| **6. limit cite corrected (NF-6, P4)** | cite names the real producer; verdict survives | **VERIFIED** | `levelup.gd` read line-by-line: :117 `if kind == "" and pool.is_empty():`, :118 `pool = LIMIT_CARDS.duplicate()`, :119 `pool.shuffle()` — the spec's "kind == "" ONLY, levelup.gd:117-118 — measured this session" is EXACT. `sim_limit.gd:249` is the KINDED `for c in LevelUpDeck.make_offer(run.game, kind)` (loop head :247, `kind ∈ {gold,weapon,passive}`) ✓. The real producer bytes: `limit-m4.jsonl:1` `"half the offers picked through the real _pick seam, half declined"`, `limit:{arm:16,dmg:14,spd:20}`, icons cleaver/dart-loop/plate — no retired id ⇒ the surviving verdict is byte-backed. |
| **7. T-M6z VERIFIES-not-fills (NF-7, P3)** | row truthfully states the pre-close precondition | **VERIFIED** | T-M6z row (:953) reads "**VERIFIED filled — NOT filled here**" with the SD-E6 serialization stated once, in that row. Consistency with SD-E6 (:720 — the row byte-identical to REV-2 per the diff): the instrument keys on the DEVIATION-DOC row status, so an AT-RISK channel that cmp-lands SHIFTS is gated by the same parse at the shifting card's close; grep "filled" = the gate sentence (:932) + the T-M6z row + fold-ledger/history only — the REV-2 contradiction is gone. The header's serialization sentence ("serializes the parallel wave's close on the owner answer: intended") matches the §10 serial-edges paragraph. |
| **8. 10→9 + pale-moon EXCLUDE (NF-8, P3)** | no dead FX pin; exclusion stated | **VERIFIED** | §2.1 :419 "15 after F6 + the 9 evolved + 2 union ids"; FX-E2 (:468) names `pale-moon` as the declared fallback row the pin EXCLUDES with the vacuity reason. Live use of "10 evolved" = ZERO (the single grep hit :1153 is the fold ledger quoting the RETIRED claim — replace-not-delete history). `weapons.gd:327-330` sed'd: the `_:` arm "fire no-ops unknown ids" — pale-moon KEEP-as-file/dead-as-fireable is byte-true; §4.1's R2 row `evolutions.gd TABLE :37 (10→9)` consistent. |
| **9. §10 RE-TALLY row + cites resolve (NF-9, P3)** | the row the five cites name exists; grep-to-zero on dangling cites | **VERIFIED** | Row at :976-983. All five cites resolve: MV-E5 :412 "(27 measured baseline; §10 re-tally row)"; §2.1 :427 "§10 re-tally proves"; §4.2 Viz :702 "the §10 re-tally row, ≤ plan 40"; SD-E4 :718 "budget row green" (the RE-TALLY row self-declares as "the ONE budget law" naming SD-E4 — resolves by the row's own text); CT-E4 :862 "+1 over the §10 RE-TALLY row's total AT THIS CLOSE". The baseline 27 is MEASURED-at-its-home: DESIGN-3D.md :74-76 "measured budget draw row 27/60 under the WORST-CASE LOADOUT, sim_budget.gd" and §12 D-6 :1063-1065 "plan 40 / hard 60 / today 27" — the RE-TALLY row's "(sim_budget, seed-fixed journey dump)" attribution checks out (sim_budget's `budget_draws` leg :125-135 is the instrument). FX-E3's stale "27→27" and CT-E4's stale "27→28" now survive ONLY inside correction sentences quoting the REV-1 claim (:469, :862) — the drift class itself greps clean of live law. |
| **10. insight resolved (NF-10, P4)** | GENERIC = {ferocity,haste,ward,grip}; insight carries the requiem-toll chip; "?" deleted | **VERIFIED (content) — cite drift NF3-2** | §3.3 (:517-525) states the four-generics law and the PS-E5 consequence explicitly; the "?" is gone; PS-E5's law cell (:631) re-read — `chips == that partner set` ⇒ the resolution is the ONLY reading consistent with it. `insight` absent from evolutions.gd (grep-zero, re-run) and the union partnership byte-true — but at `union.gd:34`, not the spec's `:37` (§3.3 + fold ledger) → NF3-2. |
| **(extra) the fold's own correction of c2's :126-128** | spec-side true; c2 doc untouched | **VERIFIED** | `levelup.gd:125-128` read: :125 `static func apply_offer(…)` head, :126 `match card.kind:`, :127 `"weapon":`, :128 append — c2's LIMIT-arm cite did sit on apply_offer's head, the correction is byte-true; `docs/M6-SPEC-DA-c2.md` diff = 0 lines (immutable honoured). |

**Fold tally: 10/10 adopted rows VERIFIED as declared (row 10 content-true with a line-drift filed
below); the extra correction true; header counts re-derived from the tables themselves — §9 = 16
rows enumerated, ACCEPT = 5+7+6+3+2+4+4 = 31 real rows, each cell with seam + planted red.**

## 2. NEW findings (REV-3 new text only; P-ranked; every cite re-measured at 3bbfd57)

### NF3-1 — P4: the events-m4 byte-quote miscounts the array — "47 entries" is **45** (§9 :913, fold ledger :1146, LEDGER T-M6-SPEC3 row)

The §9 events row, under "BYTE EVIDENCE", prints `types:[47 entries]`; the REV-3 header says the
table was "re-derived THIS session from the FIXTURE BYTES themselves". The array at
`events-m4.jsonl:6` has **45** entries (json-parsed AND raw-split; and the digest's own
`alive:45` — one type per live enemy — corroborates). The number is c2's own miscount
(`M6-SPEC-DA-c2.md`:68 "47-entry") inherited WITHOUT re-measuring, while the same fold re-measured
other drifted cites (NF-4's two comment sites, NF-6's :126-128) — the fold held itself to the byte
everywhere except the number inside a quote it had already "seen". Verdict-NEUTRAL (RNG-dependence
is field-driven, not entry-count-driven; the EXPECTS-SHIFTS verdict stands on `level:2`+`phase`+
`rng_stream` alone). **Fix (wave-brief, one digit):** 47→45 at :913 and :1146 (the LEDGER row is
history — next row supersedes per the versioned-truth law).

### NF3-2 — P4: the insight partnership cite is `union.gd:34`, not `:37` (§3.3 :521, fold ledger :1155)

Both sites cite `union.gd:37 "passive": "insight"`; the requiem-toll row is at **:34**
(`"requiem-toll": {"a": "halo", "b": "spike", "passive": "insight"}`; :37 is a `}`). Content TRUE
(the law resolution does not move); same class + same cause as NF3-1 — c2's cite carried through
while its SIBLING cites in the same two rows were re-measured and did move. **Fix (one digit):**
:34 at both sites.

### NF3-3 — P4: two §10 matrix cells the fixes moved past (rows :948 and :950)

(a) T-M6d's content cell still calls the counter "the dedicated **non-boss** counter (§4.2 REV 2)"
— post-NF-5 the law is non-boss **and non-miniboss** (§4.2, §0 F-6, SD-E2 all moved; the NF-3 edit
landed in the same cell's file-list and left the label and its REV-2 tag stale). The §4.2 cite
resolves to the full law, so a build card still reads truth — a shorthand drift, not a fork.
(b) T-M6f's row still reads "EDITED UNDER SERIAL — owned first by **T-M6p/T-M6d**" (REV-2 text,
untouched) — post-NF-3, `weapons.gd` has ONE first-owner: T-M6d (T-M6p is an editor UNDER serial,
as T-M6p's newly-edited row now says in the row above); inside the table whose own law is "owned
and ordered read from ONE table", naming a non-owner is the NF-3 class in the opposite direction.
Ordering holds under BOTH readings (the §2.2/§3.5 T-M6p→T-M6f edge is declared independently), so
nothing executable breaks — nothing can read RED from either cell. **Fix (two half-cells,
wave-brief):** "non-boss/non-miniboss counter (§4.2 REV 2 + REV 3 NF-5)"; "owned first by T-M6d
(weapons.gd under the declared §3.5 chain via T-M6p's close)".

No P1/P2/P3 new findings. The brief's new-hunt subjects came back clean: the 16-row footer parse
and SD-E6 are consistent (the instrument keys on the deviation-doc's recorded status and the gate
sentence is conditional on actual shift — the AT-RISK class it must classify already existed in
REV-2 and c2 verified that shape; six AT-RISK rows change no mechanism); the cmp-decides protocol
is stated on every one of the six AT-RISK rows; the carve wording is consistent at all four sites
that state it; the RE-TALLY row's arithmetic (27→28→28/29, families, plan/hard ceilings) re-derives
against DESIGN-3D §b + D-6 with nothing left dangling.

## 3. What SURVIVED the c3 attack (stated, per the seat's law)

- **The §9 table is now the honest artifact c2 demanded.** Every channel verdict I re-derived from
  bytes myself agrees with the row; the two "cmp decides" rows name their uncertainty instead of
  papering it; the reaper row's "CERTAIN" claim is code-true (walk loops + every-tick decline).
  All 12 strict fixtures named; all 16 rows classed; the ask-text supersession law stated with its
  rule-2 reason.
- **The fold's arithmetic is honest and its extra self-correction is real:** the :126-128 correction
  byte-verified, and it did the thing c2 said REV-3 must do (re-measure, then fold) on both NF-4
  cites and NF-6 — the two inherited drifts above are the residue, not the pattern.
- **c1's gate mechanisms untouched:** option (a) + PS-E4 + the :148 replacement (the diff only
  ADDED the NF-4 clause inside §3.4's consequence (2); the predicate text and PS-E4 row are
  byte-identical); SD-E6 byte-identical; the §3.5/§2.2 serial edges still as verified; the §11
  exclusions still hold (the cap-family clause is quoted FROM them).
- **The matrix is one-table-readable again** at T-M6d/T-M6p (the NF-3 pair), with the two stale
  half-cells above filed; the side-tag universe check still passes (PS-E7's set contains no
  weapons.gd).

## 4. The owner package, as the GATE states it (so the orchestrator cannot misstate it)

- **Three OWNER-DECISION rows:** §1.5 (:369, the six statue-class statics — recommendation + priced
  alternative + the rig-yield law), §4.2 (:689, the CLEAR carve — bosses + minibosses + the reaper
  SURVIVE, recommendation; the counter eligibility RIDES THIS ONE ruling — "if the owner rules a
  class dies instead, BOTH terms move together"; no separate counter ask exists or may be
  manufactured), §8 (:864, version = v3.1.0, recommendation first).
- **Ratification-ask precondition:** the ask the owner is given MUST derive from the REV-3 §9 table
  and supersede every earlier draft (§9 :926-929). The honest premise: **5 SHIFTS-class channels**
  (journey-5020, carry-caps, chests-tiers; + chests-evolve REMINT; + strips RE-DERIVE) and **7
  AT-RISK channels** (unions, limit, endless, events, stages, reaper, gem-merge) of which endless/
  events/stages EXPECT SHIFTS on their own fixture bytes — NOT the retired "~4 SHIFTS, 5 STAY"
  premise, which the spec itself RETIRED as manufacturing consent.
- **Wave serialization law:** T-M6r ∥ T-M6c ∥ T-M6d may all OPEN in parallel (disjoint sets), but
  SD-E6 makes a filled owner-ratification footer a **pre-close precondition of every shifting card
  starting with T-M6d** — the wave's CLOSE therefore serializes on the owner's answers (intended,
  stated truthfully in the T-M6z row); T-M6p → T-M6f → T-M6z serial behind; T-M6z **VERIFIES** the
  footer (the all-channels battery), it does not fill it.

## 5. Dissent / residual risk

- NF3-1/NF3-2 are the "adopted fix whose own byte-quote drifted" class — the lesson to carry into
  the build cards: a quote copied from a prior cycle is a claim that must be re-measured, not
  evidence. Nothing in the gate depends on the two digits; nothing in the owner package does either.
- The "the three fixture-proven ones EXPECT SHIFTS" header parenthetical is true but terse — the
  unions row ALSO states "⇒ EXPECTS SHIFTS" (proven from `sim_union.gd:15`'s header, not from the
  fixture bytes). Read the header as "byte-proven: three", not "expects-shifts: exactly three".
- If the owner rules "kills everything" on §4.2, the counter carve moves with it in the same edit —
  the spec states the coupling, so a wave-brief must carry ONE ruling, not two asks.

# VERDICT: SHIP
