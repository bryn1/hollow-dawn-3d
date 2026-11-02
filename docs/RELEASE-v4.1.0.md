# Hollow Dawn 3D — v4.1.0 “Owner Menu Trio”

The M7 milestone: the owner-menu trio filed 2026-10-28 (a playthrough verdict, not a spec,
opened it — MC 11446 found NO settings screen existed) ships complete. Three cards, three
owner-menu items, three consecutive commits onto the v4.0.0 tag: **settings**, **touch**,
**best runs**. The sim did not move for any of them — the same byte-anchored journey rides
this tag as rode v4.0.0. **MINOR v4.1.0 per the release dispatch (MC 11936)**; the version
stamp is the orchestrator’s call on the owner’s filed menu, recorded below, not a fresh
owner ruling.

## RATIFICATION

The three menu items are pasted VERBATIM from the filed backlog card titles (MC 11626 /
11627 / 11628, owner menu A/B/C, filed 2026-10-28) — the quotes the release law demands,
never paraphrased:

- **Menu A (MC 11626): “SETTINGS SCREEN - volume, window/fullscreen, pause options”** —
  the card names the origin verbatim: “owner playthrough (MC 11446) found NO settings
  screen exists (honest-absent row)”.
- **Menu B (MC 11627): “TOUCH CONTROLS for the web build (virtual joystick + pause tap;
  phones/tablets)”**.
- **Menu C (MC 11628): “LEADERBOARD DONE RIGHT - LOCAL best-runs board per hero (top runs
  survived/kills/score persisted save-side)”** — the card’s own line: “The old
  global-leaderboard claim was deleted as never-shipped (clean-code audit 2) - this builds
  the real local thing so the README claim is truthful again.”

The orchestrated dispatch order A→B→C (sequential, single-writer on the overlay family) is
the release card’s record: 11626 closed verified at commit 9c8d1e7, 11627 at eaa8cc0,
11628 at bce6d48 — each knut-PASS, each verified by the orchestrator’s own legs at close.
This release dispatch (MC 11936) carries the v4.1.0 stamp, the tag and the playable pair.

## What shipped

- **Settings (T-M7A, MC 11626, commit 9c8d1e7)** — the EIGHTH overlay on the one panel
  style: three persisted volume sliders (Master/Music/SFX — the ONE audio path,
  `default_bus_layout.tres`; `settings.gd` is the ONLY `set_bus_volume_db` home),
  window/fullscreen, and a persisted “pause when the window loses focus” option (the
  DECLARED reading of the menu’s “pause options”: the Esc freeze stays exactly as shipped;
  the overlay is menu-reachable, not a mid-run pause surface). Persistence is TWO REAL
  godot boots on one throwaway well: the second process boots with the persisted dB already
  applied to the real AudioServer buses and the widgets showing the persisted values.
  Save: five field-by-field ADDED rows (R1 serial sixth move, VERSION stays 1);
  same-value/unknown-key verbs move ZERO disk bytes; older saves migrate to defaults
  no-quarantine.
- **Touch (T-M7B, MC 11627, commit eaa8cc0)** — virtual joystick + pause tap on the WEB
  build. The move vector rides the ONE input seam keys/mouse already share (`bridge.gd`
  VSHost): 8-way octants feed the SAME arrow codes as the key pairs through a separate
  touch dict UNIONED inside `move_vector` — **the touch vector is byte-identical to the
  key-pair vector by construction** (probed all 8 octants, ident legs; opposite key/touch
  cancel exactly like KeyA+KeyD). Pause-on-tap feeds the SHIPPED Esc arm — same flag, no
  pause fork. The stick visual appears only when a real touch event has been seen
  (presence law); desktop paths byte-UNCHANGED. A WASM dogfood caught and fixed a real
  bug (resting ring painted off-screen — a Control under a CanvasLayer carries no layout).
- **Best runs (T-M7C, MC 11628, commit bce6d48)** — the NINTH overlay: per-hero top-5
  (survived / kills / score) recorded through the ONE shipped game-over funnel, persisted on
  the Dawn Well save, rank law = score desc, survived desc on a score tie, the EARLIER row
  above on a full tie (ordered-insert scan — the engine sort is an unstable quicksort).
  The score is the end panel’s OWN formula, one home proved by a repo-wide walk. TWO REAL
  BOOTS: the write boot drives real runs through the shipped game-over arms; a NEW process
  reads the IDENTICAL board rows back through the shipped loader. Recording is ONE line
  in `main._end_run`, OUTSIDE the sim step — the P-E3 funnel occurrence count HOLDS at 12
  (the honest zero-move serial row).
- **Measurable progression, replace-not-delete:** suite **382 → 395 → 399 → 412** across
  the trio — every step is EXACTLY the named new tests (M7A +11 S-E rows, M7B +4 T-E rows,
  M7C +13 L-E rows), NO test deleted; every new gate planted-red PAIRED (11 + 4 + 12 plants,
  ALL RED-as-intended, every restore byte-exact). The byte law held at every card AND at
  this tag: **journey-5071 @`HD3D_SEED=11101` md5 `5d863b8034018116a00a1015bf7ac1f6`** —
  the same recorded digest since the 3DR wave, reproduced on the release tree.
