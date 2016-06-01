#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB5101/UAB5101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Wall Piece Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SShieldStructureUnit = import('/lua/seraphimunits.lua').SShieldStructureUnit

SSB5301 = Class(SShieldStructureUnit) {
    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t2_01_emit.bp',
        
     #   '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
     #   '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
    },
    OnStopBeingBuilt = function(self,builder,layer)
        SShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
		  self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        self.ShieldIsEnabled = true
        SShieldStructureUnit.OnShieldEnabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		      self.ShieldEffectsBag = {}
		  end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.475) )
        end
        table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), '/effects/emitters/aeon_shield_generator_mobile_01_emit.bp' ):ScaleEmitter(1) )
    end,

    OnShieldDisabled = function(self)
        self.ShieldIsEnabled = false
        SShieldStructureUnit.OnShieldDisabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		      self.ShieldEffectsBag = {}
		  end
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        SShieldStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.ShieldEffctsBag then
            for k,v in self.ShieldEffectsBag do
                v:Destroy()
            end
        end
    end,
      
    OnDamage = function(self, instigator, amount, vector, damageType)
        local shieldHealth = self.MyShield:GetHealth()
        if self:ShieldIsOn() and self.MyShield:GetHealth() > 0 and self.ShieldIsEnabled then 
            self.MyShield:OnDamage(instigator, math.min(amount, shieldHealth), vector, damageType)
            --LOG(repr(instigator))
            SShieldStructureUnit.OnDamage(self, instigator, amount - shieldHealth, vector, damageType)
        else
            SShieldStructureUnit.OnDamage(self, instigator, amount, vector, damageType)
        end
    end,  
}

TypeClass = SSB5301
