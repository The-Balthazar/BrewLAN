local DirectionalWalkingLandUnit = import('/lua/defaultunits.lua').DirectionalWalkingLandUnit
local CAMEMPMissileWeapon = import('/lua/cybranweapons.lua').CAMEMPMissileWeapon

SAL0321 = Class(DirectionalWalkingLandUnit) {
    Weapons = {
        MissileRack = Class(CAMEMPMissileWeapon) {},
    },
}

TypeClass = SAL0321
