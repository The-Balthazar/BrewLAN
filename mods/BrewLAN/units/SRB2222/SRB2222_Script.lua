#****************************************************************************
#**
#**  File     :  /data/units/XRL0302/XRL0302_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Cybran Mobile Bomb Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CIFCommanderDeathWeapon = import('/lua/cybranweapons.lua').CIFCommanderDeathWeapon
local CMobileKamikazeBombDeathWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombDeathWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SRB2222 = Class(CStructureUnit) {
    Weapons = {

        DeathWeapon = Class(CIFCommanderDeathWeapon) {},
        
        Suicide = Class(CIFCommanderDeathWeapon) {       
			OnFire = function(self)			
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CIFCommanderDeathWeapon.OnFire(self)
			end,
        },
    },

    OnCreate = function(self,builder,layer)
        CStructureUnit.OnCreate(self)
        ### enable cloaking and stealth 
        self:EnableIntel('Cloak')
        self:EnableIntel('RadarStealth')
        self:EnableIntel('SonarStealth')
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CStructureUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self:GetBlueprint()    
	if self:GetCurrentLayer() == 'Water' then
            self.Trash:Add(CreateAnimator(self):PlayAnim(bp.Display.AnimationOpen))
	end
    end,

    OnScriptBitSet = function(self, bit)
        CStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 

            self:GetWeaponByLabel('Suicide'):Fire()
        end
    end,
}
TypeClass = SRB2222