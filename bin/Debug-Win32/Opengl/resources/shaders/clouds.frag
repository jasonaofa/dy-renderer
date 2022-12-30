#version 330 core
out vec4 FragColor;
in vec3 posW;

uniform float time;
uniform mat4 view; // inverse view-projection matrix
uniform mat4 projection;
uniform vec2 resolution;//(SCR_WIDTH,SCR_HEIGHT)
// Sun Params.
uniform vec3 sunColor = vec3(0.5, 0.3, 0.1);

//added parameters
uniform float cloudVolumeStartHeight; // meters - height above ground level 云层开始的高度（从地表开始算
uniform float cloudVolumeHeight; // meters - height above ground level 云层所占的高度即云层的厚度（从地表开始算

uniform vec3 lightDir; // light direction world space
uniform float groundRadius; // meters - for a ground/lower atmosphere only version, this could be smaller 从地心到地表的距离
		 
//uniform vec3 sunColor; // color of sun light

uniform uint baseShapeTextureBottomMipLevel;

uniform vec3 camPos;

uniform float cloudSpeed =   100.0f;
uniform float cloudTopOffset;

uniform vec3 windDirection = vec3(10.0, 0.0, 0.0);;
uniform uint erosionTextureBottomMipLevel;

uniform vec3 weatherTexMod; // scale(x), offset(y, z)
uniform float windStrength;

uniform sampler3D baseNoise;
uniform sampler3D detailNoise;
uniform sampler2D weatherLookup;
//uniform sampler2D depthTexture;

vec4 vec4Zero =vec4 (0,0,0,0);
vec3 vec3Zero =vec3 (0,0,0);
vec2 vec2Zero =vec2 (0,0);




float VOLUME_END_HEIGHT = cloudVolumeStartHeight + cloudVolumeHeight;//地表到云层最外侧的距离 = 地表到云层开始的距离（高度）+云层的厚度
// planet center (world space)
vec3 PLANET_CENTER = vec3(0.0f, -groundRadius - 100.0f, 0.0f); // TODO revisit - 100.0f offset is to match planet sky settings
// radius from the planet center to the bottom of the cloud volume
float PLANET_CENTER_TO_LOWER_CLOUD_RADIUS = groundRadius + cloudVolumeStartHeight;
// radius from the planet center to the top of the cloud volume
float PLANET_CENTER_TO_UPPER_CLOUD_RADIUS = groundRadius + VOLUME_END_HEIGHT;//云层最外层到地心的距离= 地表到地心的距离+地表到云层最外侧的距离
float CLOUD_SCALE = 1.0f / VOLUME_END_HEIGHT;
vec3 WEATHER_TEX_MOD = vec3(1.0f / (VOLUME_END_HEIGHT * weatherTexMod.x), weatherTexMod.y, weatherTexMod.z); 
vec2 WEATHER_TEX_MOVE_SPEED = vec2(windStrength * windDirection.x, windStrength * windDirection.z); // this is modded by app run time
  // samples based on shell thickness between inner and outer volume
uint SAMPLE_RANGE_X = 64u;
uint SAMPLE_RANGE_Y = 128u;
vec4 STRATUS_GRADIENT = vec4(0.02f, 0.05f, 0.09f, 0.11f);
vec4 STRATOCUMULUS_GRADIENT = vec4(0.02f, 0.2f, 0.48f, 0.625f);
vec4 CUMULUS_GRADIENT = vec4(0.01f, 0.0625f, 0.78f, 1.0f); // these fractions would need to be altered if cumulonimbus are added to the same pass


// random vectors on the unit sphere
  vec3 RANDOM_VECTORS[] = vec3[]
(
	vec3( 0.38051305f,  0.92453449f, -0.02111345f),
	vec3(-0.50625799f, -0.03590792f, -0.86163418f),
	vec3(-0.32509218f, -0.94557439f,  0.01428793f),
	vec3( 0.09026238f, -0.27376545f,  0.95755165f),
	vec3( 0.28128598f,  0.42443639f, -0.86065785f),
	vec3(-0.16852403f,  0.14748697f,  0.97460106f)
);

  uint LIGHT_RAY_ITERATIONS = 6u;
  float RCP_LIGHT_RAY_ITERATIONS = 1.0f / float(LIGHT_RAY_ITERATIONS);

 uniform float near_plane;
uniform float far_plane;
///////////////////////////////////////////
// Cloud Detail Params.
uniform float detailScale = 0.0002;


// Cloud Animation Params.
uniform vec3 detailwindDirection = vec3(1.0, 1.0, 0.0);

