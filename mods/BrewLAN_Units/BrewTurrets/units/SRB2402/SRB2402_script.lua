local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFHvyProtonCannonWeapon = import('/lua/cybranweapons.lua').CDFHvyProtonCannonWeapon

SRB2402 = Class(CStructureUnit) {
    Weapons = {
        ParticleGunLeft = Class(CDFHvyProtonCannonWeapon) {},
    },
}

TypeClass = SRB2402
