local BrewLANCardinalWallUnit = import('/lua/defaultunits.lua').BrewLANCardinalWallUnit

SAB5301 = Class( BrewLANCardinalWallUnit ) {

    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',  -- tight floor pulse
        '/effects/emitters/aeon_shield_generator_t2_02_emit.bp',  -- eclipse thing
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',  -- fuzzy circle
    },
    OnStopBeingBuilt = function(self,builder,layer)
        BrewLANCardinalWallUnit.OnStopBeingBuilt(self,builder,layer)
		self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        self.ShieldIsEnabled = true
        BrewLANCardinalWallUnit.OnShieldEnabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		      self.ShieldEffectsBag = {}
		  end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.49) )
        end
        table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), '/effects/emitters/aeon_shield_generator_mobile_01_emit.bp' ) )
    end,

    OnShieldDisabled = function(self)
        self.ShieldIsEnabled = false
        BrewLANCardinalWallUnit.OnShieldDisabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        BrewLANCardinalWallUnit.OnKilled(self, instigator, type, overkillRatio)
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
            BrewLANCardinalWallUnit.OnDamage(self, instigator, amount - shieldHealth, vector, damageType)
        else
            BrewLANCardinalWallUnit.OnDamage(self, instigator, amount, vector, damageType)
        end
    end,
}

TypeClass = SAB5301
