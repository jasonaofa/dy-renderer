#pragma once
#include "glad/glad.h"
#include <string>
#include <vector>

#include <iostream>
#include <detail/type_mat.hpp>
#include "Camera.h"
#include "Shader.h"
#include "stb_image.h"


class Camera;
class Shader;

class SkyBox
{
public:



	void set(Shader* skyboxShader, Shader* modelShader); 

	void draw(Shader* shader,Camera camera, glm::mat4 projection,unsigned int cubmapTexture);

	unsigned int loadCubmap(const std::vector<std::string>& faces);

private:
	unsigned int VAO, VBO;
	int width, height, nrChannels;
	Shader* shader;

	
};

