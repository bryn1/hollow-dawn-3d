# Offer-gating legs for the carry caps (T-M1b, MC 11206; PARITY-ROADMAP rev3
# M1 feature 3 ACCEPT rows). Same headless funnel as art_probe/sim_headless:
# the REAL Main.tscn, screens stubbed, the run started through the real
# _start_game. Per leg the loadout is pinned into game.weapons/game.passives
# — the DECLARED-PIN construction channel §2 names verbatim (the
# sim_boss.gd:215 pattern) — then the REAL offer funnel runs 100 times:
# pending_levels = 1 -> _enter_levelup() (the exact call _step makes at
# main.gd:183) dumps _current_offer -> decline (sim_boss._decline). ROSTER
# note (T-M1h, MC 11220): the roster is now 16
# weapon KINDS + 15 passive KINDS, so the full-slots / full-kinds caps are
# NON-VACUOUS with real entries (10 weapons and 9 kinds stay un-carried) —
# the two synthetic pins below still ride as DECLARED carriers of the exact
# 6th slot / 6th kind (sim_caps precedent), and the new passive_roster_kind
# leg proves the cap on NEW (feature-6) kinds with fully REAL pins. Rows:
# caps_leg (the pin + counts), one caps_offer per offer, caps_gate per leg,
# caps_verdict last. Checks:
# weapon_full_slots / weapon_all_six_real: zero kind:"weapon" rows AND
# kind:"upgrade" rows present (owned-weapon upgrades stay offerable at 6
# carried); weapon_below_cap: the un-carried kinds ARE offered at 5 slots
# and no CARRIED kind leaks as a new-weapon row; passive_full_kinds: the
# un-carried KIND is never offered at 6 kinds while carried-kind upgrades
# stay; passive_below_kinds: the new KIND is offered below the cap;
# passive_stack_cap_edge: a carried kind at the 5-stack cap is gone while
# one at 4 stacks stays; passive_roster_kind: at 6 carried KINDS (three of
# them feature-6 partners, all REAL) the 7th NEW kind is never offered
# while a carried NEW-kind upgrade stays offerable. Seed-pinned
# (HD3D_SEED, default 11206) — the dump is byte-stable; the committed copy
# gates test_levelup_caps.py.
extends SceneTree

const OFFERS := 100 # roadmap: "100 dumped offers"
const SLOT_PIN_ID := "m1b-pin-slot" # synthetic 6th weapon slot (declared)
const KIND_PIN_KEYS := ["m1b-pin-kind-a", "m1b-pin-kind-b"] # synthetic
	# carried passive KINDS (declared) — the roster has only 5 real kinds
const OFFER_SEED := 11206

var _main: Node
var _out: FileAccess
var _rows: Array = []
var _started := false
var _frames := 0
var _ok := true


func _process(_delta: float) -> bool:
	_frames += 1
	if not _started:
		_started = true
		var d: String = OS.get_environment("HD3D_CAPS_DUMP")
		_out = FileAccess.open(d if d != "" else "/tmp/hd3d-caps-dump.jsonl",
				FileAccess.WRITE)
		assert(_out != null)
		print("CAPS_START")
		_run()
	if _frames > 3:
		push_error("caps sim did not finish in one frame")
		quit(3)
		return true
	return false


func _run() -> void:
	var s := OS.get_environment("HD3D_SEED")
	seed(s.to_int() if s != "" else OFFER_SEED)
	var packed: PackedScene = load("res://Main.tscn")
	_main = packed.instantiate()
	root.add_child(_main) # _ready wires the real scene + bridge (S3 pattern)
	var old: CanvasLayer = _main._screens
	_main.remove_child(old)
	old.queue_free()
	var stub := SimStubScreens.new()
	_main.add_child(stub)
	_main._screens = stub
	stub.start_pressed.connect(_main._start_game)
	stub.card_picked.connect(_main._pick)
	_main._start_game()
	_leg_weapon_full_slots()
	_leg_weapon_all_six_real()
	_leg_weapon_below_cap()
	_leg_passive_full_kinds()
	_leg_passive_below_kinds()
	_leg_passive_stack_cap_edge()
	_leg_passive_roster_kind()
	_emit({"ev": "caps_verdict", "ok": _ok})
	for r in _rows:
		_out.store_line(JSON.stringify(r))
	_out.close()
	print("CAPS_OK rows=%d ok=%s" % [_rows.size(), str(_ok)])
	quit(0 if _ok else 3)


