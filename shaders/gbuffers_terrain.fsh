#version 120
// GBuffers terrain fragment - outputs: gcolor, gnormal, gaux (roughness/metalness/ao)
varying vec3 v_worldPos;
varying vec3 v_normal;
varying vec2 v_uv;

uniform sampler2D texture; // Minecraft atlas or bound albedo
uniform sampler2D normalMap; // optional
uniform sampler2D specMap; // optional roughness/metalness

vec3 fetchNormal(){
    #ifdef USE_NORMALMAP
    vec3 n = texture2D(normalMap, v_uv).rgb * 2.0 - 1.0;
    return normalize(n);
    #else
    return normalize(v_normal);
    #endif
}

float fetchRoughness(){
    #ifdef USE_SPECMAP
    return texture2D(specMap, v_uv).g;
    #else
    vec3 al = texture2D(texture, v_uv).rgb;
    float lum = dot(al, vec3(0.299,0.587,0.114));
    return clamp(1.0 - lum, 0.2, 0.9);
    #endif
}

void main(){
    vec3 N = fetchNormal();
    vec3 albedo = texture2D(texture, v_uv).rgb;
    float rough = fetchRoughness();
    float metallic = 0.0;
    float ao = 1.0;

    gl_FragData[0] = vec4(albedo, 1.0); // gcolor
    // encode normal in 0..1
    gl_FragData[1] = vec4(N * 0.5 + 0.5, 1.0); // gnormal
    gl_FragData[2] = vec4(rough, metallic, ao, 1.0); // gaux
}