- **The playable pair is ON this tag** — v4.0.0’s honest “exports pinned to the v3.1.0
  tree” limit row is CLOSED here (release law: never notes-only again): the Web + Windows
  exports were built FROM the tagged tree, served under COOP/COEP, and uploaded as this
  release’s assets (rows below).

## Checks at this tag (T-M7-R battery, MC 11936, capture `.tmp/m7rel.txt`)

- full pytest suite: **412 passed, 0 failed** rc=0 (pinned engine per conftest/VERSIONS,
  throwaway XDG well per conftest law, fresh `--import` on the release worktree — the
  fresh worktree carried NO class cache, T-M5p seam);
- roster clip gate GREEN **66/66** (CAPTURE_ROWS=66, SHAPE_CHECKS_FAILS=0, fresh xvfb
  capture through the ONE launcher);
- journey-5071 @11101: SIM_RC=0, 5071 rows, md5 == `5d863b8034018116a00a1015bf7ac1f6`
  (re-dump vs the RECORDED digest);
- dawnwell pixel gate **5/5 PASS** (shop 60855 / stage-select 52020 / achievements 56802 /
  char-select 65237 / level-up chips 124180 px vs floor 200);
- motion gate GREEN `--twice`, determinism state-rows=11 identical=True;
- HOLD md5 sweep **20/20 OK** — 12 strict jsonl + the 2 framediff CSVs + the 5 tracked
  `.tmp` capture dumps byte-invariant vs this tag’s parent base (`bce6d48`), and
  `art-s2i-probe.jsonl` md5 `ca71f16…` UNCHANGED (its declared REMINT identity);
  the deviation/pin docs (BYTE-DEVIATION-M6, CAPTURE-DEVIATION-3DR, RIG-DEVIATION-SEL-C,
  RIG-DEVIATION-3DR-2 + superseded archive) ZERO-DIFF vs the same base;
- the tag sits ON the release commit (`v4.1.0^{commit}` == pushed master tip); this notes
  file is the gh-release body byte-for-byte (`--notes-file`).

## Known limits (honest)

- **Real-finger routing is INFERRED.** The WASM legs are engine-verified — REAL
  `TouchEvent`s dispatched at the canvas froze and resumed the shipped clock (observable:
  `__vsSnapshot.time` stops; Contract B’s frozen keys carry no `paused` field, the freeze
  IS the observable), a drag painted the live stick and its release pressed nothing, and
  the hero survived an 18-s held drag (hp 84). But trusted CDP touch emulation is NOT
  exposed by the capture browser, so phone/tablet trusted-touch ROUTING to the shipped
  seam is INFERRED from those legs, never claimed as measured.
- **Headless fullscreen APPLY is INFERRED.** The persistence contract is VERIFIED (the
  checkbox lands on disk, boot #2 reads it back, the widgets show it); the window FLIP
  itself cannot runtime-prove under a headless DisplayServer — `Settings.apply_window`
  is source-pinned to WINDOW_MODE_FULLSCREEN/WINDOWED behind the headless/web guard.
- **“Pause options” shipped as the persisted focus-out option** (the declared reading,
  recorded at close for owner veto): a focus-out pauses a PLAYING run iff the option is
  on; **Esc is untouched** — the shipped freeze stays the shipped freeze; there is no
  mid-run settings surface (that would fork the phase law).
- **The volume sliders control buses that currently carry no sound.** This build ships no
  audio EMITTERS yet (KeyM-mute stays an internal flag — the shipped honest row); the
  Master/Music/SFX layout + sliders + dB read-backs are the ONE audio path future
  emitters route through. The retired README line “no audio yet” was stale about the
  SETTINGS SURFACE (fixed dated at this cut, replace-not-delete); it was and stays TRUE
  of audio content.
- **The best-runs board is LOCAL by law** (owner menu C verbatim: “LOCAL”). The
  leaderboard *server* and cloud saves stay DELIBERATE EXCLUSIONS (docs/DESIGN-3D.md §(e),
  PARITY-ROADMAP §3 rows 2/13 — untouched rulings; the retired global-leaderboard README
  claim stays retired).
- Web export stays **no-threads** (the project’s shipped web law); the pause tap works
  there through the shipped Esc arm, exactly as on desktop.

## PROMISED vs SHIPPED — the line at this tag

v4.0.0’s notes named, in “Next”, the M7 trio the owner picked for after 3DR: the
settings/options screen, mobile touch, and the leaderboard. At this tag: the settings
screen **SHIPPED**; touch **SHIPPED for the web build** (phones/tablets play the web
export; a native Android/iOS build was NOT promised and stays outside roadmap §3); the
leaderboard item shipped as the owner’s menu C words it — “LEADERBOARD DONE RIGHT -
LOCAL” — and the cloud-save/server half is NOT shipped BY RULING, not by omission. The
one item this tag adds beyond the trio: the v4.0.0 known-limit “playable exports are NOT
shipped with this tag” row is CLOSED — the WASM + Windows zips download off THIS release.

## Next (filed, not silent)

Per the owner’s clean-code doctrine the CC-audit/refactor pair rides post-GA again
(screens.gd 711 L carries its dated growth header; the named `_card-cluster` split
candidate stays open; the M7C probe-runner duplication hygiene note rides the audit’s
fix-list). Audio EMITTERS (the polish the sliders already wait for) are named open
roadmap Stretch. Nothing else in this release promises anything unnamed.
