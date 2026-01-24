Create = { }

Create.Defaults = T{
    X_Pos  = 100,
    Y_Pos  = 100,
    Visible = { true },
}

Create.Table_Flags = bit.bor(ImGuiSelectableFlags_None)

Create.ALIAS          = 'create'
Create.Scaling_Set    = false
Create.Reset_Position = true

require('rsvp_creation.buttons')

-- ------------------------------------------------------------------------------------------------------
-- Displays screen elements to make a tiemr set for {minutes} in the future.
-- ------------------------------------------------------------------------------------------------------
local makeRelativeTimer = function()
    if UI.BeginTabItem('Relative', Window.Tab_Flags) then
        Inputs.NameField()

        UI.Separator()

        UI.Text('Presets (Minutes)')

        if UI.BeginTable('Buttons', 4, Create.Table_Flags) then
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
        Inputs.MinutesField()

        local namePass,   nameError,   name   = Inputs.ValidateName(true)
        local minutePass, minuteError, minute = Inputs.ValidateMinutes()
        local pass = namePass and minutePass

        Create.Buttons.Minute(pass, minute, 'Create')

        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays screen elements to make a timer set for a specific time in the future.
-- ------------------------------------------------------------------------------------------------------
local makeSpecificTimer = function()
    if UI.BeginTabItem('Specific', Window.Tab_Flags) then
        Inputs.NameField()

        UI.Separator()

        Inputs.TimeField()
        Inputs.DateField()

        -- Validate and display the name.
        UI.Separator()
        UI.Text('Timer Preview')
        UI.Text('Name:') UI.SameLine()

        local namePass, nameError, name = Inputs.ValidateName()

        if namePass then
            UI.Text(name)
        else
            UI.TextColored(Window.Colors.RED, nameError)
        end

        -- Validate and display the time.
        UI.Text('Time:') UI.SameLine()

        local timePass, timeError, time = Inputs.ValidateTime()

        if timePass then
            UI.Text(string.format('%02d:%02d:%02d %s', time.hour, time.minute, time.second, time.meridiem))
        else
            UI.TextColored(Window.Colors.RED, timeError)
        end

        -- Validate and display the date.
        UI.Text('Date:') UI.SameLine()

        local datePass, dateError, date = Inputs.ValidateDate()

        if datePass then
            UI.Text(string.format('%02d/%02d/%02d', date.month, date.day, date.year))
        else
            UI.TextColored(Window.Colors.RED, dateError)
        end

        -- Show the timer simulation.
        UI.Text('Sim :') UI.SameLine()

        if timePass and datePass then
            local simTime, simColor = Timers.Simulate(date, time)

            UI.TextColored(simColor, simTime)
        else
            UI.Text('~--:--:--')
        end

        -- Display the creation buttons.
        local pass = namePass and timePass and datePass

        Create.Buttons.Schedule(Create.Buttons.Type.Normal, pass, name, date, time)
        UI.SameLine() Create.Buttons.Schedule(Create.Buttons.Type.King, pass, name, date, time)
        UI.SameLine() Create.Buttons.Schedule(Create.Buttons.Type.Wyrm, pass, name, date, time)

        -- Display custom window buttons
        if UI.CollapsingHeader('Custom Windows') then
            Inputs.CustomGapField()
            Inputs.CustomCountField()

            local gapPass,   gapError,   gap   = Inputs.ValidateGap()
            local countPass, countError, count = Inputs.ValidateCount()

            Create.Buttons.Schedule(Create.Buttons.Type.Custom, gapPass and countPass, name, date, time, { gap = gap, count = count })
        end

        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Show the reminder creation window.
-- ------------------------------------------------------------------------------------------------------
Create.Display = function()
    if RSVP.Create.Visible[1] then
        if Create.Reset_Position then
            UI.SetNextWindowPos({ RSVP.Create.X_Pos, RSVP.Create.Y_Pos }, ImGuiCond_Always)
            Create.Reset_Position = false
        end

        UI.PushStyleColor(ImGuiCol_WindowBg, Window.Colors.DEFAULT)
        Window.SetScaling()

        if UI.Begin('RSVP Creation', RSVP.Create.Visible, Window.Window_Flags) then
            RSVP.Create.X_Pos, RSVP.Create.Y_Pos = UI.GetWindowPos()
            Window.SetLegacyScaling()

            if UI.BeginTabBar('Reminder Types', Window.Tab_Flags) then
                makeRelativeTimer()
                makeSpecificTimer()
                UI.EndTabBar()
            end

            Window.SetLegacyScaling(Config.GetScale())
            UI.End()
        end

        Window.SetScaling(Config.GetScale())
        UI.PopStyleColor(1)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
Create.SetScalingFlag = function(scaling)
    Create.Scaling_Set = scaling
end
