local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local WeaponsFile = import ('/lua/seraphimweapons.lua')
local SDFAireauWeapon = WeaponsFile.SDFAireauWeapon

SSB2306 = Class(SStructureUnit) {
    Weapons = {
        MainGun = Class(SDFAireauWeapon) {},
    },
}

TypeClass = SSB2306
