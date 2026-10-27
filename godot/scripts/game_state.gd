# Run state + phase machine + the Contract B snapshot (exact 12 fields).
class_name GameState
extends RefCounted

const BASE_SPEED := 140.0
const IFRAMES := 0.5
const WIN_TIME := 900.0 # M1 feature 4 (PARITY-ROADMAP rev3): run length 600->900
const MAX_HP := 100.0

var phase := "menu" # menu | playing | levelup | gameover | win
var paused := false # Esc freeze; not a phase value (Contract B)
var muted := false # internal no-op flag: this build ships no audio
var time := 0.0 # seconds, advances only while playing and not paused
var run_id := ""
var hp := MAX_HP
var max_hp := MAX_HP
var level := 1
var xp := 0.0
var gold := 0
var kills := 0
var pending_levels := 0
# M2 §B.1 (MC 11239 T-M2t): the chest tier reward kinds (weapon|passive|gold)
# queue here FIFO at the ONE open funnel; the frozen levelup seam pops one
# kind per offer through make_offer ("" = the untouched full pool). Like
# endless/cycle this rides OUTSIDE the 12-field Contract B snapshot (F-3)
# and is reset in start_run below; the queue can never raise pending_levels
# by itself (grant() raises BOTH, in lockstep — chest_rewards.gd).
var reward_kinds: Array = []
# M2 pillar A (MC 11237 T-M2e, M2-SPEC §A): endless is a RUN MODE hand-in
# (F-4), not a phase value, and cycle is the 0-based cycle index (cycle =
# int(time // WIN_TIME), §A.1 — WIN_TIME stays the ONE clock). Both live
# OUTSIDE the 12-field Contract B snapshot below (F-3 frozen): neither name
# may ever appear in snapshot_json. start_run() resets both; main.gd hands
# the flag in through the ONE _dawnwell -> start seam after start_run
# (the meta_ranks pattern: empty input = every pre-endless byte unchanged).
var endless := false
var cycle := 0
# M3 pillar A (MC 11282 T-M3s, M3-SPEC §1.1): stage is the run's STAGE
# hand-in (the stage-select overlay's choice, §2) and flare the Pressure-
# Stair VISUAL band shift (§1.2, decayed by world.gd's plate logic). Like
# endless/cycle both ride OUTSIDE the 12-field Contract B snapshot (F-3,
# frozen) and are reset in start_run() below; main.gd hands the stage in
# through the ONE _dawnwell -> start seam AFTER start_run (the endless
# pattern — unset/older saves read the stage-1 id). The sim difficulty key
# stays the pure clock: flare moves the band NAME the ground/HUD read,
# never spawn stats or rates (F-4 byte corpus).
var stage := "moor-vigil"
var flare := 0.0
# M4 pillar B (MC 11364 T-M4r, M4-SPEC §2.1): reaper is the night-flag RUN
# MODE hand-in (DawnWell.flags["reaper"], the endless pattern verbatim —
# hidden well flag, NO UI row, F-7). Like endless/cycle/stage it rides
# OUTSIDE the 12-field Contract B snapshot (F-3, frozen; the B-E5 red
# column "a 13th snapshot field" fires the test_endless exact-12 pin) and
# is reset in start_run() below; main.gd hands it in at the ONE
# _dawnwell -> start seam AFTER start_run. Unset = false = every
# committed byte unchanged (B-E1).
var reaper := false
# M4 pillar C (MC 11365 T-M4l, M4-SPEC §3.1): limit is the run's LIMIT-BREAK
# counter row — the ONLY state the pool-exhaustion fallback cards touch (one
# increment per pick, levelup.gd apply_offer; the LIMIT_CARDS table itself is
# offers, not state). Like endless/cycle/stage/reaper it rides OUTSIDE the
# 12-field Contract B snapshot (F-3, frozen) and is reset in start_run()
# below; read at exactly THREE additive zero-identity seams (the T-M1h
# gilded-skull/rotten-plate precedent — at 0 picks every term adds exactly
# nothing, so every committed byte of every corpus run is unchanged).
var limit := {"dmg": 0, "spd": 0, "arm": 0}
# M5 pillar B (MC 11422 T-M5c, M5-SPEC §2.1/F-5): the roster selection.
# char_sel is the HAND-IN INPUT row (the meta_ranks pattern: main owns the
# DawnWell read and sets it BEFORE start_run, because the rule table is
# CONSUMED inside start_run below — the §2.1b after-the-reset placement is
# declared-and-rejected for this row in the card capture + LEDGER: it
# cannot feed the start_run consumption F-5 names). char_id is the run var
# the formula seams and the pawn read; it joins the reset block below
# (start_run resets it from the input row: a bare start_run reads row 0 =
# the shipped identity = every committed byte, F-2). Like endless/cycle/
# stage/reaper/limit both rows ride OUTSIDE the 12-field Contract B
# snapshot (F-3, frozen: neither name may ever appear in snapshot_json).
# The skin rows ride with the SKINS table (T-M5k, wave map + R1 sequence).
var char_sel := 0
var char_id := 0
var weapons: Array = [] # [{id, level, cd}] — ids per plan §5
# The 15 passive STAT ROWS (PARITY-ROADMAP rev3 features 3+7: original five
# + the ten evolution partners, T-M1h). Seeded here AND in start_run so
# every pool/read seam indexes a real key; effects ride the existing
# passive-effect application sites (below) — cracked-heart is applied at
# the ONE passive pick site (levelup.gd apply_offer), four-leaf-charm is a
# DECLARED stat row whose consumption site (the chest-roll line) is a
# STAY-GREEN byte-pin until its own retirement card (capture M1h row).
var passives := {"ferocity": 0, "haste": 0, "ward": 0, "grip": 0, "insight": 0,
	"cracked-heart": 0, "iron-wrap": 0, "tall-candles": 0, "four-leaf-charm": 0,
	"knotted-chain": 0, "loadstone": 0, "rotten-plate": 0, "twin-runes": 0,
	"gall-vial": 0, "gilded-skull": 0}
