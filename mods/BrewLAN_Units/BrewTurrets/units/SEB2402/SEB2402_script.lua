local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local MaelstromDeathLaser = import('/lua/sim/defaultweapons.lua').MaelstromDeathLaser

SEB2402 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(MaelstromDeathLaser){
            --FxMuzzleFlash = {},
        },
    },
}
TypeClass = SEB2402
