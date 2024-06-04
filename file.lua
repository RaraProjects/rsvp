File = T{}

File.Addend_Path = "config\\KooKoo"
File.Filename = "timers"
File.Delimter = "|||"
File.Pattern  = "([^" .. File.Delimter .. "]+)"

-- ------------------------------------------------------------------------------------------------------
-- Write to file.
-- ------------------------------------------------------------------------------------------------------
File.Save = function()
    local path = File.Path()
    File.File_Exists(path)

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, File.Filename), "w")
    if file ~= nil then
        for timer_name, timer_data in pairs(Timers.Timers) do
            local timer_start = timer_data.Start
            local timer_end = timer_data.End
            local save_string = tostring(timer_name) .. File.Delimter .. tostring(timer_start) .. File.Delimter .. tostring(timer_end)
            file:write(save_string .. "\n")
        end
        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Load data from file.
-- ------------------------------------------------------------------------------------------------------
File.Load = function()
    local path = File.Path()
    File.File_Exists(path)
    Timers.Timers = T{}
    ---@diagnostic disable-next-line: undefined-field
    for line in io.lines(('%s/%s'):fmt(path, File.Filename)) do
        local pieces = {}
        local piece_index = 1
        for piece in string.gmatch(line, File.Pattern) do
            pieces[piece_index] = piece
            piece_index = piece_index + 1
        end
        if pieces then
            local timer_name = pieces[1]
            local timer_start = tonumber(pieces[2])
            if not timer_start then timer_start = os.time() end
            local timer_end = tonumber(pieces[3])
            if not timer_end then timer_end = os.time() end
            Timers.Create(timer_name, timer_start, timer_end)
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create the base file path.
-- ------------------------------------------------------------------------------------------------------
File.Path = function()
    local directory = tostring(AshitaCore:GetInstallPath()) .. File.Addend_Path
    ---@diagnostic disable-next-line: undefined-field
    return ('%s/'):fmt(directory)
end

-- ------------------------------------------------------------------------------------------------------
-- Check if the base directory exists. If it doesn't, create it.
-- ------------------------------------------------------------------------------------------------------
---@param path string
-- ------------------------------------------------------------------------------------------------------
File.File_Exists = function(path)
    if not ashita.fs.exists(path) then
        ashita.fs.create_dir(path)
    end
end