var player := {"x": 0.0, "y": 0.0, "dir_x": 1.0, "dir_y": 0.0, "iframes": 0.0}
var stats: Dictionary = {}
# Dawn Well meta ranks (T-M1f, roadmap M1 feature 2): the ONE consumption
# point is start_run() below (roadmap: "Meta ranks are consumed at
# start_run() ... snapshot maxHp/xpNext legitimately shift with bought
# ranks"). main.gd hands the loaded save's ranks in as a plain Dictionary —
# this file never touches DawnWell/persistence. Empty ranks (every run
# before the shop exists, and every committed sim dump) leave ALL multi-
# pliers at their exact pre-shop values, so v1-parity rows stay byte-stable.
var meta_ranks: Dictionary = {}
var meta_xp_mult := 1.0
var meta_gold_mult := 1.0
var gold_frac := 0.0 # gold-rate carry: whole coins only ever enter `gold`


static func xp_need(level: int) -> int:
	return 5 + 4 * level + level * level


func player_speed() -> float:
	# LIMIT · HASTE (M4 §3.1): +3% move speed per pick as a SECOND factor —
	# 0 picks multiplies by 1.0, the IEEE identity (byte corpus unchanged).
	# M5 F-5 (T-M5c): the roster spd_pct term rides the SAME second-factor
	# shape — row 0 (0) multiplies by 1.0, the IEEE identity.
	return BASE_SPEED * (1.0 + 0.08 * passives.haste) * (1.0 + 0.03 * limit.spd) \
		* (1.0 + 0.01 * Roster.rule(char_id).spd_pct)


func damage_taken(raw: float) -> float:
	# Rotten Plate (feature-6 partner, T-M1h): stacks as ARMOR in the SAME
	# intake seam as ward — one subtraction site, our values (1 per stack).
	# LIMIT · BULWARK (M4 §3.1): +1 ARMOR per pick inside the EXISTING
	# maxf — intake stays clamped >= 0, so Bulwark can never heal damage;
	# 0 picks subtracts 0.0, the IEEE identity. M5 F-5 (T-M5c): the roster
	# armor_add term rides the SAME subtraction inside the existing maxf —
	# intake stays clamped >= 0 (B-E3); row 0 subtracts 0.0.
	return maxf(0.0, raw - passives.ward
		- float(passives["rotten-plate"]) - 1.0 * limit.arm
		- 1.0 * Roster.rule(char_id).armor_add)


