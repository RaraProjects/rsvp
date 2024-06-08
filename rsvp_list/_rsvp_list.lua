List = T{}

List.Defaults = T{
    X_Pos  = 100,
    Y_Pos  = 100,
    Scale  = 1.0,
    Visible     = {true},
    Report_Mode = true,
    Group_Mode  = true,
    Decoration  = false,
}

List.Window_Flags = bit.bor(ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav, ImGuiWindowFlags_NoBackground)

List.Table_Flags = bit.bor(ImGuiTableFlags_Borders, ImGuiTableFlags_RowBg)

List.ALIAS = "list"
List.Scaling_Set = false
List.Reset_Position = true

require("rsvp_list.buttons")

-- ------------------------------------------------------------------------------------------------------
-- Show the list of reminders.
-- ------------------------------------------------------------------------------------------------------
List.Display = function()
    if RSVP.List.Visible[1] then
        UI.PushStyleColor(ImGuiCol_TableRowBg, Window.Colors.DEFAULT)
        UI.PushStyleColor(ImGuiCol_TableRowBgAlt, Window.Colors.DEFAULT)

        local window_flags = List.Window_Flags
        if not RSVP.List.Decoration then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoDecoration) end
        if List.Reset_Position then
            UI.SetNextWindowPos({RSVP.List.X_Pos, RSVP.List.Y_Pos}, ImGuiCond_Always)
            List.Reset_Position = false
        end

        if UI.Begin("RSVP Timer List", RSVP.List.Visible, window_flags) then
            RSVP.List.X_Pos, RSVP.List.Y_Pos = UI.GetWindowPos()
            List.Set_Window_Scaling()

            if Timers.Count > 0 then
                local columns, show_groups = List.Columns()

                List.Buttons.Mode_Buttons()
                if RSVP.List.Report_Mode then end
                if UI.BeginTable("List", columns, List.Table_Flags) then
                    List.Headers(show_groups)

                    local blocked = T{}
                    local collapsed = T{}
                    for _, timer_data in ipairs(Timers.Sorted) do
                        local name = timer_data[1]
                        local group = Timers.Groups.Get(name)

                        -- Only show the earliest timer from a timer group unless it's expanded.
                        if not group or not blocked[group] or Timers.Groups.Is_Expanded(group) then
                            local timer, color = List.Timer_Color(name)
                            List.Rows(name, timer, color, show_groups, group, collapsed)
                        end

                        -- Block subsequent timers from the same group.
                        if group then
                            blocked[group] = true
                            collapsed[group] = true
                        end
                    end

                    UI.EndTable()
                end
            end

        end
        UI.End()
        UI.PopStyleColor(2)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how many columns should be shown in the active timer list.
-- ------------------------------------------------------------------------------------------------------
---@return integer
---@return boolean
-- ------------------------------------------------------------------------------------------------------
List.Columns = function()
    local show_groups = false
    local columns = 3
    if Timers.Groups.Group_Count() > 0 and RSVP.List.Group_Mode then
        show_groups = true
        columns = columns + 2
    end
    return columns, show_groups
end

-- ------------------------------------------------------------------------------------------------------
-- Sets up the list table headers.
-- ------------------------------------------------------------------------------------------------------
---@param show_groups boolean
-- ------------------------------------------------------------------------------------------------------
List.Headers = function(show_groups)
    local col_flags = bit.bor(ImGuiTableColumnFlags_None)
    UI.TableSetupColumn("Del.",  col_flags)
    UI.TableSetupColumn("Name",  col_flags)
    UI.TableSetupColumn("Time",  col_flags)
    if show_groups and RSVP.List.Group_Mode then
        UI.TableSetupColumn("Exp.", col_flags)
        UI.TableSetupColumn("Del.", col_flags)
    end
    UI.TableHeadersRow()
end

-- ------------------------------------------------------------------------------------------------------
-- Sets up the list table rows.
-- ------------------------------------------------------------------------------------------------------
---@param name string           timer name
---@param timer string          formatted timer string
---@param color table           timer color
---@param show_groups boolean   if the row involves a timer group show extra columns
---@param group string|nil      the name of the group (if applicable)
---@param collapsed table       tracks which groups are collapsed/expanded
-- ------------------------------------------------------------------------------------------------------
List.Rows = function(name, timer, color, show_groups, group, collapsed)
    UI.TableNextRow()
    UI.TableNextColumn() List.Buttons.Delete_Timer(name)
    UI.TableNextColumn() UI.Text(tostring(name))
    UI.TableNextColumn() UI.TextColored(color, timer)
    if show_groups and group and RSVP.List.Group_Mode then
        UI.TableNextColumn() if not collapsed[group] then List.Buttons.Set_Group_Expansion(group) end
        if not collapsed[group] then UI.TableNextColumn() List.Buttons.Delete_Group(group) end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the timer color.
-- ------------------------------------------------------------------------------------------------------
---@param name string
---@return string
---@return table
-- ------------------------------------------------------------------------------------------------------
List.Timer_Color = function(name)
    local timer, time, negative = Timers.Check(name, true)
    local color = Window.Colors.WHITE
    if negative then
        color = Window.Colors.RED
    else
        if time < 15 then color = Window.Colors.YELLOW end
    end
    return timer, color
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether the window scaling needs to be updated.
-- ------------------------------------------------------------------------------------------------------
List.Is_Scaling_Set = function()
    return List.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
List.Set_Scaling_Flag = function(scaling)
    List.Scaling_Set = scaling
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
List.Set_Window_Scaling = function()
    if not List.Is_Scaling_Set() then
        UI.SetWindowFontScale(Config.Get_Scale())
        List.Set_Scaling_Flag(true)
    end
end