// Cloud Shape Params.
uniform float shapeScale = 0.00001;



  ////////////////////////////////////////////////////////////////////
  float LinearizeDepth(float depth)
{
    float z = depth * 2.0 - 1.0; // Back to NDC 
    return (2.0 * near_plane * far_plane) / (far_plane + near_plane - z * (far_plane - near_plane));	
}
  /**
 * Perform a ray-sphere intersection test.
 * Returns the number of intersections in the direction of the ray (excludes intersections behind the ray origin), between 0 and 2.
 * In the case of more than one intersection, the nearest point will be returned in t1.
 * 返回在射线方向上的交叉点数(不包括射线原点后面的交叉点)，介于0到2之间。
 * 并且额外返回一个t1变量，用来记录最近的交点
 * http://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-sphere-intersection
 */
uint intersectRaySphere(
	vec3 rayOrigin,
	vec3 rayDir, // must be normalized
	vec3 sphereCenter,
	float  sphereRadius,
	out vec2 t)
{
	vec3 l = rayOrigin - sphereCenter;
	float a = 1.0f; // dot(rayDir, rayDir) where rayDir is normalized
	float b = 2.0f * dot(rayDir, l);
	float c = dot(l, l) - sphereRadius * sphereRadius;
	float discriminate = b * b - 4.0f * a * c;
	if(discriminate < 0.0f)
	{
		t.x = t.y = 0.0f;
		return 0u;
	}
	else if(abs(discriminate) - 0.00005f <= 0.0f)
	{
		t.x = t.y = -0.5f * b / a;
		return 1u;
	}
	else
	{
		float q = b > 0.0f ?
			-0.5f * (b + sqrt(discriminate)) :
			-0.5f * (b - sqrt(discriminate));
		float h1 = q / a;
		float h2 = c / q;
		t.x = min(h1, h2);
		t.y = max(h1, h2);
		if(t.x < 0.0f)
		{
			t.x = t.y;
			if(t.x < 0.0f)
			{
				return 0u;
			}
			return 1u;
		}
		return 2u;
	}
}

float getCoverage(vec3 weatherData)
{
	return weatherData.r;
}

float getPrecipitation(vec3 weatherData)
{
	return weatherData.g;
}

float getCloudType(vec3 weatherData)
{
	// weather b channel tells the cloud type 0.0 = stratus, 0.5 = stratocumulus, 1.0 = cumulus
	return weatherData.b;
}

vec3 sampleWeather(vec3 pos)
{
	return texture(weatherLookup, pos.xz * WEATHER_TEX_MOD.x + WEATHER_TEX_MOD.yz + (WEATHER_TEX_MOVE_SPEED * time)).rgb;
	//return weatherLookup.SampleLevel(texSampler, pos.xz * WEATHER_TEX_MOD.x + WEATHER_TEX_MOD.yz + (WEATHER_TEX_MOVE_SPEED * appRunTime), 0.0f).rgb;
}

//vec3 SampleWeather(vec3 pos)
//{
//	vec2 unit = pos.xz * _WeatherTexUVScale / 30000.0;
//
//	vec2 uv = unit * 0.5 + 0.5;
//
//	return tex2Dlod(_WeatherTex, float4(uv, 0.0, 0.0));
//}
float lerp (float a, float b, float x)
{
    return a + x * (b - a);
}

  vec3 lerpVec3(vec3 lVal,vec3 rVal,float factor)
  {
	vec3 value = vec3(1.0f,1.0f,1.0f);
	value.x = lerp(lVal.x,rVal.x,factor);
	value.y = lerp(lVal.y,rVal.y,factor);
	value.z = lerp(lVal.z,rVal.z,factor);

	return value;
  }

float remap(float value,float oldMin,float oldMax,float newMin,float newMax)
{
	return newMin + (value - oldMin) / (oldMax - oldMin) * (newMax - newMin);
}

///////////////////////////////////////////////////
///// 计算ray march起点在和云层的关系
//////////////////////////////////////////////////
float heightFraction(vec3 pos)
{
	/*pos即射线的出发点
											  ^    pos在云层顶部之上，distFromStart2CloudLower>云层厚度         函数结果>1（会被归一化为1
											  |	
	///////////////云层顶部///////////////////  <---pos在云层顶部，distFromStart2CloudLower==云层厚度， ****函数结果==1****
											   
	    cloudVolumeHeight云层的厚度（米）     
											  
	///////////////云层底部/////////////////// <---pos在这,distFromStart2CloudLower==0               ****函数结果==0****
											  |
											  v   pos在云层底部之下，distFromStart2CloudLower<0          函数结果<0（会被归一化为0
	*/
	float distFromStart2CloudLower =distance(pos, PLANET_CENTER) - PLANET_CENTER_TO_LOWER_CLOUD_RADIUS;
	return clamp( distFromStart2CloudLower / cloudVolumeHeight,0,1.0f);
	//return clamp( ( distance(pos, PLANET_CENTER) - PLANET_CENTER_TO_LOWER_CLOUD_RADIUS ) / cloudVolumeHeight,0,1);//
}

