local SShieldStructureUnit = import('/lua/seraphimunits.lua').SShieldStructureUnit

SSB4401_Large = Class(SShieldStructureUnit) {

    ShieldEffects = {
        --'/effects/emitters/seraphim_shield_generator_t3_01_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_02_emit.bp',
        --'/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        --'/effects/emitters/seraphim_shield_generator_t3_04_emit.bp',
        --'/effects/emitters/seraphim_shield_generator_t3_05_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        SShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        SShieldStructureUnit.OnShieldEnabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):OffsetEmitter( 0,-4, 0) )
        end
    end,

    OnShieldDisabled = function(self)
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
}

TypeClass = SSB4401_Large
