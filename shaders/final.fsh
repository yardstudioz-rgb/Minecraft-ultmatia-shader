#version 120
varying vec2 texcoord;
uniform sampler2D sceneTex;
uniform sampler2D depthTex;
uniform sampler2D ssaoTex; // computed optionally
uniform sampler2D bloomTex; // computed optionally
uniform sampler2D lutTex; // color grading 3D LUT as 2D strip optional
uniform vec3 sunScreenPos; // sun position in screen space
uniform vec3 moonScreenPos;
uniform vec3 sunColor;
uniform float time;
uniform vec3 cameraPos;
uniform float wetness; // 0..1 blend for rain

// Simple SSAO fallback (cheap single-sample)
float simpleSSAO(vec2 uv) {
    #ifdef USE_SSAO
    return texture2D(ssaoTex, uv).r;
    #else
    return 1.0;
    #endif
}

// depth fog
vec3 depthFog(vec3 color, float depth) {
    float fogStart = 16.0;
    float fogEnd = 256.0;
    float fog = clamp((depth - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
    vec3 fogColor = vec3(0.6, 0.7, 0.85) * 0.6; // cool atmospheric fog
    return mix(color, fogColor, fog);
}

// cheap god rays: radial blur sampling toward sun screen pos
vec3 godRays(vec2 uv, vec3 col) {
    #ifdef GOD_RAYS
    vec2 lightPos = sunScreenPos.xy;
    vec2 delta = (uv - lightPos);
    float dist = length(delta);
    vec2 step = delta * 0.02;
    vec2 cur = uv;
    float decay = 0.96;
    float weight = 0.9;
    vec3 sum = vec3(0.0);
    for (int i=0;i<20;i++){
        cur -= step;
        vec3 sample = texture2D(sceneTex, cur).rgb;
        sum += sample * weight;
        weight *= decay;
    }
    // tone down when sun occluded -> use brighter sum
    return col + sum * 0.08;
    #else
    return col;
    #endif
}

void main() {
    vec3 color = texture2D(sceneTex, texcoord).rgb;
    float depth = texture2D(depthTex, texcoord).r;
    // SSAO
    float ao = simpleSSAO(texcoord);
    color *= ao;

    // Bloom blend (bloomTex computed by separate bloom pass)
    #ifdef USE_BLOOM
    color += texture2D(bloomTex, texcoord).rgb * 0.8;
    #endif

    // God rays
    color = godRays(texcoord, color);

    // Wet surfaces / puddles: subtle screen-space reflection blend based on wetness
    #ifdef USE_WETNESS
    color = mix(color, vec3(0.98,1.02,1.03) * color, clamp(wetness*0.6, 0.0,1.0));
    #endif

    // Color grading using small LUT (if provided): simple gamma + contrast + lift
    color = pow(color, vec3(1.0/2.2)); // gamma correction
    color = mix(color*0.95 + vec3(0.02,0.01,-0.02), color, 0.0); // placeholder lift

    // Depth fog to increase cave/mist immersion
    color = depthFog(color, depth * 200.0);

    // Night adjustments: moonlight tint and star glow (overlay texture)
    #ifdef NIGHT_EFFECTS
    // blend moon tint when dayFactor low, not implemented here
    #endif

    gl_FragColor = vec4(color, 1.0);
}
