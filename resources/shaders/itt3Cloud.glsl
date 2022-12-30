#version 450
#define MC_VERSION 11901
#define MC_GL_VERSION 320
#define MC_GLSL_VERSION 150
#define MC_OS_WINDOWS
#define MC_GL_VENDOR_NVIDIA
#define MC_GL_RENDERER_GEFORCE
#define MC_FXAA_LEVEL 2
#define MC_NORMAL_MAP
#define MC_SPECULAR_MAP
#define MC_RENDER_QUALITY 1.1666666
#define MC_SHADOW_QUALITY 1.5
#define MC_HAND_DEPTH 0.25
#line 2 0


#define DIMENSION_MAIN


#line 1 1
#line 1 2



//Shadow-------------------------
	#define SHADOW_MAP_BIAS			0.9	// [0.0 0.1 0.7 0.75 0.8 0.85 0.9 0.92 0.94 0.96]

	#define VARIABLE_PENUMBRA_SHADOWS
	#define COLORED_SHADOWS

	#define SHADOW_BASIC_BLUR 		0.5 // [0.0 0.25 0.5 0.75 1.0]
	#define VPS_QUALITY 			17  // [11 17 25 37 55 83 125]
	#define VPS_SPREAD 				0.1 // [0.02 0.03 0.05 0.07 0.1 0.15 0.2 0.3 0.5 0.7 1.0 1.5 2.0 3.0 5.0 7.0 10.0]

	#define SCREEN_SPACE_SHADOWS

	#define CAUSTICS

	#define SUNLIGHT_LEAK_FIX

//GI------------------------------
	#define GI_RSM

	#define GI_QUALITY				16.0  // [8.0 12.0 16.0 24.0 32.0 48.0 64.0 96.0 128.0]
	#define GI_RADIUS				100.0 // [10.0 15.0 20.0 30.0 50.0 70.0 100.0 150.0 200.0 300.0 500.0]
	#define GI_BRIGHTNESS			1.0 // [0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.6 1.8 2.0 2.5 3.0 5.0 7.0 10.0 15.0 20.0 30.0 50.0 70.0 100.0]
	#define GI_RENDER_RESOLUTION	0.5	// [0.25 0.5]

	#define GI_SKYLIGHT_FALLOFF

//Light Misc-----------------------
	#define NOLIGHT_BRIGHTNESS				0.000005 // [0.000005 0.000007 0.00001 0.000015 0.00002 0.00003 0.00005 0.00007 0.0001 0.00015 0.0002 0.0003 0.0005 0.0007 0.001]
	#define NETHER_BRIGHTNESS 				1.0 // [0.1 0.15 0.2 0.3 0.5 0.7 1.0 1.5 2.3.5 5.0 7.0 10.0 15.0 20.0 30.0 50.0 70.0 100.0]
	#define COLD_MOONLIGHT

	#define TORCHLIGHT_BRIGHTNESS			0.02 // [0.0 0.001 0.0015 0.002 0.003 0.005 0.007 0.01 0.015 0.02 0.3 0.5 0.07 0.1 0.15 0.2 0.3 0.5 0.7 1.0 1.5 2.3.5 5.0 7.0 10.0]

	#define LIGHTMAP_CURVE 					2.2

	#define TORCHLIGHT_COLOR_TEMPERATURE 	3000 // [2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000 12000 15000]


	#define HELDLIGHT_BRIGHTNESS 			1.0 // [0.0 0.1 0.15 0.2 0.3 0.5 0.7 1.0 1.5 2.3.5 5.0 7.0 10.0 15.0 20.0 30.0 50.0 70.0 100.0]
	#define HELDLIGHT_FALLOFF 				2.0 // [1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0]
	#define NORMAL_HELDLIGHT
	#define SPECULAR_HELDLIGHT
  //#define FLASHLIGHT_HELDLIGHT
  	#define FLASHLIGHT_HELDLIGHT_FALLOFF 	1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0]


	#define SUNLIGHT_INTENSITY				1.0	// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
	#define SKYLIGHT_INTENSITY 				1.0	// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

//Sky&Fog--------------------------
  //#define ATMO_HORIZON
	#define ATMO_REFLECTION_HORIZON

  //#define INDOOR_FOG

	#define VOLUMETRIC_CLOUDS
	#define CLOUD_SHADOW

  //#define CLOUD_LOCAL_LIGHTING

	#define LANDSCATTERING
	#define LANDSCATTERING_DISTANCE		0.005 // [0.001 0.002 0.003 0.005 0.007 0.01 0.15 0.2 0.3 0.5 0.7 1.0]
	#define LANDSCATTERING_STRENGTH     1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.5 1.7 2.0 2.5 3.0 5.0 7.0 10.0 15.0 20.0 30.0 50.0 100.0]
  //#define LANDSCATTERING_SHADOW
    #define LANDSCATTERING_SHADOW_QUALITY 8 // [4 6 8 10 12 14 16 18 20 22 24 28 32 48 64 128]

	#define UNDERWATER_FOG
	#define WATERFOG_DENSITY 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
	#define UNDERWATER_VFOG_DENSITY 1.0 // [0.0 0.01 0.015 0.02 0.03 0.05 0.07 0.1 0.15 0.2 0.3 0.5 0.7 1.0 1.5 2.3.5 5.0 7.0 10.0 15.0 20.0 30.0 50.0 70.0 100.0]

	#define NETHER_BLOOM_BOOST 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

	#define NETHERFOG_DENSITY 1.0 // [0.0 0.1 0.15 0.2 0.3 0.5 0.7 1.0 1.5 2.3.5 5.0 7.0 10.0 15.0 20.0 30.0 50.0 70.0 100.0]

	#define SKY_TEXTURE_BRIGHTNESS	1.0

	#define STARS

	#define MOON_TEXTURE

	#define NIGHT_BRIGHTNESS 		0.00015 // [0.0 0.0001 0.00015 0.0002 0.0003 0.0005 0.0007 0.001 0.0015 0.002 0.003 0.005 0.007 0.01 1.0]

//Texture--------------------------
	#define TEXTURE_RESOLUTION		 0	// [0 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192]

	#define ANISOTROPIC_FILTERING_QUALITY 0 // [0 2 4 8 16 32]

	#define MOD_BLOCK_SUPPORT

  //#define PARALLAX
    #define PARALLAX_QUALITY 		 60 // [10 20 30 40 60 80 100 150 200 300 500]
	#define PARALLAX_MAX_REFINEMENTS 8 	// [0 2 4 6 8 12 16]

	#define PARALLAX_SHADOW
	#define PARALLAX_SHADOW_QUALITY  60 // [10 15 20 30 40 60 80 100 150 200 300 500]

  //#define SMOOTH_PARALLAX
  //#define PARALLAX_BASED_NORMAL
 	#define PARALLAX_DEPTH			1.0	// [0.1 0.15 0.2 0.3 0.5 0.75 1.0 1.25 1.5 1.75 2.0 3.0 5.0 7.5 10.0]

	#define FORCE_WET_EFFECT
	#define RAIN_SPLASH_EFFECT
  //#define RAIN_SPLASH_BILATERAL

//PBR------------------------------
	#define TEXTURE_PBR_FORMAT 		0 	//[0 1]

	#define ROUGHNESS_CLAMP

  //#define TERRAIN_NORMAL_CLAMP
	#define HAND_NORMAL_CLAMP
	#define ENTITY_NORMAL_CLAMP

	#define SKY_IMAGE_RESOLUTION 60.0 // [30.0 40.0 60.0 100.0 150.0 200.0 300.0 500.0]

	//#define LANDSCATTERING_REFLECTION
    //#define VFOG_REFLECTION

	//#define LANDSCATTERING_REFRACTION
	//#define VFOG_REFRACTION

  //#define TEXTURE_EMISSIVENESS
	#define EMISSIVENESS_BRIGHTNESS 0.5 // [0.0 0.1 0.2 0.3 0.5 0.7 1.0 1.5 2.0 3.0 5.0 7.0 10.0 15.0 20.0 30.0 50.0 70.0 100.0]
	#define EMISSIVENESS_GAMMA 		2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

//Texture Misc---------------------
	#define WATER_REFRACT_IOR		1.2
	#define WATER_PARALLAX
	#define WAVE_SCALE 				0.06 // [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.15 0.2 0.3 0.5 0.7 1.0]
	#define WAVE_HEIGHT 			1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 5.0 7.0 10.0]

	#define RAIN_SHADOW 			1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

	#define SURFACE_WETNESS 		0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

 	#define CORRECT_PARTICLE_NORMAL

	#define RAIN_VISIBILITY			1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 5.0]

	#define SELECTION_BOX_COLOR		1.0	// [0.0 1.0]

	#define ENTITY_STATUS_COLOR
	#define EYES_LIGHTING

  //#define GENERAL_GRASS_FIX
	#define WAVING_PLANTS
  //#define PLANT_TOUCH_EFFECT
	#define ANIMATION_SPEED 1.0


//DOF------------------------------
  //#define DOF
	#define DOF_SAMPLES 32 				// [16 32 64 128 256 512 1024]
	#define CAMERA_FOCUS_MODE 0 		// [0 1]
	#define CAMERA_FOCAL_POINT 10.0 	// [0.2 0.3 0.4 0.6 0.8 1.0 1.25 1.5 1.75 2.0 2.5 3.0 3.5 4.0 5.0 6.0 8.0 10.0 12.5 15.0 17.5 20.0 15.0 30.0 40.0 50.0 60.0 80.0 100.0 150.0 200.0 250.0 300.0 400.0 500.0 600.0 800.0 1000.0]
	#define CAMERA_AUTO_FOCAL_OFFSET 0 	//[-16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12 13 14 15 16]

	#define CAMERA_APERTURE 2.8 // [0.95 1.2 1.4 1.8 2.8 4 5.6 8.0 11.0 16.0 22.0]


//Bloom----------------------------
	#define BLOOM_EFFECTS

	#define BLOOM_AMOUNT			1.5	// [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 7.0 10.0]

	#define LENS_FLARE

  	#define GLARE_BRIGHTNESS 		1.0 // [0.1 0.2 0.3 0.5 0.7 1.0 1.5 2.0 3.0 5.0 7.0 10.0 15.0 20.0]
  	#define FLARE_BRIGHTNESS 		1.0 // [0.1 0.2 0.3 0.5 0.7 1.0 1.5 2.0 3.0 5.0 7.0 10.0 15.0 20.0]
	#define FLARE_GHOSTING
  //#define FLARE_SHADOWBASED

//TAA------------------------------
	#define TAA

	#define TAA_AGGRESSION 			0.97
	#define TAA_SHARPEN
	#define TAA_SHARPNESS 			0.5     //[0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

//Motion Blur----------------------
	#define MOTION_BLUR
	#define MOTION_BLUR_DITHER
	#define MOTION_BLUR_QUALITY 3 // [2 3 5 10 20 30 50 100]
	#define MOTION_BLUR_SUTTER_ANGLE 90.0 // [45.0 90.0 135.0 180.0 270.0 360.0]

//Exposure-------------------------
  //#define MANUAL_EXPOSURE
	#define EV_VALUE 	14 		// [0 1.0/3.0 2.0/3.0 1 1+1.0/3.0 1+2.0/3.0 2 2+1.0/3.0 2+2.0/3.0 3 3+1.0/3.0 3+2.0/3.0 4 4+1.0/3.0 4+2.0/3.0 5 5+1.0/3.0 5+2.0/3.0 6 6+1.0/3.0 6+2.0/3.0 7 7+1.0/3.0 7+2.0/3.0 8 8+1.0/3.0 8+2.0/3.0 9 9+1.0/3.0 9+2.0/3.0 10 10+1.0/3.0 10+2.0/3.0 11 11+1.0/3.0 11+2.0/3.0 12 12+1.0/3.0 12+2.0/3.0 13 13+1.0/3.0 13+2.0/3.0 14 14+1.0/3.0 14+2.0/3.0 15 15+1.0/3.0 15+2.0/3.0 16 16+1.0/3.0 16+2.0/3.0 17 17+1.0/3.0 17+2.0/3.0 18 18+1.0/3.0 18+2.0/3.0 19 19+1.0/3.0 19+2.0/3.0 20]
	#define AE_OFFSET	0 		// [-5 -4-2.0/3.0 -4-1.0/3.0 -4 -3-2.0/3.0 -3-1.0/3.0 -3 -2-2.0/3.0 -2-1.0/3.0 -2 -1-2.0/3.0 -1-1.0/3.0 -1 -2.0/3.0 -1.0/3.0 0 1/3 2/3 1 1+1.0/3.0 1+2.0/3.0 2 2+1.0/3.0 2+2.0/3.0 3 3+1.0/3.0 3+2.0/3.0 4 4+1.0/3.0 4+2.0/3.0 5]
	#define AE_MODE		0 		// [0 1 2 3]
	#define AE_CURVE	0.7 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
	#define AE_CLAMP
	#define LUMINANCE_WEIGHT
	#define LUMINANCE_WEIGHT_MODE 		0 	// [0 1 2]
	#define LUMINANCE_WEIGHT_STRENGTH 	0.7 // [0.5 0.7 1.0 1.5 2.0]

	#define SMOOTH_EXPOSURE
	#define EXPOSURE_TIME 	1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0]

