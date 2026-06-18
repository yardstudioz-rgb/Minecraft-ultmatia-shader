#version 120
// Water fragment - simple SSR/refraction + dudv perturbation + caustics
varying vec2 v_uv;
uniform sampler2D sceneTex;
uniform sampler2D dudvMap;
uniform sampler2D causticsMap;
uniform vec3 sunDir;
uniform float time;

void main(){
    vec2 dudv = texture2D(dudvMap, v_uv + vec2(time*0.03, time*0.02)).rg * 2.0 - 1.0;
    vec2 uvRefl = v_uv + dudv * 0.02;
    vec3 refl = texture2D(sceneTex, uvRefl).rgb;
    vec3 refr = texture2D(sceneTex, v_uv + dudv*0.005).rgb * vec3(0.9,1.0,1.05);
    float fresnel = pow(1.0 - clamp(dot(normalize(vec3(0.0,1.0,0.0)), normalize(vec3(0.0,0.0,1.0))),0.0,1.0), 3.0);
    vec3 color = mix(refr, refl, fresnel);
    float caust = texture2D(causticsMap, v_uv * 6.0 + vec2(time*0.2)).r;
    color += caust * 0.08 * max(0.0, dot(sunDir, vec3(0.0,1.0,0.0)));
    gl_FragColor = vec4(color, 0.9);
}
