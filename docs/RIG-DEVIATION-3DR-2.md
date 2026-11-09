# RIG-DEVIATION — 3DR statue re-master set, REV-2 (T-3DR-CC2, MC 11918, 2026-11-02)

> **DATED SUPERSESSION ROW (2026-11-02, MC 11918 T-3DR-CC2 — replace-not-delete):**
> this REV-2 supersedes docs/RIG-DEVIATION-3DR.md (T-3DR-r, MC 11773) for its off-by-
> one CLAIM rows ONLY: the old header + FINAL rows read "9 RIGGED / 4 STATIC" beside
> their OWN 13-row table that measures **10 rigged / 3 static** (the old FINAL row
> even named exactly THREE statics beside "4 static"); the reminted roster-clips CSV
> carries 10 rigged classes x 6 + 3 double-fail statics x 2, test_motion asserts the
> 3 null CLIP_SOURCE statics, and docs/RELEASE-v4.0.0.md :127-128 named the
> off-by-one at release (its refuting quote stands, dated). The old copy is ARCHIVED
> with the doctrine's DO-NOT-USE marker at docs/superseded/RIG-DEVIATION-3DR.md
> (versioned-truth, owner ruling 2026-10-22). Its 13-row TABLE is carried VERBATIM
> below — the B-E8/K-E3 parsers read these rows and the table bytes moved UNCHANGED
> (parse legs GREEN, capture .tmp/cc2.txt). docs/RIG-DEVIATION-SEL-C.md stays dated
> lineage with its own supersession rows. The test_motion leg
> test_rig_pin_doc_claim_matches_its_table pins header-claim == table-count: the
> off-by-one class now has a permanent RED instrument.

PIN ARTIFACT for builders/testers (B-E8 / K-E3 / MV-E4 re-pin family; the B-E8/K-E3
doc parse re-pins HERE, dated 2026-11-02, MC 11918). State of the FULL 13-class
roster under 3DR, MEASURED against this doc's own table:
**10 RIGGED / 3 STATIC** — the six statue re-master classes (3DR-a meshes, the
T-3DR-r rig pass) flip THREE of the six M5 statics (char-tallow-seer, skin-tide,
skin-void now ship walk + attack named glTF animations through the existing
`tools/mocap` 05/06 CMU chain, `assets/anim/maps/<name>.json` committed per S2r
precedent); the other three stay static below; the seven M5-era rows are HOLD-by-law
(byte-unchanged meshes, states CARRIED from docs/RIG-DEVIATION-SEL-C.md, not
re-attempted on the T-3DR-r card).

Owner ratification chain (the ONLY authority for static rows):
- 2026-10-29 owner ruling, verbatim (M6-SPEC §1.5 RESOLVED, option (c) re-master+re-rig):
  **"Ibwant skeletons with movements. 2. Rec. 3. Ship. Ratufy"**
- this milestone's package answer, verbatim (MC 11773 card prompt, package item 3,
  owner "Rec" 2026-10-31): **"UniRig seed 12345, TWO-FAIL STOP per char -> static+procedural fallback, never a broken animation; fallback rows named in docs"** — that is the
  OWNER-RATIFIED STATIC FALLBACK this doc's STATIC rows land under (kept static look +
  shipped procedural motion = the shipped M5 behavior).

Rig law carried: UniRig-2D at FIXED seed 12345 (fleet law — same mesh + seed is
deterministic, retries reproduce); per-class TWO-FAIL STOP (§3.3: rig attempt + ONE
retry, then STOP, no further burns); the shipped validators are the truth (LAW-ARTIFACTS).
Per-window evidence + both-failure transcripts: capture `.tmp/3dr.txt`.

