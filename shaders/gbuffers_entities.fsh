// Minimal entity GBuffers (legacy-friendly)
#version 120
varying vec2 v_uv;
void main(){
    v_uv = gl_TexCoord[0].xy;
    vec4 al = texture2D(texture2, v_uv);
    gl_FragColor = al;
}
