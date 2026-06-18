// Water vertex placeholder
#version 120
attribute vec3 mc_Vertex;
attribute vec2 mc_TexCoord0;
uniform mat4 MODELVIEW;
uniform mat4 PROJECTION;
varying vec2 v_uv;
void main(){ v_uv = mc_TexCoord0; gl_Position = PROJECTION * MODELVIEW * vec4(mc_Vertex,1.0); }
