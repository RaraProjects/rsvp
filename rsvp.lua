--[[
Copyright © 2024, Metra of HorizonXI
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of React nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL --Metra-- BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

addon.author = "Metra"
addon.name = "rsvp"
addon.version = "0.9.0"

Settings = require("settings")

_Globals = T{}
_Globals.Initialized = false

RSVP = T{}

UI = require("imgui")
require("ashita._ashita")
require("gui._window")
require("timers")
require("file")

-- ------------------------------------------------------------------------------------------------------
-- Catch the screen rendering packet.
-- ------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function ()
    if not _Globals.Initialized then
        if not Ashita.Player.Is_Logged_In() then return nil end

        -- Initialize settings from file.
        RSVP.Settings = T{
            Clock = Settings.load(Clock.Defaults, "clock"),
            List = Settings.load(List.Defaults, "list"),
            Reminder = Settings.load(Reminder.Defaults, "reminder"),
        }

        Clock.Initialize()
        List.Initialize()
        Reminder.Initialize()
        File.Load()

        _Globals.Initialized = true
    end
    Clock.Display()
    Reminder.Display()
    List.Display()
    Sound.Unlock_Sound()
end)

------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local command_args = e.command:lower():args()
---@diagnostic disable-next-line: undefined-field
    if table.contains({"/kookoo"}, command_args[1]) or table.contains({"/koo"}, command_args[1]) then
        local arg = command_args[2]
        if arg == "new" then
            Reminder.Visible = not Reminder.Visible
        elseif arg == "clock" then
            Clock.Visible = not Clock.Visible
        elseif arg == "timers" or arg == "list" then
            List.Visible = not List.Visible
        elseif arg == "save" then
            File.Save()
        elseif arg == "load" then
            File.Load()
        end
    end
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    Settings.save("clock")
    Settings.save("list")
    Settings.save("reminder")
    File.Save()
end)