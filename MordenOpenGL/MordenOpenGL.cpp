#include "Pch.h"
#include "application.h"

int main()
{
    auto app = std::make_unique<Application>("DyRender");
    app->loop();

    return 0;
}

