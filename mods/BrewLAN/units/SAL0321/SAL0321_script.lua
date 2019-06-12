local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local CAMEMPMissileWeapon = import('/lua/cybranweapons.lua').CAMEMPMissileWeapon

SAL0321 = Class(AWalkingLandUnit) {
    Weapons = {
        MissileRack = Class(CAMEMPMissileWeapon) {},
    },
}

TypeClass = SAL0321
