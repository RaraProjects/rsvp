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
                Create.Make_Relative_Timer()
                Create.Make_Specific_Timer()
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
Create.Make_Relative_Timer = function()
    if UI.BeginTabItem("Relative", Window.Tab_Flags) then
        Inputs.Name_Field()

        UI.Separator()
        UI.Text("Presets (Minutes)")
        if UI.BeginTable("Buttons", 4, Create.Table_Flags) then
            UI.TableNextColumn() Create.Buttons.Minute(true, 5)
            UI.TableNextColumn() Create.Buttons.Minute(true, 5.5)
            UI.TableNextColumn() Create.Buttons.Minute(true, 7)
            UI.TableNextColumn() Create.Buttons.Minute(true, 10)
            UI.TableNextColumn() Create.Buttons.Minute(true, 15)
            UI.TableNextColumn() Create.Buttons.Minute(true, 16)
            UI.TableNextColumn() Create.Buttons.Minute(true, 30)
            UI.TableNextColumn() Create.Buttons.Minute(true, 60)
            UI.EndTable()
        end

        UI.Separator()
        Inputs.Minutes_Field()

        local name_pass, name_error, name = Inputs.Validate_Name(true)
        local minute_pass, minute_error, minute = Inputs.Validate_Minutes()
        local pass = name_pass and minute_pass
        Create.Buttons.Minute(pass, minute, "Create")

        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays screen elements to make a timer set for a specific time in the future.
-- ------------------------------------------------------------------------------------------------------
Create.Make_Specific_Timer = function()
    if UI.BeginTabItem("Specific", Window.Tab_Flags) then
        -- Display entry fields.
        Inputs.Name_Field()
        UI.Separator()
        Inputs.Time_Field()
        Inputs.Date_Field()

        -- Validate and display the name.
        UI.Separator()
        UI.Text("Timer Preview")
        UI.Text("Name:") UI.SameLine()
        local name_pass, name_error, name = Inputs.Validate_Name()
        if name_pass then
            UI.Text(name)
        else
            UI.TextColored(Window.Colors.RED, name_error)
        end

        -- Validate and display the time.
        UI.Text("Time:") UI.SameLine()
        local time_pass, time_error, time = Inputs.Validate_Time()
        if time_pass then
            local display_time = string.format("%02d", time.hour) .. ":" .. string.format("%02d", time.minute) .. ":" .. string.format("%02d", time.second) .. " " .. tostring(time.meridiem)
            UI.Text(tostring(display_time))
        else
            UI.TextColored(Window.Colors.RED, time_error)
        end

        -- Validate and display the date.
        UI.Text("Date:") UI.SameLine()
        local date_pass, date_error, date = Inputs.Validate_Date()
        if date_pass then
            local display_date = string.format("%02d", date.month) .. "/" .. string.format("%02d", date.day) .. "/" .. string.format("%02d", date.year)
            UI.Text(tostring(display_date))
        else
            UI.TextColored(Window.Colors.RED, date_error)
        end

        -- Show the timer simulation.
        UI.Text("Sim :") UI.SameLine()
        if time_pass and date_pass then
            local sim_time, sim_color = Timers.Simulate(date, time)
            UI.TextColored(sim_color, sim_time)
        else
            UI.Text("~--:--:--")
        end

        -- Display the creation buttons.
        local pass = name_pass and time_pass and date_pass
        Create.Buttons.Schedule(Create.Buttons.Type.Normal, pass, name, date, time)
        UI.SameLine() Create.Buttons.Schedule(Create.Buttons.Type.King, pass, name, date, time)
        UI.SameLine() Create.Buttons.Schedule(Create.Buttons.Type.Wyrm, pass, name, date, time)

        -- Display custom window buttons
        if UI.CollapsingHeader("Custom Windows") then
            Inputs.Custom_Gap_Field()
            Inputs.Custom_Count_Field()
            local gap_pass, gap_error, gap = Inputs.Validate_Gap()
            local count_pass, count_error, count = Inputs.Validate_Count()
            Create.Buttons.Schedule(Create.Buttons.Type.Custom, gap_pass and count_pass, name, date, time, {gap = gap, count = count})
        end

        UI.EndTabItem()
    end
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