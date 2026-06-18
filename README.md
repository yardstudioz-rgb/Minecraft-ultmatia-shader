AetherRealism shaderpack (scaffold)
Installation:
1. Install OptiFine or an equivalent shader loader that supports multiple render targets and custom passes.
2. Place this folder inside your Minecraft shaders/ directory (e.g., .minecraft/shaderpacks/AetherRealism/).
3. Place resources/ noise textures and LUT into the same folder or reference them from your resourcepack.
4. In-game: Shaders -> AetherRealism -> choose preset (ultra / balanced / performance).

Performance presets & tuning:
- clouds: high uses multi-layer marching + lighting; medium uses single-layer clouds.fsh; low disables volumetrics and draws baked simple skybox.
- shadows: use 2/3 cascades for medium/ultra; low uses a single shadow map with larger PCF kernel.
- ssr (screen-space reflections): expensive; disable on lower-end GPUs.
- ssao: toggle on/off; tune radius & samples in final.fsh.
- volumetrics: set sample count (0..8). 0 = off, 1..3 = reasonable perf/quality mix, 4+ high cost.
- water: toggle SSR/refraction, caustic detail resolution, dudv map resolution.

Art & resources:
- Provide a small blue-noise, a caustics sheet, and a 3D LUT for color grading to achieve the intended look.
- For PBR feel: prepare optional normal/specular/roughness textures that align with Minecraft atlas.

Notes & limitations:
- The GLSL provided is a focused, portable scaffold. OptiFine and shader loaders differ in semantics. You may need to adapt uniform/attribute names to the loader.
- True path-traced GI and full multi-scatter volumetric clouds are left as optional advanced modules; I provided pragmatic screen-space and cheap raymarching approximations to keep performance reasonable.
- If you want, I can replace the simple SSAO with a multi-sample horizon-based AO, integrate cascaded shadow mapping with PCSS soft shadows, or provide a higher-quality cloud raymarcher and a more accurate atmospheric model (Bruneton). Tell me which module to refine next.

Performance / compatibility checklist:
- Target GPUs: modern Nvidia/AMD discrete GPUs and mid/high-end integrated GPUs (with lower presets for low-end).
- For best results, supply normal/specular textures and a 3D LUT.
- Test on a world with a few biomes and adjust cloud coverage & water resolution before exploring massive scenes.

Credits & inspiration:
- Visual goals inspired by BSL, SEUS PTGI, Complementary Reimagined. The implementation prioritizes realistic atmosphere, cinematic post-processing, and a preserved blocky Minecraft aesthetic.