vec4 mixGradients(float cloudType)
{
	float stratus = 1.0f - clamp(cloudType * 2.0f,0,1.0f);
	float stratocumulus = 1.0f - abs(cloudType - 0.5f) * 2.0f;
	float cumulus = clamp(cloudType - 0.5f,0,1.0f) * 2.0f;
	return STRATUS_GRADIENT * stratus + STRATOCUMULUS_GRADIENT * stratocumulus + CUMULUS_GRADIENT * cumulus;
}

float densityHeightGradient(float heightFrac,float cloudType)
{
	vec4 cloudGradient = mixGradients(cloudType);
	return smoothstep(cloudGradient.x, cloudGradient.y, heightFrac) - smoothstep(cloudGradient.z, cloudGradient.w, heightFrac);
}


float sampleCloudDensity(vec3 pos, vec3 weatherData,float heightFrac,float lod)
{
	pos += heightFrac * windDirection * cloudTopOffset;
	pos += (windDirection + vec3(0.0f, -0.25f, 0.0f)) * cloudSpeed * (time/* * 25.0f*/); // the * 25.0f is just for testing to make the effect obvious
	pos *= CLOUD_SCALE;

	vec4 lowFreqNoise = texture(baseNoise, shapeScale * pos);
	//vec4 lowFreqNoise = texture(baseNoise, shapeScale * (pos + windDirection * cloudSpeed * time));
	//vec4 lowFreqNoise = baseShapeLookup.SampleLevel(texSampler, pos, lerp(0.0f, baseShapeTextureBottomMipLevel, lod));
	float lowFreqFBM =
		(lowFreqNoise.g * 0.625f) +
		(lowFreqNoise.b * 0.25f) +
		(lowFreqNoise.a * 0.125f);

	float baseCloud = remap(
		lowFreqNoise.r,
		-(1.0f - lowFreqFBM), 1.0f, // gets about the same results just using -lowFreqFBM
		0.0f, 1.0f);


	float densityGradient = densityHeightGradient(heightFrac, getCloudType(weatherData));
	baseCloud *= densityGradient;

	float cloudCoverage = getCoverage(weatherData);
	float baseCloudWithCoverage = remap(
		baseCloud,
		1.0f - cloudCoverage, 1.0f,
		0.0f, 1.0f);
	baseCloudWithCoverage *= cloudCoverage;

	//// TODO add curl noise
	//// pos += curlNoise.xy * (1.0f - heightFrac);

	vec3 highFreqNoise = texture(detailNoise, detailScale * (pos + detailwindDirection * cloudSpeed * time)).rgb;
	float highFreqFBM =
		(highFreqNoise.r * 0.625f) +
		(highFreqNoise.g * 0.25f) +
		(highFreqNoise.b * 0.125f);

	float highFreqNoiseModifier = lerp(highFreqFBM, 1.0f - highFreqFBM, clamp(heightFrac * 10.0f,0,1));

	baseCloudWithCoverage = remap(
		baseCloudWithCoverage,
		highFreqNoiseModifier * 0.2f, 1.0f,
		0.0f, 1.0f);

	return clamp(baseCloudWithCoverage,0,1.0f);
}

float beerLambert(float sampleDensity, float precipitation)
{
	return exp(-sampleDensity * precipitation);
}

float powder(float sampleDensity, float lightDotEye)
{
	float powd = 1.0f - exp(-sampleDensity * 2.0f);
	return lerp(
		1.0f,
		powd,
		clamp((-lightDotEye * 0.5f) + 0.5f,0,1) // [-1,1]->[0,1]
	);
}
float henyeyGreenstein(
	float lightDotEye,
	float g)
{
	float g2 = g * g;
	return ((1.0f - g2) / pow((1.0f + g2 - 2.0f * g * lightDotEye), 1.5f)) * 0.25f;
}

