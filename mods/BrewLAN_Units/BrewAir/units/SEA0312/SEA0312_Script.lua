--------------------------------------------------------------------------------
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TIFCruiseMissileLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileLauncher
--------------------------------------------------------------------------------
SEA0312 = Class(TAirUnit) {
    Weapons = {
        Missile = Class(TIFCruiseMissileLauncher) {},
    },
}

TypeClass = SEA0312
