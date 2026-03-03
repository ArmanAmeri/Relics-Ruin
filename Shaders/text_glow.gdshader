shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform float glow_strength = 2.0;
uniform float glow_size = 4.0;

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    float glow = 0.0;
    glow += texture(TEXTURE, UV + vec2(glow_size, 0.0) * TEXTURE_PIXEL_SIZE).a;
    glow += texture(TEXTURE, UV - vec2(glow_size, 0.0) * TEXTURE_PIXEL_SIZE).a;
    glow += texture(TEXTURE, UV + vec2(0.0, glow_size) * TEXTURE_PIXEL_SIZE).a;
    glow += texture(TEXTURE, UV - vec2(0.0, glow_size) * TEXTURE_PIXEL_SIZE).a;

    vec4 glow_effect = glow_color * glow * glow_strength;
    COLOR = base + glow_effect;
}