float lightEnergy(
	float lightDotEye,
	float densitySample,
	float originalDensity,
	float precipitation)
{
	return 2.0f *
		beerLambert(densitySample, precipitation) *
		powder(originalDensity, lightDotEye) * 
		lerp(henyeyGreenstein(lightDotEye, 0.8f), henyeyGreenstein(lightDotEye, -0.5f), 0.5f);
}

// TODO get from cb values - has to change as time of day changes
vec3 ambientLight(float heightFrac)
{
	vec3 tempVec3 = vec3Zero;
	tempVec3.x=lerp(0.5f,1.0f,heightFrac);
	tempVec3.y=lerp(0.67f,1.0f,heightFrac);
	tempVec3.z=lerp(0.82f,1.0f,heightFrac);
	return tempVec3;
	//return lerp(vec3(0.5f, 0.67f, 0.82f),vec3(1.0f, 1.0f, 1.0f),heightFrac);
}

float sampleCloudDensityAlongCone(
	vec3 startPos,
	float  stepSize,
	float  lightDotEye,
	float  originalDensity)
{
	vec3 lightStep = stepSize * -lightDir;
	vec3 pos = startPos;
	float coneRadius = 1.0f;
	float coneStep = RCP_LIGHT_RAY_ITERATIONS;
	float densityAlongCone = 0.0f;
	float lod = 0.0f;
	float lodStride = RCP_LIGHT_RAY_ITERATIONS;
	vec3 weatherData = vec3Zero;
	float rcpThickness = 1.0f / (stepSize * LIGHT_RAY_ITERATIONS);
	float density = 0.0f;

	for(uint i = 0u; i < LIGHT_RAY_ITERATIONS; ++i)
	{
		vec3 conePos = pos + coneRadius * RANDOM_VECTORS[i] * float(i + 1u);
		float heightFrac = heightFraction(conePos);
		if(heightFrac <= 1.0f)
		{
			weatherData = sampleWeather(conePos);
			float cloudDensity = sampleCloudDensity(
				conePos,
				weatherData,
				heightFrac,
				lod);
			if(cloudDensity > 0.0f)
			{
				density += cloudDensity;
				float transmittance = 1.0f - (density * rcpThickness);
				densityAlongCone += (cloudDensity * transmittance);
			}
		}
		pos += lightStep;
		coneRadius += coneStep;
		lod += lodStride;
	}
	// take additional step at large distance away for shadowing from other clouds
	pos = pos + (lightStep * 8.0f);
	weatherData = sampleWeather(pos);
	float heightFrac = heightFraction(pos);
	if(heightFrac <= 1.0f)
	{
		float cloudDensity = sampleCloudDensity(
			pos,
			weatherData,
			heightFrac,
			0.8f);
		// no need to branch here since density variable is no longer used after this
		density += cloudDensity;
		float transmittance = 1.0f - clamp(density * rcpThickness,0,1);
		densityAlongCone += (cloudDensity * transmittance);
	}

	return clamp((lightEnergy(lightDotEye,densityAlongCone,originalDensity,lerp(1.0f, 2.0f, getPrecipitation(weatherData)))),0,1);
}

