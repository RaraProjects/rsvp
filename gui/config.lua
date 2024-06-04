Config = T{}

-- ------------------------------------------------------------------------------------------------------
-- Displays the configuration window.
-- ------------------------------------------------------------------------------------------------------
Config.Display = function()
    if UI.Begin("Config", true, Window.Window_Flags) then
        UI.Text("Text Commands")
        UI.Text("Toggle Decoration")
        UI.Text("Toggle Preview Alert")
        UI.Text("Font Scaling")
    end
    UI.End()
end