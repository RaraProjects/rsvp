List.Buttons = T{}

-- ------------------------------------------------------------------------------------------------------
-- Displays a create new button.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Create_New = function()
    if UI.SmallButton(" + ") then Config.Toggle.Create_Window_Visibility() end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays the mode buttons at the top of the timer list.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Mode_Buttons = function()
    List.Buttons.Create_New()
    UI.SameLine() List.Buttons.Toggle_Group_Mode()
    UI.SameLine() List.Buttons.Toggle_Timestamp()
    UI.SameLine() List.Buttons.Toggle_Filter()
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
-- Shows the toggle group mode button.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Toggle_Group_Mode = function()
    if UI.SmallButton("Group") then RSVP.List.Group_Mode = not RSVP.List.Group_Mode end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the toggle timestamp button.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Toggle_Timestamp = function()
    local caption = "Timer"
    if RSVP.List.Show_Countdown then caption = "Stamp" end
    if UI.SmallButton(caption) then RSVP.List.Show_Countdown = not RSVP.List.Show_Countdown end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the toggle filter button.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.Toggle_Filter = function()
    local caption = "Filt: OFF"
    if RSVP.List.Apply_Filter then caption = "Filt: (" .. tostring(List.Filtered) .. ")" end
    UI.PushID("Filter")
    if UI.SmallButton(caption) then RSVP.List.Apply_Filter = not RSVP.List.Apply_Filter end
end