#include "Pch.h"
#include "PropertyPanel.h"

#include "Utils/Imgui_Widgets.h"

namespace Gui
{
	void PropertyPanel::render(Scene* scene)
	{
		auto mesh = scene->get_mesh();

		ImGui::Begin("Properties");
		if (ImGui::CollapsingHeader("Mesh", ImGuiTreeNodeFlags_DefaultOpen))
		{
			if (ImGui::Button("Open..."))
			{
				m_FileDialog.Open();
			}
			ImGui::SameLine(0, 5.0f);
			ImGui::Text(m_CurrentFile.c_str());
		}

		if (ImGui::CollapsingHeader("Material") && mesh)
		{
			ImGui::ColorPicker3("Color", (float*)&mesh->mColor,
			                    ImGuiColorEditFlags_PickerHueWheel | ImGuiColorEditFlags_DisplayRGB);
			ImGui::SliderFloat("Roughness", &mesh->mRoughness, 0.0f, 1.0f);
			ImGui::SliderFloat("Metallic", &mesh->mMetallic, 0.0f, 1.0f);
		}

		if (ImGui::CollapsingHeader("Light"))
		{
			ImGui::Separator();
			ImGui::Text("Position");
			ImGui::Separator();
			DyImgui::draw_vec3_widget("Position", scene->get_light()->m_Position, 80.0f);
		}
		if (ImGui::CollapsingHeader("Camera"))
		{
			ImGui::Separator();
			ImGui::Text("Camera Position");
			ImGui::Separator();
			DyImgui::draw_vec3_widget("Camera Position", scene->get_Camera()->m_Position, 80.0f);
		}

		ImGui::End();

		m_FileDialog.Display();
		if (m_FileDialog.HasSelected())
		{
			auto file_path = m_FileDialog.GetSelected().string();
			m_CurrentFile = file_path.substr(file_path.find_last_of("/\\") + 1);

			m_MeshLoadCallback(file_path);

			m_FileDialog.ClearSelected();
		}
	}
}
