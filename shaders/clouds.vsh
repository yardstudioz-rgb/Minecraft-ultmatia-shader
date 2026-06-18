// Minimal cloud vertex pass (screen-space quad)
#version 120
attribute vec4 mc_Vertex;
attribute vec2 mc_TexCoord0;
varying vec2 uv;
void main(){ uv = mc_TexCoord0; gl_Position = mc_Vertex; }
