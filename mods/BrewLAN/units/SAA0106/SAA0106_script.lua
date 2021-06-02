--------------------------------------------------------------------------------
--  Summary  :  Aeon Torpedo Bomber Script
--------------------------------------------------------------------------------
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AANDepthChargeBombWeapon = import('/lua/aeonweapons.lua').AANDepthChargeBombWeapon

SAA0106 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(AANDepthChargeBombWeapon) {},
    },
}

TypeClass = SAA0106
