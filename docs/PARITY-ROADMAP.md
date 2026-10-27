# PARITY-ROADMAP — hollow-dawn-3d vs Vampire Survivors (MC 11196, T-S17)

- Authored 2026-10-23 by the `design` profile. Inputs read this session: `docs/VS-FEATURES.md`
  (MC 11195 inventory), `LEDGER.md`, `docs/DESIGN-3D.md`, `godot/scripts/` (render.gd BIOMES,
  world.gd ENEMY_TYPES, weapons.gd META, levelup.gd PASSIVES, game_state.gd), `tools/` gates.
- **REV 3, 2026-10-23, after DA cycle 2** (`docs/PARITY-ROADMAP-DA-c2.md` @ d2897da, MC 11203
  — immutable): adoption audited 7/7 and the rev-2 REBUTTAL **UPHELD** (c2 PASS 2: c1
  EVIDENCE-ERROR, both-pins-true, DA re-ran the greps + pytest 58 green itself). The 3 c2 P2s
  land as exact edits (N-1 → feature 7 WEAPON-side icon-suite bullet; N-2 → §2 loadout
  construction channel; N-3 → feature 3 passive clause mirrored to the weapon clause) and the
  3 c2 P3s fold (N-4 write-path atomicity, N-5 re-estimate note, N-6 loadout wording); no
  decomposition change.
- **REV 2, 2026-10-23, after DA cycle 1** (verdict FIX: `docs/PARITY-ROADMAP-DA.md` @ 000ba42,
  MC 11202 — that DA doc stays immutable). The ranked 7-edit fix list is folded in: P1 carry-cap
  + canonical worst-case loadout; suite-pin names/locations corrected (re-verified against tests/
  this session); draw plan 33→40 declared as a divergence with its retirement row; vague
  acceptance rows tightened (pixel floors, named shot paths, pinned constants, named
  observables); spine doc-sync row; persistence as its own M1 work-package, M1 re-sized to
  12–14 seat-days; M4 asset count corrected; one DA row rebutted with evidence (footer, and
  flagged in the cycle-2 RESULT).
- **STANDING CONSTRAINT (honesty rule, binding on every card this roadmap spawns):** the VS
  numbers are THEIRS. Parity means equivalent SYSTEMS with our own content and numbers —
  never copied values, never copied assets, never their flavor text. The VS-FEATURES.md
  inventory is a clean-room feature reference (public wiki text only, MC 11195); every table
  we build gets OUR numbers, pinned by OUR suite. "Archetype" below = a behavior class, not
  a clone target.
- Length note (>~300 lines, stated why): the DoD names this ONE path for one subject (the
  parity roadmap); splitting would defeat the pointable artifact.
- Code-truth notes: brief said "6 passives" — the tree ships **5** (`levelup.gd:8-14`);
  brief said 4 biome bands — confirmed (`render.gd:66-75`); gems/coins/Dawnlight exist in the
  sim but have **no 3D draw path** yet (only `world.gd` references them) — the in-flight
  visibility card owns that row.

## 1. GAP TABLE (current vs VS; VS column cites VS-FEATURES.md rows)

