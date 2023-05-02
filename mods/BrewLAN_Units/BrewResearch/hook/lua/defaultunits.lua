--------------------------------------------------------------------------------
-- Research item stuff
--------------------------------------------------------------------------------
local Game = import('/lua/game.lua')
local VersionIsFAF = string.sub(GetVersion(),1,3) == '1.5' and tonumber(string.sub(GetVersion(),5)) > 3603
--------------------------------------------------------------------------------

ResearchItem = Class(Unit) {
    OnCreate = function(self)
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        Unit.OnCreate(self)
        --Restrict me, the RND item, to one being built at a time.
        AddBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        local army = self:GetArmy()
        local factionCat = categories[string.upper(bp.General.FactionName or 'SELECTABLE')]
        --Enable what we were supposed to allow.
        if bp.ResearchId == string.lower(bp.ResearchId) then --This wont work for any units without letters in the ID.
            if self:CheckBuildRestrictionsAllow(bp.ResearchId) then
                RemoveBuildRestriction(army, categories[bp.ResearchId] )
            else
                WARN("Research item for " .. bp.ResearchId .. " was just completed, however lobby restrictions forbid it. Item shouldn't have been researchable.")
            end
        else -- else we are a category, not a unitID
            RemoveBuildRestriction(army, (categories[bp.ResearchId] * factionCat) - categories.RESEARCHLOCKED - categories[bp.BlueprintId] - (self:BuildRestrictionCategories()) )
            --Unlock the next tech research as well.
            if bp.ResearchId == 'RESEARCHLOCKEDTECH1' then
                RemoveBuildRestriction(army, categories.TECH2 * factionCat * categories.CONSTRUCTIONSORTDOWN - (self:BuildRestrictionCategories()) )
            elseif bp.ResearchId == 'TECH2' then
                RemoveBuildRestriction(army, categories.TECH3 * factionCat * categories.CONSTRUCTIONSORTDOWN - (self:BuildRestrictionCategories()) )
            elseif bp.ResearchId == 'TECH3' then
                RemoveBuildRestriction(army, categories.EXPERIMENTAL * factionCat * categories.CONSTRUCTIONSORTDOWN - (self:BuildRestrictionCategories()) )
            end
        end

        --Tell the manager this is done if we're an AI and presumably have a manager.
        local AIBrain = self:GetAIBrain()
        if AIBrain.BrainType ~= 'Human' and AIBrain.BrewRND then
            AIBrain.BrewRND.MarkResearchComplete(AIBrain, bp.BlueprintId)
        end

        self:Destroy()
    end,

    CheckBuildRestrictionsAllow = function(self, WorkID)
        local Restrictions = ScenarioInfo.Options.RestrictedCategories
        if not Restrictions or not next(Restrictions) then
            return true
        elseif VersionIsFAF then
            return not Game.IsRestricted(WorkID)
        else
            local restrictedData = import('/lua/ui/lobby/restrictedunitsdata.lua').restrictedUnits
            for i, group in Restrictions do
                local tablefind = table.find
                for j, cat in restrictedData[group].categories do --
                    if WorkID == cat or tablefind(__blueprints[WorkID].Categories, cat) then
                        return false
                    end
                end
            end
        end
        return true
    end,

    BuildRestrictionCategories = function(self)
        local Restrictions = ScenarioInfo.Options.RestrictedCategories
        if not Restrictions or table.getn(Restrictions) == 0 then
            --No restrictions
            return categories.NOTHINGIMPORTANT -- DE NADA
        elseif VersionIsFAF then
            --FAF restrictions
            local restrictedCategories = categories.NOTHINGIMPORTANT
            for id, bool in Game.GetRestrictions().Global do
                restrictedCategories = restrictedCategories + categories[id]
                --Also restrict research items of blocked things.
                --The there is no easy way to do this the other ways.
                --So FAF actually functions better here.
                if __blueprints[id .. 'rnd'] then
                    restrictedCategories = restrictedCategories + categories[id .. 'rnd']
                end
            end
            return restrictedCategories
        else
            local restrictedData = import('/lua/ui/lobby/restrictedunitsdata.lua').restrictedUnits
            local restrictedCategories = categories.NOTHINGIMPORTANT
            for i, group in Restrictions do
                for j, cat in restrictedData[group].categories do
                    restrictedCategories = restrictedCategories + categories[cat]
                end
            end
            return restrictedCategories
        end
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        --Allow restarting of me, the RND item, if I was never finished.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )
        end
        Unit.OnKilled(self, instigator, type, overKillRatio)
    end,

    OnDestroy = function(self)
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        --Allow restarting of me, the RND item, if I was never finished. In case of reclaim.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )
        end
        Unit.OnDestroy(self)
    end,
}

