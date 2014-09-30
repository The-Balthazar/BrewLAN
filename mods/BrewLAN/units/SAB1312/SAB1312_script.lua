#****************************************************************************
#**
#**  Summary  :  Aeon Shielded Mass Extractor Script
#**
#****************************************************************************

local AMassCollectionUnit = import('/lua/aeonunits.lua').AMassCollectionUnit

SAB1312 = Class(AMassCollectionUnit) {
         
    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        --'/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },
    
    OnCreate = function(self)
        AMassCollectionUnit.OnCreate(self)
        self.ExtractionAnimManip = CreateAnimator(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        self.ExtractionAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate):SetRate(1)
        self.Trash:Add(self.ExtractionAnimManip)
        AMassCollectionUnit.OnStopBeingBuilt(self,builder,layer)
        ChangeState(self, self.ActiveState)
	     self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        AMassCollectionUnit.OnShieldEnabled(self)
        if not self.Spinner then
            self.Spinner = CreateRotator(self, 'Ring', 'z', nil, 0, 45, -45)
            self.Trash:Add(self.OrbManip1)
        end
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.4) )
        end
    end,
   
    OnShieldDisabled = function(self)
        AShieldStructureUnit.OnShieldDisabled(self)
        if self.Spinner then
            self.Spinner:SetSpinDown(true)
            self.Spinner:SetTargetSpeed(0)
        end
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,

    ActiveState = State {
        Main = function(self)
            WaitFor(self.ExtractionAnimManip)
            while not self:IsDead() do
                
                self.ExtractionAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate):SetRate(1)
                WaitFor(self.ExtractionAnimManip)
            end
        end,

        OnProductionPaused = function(self)
            AMassCollectionUnit.OnProductionPaused(self)
            ChangeState(self, self.InActiveState)
        end,
    },

    InActiveState = State {
        Main = function(self)
            WaitFor(self.ExtractionAnimManip)
            if self.ArmsUp == true then
                self.ExtractionAnimManip:SetRate(-1)
                WaitFor(self.ExtractionAnimManip)
                self.ArmsUp = false
            end
            WaitFor(self.ExtractionAnimManip)
        end,

        OnProductionUnpaused = function(self)
            AMassCollectionUnit.OnProductionUnpaused(self)
            ChangeState(self, self.ActiveState)
        end,
    },
}


TypeClass = SAB1312