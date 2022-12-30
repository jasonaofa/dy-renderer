#pragma once
#include <functional>
#include "imgui/imgui.h"
#include "Scene.h"
#include <imgui/imfilebrowser.h>

namespace Gui
{
    class PropertyPanel
    {
    public:

        PropertyPanel()
        {
            m_CurrentFile = "< ... >";

            m_FileDialog.SetTitle("Open mesh");
            m_FileDialog.SetTypeFilters({ ".fbx", ".obj" });
        }

        void render(Gui::Scene* mScene);

        void set_mesh_load_callback(const std::function<void(const std::string&)>& callback)
        {
            m_MeshLoadCallback = callback;
        }

    private:
        // create a file browser instance
        ImGui::FileBrowser m_FileDialog;

        std::function<void(const std::string&)> m_MeshLoadCallback;

        std::string m_CurrentFile;


    };

}

