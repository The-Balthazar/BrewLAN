local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CIFNaniteTorpedoWeapon = import('/lua/cybranweapons.lua').CIFNaniteTorpedoWeapon

SRA0307 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(CIFNaniteTorpedoWeapon) {},
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self:EnableUnitIntel('RadarStealth')
    end,
}

TypeClass = SRA0307
