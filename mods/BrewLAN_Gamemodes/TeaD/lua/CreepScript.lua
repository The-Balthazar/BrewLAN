local Unit = import('/lua/sim/Unit.lua').Unit

Creep = Class(Unit) {
    OnStopBeingBuilt = function(self,builder,layer)
        Unit.OnStopBeingBuilt(self,builder,layer)
        self:ForkThread(function()
            WaitSeconds(1)
            IssueClearCommands({self})
            if self.Target then
                IssueMove({self}, self.Target)
            else
                IssueMove({self}, {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2})
            end
        end)      
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        instigator:GetAIBrain():GiveResource('Mass', self:GetBlueprint().Economy.BuildCostMass * self:GetBlueprint().Wreckage.MassMult )
        instigator:GetAIBrain():GiveResource('Energy', self:GetBlueprint().Economy.BuildCostEnergy * self:GetBlueprint().Wreckage.EnergyMult )
        Unit.OnKilled(self, instigator, type, 2)
    end,
}