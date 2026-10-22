"""A7 icon gate (MC 11103 T-S5): the 12 upgrade-card pool kinds must each
resolve to a NON-BLANK icon file. Source-truth suite convention (see
test_game_numbers.py header): the .gd files are read as text — the offer
dicts levelup.gd builds are mirrored here from the same source, and the
icon resolver is the PASSIVE_ICONS table + path rule regexed out of
screens.gd, so this file fails if either side drifts.

Rows (DOD-ACCEPTANCE A7 + N45): 6 weapon icons + coin REUSE v1
static/assets PNGs byte-identical (MANIFEST.md:28-33,35); 5 passive icons
are the NEW 3090 renders — 512x512 RGBA with embedded prompt provenance
(PIL .text). The v1 blank-icon path (levelup.gd "icon": "") must be
structurally unreachable: screens.gd has NO conditional guarding the icon
TextureRect, the resolver is total over the 12 kinds, and PASSIVES ==
PASSIVE_ICONS keys is pinned here.
"""

import hashlib
import os
import re

import conftest
from PIL import Image

SCRIPTS = os.path.join(conftest.REPO, "godot", "scripts")
GODOT = os.path.join(conftest.REPO, "godot")
V1_ASSETS = "/home/claudecode/Games/vampire_survivor/static/assets"
NEW_SRC = os.path.join(conftest.REPO, "assets", "icons", "new")

WEAPON_KEYS = ["talon", "ember", "cleaver", "halo", "ward", "spike"]
NEW_KEYS = ["ferocity", "haste", "ward", "grip", "insight"]


def read(name):
    with open(os.path.join(SCRIPTS, name), encoding="utf-8") as fh:
        return fh.read()


WEAPONS = read("weapons.gd")
LEVELUP = read("levelup.gd")
SCREENS = read("screens.gd")


def res_to_fs(res_path):
    assert res_path.startswith("res://"), res_path
    return os.path.join(GODOT, res_path[len("res://"):])


# ---- the resolver mirrored out of screens.gd (single source of truth) ----

ICONS_TABLE = dict(
    re.findall(r'"(\w+)":\s*"(res://assets/icons/passives/[\w./-]+\.png)"', SCREENS)
)
ICON_PATH_RULE = re.search(
    r'"(res://assets/icons/%s\.png)"\s*%\s*card\.icon', SCREENS
)
FALLBACK = re.search(r'const FALLBACK_ICON := "(res://[\w./-]+\.png)"', SCREENS)


def resolve_icon(kind, key=None, icon=None):
    """Mirror of screens.gd icon_path() for the 12 pool kinds."""
    if ICON_PATH_RULE is None or FALLBACK is None:
        raise AssertionError("screens.gd lost its total icon resolver")
    if kind == "passive":
        return res_to_fs(ICONS_TABLE[key])
    return res_to_fs(ICON_PATH_RULE.group(1) % icon)


# ---- 12 kinds, straight out of the offer source ----

def meta_icons():
    """weapons.gd META: {id: icon} for the 6 weapon kinds (kind weapon and
    kind upgrade share these icons, levelup.gd build_pool)."""
    table = dict(
        re.findall(r'"(\w+)":\s*\{.*?"icon":\s*"([\w-]+)"', WEAPONS, re.S)
    )
    assert sorted(table) == sorted(WEAPON_KEYS), table
    return table


def passive_keys():
    block = re.search(r"const PASSIVES := \[(.*?)\]\n", LEVELUP, re.S).group(1)
    return re.findall(r'"key":\s*"(\w+)"', block)


def bonus_icon():
    return re.search(
        r'"kind":\s*"bonus".*?"icon":\s*"([\w-]+)"', LEVELUP, re.S
    ).group(1)


# ---- structural: the blank-icon path is impossible ----

def test_no_conditional_icon_branch():
    """v1's `if card.icon != "":` guard (levelup.gd:35 gap) must not return."""
    assert re.search(r"if\s+card\.icon", SCREENS) is None
    m = re.search(r"func _card\(.*?\n(?=\nfunc |\Z)", SCREENS, re.S)
    body = m.group(0)
    assert re.search(r"var\s+icon\s*:=\s*TextureRect\.new\(\)", body)
    assert re.search(r"icon\.texture\s*=\s*load\(", body)
    # the TextureRect sits at function level — no enclosing if:
    icon_line = [ln for ln in body.splitlines() if "TextureRect.new()" in ln][0]
    assert not icon_line.startswith("\t\t"), "icon creation re-nested under a branch"


