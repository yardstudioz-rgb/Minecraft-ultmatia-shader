#version 120
// Shadow pass placeholder: implement cascaded shadow maps + PCF/PCSS here
varying vec2 texcoord;
uniform sampler2D shadowMap;
void main(){
    float shadow = texture2D(shadowMap, texcoord).r;
    gl_FragColor = vec4(vec3(shadow),1.0);
}
