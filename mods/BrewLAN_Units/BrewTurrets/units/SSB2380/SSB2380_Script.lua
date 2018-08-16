local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local DisarmBeamWeapon = import('/lua/sim/defaultweapons.lua').DisarmBeamWeapon

SSB2380 = Class(SStructureUnit) {
    Weapons = {
        MainGun = Class(DisarmBeamWeapon) {},
    },
}
TypeClass = SSB2380
