# RIG-DEVIATION — SEL-C asset set, T-M5r rig+clip pass (MC 11440, 2026-10-27)

> **DATED SUPERSESSION ROW (2026-11-01, MC 11773 T-3DR-r — replace-not-delete):** the
> 3DR statue re-master (docs/3DR-SPEC.md REV 4 §3.3 option (c), owner ruling 2026-10-29
> "Ibwant skeletons with movements...") re-rigged the six statue classes on NEW meshes;
> three M5 statics FLIPPED to RIGGED (char-tallow-seer, skin-tide, skin-void). The LIVE
> rig-state pin is now **docs/RIG-DEVIATION-3DR-2.md** (3DR-era state MEASURED:
> 10 rigged / 3 static — the T-3DR-r pin header's "9 rigged / 4 static" was an
> off-by-one against its own table, superseded 2026-11-02, MC 11918 T-3DR-CC2);
> this doc's rows STAY as measured M5 lineage, its table is byte-unchanged, and its
> "Final table" line is struck in place below. The B-E8/K-E3 test re-pin to the new doc
> rides T-3DR-c per §3.4.

Pin artifact for builders/testers (B-E8 / K-E3): of the 13 SEL-C meshes, **7 ship
rigged+clipped** (walk + attack named glTF animations, CMU 07_01 / 02_05 retargeted
by the existing `tools/mocap` chain, `assets/anim/maps/<name>.json` committed per
S2r precedent) and **6 ship STATIC**. Static rows are EXCUSED-not-removed.

Owner artifact: orchestrator FINAL RULING MC 11440, owner ratification verbatim
**"Rec"** (2026-10-27) to the recorded recommendation — "OPTION A — the five
rig-inference failures SHIP STATIC ... (option A, statue-class static)". No reserve
burns beyond the two ratified re-masters; mesh reserve 1/3 HELD.

| # | asset | state | reason (static rows) |
|---|-------|-------|----------------------|
| 1 | char-emberwright.glb | RIGGED walk+attack | — |
| 2 | char-grave-ward.glb | RIGGED walk+attack | — |
| 3 | char-coinhound.glb | STATIC (v2 file) | rig-stage double-fail: v1 seated quadruped AND v2 re-mastered upright hound-knight (ruling-1 re-master, mesh passed every asset gate incl. 4-yaw SOLID) both yield a deterministic UniRig **4-bone** skeleton collapse; owner "Rec" artifact |
| 4 | char-duskrunner.glb | RIGGED walk+attack | — |
| 5 | char-tallow-seer.glb | STATIC (v2 file) | rig-stage double-fail: v1 sealed-robe AND v2 re-mastered (legs visible in robe opening, arms flat) both yield a deterministic UniRig **3-bone** collapse (skin stage then crashes `index 3 out of bounds`); v2 mesh passed every asset gate incl. 4-yaw SOLID — stop clause = static, v2 file ships |
| 6 | char-iron-penitent.glb | RIGGED walk+attack | — |
| 7 | char-shroud-saint.glb | STATIC | deterministic UniRig collapse: **9-bone single vertical chain** (zero side chains) — fully shrouded sealed-bell silhouette defeats the humanoid skeleton model; seed 12345 fixed => retries do not change the result |
| 8 | char-hoard-wretch.glb | STATIC | deterministic UniRig mis-read: **41 bones but NO leg chains** (wings-as-arms with claw-finger fans; crouch posture) — a humanoid CMU walk/attack cannot be driven without legs |
| 9 | skin-ash.glb | RIGGED walk+attack | — (map data adjusted: Neck1 dropped per player.json precedent, mapped=22) |
| 10 | skin-marrow.glb | RIGGED walk+attack | — |
| 11 | skin-tide.glb | STATIC | deterministic UniRig collapse: **3-bone** skeleton (skin stage then crashes `index 3 out of bounds`); same class as tallow-seer-v1 |
| 12 | skin-relic.glb | RIGGED walk+attack | skeleton = exactly the player's 34-joint reference (match=True) |
| 13 | skin-void.glb | STATIC | deterministic UniRig collapse: **3-bone** skeleton + skin-stage crash (identical class to skin-tide) |

TABLE-FOOTER (char-tallow-seer): v1 sealed-robe mesh collapsed deterministically to
3 bones twice (windows 12:07Z / 12:25Z). Ruling-2 re-mastered ref (legs visible in
the robe opening) regenerated GREEN (seed 805: 7962/8000 tris, ext/fill PASS,
VISUAL PASS, aspect 1.67/0.45 PASS, static 4-yaw SOLID); its rig pass (15:05Z
window) then collapsed 3-bone AGAIN + skin-stage crash -> DOUBLE-FAIL stop clause,
STATIC with the v2 file. Final table: ~~**7 rigged / 6 static**~~ **(3DR-era live state
10 rigged / 3 static — pinned in docs/RIG-DEVIATION-3DR-2.md; the struck 2026-11-01
row (MC 11773) carried an off-by-one "9 rigged / 4 static" claim against its own
table, itself superseded dated 2026-11-02, MC 11918 T-3DR-CC2)** (window evidence + per-mesh gates in `.tmp/m5-rig.txt`). Portrait icons: coinhound + tallow-seer busts
depict no stance and keep the re-mastered identities (chain+coin medallion / hooded
seer) -> KEPT, stated per ruling ("keep unless clear mismatch"; none measured).

Bone-count note (M5-SPEC §3.1 honest row): the 34-joint reference is the PLAYER
row; UniRig bone counts are per-asset (this batch: 28–53 joints, relic exactly 34).
The observable gate is the shipped named animations + skin data, measured per mesh
in `.tmp/m5-rig.txt`.
