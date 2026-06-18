#version 120
// Outputs: gcolor, gnormal, gaux (roughness/metalness/ao), gdepth
varying vec3 v_pos;
varying vec3 v_normal;
varying vec2 v_uv;
varying vec3 v_worldPos;

uniform sampler2D texture; // Minecraft diffuse atlas
uniform sampler2D normalmap; // optional normal map derived from resource pack
uniform sampler2D specularmap; // optional roughness/metalness pack
uniform vec3 sunDirection;
uniform vec3 sunColor;
uniform vec3 ambientColor;
uniform float time;
uniform vec3 cameraPos;

// Simple normal fetch/perturb fallback
vec3 fetchNormal() {
    #ifdef USE_NORMALMAP
    vec3 n = texture2D(normalmap, v_uv).rgb * 2.0 - 1.0;
    return normalize(n);
    #else
    return normalize(v_normal);
    #endif
}

// Estimate roughness from specularmap or from brightness
float fetchRoughness() {
    #ifdef USE_SPECULARMAP
    return texture2D(specularmap, v_uv).g;
    #else
    vec3 albedo = texture2D(texture, v_uv).rgb;
    float lumin = dot(albedo, vec3(0.299,0.587,0.114));
    return clamp(1.0 - lumin, 0.15, 0.9); // dark -> glossier heuristic
    #endif
}

void main() {
    vec3 N = fetchNormal();
    vec3 albedo = texture2D(texture, v_uv).rgb;
    float roughness = fetchRoughness();
    float metallic = 0.0; // Minecraft is mostly dielectric
    float ao = 1.0; // simple default, can be replaced by AO maps

    // Pack outputs in multiple render targets depending on loader. For OptiFine we write gl_FragData[0..]
    gl_FragData[0] = vec4(albedo, 1.0);     // gcolor
    gl_FragData[1] = vec4(N * 0.5 + 0.5, 1.0); // gnormal
    gl_FragData[2] = vec4(roughness, metallic, ao, 1.0); // gaux
    // depth is provided by depth buffer; additional depth output not needed
}
