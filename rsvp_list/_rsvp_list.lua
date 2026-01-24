List = { }

List.Defaults = T{
    X_Pos  = 100,
    Y_Pos  = 100,
    Scale  = 1.0,
    Visible          = { true },
    Group_Mode       = true,
    Decoration       = false,
    Apply_Filter     = true,
    Hour_Filter      = 2,
    Show_Countdown   = true,
    Auto_Clear       = false,
    Auto_Clear_Delay = 30,
}

List.Window_Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav,
    ImGuiWindowFlags_NoBackground
)

List.Table_Flags = bit.bor(
    ImGuiTableFlags_Borders,
    ImGuiTableFlags_RowBg
)

List.ALIAS          = 'list'
List.Filtered       = 0
List.Scaling_Set    = false
List.Reset_Position = true

require('rsvp_list.buttons')

-- ------------------------------------------------------------------------------------------------------
-- Returns how many columns should be shown in the active timer list.
-- ------------------------------------------------------------------------------------------------------
---@return integer
---@return boolean
-- ------------------------------------------------------------------------------------------------------
local columns = function()
    local showGroups = false
    local columns    = 3

    if Timers.Groups.GroupCount() > 0 and RSVP.List.Group_Mode then
        showGroups = true
        columns    = columns + 2
    end

    return columns, showGroups
end

-- ------------------------------------------------------------------------------------------------------
-- Sets up the list table headers.
-- ------------------------------------------------------------------------------------------------------
---@param showGroups boolean
-- ------------------------------------------------------------------------------------------------------
local tableHeaders = function(showGroups)
    local colFlags = bit.bor(ImGuiTableColumnFlags_None)

    UI.TableSetupColumn('Del.',  colFlags)
    UI.TableSetupColumn('Name',  colFlags)
    UI.TableSetupColumn('Time',  colFlags)

    if showGroups and RSVP.List.Group_Mode then
        UI.TableSetupColumn('Exp.', colFlags)
        UI.TableSetupColumn('Del.', colFlags)
    end

    UI.TableHeadersRow()
end

-- ------------------------------------------------------------------------------------------------------
-- Sets up the list table rows.
-- ------------------------------------------------------------------------------------------------------
---@param name       string        timer name
---@param timer      string|osdate formatted timer string
---@param color      table         timer color
---@param showGroups boolean       if the row involves a timer group show extra columns
---@param group      string|nil    the name of the group (if applicable)
---@param collapsed  table         tracks which groups are collapsed/expanded
-- ------------------------------------------------------------------------------------------------------
local tableRows = function(name, timer, color, showGroups, group, collapsed)
    UI.TableNextRow()
    UI.TableNextColumn() List.Buttons.DeleteTimer(name)
    UI.TableNextColumn() UI.Text(tostring(name))
    UI.TableNextColumn() UI.TextColored(color, timer)

    if showGroups and group and RSVP.List.Group_Mode then
        UI.TableNextColumn()

        if not collapsed[group] then
            List.Buttons.SetGroupExpansion(group)
        end

        if not collapsed[group] then
            UI.TableNextColumn() List.Buttons.DeleteGroup(group)
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the timer color.
-- ------------------------------------------------------------------------------------------------------
---@param name string
---@return string|osdate, table
-- ------------------------------------------------------------------------------------------------------
local timerColor = function(name)
    local timer, time, negative = Timers.Check(name, true)
    local color = Window.Colors.WHITE

    if negative then
        color = Window.Colors.RED
    else
        if time < 15 then
            color = Window.Colors.YELLOW
        end
    end

    return timer, color
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
local setWindowScaling = function()
    if not List.Scaling_Set then
        UI.SetWindowFontScale(Config.GetScale())
        List.SetScalingFlag(true)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Show the list of reminders.
-- ------------------------------------------------------------------------------------------------------
List.Display = function()
    if RSVP.List.Visible[1] then
        UI.PushStyleColor(ImGuiCol_TableRowBg,    Window.Colors.DEFAULT)
        UI.PushStyleColor(ImGuiCol_TableRowBgAlt, Window.Colors.DEFAULT)

        local windowFlags = List.Window_Flags

        if not RSVP.List.Decoration then
            windowFlags = bit.bor(windowFlags, ImGuiWindowFlags_NoDecoration)
        end

        if List.Reset_Position then
            UI.SetNextWindowPos({ RSVP.List.X_Pos, RSVP.List.Y_Pos }, ImGuiCond_Always)
            List.Reset_Position = false
        end

        if UI.Begin('RSVP Timer List', RSVP.List.Visible, windowFlags) then
            RSVP.List.X_Pos, RSVP.List.Y_Pos = UI.GetWindowPos()
            setWindowScaling()

            local filteredTimers = 0

            List.Buttons.ModeButtons()
            if Timers.Count > 0 then
                local columns, showGroups = columns()
                local shownTimers = 0

                if UI.BeginTable('List', columns, List.Table_Flags) then
                    tableHeaders(showGroups)

                    local blocked   = { }
                    local collapsed = { }
                    local now       = os.time()

                    for _, timerData in ipairs(Timers.Sorted) do
                        local name  = timerData[1]
                        local group = Timers.Groups.Get(name)

                        -- Filter and auto-clear setup.
                        local endTime  = timerData[2]
                        local duration = endTime - now

                        if RSVP.List.Auto_Clear and duration < (RSVP.List.Auto_Clear_Delay * -1) then
                            Timers.End(name)
                        end

                        if not RSVP.List.Apply_Filter then
                            duration = 0
                        end -- Show everything.

                        -- Only show the earliest timer from a timer group (unless it's expanded) within filter time.
                        if duration < (RSVP.List.Hour_Filter * 3600) then
                            if not group or not blocked[group] or Timers.Groups.IsExpanded(group) then
                                shownTimers = shownTimers + 1

                                local timer, color = timerColor(name)

                                tableRows(name, timer, color, showGroups, group, collapsed)
                            end
                        else
                            if not group or (group and not blocked[group]) then
                                filteredTimers = filteredTimers + 1
                            end
                        end

                        -- Block subsequent timers from the same group.
                        if group then
                            blocked[group] = true
                            collapsed[group] = true
                        end
                    end

                    UI.EndTable()

                    if shownTimers == 0 then
                        UI.Text('No timers to show.')
                    end
                end

                List.Filtered = filteredTimers
            else
                UI.Text('No timers set.')
            end
        end

        UI.End()
        UI.PopStyleColor(2)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
List.SetScalingFlag = function(scaling)
    List.Scaling_Set = scaling
end
