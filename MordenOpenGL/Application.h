#pragma once

#include <memory>
#include <string>
#include "src/Window/DyWindow.h"


class Application
{

public:
	Application(const std::string& app_name);

	static Application& Instance() { return *sInstance; }

	void loop();

private:
	static Application* sInstance;

	std::unique_ptr<Window::GLWindow> m_Window;
};
