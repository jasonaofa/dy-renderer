#include "Clouds.h"
#include <stb_image.h>

float Clouds::cloudsCubeVertices[] = {
-1.0f, -1.0f, -1.0f,
1.0f, -1.0f, -1.0f,
1.0f, 1.0f, -1.0f,
1.0f, 1.0f, -1.0f,
-1.0f, 1.0f, -1.0f,
-1.0f, -1.0f, -1.0f,

-1.0f, -1.0f, 1.0f,
1.0f, -1.0f, 1.0f,
1.0f, 1.0f, 1.0f,
1.0f, 1.0f, 1.0f,
-1.0f, 1.0f, 1.0f,
-1.0f, -1.0f, 1.0f,

-1.0f, 1.0f, 1.0f,
-1.0f, 1.0f, -1.0f,
-1.0f, -1.0f, -1.0f,
-1.0f, -1.0f, -1.0f,
-1.0f, -1.0f, 1.0f,
-1.0f, 1.0f, 1.0f,

1.0f, 1.0f, 1.0f,
1.0f, 1.0f, -1.0f,
1.0f, -1.0f, -1.0f,
1.0f, -1.0f, -1.0f,
1.0f, -1.0f, 1.0f,
1.0f, 1.0f, 1.0f,

-1.0f, -1.0f, -1.0f,
1.0f, -1.0f, -1.0f,
1.0f, -1.0f, 1.0f,
1.0f, -1.0f, 1.0f,
-1.0f, -1.0f, 1.0f,
-1.0f, -1.0f, -1.0f,

-1.0f, 1.0f, -1.0f,
1.0f, 1.0f, -1.0f,
1.0f, 1.0f, 1.0f,
1.0f, 1.0f, 1.0f,
-1.0f, 1.0f, 1.0f,
-1.0f, 1.0f, -1.0f
};


void Clouds::cloudsInit()
{


	GLuint VBO;
	glGenBuffers(1, &VBO);
	glGenVertexArrays(1, &getCloudVAO());
	glBindVertexArray(getCloudVAO());
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(cloudsCubeVertices), cloudsCubeVertices, GL_STATIC_DRAW);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(0);

	// Texture loading.
	glEnable(GL_TEXTURE_3D);
	int texWidth, texHeight, texChannels;
	unsigned char* texData;
	stbi_set_flip_vertically_on_load(true);

	// Base Worley noise (128x128x128).
	//texData = stbi_load("resources/textures/Clouds/base_noise.tga", &texWidth, &texHeight, &texChannels, 0);
	texData = stbi_load("resources/textures/Clouds/lowFrequency.tga", &texWidth, &texHeight, &texChannels, 0);

	unsigned int baseNoiseTex;
	glGenTextures(1, &baseNoiseTex);
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_3D, baseNoiseTex);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_WRAP_R, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage3D(GL_TEXTURE_3D, 0, GL_RGBA, texHeight, texHeight, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, texData);

	// Detail Worley noise (32x32x32)
	//texData = stbi_load("resources/textures/Clouds/noiseShape.tga", &texWidth, &texHeight, &texChannels, 0);
	texData = stbi_load("resources/textures/Clouds/noiseErosion.tga", &texWidth, &texHeight, &texChannels, 0);

	unsigned int detailNoiseTex;
	glGenTextures(1, &detailNoiseTex);
	glActiveTexture(GL_TEXTURE1);
	glBindTexture(GL_TEXTURE_3D, detailNoiseTex);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_WRAP_R, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage3D(GL_TEXTURE_3D, 0, GL_RGBA, texHeight, texHeight, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, texData);

	// weather 
	unsigned char* weatherData = stbi_load("resources/textures/Clouds/weather_8.png", &texWidth, &texHeight,
		&texChannels, 0);

	glGenTextures(1, &m_weatherTex);

	glBindTexture(GL_TEXTURE_2D, m_weatherTex);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 256, 256, 0, GL_RGB, GL_UNSIGNED_BYTE, weatherData);
	glBindTexture(GL_TEXTURE_2D, 0);


	// curlNoise 
	unsigned char* curlNoiseData = stbi_load("resources/textures/Clouds/curlNoise.png", &texWidth, &texHeight,
		&texChannels, 0);

	glGenTextures(1, &m_curlNoiseTex);
	glActiveTexture(GL_TEXTURE4);
	glBindTexture(GL_TEXTURE_2D, m_curlNoiseTex);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 128, 128, 0, GL_RGB, GL_UNSIGNED_BYTE, curlNoiseData);
	glBindTexture(GL_TEXTURE_2D, 0);

	// blueNoise 
	unsigned char* blueNoise = stbi_load("resources/textures/Clouds/BlueNoise512.png", &texWidth, &texHeight,
		&texChannels, 0);

	glGenTextures(1, &m_blueNoiseTex);
	glBindTexture(GL_TEXTURE_2D, m_blueNoiseTex);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 512, 512, 0, GL_RGB, GL_UNSIGNED_BYTE, blueNoise);
	glBindTexture(GL_TEXTURE_2D, 0);
}
