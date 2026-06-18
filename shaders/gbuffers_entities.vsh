// Placeholder scaffold files for GBuffers entity shaders
// These are minimal and intended to be extended for entities (players, mobs)

// Vertex
#version 120
attribute vec3 mc_Vertex;
attribute vec3 mc_Normal;
attribute vec2 mc_TexCoord0;
uniform mat4 MODELVIEW;
uniform mat4 PROJECTION;
void main(){
    gl_TexCoord[0] = gl_MultiTexCoord0;
    gl_Position = PROJECTION * MODELVIEW * vec4(mc_Vertex,1.0);
}
