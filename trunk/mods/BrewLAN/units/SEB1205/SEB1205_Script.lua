#****************************************************************************
#**
#**  Summary  :  UEF Energy Storage
#**
#****************************************************************************
local TEnergyStorageUnit = import('/lua/terranunits.lua').TEnergyStorageUnit
local BareBonesWeapon = import('/lua/sim/DefaultWeapons.lua').BareBonesWeapon

SEB1205 = Class(TEnergyStorageUnit) {

    OnCreate = function(self)
        TEnergyStorageUnit.OnCreate(self)
        self.Trash:Add(CreateStorageManip(self, 'B01', 'ENERGY', 0, 0, -0.6, 0, 0, 0))
    end,

    Weapons = {
	DeathWeapon = Class(BareBonesWeapon) {

	    OnCreate = function(self)
	        BareBonesWeapon.OnCreate(self)
	        local myBlueprint = self:GetBlueprint()
	        self.Data = {
		    Damage = 5000,
	        }
	        self:SetWeaponEnabled(false)
	    end,

	    OnFire = function(self)
	    end,

	    Fire = function(self)
	        local myBlueprint = self:GetBlueprint()
	        local myProjectile = self.unit:CreateProjectile( myBlueprint.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
	        if self.Data then
	            myProjectile:PassData(self.Data)
	        end
	    end,
	},
    },	
}

TypeClass = SEB1205