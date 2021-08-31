local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFHeavyMicrowaveLaserGeneratorCom--import('/lua/cybranweapons.lua').CDFParticleCannonWeapon

URB2301 = Class(CStructureUnit) {
    Weapons = {
        MainGun = Class(CDFParticleCannonWeapon) { },
    },
}

TypeClass = URB2301
