List.Buttons = { }

-- ------------------------------------------------------------------------------------------------------
-- Displays a create new button.
-- ------------------------------------------------------------------------------------------------------
local createNew = function()
    if UI.SmallButton(' + ') then
        Config.Toggle.CreateWindowVisibility()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the toggle group mode button.
-- ------------------------------------------------------------------------------------------------------
local toggleGroupMode = function()
    if UI.SmallButton('Group') then
        RSVP.List.Group_Mode = not RSVP.List.Group_Mode
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the toggle timestamp button.
-- ------------------------------------------------------------------------------------------------------
local toggleTimestamp = function()
    local caption = 'Timer'

    if RSVP.List.Show_Countdown then
        caption = 'Stamp'
    end

    if UI.SmallButton(caption) then
        RSVP.List.Show_Countdown = not RSVP.List.Show_Countdown
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the toggle filter button.
-- ------------------------------------------------------------------------------------------------------
local toggleFilter = function()
    local caption = 'Filt: OFF'

    if RSVP.List.Apply_Filter then
        caption = string.format('Filt: (%d)', List.Filtered)
    end

    UI.PushID('Filter')

    if UI.SmallButton(caption) then
        RSVP.List.Apply_Filter = not RSVP.List.Apply_Filter
    end

    UI.PopID()
end

-- ------------------------------------------------------------------------------------------------------
-- Displays the mode buttons at the top of the timer list.
-- ------------------------------------------------------------------------------------------------------
List.Buttons.ModeButtons = function()
    createNew()
    UI.SameLine() toggleGroupMode()
    UI.SameLine() toggleTimestamp()
    UI.SameLine() toggleFilter()
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the delete comment button.
-- ------------------------------------------------------------------------------------------------------
---@param timerName string
-- ------------------------------------------------------------------------------------------------------
List.Buttons.DeleteTimer = function(timerName)
    if not timerName then
        return nil
    end

    UI.PushID(timerName)

    if UI.Button(' X ') then
        Timers.End(timerName)
    end

    UI.PopID()
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles visibility of non-first timers in a group.
-- ------------------------------------------------------------------------------------------------------
---@param group string
-- ------------------------------------------------------------------------------------------------------
List.Buttons.SetGroupExpansion = function(group)
    if not group then
        return nil
    end

    local caption  = ' + '
    local expanded = Timers.Groups.IsExpanded(group)

    if expanded then
        caption = ' - '
    end

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
List.Buttons.DeleteGroup = function(group)
    if not group then
        return nil
    end

    UI.PushID(group)

    if UI.Button(' X ') then
        Timers.Groups.Delete(group)
    end

    UI.PopID()
end
