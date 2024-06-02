Reminder = T{}

Reminder.Defaults = T{
    Width  = 700,
    Height = 10,
    X_Pos  = 100,
    Y_Pos  = 100,
}

Reminder.Buffers = T{
    Name    = T{},
    Minutes = T{},
    Year    = T{},
    Month   = T{},
    Day     = T{},
    Hour    = T{[1] = tostring(0)},
    Minute  = T{[1] = tostring(0)},
    Second  = T{[1] = tostring(0)},
}

Reminder.Visible = true

Reminder.Table_Flags = bit.bor(ImGuiTableFlags_Resizable, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_NoHostExtendX)

-- ------------------------------------------------------------------------------------------------------
-- Initializes the clock window.
-- ------------------------------------------------------------------------------------------------------
Reminder.Initialize = function()
    UI.SetNextWindowPos({RSVP.Settings.Reminder.X_Pos, RSVP.Settings.Reminder.Y_Pos}, ImGuiCond_Always)
    Reminder.Display()
end

-- ------------------------------------------------------------------------------------------------------
-- Show the reminder window.
-- ------------------------------------------------------------------------------------------------------
Reminder.Display = function()
    if Reminder.Visible then
        local flags = Window.Flags
        UI.PushStyleColor(ImGuiCol_WindowBg, Window.Colors.DEFAULT)
        if UI.Begin("Reminder", true, flags) then
            RSVP.Settings.Reminder.X_Pos, RSVP.Settings.Reminder.Y_Pos = UI.GetWindowPos()

            UI.SetNextItemWidth(150)
            UI.InputText("Name", Reminder.Buffers.Name, 100)

            if UI.BeginTabBar("Reminder Types", Window.Tabs.Flags) then
                Reminder.Create_Minute_Timer()
                Reminder.Create_Future_Timer()
                UI.EndTabBar()
            end
        end
        UI.End()
        UI.PopStyleColor(1)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays screen elements to make a tiemr set for {minutes} in the future.
