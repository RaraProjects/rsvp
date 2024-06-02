List = T{}

List.Defaults = T{
    Width  = 700,
    Height = 10,
    X_Pos  = 100,
    Y_Pos  = 100,
}

List.Visible = true

List.Window_Flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav, ImGuiWindowFlags_NoBackground)

List.Table_Flags = bit.bor(ImGuiTableFlags_Resizable, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders,
ImGuiTableFlags_NoHostExtendX, ImGuiTableFlags_RowBg)

-- ------------------------------------------------------------------------------------------------------
-- Initializes the clock window.
-- ------------------------------------------------------------------------------------------------------
List.Initialize = function()
    UI.SetNextWindowPos({RSVP.Settings.List.X_Pos, RSVP.Settings.List.Y_Pos}, ImGuiCond_Always)
    List.Display()
end

-- ------------------------------------------------------------------------------------------------------
-- Show the list of reminders.
-- ------------------------------------------------------------------------------------------------------
List.Display = function()
    if List.Visible then
        UI.PushStyleColor(ImGuiCol_TableRowBg, Window.Colors.DEFAULT)
        UI.PushStyleColor(ImGuiCol_TableRowBgAlt, Window.Colors.DEFAULT)

        if UI.Begin("List", true, List.Window_Flags) then
            RSVP.Settings.List.X_Pos, RSVP.Settings.List.Y_Pos = UI.GetWindowPos()

            local col_flags = bit.bor(ImGuiTableColumnFlags_None)
            if UI.BeginTable("List", 3, List.Table_Flags) then
                UI.TableSetupColumn("Del.", col_flags)
                UI.TableSetupColumn("Timer Name", col_flags, 80)
                UI.TableSetupColumn("Countdown", col_flags, 70)
                UI.TableHeadersRow()

                for name, _ in pairs(Timers.Timers) do
                    UI.TableNextRow()

                    local timer, time, negative = Timers.Check(name, true)
                    local color = Window.Colors.WHITE
                    if negative then
                        color = Window.Colors.RED
                    else
                        if time < 15 then
                            color = Window.Colors.YELLOW
                        end
                    end

                    UI.TableNextColumn() List.Delete_Timer(name)
                    UI.TableNextColumn() UI.Text(tostring(name))
                    UI.TableNextColumn() UI.TextColored(color, timer)
                end
                UI.EndTable()
            end
        end
        UI.End()

        UI.PopStyleColor(2)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the delete comment button.
-- ------------------------------------------------------------------------------------------------------
---@param timer_name string
-- ------------------------------------------------------------------------------------------------------
List.Delete_Timer = function(timer_name)
    local clicked = 0
    UI.PushID(timer_name)
    if UI.Button(" X ") then
        clicked = 1
        if clicked and 1 then
            Timers.End(timer_name)
        end
    end
    UI.PopID()
end