| # | Family | CURRENT (code truth) | VS (cite: VS-FEATURES section ~line) | Roadmap parity target (our system, our numbers) |
|---|--------|----------------------|--------------------------------------|--------------------------------------------------|
| 1 | Weapons: count + behavior | 16 (`weapons.gd IDS:19` — roster wired by T-M1h; 6 until v1.1.1), one behavior each, MAX_LEVEL 8 (`:22`), flat `META` table, `_fire` match | 273 total = 138 base + 94 evo + 7 unions + 4 gifts + 19 counterparts + 11 special (S1 tables ~19–304; tally ~710–712); base max lvl mostly 8 (S1 intro ~15) | 16 by M1, 24 by M2, 26+ by M4 — count is NOT the parity metric; behavior-class coverage + level/pool mechanics are. Their 273 incl. DLC is not a cloning target. LANDED-M1h: 16 (M2's +8 rides the deferred roster-expansion card, M2-SPEC §8.5) |
| 2 | Evolutions + unions | evolutions LIVE + pool-reachable (`evolutions.gd` 10-row TABLE, T-M1e + T-M1h) + 2 UNIONS (`union.gd:33` TABLE, T-M2u); chest-open precedence union→evolution | max weapon + carried passive + chest after 10:00 converts (S3 ~354–358); unions = 2 maxed weapons (S1.3 ~266–276); transforms inventory parse: 29 base + 64 DLC = 93 combos (S3 ~367) | M1: chest-driven evolutions (our rule, our time gate); M2: 2 unions — LANDED both |
| 3 | Passives | 15 × 5 stacks (`levelup.gd:10` PASSIVES, T-M1h), carry cap 6 KINDS + 6 weapon slots | 33 total (S2 ~309–311); max 6 different carried per run (S2 ~313) | 15 by M1 (one per evolution partner), 20 by M2; **M1 carry cap = 6 passive KINDS + 6 weapon slots, OUR numbers — M1 feature 3 (DA c1 P1)**; VS weapon-slot rule absent from VS-FEATURES (inventory gap — re-verify before citing any number of theirs). LANDED-M1h: 15 (M2's +5 deferred with the roster expansion) |
| 4 | Stages + gimmicks | **3 SELECTABLE STAGES LANDED-M3** (T-M3s): `STAGES` table `render.gd:110` (old pin :104, re-grepped at the v2.1.0 cut — the M4 `events` column grew above it) BELOW `biome_at` (slice law), ONE band mechanism `band_at:188` (old pin :169) per-stage lists (stage 1 = the shipped BIOMES:68 rows, byte-anchored); gimmicks: stage 2 drowned-cairns = two ember chests at FIXED coords through the ONE collect funnel (zero RNG), stage 3 pressure-plates = spawn surge ×1.5 INSIDE the untouched `minf(12.0)` clamp + band flare +150 s NAMES-only 30 s decay; **M4 LANDED: the `events` column (T-M4e) — stages 2/3 each carry ONE event window [660,720) with a fixed cone + ×2 surge INSIDE the same ceilings, stage 1 `events: []` byte-law**; stage-select = the FIFTH overlay (`screens.gd show_stages:381`) | 25 stages, each time-limited (15–30 min) with gimmicks: stage items, traps, boss (S4 table ~382–409; Reaper at limit ~378) | M3: 3 selectable stages via a stage table riding the band mechanism; 1 cheap gimmick per stage from existing mechanisms — **LANDED-M3** (3/3 + one gimmick each; cairns shipped as ember-tier stage-item chests, M3-SPEC rev-3 §1.2 reading; their further stages ride M4+ — mechanism now exists; event waves LANDED-M4 on stages 2/3) |
| 5 | End-bosses + minibosses | **3 end-bosses, ONE per stage, LANDED-M3** (T-M3b): all @540 of THEIR stage through the unified schedule latch — warden (hp 3000, `BOSS_AT world.gd:8`) + cathedral-choir 4200 + ossuary-warden 5600 (`ENEMY_TYPES world.gd:156-157` — old pin :123-124, re-grepped at the v2.1.0 cut), own meshes T-M3a, per-stage name bar keyed off the row); keyed chest drops `CHEST_TIER_BY_SOURCE[String(enemy.type)] world.gd:494` (old pin :365; choir→warden II, ossuary→dawn III); + 2 stage-1 minibosses @600/780 (`MINIBOSS_AT world.gd:12`, own meshes since T-M1g) + **2 event minibosses LANDED-M4** (T-M4e: sunken-prelate @660 stage 2 / stair-acolyte @660 stage 3, `ENEMY_TYPES world.gd:150-151`, own meshes T-M4a, riding the ONE schedule latch + the `miniboss` drop literal — map stays 7 rows, M4-SPEC F-3) | end-of-stage bosses per stage (S5 table ~427–439) + 72 named wave bosses (S5 ~441–457); boss chest-drop rule (S5 ~419) | M1: 2 minibosses; M2: +2; M3: 1 end-boss per stage; event swarm waves M2+. **M3 LANDED: 1 end-boss per stage (3 total incl. the warden)** + the boss chest-drop rule LANDED keyed; **M4 LANDED (2026-10-26, v2.1.0): the +2 event miniboss classes shipped with the event-wave pillar (T-M4a/T-M4e) — the deferred M2/M3 event-wave row retires HERE as this LANDED cell** |
| 6 | Endless mode | ENDLESS LIVE (T-M2e): `cycle = time // WIN_TIME` (`game_state.gd:7` WIN_TIME 900), flag `DawnWell.flags["endless"]`, capped scalars `HP_CYC`/`QTY_CYC`/`DMG_CYC` + clamps (`world.gd`, `main.gd:20` `MAX_CONTACT_DMG` — old pin :18, re-grepped at the v2.1.0 cut), best_cycle save row + **reaper night flag LANDED-M4** (T-M4r: hidden `flags["reaper"]`, endless keeps precedence; THE REAPER arrives at the limit + one per `REAPER_PERIOD world.gd:112`, contact ENDS the run — the F-6 end law, no damage path) | cycles restart waves with per-cycle HP/qty/damage scaling; Reaper only in non-Endless (S5 ~465–471); Limit Break beyond max (S5 ~473) | M2: endless with OUR scaling curve — LANDED; **M4 LANDED (2026-10-26, v2.1.0): limit-break-lite (T-M4l: three repeatable fallback stat cards at the ONE offer funnel) + the Reaper night flag (T-M4r) — the deferred M2 Reaper row retires HERE as this LANDED cell** |
| 7 | Characters + unlocks | 1 fixed character, talon start (`game_state.gd:173` — old pins :56, :139; re-grepped at the v2.1.0 cut) | 165 (S6 ~481; roster CONTRADICTED at 168 — treat count as ~165); gold-purchase with additive price scaling; secret unlocks (S6 ~481–483) | M4: 6 selectable, each start-weapon + one signature stat rule; purchase price curve OURS |
| 8 | Meta shop + refund | LIVE (T-M1f): `DawnWell` save (`save.gd`, `user://dawnwell.json`) + the shop panel (`screens.gd`, fourth overlay, one style); 24 power-up rows (12 live effects, 12 sealed pending the M2 probe — T-M1h STAT-ROW count), per-rank refunds + refund-all, run gold → well gold at every run end | 24/25 PowerUps table (S7 ~573–605; count CONTRADICTED 24-vs-25); refund-all rule (S7 ~609); disable-when-maxed rule (S7 ~610) | M1: meta shop (12 power-ups M1 → ~18 M2, our ranks/prices) + refund — LANDED (24 rows shipped, 12 sealed); persist via `user://dawnwell.json` — LANDED |
| 9 | Pickup systems | pickups DRAW via `pickup_viz` MultiMeshes (T-S18); chests in 3 tiers stamped at drop from `CHEST_TIER_BY_SOURCE` (`world.gd:76` — **7 rows since M3: miniboss/warden/endless-cycle/event + stage-item cairns + cathedral-choir + ossuary-warden**, drop site keyed `world.gd:365`, T-M2t→T-M3b) + gem-merge cap 200/batch 100 (`world.gd:29-30`, T-M2g, bulk gem same array); coin-bag tiers NOT shipped | chests w/ tiers + fixed first-6 sequence (S8 ~651–656); 400-gem merge-to-red rule (S8 ~644); Coin Bag / Rich Coin Bag + light-source pickups (S8 ~649, S7 ~628) | M1: chests (single tier); M2: 3 tiers + gem-merge cap (ours) — LANDED both (ours: 200-threshold, weighted rolls, NOT their fixed 1-1-3-1-1-5); coin-bag tiers DEFERRED (M2-SPEC §8.1) |
| 10 | Achievement-chain unlocks | **stage-chain unlocks LIVE (M3)**: reach level 10 in stage 1 → stage 2, level 14 in stage 2 → stage 3 — SET-only through the ONE `_meta_changed` funnel, disk-persisted well flags (`main.gd:373-376` — old pin :333-337, re-grepped at the v2.1.0 cut; the M4 reaper fork rides the same flag channel, `main.gd:246-249` cap branch), `save.gd` flags rows; A-E5 legs). Pool-gating counters + achievements PAGE still not shipped | passives/weapons/stages gated by achievement chains (S7 ~617–624: e.g. "Level up X to lvl 4" → passive; stage unlock = reach lvl N in previous stage ~624) | M2: unlock-flag store gating the level-up pool (NOT LANDED — named follow-on); M3: stage-chain unlock — **LANDED-M3** (their stage-chain row, OUR levels); M4: achievements page (~20 rows) — NOT LANDED, deferred out of v2.1.0 named+tracked (M4-SPEC §6, `T-M4p-ACHIEVEMENTS`) |
| 11 | Co-op | none | local co-op up to 4; changes pooling/shared chests (S8 ~671–674) | EXCLUDED — see §3 |
| 12 | Mobile | none (desktop/web builds) | official mobile releases exist; control details UNVERIFIED (S8 ~676–678) | EXCLUDED (revisit on owner word) — see §3 |
| 13 | Cloud save | none; no leaderboard server exists in this repo — the former "rides the v1 server" wording was a CONTRADICTED claim, retired at MC 11398 §4.1 / MC 11401 (zero commits ever touched `server/`, measured) | "Steam Cloud" listed as platform category; internals UNVERIFIED (S8 ~680–682) | EXCLUDED — platform service, see §3 |

