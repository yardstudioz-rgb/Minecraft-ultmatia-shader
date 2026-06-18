#version 120
// Underwater pass: color attenuation + caustics
varying vec2 gl_TexCoord0;
uniform sampler2D sceneTex;
uniform sampler2D causticsMap;
uniform float time;
void main(){
    vec2 uv = gl_TexCoord0.xy;
    vec3 col = texture2D(sceneTex, uv).rgb;
    float caust = texture2D(causticsMap, uv*6.0 + vec2(time*0.2)).r;
    col *= vec3(0.6,0.8,1.0);
    col += caust * 0.06;
    col = mix(col, vec3(0.02,0.03,0.04), 0.5);
    gl_FragColor = vec4(col, 1.0);
}
