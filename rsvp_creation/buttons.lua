Create.Buttons = T{}

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
---@param minutes? number number of minutes in the future to set the timer.
---@param caption? string name of the button the user will click to create this timer (quick button).
-- ------------------------------------------------------------------------------------------------------
Create.Buttons.Minute = function(minutes, caption)
    local inactive = false
    local error = Timers.Validate()
    if error ~= Timers.Errors.NO_ERROR then inactive = true end

    if not minutes then minutes = 0 end
    local button_name = string.format("%2d", minutes)
    if caption then button_name = caption end

    if inactive then
        UI.PushStyleColor(ImGuiCol_Button, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Window.Colors.INACTIVE)
    end
    if UI.Button(button_name) then
        local timer_name = Inputs.Name()
        if minutes == 0 then return nil end
        if not inactive then Timers.Start(timer_name, minutes) end
    end
    if inactive then UI.PopStyleColor(3) end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
Create.Buttons.Schedule = function()
    local inactive = false
    local error = Timers.Validate()
    if error ~= Timers.Errors.NO_ERROR then inactive = true end

    if inactive then
        UI.PushStyleColor(ImGuiCol_Button, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Window.Colors.INACTIVE)
    end
    if UI.Button("Create") then
        local timer_name = Inputs.Name()
        local new_instant = Create.Handle_Date_Input()
        local future_minutes = (new_instant - os.time()) / 60
        if not inactive then Timers.Start(timer_name, future_minutes) end
    end
    if inactive then UI.PopStyleColor(3) end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a seven alerts 10 minutes apart from the start time.
-- ------------------------------------------------------------------------------------------------------
Create.Buttons.Kings = function()
    local inactive = false
    local error = Timers.Validate()
    if error ~= Timers.Errors.NO_ERROR then inactive = true end

    if inactive then
        UI.PushStyleColor(ImGuiCol_Button, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Window.Colors.INACTIVE)
    end
    if UI.Button("10M7") then
        local timer_name = Inputs.Name()
        local start_time = Create.Handle_Date_Input()
        local future_minutes = (start_time - os.time()) / 60
        for i = 0, 6, 1 do
            local name = timer_name .. " (" .. tostring(i + 1) .. "/7)"
            Timers.Start(name, future_minutes + (10 * i), timer_name)
        end
    end
    if inactive then UI.PopStyleColor(3) end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a seven alerts 10 minutes apart from the start time.
-- ------------------------------------------------------------------------------------------------------
Create.Buttons.Wyrms = function()
    local inactive = false
    local error = Timers.Validate()
    if error ~= Timers.Errors.NO_ERROR then inactive = true end

    if inactive then
        UI.PushStyleColor(ImGuiCol_Button, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Window.Colors.INACTIVE)
    end
    if UI.Button("1H25") then
        local timer_name = Inputs.Name()
        local start_time = Create.Handle_Date_Input()
        local future_minutes = (start_time - os.time()) / 60
        for i = 0, 24, 1 do
            local name = timer_name .. " (" .. tostring(i + 1) .. "/25)"
            Timers.Start(name, future_minutes + (60 * i), timer_name)
        end
    end
    if inactive then UI.PopStyleColor(3) end
end