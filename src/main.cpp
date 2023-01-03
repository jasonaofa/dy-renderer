//
//                      _oo0oo_
//                     o8888888o
//                     88" . "88
//                     (| -_- |)
//                     0\  =  /0
//                   ___/`---'\___
//                 .' \\|     |# '.
//                / \\|||  :  |||# \
//               / _||||| -:- |||||- \
//              |   | \\\  -  #/ |   |
//              | \_|  ''\---/''  |_/ |
//              \  .-\__  '-'  ___/-. /
//            ___'. .' / --.--\  `. .'___
//         ."" '<  `.___\_<|>_/___.' >' "".
//        | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//        \  \ `_.   \_ __\ /__ _/   .-` /  /
//    =====`-.____`.___ \_____/___.-`___.-'=====
//                      `=---='
//    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//				 佛祖保佑	    	 永无BUG
#include <glad/glad.h>
//load images
#include "Model.h"
#include "SkyBox.h"
#include <filesystem>
#include <iostream>
#include <GLFW/glfw3.h>
#include "Shader.h"
#include <glm.hpp>
#include <gtc/matrix_transform.hpp>
#include <gtc/type_ptr.hpp>

#include "imgui.h"
#include "imgui_impl_glfw.h"
//#include "imgui_demo.cpp"
#include "imgui_impl_opengl3.h"

#include "Camera.h"

#include "LightDirectional.h"

#define STB_IMAGE_IMPLEMENTATION
#define DEBUG 1
#include "Fbo.h"
#include "stb_image.h"
#include "ShaderList.h"
#include "Clouds.h"
#include "Languages.h"
//#include "Core/Log.h"


// Usage:
//  static ExampleAppLog my_log;
//  my_log.AddLog("Hello %d world\n", 123);
//  my_log.Draw("title");
struct ExampleAppLog
{
	ImGuiTextBuffer Buf;
	ImGuiTextFilter Filter;
	ImVector<int> LineOffsets; // Index to lines offset. We maintain this with AddLog() calls.
	bool AutoScroll; // Keep scrolling if already at the bottom.

	ExampleAppLog()
	{
		AutoScroll = true;
		Clear();
	}

	void Clear()
	{
		Buf.clear();
		LineOffsets.clear();
		LineOffsets.push_back(0);
	}

	void AddLog(const char* fmt, ...) IM_FMTARGS(2)
	{
		int old_size = Buf.size();
		va_list args;
		va_start(args, fmt);
		Buf.appendfv(fmt, args);
		va_end(args);
		for (int new_size = Buf.size(); old_size < new_size; old_size++)
			if (Buf[old_size] == '\n')
				LineOffsets.push_back(old_size + 1);
	}

	void Draw(const char* title, bool* p_open = NULL)
	{
		if (!ImGui::Begin(title, p_open))
		{
			ImGui::End();
			return;
		}

		// Options menu
		if (ImGui::BeginPopup("Options"))
		{
			ImGui::Checkbox("Auto-scroll", &AutoScroll);
			ImGui::EndPopup();
		}

		// Main window
		if (ImGui::Button("Options"))
			ImGui::OpenPopup("Options");
		ImGui::SameLine();
		bool clear = ImGui::Button("Clear");
		ImGui::SameLine();
		bool copy = ImGui::Button("Copy");
		ImGui::SameLine();
		Filter.Draw("Filter", -100.0f);

		ImGui::Separator();

		if (ImGui::BeginChild("scrolling", ImVec2(0, 0), false, ImGuiWindowFlags_HorizontalScrollbar))
		{
			if (clear)
				Clear();
			if (copy)
				ImGui::LogToClipboard();

			ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 0));
			const char* buf = Buf.begin();
			const char* buf_end = Buf.end();
			if (Filter.IsActive())
			{
				// In this example we don't use the clipper when Filter is enabled.
				// This is because we don't have random access to the result of our filter.
				// A real application processing logs with ten of thousands of entries may want to store the result of
				// search/filter.. especially if the filtering function is not trivial (e.g. reg-exp).
				for (int line_no = 0; line_no < LineOffsets.Size; line_no++)
				{
					const char* line_start = buf + LineOffsets[line_no];
					const char* line_end = (line_no + 1 < LineOffsets.Size)
						                       ? (buf + LineOffsets[line_no + 1] - 1)
						                       : buf_end;
					if (Filter.PassFilter(line_start, line_end))
						ImGui::TextUnformatted(line_start, line_end);
				}
			}
			else
			{
				// The simplest and easy way to display the entire buffer:
				//   ImGui::TextUnformatted(buf_begin, buf_end);
				// And it'll just work. TextUnformatted() has specialization for large blob of text and will fast-forward
				// to skip non-visible lines. Here we instead demonstrate using the clipper to only process lines that are
				// within the visible area.
				// If you have tens of thousands of items and their processing cost is non-negligible, coarse clipping them
				// on your side is recommended. Using ImGuiListClipper requires
				// - A) random access into your data
				// - B) items all being the  same height,
				// both of which we can handle since we have an array pointing to the beginning of each line of text.
				// When using the filter (in the block of code above) we don't have random access into the data to display
				// anymore, which is why we don't use the clipper. Storing or skimming through the search result would make
				// it possible (and would be recommended if you want to search through tens of thousands of entries).
				ImGuiListClipper clipper;
				clipper.Begin(LineOffsets.Size);
				while (clipper.Step())
				{
					for (int line_no = clipper.DisplayStart; line_no < clipper.DisplayEnd; line_no++)
					{
						const char* line_start = buf + LineOffsets[line_no];
						const char* line_end = (line_no + 1 < LineOffsets.Size)
							                       ? (buf + LineOffsets[line_no + 1] - 1)
							                       : buf_end;
						ImGui::TextUnformatted(line_start, line_end);
					}
				}
				clipper.End();
			}
			ImGui::PopStyleVar();

