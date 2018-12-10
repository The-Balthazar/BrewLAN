AIBrain = Class(AIBrain) {

    --Function to match starting tech level research to starting units
    StartingResearch = function(self)
        self:ForkThread(self.StartingResearchThread)
    end,

    StartingResearchThread = function(self)
        WaitTicks(3)
        local AIUtils = import('/lua/ai/aiutilities.lua')
        local pos = {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2}
        local radius = ScenarioInfo.size[1]

        -- variable for tracking max tech level owned
        local maxtech = 0
        --go through the categories in order to see if we have any.
        for i, cat in {categories.RESEARCHLOCKEDTECH1, categories.TECH2, categories.TECH3, categories.EXPERIMENTAL} do
            --arbirary all-map pos, becaues I can't find a function that returns all a brains units.
            if AIUtils.GetOwnUnitsAroundPoint( self, cat, pos, radius)[1] then
                -- index == tech level
                maxtech = math.max(maxtech, i)
            end
        end

        --spawn all tech level research units of the faction, up to what we already have.
        if maxtech > 0 then
            local factions = {'e','a','r','s'}
            local f = factions[self:GetFactionIndex()]
            for i = 1, maxtech do
                CreateUnitHPR('s' .. f .. 'r9' .. i .. '00', self:GetArmyIndex(),0,0,0,0,0,0)
            end
        end

        --If they have a specifically research locked unit already, unlock it. If anything, most likely prebuilt units are on, and they have a t1 pgen.
        for i, unit in AIUtils.GetOwnUnitsAroundPoint( self, categories.RESEARCHLOCKED, pos, radius) do
            CreateUnitHPR(unit:GetBlueprint().BlueprintId .. 'rnd', self:GetArmyIndex(),0,0,0,0,0,0)
        end
    end,
}
