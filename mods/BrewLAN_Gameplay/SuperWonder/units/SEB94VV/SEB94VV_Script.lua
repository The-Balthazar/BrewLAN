local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

SEB94VV = Class(TStructureUnit) {

    OnCreate = function(self)
        TStructureUnit.OnCreate(self)
        local pos = self:GetPosition()
        local rad = self:GetBlueprint().Intel.VisionRadius
        for i, brain in ArmyBrains do
            self.Trash:Add(VizMarker({
                X = pos[1],
                Z = pos[3],
                Radius = rad or 20,
                LifeTime = -1,
                Army = brain:GetArmyIndex(),
            }))
        end
        AddBuildRestriction(self:GetArmy(), categories.PRODUCTBREWWONDER )
        self:SetCapturable(false)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TStructureUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.VictoryCountdownThread)
    end,

    OnDestroy = function(self)
        RemoveBuildRestriction(self:GetArmy(), categories.PRODUCTBREWWONDER )
        TStructureUnit.OnDestroy(self)
    end,

    VictoryCountdownThread = function(self)
        local vsex = 600
        local vnum = 1/vsex
        for i = 1, vsex do
            self:SetWorkProgress(vnum*i)
            WaitSeconds(1)
        end
        LOG("VENI VEDI VICI")

        if ScenarioInfo.Options.TeamLock == "locked" then
            for i, brain in ArmyBrains do
                if not IsAlly(self:GetArmy(), brain:GetArmyIndex()) then
                    brain:OnDefeat()
                end
            end
        elseif ScenarioInfo.Options.TeamLock == "unlocked" then
            for i, brain in ArmyBrains do
                if self:GetArmy() ~= brain:GetArmyIndex() then
                    brain:OnDefeat()
                end
            end
        end
        self:SetWorkProgress(0)
    end,
}

TypeClass = SEB94VV
