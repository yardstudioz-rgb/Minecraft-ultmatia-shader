#version 120
varying vec2 uv;
uniform sampler2D perlinNoise; // tiling 3D noise encoded as 2D sheets or 3D via layers
uniform vec3 sunDirection;
uniform float time;
uniform float cloudCoverage; // 0..1
uniform float cloudLightIntensity;

float hash(vec2 p) { return fract(sin(dot(p,vec2(127.1,311.7))) * 43758.5453123); }

// cheap fbm
float noiseFbm(vec3 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i=0;i<5;i++){
        vec2 tc = p.xy * pow(2.0, float(i)) + vec2(0.0, float(i)*0.3);
        f += texture2D(perlinNoise, fract(tc * 0.01)).r * amp;
        amp *= 0.5;
    }
    return f;
}

void main() {
    vec3 viewDir = vec3(uv - 0.5, 1.0);
    // Layered cloud marching (cheap)
    float cloud = 0.0;
    float baseHeight = 120.0;
    float scale = 0.02;
    for (int i=0;i<6;i++){
        float h = baseHeight + float(i) * 6.0;
        float d = noiseFbm(vec3((uv.xy * 800.0 + time * 4.0), h) * scale);
        cloud += smoothstep(0.45, 0.6, d) * exp(-float(i)*0.25);
    }
    cloud = clamp(cloud * cloudCoverage, 0.0, 1.0);

    // lighting
    float NdotL = clamp(dot(normalize(vec3(0.0,1.0,0.0)), sunDirection), 0.0, 1.0);
    vec3 skyColor = mix(vec3(0.9,0.95,1.0), vec3(1.0,0.8,0.6), pow(1.0 - sunDirection.y, 3.0));
    vec3 cloudColor = mix(vec3(0.6), skyColor, NdotL) * (0.6 + 0.4 * NdotL);
    gl_FragColor = vec4(cloudColor * cloud, cloud);
}
