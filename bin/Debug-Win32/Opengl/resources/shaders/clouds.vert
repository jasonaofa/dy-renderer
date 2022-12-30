#version 330 core
layout (location = 0) in vec3 aPos;
//layout (location = 0) in vec2 aPos;// 原
out vec3 posW;
out float viewDepth;
uniform mat4 p;
uniform mat4 m;
uniform mat4 v;
void main()
{
   // WorldPos = vec3(m * vec4(aPos, 1.0));
 
    //gl_Position =  p * v * vec4(aPos, 1.0);


    //原来的↓
	//vec4 pos = p*v*m*vec4(aPos, 0.0, 1.0);
		//gl_Position = pos.xyww;
	posW = vec3(m * vec4(aPos, 1.0));
	viewDepth = (v*vec4(aPos,1)).z;
	gl_Position = vec4(aPos, 1.0);
}