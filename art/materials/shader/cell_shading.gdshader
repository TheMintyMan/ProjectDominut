// NOTE: Shader automatically converted from Godot Engine 4.5.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_disabled, diffuse_toon, specular_toon, alpha_to_coverage_and_one;

uniform int world_space_texture : hint_range(0,1) = 0;
uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset = vec3(0.0);

uniform vec4 albedo : source_color = vec4(1.0, 0.5, 0.7, 1.0);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;
uniform float roughness : hint_range(0.0, 1.0) = 0.5;
uniform float specular : hint_range(0.0, 1.0) = 0.0;

uniform sampler2D color_gradient; // toon ramp
uniform sampler2D noise_tex : repeat_enable; // noise texture


uniform float light_noise_strength : hint_range(0.0, 1.0) = 0.25;
uniform float light_noise_scale = 4.0;

varying vec3 v_world_pos;

void vertex() {
    v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec2 tex_uv = (world_space_texture == 1) ? (v_world_pos.xz * uv1_scale.xy + uv1_offset.xy) : UV;
	vec4 tex_col = texture(texture_albedo, tex_uv);

    // Combine texture and base color
    ALBEDO = albedo.rgb * tex_col.rgb;

    // Alpha
    ALPHA = alpha * albedo.a * tex_col.a;

    // Metallic & roughness
    float metallic_tex = dot(texture(texture_metallic, UV), metallic_texture_channel);
    METALLIC = metallic_tex * metallic;

    float roughness_tex = dot(texture(texture_roughness, UV), vec4(1.0,0.0,0.0,0.0));
    ROUGHNESS = roughness_tex * roughness;

    // Specular
    SPECULAR = specular;
}

void light() {
    // Base light sample from dot product
    float ndl = clamp(dot(NORMAL, LIGHT), -0.9, 0.9);
    float base_sample = clamp((ndl + 1.0) * ATTENUATION / 2.1, 0.05, 0.95);

    // Noise coordinates
    vec2 noise_uv = v_world_pos.xz * light_noise_scale;

    // Sample noise texture
    float noise = texture(noise_tex, noise_uv).r;

    // Modulate toon ramp sample with noise
    float sample = clamp(base_sample + (noise - 0.5) * light_noise_strength, 0.05, 0.95);

    // Sample toon ramp
    vec4 shaded = texture(color_gradient, vec2(sample, 0.0));

    // Apply to light
    DIFFUSE_LIGHT += shaded.rgb * LIGHT_COLOR;
}
