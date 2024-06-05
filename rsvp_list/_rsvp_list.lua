List = T{}

List.Defaults = T{
    Width  = 700,
    Height = 10,
    X_Pos  = 100,
    Y_Pos  = 100,
}

List.Visible = true
List.Report_Mode = false
List.Group_Mode  = true

List.Window_Flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav, ImGuiWindowFlags_NoBackground)

List.Table_Flags = bit.bor(ImGuiTableFlags_Borders, ImGuiTableFlags_RowBg)

require("rsvp_list.buttons")
require("rsvp_list.publishing")

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

            if Timers.Count > 0 then
                local columns, show_groups = List.Columns()

                List.Buttons.Mode_Buttons()
                if List.Report_Mode then List.Publishing.Chat_Selection() end
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
    if List.Report_Mode then columns = columns + 1 end
    if Timers.Groups.Group_Count() > 0 and List.Group_Mode then
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
    if List.Report_Mode then UI.TableSetupColumn("Rep.",  col_flags) end
    if show_groups and List.Group_Mode then
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
    if List.Report_Mode then UI.TableNextColumn() List.Buttons.Report_Timer(name) end
    if show_groups and group and List.Group_Mode then
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