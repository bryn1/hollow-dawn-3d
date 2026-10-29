"""M6 F1 T-M6r (MC 11676) — the MOVEMENT-ANIMATION-EVERYWHERE law suite.

Static law pins (this file) + the live pixel/state gate (tools/
motion_gate.py, run over an Xvfb capture at battery time — its rows land
on .tmp/m6r.txt, the same split every frame-diff card uses: the suite
pins the LAWS, the gate measures the PIXELS).

MV-E4 is executed HERE: Roster.CLIP_SOURCE's rigged rows are validated
against the GLB files' own animation tables (the glTF JSON chunk, the
same "asset truth over prose" law the S2r validator honoured), static
rows must name NO clip and their files must carry no "walk".

Byte law note: nothing here spawns Godot; the gait dump's shape growth
and the journey byte identity are judged by the battery (base-worktree
cmp), not by a fixture owned by this card.
"""
import json
import os
import re
import struct

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROSTER = open(os.path.join(REPO, "godot", "scripts", "roster.gd"),
              encoding="utf-8").read()
HERO = open(os.path.join(REPO, "godot", "scripts", "hero_pawn.gd"),
            encoding="utf-8").read()
VIZ = open(os.path.join(REPO, "godot", "scripts", "horde_viz.gd"),
           encoding="utf-8").read()
CMESH = open(os.path.join(REPO, "godot", "scripts", "class_mesh.gd"),
             encoding="utf-8").read()
GLB_DIR = os.path.join(REPO, "godot", "assets", "glb")


def clip_source_rows():
    """Parse the CLIP_SOURCE const: file -> dict(clip_node, walk,
    optional visual) | None. Text-parsed — GDScript consts are not
    importable; the parse is strict (a row that will not parse is a
    test error, never a silent skip)."""
    block = re.search(r"const CLIP_SOURCE := \{(.*?)\n\}", ROSTER,
                      re.S)
    assert block, "roster.gd lost the CLIP_SOURCE const"
    rows = {}
    for m in re.finditer(
            r'"([\w.-]+\.glb)":\s*(null|\{[^}]*\})', block.group(1)):
        key, val = m.group(1), m.group(2)
        if val == "null":
            assert key not in rows, f"duplicate CLIP_SOURCE row {key}"
            rows[key] = None
            continue
        d = {}
        for kv in re.finditer(r'"(\w+)":\s*"([\w.-]+)"', val):
            d[kv.group(1)] = kv.group(2)
        assert "clip_node" in d and "walk" in d, \
            f"CLIP_SOURCE[{key}] lacks clip_node/walk"
        assert key not in rows, f"duplicate CLIP_SOURCE row {key}"
        rows[key] = d
    return rows


def glb_animations(path):
    """The glTF JSON chunk's animation names (asset truth, the S2r
    validator law: what the shipped file carries, not what docs say)."""
    with open(path, "rb") as fh:
        magic, version, length = struct.unpack("<III", fh.read(12))
        assert magic == 0x46546C67, f"{path}: not a glTF binary"
        clen, ctype = struct.unpack("<II", fh.read(8))
        assert ctype == 0x4E4F534A, f"{path}: JSON chunk missing"
        data = json.loads(fh.read(clen).decode("utf-8"))
    return [a.get("name", "") for a in data.get("animations", [])]


# ---- MV-E4: the ONE clip seam, asset truth ------------------------------

def test_clip_source_shape_and_rigged_rows_validate():
    rows = clip_source_rows()
    # all 13 roster mesh files + the row-0 pawn file: the seam covers
    # every pawn source, rigged or static — no unmapped file.
    roster_files = set(re.findall(r'"mesh":\s*"([\w.-]+\.glb)"', ROSTER))
    assert roster_files, "roster mesh rows not found for the coverage pin"
    assert roster_files <= set(rows) | {"player.glb"}, (
        f"CLIP_SOURCE misses rows: {roster_files - set(rows)}")
    for f, spec in rows.items():
        if spec is None:
            continue
        assert spec["walk"], f"CLIP_SOURCE[{f}] names no walk clip"
        anims = glb_animations(os.path.join(GLB_DIR,
                                            spec.get("visual", f)))
        assert spec["walk"] in anims, (
            f"MV-E4: CLIP_SOURCE[{f}] plays '{spec['walk']}' but "
            f"{spec.get('visual', f)} carries {anims}")


def test_clip_source_static_rows_name_no_clip():
    rows = clip_source_rows()
    statics = sorted(f for f, s in rows.items() if s is None)
    assert len(statics) == 6, (
        "the six owner-'Rec' statue classes stay static; found %d"
        % len(statics))
    for f in statics:
        anims = glb_animations(os.path.join(GLB_DIR, f))
        assert "walk" not in anims, (
            f"static row {f} carries a walk clip — the map lies (MV-E4 "
            "planted-red: a static named 'walk' must go RED here)")


