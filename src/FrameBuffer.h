#pragma once
#include "glad/glad.h"
#include <GLFW/glfw3.h>
#include <iostream>
#include "Shader.h"



class FrameBuffer
{
public:

	void setQuad();
	void setFbo(GLsizei width, GLsizei height);
	void draw(Shader* screenShader);
private:

	unsigned int quadVAO, quadVBO, fbo, rbo, texColorBuffer;
};

