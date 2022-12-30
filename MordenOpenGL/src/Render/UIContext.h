#pragma once
#include "RenderBase.h"

namespace Render
{
    class UIContext : public RenderContext
    {

    public:

        bool init(Window::DyWindow* window) override;

        void preRender() override;

        void postRender() override;

        void end() override;

    };
};

