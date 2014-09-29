#****************************************************************************
#**
#**  Summary  :  Cybran Stationary Explosive Script
#**
#****************************************************************************

local NukeMineStructureUnit = import('/mods/brewlan/lua/defaultunits.lua').NukeMineStructureUnit
local CIFCommanderDeathWeapon = import('/lua/cybranweapons.lua').CIFCommanderDeathWeapon

SRB2222 = Class(CStructureUnit) {
    Weapons = {
        DeathWeapon = Class(CIFCommanderDeathWeapon) {},
        Suicide = Class(CIFCommanderDeathWeapon) {},
    },
}
TypeClass = SRB2222