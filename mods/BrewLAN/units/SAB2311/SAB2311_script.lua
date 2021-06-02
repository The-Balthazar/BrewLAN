local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

SAB2311 = Class(AStructureUnit) {
    Weapons = {
        MainGun = Class(import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon02) {},
    },
}

TypeClass = SAB2311
