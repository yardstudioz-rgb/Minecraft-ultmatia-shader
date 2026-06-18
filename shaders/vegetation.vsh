#version 120
attribute vec3 mc_Vertex;
attribute vec3 mc_Normal;
attribute vec2 mc_TexCoord0;
attribute float windWeight; // from custom attribute or use position.y as heuristic

uniform mat4 MODEL;
uniform mat4 MODELVIEW;
uniform mat4 PROJECTION;
uniform float time;
uniform vec3 windDirection;
uniform float windSpeed;
uniform float windStrength;

varying vec2 v_uv;

//
// Simple combined curl + sin wind used for leaves/grass
//
float snoise(vec3 v) { return fract(sin(dot(v, vec3(12.9898,78.233,45.164))) * 43758.5453); }

vec3 windOffset(vec3 worldPos, float weight) {
    // base swaying
    float phase = dot(worldPos.xz, vec2(0.12, 0.17)) + time * windSpeed;
    float sway = sin(phase) * 0.25 * weight;
    // curl-like small variation
    float curl = snoise(worldPos * 0.1 + time*0.1);
    vec3 dir = normalize(windDirection);
    return dir * sway * windStrength + vec3(0.0, abs(sway)*0.2 * weight, 0.0) + vec3(curl, curl*0.5, curl*0.3) * 0.02;
}

void main() {
    v_uv = mc_TexCoord0;
    vec4 worldPos = MODEL * vec4(mc_Vertex, 1.0);
    vec3 offset = windOffset(worldPos.xyz, mc_Vertex.y*windWeight + 0.1);
    worldPos.xyz += offset;
    gl_Position = PROJECTION * MODELVIEW * (vec4(mc_Vertex,1.0) + vec4(offset,0.0));
}
