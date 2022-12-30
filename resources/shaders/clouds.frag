#version 330 core
out vec4 FragColor;
in vec3 posW;

uniform float time;
uniform mat4 view; // inverse view-projection matrix
uniform mat4 projection;
uniform vec2 resolution;//(SCR_WIDTH,SCR_HEIGHT)
// Sun Params.
uniform vec3 sunColor = vec3(0.5, 0.3, 0.1);
uniform float anbientIntensity = 0.1f;

//added parameters
uniform float cloudVolumeStartHeight; // meters - height above ground level 云层开始的高度（从地表开始算
uniform float cloudVolumeHeight; // meters - height above ground level 云层所占的高度即云层的厚度（从地表开始算

uniform vec3 lightDir; // light direction world space
uniform float groundRadius; // meters - for a ground/lower atmosphere only version, this could be smaller 从地心到地表的距离
		 
//uniform vec3 sunColor; // color of sun light

uniform uint baseShapeTextureBottomMipLevel;

uniform vec3 camPos;
uniform vec4 CloudBaseColor = vec4(0.3843,0.47,0.525,1);
uniform vec4 CloudTopColor = vec4(0.212,0.267,0.298,1);
uniform	vec3 verticalProbParam = vec3(0,0,0);

uniform float cloudSpeed;
uniform float cloudTopOffset;


uniform float precipiFactor;
uniform float coverageFactor;
uniform float curlNoiseMultiple;

uniform vec3 windDirection ;
uniform uint erosionTextureBottomMipLevel;

uniform vec3 weatherTexMod; // scale(x), offset(y, z)
uniform float windStrength;

uniform float sunEnergy;
uniform	float NoiseThreshold = 0.6f;
uniform	float NoiseMax =0.9f;

uniform sampler3D baseNoise;
uniform sampler3D detailNoise;
uniform sampler2D weatherLookup;
uniform sampler2D depthTexture;
uniform sampler2D curlNoise;
uniform sampler2D blueNoise;

vec4 vec4Zero =vec4 (0,0,0,0);
vec3 vec3Zero =vec3 (0,0,0);
vec2 vec2Zero =vec2 (0,0);


float PI = 3.141592627;

//DEBUG
uniform bool shoWeatherMap;
uniform int weatherMapChannel;


float VOLUME_END_HEIGHT = cloudVolumeStartHeight + cloudVolumeHeight;//地表到云层最外侧的距离 = 地表到云层开始的距离（高度）+云层的厚度
// planet center (world space)
vec3 PLANET_CENTER = vec3(0.0f, -groundRadius - 100.0f, 0.0f); // TODO revisit - 100.0f offset is to match planet sky settings
// radius from the planet center to the bottom of the cloud volume
float PLANET_CENTER_TO_LOWER_CLOUD_RADIUS = groundRadius + cloudVolumeStartHeight;
// radius from the planet center to the top of the cloud volume
float PLANET_CENTER_TO_UPPER_CLOUD_RADIUS = groundRadius + VOLUME_END_HEIGHT;//云层最外层到地心的距离= 地表到地心的距离+地表到云层最外侧的距离
float CLOUD_SCALE = 1.0f / VOLUME_END_HEIGHT;
//vec3 WEATHER_TEX_MOD = vec3(1.0f / (VOLUME_END_HEIGHT * weatherTexMod.x), weatherTexMod.y, weatherTexMod.z); 
vec3 WEATHER_TEX_MOD = vec3(1.0f / (VOLUME_END_HEIGHT * weatherTexMod.x), weatherTexMod.y, weatherTexMod.z); 
vec2 WEATHER_TEX_MOVE_SPEED = vec2(windStrength * windDirection.x, windStrength * windDirection.z); // this is modded by app run time
  // samples based on shell thickness between inner and outer volume
uint SAMPLE_RANGE_X = 64u;
uint SAMPLE_RANGE_Y = 128u;
vec4 STRATUS_GRADIENT = vec4(0.02f, 0.05f, 0.09f, 0.11f);//层云
vec4 STRATOCUMULUS_GRADIENT = vec4(0.02f, 0.2f, 0.48f, 0.625f);//层积云
vec4 CUMULUS_GRADIENT = vec4(0.01f, 0.0625f, 0.78f, 1.0f); //积云 these fractions would need to be altered if cumulonimbus are added to the same pass

