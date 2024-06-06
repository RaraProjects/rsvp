Sound = T{}

Sound.Active = false
Sound.Lock_Timer = nil
Sound.Lockout_Time = 3

Sound.WARNING = "warning"
Sound.ALERT = "alert"

-- https://mixkit.co
Sound.Files = T{
    [Sound.ALERT] = "mixkit-gold-coin-prize-1999.wav",
    [Sound.WARNING] = "mixkit-flute-cell-phone-alert-2315.wav"
}

-- ------------------------------------------------------------------------------------------------------
-- Plays a sound.
-- ------------------------------------------------------------------------------------------------------
---@param sound_type string
-- ------------------------------------------------------------------------------------------------------
Sound.Play_Sound = function(sound_type)
    if not Sound.Active and sound_type and Sound.Files[sound_type] then
        local path = addon.path:append('\\sounds\\')
        Sound.Lock_Sound()
        ashita.misc.play_sound(path .. Sound.Files[sound_type])
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Locks the sound player so that multiple sounds can't happen at once.
-- ------------------------------------------------------------------------------------------------------
Sound.Lock_Sound = function()
    Sound.Active = true
    Sound.Lock_Timer = os.time()
end

-- ------------------------------------------------------------------------------------------------------
-- Unlocks the sound player.
-- ------------------------------------------------------------------------------------------------------
Sound.Unlock_Sound = function()
    if Sound.Active and Sound.Lock_Timer then
        local now = os.time()
        if (now - Sound.Lock_Timer) >= Sound.Lockout_Time then
            Sound.Active = false
            Sound.Lock_Timer = nil
        end
    end
end