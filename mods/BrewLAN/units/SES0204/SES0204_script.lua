local TSubUnit = import('/lua/terranunits.lua').TSubUnit
local WeaponFile = import('/lua/terranweapons.lua')
local TANTorpedoAngler = WeaponFile.TANTorpedoAngler
local TIFSmartCharge = WeaponFile.TIFSmartCharge
local TAAFlakArtilleryCannon = WeaponFile.TAAFlakArtilleryCannon
WeaponFile = nil

SES0204 = Class(TSubUnit) {
    Weapons = {
        Torpedo = Class(TANTorpedoAngler) {},
        AntiTorpedo = Class(TIFSmartCharge) {},
        AAGun = Class(TAAFlakArtilleryCannon) {},
    },
}

TypeClass = SES0204
