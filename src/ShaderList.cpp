#include "ShaderList.h"

void ShaderList::initAllShader()
{
	s_standard = new Shader("resources/shaders/standardVS.glsl", "resources/shaders/standardFRAG.glsl");
	s_equalRectTOCube = new Shader("resources/shaders/equalRectVS.glsl",
		"resources/shaders/equalRectFRAG.glsl");
	s_irradianceMap = new Shader("resources/shaders/equalRectVS.glsl",
		"resources/shaders/irradianceMapFRAG.glsl");
	s_preFilter = new Shader("resources/shaders/equalRectVS.glsl", "resources/shaders/preFilterFRAG.glsl");
	s_genBrdfLut = new Shader("resources/shaders/genBrdfLutVS.glsl",
		"resources/shaders/genBrdfLutFRAG.glsl");

	s_sceneShader = new Shader("resources/shaders/vertexShader.glsl", "resources/shaders/fragmentShader.glsl");

	s_skyBoxShader = new Shader("resources/shaders/skyBoxVertexShader.glsl",
		"resources/shaders/skyBoxFragmentShader.glsl");
	s_simpleDepth = new Shader("resources/shaders/simpleDepthShaderVS.glsl",
		"resources/shaders/simpleDepthFRAG.glsl");
	s_debugDepth = new Shader("resources/shaders/debugDepthVS.glsl", "resources/shaders/debugDepthFRAG.glsl");

	s_skyBoxHDR = new Shader("resources/shaders/skyBoxHDRVS.glsl", "resources/shaders/skyBoxHDRFRAG.glsl");
	s_DEBUGSKYBOX = new Shader("resources/shaders/DEBUGshowSkyboxVS.glsl",
		"resources/shaders/DEBUGshowSkyboxFRAG.glsl");

	s_cloud = new Shader("resources/shaders/clouds.vert", "resources/shaders/clouds.frag");
}
