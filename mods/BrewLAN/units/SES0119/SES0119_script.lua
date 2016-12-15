local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit

SES0119 = Class(TSeaUnit) {

    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_shipmobile_01_emit.bp',
        '/effects/emitters/terran_shield_generator_shipmobile_02_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetupBuildBones()
        self:ForkThread(self.AssistThread)
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        WaitSeconds( 0.1 )
        for k, v in self:GetBlueprint().General.BuildBones.BuildEffectBones do
            self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )         
            self.BuildEffectsBag:Add( self:ForkThread( import('/lua/EffectUtilities.lua').CreateDefaultBuildBeams, unitBeingBuilt, {v}, self.BuildEffectsBag ) )
        end
    end,

    AssistThread = function(self)
        while true do
            if self:IsIdleState() then
                --Insert some kind of table sort for most damaged here
                for i, v in self:GetAIBrain():GetUnitsAroundPoint(categories.ALLUNITS, self:GetPosition(), 30, 'Ally' ) do
                    if v:GetHealthPercent() != 1 then
                        IssueRepair({self}, v)
                    end
                end
            end   
            WaitTicks(30)
        end
    end,
}

TypeClass = SES0119