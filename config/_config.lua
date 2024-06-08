Config = T{}
Config.Toggle = T{}
Config.Widget = T{}

Config.Defaults = T{
    X_Pos  = 100,
    Y_Pos  = 100,
    Scale = 1.0,
}

Config.Table_Flags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)

Config.Draggable_Width = 100
Config.ALIAS = "config"
Config.Scaling_Set = false
Config.Reset_Position = true

-- ------------------------------------------------------------------------------------------------------
-- Displays the configuration window.
-- ------------------------------------------------------------------------------------------------------
Config.Display = function()
    if Config.Reset_Position then
        UI.SetNextWindowPos({RSVP.Config.X_Pos, RSVP.Config.Y_Pos}, ImGuiCond_Always)
        Config.Reset_Position = false
    end
    if UI.Begin("RSVP Config", true, Window.Window_Flags) then
        RSVP.Config.X_Pos, RSVP.Config.Y_Pos = UI.GetWindowPos()
        Config.Set_Window_Scaling()

        if UI.BeginTabBar("Settings Tabs", ImGuiTabBarFlags_None) then
            Config.Help_Text()
            Config.Settings()
            UI.EndTabBar()
        end

        UI.End()
    end

end

-- ------------------------------------------------------------------------------------------------------
-- Shows the help text section.
-- ------------------------------------------------------------------------------------------------------
Config.Help_Text = function()
    if UI.BeginTabItem("Help") then
        UI.Text("Read Me: https://github.com/RaraProjects/rsvp")
        UI.Text("Version: " .. tostring(addon.version))
        UI.Text("")
        UI.Text("Base command: /rsvp")
        UI.Text("Arguments:")
        if UI.BeginTable("Text Commands", 3, Config.Table_Flags) then
            UI.TableSetupColumn("Full")
            UI.TableSetupColumn("Short")
            UI.TableSetupColumn("Description")
            UI.TableHeadersRow()

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("create\nmake")
            UI.TableNextColumn() UI.Text("c\nm")
            UI.TableNextColumn() UI.Text("Toggles timer creation window visibility.")

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("timers\nlist")
            UI.TableNextColumn() UI.Text("t\nl")
            UI.TableNextColumn() UI.Text("Toggles timer list window visibility.")

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("clock")
            UI.TableNextColumn() UI.Text("cl")
            UI.TableNextColumn() UI.Text("Toggles clock visibility.")

            UI.EndTable()
        end
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the settings section.
-- ------------------------------------------------------------------------------------------------------
Config.Settings = function()
    if UI.BeginTabItem("Settings") then
        Config.Widget.Decoration()
        UI.Separator()
        Config.Widget.Set_Scale()
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the current window scaling.
-- ------------------------------------------------------------------------------------------------------
Config.Get_Scale = function()
    return RSVP.Config.Scale
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether the window scaling needs to be updated.
-- ------------------------------------------------------------------------------------------------------
Config.Is_Scaling_Set = function()
    return Config.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
Config.Set_Scaling_Flag = function(scaling)
    Config.Scaling_Set = scaling
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Config.Set_Window_Scaling = function()
    if not Config.Is_Scaling_Set() then
        UI.SetWindowFontScale(Config.Get_Scale())
        Config.Set_Scaling_Flag(true)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets window scaling.
-- ------------------------------------------------------------------------------------------------------
Config.Widget.Set_Scale = function()
    local window_scale = {[1] = RSVP.Config.Scale}
    UI.SetNextItemWidth(Config.Draggable_Width)
    if UI.DragFloat("Window Scaling", window_scale, 0.005, 0.7, 3, "%.2f", ImGuiSliderFlags_None) then
        if window_scale[1] < 0.7 then window_scale[1] = 0.7
        elseif window_scale[1] > 3 then window_scale[1] = 3 end
        RSVP.Config.Scale = window_scale[1]
        Create.Set_Scaling_Flag(false)
        Clock.Set_Scaling_Flag(false)
        List.Set_Scaling_Flag(false)
        Config.Set_Scaling_Flag(false)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles window decoration on the Timer List.
-- ------------------------------------------------------------------------------------------------------
Config.Widget.Decoration = function()
    if UI.Checkbox("List Window Header", {RSVP.List.Decoration}) then
        RSVP.List.Decoration = not RSVP.List.Decoration
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles creation window visibility.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.Create_Window_Visibility = function()
    RSVP.Create.Visible[1] = not RSVP.Create.Visible[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles timer list window visibility.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.List_Window_Visibility = function()
    RSVP.List.Visible[1] = not RSVP.List.Visible[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles clock visibility.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.Clock_Visibility = function()
    RSVP.Clock.Visible[1] = not RSVP.Clock.Visible[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles window decoration.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.Decoration = function()

end