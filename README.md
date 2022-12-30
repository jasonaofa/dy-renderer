# DyEngine
- 一个基于Opengl的前向管线的PBR渲染器，不是专业程序员，非常业余的学习成果。
- This is a PBR renderer based on the OPENGL forward rendering pipeline，I'm not a professional programmer,
This is just a very unprofessional record of learning outcomes
## 实现的功能有：
- 基于金属度/粗糙度的PBR-shader
- IBL
- PCF阴影
- HDR
- Bloom
- 基于Assimp的模型和材质加载
- 和其他Opengl的基础功能
- 延迟渲染的内容在另外一个项目里，之后会上传
## Features：
- Pbr-Shader based on Metalness/Roughness
- IBL
- PCF Shadow
- HDR
- Bloom(based on gaussian Blur with ping pong buffer)
- Other basic functions of Opengl
- deffered rendering pipline is on another Repositories,Upload later.
## Dependancies needed:
- IMGUI
- ASSIMP
- STBI
- GLM
- GLFW
## 效果展示：
- ![image](https://user-images.githubusercontent.com/31367799/183667524-b8ad43be-130d-42ad-a844-bd02f8ce8e4e.png)
- ![image](https://user-images.githubusercontent.com/31367799/183667591-2bce0eeb-cbd9-4fa9-90a7-5df324ee875f.png)
- [![PBRDEMO](https://res.cloudinary.com/marcomontalbano/image/upload/v1660053361/video_to_markdown/images/youtube--AO9hx4ac0p0-c05b58ac6eb4c4700831b2b3070cd403.jpg)](https://youtu.be/AO9hx4ac0p0 "PBRDEMO")
# HOW TO USE
### About Demo
- row,colimns,spacing set：
~~~C++
	int nrRows = 5;
	int nrColumns = 5;
	float spacing = 2.5;
~~~
- Draw:
~~~c++
		// render rows*column number of spheres with varying metallic/roughness values scaled by rows and columns respectively
		glm::mat4 model = glm::mat4(1.0f);
		unsigned int counts = 0;
		for (int row = 0; row < nrRows; ++row)
		{
			for (int col = 0; col < nrColumns; ++col)
			{
				model = glm::mat4(1.0f);
				model = glm::translate(model, glm::vec3(
					(float)(col - (nrColumns / 2)) * spacing,
					(float)(row - (nrRows / 2)) * spacing,
					-2.0f
				));
				standardShader->PassMat4ToShader("model", model);
				sphereArray[counts].Draw(standardShader);
				counts++;
			}
		}
~~~
### PBR 
- HDRmap to iblMap functions in Core.h
~~~C++
	static void getIndirectDiffuseMaps(GLuint* cubemapFromHDR, GLuint* irradianceMap, Shader* equalRectTOCubeShader, Shader* irradianceMapShader);
	static void getIndirectSpecularMaps(GLuint* prefilterMap, GLuint* brdfLUTTexture, GLuint* cubemapFromHDR, Shader* preFilterShader, Shader* genBrdfLutShader);
~~~
- HDRmapPath in core.h
~~~C++
	static inline char const* HDRPath = "resources/textures/hdr/Arches_E_PineTree_3k.hdr";
~~~
