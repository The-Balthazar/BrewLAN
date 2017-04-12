local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local DisarmBeamWeapon = import('/mods/brewlan_units/brewturrets/lua/weapons.lua').DisarmBeamWeapon

SSB2380 = Class(SStructureUnit) {
    Weapons = {
        MainGun = Class(DisarmBeamWeapon) {},
    },
}
TypeClass = SSB2380
