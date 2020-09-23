local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local MissileFlare = import('/lua/defaultunits.lua').BaseDirectionalAntiMissileFlare

local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SIFBombZhanaseeWeapon = SeraphimWeapons.SIFBombZhanaseeWeapon
local SLaanseMissileWeapon = SeraphimWeapons.SLaanseMissileWeapon
local SANHeavyCavitationTorpedo = SeraphimWeapons.SANHeavyCavitationTorpedo
--local SB0OhwalliExperimentalStrategicBombWeapon = SeraphimWeapons.SB0OhwalliExperimentalStrategicBombWeapon

SSA0314 = Class(SAirUnit, MissileFlare) {
    Weapons = {
        Bomb = Class(SIFBombZhanaseeWeapon) {},
        Torpedo = Class(SANHeavyCavitationTorpedo) {},
        CruiseMissile = Class(SLaanseMissileWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        SAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_StealthToggle', true)
        self:CreateMissileDetector()
    end,

    FlareBones = {'Ring_C'},
    --ContrailEffects = {'/effects/emitters/contrail_ser_ohw_polytrail_01_emit.bp',},
}

TypeClass = SSA0314
