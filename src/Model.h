#pragma once
#include  <iostream>
#include  "Mesh.h"
#include  "assimp/Importer.hpp"
#include  "assimp/scene.h"
#include  "assimp/postprocess.h"
class Model
{
public:
	//储存所有的纹理，并且确保纹理只被加载一遍
	Model(std::string path);
	//里面都是Mesh类的vector（vector是mesh模板类，类似列表）


	void Draw(Shader* shader);


private:
	void loadModel(std::string path);
	//这里用指针，如果传真正的部件，会有拷贝的问题，而且也会占一个内存
	void processNode(aiNode* node, const aiScene* scene);
	//建立一个我们自己定义的Mesh类的
	Mesh processMesh(aiMesh* mesh, const aiScene* scene);

	glm::vec3 angles = glm::vec3(0, 0, 0);
	glm::vec3 scale = glm::vec3(1.0f, 1.0f, 1.0f);
	glm::vec3 translate = glm::vec3(0, 0, 0);
	std::vector<Mesh> meshes;
	std::string directory;
	std::vector<Texture> textures_loaded;	// stores all the textures loaded so far, optimization to make sure textures aren't loaded more than once.

	unsigned int TextureFromFile(const char* path, const std::string& directory, bool gamma = false);
	std::vector<Texture> loadMaterialTextures(aiMaterial* mat, aiTextureType type, std::string typeName);

};

