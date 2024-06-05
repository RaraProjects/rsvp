Window = T{}

Window.Defaults = T{
    Width  = 700,
    Height = 10,
    X_Pos  = 100,
    Y_Pos  = 100,
}

Window.Window_Flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav)

Window.Tab_Flags = ImGuiTabBarFlags_None

Window.Colors = T{
    WHITE    = {1.0,  1.0,  1.0,  1.0},
    BLACK    = {0.0,  0.0,  0.0,  1.0},
    RED      = {1.0,  0.2,  0.2,  1.0},
    ORANGE   = {0.9,  0.6,  0.0,  1.0},
    YELLOW   = {0.9,  1.0,  0.0,  1.0},
    DIM      = {0.4,  0.4,  0.4,  1.0},
    DEFAULT  = {0.18, 0.20, 0.23, 0.96},
    INACTIVE = {0.4,  0.4,  0.4,  1.0},
}

require("gui.clock")
require("rsvp_creation._rsvp_creation")
require("rsvp_list._rsvp_list")
require("gui.config")