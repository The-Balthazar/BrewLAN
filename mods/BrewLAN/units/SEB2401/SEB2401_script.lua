local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local MaelstromDeathLaser = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/weapons.lua').MaelstromDeathLaser

SEB2401 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(MaelstromDeathLaser){},
    },
}
TypeClass = SEB2401
