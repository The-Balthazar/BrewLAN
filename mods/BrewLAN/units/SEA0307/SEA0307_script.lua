--------------------------------------------------------------------------------
--  Summary  :  UEF Torpedo Bomber Script
--------------------------------------------------------------------------------
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun

SEA0307 = Class(TAirUnit) {
    Weapons = {
        Torpedo = Class(TANTorpedoAngler) {},
        LinkedRailGun = Class(TAirToAirLinkedRailgun) {},
    },
}

TypeClass = SEA0307
