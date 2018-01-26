local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TDFShipGaussCannonWeapon = import('/lua/terranweapons.lua').TDFShipGaussCannonWeapon--import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/weapons.lua').MaelstromDeathLaser

SEB2401 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TDFShipGaussCannonWeapon){
            FxMuzzleFlash = {},
        },
    },
}
TypeClass = SEB2401
