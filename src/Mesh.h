#pragma once
#include "glad/glad.h"
#include <glm.hpp>
#include <string>
#include <vector>


#include <assimp/material.h>

#include <iostream>


class Shader;

struct Vertex
{
	glm::vec3 Position;
	glm::vec3 Normal;
	glm::vec2 TexCoords;
};

struct Texture
{
	unsigned int id;
	std::string type;
	//纹理在硬盘上的路径
	std::string path;
};

class Mesh
{
public:


	//Mesh(float vertices[]);
	static void drawCube();
	static void drawQuad();
	Mesh(std::vector<Vertex> vertices, std::vector<unsigned int> indices, std::vector<Texture> textures);
	void Draw(Shader* shader);
private:
	std::vector<Vertex> vertices;
	std::vector<unsigned int> indices;
	std::vector<Texture> textures;
	unsigned int VAO, VBO, EBO;
	void setupMesh();

	//std::vector<Texture> loadMaterialTextures(aiMaterial* mat, aiTextureType type, std::string typeName);

};
