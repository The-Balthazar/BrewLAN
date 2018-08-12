AIBrain = Class(AIBrain) {
    AISimulateResearch = function(self)
        if self.BrainType != 'Human' and not self.DaiquirisResearch then
            self:ForkThread(self.SimulateResearchThread)
        end
    end,

    SimulateResearchThread = function(self)
        WaitTicks(50) -- Wait for the plan to be initialised, then check if we know the builder.
        if not self.BuilderManagers.MAIN.BuilderHandles.EngineerResearchBuilders then
            local factions = {'e','a','r','s'}
            local f = factions[self:GetFactionIndex()]
            local maxdeviation = 2
            local GetRandomFloat = import('utilities.lua').GetRandomFloat
            local army = self:GetArmyIndex()
            WaitSeconds(27 * GetRandomFloat(1,maxdeviation) )
            --tech 1
            CreateUnitHPR('s' .. f .. 'r9100',army,0,0,0,0,0,0)
            WaitSeconds(86 * GetRandomFloat(1,maxdeviation) )
            --tech 2
            if not self:IsDefeated() then
                print(self.Nickname .. " is at tech level 2")
                CreateUnitHPR('s' .. f .. 'r9200',army,0,0,0,0,0,0)
                WaitSeconds(212 * GetRandomFloat(1,maxdeviation) )
            end
            --tech 3
            if not self:IsDefeated() then
                print(self.Nickname .. " is at tech level 3")
                CreateUnitHPR('s' .. f .. 'r9300',army,0,0,0,0,0,0)
                WaitSeconds(460 * GetRandomFloat(1,maxdeviation) )
            end
            --experimental
            if not self:IsDefeated() then
                print(self.Nickname .. " has access to experimental tech")
                CreateUnitHPR('s' .. f .. 'r9400',army,0,0,0,0,0,0)
            end
        end
    end,
}
