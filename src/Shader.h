#pragma once
#include "glad/glad.h"
#include <string>
#include <detail/type_vec.hpp>
#include <iostream>
#include  <GLFW/glfw3.h>
#include "fstream"
#include "sstream"
#include <glm.hpp>
#include <map>
#include <mutex>
#include <thread>
#include <vector>
#include <gtc/type_ptr.hpp>

class Shader
{
public:
	Shader(const char* vertexPath = nullptr, const char* fragmentPath = nullptr, const char* geometryPath = nullptr);




	enum slotNum
	{
		DIFFUSE,
		SPECULAR,
		EMISSION,
		Reflection
	};

	void use();
	int const GetID() { return ID; }
	void PassUniformToShader(const char* paramNameString, glm::vec4 param);
	void PassUniformToShader(const char* paramNameString, glm::vec3 param);
	void PassUniformToShader(const char* paramNameString, glm::vec2 param);
	void PassUniformToShader(const char* paramNameString, float param);
	void PassUniformToShader(const char* paramNameString, int slot);
	void PassUniformToShader(const char* paramNameString, unsigned int slot);
	void PassUniformToShader(const char* paramNameString, glm::mat4 matName);
	void loadShaderFiles();
	void createNewID(){ID = glCreateProgram();
	}


private:
	std::string vertexString;
	std::string fragmentString;
	std::string geometryString;
	const char* vertexSource;
	const char* fragmentSource;
	const char* geometrySource;

	const char* m_vertexPath;
	const char* m_fragmentPath;
	const char* m_geometryPath;

	unsigned int ID;//shader program ID
	void checkShaderCompileError(unsigned int ID, std::string type);
};