def test_resolver_asserts_existence():
    assert "assert(ResourceLoader.exists(" in SCREENS
    assert "assert(PASSIVE_ICONS.has(" in SCREENS


def test_passives_table_pinned_to_pool():
    """PASSIVES (levelup.gd) == PASSIVE_ICONS (screens.gd) keys, both orders."""
    assert sorted(passive_keys()) == sorted(NEW_KEYS)
    assert sorted(ICONS_TABLE) == sorted(passive_keys())


# ---- per-kind: file exists, non-empty, dims right, provenance kept ----

def test_all_12_kinds_resolve_to_real_icons():
    rows = []
    for icon in meta_icons().values():
        rows.append(resolve_icon("weapon", icon=icon))
    for key in passive_keys():
        rows.append(resolve_icon("passive", key=key))
    rows.append(resolve_icon("bonus", icon=bonus_icon()))
    assert len(rows) == 12
    for path in rows:
        assert os.path.isfile(path), path
        assert os.path.getsize(path) > 0, path


def test_new_icons_512_rgba_with_provenance():
    for key in NEW_KEYS:
        path = resolve_icon("passive", key=key)
        im = Image.open(path)
        assert im.size == (512, 512), (path, im.size)
        assert im.mode == "RGBA", path
        assert im.text.get("impeccable:prompt", "").strip(), \
            "%s lost its embedded prompt provenance" % path


def test_reused_icons_byte_identical_to_v1():
    for icon in meta_icons().values():
        src = os.path.join(V1_ASSETS, icon + ".png")
        dst = resolve_icon("weapon", icon=icon)
        _assert_same_bytes(src, dst)
    src = os.path.join(V1_ASSETS, bonus_icon() + ".png")
    _assert_same_bytes(src, resolve_icon("bonus", icon=bonus_icon()))
    # dims = source dims (A7: "source dims for reused")
    for icon in list(meta_icons().values()) + [bonus_icon()]:
        src = Image.open(os.path.join(V1_ASSETS, icon + ".png"))
        dst = Image.open(resolve_icon("weapon", icon=icon))
        assert src.size == dst.size


def test_new_icons_byte_identical_to_art_source():
    for key in NEW_KEYS:
        src = os.path.join(NEW_SRC, "icon-%s.png" % key)
        _assert_same_bytes(src, resolve_icon("passive", key=key))


def test_card_frame_reused_byte_identical():
    src = os.path.join(V1_ASSETS, "card-frame.png")
    dst = os.path.join(GODOT, "assets", "card-frame.png")
    _assert_same_bytes(src, dst)
    assert re.search(r'load\("res://assets/card-frame\.png"\)', SCREENS)


def _assert_same_bytes(src, dst):
    assert os.path.isfile(dst), dst
    with open(src, "rb") as fh:
        a = hashlib.sha256(fh.read()).hexdigest()
    with open(dst, "rb") as fh:
        b = hashlib.sha256(fh.read()).hexdigest()
    assert a == b, "not byte-identical: %s != %s" % (src, dst)


# ---- offer-shape mirror: the dicts levelup.gd builds carry the fields
# this test resolves on (weapon/upgrade: id+icon; passive: key; bonus: icon)

def test_offer_dict_shape():
    assert re.search(r'"kind":\s*"weapon".*?"icon":\s*meta\.icon', LEVELUP, re.S)
    assert re.search(r'"kind":\s*"upgrade".*?"icon":\s*meta\.icon', LEVELUP, re.S)
    assert re.search(r'"kind":\s*"passive",\s*"key":\s*passive\.key', LEVELUP)
    # passive cards STILL carry icon: "" (levelup.gd not forked) — the gap is
    # closed in screens.gd, by the total resolver, not by editing the pool.
    assert re.search(r'"icon":\s*""', LEVELUP)
