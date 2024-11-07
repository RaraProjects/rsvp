Inputs = T{}

Inputs.Enum = T{
    ASCII_DEC_START = 48,
    ASCII_DEC_END   = 57,
    ASCII_TAB       = 9,
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
    Name         = T{},
    Date         = T{[1] = tostring(os.date("%m/%d/%y", os.time()))},
    Time         = T{[1] = "00:00:00 AM"},
    Custom_Gap   = T{},
    Custom_Count = T{},
    Minutes = T{},  -- ???
    Year    = T{[1] = tostring(os.date("*t", os.time()).year)},
    Month   = T{[1] = tostring(os.date("*t", os.time()).month)},
    Day     = T{[1] = tostring(os.date("*t", os.time()).day)},
    Hour    = T{[1] = tostring(0)},
    Minute  = T{[1] = tostring(0)},
    Second  = T{[1] = tostring(0)},
}

Inputs.Widths = T{}
Inputs.Widths.Primary = 150
Inputs.Widths.Minute = 50
Inputs.Widths.Custom = 100

Inputs.Meridiem = T{}
Inputs.Meridiem.AM = "AM"
Inputs.Meridiem.PM = "PM"

Inputs.Text_Flags = bit.bor(ImGuiInputTextFlags_CallbackCharFilter, ImGuiInputTextFlags_AutoSelectAll)
Inputs.Date_Time_Flags = bit.bor(ImGuiInputTextFlags_AutoSelectAll)

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the name buffer.
-- ------------------------------------------------------------------------------------------------------
Inputs.Get_Name = function()
    return Inputs.Buffers.Name[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the time buffer.
-- ------------------------------------------------------------------------------------------------------
Inputs.Get_Time = function()
    return Inputs.Buffers.Time[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the date buffer.
-- ------------------------------------------------------------------------------------------------------
Inputs.Get_Date = function()
    return Inputs.Buffers.Date[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the custom gap buffer.
-- ------------------------------------------------------------------------------------------------------
Inputs.Get_Custom_Gap = function()
    return Inputs.Buffers.Custom_Gap[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the custom count buffer.
-- ------------------------------------------------------------------------------------------------------
Inputs.Get_Custom_Count = function()
    return Inputs.Buffers.Custom_Count[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the minutes buffer.
-- ------------------------------------------------------------------------------------------------------
Inputs.Get_Minutes = function()
    return Inputs.Buffers.Minutes[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for name.
-- ------------------------------------------------------------------------------------------------------
Inputs.Name_Field = function()
    UI.SetNextItemWidth(Inputs.Widths.Primary) UI.InputText("Name", Inputs.Buffers.Name, 100, ImGuiInputTextFlags_AutoSelectAll)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for time.
-- ------------------------------------------------------------------------------------------------------
Inputs.Time_Field = function()
    UI.SetNextItemWidth(Inputs.Widths.Primary) UI.InputText("Time", Inputs.Buffers.Time, 12, Inputs.Date_Time_Flags)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for date.
-- ------------------------------------------------------------------------------------------------------
Inputs.Date_Field = function()
    UI.SetNextItemWidth(Inputs.Widths.Primary) UI.InputText("Date", Inputs.Buffers.Date, 9, Inputs.Date_Time_Flags)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for custom gap.
-- ------------------------------------------------------------------------------------------------------
Inputs.Custom_Gap_Field = function()
    UI.SetNextItemWidth(Inputs.Widths.Custom) UI.InputInt("Minutes", Inputs.Buffers.Custom_Gap, 1, 5, ImGuiInputTextFlags_AutoSelectAll)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for custom count.
-- ------------------------------------------------------------------------------------------------------
Inputs.Custom_Count_Field = function()
    UI.SetNextItemWidth(Inputs.Widths.Custom) UI.InputInt("# Windows", Inputs.Buffers.Custom_Count, 1, 5, ImGuiInputTextFlags_AutoSelectAll)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for minutes.
-- ------------------------------------------------------------------------------------------------------
Inputs.Minutes_Field = function()
    UI.SetNextItemWidth(Inputs.Widths.Minute) UI.InputText("Minutes", Inputs.Buffers.Minutes, 4)
end

-- ------------------------------------------------------------------------------------------------------
-- Validates name input.
-- ------------------------------------------------------------------------------------------------------
---@param not_required? boolean
---@return boolean
---@return string
---@return string
-- ------------------------------------------------------------------------------------------------------
Inputs.Validate_Name = function(not_required)
    local default_name = "Default Name"
    local name = Inputs.Get_Name()

    if not name then
        return false, Timers.Errors.ERROR, default_name
    elseif not not_required and string.len(name) == 0 then
        return false, Timers.Errors.NO_NAME, default_name
    elseif Timers.Timers[name] or Timers.Groups.Exists(name) then
        return false, Timers.Errors.EXISTS, default_name
    end

    return true, Timers.Errors.NO_ERROR, name
end

-- ------------------------------------------------------------------------------------------------------
-- Validates a time input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return table
-- ------------------------------------------------------------------------------------------------------
Inputs.Validate_Time = function()
    local err = ""
    local default_time = {hour = 0, minute = 0, second = 0, meridiem = "AM"}

    local time = Inputs.Get_Time()
    if not time or time == "" then
        err = "Time Required"
        return false, err, default_time
    end

    local hours, minutes, seconds, meridiem = string.match(time, "(%d?%d):(%d?%d):(%d?%d)%s*(%a?%a?)")

    -- If a meridian was entered then need to make sure it is valid.
    if meridiem and meridiem ~= "" then
        if string.lower(meridiem) == "am" then
            meridiem = Inputs.Meridiem.AM
        elseif string.lower(meridiem) == "pm" then
            meridiem = Inputs.Meridiem.PM
        else
            err = "Invalid Time"
            return false, err, default_time
        end
    end

    -- Validate and adjust hours for AM/PM.
    if hours and minutes and seconds then
        hours   = tonumber(hours)
        minutes = tonumber(minutes)
        seconds = tonumber(seconds)

        local hour_check   = hours   >= 0 and hours   <= 24
        local minute_check = minutes >= 0 and minutes <= 59
        local second_check = seconds >= 0 and seconds <= 59
        if not (hour_check and minute_check and second_check) then
            err = "Invalid Time"
            return false, err, default_time
        end

        -- Hours will supercede meridiem. Meridiem only matters for values less than 13.
        -- If AM/PM is not entered for values less than 13 then we assume miliatry time.
        if hours == 12 then
            if meridiem == "" then meridiem = "AM" end
            if meridiem == "AM" then hours = hours - 12 end
        elseif hours <= 11 then
            if meridiem == Inputs.Meridiem.PM then
                hours = hours + 12
            else
                meridiem = "AM"
            end
        else
            meridiem = "PM"
        end
    else
        err = "Invalid Time"
        return false, err, default_time
    end

    return true, err, {hour = hours, minute = minutes, second = seconds, meridiem = string.upper(meridiem)}
end

-- ------------------------------------------------------------------------------------------------------
-- Validates date input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return table
-- ------------------------------------------------------------------------------------------------------
Inputs.Validate_Date = function()
    local err = ""
    local now = os.time()
    local default_date = {month = os.date("%m", now), day = os.date("%d", now), year = os.date("%y", now)}

    local date = Inputs.Get_Date()
    if not date then
        err = "Date Required"
        return false, err, default_date
    end

    local month, day, year = string.match(date, "^(%d?%d)[/%-](%d?%d)[/%-](%d%d)$")

    if month and day and year then
        month = tonumber(month)
        day   = tonumber(day)
        year  = tonumber(year)

        local month_check = month >= 1 and month <= 12
        local day_check   = day   >= 1 and day <= 31
        if not (month_check and day_check) then
            err = "Date Required"
            return false, err, default_date
        end
    else
        err = "Date Required"
        return false, err, default_date
    end

    return true, err, {month = month, day = day, year = year}
end

-- ------------------------------------------------------------------------------------------------------
-- Validates gap input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Inputs.Validate_Gap = function()
    local err = ""
    local gap = tonumber(Inputs.Get_Custom_Gap())
    if not gap then
        err = "Gap Required"
        return false, err, 0
    end

    if gap <= 0 then
        err = "Positive Gap Required"
        return false, err, 0
    elseif gap > 720 then
        err = "Gap Too High"
        return false, err, 720
    end

    return true, err, gap
end

-- ------------------------------------------------------------------------------------------------------
-- Validates gap input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Inputs.Validate_Count = function()
    local err = ""
    local count = tonumber(Inputs.Get_Custom_Count())
    if not count then
        err = "Count Required"
        return false, err, 0
    end

    if count <= 0 then
        err = "Positive Count Required"
        return false, err, 0
    elseif count > 25 then
        err = "Gap Too High"
        return false, err, 25
    end

    return true, err, count
end

-- ------------------------------------------------------------------------------------------------------
-- Validates minute input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Inputs.Validate_Minutes = function()
    local err = ""
    local minutes = tonumber(Inputs.Get_Minutes())
    if not minutes then
        err = "Minutes Required"
        return false, err, 0
    end

    if minutes <= 0 then
        err = "Positive Minutes Required"
        return false, err, 0
    elseif minutes > 1440 then
        err = "Gap Too High"
        return false, err, 1440
    end

    return true, err, minutes
end