local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SDFPhasicAutoGunWeapon = import('/lua/seraphimweapons.lua').SDFPhasicAutoGunWeapon
local SAALosaareAutoCannonWeapon = import('/lua/seraphimweapons.lua').SAALosaareAutoCannonWeaponAirUnit

SSA0305 = Class(SAirUnit) {
    Weapons = {
        AutoCannon1 = Class(SAALosaareAutoCannonWeapon) {},
        Turret = Class(SDFPhasicAutoGunWeapon) {},
    },
}

TypeClass = SSA0305
