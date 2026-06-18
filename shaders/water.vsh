#version 120
// Water vertex - legacy friendly
attribute vec4 mc_Vertex;
attribute vec2 mc_TexCoord0;
varying vec2 v_uv;
void main(){ v_uv = mc_TexCoord0; gl_Position = mc_Vertex; }