/////////////////////////////////////////////////////////////////////
////core trace CODE
/////////////////////////////////////////////////////////////////////
vec4 traceClouds(
	vec3 viewDirW,		// world space view direction
	vec3 startPos,		// world space start position
	vec3 endPos)			// world space end position
{
	vec3 dir = endPos - startPos;//从起点到终点的向量
	float thickness = length(dir);//厚度
	float rcpThickness = 1.0f / thickness;

	//参考这里是Uint 
	float sampleCount = lerp(SAMPLE_RANGE_X, SAMPLE_RANGE_Y, clamp(((thickness - cloudVolumeHeight) / cloudVolumeHeight),0,1));//采样的次数
	//int sampleCount = lerp(SAMPLE_RANGE_X, SAMPLE_RANGE_Y, clamp(((thickness - cloudVolumeHeight) / cloudVolumeHeight),0,1));//采样的次数

	float stepSize = thickness / float(sampleCount);//每次采样前进的距离，步长
	dir /= thickness;//normalize向量归一化
	vec3 posStep = stepSize * dir;//沿着dir向量走stepSize这么远

	float lightDotEye = -dot(lightDir, viewDirW);

	vec3 pos = startPos;
	vec3 weatherData = vec3Zero;
	vec4 result = vec4Zero ;
	float density = 0.0f;
	
	//for(uint i = 0u; i < sampleCount; ++i)
	for(uint i = 0u; i < floor(sampleCount); ++i)
	{
		float heightFrac = heightFraction(pos);//得到startPos和云层的关系。
		weatherData = sampleWeather(pos);
		float cloudDensity = sampleCloudDensity(
			pos,
			weatherData,
			heightFrac,
			0.0f);

		if(cloudDensity > 0.0f)
		{
			density += cloudDensity;
			float transmittance = 1.0f - (density * rcpThickness);
			float lightDensity = sampleCloudDensityAlongCone(
				pos,
				stepSize,
				lightDotEye,
				cloudDensity);

			vec3 ambientBadApprox = ambientLight(heightFrac) * min(1.0f, length(sunColor.rgb * 0.0125f)) * transmittance;
			vec4 source = vec4((sunColor.rgb * lightDensity) + ambientBadApprox/*+ ambientLight(heightFrac)*/, cloudDensity * transmittance); // TODO enable ambient when added to constant buffer
			source.rgb *= source.a;
			result = (1.0f - result.a) * source + result;
			if(result.a >= 1.0f) break;
		}

		pos += posStep;
	}

	// experimental fog - may not be needed if clouds are drawn before atmosphere - would have to draw sun by itself, then clouds, then atmosphere
	// fogAmt = 0 to disable
	float fogAmt = 1.0f - exp(-distance(startPos, camPos) * 0.00001f);
	vec3 fogColor = vec3(0.3f, 0.4f, 0.45f) * length(sunColor.rgb * 0.125f) * 0.8f;
	vec3 sunColor = normalize(sunColor.rgb) * 4.0f * length(sunColor.rgb * 0.125f);

	fogColor = lerpVec3(fogColor, sunColor,   pow(clamp(lightDotEye,0.0f,1.0f),8.0f)    );


	return result;
	return vec4(fogColor,1);
	return vec4(clamp(lerpVec3(result.xyz,fogColor,fogAmt), 0.0f, 1000.0f), clamp(result.a,0,1));
	//return vec4(clamp(lerp(result.rgb, fogColor, fogAmt), 0.0f, 1000.0f), clamp(result.a,0,1));
}


    ////////////////////////////////////////////////////////////////////




uniform vec3 cameraPos;



// Sun Params.
uniform float sunEnergy = 0.5;
uniform vec3 sunDirection;


// Cloud Layer Params.
uniform float cloudBottom = 1500.0;
uniform float cloudTop = 10000.0;

// Cloud Shape Params.
uniform vec3 shapeWeights = vec3(0.33, 0.33, 0.33);
uniform float cloudCover = 0.3;

// Cloud Detail Params.
uniform vec3 detailWeights = vec3(0.33, 0.33, 0.33);
uniform float detailMultiplier = 0.05;



// Lighting params.
uniform float lightAbsorptionTowardsSun = 0.5;
uniform float forwardScattering = 0.1;
uniform float powderStrength = 0.1;

// Cloud Absorption Params.
uniform float cloudAbsorption = 0.5;
uniform vec3 ambient = vec3(0.4, 0.4, 0.4);

// Raymarching Params.
uniform int raymarchingSteps = 256; // max number of samples
uniform int lightSteps = 12;
uniform float renderDistance = 100000.0;



float intersectPlane(float height, vec3 pos, vec3 dir) {
	return (height - pos.y) / dir.y;
}

//float remap(const float originalValue, const float originalMin, const float originalMax, const float newMin, const float newMax) {
//	return newMin + (((originalValue - originalMin) / (originalMax - originalMin)) * (newMax - newMin));
//}

// Position to relative height in cloud layer.
float getHeightFractionForPoint(vec3 pos) {
	return (pos.y - cloudBottom) / (cloudTop - cloudBottom);
}

//float getCloudType(vec3 weatherData)
//{
//	// weather b channel tells the cloud type 0.0 = stratus, 0.5 = stratocumulus, 1.0 = cumulus
//	return weatherData.b;
//}


// Cloud gradients.
float heightGradient(float ll, float lu, float ul, float uu, float height) {
	return smoothstep(ll, lu, height) - smoothstep(ul, uu, height);
}

float stratusGradient(float height) {
	return heightGradient(0.0, 0.05, 0.08, 0.1, height);
}

float cumulusGradient(float height) {
	return heightGradient(0.0, 0.2, 0.4, 0.6, height);
}

float cumulonimbusGradient(float height) {
	return heightGradient(0.0, 0.1, 0.7, 1.0, height);
}
//vec4 mixGradients(
//	float cloudType)
//{
//	float stratus = 1.0f - clamp((cloudType * 2.0f),0,1.0f);
//	float stratocumulus = 1.0f - abs(cloudType - 0.5f) * 2.0f;
//	float cumulus = clamp(((cloudType - 0.5f) * 2.0f),0,1.0f);
//	return STRATUS_GRADIENT * stratus + STRATOCUMULUS_GRADIENT * stratocumulus + CUMULUS_GRADIENT * cumulus;
//}

