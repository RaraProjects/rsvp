Window = T{}

Window.Window_Flags = bit.bor(ImGuiWindowFlags_AlwaysAutoResize,
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

------------------------------------------------------------------------------------------------------
-- Sets the table row color.
------------------------------------------------------------------------------------------------------
---@param row integer
------------------------------------------------------------------------------------------------------
Window.Table_Row_Color = function(row)
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBg)
    if (row % 2) == 0 then x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBgAlt) end
    local row_color = UI.GetColorU32({x, y, z, w})
    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_color)
end