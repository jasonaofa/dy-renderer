#include "Pch.h"
#include "Mesh.h"

#include "Render/OpenGLBufferManager.h"

#include <assimp/Importer.hpp>
#include <assimp/postprocess.h>
#include <assimp/scene.h>
namespace Base
{
    void Mesh::init()
    {
        m_RenderBufferMgr = std::make_unique<Render::OpenGL_VertexIndexBuffer>();

        create_buffers();
    }

    Mesh::~Mesh()
    {
        delete_buffers();
    }

    bool Mesh::load(const std::string& filepath)
    {
        const uint32_t cMeshImportFlags =
            aiProcess_CalcTangentSpace |
            aiProcess_Triangulate |
            aiProcess_SortByPType |
            aiProcess_GenNormals |
            aiProcess_GenUVCoords |
            aiProcess_OptimizeMeshes |
            aiProcess_ValidateDataStructure;

        Assimp::Importer Importer;

        const aiScene* pScene = Importer.ReadFile(filepath.c_str(),
            cMeshImportFlags);

        if (pScene && pScene->HasMeshes())
        {
            m_VertexIndices.clear();
            m_Vertices.clear();

            auto* mesh = pScene->mMeshes[0];

            for (uint32_t i = 0; i < mesh->mNumVertices; i++)
            {
                VertexHolder vh;
                vh.mPos = { mesh->mVertices[i].x, mesh->mVertices[i].y ,mesh->mVertices[i].z };
                vh.mNormal = { mesh->mNormals[i].x, mesh->mNormals[i].y ,mesh->mNormals[i].z };

                add_vertex(vh);
            }

            for (size_t i = 0; i < mesh->mNumFaces; i++)
            {
                aiFace face = mesh->mFaces[i];

                for (size_t j = 0; j < face.mNumIndices; j++)
                    add_vertex_index(face.mIndices[j]);
            }

            init();
            return true;
        }
        return false;
    }

    void Mesh::create_buffers()
    {
        m_RenderBufferMgr->create_buffers(m_Vertices, m_VertexIndices);
    }

    void Mesh::delete_buffers()
    {
        m_RenderBufferMgr->delete_buffers();
    }

    void Mesh::bind()
    {
        m_RenderBufferMgr->bind();
    }

    void Mesh::unbind()
    {
        m_RenderBufferMgr->unbind();
    }

    void Mesh::render()
    {
        m_RenderBufferMgr->draw((int)m_VertexIndices.size());
    }
}
