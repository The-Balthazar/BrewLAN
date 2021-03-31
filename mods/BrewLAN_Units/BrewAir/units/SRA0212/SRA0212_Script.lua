local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CAAAutocannon = import('/lua/cybranweapons.lua').CAAAutocannon

SRA0102 = Class(CAirUnit) {
    Weapons = {
        AutoCannon = Class(CAAAutocannon) {},
    },
}

TypeClass = SRA0102
