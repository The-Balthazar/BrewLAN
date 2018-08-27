--------------------------------------------------------------------------------
local OLDSRB0401 = SRB0401
SRB0401 = Class(OLDSRB0401) {
--------------------------------------------------------------------------------
-- Button controls
--------------------------------------------------------------------------------
    OnScriptBitSet = function(self, bit)
        OLDSRB0401.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.airmode = true
            BuildModeChange(self)
        end
    end,

    OnScriptBitClear = function(self, bit)
        OLDSRB0401.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.airmode = false
            BuildModeChange(self)
        end
    end,
}

TypeClass = SRB0401