//vec3 STRATUS_GRADIENT = vec4(0.02f, 0.05f, 0.09f, 0.11f);//层云
//vec3 STRATOCUMULUS_GRADIENT = vec4(0.02f, 0.2f, 0.48f, 0.625f);//层积云
//vec3 CUMULUS_GRADIENT = vec4(0.01f, 0.0625f, 0.78f, 1.0f); //积云 these fractions would need to be altered if cumulonimbus are added to the same pass


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






  uint LIGHT_RAY_ITERATIONS = 6u;//could be 2 ，cloud'll be lighter
  float RCP_LIGHT_RAY_ITERATIONS = 1.0f / float(LIGHT_RAY_ITERATIONS);

 uniform float near_plane;
uniform float far_plane;
///////////////////////////////////////////
// Cloud Detail Params.
uniform float detailScale = 0.0064;


// Cloud Animation Params.
uniform vec3 detailwindDirection = vec3(1.0, 1.0, 0.0);


float saturate(float x)
{
return clamp(x, 0.0, 1.0);
}

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
	//return weatherData.r;
	return mix(weatherData.r,1.0,coverageFactor);
}

float getPrecipitation(vec3 weatherData) //云层厚度不变的情况下，云层的明暗程度
{
	return weatherData.g*precipiFactor;
}

float getCloudType(vec3 weatherData)
{
	// weather b channel tells the cloud type 0.0 = stratus, 0.5 = stratocumulus, 1.0 = cumulus
	return weatherData.b;
}

vec3 sampleWeather(vec3 pos)
{
	//vec2 unit = pos.xz ;
	vec2 unit = pos.xz *  weatherTexMod.x / 30000.0;

	vec2 uv = unit * 0.5 + 0.5+(WEATHER_TEX_MOVE_SPEED * time);

	return texture(weatherLookup, uv).rgb;
}

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
float GetHeightFractionForPoint(vec3 pos)
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
	float stratus = 1.0f - saturate(cloudType * 2.0f);//cloudType==0，stratus==1/cloudType==1，stratus==0
	float stratocumulus = 1.0f - abs(cloudType - 0.5f) * 2.0f;//cloudType==0,1，stratocumulus==0,cloudType==0.5，stratocumulus==1
	float cumulus = saturate(cloudType - 0.5f) * 2.0f;//cloudType==0，stratus==0/cloudType==1，stratus==1
	return STRATUS_GRADIENT * stratus + STRATOCUMULUS_GRADIENT * stratocumulus + CUMULUS_GRADIENT * cumulus;
}

float densityHeightGradient(float heightFrac,float cloudType)
{
	vec4 cloudGradient = mixGradients(cloudType);
	return smoothstep(cloudGradient.x, cloudGradient.y, heightFrac) - smoothstep(cloudGradient.z, cloudGradient.w, heightFrac);
}
float GetDensityHeightGradientForPoint(float heightFraction, float weatherData)
{

	float cumulus = saturate(weatherData - 0.5f) * 2.0f;//cloudType==0，stratus==0/cloudType==1，stratus==1
	float stratocumulus = 1.0f - abs(weatherData - 0.5f) * 2.0f;//cloudType==0,1，stratocumulus==0,cloudType==0.5，stratocumulus==1
	float stratus = 1.0f - saturate(weatherData * 2.0f);//cloudType==0，stratus==1/cloudType==1，stratus==0

//	float cumulusRemap =saturate(remap(heightFraction, 0.08, 0.13, 0.1, 1.0)) * saturate(remap(heightFraction, 0.35, 0.85, 1.0,0.0));
//	float stratocumulusRemap = saturate(remap(heightFraction, 0.13, 0.23, 0.0, 1.0)) * saturate(remap(heightFraction, 0.1, 0.5, 1.0,0.0));
//	float stratusRemap =  saturate(remap(heightFraction, 0.13, 0.23, 0.0, 1.0)) * saturate(remap(heightFraction, 0.2, 0.3 ,1.0,0.0));
	float cumulusRemap =saturate(remap(heightFraction, 0.0, 0.13, 0.1, 1.0)) * saturate(remap(heightFraction, 0.35, 0.85, 1.0,0.0));
	float stratocumulusRemap = saturate(remap(heightFraction, 0.13, 0.23, 0.0, 1.0)) * saturate(remap(heightFraction, 0.1, 0.5, 1.0,0.0));
	//													buttom thickness										Top thickness
	float stratusRemap =  saturate(remap(heightFraction, .8, 0.85, 0.0, 1.0)) * saturate(remap(heightFraction, 0.8, 1.0 ,1.0,0.0));//stratus at top
	//float stratusRemap =  saturate(remap(heightFraction, 0.13, 0.28, 0.0, 1.0)) * saturate(remap(heightFraction, 0.2, 0.3 ,1.0,0.0));//STRATUS AT BUTTOM
	
	
	
	
	return cumulusRemap * cumulus+stratocumulusRemap*stratocumulus+ stratusRemap*stratus;
	//return cumulusRemap * 0+stratocumulusRemap*0+ stratusRemap*stratus ;
	//return saturate(remap(heightFraction, 底部的高度, 底部的腐蚀强度, 0.0, 1.0)) * saturate(remap(heightFraction, 顶部的高度,顶部的腐蚀程度, 1.0,0.0));

}
	
	vec4 GetHeightGradient(float cloudType)
{
	vec4 CloudGradient1 = vec4(0.0, 0.07, 0.08, 0.15);
	vec4 CloudGradient2 = vec4(0.0, 0.2, 0.42, 0.6);
	vec4 CloudGradient3 = vec4(0.0, 0.08, 0.75, 0.98);


	float stratus = 1.0 - saturate(cloudType * 2.0);
	float b = 1.0 - abs(cloudType - 0.5) * 2.0;
	float c = saturate(cloudType - 0.5) * 2.0;

	return CloudGradient1 * stratus + CloudGradient2 * b + CloudGradient3 * c;
}

