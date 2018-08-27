--------------------------------------------------------------------------------
local OLDSAB0401 = SAB0401
SAB0401 = Class(OLDSAB0401) {
--------------------------------------------------------------------------------
-- Function triggers
--------------------------------------------------------------------------------
    --[[OnStopBeingBuilt = function(self, builder, layer)
        self:SetScriptBit('RULEUTC_WeaponToggle', false)
        OLDSAB0401.OnStopBeingBuilt(self, builder, layer)
    end,]]

--------------------------------------------------------------------------------
-- Button controls
--------------------------------------------------------------------------------
    OnScriptBitSet = function(self, bit)
        OLDSAB0401.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.airmode = false
            BuildModeChange(self)
        end
    end,

    OnScriptBitClear = function(self, bit)
        OLDSAB0401.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.airmode = true
            BuildModeChange(self)
        end
    end,
}

TypeClass = SAB0401
