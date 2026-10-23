// World-locked biome tiling (DESIGN-3D §a): UV = world_xz / TILE_M — the
// world-lock rule is v1's grid-snap tiled draw (render.gd:215-222), never
// screen-locked. T-S10 (MC 11159, owner ruling 2026-10-23): the v1 tile
// size 42.7 m (= 1024 px / S) made one tile span ~80 % of the 30 m ortho
// view, so painted detail landed ~1:1 with screen pixels (grass tufts =
// 8-12 m giants) and the ground became the loudest layer; TILE_M drops to
// 11.0 m (4x detail density, biome identity stays in the HUE order) and
// TONE darkens the albedo toward the <=34 floor-lum gate. ground.gd mips
// the tiles at load and samples them linearly so the density doesn't
// shimmer (.import metadata is gitignored — the mip pass lives there).
shader_type spatial;
render_mode unshaded;

const float TILE_M = 11.0;

uniform sampler2D albedo_tex : source_color, hint_default_white;
// Biome-darkening multiplier (T-S10 floor-lum gate; per-band tuning rides
// on the same uniform — the bands share one value in the accepted build).
uniform float tone : hint_range(0.0, 1.0) = 0.62;

void vertex() {
	vec4 world_pos = MODEL_MATRIX * vec4(VERTEX, 1.0);
	UV = world_pos.xz / TILE_M;
}

void fragment() {
	ALBEDO = texture(albedo_tex, UV).rgb * tone;
}
