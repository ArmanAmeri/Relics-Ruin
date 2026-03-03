shader_type canvas_item;
render_mode unshaded;

// Burn pixelation control
uniform int   burn_pixel_size : hint_range(1,128) = 8;

// Dissolve parameters
uniform sampler2D dissolve_texture : source_color, filter_nearest; // nearest-neighbor for crisp blocks
uniform float       dissolve_value    : hint_range(0,1);
uniform float       burn_size         : hint_range(0.0,1.0,0.01);
uniform vec4        burn_color        : source_color;

void fragment() {
    // 1. Sample main texture at full resolution
    vec4 main_tex = texture(TEXTURE, UV);

    // 2. Quantize UVs for the burn (noise) lookup
    vec2 burnUV   = round(UV * float(burn_pixel_size)) / float(burn_pixel_size);

    // 3. Sample noise at quantized UVs, LOD 0
    vec4 noise_tex = textureLod(dissolve_texture, burnUV, 0.0);

    // 4. Compute thresholds
    float bs      = burn_size * step(0.001, dissolve_value) * step(dissolve_value, 0.999);
    float thr     = smoothstep(noise_tex.x - bs, noise_tex.x, dissolve_value);
    float border  = smoothstep(noise_tex.x, noise_tex.x + bs, dissolve_value);

    // 5. Apply dissolve and burn coloring
    COLOR.a      *= thr;
    COLOR.rgb     = mix(burn_color.rgb, main_tex.rgb, border);
}