## 2. PHASED PLAN — M1..M4, each phase a SHIPPABLE release

Release spine for every phase (unchanged fleet process): version bump + release-notes line,
web double-export + win export RC=0, VM120 field test (session-1 screenshot), playwright
0 console errors, `gh release create` with both zips + digests (S9/S11 LEDGER rows are the
pattern). **Doc-sync row in the spine (DA c1 §5-2, retired-claim doctrine):** every deliberate
divergence rewrites the docs it falsifies IN THE SAME RELEASE COMMIT — v1.2.0 rewrites
README.md:12–14 ("same … numbers as v1 … 10-minute win") and the DESIGN-3D §b/§d notes it
breaks; the close's grep for the retired claim must return zero. Suite posture: the
v1-verbatim pin era ENDS at the first deliberate divergence — the same commit that changes a
pinned number RETIRES its test row and adds the new pin — never leave a RED row; M1's exact
retire-and-replace list is named in M1 feature 7. **Version convention (DA c1 F-1):** major =
a new player-navigated UI surface (M3 stage select → v2.0.0); new subsystems and changed run
numbers ride minor (M1 → v1.2.0, M2 → v1.3.0, M4 → v2.1.0). Stated so M3's major is a rule,
not post-hoc.

Engine budgets, standing for all phases. **Draw plan 33→40 declared as a deliberate
divergence (DA c1 E-2c/C-1):** DESIGN-3D §b pins planned-33 and
`tests/test_art_integration.py:42,144` asserts it — the M1 commit that raises the plan to 40
RETIRES and REPLACES that row (same commit, plus the §b note rewrite via the spine doc-sync
row). Hard cap stays **60**; re-tally via the art-probe fixture per phase. **Canonical
WORST-CASE LOADOUT:** every budget acceptance line (≤ 40 planned, ≤ 60 total, 400-alive) is
computed against one NAMED loadout, never whatever a verifier's sim leg happened to own —
six weapon slots (feature 3) filled by the class-covering set (activates the zone MM; every
weapon-FX class live; fixture re-tally is the gate — c2 N-6), all at L8/evolved: Red Wail,
Thousand Darts, Rot Spiral, Judgement Cross, Eternal Matins, The Sluice, with evolution
partners Cracked Heart / Iron Wrap / Tall Candles / Four-Leaf Charm / Knotted Chain /
Loadstone carried (6/6 passive kinds). **Construction channel (c2 N-2): the loadout is a
DECLARED-PIN scripted leg** — pinned into `game.weapons`/`game.passives` via the existing
`sim_boss.gd:215` pattern (`run.game.weapons = build # DECLARED pin (SimCombat pattern)`),
zero new mechanism; PLAY-reachability of the full evolved set by 900 s is explicitly NOT
claimed (≈ 30 level-up picks available vs ≈ 54 needed, and ≤ ~3 chest rolls available vs 6
evolutions). The PLAYED cap-curve (what a real policy run actually owns at the caps) is a
SEPARATE acceptance row: the M1 sim-policy leg dumps its owned-set rows and the offer-gating
legs (feature 3) cover it — budget legs do not double as play-reachability claims.
Expected draw under the pinned loadout ≈ 37–40 (§b 33 + 2 miniboss
class MMs + zone/chest FX ≈ 2–3; DA c1 C-1's own re-tally) ≤ 60. Horde cap **400 alive**
(new hard rule M1: spawns pause at the cap in the single spawn loop `world.gd:83-92`; our
analogue of their 300-alive pause S5 ~422, OUR number); a verifier leg with fewer owned
weapons gets NO budget credit (DA c1 A-1). Sim legs stay seed-pinned headless runs.
**Web-rAF honesty (DA c1 C-2):** playwright rAF is measured in the 10 s boot window only
(24.5/20.4 fps llvmpipe declared floor); endgame frame-time under the worst-case loadout is
proven ONLY by the real-clock sim tick-rate rows (s8 pattern) plus a named per-frame draw
re-tally row — no rAF claim is made for endgame.

### M1 — v1.2.0 "Evolutions & Dawn Well" (~12–14 seat-days; re-sized after DA c1 A-2 — persistence is a NEW subsystem and the ledger's card granularity says 12–14, not 10; c2 N-5: honest at the edge, the M1 parent RE-ESTIMATES after the W-P persistence card closes)

Prereq (in flight, not counted here): gold/XP pickup visibility fix + S12 playtest verdict
(visible gold/XP, readable upgrade cards) — §4; DA c1 E-3 flags S12 has no repo trace, the
orchestrator confirms the card on the board before M1 build cards are filed.

1. **W-P persistence — the Dawn Well save subsystem (NEW subsystem, own work package; DA c1
   A-2: grep `user://` across godot/ = ZERO hits, none exists).** File `user://dawnwell.json`,
   format `{version:int, gold:int, ranks:{powerup_id:rank}, flags:{unlock_id:1}}`. Reset/
   recovery rules (all observables, no "fails loudly"): missing file → fresh defaults;
   undecodable → rename to `dawnwell.corrupt.json`, start with defaults, print
   `SAVE_LOAD_FAIL path=...` to stderr (the pytest leg asserts BOTH the rename and the
   stderr marker — planted-red both sides); `version` newer than code knows → refuse load,
   same quarantine path; a save from an older version migrates field-by-field (new fields
   default). **Write path (c2 N-4):** every rank/gold/refund mutation writes via
   temp-file + rename (atomic — a torn write cannot land mid-save; a corrupt file can only
   come from outside), and delete-while-running is UNDEFINED BY DESIGN: the in-memory state
   re-creates the file at the next mutation (stated, not a bug). Meta ranks are consumed at
   `start_run()` (`game_state.gd:44-59`) so snapshot
   `maxHp`/`xpNext` legitimately shift with bought ranks (stated, contract-visible but
   field-compatible). ACCEPT: pytest pin of the format keys + reset-rule table; planted
   corrupt/quasi-future-version save fixtures (RED+green pairs); quarantine-file existence
   assertion in the leg output.
2. **Meta shop "Dawn Well" + refund.** 12-power-up table (our names/ranks/prices; effect
   stats ours) bought with run-gold; refund-all button (their refund semantics S7 ~609;
   OUR fee pinned as a table row — `REFUND_FEE_PCT := 5` (floor division), governed by the
   same pytest regex-pin as the table, not prose). **M1's power-up effects are restricted to
   snapshot-EXPOSED stats (maxHp, xpNext, gold-rate via gold/kills rows) (DA c1 B-5);**
   speed/area/cooldown/luck-class powerups are deferred to M2 and proven by named
   `HD3D_OUT` dump-probe rows, never by the 12-field Contract-B snapshot. ACCEPT: pytest
   regex-pin of the power-up table incl. REFUND_FEE_PCT; persistence+shop leg — run ends,
   gold persists, buy rank, next run's `start_run()` applies it: per power-up dump-probe row
   `dawnwell.<id>.rank` and matching snapshot row (`maxHp == 100 + Σ maxHp-ranks*10`,
   `xpNext == xp_need(level)` unchanged where applicable) — exact named checks, not "+stat";
   refund leg asserts gold returned == Σ spent floor × (1 − REFUND_FEE_PCT/100); shop UI leg
   under Xvfb, shot path `assets/screens/m1-dawnwell.png`, shop-panel crop non-bg pixels
   **≥ 200** vs a hidden-UI empty baseline (S8 HUD pixel-floor pattern; DA c1 B-1);
   planted-red: hand-corrupt the save → quarantine leg rows go RED/GREEN as named above.
3. **Carry caps (DA c1 P1/A-1 — without these the budget rows are unbounded and unverifiable;
   OUR numbers, named rule):** **6 weapon slots + 6 passive KINDS** (existing 5-stack cap
   per passive kind unchanged). Pool consequence: `build_pool` (`levelup.gd:32-66`, old pin :17-36; v2.1.0-cut re-grep; the one
   pool source) drops NEW-weapon offers when 6 slots are full (owned-weapon upgrades stay
   offerable), and identically **drops NEW passive KIND offers when 6 distinct KINDS are
   already carried — carried-kind upgrades stay offerable up to the 5-stack cap** (c2 N-3
   wording fix: the old "drops once it is the 6th" phrasing off-by-one'd the cap to 5);
   evolutions replace in-slot, never add a 7th. Honest inventory note: VS-FEATURES carries ONLY the
   6-passive rule (:313); their weapon-slot count is an **inventory gap** — do NOT invent
   their number; 6/6 is OUR rule, re-verify the slot rule publicly before the gap table ever
   cites it as theirs. ACCEPT both sides: full-slots leg — scripted policy owns 6 weapons,
   100 dumped offers contain ZERO kind:"weapon" rows (RED if pool leaks); <6 leg — new-weapon
   offers present; same both-sides pair for passive kinds; the §2 WORST-CASE LOADOUT sim leg
   runs under exactly this cap.
4. **Run length + bosses.** WIN 600→900 s (BOTH suite pins retired+replaced — feature 7);
   2 minibosses @ t=600, 780 (static meshes + Route-A gait per DESIGN §c — no new UniRig
   runs); horde cap 400 rule. ACCEPT: sim_s8-style real-clock legs at the new WIN; max-alive
   row ≤ 400 in the 900 s dump **under the WORST-CASE LOADOUT policy**; chest-drop rate
   pinned as named consts in the `world.gd` HEAL_DROP_CHANCE pattern: `CHEST_CHANCE_BOSS :=
   1.0` (guaranteed, S5 ~419 shape ref), `CHEST_CHANCE_MINIBOSS := 0.6`, pytest-pinned +
   kill-leg roll rows (DA c1 B-3).
5. **Chests + evolutions.** Chest pickup from boss/miniboss kills; opening pauses and grants
   a reward card (level-up fallback = gold, ours). Phase decision stated (DA c1 A-2): chest
   opening reuses the frozen `levelup` pause phase (menu|playing|levelup|gameover|win stays
   the enum; Contract B untouched). Evolution rule (our gate values): weapon MAX + partner
   passive carried (any rank) + chest opened at t ≥ 600 → replace base with evolved, reset
   its cooldown. **Gate provenance (DA c1 G-1): 600 is OUR value — it is our own v1
   WIN_TIME; their page also says 10:00 — coincidence stated so no later reading mistakes
   it for a copied number.** ACCEPT: `sim_evolve.gd` scripted leg (owns L-max weapon +
   partner → chest after gate → evolved id in `game.weapons`, base removed, slot count
   unchanged); planted-red chest at t < gate must NOT evolve; evolution table pytest pin;
   chest-open shot `assets/screens/m1-chest.png` non-bg pixels ≥ 200 vs empty baseline.
6. **10 new weapons** (names ours; archetype = behavior class; mechanism = reuse):

   | ours | archetype (S1 row) | behavior (ours) | reuses | partner passive (new) → evolution |
   |---|---|---|---|---|
   | Bone Whip | Whip (S1 ~23) | piercing line ahead | `_hit` line area | Cracked Heart (+max hp) → Red Wail |
   | Dart Loop | Knife (S1 ~25) | rapid faced shots | bolts, faced | Iron Wrap (+proj speed) → Thousand Darts |
   | Hewn Axe | Axe (S1 ~26) | heavy piercing throw | throws + pierce | Tall Candles (+area) → Rot Spiral |
   | Pilgrim Cross | Cross (S1 ~27) | boomerang return-throw | throws + return phase | Four-Leaf Charm (+luck) → Judgement Cross |
   | Censer of Hours | King Bible (S1 ~28) | cross-pattern orbit volley | orbit (halo) | Knotted Chain (+duration) → Eternal Matins |
   | Rot Water | Santa Water (S1 ~31) | lingering tick zones at feet | NEW zones list (the ONE new mechanism; reused M2+) | Loadstone (+pickup r) → The Sluice (follow zones) |
   | Spectral Disc | Runetracer (S1 ~32) | edge-bouncing piercer | bolts + bounce | Rotten Plate (+armor/retaliate) → Grave Orbit (explode on bounce) |
   | Storm Peal | Lightning Ring (S1 ~33) | strikes at random foes | burst targeting, random | Twin Runes (+projectiles) → Rolling Thunder (double strike) |
   | Fire Lash | Fire Wand (S1 ~29) | heavy bolt, random target | bolts, random | Gall Vial (+damage) → Inferno Lash (pierce) |
   | Doom Sigil | Pentagram (S1 ~34) | rare screen-clear blast | `_hit` full-screen, long cd | Gilded Skull (+xp) → Pale Moon (blast + gem rain) |

   ACCEPT: per weapon — sim leg owns it + kill attribution row (per-weapon-kills pattern from
   S4); `_hit` remains the SINGLE damage entry; FX draws re-tallied ≤ cap under the
   WORST-CASE LOADOUT (new: zones MM +1, chest MM +1 → planned 40, declared above); 16 weapon
   icons visible on cards (screens leg, no-blank rule stays); planted-red per new behavior
   (cooldown never reaches fire → leg goes RED).

   T-M1h landing note (MC 11220 dispatch, NO-NEW-VIZ-MECHANISM ruling; the two cells whose
   "reuses" column implied new machinery LANDED MAPPED, declared in the M1h capture's mapping
   table): Rot Water rides the ward ring-tick class (rings FX + ticked `_hit` at the feet —
   the zones list stays deferred, the plan-40 +1 reserve stays unconsumed); Censer of Hours
   rides the bolts class as a rotating cross volley (the `halos` array has ONE writer by
   design — a second clearing/refilling writer beside `halo` would fight — and the §i
   HALO_MAX ≤ 4 row stays byte-true). Every other table cell landed verbatim.
7. **10 partner passives** (15 total; each a stat row on GameState, our values) **and the M1
   retire-and-replace suite list** (all rows retired AND replaced in the same commit —
   locations re-grepped this session, see REBUTTAL):
   - `tests/test_game_numbers.py::test_win_threshold_600` (:39) → new-value pin (900)
   - `tests/test_biome_numbers.py::test_win_time_600` (:65) → new-value pin (900)
   - `tests/test_biome_numbers.py::test_six_weapon_ids_and_meta` (:226, verbatim 6-IDS regex +
     META name order) → 16-weapon IDS + META pin (REPLACE, not add)
   - `tests/test_card_icons.py` WEAPON-side pins (c2 N-1): static `WEAPON_KEYS` 6-ID list
     (:29), `meta_icons()` table equality `sorted(table) == sorted(WEAPON_KEYS)` (:76), and
     the pool-count pin `assert len(rows) == 12` (:124) → 16-weapon keys, 16+15+1=32-kind
     count, + 10 new weapon-icon provenance rows (REPLACE — same RED class as the PASSIVES
     bullet below; the first M1 weapon-icon commit breaks all three otherwise)
   - `tests/test_card_icons.py` PASSIVES↔PASSIVE_ICONS key-set pins (:81, :111, "both orders")
     → 15-passive key sets + 10 new passive icon rows (the no-blank card rule keeps the
     resolver total)
   - `tests/test_art_integration.py` planned-33 assert (:42, :144) → planned-40 row (§b note
     rewritten in the same commit)
   - STAY-GREEN pairs (no retirement): `test_game_numbers.py::test_boss_at_540` (:35) +
     `tests/test_boss_numbers.py::test_boss_spawns_exactly_once_at_540` (:64) — BOSS_AT
     unchanged at 540; `MAX_PASSIVE_STACKS == 5` (test_biome_numbers.py:238) unchanged.
   ACCEPT: pytest 100 % green on the M1 tip (no RED carry); each retired name returns zero
   hits on grep (retired-claim doctrine); per-stat dump probe for each new passive.

3090 asset rows (M1): **31 imagegen 2D icons** (10 weapon + 10 evolution + 10 passive +
1 chest; 512² RGBA, imagegen spine + provenance rows, DESIGN-3D §j pattern) and
**12 TRELLIS 3D meshes** (10 weapon meshes + 2 miniboss meshes; class tri budgets §b;
minibosses static+gait, NOT skinned) — planned as **one batch + a declared re-roll reserve
(~30 % of rows held)**: the ledger's own yield history (S1a 10/11 with the player row
skipped, S1p remaster card, S1q regen card) says first-pass acceptance is not 100 %
(DA c1 item-8/A-2). Same reserve wording applies to every phase's asset rows below.

### M2 — v1.3.0 "Depth & Cycles" (~7 seat-days)

1. **Endless mode** — post-limit wave cycles with OUR per-cycle scaling (their +100%/cycle
   shape S5 ~467 is a shape reference; our curve pinned by test); Reaper analogue at the
   non-endless limit. ACCEPT: sim endless leg ≥ 2 cycles, cycle-scaling rows from dump.
2. **Chest tiers + gem merge + coin bags** — 3 chest tiers (source: miniboss/boss/event),
   merge cap on ground gems (ours, e.g. >300 → single big gem; their 400 rule S8 ~644 is
   shape ref), coin-bag tiers replacing stacked coins. ACCEPT: sim legs per tier + merge
   threshold boundary (negative test at cap±1).
3. **2 unions + 8 more weapons + 5 more passives** (24 weapons / 20 passives). One new
   behavior mechanism max; enemy weight/knockback-lite row (their knockback class S8
   ~661–665 is a shape ref, heavies resist our new shove FX). ACCEPT rows as M1-4.
4. **Unlock-flag store** — counters (kills, minutes, levels, pickups) persisted; pool-gating
   table (weapon/passive unavailable until flag); 4 sample chains (our triggers).
   ACCEPT: fresh-save leg shows gated card ABSENT, flagged save shows it PRESENT (both sides).
5. **+2 minibosses + first event-wave** (swarm-wall from one edge). ACCEPT: alive-cap holds.

**M2 landing note (v1.3.0, MC 11241, greps re-run at the v1.3.0 base — the same
retire-and-replace discipline as the M1 notes above):** LANDED — item 1 ENDLESS as built by
T-M2e (`DawnWell.flags["endless"]` hand-in, cycle-clear chest + reward card on the frozen
seams, capped `HP_CYC` ≤ 6 with the 18× clamp / `QTY_CYC` ≤ 2 / `DMG_CYC` ≤ 2.5 with the
`MAX_CONTACT_DMG 20` contact clamp, `best_cycle` save row, endless-gated cycle HUD row;
ACCEPT rows A-E1..A-E8 all green in the v1.3.0 acceptance capture) — the Reaper
analogue that was deferred at this cut (the then-tracked M2-SPEC §8.3 card) LANDED in M4
on 2026-10-26 as the reaper NIGHT FLAG (T-M4r, v2.1.0 — roadmap-is-law closed: the deferral
row retires into this dated LANDED note, no silent drop either way). Item 2 LANDED as chest tiers (T-M2t:
`CHEST_TIER_BY_SOURCE` single-source map incl. the endless-cycle → dawn row +
`chest_rewards.gd` weighted rolls — NOT their fixed 1-1-3-1-1-5) + gem-merge (T-M2g: 200/100
fold on the ONE gems array, bulk gem, both XP-conservation legs) — **except** coin-bag
tiers, DEFERRED (M2-SPEC §8.1, named follow-on). Item 3 LANDED as the 2 unions (T-M2u:
`union.gd` 2-row TABLE, precedence over evolution, the reserve rule for shared bases) riding
the roster prerequisite T-M1h (16/15 pool LIVE) — the roadmap's 24/20 (+8 weapons/+5
passives) and the knockback-lite row ride a named follow-on card (M2-SPEC §8.5). Item 4
(unlock-flag store) NOT LANDED — still named+tracked at the v2.1.0 cut; item 5
(+2 minibosses + event-wave) LANDED in M4 on 2026-10-26 (v2.1.0, T-M4a/T-M4e — see the M4
landing note below), `event` stays the forward-declared chest-source reservation (M4-SPEC
F-3: event minibosses ride the `miniboss` literal, the map stays 7 rows).

