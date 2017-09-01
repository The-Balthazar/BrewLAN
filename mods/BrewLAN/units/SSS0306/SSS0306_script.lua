SSS0306 = Class(import('/lua/seraphimunits.lua').SHoverLandUnit) {
    Weapons = {
        TorpedoTurrets = Class(import('/lua/seraphimweapons.lua').SANHeavyCavitationTorpedo) {},
        AjelluTorpedoDefense = Class(import('/lua/seraphimweapons.lua').SDFAjelluAntiTorpedoDefense) {},
    },
}
TypeClass = SSS0306
