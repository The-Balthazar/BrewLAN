--------------------------------------------------------------------------------
local OLDSSB0401 = SSB0401
SSB0401 = Class(OLDSSB0401) {
--------------------------------------------------------------------------------
-- Button controls
--------------------------------------------------------------------------------
    OnScriptBitSet = function(self, bit)
        OLDSSB0401.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.airmode = true
            BuildModeChange(self)
        end
    end,

    OnScriptBitClear = function(self, bit)
        OLDSSB0401.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.airmode = false
            BuildModeChange(self)
        end
    end,
}

TypeClass = SSB0401
