local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TOrbitalDeathLaserBeamWeapon = import('/lua/terranweapons.lua').TOrbitalDeathLaserBeamWeapon

SEB2401 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TOrbitalDeathLaserBeamWeapon){},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
        LOG("Test")
    end,
}
TypeClass = SEB2401
