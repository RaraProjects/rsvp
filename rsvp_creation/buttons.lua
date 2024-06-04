Reminder.Buttons = T{}

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
---@param minutes? number number of minutes in the future to set the timer.
---@param caption? string name of the button the user will click to create this timer (quick button).
-- ------------------------------------------------------------------------------------------------------
Reminder.Buttons.Minute = function(minutes, caption)
    if not minutes then minutes = 0 end
    local clicked = 0
    local button_name = string.format("%2d", minutes)
    if caption then button_name = caption end

    if UI.Button(button_name) then
        clicked = 1
        if minutes == 0 then return nil end
        if clicked and 1 then
            local timer_name = Inputs.Buffers.Name[1]
            if string.len(timer_name) == 0 then timer_name = tostring(os.date("%H:%M:%S", os.time())) .. " (" .. tostring(minutes) .. ")" end
            Timers.Start(timer_name, minutes)
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
Reminder.Buttons.Schedule = function()
    local clicked = 0
    if UI.Button("Create") then
        clicked = 1
        if clicked and 1 then
            local new_instant = Reminder.Handle_Date_Input()
            local future_minutes = (new_instant - os.time()) / 60

            -- Default the name to the time the timer was set if no name is provided.
            local timer_name = Inputs.Name()
            if string.len(timer_name) == 0 then timer_name = tostring(os.date("%H:%M:%S", new_instant)) end

            Timers.Start(timer_name, future_minutes)
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a seven alerts 10 minutes apart from the start time.
-- ------------------------------------------------------------------------------------------------------
Reminder.Buttons.Kings = function()
    local clicked = 0
    if UI.Button("10M7") then
        clicked = 1
        if clicked and 1 then
            local start_time = Reminder.Handle_Date_Input()
            local future_minutes = (start_time - os.time()) / 60
            local timer_name = Inputs.Name()
            if string.len(timer_name) == 0 then timer_name = tostring(os.date("%H:%M:%S", os.time())) end
            for i = 0, 6, 1 do
                local name = timer_name .. " (" .. tostring(i + 1) .. "/7)"
                Timers.Start(name, future_minutes + (10 * i), timer_name)
            end
        end
    end
end