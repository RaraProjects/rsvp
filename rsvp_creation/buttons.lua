Create.Buttons = { }

Create.Buttons.Type =
{
    Normal = 1,
    King   = 2,
    Wyrm   = 3,
    Custom = 4,
}

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
---@param pass     boolean
---@param minutes? number number of minutes in the future to set the timer.
---@param caption? string name of the button the user will click to create this timer (quick button).
-- ------------------------------------------------------------------------------------------------------
Create.Buttons.Minute = function(pass, minutes, caption)
    minutes = minutes or 0

    local buttonName = caption or string.format('%3s', minutes)

    if not pass then
        UI.PushStyleColor(ImGuiCol_Button,        Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive,  Window.Colors.INACTIVE)
    end

    if UI.Button(buttonName) then
        if pass then
            if minutes == 0 then
                return nil
            end

            local timerName = Inputs.GetName()

            if timerName == '' then
                timerName = tostring(os.date('%X', os.time() + (minutes * 60)))
            end

            Timers.Start(timerName, minutes)
        end
    end

    if not pass then
        UI.PopStyleColor(3)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
---@param type        integer
---@param pass        boolean
---@param name        string
---@param date        table
---@param time        table
---@param customInfo? table
-- ------------------------------------------------------------------------------------------------------
Create.Buttons.Schedule = function(type, pass, name, date, time, customInfo)
    if not pass then
        UI.PushStyleColor(ImGuiCol_Button,        Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonHovered, Window.Colors.INACTIVE)
        UI.PushStyleColor(ImGuiCol_ButtonActive,  Window.Colors.INACTIVE)
    end

    if type == Create.Buttons.Type.Normal then
        if UI.Button('Create') then
            if pass then
                local timestamp     = Timers.MakeTimeTable(date, time)
                local futureMinutes = (timestamp - os.time()) / 60

                Timers.Start(name, futureMinutes)
            end
        end

    elseif type == Create.Buttons.Type.King then
        if UI.Button('10M7') then
            if pass then
                local timestamp     = Timers.MakeTimeTable(date, time)
                local futureMinutes = (timestamp - os.time()) / 60

                for i = 0, 6, 1 do
                    local timerName = string.format("%s (%d/7)", name, i + 1)

                    Timers.Start(timerName, futureMinutes + (10 * i), name)
                end
            end
        end

    elseif type == Create.Buttons.Type.Wyrm then
        if UI.Button('1H25') then
            if pass then
                local timestamp     = Timers.MakeTimeTable(date, time)
                local futureMinutes = (timestamp - os.time()) / 60

                for i = 0, 24, 1 do
                    local timerName = string.format("%s (%d/25)", name, i + 1)

                    Timers.Start(timerName, futureMinutes + (60 * i), name)
                end
            end
        end

    elseif type == Create.Buttons.Type.Custom then
        if UI.Button('Create Custom') then
            if pass and customInfo then
                local timestamp     = Timers.MakeTimeTable(date, time)
                local futureMinutes = (timestamp - os.time()) / 60

                for i = 0, customInfo.count, 1 do
                    local timerName = string.format("%s (%d/%d)", name, i + 1, customInfo.count + 1)

                    Timers.Start(timerName, futureMinutes + (customInfo.gap * i), name)
                end
            end
        end
    end

    if not pass then
        UI.PopStyleColor(3)
    end
end