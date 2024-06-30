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
addon.version = "06.30.24.00"

Settings = require("settings")
UI = require("imgui")
require("ashita._ashita")
require("gui._window")
require("config._config")
require("clock._clock")
require("rsvp_creation._rsvp_creation")
require("rsvp_list._rsvp_list")
require("timers._timers")
require("file")
require("inputs")
require("initialization")

_Globals = T{}
_Globals.Initialized = false

RSVP = T{}

-- ------------------------------------------------------------------------------------------------------
-- Catch the screen rendering packet.
-- ------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function ()
    if not _Globals.Initialized then return nil end
    if not Ashita.Player.Is_Logged_In() then return nil end
    Clock.Display()
    Create.Display()
    List.Display()
    Config.Display()
end)

------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local command_args = e.command:lower():args()
    ---@diagnostic disable-next-line: undefined-field
    if table.contains({"/rsvp"}, command_args[1]) then
        local arg = command_args[2]
        if not arg then
            Config.Toggle.Config_Window_Visibility()
        elseif arg == "create" or arg == "make" or arg == "c" or arg == "m" then
            Config.Toggle.Create_Window_Visibility()
        elseif arg == "clock" or arg == "cl" then
            Config.Toggle.Clock_Visibility()
        elseif arg == "timers" or arg == "list" or arg == "t" or arg == "l" then
            Config.Toggle.List_Window_Visibility()
        end
    end
end)