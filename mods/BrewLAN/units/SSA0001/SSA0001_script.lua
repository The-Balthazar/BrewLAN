local SConstructionUnit = import('/lua/seraphimunits.lua').SConstructionUnit

SSA0001 = Class(SConstructionUnit) {

    OnCreate = function(self)
        SConstructionUnit.OnCreate(self)
        self:AddBuildRestriction(categories.SELECTABLE)
    end,

    OnStopBeingBuilt = function(self, ...)
        SConstructionUnit.OnStopBeingBuilt(self, unpack(arg) )
    end,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.PodName = podName
        self:ForkThread(self.StayCloseThread)
    end,

    StayCloseThread = function(self)
        local myPos, pPos
        WaitTicks(3)
        self:RemoveBuildRestriction(categories[self.Parent.Pods[self.PodName].StorageID])
        self:RequestRefreshUI()
        while self do
            WaitSeconds(3)
            myPos = self:GetPosition()
            pPos = self.Parent:GetPosition()
            if not self.Parent:IsDead() and VDist2Sq(myPos[1], myPos[3], pPos[1], pPos[3]) > 900 then
                IssueClearCommands({self})
                IssueMove({self},pPos)
            end
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Parent and not self.Parent:IsDead() then
            self.Parent:NotifyOfPodDeath(self.PodName)
            self.Parent = nil
        end
        SConstructionUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnDestroy = function(self)
        if self.Parent and not self.Parent:IsDead() then
            self.Parent:NotifyOfPodDeath(self.PodName)
            self.Parent = nil
        end
        SConstructionUnit.OnDestroy(self)
    end,
}

TypeClass = SSA0001