-- ------------------------------------------------------------------------------------------------------
Reminder.Create_Minute_Timer = function()
    if UI.BeginTabItem("Minutes", Window.Tabs.Flags) then
        UI.SetNextItemWidth(50)
        UI.InputText("Minutes", Reminder.Buffers.Minutes, 4)
        UI.SameLine() UI.Text(" ") UI.SameLine() Reminder.Minute_Button(tonumber(Reminder.Buffers.Minutes[1]), "Create")

        if UI.BeginTable("Buttons", 4, Reminder.Table_Flags) then
            UI.TableNextColumn() Reminder.Minute_Button(5)
            UI.TableNextColumn() Reminder.Minute_Button(7)
            UI.TableNextColumn() Reminder.Minute_Button(10)
            UI.TableNextColumn() Reminder.Minute_Button(15)
            UI.TableNextColumn() Reminder.Minute_Button(16)
            UI.TableNextColumn() Reminder.Minute_Button(30)
            UI.TableNextColumn() Reminder.Minute_Button(60)
            UI.EndTable()
        end
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays screen elements to make a timer set for a specific time in the future.
-- ------------------------------------------------------------------------------------------------------
Reminder.Create_Future_Timer = function()
    if UI.BeginTabItem("Time", Window.Tabs.Flags) then

        UI.SetNextItemWidth(50) UI.InputText("Hour   (0-24)", Reminder.Buffers.Hour, 3)
        UI.SetNextItemWidth(50) UI.InputText("Minute (0-60)", Reminder.Buffers.Minute, 3)
        UI.SetNextItemWidth(50) UI.InputText("Second (0-60)", Reminder.Buffers.Second, 3)
        UI.Separator()
        UI.SetNextItemWidth(50) UI.InputText("Year   (YYYY)", Reminder.Buffers.Year, 5) Reminder.Date_Help()
        UI.SetNextItemWidth(50) UI.InputText("Month  (0-12)", Reminder.Buffers.Month, 3) Reminder.Date_Help()
        UI.SetNextItemWidth(50) UI.InputText("Day    (0-31)", Reminder.Buffers.Day, 3) Reminder.Date_Help()

        if string.len(Reminder.Buffers.Hour[1]) == 0 then Reminder.Buffers.Hour[1] = tostring(0) end
        if string.len(Reminder.Buffers.Minute[1]) == 0 then Reminder.Buffers.Minute[1] = tostring(0) end
        if string.len(Reminder.Buffers.Second[1]) == 0 then Reminder.Buffers.Second[1] = tostring(0) end

        Reminder.Future_Button()
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
---@param minutes? number number of minutes in the future to set the timer.
---@param caption? string name of the button the user will click to create this timer (quick button).
-- ------------------------------------------------------------------------------------------------------
Reminder.Minute_Button = function(minutes, caption)
    if not minutes then minutes = 0 end
    local clicked = 0
    local button_name = string.format("%2d", minutes)
    if caption then button_name = caption end
    if UI.Button(button_name) then
        clicked = 1
        if minutes == 0 then return nil end
        if clicked and 1 then
            local timer_name = Reminder.Buffers.Name[1]
            if string.len(timer_name) == 0 then timer_name = tostring(os.date("%H:%M", os.time())) .. " (" .. tostring(minutes) .. ")" end
            Timers.Start(timer_name, minutes)
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
Reminder.Future_Button = function()
    local clicked = 0
    if UI.Button("Create") then
        clicked = 1
        if clicked and 1 then
            local new_instant = Reminder.Handle_Date_Input()
            local future_minutes = (new_instant - os.time()) / 60

            local timer_name = tostring(Reminder.Buffers.Name[1])
            if string.len(timer_name) == 0 then timer_name = tostring(os.date("%H:%M:%S", new_instant)) end

            Timers.Start(timer_name, future_minutes)

            Reminder.Buffers.Year[1] = T{}
            Reminder.Buffers.Month[1] = T{}
            Reminder.Buffers.Day[1] = T{}
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Handles date input to get a final instant for the timer.
-- ------------------------------------------------------------------------------------------------------
Reminder.Handle_Date_Input = function()
    local year   = tonumber(Reminder.Buffers.Year[1])
    local month  = tonumber(Reminder.Buffers.Month[1])
    local day    = tonumber(Reminder.Buffers.Day[1])
    local hour   = tonumber(Reminder.Buffers.Hour[1])
    local minute = tonumber(Reminder.Buffers.Minute[1])
    local second = tonumber(Reminder.Buffers.Second[1])

    -- Not having year, month, or day is okay.
    if not hour or not minute or not second then return nil end
    if hour < 0 or hour > 24 then hour = 0 end
    if minute < 0 or minute > 60 then minute = 0 end
    if second < 0 or second > 60 then second = 0 end

    local now = os.time()
    local now_table = os.date("*t", now)
    local new_instant = now

    -- If a date was entered then try to set to that time even if it was in the past.
    if string.len(Reminder.Buffers.Year[1]) > 0 or string.len(Reminder.Buffers.Month[1]) > 0 or string.len(Reminder.Buffers.Day[1]) > 0 then
        -- Default blanks to current.
        if not year then year   = tonumber(os.date("*t", os.time()).year) end
        if not month then month = tonumber(os.date("*t", os.time()).month) end
        if not day then day     = tonumber(os.date("*t", os.time()).day) end

        -- Data validation.
        if year < 2003 then return nil end
        if month < 0 or month > 12 then return nil end
        if day < 0 or month > 31 then return nil end

---@diagnostic disable-next-line: assign-type-mismatch
        new_instant = os.time{year = year, month = month, day = day, hour = hour, min = minute, sec = second}

        -- Check if the time has already passed. If no date was entered then set timer to the next available time (24 hours later).
    else
        new_instant = os.time{year = now_table.year, month = now_table.month, day = now_table.day, hour = hour, min = minute, sec = second}
        if new_instant < now then
            new_instant = new_instant + (3600 * 24)
        end
    end

    return new_instant
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the help text for the date fields.
-- ------------------------------------------------------------------------------------------------------
Reminder.Date_Help = function()
    UI.SameLine()
    Window.HelpMarker("You only need to set these if you want to set a timer for a specific date. "
                      .. "If you leave them blank, the timer will be set for the nearest available time. "
                      .. "Ex: If it's 12:00 PM and you set the time for 9:00 AM (in the past) then "
                      .. "the timer will be set for 9:00 AM tomorrow.")
end