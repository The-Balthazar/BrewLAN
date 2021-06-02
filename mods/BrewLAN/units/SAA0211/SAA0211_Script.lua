--------------------------------------------------------------------------------
--  Summary  :  Aeon Bomber Script
--------------------------------------------------------------------------------
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFBombQuarkWeapon = import('/lua/aeonweapons.lua').AIFBombQuarkWeapon

SAA0211 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(AIFBombQuarkWeapon) {},
    },
}

TypeClass = SAA0211
