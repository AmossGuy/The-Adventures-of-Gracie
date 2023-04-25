shader_type canvas_item;

uniform sampler2D palettes : filter_nearest;
uniform int palette;

void fragment() {
	vec4 orig = texture(TEXTURE, UV);
	float palette_v = float(palette) / float(textureSize(palettes, 0).y);
	COLOR = texture(palettes, vec2(orig.r, palette_v));
	COLOR.a = orig.a;
}
