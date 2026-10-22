# LEDGER — hollow-dawn-3d
- master @ seed; repo created 2026-10-21 (owner ruling: own repo + own releases, verbatim in run goal.md)
- run dir: ../.audits/$(basename $RUN) era 2026-10-21; parent MC 11094
STATUS: EXECUTION (design phase CLOSED 2026-10-21/22: DESIGN-3D@db743a4 + DOD-ACCEPTANCE@52ade44 pinned via merge 83c1f27, DA gate 4 cycles c4 SHIP run 202610211928; build stages S1/S3 starting; DINOv3 HF-gate owner-approval pending for TRELLIS leg)

- S3 core loop MERGED 606405d (MC 11101): ortho rig 30@20deg, biome bands, v1-verbatim data layer, gait stub, headless sim (gameover 467.083 / WIN 600.017), suite 39/39.
- S4 combat MERGED 9496ea2 (MC 11102): 6 weapon FX classes 7 draws, per-sample caps 0/601 violations, per-weapon kills, RUN-CONDITIONED halo owned t=26.9, suite 52/52.
- S5 card UI MERGED 58e31e1 (MC 11103): 12/12 skill icons (5 new 3090 imagegen + provenance), blank path structurally closed, Xvfb render proof, suite 61/61.
- S6 boss MERGED 57b8f7f (MC 11107): Warden t>=540 hp_base 3000 (spawn rides v1 ramp — parity, R3), HUD bar render.gd:194-207 verbatim, guaranteed Dawnlight+50g via direct-kill leg (pickup-consumption reading declared), 7 planted-red proofs, suite 71/71.
- A5 OPEN rows (S1/S2-dependent): skinned-boss clip + <=15000 tri + frame-diff >=2px + boss-bar PIXEL proof (live-node-state proven now).
- T-P2-1 3D-art stack DONE (MC 11096, infra, 2026-10-22): TRELLIS.2 + UniRig installed on vm100 (one imagegen spine, no second zoo); PoC assets/poc/ghoul.glb (43.6MB, VISUAL_VALID=PASS) + ghoul-rigged.glb (57.7MB, RIG_VALID=PASS skins=1 joints=34, textures survive merge); DINOv3 gate RESOLVED (owner accepted as token-account Lekis; no mirrors); tools/vm100/ = installs+run+validators; capture .tmp/stack-install-p2-1.txt VERIFY_EXIT=0; GPU windows all trap-closed, llama-swap active. Honest: rig is auto-assigned generic 34-bone skeleton (non-human form) — skinning valid, semantics unassigned.
