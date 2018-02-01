local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TDFShipGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

SEB2211 = Class(TStructureUnit) {
    Weapons = {
        FrontTurret02 = Class(TDFShipGaussCannonWeapon) {},
    },
}

TypeClass = SEB2211
