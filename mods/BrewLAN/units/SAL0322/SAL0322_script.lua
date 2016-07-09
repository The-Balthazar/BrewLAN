local AShieldHoverLandUnit = import('/lua/aeonunits.lua').AShieldHoverLandUnit

SAL0322 = Class(AShieldHoverLandUnit) {
    
    ShieldEffects = {      
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        '/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
       -- '/effects/emitters/aeon_shield_generator_mobile_01_emit.bp',
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        AShieldHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.ShieldEffectsBag = {}
    end,
    
    OnShieldEnabled = function(self)
        AShieldHoverLandUnit.OnShieldEnabled(self)
        if not self.Animator then
            self.Animator = CreateAnimator(self)
            self.Trash:Add(self.Animator)
            self.Animator:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
        end
        self.Animator:SetRate(1)
        if not self.Rotarybits then
           self.Rotarybits = {}
           self.Rotarybits[1] = CreateRotator(self, 'Ring1', 'z', nil, 0, 45, math.random(-45, 45 ) )
           self.Rotarybits[2] = CreateRotator(self, 'Ring2', 'z', nil, 0, 45, math.random(-45, 45 ) )
           self.Rotarybits[3] = CreateRotator(self, 'GeoSphere', 'z', nil, 0, 45, math.random(-45, 45 ) )
           self.Rotarybits[4] = CreateRotator(self, 'GeoSphere', 'z', nil, 0, 45, math.random(-45, 45 ) )
           self.Rotarybits[5] = CreateRotator(self, 'GeoSphere', 'y', nil, 0, 45, math.random(-45, 45 ) ) 
        end    
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.15):OffsetEmitter(0,.1,-.1) )
        end
    end,

    OnShieldDisabled = function(self)
        AShieldHoverLandUnit.OnShieldDisabled(self)
        if self.Animator then
            self.Animator:SetRate(-1)
        end
         
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,


}

TypeClass = SAL0322