//Post-----------------------------
	#define TONEMAP_OPERATOR 	Default // Each tonemap operator defines a different way to present the raw internal HDR color information to a color range that fits nicely with the limited range of monitors/displays. Each operator gives a different feel to the overall final image. [Default SEUSTonemap LottesTonemap UchimuraTonemap HableTonemap ACESTonemap ACESTonemap2 None]
	#define TONEMAP_CURVE 		1.0 // Controls the intensity of highlights. Lower values give a more filmic look, higher values give a more vibrant/natural look. Default: 2.0 [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 5.0]


  //#define ADVANCED_COLOR
	#define GAMMA 				1.0 // Gamma adjust. Lower values make shadows darker. Higher values make shadows brighter. Default: 1.0 [0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5]
	#define LUMA_GAMMA 			1.0 // Gamma adjust of luminance only. Preserves colors while adjusting contrast. Lower values make shadows darker. Higher values make shadows brighter. Default: 1.0 [0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5]
	#define SATURATION 			1.0 // Saturation adjust. Higher values give a more colorful image. Default: 1.0 [0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
	#define WHITE_CLIP 			0.0 // Higher values will introduce clipping to white on the highlights of the image. [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]
	#define WHITE_BALANCE 		6500 // [4000 4100 4200 4300 4400 4500 4600 4700 4800 4900 5000 5100 5200 5300 5400 5500 5600 5700 5800 5900 6000 6100 6200 6300 6400 6500 6600 6700 6800 6900 7000 7100 7200 7300 7400 7500 7600 7700 7800 7900 8000 8100 8200 8300 8400 8500 8600 8700 8800 8900 9000 9100 9200 9300 9400 9500 9600 9700 9800 9900 10000 10100 10200 10300 10400 10500 10600 10700 10800 10900 11000 11100 11200 11300 11400 11500 11600 11700 11800 11900 12000]
	#define TINT_BALANCE 		0.0 // [-1.0 -0.95 -0.9 -0.85 -0.8 -0.75 -0.7 -0.65 -0.6 -0.55 -0.5 -0.45 -0.4 -0.35 -0.3 -0.25 -0.2 -0.15 -0.1 -0.05 0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

	#define POST_SHARPENING 	1 //[0 1 2 3]

	#define SEREEN_RATIO 		0.0 // [0.0 1.333333 1.435052 1.5 1.6 1.777778 2.0 2.333333 2.39]

  //#define LOWLIGHT_COLORFADE
	#define LOWLIGHT_COLORFADE_THRESHOLD 0.0001 // [0.00001 0.000015 0.00002 0.00003 0.00005 0.00007 0.0001 0.00015 0.0002 0.0003 0.0005 0.0007 0.001]
	#define LOWLIGHT_COLORFADE_STRENGTH  0.7 	// [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
  //#define LUT



//Other----------------------------
  //#define CAVE_MODE
  //#define WHITE_DEBUG_WORLD
  #define TITLE
  //#define TEAPOT
  //#define DEBUG_COUNTER
#line 2 1

uniform int heldItemId;
uniform int heldBlockLightValue;
uniform int heldItemId2;
uniform int heldBlockLightValue2;
uniform int fogMode;
uniform float fogDensity;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform int worldTime;
uniform int worldDay;
uniform int moonPhase;
uniform int frameCounter;
uniform float frameTime;
uniform float frameTimeCounter;
uniform float sunAngle;
uniform float shadowAngle;
uniform float rainStrength;
uniform float aspectRatio;
uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 shadowLightPosition;
uniform vec3 upPosition;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform float wetness;
uniform float eyeAltitude;
uniform ivec2 eyeBrightness;
uniform ivec2 eyeBrightnessSmooth;
uniform int isEyeInWater;
uniform float nightVision;
uniform float blindness;
uniform float screenBrightness;
uniform int hideGUI;
uniform float centerDepthSmooth;
uniform ivec2 atlasSize;
uniform vec4 spriteBounds;
uniform vec4 entityColor;
uniform int entityId;
uniform int blockEntityId;
uniform ivec4 blendFunc;
uniform int instanceId;
uniform float playerMood;
uniform int renderStage;

uniform vec2 taaJitter;
uniform vec2 screenSize;
uniform vec2 pixelSize;
uniform float mainOutputFactor;
uniform float eyeBrightnessSmoothCurved;
uniform float eyeBrightnessZeroSmooth;
uniform float eyeSnowySmooth;
uniform float eyeRySmooth;


uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D colortex8;
#ifdef COLORTEX9_2D
    uniform sampler2D colortex9;
#else
    uniform sampler3D colortex9;
#endif
uniform sampler2D colortex10;
uniform sampler2D colortex11;
uniform sampler2D colortex12;
uniform sampler2D gdepthtex;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D noisetex;
#line 8 0
#line 1 3
#define iterationT_VERSION AT // [AT BT]
#define iterationT_VERSION_TYPE AT // [AT BT]


//Renewed modified by Tahnass


const float PI = 3.14159265359;


float saturate(float x){
	return clamp(x, 0.0, 1.0);
}

vec2 saturate(vec2 x){
	return clamp(x, vec2(0.0), vec2(1.0));
}

vec3 saturate(vec3 x){
	return clamp(x, vec3(0.0), vec3(1.0));
}

vec3 LinearToGamma(vec3 c){
	return pow(c, vec3(1.0 / 2.2));
}

vec3 GammaToLinear(vec3 c){
	return pow(c, vec3(2.2));
}

vec3 LinearToCurve(vec3 c){
	return pow(c, vec3(0.25));
}

vec3 CurveToLinear(vec3 c){
	c = c * c;
	return c * c;
}

float LinearToCurve(float c){
	return pow(c, 0.25);
}

float CurveToLinear(float c){
	c = c * c;
	return c * c;
}


float curve(float x){
	return x * x * (3.0 - 2.0 * x);
}

vec3 curve(vec3 x){
	return x * x * (3.0 - 2.0 * x);
}

float remap(float e0, float e1, float x){
	return saturate((x - e0) / (e1 - e0));
}

float atan2(vec2 v){
	return v.x == 0.0 ?
		(1.0 - step(abs(v.y), 0.0)) * sign(v.y) * PI * 0.5 :
		atan(v.y / v.x) + step(v.x, 0.0) * sign(v.y) * PI;
}

float Luminance(vec3 c){
	return dot(c, vec3(0.2125, 0.7154, 0.0721));
}

void DoNightEye(inout vec3 c){
	float luminance = Luminance(c);
	c = mix(c, luminance * vec3(0.7771, 1.0038, 1.6190), vec3(0.5));
}



float Pack2x8(vec2 x){
    return dot(floor(x * 255.0), vec2(1.0, 256.0) / 65535.0);
}

vec2 Unpack2x8(float x){
    x *= 65535.0;
	float a = fract(x / 256.0) * 256.0;
	return vec2(a / 255.0, (x - a) / 65280.0);
}

vec4 PackRGBE16(vec3 x){
    const float r16 = 1.0 / 65535.0;
    float exponentPart = floor(log2(max(max(x.r, x.g), x.b)));
    vec3 mantissaPart = saturate((32768.0 * r16) * x / exp2(exponentPart));
    exponentPart = saturate((exponentPart + 32767.0) * r16);
    return vec4(mantissaPart, exponentPart);
}

vec3 UnpackRGBE16(vec4 x){
    float exponentPart = exp2(x.a * 65535.0 - 32767.0);
    vec3 mantissaPart = (131070.0 / 65536.0) * x.rgb;

    return exponentPart * mantissaPart;
}

vec4 PackRGB16E8P8(vec4 x){
    float exponentPart = floor(log2(max(max(x.r, x.g), x.b)));
    vec3 mantissaPart = saturate(32768.0 / 65535.0 * x.rgb / exp2(exponentPart));
    exponentPart = saturate((exponentPart + 127.0) / 255.0);

    return vec4(mantissaPart, Pack2x8(vec2(exponentPart, saturate(x.a))));
}

vec4 UnpackRGB16E8P8(vec4 x){
    vec2 u8 = Unpack2x8(x.a);
	float exponentPart = exp2(u8.x * 255.0 - 127.0);
    vec3 mantissaPart = (131070.0 / 65536.0) * x.rgb;

    return vec4(exponentPart * mantissaPart, u8.y);
}

vec3 DecodeNormalTex(vec3 texNormal){
	vec3 normal = texNormal.xyz * 2.0 - 1.0;
	#if TEXTURE_PBR_FORMAT == 1
		normal.z = sqrt(1.0 - dot(normal.xy, normal.xy));
	#endif
	normal.xy = max(abs(normal.xy) - 1.0 / 255.0, 0.0) * sign(normal.xy);
	return normal;
}

vec2 OctWrap(vec2 v) {
	return (1.0 - abs(v.yx)) * (step(0.0, v.xy) * 2.0 - 1.0);
}

vec2 EncodeNormal(vec3 n){ // Signed Octahedron.
	n.xy /= (abs(n.x) + abs(n.y) + abs(n.z));
	n.xy = n.z >= 0.0 ? n.xy : OctWrap(n.xy);

	return n.xy * 0.5 + 0.5;
}

vec3 DecodeNormal(vec2 en){ // Signed Octahedron.
	vec2 n = en * 2.0 - 1.0;

    float nz = 1.0 - abs(n.x) - abs(n.y);
	return normalize(vec3(nz >= 0 ? n : OctWrap(n), nz));
}

vec3 Blackbody(float temperature){
	// https://en.wikipedia.org/wiki/Planckian_locus
	const vec4[2] xc = vec4[2](
		vec4(-0.2661293e9,-0.2343589e6, 0.8776956e3, 0.179910), // 1667k <= t <= 4000k
		vec4(-3.0258469e9, 2.1070479e6, 0.2226347e3, 0.240390)  // 4000k <= t <= 25000k
	);
	const vec4[3] yc = vec4[3](
		vec4(-1.1063814,-1.34811020, 2.18555832,-0.20219683), // 1667k <= t <= 2222k
		vec4(-0.9549476,-1.37418593, 2.09137015,-0.16748867), // 2222k <= t <= 4000k
		vec4( 3.0817580,-5.87338670, 3.75112997,-0.37001483)  // 4000k <= t <= 25000k
	);

	float temperatureSquared = temperature * temperature;
	vec4 t = vec4(temperatureSquared * temperature, temperatureSquared, temperature, 1.0);

	float x = dot(1.0 / t, temperature < 4000.0 ? xc[0] : xc[1]);
	float xSquared = x * x;
	vec4 xVals = vec4(xSquared * x, xSquared, x, 1.0);

	vec3 xyz = vec3(0.0);
	xyz.y = 1.0;
	xyz.z = 1.0 / dot(xVals, temperature < 2222.0 ? yc[0] : temperature < 4000.0 ? yc[1] : yc[2]);
	xyz.x = x * xyz.z;
	xyz.z = xyz.z - xyz.x - 1.0;

    const mat3 xyzToSrgb = mat3(
        3.24097, -0.96924, 0.05563,
        -1.53738, 1.87597, -0.20398,
        -0.49861, 0.04156, 1.05697
    );

	return max(xyzToSrgb * xyz, vec3(0.0));
}



vec2 RaySphereIntersection(vec3 p, vec3 dir, float r){
	float b = dot(p, dir);
	float c = -r * r + dot(p, p);
	float d = b * b - c;

	if (d < 0.0) return vec2(10000.0, -10000.0);

	d = sqrt(d);

	return vec2(-b - d, -b + d);
}


float RayleighPhaseFunction(float nu) {
    return 0.059683104 * (nu * nu + 1.0);
}

float MiePhaseFunction(float g, float nu) {
    float gg = g * g;
    float k = 0.1193662 * (1.0 - gg) / (2.0 + gg);
    return k * (1.0 + nu * nu) * pow(1.0 + gg - 2.0 * g * nu, -1.5);
}



float InterleavedGradientNoise(vec2 c){
    return fract(52.9829189 * fract(0.06711056 * c.x + 0.00583715 * c.y));
}

