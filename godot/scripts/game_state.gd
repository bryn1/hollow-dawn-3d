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
	return BASE_SPEED * (1.0 + 0.08 * passives.haste)


func damage_taken(raw: float) -> float:
	# Rotten Plate (feature-6 partner, T-M1h): stacks as ARMOR in the SAME
	# intake seam as ward — one subtraction site, our values (1 per stack).
	return maxf(0.0, raw - passives.ward - float(passives["rotten-plate"]))


func damage_multiplier() -> float:
	# Gall Vial (partner): +8% weapon damage per stack in the SAME multiplier
	# seam as ferocity (its +10% row unchanged; values ours).
	return 1.0 + 0.1 * passives.ferocity + 0.08 * float(passives["gall-vial"])


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
	max_hp = MAX_HP + PowerUps.max_hp_bonus(meta_ranks)
	hp = max_hp
	level = 1
	xp = 0.0
	gold = 0
	gold_frac = 0.0
	meta_xp_mult = 1.0 + PowerUps.xp_bonus(meta_ranks)
	meta_gold_mult = 1.0 + PowerUps.gold_bonus(meta_ranks)
	kills = 0
	pending_levels = 0
	weapons = [{"id": "talon", "level": 1, "cd": 0.0}]
	passives = {"ferocity": 0, "haste": 0, "ward": 0, "grip": 0, "insight": 0,
		"cracked-heart": 0, "iron-wrap": 0, "tall-candles": 0, "four-leaf-charm": 0,
		"knotted-chain": 0, "loadstone": 0, "rotten-plate": 0, "twin-runes": 0,
		"gall-vial": 0, "gilded-skull": 0}
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
