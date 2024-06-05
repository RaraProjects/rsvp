Ashita.Chat = T{}

Ashita.Chat.Selection = T{
    Title = "Chat Mode",
    Width = 150,
}

Ashita.Chat.Modes = {
    [1] = {Name = "Party", Prefix = "/p"},
    [2] = {Name = "Linkshell 1", Prefix = "/l"},
    [3] = {Name = "Linkshell 2", Prefix = "/l2"},
}

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat. This is meant to be viewed by other people.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
Ashita.Chat.Add_To_Chat = function(type, message)
    AshitaCore:GetChatManager():QueueCommand(1, tostring(type) .. " " .. tostring(message))
end