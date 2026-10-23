# PARITY-ROADMAP — hollow-dawn-3d vs Vampire Survivors (MC 11196, T-S17)

- Authored 2026-10-23 by the `design` profile. Inputs read this session: `docs/VS-FEATURES.md`
  (MC 11195 inventory), `LEDGER.md`, `docs/DESIGN-3D.md`, `godot/scripts/` (render.gd BIOMES,
  world.gd ENEMY_TYPES, weapons.gd META, levelup.gd PASSIVES, game_state.gd), `tools/` gates.
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
| 1 | Weapons: count + behavior | 6 (`weapons.gd IDS:6`), one behavior each, MAX_LEVEL 8 (`:7`), flat `META` table, `_fire` match | 273 total = 138 base + 94 evo + 7 unions + 4 gifts + 19 counterparts + 11 special (S1 tables ~19–304; tally ~710–712); base max lvl mostly 8 (S1 intro ~15) | 16 by M1, 24 by M2, 26+ by M4 — count is NOT the parity metric; behavior-class coverage + level/pool mechanics are. Their 273 incl. DLC is not a cloning target |
| 2 | Evolutions + unions | none | max weapon + carried passive + chest after 10:00 converts (S3 ~354–358); unions = 2 maxed weapons (S1.3 ~266–276); combo totals ~367 | M1: chest-driven evolutions (our rule, our time gate); M2: 2 unions |
| 3 | Passives | 5 × 5 stacks (`levelup.gd:8-14`), no carry cap | 33 total (S2 ~309–311); max 6 different carried per run (S2 ~313) | 15 by M1 (one per evolution partner), 20 by M2; carry-cap rule ours |
| 4 | Stages + gimmicks | ONE arena, 4 biome bands t=0/150/300/450 (`render.gd BIOMES:66-75`), no per-stage rules | 25 stages, each time-limited (15–30 min) with gimmicks: stage items, traps, boss (S4 table ~382–409; Reaper at limit ~378) | M3: 3 selectable stages via a stage table riding the band mechanism; 1 cheap gimmick per stage from existing mechanisms |
| 5 | End-bosses + minibosses | 1 boss (warden hp 3000 @ t=540, `world.gd:5,24`) | end-of-stage bosses per stage (S5 table ~427–439) + 72 named wave bosses (S5 ~441–457); boss chest-drop rule (S5 ~419) | M1: 2 minibosses; M2: +2; M3: 1 end-boss per stage (4 total); event swarm waves M2+ |
| 6 | Endless mode | none — WIN_TIME 600 (`game_state.gd:7`) | cycles restart waves with per-cycle HP/qty/damage scaling; Reaper only in non-Endless (S5 ~465–471); Limit Break beyond max (S5 ~473) | M2: endless with OUR scaling curve; M4: limit-break-lite |
| 7 | Characters + unlocks | 1 fixed character, talon start (`game_state.gd:56`) | 165 (S6 ~481; roster CONTRADICTED at 168 — treat count as ~165); gold-purchase with additive price scaling; secret unlocks (S6 ~481–483) | M4: 6 selectable, each start-weapon + one signature stat rule; purchase price curve OURS |
| 8 | Meta shop + refund | none — gold dies with the run (score adds it, `main.gd:239`); no save file | 24/25 PowerUps table (S7 ~573–605; count CONTRADICTED 24-vs-25); refund-all rule (S7 ~609); disable-when-maxed rule (S7 ~610) | M1: meta shop (12 power-ups M1 → ~18 M2, our ranks/prices) + refund; persist via `user://save.json` |
| 9 | Pickup systems | gem/coin/heal in sim only, NO 3D draw (in-flight visibility fix); no chests, no merge, no bags; boss +50g flat (`world.gd:126–138`) | chests w/ tiers + fixed first-6 sequence (S8 ~651–656); 400-gem merge-to-red rule (S8 ~644); Coin Bag / Rich Coin Bag + light-source pickups (S8 ~649, S7 ~628) | M1: chests (single tier); M2: 3 tiers + gem-merge cap (ours) + coin-bag tiers |
| 10 | Achievement-chain unlocks | none (no counters persisted) | passives/weapons/stages gated by achievement chains (S7 ~617–624: e.g. "Level up X to lvl 4" → passive; stage unlock = reach lvl N in previous stage ~624) | M2: unlock-flag store gating the level-up pool; M4: achievements page (~20 rows) |
| 11 | Co-op | none | local co-op up to 4; changes pooling/shared chests (S8 ~671–674) | EXCLUDED — see §3 |
| 12 | Mobile | none (desktop/web builds) | official mobile releases exist; control details UNVERIFIED (S8 ~676–678) | EXCLUDED (revisit on owner word) — see §3 |
| 13 | Cloud save | none; leaderboard via vendored v1 server only | "Steam Cloud" listed as platform category; internals UNVERIFIED (S8 ~680–682) | EXCLUDED — platform service, see §3 |

## 2. PHASED PLAN — M1..M4, each phase a SHIPPABLE release

Release spine for every phase (unchanged fleet process): version bump + release-notes line,
web double-export + win export RC=0, VM120 field test (session-1 screenshot), playwright
0 console errors, `gh release create` with both zips + digests (S9/S11 LEDGER rows are the
pattern). Suite posture: the v1-verbatim pin era ENDS at the first deliberate divergence —
the same commit that changes a pinned number RETIRES its test row and adds the new pin
("test_win_threshold_600" → new value) — never leave a RED row.

