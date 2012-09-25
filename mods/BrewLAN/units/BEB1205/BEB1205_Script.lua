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

    OnKilled = function(self, instigator, type, overkillRatio)

	local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')

	self:GetBlueprint().Weapon.Damage = math.floor(self:GetBlueprint().Weapon.DamageFull * curEnergy)

        self.Trash:Destroy()
        self.Trash = TrashBag() 

    end,
	
}

TypeClass = BEB1205