# --- legs -------------------------------------------------------------------

func _leg_weapon_full_slots() -> void:
	# DECLARED pin (declared in the row): 5 real kinds + one synthetic slot
	# = 6 carried while a real kind (spike) stays un-carried — a DECLARED
	# carrier of the exact 6th slot (since T-M1h the roster has 16 kinds,
	# so weapon_all_six_real is non-vacuous too; this pin keeps the exact
	# synthetic-slot shape the T-M1b planted-red pair exercised). The
	# zero-weapon-rows check below can go RED (10 real kinds stay open).
	var pin := [["talon", 1], ["ember", 2], ["cleaver", 3], ["halo", 4],
		["ward", 5], [SLOT_PIN_ID, 1]]
	var cards := _offers_pin_weapons(pin)
	_gate("weapon_full_slots", pin, {}, cards, {
		"new_weapon_rows_zero": _count_kind(cards, "weapon") == 0,
		"upgrade_rows_present": _count_kind(cards, "upgrade") > 0,
	}, "DECLARED pin: synthetic 6th slot " + SLOT_PIN_ID)


func _leg_weapon_all_six_real() -> void:
	# The roadmap row read literally: scripted policy owns 6 real weapons
	# (the whole roster) -> zero kind:"weapon" rows, upgrades still offered.
	var pin := [["talon", 1], ["ember", 2], ["cleaver", 3], ["halo", 4],
		["ward", 5], ["spike", 6]]
	var cards := _offers_pin_weapons(pin)
	_gate("weapon_all_six_real", pin, {}, cards, {
		"new_weapon_rows_zero": _count_kind(cards, "weapon") == 0,
		"upgrade_rows_present": _count_kind(cards, "upgrade") > 0,
	}, "")


func _leg_weapon_below_cap() -> void:
	# <6 leg: at 5 carried slots the un-carried kinds ARE still offered —
	# the whole un-carried rest of the roster (T-M1h: 11 kinds, spike + the
	# ten feature-6 weapons), and no CARRIED kind ever leaks as a NEW-
	# weapon row (upgrade rows for carried kinds are the other kind).
	var pin := [["talon", 1], ["ember", 2], ["cleaver", 3], ["halo", 4],
		["ward", 5]]
	var cards := _offers_pin_weapons(pin)
	var leaks := 0
	for c in cards:
		if c.kind == "weapon":
			for r in pin:
				if c.id == r[0]:
					leaks += 1 # a carried kind must never appear as "weapon"
	_gate("weapon_below_cap", pin, {}, cards, {
		"new_weapon_offers_present": _count_kind(cards, "weapon") > 0,
		"new_weapon_only_uncarried_kind": leaks == 0,
	}, "")


func _leg_passive_full_kinds() -> void:
	# DECLARED pin (declared in the row): 4 real kinds @1 + 2 synthetic
	# carried kinds = 6 distinct KINDS already carried while insight (0
	# stacks) stays un-carried (the cap blocks the 7th KIND, never the 6th:
	# c2 N-3). The un-carried KIND must never be offered; carried-kind
	# upgrades stay (all @1 < the 5-stack cap). Since T-M1h the roster has
	# 15 real KINDS, so the full 12 other kinds may also never appear —
	# the passive_roster_kind leg pins that side with REAL entries.
	var pin := {"ferocity": 1, "haste": 1, "ward": 1, "grip": 1,
		KIND_PIN_KEYS[0]: 1, KIND_PIN_KEYS[1]: 1}
	var cards := _offers_pin_passives(pin)
	_gate("passive_full_kinds", [["talon", 1]], pin, cards, {
		"new_kind_rows_zero": _count_passive_key(cards, "insight") == 0,
		"carried_kind_rows_present": _count_passive_any(cards) > 0,
	}, "DECLARED pin: synthetic carried kinds " + KIND_PIN_KEYS[0] + " + " + KIND_PIN_KEYS[1])


func _leg_passive_below_kinds() -> void:
	# <6 leg, sitting exactly on the cap edge: 4 real kinds + 1 synthetic
	# = 5 carried — the 6th KIND IS still offered (the c2 N-3 reading: the
	# cap blocks the 7th, never the 6th; a cap that lands on 5 goes RED
	# right here).
	var pin := {"ferocity": 1, "haste": 1, "ward": 1, "grip": 1,
		KIND_PIN_KEYS[0]: 1}
	var cards := _offers_pin_passives(pin)
	_gate("passive_below_kinds", [["talon", 1]], pin, cards, {
		"new_kind_offers_present": _count_passive_key(cards, "insight") > 0,
	}, "")