--------------------------------------------------------------------------------
-- Research Center AI
--------------------------------------------------------------------------------
local Buff = {}
--Wizardry to make FA buff scripts not break the game on original SupCom.
if not string.sub(GetVersion(),1,3) == '1.1' or string.sub(GetVersion(),1,3) == '1.0' then Buff = import('/lua/sim/Buff.lua') else Buff.ApplyBuff = function() end end
--------------------------------------------------------------------------------
ResearchFactoryUnit = Class(FactoryUnit) {

    -- Prevents LOUD factory manager errors.
    SetupComplete = true,

    OnPreCreate = function(self)
        FactoryUnit.OnPreCreate(self)
        if not self.BpId then
            self.BpId = self:GetBlueprint().BlueprintId
        end
    end,

    OnStartBeingBuilt = function(self, creator, layer)
        local AIBrain = self:GetAIBrain()
        if AIBrain.BrainType ~= 'Human' and AIBrain:GetListOfUnits(categories[self.BpId], false)[1] then
            self:Destroy()
        end
        FactoryUnit.OnStartBeingBuilt(self, creator, layer)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        --If we're an AI
        local AIBrain = self:GetAIBrain()
        if AIBrain.BrainType ~= 'Human' then
            self.ResearchThread = self:ForkThread(self.ResearchThread) --Create the research thread
            self:AICheatsBuffs()                 --CHEAT!
        end
        FactoryUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    OnStopBuild = function(self, unitbuilding, order)
        --Give buff based on what we researched
        if unitbuilding.GetFractionComplete and unitbuilding:GetFractionComplete() == 1 then
            local n = EntityCategoryContains(categories.EXPERIMENTAL, unitbuilding) and 5 or
                      EntityCategoryContains(categories.TECH3, unitbuilding) and 3 or
                      EntityCategoryContains(categories.TECH2, unitbuilding) and 2 or 1
            Buff.ApplyBuff(self, 'ResearchItemBuff'..n)
        end
        FactoryUnit.OnStopBuild(self, unitbuilding, order)
    end,

    UpgradingState = State(FactoryUnit.UpgradingState) {
        OnStopBuild = function(self, unitbuilding, order)
            --Pass on buffs to the replacement
            if unitbuilding.GetFractionComplete and unitbuilding:GetFractionComplete() == 1 and order == 'Upgrade' then
                if self.Buffs.BuffTable.RESEARCH then
                    for buff, data in self.Buffs.BuffTable.RESEARCH do
                        if Buffs[buff] then --Ensure that the data structure is the same as we are expecting.
                            for i = 1, (data.Count or 1) do
                                Buff.ApplyBuff(unitbuilding, buff)
                            end
                        end
                    end
                end
            end
            FactoryUnit.UpgradingState.OnStopBuild(self, unitbuilding, order)
        end,
    },

    ----------------------------------------------------------------------------
    -- AI research control
    ----------------------------------------------------------------------------

    -- Persistent research thread
    -- "Decides" when to do research
        -- Checks every 5 seconds if we are idle
        -- Checks with the AI brain if we're allowed to research
        -- then research
    ResearchThread = function(self)
        local AIBrain = self:GetAIBrain()
        while not self.Dead and not AIBrain.BrewResearchIsComplete and AIBrain.BrewRND and AIBrain.BrewRND.IsResearchRemaining(AIBrain) do
            if self:IsIdleState() and AIBrain.BrewRND.IsAbleToResearch(AIBrain) then
                self:Research()
                coroutine.yield(10)
            else
                coroutine.yield(100)
            end
        end
        WARN("An AI has finished researching.")
    end,

    -- Ran every time "ResearchThread" decides we need to research
        -- Prioritises upgrading if it's available
        -- else calls GetResearchItem to decide what to research
    Research = function(self)
        local AIBrain = self:GetAIBrain()
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        --Upgrade if we can first
        if bp.General.UpgradesTo and __blueprints[bp.General.UpgradesTo] and self:CanBuild(bp.General.UpgradesTo) then
            IssueUpgrade({self}, bp.General.UpgradesTo)
        elseif AIBrain.BrewRND then
            AIBrain:BuildUnit(self, AIBrain.BrewRND.GetResearchItem(AIBrain, self), 1)
        end
    end,

    --Applied OnStopBeingBuilt.
    --Passed on with the other buffs on upgrade.
    AICheatsBuffs = function(self)
        local AIBrain = self:GetAIBrain()
        if AIBrain.CheatEnabled then
            Buff.ApplyBuff(self, 'ResearchAIxBuff')
        else
            Buff.ApplyBuff(self, 'ResearchAIBuff')
        end
    end
}