			// Keep up at the bottom of the scroll region if we were already at the bottom at the beginning of the frame.
			// Using a scrollbar or mouse-wheel will take away from the bottom edge.
			if (AutoScroll && ImGui::GetScrollY() >= ImGui::GetScrollMaxY())
				ImGui::SetScrollHereY(1.0f);
		}
		ImGui::EndChild();
		ImGui::End();
	}
};

// ---------------------------------*相机*---------------------------------
Camera camera(glm::vec3(0, 5.0f, -10.0f), glm::radians(0.0f), glm::radians(0.0f), glm::vec3(0, 1.0f, 0));
float viewPortAspectRatio = 9.0f / 16.0f;
// ---------------------------------*鼠标*---------------------------------
void processInput(GLFWwindow* window);
void mouse_callback(GLFWwindow* window, double xPos, double yPos);
void windowResizeCallBack(GLFWwindow* window, int width, int height);
//上一次鼠标的x和y坐标
float lastX = 960;
float lastY = 540;
bool firstMouse = true;


// ---------------------------------*UI*---------------------------------
void drawUI();
void drawNewUI();
static int shadowMapFlagClicked = 0;
static int shadowFlagClicked = 0;
static int cloudsOnFlagClicked = 0;
static int showWeatherClicked = 0;
static int weatherMapChannel = 0;
static int reloadShaderOnFlagClicked = 0;
static int swapLanguagesClicked = 0;
bool reloadShaderOnFlag = false;

bool shoWeatherMap = false;
bool swapLanguages = false;

bool shadowMapFlag = false;
bool shadowFlag = false;
bool cloudsOnFlag = false;


float ao = 0.8f;
int m_SPFSize = 3;
float m_shadowMapBias = 0.0002f;
float exposure = 1.0f;


// ---------------------------------*Cloud*---------------------------------
#define PI 3.1415926535f

float windStrength = 0.00026f;
glm::vec3 windDirection = glm::vec3(0, 0, -10.0f);

// Sun Params
float sunEnergy = 1.8f;
float anbientIntensity = 0.329f;
glm::vec3 sunColor = glm::vec3(1.0, 1.0, 1.0);

glm::vec3 verticalProbParam = glm::vec3(0.0, 0.2, 1.76);

glm::vec4 CloudBaseColor = glm::vec4(0.613f, 0.795f, 1.0f, 1.0f);
glm::vec4 CloudTopColor = glm::vec4(1.0f, 1.0f, 1.0f, 1.0f);
float totalBrightnessFactor = 0.4f;
float powderTopBrightness = 0.15f;

float precipiFactor = 0.513f;
float coverageFactor = 0.0f;
float curlNoiseMultiple = 0.0f;

// Cloud Detail Params.
float detailScale = 1.68f;
glm::vec3 detailwindDirection = glm::vec3(0.005, 0.0, 0.005);

////////////////////////////////////////////////////////////
//added parameters
float cloudVolumeStartHeight = 4000.0f; // meters - height above ground level 云层开始的高度（从地表开始算
float cloudVolumeHeight = 12000.0f; // meters - height above ground level 云层所占的高度即云层的厚度（从地表开始算

float groundRadius = 637100.0f; // meters - for a ground/lower atmosphere only version, this could be smaller
// Cloud Animation Params.
float cloudSpeed = 27.7f;


glm::vec3 weatherTexMod = glm::vec3(0.5f, 0, 0); // scale(x), offset(y, z)


float cloudTopOffset = 1.0f;

float NoiseThreshold = 0.0f;
float NoiseMax = 0.777f;
// ---------------------------------*Light*---------------------------------
LightDirectional light_directional(
	//position
	glm::vec3(0, 0, -30.0f),
	//angle
	glm::vec3(-200.0f, 18.0f, 0.0f),
	//color
	glm::vec3(1.0f, 1.0f, 1.0f),
	//intensity
	float(5.0f)
);
//IMGUI TODO move to class
static void glfw_error_callback(int error, const char* description)
{
	fprintf(stderr, "Glfw Error %d: %s\n", error, description);
}

void imguiDock();
// ---------------------------------*MVP矩阵*---------------------------------
glm::mat4 view, projection, modelMat;
// #################################*MAIN*######################################


GLuint viewPortFbo = NULL;
GLuint viewPortTexture = NULL;

