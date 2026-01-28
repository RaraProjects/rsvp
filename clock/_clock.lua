Clock = { }

Clock.Defaults = T{
    X_Pos   = 100,
    Y_Pos   = 100,
    Visible = { true },
}

Clock.Window_Flags = bit.bor(
    ImGuiWindowFlags_NoDecoration,
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav,
    ImGuiWindowFlags_NoBackground
)

Clock.Table_Flags = bit.bor(
    ImGuiTableFlags_PadOuterX,
    ImGuiTableFlags_Borders,
    ImGuiTableFlags_NoHostExtendX,
    ImGuiTableFlags_RowBg
)

Clock.ALIAS          = 'clock'
Clock.Scaling_Set    = false
Clock.Reset_Position = true

-- ------------------------------------------------------------------------------------------------------
-- Show the clock.
-- ------------------------------------------------------------------------------------------------------
Clock.Display = function()
    if RSVP.Clock.Visible[1] then
        if Clock.Reset_Position then
            UI.SetNextWindowPos({RSVP.Clock.X_Pos, RSVP.Clock.Y_Pos}, ImGuiCond_Always)
            Clock.Reset_Position = false
        end

        UI.PushStyleColor(ImGuiCol_TableRowBg, Window.Colors.BLACK)
        Window.SetScaling()

        if UI.Begin('Clock', RSVP.Clock.Visible, Clock.Window_Flags) then
            RSVP.Clock.X_Pos, RSVP.Clock.Y_Pos = UI.GetWindowPos()
            Window.SetLegacyScaling()

            if UI.BeginTable('Clock', 1, Clock.Table_Flags) then
                local now = os.time()

                UI.TableNextColumn() UI.Text(os.date('%X', now))
                UI.EndTable()
            end

            Window.SetLegacyScaling(Config.GetScale())
            UI.End()
        end

        Window.SetScaling(Config.GetScale())
        UI.PopStyleColor(1)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
Clock.SetScalingFlag = function(scaling)
    Clock.Scaling_Set = scaling
end
