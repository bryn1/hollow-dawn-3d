# M5-SPEC-DA — Devil's-advocate gate, cycle 1 (MC 11406, T-M5d)

- **Target:** `docs/M5-SPEC.md` REV-1 @ `e58569f` (docs-only on top of the declared read-base
  `48f5b33` — `git diff --stat 48f5b33 e58569f` re-run THIS session: **one file, docs/M5-SPEC.md,
  zero product diffs**; every citation below is therefore judged at both SHAs identically and the
  base-vs-ship drift excuse does not exist).
- **Method:** every code/doc/fixture citation re-grepped THIS session at `e58569f` against the real
  tree (`godot/scripts/`, `godot/sim/`, `tests/`, `tools/`, `docs/`, `LEDGER.md`); the base-suite
  claim independently reproduced in my own worktree: **278 passed, PYTEST_RC=0 (157.93 s vs the
  spec's 157.24 s at 48f5b33)** — the green-base line VERIFIED, not quoted. All 24 ACCEPT rows
  attacked (P-E1..7, B-E1..9, K-E1..5, D-E1..3); the R1–R4 pin cites re-read VERBATIM at the cited
  lines; the SEL-A/B/C arithmetic re-derived per option (the SEL CHOICE itself is owner-pending and
  is NOT verdicted — the brief's law, and the spec's table prices all three honestly); a deliberate
  fold-collision pass over 16 clause pairs sharing the RNG/save/pixel/source-regex substrate (the
  M3-P1-1/M4-P1-1 class this gate caught twice before).
- **Prior art honoured:** M4 c1 P1-1 (a source-regex pin vs a mechanism change — the STAY list cited
  a range and the mechanism landed inside it) and P1-2 (a red that can never fire). Both classes
  recur in reduced form here (P2-1, P2-4); the mechanism-level P1 is a NEW class: the spec cites a
  runtime truth (pawn mesh read ONCE at ready) in its own Code-truth paragraph and then specifies a
  selection law that never reconciles with it.

## 0. Verdict summary

**FIX.** 1 × P1, 4 × P2, 3 × P3, 4 × P4. The milestone shape survives: F-1 is grounded (the owner
quote is real at `DESIGN-3D.md:4`; §a–§d executed, §h's rejections real), the version law applies
as claimed (`PARITY-ROADMAP.md:63-66` verbatim; two navigated surfaces; the `:336-338` ratification
promise verbatim), F-3's zero-world.gd proof HOLDS (no card file-set names it; the mechanism reads
`world.reaper_spawned` — real at `world.gd:216` — without growth), R1's pin cite is VERBATIM-EXACT
(`test_save.py:184-186` re-read), the counter arithmetic (20 = 4+3+3+2+3+2+1+1+1), the SEL table
arithmetic (5/2/8 new meshes; 10/7/13 GLBs) and the window estimates all re-derive true against the
LEDGER's own yield history (`T-M1c2: 4 meshes, 12 windows` — the quoted row, verbatim). But the
character/skin mesh law ships a feature that is half-dead in the primary in-session flow with no
ACCEPT row able to see it (P1-1), two ACCEPT rows cite instruments that cannot fire the reds they
name (P2-1, P2-4), one ACCEPT row's no-op leg contradicts the spec's own Σ-add table (P2-3), and
the roster-consumption law omits the repo's own aliasing precedent that guards the byte corpus
(P2-2). None is reconsideration material; all are same-document fixes. §6 names the edits.

## 1. Attack surface 1 — EXECUTABILITY, all 24 rows

Channels verified real (seam by seam): `achv_probe.gd` rides the `save_probe` throwaway-`user://`
pattern (the probe fixture at `test_save.py:148+` is the living shape) ✓; `sim_chars.gd` rides
`SimFunnel.fresh_run` — opts `wipe_wire_pick_flags_stage` all real (`sim_funnel.gd:30-49`), a
`char` key is an additive `opts.get` ✓; the `_player_mesh()` extension can keep the pinned literal
`ClassMesh.mesh_for("player.glb", HordeViz.MODEL_H_PLAYER)` inside the function body — the seam-pin
(`test_art_integration.py:152-162`) asserts a substring, extension is feasible verbatim ✓; every
B-E3 formula matches the shipped expression to the constant (140/haste 0.08/limit-spd 0.03;
1+0.1·ferocity+0.08·gall+0.04·limit.dmg; `maxf(0.0, raw−ward−rotten−1.0·arm)`;
`max_hp = MAX_HP + PowerUps.max_hp_bonus` + additive term — `game_state.gd:98-121,:152`); the
`gold = 0`→`Roster…gold_add` swap falsifies NO pin (no test greps `gold = 0` or the passives
literal — grep-zero run); `test_dawnwell_shop.py:139` stays green by substring-append; B-E5's gate
law + B-E9's cross-pillar id pin (`achv:kills-50k`, `achv:cycle-1` — both real rows of §1.1's table)
✓; K-E4's wear-check (skins only on row 0, group law §3.1) is constructible ✓; D-E1..3 ride the
shipped gate set (`validate_glb`, extent/fill/aspect, turntable-solid — the LEDGER §M1c2 blind-spot
law re-read) ✓. **The failures are four specific legs, filed as P1-1/P2-1/P2-3/P2-4 — rows attacked
24/24.**