vec3 rand(vec2 coord){
	float noiseX = saturate(fract(sin(dot(coord, vec2(12.9898, 78.223))) * 43758.5453));
	float noiseY = saturate(fract(sin(dot(coord, vec2(12.9898, 78.223)*2.0)) * 43758.5453));
	float noiseZ = saturate(fract(sin(dot(coord, vec2(12.9898, 78.223)*3.0)) * 43758.5453));

	return vec3(noiseX, noiseY, noiseZ);
}

uint triple32(uint x){
    // https://nullprogram.com/blog/2018/07/31/
    x ^= x >> 17;
    x *= 0xed5ad4bbu;
    x ^= x >> 11;
    x *= 0xac4c1b51u;
    x ^= x >> 15;
    x *= 0x31848babu;
    x ^= x >> 14;
    return x;
}

#ifdef ENABLE_RAND
	uint randState = triple32(uint(gl_FragCoord.x + screenSize.x * gl_FragCoord.y) + uint(screenSize.x * screenSize.y) * frameCounter);
	uint RandNext(){
	    return randState = triple32(randState);
	}
	#define RandNext2() uvec2(RandNext(), RandNext())
	#define RandNext3() uvec3(RandNext2(), RandNext())
	#define RandNext4() uvec4(RandNext3(), RandNext())
	#define RandNextF() (float(RandNext()) / float(0xffffffffu))
	#define RandNext2F() (vec2(RandNext2()) / float(0xffffffffu))
	#define RandNext3F() (vec3(RandNext3()) / float(0xffffffffu))
	#define RandNext4F() (vec4(RandNext4()) / float(0xffffffffu))
#endif

float bayer2(vec2 a) {
	a = floor(a);

	return fract(dot(a, vec2(0.5, a.y * 0.75)));
}

float bayer4(const vec2 a)   { return bayer2 (0.5   * a) * 0.25     + bayer2(a); }
float bayer8(const vec2 a)   { return bayer4 (0.5   * a) * 0.25     + bayer2(a); }
float bayer16(const vec2 a)  { return bayer4 (0.25  * a) * 0.0625   + bayer4(a); }
float bayer32(const vec2 a)  { return bayer8 (0.25  * a) * 0.0625   + bayer4(a); }
float bayer64(const vec2 a)  { return bayer8 (0.125 * a) * 0.015625 + bayer8(a); }
float bayer128(const vec2 a) { return bayer16(0.125 * a) * 0.015625 + bayer8(a); }
#line 9 0


const int 		noiseTextureResolution  = 64;

const float		sunPathRotation	= -30;		// [-90 -89 -88 -87 -86 -85 -84 -83 -82 -81 -80 -79 -78 -77 -76 -75 -74 -73 -72 -71 -70 -69 -68 -67 -66 -65 -64 -63 -62 -61 -60 -59 -58 -57 -56 -55 -54 -53 -52 -51 -50 -49 -48 -47 -46 -45 -44 -43 -42 -41 -40 -39 -38 -37 -36 -35 -34 -33 -32 -31 -30 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 ]


/* DRAWBUFFERS:137 */
layout(location = 0) out vec4 compositeOutput1;
layout(location = 1) out vec4 compositeOutput3;
layout(location = 2) out vec4 compositeOutput7;


in vec2 texcoord;

in vec3 worldShadowVector;
in vec3 shadowVector;
in vec3 worldSunVector;
in vec3 worldMoonVector;

in vec3 colorShadowlight;
in vec3 colorSunlight;
in vec3 colorMoonlight;

in vec3 colorSkylight;
in vec3 colorSunSkylight;
in vec3 colorMoonSkylight;

in vec3 colorTorchlight;

in float timeNoon;
in float timeMidnight;


#line 1 4


float CurveBlockLightSky(float blockLight){
	blockLight = 1.0 - pow(1.0 - blockLight * 0.9, 0.7);

	blockLight = saturate(blockLight * blockLight * blockLight * 1.95);

	return blockLight;
}

float CurveBlockLightTorch(float blockLight){
	float dist = (1.0 - blockLight) * 15.0 + 1.0;
	dist = dist * dist;

	blockLight *= curve(saturate(blockLight * 4.0 - 0.17));
	blockLight /= dist;

	return blockLight;
}

struct Material {
	float rawSmoothness;
	float rawMetalness;
	float roughness;
	float metalness;
	float f0;
	vec3 n;
	vec3 k;
	float emissiveness;
	bool albedoTintsMetalReflections;
	bool doCSR;
};

struct GbufferData {
	vec3 albedo;
	vec4 albedoW;
	vec3 normalL;
	vec3 normalW;
	float depthL;
	float depthW;
	vec2 lightmapL;
	vec2 lightmapW;
	float materialIDL;
	float materialIDW;
	float waterMask;
	float rainAlpha;
	float parallaxShadow;
	Material material;
};

struct Ray {
	vec3 dir;
	vec3 origin;
};

struct Plane {
	vec3 normal;
	vec3 origin;
};

struct Intersection {
	vec3 pos;
	float distance;
	float angle;
};

float F0ToIor(float f0) {
	f0 = sqrt(f0) * 0.99999; // *0.99999 to prevent divide by 0 errors
	return (1.0 + f0) / (1.0 - f0);
}
vec3 F0ToIor(vec3 f0) {
	f0 = sqrt(f0) * 0.99999; // *0.99999 to prevent divide by 0 errors
	return (1.0 + f0) / (1.0 - f0);
}

const Material airMaterial 		= Material(0.0, 0.0, 0.0, 0.0, 0.0,    vec3(1.000275), vec3(0.0), 0.0, false, false);
const Material material_water 	= Material(1.0, 0.0, 0.0, 0.0, 0.1427, vec3(1.200000), vec3(0.0), 0.0, false, true);
const Material material_glass 	= Material(1.0, 0.0, 0.0, 0.0, 0.1863, vec3(1.458000), vec3(0.0), 0.0, false, true);
const Material material_ice 	= Material(1.0, 0.0, 0.0, 0.0, 0.1338, vec3(1.309000), vec3(0.0), 0.0, false, true);

Material MaterialFromTex(inout vec3 baseTex, vec4 specTex)
{
	//materialID = floor(materialID * 255.0);
	Material material;
	float wet = specTex.a;

	#if TEXTURE_PBR_FORMAT == 0
		material.rawSmoothness = mix(specTex.r, 1.0, wet);
		material.rawMetalness = specTex.g;

		material.roughness = 1.0 - material.rawSmoothness;
		material.roughness *= material.roughness;

		material.metalness = material.rawMetalness;

		material.f0 = material.rawMetalness * 0.96 + 0.04;

		material.emissiveness = specTex.b;


	#elif TEXTURE_PBR_FORMAT == 1
		bool isMetal = specTex.g > (229.5 / 255.0);

		material.rawSmoothness = mix(specTex.r, 1.0, wet);
		material.rawMetalness = float(isMetal);

		material.roughness = 1.0 - material.rawSmoothness;
		material.roughness *= material.roughness;

		material.metalness = material.rawMetalness;

		if (isMetal){
			material.f0 = 0.91;
			int index = int(specTex.g * 255.0 + 0.5) - 230;
			material.albedoTintsMetalReflections = index < 8;
			if (material.albedoTintsMetalReflections) {
				vec3[8] metalN = vec3[8](
					vec3(2.91140, 2.94970, 2.58450), // Iron
					vec3(0.18299, 0.42108, 1.37340), // Gold
					vec3(1.34560, 0.96521, 0.61722), // Aluminium
					vec3(3.10710, 3.18120, 2.32300), // Chrome
					vec3(0.27105, 0.67693, 1.31640), // Copper
					vec3(1.91000, 1.83000, 1.44000), // Lead
					vec3(2.37570, 2.08470, 1.84530), // Platinum
					vec3(0.15943, 0.14512, 0.13547)  // Silver
				);
				vec3[8] metalK = vec3[8](
					vec3(3.0893, 2.9318, 2.7670), // Iron
					vec3(3.4242, 2.3459, 1.7704), // Gold
					vec3(7.4746, 6.3995, 5.3031), // Aluminium
					vec3(3.3314, 3.3291, 3.1350), // Chrome
					vec3(3.6092, 2.6248, 2.2921), // Copper
					vec3(3.5100, 3.4000, 3.1800), // Lead
					vec3(4.2655, 3.7153, 3.1365), // Platinum
					vec3(3.9291, 3.1900, 2.3808)  // Silver
				);

				material.n = metalN[index];
				material.k = metalK[index];
			} else {
				material.n = F0ToIor(baseTex.rgb) * airMaterial.n;
				material.k = vec3(0.0);
			}
		} else {
			material.f0 = specTex.g * 0.96 + 0.04;
			material.n = F0ToIor(mix(vec3(0.04) * material.rawSmoothness, baseTex, material.rawMetalness)) * airMaterial.n;
			material.k = vec3(0.0);

			material.albedoTintsMetalReflections = false;
		}

		material.emissiveness = specTex.b == 1.0 ? 0.0 : specTex.b;

	#endif


	#ifdef ROUGHNESS_CLAMP
		material.doCSR = max(0.625 - material.roughness, 0.0) + material.rawMetalness > 0.0001;
	#else
		material.doCSR = max(1.0 - material.roughness, 0.0) + material.rawMetalness > 0.0001;
	#endif

	material.emissiveness = pow(material.emissiveness, EMISSIVENESS_GAMMA);

	baseTex *= 1.0 - saturate(wet * 2.5 - 1.5) * 0.3;

	return material;
}



GbufferData GetGbufferData()
{
	GbufferData data;

	vec4 gbuffer0 = texture(colortex0, texcoord.st);
	vec4 gbuffer3 = texture(colortex3, texcoord.st);
	vec4 gbuffer4 = texture(colortex4, texcoord.st);
	vec4 gbuffer5 = texture(colortex5, texcoord.st);
	vec4 gbuffer6 = texture(colortex6, texcoord.st);

	data.albedo 		= GammaToLinear(gbuffer0.rgb);
	data.albedoW 		= vec4(Unpack2x8(gbuffer5.r), Unpack2x8(gbuffer5.g));
	data.albedoW.rgb 	= GammaToLinear(data.albedoW.rgb);
	data.normalL 		= DecodeNormal(gbuffer3.rg);
	data.normalW 		= DecodeNormal(gbuffer4.rg);
	data.depthL 		= texture(depthtex1, texcoord.st).x;
	data.depthW 		= texture(gdepthtex, texcoord.st).x;
	data.lightmapL 		= gbuffer3.ba;
	data.lightmapW 		= gbuffer4.ba;
	//data.lightmapL 		= vec2(CurveBlockLightTorch(data.lightmapL.r), CurveBlockLightSky(data.lightmapL.g));
	//data.lightmapW 		= vec2(CurveBlockLightTorch(data.lightmapW.r), CurveBlockLightSky(data.lightmapW.g));
	data.lightmapL 		= vec2(data.lightmapL.r, CurveBlockLightSky(data.lightmapL.g));
	data.lightmapW 		= vec2(data.lightmapW.r, CurveBlockLightSky(data.lightmapW.g));
	data.materialIDL 	= gbuffer6.b;
	data.materialIDW 	= gbuffer5.b;
	data.waterMask 		= gbuffer5.a;
	data.rainAlpha 		= 1.0 - gbuffer0.a;
	//data.rainAlpha 		= data.rainAlpha > 0.999 ? 0.0 : data.rainAlpha;
	data.parallaxShadow = gbuffer6.a;


	vec4 specTex		= vec4(Unpack2x8(gbuffer6.r), Unpack2x8(gbuffer6.g));
	data.material       = MaterialFromTex(data.albedo, specTex);

	return data;
}


struct MaterialMask
{
	float sky;
	float land;
	float grass;
	float leaves;
	float hand;
	float entityPlayer;
	float water;
	float stainedGlass;
	float ice;

	float entitys;
	float entitysLitHigh;
	float entitysLitMedium;
	float entitysLitLow;
	float lightning;

	float torch;
	float lava;
	float glowstone;
	float fire;
	float redstoneTorch;
	float redstone;
	float soulFire;
	float amethyst;
	float endPortal;

	float eyes;
	float particle;
	float particlelit;

	float selection;
	float debug;
};

