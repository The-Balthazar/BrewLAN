#****************************************************************************
#**
#**  File     :  /BEB2404/BEB2404_script.lua
#**  Author(s):  Sean Wheeldon
#**
#**  Summary  :  Experemental Point Defence System
#**
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TRadarUnit = import('/lua/terranunits.lua').TRadarUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

BEB2404 = Class(TStructureUnit) {

# Gun section A control ---------------------------

    Weapons = {
        GunA01 = Class(TDFGaussCannonWeapon) {},
        GunA02 = Class(TDFGaussCannonWeapon) {},
        GunA03 = Class(TDFGaussCannonWeapon) {},
        GunA04 = Class(TDFGaussCannonWeapon) {},
    },


# Radar dish control ---------------------------

    OnIntelDisabled = function(self)
        TRadarUnit.OnIntelDisabled(self)
        self.UpperRotator:SetTargetSpeed(0)
        self.LowerRotator:SetTargetSpeed(0)
    end,

    OnIntelEnabled = function(self)
        TRadarUnit.OnIntelEnabled(self)
        if not self.UpperRotator then
            self.UpperRotator = CreateRotator(self, 'Radar', 'y')
            self.Trash:Add(self.UpperRotator)
            self.UpperRotator:SetAccel(5)
        end
        self.UpperRotator:SetTargetSpeed(10)
    end,

}
TypeClass = BEB2404