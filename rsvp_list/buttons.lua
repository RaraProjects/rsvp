List.Buttons = T{}

-- ------------------------------------------------------------------------------------------------------
-- Displays the mode buttons at the top of the timer list.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Mode_Buttons = function()
    List.Buttons.Toggle_Group_Mode() UI.SameLine() List.Buttons.Toggle_Report_Mode()
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the delete comment button.
-- ------------------------------------------------------------------------------------------------------
---@param timer_name string
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Delete_Timer = function(timer_name)
    if not timer_name then return nil end
    UI.PushID(timer_name)
    if UI.Button(" X ") then Timers.End(timer_name) end
    UI.PopID()
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the report timer button.
-- ------------------------------------------------------------------------------------------------------
---@param timer_name string
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Report_Timer = function(timer_name)
    if not timer_name then return nil end
    UI.PushID(timer_name)
    if UI.Button(" R ") then Timers.Report(timer_name) end
    UI.PopID()
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles visibility of non-first timers in a group.
-- ------------------------------------------------------------------------------------------------------
---@param group string
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Set_Group_Expansion = function(group)
    if not group then return nil end
    local caption = " + "
    local expanded = Timers.Groups.Is_Expanded(group)
    if expanded then caption = " - " end

    UI.PushID(group)
    if UI.Button(caption) then
        if expanded then
            Timers.Groups.Collapse(group)
        else
            Timers.Groups.Expand(group)
        end
    end
    UI.PopID()
end

-- ------------------------------------------------------------------------------------------------------
-- Deletes a timer group.
-- ------------------------------------------------------------------------------------------------------
---@param group string
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Delete_Group = function(group)
    if not group then return nil end
    UI.PushID(group)
    if UI.Button(" X ") then Timers.Groups.Delete(group) end
    UI.PopID()
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the toggle delete button.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Toggle_Group_Mode = function()
    if UI.Button("Group Mode") then List.Group_Mode = not List.Group_Mode end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the enable report button.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Toggle_Report_Mode = function()
    if UI.Button("Report Mode") then List.Report_Mode = not List.Report_Mode end
end