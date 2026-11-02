# Best-runs board rules (T-M7C, MC 11628): the rule module beside
# achievements.gd / roster.gd (the rule-module precedent) for the LOCAL
# per-hero top-5 best-runs board — the honest thing the retired global-
# leaderboard claim promised to be (README doc-sync, MC 11401 lineage):
# this machine's own runs, persisted in the Dawn Well save, NO server.
# THE SCHEMA (DECLARED READING, on the card's law): well.best_runs maps
# "<char_index>" -> an Array of at most TOP run rows, each row a small
# Dictionary {"survived": int seconds (floored), "kills": int, "score":
# int}. The row is frozen at the run end; the page READS rows, it never
# recomputes.
# THE SCORE FORMULA is the SHIPPED one — main.gd's _score(stats) =
# roundi(time*10 + kills*5 + level*25 + gold), the end panel's "Score"
# row since v1-heritage (pinned by tests/test_biome_numbers.py::
# test_score_formula). ONE implementation: record() receives the score
# the run-end handler already computed — no second formula home (the
# L-E1 one-home walk proves the formula occurs in no other .gd).
# THE RANK LAW (DECLARED): rank = score desc; a tie breaks on survived
# desc; a FULL tie (same score AND same survived) keeps the EARLIER row
# above the later one (insertion order — the new row never displaces its
# equal). Implemented as the ordered-insert scan below, never a sort
# (Array.sort_custom is an unstable quicksort — a full-tie pair could
# swap; the scan is deterministic BY CONSTRUCTION). Truncation: a row
# that would land past TOP is dropped (a 6th row never enters the board).
class_name BestRuns
extends RefCounted

const TOP := 5 # per-hero board size (the card's top-5 law)


# The ONE run-end recording entry — called by main._end_run with the
# run's own frozen stats + the score from the shipped _score. Mutates the
# in-memory well.best_runs ONLY: persistence is the ONE _meta_changed()
# funnel under the gold line (the P-E3 PIN-HOLD shape verbatim; zero
# save() or funnel calls here, zero RNG, zero game/world writes — the
# sim consumes NOTHING new, the byte law).
static func record(well: DawnWell, char_idx: int, survived: int,
		kills: int, score: int) -> void:
	var key := num_to_int(char_idx) # the canonical String key (the disk
	# law: JSON object keys are Strings; record/save/load all speak it)
	var rows: Array = well.best_runs.get(key, [])
	var row := {"survived": survived, "kills": kills, "score": score}
	var at := rows.size() # insertion tail: the full-tie law keeps an
	for i in rows.size(): # equal-or-better row ABOVE the new one — the
		if int(rows[i].score) < score \
				or (int(rows[i].score) == score and int(rows[i].survived) < survived):
			at = i # first strictly-worse row: the new row takes its slot
			break
	rows.insert(at, row)
	if rows.size() > TOP:
		rows.resize(TOP) # a row that ranked past the board falls off the
	well.best_runs[key] = rows # tail — truncation, never rotation


# The page's ONE read: the hero's rows, rank order, [] when none yet.
static func rows(well: DawnWell, char_idx: int) -> Array:
	return well.best_runs.get(num_to_int(char_idx), [])


static func num_to_int(char_idx: int) -> String:
	return String.num_int64(char_idx)
