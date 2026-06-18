#version 120
varying vec2 texcoord;
uniform sampler2D gcolor;
uniform sampler2D gnormal;
uniform sampler2D gaux;
uniform sampler2D depthTex;
uniform vec3 sunDirection;
uniform vec3 sunColor;
uniform vec3 moonDirection;
uniform vec3 moonColor;
uniform vec3 cameraPos;
uniform mat4 inverseProjection;
uniform mat4 inverseView;
uniform float time;
uniform float dayFactor; // 0..1 (0 night, 1 day)

// ---- Atmospheric scattering (practical, Preetham-like) ----
vec3 phaseHenveyGreenstein(float cosTheta, float g) {
    float denom = 1.0 + g*g - 2.0*g*cosTheta;
    return vec3((1.0 - g*g) / (4.0 * 3.14159265359 * pow(denom,1.5)));
}

// Simple aerial/inscattering based on view direction and sun
vec3 atmosphereScattering(vec3 viewDir) {
    float mu = dot(viewDir, sunDirection);
    float RayleighStrength = 0.8;
    float MieStrength = 0.03;
    vec3 rayleighColor = vec3(0.5, 0.7, 1.0);
    vec3 mieColor = vec3(1.0, 0.9, 0.7);
    float hr = 7.5; // rayleigh scale height
    float hm = 1.2; // mie scale height
    float scatter = exp(-max(viewDir.y, 0.0) * 1.0); // horizon accent
    vec3 result = RayleighStrength * rayleighColor * max(mu,0.0) + MieStrength * mieColor * pow(max(mu,0.0), 0.6);
    result *= mix(0.3, 1.0, dayFactor) * scatter;
    // warm tint at low sun
    float sunElev = clamp(sunDirection.y, -1.0, 1.0);
    vec3 sunTint = mix(vec3(1.0,1.0,1.0), vec3(1.0,0.65,0.45), pow(1.0 - sunElev, 3.0));
    return result * sunTint;
}

// Soft directional light + simple PBR direct lighting (using GBuffers)
vec3 directLighting(vec3 worldPos, vec3 N, vec3 albedo, float roughness, float ao) {
    vec3 V = normalize(cameraPos - worldPos);
    vec3 L = normalize(sunDirection);
    // lambert diffuse
    float NdotL = max(dot(N, L), 0.0);
    // Fresnel + specular (Schlick + Blinn-GGX approximation)
    vec3 H = normalize(L + V);
    float NdotH = max(dot(N, H), 0.0);
    float VdotH = max(dot(V, H), 0.0);
    float alpha = roughness*roughness;
    // GGX D approximation
    float denom = (NdotH*NdotH*(alpha*alpha - 1.0) + 1.0);
    float D = alpha*alpha / (3.14159265 * denom * denom + 1e-5);
    // Schlick Fresnel (F0 default 0.04 for dielectric)
    vec3 F0 = vec3(0.04);
    vec3 F = F0 + (1.0 - F0) * pow(1.0 - VdotH, 5.0);
    float G = min(1.0, min(2.0 * NdotH * dot(N, V) / VdotH, 2.0 * NdotH * NdotL / VdotH));
    vec3 spec = (D * F * G) / (4.0 * max(0.001, dot(N,V) * NdotL));
    vec3 diffuse = (1.0 - F) * albedo / 3.14159265;
    vec3 color = (diffuse + spec) * sunColor * NdotL;
    color *= ao;
    // add ambient sky lighting
    color += atmosphereScattering(normalize(cameraPos - worldPos)) * 0.8 * (1.0 - roughness);
    return color;
}

void main() {
    vec3 albedo = texture2D(gcolor, texcoord).rgb;
    vec3 N = texture2D(gnormal, texcoord).rgb * 2.0 - 1.0;
    vec3 aux = texture2D(gaux, texcoord).rgb;
    float roughness = aux.r;
    float metallic = aux.g;
    float ao = aux.b;

    // Reconstruct world position (approx) from depth
    float z = texture2D(depthTex, texcoord).x;
    // If loader gives linear depth, map properly. We'll do a simple ray approach:
    vec4 clip = vec4(texcoord * 2.0 - 1.0, z * 2.0 - 1.0, 1.0);
    vec4 view = inverseProjection * clip;
    view /= view.w;
    vec4 world = inverseView * view;
    vec3 worldPos = world.xyz;

    vec3 color = directLighting(worldPos, normalize(N), albedo, roughness, ao);

    // Atmospheric sky blend (sun glow + gradient)
    vec3 viewDir = normalize(worldPos - cameraPos);
    vec3 sky = atmosphereScattering(viewDir);
    // Mix sky by horizon factor and depth
    float skyFactor = clamp(1.0 - exp(-max(viewDir.y,0.0)*6.0), 0.0, 1.0);
    color = mix(color, sky + sunColor * pow(max(dot(viewDir, sunDirection),0.0), 80.0) * 2.0, 1.0 - ao * 0.9 * skyFactor);

    // God rays (cheap screen-space radial blur around sun position)
    // Real implementation is in final pass as a postprocess for quality/perf separation.

    gl_FragColor = vec4(color, 1.0);
}
