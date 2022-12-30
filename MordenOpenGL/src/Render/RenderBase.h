#pragma once
#include "Base/VertexHolder.h"
#include "Window/Window.h"

namespace Render
{
	class VertexIndexBuffer
	{
	public:
		VertexIndexBuffer() : mVBO{ 0 }, mVAO{ 0 }, mIBO{ 0 }
		{}

		virtual void create_buffers(const std::vector<Base::VertexHolder>& vertices, const std::vector<unsigned int>& indices) = 0;

		virtual void delete_buffers() = 0;

		virtual void bind() = 0;

		virtual void unbind() = 0;

		virtual void draw(int index_count) = 0;

	protected:
		GLuint mVBO;
		GLuint mVAO;
		GLuint mIBO;
	};


	class RenderContext
	{
	public:
		RenderContext() : m_Window(nullptr)
		{
		}

		virtual bool init(Window::DyWindow* window)
		{
			m_Window = window;
			return true;
		}

		virtual void preRender() = 0;

		virtual void postRender() = 0;

		virtual void end() = 0;

	protected:
		Window::DyWindow* m_Window;
	};

	class FrameBuffer
	{
	public:
		FrameBuffer() : mFBO{ 0 }, mDepthId{ 0 }
		{}

		virtual void create_buffers(int32_t width, int32_t height) = 0;

		virtual void delete_buffers() = 0;

		virtual void bind() = 0;

		virtual void unbind() = 0;

		virtual uint32_t get_texture() = 0;

	protected:
		uint32_t mFBO = 0;
		uint32_t mTexId = 0;
		uint32_t mDepthId = 0;
		int32_t mWidth = 0;
		int32_t mHeight = 0;
	};

}