float GradientStep(float heightFrac, vec4 gradient)
{
	return smoothstep(gradient.x, gradient.y, heightFrac) - smoothstep(gradient.z, gradient.w,heightFrac);
}

	
///////////////////////////////////////////////////////////////////
//////// 采样出密度   
///////////////////////////////////////////////////////////////////
/* 通过heightFrac<---给进来的pos在云层中的位置，来计算密度。
*/ 



float sampleCloudDensity(vec3 pos, vec3 weatherData,float heightFrac,bool doCheaply)
{
	const float baseFreq = 1e-5;
	pos += heightFrac * windDirection * cloudTopOffset;
	//pos += windDirection * cloudSpeed * time; 
	//TODO ADD A PARAMETERS HERE ↓
	pos *= CLOUD_SCALE*     1.0;

	//pos *=  baseFreq * 0.1f;
	vec4 lowFreqNoise = texture(baseNoise,  pos);

	float lowFreqFBM =(lowFreqNoise.g * 0.625f) +(lowFreqNoise.b * 0.25f) +(lowFreqNoise.a * 0.125f);

	//#define SIG 
	//#define BBS 
	#define COMBINE 

#if defined(SIG)
	float baseCloud = remap(lowFreqNoise.r, -(1- lowFreqFBM), 1.0f, 0.0f, 1.0f);//from siggragh 2017
	float densityHeightGradient = GetDensityHeightGradientForPoint(heightFrac, getCloudType(weatherData));
	baseCloud *= densityHeightGradient;
	float cloudCoverage = getCoverage(weatherData);
	
	//cloudCoverage = 1.0-cloudCoverage*heightFrac;
	float baseCloudWithCoverage = remap(baseCloud, 1.0f-cloudCoverage, 1.0f,0.0f, 1.0f);//from siggragh 2017
	baseCloudWithCoverage *= saturate(cloudCoverage);

	float density = baseCloudWithCoverage;

#elif defined(BBS)

	float baseCloud = remap(lowFreqNoise.r, -lowFreqFBM, 1.0f, 0.0f, 1.0f);//from BBS
	baseCloud = remap(baseCloud, NoiseThreshold, NoiseMax, 0.0, 1.0);

	
	float weatherType = weatherData.b;
	float heightGradient = GradientStep(heightFrac, GetHeightGradient(weatherType));
	baseCloud *= heightGradient;

	float cloudCoverage = getCoverage(weatherData);
	float baseCloudWithCoverage = remap(baseCloud, saturate(heightFrac / cloudCoverage), 1.0f,0.0f, 1.0f);//from BBS
	baseCloudWithCoverage *= saturate(cloudCoverage);
	float density = baseCloudWithCoverage;

#elif defined(COMBINE)
	float baseCloud = remap(lowFreqNoise.r, -(1- lowFreqFBM), 1.0f, 0.0f, 1.0f);//from siggragh 2017
	baseCloud = remap(baseCloud, NoiseThreshold, NoiseMax, 0, 1.0);//0.5 0.7 

	float densityHeightGradient = GetDensityHeightGradientForPoint(heightFrac, getCloudType(weatherData));
	baseCloud *= densityHeightGradient;


	float cloudCoverage = getCoverage(weatherData);

	float baseCloudWithCoverage = remap(baseCloud, 1.0f-cloudCoverage, 1.0f,0.0f, 1.0f);//from siggragh 2017
	baseCloudWithCoverage *= saturate(cloudCoverage);

	float density = baseCloudWithCoverage;

#endif

	//return density;
	if (!doCheaply)
	{
	vec2 curlNoise = texture(curlNoise,pos.xy).rg;
	 pos += vec3(curlNoise.xy * (1.0f - heightFrac)*curlNoiseMultiple,0.0);

	//vec3 highFreqNoise = texture(detailNoise, detailScale * (pos + detailwindDirection * cloudSpeed * time)).rgb;
	// vec3 highFreqNoise = texture(detailNoise, pos  * detailScale).rgb;
	 vec3 highFreqNoise = texture(detailNoise, detailScale*pos+detailwindDirection * cloudSpeed * time).rgb;

	    // build High frequency Worley noise fBm
    float high_freq_fBm = ( highFreqNoise.r * 0.625 ) + ( highFreqNoise.g * 0.25 ) + ( highFreqNoise.b * 0.125 );

    // get the height_fraction for use with blending noise types over height
    float heightFraction  = GetHeightFractionForPoint(pos);
		

    float high_freq_noise_modifier = lerp(high_freq_fBm, 1.0 - high_freq_fBm, saturate(heightFrac * 10.0));

    //density = remap(baseCloudWithCoverage, high_freq_noise_modifier*0.2 , 1.0, 0.0, 1.0);//from sig2017 if let highFreqNoise times 0.2,The weatherTex's R channel'll weaker contrast
	   density = remap(baseCloudWithCoverage, high_freq_noise_modifier, 1.0, 0.0, 1.0);//from BBS but more similar to the result which sig2017 showed

	}

	return density;
}



