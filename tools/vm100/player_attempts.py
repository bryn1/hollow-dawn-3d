#!/usr/bin/env python3
"""MC 11118 — player-row quality attempts (post-batch discovery: TRELLIS collapsed the
dark-robed player sprite on seeds 17 (flat card, y-extent 0.002 m) and 30 (solid box,
fill 0.80 of bbox). Same batch_trellis.py generator per attempt; this driver adds the
MISSING quality gates (tri budget alone passed those failures):
  gate1 extent: min(x,y,z) > 0.05 * max(x,y,z)      — rejects flat cards/sprites
  gate2 fill:   mesh_volume / bbox_volume <= 0.60    — rejects solid slabs (slab=0.80)
Concept render per attempt is written next to the glb (<name>-render.png).
Usage: player_attempts.py <sprite.png> <seeds csv> [base=player]"""
import os, subprocess, sys, tempfile
sys.path.insert(0, "/opt/imagegen/venv3d/lib/python3.10/site-packages")
import trimesh

sprite, seeds, base = sys.argv[1], sys.argv[2].split(","), sys.argv[3] if len(sys.argv) > 3 else "player"
OUT = "/opt/imagegen/output/mc11118"

for s in (int(x) for x in seeds):
    name = f"{base}-s{s}"
    spec = tempfile.NamedTemporaryFile("w", suffix=".tsv", delete=False)
    spec.write(f"{name}\t{sprite}\t8000\t{s}\n")
    spec.close()
    p = subprocess.run(["/opt/imagegen/tmp/mc11118/run-batch-inner.sh", spec.name])
    glb = f"{OUT}/{name}.glb"
    ok = False
    if p.returncode == 0 and os.path.exists(glb):
        m = trimesh.load(glb, force="scene")
        sub = [g for g in m.geometry.values() if len(g.faces) > 10]
        m = sub[0] if len(sub) == 1 else trimesh.util.concatenate(sub)
        ext = m.extents
        fill = abs(m.volume) / max(ext.prod(), 1e-9) if m.is_watertight else float("nan")
        g1 = float(ext.min()) > 0.05 * float(ext.max())
        g2 = (not (fill == fill)) or fill <= 0.60  # NaN (non-watertight) passes g2
        print(f"QUALITY {name}: ext={ext[0]:.3f},{ext[1]:.3f},{ext[2]:.3f} "
              f"fill={'watertight %.2f' % fill if fill == fill else 'non-watertight'} "
              f"ext_gate={'PASS' if g1 else 'FAIL'} fill_gate={'PASS' if g2 else 'FAIL'}")
        ok = g1 and g2
    subprocess.run(["/opt/imagegen/venvrig/bin/python", "/opt/imagegen/tmp/mc11118/dump_render.py",
                    glb, f"{OUT}/{name}-render.png", "8000"],
                   stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    print(f"ATTEMPT seed={s} -> {'ACCEPT' if ok else 'REJECT'}\n", flush=True)
    if ok:
        print(f"ACCEPTED-SEED={s}")
        break
print("ATTEMPTS-DONE")
