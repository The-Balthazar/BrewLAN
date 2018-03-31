local DummyUnit = import('/lua/defaultunits.lua').DummyUnit

ResearchItem = Class(DummyUnit) {
    OnCreate = function(self)
        DummyUnit.OnCreate(self)
        AddBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().BlueprintId] )
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        RemoveBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().ResearchId] )
        DummyUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
        --Allow another if it was never finished.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().BlueprintId] )
        end
        DummyUnit.OnKilled(self, instigator, type, overKillRatio)
    end,

    OnDestroy = function(self)
        --Allow another if it was never finished.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().BlueprintId] )
        end
        DummyUnit.OnDestroy(self)
    end,
}
