#version 120
// Shadow pass placeholder - supports single shadow map
varying vec2 gl_TexCoord0;
uniform sampler2D shadowMap;
void main(){
    float s = texture2D(shadowMap, gl_TexCoord0.xy).r;
    gl_FragColor = vec4(vec3(s),1.0);
}
