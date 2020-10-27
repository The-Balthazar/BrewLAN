local SShieldStructureUnit = import('/lua/seraphimunits.lua').SShieldStructureUnit
local ShieldStructureUnitOnShieldDisabled = import('/lua/defaultunits.lua').ShieldStructureUnit.OnShieldDisabled
local CleanShieldBag = function(self)
    if self.ShieldEffectsBag and self.ShieldEffectsBag[1] then
        for k, v in self.ShieldEffectsBag do
            v:Destroy()
        end
        if not self.Dead then
            self.ShieldEffectsBag = {}
        end
    end
end

SSB4102 = Class(SShieldStructureUnit) {
    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t2_01_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        SShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        self.ShieldActive = true
        SShieldStructureUnit.OnShieldEnabled(self)
        CleanShieldBag(self)
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.5) )
        end
    end,

    OnShieldDisabled = function(self)
        if self.Dead then
            ShieldStructureUnitOnShieldDisabled(self)
        else
            self.ShieldActive = nil
            SShieldStructureUnit.OnShieldDisabled(self)
        end
        CleanShieldBag(self)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        SShieldStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.AnimationManipulator then
            self.AnimationManipulator:Destroy()
        end
        CleanShieldBag(self)
    end,

    PlayAnimationThread = function(self, anim, rate)
        if anim == 'AnimationDeath' then
            if self.ShieldActive then
                local bp = self:GetBlueprint().Display[anim]
                self.DeathAnimManip = CreateAnimator(self)
                self.DeathAnimManip:PlayAnim(bp[1].Animation):SetRate(1)
                self.Trash:Add(self.DeathAnimManip)
                WaitFor(self.DeathAnimManip)
            end
        else
            SShieldStructureUnit.PlayAnimationThread(self, anim, rate)
        end
    end,
}

TypeClass = SSB4102
