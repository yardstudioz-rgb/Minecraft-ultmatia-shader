#version 120
varying vec2 v_uv;
uniform sampler2D sceneColor; // scene for SSR
uniform sampler2D sceneDepth;
uniform sampler2D dudvMap; // normal/perturb textures for waves
uniform sampler2D causticsMap;
uniform vec3 sunDirection;
uniform vec3 cameraPos;
uniform float time;
uniform float waterLevel;

vec3 getReflection(vec3 viewDir, vec3 normal) {
    vec3 R = reflect(viewDir, normal);
    // sample screen-space reflection (cheap) by projecting R into screen coords - approximated
    vec2 screenUV = v_uv + R.xz * 0.02; // small perturb, cheap
    return texture2D(sceneColor, screenUV).rgb;
}

void main() {
    // generate normal from dudv map + time
    vec2 dudv = texture2D(dudvMap, v_uv + vec2(time*0.03, time*0.02)).rg * 2.0 - 1.0;
    vec3 N = normalize(vec3(dudv.x * 0.25, 1.0, dudv.y * 0.25));
    vec3 viewDir = normalize(cameraPos - vec3(v_uv.x, waterLevel, v_uv.y));
    vec3 reflection = getReflection(viewDir, N);
    // refraction color: sample scene slightly below water (approx)
    vec3 refraction = texture2D(sceneColor, v_uv + dudv*0.01).rgb;
    // fresnel blend
    float fresnel = pow(1.0 - max(dot(N, viewDir), 0.0), 3.0);
    vec3 color = mix(refraction * vec3(0.9,1.0,1.05), reflection, fresnel * 1.2);
    // caustics projection (cheap): blend in tiled caustics texture using viewDist
    float caust = texture2D(causticsMap, v_uv * 6.0 + vec2(time*0.2)).r;
    color += caust * 0.12 * max(0.0, dot(sunDirection, vec3(0.0,1.0,0.0)));
    // watery foamy edge (not full implementation)
    float edge = smoothstep(0.0, 0.05, abs(dudv.x)+abs(dudv.y));
    color = mix(color, vec3(1.0), edge*0.15);
    gl_FragColor = vec4(color, 0.9);
}
