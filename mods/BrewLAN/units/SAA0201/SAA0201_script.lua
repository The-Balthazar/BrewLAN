--------------------------------------------------------------------------------
--  Summary  :  Aeon Decoy Plane Script
--  Author   :  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit

SAA0201 = Class(AAirUnit) {

    OnScriptBitSet = function(self, bit)
        AAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            local speedMult = 0.26666666666667
            local accelMult = 0.25
            local turnMult = 0.25
            if __blueprints.uaa0310
            and __blueprints.uaa0310.MaxAirspeed
            and __blueprints.saa0201
            and __blueprints.saa0201.MaxAirspeed then
                speedMult = __blueprints.uaa0310.MaxAirspeed / __blueprints.saa0201.MaxAirspeed
            end
            self:SetSpeedMult(speedMult)
            self:SetAccMult(accelMult)
            self:SetTurnMult(turnMult)
        end
    end,

    OnScriptBitClear = function(self, bit)
        AAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetSpeedMult(1)
            self:SetAccMult(1)
            self:SetTurnMult(1)
        end
    end,
}

TypeClass = SAA0201
