#version 120
// Underwater pass: color attenuation, caustics, and fog
varying vec2 v_uv;
uniform sampler2D sceneTex;
uniform sampler2D causticsMap;
uniform float time;
void main(){
    vec3 color = texture2D(sceneTex, v_uv).rgb;
    float caust = texture2D(causticsMap, v_uv * 6.0 + vec2(time*0.2)).r;
    vec3 atten = color * vec3(0.7,0.85,1.0) * (1.0 - 0.35);
    vec3 outc = atten + caust * 0.08;
    // fog
    float fog = smoothstep(0.0,1.0, v_uv.y);
    outc = mix(outc, vec3(0.02,0.03,0.04), fog*0.6);
    gl_FragColor = vec4(outc,1.0);
}
