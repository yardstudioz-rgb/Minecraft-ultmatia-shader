#version 120
// Layered volumetric clouds - simplified and cheap
varying vec2 uv;
uniform sampler2D perlinNoise;
uniform vec3 sunDirection;
uniform float time;
uniform float coverage;

float fbm(vec2 p){
    float f = 0.0;
    float amp = 0.5;
    for(int i=0;i<5;i++){ f += texture2D(perlinNoise, p * pow(2.0,float(i))).r * amp; amp *= 0.5; }
    return f;
}

void main(){
    vec2 p = uv * 2.0 - 1.0;
    float c = fbm(p * 1.2 + vec2(time*0.02));
    c = smoothstep(0.4, 0.7, c) * coverage;
    vec3 sky = mix(vec3(0.6,0.72,1.0), vec3(1.0,0.8,0.6), pow(1.0 - sunDirection.y, 3.0));
    vec3 col = mix(vec3(0.8), sky, clamp(dot(vec3(0.0,1.0,0.0), sunDirection),0.0,1.0)) * c;
    gl_FragColor = vec4(col, c);
}