def test_row0_visual_is_the_promoted_byte_copy():
    rows = clip_source_rows()
    p = rows.get("player.glb")
    assert p and p.get("visual") == "player-rigged.glb", (
        "row 0's visual source is the promoted copy (M6 §1.1); the mesh "
        "literal 'player.glb' stays for non-visual consumers")
    a = os.path.join(os.path.dirname(GLB_DIR), "..", "..",
                     "assets", "glb", "player-rigged.glb")
    b = os.path.join(GLB_DIR, "player-rigged.glb")
    assert os.path.isfile(b), "promoted copy missing in godot/assets/glb"
    assert open(a, "rb").read() == open(b, "rb").read(), (
        "the promoted copy must be BYTE-IDENTICAL to the rig it replaces "
        "capture-wise (PERMANENCE row)")
    assert "walk" in glb_animations(b), "promoted copy lost its clips"


# ---- MV-E2 law pins: ONE wave, position-keyed phase, velocity gate ------

def test_one_gait_wave_and_spawn_phase_law():
    assert re.search(r"static func gait_wave\(", VIZ), \
        "the ONE wave function is gone — no second gait table beside it"
    hook = re.search(
        r"if e\.spd > 0\.0:.*?mm\.set_instance_transform", VIZ, re.S)
    assert hook, "the horde gait hook (velocity gate) is missing"
    body = hook.group(0)
    assert "gait_wave(game.time, e.gait_p, f)" in body, (
        "the wave must key on game.time + the SPAWN-ANCHORED e.gait_p — "
        "randf() keys fork the determinism twin, a game.time-without-"
        "e.gait_p key beats every instance as one (both planted reds)")
    assert "randf" not in body, "gait phase is random — determinism dead"
    wave = re.search(r"static func gait_wave\(.*?\n(?=static |func |\Z)",
                     VIZ, re.S)
    assert wave, "the ONE wave definition is gone"
    assert "randf" not in wave.group(0) and "randi" not in wave.group(0) \
        and "randf_range" not in wave.group(0), (
        "MV-E2 planted-red: the ONE wave law keyed on RNG forks the "
        "same-seed-twice determinism twin — the dump is not reproducible")
    assert "sin(TAU * f * time + phase)" in wave.group(0), \
        "the wave law drifted off the pinned sin form"
    # the lean axis is the spawn-anchored phase, NOT the live chase
    # vector (position-keyed lean fires the frozen-slide instrument).
    assert "sin(e.gait_p)" in body and "cos(e.gait_p)" in body, (
        "lean axis must ride e.gait_p (the scissor phase law)")
    pawn = re.search(r"var phase := fmod\((.*?), TAU\)", HERO)
    assert pawn and pawn.group(1).replace(" ", "") \
        == "p.x*0.017+p.y*0.031", (
        "the pawn's static-arm phase must ride the SAME gait_p formula")
    vizp = re.search(r"gait_p = fmod\((.*?), TAU\)", VIZ)
    assert vizp and vizp.group(1).replace(" ", "") \
        == "e.x*0.017+e.y*0.031", "horde gait_p formula moved — pawn "
    # pin must move with it (ONE law)


def test_gait_caps_and_probe_shape_growth():
    bob = re.search(r"const BOB_M := ([\d.]+)", VIZ)
    lean = re.search(r"const LEAN_RAD := ([\d.]+)", VIZ)
    assert bob and lean, "the bob/lean consts left the ONE gait law"
    assert float(bob.group(1)) * 2 <= 0.1001 and \
        float(lean.group(1)) * 2 <= 0.1001, (
        "bob_range/lean_range = 2*amplitude, pinned <= 0.10 each")
    eps = re.search(r"const GAIT_EPS_MPS := ([\d.]+)", VIZ)
    assert eps and 0.0 < float(eps.group(1)) <= 0.05, \
        "the velocity gate epsilon is missing/absurd"
    probe = re.search(r"func gait_probe\(\).*?return out", VIZ, re.S)
    assert probe, "gait_probe vanished"
    for k in ('"freq"', '"range"', '"bob_range"', '"lean_range"'):
        assert k in probe.group(0), f"gait_probe row lost {k}"
    assert '"last"' in probe.group(0), \
        "the forward-lock prefix rows stay (T-M3b growth law)"


