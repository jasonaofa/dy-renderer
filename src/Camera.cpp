#include "Camera.h"


Camera::Camera(glm::vec3 position, glm::vec3 target, glm::vec3 worldup)
{
	Position = position;
	WorldUp = worldup;
	Forward = glm::normalize(target - Position);
	Right = glm::cross(WorldUp, Forward);
	Up = glm::cross(Right, Forward);
}

Camera::Camera(glm::vec3 position, float pitch, float yaw, glm::vec3 worldup)
{
	Position = position;
	WorldUp = worldup;
	Pitch = pitch;
	Yaw = yaw;
	Forward.x = glm::cos(Pitch) * glm::sin(Yaw);
	Forward.y = glm::sin(Pitch);
	Forward.z = glm::cos(Pitch) * glm::cos(Yaw);
	Right = glm::cross(WorldUp,Forward);
	Up = glm::cross( Right, Forward);

}

//鼠标控制镜头
void Camera::ProcessMouseMovement(float offsetX, float offsetY)
{
	//定义一个灵敏度，防止镜头移动太快
	Pitch -= offsetY * sensitive;
	Yaw -= offsetX * sensitive;
	//限制一下最大角度，防止反转
	if (Pitch > 89.0f)
		Pitch = 89.0f;
	if (Pitch < -89.0f)
		Pitch = -89.0f;
	//每次应用偏移值之后，都更新相机的属性(Foward值）
	UpdateCameraVectors();
}

//更新相机的pitch和yaw
void Camera::UpdateCameraVectors()
{
	Forward.x = glm::cos(Pitch) * glm::sin(Yaw);
	Forward.y = glm::sin(Pitch);
	Forward.z = glm::cos(Pitch) * glm::cos(Yaw);
	Right = glm::cross(WorldUp, Forward);
	Up = glm::cross(Right, Forward);
}


glm::mat4 Camera::GetViewMatrix()
{
	return glm::lookAt(Position, Position + Forward, WorldUp);
}





void Camera::UpdateCameraPos()
{
	Position += (Forward * SpeedZ * 0.1f) + (Right * SpeedX * 0.1f) + (Up * SpeedY * 0.1f);
}


