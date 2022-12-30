#pragma once
#include "Shader.h"

class ShaderList
{
public:
	ShaderList()=default;
	void initAllShader();

public:
	Shader* s_standard;
	Shader* s_equalRectTOCube;
	Shader* s_irradianceMap;
	Shader* s_preFilter;
	Shader* s_genBrdfLut;
	Shader* s_sceneShader;
	Shader* s_skyBoxShader;
	Shader* s_simpleDepth;
	Shader* s_debugDepth;
	Shader* s_skyBoxHDR;
	Shader* s_DEBUGSKYBOX;

	Shader* s_cloud;
};
