--------------------------------------------------------------------------------
--  Summary  :  Cybran Strategic Bomber Script
--------------------------------------------------------------------------------
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon

SRA0211 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(CIFBombNeutronWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_StealthToggle', true)
    end,
}

TypeClass = SRA0211
