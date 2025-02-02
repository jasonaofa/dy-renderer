#pragma once
#include "glad/glad.h"
#include <glm.hpp>
#include "Shader.h"

class Material
{
public:


	//Material(Shader* _shader = NULL , glm::vec3 _ambient = glm::vec3(0,0,0), unsigned int _diffuse = NULL, unsigned int _specular = NULL, unsigned int _emission = NULL, unsigned int _reflection = NULL, float _shininess = NULL);
	Material(Shader* _shader = NULL , unsigned int _albedo = NULL, unsigned int _metallic = NULL, unsigned int _normal = NULL, unsigned int _roughness = NULL, unsigned int _ao = NULL);

	unsigned int LoadImageToGPU(const char* imageName);
private:
	//属性
	Shader* shader;
	glm::vec3 ambient;
	unsigned int diffuse, specular, emission, reflection;
	//PRR texture
	unsigned int albedo, metallic, normal, roughness, ao;
	float shininess;
	float intensity;

};