int main(int argc, char* argv[])
{
	std::string exePath = argv[0];

	glfwInit();
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	GLFWwindow* window = glfwCreateWindow(Fbo::GetScreenWidth(), Fbo::GetScreenHeight(), "Cloud", nullptr, nullptr);
	if (window == nullptr)
	{
		std::cout << "打开窗口失败" << std::endl;
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(window);
	glfwSetWindowSizeCallback(window, windowResizeCallBack);
	glfwSetCursorPosCallback(window, mouse_callback);
	//glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
	// glad: load all OpenGL function pointers
	// ---------------------------------------
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		std::cout << "Failed to initialize GLAD" << std::endl;
		return -1;
	}


	glViewport(0, 0, Fbo::GetScreenWidth(), Fbo::GetScreenHeight());

	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);

	//glEnable(GL_FRAMEBUFFER_SRGB);	
	glfwSwapInterval(0); //disable VSync.
	glEnable(GL_TEXTURE_CUBE_MAP_SEAMLESS); // 修复预滤波贴图的接缝脱节

	// ---------------------------------*Shader*---------------------------------
	ShaderList m_shaderList;
	m_shaderList.initAllShader();
	//auto s_cloud = m_shaderList.s_cloud;

	//---------------------------------*SkyBox*---------------------------------
	SkyBox skyBox;
	skyBox.set(m_shaderList.s_skyBoxShader, m_shaderList.s_sceneShader);

	Model m_scene(
		exePath.substr(0, exePath.find_last_of('\\')) + "\\" + "Models" + "\\" + "cz" + "\\" + "all.obj");
	//// ---------------------------------*ImGUI*---------------------------------
	//// Setup Dear ImGui context

	glfwSetErrorCallback(glfw_error_callback);
	IMGUI_CHECKVERSION();
	ImGui::CreateContext();
	ImGuiIO& io = ImGui::GetIO();
	(void)io;
	io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard; // Enable Keyboard Controls
	io.ConfigFlags |= ImGuiConfigFlags_DockingEnable; // Enable Docking
	io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable; // Enable Multi-Viewport / Platform Windows
	 // Load Fonts
	io.Fonts->AddFontFromFileTTF("resources/fonts/msyhl.ttf", 18.0f, NULL, io.Fonts->GetGlyphRangesChineseSimplifiedCommon());


	// Setup Dear ImGui style
	ImGui::StyleColorsDark();

	// When viewports are enabled we tweak WindowRounding/WindowBg so platform windows can look identical to regular ones.
	ImGuiStyle& style = ImGui::GetStyle();
	if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
	{
		style.WindowRounding = 0.0f;
		style.Colors[ImGuiCol_WindowBg].w = 1.0f;
	}
	ImGui_ImplGlfw_InitForOpenGL(window, true);
	ImGui_ImplOpenGL3_Init("#version 330");


	// ---------------------------------*FrameBuffer*---------------------------------
	// Texture for Shadow Map FBO
	unsigned int quadVAO;
	quadVAO = Fbo::getQuadVAO();
	// ---------------------------------*ShadowMap*---------------------------------
	// Framebuffer for Shadow Map
	GLuint shadowMapFBO = NULL;
	GLuint shadowMap = NULL;

	Fbo::getShdowFboMap(shadowMapFBO, shadowMap, shadowMapWidth, shadowMapHeight);
	// ---------------------------------*PBR 预处理*---------------------------------
	//漫反射部分
	GLuint* cubemapFromHDR = new GLuint;
	GLuint* irradianceMap = new GLuint;
	//镜面反射部分的贴图
	GLuint* brdfLUTTexture = new GLuint;
	GLuint* prefilterMap = new GLuint;

	Fbo::getIndirectDiffuseMaps(cubemapFromHDR, irradianceMap, m_shaderList.s_equalRectTOCube,
	                            m_shaderList.s_irradianceMap);
	Fbo::getIndirectSpecularMaps(prefilterMap, brdfLUTTexture, cubemapFromHDR, m_shaderList.s_preFilter,
	                             m_shaderList.s_genBrdfLut);

	//glEnable(GL_CULL_FACE);

	//---------------------------------*SHADER setup*---------------------------------
	m_shaderList.s_standard->use();
	m_shaderList.s_standard->PassUniformToShader("prefilterMap", 8);
	m_shaderList.s_standard->PassUniformToShader("brdfLUT", 7);
	m_shaderList.s_standard->PassUniformToShader("irradianceMap", 6);
	m_shaderList.s_standard->PassUniformToShader("shadowMap", 9);
	glActiveTexture(GL_TEXTURE8);
	glBindTexture(GL_TEXTURE_CUBE_MAP, *prefilterMap);
	glActiveTexture(GL_TEXTURE7);
	glBindTexture(GL_TEXTURE_2D, *brdfLUTTexture);
	glActiveTexture(GL_TEXTURE6);
	glBindTexture(GL_TEXTURE_CUBE_MAP, *irradianceMap);

	m_shaderList.s_skyBoxHDR->use();
	m_shaderList.s_skyBoxHDR->PassUniformToShader("environmentMap", 0);

	m_shaderList.s_DEBUGSKYBOX->use();
	m_shaderList.s_DEBUGSKYBOX->PassUniformToShader("environmentMap", 0);


	//---------------------------------*Clouds*---------------------------------

	Shader s_cloud("resources/shaders/clouds.vert", "resources/shaders/clouds.frag");
	s_cloud.use();
	Clouds::cloudsInit();
	s_cloud.PassUniformToShader("depthTexture", 3);


	///////////////////////////////////////////////////////////////////////////////
	///DEPTH BUFFER
	///////////////////////////////////////////////////////////////////////////////
	// configure depth map FBO
	// -----------------------
	// ---------------------------------*ShadowMap*---------------------------------
	// Framebuffer for Shadow Map
	GLuint viewSpaceDepthMapFBO = NULL;
	GLuint viewSpaceDepthMap = NULL;
	Fbo::getShdowFboMap(viewSpaceDepthMapFBO, viewSpaceDepthMap, Fbo::GetScreenWidth(), Fbo::GetScreenHeight());
	Shader* simpleDepthShader = new Shader("resources/shaders/depth.vert", "resources/shaders/depth.frag");

	GLfloat nearPlane = 0.1f, farPlane = 750.0f;

	Fbo::GetColTexFbo(viewPortFbo, viewPortTexture, Fbo::GetScreenWidth(), Fbo::GetScreenHeight());
	//for depth map
	//s_cloud.use();
	//s_cloud.PassUniformToShader("near_plane", nearPlane);
	//s_cloud.PassUniformToShader("far_plane", farPlane);
	// #################################*渲染循环*######################################
	while (!glfwWindowShouldClose(window))
	{

		processInput(window);; // ---------------------------------*MVP矩阵*---------------------------------
		//赋值
		view = camera.GetViewMatrix();
		projection = glm::perspective(glm::radians(60.0f), Fbo::GetScreenWidth() / Fbo::GetScreenHeight(), nearPlane,
		                              farPlane);
		// ---------------------------------*framebuffer*---------------------------------
		glEnable(GL_DEPTH_TEST);
		glEnable(GL_CULL_FACE);
		glClearColor(0.15f, 0.15f, 0.15f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		///////////////////////////////////////////////////////////////////
		// ---------------------------------*shadowMap*---------------------------------
		glm::mat4 orthgonalProjection = glm::ortho(-35.0f, 35.0f, -35.0f, 35.0f, 0.1f, 1000.0f);
		glm::mat4 lightModel = glm::mat4(1.0f);
		//这里的X要绕着负的x轴转，看起来才是对的，根据图形学第一定律，就这样不改了
		lightModel = rotate(lightModel, glm::radians(light_directional.GetAngles().x), glm::vec3(-1.0f, 0.0f, 0));
		lightModel = rotate(lightModel, glm::radians(light_directional.GetAngles().y), glm::vec3(0.0f, -1.0f, 0));
		lightModel = rotate(lightModel, glm::radians(light_directional.GetAngles().z), glm::vec3(0.0f, 0, -1.0f));
		glm::mat4 lightView = lookAt(light_directional.GetPosition() - glm::vec3(5, 0, 0), glm::vec3(0),
		                             glm::vec3(0.0f, 1.0f, 0.0f));
		//glm::mat4 lightProjection = orthgonalProjection * lightView * lightModel;
		glm::mat4 lightProjection = orthgonalProjection * lightView * lightModel;

		//把顶点转向灯光视角的矩阵传给simpleDepthShader，用来获取深度图
		m_shaderList.s_simpleDepth->use();
		m_shaderList.s_simpleDepth->PassUniformToShader("lightProjection", lightProjection);
		m_shaderList.s_simpleDepth->PassUniformToShader("model", modelMat);
		//把视口改成深度图需要的分辨率，准备开始画深度图
		glViewport(0, 0, shadowMapWidth, shadowMapHeight);
		//把shadowMapFBO绑到当前的Framebuffer并激活;
		glBindFramebuffer(GL_FRAMEBUFFER, shadowMapFBO);
		glClear(GL_DEPTH_BUFFER_BIT);
		if (shadowFlag)
		{
			//用simpleDepthShader画出场景
			m_scene.Draw(m_shaderList.s_simpleDepth);
		}

		//解绑Framebuffer
		glBindFramebuffer(GL_FRAMEBUFFER, 0);
		glViewport(0, 0, Fbo::GetScreenWidth(), Fbo::GetScreenHeight());
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		m_shaderList.s_standard->use();
		m_shaderList.s_standard->PassUniformToShader("lightSpaceMatrix", lightProjection);

		glActiveTexture(GL_TEXTURE0);
		//shadow end
		///////////////////////////////////////////////////////////////////


		/////////////////////////////////////////////////////////////////////////////////////
		///Render Cloud
		/////////////////////////////////////////////////////////////////////////////////////
		glBindFramebuffer(GL_FRAMEBUFFER, viewPortFbo);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);



		if(cloudsOnFlag)
		{
		s_cloud.use();

		glActiveTexture(GL_TEXTURE2);
		glBindTexture(GL_TEXTURE_2D, Clouds::getWeatherTex());
		glActiveTexture(GL_TEXTURE0);

		s_cloud.PassUniformToShader("weatherLookup", 2);
//		glActiveTexture(GL_TEXTURE4);
//		glBindTexture(GL_TEXTURE_2D, Clouds::getCurlNoiseTex());

		s_cloud.PassUniformToShader("curlNoise", 4);
		glActiveTexture(GL_TEXTURE5);
		glBindTexture(GL_TEXTURE_2D, Clouds::getBlueNoiseTex());
			glActiveTexture(GL_TEXTURE0);
		s_cloud.PassUniformToShader("blueNoise", 5);
		//glm::mat4 v = glm::mat4(glm::mat3(camera.GetViewMatrix()));


		//added parameters
		//////////////////////////////////////////


		s_cloud.PassUniformToShader("projection", projection);
		s_cloud.PassUniformToShader("m", modelMat);
		s_cloud.PassUniformToShader("time", (GLfloat)glfwGetTime());
		s_cloud.PassUniformToShader("view", view);
		s_cloud.PassUniformToShader("projection", projection);
		s_cloud.PassUniformToShader("lightDir", light_directional.GetDirection());
		s_cloud.PassUniformToShader("camPos", camera.GetPosition());
		s_cloud.PassUniformToShader("shoWeatherMap", shoWeatherMap);
		s_cloud.PassUniformToShader("weatherMapChannel", weatherMapChannel);


		s_cloud.PassUniformToShader("sunEnergy", sunEnergy);

		s_cloud.PassUniformToShader("resolution", glm::vec2(Fbo::GetScreenWidth(), Fbo::GetScreenHeight()));
		s_cloud.PassUniformToShader("cloudVolumeStartHeight", cloudVolumeStartHeight);
		s_cloud.PassUniformToShader("cloudVolumeHeight", cloudVolumeHeight);

		s_cloud.PassUniformToShader("groundRadius", groundRadius);
		s_cloud.PassUniformToShader("windDirection", windDirection);
		s_cloud.PassUniformToShader("windStrength", windStrength);

		s_cloud.PassUniformToShader("precipiFactor", precipiFactor);
		s_cloud.PassUniformToShader("coverageFactor", coverageFactor);
		s_cloud.PassUniformToShader("curlNoiseMultiple", curlNoiseMultiple);

		s_cloud.PassUniformToShader("cloudTopOffset", cloudTopOffset);

		s_cloud.PassUniformToShader("weatherTexMod", weatherTexMod);
		s_cloud.PassUniformToShader("detailScale", detailScale);
		s_cloud.PassUniformToShader("detailwindDirection", detailwindDirection);
		s_cloud.PassUniformToShader("cloudSpeed", cloudSpeed);
		s_cloud.PassUniformToShader("sunColor", sunColor);
		s_cloud.PassUniformToShader("CloudBaseColor", CloudBaseColor);
		s_cloud.PassUniformToShader("CloudTopColor", CloudTopColor);
		s_cloud.PassUniformToShader("NoiseThreshold", NoiseThreshold);
		s_cloud.PassUniformToShader("NoiseMax", NoiseMax);
		s_cloud.PassUniformToShader("anbientIntensity", anbientIntensity);
		s_cloud.PassUniformToShader("verticalProbParam", verticalProbParam);
		s_cloud.PassUniformToShader("totalBrightnessFactor", totalBrightnessFactor);
		s_cloud.PassUniformToShader("powderTopBrightness", powderTopBrightness);

		glActiveTexture(GL_TEXTURE3);
		glBindTexture(GL_TEXTURE_2D, viewSpaceDepthMap);
		glDepthMask(GL_FALSE);
		glDisable(GL_CULL_FACE);
		//glBindVertexArray(Clouds::m_quadVAO);
		glBindVertexArray(Clouds::getCloudVAO());
		glDrawArrays(GL_TRIANGLES, 0, 36);
		glEnable(GL_CULL_FACE);
		glDepthMask(GL_TRUE);

		//Debug 
		if (reloadShaderOnFlag)
		{
			// weather
			int texWidth, texHeight, texChannels;
			unsigned char* weatherData = stbi_load("resources/textures/Clouds/weather_8.png", &texWidth, &texHeight,
				&texChannels, 0);

			glGenTextures(1, &Clouds::getWeatherTex());
			glBindTexture(GL_TEXTURE_2D, Clouds::getWeatherTex());
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 256, 256, 0, GL_RGB, GL_UNSIGNED_BYTE, weatherData);
			glBindTexture(GL_TEXTURE_2D, 0);

			s_cloud.createNewID();
			s_cloud.loadShaderFiles();
			s_cloud.use();
			s_cloud.PassUniformToShader("depthTexture", 3);
			s_cloud.PassUniformToShader("baseNoise", 0);
			s_cloud.PassUniformToShader("detailNoise", 1);
			//s_cloud.PassUniformToShader("near_plane", nearPlane);
			//s_cloud.PassUniformToShader("far_plane", farPlane);
		}
		reloadShaderOnFlagClicked = 0;
		}
		/////////////////////////////////////////////////////////////////////////////////////
		///Render Scene
		/////////////////////////////////////////////////////////////////////////////////////
		m_shaderList.s_standard->use();
		m_shaderList.s_standard->PassUniformToShader("ao", ao);

		m_shaderList.s_standard->PassUniformToShader("view", view);
		m_shaderList.s_standard->PassUniformToShader("projection", projection);
		m_shaderList.s_standard->PassUniformToShader("camPos", camera.GetPosition());


		m_shaderList.s_standard->PassUniformToShader("model", modelMat);
		m_shaderList.s_standard->PassUniformToShader("lightDir", light_directional.GetDirection());
		m_shaderList.s_standard->PassUniformToShader("lightColor", light_directional.GetColor());
		m_shaderList.s_standard->PassUniformToShader("lightIntensity", light_directional.GetIntensity());
		m_shaderList.s_standard->PassUniformToShader("SPFSize", m_SPFSize);
		m_shaderList.s_standard->PassUniformToShader("shadowMapBias", m_shadowMapBias);

		glActiveTexture(GL_TEXTURE9);
		glBindTexture(GL_TEXTURE_2D, shadowMap);

		m_scene.Draw(m_shaderList.s_standard);

		glBindFramebuffer(GL_FRAMEBUFFER, 0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);


		//drawSkyBos
		//skyBox.draw(m_shaderList.s_skyBoxShader, camera, projection, *cubemapFromHDR);
		/////////////////////////////////////////////////////////////////////////////////////
		///Get camera space depth Texture
		/////////////////////////////////////////////////////////////////////////////////////
		simpleDepthShader->use();
		simpleDepthShader->PassUniformToShader("p", projection);
		simpleDepthShader->PassUniformToShader("m", modelMat);
		simpleDepthShader->PassUniformToShader("v", view);
		//把视口改成深度图需要的分辨率，准备开始画深度图
		//glViewport(0, 0, Fbo::GetScreenWidth(), Fbo::GetScreenHeight());
		//把shadowMapFBO绑到当前的Framebuffer并激活;
		glBindFramebuffer(GL_FRAMEBUFFER, viewSpaceDepthMapFBO);
		glClear(GL_DEPTH_BUFFER_BIT);
		//用simpleDepthShader画出场景
		m_scene.Draw(simpleDepthShader);
		//m_scene.Draw(m_shaderList.s_standard);
		//解绑Framebuffer
		glBindFramebuffer(GL_FRAMEBUFFER, 0);
		glClear(GL_DEPTH_BUFFER_BIT);
		/////////////////////////////////////////////////////////////////////////////////////
		if (shadowMapFlag)
		{
			m_shaderList.s_debugDepth->use();
			m_shaderList.s_debugDepth->PassUniformToShader("depthMap", 0);
			glViewport(0, 0, Fbo::GetScreenWidth() / 3, Fbo::GetScreenHeight() / 3);
			glBindFramebuffer(GL_FRAMEBUFFER, 0);
			m_shaderList.s_debugDepth->use();
			m_shaderList.s_debugDepth->PassUniformToShader("near_plane", nearPlane);
			m_shaderList.s_debugDepth->PassUniformToShader("far_plane", farPlane);
			glBindVertexArray(quadVAO);
			glActiveTexture(GL_TEXTURE0);
			glBindTexture(GL_TEXTURE_2D, viewSpaceDepthMap);
			glDrawArrays(GL_TRIANGLES, 0, 6);
			glBindVertexArray(0);
			glBindFramebuffer(GL_FRAMEBUFFER, 0);
		}


		//}

		// ---------------------------------*ImGUI*---------------------------------
		imguiDock();
		// Rendering
		ImGui::Render();
		ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
		// Update and Render additional Platform Windows
		// (Platform functions may change the current OpenGL context, so we save/restore it to make it easier to paste this code elsewhere.
		//  For this specific demo app we could also call glfwMakeContextCurrent(window) directly)
		if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
		{
			GLFWwindow* backup_current_context = glfwGetCurrentContext();
			ImGui::UpdatePlatformWindows();
			ImGui::RenderPlatformWindowsDefault();
			glfwMakeContextCurrent(backup_current_context);
		}


		glfwSwapBuffers(window);
		glfwPollEvents();


		camera.UpdateCameraPos();
	}
	ImGui_ImplOpenGL3_Shutdown();
	ImGui_ImplGlfw_Shutdown();
	ImGui::DestroyContext();

	glfwDestroyWindow(window);
	glfwTerminate();
	return 0;
}

