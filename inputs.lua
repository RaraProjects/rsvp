Inputs = T{}

Inputs.Enum = T{
    ASCII_DEC_START = 48,
    ASCII_DEC_END   = 57,
    NAME   = "Name",
    YEAR   = "Year",
    MONTH  = "Month",
    DAY    = "Day",
    HOUR   = "Hour",
    MINUTE = "Minute",
    SECOND = "Second",
    MIN_YEAR = 2003,
    MAX_YEAR = 3000,
}

Inputs.Buffers = T{
    Name    = T{},
    Minutes = T{},  -- ???
    Year    = T{[1] = tostring(os.date("*t", os.time()).year)},
    Month   = T{[1] = tostring(os.date("*t", os.time()).month)},
    Day     = T{[1] = tostring(os.date("*t", os.time()).day)},
    Hour    = T{[1] = tostring(0)},
    Minute  = T{[1] = tostring(0)},
    Second  = T{[1] = tostring(0)},
}

Inputs.Text_Flags = bit.bor(ImGuiInputTextFlags_CallbackCharFilter)

-- ------------------------------------------------------------------------------------------------------
-- Catch the screen rendering packet.
-- ------------------------------------------------------------------------------------------------------
---@param input any
-- ------------------------------------------------------------------------------------------------------
Inputs.Number_Filter = function(input)
    if input then
        local ascii = input.EventChar
        if ascii >= Inputs.Enum.ASCII_DEC_START and ascii <= Inputs.Enum.ASCII_DEC_END then
            return 0
        end
    end
    return 1
end

-- ------------------------------------------------------------------------------------------------------
-- Returns a given field.
-- ------------------------------------------------------------------------------------------------------
---@param field string
---@param make_number? boolean
---@return string|number
-- ------------------------------------------------------------------------------------------------------
Inputs.Get_Field = function(field, make_number)
    if not field then return "Error" end
    if not Inputs.Buffers[field] then return "Error" end

    local month = Inputs.Trim_String(Inputs.Buffers[field][1])
    if make_number then
        local month_number = tonumber(month)
        if not month_number then month_number = 0 end
        return month_number
    end
    return month
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the name field.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
Inputs.Name = function()
    return tostring(Inputs.Buffers.Name[1])
end

-- ------------------------------------------------------------------------------------------------------
-- Provides the prompt to set the year field.
-- ------------------------------------------------------------------------------------------------------
Inputs.Set_Year = function()
    UI.SetNextItemWidth(50) UI.InputText("Year   (YYYY)", Inputs.Buffers.Year,  5, Inputs.Text_Flags, Inputs.Number_Filter)
    local year = Inputs.Trim_String(Inputs.Buffers.Year[1])
    if string.len(year) < 4 then
        Inputs.Buffers.Year[1] = tostring(os.date("*t", os.time()).year)
    elseif tonumber(year) > Inputs.Enum.MAX_YEAR then
        Inputs.Buffers.Year[1] = tostring(Inputs.Enum.MAX_YEAR)
    elseif tonumber(year) < Inputs.Enum.MIN_YEAR then
        Inputs.Buffers.Year[1] = tostring(Inputs.Enum.MIN_YEAR)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Provides the prompt to set the month field.
-- ------------------------------------------------------------------------------------------------------
Inputs.Set_Month = function()
    UI.SetNextItemWidth(50) UI.InputText("Month  (1-12)", Inputs.Buffers.Month, 3, Inputs.Text_Flags, Inputs.Number_Filter)
    local month = Inputs.Trim_String(Inputs.Buffers.Month[1])
    if string.len(month) == 0 then
        Inputs.Buffers.Month[1] = tostring(os.date("*t", os.time()).month)
    elseif tonumber(month) < 1 then
        Inputs.Buffers.Month[1] = tostring(1)
    elseif tonumber(month) > 12 then
        Inputs.Buffers.Month[1] = tostring(12)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Provides the prompt to set the day field.
-- ------------------------------------------------------------------------------------------------------
Inputs.Set_Day = function()
    UI.SetNextItemWidth(50) UI.InputText("Day    (1-31)", Inputs.Buffers.Day,   3, ImGuiInputTextFlags_CallbackCharFilter, Inputs.Number_Filter)
    local day = Inputs.Trim_String(Inputs.Buffers.Day[1])
    if string.len(day) == 0 then
        Inputs.Buffers.Day[1] = tostring(os.date("*t", os.time()).day)
    elseif tonumber(day) < 1 then
        Inputs.Buffers.Day[1] = tostring(1)
    elseif tonumber(day) > 31 then
        Inputs.Buffers.Day[1] = tostring(31)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Provides the prompt to set the hour field.
-- ------------------------------------------------------------------------------------------------------
Inputs.Set_Hour = function()
    UI.SetNextItemWidth(50) UI.InputText("Hour   (0-23)", Inputs.Buffers.Hour,   3, ImGuiInputTextFlags_CallbackCharFilter, Inputs.Number_Filter)
    local hour = Inputs.Trim_String(Inputs.Buffers.Hour[1])
    if string.len(hour) == 0 then
        Inputs.Buffers.Hour[1] = tostring(0)
    elseif tonumber(hour) > 23 then
        Inputs.Buffers.Hour[1] = tostring(24)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Provides the prompt to set the minute field.
-- ------------------------------------------------------------------------------------------------------
Inputs.Set_Minute = function()
    UI.SetNextItemWidth(50) UI.InputText("Minute (0-59)", Inputs.Buffers.Minute, 3, ImGuiInputTextFlags_CallbackCharFilter, Inputs.Number_Filter)
    local minute = Inputs.Trim_String(Inputs.Buffers.Minute[1])
    if string.len(minute) == 0 then
        Inputs.Buffers.Minute[1] = tostring(0)
    elseif tonumber(minute) > 59 then
        Inputs.Buffers.Minute[1] = tostring(59)
    end
end
-- ------------------------------------------------------------------------------------------------------
-- Provides the prompt to set the second field.
-- ------------------------------------------------------------------------------------------------------
Inputs.Set_Second = function()
    UI.SetNextItemWidth(50) UI.InputText("Second (0-59)", Inputs.Buffers.Second, 3, ImGuiInputTextFlags_CallbackCharFilter, Inputs.Number_Filter)
    local second = Inputs.Trim_String(Inputs.Buffers.Second[1])
    if string.len(second) == 0 then
        Inputs.Buffers.Second[1] = tostring(0)
    elseif tonumber(second) > 59 then
        Inputs.Buffers.Second[1] = tostring(59)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Trims junk characters out of strings.
-- ------------------------------------------------------------------------------------------------------
---@param junk_string string
---@return string
-- ------------------------------------------------------------------------------------------------------
Inputs.Trim_String = function(junk_string)
    local trimmed = ""
    for i in string.gmatch(junk_string, "%d") do
        trimmed = trimmed .. tostring(i)
    end
    return trimmed
end