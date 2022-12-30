#pragma once
#include "glad/glad.h"
#include "Shader.h"
#include <cstddef>
#include "Mesh.h"
#include "Shader.h"
#include <gtc/matrix_transform.hpp>


class Clouds
{
public:
	void static cloudsInit();

	static GLuint& getCloudVAO() { return m_cloudVAO; }
	static GLuint& getWeatherTex() { return m_weatherTex; }
	static GLuint& getCurlNoiseTex() { return m_curlNoiseTex; }
	static GLuint& getBlueNoiseTex() { return m_blueNoiseTex; }

private:
	inline static GLuint m_cloudVAO = 0u;
	inline static GLuint m_weatherTex = 0u;
	inline static GLuint m_curlNoiseTex = 0u;
	inline static GLuint m_blueNoiseTex = 0u;
	static float cloudsCubeVertices[];
};
