#pragma once
#include "Element.h"
#include <glm/glm/gtx/quaternion.hpp>

#include "Input.h"

namespace Base
{
	class Camera : public Element
	{
	public:

		Camera(const glm::vec3& position, float fov, float aspect, float near, float far)
		{
			m_Position = position;
			m_Aspect = aspect;
			m_Near = near;
			m_Far = far;
			m_FOV = fov;

			set_aspect(m_Aspect);

			update_view_matrix();
		}

		void update(Shader::Shader* shader) override
		{
			glm::mat4 model{ 1.0f };
			shader->set_mat4(model, "model");
			shader->set_mat4(mViewMatrix, "view");
			shader->set_mat4(get_projection(), "projection");
			shader->set_vec3(m_Position, "camPos");
		}

		void set_aspect(float aspect)
		{
			m_Projection = glm::perspective(m_FOV, aspect, m_Near, m_Far);
		}

		void set_distance(float offset)
		{
			mDistance += offset;
			update_view_matrix();
		}

		const glm::mat4& get_projection() const
		{
			return m_Projection;
		}

		glm::mat4 get_view_projection() const
		{
			return m_Projection * get_view_matrix();
		}

		glm::vec3 get_up() const
		{
			return glm::rotate(get_direction(), cUp);
		}

		glm::vec3 get_right() const
		{
			return glm::rotate(get_direction(), cRight);
		}

		glm::vec3 get_forward() const
		{
			return glm::rotate(get_direction(), cForward);
		}

		glm::quat get_direction() const
		{
			return glm::quat(glm::vec3(-mPitch, -mYaw, 0.0f));
		}

		glm::mat4 get_view_matrix() const
		{
			return mViewMatrix;
		}

		void on_mouse_wheel(double delta)
		{
			set_distance(delta * 0.5f);

			update_view_matrix();
		}

		void reset()
		{
			mFocus = { 0.0f, 0.0f, 0.0f };
			//mDistance = 5.0f;
			update_view_matrix();
		}

		void on_mouse_move(double x, double y, InputButton button)
		{
			glm::vec2 pos2d{ x, y };

			if (button == InputButton::Right)
			{
				glm::vec2 delta = (pos2d - mCurrentPos2d) * 0.004f;

				float sign = get_up().y < 0 ? -1.0f : 1.0f;
				mYaw += sign * delta.x * cRotationSpeed;
				mPitch += delta.y * cRotationSpeed;

				update_view_matrix();
			}
			else if (button == InputButton::Middle)
			{
				// TODO: Adjust pan speed for distance
				glm::vec2 delta = (pos2d - mCurrentPos2d) * 0.003f;

				mFocus += -get_right() * delta.x * mDistance;
				mFocus += get_up() * delta.y * mDistance;

				update_view_matrix();
			}

			mCurrentPos2d = pos2d;
		}

		void update_view_matrix()
		{
			m_Position = mFocus - get_forward() * mDistance;

			glm::quat orientation = get_direction();
			mViewMatrix = glm::translate(glm::mat4(1.0f), m_Position) * glm::toMat4(orientation);
			mViewMatrix = glm::inverse(mViewMatrix);
		}

		glm::vec3 GetPosition() { return m_Position; }
		glm::vec3 m_Position = { 0.0f, 0.0f, 0.0f };
		glm::mat4 m_Projection = glm::mat4{ 1.0f };
	private:
		glm::mat4 mViewMatrix;



		glm::vec3 mFocus = { 0.0f, 0.0f, 0.0f };

		float mDistance = 5.0f;
		float m_Aspect;
		float m_FOV;
		float m_Near;
		float m_Far;

		float mPitch = 0.0f;
		float mYaw = 0.0f;

		glm::vec2 mCurrentPos2d = { 0.0f, 0.0f };

		const glm::vec3 cRight = { 1.0f, 0.0f, 0.0f };
		const glm::vec3 cUp = { 0.0f, 1.0f, 0.0f };
		const glm::vec3 cForward = { 0.0f, 0.0f, -1.0f };

		const float cRotationSpeed = 2.0f;

	};
}

