Sound = T{}

Sound.Active = false
Sound.Lock_Timer = nil
Sound.Lockout_Time = 3
Sound.File = "mixkit-flute-cell-phone-alert-2315.wav" -- https://mixkit.co (I couldn't find a coo coo clock sound)

-- ------------------------------------------------------------------------------------------------------
-- Plays a sound.
-- ------------------------------------------------------------------------------------------------------
Sound.Play_Sound = function()
    if not Sound.Active then
        local path = addon.path:append('\\sounds\\')
        Sound.Lock_Sound()
        ashita.misc.play_sound(path .. Sound.File)
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