MaterialMask CalculateMasks(float materialID)
{
	MaterialMask mask;

	materialID = floor(materialID * 255.0);

	mask.sky				= float(materialID == 0.0);
	mask.land				= float(materialID == 1.0);
	mask.grass				= float(materialID == 2.0);
	mask.leaves				= float(materialID == 3.0);
	mask.hand				= float(materialID == 4.0);
	mask.entityPlayer		= float(materialID == 5.0);
	mask.water				= float(materialID == 6.0);
	mask.stainedGlass		= float(materialID == 7.0);
	mask.ice				= float(materialID == 8.0);

	mask.entitys			= float(materialID == 10.0);
	mask.entitysLitHigh		= float(materialID == 11.0);
	mask.entitysLitMedium	= float(materialID == 12.0);
	mask.entitysLitLow		= float(materialID == 13.0);
	mask.lightning			= float(materialID == 14.0);

	mask.torch				= float(materialID == 25.0);
	mask.lava 				= float(materialID == 26.0);
	mask.glowstone 			= float(materialID == 27.0);
	mask.fire 				= float(materialID == 28.0);
	mask.redstoneTorch 		= float(materialID == 29.0);
	mask.redstone	 		= float(materialID == 30.0);
	mask.soulFire	 		= float(materialID == 31.0);
	mask.amethyst	 		= float(materialID == 32.0);
	mask.endPortal	 		= float(materialID == 33.0);

	mask.eyes				= float(materialID == 38.0);
	mask.particle			= float(materialID == 39.0);
	mask.particlelit		= float(materialID == 40.0);

	mask.selection			= float(materialID == 200.0);
	mask.debug				= float(materialID == 201.0);

	return mask;
}

void FixParticleMask(inout MaterialMask materialMaskSoild, inout MaterialMask materialMask, inout float depthL, in float depthW){
	#if MC_VERSION >= 11500
	if(materialMaskSoild.particle > 0.5 || materialMaskSoild.particlelit > 0.5){
		materialMask.particle = 1.0;
		materialMask.water = 0.0;
		materialMask.stainedGlass = 0.0;
		materialMask.ice = 0.0;
		materialMask.sky = 0.0;
		depthL = depthW;
	}
	#endif
}

void FixParticleMask(inout MaterialMask materialMaskSoild, inout MaterialMask materialMask){
	#if MC_VERSION >= 11500
	if(materialMaskSoild.particle > 0.5 || materialMaskSoild.particlelit > 0.5){
		materialMask.particle = 1.0;
		materialMask.water = 0.0;
		materialMask.stainedGlass = 0.0;
		materialMask.ice = 0.0;
		materialMask.sky = 0.0;
	}
	#endif
}

void ApplyMaterial(inout Material material, in MaterialMask materialMask, inout bool isSmooth){
	if (materialMask.water > 0.5){
		material = material_water;
		isSmooth = true;
	}
	if (materialMask.stainedGlass > 0.5){
		material = material_glass;
		isSmooth = true;
	}
	if (materialMask.ice > 0.5){
		material = material_ice;
		isSmooth = true;
	}
}
#line 44 0
#line 1 5
vec3 ViewPos_From_ScreenPos(vec2 coord, float depth){
	#ifdef TAA
		coord -= taaJitter * 0.5;
	#endif
	vec3 ndcPos = vec3(coord, depth) * 2.0 - 1.0;
	vec3 viewPos = vec3(vec2(gbufferProjectionInverse[0].x, gbufferProjectionInverse[1].y) * ndcPos.xy, 0.0) + gbufferProjectionInverse[3].xyz;
	return viewPos / (gbufferProjectionInverse[2].w * ndcPos.z + gbufferProjectionInverse[3].w);
}

vec3 ViewPos_From_ScreenPos_Raw(vec2 coord, float depth){
	vec3 ndcPos = vec3(coord, depth) * 2.0 - 1.0;
	vec3 viewPos = vec3(vec2(gbufferProjectionInverse[0].x, gbufferProjectionInverse[1].y) * ndcPos.xy, 0.0) + gbufferProjectionInverse[3].xyz;
	return viewPos / (gbufferProjectionInverse[2].w * ndcPos.z + gbufferProjectionInverse[3].w);
}

vec3 ScreenPos_From_ViewPos_Raw(vec3 viewPos){
	vec3 screenPos = vec3(gbufferProjection[0].x, gbufferProjection[1].y, gbufferProjection[2].z) * viewPos + gbufferProjection[3].xyz;
	return screenPos * (0.5 / -viewPos.z) + 0.5;
}

float LinearDepth_From_ScreenDepth(float depth){
    depth = depth * 2.0 - 1.0;
    return 1.0 / (depth * gbufferProjectionInverse[2][3] + gbufferProjectionInverse[3][3]);
}

float ScreenDepth_From_LinearDepth(float depth){
	depth = (1.0 / depth - gbufferProjectionInverse[3][3]) / gbufferProjectionInverse[2][3];
    return depth * 0.5 + 0.5;
}
#line 45 0
#line 1 6
vec3 ShadowPos_From_WorldPos_Distorted_Biased(vec3 worldPos, vec3 worldNormal, out float dist, out float distortFactor){
	vec3 sn = normalize((shadowModelView * vec4(worldNormal.xyz, 0.0)).xyz) * vec3(1, 1, -1);

	vec4 sp = (shadowModelView * vec4(worldPos, 1.0));
	sp = shadowProjection * sp;
	vec3 shadowPos = sp.xyz / sp.w;

	dist = length(shadowPos.xy);
	distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;
	shadowPos.xyz += sn * 0.002 * distortFactor;
	shadowPos.xy *= 0.95f / distortFactor;

	shadowPos.z = mix(shadowPos.z, 0.5, 0.8);

	return shadowPos * 0.5f + 0.5f;
}

vec3 ShadowPos_From_WorldPos_Distorted(vec3 worldPos){
	vec4 sp = (shadowModelView * vec4(worldPos, 1.0));
	sp = shadowProjection * sp;
	vec3 shadowPos = sp.xyz / sp.w;

	float dist = length(shadowPos.xy);
	float distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;
	shadowPos.xy *= 0.95f / distortFactor;

	shadowPos.z = mix(shadowPos.z, 0.5, 0.8);

	return shadowPos * 0.5f + 0.5f;
}

vec3 ShadowPos_From_WorldPos(vec3 worldPos){
	vec4 sp = (shadowModelView * vec4(worldPos, 1.0));
	sp = shadowProjection * sp;
	vec3 shadowPos = sp.xyz / sp.w;

	shadowPos.z = mix(shadowPos.z, 0.5, 0.8);

	return shadowPos * 0.5f + 0.5f;
}

vec3 ShadowPos_From_WorldPos_Raw(vec3 worldPos){
	vec4 sp = (shadowModelView * vec4(worldPos, 1.0));
	sp = shadowProjection * sp;
	vec3 shadowPos = sp.xyz / sp.w;

	return shadowPos * 0.5f + 0.5f;
}

vec2 DistortShadowPos(vec2 shadowPos){
	shadowPos = shadowPos * 2.0 - 1.0;

	float dist = length(shadowPos.xy);
	float distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;
	shadowPos *= 0.95f / distortFactor;

	return shadowPos * 0.5 + 0.5;
}
#line 46 0

float BlueNoise(const float ir){
	return fract(texelFetch(noisetex, ivec2(gl_FragCoord.xy)%64, 0).x + ir * (frameCounter % 64));
}


#line 1 7
#define TRANSMITTANCE_TEXTURE_WIDTH 256
#define TRANSMITTANCE_TEXTURE_HEIGHT 64

#define SCATTERING_TEXTURE_R_SIZE 32 //z
#define SCATTERING_TEXTURE_MU_SIZE 128 //y
#define SCATTERING_TEXTURE_MU_S_SIZE 32 //x
#define SCATTERING_TEXTURE_NU_SIZE 16 //x

#define IRRADIANCE_TEXTURE_WIDTH 64
#define IRRADIANCE_TEXTURE_HEIGHT 16


struct DensityProfileLayer {
  float width;
  float exp_term;
  float exp_scale;
  float linear_term;
  float constant_term;
};

struct DensityProfile {
  DensityProfileLayer layers[2];
};

struct AtmosphereParameters {
  vec3              solar_irradiance;
  float             sun_angular_radius;
  float             bottom_radius;
  float             top_radius;
  DensityProfile    rayleigh_density;
  vec3              rayleigh_scattering;
  DensityProfile    mie_density;
  vec3              mie_scattering;
  vec3              mie_extinction;
  float             mie_phase_function_g;
  DensityProfile    absorption_density;
  vec3              absorption_extinction;
  vec3              ground_albedo;
  float             mu_s_min;
};

const AtmosphereParameters atmosphereModel = AtmosphereParameters(
    vec3(1.68194,1.85149,1.91198), //solar_irradiance 620 540 440
    0.005, //sun_angular_radius

    6360.0, //bottom_radius
    6420.0, //Length top_radius

    DensityProfile(DensityProfileLayer[2](  // rayleigh_density
        DensityProfileLayer(0.000000,0.000000,0.000000,0.000000,0.000000),
        DensityProfileLayer(0.000000,1.000000,-0.125000,0.000000,0.000000)
    )),
    vec3(0.008396,0.014590,0.033100), //rayleigh_scattering 620 540 440

    DensityProfile(DensityProfileLayer[2](  // mie_density
        DensityProfileLayer(0.000000,0.000000,0.000000,0.000000,0.000000),
        DensityProfileLayer(0.000000,1.000000,-0.833333,0.000000,0.000000)
    )),
    vec3(0.003996), //mie_scattering
    vec3(0.004440), //mie_extinction
    0.8, //mie_phase_function_g

    DensityProfile(DensityProfileLayer[2]( //absorption_density
        DensityProfileLayer(25.000000,0.000000,0.000000,0.066667,-0.666667),
        DensityProfileLayer(0.000000,0.000000,0.000000,-0.066667,2.666667)
    )),
    vec3(0.0020031,0.0016555,0.0000847), //absorption_extinction 620 540 440

    vec3(0.1), //ground_albedo
    -0.5 // mu_s_min
);



//////////Utility functions///////////////////////
//////////Utility functions///////////////////////

float ClampCosine(float mu){
    return clamp(mu, -1.0, 1.0);
}

float ClampDistance(float d){
    return max(d, 0.0);
}

float ClampRadius(AtmosphereParameters atmosphere, float r){
    return clamp(r, atmosphere.bottom_radius, atmosphere.top_radius);
}

float SafeSqrt(float a){
    return sqrt(max(a, 0.0));
}

vec3 RenderSunDisc(vec3 worldDir, vec3 sunDir){
	float d = dot(worldDir, sunDir);

	float size = 5e-5;
	float hardness = 4e4;

    float disc = pow(curve(saturate((d - (1.0 - size)) * hardness)), 2.0);

	return vec3(1.1114, 0.9756, 0.9133) * disc;
}

float RenderMoonDisc(vec3 worldDir, vec3 moonDir){
	float d = dot(worldDir, moonDir);

	float size = 5e-5;
	float hardness = 1e5;

	return pow(curve(saturate((d - (1.0 - size)) * hardness)), 2.0);
}

float RenderMoonDiscReflection(vec3 worldDir, vec3 moonDir){
	float d = dot(worldDir, moonDir);

	float size = 0.0025;
	float hardness = 300.0;

	return pow(curve(saturate((d - (1.0 - size)) * hardness)), 2.0);
}



//////////Intersections///////////////////////////
//////////Intersections///////////////////////////

float DistanceToTopAtmosphereBoundary(
    AtmosphereParameters atmosphere,
    float r,
    float mu
    ){
        float discriminant = r * r * (mu * mu - 1.0) + atmosphere.top_radius * atmosphere.top_radius;
        return ClampDistance(-r * mu + SafeSqrt(discriminant));
}

float DistanceToBottomAtmosphereBoundary(
    AtmosphereParameters atmosphere,
    float r,
    float mu
    ){
        float discriminant = r * r * (mu * mu - 1.0) + atmosphere.bottom_radius * atmosphere.bottom_radius;
        return ClampDistance(-r * mu - SafeSqrt(discriminant));
}

bool RayIntersectsGround(
    AtmosphereParameters atmosphere,
    float r,
    float mu
    ){
        return mu < 0.0 && r * r * (mu * mu - 1.0) + atmosphere.bottom_radius * atmosphere.bottom_radius >= 0.0;
}



//////////Density at altitude/////////////////////
//////////Density at altitude/////////////////////

float GetLayerDensity(
    DensityProfileLayer layer,
    float altitude
    ){
        float density = layer.exp_term * exp(layer.exp_scale * altitude) +
                        layer.linear_term * altitude + layer.constant_term;
        return clamp(density, float(0.0), float(1.0));
}

float GetProfileDensity(
    DensityProfile profile,
    float altitude
    ){
        return altitude < profile.layers[0].width ?
            GetLayerDensity(profile.layers[0], altitude) :
            GetLayerDensity(profile.layers[1], altitude);
}



//////////Coord Transforms////////////////////////
//////////Coord Transforms////////////////////////

float GetTextureCoordFromUnitRange(float x, int texture_size) {
    return 0.5 / float(texture_size) + x * (1.0 - 1.0 / float(texture_size));
}

