#version 120
// Final pass: post-processing hooks for AO, bloom, god rays, fog
varying vec2 gl_TexCoord0;
uniform sampler2D sceneTex;
uniform sampler2D depthTex;
uniform sampler2D ssaoTex; // optional
uniform sampler2D bloomTex; // optional
uniform float time;
uniform float wetness;

float getAO(vec2 uv){
    #ifdef USE_SSAO
    return texture2D(ssaoTex, uv).r;
    #else
    return 1.0;
    #endif
}

vec3 depthFog(vec3 col, float depth){
    float fogStart = 20.0;
    float fogEnd = 200.0;
    float f = clamp((depth - fogStart)/(fogEnd - fogStart), 0.0, 1.0);
    vec3 fogCol = vec3(0.6,0.7,0.85) * 0.6;
    return mix(col, fogCol, f);
}

void main(){
    vec2 uv = gl_TexCoord0.xy;
    vec3 col = texture2D(sceneTex, uv).rgb;
    float depth = texture2D(depthTex, uv).r;

    float ao = getAO(uv);
    col *= ao;

    #ifdef USE_BLOOM
    col += texture2D(bloomTex, uv).rgb * 0.7;
    #endif

    // wetness: simple desaturated reflection
    #ifdef USE_WETNESS
    col = mix(col, vec3(1.0)*(col.r*0.3+col.g*0.6+col.b*0.1), clamp(wetness*0.6,0.0,1.0));
    #endif

    col = depthFog(col, depth*200.0);
    col = pow(col, vec3(1.0/2.2));
    gl_FragColor = vec4(col, 1.0);
}
