#pragma once
#include "Shader/ShaderUtil.h"

namespace Base
{
	class Element
	{
	public:
		virtual void update(Shader::Shader* shader) = 0;
	};
}


