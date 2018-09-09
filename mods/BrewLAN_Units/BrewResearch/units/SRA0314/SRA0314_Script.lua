--------------------------------------------------------------------------------
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local MissileFlare = import('/lua/defaultunits.lua').BaseDirectionalAntiMissileFlare
--------------------------------------------------------------------------------
local CybranWeapons = import('/lua/cybranweapons.lua')
local CIFBombNeutronWeapon = CybranWeapons.CIFBombNeutronWeapon
local CDFRocketIridiumWeapon = CybranWeapons.CDFRocketIridiumWeapon
local CIFNaniteTorpedoWeapon = CybranWeapons.CIFNaniteTorpedoWeapon
--------------------------------------------------------------------------------
-- Cybran Penetrator Bomber
--------------------------------------------------------------------------------
SRA0314 = Class(CAirUnit, MissileFlare) {
    Weapons = {
        Bomb = Class(CIFBombNeutronWeapon) {},
        Missile = Class(CDFRocketIridiumWeapon) {},
        Torpedo = Class(CIFNaniteTorpedoWeapon) {},
    },

    FlareBones = {'Flare_L', 'Flare_R'},

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_StealthToggle', true)
        self:CreateMissileDetector()
    end,
}
--------------------------------------------------------------------------------
TypeClass = SRA0314
