#include "Pch.h"
#include "OpenGLContext.h"

namespace Render
{
	static void on_key_callback(GLFWwindow* window, int key, int scancode, int action, int mods)
	{
		auto pWindow = static_cast<Window::DyWindow*>(glfwGetWindowUserPointer(window));
		pWindow->on_key(key, scancode, action, mods);
	}

	static void on_scroll_callback(GLFWwindow* window, double xoffset, double yoffset)
	{
		auto pWindow = static_cast<Window::DyWindow*>(glfwGetWindowUserPointer(window));
		pWindow->on_scroll(yoffset);
	}

	static void on_window_size_callback(GLFWwindow* window, int width, int height)
	{
		auto pWindow = static_cast<Window::DyWindow*>(glfwGetWindowUserPointer(window));
		pWindow->on_resize(width, height);
	}

	static void on_window_close_callback(GLFWwindow* window)
	{
		Window::DyWindow* pWindow = static_cast<Window::DyWindow*>(glfwGetWindowUserPointer(window));
		pWindow->on_close();
	}



	bool OpenGLContext::init(Window::DyWindow* window)
	{
		__super::init(window);

		/* Initialize the library */
		if (!glfwInit())
		{
			fprintf(stderr, "Error: GLFW Window couldn't be initialized\n");
			return false;
		}

		// Create the window and store this window as window pointer
		// so that we can use it in callback functions
		auto glWindow = glfwCreateWindow(window->m_Width, window->m_Height, window->m_Title.c_str(), nullptr, nullptr);
		window->set_native_window(glWindow);

		if (!glWindow)
		{
			fprintf(stderr, "Error: GLFW Window couldn't be created\n");
			return false;
		}

		glfwSetWindowUserPointer(glWindow, window);
		glfwSetKeyCallback(glWindow, on_key_callback);
		glfwSetScrollCallback(glWindow, on_scroll_callback);
		glfwSetWindowSizeCallback(glWindow, on_window_size_callback);
		glfwSetWindowCloseCallback(glWindow, on_window_close_callback);
		glfwMakeContextCurrent(glWindow);

		if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
		{
			std::cout << "Failed to initialize GLAD" << std::endl;
			return -1;
		}

		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);
		glfwSwapInterval(0); //disable VSync.
		glEnable(GL_TEXTURE_CUBE_MAP_SEAMLESS); // ÐÞ¸´Ô¤ÂË²¨ÌùÍ¼µÄ½Ó·ìÍÑ½Ú

		return true;
	}

	void OpenGLContext::preRender()
	{
		glViewport(0, 0, m_Window->m_Width, m_Window->m_Height);
		glClearColor(0.2f, 0.2f, 0.2f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}

	void OpenGLContext::postRender()
	{
		glfwPollEvents();
		glfwSwapBuffers((GLFWwindow*)m_Window->get_native_window());
	}

	void OpenGLContext::end()
	{
		glfwDestroyWindow((GLFWwindow*)m_Window->get_native_window());
		glfwTerminate();
	}
}
