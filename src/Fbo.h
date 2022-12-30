#pragma once

#include <cstddef>
#include "Mesh.h"
#include "Shader.h"
#include <gtc/matrix_transform.hpp>


#define shadowMapWidth 1024.0f
#define shadowMapHeight 1024.0f
#define ASSERT(x) if(!(x)) __debugbreak();

#define BIT(x) (1 << x)
#define CORE_BIND_EVENT_FN(fn) std::bind(&fn, this, std::placeholders::_1)

#define CORE_ASSERT(x, ...) { if(!(x)) { LOG_ERROR("Assertion Failed: {0}", __VA_ARGS__); __debugbreak(); } }
class Fbo
{
public:

	//static Shader* equalRectTOCubeShader;
	//static Shader* irradianceMapShader;
	//static Shader* preFilterShader;
	//static Shader* genBrdfLutShader;

	static void GetColTexFbo(GLuint& FBO, GLuint& texture, GLsizei width, GLsizei height);
	//functions
	static void getShdowFboMap(GLuint &shadowMapFBO, GLuint &shadowMap, GLsizei SMWidth, GLsizei SMHeight);
	static GLuint getQuadVAO();
	static void getIndirectDiffuseMaps(GLuint* cubemapFromHDR, GLuint* irradianceMap, Shader* equalRectTOCubeShader, Shader* irradianceMapShader);
	static void getIndirectSpecularMaps(GLuint* prefilterMap, GLuint* brdfLUTTexture, GLuint* cubemapFromHDR, Shader* preFilterShader, Shader* genBrdfLutShader);
	static float GetScreenWidth() { return m_screenWidth; }
	static float GetScreenHeight() { return m_screenHeight; }
	static void SetScreenWidth(float newScreenWidth) { m_screenWidth = newScreenWidth; }
	static void SetScreenHeight(float newScreenHeight) { m_screenHeight = newScreenHeight; }

private:
	
	static inline char const* HDRPath = "resources/textures/hdr/Arches_E_PineTree_3k.hdr";
	static  inline glm::mat4 captureProjection = glm::perspective(glm::radians(90.0f), 1.0f, 0.1f, 100.0f);
	static  inline glm::mat4 captureViews[] =
	{
		glm::lookAt(glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(1.0f, 0.0f, 0.0f), glm::vec3(0.0f, -1.0f, 0.0f)),
		glm::lookAt(glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(-1.0f, 0.0f, 0.0f), glm::vec3(0.0f, -1.0f, 0.0f)),
		glm::lookAt(glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, 1.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f)),
		glm::lookAt(glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, -1.0f, 0.0f), glm::vec3(0.0f, 0.0f, -1.0f)),
		glm::lookAt(glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f), glm::vec3(0.0f, -1.0f, 0.0f)),
		glm::lookAt(glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, 0.0f, -1.0f), glm::vec3(0.0f, -1.0f, 0.0f))
	};

	inline static float m_screenWidth = 1920.0f;
	inline static float m_screenHeight = 1080.0f;


};

