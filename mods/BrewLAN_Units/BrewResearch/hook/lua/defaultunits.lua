local SyncroniseThread = function(self, interval, event, data)
    local time = GetGameTick()
    local wait = interval - math.mod(time,interval) + 1
    WaitTicks(wait)
    while true do
        event(data)
        WaitTicks(interval + 1)
    end
end


ResearchItem = Class(DummyUnit) {
    OnCreate = function(self)
        DummyUnit.OnCreate(self)
        --Restrict me, the RND item, to one being built at a time.
        AddBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().BlueprintId] )
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        --Enable what we were supposed to allow.
        RemoveBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().ResearchId] )
        --Before the rest, because the rest is Destroy(self)
        DummyUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
        --Allow restarting of me, the RND item, if I was never finished.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().BlueprintId] )
        end
        DummyUnit.OnKilled(self, instigator, type, overKillRatio)
    end,

    OnDestroy = function(self)
        --Allow restarting of me, the RND item, if I was never finished. In case of reclaim.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().BlueprintId] )
        end
        DummyUnit.OnDestroy(self)
    end,
}

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
    end
}
