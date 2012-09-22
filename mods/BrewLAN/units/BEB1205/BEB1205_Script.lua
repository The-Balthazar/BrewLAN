#****************************************************************************
#**
#**  Summary  :  UEF Energy Storage
#**
#****************************************************************************
local TEnergyStorageUnit = import('/lua/terranunits.lua').TEnergyStorageUnit

BEB1205 = Class(TEnergyStorageUnit) {

    OnCreate = function(self)
        TEnergyStorageUnit.OnCreate(self)
        self.Trash:Add(CreateStorageManip(self, 'B01', 'ENERGY', 0, 0, -0.6, 0, 0, 0))
    end,

    Weapon = {
	local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')
	Damage = math.floor(bp.weapon.damage * curEnergy)
    },
	
}

TypeClass = BEB1205