vec4 GetScatteringTextureUvwzFromRMuMuSNu(
    AtmosphereParameters atmosphere,
    float r,
    float mu,
    float mu_s,
    float nu,
    bool ray_r_mu_intersects_ground
    ){
        float H = sqrt(atmosphere.top_radius * atmosphere.top_radius - atmosphere.bottom_radius * atmosphere.bottom_radius);

        float rho = SafeSqrt(r * r - atmosphere.bottom_radius * atmosphere.bottom_radius);
        float u_r = GetTextureCoordFromUnitRange(rho / H, SCATTERING_TEXTURE_R_SIZE);

        float r_mu = r * mu;
        float discriminant = r_mu * r_mu - r * r + atmosphere.bottom_radius * atmosphere.bottom_radius;
        float u_mu;

        if (ray_r_mu_intersects_ground){
            float d = -r_mu - SafeSqrt(discriminant);
            float d_min = r - atmosphere.bottom_radius;
            float d_max = rho;
            u_mu = 0.5 - 0.5 * GetTextureCoordFromUnitRange(d_max == d_min ? 0.0 : (d - d_min) / (d_max - d_min), SCATTERING_TEXTURE_MU_SIZE / 2);
        }else{
            float d = -r_mu + SafeSqrt(discriminant + H * H);
            float d_min = atmosphere.top_radius - r;
            float d_max = rho + H;
            u_mu = 0.5 + 0.5 * GetTextureCoordFromUnitRange((d - d_min) / (d_max - d_min), SCATTERING_TEXTURE_MU_SIZE / 2);
        }

        float d = DistanceToTopAtmosphereBoundary(atmosphere, atmosphere.bottom_radius, mu_s);
        float d_min = atmosphere.top_radius - atmosphere.bottom_radius;
        float d_max = H;
        float a = (d - d_min) / (d_max - d_min);
        float D = DistanceToTopAtmosphereBoundary(atmosphere, atmosphere.bottom_radius, atmosphere.mu_s_min);
        float A = (D - d_min) / (d_max - d_min);
        float u_mu_s = GetTextureCoordFromUnitRange(max(1.0 - a / A, 0.0) / (1.0 + a), SCATTERING_TEXTURE_MU_S_SIZE);
        float u_nu = (nu + 1.0) / 2.0;
        return vec4(u_nu, u_mu_s, u_mu, u_r);
}



//////////Transmittance Lookup////////////////////
//////////Transmittance Lookup////////////////////

vec2 GetTransmittanceTextureUvFromRMu(
    AtmosphereParameters atmosphere,
    float r,
    float mu
    ){
        float H = sqrt(atmosphere.top_radius * atmosphere.top_radius - atmosphere.bottom_radius * atmosphere.bottom_radius);

        float rho = SafeSqrt(r * r - atmosphere.bottom_radius * atmosphere.bottom_radius);

        float d = DistanceToTopAtmosphereBoundary(atmosphere, r, mu);
        float d_min = atmosphere.top_radius - r;
        float d_max = rho + H;
        float x_mu = (d - d_min) / (d_max - d_min);
        float x_r = rho / H;
        return vec2(GetTextureCoordFromUnitRange(x_mu, TRANSMITTANCE_TEXTURE_WIDTH),
                    GetTextureCoordFromUnitRange(x_r, TRANSMITTANCE_TEXTURE_HEIGHT));
}

vec3 GetTransmittanceToTopAtmosphereBoundary(
    AtmosphereParameters atmosphere,
    sampler2D transmittance_texture,
    float r,
    float mu
    ){
        vec2 uv = GetTransmittanceTextureUvFromRMu(atmosphere, r, mu);
        return vec3(texture(transmittance_texture, uv));
}

vec3 GetTransmittance(
    AtmosphereParameters atmosphere,
    sampler2D transmittance_texture,
    float r,
    float mu,
    float d,
    bool ray_r_mu_intersects_ground
    ){
        float r_d = ClampRadius(atmosphere, sqrt(d * d + 2.0 * r * mu * d + r * r));
        float mu_d = ClampCosine((r * mu + d) / r_d);

        if (ray_r_mu_intersects_ground) {
            return min(
            GetTransmittanceToTopAtmosphereBoundary(atmosphere, transmittance_texture, r_d, -mu_d) /
                GetTransmittanceToTopAtmosphereBoundary(atmosphere, transmittance_texture, r, -mu),
            vec3(1.0));
        } else {
            return min(
            GetTransmittanceToTopAtmosphereBoundary(atmosphere, transmittance_texture, r, mu) /
                GetTransmittanceToTopAtmosphereBoundary(atmosphere, transmittance_texture, r_d, mu_d),
            vec3(1.0));
        }
}

vec3 GetTransmittanceToSun(
    AtmosphereParameters atmosphere,
    sampler2D transmittance_texture,
    float r,
    float mu_s
    ){
        float sin_theta_h = atmosphere.bottom_radius / r;
        float cos_theta_h = -sqrt(max(1.0 - sin_theta_h * sin_theta_h, 0.0));

        return GetTransmittanceToTopAtmosphereBoundary(atmosphere, transmittance_texture, r, mu_s) *
            smoothstep(-sin_theta_h * atmosphere.sun_angular_radius,
                       sin_theta_h * atmosphere.sun_angular_radius,
                       mu_s - cos_theta_h);
}



//////////Scattering Lookup///////////////////////
//////////Scattering Lookup///////////////////////

vec3 GetExtrapolatedSingleMieScattering(
    AtmosphereParameters atmosphere,
    vec4 scattering
    ){
        if (scattering.r <= 0.0){
            return vec3(0.0);
        }
        return scattering.rgb * scattering.a / scattering.r *
            (atmosphere.rayleigh_scattering.r / atmosphere.mie_scattering.r) *
            (atmosphere.mie_scattering / atmosphere.rayleigh_scattering);
}

vec3 GetCombinedScattering(
    AtmosphereParameters atmosphere,
    sampler3D scattering_texture,
    float r,
    float mu,
    float mu_s,
    float nu,
    bool ray_r_mu_intersects_ground,
    out vec3 single_mie_scattering
    ){
        vec4 uvwz = GetScatteringTextureUvwzFromRMuMuSNu(atmosphere, r, mu, mu_s, nu, ray_r_mu_intersects_ground);
        float tex_coord_x = uvwz.x * float(SCATTERING_TEXTURE_NU_SIZE - 1);
        float tex_x = floor(tex_coord_x);
        float lerp = tex_coord_x - tex_x;
        vec3 uvw0 = vec3((tex_x + uvwz.y) / float(SCATTERING_TEXTURE_NU_SIZE), uvwz.z, uvwz.w);
        vec3 uvw1 = vec3((tex_x + 1.0 + uvwz.y) / float(SCATTERING_TEXTURE_NU_SIZE), uvwz.z, uvwz.w);

        vec4 combined_scattering = texture(scattering_texture, uvw0) * (1.0 - lerp) + texture(scattering_texture, uvw1) * lerp;

        vec3 scattering = vec3(combined_scattering);
        single_mie_scattering = GetExtrapolatedSingleMieScattering(atmosphere, combined_scattering);

        return scattering;
}



//////////Irradiance Lookup///////////////////////
//////////Irradiance Lookup///////////////////////

vec3 GetIrradiance(
    AtmosphereParameters atmosphere,
    sampler2D irradiance_texture,
    float r,
    float mu_s
    ){
        float x_r = (r - atmosphere.bottom_radius) / (atmosphere.top_radius - atmosphere.bottom_radius);
        float x_mu_s = mu_s * 0.5 + 0.5;
        vec2 uv = vec2(GetTextureCoordFromUnitRange(x_mu_s, IRRADIANCE_TEXTURE_WIDTH),
                       GetTextureCoordFromUnitRange(x_r, IRRADIANCE_TEXTURE_HEIGHT));

        return vec3(texture(irradiance_texture, uv));
}



//////////Rendering///////////////////////////////
//////////Rendering///////////////////////////////

const mat3 LMS = mat3(1.6218, -0.4493, 0.0325, -0.0374, 1.0598, -0.0742, -0.0283, -0.1119, 1.0491);


vec3 GetSunAndSkyIrradiance(
    AtmosphereParameters atmosphere,
    sampler2D transmittance_texture,
    sampler2D irradiance_texture,
    vec3 point,
    vec3 sun_direction,
    vec3 moon_direction,
    out vec3 moon_irradiance,
    out vec3 sun_sky_irradiance,
    out vec3 moon_sky_irradiance
    ){
        float r = length(point);
        float sun_mu_s = dot(point, sun_direction) / r;
        float moon_mu_s = dot(point, moon_direction) / r;

        sun_sky_irradiance = GetIrradiance(atmosphere, irradiance_texture, r, sun_mu_s) * LMS;
        moon_sky_irradiance = GetIrradiance(atmosphere, irradiance_texture, r, moon_mu_s) * NIGHT_BRIGHTNESS * LMS;

        vec3 sun_irradiance = atmosphere.solar_irradiance * 0.6;
        moon_irradiance = sun_irradiance * GetTransmittanceToSun(atmosphere, transmittance_texture, r, moon_mu_s) * NIGHT_BRIGHTNESS * LMS;
        sun_irradiance *= GetTransmittanceToSun(atmosphere, transmittance_texture, r, sun_mu_s);

        return sun_irradiance * LMS;
}


vec3 GetSkyRadiance(
    AtmosphereParameters atmosphere,
    sampler2D transmittance_texture,
    sampler3D scattering_texture,
    sampler2D irradiance_texture,
    vec3 camera,
    vec3 view_ray,
    vec3 sun_direction,
    vec3 moon_direction,
    bool horizon,
    out vec3 transmittance,
    out bool ray_r_mu_intersects_ground
    ){
        float r = length(camera);
        float rmu = dot(camera, view_ray);
        float distance_to_top_atmosphere_boundary = -rmu - sqrt(rmu * rmu - r * r + atmosphere.top_radius * atmosphere.top_radius);

        if (distance_to_top_atmosphere_boundary > 0.0){
            camera = camera + view_ray * distance_to_top_atmosphere_boundary;
            r = atmosphere.top_radius;
            rmu += distance_to_top_atmosphere_boundary;
        } else if (r > atmosphere.top_radius) {
            transmittance = vec3(1.0);
            return vec3(0.0);
        }

        float mu = rmu / r;
        float sun_mu_s = dot(camera, sun_direction) / r;
        float sun_nu = dot(view_ray, sun_direction);

        float moon_mu_s = dot(camera, moon_direction) / r;
        float moon_nu = dot(view_ray, moon_direction);


        ray_r_mu_intersects_ground = RayIntersectsGround(atmosphere, r, mu);


        transmittance = ray_r_mu_intersects_ground ? vec3(0.0) : GetTransmittanceToTopAtmosphereBoundary(atmosphere, transmittance_texture, r, mu);

        vec3 sun_single_mie_scattering;
        vec3 sun_scattering;

        vec3 moon_single_mie_scattering;
        vec3 moon_scattering;

        horizon = horizon && ray_r_mu_intersects_ground;

        sun_scattering = GetCombinedScattering(atmosphere, scattering_texture, r, mu, sun_mu_s, sun_nu, horizon, sun_single_mie_scattering);
        moon_scattering = GetCombinedScattering(atmosphere, scattering_texture, r, mu, moon_mu_s, moon_nu, horizon, moon_single_mie_scattering);


        vec3 groundDiffuse = vec3(0.0);
        #ifdef ATMO_HORIZON
        if (horizon){
            vec3 planet_surface = camera + view_ray * DistanceToBottomAtmosphereBoundary(atmosphere, r, mu);

            float r = length(planet_surface);
            float sun_mu_s = dot(planet_surface, sun_direction) / r;
            float moon_mu_s = dot(planet_surface, moon_direction) / r;

            vec3 sky_irradiance = GetIrradiance(atmosphere, irradiance_texture, r, sun_mu_s);
            sky_irradiance += GetIrradiance(atmosphere, irradiance_texture, r, moon_mu_s) * NIGHT_BRIGHTNESS;
            vec3 sun_irradiance = atmosphere.solar_irradiance * GetTransmittanceToSun(atmosphere, transmittance_texture, r, sun_mu_s);

            float d = distance(camera, planet_surface);
            vec3 surface_transmittance = GetTransmittance(atmosphere, transmittance_texture, r, mu, d, ray_r_mu_intersects_ground);

            groundDiffuse = mix(sky_irradiance * 0.1, sun_irradiance * 0.008, wetness * 0.6) * surface_transmittance;
        }
        #endif


        vec3 rayleigh = sun_scattering * RayleighPhaseFunction(sun_nu)
                     + moon_scattering * RayleighPhaseFunction(moon_nu) * NIGHT_BRIGHTNESS;

        vec3 mie = sun_single_mie_scattering * MiePhaseFunction(atmosphere.mie_phase_function_g, sun_nu)
                + moon_single_mie_scattering * MiePhaseFunction(atmosphere.mie_phase_function_g, moon_nu) * NIGHT_BRIGHTNESS;

        rayleigh = mix(rayleigh,  vec3(Luminance(rayleigh)) * atmosphere.solar_irradiance, wetness * 0.5);

        return (rayleigh + mie + groundDiffuse) * (1.0 - wetness * 0.4) * LMS;
}


