Timers.Groups = { }

Timers.Groups.List     = { }
Timers.Groups.Expanded = { }
Timers.Groups.NO_GROUP = "@!@!@!@!@"

-- --------------------------------------------------------------------------
-- Deletes a timer group.
-- --------------------------------------------------------------------------
---@param group string
-- --------------------------------------------------------------------------
Timers.Groups.Delete = function(group)
    for name, timerData in pairs(Timers.Timers) do
        if timerData.Group == group then
            Timers.End(name)
        end
    end
end

-- --------------------------------------------------------------------------
-- Returns a timer's group (if any).
-- --------------------------------------------------------------------------
---@param name string
---@return string|nil
-- --------------------------------------------------------------------------
Timers.Groups.Get = function(name)
    if not Timers.Timers[name] then
        return nil
    end

    if Timers.Timers[name].Group == Timers.Groups.NO_GROUP then
        return nil
    end

    return Timers.Timers[name].Group
end

-- --------------------------------------------------------------------------
-- Returns a timer's group (if any).
-- --------------------------------------------------------------------------
---@param group string
---@return boolean
-- --------------------------------------------------------------------------
Timers.Groups.Exists = function(group)
    if not group then
        return false
    end

    for _, timerData in pairs(Timers.Timers) do
        if timerData.Group == group then
            return true
        end
    end

    return false
end

-- --------------------------------------------------------------------------
-- Returns how many groups exist.
-- --------------------------------------------------------------------------
---@return integer
-- --------------------------------------------------------------------------
Timers.Groups.GroupCount = function()
    local count = 0

    for _, _ in pairs(Timers.Groups.List) do
        count = count + 1
    end

    return count
end

-- --------------------------------------------------------------------------
-- Expands a timer group.
-- --------------------------------------------------------------------------
---@param group string
-- --------------------------------------------------------------------------
Timers.Groups.Expand = function(group)
    if not group then
        return nil
    end

    Timers.Groups.Expanded[group] = true
end

-- --------------------------------------------------------------------------
-- Collapses a timer group.
-- --------------------------------------------------------------------------
---@param group string
-- --------------------------------------------------------------------------
Timers.Groups.Collapse = function(group)
    if not group then
        return nil
    end

    Timers.Groups.Expanded[group] = nil
end

-- --------------------------------------------------------------------------
-- Returns whether a group is expanded or not.
-- --------------------------------------------------------------------------
---@param group string
---@return boolean
-- --------------------------------------------------------------------------
Timers.Groups.IsExpanded = function(group)
    if not group then
        return false
    end

    return Timers.Groups.Expanded[group]
end