void processInput(GLFWwindow* window)
{
	float slowSpeed = 0.1f;
	float fastSpeed = 1.0f;
	float moveSpeed = 1.0f;
	if (glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_RIGHT) == GLFW_PRESS)
	{
		if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
		{
			glfwSetWindowShouldClose(window, true);
		}
		if (glfwGetKey(window, GLFW_KEY_LEFT_SHIFT) == GLFW_PRESS)
		{
			moveSpeed = fastSpeed;
		}
		else
		{
			moveSpeed = slowSpeed;
		}

		//前后移动
		if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS)
		{
			camera.SetSpeedZ(1.0f * moveSpeed);
		}
		else if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS)
		{
			camera.SetSpeedZ(-1.0F * moveSpeed);
		}
		else
		{
			camera.SetSpeedZ(0);
		}
		//左右移动
		if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS)
		{
			camera.SetSpeedX(1.0F * moveSpeed);
		}
		else if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS)
		{
			camera.SetSpeedX(-1.0F * moveSpeed);
		}
		else
		{
			camera.SetSpeedX(0);
		}
		//上下移动
		if (glfwGetKey(window, GLFW_KEY_E) == GLFW_PRESS)
		{
			camera.SetSpeedY(1.0F * moveSpeed);
		}
		else if (glfwGetKey(window, GLFW_KEY_Q) == GLFW_PRESS)
		{
			camera.SetSpeedY(-1.0F * moveSpeed);
		}
		else
		{
			camera.SetSpeedY(0);
		}
	}
}