//float densityHeightGradient(
//	float heightFrac,
//	float cloudType)
//{
//	vec4 cloudGradient = mixGradients(cloudType);
//	return smoothstep(cloudGradient.x, cloudGradient.y, heightFrac) - smoothstep(cloudGradient.z, cloudGradient.w, heightFrac);
//}


float HGphase(float g, float costheta) {
	float gg = g*g;
	return (1.0 - gg) / pow(1.0 + gg - 2.0 * g * costheta, 1.5);
}


////////////////////////////////////////////////////////////
////采样密度///////
////////////////////////////////////////////////////////////
float sampleCloudDensity
	(
	vec3 pos, bool highQuality,	
	float heightFrac,vec3 weatherData = vec3(1,1,1)
	)
{
	vec4 lowFreqNoise = texture(baseNoise, shapeScale * (pos + windDirection * cloudSpeed * time));
	float lowFreqFBM =
		(lowFreqNoise.g * 0.625f) +
		(lowFreqNoise.b * 0.25f) +
		(lowFreqNoise.a * 0.125f);

	float baseCloud  = remap(lowFreqNoise.r, -(1.0f - lowFreqFBM), 1.0, 0.0, 1.0) ;
	baseCloud  *= cumulonimbusGradient(getHeightFractionForPoint(pos));//原来的

	float densityGradient = densityHeightGradient(heightFrac, getCloudType(weatherData));

	float baseCloudWithCoverage = remap(baseCloud, 1.0 - cloudCover, 1.0, 0.0, 1.0);
	baseCloudWithCoverage *= cloudCover;

	if (highQuality) {

		vec3 highFreqNoise = texture(detailNoise, detailScale * (pos + detailwindDirection * cloudSpeed * time)).rgb;
		//float detailFBM = dot(detailNoiseValue, detailWeights);
			float highFreqFBM =
		(highFreqNoise.r * 0.625f) +
		(highFreqNoise.g * 0.25f) +
		(highFreqNoise.b * 0.125f);

		float heightFraction = getHeightFractionForPoint(pos);
		float detailNoiseModifier = mix(highFreqFBM, 1.0 - highFreqFBM, clamp(heightFraction * 10.0, 0.0, 1.0));

		baseCloudWithCoverage = remap(baseCloudWithCoverage, detailNoiseModifier * detailMultiplier, 1.0, 0.0, 1.0);
	}

	return clamp(baseCloudWithCoverage, 0.0, 1.0);
}

vec3 sampleLight(vec3 pos) {

	float stepSize = 100.0;
	vec3 lightStep = stepSize * sunDirection;
	float densityAlongCone = 0.0;

	for (int i = 0; i < 6; ++i) {
		if (pos.y < cloudBottom || pos.y > cloudTop) break;

		pos += lightStep;
		lightStep += 0.5 * lightStep;
		float heightFrac = heightFraction(pos);//得到startPos和云层的关系。
		densityAlongCone += sampleCloudDensity(pos, true,heightFrac) * stepSize * lightAbsorptionTowardsSun;

	}
	float beers = max(exp(-densityAlongCone), 0.7 * exp(-densityAlongCone * 0.25)); // 1
	float powder = 1.0 - powderStrength * exp(-2.0*densityAlongCone); // 0
	return vec3(1.0) * sunEnergy * beers * powder;
}

