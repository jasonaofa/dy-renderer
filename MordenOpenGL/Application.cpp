#include "Pch.h"
#include "application.h"

#include "src/Window/DyWindow.h"

Application::Application(const std::string& app_name)
{
    m_Window = std::make_unique<Window::GLWindow>();
    m_Window->init(1920,1080, app_name);

}

void Application::loop()
{
    while (m_Window->is_running())
    {
        m_Window->render();
    }
}