--------------------------------------------------------------------------------
-- Variable producer stuff
--------------------------------------------------------------------------------
local SyncroniseThread = function(self, interval, event, data)
    local time = GetGameTick()
    local wait = interval - math.mod(time,interval) + 1
    WaitTicks(wait)
    while not self.Dead do
        event(data)
        WaitTicks(interval + 1)
    end
end

--------------------------------------------------------------------------------
local WindEnergyMin = false
local WindEnergyRange = false
--These are defined here so they are global for the turbines, and only 1 has to define it.
WindEnergyCreationUnit = Class(EnergyCreationUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        EnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)
        ------------------------------------------------------------------------
        -- Pre-setup
        ------------------------------------------------------------------------
        self:SetProductionPerSecondEnergy(0)
        self.Spinners = {
            --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
            CreateRotator(self, 'Tower', 'z', 0, 5, 1),
            CreateRotator(self, 'Rotors', 'z', nil, 0, 100, 0),
        }
        ------------------------------------------------------------------------
        -- Calculate energy values
        ------------------------------------------------------------------------
        if not WindEnergyMin and not WindEnergyRange then
            SPEW("Defining wind turbine energy output value range.")
            local bp = self:GetBlueprint().Economy
            local mean = bp.ProductionPerSecondEnergy or 17.5
            local min = bp.ProductionPerSecondEnergyMin or 5
            local max = bp.ProductionPerSecondEnergyMax or 30
            if (min + max) / 2 == mean then
                --Then nothing has messed with the numbers, or something messed with all of them.
                WindEnergyMin = min
                WindEnergyRange = max - min
            else
                --Something has messed with the numbers, and we should move to match.
                local mult = mean / 17.5
                WindEnergyMin = min * mult
                WindEnergyRange = (max - min) * mult
            end
        end
        ------------------------------------------------------------------------
        -- Run the thread
        ------------------------------------------------------------------------
        self.ControlThread = self:ForkThread(SyncroniseThread,30,self.OnWeatherInterval,self)
    end,

    OnWeatherInterval = function(self)
        if not self.Dead then
            self.Spinners[1]:SetGoal(ScenarioInfo.WindStats.Direction)
            self.Spinners[2]:SetTargetSpeed(-65 - (335 * ScenarioInfo.WindStats.Power))
            self:SetProductionPerSecondEnergy(
                (WindEnergyMin + WindEnergyRange * ScenarioInfo.WindStats.Power)
                *
                (self.EnergyProdAdjMod or 1)
            )
        end
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
        KillThread(self.ControlThread)
        if self.Spinners then
            self.Spinners[2]:Destroy()
        end
        EnergyCreationUnit.OnKilled(self, instigator, type, overKillRatio)
    end,
}

