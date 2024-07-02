Create = T{}

Create.Defaults = T{
    X_Pos  = 100,
    Y_Pos  = 100,
    Visible = {true},
}

Create.Table_Flags = bit.bor(ImGuiSelectableFlags_None)

Create.ALIAS = "create"
Create.Scaling_Set = false
Create.Reset_Position = true

require("rsvp_creation.buttons")

-- ------------------------------------------------------------------------------------------------------
-- Show the reminder creation window.
-- ------------------------------------------------------------------------------------------------------
Create.Display = function()
    if RSVP.Create.Visible[1] then
        if Create.Reset_Position then
            UI.SetNextWindowPos({RSVP.Create.X_Pos, RSVP.Create.Y_Pos}, ImGuiCond_Always)
            Create.Reset_Position = false
        end
        UI.PushStyleColor(ImGuiCol_WindowBg, Window.Colors.DEFAULT)
        if UI.Begin("RSVP Creation", RSVP.Create.Visible, Window.Window_Flags) then
            RSVP.Create.X_Pos, RSVP.Create.Y_Pos = UI.GetWindowPos()
            Create.Set_Window_Scaling()
            if UI.BeginTabBar("Reminder Types", Window.Tab_Flags) then
                Create.Create_Minute_Timer()
                Create.Create_Future_Timer()
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
Create.Create_Minute_Timer = function()
    if UI.BeginTabItem("Relative", Window.Tab_Flags) then
        UI.SetNextItemWidth(150) UI.InputText("Name", Inputs.Buffers.Name, 100)
        UI.Separator()

        UI.Text("Minute Presets")
        if UI.BeginTable("Buttons", 5, Create.Table_Flags) then
            UI.TableNextColumn() Create.Buttons.Minute(5)
            UI.TableNextColumn() Create.Buttons.Minute(7)
            UI.TableNextColumn() Create.Buttons.Minute(10)
            UI.TableNextColumn() Create.Buttons.Minute(15)
            UI.TableNextColumn() Create.Buttons.Minute(16)
            UI.TableNextColumn() Create.Buttons.Minute(30)
            UI.TableNextColumn() Create.Buttons.Minute(60)
            UI.EndTable()
        end
        UI.Separator()
        UI.SetNextItemWidth(50) UI.InputText("Minutes", Inputs.Buffers.Minutes, 4)
        UI.SameLine() Create.Buttons.Minute(tonumber(Inputs.Buffers.Minutes[1]), "Create")
        local error = Timers.Validate()
        if error ~= Timers.Errors.NO_ERROR then UI.TextColored(Window.Colors.RED, error) end
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays screen elements to make a timer set for a specific time in the future.
-- ------------------------------------------------------------------------------------------------------
Create.Create_Future_Timer = function()
    if UI.BeginTabItem("Specific", Window.Tab_Flags) then
        UI.SetNextItemWidth(150) UI.InputText("Name", Inputs.Buffers.Name, 100)
        UI.Separator()
        UI.Separator()

        UI.Text("24-HR Format")
        Inputs.Set_Hour()
        UI.SameLine() Inputs.Set_Minute()
        UI.SameLine() Inputs.Set_Second()
        UI.Separator()

        Inputs.Set_Month()
        UI.SameLine() Inputs.Set_Day()
        UI.SameLine() Inputs.Set_Year()
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

        UI.Text("Preview")
        UI.Text("Name:") UI.SameLine()
        local error = Timers.Validate()
        if error ~= Timers.Errors.NO_ERROR then
            UI.TextColored(Window.Colors.RED, error)
        else
            UI.Text(Inputs.Name())
        end
        UI.Text("Date: " .. tostring(date))
        UI.Text("Time: " .. tostring(time))
        UI.Text("Sim :") UI.SameLine() UI.TextColored(sim_color, sim_time)
        UI.Separator()

        Create.Buttons.Schedule()
        UI.SameLine() Create.Buttons.Kings()
        UI.SameLine() Create.Buttons.Wyrms()
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Handles date input to get a final instant for the timer.
-- ------------------------------------------------------------------------------------------------------
Create.Handle_Date_Input = function()
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

-- ------------------------------------------------------------------------------------------------------
-- Returns whether the window scaling needs to be updated.
-- ------------------------------------------------------------------------------------------------------
Create.Is_Scaling_Set = function()
    return Create.Scaling_Set
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
Create.Set_Scaling_Flag = function(scaling)
    Create.Scaling_Set = scaling
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Create.Set_Window_Scaling = function()
    if not Create.Is_Scaling_Set() then
        UI.SetWindowFontScale(Config.Get_Scale())
        Create.Set_Scaling_Flag(true)
    end
end