// GBuffers terrain vertex shader
#version 120
// OptiFine-style attribute/uniform bindings are assumed by loader
attribute vec4 mc_Entity;
attribute vec3 mc_Vertex;
attribute vec2 mc_TexCoord0;
attribute vec3 mc_Normal;

uniform mat4 MODELVIEW;
uniform mat4 PROJECTION;
uniform mat4 MODEL;

varying vec3 v_pos;
varying vec3 v_normal;
varying vec2 v_uv;
varying vec3 v_worldPos;

void main() {
    vec4 worldPos = MODEL * vec4(mc_Vertex, 1.0);
    v_worldPos = worldPos.xyz;
    v_pos = (MODELVIEW * vec4(mc_Vertex,1.0)).xyz;
    v_normal = normalize((MODEL * vec4(mc_Normal,0.0)).xyz);
    v_uv = mc_TexCoord0;
    gl_Position = PROJECTION * MODELVIEW * vec4(mc_Vertex, 1.0);
}
