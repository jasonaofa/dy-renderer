#pragma once
#include "Element.h"
#include "VertexHolder.h"
#include "Render/RenderBase.h"
#include "Shader/ShaderUtil.h"

namespace Base
{
	class Mesh : public Element
	{
	public:
        Mesh() = default;

        virtual ~Mesh();

        bool load(const std::string & filepath);

        void add_vertex(const VertexHolder & vertex) { m_Vertices.push_back(vertex); }

        void add_vertex_index(unsigned int vertex_idx) { m_VertexIndices.push_back(vertex_idx); }

        std::vector<unsigned int> get_vertex_indices() { return m_VertexIndices; }

        void update(Shader::Shader *shader) override
        {
            // pbr color
            shader->set_vec3(mColor, "albedo");

            shader->set_f1(mRoughness, "roughness");
            shader->set_f1(mMetallic, "metallic");
            shader->set_f1(1.0f, "ao");

        }

        glm::vec3 mColor = { 1.0f, 0.0f, 0.0f };
        float mRoughness = 0.2f;
        float mMetallic = 0.1f;

        void init();

        void create_buffers();

        void delete_buffers();

        void render();

        void bind();

        void unbind();

	private:
		// Buffers manager
		std::unique_ptr<Render::VertexIndexBuffer> m_RenderBufferMgr;

		// Vertices and indices
		std::vector<VertexHolder> m_Vertices;
		std::vector<unsigned int> m_VertexIndices;
	};
}
