#version 330 core
out vec4 FragColor;

uniform mat4 view; // inverse view-projection matrix
uniform mat4 projection;
uniform vec3 cameraPos;
uniform vec2 resolution;//(SCR_WIDTH,SCR_HEIGHT)
uniform sampler3D baseNoise;
uniform sampler3D detailNoise;
uniform float time;

//added parameters
uniform float cloudVolumeStartHeight; // meters - height above ground level 云层开始的高度（从地表开始算
uniform float cloudVolumeHeight; // meters - height above ground level 云层所占的高度即云层的厚度（从地表开始算
uniform float groundRadius; // meters - for a ground/lower atmosphere only version, this could be smaller 从地心到地表的距离

float VOLUME_END_HEIGHT = cloudVolumeStartHeight + cloudVolumeHeight;//地表到云层最外侧的距离 = 地表到云层开始的距离（高度）+云层的厚度

// radius from the planet center to the bottom of the cloud volume
 float PLANET_CENTER_TO_LOWER_CLOUD_RADIUS = groundRadius + cloudVolumeStartHeight;
// radius from the planet center to the top of the cloud volume
  float PLANET_CENTER_TO_UPPER_CLOUD_RADIUS = groundRadius + VOLUME_END_HEIGHT;//云层最外层到地心的距离= 地表到地心的距离+地表到云层最外侧的距离
// Sun Params.
uniform float sunEnergy = 0.5;
uniform vec3 sunDirection;
uniform vec3 sunColor = vec3(0.5, 0.3, 0.1);

// Cloud Layer Params.
uniform float cloudBottom = 1500.0;
uniform float cloudTop = 10000.0;

// Cloud Shape Params.
uniform float shapeScale = 0.00001;
uniform vec3 shapeWeights = vec3(0.33, 0.33, 0.33);
uniform float cloudCover = 0.3;

// Cloud Detail Params.
uniform float detailScale = 0.0002;
uniform vec3 detailWeights = vec3(0.33, 0.33, 0.33);
uniform float detailMultiplier = 0.05;

// Cloud Animation Params.
uniform vec3 windVector = vec3(10.0, 0.0, 0.0);
uniform vec3 detailWindVector = vec3(1.0, 1.0, 0.0);
uniform float windSpeed = 100.0;

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

  vec4 STRATUS_GRADIENT = vec4(0.02f, 0.05f, 0.09f, 0.11f);
  vec4 STRATOCUMULUS_GRADIENT = vec4(0.02f, 0.2f, 0.48f, 0.625f);
  vec4 CUMULUS_GRADIENT = vec4(0.01f, 0.0625f, 0.78f, 1.0f); // these fractions would need to be altered if cumulonimbus are added to the same pass

float intersectPlane(float height, vec3 pos, vec3 dir) {
	return (height - pos.y) / dir.y;
}

float remap(const float originalValue, const float originalMin, const float originalMax, const float newMin, const float newMax) {
	return newMin + (((originalValue - originalMin) / (originalMax - originalMin)) * (newMax - newMin));
}

// Position to relative height in cloud layer.
float getHeightFractionForPoint(vec3 pos) {
	return (pos.y - cloudBottom) / (cloudTop - cloudBottom);
}

float getCloudType(vec3 weatherData)
{
	// weather b channel tells the cloud type 0.0 = stratus, 0.5 = stratocumulus, 1.0 = cumulus
	return weatherData.b;
}


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
vec4 mixGradients(
	float cloudType)
{
	float stratus = 1.0f - clamp((cloudType * 2.0f),0,1.0f);
	float stratocumulus = 1.0f - abs(cloudType - 0.5f) * 2.0f;
	float cumulus = clamp(((cloudType - 0.5f) * 2.0f),0,1.0f);
	return STRATUS_GRADIENT * stratus + STRATOCUMULUS_GRADIENT * stratocumulus + CUMULUS_GRADIENT * cumulus;
}

float densityHeightGradient(
	float heightFrac,
	float cloudType)
{
	vec4 cloudGradient = mixGradients(cloudType);
	return smoothstep(cloudGradient.x, cloudGradient.y, heightFrac) - smoothstep(cloudGradient.z, cloudGradient.w, heightFrac);
}


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
	float heightFrac=0,vec3 weatherData = vec3(1,1,1)
	)
{
	vec4 lowFreqNoise = texture(baseNoise, shapeScale * (pos + windVector * windSpeed * time));
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

		vec3 highFreqNoise = texture(detailNoise, detailScale * (pos + detailWindVector * windSpeed * time)).rgb;
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

		densityAlongCone += sampleCloudDensity(pos, true) * stepSize * lightAbsorptionTowardsSun;

	}
	float beers = max(exp(-densityAlongCone), 0.7 * exp(-densityAlongCone * 0.25)); // 1
	float powder = 1.0 - powderStrength * exp(-2.0*densityAlongCone); // 0
	return vec3(1.0) * sunEnergy * beers * powder;
}

void main() {

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
			float sampledDensity = sampleCloudDensity(rayPos, true);

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
			cloudTest = sampleCloudDensity(rayPos, false);

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
	//FragColor = vec4(0,0.5,0,1);
	//FragColor= vec4(rayPos,1);
//	FragColor= vec4(lightEnergy,1);
	//FragColor= vec4(dstToLayer);

}