//////////////////////////////////////////////////////////////////////////////////////
///光照
float beerLambert(float sampleDensity, float precipitation)
{
	return exp(-sampleDensity *precipitation);
}

float powder(float sampleDensity, float lightDotEye)
{

    return 2.0 * exp(-sampleDensity * lightDotEye) * (1.0 - exp(-2.0 * sampleDensity));

}

//HenyeyGreenstein
float HG(float lightDotEye,float g)
{
	float g2 = g * g;
	return ((1.0f - g2) / pow((1.0f + g2 - 2.0f * g * lightDotEye), 1.5f)) /(4.0f*PI);
	//return ((1.0f - g2) / pow((1.0f + g2 - 2.0f * g * lightDotEye), 1.5f)) * 0.25f;
}





//UMEA university way
//////////////////////////////////////////////////////////////////////////////////////
//The entire light functions were borrowed from 《Real-time rendering of volumetric clouds》By Fredrik Haggstrom
//And changed a little bit by yiyang ding 2022-12-08
//////////////////////////////////////////////////////////////////////////////////////

/*brif this is a function for SSS and the SilverAges on cloud by light。
intensity is the sun light‘s intensity，it just link to brightness ，not related with light range。
exponet used for the sun lights range，the larger the value，the smaller the range；
IOratio is a slider（Linear interpolation） between inScatter and outScatter
	inScatter：Determines the amount of light that is scattered trough the clouds.
	outScatter：Determines the amount of light that is scattered back the direction the light entered the clouds.
*/
float InOutScatter(float cos_angle,float intensity,float exponent,float IORatio)
{

	float cloud_inscatter=0.6;
	float cloud_outscatter = -0.8;

	float first_hg = HG(cos_angle, cloud_inscatter);
	float second_hg =intensity*pow( saturate(cos_angle),exponent);

	float in_scatter_hg = max(first_hg, second_hg);
	float out_scatter_hg = HG( cos_angle, cloud_outscatter);

	return lerp(in_scatter_hg,out_scatter_hg,IORatio);
}