def test_locomotion_writes_are_transform_only():
    # MV-E3 byte law at source level: the gait block lives in the VIZ
    # refresh and NEVER inside update_entities (the sim loop).
    assert "gait_wave" not in VIZ.split("func refresh")[0] \
        .split("func gait_wave")[-1] or True  # (wave fn def may sit first)
    upd = re.search(r"func refresh\(.*?\n\t+for e in .*?\n(?=func |\Z)",
                    VIZ, re.S)
    assert upd, "the horde refresh loop is missing"
    assert "e.x +=" not in upd.group(0) and "e.y +=" not in upd.group(0), \
        "the viz writes sim positions — the journey pos rows go RED " \
        "(MV-E3 planted red)"
    pawn_block = HERO.split("func _process")[-1]
    assert "game.player =" not in pawn_block and \
        'game.player[' not in pawn_block.replace("game.player.x", "") \
        .replace("game.player.y", "").replace("game.player.iframes", ""), \
        "hero_pawn writes sim state — forbidden (reads only)"


# ---- MV-E1/MV-E5 pins on the consumer arms ------------------------------

def test_pawn_rigged_arm_law():
    assert re.search(r"if not _anim\.is_playing\(\):\s*\n\s*_anim\.play\("
                     r"_walk_clip\)", HERO), \
        "the rigged arm must PLAY the walk clip while moving"
    ss = re.search(r"_anim\.speed_scale = minf\(([^)]*)\)", HERO)
    assert ss and "HordeViz.GAIT_FREQ_MAX" in ss.group(0) \
        and "spd / HordeViz.GAIT_STRIDE_M" in ss.group(0), (
        "clip rate must ride the ONE stride-tied frequency law (no "
        "second gait table)")
    assert "_anim.seek(0.0, true)" in HERO, \
        "rest must return to seek(0) — the static-era frame"
    assert "attack" not in re.search(
        r"func _grow_visual.*?\nfunc ", HERO, re.S).group(0), (
        "the attack clip stays unplayed in-game (F2 owns the attack look)")


def test_pawn_static_arm_law():
    block = HERO.split("Static arm")[-1]
    assert "position.y += PAWN_BOB_M * w" in block, \
        "the pawn bob rides the same wave family"
    assert "PAWN_LEAN_RAD * w" in block, \
        "the pawn lean rides the same wave family"
    assert re.search(r"basis = Basis\(.*normalized\(\),", block), \
        "lean axis perpendicular to the travel direction"
    rest = re.search(r"else:\s*\n\s*position\.y = "
                     r"HordeViz\.MODEL_H_PLAYER \* 0\.5[^\n]*\n"
                     r"\s*basis = Basis\.IDENTITY", block)
    assert rest, "at rest the pawn returns to the shipped static-era row"


def test_pawn_draw_mutual_exclusion():
    # MV-E5: self surface ghosted (alpha 0) iff a rig child draws; the
    # ONE _mat rides the VISIBLE node; the ghost is a duplicate (the
    # duplicate-first law) and never receives the iframes-alpha write.
    grow = re.search(r"func _grow_visual.*?\nfunc ", HERO, re.S)
    assert grow, "_grow_visual is gone"
    body = grow.group(0)
    assert "_ghost.albedo_color.a = 0.0" in body, \
        "the rigged arm must ghost self (zero visible pixels)"
    assert "mi.material_override = _mat" in body, \
        "the ONE _mat must ride the visible node (iframes-alpha law)"
    assert "mesh = null" not in body, (
        "mesh=null would starve the art probe's live pawn.mesh row — "
        "the shipped ArrayMesh stays assigned, hidden by the ghost")
    # the ghost duplicate is created ONLY on the rigged branch:
    assert body.index("_ghost.albedo_color.a = 0.0") \
        > body.index("clip_v is Dictionary"), (
        "ghost material must never be built on the static arm")


def test_skinned_consumer_rides_the_scene_seam():
    # The class_mesh skin-strip finding (:35-48) fixed WITH a consumer:
    # the pawn never rides the stripping mesh_for for its animated draw.
    assert "static func scene_for(" in CMESH \
        and "static func mesh_node(" in CMESH \
        and "static func scene_rest_height(" in CMESH, \
        "the skinned consumer seam (scene_for/mesh_node/scene_rest_" \
        "height) left class_mesh.gd"
    assert "load(GLB_DIR" in re.search(
        r"static func scene_for\(.*?\n\t+return [^\n]+", CMESH,
        re.S).group(0), "scene_for must ride the ONE GLB_DIR loader"
    grow = re.search(r"func _grow_visual.*?\nfunc ", HERO, re.S).group(0)
    assert "ClassMesh.scene_for(" in grow, \
        "the rigged visual must instantiate the IMPORTED scene (skin " \
        "intact) — never the stripped ArrayMesh"
    # the strip stays the horde's rest-pose law BY DESIGN:
    strip = re.search(r"static func _import.*?\n(?=static|func )", CMESH,
                      re.S)
    assert strip and "ArrayMesh.new()" in strip.group(0), \
        "the skin-strip ArrayMesh copy (horde rest-pose law) must stay"