| # | asset | state | reason (static rows) / evidence (rigged rows) |
|---|-------|-------|------------------------------------------------|
| 1 | char-emberwright.glb | RIGGED walk+attack | — (M5-era row CARRIED, HOLD; mesh byte-unchanged since MC 11440) |
| 2 | char-grave-ward.glb | RIGGED walk+attack | — (M5-era row CARRIED, HOLD) |
| 3 | char-coinhound.glb | STATIC (v3 file) | rig-stage double-fail on the 3DR-a v3 mesh (mesh GREEN seed 803 first-seed, all gates): UniRig seed 12345 emits a deterministic **30-joint QUADRUPED-topology** skeleton — the two leg columns parent UNDER bone_1 (LowerBack, not the root), a 4-chain head/snout cluster + a tail chain fan off the shoulder joint; the shipped 05 humanoid rules (arms off the spine, legs off the root) then read all 11 chains as arms -> `cmu LeftShoulder double-mapped` assert, TWICE (22:58:26Z / 23:10:37Z windows, identical tree, identical assert). Not a low-bone collapse (30 joints) and NOT the mesh: the TOPOLOGY UniRig infers from hound-class geometry is undrivable by the one humanoid CMU ruleset; a hand-authored map is a second mechanism AND hips-at-foot + quad tree under humanoid clips is exactly the owner-vetoed broken-animation shape. Owner package item 3 artifact above. |
| 4 | char-duskrunner.glb | RIGGED walk+attack | — (M5-era row CARRIED, HOLD) |
| 5 | char-tallow-seer.glb | RIGGED walk+attack | **FLIPPED from the M5 STATIC row by the 3DR re-master**: 3DR-a v3 mesh (seed 805 first-seed) + UniRig seed 12345 -> 22-joint mapped humanoid (map mapped=22, target_unmapped=0, `assets/anim/maps/char-tallow-seer.json`), CMU walk 07_01 + attack 02_05 via tools/mocap 05/06, 04-validate rigged PASS + red-control, VISUAL PASS, post-merge TRIS 9545 (= 9465 + the 80-tri importer phantom, M5r ghost law), 4-yaw turntable SOLID. Frame-diff (roster_capture.gd through capture_lib, judged by roster_clip_gate law): walk 124289/137187 px, attack 60877/69390 px, frozen controls 0/0 px. Twin `godot/assets/glb/char-tallow-seer-rigged.glb` sha256[:16] 8082ac0f62af0d24. |
| 6 | char-iron-penitent.glb | RIGGED walk+attack | — (M5-era row CARRIED, HOLD) |
| 7 | char-shroud-saint.glb | STATIC (v3 file) | rig-stage double-fail on the 3DR-a v3 mesh (mesh GREEN seed 807 first-seed): UniRig seed 12345 emits a deterministic **15-joint vertical BELL SLAB** — 5-joint spine chain + TWO 1-joint toe stubs (bone_13/14) under the Hips root + two arm chains hanging off the Neck joint (excluded by shipped R5: arms attach at/below Spine1); map = 7 roles only (no UpLeg/Leg/Foot, no arms); 06 retarget then hits its parent-chain law TWICE (23:22:04Z / 23:27:38Z, identical): "parent mismatch: target bone_0->bone_13 wants cmu Hips, source parent chain LeftFoot <- LeftLeg". Same sealed-drape collapse family as the SEL-C row 7 ("9-bone single vertical chain") — the opened drape changed the look, not the inferred topology. Owner package item 3 artifact above. |
| 8 | char-hoard-wretch.glb | STATIC (v7 file) | rig-stage double-fail on the 3DR-a v7 mesh (mesh GREEN seed 808 first-seed): UniRig seed 12345 emits a deterministic **44-joint mis-read** — the two side columns tail-align to Leg/Foot/ToeBase with NO UpLeg/HipJoint (06: "parent mismatch ... source parent chain LeftUpLeg <- LHipJoint", 23:32:05Z / 23:39:22Z identical), while the spine fan carries arm chains ending in FOUR-FINGER CLAW FANS (bone_14..25 / bone_30..41 — the open-claw class persists under ref-v7's block fists). Same MIS-READ class as the SEL-C row 8 ("41 bones but NO leg chains"). Owner package item 3 artifact above. |
| 9 | skin-ash.glb | RIGGED walk+attack | — (M5-era row CARRIED, HOLD; map carries its Neck1-dropped adjustment) |
| 10 | skin-marrow.glb | RIGGED walk+attack | — (M5-era row CARRIED, HOLD) |
| 11 | skin-tide.glb | RIGGED walk+attack | **FLIPPED from the M5 STATIC 3-bone collapse by the 3DR fused-lantern bell-robe re-master**: 3DR-a v3 mesh (seed 813 first-seed) + UniRig seed 12345 -> skins=1 RIG_VALID=PASS, map mapped=22 target_unmapped=6 cmu_unmapped=9 (`assets/anim/maps/skin-tide.json`, 28/22/6), CMU 07_01/02_05 via 05/06, 04-validate rigged PASS (168 channels) + red-control, VISUAL PASS, post-merge TRIS 9271 (= 9191 + 80 ghost), turntable SOLID + TEXTURED (teal robe, wave relief, lantern block). Frame-diff: walk 137454/150212 px, attack 79156/85519 px, frozen 0/0 px. Twin `godot/assets/glb/skin-tide-rigged.glb` sha256[:16] b46195bd34ecff37. |
| 12 | skin-relic.glb | RIGGED walk+attack | — (M5-era row CARRIED, HOLD; exactly the player's 34-joint reference) |
| 13 | skin-void.glb | RIGGED walk+attack | **FLIPPED from the M5 STATIC 3-bone collapse by the 3DR split-robe re-master**: 3DR-a v6 mesh (seed 815 first-seed) + UniRig seed 12345 -> skins=1 RIG_VALID=PASS, map mapped=22 target_unmapped=12 cmu_unmapped=9 (`assets/anim/maps/skin-void.json`, 34/22/12), CMU 07_01/02_05 via 05/06, 04-validate rigged PASS (204 channels) + red-control, VISUAL PASS, post-merge TRIS 9367 (= 9287 + 80 ghost), 4-yaw turntable SOLID + TEXTURED (dark cowl, block fists, plinth). Frame-diff: walk 117183/129995 px, attack 65739/75838 px, frozen 0/0 px. Twin `godot/assets/glb/skin-void-rigged.glb` sha256[:16] 77a4958ef5791e8f. |

FINAL 3DR STATE (REV-2, measured): **10 rigged / 3 static** — statics: char-coinhound, char-shroud-saint,
char-hoard-wretch (rows above, each a measured rig-stage DOUBLE-FAIL under the TWO-FAIL
STOP; EXCUSED-not-removed, procedural motion ships) + the six-class promise "3 flips" —
char-tallow-seer, skin-tide, skin-void now RIGGED through the ONE consumer path (flip +
CLIP_SOURCE rows land on T-3DR-c, this doc is its pin (REV-2)). Rig-yield 3/6 on FIRST SEED,
zero third attempts, mesh-stage reserve UNTOUCHED. §3.3's honest-odds row (LOW for the
shroud/quadruped/wing classes) stands measured.

Bone-count note (M5 §3.1 honest row CARRIED): the 34-joint player row is the reference;
UniRig counts are per-asset — this card's rigged rows (map JSON fields: target_joints /
mapped / target_unmapped): char-tallow-seer 22/22/0, skin-tide 28/22/6, skin-void 34/22/12
(all up-axis Z, side-axis X, the same 22-role CMU map scale as the shipped rows).
The observable gate is the shipped named animations + skin data, measured per mesh in
`.tmp/3dr.txt` (per-window LAW rows, both-failure transcripts, framediff legs).

