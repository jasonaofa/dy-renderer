#pragma once
#include "Render/OpenGLContext.h"
#include <memory>
#include "Window.h"
#include "Gui/PropertyPanel.h"
#include "Gui/Scene.h"
#include "Render/UIContext.h"

namespace Window
{
	class GLWindow : public DyWindow
	{
	public:
		GLWindow() :
			m_IsRunning(true), m_Window(nullptr)
		{
			m_UIContext = std::make_unique<Render::UIContext>();
			m_RenderContext = std::make_unique<Render::OpenGLContext>();
		}

		~GLWindow();

		bool init(int width, int height, const std::string& title);

		void render();

		void handle_input();

		void* get_native_window() override { return m_Window; }

		void set_native_window(void* window)
		{
			m_Window = (GLFWwindow*)window;
		}

		void on_scroll(double delta) override;

		void on_key(int key, int scancode, int action, int mods) override;

		void on_resize(int width, int height) override;

		void on_close() override;

		bool is_running() { return m_IsRunning; }

	private:
		GLFWwindow* m_Window;

		// Render contexts
		std::unique_ptr<Render::UIContext> m_UIContext;

		std::unique_ptr<Render::OpenGLContext> m_RenderContext;

		//// UI components
		std::unique_ptr<Gui::PropertyPanel> m_PropertyPanel;

		std::unique_ptr<Gui::Scene> m_Scene;

		bool m_IsRunning;
	};
};
