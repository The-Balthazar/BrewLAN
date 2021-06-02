local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CMobileKamikazeBombDeathWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombDeathWeapon

SRL0318 = Class(CWalkingLandUnit) {
    Weapons = {
        DeathWeapon = Class(CMobileKamikazeBombDeathWeapon) {},
        Suicide = Class(CMobileKamikazeBombWeapon) {
			OnFire = function(self)
				--disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CMobileKamikazeBombWeapon.OnFire(self)
			end,
        },
    },
}

TypeClass = SRL0318
