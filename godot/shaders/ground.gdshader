// World-locked biome tiling (DESIGN-3D §a): UV = world_xz / 42.7 m — the v1
// 1024 px tile at S = 24 px/m, so terrain pans with the camera exactly like
// v1's grid-snap tiled draw (render.gd:215-222), never screen-locked.
shader_type spatial;
render_mode unshaded;

const float TILE_M = 42.7;

uniform sampler2D albedo_tex : source_color, hint_default_white;

void vertex() {
	vec4 world_pos = MODEL_MATRIX * vec4(VERTEX, 1.0);
	UV = world_pos.xz / TILE_M;
}

void fragment() {
	ALBEDO = texture(albedo_tex, UV).rgb;
}