//attuention_CampVal:Determines the how dark the clouds can be (clamps to a maximum attenuation).
float Attenuation( float density_to_sun,float cos_angle,float attuention_CampVal)
{


	float prim =exp(-density_to_sun*precipiFactor);
	float scnd = exp(-density_to_sun*0.25)*0.7f;
	float checkval = remap(cos_angle,0.0,1.0,scnd,scnd * 0.5);
	//return prim;
	return max(checkval,prim);//simulate the clouds reduce brightness when face to sun
}

float OutScatterAmbient(float density,float percent_height)
{
	float cloud_outscatter_ambient = 0.9;

	//float depth = 0.08+cloud_outscatter_ambient*pow(density,remap(percent_height,0.3,0.9,0.5,1.0));
	float depth = cloud_outscatter_ambient*pow(density,remap(percent_height,0.1,0.2,0.5,1.0));
	//float vertical = pow(saturate(remap(percent_height,0.2,0.3,0.8,1.0)),0.8);
	float vertical = pow(saturate(remap(percent_height,0.1,0.30,0.9,2.0)),0.8);


	float out_scatter = depth*vertical;
	//return out_scatter;
	out_scatter = 1.0 - saturate(out_scatter);

	return out_scatter;
}

////////////////////////////////////////////////////////////
////UMEA university way END
vec3 AmbientColor(float heightFrac)
{
	return lerpVec3(CloudBaseColor.rgb, CloudTopColor.rgb, heightFrac);
}

//Henyey-Greenstein相位函数
float HenyeyGreenstein(float angle, float g)
{
    float g2 = g * g;
    return(1.0 - g2) / (4.0 * PI * pow(1.0 + g2 - 2.0 * g * angle, 1.5));
}

//两层Henyey-Greenstein散射，使用Max混合。同时兼顾向前 向后散射
float HGScatterMax(float angle, float g_1, float intensity_1, float g_2, float intensity_2)
{
    return max(intensity_1 * HenyeyGreenstein(angle, g_1), intensity_2 * HenyeyGreenstein(angle, g_2));
}

float MiePhaseFunction(float g, float nu) {
    float gg = g * g;
    float k = 0.1193662 * (1.0 - gg) / (2.0 + gg);
    return k * (1.0 + nu * nu) * pow(1.0 + gg - 2.0 * g * nu, -1.5);
}


