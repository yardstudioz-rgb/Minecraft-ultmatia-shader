// GBuffers terrain vertex shader - legacy attribute friendly
// Uses built-in attributes to maximize compatibility (gl_Vertex, gl_Normal, gl_MultiTexCoord0)
#version 120

varying vec3 v_worldPos;
varying vec3 v_normal;
varying vec2 v_uv;

void main() {
    vec4 worldPos = gl_ModelViewMatrix * gl_Vertex;
    v_worldPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    v_normal = normalize(gl_NormalMatrix * gl_Normal);
    v_uv = gl_MultiTexCoord0.xy;
    gl_Position = gl_ProjectionMatrix * worldPos;
}
