# Chest tier rewards (M2 pillar B, MC 11239; M2-SPEC rev-2 §B.1) — the ONE
# new rule entry of the pillar: the tier table + a seed-pinned weighted
# chooser. Every mechanic it grants is an existing one: the tier cards ride
# the frozen pending_levels -> _enter_levelup -> make_offer -> apply_offer
# seam (each pending is one 3-card offer, so a bigger chest = more offers;
# the per-offer reward KIND rides the game.reward_kinds FIFO the seam pops),
# and the gold line returns a raw roll the collect funnel credits through
# the ONE GameState.credit_gold seam. VS-FEATURES §S8 shape ref (contents =
# items + a random gold roll); THEIR fixed first-six sequence 1-1-3-1-1-5
# is NOT cloned — replaced by OUR weighted rolls (rev-2 S8 wording verbatim:
# "replaced ... not copied"). No pity/gold-extra rule exists in §B — the
# table's three columns are the law (brief: "table is law").
# RNG: the chooser consumes the GLOBAL stream (randi()), the ONE channel the
# sim harness pins (HD3D_SEED -> seed() — the same mechanism that already
# byte-stabilizes pool.shuffle and every drop roll). A second, privately
# seeded RandomNumberGenerator would sit BEYOND that pin — replace-not-add
# forbids a parallel RNG the seed pin cannot reach; seed-pinned means
# reachable-by-the-pin, and this is.
class_name ChestRewards
extends RefCounted

# §B.1 tier table, OUR counts and OUR weights (the doc's 1-1-3-1-1-5 is
# theirs, never used). item_count = weighted picks AND pending cards;
# pick weights are weapon/passive/gold (sum 100 per tier); gold_lo/hi is
# the inclusive per-open gold roll range.
const TIERS := {
	"ember": {"item_count": 1, "weapon": 50, "passive": 30, "gold": 20,
		"gold_lo": 5, "gold_hi": 15},
	"warden": {"item_count": 2, "weapon": 40, "passive": 40, "gold": 20,
		"gold_lo": 15, "gold_hi": 40},
	"dawn": {"item_count": 3, "weapon": 35, "passive": 45, "gold": 20,
		"gold_lo": 40, "gold_hi": 90},
}

# The weighted walk over a row's three weight columns: randi() into the
# [0,total) span, first kind whose bucket end passes the roll wins. A
# zero-weight bucket spans ZERO width, so it can never be returned — the
# weight-zero determinism leg asserts exactly that.
static func pick(weights: Dictionary) -> String:
	var total := 0
	for k in ["weapon", "passive", "gold"]:
		total += int(weights[k])
	var r := randi() % total
	for k in ["weapon", "passive", "gold"]:
		r -= int(weights[k])
		if r < 0:
			return k
	return "gold" # unreachable while total > 0 (every tier row sums 100)


# The open grant, called at the ONE chest-open funnel AFTER the transform
# (world.gd: try_evolve first — the union pillar's try_union will take its
# precedence slot at the same site). Queues item_count reward kinds onto the
# seam's FIFO, raises the frozen pending_levels by item_count, and RETURNS
# the tier's gold roll (raw — the collect funnel credits it through the ONE
# credit_gold seam, meta gold-rate included). The chest tier key exists on
# every drop path (CHEST_TIER_BY_SOURCE stamps all three drop sites): a
# missing/unknown tier is a programmer bypass and crashes HERE loudly, never
# silently de-tiered (the map-bypass planted-red rides this strictness).
static func grant(game: GameState, chest: Dictionary) -> int:
	var row: Dictionary = TIERS[String(chest["tier"])]
	for i in int(row["item_count"]):
		game.reward_kinds.append(pick(row))
	game.pending_levels += int(row["item_count"])
	var lo: int = int(row["gold_lo"])
	return lo + randi() % (int(row["gold_hi"]) - lo + 1)
