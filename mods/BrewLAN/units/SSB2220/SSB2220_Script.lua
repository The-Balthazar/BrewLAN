#****************************************************************************
#**
#**  Summary  :  Seraphim Stationary Explosive Script
#**
#****************************************************************************
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CMobileKamikazeBombDeathWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombDeathWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SSB2220 = Class(SStructureUnit) {
    Weapons = {

        DeathWeapon = Class(CMobileKamikazeBombDeathWeapon) {},
        
        Suicide = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.SZhanaseeBombHit01,  
			OnFire = function(self)			
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CMobileKamikazeBombWeapon.OnFire(self)
			end,
        },
    },

    OnCreate = function(self,builder,layer)
        SStructureUnit.OnCreate(self)
        ### enable cloaking and stealth 
        self:EnableIntel('Cloak')
        self:EnableIntel('RadarStealth')
        self:EnableIntel('SonarStealth')
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        SStructureUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self:GetBlueprint()    
	if self:GetCurrentLayer() == 'Water' then
            self.Trash:Add(CreateAnimator(self):PlayAnim(bp.Display.AnimationOpen))
	end
    end,

    OnScriptBitSet = function(self, bit)
        SStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 

            self:GetWeaponByLabel('Suicide'):FireWeapon()
        end
    end,
}
TypeClass = SSB2220