Assets (M2): 8 weapon + 8 evo + 2 union + 5 passive + 3 pickup icons = **26 icons**;
8 weapon + 2 union + 2 miniboss meshes = **12 meshes**. LANDING NOTE (M2-SPEC §6 divergence,
adopted): the four-pillar batch is **5 icons + 2 union meshes** (T-M2a LANDED, first-batch
5/5 + 2/2); the 8-weapon/8-evo/5-passive/3-pickup icon rows and the 8-weapon/2-miniboss
mesh rows ride the deferred roster-expansion/event-wave cards (their 10 weapon + 10 passive
icons already shipped in the M1 batch T-M1c).

### M3 — v2.0.0 "Stages" (~8 seat-days) — major-version-worthy: stage select exists

1. **Stage table** — `BIOMES` generalized per stage (stage → band list, gimmick id, end boss,
   limit); stage-select menu (screens.gd CanvasLayer reuse). Stage 1 = current arena.
2. **2 new stages, gimmicks chosen for mechanism reuse:** "Sunken Chapel" — 2 signature
   passives spawn as GROUND items (their stage-items gimmick S4 ~384–385, shape ref);
   "Ossuary Stair" — circular pressure plates trigger a wave surge / band flare (their
   pressure plates S4 ~386, shape ref; reuses spawn surge + band swap — no new geometry).
