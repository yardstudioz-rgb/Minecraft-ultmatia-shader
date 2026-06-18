#version 120
// Vegetation vertex wind - legacy attributes
varying vec2 v_uv;

void main(){
    v_uv = gl_MultiTexCoord0.xy;
    vec4 pos = gl_Vertex;
    float time = gl_ProjectionMatrix[0][0] * 0.0; // placeholder; actual time passed via uniform if available
    // simple sway
    float sway = sin(pos.x * 0.2 + pos.y * 0.5) * 0.03;
    pos.x += sway * 0.8;
    pos.z += sway * 0.2;
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * pos;
}
