
#include "Pch.h"
#include "DyWindow.h"

#include <iostream>

namespace Window
{
    bool GLWindow::init(int width, int height, const std::string& title)
    {
        m_Width = width;
        m_Height = height;
        m_Title = title;

        m_RenderContext->init(this);

        m_UIContext->init(this);

        m_Scene = std::make_unique<Gui::Scene>();

        m_PropertyPanel = std::make_unique<Gui::PropertyPanel>();

        m_PropertyPanel->set_mesh_load_callback(
            [this](std::string filepath) { m_Scene->load_mesh(filepath); });

        return m_IsRunning;
    }

    GLWindow::~GLWindow()
    {
        m_UIContext->end();

        m_RenderContext->end();
    }

    void GLWindow::on_resize(int width, int height)
    {
        m_Width = width;
        m_Height = height;

        m_Scene->resize(m_Width, m_Height);
        render();
    }

    void GLWindow::on_scroll(double delta)
    {
        m_Scene->on_mouse_wheel(delta);
    }

    void GLWindow::on_key(int key, int scancode, int action, int mods)
    {
        if (action == GLFW_PRESS)
        {
        }
    }

    void GLWindow::on_close()
    {
        m_IsRunning = false;
    }

    void GLWindow::render()
    {

        // Clear the view
        m_RenderContext->preRender();

        // Initialize UI components
        m_UIContext->preRender();

        // render scene to framebuffer and add it to scene view
        m_Scene->render();

        m_PropertyPanel->render(m_Scene.get());

        // Render the UI 
        m_UIContext->postRender();

        // Render end, swap buffers
        m_RenderContext->postRender();

        handle_input();
    }

    void GLWindow::handle_input()
    {
        // TODO: move this and camera to scene UI component?

        if (glfwGetKey(m_Window, GLFW_KEY_W) == GLFW_PRESS)
        {
            m_Scene->on_mouse_wheel(-0.4f);
        }

        if (glfwGetKey(m_Window, GLFW_KEY_S) == GLFW_PRESS)
        {
            m_Scene->on_mouse_wheel(0.4f);
        }

        if (glfwGetKey(m_Window, GLFW_KEY_F) == GLFW_PRESS)
        {
            m_Scene->reset_view();
        }

        double x, y;
        glfwGetCursorPos(m_Window, &x, &y);

        m_Scene->on_mouse_move(x, y, Base::Input::GetPressedButton(m_Window));



    }

}