3. **Per-stage end boss + limit Reaper** (3 end bosses incl. warden; 2 new large miniboss-
   class meshes, Route-A scaled). Stage unlock chain: reach level N in stage k → stage k+1
   (their stage-chain S7 ~624, our N). ACCEPT: per-stage sim legs (win/limit/plate legs),
   stage-unchained leg (fresh save: stage 2 locked), v2 biome-readability gate per stage
   tiles (tools/biome_readability.py extended per stage; RED-proven), screenshots per stage.

Assets (M3): 3 seamless 1024² tiles (v2 recipe + biome_readability gate), 2 end-boss +
2 miniboss meshes = **4 TRELLIS**, 3 stage thumbnails + 4 boss-adjacent icons = **~7 icons**.

**M3 landing note (v2.0.0, MC 11286, greps re-run at the v2.0.0 base — the same
retire-and-replace discipline as the M1/M2 notes above):** LANDED — item 1 stage table +
stage select as built by T-M3s (`STAGES` below `biome_at`, the ONE band mechanism
`band_at`, stage/flare run vars OUTSIDE the frozen 12-field snapshot, the FIFTH overlay in
the one panel style with Sealed lock lines DISABLED-not-hidden, rows rebuilt from the ONE
table per open — ACCEPT rows A-E1..A-E8 all green in the v2.0.0 acceptance capture);
item 2 LANDED with the M3-SPEC rev-3 §1.2 reading — drowned-cairns ship as two ember-tier
**chests at fixed coords** (stage-item map row, zero-RNG seeding, the ONE collect funnel),
not the roadmap's shorthand "passives as GROUND items", and the pressure-stair surge
composes INSIDE the untouched `minf(12.0)`/`ALIVE_CAP 400` ceilings (cap + saturation legs,
flare moves NAMES only — difficulty reads the clock); item 3 LANDED — 1 end-boss per stage
(T-M3b: cathedral-choir + ossuary-warden rows, @540 of THEIR stage through the unified
schedule latch, per-stage keyed name bar + keyed chest tiers) + the stage unlock chain
(level 10/14, SET-only, one funnel, disk-verified; the roadmap's own stage-unchained leg
green: a fresh save ships stage 2 LOCKED). The event-wave pillar — the M2 residue "+2
minibosses + first event-wave" — was deferred out of M3 (M3-SPEC §4 decision: two more
enemy classes would break the budget re-tally law; M3 shipped the spawn-surge half of the
math); it LANDED in M4 on 2026-10-26 (v2.1.0, T-M4a/T-M4e — see the M4 landing note
below), as did the Reaper analogue (T-M4r; both deferral rows retire into this dated
LANDED note, replace-not-delete).

