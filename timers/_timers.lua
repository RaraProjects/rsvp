Timers = T{}

Timers.Timers = T{}
Timers.Sorted = T{}
Timers.Count = 0

Timers.Errors = T{
    NO_ERROR = "No Error",
    ERROR    = "Error",
    NO_NAME  = "Name is required.",
    EXISTS   = "Timer already exists.",
}

require("timers.groups")

-- --------------------------------------------------------------------------
-- Start the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
---@param minutes number number of minutes from now for the timer.
---@param group? string name of the group for a set of related timers.
-- --------------------------------------------------------------------------
Timers.Start = function(name, minutes, group)
    if not name then name = "Default" end
    if not Timers.Timers[name] then Timers.Timers[name] = {} end
    Timers.Timers[name].Start = os.time()
    Timers.Timers[name].End   = os.time() + (minutes * 60)
    Timers.Timers[name].Group = nil
    if group then
        Timers.Timers[name].Group = group
        Timers.Groups.List[group] = true
    end
    Timers.Count = Timers.Count + 1
    Timers.Sort()
end

-- --------------------------------------------------------------------------
-- End the timer.
-- --------------------------------------------------------------------------
---@param name string name of the timer to check.
-- --------------------------------------------------------------------------
Timers.End = function(name)
    if not Timers.Timers[name] then return nil end
    local group = Timers.Timers[name].Group
    Timers.Timers[name] = nil
    Timers.Count = Timers.Count - 1
    if Timers.Count < 0 then Timers.Count = 0 end
    if group and not Timers.Groups.Exists(group) then
        if Timers.Groups.List[group] then Timers.Groups.List[group] = nil end
    end
    Timers.Sort()
end

-- --------------------------------------------------------------------------
-- Creates a timer from file load.
-- --------------------------------------------------------------------------
---@param name string
---@param start_time number
---@param end_time number
---@param group? string true if this timer belongs to a group like a king timer.
-- --------------------------------------------------------------------------
Timers.Create = function(name, start_time, end_time, group)
    if not name or not start_time or not end_time then return nil end
    if not Timers.Timers[name] then Timers.Timers[name] = T{} end
    Timers.Timers[name].Start = start_time
    Timers.Timers[name].End   = end_time
    Timers.Timers[name].Group = Timers.Groups.NO_GROUP
    if group then
        Timers.Timers[name].Group = group
        Timers.Groups.List[group] = true
    end
    Timers.Count = Timers.Count + 1
    Timers.Sort()
end

-- --------------------------------------------------------------------------
-- Sorts the timers by due time. Earliest due times come first.
-- --------------------------------------------------------------------------
Timers.Sort = function()
    Timers.Sorted = T{}
    for name, timer_data in pairs(Timers.Timers) do
        table.insert(Timers.Sorted, {name, timer_data.End})
    end
    table.sort(Timers.Sorted, function (a, b)
		local a_time = a[2]
		local b_time = b[2]
		return (a_time < b_time)
	end)
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

        if not negative_time and Config.Warning_Sound() then
            if duration == Config.Get_Warning_Sound_Time() then Sound.Play_Sound(Sound.WARNING) end
        end

        if duration == 0 then
            Sound.Play_Sound(Sound.ALERT)
        end

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
    if not time then return "00:00", 0 end
    local sign = "-"
    if negative_time then sign = "+" end
    time = math.abs(time)
    local hour   = string.format("%02d", math.floor(time / 3600))
    local minute = string.format("%02d", math.floor((time / 60) - (hour * 60)))
    local second = string.format("%02d", math.floor(time % 60))

    if hour and tonumber(hour) > 99 then return "LONG", time, negative_time end
    return sign .. hour .. ":" .. minute .. ":" .. second, time, negative_time
end

-- --------------------------------------------------------------------------
-- Simulates a timer.
-- --------------------------------------------------------------------------
---@return string, string
-- --------------------------------------------------------------------------
Timers.Simulate = function()
    local time = Create.Handle_Date_Input() - os.time()
    local negative = false
    if time < 0 then negative = true end

    local color = Window.Colors.WHITE
    if negative then
        color = Window.Colors.RED
    else
        if time < 15 then color = Window.Colors.YELLOW end
    end

    return Timers.Format(time, negative), color
end

-- ------------------------------------------------------------------------------------------------------
-- Determines if a timer can be created or not.
-- Cannot create a timer if there isn't a name provided or a timer with same name already exists.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
Timers.Validate = function()
    local timer_name = Inputs.Name()
    if not timer_name then
        return Timers.Errors.ERROR
    elseif string.len(timer_name) == 0 then
        return Timers.Errors.NO_NAME
    elseif Timers.Timers[timer_name] then
        return Timers.Errors.EXISTS
    end
    return Timers.Errors.NO_ERROR
end

-- ------------------------------------------------------------------------------------------------------
-- Reports a timer to chat.
-- ------------------------------------------------------------------------------------------------------
---@param timer_name string
-- ------------------------------------------------------------------------------------------------------
Timers.Report = function(timer_name)
    if not timer_name then return nil end
    if not Timers.Timers[timer_name] then return nil end
    Ashita.Chat.Add_To_Chat(List.Publishing.Chat_Mode.Prefix, tostring(Timers.Check(timer_name, true)))
end