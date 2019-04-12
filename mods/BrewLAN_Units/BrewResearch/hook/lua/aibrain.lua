local GTEEOT = import('/lua/editor/EconomyBuildConditions.lua').GreaterThanEconEfficiencyOverTime

AIBrain = Class(AIBrain) {

    BrewRND = {
        Init = function(self)
            --Init for starting research
            self:ForkThread(self.BrewRND.StartingResearch)

            --Init for AI research manager
            if self.BrainType ~= 'Human' then
                local f = self:GetFactionIndex()
                local fname = {'UEF', 'Aeon', 'Cybran', 'Seraphim'}--[f]
                fname = fname[f]

                --Generate the full research list
                self.BrewRND.ResearchList = {}
                for id, bp in __blueprints do
                    if bp.Categories then
                        if bp.General.FactionName == fname and table.find(bp.Categories, 'BUILTBYRESEARCH') and not table.find(self.BrewRND.ResearchList, bp.BlueprintId) then
                            table.insert(self.BrewRND.ResearchList, bp.BlueprintId)
                        end
                    end
                end

                --Initialise the table to recieve requests.
                self.BrewRND.ResearchRequests = {}
            end
        end,

        --Function to match starting tech level research to starting units
        StartingResearch = function(self)
            WaitTicks(3)
            local AIUtils = import('/lua/ai/aiutilities.lua')
            local pos = {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2}
            local radius = ScenarioInfo.size[1]

            -- variable for tracking max tech level owned
            local maxtech = 0
            --go through the categories in order to see if we have any.
            for i, cat in {categories.TECH1, categories.TECH2, categories.TECH3, categories.EXPERIMENTAL} do
                --arbirary all-map pos, becaues I can't find a function that returns all a brains units.
                if AIUtils.GetOwnUnitsAroundPoint( self, cat * (categories.ENGINEER + categories.FACTORY), pos, radius)[1] then
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

            -- housekeeping
            self.BrewRND.Init = nil
            self.BrewRND.StartingResearch = nil
        end,

        ResearchIsComplete = false,

        -- Is there anything left to research?
        IsResearchRemaining = function(self)
            if self.BrewRND.ResearchList[1] then
                return true
            else
                self.BrewRND.ResearchIsComplete = true
                return false
            end
        end,

        --Check if we should research
        IsAbleToResearch = function(self)
            return GTEEOT(self, 0.5, 0.9)
        end,

        --Return the first thing we can deal with from the requests list, or a random thing off the full list.
            -- Research items self restrict, so there is no danger of repeat items.
        GetResearchItem = function(self, center)
            --Check the requests list first for things they can currently do
            if self.BrewRND.ResearchRequests[1] then
                for i, id in self.BrewRND.ResearchRequests do
                    if __blueprints[id] and center:CanBuild(id) then
                        return self.BrewRND.ResearchRequests[i]
                    end
                end
            end

            --Check the full list for anything they can currently do
            local currentResearch = {}
            for i, id in self.BrewRND.ResearchList do
                if __blueprints[id] and center:CanBuild(id) then
                    table.insert(currentResearch, id)
                end
            end

            --Return something at random from the current list.
            local choice = currentResearch[math.random(1, table.getn(currentResearch))]
            LOG("AI starting research for " .. (__blueprints[choice].Description or "unknown research item") .. ".")
            return choice
        end,

        --Request something be researched. Must be valid for this faction, and not already researched.
        AddResearchRequest = function(self, item)
            --if this request isn't already on the table, then...
            if not table.find(self.BrewRND.ResearchRequests, item) and not table.find(self.BrewRND.ResearchRequests, item .. 'rnd') then
                --if it directly is a valid research item add it
                if table.find(self.BrewRND.ResearchList, item) then
                    table.insert(self.BrewRND.ResearchRequests, item)
                -- if the unit code + rnd is a valid research item then add that
                elseif table.find(self.BrewRND.ResearchList, item .. 'rnd') then
                    table.insert(self.BrewRND.ResearchRequests, item .. 'rnd')
                -- else we have un defined behaviour
                else
                    WARN("Unknown research request type " .. item)
                end
            end
        end,

        --Tell the manager it is done. This is called by the actual research item unit, and doesn't need calling elsewhere
        MarkResearchComplete = function(self, item)
            for i, array in {self.BrewRND.ResearchList, self.BrewRND.ResearchRequests} do
                local f = table.find(array, item)
                if f then
                    table.remove(array, f)
                end
            end
        end,
    }
}
