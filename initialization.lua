------------------------------------------------------------------------------------------------------
-- Load settings when the addon is loaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    RSVP = T{
        Clock  = Settings.load(Clock.Defaults, Clock.ALIAS),
        List   = Settings.load(List.Defaults, List.ALIAS),
        Create = Settings.load(Create.Defaults, Create.ALIAS),
        Config = Settings.load(Config.Defaults, Config.ALIAS)
    }
    File.Load()
    _Globals.Initialized = true
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    Settings.save(Clock.ALIAS)
    Settings.save(List.ALIAS)
    Settings.save(Create.ALIAS)
    Settings.save(Config.ALIAS)
    File.Save()
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific MP settings.
------------------------------------------------------------------------------------------------------
Settings.register(Clock.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        RSVP.Clock = settings
        Clock.Reset_Position = true
        Settings.save(Clock.ALIAS)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific MP settings.
------------------------------------------------------------------------------------------------------
Settings.register(List.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        RSVP.List = settings
        List.Reset_Position = true
        Settings.save(List.ALIAS)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific MP settings.
------------------------------------------------------------------------------------------------------
Settings.register(Create.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        RSVP.Create = settings
        Create.Reset_Position = true
        Settings.save(Create.ALIAS)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific MP settings.
------------------------------------------------------------------------------------------------------
Settings.register(Config.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        RSVP.Config = settings
        Config.Reset_Position = true
        Settings.save(Config.ALIAS)
    end
end)