#****************************************************************************
#**
#**  File     :  /data/units/XRL0302/XRL0302_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Cybran Mobile Bomb Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local util = import('/lua/utilities.lua')
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CMobileKamikazeBombDeathWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombDeathWeapon


BEB2220 = Class(TStructureUnit) {
    Weapons = {

        DeathWeapon = Class(CMobileKamikazeBombDeathWeapon) {},
        
        Suicide = Class(CMobileKamikazeBombWeapon) {        
			OnFire = function(self)			
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CMobileKamikazeBombWeapon.OnFire(self)
			end,
        },
    },

    OnCreate = function(self,builder,layer)
        TStructureUnit.OnCreate(self)
        ### enable cloaking and stealth 
        self:EnableIntel('Cloak')
        self:EnableIntel('RadarStealth')
    end,

#    DeathThread = function(self)
#        ### Removes unused bones after the unit has detonated
#        self:HideBone('UEFmine1', true)
#
#        ### Disables cloaking and stealth
#        self:DisableIntel('Cloak')
#        self:DisableIntel('RadarStealth')
#
#        ### Short delay to allow detonation effects to complete
#        WaitSeconds(2)
#
#        ### Removes the unwanted damage effects and whats left of the mine after detonation
#        self:DestroyAllDamageEffects()
#        self:Destroy()
#    end,

    MineDetonation = function(self)
        ### Scorch marks
        local pos = self:GetPosition()
        CreateDecal( pos, util.GetRandomFloat(0,2*math.pi), 'nuke_scorch_001_normals', '', 'Alpha Normals', 3, 3, 100, 50, self:GetArmy() )
        CreateDecal( pos, util.GetRandomFloat(0,2*math.pi), 'nuke_scorch_002_albedo', '', 'Albedo', 6, 6, 100, 50, self:GetArmy() )
        DamageArea(self, pos, 4, 1, 'Force', false)
    end,
}
TypeClass = BEB2220