void mouse_callback(GLFWwindow* window, double xPos, double yPos)
{
	if (firstMouse)
	{
		lastX = xPos;
		lastY = yPos;
		firstMouse = false;
	}
	float offsetX, offsetY;
	offsetX = xPos - lastX;
	offsetY = yPos - lastY;

	lastX = xPos;
	lastY = yPos;
	if (glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_RIGHT) == GLFW_PRESS)
	{
		camera.ProcessMouseMovement(offsetX, offsetY);
		//隐藏鼠标
		glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
	}
	else
	{
		glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_NORMAL);
	}
}

void windowResizeCallBack(GLFWwindow* window, int width, int height)
{
	Fbo::SetScreenHeight(height);
	Fbo::SetScreenWidth(width);
}

void imguiDock()
{


	ImGui_ImplOpenGL3_NewFrame();
	ImGui_ImplGlfw_NewFrame();
	ImGui::NewFrame();

	// DockSpace
	ImGuiIO& io = ImGui::GetIO();
	ImGuiStyle& style = ImGui::GetStyle();

	// Note: Switch this to true to enable dockspace
	static bool dockspaceOpen = true;
	static bool opt_fullscreen_persistant = true;
	bool opt_fullscreen = opt_fullscreen_persistant;
	static ImGuiDockNodeFlags dockspace_flags = ImGuiDockNodeFlags_None;

	// We are using the ImGuiWindowFlags_NoDocking flag to make the parent window not dockable into,
	// because it would be confusing to have two docking targets within each others.
	ImGuiWindowFlags window_flags = ImGuiWindowFlags_MenuBar | ImGuiWindowFlags_NoDocking;
	if (opt_fullscreen)
	{
		ImGuiViewport* viewport = ImGui::GetMainViewport();
		ImGui::SetNextWindowPos(viewport->Pos);
		ImGui::SetNextWindowSize(viewport->Size);
		ImGui::SetNextWindowViewport(viewport->ID);
		ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0f);
		ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);
		window_flags |= ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize |
			ImGuiWindowFlags_NoMove;
		window_flags |= ImGuiWindowFlags_NoBringToFrontOnFocus | ImGuiWindowFlags_NoNavFocus;
	}

	// When using ImGuiDockNodeFlags_PassthruCentralNode, DockSpace() will render our background and handle the pass-thru hole, so we ask Begin() to not render a background.
	if (dockspace_flags & ImGuiDockNodeFlags_PassthruCentralNode)
		window_flags |= ImGuiWindowFlags_NoBackground;

	// Important: note that we proceed even if Begin() returns false (aka window is collapsed).
	// This is because we want to keep our DockSpace() active. If a DockSpace() is inactive, 
	// all active windows docked into it will lose their parent and become undocked.
	// We cannot preserve the docking relationship between an active window and an inactive docking, otherwise 
	// any change of dockspace/settings would lead to windows being stuck in limbo and never being visible.
	ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0f, 0.0f));
	ImGui::Begin("DockSpace Demo", &dockspaceOpen, window_flags);
	ImGui::PopStyleVar();

	if (opt_fullscreen)
		ImGui::PopStyleVar(2);



	float minWinSizeX = style.WindowMinSize.x;
	style.WindowMinSize.x = 370.0f;
	if (io.ConfigFlags & ImGuiConfigFlags_DockingEnable)
	{
		ImGuiID dockspace_id = ImGui::GetID("MyDockSpace");
		ImGui::DockSpace(dockspace_id, ImVec2(0.0f, 0.0f), dockspace_flags);
	}

	style.WindowMinSize.x = minWinSizeX;

	if (ImGui::BeginMenuBar())
	{
		if (ImGui::BeginMenu("File"))
		{
			// Disabling fullscreen would allow the window to be moved to the front of other windows, 
			// which we can't undo at the moment without finer window depth/z control.
			//ImGui::MenuItem("Fullscreen", NULL, &opt_fullscreen_persistant);

			if (ImGui::MenuItem("New", "Ctrl+N"))
				std::cout << ("new");

			if (ImGui::MenuItem("Open...", "Ctrl+O"))
				std::cout << ("open");
			if (ImGui::MenuItem("Save As...", "Ctrl+Shift+S"))
				std::cout << ("save");

			if (ImGui::MenuItem("Exit"))
				std::cout << ("close");;
			ImGui::EndMenu();
		}
		ImGui::EndMenuBar();
	}

	{
		static ExampleAppLog log;
		// Actually call in the regular Log helper (which will Begin() into the same window as we just did)
		log.Draw("Example: Log");
	}


	////panel
	//m_SceneHierarchyPanel.OnImGuiRender();
	{
		ImGui::Begin("Stats");

		//std::string name = "None";
		//if (m_HoveredEntity)
		//	name = m_HoveredEntity.GetComponent<TagComponent>().Tag;


		ImGui::Text("Application average %.3f ms/frame (%.1f FPS)", 1000.0f / ImGui::GetIO().Framerate,
		            ImGui::GetIO().Framerate);
		/*	auto stats = Renderer2D::GetStats()*/
		;

		if (ImGui::Button(u8"切换语言"))
			swapLanguagesClicked++;
		swapLanguages = false;
		if (swapLanguagesClicked & 1) Languages::showChinese();
		else Languages::showEnglish();


		if (ImGui::Button(Languages::enableShadow))
			shadowFlagClicked++;
		shadowFlag = false;
		if (shadowFlagClicked & 1)
		{
			shadowFlag = true;
		}

		ImGui::SameLine();
		if (ImGui::Button(Languages::showShadowMap))
			shadowMapFlagClicked++;
		shadowMapFlag = false;
		if (shadowMapFlagClicked & 1)
		{
			shadowMapFlag = true;
		}

		ImGui::SliderInt(Languages::spfSize, &m_SPFSize, 1, 12);
		ImGui::InputFloat(Languages::shadowMapBias, &m_shadowMapBias, 0.0001, 0.001, "%.5");

		ImGui::Text(Languages::globalSettings);
		ImGui::SliderFloat(Languages::lightIntensity, light_directional.SetIntensity(), 0.0f, 5.0f);
		// Edit 1 float using a slider from 0.0f to 1.0f
		//ImGui::ColorEdit3("DirLigh Ccolor", (float*)&light_directional.color);
		// Edit 3 floats representing a color
		ImGui::SliderFloat3(Languages::lightDirection, (float*)light_directional.SetAngles(), -360, 360);
		ImGui::DragFloat3(Languages::cameraPos, (float*)camera.SetPosition() ,100.0f, 0.0f, 100000.0f, "%.2f", 1.0f);

		//ImGui::SliderFloat3("LightPosition", (float*)&light_directional.position, -360, 360);
		ImGui::Spacing();

		//ImGui::SliderFloat("exposure ", (float*)&exposure, 0.001, 10.0f);
		//这里记得要更新direction，因为们是传direction到shader，而angles的值在初始化的时候就定了，然后马上会调用这个函数去更新方向，
		//所以如果不在这里再次更新方向，那angles的值就算用指针变了，但是他不会更新成direction。
		light_directional.UpdateDirection();

		ImGui::SameLine();
		if (ImGui::Button(Languages::showCloud))
			cloudsOnFlagClicked++;
		cloudsOnFlag = false;
		if (cloudsOnFlagClicked & 1)
		{
			cloudsOnFlag = true;
		}
		ImGui::SameLine();
		if (ImGui::Button(Languages::showWeatherMap))showWeatherClicked++;
		shoWeatherMap = false;
		if (showWeatherClicked & 1)shoWeatherMap = true;
		if (shoWeatherMap)
		{
			ImGui::RadioButton(Languages::coverage, &weatherMapChannel, 0);
			ImGui::SameLine();
			ImGui::RadioButton(Languages::precipitation, &weatherMapChannel, 1);
			ImGui::SameLine();
			ImGui::RadioButton(Languages::cloudType, &weatherMapChannel, 2);
		}
		ImGui::SameLine();
		if (ImGui::Button(Languages::reload))
			reloadShaderOnFlagClicked++;
		reloadShaderOnFlag = false;
		if (reloadShaderOnFlagClicked & 1)
		{
			reloadShaderOnFlag = true;
		}


		ImGui::Text(Languages::globalCloudsSettings);
		ImGui::InputFloat(Languages::cloudVolumeStartHeight, &cloudVolumeStartHeight, 0.0f, 10000.0f);
		ImGui::InputFloat(Languages::cloudVolumeHeight, &cloudVolumeHeight, 0.0f, 10000.0f);
		ImGui::InputFloat(Languages::groundRadius, &groundRadius, 0.0f, 10000.0f);


		ImGui::SliderFloat(Languages::windStrength, &windStrength, 0.000f, 0.001f, "%.5f");
		ImGui::InputFloat3(Languages::windDirection, glm::value_ptr(windDirection));

		ImGui::SliderFloat(Languages::turbStrength, &cloudSpeed, 0.0f, 100.0f);
		ImGui::InputFloat3(Languages::turbDirection, (float*)&detailwindDirection);


		ImGui::InputFloat3(Languages::weatherTexMod, glm::value_ptr(weatherTexMod));

		ImGui::Text(Languages::cloudShapeSettings);
		ImGui::SliderFloat(Languages::baseNoiseThreshold, &NoiseThreshold, 0.0f, 1.0f);
		ImGui::SliderFloat(Languages::baseNoiseMax, &NoiseMax, 0.0f, 1.0f);

		ImGui::SliderFloat(Languages::cloudCoverage, &coverageFactor, 0, 1.0f, "%.3f");

		ImGui::SliderFloat(Languages::detailScale, &detailScale, 0.0001, 10.0f, "%.4f");
		ImGui::SliderFloat(Languages::cloudTopColor, &cloudTopOffset, -10.0f, 500.0f);

		ImGui::SliderFloat(Languages::curlNoiseMultiple, &curlNoiseMultiple, 0, 10.0f, "%.3f");



		ImGui::Text(Languages::cloudLightingSettings);
		ImGui::SliderFloat(Languages::precipiFactor, &precipiFactor, 0, 1.0f, "%.3f");
		ImGui::InputFloat(Languages::sunEnergy, &sunEnergy, 0.0f, 10.0f);
		ImGui::SliderFloat(Languages::ambientIntensity, &anbientIntensity, 0.0f, 1.0f);
		ImGui::DragFloat3(Languages::verticalProbParam, (float*)&verticalProbParam, 0.01f, 0.0f, 5.0f, "%.2f", 1.0f);
		ImGui::DragFloat(Languages::totalBrightnessFactor, &totalBrightnessFactor, 0.01f, 0.0f, 1.0f, "%.2f", 1.0f);
		ImGui::DragFloat(Languages::powderTopBrightness, &powderTopBrightness, 0.01f, 0.0f, 1.0f, "%.2f", 1.0f);

		ImGui::ColorEdit3(Languages::sunColor, glm::value_ptr(sunColor));
		ImGui::ColorEdit3(Languages::cloudBaseColor, glm::value_ptr(CloudBaseColor));
		ImGui::ColorEdit3(Languages::cloudTopColor, glm::value_ptr(CloudTopColor));

		//buffer images
		int bufferWidth, bufferHight;
		bufferWidth = 220;
		bufferHight = 220;
		if (ImGui::BeginTable("bufferImages", 2))
		{
			ImGui::TableNextRow();
			ImGui::TableNextColumn();
			ImGui::Text(Languages::weatherTexture);
			ImGui::Image((void*)Clouds::getWeatherTex(), ImVec2(bufferWidth, bufferHight));


			ImGui::TableNextColumn();
			ImGui::Text(Languages::curlNoiseTex);
			ImGui::Image((void*)(intptr_t)Clouds::getCurlNoiseTex(), ImVec2(bufferWidth, bufferHight));

			ImGui::EndTable();
		}


		ImGui::End();
	}
	ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2{0, 0});
	ImGui::Begin("Viewport");

	//auto viewportMinRegion = ImGui::GetWindowContentRegionMin();
	//auto viewportMaxRegion = ImGui::GetWindowContentRegionMax();
	//auto viewportOffset = ImGui::GetWindowPos();

	//m_ViewportBounds[0] = { viewportMinRegion.x + viewportOffset.x, viewportMinRegion.y + viewportOffset.y };
	//m_ViewportBounds[1] = { viewportMaxRegion.x + viewportOffset.x, viewportMaxRegion.y + viewportOffset.y };

	//m_ViewportFocused = ImGui::IsWindowFocused();
	//m_ViewportHovered = ImGui::IsWindowHovered();

	ImVec2 viewportPanelSize = ImGui::GetContentRegionAvail();

	ImGui::Image(reinterpret_cast<void*>(viewPortTexture),
	             ImVec2{viewportPanelSize.x, viewportPanelSize.x * viewPortAspectRatio},
	             ImVec2{0, 1}, ImVec2{1, 0});

	ImGui::End();
	ImGui::PopStyleVar();

	ImGui::End();
}

