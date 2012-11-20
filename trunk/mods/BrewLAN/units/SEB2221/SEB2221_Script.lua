#****************************************************************************
#**
#**  Summary  :  UEF Stationary Explosive Script
#**
#****************************************************************************
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CMobileKamikazeBombDeathWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombDeathWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SEB2221 = Class(TStructureUnit) {
    Weapons = {

        DeathWeapon = Class(CMobileKamikazeBombDeathWeapon) {},
        
        Suicide = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.TAntiMatterShellHit01,  
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
        self:EnableIntel('SonarStealth')
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self:GetBlueprint()    
	if self:GetCurrentLayer() == 'Water' then
            self.Trash:Add(CreateAnimator(self):PlayAnim(bp.Display.AnimationOpen))
	end
    end,

    OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 

            self:GetWeaponByLabel('Suicide'):FireWeapon()
        end
    end,
}
TypeClass = SEB2221