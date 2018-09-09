--------------------------------------------------------------------------------
-- Research item stuff
--------------------------------------------------------------------------------
local Game = import('/lua/game.lua')
local BrewLANPath = Game.BrewLANPath()
local VersionIsFAF = import(BrewLANPath .. "/lua/legacy/versioncheck.lua").VersionIsFAF()
--------------------------------------------------------------------------------
ResearchItem = Class(DummyUnit) {
    OnCreate = function(self)
        local bp = self:GetBlueprint()
        DummyUnit.OnCreate(self)
        --Restrict me, the RND item, to one being built at a time.
        AddBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        local bp = self:GetBlueprint()
        --Enable what we were supposed to allow.
        if bp.ResearchId == string.lower(bp.ResearchId) then --This wont work for any units without letters in the ID.
            if self:CheckBuildRestrictionsAllow(bp.ResearchId) then
                RemoveBuildRestriction(self:GetArmy(), categories[bp.ResearchId] )
            else
                LOG("WARNING: Research item for " .. categories[bp.ResearchId] .. " was just completed, however lobby restrictions forbid it. Item shouldn't have been researchable.")
            end
        else -- else we are a category, not a unitID
            RemoveBuildRestriction(self:GetArmy(), (categories[bp.ResearchId] * categories[string.upper(bp.General.FactionName or 'SELECTABLE')]) - categories.RESEARCHLOCKED - categories[bp.BlueprintId] - (self:BuildRestrictionCategories()) )
            --Unlock the next tech research as well.
            if bp.ResearchId == 'RESEARCHLOCKEDTECH1' then
                RemoveBuildRestriction(self:GetArmy(), categories.TECH2 * categories[string.upper(bp.General.FactionName or 'SELECTABLE')] * categories.CONSTRUCTIONSORTDOWN - (self:BuildRestrictionCategories()) )
            elseif bp.ResearchId == 'TECH2' then
                RemoveBuildRestriction(self:GetArmy(), categories.TECH3 * categories[string.upper(bp.General.FactionName or 'SELECTABLE')] * categories.CONSTRUCTIONSORTDOWN - (self:BuildRestrictionCategories()) )
            elseif bp.ResearchId == 'TECH3' then
                RemoveBuildRestriction(self:GetArmy(), categories.EXPERIMENTAL * categories[string.upper(bp.General.FactionName or 'SELECTABLE')] * categories.CONSTRUCTIONSORTDOWN - (self:BuildRestrictionCategories()) )
            end
        end
        --Before the rest, because the rest is Destroy(self)
        DummyUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    CheckBuildRestrictionsAllow = function(self, WorkID)
        local Restrictions = ScenarioInfo.Options.RestrictedCategories
        if not Restrictions or table.getn(Restrictions) == 0 then
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
            for id, bool in import('/lua/game.lua').GetRestrictions().Global do
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
        local bp = self:GetBlueprint()
        --Allow restarting of me, the RND item, if I was never finished.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )
        end
        DummyUnit.OnKilled(self, instigator, type, overKillRatio)
    end,

    OnDestroy = function(self)
        local bp = self:GetBlueprint()
        --Allow restarting of me, the RND item, if I was never finished. In case of reclaim.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )
        end
        DummyUnit.OnDestroy(self)
    end,
}