## 2. Attack surface 2 — BYTE-ANCHOR TRUTH

- **R1 VERBATIM ✓:** `test_save.py:184-186` re-read literally —
  `assert set(disk) == {"version", "gold", "ranks", "flags", "best_cycle", "stage"}, "on-disk keys
  must be exactly the roadmap's four + best_cycle + stage"` — at :184-186 exactly as the retire row
  quotes; the comment at :181-183 narrates "REPLACED twice" exactly as §2.2/R1 claim. Three
  same-commit re-pins in series is the honest third/fourth move of the named lineage.
- **The corpus law classes match the post-MC-11317 reality:** 12 committed fixtures (count-matched
  file-for-file against `ls tests/fixtures/`); strips modulo `_ms`/`CAPDIR` = the C3 norm verbatim;
  s8 as A1 contract-checks (kind/hp-pin/monotonicity/t_sim/kills — the C3 row's own list), the
  s8 11-row count machine-checked (`grep -c 'row("' tools/s8_acceptance.py` = 11, A1..A8 + the
  T-M4r additive row); s8_capture's THREE DECLARED variants at :26/:32/:50 verbatim ✓; the journey
  "vs the committed records" claim RESOLVES — the 5020-row @11101 record is committed
  (`.tmp/hd3d-boss-s6-dump.jsonl`, tracked, named as the journey anchor in the T-C3 LEDGER row) —
  the class-1 wording survives contact with the tree.
- **The named STAY probes stay green by construction** (each re-derived, not waved): `test_endless
  .py:130-135` (start_run→endless regex, comments-only zone; hand-ins at the F-7 end-of-block
  position can't touch it), :123-127 (names endless/cycle only; `char_id = 0` joins the reset block
  freely), :138-148 R9 era (cap fork `main.gd:266-269` — no M5 card has a line there),
  `test_card_icons.py:138` (`== 32` is a POOL-kind pin, not an icon-dir listing — 11 new icon files
  cannot enter it), exact-12 (`snapshot_json:228-244`, char/skin outside, the `limit` precedent),
  `sim_stages.gd:98` delegator untouched, `DRAWS_PLANNED = 40` (:42). **One STAY cite is truncated
  exactly where the risk begins — P2-1.**
- **R2 carries a stale row count (P3-1)** and R3/R4 verify (`PX_MIN = 200` :44, rows dict :69-70;
  PERMANENCE §M4a precedent real). R-cites verified 4/4, one with a stale count.

## 3. Attack surface 3 — FOLD-COLLISION PASS (16 pairs run, 13 cleared, 3 findings)

Cleared (the pair ran, both clauses survive): counter block × journey RNG (run-end-only, int math,
dump stream never reads run end — `game.end_run(result)` lands at :356 and phase=="win" is
readable there ✓); roster stat terms × byte corpora (every row-0 term is the shipped
`+0.0/×1.0/−0.0` shape — the exact limit-break arms at :101/:114-121/:104-110 re-read, F-2 sound);
char_id reset × `test_endless:123-127`; hand-ins × the start-seam regexes AND the
`test_stages:318` seed_stage_props pin (membership, not adjacency) ✓; skins × frame-diff gates
(new `roster_capture` fixture; the S2r CSV stays byte-locked); SimFunnel opts growth × existing
callers (default-absent = row 0); char/skin save fields × the save law (`save.gd:5,:37` — the
file's OWN field-by-field-ADDED-no-bump law re-read verbatim; VERSION-1 no-bump is the shipped
`best_cycle`/`stage` precedent, and old-code-reads-new-save degrades safely because the loader is
keyed-field reads); menu +2 buttons × pixel gates (no menu pins exist; gate rows are overlay-scoped);
`test_run_behavior_untouched`'s `"DawnWell" not in MAIN.split("func _step")[1]` × the update block
(lowers to `_dawnwell`, and the stage-chain precedent at :374 proves the pattern green);
counters-dict × flags `{unlock_id:1}` law; evolutions/unions_seen × the two TABLE consts
(read-only, both `class_name`s real: `evolutions.gd:18/:27`, `union.gd:26/:33`); screens.gd growth
× 600 (watch row + crossing plan stated ✓); seeds-law × sim idiom; badges n=0 × the `icon_path`
`_:` catch-all (real at :69-72) + the T-M4a icons-n=0 precedent; win-counter phase read × call
order.

**Collisions that did NOT clear:** (a) the `_end_run` update-block placement vs the
`gold→_meta_changed` source-regex pin — P2-1; (b) roster TABLE rows handed into run state × the
multi-run-in-one-process dump idiom — P2-2; (c) the pawn's ready-time mesh read vs the per-run
selection law — P1-1 (a timing pair on the same file's substrate).

## 4. Attacks 4-6 — F-1 grounding, version law, estimate honesty

- **F-1 holds.** The owner's ruling is a literal artifact — `DESIGN-3D.md:4` carries the verbatim
  *"a 3d remake. Same type of viduals, top down…"* — and §h's rejections are real
  (skinned horde = Route B math; full 3D physics; heightmap terrain — re-read). A pivot would
  overturn a DA-gated design + the ruling with no owner artifact (Rule 2). The one crack is
  attribution: §h does NOT reject "perspective camera" — §a :19-20 does (ortho rig, "perspective
  rejected: v1 entities are size-pinned"). Substance stands; one bullet names the wrong section
  (P4-1). The designer is not reading convenience into the doc; he is citing it one section off.
- **Version law holds.** `PARITY-ROADMAP.md:63-66` verbatim: "major = a new player-navigated UI
  surface (M3 stage select → v2.0.0)… Stated so M3's major is a rule, not post-hoc." M5 ships two
  such surfaces (character screen — roadmap item 1's own "purchase screen"; achievements page —
  item 2's "page"); v2.1.0 → v3.0.0 is the law's verdict; the "law keys on the trigger, not the
  count" reading matches the law's grammar (one MAJOR per release regardless). The `:336-338`
  landing-note promise ("the release that lands that surface carries the SEL version decision to the
  owner") is verbatim real; the skin-chips-not-a-surface reading (F-8) is stated where a later
  reader would otherwise count it, and the menu gains exactly two buttons. The rejected
  "keep v2.x via a shop sub-section" refusal is the right post-hoc guard. **No severity.**
- **Estimates honest.** SEL-A 38-44 re-derives from the repo's OWN history: 10 meshes × ~3
  (T-M1c2's measured 4/12 — quoted verbatim from the LEDGER) + reserve 3 meshes + 11 icons in 1-2
  imagegen windows (T-M1c: 31 icons ONE window; T-M2a: 5 icons ONE window) ≈ 39; SEL-B 25-30 and
  SEL-C 46-54 reproduce identically at 7 and 13 meshes. The "~3/mesh" is CONSERVATIVE against the
  newer yields (T-M4a: 3 meshes, 3 TRELLIS windows first-seed) — the spec says so and reserves
  upward, never downward. GLB counts per option (10/7/13), roster arithmetic (SEL-B rows 0-2, SEL-C
  +3 gated rows whose gates `achv:level-25`/`runs-150`/`gold-10000` all exist in §1.1's table), the
  suite projections (~330/~345/~355 — consistent with 278 + fixed P/K/D additions + ~16/~25/~34
  char rows) and the screens.gd watch math (445+~130≈575 < 600) all re-derive. The SEL table is an
  honest price list, not a push toward A; the one citation nit is P4-2.
- **F-3's zero-world.gd proof HOLDS:** all five cards' file-sets re-read — no `world.gd`; the
  mechanism's only world touch is a READ of `reaper_spawned` (int, `world.gd:216`) from main.gd;
  chest-count achievements (the world-side-counter temptation) are NOT shipped and are named in the
  doc; the SCHEDULED-split header re-read verbatim; the CLEAN-CODE-AUDIT-2 §5 deferrals are
  re-declared, each NAMED (strips_capture 596 = 4 under the 600 hard fail — measured; sim_stages
  583 — measured; sim_events count stale — P3-2).

## 5. Findings register

| id | sev | one-liner | fix (one clause) |
|---|---|---|---|
| P1-1 | **P1** | **The selected mesh never reaches the pawn in-session; no ACCEPT row can see it.** The spec's OWN Code-truth line states it: `hero_pawn.gd:35` sets `mesh = _player_mesh()` **once at `_ready`**, and the pawn is instantiated once at boot (`main.gd:89`, never re-created per run — `_pawn` appears exactly at :32/:89-91). F-7 lands the char/skin hand-ins at the END of the `_start_game` block (`:318+`) — AFTER the pawn has already read its mesh. Implemented as written, buy+select+play shows the OLD mesh until a process restart (the stat terms read `game` live and are correct; the mesh is the dead half) — in the exact in-session flow the milestone sells (field-test history: players never restart between runs). B-E7 tests the SEAM function and the fixtures, not the pawn's lifecycle; K-E rows test verbs and the default-skin byte law. A second-order trap rides along: `_ready` also derives `_mat` from `mesh.surface_get_material(0)` — a naive per-run `mesh = _player_mesh()` re-read without the material block loses the `PLAYER_TINT`/unshaded law (`hero_pawn.gd:36-43,:50`), i.e. the fix needs an apply-step, not just a re-call. | §2.1/§2.4: the hand-in lines at the F-7 position gain `_pawn.apply_selection()` — one re-read of mesh AND the material block re-derived from the new surface (the §b multiplier convention kept); + one B-E7 twin-leg: after a run start with a planted selection, the pawn's live `mesh` equals the selected row's GLB (and row-0 twin equals the shipped mesh object path) — the observable the row currently cannot see. |
| P2-1 | **P2** | **Fold collision: the `_end_run` update-block placement vs the `gold→_meta_changed` adjacency pin.** §1.1 lands the block "BESIDE the stage-chain block (main.gd :372-376)" — but `test_dawnwell_shop.py:156-157` source-pins `_dawnwell.gold += game.stats.gold` → `\s*\n\s*` → `_meta_changed()` (WHITESPACE ONLY between; comments are not `\s`), and the persistence law forces the block ABOVE `_meta_changed()`. The literal readings "beside :376" — below (breaks P-E2's on-disk legs: funnel saves before the counters change) and between :374/:375 or :375/:376 (breaks the wiring pin — suite RED) both fail; the ONLY lawful landing is ABOVE the `gold +=` line, which the spec never says. Worse, §7.2's STAY row names `test_dawnwell_shop.py:136-155` — a range that ends exactly where the at-risk regex begins (:156-157 is outside the cited lines). | §1.1: "the block lands in the persistence region ABOVE `_dawnwell.gold += game.stats.gold`" (one sentence, e.g. after the best_cycle write); §7.2: extend the STAY cite to `test_dawnwell_shop.py:153-157` naming the gold→funnel adjacency regex. |
| P2-2 | **P2** | **Fold collision: roster TABLE rows into run state without the aliasing law.** F-5: "weapons row = `Roster.start_weapons(char_id)` (row 0 returns the literal talon row `:173` byte-for-byte)" — GDScript const containers are SHARED mutable references; the dump idiom runs up to 20 `fresh_run()`s per process (`sim_stages`) and runs mutate `weapons` in place (level-ups, evolutions); a returned table row makes run 2 inherit run 1's weapon state — every multi-run fixture forks. The repo named this trap once and pinned its fix: `game.meta_ranks = _dawnwell.ranks.duplicate()` with the comment "the duplicate keeps run state from aliasing the live shop dictionary" (`main.gd:300-301`, pinned verbatim at `test_dawnwell_shop.py:154-155`). Twice-cmp fixture generation does NOT catch it: both generations poison identically. B-E2's red (table-key drift) and B-E1 (single-run journey) both miss it. | F-5/§2.1: "start_weapons/start_passives hand the run a `duplicate()` of the table row — the meta_ranks law (`main.gd:301`) restated; equality pinned BY VALUE"; + one B-E2 leg: two `fresh_run()`s in one process start with byte-equal weapons rows. |
| P2-3 | **P2** | **P-E1's no-op leg contradicts its own Σ-add table.** "a zero-gold/zero-kill end changes NOTHING writable (no-op ⇒ no write — the shop law)" — but the §1.1 table increments `runs_total += 1` UNCONDITIONALLY (`minutes_total += floor(time/60)` too); no run-end exists that changes no counter, so the leg as written is deterministically RED against correct code on a disk-invariant read, and green-but-vacuous on a flags-only read. The shop's no-op law is a VERB law; the run end is not a no-op by construction. §1.1's own wording ("run end with zero counter/flag change writes nothing new") describes an unreachable state. | P-E1: replace the leg — "a run whose stats move only the Σ-add rows SETS no new flag and moves no max-rule counter; the Σ-add rows move by the EXACT delta and nothing else" (the disk-write itself is the shipped always-write funnel law, not this row's instrument). |
| P2-4 | **P2** | **P-E3 cites an instrument that cannot fire its named reds.** "the `test_save.py` marker-count pin (call count == 2 boot+funnel)" does not exist: test_save's marker pin is `len(markers) == 2` QUARANTINE markers (:219, unrelated); its funnel pin is `MAIN.count("_dawnwell.save()") == 1` (:133, MAIN-scoped); the per-end instrument is `test_stages.py:296` `end_run.count("_meta_changed()") == 1` (block-scoped). A planted direct `well.save()` **inside achievements.gd** fires NEITHER (wrong file scope); an update call from `_start_game` fires NEITHER (wrong block scope). Both reds can only fire on the row's own NEW "source pin beside the R1 re-pin" — whose scope the row never names. A fleet red-proven-law row shipped with a false-green instrument as cited. | P-E3: cite the real instruments (`test_save.py:133` + `test_stages.py:296`) and name the new pin's scope: a whole-`godot/scripts/` grep pin — zero `.save(` outside `save.gd`/`main._meta_changed`, and a `_meta_changed(` call-site count in main.gd pinned at its current set. |
| P3-1 | P3 | R2's forward-lock count is stale at base: `art-s2i-probe.jsonl` is **18 rows** at `48f5b33`/`e58569f` (T-M4r grew 17→18 per its LEDGER row); R2 says "15→17 rows since T-M4e/R4" and §7.1 says "prior 17 rows byte-preserved… grown twice already" — a card that pins "prior 17" under-protects the 18th (the-reaper) row; the M5 growth is the FOURTH growth since the 13-base era, not the third. | §7.1 class-1 + §7.2 R2: "18 rows since T-M4r; prior 18 byte-preserved; M5 grows the fourth time". |
| P3-2 | P3 | F-9/§6 carry the audit's stale `sim_events 533`; the file is **537** at the spec's own base. The spec updated world.gd (audit 548 → its 551) but not this one — the doc's own law: "the reason must state the truth, not stale". | §0 F-9 + §6 watch column: 533 → 537 (and re-measure all four carry numbers at c2). |
| P3-3 | P3 | Header Code-truth cites drift by 1-4 lines on six anchors despite "every claim re-grepped THIS session": `game.start_run() :301` → **:302**; `VERSION := 1 :26` → **:24**; `save() :79` → **:76**; "fields gold/ranks/flags/best_cycle/stage :29-46" → **:27-42**; overlays ":97-106" → **:98-107**; `start_run():144-185` overshoots `set_phase` (:182). All self-resolve within a few lines; none changes a mechanism. | Header: one re-grep pass at c2 (the author's own §5 checklist row demands it). |
| P4-1 | P4 | F-1/§9.1 attribute the perspective-camera rejection to §h; §h does not list it — §a :19-20 rejects it (ortho, "perspective rejected: v1 entities are size-pinned"). The rejection exists; the section citation is wrong. | §0 F-1: "(perspective: §a camera row; skinned horde / full-3D physics / heightmap: §h)". |
| P4-2 | P4 | §2.5 grounds windows on "T-S1p: player = 1 TRELLIS + 1 UniRig window first-seed"; the LEDGER T-S1p row records **ONE** bounded window (15:37→15:44) covering mesh+rig acceptance. The citation overcounts the history (the estimate stays conservative — it errs the safe way). | §2.5: quote the row as measured ("ONE window for mesh+rig first-seed"), keeping ~3/mesh as the reserved estimate. |
| P4-3 | P4 | B-E4's red column names "the B-E1 endless pattern's own red column" — this document's B-E1 is the byte-identity row; the intended reference is M4-SPEC's B-E1 (reaper default-flag-true red). Cross-milestone row-id collision reads as self-reference. | B-E4: "the M4-SPEC B-E1 endless-pattern red". |
| P4-4 | P4 | §6's doc-sync row moves roadmap gap rows 7/10 but not the roadmap's OWN M2 #4 feature row (`:238-240`), whose ACCEPT text ("fresh-save leg shows gated card ABSENT") is the pool-GATING half M5 explicitly does NOT ship — after v3.0.0, an un-swept reader finds the counter-store row looking shipped-or-stale. | T-M5z doc-sync list: add roadmap `:238-240` — "counter+flag store LANDED-M5 (named); pool-gating NOT LANDED, tracked as the §9.2 follow-on", replace-not-delete. |

**Counts: P1 = 1, P2 = 4, P3 = 3, P4 = 4.**

## 6. What survived the attack (for the record)

The green base (278 passed reproduced HERE, RC=0); R1 verbatim; the three byte-anchor classes and
the committed journey record; F-3's zero-world.gd file-set proof AND its mechanism honesty (the
20 rows are each computable at the one funnel from `game.stats`/`game.weapons`/`game.cycle`/
`world.reaper_spawned` — every input re-verified to exist); F-8/F-6's one-funnel purchase law and
no-op-no-write (the shop regexes survive additive lines by construction); the version law and both
owner lines (ratification quote real); the SEL table's arithmetic and the honesty of NOT choosing;
F-2's IEEE-identity carve (the exact shipped limit-arm shapes); F-7's start-seam placement law; the
R3 pixel rows (floor 200, baseline idiom, `capture_lib` the ONE launcher — real, C1 row); the
retired-pin ledger discipline (three dated R1 moves, equal-or-stronger legs named); the wave map
(one serial spine, every pairwise edge true against the file columns; T-M5a the only parallel row;
the SEL-C split clause); the GitHub-Release trio + LEDGER-row laws on T-M5z; the clean-room posture
(every "their" cite resolves: S6 :477-483 verbatim incl. the +10%-additive quote, S7 :613-624,
roadmap items 1/2/4 verbatim — and every OUR number pinned by OUR suite as claimed); §9's exclusions
each carry a reason, and the §10 tail's six preempted attacks all survive re-attack — the
counter-store IS run-end observable, the overlays ARE two, the badges ARE reuse.

## 7. Strongest finding, one line

The spec hand-in-laws its selection AFTER `start_run` while its own Code-truth paragraph quotes the
pawn reading its mesh ONCE at boot — so the shipped release buys a character and the hero does not
change until the game restarts, and every mesh row still goes green (P1-1); with the two
false-instrument rows (P2-1, P2-4) and the aliasing omission (P2-2), the four findings share one
root: the laws were read from source, the RUNTIME TIMELINE was not.

## 8. Reading-of-ambiguity statement

Per the brief, the SEL-A/B/C choice is owner-pending and I do NOT verdict it — I verified the
table's arithmetic and the mechanism's option-independence (the F-2 carve, the DATA-table shape and
the "pin reads the ruling's number at card time" clause make B/C shrink-and-grow lawful: confirmed —
no mechanism clause references a roster length except through the option-pinned rows). "BESIDE the
stage-chain block" is read as an ambiguous placement (not as the safe landing) precisely because
two of its three literal readings fail — that is P2-1, not a charitable reading. "row 0 returns the
literal `:173` row" is read as value-equality intent with an unspecified object law — that is P2-2.
The 24-row count matches the spec exactly (7+9+5+3); the brief's arithmetic claims about my brief I
followed as written; the journey-anchor question resolved in the spec's favour (the 5020-row record
IS committed). Base-suite timing differs from the author's run by 0.7 s (host load) — stated, not a
finding.

## 9. Fix list for cycle 2 (exact sections)

1. **§2.1/§2.4 + B-E7** — P1-1: pawn selection apply-step at the F-7 hand-in (mesh + material
   re-derivation) + the pawn-lifecycle twin-leg.
2. **§1.1 + §7.2 STAY list** — P2-1: above-the-gold-line landing sentence + STAY cite :153-157.
3. **§0 F-5 + §2.1 + B-E2** — P2-2: duplicate() law restated + the second-run alias-guard leg.
4. **§1.3 P-E1** — P2-3: rewrite the no-op leg to the zero-DIFF shape.
5. **§1.3 P-E3** — P2-4: real instrument cites + name the new pin's whole-scripts scope.
6. **§7.1/§7.2 R2; §0 F-9/§6; header** — P3-1..P3-3: the 18-row count, 537, the six drifted cites.
7. **§0 F-1; §2.5; B-E4; §6 T-M5z row** — P4-1..P4-4: section attribution, the T-S1p quote, the
   M4 cross-reference, the roadmap M2 #4 doc-sync clause.

Rows 1-5 (the P1 + the four P2s) are the gate; after they land as declared lines, c2 can SHIP on
re-check.

# VERDICT: FIX
