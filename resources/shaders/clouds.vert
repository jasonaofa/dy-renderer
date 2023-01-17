#version 330 core
layout (location = 0) in vec3 aPos;
//layout (location = 0) in vec2 aPos;// 原

uniform mat4 m;
uniform mat4 projection;
uniform mat4 v;

out vec3 posW;
out float viewDepth;

out vec2 TexCoord;

void main()
{
	TexCoord = (aPos.xy + 1.0) * 0.5;
   // WorldPos = vec3(m * vec4(aPos, 1.0));
 
    //gl_Position =  p * v * vec4(aPos, 1.0);


    //原来的↓
	//vec4 pos = p*v*m*vec4(aPos, 0.0, 1.0);
		//gl_Position = pos.xyww;

	 vec4 pos=projection*v*vec4(aPos, 1.0);
	gl_Position = vec4(aPos, 1.0);
	posW =  vec3(m * vec4(aPos, 1.0));
}