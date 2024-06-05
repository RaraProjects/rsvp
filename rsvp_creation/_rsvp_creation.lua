Reminder = T{}

Reminder.Defaults = T{
    Width  = 700,
    Height = 10,
    X_Pos  = 100,
    Y_Pos  = 100,
}

Reminder.Table_Flags = bit.bor(ImGuiSelectableFlags_None)
Reminder.Visible = true
require("rsvp_creation.buttons")

-- ------------------------------------------------------------------------------------------------------
-- Initializes the clock window.
-- ------------------------------------------------------------------------------------------------------
Reminder.Initialize = function()
    UI.SetNextWindowPos({RSVP.Settings.Reminder.X_Pos, RSVP.Settings.Reminder.Y_Pos}, ImGuiCond_Always)
    Reminder.Display()
end

-- ------------------------------------------------------------------------------------------------------
-- Show the reminder creation window.
-- ------------------------------------------------------------------------------------------------------
Reminder.Display = function()
    if Reminder.Visible then
        UI.PushStyleColor(ImGuiCol_WindowBg, Window.Colors.DEFAULT)
        if UI.Begin("Reminder", true, Window.Window_Flags) then
            RSVP.Settings.Reminder.X_Pos, RSVP.Settings.Reminder.Y_Pos = UI.GetWindowPos()
            if UI.BeginTabBar("Reminder Types", Window.Tab_Flags) then
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
    if UI.BeginTabItem("Minutes", Window.Tab_Flags) then
        UI.SetNextItemWidth(150) UI.InputText("Name", Inputs.Buffers.Name, 100)
        local error = Timers.Validate()
        if error ~= Timers.Errors.NO_ERROR then UI.TextColored(Window.Colors.RED, error) end
        UI.Separator()

        UI.Text("Quick Timers")
        if UI.BeginTable("Buttons", 5, Reminder.Table_Flags) then
            UI.TableNextColumn() Reminder.Buttons.Minute(5)
            UI.TableNextColumn() Reminder.Buttons.Minute(7)
            UI.TableNextColumn() Reminder.Buttons.Minute(10)
            UI.TableNextColumn() Reminder.Buttons.Minute(15)
            UI.TableNextColumn() Reminder.Buttons.Minute(16)
            UI.TableNextColumn() Reminder.Buttons.Minute(30)
            UI.TableNextColumn() Reminder.Buttons.Minute(60)
            UI.EndTable()
        end
        UI.Separator()

        UI.Text("Custom Timers")
        UI.SetNextItemWidth(50) UI.InputText("Minutes", Inputs.Buffers.Minutes, 4)
        UI.SameLine() UI.Text(" ") UI.SameLine() Reminder.Buttons.Minute(tonumber(Inputs.Buffers.Minutes[1]), "Create")
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays screen elements to make a timer set for a specific time in the future.
-- ------------------------------------------------------------------------------------------------------
Reminder.Create_Future_Timer = function()
    if UI.BeginTabItem("Time", Window.Tab_Flags) then
        UI.SetNextItemWidth(150) UI.InputText("Name", Inputs.Buffers.Name, 100)
        local error = Timers.Validate()
        if error ~= Timers.Errors.NO_ERROR then UI.TextColored(Window.Colors.RED, error) end
        UI.Separator()

        Inputs.Set_Hour()
        Inputs.Set_Minute()
        Inputs.Set_Second()
        UI.Separator()

        Inputs.Set_Year()
        Inputs.Set_Month()
        Inputs.Set_Day()
        UI.Separator()

        local year   = string.format("%04d", Inputs.Get_Field(Inputs.Enum.YEAR, true))
        local month  = string.format("%02d", Inputs.Get_Field(Inputs.Enum.MONTH, true))
        local day    = string.format("%02d", Inputs.Get_Field(Inputs.Enum.DAY, true))
        local hour   = string.format("%02d", Inputs.Get_Field(Inputs.Enum.HOUR, true))
        local minute = string.format("%02d", Inputs.Get_Field(Inputs.Enum.MINUTE, true))
        local second = string.format("%02d", Inputs.Get_Field(Inputs.Enum.SECOND, true))
        local date = month .. "/" .. day .. "/" .. year
        local time = hour .. ":" .. minute .. ":" .. second
        local sim_time, sim_color = Timers.Simulate()

        UI.Text("Schedule Preview")
        UI.Text(date .. " " .. time)
        UI.TextColored(sim_color, sim_time)

        Reminder.Buttons.Schedule()
        UI.SameLine() Reminder.Buttons.Kings()
        UI.SameLine() Reminder.Buttons.Wyrms()
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Handles date input to get a final instant for the timer.
-- ------------------------------------------------------------------------------------------------------
Reminder.Handle_Date_Input = function()
    local year   = Inputs.Get_Field(Inputs.Enum.YEAR, true)
    local month  = Inputs.Get_Field(Inputs.Enum.MONTH, true)
    local day    = Inputs.Get_Field(Inputs.Enum.DAY, true)
    local hour   = Inputs.Get_Field(Inputs.Enum.HOUR, true)
    local minute = Inputs.Get_Field(Inputs.Enum.MINUTE, true)
    local second = Inputs.Get_Field(Inputs.Enum.SECOND, true)

    if not hour or not minute or not second then return nil end
    if hour < 0 or hour > 24 then hour = 0 end
    if minute < 0 or minute > 60 then minute = 0 end
    if second < 0 or second > 60 then second = 0 end

    return os.time{year = year, month = month, day = day, hour = hour, min = minute, sec = second}
end