#pragma once
#include "Base/Camera.h"
#include "Base/Light.h"
#include "Base/Mesh.h"
#include "Render/OpenGLBufferManager.h"
#include "Shader/ShaderUtil.h"

namespace Gui
{
	class Scene
	{
    public:
        Scene() :
            m_Camera(nullptr), m_FrameBuffer(nullptr), m_Shader(nullptr),
            m_Light(nullptr),m_Size(1920, 1080)
        {
            m_FrameBuffer = std::make_unique<Render::OpenGL_FrameBuffer>();
            m_FrameBuffer->create_buffers(1920, 1080);
            m_Shader = std::make_unique<Shader::Shader>();
            m_Shader->load("src/Resources/Shaders/v1.shader", "src/Resources/Shaders/fs_pbr.shader");
            m_Light = std::make_unique<Base::Light>();

            m_Camera = std::make_unique<Base::Camera>(glm::vec3(0, 0, 3), 45.0f, 1.78f, 0.01f, 10000.0f);
        }

        ~Scene()
        {
            m_Shader->unload();
        }

        Base::Light* get_light() { return m_Light.get(); }
        Base::Camera* get_Camera() { return m_Camera.get(); }

        void resize(int32_t width, int32_t height);

        void render();

        void load_mesh(const std::string& filepath);

        void set_mesh(std::shared_ptr<Base::Mesh> mesh)
        {
            m_Mesh = mesh;
        }

        std::shared_ptr<Base::Mesh> get_mesh() { return m_Mesh; }

        void on_mouse_move(double x, double y, Base::InputButton button);

        void on_mouse_wheel(double delta);

        void reset_view()
        {
            m_Camera->reset();
        }


    private:
        std::unique_ptr<Base::Camera> m_Camera;
        std::unique_ptr<Render::OpenGL_FrameBuffer> m_FrameBuffer;
        std::unique_ptr<Shader::Shader> m_Shader;
        std::unique_ptr<Base::Light> m_Light;
        std::shared_ptr<Base::Mesh> m_Mesh;
        glm::vec2 m_Size;
	};
}
