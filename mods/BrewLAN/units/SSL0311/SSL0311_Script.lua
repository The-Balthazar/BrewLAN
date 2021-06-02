local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SDFAireauBolterWeapon = import('/lua/seraphimweapons.lua').SDFAireauBolterWeapon02

SSL0311 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFAireauBolterWeapon) {}
    },
}

TypeClass = SSL0311
