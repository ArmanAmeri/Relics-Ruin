shader_type canvas_item;

// — Core card‐warp uniforms (unchanged logic) —
uniform vec2   rect_size;
uniform float  fov      : hint_range(1.0, 179.0) = 90.0;    // numeric ranges use hint_range(min,max[,step]) :contentReference[oaicite:0]{index=0}
uniform bool   cull_back = true;
uniform float  y_rot    : hint_range(-360.0, 360.0) = 0.0;  // rotation around Y drives flip :contentReference[oaicite:1]{index=1}
uniform float  x_rot    : hint_range(-360.0, 360.0) = 0.0;
uniform float  inset    : hint_range(0.0, 1.0) = 0.0;

// — Back‐of‐card texture (sRGB/albedo data) —
uniform sampler2D back_tex : source_color;                  // replaces hint_albedo/hint_color :contentReference[oaicite:2]{index=2}

// Varyings from vertex to fragment
varying flat vec2 o;
varying vec3       p;

void vertex() {
    // your existing rotation math…
    float sin_b = sin(y_rot * PI/180.0);
    float cos_b = cos(y_rot * PI/180.0);
    float sin_c = sin(x_rot * PI/180.0);
    float cos_c = cos(x_rot * PI/180.0);

    mat3 inv_rot_mat;
    inv_rot_mat[0] = vec3( cos_b,                  0.0, -sin_b );
    inv_rot_mat[1] = vec3( sin_b * sin_c,   cos_c,  cos_b * sin_c );
    inv_rot_mat[2] = vec3( sin_b * cos_c,  -sin_c,  cos_b * cos_c );

    float t = tan(fov * PI/360.0);
    p = inv_rot_mat * vec3(UV - 0.5, 0.5/t);
    float v = 0.5 + (0.5/t);
    p.xy *= v * inv_rot_mat[2].z;
    o    = v * inv_rot_mat[2].xy;

    VERTEX += (UV - 0.5) * rect_size * t * (1.0 - inset);
}

void fragment() {
    // Determine whether we should show the back side
    bool showing_back = abs(y_rot) > 90.0;

    // (Optional) still cull front-facing back-faces
    if (cull_back && !showing_back && p.z <= 0.0) {
        discard;
    }

    // Compute warped UVs (same as before)
    vec2 base_uv = (p.xy / p.z) - o;
    vec2 samp_uv = base_uv + 0.5;

    // Mirror horizontally when showing the back
    if (showing_back) {
        samp_uv.x = 1.0 - samp_uv.x;
    }

    // *** FIX HERE: sample the texture via texture(), do NOT use back_tex.xyz ***
    vec4 col;
    if (showing_back) {
        col = texture(back_tex, samp_uv);
    } else {
        col = texture(TEXTURE, samp_uv);
    }

    // Soft‐crop the edges
    col.a *= step(max(abs(base_uv.x), abs(base_uv.y)), 0.5);

    COLOR = col;
}
