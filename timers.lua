Timers = T{}

Timers.Timers = T{}

-- --------------------------------------------------------------------------
-- Start the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
---@param minutes number number of minutes from now for the timer.
-- --------------------------------------------------------------------------
Timers.Start = function(name, minutes)
    if not name then name = "Default" end
    if not Timers.Timers[name] then Timers.Timers[name] = {} end
    Timers.Timers[name].Start = os.time()
    Timers.Timers[name].End   = os.time() + (minutes * 60)
end

-- --------------------------------------------------------------------------
-- End the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
-- --------------------------------------------------------------------------
Timers.End = function(name)
    if Timers.Timers[name] then
        Timers.Timers[name] = nil
    end
end

-- --------------------------------------------------------------------------
-- Creates a timer from file load.
-- --------------------------------------------------------------------------
---@param name string
---@param start_time number
---@param end_time number
-- --------------------------------------------------------------------------
Timers.Create = function(name, start_time, end_time)
    if not name or not start_time or not end_time then return nil end
    if not Timers.Timers[name] then Timers.Timers[name] = T{} end
    Timers.Timers[name].Start = start_time
    Timers.Timers[name].End   = end_time
end

-- --------------------------------------------------------------------------
-- Check the timer.
-- If the time is a countdown then start counting up after the end time passes.
-- Play a sound when the timer reaches zero.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
---@param countdown? boolean true: count down; false: count up
---@return string
-- --------------------------------------------------------------------------
Timers.Check = function(name, countdown)
    if Timers.Timers[name] then
        local now = os.time()
        local anchor_time = os.time()
        local duration = 0
        local negative_time = false

        if countdown then
            anchor_time = Timers.Timers[name].End
            duration = anchor_time - now
            if duration < 0 then
                duration = now - anchor_time
                negative_time = true
            end
        else
            anchor_time = Timers.Timers[name].Start
            duration = now - anchor_time
        end

        if duration == 0 then Sound.Play_Sound() end

        return Timers.Format(duration, negative_time)
    end
    return Timers.Format()
end

-- --------------------------------------------------------------------------
-- Formats the display timer.
-- --------------------------------------------------------------------------
---@param time? number duration in seconds.
---@param negative_time? boolean if a countdown is negative add negative sign. 
---@return string, number?, boolean|nil?
-- --------------------------------------------------------------------------
Timers.Format = function(time, negative_time)
    if not time then return '00:00', 0 end
    local sign = "-"
    if negative_time then sign = "+" end
    local hour, minute, second
    hour   = string.format("%02.f", math.floor(time / 3600))
    minute = string.format("%02.f", math.floor((time / 60) - (hour * 60)))
    second = string.format("%02.f", math.floor(time % 60))

    if hour and tonumber(hour) > 99 then return "LONG", time, negative_time end
    return sign .. hour .. ":" .. minute .. ":" .. second, time, negative_time
end