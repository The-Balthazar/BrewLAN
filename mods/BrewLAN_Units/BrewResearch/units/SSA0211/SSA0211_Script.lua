--------------------------------------------------------------------------------
--  Summary  :  Seraphim Strategic Bomber Script
--------------------------------------------------------------------------------
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SIFBombZhanaseeWeapon = import('/lua/seraphimweapons.lua').SIFBombZhanaseeWeapon

SSA0211 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(SIFBombZhanaseeWeapon) {},
    },
}

TypeClass = SSA0211
