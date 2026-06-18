#version 120
// Clouds vertex: screen-space quad
attribute vec4 mc_Vertex;
attribute vec2 mc_TexCoord0;
varying vec2 uv;
void main(){ uv = mc_TexCoord0; gl_Position = mc_Vertex; }