vec3 GetSkyRadianceToPoint(
    AtmosphereParameters atmosphere,
    sampler2D transmittance_texture,
    sampler3D scattering_texture,
    vec3 camera,
    vec3 point,
    vec3 sun_direction,
    vec3 moon_direction,
    out vec3 transmittance
    ){
        vec3 view_ray = normalize(point - camera);
        float r = length(camera);
        float rmu = dot(camera, view_ray);
        float distance_to_top_atmosphere_boundary = -rmu - sqrt(rmu * rmu - r * r + atmosphere.top_radius * atmosphere.top_radius);

        if (distance_to_top_atmosphere_boundary > 0.0){
            camera = camera + view_ray * distance_to_top_atmosphere_boundary;
            r = atmosphere.top_radius;
            rmu += distance_to_top_atmosphere_boundary;
        }

        float mu = rmu / r;
        float sun_mu_s = dot(camera, sun_direction) / r;
        float sun_nu = dot(view_ray, sun_direction);
        float moon_mu_s = dot(camera, moon_direction) / r;
        float moon_nu = dot(view_ray, moon_direction);
        float d = length(point - camera);


            bool ray_r_mu_intersects_ground = false;


        transmittance = GetTransmittance(atmosphere, transmittance_texture, r, mu, d, ray_r_mu_intersects_ground);

        vec3 sun_single_mie_scattering;
        vec3 sun_scattering = GetCombinedScattering(atmosphere, scattering_texture, r, mu, sun_mu_s, sun_nu, ray_r_mu_intersects_ground, sun_single_mie_scattering);
        vec3 moon_single_mie_scattering;
        vec3 moon_scattering = GetCombinedScattering(atmosphere, scattering_texture, r, mu, moon_mu_s, moon_nu, ray_r_mu_intersects_ground, moon_single_mie_scattering);

        float r_p = ClampRadius(atmosphere, sqrt(d * d + 2.0 * r * mu * d + r * r));
        float mu_p = (r * mu + d) / r_p;
        float sun_mu_s_p = (r * sun_mu_s + d * sun_nu) / r_p;
        float moon_mu_s_p = (r * moon_mu_s + d * moon_nu) / r_p;

        vec3 sun_single_mie_scattering_p;
        vec3 sun_scattering_p = GetCombinedScattering(atmosphere, scattering_texture, r_p, mu_p, sun_mu_s_p, sun_nu, ray_r_mu_intersects_ground, sun_single_mie_scattering_p);
        vec3 moon_single_mie_scattering_p;
        vec3 moon_scattering_p = GetCombinedScattering(atmosphere, scattering_texture, r_p, mu_p, moon_mu_s_p, moon_nu, ray_r_mu_intersects_ground, moon_single_mie_scattering_p);

        sun_scattering = sun_scattering - transmittance * sun_scattering_p;
        sun_single_mie_scattering = sun_single_mie_scattering - transmittance * sun_single_mie_scattering_p;
        moon_scattering = moon_scattering - transmittance * moon_scattering_p;
        moon_single_mie_scattering = moon_single_mie_scattering - transmittance * moon_single_mie_scattering_p;

        sun_single_mie_scattering = sun_single_mie_scattering * smoothstep(0.0, 0.01, sun_mu_s);
        moon_single_mie_scattering = moon_single_mie_scattering * smoothstep(0.0, 0.01, moon_mu_s);

        vec3 rayleigh = sun_scattering * RayleighPhaseFunction(sun_nu)
                     + moon_scattering * RayleighPhaseFunction(moon_nu) * NIGHT_BRIGHTNESS;

        vec3 mie = sun_single_mie_scattering * MiePhaseFunction(atmosphere.mie_phase_function_g, sun_nu)
                + moon_single_mie_scattering * MiePhaseFunction(atmosphere.mie_phase_function_g, moon_nu) * NIGHT_BRIGHTNESS;

        rayleigh = mix(rayleigh, vec3(Luminance(rayleigh)) * atmosphere.solar_irradiance, wetness * 0.5);

        return (rayleigh + mie) * (1.0 - wetness * 0.4) * LMS;
}
#line 53 0
#line 1 8


#define CLOUD_CLEAR_ALTITUDE 		1200.0 	// [0.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 1700.0 1800.0 1900.0 2000.0 2250.0 2500.0 2750.0 3000.0 4000.0 5000.0]
#define CLOUD_CLEAR_THICKNESS 		2500.0 	// [0.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 1700.0 1800.0 1900.0 2000.0 2250.0 2500.0 2750.0 3000.0 4000.0 5000.0]
#define CLOUD_CLEAR_COVERY 			0.0 	// [-0.5 -0.4 -0.3 -0.25 -0.2 -0.15 -0.1 -0.05 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0]
#define CLOUD_CLEAR_DENSITY 		1.0 	// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_CLEAR_SUNLIGHTING		1.0		// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_CLEAR_SKYLIGHTING		1.0		// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_CLEAR_NOISE_SCALE 	0.0002 	// [0.0001 0.00012 0.00014 0.00016 0.00018 0.0002 0.00022 0.00024 0.00026 0.00028 0.0003 0.00035 0.0004 0.0005]
#define CLOUD_CLEAR_FBM_OCTSCALE	2.8 	// [2.0 2.1 2.2 2.3 2.4 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define CLOUD_CLEAR_UPPER_LIMIT 	0.5 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define CLOUD_CLEAR_LOWER_LIMIT 	0.15 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

#define CLOUD_RAIN_ALTITUDE 		600.0 	// [0.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 1700.0 1800.0 1900.0 2000.0 2250.0 2500.0 2750.0 3000.0 4000.0 5000.0]
#define CLOUD_RAIN_THICKNESS 		2500.0 	// [0.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 1700.0 1800.0 1900.0 2000.0 2250.0 2500.0 2750.0 3000.0 4000.0 5000.0]
#define CLOUD_RAIN_COVERY 			2.0 	// [-0.5 -0.4 -0.3 -0.25 -0.2 -0.15 -0.1 -0.05 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0]
#define CLOUD_RAIN_DENSITY 			1.0 	// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_RAIN_SUNLIGHTING		0.6 	// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_RAIN_SKYLIGHTING		0.8		// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_RAIN_NOISE_SCALE 		0.0003 	// [0.0001 0.00012 0.00014 0.00016 0.00018 0.0002 0.00022 0.00024 0.00026 0.00028 0.0003 0.00035 0.0004 0.0005]
#define CLOUD_RAIN_FBM_OCTSCALE		2.4 	// [2.0 2.1 2.2 2.3 2.4 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define CLOUD_RAIN_UPPER_LIMIT 		0.6 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define CLOUD_RAIN_LOWER_LIMIT 		0.4 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]


#define CLOUD_ACCURACY 				17.0 	// [11.0 17.0 25.0 37.0 55.0 83.0 125.0]
#define CLOUD_FBM_OCTAVES			4 		// [4 5 6 7 8 9]
#define ADAPTIVE_OCTAVES

#define CLOUD_LIGHTING_OFFSET
#define CLOUD_FADING

#define CLOUD_SPEED 				1.0 	// [0.0 0.25 0.5 0.75 1.0 1.5 2.0 3.0 4.0 5.0 7.5 10.0 15.0 20.0 30.0 40.0 50.0 75.0 100.0]


#define ADAPTIVE_OCTAVES_LEVEL 		3
#define ADAPTIVE_OCTAVES_DISTANCE 	60.0
#define CLOUD_SUNLIGHT_QUALITY 		3
#define CLOUD_SKYLIGHT_QUALITY 		2
#define CLOUD_CLEAR_SUNLIGHT_LENGTH 300.0
#define CLOUD_CLEAR_SKYLIGHT_LENGTH 700.0
#define CLOUD_RAIN_SUNLIGHT_LENGTH 	150.0
#define CLOUD_RAIN_SKYLIGHT_LENGTH 	100.0
#define FTC_OFFSET 					0 		// [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185 190 195 200 205 210 215 220 225 230 235 240 245 250 255 260 265 270 275 280 285 290 295 300 305 310 315 320 325 330 335 340 345 350 355]




struct CloudProperties{
	float altitude;
	float thickness;
	float coverage;
	float density;
	float sunlighting;
	float skylighting;
	float scale;
	float octScale;
	float lowerLimit;
	float upperLimit;
};


CloudProperties GetGlobalCloudProperties(){
	float lerpFactor = wetness;

	CloudProperties cp;
	cp.altitude 	= mix(CLOUD_CLEAR_ALTITUDE, 	CLOUD_RAIN_ALTITUDE, 		lerpFactor);
	cp.thickness 	= mix(CLOUD_CLEAR_THICKNESS, 	CLOUD_RAIN_THICKNESS, 		lerpFactor);
	cp.coverage 	= mix(CLOUD_CLEAR_COVERY, 		CLOUD_RAIN_COVERY, 			lerpFactor);
	cp.density 		= mix(CLOUD_CLEAR_DENSITY, 		CLOUD_RAIN_DENSITY, 		lerpFactor);
	cp.sunlighting 	= mix(CLOUD_CLEAR_SUNLIGHTING, 	CLOUD_RAIN_SUNLIGHTING, 	lerpFactor);
	cp.skylighting 	= mix(CLOUD_CLEAR_SKYLIGHTING, 	CLOUD_RAIN_SKYLIGHTING, 	lerpFactor);
	cp.scale 		= mix(CLOUD_CLEAR_NOISE_SCALE, 	CLOUD_RAIN_NOISE_SCALE, 	lerpFactor);
	cp.octScale 	= mix(CLOUD_CLEAR_FBM_OCTSCALE, CLOUD_RAIN_FBM_OCTSCALE, 	lerpFactor);
	cp.lowerLimit 	= mix(CLOUD_CLEAR_LOWER_LIMIT, 	CLOUD_RAIN_LOWER_LIMIT, 	lerpFactor);
	cp.upperLimit 	= mix(CLOUD_CLEAR_UPPER_LIMIT, 	CLOUD_RAIN_UPPER_LIMIT, 	lerpFactor);

	return cp;
}



float Calculate3DNoise(vec3 position){
    vec3 p = floor(position);
    vec3 b = curve(fract(position));

    vec2 uv = 17.0 * p.z + p.xy + b.xy;
    vec2 rg = texture(noisetex, (uv + 0.5) / 64.0).zw;

    return mix(rg.x, rg.y, b.z);
}



float CalculateCloudFBM(vec3 position, vec3 windDirection, int octaves, CloudProperties cp){
    const float octAlpha = 0.45;
    float octScale = cp.octScale;
    float octShift = (octAlpha / octScale) / octaves;

    float accum = 0.0;
    float alpha = 0.5;
    vec3  shift = windDirection;

	position += windDirection;

    for (int i = 0; i < octaves; i++) {
		accum += alpha * Calculate3DNoise(position);
        position = (position + shift) * octScale;
        alpha *= octAlpha;
    }

    return accum + octShift;
}


float GetCloudDensity(CloudProperties cp, vec3 worldPos, vec3 windDirection, int octaves){
    vec3  cloudPos  = worldPos * cp.scale;

    float clouds = CalculateCloudFBM(cloudPos, windDirection, octaves, cp);

	float normalizedHeight  = saturate((worldPos.y - cp.altitude) / cp.thickness);
	float heightAttenuation = saturate(normalizedHeight / cp.lowerLimit) * saturate((1.0 - normalizedHeight) / (1.0 - cp.upperLimit));

	clouds  = clouds * heightAttenuation * (1.9 + cp.coverage) - (0.9 * heightAttenuation + normalizedHeight * 0.5 + 0.1);
	clouds  = saturate(clouds * 5.0 * cp.density);

	return clouds;
}

float CalculateMultipleScatteringCloudPhases(float VoL){
	float cloudForwardG = 0.7 - 0.3 * wetness;
	float cloudBackwardG = -0.2;
	float cloudMixG = 0.5;

	float phases = 0.0;
	float cn = 1.0;

    for (int i = 0; i < 4; i++, cn *= 0.5){
        phases += mix(MiePhaseFunction(cloudBackwardG * cn, VoL), MiePhaseFunction(cloudForwardG * cn, VoL), cloudMixG) * cn;
    }

	return phases;
}