func damage_multiplier() -> float:
	# Gall Vial (partner): +8% weapon damage per stack in the SAME multiplier
	# seam as ferocity (its +10% row unchanged; values ours). LIMIT · FURY
	# (M4 §3.1): +4% weapon damage per pick as the same-shape additive term
	# (0.04 vs the passive's 0.08 — the fallback is WEAKER per pick than the
	# capped passive it stands behind); 0 picks adds 0.0, the IEEE identity.
	# M5 F-5 (T-M5c): the roster dmg_pct term is the same-shape additive
	# (+0.01·row); row 0 adds 0.0.
	return 1.0 + 0.1 * passives.ferocity + 0.08 * float(passives["gall-vial"]) \
		+ 0.04 * limit.dmg + 0.01 * Roster.rule(char_id).dmg_pct


# Roster-passive multipliers (T-M1h partners, OUR values): consumed by the
# NEW weapon fire branches (the six v1-era weapons' numbers are S4
# byte-pins — STAY-GREEN, so the partners read at the new weapons' spawn
# math + these shared seams; mapping table in the M1h capture).
func proj_speed_mult() -> float:
	return 1.0 + 0.06 * float(passives["iron-wrap"])


func duration_mult() -> float:
	return 1.0 + 0.08 * float(passives["knotted-chain"])


func area_mult() -> float:
	return 1.0 + 0.06 * float(passives["tall-candles"])


func extra_projectiles() -> int:
	return int(passives["twin-runes"])


func start_run() -> void:
	phase = "playing"
	paused = false
	time = 0.0
	run_id = "rd-" + _random_hex(8)
	# Meta-rank consumption (T-M1f): maxHp = 100 + Σ maxhp-ranks * 10 exactly
	# as the roadmap pins it; the xp/gold rates fold into multipliers here.
	# With empty meta_ranks every value is the pre-shop constant, byte-equal.
	# M5 §2.1 (T-M5c): the roster reset row JOINS this block as the hand-in
	# INPUT read immediately above the consumption — unset input = row 0,
	# and every char term below is an additive/multiplicative DEFAULT
	# (B-E3's "+0 / ·1.0 / +0.01·0" identity rows: IEEE-exact, F-2). The
	# planted red "a default from a global" (M4 B-E1's endless-pattern red
	# restated) fires the hand-in regex leg in test_characters.py.
	char_id = char_sel
	max_hp = MAX_HP + PowerUps.max_hp_bonus(meta_ranks) + Roster.rule(char_id).hp_add
	hp = max_hp
	level = 1
	xp = 0.0
	gold = Roster.gold_start(char_id) # M5 F-5: the gold_add term, row 0 = 0
	gold_frac = 0.0
	meta_xp_mult = 1.0 + PowerUps.xp_bonus(meta_ranks) + 0.01 * Roster.rule(char_id).xp_pct
	meta_gold_mult = 1.0 + PowerUps.gold_bonus(meta_ranks)
	kills = 0
	pending_levels = 0
	reward_kinds = []
	endless = false # §A.2: fresh-run reset; the flag is re-handed by main._start_game
	cycle = 0     # after start_run (hand-in seam, never a start_run default)
	reaper = false # M4 §2.1 T-M4r: fresh-run reset, the endless pattern; the
	#   night flag is re-handed by main._start_game (hand-in seam, never a
	#   start_run default — B-E1's planted red "default the flag true" here)
	limit = {"dmg": 0, "spd": 0, "arm": 0} # M4 §3.1 T-M4l: fresh-run reset —
	#   the counter row is RUN state (outside the snapshot; the 13th-field
	#   instrument is the sim_limit limit_snapshot leg + test_endless's pin)
	stage = "moor-vigil" # §1.1 M3: fresh-run reset to the stage-1 id; re-handed
	flare = 0.0          # by main._start_game after this call (plate logic owns decay)
	# FALSIFIED-BY-DESIGN AND REPLACED (M2-SPEC B3/T-M2c, MC 11236): the
	# ember start-row drift — the talon literal below was the M2-era start
	# row. REPLACED AGAIN (M5 §2.2, T-M5c, MC 11422, replace-not-delete,
	# history kept): the literal moved VERBATIM into roster.gd as
	# CHARACTERS[0].start_weapons (row 0 IS the shipped identity) and the
	# hand-out rides Roster.start_weapons()'s deep duplicate() — the §2.2
	# law: const rows are DEEP read-only on the pinned 4.7.2 and
	# levelup.gd's upgrade arm mutates the run dict (shallow duplicate
	# re-shares the row; assignment into a const row aborts — both DA-c2
	# measured on the pinned binary). A bare start_run consumes row 0 = the
	# identical row (B-E1 byte law); the re-copied-literal equality pin
	# lives in test_characters.py (the M2-B3 shape, re-pointed to the
	# ROSTER seam: the start_run body regex-pins the ROSTER call below).
	weapons = Roster.start_weapons(char_id)
	passives = {"ferocity": 0, "haste": 0, "ward": 0, "grip": 0, "insight": 0,
		"cracked-heart": 0, "iron-wrap": 0, "tall-candles": 0, "four-leaf-charm": 0,
		"knotted-chain": 0, "loadstone": 0, "rotten-plate": 0, "twin-runes": 0,
		"gall-vial": 0, "gilded-skull": 0}
	# M5 F-5 (T-M5c): start passives write INTO the same dict (the §2.2
	# hand-out is a deep duplicate; every SEL-C row carries an EMPTY row
	# today — the write loop is the mechanism the field shape freezes, the
	# row-0 and every-current-row merge is exactly nothing, F-2).
	var start_pass: Dictionary = Roster.start_passives(char_id)
	for k in start_pass:
		passives[k] = int(passives[k]) + int(start_pass[k])
	player = {"x": 0.0, "y": 0.0, "dir_x": 1.0, "dir_y": 0.0, "iframes": 0.0}
	stats = {}


