Timers = { }

Timers.Timers = { }
Timers.Sorted = { }
Timers.Count = 0

Timers.Errors = T{
    NO_ERROR = 'No Error',
    ERROR    = 'Error',
    NO_NAME  = 'Name Required',
    EXISTS   = 'Already Exists',
}

require('timers.groups')

-- --------------------------------------------------------------------------
-- Sorts the timers by due time. Earliest due times come first.
-- --------------------------------------------------------------------------
local sort = function()
    Timers.Sorted = { }

    for name, timerData in pairs(Timers.Timers) do
        table.insert(Timers.Sorted, {name, timerData.End})
    end

    table.sort(Timers.Sorted, function (a, b)
		local a_time = a[2]
		local b_time = b[2]
		return (a_time < b_time)
	end)
end

-- --------------------------------------------------------------------------
-- Formats the display timer.
-- --------------------------------------------------------------------------
---@param time?         number  duration in seconds.
---@param negativeTime? boolean if a countdown is negative add negative sign.
---@return string, number?, boolean|nil?
-- --------------------------------------------------------------------------
local format = function(time, negativeTime)
    if not time then
        return '00:00', 0
    end

    local sign = '-'

    if negativeTime then
        sign = '+'
    end

    time = math.abs(time)
    local hour   = string.format('%02d', math.floor(time / 3600))
    local minute = string.format('%02d', math.floor((time / 60) - (hour * 60)))
    local second = string.format('%02d', math.floor(time % 60))

    if hour and tonumber(hour) > 99 then
        return 'LONG', time, negativeTime
    end

    return string.format('%s%s:%s:%s', sign, hour, minute, second), time, negativeTime
end

-- --------------------------------------------------------------------------
-- Returns the timer's end time for display.
-- Assumes that the timer exists.
-- --------------------------------------------------------------------------
---@param name string
---@return string|osdate, integer, boolean
-- --------------------------------------------------------------------------
local timestamp = function(name)
    local endTime = Timers.Timers[name].End

    return os.date('%H:%M:%S', endTime), 999, false
end

-- --------------------------------------------------------------------------
-- Start the timer.
-- --------------------------------------------------------------------------
---@param name    string name of the timer to check.
---@param minutes number number of minutes from now for the timer.
---@param group?  string name of the group for a set of related timers.
-- --------------------------------------------------------------------------
Timers.Start = function(name, minutes, group)
    if not name then
        name = 'Default'
    end

    if not Timers.Timers[name] then
        Timers.Timers[name] = {}
    end

    Timers.Timers[name].Start = os.time()
    Timers.Timers[name].End   = os.time() + (minutes * 60)
    Timers.Timers[name].Group = nil

    if group then
        Timers.Timers[name].Group = group
        Timers.Groups.List[group] = true
    end

    Timers.Count = Timers.Count + 1
    sort()
end

-- --------------------------------------------------------------------------
-- End the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
-- --------------------------------------------------------------------------
Timers.End = function(name)
    if not Timers.Timers[name] then
        return nil
    end

    local group = Timers.Timers[name].Group

    Timers.Timers[name] = nil
    Timers.Count        = Timers.Count - 1

    if Timers.Count < 0 then
        Timers.Count = 0
    end

    if group and not Timers.Groups.Exists(group) then
        if Timers.Groups.List[group] then
            Timers.Groups.List[group] = nil
        end
    end

    sort()
end

-- --------------------------------------------------------------------------
-- Creates a timer from file load.
-- --------------------------------------------------------------------------
---@param name      string
---@param startTime number
---@param endTime   number
---@param group?    string true if this timer belongs to a group like a king timer.
-- --------------------------------------------------------------------------
Timers.Create = function(name, startTime, endTime, group)
    if not name or not startTime or not endTime then
        return nil
    end

    if not Timers.Timers[name] then
        Timers.Timers[name] = { }
    end

    Timers.Timers[name].Start = startTime
    Timers.Timers[name].End   = endTime
    Timers.Timers[name].Group = Timers.Groups.NO_GROUP

    if group then
        Timers.Timers[name].Group = group
        Timers.Groups.List[group] = true
    end

    Timers.Count = Timers.Count + 1
    sort()
end

-- --------------------------------------------------------------------------
-- Check the timer.
-- If the time is a countdown then start counting up after the end time passes.
-- --------------------------------------------------------------------------
---@param name       string  name of the timer to check.
---@param countdown? boolean true: count down; false: count up
---@return string|osdate, number?, boolean?
-- --------------------------------------------------------------------------
Timers.Check = function(name, countdown)
    if Timers.Timers[name] then
        if not RSVP.List.Show_Countdown then
            return timestamp(name)
        end

        local now          = os.time()
        local anchorTime   = os.time()
        local duration     = 0
        local negativeTime = false

        if countdown then
            anchorTime = Timers.Timers[name].End
            duration   = anchorTime - now

            if duration < 0 then
                duration     = now - anchorTime
                negativeTime = true
            end
        else
            anchorTime = Timers.Timers[name].Start
            duration   = now - anchorTime
        end

        return format(duration, negativeTime)
    end

    return format()  -- 00:00
end

-- --------------------------------------------------------------------------
-- Creates an date table and returns a timestamp.
-- Date and time are assumed valid.
-- --------------------------------------------------------------------------
---@param date table
---@param time table
---@return number
-- --------------------------------------------------------------------------
Timers.MakeTimeTable = function(date, time)
    local timeTable =
    {
        year  = date.year + 2000,
        month = date.month,
        day   = date.day,
        hour  = time.hour,
        min   = time.minute,
        sec   = time.second,
    }

    return os.time(timeTable)
end

-- --------------------------------------------------------------------------
-- Simulates a timer.
-- --------------------------------------------------------------------------
---@param date table
---@param time table
---@return string, string
-- --------------------------------------------------------------------------
Timers.Simulate = function(date, time)
    local stamp    = Timers.MakeTimeTable(date, time)
    local timeDiff = stamp - os.time()
    local negative = false

    if timeDiff < 0 then
        negative = true
    end

    -- Colors
    local color = Window.Colors.WHITE

    if negative then
        color = Window.Colors.RED
    else
        if timeDiff < 15 then
            color = Window.Colors.YELLOW
        end
    end

    return format(timeDiff, negative), color
end