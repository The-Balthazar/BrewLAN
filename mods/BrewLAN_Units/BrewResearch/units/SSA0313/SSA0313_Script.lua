--------------------------------------------------------------------------------
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local MissileFlare = import('/lua/defaultunits.lua').BaseDirectionalAntiMissileFlare
--------------------------------------------------------------------------------
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SAALosaareAutoCannonWeapon = SeraphimWeapons.SAALosaareAutoCannonWeaponAirUnit
local SDFUnstablePhasonBeam = SeraphimWeapons.SDFUnstablePhasonBeam

SSA0313 = Class(SAirUnit, MissileFlare) {
    Weapons = {
        AutoCannon = Class(SAALosaareAutoCannonWeapon) {},
        PhasonBeam = Class(SDFUnstablePhasonBeam) {},
    },

    FlareBones = {'Smol_Ring'},

    OnStopBeingBuilt = function(self,builder,layer)
        SAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_StealthToggle', true)
        self:CreateMissileDetector()
		self:DisableUnitIntel('Cloak')
        self:RequestRefreshUI()
    end,

    OnLayerChange = function(self, new, old)
        SAirUnit.OnLayerChange(self, new, old)
        if new == 'Land' then
            self:EnableUnitIntel('Cloak')
        else
		    self:DisableUnitIntel('Cloak')
        end
    end,
}

TypeClass = SSA0313