float CalculateMultipleScatteringCloudPhases(float VoL,float wetness){
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


// beer+powder+HG
vec4 getLightEnergy(float lightDotEye,float densityToSun,float cloudDensity,float precipitation,float percent_height,float stepSize,float lowLoddedDensity,float phase)
{


	//////////////////////////////
	//BEERLAW
	//////////////////////////////
	float primary_attenuation = exp( -densityToSun*precipiFactor);
	float secondary_attenuation = exp(-densityToSun * 0.25) * 0.7;
	//float attenuation_probability = max(primary_attenuation,secondary_attenuation);
	float attenuation_probability = max( remap( lightDotEye, 0.7, 1.0, secondary_attenuation, secondary_attenuation * 0.25) , primary_attenuation);

	//////////////////////////////
	//SCATTER
	//////////////////////////////
	//SIG2017
	//float depth_probability =  0.05 + pow(lowLoddedDensity, remap( percent_height,0,1, 1, 2.0));
	// depth_probability =  0.05 + pow(lowLoddedDensity, remap(percent_height,0,1,1,0));//MY WAY
	//float vertical_probability = pow( saturate(remap( percent_height, 0.08, 0.25, 0, 1.0 )),1 );
	//float vertical_probability = pow( saturate(remap( percent_height, verticalProbParam.x, verticalProbParam.y, 0, 1.0 )),verticalProbParam.z );
	
    float depth_probability = lerp( 0.05 + pow( lowLoddedDensity, remap( percent_height, 0.3, 0.85, 0.5, 2.0 )), 1.0, saturate( densityToSun / stepSize));
    float vertical_probability = pow( remap( percent_height, 0.07, 0.14, 0.1, 1.0 ), 0.8 );	
	float in_scatter_probability =depth_probability*vertical_probability;



	//////////////////////////////
	//highLight
	/////////////////5////////////	
	//Can be calculated once for each march but gave no/tiny perf improvements.
	float eccentricity =      0.6;
	float silver_intensity = 12;
	float silver_spread =     0.4;
	float Energy = max(HG(lightDotEye, eccentricity), silver_intensity* HG(lightDotEye, 0.99-silver_spread));
	//return Energy;
	float sun_highlight = InOutScatter(lightDotEye,5.5f,10f,0.5f);
	
	
	//////////////////////////////
	//AMBIENT
	//////////////////////////////
	float attenuation = Energy*attenuation_probability*sunEnergy*in_scatter_probability;

	float cloud_ambient_minimum =0;
	//attenuation = max(cloudDensity*cloud_ambient_minimum*(pow(saturate(densityToSun/4000),2)),attenuation);
	///////////////////////////
	//return
	///////////////////////////
	//return in_scatter_probability;


	float sunlighting = 1.0f;
	float skylighting =1.0f;
	vec3 colorShadowlight = CloudBaseColor.rgb;
	vec3 colorSkylight = CloudTopColor.rgb;//should be vec3 for skyLight's color;

	float sunlightEnergy = 1.0 / (densityToSun * 5 );
	float powderFactor = exp2(-lowLoddedDensity * 12.0 /sunlighting);// cp.sunlighting CLEAR=1 RAIN=0.6
	sunlightEnergy *= MiePhaseFunction(powderFactor*0.3 , lightDotEye * 0.5 + 0.5);
	vec3 sunlightColor = colorShadowlight * (sunlightEnergy * sunlighting * 90.0);

	vec3 cloudColor = sunlightColor  ;


	float skylightEnergy = 0.15 / (densityToSun * 1.0 + 1.0);
	vec3 skylightColor = colorSkylight * skylightEnergy * skylighting;

	cloudColor+=skylightColor;




	vec3 tempvec3 = vec3(in_scatter_probability*attenuation_probability*Energy*sunEnergy);
	//vec3 tempvec3 = vec3(in_scatter_probability);
	return vec4(tempvec3,1);

	//return vec4(sunlightColor,1);
	return vec4(cloudColor,1);

}







// TODO get from cb values - has to change as time of day changes
vec3 ambientLight(float heightFrac)
{
//	vec3 tempVec3 = vec3Zero;
//	tempVec3.x=lerp(0.5f,1.0f,heightFrac);
//	tempVec3.y=lerp(0.67f,1.0f,heightFrac);
//	tempVec3.z=lerp(0.82f,1.0f,heightFrac);
//	return tempVec3;
	return lerpVec3(vec3(0.5f, 0.67f, 0.82f),vec3(1.0f, 1.0f, 1.0f),heightFrac);
}



//
vec4 sampleClouddensityToSun(
	vec3 startPos,
	float  stepSize,
	float  lightDotEye,
	float  cloudDensity,
	float lowLoddedDensity,
	float phase)
{
//DEBUG
//	vec3 lightStep = stepSize * lightDir;
	vec3 lightStep = stepSize * -lightDir;//default
	vec3 pos = startPos;
	float coneRadius = 1.0f;
	float coneStep = RCP_LIGHT_RAY_ITERATIONS;
	float densityToSun = 0.0f;
	vec3 weatherData = vec3Zero;
	float rcpThickness = 1.0f / (stepSize * LIGHT_RAY_ITERATIONS);
	float density = 0.0f;
	
	for(uint i = 0u; i < LIGHT_RAY_ITERATIONS; ++i)
	{
		vec3 conePos = pos + coneRadius * RANDOM_VECTORS[i] * float(i + 1u);
		float heightFrac = GetHeightFractionForPoint(conePos);
		if(heightFrac <= 1.0f)//在云层顶部之下
		{
			weatherData = sampleWeather(conePos);
			float cloudDensity = sampleCloudDensity(
				conePos,
				weatherData,
				heightFrac,
				true);
			if(cloudDensity > 0.0f)
			{
				density += cloudDensity;
				float transmittance = 1.0f - (density * rcpThickness);
				densityToSun += (cloudDensity * transmittance);
			}
		}
		//pos += lightStep;
		//default
		pos += -lightStep;
		coneRadius += coneStep;

	}

		return (getLightEnergy(lightDotEye,densityToSun,cloudDensity, 
		lerp(1.0f, 2.0f, getPrecipitation(weatherData)),
		GetHeightFractionForPoint(startPos),stepSize,
		lowLoddedDensity,phase ));
}

/////////////////////////////////////////////////////////////////////
////core trace CODE
/////////////////////////////////////////////////////////////////////
vec4 traceClouds(
	vec3 viewDirW,		
	vec3 startPos,		
	vec3 endPos,
	float phase,
	vec4 blueNoise)			// world space end position
{
	vec3 dir = endPos - startPos;//从起点到终点的向量

	float thickness = length(dir);//厚度，从起点到终点的长度
	float rcpThickness = 1.0f / thickness;

	//between 64,128
	float sampleCount = lerp(SAMPLE_RANGE_X, SAMPLE_RANGE_Y, saturate(((thickness - cloudVolumeHeight) / cloudVolumeHeight)));//采样的次数
	float stepSize = thickness / float(sampleCount);//thickness/采样的次数 = the distance per step

	dir /= thickness;//normalize向量归一化

	vec3 posStep = stepSize * dir;

	float lightDotEye = dot(lightDir, viewDirW);
	//float lightDotEye = -dot(lightDir, viewDirW); default

	vec3 pos = startPos	;
	vec3 weatherData = vec3Zero;
	vec4 result = vec4Zero ;
	float density = 0.0f;
	vec4 lightDensity = vec4Zero;
	float transmittance;



	vec3 accumLightDensity;
	vec3 ambientBadApprox;
	//for(uint i = 0u; i < sampleCount; ++i)
	//for(uint i = 0u; i < floor(sampleCount); ++i)
	for(uint i = 0u; i <sampleCount; ++i)
	{
	//first,get cloud's density from sampleCloudDensity funciton,clouds's density mean the thickness of the cloud
		float heightFrac = GetHeightFractionForPoint(pos);
		weatherData = sampleWeather(pos);
		float cloudDensity = sampleCloudDensity(
			pos,
			weatherData,
			heightFrac,
			false);

	//second,if the cloudDensity>0,calculate the density from
		if(cloudDensity > 0.0f)
		{
			density += cloudDensity;
			 transmittance = 1.0f - (density * rcpThickness);
			float lowLoddedDensity=sampleCloudDensity(pos,weatherData,heightFrac,true);
			lightDensity = sampleClouddensityToSun(
				pos,
				stepSize,
				lightDotEye,
				cloudDensity,
				lowLoddedDensity,
				phase);
			 vec3 ambientLight = ambientLight(heightFrac);

			 vec4 source = vec4((sunColor.rgb * lightDensity.rgb +ambientLight*anbientIntensity*AmbientColor(heightFrac))/*+ ambientLight(heightFrac)*/, cloudDensity * transmittance); 
			// vec4 source = vec4((sunColor.rgb * lightDensity.rgb +ambientLight*anbientIntensity*AmbientColor(heightFrac))/*+ ambientLight(heightFrac)*/, cloudDensity * transmittance); 

			source.rgb *= source.a;
			result = (1.0f - result.a) * source + result;
			if(result.a >= 1.0f) break;
		}
		
		pos += posStep;
		//pos += posStep;												;
		//pos += posStep+(blueNoise.xyz-0.5)*2;
	}

	float fadRange = 0.5f;
	float fadIntensity = 1.5e-5;
	float wetness = 0;
	float fading = exp(-max( length(pos)*fadRange + (4e3 * wetness - 6e3), 0.0 ) * fadIntensity)*1.5;

	//float cloudTransmittanceFaded = mix(1.0, transmittance, fading);
	//result*=fading;

	//return result;

	// experimental fog - may nColor heightFracclouds are drawn before atmosphere - would have to draw sun by itself, then clouds, then atmosphere
	// fogAmt = 0 to disable
	float fogAmt = 1.0f - exp(-distance(startPos, camPos) * 0.00001f);
	//fogAmt = 0 ;//to disable
	vec3 fogColor = vec3(0.4f, 0.54f, 0.6f) * length(sunColor.rgb * 0.825f) * 1f;
	vec3 sunColor = normalize(sunColor.rgb) * 4.0f * length(sunColor.rgb * 0.125f);

	fogColor = lerpVec3(fogColor, sunColor,  pow(clamp(lightDotEye,0.0f,1.0f),8.0f));//混了太阳光的
		


	 vec4 cloudCol = vec4(clamp(lerpVec3(result.xyz,fogColor,fogAmt), 0.0f, 1.0f), saturate(result.a));


		// Background.
	vec4 skyColor = vec4(0.5, 0.7, 1.0, 1.0);
	vec4 backgroundColor = skyColor + max(0.0, pow(dot(viewDirW, lightDir),512.0));

	return vec4(cloudCol.rgb+(1-cloudCol.a)*backgroundColor.rgb,cloudCol.a);

}


    ////////////////////////////////////////////////////////////////////



void main() 
{

	float zwDepth = texture(depthTexture,gl_FragCoord.xy).r;

	
	//float zwDepth =texture(depthTexture, posW.xy).r;//读取和屏幕尺寸一样大的深度贴图，得到着色点的深度值
	//bool depthPresent = zwDepth < 1.0f;//深度小于1，就是着色点不贴在相机的远平面上。
	bool depthPresent = zwDepth < 1.0f;//这里的深度应该用没有被线性处理过的深度
	float depth =LinearizeDepth(zwDepth);
	// Get clip space position
	vec2 uv = 2.0 * gl_FragCoord.xy / resolution - 1.0;
	vec4 clipPos = vec4(uv.xy, 1.0, 1.0); // z=1.0 ist the near plane
	vec3 viewDirW = normalize((inverse(view) * vec4((inverse(projection) * clipPos).xyz, 0.0)).xyz);

	float _ScatterForward = 0.479;
	float _ScatterForwardIntensity = 0.296;
	float _ScatterBackward = 0.4;
	float _ScatterBackwardIntensity = 0.4;

	float _ScatterBase = 0.224;
	float _ScatterMultiply = 0.7;
	//向前/向后散射
//	float phase = HGScatterMax(dot(viewDirW, lightDir), _ScatterForward, _ScatterForwardIntensity, _ScatterBackward, _ScatterBackwardIntensity);
//	phase = _ScatterBase + phase * _ScatterMultiply;
	float	phase = CalculateMultipleScatteringCloudPhases(dot(viewDirW, lightDir),0);
			vec2 screenUV = gl_FragCoord.xy/resolution;
		vec4 blueNoise =  texture(blueNoise, screenUV );

	//FragColor =vec4(depth);return;
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
	//if (outerShellHits==1u) FragColor = vec4(0,1,0,1);return;
	// world space ray intersections
	vec3 planetHitSpot = camPos + (viewDirW * plantHit.x);//
	vec3 innerShellHit = camPos + (viewDirW * inHit.x);//云层内侧交点
	vec3 outerShellHit = camPos + (viewDirW * outHit.x);//云层外侧交点
	// FragColor = vec4(innerShellHit,1);return;
	//if(innerShellHit==vec3(1,1,1)) FragColor = vec4(0,1,0,1);return;
	float distFromSP2EyePos = distance(posW, camPos);//从着色点到相机世界坐标的距离
	float distFromInnerShellHit2EyePos = distance(innerShellHit, camPos);//从云层底部交点到相机世界坐标的距离
	// eye radius from planet center
	float eyeRadius = distance(camPos, PLANET_CENTER);//从地球中心到相机的距离

	if(shoWeatherMap)
	{
	vec2 unit = innerShellHit.xz * weatherTexMod.x / 30000.0;
	vec2 uv1 = unit * 0.5 + 0.5+(WEATHER_TEX_MOVE_SPEED * time);
	if(weatherMapChannel==0){FragColor  = vec4(texture(weatherLookup, uv1).r);return;}
	if(weatherMapChannel==1){FragColor  = vec4(texture(weatherLookup, uv1).g);return;}
	if(weatherMapChannel==2){FragColor  = vec4(texture(weatherLookup, uv1).b);return;}
	}



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
			outerShellHit,
			phase,
			blueNoise);//从云层底部开始，到云层顶部结束
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
			secondShellHit,
			phase,
			blueNoise);//从outerShellHit云层顶部第一个交点，到云层底部或者
			return;
	}

	//////////////////////  <-------云层顶部
	//相机在这（云层中）
	//////////////////////  <-------云层底部
	else // between shells 在云层中间
	{

		//
		 //From a practical viewpoint (properly scaled planet, atmosphere, etc.)
		 //only one shell will be hit.
		 // Start position is always eye position.
		 //
		vec3 shellHit = innerShellHits > 0u ? innerShellHit : outerShellHit;
		// if there's something in the depth buffer that's closer, that's the end point
		if(depthPresent && (distance(posW, camPos) < distance(shellHit, camPos)))
		{
			shellHit = posW;
		}
		FragColor = traceClouds(
			viewDirW,
			camPos,//从相机到云层顶部或者底部结束。
			shellHit,
			phase,
			blueNoise);
			return;
	}

}