vec4 SampleVolumetricClouds(CloudProperties cp, vec3 worldPos, vec3 worldDir, vec3 windDirection, float VdotL, float phases){
	float eyeLength = length(worldPos - cameraPosition);
	int octaves = CLOUD_FBM_OCTAVES;
		octaves += max(ADAPTIVE_OCTAVES_LEVEL - int(floor(sqrt(eyeLength) / ADAPTIVE_OCTAVES_DISTANCE)), 0);


	float density = GetCloudDensity(cp, worldPos, windDirection, octaves);
	float softDensity = density;
	density = smoothstep(0.0, 0.6, density);

	if (density < 0.0001) return vec4(0.0);

	float sunlightLength = mix(CLOUD_CLEAR_SUNLIGHT_LENGTH, CLOUD_RAIN_SUNLIGHT_LENGTH, wetness);
	float skylightLength = mix(CLOUD_CLEAR_SKYLIGHT_LENGTH, CLOUD_RAIN_SKYLIGHT_LENGTH, wetness);

	float sunlightExtinction = 0.0;
		float sa = smoothstep(0.2, 0.05, worldDir.y);
		float checkOffset = smoothstep(sa * 0.6, -0.6, VdotL) * (60.0 - 40.0 * wetness) * (1.0 + 3.0 * sa);
	for (int i = 1; i <= CLOUD_SUNLIGHT_QUALITY; i++)
	{
		float fi = float(i) / 2;
		fi = pow(fi, 1.5) * sunlightLength;
			fi += checkOffset;
		vec3 checkPos = worldShadowVector * fi + worldPos;
		float densityCheck = GetCloudDensity(cp, checkPos, windDirection, octaves);
		sunlightExtinction += densityCheck;
	}
	float sunlightEnergy = 1.0 / (sunlightExtinction * 10.0 + 1.0);

	float powderFactor = exp2(-softDensity * 12.0 / cp.sunlighting);// cp.sunlighting CLEAR=1 RAIN=0.6
 	powderFactor *= saturate(sunlightEnergy * sunlightEnergy * 14.0);
	sunlightEnergy *= MiePhaseFunction(powderFactor * 0.3, VdotL * 0.5 + 0.5);

	vec3 sunlightColor = colorShadowlight * (sunlightEnergy * cp.sunlighting * 90.0);

	vec3 cloudColor = sunlightColor * phases;


	float skylightExtinction = 0.0;
	for (int i = 1; i < CLOUD_SKYLIGHT_QUALITY; i++)
	{
		float fi = float(i) / 2;
		fi = pow(fi, 1.5);
		vec3 checkPos =  worldPos + vec3(0.0, fi * skylightLength, 0.0);
		float densityCheck = GetCloudDensity(cp, checkPos, windDirection, octaves);
		skylightExtinction += densityCheck;
	}
	float skylightEnergy = 0.15 / (skylightExtinction * 1.0 + 1.0);

	vec3 skylightColor = colorSkylight * skylightEnergy * cp.skylighting;

	cloudColor += skylightColor;


	return vec4(cloudColor * density, density);
}

#endif

void VolumetricClouds(inout vec3 color, in vec3 worldDir, in vec3 camera, in CloudProperties cloudProperties, in float noise, in bool ray_r_mu_intersects_ground, out float cloudTransmittance){
	//noise = BlueNoise(1.41421356);
	vec3 cloudAccum = vec3(0.0, 0.0, 0.0);
	cloudTransmittance = 1.0;

	float cloudUpperAltitude = cloudProperties.altitude + cloudProperties.thickness * (cameraPosition.y > cloudProperties.altitude ? 1.0 : 0.6 + 0.2 * wetness);

	if ((cameraPosition.y < cloudProperties.altitude && ray_r_mu_intersects_ground) || (cameraPosition.y > cloudUpperAltitude &&  worldDir.y > 0.0)) return;

	CloudProperties cp = cloudProperties;
	float planetRadius = atmosphereModel.bottom_radius * 1e3;

	vec3 rayStartPos = vec3(0.0, planetRadius + cameraPosition.y, 0.0);
	vec2 iBottom = RaySphereIntersection(rayStartPos, worldDir, planetRadius + cloudProperties.altitude);
	vec2 iTop = RaySphereIntersection(rayStartPos, worldDir, planetRadius + cloudUpperAltitude);

	vec2 iMarching = cameraPosition.y > cloudUpperAltitude ? vec2(iTop.x, iBottom.x) : vec2(iBottom.y, iTop.y);
	vec3 marchingStart = iMarching.x * worldDir;
	vec3 marchingEnd = iMarching.y * worldDir;

	float inCloud = (1.0 - saturate((cameraPosition.y - cloudUpperAltitude) * 0.005)) *
					(1.0 - saturate((cloudProperties.altitude - cameraPosition.y) * 0.005));

	float iInner = iBottom.y >= 0.0 && cameraPosition.y > cloudProperties.altitude ? iBottom.x : iTop.y;
	iInner = min(iInner, cloudProperties.altitude * 10.0);

	marchingStart = marchingStart * (1.0 - inCloud) + cameraPosition;
	marchingEnd = mix(marchingEnd, iInner * worldDir, inCloud) + cameraPosition;

	float marchingSteps = CLOUD_ACCURACY;
	float marchingStepSize = 1.0 / marchingSteps;

	vec3 marchingIncrement = (marchingEnd - marchingStart) * marchingStepSize;
	vec3 marchingPos = marchingStart + marchingIncrement * noise;

	float wind = 0.002 * (frameTimeCounter * CLOUD_SPEED + 10.0 * FTC_OFFSET);
	//wind = 0.002 * mod(frameTimeCounter * 60.0, 3600.0);

	vec3  windDirection = vec3(1.0, wetness * 0.1 -0.05, 0.4) * wind;


	vec3 rayHitPos;
	float sumTransmit;

	for (int i = 0; i < marchingSteps; i++, marchingPos += marchingIncrement)
	{
		vec3 cloudPos = marchingPos;
		cloudPos.y = length(cloudPos + vec3(0.0, planetRadius, 0.0)) - planetRadius;

		vec3 atmoPoint = marchingPos - cameraPosition;
		atmoPoint = camera + atmoPoint * 0.001;

			vec4 cloudSample = SampleVolumetricClouds(cp, cloudPos, worldDir, windDirection, VdotL, phases);


		cloudAccum += cloudSample.rgb * cloudTransmittance;

		rayHitPos += marchingPos * cloudTransmittance;
		sumTransmit += cloudTransmittance;

		cloudTransmittance *= 1.0 - cloudSample.a;
		if (cloudTransmittance < 0.0001) break;
	}

		rayHitPos /= sumTransmit;
		rayHitPos -= cameraPosition;

		float fading = exp(-max(length(rayHitPos) + (4e3 * wetness - 6e3), 0.0) * 1.5e-5);
		float cloudTransmittanceFaded = mix(1.0, cloudTransmittance, fading);
		cloudAccum *= fading;

		if(cloudTransmittance > 0.9999) return;

		vec3 atmoPoint = camera + rayHitPos * 0.001;
		vec3 transmittance;
		vec3 aerialPerspective = GetSkyRadianceToPoint(atmosphereModel, colortex11, colortex9, camera, atmoPoint, worldSunVector, worldMoonVector, transmittance);

		color *= cloudTransmittanceFaded;

		color += aerialPerspective * (1.0 - cloudTransmittanceFaded);
		color += cloudAccum * transmittance;

}
#line 54 0
#line 1 9
//#define PLANAR_CLOUDS // Shader option OFF

#define PC_COVERAGE 0.48 // [0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1]

#define PC_NOISE_SCALE 0.02

#define PC_ALTITUDE 6000



vec4 GetNoise(sampler2D noiseSampler, vec2 position) {
	return texture(noiseSampler, position / 1e4);
}

vec2 cubeSmooth(vec2 x){
    return x * x * (3.0 - 2.0 * x);
}

float Get2DNoise(vec2 pos)
{
	vec2 p = floor(pos);
	vec2 f = cubeSmooth(fract(pos));

	vec2 uv =  p + f + 0.5;

	return texture(noisetex, uv / noiseTextureResolution).x;
}







float Get2DCloudsDensity(vec2 position, vec2 cloudsTime) {
	const float tau         = PI * 2.0;
	const float phi         = sqrt(5.0) * 0.5 + 0.5;
	const float goldenAngle = tau / (phi + 1.0);

	const mat2 rotateGoldenAngle = mat2(cos(goldenAngle), -sin(goldenAngle), sin(goldenAngle), cos(goldenAngle));

	position *= PC_NOISE_SCALE;

	position += vec2(GetNoise(noisetex, position * vec2(2.0, 0.7) - cloudsTime).x * 50.0);
	//position += vec2(GetNoise(noisetex, position * vec2(6.0, -2.0) - cloudsTime).x * 20.0);


	float noise = 0.0;
	{
		const int octaves = 5;
		const float alpha = 0.85;
		const float freqGain = 3.6;

		vec2 noisePosition = position;
		noise = GetNoise(noisetex, noisePosition - cloudsTime).x;
		float weightSum = 1.0;
		mat2 rot = freqGain * rotateGoldenAngle;

		for (int i = 1; i < octaves; i++)
		{
			float f = pow(freqGain, i);
			vec2 noisePosition = rot * (noisePosition - cloudsTime * sqrt(i + 1.0));
			noisePosition *= vec2(1.0 - 0.35 * sqrt(i), 1.0 + 0.05 * sqrt(i));
			float weight = 1.0 / pow(f, alpha);
			noise += GetNoise(noisetex, noisePosition).x * weight;
			weightSum += weight;
			rot *= freqGain * rotateGoldenAngle;
		}
		noise /= weightSum;
	}

	float density = saturate(noise + PC_COVERAGE - 1.0) * 0.6;
	//density = density * density;
	return density;
}

//--// Lighting //------------------------------------------------------------//



void PlanarClouds(inout vec3 color, vec3 worldDir, vec3 camera, float dither, bool ray_r_mu_intersects_ground) {

	if (cameraPosition.y >= PC_ALTITUDE || ray_r_mu_intersects_ground) return;

	float planetRadius = atmosphereModel.bottom_radius * 1e3;

	vec3 rayStartPos = vec3(0.0, planetRadius + cameraPosition.y, 0.0);
	float intersection = RaySphereIntersection(rayStartPos, worldDir, planetRadius + PC_ALTITUDE).y;

	if (intersection <= 0.0) return;
	vec3 centerPosition = worldDir * intersection;

	float frameTime = 0.8 * (frameTimeCounter * CLOUD_SPEED + 10.0 * FTC_OFFSET);
	vec2 cloudsTime = vec2(frameTime, -frameTime * 0.2);

	float density = Get2DCloudsDensity(centerPosition.xz + cameraPosition.xz, cloudsTime);

	float fading = exp(-max(length(centerPosition) + (6e3 * wetness - 1e4), 0.0) * (1e-5 - 5e-6 * wetness));
	//float cloudTransmittanceFaded = mix(1.0, cloudTransmittance, fading);
	density *= fading;

	if (density <= 0.0001) return;

	vec3 cloudColor = colorSunlight * 6.0 * density * density;

	color *= (1.0 - density);

	vec3 atmoPoint = camera + centerPosition * 0.001;
	vec3 transmittance;
	vec3 aerialPerspective = GetSkyRadianceToPoint(atmosphereModel, colortex11, colortex9, camera, atmoPoint, worldSunVector, -worldSunVector, transmittance);

	color += aerialPerspective * density;

	color += cloudColor * transmittance;
}
#line 55 0



