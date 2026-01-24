Config = { }
Config.Toggle = { }
Config.Widget = { }

Config.Defaults = T{
    X_Pos   = 100,
    Y_Pos   = 100,
    Scale   = 1.0,
}

Config.Table_Flags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)

Config.Draggable_Width = 100
Config.ALIAS           = 'config'   -- Used for the settings file.
Config.Scaling_Set     = false
Config.Reset_Position  = true
Config.Visible         = { false }

-- ------------------------------------------------------------------------------------------------------
-- Shows the help text section.
-- ------------------------------------------------------------------------------------------------------
local helpText = function()
    if UI.BeginTabItem('Help') then
        if UI.BeginTable('Help General', 2, Config.Table_Flags) then
            UI.TableSetupColumn('Col1')
            UI.TableSetupColumn('Col2')

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text('GitHub')
            UI.TableNextColumn() UI.Text('https://github.com/RaraProjects/rsvp')
            Window.TableRowColor(1)

            UI.TableNextColumn() UI.Text('Discord')
            UI.TableNextColumn() UI.Text('https://discord.gg/u5yqUbR6R7')
            Window.TableRowColor(0)

            UI.TableNextColumn() UI.Text('Version')
            UI.TableNextColumn() UI.Text(tostring(addon.version))
            Window.TableRowColor(1)

            UI.TableNextColumn() UI.Text('Command')
            UI.TableNextColumn() UI.Text('/rsvp')
            Window.TableRowColor(0)

            UI.EndTable()
        end

        if UI.BeginTable('Text Commands', 3, Config.Table_Flags) then
            UI.TableSetupColumn('Full')
            UI.TableSetupColumn('Short')
            UI.TableSetupColumn('Description')
            UI.TableHeadersRow()

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text('create\nmake')
            UI.TableNextColumn() UI.Text('c\nm')
            UI.TableNextColumn() UI.Text('Toggles timer creation window visibility.')

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text('timers\nlist')
            UI.TableNextColumn() UI.Text('t\nl')
            UI.TableNextColumn() UI.Text('Toggles timer list window visibility.')

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text('clock')
            UI.TableNextColumn() UI.Text('cl')
            UI.TableNextColumn() UI.Text('Toggles clock visibility.')

            UI.EndTable()
        end

        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the window scaling update flag.
-- ------------------------------------------------------------------------------------------------------
local setScalingFlag = function(scaling)
    Config.Scaling_Set = scaling
end

-- ------------------------------------------------------------------------------------------------------
-- Sets window scaling.
-- ------------------------------------------------------------------------------------------------------
local setScale = function()
    local windowScale = { [1] = RSVP.Config.Scale }

    UI.SetNextItemWidth(Config.Draggable_Width)

    if UI.DragFloat('Window Scaling', windowScale, 0.005, 0.7, 3, '%.2f', ImGuiSliderFlags_None) then
        if windowScale[1] < 0.7 then
            windowScale[1] = 0.7
        elseif windowScale[1] > 3 then
            windowScale[1] = 3
        end

        RSVP.Config.Scale = windowScale[1]

        Create.SetScalingFlag(false)
        Clock.SetScalingFlag(false)
        List.SetScalingFlag(false)
        setScalingFlag(false)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles window decoration on the Timer List.
-- ------------------------------------------------------------------------------------------------------
local widgetDecoration = function()
    if UI.Checkbox('List Window Header', { RSVP.List.Decoration }) then
        RSVP.List.Decoration = not RSVP.List.Decoration
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles countdown on the Timer List.
-- ------------------------------------------------------------------------------------------------------
local widgetCountdown = function()
    if UI.Checkbox('Countdown Mode', { RSVP.List.Show_Countdown }) then
        RSVP.List.Show_Countdown = not RSVP.List.Show_Countdown
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the hour filter value.
-- ------------------------------------------------------------------------------------------------------
local widgetSetHourFilter = function()
    local hourFilter = { [1] = RSVP.List.Hour_Filter }

    UI.SetNextItemWidth(Config.Draggable_Width)

    if UI.DragInt('Hour Filter', hourFilter, 0.1, 1, 48, '%d', ImGuiSliderFlags_None) then
        if hourFilter[1] < 1 then
            hourFilter[1] = 1
        elseif hourFilter[1] > 48 then
            hourFilter[1] = 48
        end

        RSVP.List.Hour_Filter = hourFilter[1]
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles auto clear on the Timer List.
-- ------------------------------------------------------------------------------------------------------
local widgetAutoClear = function()
    if UI.Checkbox('Auto Clear', { RSVP.List.Auto_Clear }) then
        RSVP.List.Auto_Clear = not RSVP.List.Auto_Clear
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the auto clear delay.
-- ------------------------------------------------------------------------------------------------------
local widgetAutoClearDelay = function()
    local delay = { [1] = RSVP.List.Auto_Clear_Delay }

    UI.SetNextItemWidth(Config.Draggable_Width)

    if UI.DragInt('Seconds', delay, 0.1, 0, 60, '%d', ImGuiSliderFlags_None) then
        if delay[1] < 0 then
            delay[1] = 0
        elseif delay[1] > 60 then
            delay[1] = 60
        end

        RSVP.List.Auto_Clear_Delay = delay[1]
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the settings section.
-- ------------------------------------------------------------------------------------------------------
local settings = function()
    if UI.BeginTabItem('Settings') then
        widgetDecoration()
        widgetCountdown()

        UI.Separator()

        widgetAutoClear()

        if RSVP.List.Auto_Clear then
            widgetAutoClearDelay()
        end

        UI.Separator()

        widgetSetHourFilter()

        UI.Separator()

        setScale()

        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the update section.
-- ------------------------------------------------------------------------------------------------------
local updates = function()
    if UI.BeginTabItem('Update') then
        Version.Populate()
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Displays the configuration window.
-- ------------------------------------------------------------------------------------------------------
Config.Display = function()
    if Config.Visible[1] then
        if Config.Reset_Position then
            UI.SetNextWindowPos({RSVP.Config.X_Pos, RSVP.Config.Y_Pos}, ImGuiCond_Always)
            Config.Reset_Position = false
        end

        Window.SetScaling()

        if UI.Begin('RSVP Config', Config.Visible, Window.Window_Flags) then
            RSVP.Config.X_Pos, RSVP.Config.Y_Pos = UI.GetWindowPos()
            Window.SetLegacyScaling()

            if UI.BeginTabBar('Settings Tabs', ImGuiTabBarFlags_None) then
                helpText()
                settings()
                updates()
                UI.EndTabBar()
            end

            Window.SetLegacyScaling(Config.GetScale())
            UI.End()
        end

        Window.SetScaling(Config.GetScale())
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the current window scaling.
-- ------------------------------------------------------------------------------------------------------
Config.GetScale = function()
    return RSVP.Config.Scale
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles config window visibility.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.ConfigWindowVisibility = function()
    Config.Visible[1] = not Config.Visible[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles creation window visibility.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.CreateWindowVisibility = function()
    RSVP.Create.Visible[1] = not RSVP.Create.Visible[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles timer list window visibility.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.ListWindowVisibility = function()
    RSVP.List.Visible[1] = not RSVP.List.Visible[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles clock visibility.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.ClockVisibility = function()
    RSVP.Clock.Visible[1] = not RSVP.Clock.Visible[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles showing the countdown.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle.Countdown = function()
    RSVP.List.Show_Countdown = not RSVP.List.Show_Countdown
end