void mai1n() {

	// Get clip space position
	vec2 uv = 2.0 * gl_FragCoord.xy / resolution - 1.0;
	vec4 clipPos = vec4(uv.xy, 1.0, 1.0); // z=1.0 ist the near plane

	// Set ray origin in "earth space".
	vec3 rayPos = (inverse(view) * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	vec3 viewDirW = normalize((inverse(view) * vec4((inverse(projection) * clipPos).xyz, 0.0)).xyz);

	// Calculate the distance the ray has to travel.
	float dstBottom = max(0.0, intersectPlane(cloudBottom, rayPos, viewDirW));
	float dstTop = max(0.0, intersectPlane(cloudTop, rayPos, viewDirW));
	float dstInLayer = min(abs(dstTop - dstBottom), renderDistance);
	float dstToLayer = min(dstTop, dstBottom);

	float dstTravelled = 0.0;

	FragColor = vec4(0.4, 0.4, 0.4, 1.0);

	// Move ray origin to intersection with cloud bottom plane.
	rayPos += viewDirW * dstToLayer;//世界坐标

	float heightFrac = heightFraction(rayPos);//得到startPos和云层的关系。
	dstTravelled += dstToLayer;

	float stepSize = dstInLayer / float(raymarchingSteps);
	
	vec3 rayStep = stepSize * viewDirW;

	vec3 lightEnergy = vec3(0.0);
	float transmittance = 1.0;
	float cloudTest = 0.0;
	int zeroDensitySampleCount = 0;

	for (int i = 0; i < raymarchingSteps; ++i) {
		if (dstTravelled > renderDistance) break;
		if (dstBottom == dstTop) break; // not inside clouds
		if (transmittance < 0.001) break;

		if (cloudTest > 0.0) {
			float sampledDensity = sampleCloudDensity(rayPos, true,heightFrac);

			if (sampledDensity == 0.0) {
				++zeroDensitySampleCount;
			}

			if (zeroDensitySampleCount != 6) {
				transmittance *= exp(-sampledDensity * stepSize * cloudAbsorption);
				if (sampledDensity != 0.0) {
					lightEnergy += sampleLight(rayPos) * sampledDensity * stepSize * transmittance;
				}
				rayPos += rayStep;
				dstTravelled += stepSize;
			} else {
				cloudTest = 0.0;
				zeroDensitySampleCount = 0;
			}

		} else {
			cloudTest = sampleCloudDensity(rayPos, false,heightFrac);

			if (cloudTest == 0.0) {
				rayPos += rayStep;
				dstTravelled += stepSize;
			}
		}
	}

	// HG 根据太阳的位置，加入散射效果效果
	float phaseVal = HGphase(forwardScattering, dot(viewDirW, sunDirection));
	lightEnergy *= phaseVal;

	//增加云层受太阳光的颜色影响
	lightEnergy = clamp(lightEnergy * sunColor, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));

	// Background.
	vec4 skyColor = vec4(0.5, 0.7, 1.0, 1.0);
	vec4 backgroundColor = skyColor + max(0.0, pow(dot(viewDirW, sunDirection), 512.0));

	// Compose.
	FragColor = mix(vec4(ambient, 1.0), backgroundColor, transmittance) + vec4(lightEnergy * (1.0 - transmittance), 1.0);


}


