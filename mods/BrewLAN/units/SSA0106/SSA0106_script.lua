local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SANHeavyCavitationTorpedo = SeraphimWeapons.SANHeavyCavitationTorpedo

SSA0106 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(SANHeavyCavitationTorpedo) {},
    },
}

TypeClass = SSA0106
