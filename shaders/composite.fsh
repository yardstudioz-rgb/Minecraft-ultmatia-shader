#version 120
// Composite pass: reads GBuffers and depth, outputs lit scene
varying vec2 gl_TexCoord0;

uniform sampler2D gcolor;
uniform sampler2D gnormal;
uniform sampler2D gaux;
uniform sampler2D depth;
uniform vec3 sunDirection;
uniform vec3 sunColor;
uniform vec3 ambientColor;
uniform vec3 cameraPos;
uniform float time;

vec3 atmosphereScattering(vec3 viewDir, float dayFactor){
    float mu = max(dot(viewDir, sunDirection), 0.0);
    vec3 rayleigh = vec3(0.5, 0.7, 1.0) * max(mu,0.0) * 0.9;
    vec3 mie = vec3(1.0,0.9,0.7) * pow(max(mu,0.0), 0.6) * 0.04;
    return (rayleigh + mie) * dayFactor;
}

void main(){
    vec2 uv = gl_TexCoord0.xy;
    vec3 albedo = texture2D(gcolor, uv).rgb;
    vec3 N = texture2D(gnormal, uv).rgb * 2.0 - 1.0;
    vec3 aux = texture2D(gaux, uv).rgb;
    float rough = aux.r;
    float ao = aux.b;

    // simple lambert + fresnel/specular schlick approximation
    vec3 V = normalize(cameraPos - vec3(0.0)); // placeholder; full reconstruction is loader-specific
    vec3 L = normalize(sunDirection);
    float NdotL = max(dot(N,L), 0.0);
    vec3 diffuse = albedo / 3.14159265;

    // rough specular approximation
    float spec = pow(max(dot(normalize(L+V), N), 0.0), 1.0/(max(0.001,rough)));
    vec3 specColor = vec3(0.04) * spec;

    vec3 color = (diffuse + specColor) * sunColor * NdotL;
    color += atmosphereScattering(normalize(V), 1.0);
    color = mix(color, albedo * 0.3 + atmosphereScattering(normalize(V), 1.0)*0.7, 0.2);

    gl_FragColor = vec4(color, 1.0);
}
