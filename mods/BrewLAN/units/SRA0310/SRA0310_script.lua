--------------------------------------------------------------------------------
--  Summary  :  Cybran Spy Plane Script
--------------------------------------------------------------------------------
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit

SRA0310 = Class(CAirUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,

    OnScriptBitSet = function(self, bit)
        CAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            local speedMult = 0.26666666666667
            local accelMult = 0.25
            local turnMult = 0.25
            if __blueprints.ura0401.MaxAirspeed and __blueprints.sra0310.MaxAirspeed then
                speedMult = __blueprints.ura0401.MaxAirspeed / __blueprints.sra0310.MaxAirspeed
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

TypeClass = SRA0310
