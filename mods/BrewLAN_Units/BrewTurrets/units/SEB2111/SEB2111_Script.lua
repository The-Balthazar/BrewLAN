local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TDFShipGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

SEB2111 = Class(TStructureUnit) {
    Weapons = {
        FrontTurret02 = Class(TDFShipGaussCannonWeapon) {},
    },
}

TypeClass = SEB2111
