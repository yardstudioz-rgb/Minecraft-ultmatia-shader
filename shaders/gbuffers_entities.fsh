#version 120
varying vec2 v_uv;
void main(){
    // Minimal entity fragment: copy albedo from bound texture
    vec4 albedo = texture2D(texture2, v_uv);
    gl_FragColor = albedo;
}
