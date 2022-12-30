#pragma once
#include "Element.h"

namespace Base
{
    class Light : public Element
    {
    public:

        Light()
        {
            m_Color = glm::vec3(1.0f, 1.0f, 1.0f);
            m_Position = { 1.5f, 3.5f, 3.0f };
            m_Intensity = 100.0f;
        }

        ~Light() {}

        void update(Shader::Shader* shader) override
        {

            shader->set_vec3(m_Position, "lightPosition");
            shader->set_vec3(m_Color * m_Intensity, "lightColor");

        }

        glm::vec3 m_Position;

        glm::vec3 m_Color;

        float m_Intensity;

    };
}