Engine budgets, standing for all phases (from DESIGN-3D §b, restated): concurrent horde
cap **400 alive** (new hard rule M1: spawns pause at cap — our analogue of their 300-alive
pause, S5 ~422, OUR number); draw plan ≤ 40 / **hard cap 60** (every new FX class batches
into MultiMesh pools; re-tally via the art-probe fixture per phase); sim legs stay
seed-pinned headless runs; web rAF reported against the DECLARED software-GL floor (~20 fps
llvmpipe), never owner-hardware claims.

### M1 — v1.2.0 "Evolutions & Dawn Well" (~10 seat-days)

Prereq (in flight, not counted here): gold/XP pickup visibility fix + S12 playtest verdict
(visible gold/XP, readable upgrade cards) — §4.

1. **Meta shop "Dawn Well" + refund.** Persistent gold (`user://save.json`); 12-power-up
   table (our names/ranks/prices; effect stats ours) bought with run-gold; refund-all button
   (their refund semantics S7 ~609, our rounding honest). ACCEPT: pytest regex-pin of the
   power-up table; sim leg — run ends, gold persists, buy rank, next run sees `+stat`
   (snapshot row proves it); refund returns gold minus declared fee; shop UI Xvfb screenshot;
   planted-red: tamper save → migration leg must fail loudly.
2. **Run length + bosses.** WIN 600→900 s (suite row retired+new pin in same commit);
   2 minibosses @ t=600, 780 (static meshes + Route-A gait per DESIGN §c — no new UniRig
   runs); horde cap 400 rule. ACCEPT: sim_s8-style real-clock legs at the new WIN; max-alive
   row ≤ 400 in the 900 s dump; boss/miniboss chest-drop roll rows (their chest-on-kill rule
   S5 ~419, our rate).
3. **Chests + evolutions.** Chest pickup from boss/miniboss kills; opening pauses and grants
   a reward card (level-up fallback = gold, ours). Evolution rule (our gate values): weapon
   MAX + partner passive carried (any rank) + chest opened at t ≥ 600 → replace base with
   evolved, reset its cooldown. ACCEPT: `sim_evolve.gd` scripted leg (owns L-max weapon +
   partner → chest after gate → evolved id in `game.weapons`, base removed); planted-red
   chest at t < gate must NOT evolve; evolution table pytest pin; chest-open screenshot.
4. **10 new weapons** (names ours; archetype = behavior class; mechanism = reuse):

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
   S4); `_hit` remains the SINGLE damage entry; FX draws re-tallied ≤ cap (new: zones MM +1,
   chest MM +1 → planned ≤ 40); 16 weapon icons visible on cards (screens leg, no-blank rule
   stays); planted-red per new behavior (cooldown never reaches fire → leg goes RED).
5. **10 partner passives** (15 total; each a stat row on GameState, our values).
   ACCEPT: pytest pin table; one per-stat sim probe each.

3090 asset rows (M1): **31 imagegen 2D icons** (10 weapon + 10 evolution + 10 passive +
1 chest; 512² RGBA, imagegen spine + provenance rows, DESIGN-3D §j pattern) and
**12 TRELLIS 3D meshes** (10 weapon meshes + 2 miniboss meshes; class tri budgets §b;
minibosses static+gait, NOT skinned).

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

Assets (M2): 8 weapon + 8 evo + 2 union + 5 passive + 3 pickup icons = **26 icons**;
8 weapon + 2 union + 2 miniboss meshes = **12 meshes**.

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

Assets (M4): 6 character meshes + 6 rig-retarget runs (pipeline exists) = **6 TRELLIS**;
**6 portraits + ~6 achievement badge icons** (badges may reuse existing icons — stated).

### Stretch (unplanned, name only — no DoD here)
Hidden-evolution relic chain (their rings/Metaglio route S3 ~369), more stages toward 5+,
merchant NPC, audio (already open polish), light-source destructibles.

## 3. DELIBERATE EXCLUSIONS

1. **Co-op** — separate netting/input subsystem (VS ships LOCAL co-op only, S8 ~671–674; it
   rewrites level-up pooling, shared chests, enemy scaling). Out; separate project if the
   owner ever asks.
2. **Cloud saves** — a platform service (Steam Cloud, S8 ~680–682); we are self-hosted
   web+win. `user://` save files + the leaderboard server cover our persistence.
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
- **Suite pins** — WIN_TIME 600 / BOSS_AT 540 are test-pinned (`test_game_numbers.py`);
  M1's run-length change must retire+replace those rows in the same commit (no RED carry).
- **Contract B snapshot** (exact 12 fields, `game_state.gd:87-104` + bridge/web JS) —
  meta/evolution state lives OUTSIDE the run snapshot (menu layer + new snapshot version if
  ever exposed); any field addition is an owner-visible contract change, flagged at M1 design.
- **Draw/horde budget + Route A** (DESIGN-3D §b/§c) — every M-phase FX addition re-tallies
  the draw budget; no skinned horde, no per-enemy draws, ever.
- **GPU windows (vm100 3090)** — TRELLIS/imagegen batches run per-phase off-peak with
  drain_barrier + trap-close (S1a/S1p pattern); asset rows above assume one batch per phase.
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

--- END ROADMAP ---
