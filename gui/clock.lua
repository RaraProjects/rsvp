Clock = T{}

Clock.Defaults = T{
    Width  = 700,
    Height = 10,
    X_Pos  = 100,
    Y_Pos  = 100,
}

Clock.Visible = true

Clock.Window_Flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav, ImGuiWindowFlags_NoBackground)

Clock.Table_Flags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders,
ImGuiTableFlags_NoHostExtendX, ImGuiTableFlags_RowBg)

-- ------------------------------------------------------------------------------------------------------
-- Initializes the clock window.
-- ------------------------------------------------------------------------------------------------------
Clock.Initialize = function()
    UI.SetNextWindowPos({RSVP.Settings.Clock.X_Pos, RSVP.Settings.Clock.Y_Pos}, ImGuiCond_Always)
    Clock.Display()
end

-- ------------------------------------------------------------------------------------------------------
-- Show the clock.
-- ------------------------------------------------------------------------------------------------------
Clock.Display = function()
    if Clock.Visible then
        UI.PushStyleColor(ImGuiCol_TableRowBg, Window.Colors.BLACK)
        if UI.Begin("Clock", true, Clock.Window_Flags) then
            RSVP.Settings.Clock.X_Pos, RSVP.Settings.Clock.Y_Pos = UI.GetWindowPos()

            if UI.BeginTable("Clock", 1, Clock.Table_Flags) then
                local now = os.time()
                UI.TableNextColumn() UI.Text(os.date("%X %p", now))
                UI.EndTable()
            end
        end
        UI.End()
        UI.PopStyleColor(1)
    end
end