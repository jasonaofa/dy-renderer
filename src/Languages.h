#pragma once

class Languages
{
public:
	static void showChinese()
	{
		spfSize = u8"SPF��filter�ĳߴ�";
		shadowMapBias = u8"SM��ƫ��ֵ";

		globalSettings = u8"ȫ������";
		enableShadow = u8"����Ӱ";
		showShadowMap = u8"��ʾshadowMap";
		lightIntensity = u8"�ƹ�ǿ��";
		lightDirection = u8"̫������";
		cameraPos = u8"���λ��";

		showCloud = u8"����";
		showWeatherMap = u8"��ʾ������ͼ";
		coverage = u8"������Rͨ��";
		precipitation = u8"�������Gͨ��";
		cloudType = u8"�Ʋ�����Bͨ��";
		reload = u8"����������ͼ��shader";

		globalCloudsSettings = u8"�Ʋ�ȫ������";
		cloudVolumeStartHeight = u8"�Ʋ�ײ��߶�";
		cloudVolumeHeight = u8"�Ʋ���";
		groundRadius = u8"����뾶";
		windStrength = u8"����";
		windDirection = u8"����";
		turbStrength = u8"�Ŷ�ǿ��";
		turbDirection = u8"�Ŷ�����";
		weatherTexMod = u8"������ͼģʽ";

		cloudShapeSettings = u8"�Ʋ���״����";
		baseNoiseThreshold = u8"����������ֵ";
		baseNoiseMax = u8"�����������ֵ";
		cloudCoverage = u8"�Ʋ㸲����";
		detailScale = u8"ϸ����ͼ������";
		cloudTopOffset = u8"����ƫ��";
		curlNoiseMultiple = u8"������ͼ������";
		cloudSmoothness = u8"�Ʋ�����ƽ����";

		cloudLightingSettings = u8"�Ʋ���ɫ����";
		precipiFactor = u8"�������";
		sunEnergy = u8"̫����ǿ��";
		ambientIntensity = u8"������ǿ��";
		verticalProbParam = u8"��ֱ���ʲ���";
		totalBrightnessFactor = u8"��������";
		powderTopBrightness = u8"powder��������";
		sunColor = u8"̫������ɫ";
		cloudBaseColor = u8"�Ʋ������ɫ";
		cloudTopColor = u8"�Ʋ㶥����ɫ";

		weatherTexture = u8"������ͼ";
		curlNoiseTex = u8"������ͼ";

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