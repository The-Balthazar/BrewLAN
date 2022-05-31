local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local AIFMissileTacticalSerpentine02Weapon = import('/lua/aeonweapons.lua').AIFMissileTacticalSerpentine02Weapon

SAL0312 = Class(ALandUnit) {
    Weapons = {
        MissileRack = Class(AIFMissileTacticalSerpentine02Weapon) {},
    },
}

TypeClass = SAL0312
