AetherRealism shaderpack (OptiFine/Iris-friendly rewrite)

This commit replaces the previous scaffold with a simplified, loader-friendly GLSL set using legacy attributes (gl_Vertex, gl_Normal, gl_MultiTexCoord0, built-in matrices) and explicit MRT outputs for better compatibility.

Installation (quick):
1. Install OptiFine or Iris (OptiFine-compatible).
2. Place this folder inside your .minecraft/shaderpacks/ directory.
3. Add textures from resources/ (blue-noise, caustics, dudv, perlinNoise, lut) or point uniforms to your resourcepack.
4. Enable Shaders in Minecraft and select AetherRealism. Use Balanced preset for first run.

If the shader still fails to load, open the shader log from the shader loader (OptiFine log) and paste the error here — I'll adapt the uniform/attribute names to match your loader.
