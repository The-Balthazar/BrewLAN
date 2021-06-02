local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SEB2101 = Class(TStructureUnit) {
    Weapons = {
        Riotgun01 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
    },
}

TypeClass = SEB2101
