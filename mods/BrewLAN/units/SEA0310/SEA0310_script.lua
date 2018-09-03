--------------------------------------------------------------------------------
--  Summary  :  UEF Decoy Plane Script
--------------------------------------------------------------------------------
local TAirUnit = import('/lua/terranunits.lua').TAirUnit

SEA0310 = Class(TAirUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,

    OnScriptBitSet = function(self, bit)
        CAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            local speedMult = 0.26666666666667
            local accelMult = 0.25
            local turnMult = 0.25
            if __blueprints.sra0401.MaxAirspeed and __blueprints.sea0310.MaxAirspeed then
                speedMult = __blueprints.sra0401.MaxAirspeed / __blueprints.sea0310.MaxAirspeed
            end
            self:SetSpeedMult(speedMult)
            self:SetAccMult(accelMult)
            self:SetTurnMult(turnMult)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetSpeedMult(1)
            self:SetAccMult(1)
            self:SetTurnMult(1)
        end
    end,
}

TypeClass = SEA0310