func set_phase(next_phase: String) -> void:
	phase = next_phase
	paused = false


func end_run(result: String) -> void:
	stats = {
		"time": time,
		"kills": kills,
		"level": level,
		"gold": gold,
	}
	phase = result # "gameover" | "win"


# Insight multiplies gained xp; overflow may raise several levels at once.
# The meta xp multiplier (T-M1f) is a plain *1.0 factor with no ranks bought
# — the IEEE product is unchanged for every pre-shop run.
func add_xp(amount: float) -> void:
	xp += amount * (1.0 + 0.15 * passives.insight) * meta_xp_mult
	# Gilded Skull (partner, T-M1h): +8% xp per stack as its OWN additive
	# term in this ONE xp seam (the insight line is a byte-pin — replace-
	# not-touch; 0 stacks adds exactly 0.0, every pre-M1h dump byte-equal).
	xp += amount * 0.08 * float(passives["gilded-skull"]) * meta_xp_mult
	while xp >= float(xp_need(level)):
		xp -= float(xp_need(level))
		level += 1
		pending_levels += 1


# The gold-rate seam (T-M1f, roadmap "gold-rate via gold/kills rows"): raw
# pickup gold enters the run through HERE, multiplied by the meta gold rate
# with the fractional remainder carried, so `gold` (an int in the Contract B
# snapshot) only ever moves by whole coins. meta_gold_mult 1.0 returns raw
# exactly. The Warden's direct +50 kill bounty (world.gd) is NOT doubled by
# the rate — the rate is a PICKUP effect (declared in the card capture).
func credit_gold(raw: int) -> int:
	if raw <= 0:
		return raw
	gold_frac += float(raw) * meta_gold_mult
	var whole := int(floor(gold_frac))
	gold_frac -= float(whole)
	return whole


# Exact Contract B shape, field for field, serialized for window.__vsSnapshot.
func snapshot_json(enemy_count: int) -> String:
	var weapon_rows: Array = []
	for w in weapons:
		weapon_rows.append({"id": w.id, "level": w.level})
	return JSON.stringify({
		"phase": phase,
		"hp": hp,
		"maxHp": max_hp,
		"level": level,
		"xp": xp,
		"xpNext": xp_need(level),
		"gold": gold,
		"kills": kills,
		"time": time,
		"enemies": enemy_count,
		"weapons": weapon_rows,
		"runId": run_id,
	})


func _random_hex(byte_count: int) -> String:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var out := ""
	for i in byte_count:
		out += "%02x" % (rng.randi() % 256)
	return out