void WaterFog(inout vec3 color, in vec3 viewDir, in float opaqueDist, in float waterDist, in MaterialMask mask, in float occludedWater, in float waterSkylight, in float totalInternalReflection){
	float inAir = step(float(isEyeInWater), 0.0);

	float eyeWaterDepth = saturate(float(eyeBrightnessSmooth.y) / 120.0 - 0.8);

	float distDiff = opaqueDist - waterDist;
	waterDist = mix(mix(waterDist, opaqueDist, mask.stainedGlass),
	                mix(distDiff, min(distDiff * 0.3, 6.0), occludedWater),
				    inAir);

	waterDist = max(waterDist, totalInternalReflection * 50.0 * eyeWaterDepth);

	float fogDensity = mix(0.03, 0.7, mask.ice);

	vec3 shadowVectorRefracted = refract(-shadowVector, gbufferModelView[1].xyz, 1.0 / WATER_REFRACT_IOR);

	vec3 waterFogColor = mix(vec3(0.05, 0.6, 1.0), vec3(0.3, 0.9, 1.5), mask.ice);
	waterFogColor = mix(waterFogColor, vec3(0.5), wetness * 0.6);

	waterFogColor *= dot(vec3(0.33333), colorSkylight) * 0.02;

	if (isEyeInWater == 0){
		waterFogColor *= 2.6 - wetness * 2.2;
		waterFogColor *= waterSkylight;
		fogDensity = 0.2;

		float scatter = 1.0 / (pow(saturate(dot(shadowVectorRefracted, viewDir) * 0.5 + 0.5) * 20.0, 2.0) + 0.1);
		waterFogColor = mix(waterFogColor, colorShadowlight * 5.0 * waterFogColor, vec3(scatter * (1.0 - wetness)));
	}else{
		waterFogColor *= 1.0 - wetness * 0.6;
		float scatter = 1.0 / (pow(saturate(dot(shadowVectorRefracted, viewDir) * 0.5 + 0.5) * 10.0, 1.0) + 0.1);
		vec3 waterSunlightScatter = colorShadowlight * scatter * waterFogColor * 2.0;

		waterFogColor *= dot(viewDir, gbufferModelView[1].xyz) * 0.4 + 0.6;
		waterFogColor += waterSunlightScatter * (eyeWaterDepth * (1.0 - wetness * 0.6));
	}

	float visibility = exp(-waterDist * fogDensity * WATERFOG_DENSITY);

	visibility = clamp(visibility, 0.35 * mask.ice, 1.0);
	visibility = mix(visibility, 0.7, mask.hand);

	vec3 attenuationColor = mix(vec3(0.1, 0.6, 1.0), vec3(0.2, 0.5, 0.7), inAir);
	color *= pow(attenuationColor * 0.99, vec3(waterDist * (0.21 * inAir + 0.04) * WATERFOG_DENSITY));

	color = mix(waterFogColor, color, visibility);
}





vec3 CalculateStars(vec3 worldDir){
	const float scale = 384.0;
	const float coverage = 0.007;
	const float maxLuminance = 1.0 * NIGHT_BRIGHTNESS;
	const float minTemperature = 4000.0;
	const float maxTemperature = 8000.0;

	//float visibility = curve(saturate(worldDir.y));

	float cosine = dot(worldSunVector,  vec3(0, 0, 1));
	vec3 axis = cross(worldSunVector,  vec3(0, 0, 1));
	float cosecantSquared = 1.0 / dot(axis, axis);
	worldDir = cosine * worldDir + cross(axis, worldDir) + (cosecantSquared - cosecantSquared * cosine) * dot(axis, worldDir) * axis;

	vec3  p = worldDir * scale;
	ivec3 i = ivec3(floor(p));
	vec3  f = p - i;
	float r = dot(f - 0.5, f - 0.5);

	vec3 i3 = fract(i * vec3(443.897, 441.423, 437.195));
	i3 += dot(i3, i3.yzx + 19.19);
	vec2 hash = fract((i3.xx + i3.yz) * i3.zy);
	hash.y = 2.0 * hash.y - 4.0 * hash.y * hash.y + 3.0 * hash.y * hash.y * hash.y;

	float c = remap(1.0 - coverage, 1.0, hash.x);
	return (maxLuminance * remap(0.25, 0.0, r) * c * c) * Blackbody(mix(minTemperature, maxTemperature, hash.y));
}


vec3 UnprojectSky(vec2 coord, float tileSize){
	coord *= screenSize;
	float tileSizeDivide = 1.0 / (0.5 * tileSize - 1.5);

	vec3 direction = vec3(0.0);

	if (coord.x < tileSize) {
		direction.x =  coord.y < tileSize ? -1 : 1;
		direction.y = (coord.x - tileSize * 0.5) * tileSizeDivide;
		direction.z = (coord.y - tileSize * (coord.y < tileSize ? 0.5 : 1.5)) * tileSizeDivide;
	} else if (coord.x < 2.0 * tileSize) {
		direction.x = (coord.x - tileSize * 1.5) * tileSizeDivide;
		direction.y =  coord.y < tileSize ? -1 : 1;
		direction.z = (coord.y - tileSize * (coord.y < tileSize ? 0.5 : 1.5)) * tileSizeDivide;
	} else {
		direction.x = (coord.x - tileSize * 2.5) * tileSizeDivide;
		direction.y = (coord.y - tileSize * (coord.y < tileSize ? 0.5 : 1.5)) * tileSizeDivide;
		direction.z =  coord.y < tileSize ? -1 : 1;
	}

	return normalize(direction);
}

////////////////////////////// Main //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// Main //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// Main //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void main(){
	GbufferData gbuffer 			= GetGbufferData();
	MaterialMask materialMask 		= CalculateMasks(gbuffer.materialIDW);
	MaterialMask materialMaskSoild 	= CalculateMasks(gbuffer.materialIDL);
	CloudProperties cloudProperties = GetGlobalCloudProperties();

	FixParticleMask(materialMaskSoild, materialMask, gbuffer.depthL, gbuffer.depthW);

	if (materialMask.water > 0.5)
	{
		gbuffer.material.roughness = 1.0;
		gbuffer.material.metalness = 0.0;
	}

	vec3 viewPos 					= ViewPos_From_ScreenPos(texcoord, gbuffer.depthL);
	vec3 worldPos					= mat3(gbufferModelViewInverse) * viewPos;

	vec3 viewDir 					= normalize(viewPos);
	vec3 worldDir 					= normalize(worldPos);
	vec3 rawWorldNormal 			= mat3(gbufferModelViewInverse) * gbuffer.normalL;
	vec3 worldNormal 				= rawWorldNormal;

	float farDist = max(far * 1.2, 1024.0);
	float opaqueDist = mix(length(viewPos), farDist, step(1.0, gbuffer.depthL));
	float waterDist = mix(length(ViewPos_From_ScreenPos(texcoord, gbuffer.depthW)), farDist, step(1.0, gbuffer.depthW));

	float cloudShadow 				= 1.0;

	#ifdef ATMO_HORIZON
		float minAltitude = 800.0;
	#else
		float minAltitude = 100.0;
	#endif
	vec3 camera = vec3(0.0, max(cameraPosition.y, minAltitude) * 0.001 + atmosphereModel.bottom_radius, 0.0);

	float noise_0  = bayer64(gl_FragCoord.xy);

	float noise_1 = noise_0;
	#ifdef TAA
		noise_1 = fract(frameCounter * (1.0 / 7.0) + noise_1);
    #endif

	vec3 finalComposite = CurveToLinear(texture(colortex1, texcoord).rgb) * mainOutputFactor;


//////////////////// Sky ///////////////////////////////////////////////////////////////////////////
//////////////////// Sky ///////////////////////////////////////////////////////////////////////////

	worldDir = (isEyeInWater == 1 && materialMask.water > 0.5) ? refract(worldDir, mat3(gbufferModelViewInverse) * gbuffer.normalW, WATER_REFRACT_IOR) : worldDir;

	if (materialMaskSoild.sky > 0.5){
		finalComposite = vec3(0.0);

		vec3 transmittance = vec3(1.0);
		float cloudVisibility = 1.0;

		#ifdef ATMO_HORIZON
			bool horizon = true;
		#else
			bool horizon = false;
		#endif
		bool ray_r_mu_intersects_ground;
		vec3 atmosphere = GetSkyRadiance(atmosphereModel, colortex11, colortex9, colortex10, camera, worldDir, worldSunVector, worldMoonVector, horizon, transmittance, ray_r_mu_intersects_ground);

		finalComposite += atmosphere;

		#ifdef PLANAR_CLOUDS
			PlanarClouds(finalComposite, worldDir, camera, noise_1, ray_r_mu_intersects_ground);
		#endif

		#ifdef VOLUMETRIC_CLOUDS
			VolumetricClouds(finalComposite, worldDir, camera, cloudProperties, noise_1, ray_r_mu_intersects_ground, cloudVisibility);
		#endif


		vec3 sunDisc;
		vec3 moonDisc;
		vec3 celestial = vec3(0.0);

		#ifdef STARS
			celestial += CalculateStars(worldDir);
		#endif

		#if (defined MOON_TEXTURE && MC_VERSION >= 11605)
			if(isEyeInWater == 1){
				moonDisc = vec3(RenderMoonDisc(worldDir, worldMoonVector));
				float luminance = Luminance(moonDisc);
				moonDisc = mix(moonDisc, luminance * vec3(0.7771, 1.0038, 1.6190), vec3(0.5));
			}else{
				moonDisc = gbuffer.albedo * SKY_TEXTURE_BRIGHTNESS * 0.2;
			}
		#else
			moonDisc = vec3(RenderMoonDisc(worldDir, worldMoonVector));
		#endif

		sunDisc = RenderSunDisc(worldDir, worldSunVector);
		sunDisc += moonDisc * NIGHT_BRIGHTNESS;
		#ifdef CAVE_MODE
			sunDisc *= 1.0 - eyeBrightnessZeroSmooth;
		#endif

		celestial += sunDisc * (RAIN_SHADOW * 200.0);

		celestial *= transmittance * cloudVisibility;

		finalComposite += sunDisc * (200.0 - RAIN_SHADOW * 200.0) + celestial;

		#ifdef CAVE_MODE
			finalComposite = mix(finalComposite, vec3(max(NOLIGHT_BRIGHTNESS, 0.00007) * 0.05), saturate(eyeBrightnessZeroSmooth));
		#endif
	}

//////////////////// Transparent ///////////////////////////////////////////////////////////////////
//////////////////// Transparent ///////////////////////////////////////////////////////////////////

	float totalInternalReflection = 0.0;
	if (length(worldDir) < 0.5)
	{
		//viewDir = reflect(viewDir, gbuffer.normalW);
		finalComposite = vec3(0.0);
		totalInternalReflection = 1.0;
	}

	#ifdef UNDERWATER_FOG
		if(gbuffer.waterMask > 0.5 || isEyeInWater == 1 || materialMask.ice > 0.5){
			float occludedWater = gbuffer.waterMask * materialMask.stainedGlass;
			WaterFog(finalComposite, viewDir, opaqueDist, waterDist, materialMask, occludedWater, gbuffer.lightmapW.g, totalInternalReflection);
			//finalComposite += colorSkylight * (occludedWater * 0.06);
		}
	#endif

//////////////////// Main Ouptut ///////////////////////////////////////////////////////////////////
//////////////////// Main Ouptut ///////////////////////////////////////////////////////////////////

	finalComposite /= mainOutputFactor;
	finalComposite = LinearToCurve(finalComposite);
	//finalComposite += rand(texcoord + sin(frameTimeCounter)) * (1.0 / 65535.0);

	compositeOutput1 = vec4(finalComposite.rgb, 0.0);

//////////////////// Sky Image /////////////////////////////////////////////////////////////////////
//////////////////// Sky Image /////////////////////////////////////////////////////////////////////

	vec3 skyImage = vec3(0.0);
	float cloudVisibility = 1.0;
	vec3 transmittance = vec3(1.0);
	float tileSize = min(SKY_IMAGE_RESOLUTION, min(floor(screenSize.x * 0.5) / 1.5, floor(screenSize.y * 0.5)));
	vec2 cmp = tileSize * vec2(3.0, 2.0);

	if (gl_FragCoord.x < cmp.x && gl_FragCoord.y < cmp.y)
	{
		vec3 viewVector = UnprojectSky(texcoord, tileSize);

		#ifdef ATMO_REFLECTION_HORIZON
			bool horizon = true;
		#else
			bool horizon = false;
		#endif
		bool ray_r_mu_intersects_ground;
		vec3 atmosphere = GetSkyRadiance(atmosphereModel, colortex11, colortex9, colortex10, camera, viewVector, worldSunVector, worldMoonVector, horizon, transmittance, ray_r_mu_intersects_ground);

		skyImage += atmosphere;


		#ifdef PLANAR_CLOUDS
			PlanarClouds(skyImage, viewVector, camera, noise_0, ray_r_mu_intersects_ground);
		#endif

		#ifdef VOLUMETRIC_CLOUDS
			VolumetricClouds(skyImage, viewVector, camera, cloudProperties, noise_0, ray_r_mu_intersects_ground, cloudVisibility);
		#endif

		#ifdef CAVE_MODE
			skyImage = mix(skyImage, vec3(max(NOLIGHT_BRIGHTNESS, 0.00005) * 0.07), eyeBrightnessZeroSmooth);
		#endif

		skyImage /= mainOutputFactor;
		skyImage = LinearToCurve(skyImage);
	}

	compositeOutput3 = vec4(skyImage, 0.0);

	cloudVisibility = saturate(cloudVisibility) * 0.5 + totalInternalReflection;
	compositeOutput7 = vec4(transmittance, cloudVisibility);
}
