Create.Buttons = T{}

Create.Buttons.Type = T{
    Normal = 1,
    King   = 2,
    Wyrm   = 3,
    Custom = 4,
}

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
---@param pass boolean
---@param minutes? number number of minutes in the future to set the timer.
---@param caption? string name of the button the user will click to create this timer (quick button).
-- ------------------------------------------------------------------------------------------------------
Create.Buttons.Minute = function(pass, minutes, caption)
    if not minutes then minutes = 0 end
    local button_name = string.format("%3s", tostring(minutes))
    if caption then button_name = caption end

    if not pass then
        UI.PushStyleColor(ImGuiCol_Button, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Window.Colors.INACTIVE)
    end
    if UI.Button(button_name) then
        if pass then
            if minutes == 0 then return nil end
            local timer_name = Inputs.Get_Name()
            if timer_name == "" then timer_name = tostring(os.date("%X", os.time() + (minutes * 60))) end
            Timers.Start(timer_name, minutes)
        end
    end
    if not pass then UI.PopStyleColor(3) end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
---@param type integer
---@param pass boolean
---@param name string
---@param date table
---@param time table
---@param custom_info? table
-- ------------------------------------------------------------------------------------------------------
Create.Buttons.Schedule = function(type, pass, name, date, time, custom_info)
    if not pass then
        UI.PushStyleColor(ImGuiCol_Button, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive, Window.Colors.INACTIVE)
    end

    if type == Create.Buttons.Type.Normal then
        if UI.Button("Create") then
            if pass then
                local timestamp  = Timers.Make_Time_Table(date, time)
                local future_minutes = (timestamp - os.time()) / 60
                Timers.Start(name, future_minutes)
            end
        end

    elseif type == Create.Buttons.Type.King then
        if UI.Button("10M7") then
            if pass then
                local timestamp = Timers.Make_Time_Table(date, time)
                local future_minutes = (timestamp - os.time()) / 60
                for i = 0, 6, 1 do
                    local timer_name = name .. " (" .. tostring(i + 1) .. "/7)"
                    Timers.Start(timer_name, future_minutes + (10 * i), name)
                end
            end
        end

    elseif type == Create.Buttons.Type.Wyrm then
        if UI.Button("1H25") then
            if pass then
                local timestamp = Timers.Make_Time_Table(date, time)
                local future_minutes = (timestamp - os.time()) / 60
                for i = 0, 24, 1 do
                    local timer_name = name .. " (" .. tostring(i + 1) .. "/25)"
                    Timers.Start(timer_name, future_minutes + (60 * i), name)
                end
            end
        end

    elseif type == Create.Buttons.Type.Custom then
        if UI.Button("Create Custom") then
            if pass and custom_info then
                local timestamp  = Timers.Make_Time_Table(date, time)
                local future_minutes = (timestamp - os.time()) / 60
                for i = 0, custom_info.count, 1 do
                    local timer_name = name .. " (" .. tostring(i + 1) .. "/" .. tostring(custom_info.count + 1) .. ")"
                    Timers.Start(timer_name, future_minutes + (custom_info.gap * i), name)
                end
            end
        end
    end

    if not pass then UI.PopStyleColor(3) end
end