--------------------------------------------------------------------------------
-- Research Center AI
--------------------------------------------------------------------------------
local Buff = import(BrewLANPath .. '/lua/legacy/VersionCheck.lua').Buff
--------------------------------------------------------------------------------
ResearchFactoryUnit = Class(FactoryUnit) {

    BuildLevel = 0,

    OnStopBeingBuilt = function(self, builder, layer)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType != 'Human' then
            if builder.ResearchList then
                self.ResearchList = table.copy(builder.ResearchList)
            end
            self:ForkThread(self.ResearchThread)
            self:AICheatsBuffs()
        end
        FactoryUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    StartBuildFx = function(self, unitBeingBuilt)
        local bp = self:GetBlueprint()
        local faction = string.lower(bp.General.FactionName or 'nothing')
        local EffectUtil = import('/lua/effectutilities.lua')
        if faction == 'aeon' then
            local thread = self:ForkThread( EffectUtil.CreateAeonFactoryBuildingEffects, unitBeingBuilt, bp.General.BuildBones.BuildEffectBones, 'Attachpoint', self.BuildEffectsBag )
            unitBeingBuilt.Trash:Add(thread)
        elseif faction == 'uef' then
            WaitTicks(1)
            --unitBeingBuilt:SetMesh(unitBeingBuilt:GetBlueprint().Display.BuildMeshBlueprint, true)
            for k, v in bp.General.BuildBones.BuildEffectBones do
                self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )
                self.BuildEffectsBag:Add( self:ForkThread( EffectUtil.CreateDefaultBuildBeams, unitBeingBuilt, {v}, self.BuildEffectsBag ) )
            end
        elseif faction == 'cybran' then
            local buildbots = EffectUtil.SpawnBuildBots( self, unitBeingBuilt, table.getn(bp.General.BuildBones.BuildEffectBones), self.BuildEffectsBag )
            EffectUtil.CreateCybranEngineerBuildEffects( self, bp.General.BuildBones.BuildEffectBones, buildbots, self.BuildEffectsBag )
        elseif faction == 'seraphim' then
    		local BuildBones = bp.General.BuildBones.BuildEffectBones
            local thread = self:ForkThread( EffectUtil.CreateSeraphimFactoryBuildingEffects, unitBeingBuilt, BuildBones, 'Attachpoint', self.BuildEffectsBag )
            unitBeingBuilt.Trash:Add(thread)
        end
        if FactoryUnit.StartBuildFx then
            FactoryUnit.StartBuildFx(self, unitBeingBuilt)
        end
    end,

    OnStopBuild = function(self, unitbuilding, order)
        if not Buffs['ResearchItemBuff5'] then
            for i = 1, 5 do
                if i != 4 then
                    BuffBlueprint {
                        Name = 'ResearchItemBuff' .. i, DisplayName = 'ResearchItemBuff' .. i,
                        BuffType = 'RESEARCH', Stacks = 'ALWAYS', Duration = -1,
                        Affects = {
                            BuildRate    = {Add = (i/100), Mult = 1},
                            EnergyActive = {Add = 0, Mult = 1-(i/100)},
                            MassActive   = {Add = 0, Mult = 1-(i/100)},
                        },
                    }
                end
            end
        end
        if unitbuilding:GetFractionComplete() == 1 then
            if EntityCategoryContains(categories.EXPERIMENTAL, unitbuilding) then
                Buff.ApplyBuff(self, 'ResearchItemBuff5')
            elseif EntityCategoryContains(categories.TECH3, unitbuilding) then
                Buff.ApplyBuff(self, 'ResearchItemBuff3')
            elseif EntityCategoryContains(categories.TECH2, unitbuilding) then
                Buff.ApplyBuff(self, 'ResearchItemBuff2')
            elseif EntityCategoryContains(categories.TECH1, unitbuilding) then
                Buff.ApplyBuff(self, 'ResearchItemBuff1')
            end
        end
        FactoryUnit.OnStopBuild(self, unitbuilding, order)
    end,

    UpgradingState = State(FactoryUnit.UpgradingState) {
        OnStopBuild = function(self, unitbuilding, order)
            if unitbuilding:GetFractionComplete() == 1 and order == 'Upgrade' then
                if self.Buffs.BuffTable.RESEARCH then
                    for buff, data in self.Buffs.BuffTable.RESEARCH do
                        if Buffs[buff] then --Ensure that the data structure is the same as we are expecting.
                            for i = 1, (data.Count or 1) do
                                LOG('Passing on buff: ' .. buff)
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
        -- Checks every 10 seconds if we are idle
        -- If we ar wait a random number of ticks
        -- that increases later into the game
        -- then research
    ResearchThread = function(self)
        while not self.Dead do
            if self:IsIdleState() then
                WaitTicks(math.random(1, GetGameTimeSeconds()))
                self:Research()
            else
                WaitTicks(100)
            end
        end
    end,

    -- Ran every time "ResearchThread" decides we need to research
        -- Prioritises upgrading if it's available
        -- else calls GetResearchItem to decide what to research
    Research = function(self)
        local aiBrain = self:GetAIBrain()
        local bp = self:GetBlueprint()
        --Upgrade if we can first
        if bp.General.UpgradesTo and __blueprints[bp.General.UpgradesTo] and self:CanBuild(bp.General.UpgradesTo) then
            IssueUpgrade({self}, bp.General.UpgradesTo)
        else
            aiBrain:BuildUnit(self, self:GetResearchItem(), 1)
        end
    end,

    -- Ran via Research to "decide" what we should research
        -- The first time it's ran per research center it generates a comprehensive list of all things this can research
        -- It loops through that list to see what it can currently research
        -- Then it picks one of those at random to build.
        -- Research items self restrict, so there is no damger of repeat items unless nessessary.
        -- Currently doesn't handle running out of things to research very well.
        -- Should probably inform the AI brain that we are done and we no longer need a research center.
    GetResearchItem = function(self)
        local selfbp = self:GetBlueprint()
        if not self.ResearchList then
            self.ResearchList = {}
            for id, bp in __blueprints do
                if bp.Categories then
                    if selfbp.General.FactionName == bp.General.FactionName and table.find(bp.Categories, 'BUILTBYRESEARCH') then
                        table.insert(self.ResearchList, bp.BlueprintId)
                    end
                end
            end
        end
        --WARN(repr(self.ResearchList))
        local currentResearch = {}
        for i, id in self.ResearchList do
            if __blueprints[id] and self:CanBuild(id) then
                table.insert(currentResearch, id)
            end
        end
        --WARN(repr(currentResearch))
        local choicei = math.random(1, table.getn(currentResearch))
        LOG("AI starting research for " .. (__blueprints[currentResearch[choicei]].Description or "unknown research item") .. ".")
        return currentResearch[choicei]
    end,

    --Applied OnStopBeingBuilt.
    --Passed on with the other buffs on upgrade.
    AICheatsBuffs = function(self)
        local aiBrain = self:GetAIBrain()
        if aiBrain.CheatEnabled then
            if not Buffs['ResearchAIxBuff'] then
                BuffBlueprint {
                    Name = 'ResearchAIxBuff',
                    DisplayName = 'ResearchAIxBuff',
                    BuffType = 'RESEARCH',
                    Stacks = 'ALWAYS',
                    Duration = -1,
                    Affects = {
                        --Research buffs are passed on as upgrades, so the final upgrade gets 3 instances of these.
                        BuildRate = {Add = 0, Mult = 1 + (0.25 / 3)},
                        EnergyActive = {Add = -0.2, Mult = 1},
                        MassActive = {Add = -0.2, Mult = 1},
                    },
                }
            end
            Buff.ApplyBuff(self, 'ResearchAIxBuff')
        else
            if not Buffs['ResearchAIBuff'] then
                BuffBlueprint {
                    Name = 'ResearchAIBuff',
                    DisplayName = 'ResearchAIBuff',
                    BuffType = 'RESEARCH',
                    Stacks = 'ALWAYS',
                    Duration = -1,
                    Affects = {
                        --Research buffs are passed on as upgrades, so the final upgrade gets 3 instances of these.
                        EnergyActive = {Add = -0.1, Mult = 1},
                        MassActive = {Add = -0.1, Mult = 1},
                    },
                }
            end
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
    while true do
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
            LOG("Defining wind turbine energy output value range.")
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
        self:ForkThread(SyncroniseThread,30,self.OnWeatherInterval,self)
    end,

    OnWeatherInterval = function(self)
        self.Spinners[1]:SetGoal(ScenarioInfo.WindStats.Direction)
        self.Spinners[2]:SetTargetSpeed(-65 - (335 * ScenarioInfo.WindStats.Power))
        self:SetProductionPerSecondEnergy(
            (WindEnergyMin + WindEnergyRange * ScenarioInfo.WindStats.Power)
            *
            (self.EnergyProdAdjMod or 1)
        )
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
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
            CreateRotator(self, 'Rotors', 'z', nil, 0, 100, 0),
        }
        ------------------------------------------------------------------------
        -- Calculate energy values
        ------------------------------------------------------------------------
        if not TidalEnergyMin and not TidalEnergyRange then
            LOG("Defining tidal generator energy output value range.")
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
            LOG("Map tidal strength defined as: " .. TidalEnergyMin .. "–" .. TidalEnergyMin + TidalEnergyRange)
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

