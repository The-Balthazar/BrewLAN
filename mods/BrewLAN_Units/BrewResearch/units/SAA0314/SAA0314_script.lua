local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local MissileFlare = import('/lua/defaultunits.lua').BaseDirectionalAntiMissileFlare

local AeonWeapons = import('/lua/aeonweapons.lua')
local AIFBombQuarkWeapon = AeonWeapons.AIFBombQuarkWeapon
local ACruiseMissileWeapon = AeonWeapons.ACruiseMissileWeapon
local AANDepthChargeBombWeapon = AeonWeapons.AANDepthChargeBombWeapon

SAA0314 = Class(AAirUnit, MissileFlare) {
    Weapons = {
        Bomb = Class(AIFBombQuarkWeapon) {},
        CruiseMissile = Class(ACruiseMissileWeapon) {},
        Torpedo = Class(AANDepthChargeBombWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_StealthToggle', true)
        self:CreateMissileDetector()
    end,

    FlareBones = {'Diamond'},
}

TypeClass = SAA0314