func _leg_passive_stack_cap_edge() -> void:
	# The stack-cap edge (the unchanged MAX_PASSIVE_STACKS rule under the
	# kind cap): a carried kind at 5 stacks is gone from the pool, a carried
	# kind at 4 stacks is still offered (upgrades stay offerable up to the
	# 5-stack cap).
	var pin := {"insight": 5, "ferocity": 4}
	var cards := _offers_pin_passives(pin)
	_gate("passive_stack_cap_edge", [["talon", 1]], pin, cards, {
		"capped_kind_rows_zero": _count_passive_key(cards, "insight") == 0,
		"under_cap_rows_present": _count_passive_key(cards, "ferocity") > 0,
	}, "")


func _leg_passive_roster_kind() -> void:
	# T-M1h NEW leg (brief: "7th new-kind never offered at cap; new-kind
	# upgrades offerable") — the cap enforced on the FEATURE-6 partner
	# kinds with FULLY REAL pins (no synthetic carriers needed any more):
	# 6 distinct carried KINDS, three of them partners (cracked-heart,
	# iron-wrap, tall-candles @1). The 7th NEW kind (loadstone, 0 stacks)
	# is never offered; the carried NEW-kind upgrade (cracked-heart @1 <
	# the 5-stack cap) stays offerable.
	var pin := {"ferocity": 1, "haste": 1, "ward": 1,
		"cracked-heart": 1, "iron-wrap": 1, "tall-candles": 1}
	var cards := _offers_pin_passives(pin)
	_gate("passive_roster_kind", [["talon", 1]], pin, cards, {
		"new_kind_rows_zero": _count_passive_key(cards, "loadstone") == 0,
		"new_kind_upgrade_present": _count_passive_key(cards, "cracked-heart") > 0,
	}, "REAL pins (roster 15 kinds since T-M1h)")


# --- the one offer funnel, driven OFFERS times ------------------------------

func _reset() -> void:
	_main.game.start_run() # canonical start state: talon L1, zero passives


func _offers_pin_weapons(pin: Array) -> Array:
	_reset()
	_main.game.weapons.clear()
	for r in pin:
		_main.game.weapons.append({"id": r[0], "level": r[1], "cd": 0.0})
	return _dump_offers()


func _offers_pin_passives(pin: Dictionary) -> Array:
	_reset() # keeps the canonical 15-key passives dict + talon L1
	for key in pin:
		_main.game.passives[key] = pin[key]
	return _dump_offers()


func _dump_offers() -> Array:
	# The real level-up funnel per offer: pending_levels -> _enter_levelup
	# (the exact call _step makes at main.gd:183), dump _current_offer,
	# decline the way SimBoss declines (pending 0, back to playing).
	var cards: Array = []
	for i in OFFERS:
		_main.game.pending_levels = 1
		_main._enter_levelup()
		var offer: Array = []
		for c in _main._current_offer:
			offer.append({"kind": c.kind,
				"id": c.get("id", c.get("key", "bonus"))})
			cards.append({"kind": c.kind,
				"id": c.get("id", c.get("key", "bonus"))})
		_emit({"ev": "caps_offer", "i": i, "cards": offer})
		_main.game.pending_levels = 0
		_main.game.set_phase("playing")
	return cards


# --- rows + gates ------------------------------------------------------------

func _gate(name: String, weapon_pin: Array, passive_pin: Dictionary,
		cards: Array, checks: Dictionary, note: String) -> void:
	var leg_ok := true
	for k in checks:
		if not checks[k]:
			leg_ok = false
	_ok = _ok and leg_ok
	_emit({"ev": "caps_leg", "leg": name, "offers": OFFERS,
		"weapons": weapon_pin, "passives": passive_pin, "note": note})
	_emit({"ev": "caps_gate", "leg": name, "cards": cards.size(),
		"checks": checks, "ok": leg_ok})


func _count_kind(cards: Array, kind: String) -> int:
	var n := 0
	for c in cards:
		if c.kind == kind:
			n += 1
	return n


func _count_passive_key(cards: Array, key: String) -> int:
	var n := 0
	for c in cards:
		if c.kind == "passive" and c.id == key:
			n += 1
	return n


func _count_passive_any(cards: Array) -> int:
	return _count_kind(cards, "passive")


func _emit(row: Dictionary) -> void:
	_rows.append(row)