--------------------------------------------------------------------------------
-- Scripts for directional anti-AA-missile flares for aircraft
--------------------------------------------------------------------------------
local AntiWeapons = import('/lua/defaultantiprojectile.lua')
local AAFlare = AntiWeapons.AAFlare
local MissileDetector = AntiWeapons.MissileDetector
--------------------------------------------------------------------------------
local MissileDetectorRadius = {}
--------------------------------------------------------------------------------
BaseDirectionalAntiMissileFlare = Class() {
    CreateMissileDetector = function(self)
        local bp = self:GetBlueprint()
        local MDbp = self:GetBlueprint().Defense.MissileDetector

        if not MissileDetectorRadius[bp.BlueprintId] and MDbp then
            LOG("Calculating missile detector radius for " .. bp.BlueprintId)
            MissileDetectorRadius[bp.BlueprintId] = math.sqrt(math.pow(VDist3(self:GetPosition(),self:GetPosition(MDbp.AttachBone)),2) + math.pow(bp.SizeSphere, 2))
        elseif not MissileDetectorRadius and not MDbp then
            MissileDetectorRadius[bp.BlueprintId] = 3
            WARN("Missile Detector data not set up correctly.")
        end

        self.Trash:Add(MissileDetector {
            Owner = self,
            Radius = MissileDetectorRadius[bp.BlueprintId],
            AttachBone = MDbp.AttachBone,
        })
    end,

    DeployFlares = function(self)
        AAFlare {
            Owner = self,
            Radius = 3,
            AttachBone = self.FlareBones[math.random(1,table.getn(self.FlareBones))] or 0,
        }
    end,
}
