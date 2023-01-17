#pragma once

class Languages
{
public:
	static void showChinese()
	{
		spfSize = u8"SPF的filter的尺寸";
		shadowMapBias = u8"SM的偏置值";

		globalSettings = u8"全局设置";
		enableShadow = u8"打开阴影";
		showShadowMap = u8"显示shadowMap";
		lightIntensity = u8"灯光强度";
		lightDirection = u8"太阳方向";
		cameraPos = u8"相机位置";

		showCloud = u8"打开云";
		showWeatherMap = u8"显示天气贴图";
		coverage = u8"覆盖率R通道";
		precipitation = u8"降雨概率G通道";
		cloudType = u8"云层类型B通道";
		reload = u8"重新载入贴图和shader";

		globalCloudsSettings = u8"云层全局设置";
		cloudVolumeStartHeight = u8"云层底部高度";
		cloudVolumeHeight = u8"云层厚度";
		groundRadius = u8"地球半径";
		windStrength = u8"风力";
		windDirection = u8"风向";
		turbStrength = u8"扰动强度";
		turbDirection = u8"扰动方向";
		weatherTexMod = u8"天气贴图模式";

		cloudShapeSettings = u8"云层形状设置";
		baseNoiseThreshold = u8"基础噪声阈值";
		baseNoiseMax = u8"基础噪声最大值";
		cloudCoverage = u8"云层覆盖率";
		detailScale = u8"细节贴图的缩放";
		cloudTopOffset = u8"顶部偏移";
		curlNoiseMultiple = u8"卷曲贴图的缩放";
		cloudSmoothness = u8"云层整体平滑度";

		cloudLightingSettings = u8"云层着色参数";
		precipiFactor = u8"降雨概率";
		sunEnergy = u8"太阳光强度";
		ambientIntensity = u8"环境光强度";
		verticalProbParam = u8"垂直概率参数";
		totalBrightnessFactor = u8"总体亮度";
		powderTopBrightness = u8"powder顶部亮度";
		sunColor = u8"太阳光颜色";
		cloudBaseColor = u8"云层基础颜色";
		cloudTopColor = u8"云层顶部颜色";

		weatherTexture = u8"天气贴图";
		curlNoiseTex = u8"卷曲贴图";

	}

	static void showEnglish()
	{
		spfSize = "Spf-Size";
		shadowMapBias = "shadowMapBias";

		globalSettings = "Global settings";
		enableShadow = "enableShadow";
		showShadowMap = "showShadowMap";
		lightIntensity = "lightIntensity";
		lightDirection = "lightDirection";
		cameraPos = "cameraPos";

		showCloud = "showCloud";
		showWeatherMap = "showWeatherMap";
		coverage = "coverage";
		precipitation = "precipitation";
		cloudType = "cloudType";
		reload = "reload Shader&Weather";

		globalCloudsSettings = "Global Clouds Settings";
		cloudVolumeStartHeight = "cloudVolumeStartHeight";
		cloudVolumeHeight = "cloudVolumeHeight";
		groundRadius = "groundRadius";
		windStrength = "windStrength";
		windDirection = "windDirection";
		turbStrength = "turbStrength";
		turbDirection = "turbDirection";
		weatherTexMod = "weatherTexMod";

		cloudShapeSettings = "cloudShapeSettings";
		baseNoiseThreshold = "baseNoiseThreshold";
		baseNoiseMax = "baseNoiseMax";
		cloudCoverage = "cloudCoverage";
		detailScale = "detailScale";
		cloudTopOffset = "cloudTopOffset";
		curlNoiseMultiple = "curlNoiseMultiple";
		cloudSmoothness = "cloudSmoothness";

		cloudLightingSettings = "Cloud Lighting Settings";
		precipiFactor = "precipiFactor";
		sunEnergy = "sunEnergy";
		ambientIntensity = "ambientIntensity";
		verticalProbParam = "verticalProbParam";
		totalBrightnessFactor = "totalBrightnessFactor";
		powderTopBrightness = "powderTopBrightness";
		sunColor = "sunColor";
		cloudBaseColor = "cloudBaseColor";
		cloudTopColor = "cloudTopColor";

		weatherTexture = "weatherTexture";
		curlNoiseTex = "curlNoiseTex";




	}

	static inline const char *spfSize;
	static inline const char *shadowMapBias;
	static inline const char *globalSettings;
	static inline const char *enableShadow;
	static inline const char *showShadowMap;
	static inline const char *lightIntensity;
	static inline const char *lightDirection;
	static inline const char *cameraPos;
	static inline const char *showCloud;
	static inline const char *showWeatherMap;
	static inline const char *coverage;
	static inline const char *precipitation;
	static inline const char *cloudType;
	static inline const char *reload;

	static inline const char *globalCloudsSettings;
	static inline const char *cloudVolumeStartHeight;
	static inline const char *cloudVolumeHeight;
	static inline const char *groundRadius;
	static inline const char *windStrength;
	static inline const char *windDirection;
	static inline const char *turbStrength;
	static inline const char *turbDirection;
	static inline const char *weatherTexMod;

	static inline const char *cloudShapeSettings;
	static inline const char *baseNoiseThreshold;
	static inline const char *baseNoiseMax;
	static inline const char *cloudCoverage;
	static inline const char *detailScale;
	static inline const char *cloudTopOffset;
	static inline const char *curlNoiseMultiple;
	static inline const char *cloudSmoothness;

	static inline const char *cloudLightingSettings;
	static inline const char *precipiFactor;
	static inline const char *sunEnergy;
	static inline const char *ambientIntensity;
	static inline const char *verticalProbParam;
	static inline const char *totalBrightnessFactor;
	static inline const char *powderTopBrightness;
	static inline const char *sunColor;
	static inline const char *cloudBaseColor;
	static inline const char *cloudTopColor;

	static inline const char *weatherTexture;
	static inline const char *curlNoiseTex;




	
};