## §Gate-lab supersession — interior-strip law for art bakes (MC 12334, 2026-11-09)

The gate-lab verdicts (MC 12319 probe, MC 12320 stripper — pinned under
`.audits/20261109-1115-gate-lab/out/`, verdict files TEST-verdict-P1/P2.md) are
PIPELINE LAW for NEW bakes as of this commit:

* The community claim "TRELLIS.2 outputs carry a hidden duplicate inner surface"
  measured TRUE on ours (interior-fraction 0.9533/0.9700 at full resolution on
  both config outputs; solid-sphere control 0.0).
* The standing bake path (tools/vm100/batch_trellis.py) now runs EVERY export
  through the two-pass seam tools/art/trellis_bake_wrap.py: remesh+decimate ->
  CPU strip (tools/art/interior_strip.py, roof rule) -> probe gate (must read
  CLEAN or the bake is REFUSED) -> re-bake on the stripped mesh. The probe's
  --selftest calibration contract gates the process (controls fail => no bake).
* ALREADY-SHIPPED ASSETS ARE NOT AUTO-STRIPPED. The 16 hold-sweep md5s stay
  untouched (LEDGER hold rows); re-mastering existing GLBs rides MC 12335
  (emberwright first). This doc row changes NEW bakes only.
* The GPU-leg proof of the seam (real o_voxel bake, texture parity on a real
  asset) is MC 12335's card, not this one: this commit lands the seam, the
  instruments and the CPU parity tests (tests/test_art_interior_gate.py).