void main() 
{
/*	int3 loadIndices = int3(pIn.posH.xy, 0); //posH 应该就是 posH: POSITION0;，顶点的坐标
//	float zwDepth = depthTexture.Load(loadIndices).r; //读取和屏幕尺寸一样大的深度贴图，得到着色点的深度值
	~~~
	void ps_main(float4 screenPos : SV_Position, ...)
{
    float depth = depthTexture.Load(int3(screenPos.xy, 0));      texture.load()的用法
    ...
}
	~~~
//	bool depthPresent = zwDepth < 1.0f;//深度小于1，就是着色点不贴在相机的近平面上。

//	float depth = linearizeDepth(zwDepth); https://www.prkz.de/blog/1-linearizing-depth-buffer-samples-in-hlsl

//	vec3 posV = pIn.viewRay * depth; //frag pos in viewSpace 相机空间下的片元坐标
//	vec3 posW = mul(vec4(posV, 1.0f), inverseViewMatrix).xyz; //世界空间下的片元坐标
	//vec3 viewDirW = normalize(posW - camPos);//片元坐标-相机坐标=从相机到片元的向量 自然就是viewDir （world space
*/	
		
    float  depth =LinearizeDepth(gl_FragCoord.z)/far_plane;
	//float zwDepth =texture(depthTexture, posW.xy).r;//读取和屏幕尺寸一样大的深度贴图，得到着色点的深度值
	//bool depthPresent = zwDepth < 1.0f;//深度小于1，就是着色点不贴在相机的远平面上。
	bool depthPresent = depth < 1.0f;//这不必定<1吗
	
	// Get clip space position
	vec2 uv = 2.0 * gl_FragCoord.xy / resolution - 1.0;
	vec4 clipPos = vec4(uv.xy, 1.0, 1.0); // z=1.0 ist the near plane
	vec3 viewDirW = normalize((inverse(view) * vec4((inverse(projection) * clipPos).xyz, 0.0)).xyz);
	/* find nearest planet surface point
	/intersectRaySphere 返回相交的次数
	/和最后一个参数，最后一个参数代表第一次相交的坐标
	ph代表从地球中心出发，往视线方向发射射线，该射线与地球的交点
	*/
	vec2 plantHit = vec2(0,0);
	uint planetHits = intersectRaySphere(
		camPos,
		viewDirW,
		PLANET_CENTER,
		groundRadius,
		plantHit);

	/* find nearest inner shell point

	/ih代表从地球中心出发，往视线方向发射射线，该射线和云层的底层边界的交点
	*/
	vec2 inHit = vec2(0,0);
	uint innerShellHits = intersectRaySphere(
		camPos,
		viewDirW,
		PLANET_CENTER,
		PLANET_CENTER_TO_LOWER_CLOUD_RADIUS,//从地球中心到云层最低处的半径
		inHit);

	/* find nearest outer shell point
		/oh代表从地球中心出发，往视线方向发射射线，该射线和云层的外层边界的交点
	*/
	vec2 outHit = vec2(0,0);
	uint outerShellHits = intersectRaySphere(
		camPos,
		viewDirW,
		PLANET_CENTER,
		PLANET_CENTER_TO_UPPER_CLOUD_RADIUS,//radius from the planet center to the top of the cloud volume
		outHit);

	// world space ray intersections
	vec3 planetHitSpot = camPos + (viewDirW * plantHit.x);//viewDirW * ph.x==沿着视线方向，向
	vec3 innerShellHit = camPos + (viewDirW * inHit.x);
	vec3 outerShellHit = camPos + (viewDirW * outHit.x);

	float distFromSP2EyePos = distance(posW, camPos);//从着色点到相机世界坐标的距离
	float distFromInnerShellHit2EyePos = distance(innerShellHit, camPos);//从云层底部交点到相机世界坐标的距离
	// eye radius from planet center
	float eyeRadius = distance(camPos, PLANET_CENTER);//从地球中心到相机的距离

			 FragColor=traceClouds(
			viewDirW,
			innerShellHit,
			outerShellHit);//从云层底部开始，到云层顶部结束
			return;



	//////////////////////  <-------云层顶部

	//////////////////////  <-------云层底部
	//相机在这（云层底部之下）
	if(eyeRadius < PLANET_CENTER_TO_LOWER_CLOUD_RADIUS) // under inner shell 
	{
	
		// exit if there's something in front of the start of the cloud volume
		// 如果有任何东西挡在云层之前（用 着色点到相机的距离<云层最低处的交点到相机的距离 判断）
		if((depthPresent && (distFromSP2EyePos < distFromInnerShellHit2EyePos)) ||
			planetHits > 0u) // shell hits are guaranteed, but the ground may be occluding cloud layer
		{
			FragColor = vec4(0.0f, 0.0f, 0.0f, 0.0f);
			return;
		}
		 FragColor=traceClouds(
			viewDirW,
			innerShellHit,
			outerShellHit);//从云层底部开始，到云层顶部结束
			return;
	}
	//相机在这（云层顶部之上）
	//////////////////////  <-------云层顶部

	//////////////////////  <-------云层底部
	else if(eyeRadius > PLANET_CENTER_TO_UPPER_CLOUD_RADIUS) // over outer shell 
	{
		// possibilities are
		// 1) enter outer shell, leave inner shell
		// 2) enter outer shell, leave outer shell
		vec3 firstShellHit = outerShellHit;
		if(outerShellHits == 0u ||
			depthPresent && (distFromSP2EyePos < distance(firstShellHit, camPos)))
		{
			FragColor = vec4(0.0f, 0.0f, 0.0f, 0.0f);
			return;
		}
		vec3 secondShellHit = outerShellHits == 2u && innerShellHits == 0u ? camPos + (viewDirW * outHit.y) : innerShellHit;
		FragColor = traceClouds(
			viewDirW,
			firstShellHit,
			secondShellHit);//从outerShellHit云层顶部第一个交点，到云层底部或者
			return;
	}

	//////////////////////  <-------云层顶部
	//相机在这（云层中）
	//////////////////////  <-------云层底部
	else // between shells 在云层中间
	{
		/*
		 * From a practical viewpoint (properly scaled planet, atmosphere, etc.)
		 * only one shell will be hit.
		 * Start position is always eye position.
		 */
		vec3 shellHit = innerShellHits > 0u ? innerShellHit : outerShellHit;
		// if there's something in the depth buffer that's closer, that's the end point
		if(depthPresent && (distance(posW, camPos) < distance(shellHit, camPos)))
		{
			shellHit = posW;
		}
		FragColor = traceClouds(
			viewDirW,
			camPos,//从相机到云层顶部或者底部结束。
			shellHit);
			return;
	}
}