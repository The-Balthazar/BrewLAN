local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local MissileFlare = import('/lua/defaultunits.lua').BaseDirectionalAntiMissileFlare
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon

SRA0313 = Class(CAirUnit, MissileFlare) {
    ExhaustBones = { 'Exhaust', },
    ContrailBones = { 'Tip_001', 'Tip_009', },
    Weapons = {
        Laser = Class(CDFParticleCannonWeapon) {},
    },

    FlareBones = {'Tip_Rear_001', 'Tip_Rear_002'},

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_StealthToggle', true)
        self:CreateMissileDetector()
		self:DisableUnitIntel('Cloak')
        self:RequestRefreshUI()
    end,

    OnLayerChange = function(self, new, old)
        CAirUnit.OnLayerChange(self, new, old)
        if new == 'Land' then
            self:EnableUnitIntel('Cloak')
        else
		    self:DisableUnitIntel('Cloak')
        end
    end,
}

TypeClass = SRA0313