Assets (M3) LANDING NOTE (M3-SPEC rev-3 §6 divergence, adopted): shipped **4 icons +
2 meshes** (T-M3a, §6-exact: 3 stage thumbnails + icon-plate; cairns REUSE the shipped
chest icons — zero rows); **0 new tiles** — stages ride the shipped biome-v2 tiles and the
biome_readability gate runs per stage instead (9 windows green, the roadmap's own
"extended per stage" ACCEPT row); the 2 miniboss meshes + the boss-adjacent icon rows
shipped in M4 (2026-10-26, v2.1.0: sunken-prelate/stair-acolyte/the-reaper meshes,
T-M4a) with their classes. Mesh budget rows (M3, 4000-tri character class):
cathedral-choir 3923/4000, ossuary-warden 3865/4000 — solid at all four turntable yaws
(binding eyeball gate), same 5.33 m boss height class as the warden (height rows
rel_err 0.0).

**M4 landing note (v2.1.0 "Nightfall & Legacy", MC 11363, 2026-10-26 — LANDED named,
NOT-LANDED named, replace-not-delete):** LANDED — **event-waves** (T-M4a/T-M4e: sunken-
tide / stair-wall windows [660,720) as STAGES-table `events` rows, fixed 90° cones from
the west/east, ×2 surge INSIDE the untouched `minf(12.0)`/`ALIVE_CAP 400` ceilings —
their above-cap pause exemption REJECTED, M4-SPEC F-4 — + the 2 event miniboss classes
sunken-prelate / stair-acolyte @660 on the ONE schedule latch, riding the `miniboss`
drop literal, map stays 7 rows, F-3; stage 1 `events: []` byte-law, A-E1 re-measured at
the release cut); **the Reaper night flag** (T-M4r: hidden `flags["reaper"]` = the
endless precedent channel, endless precedence source-pinned (R9), one reaper at the
limit + one per 60 s, contact ENDS the run — an END law, not damage, F-6; flag-off win
byte-identical); **limit-break-lite** (T-M4l: three repeatable stat cards LIMIT · FURY/
HASTE/BULWARK at the ONE offer funnel ONLY when the pool is exhausted — the 32 pool-kind
law stands, s8 A7 re-pinned; three additive zero-identity seams, C-E3 formula rows);
**desert re-tone** (T-M4a: BURNING DUNES warm-dune hue inside the luma envelope — tile
gate 32.9/26–36 at this cut, superseded v2 tile archived). Version decision SEL-A:
no new player-navigated surface shipped (M4-SPEC §5/§9 F-7) ⇒ MINOR v2.1.0 per the law
at `:63-66`. **NOT LANDED (named+tracked, not silence):** the 6 characters + purchase
screen (item 1 — `T-M4c-CHARACTERS`: the release that lands that surface carries the SEL
version decision to the owner), the achievements page (item 2 — `T-M4p-ACHIEVEMENTS`),
player skins (item 4 — `T-M4k-SKINS`), plus the pre-existing tracked deferrals: coin-bag
tiers (M2-SPEC §8.1), roster-expansion +8/+5 (M2-SPEC §8.5), the unlock-flag store
(roadmap M2 #4). The tranche name "Roster & Legacy" describes the deferred roster half;
what shipped is the four-pillar subset the MC 11334 brief ordered (one-milestone size
law). Assets (M4): **3 meshes + 1 tile retone, 0 new icons** (limit cards ride the
inline-icon catch-all, M4-SPEC P3-5): sunken-prelate 3834/4000, stair-acolyte 3851/4000,
the-reaper 3866/4000 tris, all FIRST SEED, @1.42 gates (PERMANENCE §M4 rows); the retone
is a pixel swap at the shipped path, not a new tile. Byte law at this cut: stage-1
journey 5020 rows + every strict fixture byte-identical vs the v2.0.0 base (declared
re-mints: stages-m3's 3 R2 rows, art-s2i forward-lock; new events/reaper/limit fixtures
twice-cmp-identical, per-sim seeds = card ids — the spec seed line superseded, declared
in the LEDGER).

### M4 — v2.1.0 "Roster & Legacy" (~7 seat-days)

1. **6 selectable characters** — each = start weapon + one signature stat rule + portrait
   icon; purchase screen with additive price curve (ours); 2 characters achievement-gated
   (uses M2 store). ACCEPT: per-character sim leg (start weapon fires, signature rule pinned
   by test), purchase leg, select-screen screenshot.
2. **Achievements page** (~20 rows, our conditions) surfacing M2 chains + character gates.
3. **Limit-break-lite** — all-maxed state grants repeatable stat cards (their Limit Break
   S5 ~473 is shape ref; our stat-per-card rules). ACCEPT: all-maxed scripted leg offers a
   limit-break card (pool-exhaustion fallback pinned).
4. **Player-character skins** — 5 extra TRELLIS meshes retargeted onto the EXISTING
   player rig + clips (tools/mocap pipeline; same 34-joint skeleton, no new rig class).

Assets (M4): **11 TRELLIS-class items** — 6 character meshes + 5 alternate skins, each a
DISTINCT mesh on the same 34-joint rig (DA c1 P2-6 fix: skins are real meshes, not re-tints;
skins may share a decimated base but ship as their own GLB+tri dump rows) + 6 rig-retarget
runs (pipeline exists, tools/mocap); **6 portraits + ~6 achievement badge icons** (badges may
reuse existing icons — stated). Batch + ~30 % re-roll reserve as in M1.

### Stretch (unplanned, name only — no DoD here)
Hidden-evolution relic chain (their rings/Metaglio route S3 ~369), more stages toward 5+,
merchant NPC, audio (already open polish), light-source destructibles.

## 3. DELIBERATE EXCLUSIONS

1. **Co-op** — separate netting/input subsystem (VS ships LOCAL co-op only, S8 ~671–674; it
   rewrites level-up pooling, shared chests, enemy scaling). Out; separate project if the
   owner ever asks.
2. **Cloud saves** — a platform service (Steam Cloud, S8 ~680–682); we are self-hosted
   web+win. `user://` save files cover our persistence (the former "+ the leaderboard
   server" clause named a component this repo never carried — retired MC 11398 §4.1).
3. **Mobile touch controls** — owner plays desktop/web (their mobile releases exist but the
   control rows are UNVERIFIED, S8 ~676–678). Revisit on owner word.
4. **DLC-flagged / UNVERIFIED inventory rows** (S2 DLC passives, S4 [DLC] stages, S6 DLC
   roster ~97 names) — these are inventory GAPS (names only, effects unverified); re-verify
   before cloning any SYSTEM from them. No DLC-parity phase.
5. **Counterpart weapons / Inverse mode** (S1.5 ~287–289) — rides an Inverse mode that itself
   rides DLC-era systems; not base parity.
6. **Arcanas / Secrets menu / spells** — referenced only as adjacent mechanics in
   VS-FEATURES (e.g. S8 ~658–660) and not in the DoD family list; do not clone blind.

## 4. DEPENDENCY MAP (what rides on what)

- **S12 playtest verdict (in flight)** → gold/XP pickup visibility + readable upgrade cards.
  M1's meta shop, chest UX, and gold economy are BLOCKED on visible gold being real in-game
  (the coin/gem/Dawnlight 3D draw path does not exist yet — only sim state — VERIFIED this
  session by grep: no draw references outside world.gd).
- **Biome v2 tiles merged** (T-S15, master 130b33d + tick-deterministic gate) → M3 stage
  tiles reuse the v2 recipe; `tools/biome_readability.py` is the stage-readability gate.
- **Suite pins** (corrected per DA c1 E-2, re-grepped this session) — WIN_TIME 600 is pinned
  TWICE: `tests/test_game_numbers.py:39` + `tests/test_biome_numbers.py:65`; BOSS_AT 540 twice:
  `tests/test_game_numbers.py:35` + `tests/test_boss_numbers.py:64` (stays 540 in M1 — must
  stay GREEN). M1's run-length change retires+replaces BOTH WIN pins in the same commit; the
  full retire list is M1 feature 7 (no RED carry).
- **Contract B snapshot** (exact 12 fields, `game_state.gd:226-245` — old pin :87-104; v2.1.0-cut re-grep — + bridge/web JS) —
  meta/evolution state lives OUTSIDE the run snapshot (menu layer + new snapshot version if
  ever exposed); any field addition is an owner-visible contract change, flagged at M1 design.
- **Draw/horde budget + Route A** (DESIGN-3D §b/§c) — every M-phase FX addition re-tallies
  the draw budget; no skinned horde, no per-enemy draws, ever.
- **GPU windows (vm100 3090)** — TRELLIS/imagegen batches run per-phase off-peak with
  drain_barrier + trap-close (S1a/S1p pattern); asset rows are planned as ONE batch per phase
  **plus a declared re-roll reserve (~30 % of rows)** — S1a/S1p/S1q history shows first-pass
  acceptance < 100 % (DA c1 item-8).
- **S12 in-flight status (DA c1 E-3)** — UNVERIFIABLE from the repo (no S12 row in LEDGER,
  no git trace); the orchestrator confirms the board card before M1 build cards are filed.
- **Fleet law** — roadmap-gated build cards are filed ONLY after the DA SHIP on this
  roadmap (§5); each M-phase build parent then runs its own phase-0 front-matter where not
  already covered by this document.

## 5. PHASE-0 NOTE — DA gate (fleet law: required — YES)

This parent is far above trivial size (≈32 seat-days, 4 releases), so per fleet law the
front-matter needs its own devils-advocate gate BEFORE any roadmap-gated card is filed.
This document IS the phase-0 bundle: research = VS-FEATURES.md (MC 11195, cited per claim),
architecture map = §1 + §4, phase plan = §2. The DA must check, at minimum:

1. Honesty constraint present and enforced in every table ("our numbers", no copied values/assets).
2. Every M-phase is independently shippable (own version bump + release-notes line + S9/S11 export spine).
3. Reuse-first: every new weapon maps to an existing mechanism or to THE ONE new shared
   mechanism (zones); no second mechanism beside an existing one anywhere in §2.
4. Budget rows are real: 400-alive cap, draw ≤ 60 re-tally, web+win parity legs named.
5. Every acceptance line is checkable (named sim leg / gate script / screenshot / pytest row),
   with planted-red rows where a gate could pass vacuously.
6. §4 dependencies match live state (S12 verdict, visibility fix, suite pins, Contract B).
7. Exclusions carry reasons, not silence.
8. Effort sizing is honest for ~4 releases of systems + assets.
9. Gap table VS column is section-cited and its own CONTRADICTED/UNVERIFIED caveats respected.
10. The v1-verbatim suite retirement handling (retire+replace in same commit) is stated, not glossed.

**Cycle state (rev 3):** DA cycle 1 → FIX (c1 @ 000ba42, adopted 7/7 + 6 P3s in rev 2);
cycle 2 → FIX with adoption audited 7/7, **rebuttal UPHELD** (c2 @ d2897da — both-pins-true,
pytest 58 green run by the DA itself), its 3 P2s + 3 P3s landed in this rev. Roadmap-gated
build cards stay filed-only-after the cycle-3 verdict SHIPs.

## REBUTTAL (cycle-2 judgment material — fix list still adopted in full)

**RESOLVED — UPHELD by DA cycle 2 (c2 PASS 2, MC 11203): the DA re-ran the greps and pytest
(58 passed) itself and ruled the producer right; state of the world = both-pins-true.**
Section kept below immutable as the cycle-2 judgment record.

- **DA E-2(a)/(b) fact-row is CONTRADICTED (re-grepped rev-2 session):** the DA says
  `test_win_threshold_600` "does not exist" and WIN/BOSS pins live "in test_biome_numbers.py:65
  / test_boss_numbers.py:64, NOT in test_game_numbers.py as §4 claims". Grep this session:
  `tests/test_game_numbers.py:39` **defines** `def test_win_threshold_600()` (asserts
  `const("WIN_TIME", GAME_STATE) == 600.0` + the main.gd gate regex) and `:35` defines
  `test_boss_at_540` — the v1-verbatim copies, present and green. Rev-1 §4's attribution was
  TRUE. The DA's SUBSTANTIVE finding is also true and is adopted in full: a SECOND pin pair
  exists (`test_biome_numbers.py:65`, `test_boss_numbers.py:64`) and the IDS pin
  (`test_biome_numbers.py:226`) plus the PASSIVES↔icons pins (`test_card_icons.py:81,111`)
  and the planned-33 assert (`test_art_integration.py:42,144`) were unlisted — rev 2 names all
  six obligations in M1 feature 7. Net effect: retirement list grew, nothing in the fix list
  is refused; only the "no such test exists" evidence claim is rebutted, because an executor
  trusting it would have DELETED a live green pin instead of retiring it deliberately.

--- END ROADMAP ---
