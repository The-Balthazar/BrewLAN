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
-- Wind turbine stuff
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
WindEnergyCreationUnit = Class(EnergyCreationUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        EnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetProductionPerSecondEnergy(0)
        self.Spinners = {
            --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
            CreateRotator(self, 'Tower', 'z', 0, 5, 1),
            CreateRotator(self, 'Rotors', 'z', nil, 0, 100, 0),
        }
        self:ForkThread(SyncroniseThread,30,self.OnWeatherInterval,self)
    end,

    OnWeatherInterval = function(self)
        self.Spinners[1]:SetGoal(ScenarioInfo.WindStats.Direction)
        self.Spinners[2]:SetTargetSpeed(-400 * ((1/30) * ScenarioInfo.WindStats.Power))
        self:SetProductionPerSecondEnergy(ScenarioInfo.WindStats.Power)
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
        local bp = self:GetBlueprint()
        --Allow restarting of me, the RND item, if I was never finished.
        if self.Spinners then
            self.Spinners[2]:Destroy()
        end
        EnergyCreationUnit.OnKilled(self, instigator, type, overKillRatio)
    end,
}