--------------------------------------------------------------------------------
-- Tidal generator stuff
--------------------------------------------------------------------------------
local GetEstimateMapWaterRatioFromGrid = function(grid)
    --aibrain:GetMapWaterRatio()
    if not grid then grid = 4 end
    local totalgrids = grid * grid
    local watergrids = 0
    local size = {
        ScenarioInfo.size[1] / (grid + 1),
        ScenarioInfo.size[2] / (grid + 1)
    }
    for x = 1, grid do
        for y = 1, grid do
            local coord = {x * size[1], y * size[2]}
            if GetSurfaceHeight(unpack(coord)) > GetTerrainHeight(unpack(coord)) then
                watergrids = watergrids + 1
            end
        end
    end
    return watergrids / totalgrids
end
--------------------------------------------------------------------------------
local TidalEnergyMin = false
local TidalEnergyRange = false
--These are defined here so they are global for the turbines, and only 1 has to define it.
TidalEnergyCreationUnit = Class(EnergyCreationUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        EnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)
        ------------------------------------------------------------------------
        -- Pre-setup
        ------------------------------------------------------------------------
        self:SetProductionPerSecondEnergy(0)
        self.Spinners = {
            --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
            CreateRotator(self, self.RotorName or 'Rotors', 'z', nil, 0, 100, 0),
        }

        local pos = self.CachePosition or self:GetPosition()
        local co = 0.03
        if self.YawBone then
            self.Spinners[2] = CreateRotator(self, self.YawBone, 'y', 90 * (math.cos(pos[1]*co)+math.sin(pos[3]*co)), 30, 1)
        end
        ------------------------------------------------------------------------
        -- Calculate energy values
        ------------------------------------------------------------------------
        if not TidalEnergyMin and not TidalEnergyRange then
            SPEW("Defining tidal generator energy output value range.")
            --------------------------------------------------------------------
            -- Check check values to make sure another mod didn't change them
            --------------------------------------------------------------------
            local bp = self:GetBlueprint().Economy
            local mean = bp.ProductionPerSecondEnergy or 25
            local min = bp.ProductionPerSecondEnergyMin or 10
            local max = bp.ProductionPerSecondEnergyMax or 40
            local range = max - min
            if (min + max) / 2 ~= mean then
                local mult = mean / 25
                min = min * mult
                max = max * mult
                range = range * mult
            end
            --------------------------------------------------------------------
            -- Get two indpendant variables of map wetness
            --------------------------------------------------------------------
            local wR1 = GetEstimateMapWaterRatioFromGrid(4)
            local wR2 = self:GetAIBrain():GetMapWaterRatio()
            --------------------------------------------------------------------
            -- Calculate the actual range base on them
            --------------------------------------------------------------------
            TidalEnergyMin = min + (range * math.min(wR1,wR2))
            TidalEnergyRange = min + (range * math.max(wR1,wR2)) - TidalEnergyMin
            SPEW("Map tidal strength defined as: " .. TidalEnergyMin .. "–" .. TidalEnergyMin + TidalEnergyRange)
        end
        ------------------------------------------------------------------------
        -- Run the thread
        ------------------------------------------------------------------------
        self:SetProductionPerSecondEnergy(TidalEnergyMin)
        self.Spinners[1]:SetTargetSpeed( - TidalEnergyMin * 10 )
        if TidalEnergyRange >= 0.1 then
            self:ForkThread(SyncroniseThread,60,self.OnWeatherInterval,self)
        end
    end,

    OnWeatherInterval = function(self)
        local power = TidalEnergyMin + ((math.sin(GetGameTimeSeconds()) + 1) * TidalEnergyRange * 0.5)
        self.Spinners[1]:SetTargetSpeed( - power * 10 )
        self:SetProductionPerSecondEnergy( power * (self.EnergyProdAdjMod or 1) )
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
        if self.Spinners then
            self.Spinners[1]:Destroy()
        end
        EnergyCreationUnit.OnKilled(self, instigator, type, overKillRatio)
    end,
}
