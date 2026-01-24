File = { }

File.Addend_Path = 'config\\rsvp'
File.Filename    = 'timers'
File.Delimter    = '|||'
File.Pattern     = string.format("([^%s]+)", File.Delimter)
File.NO_GROUP    = '@!@!@!@!@'

-- ------------------------------------------------------------------------------------------------------
-- Create the base file path.
-- ------------------------------------------------------------------------------------------------------
local path = function()
    local directory = string.format("%s%s", AshitaCore:GetInstallPath(), File.Addend_Path)

    ---@diagnostic disable-next-line: undefined-field
    return ('%s/'):fmt(directory)
end

-- ------------------------------------------------------------------------------------------------------
-- Check if the base directory exists. If it doesn't, create it.
-- ------------------------------------------------------------------------------------------------------
---@param filePath string
-- ------------------------------------------------------------------------------------------------------
local fileExists = function(filePath)
    if not ashita.fs.exists(filePath) then
        ashita.fs.create_dir(filePath)
    end

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(filePath, File.Filename), 'r')

    if not file then
        ---@diagnostic disable-next-line: undefined-field
        file = io.open(('%s/%s'):fmt(filePath, File.Filename), 'w')

        if file then
            file:close()
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Write to file.
-- ------------------------------------------------------------------------------------------------------
File.Save = function()
    local filePath = path()

    fileExists(filePath)

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(filePath, File.Filename), 'w')

    if file ~= nil then
        for timerName, timerData in pairs(Timers.Timers) do
            local timerStart = timerData.Start
            local timerEnd   = timerData.End
            local timerGroup = timerData.Group

            if not timerGroup then
                timerGroup = Timers.Groups.NO_GROUP
            end

            local saveString = string.format(
                "%s%s%s%s%s%s%s",
                timerName,  File.Delimter,
                timerStart, File.Delimter,
                timerEnd,   File.Delimter,
                timerGroup
            )

            file:write(string.format("%s\n", saveString))
        end

        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Load data from file.
-- ------------------------------------------------------------------------------------------------------
File.Load = function()
    local filePath = path()

    fileExists(filePath)
    Timers.Timers = { }

    ---@diagnostic disable-next-line: undefined-field
    for line in io.lines(('%s/%s'):fmt(filePath, File.Filename)) do
        local pieces      = {}
        local pieceIndex = 1

        for piece in string.gmatch(line, File.Pattern) do
            pieces[pieceIndex] = piece
            pieceIndex         = pieceIndex + 1
        end

        if pieces then
            local timerName = pieces[1]
            local timerStart = tonumber(pieces[2]) or os.time()
            local timerEnd   = tonumber(pieces[3]) or os.time()
            local timerGroup = tostring(pieces[4]) or Timers.Groups.NO_GROUP

            Timers.Create(timerName, timerStart, timerEnd, timerGroup)
        end
    end
end
