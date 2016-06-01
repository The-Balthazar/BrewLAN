local AShieldStructureUnit = import('/lua/aeonunits.lua').AShieldStructureUnit
local CardinalWallUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/walls.lua').CardinalWallUnit
AShieldStructureUnit = CardinalWallUnit( AShieldStructureUnit ) 

SAB5301 = Class( AShieldStructureUnit ) {
    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',  -- tight floor pulse
        '/effects/emitters/aeon_shield_generator_t2_02_emit.bp',-- eclipse thing
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',  -- fuzzy circle
        --'/effects/emitters/aeon_shield_generator_t3_04_emit.bp',-- floor spread
    },
    OnStopBeingBuilt = function(self,builder,layer)
        AShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
		  self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        self.ShieldIsEnabled = true
        AShieldStructureUnit.OnShieldEnabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		      self.ShieldEffectsBag = {}
		  end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.49) )
        end
        table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), '/effects/emitters/aeon_shield_generator_mobile_01_emit.bp' ):ScaleEmitter(1) )
    end,

    OnShieldDisabled = function(self)
        self.ShieldIsEnabled = false
        AShieldStructureUnit.OnShieldDisabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		      self.ShieldEffectsBag = {}
		  end
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        AShieldStructureUnit.OnKilled(self, instigator, type, overkillRatio)
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
            AShieldStructureUnit.OnDamage(self, instigator, amount - shieldHealth, vector, damageType)
        else
            AShieldStructureUnit.OnDamage(self, instigator, amount, vector, damageType)
        end
    end,  
}

TypeClass = SAB5301
