local SConstructionUnit = import('/lua/seraphimunits.lua').SConstructionUnit

SSA0001 = Class(SConstructionUnit) {

    OnCreate = function(self)
        SConstructionUnit.OnCreate(self)
        self:AddBuildRestriction(categories.SELECTABLE)
    end,

    SetParent = function(self, parent, podName, WorkID)
        self.Parent = parent
        self.PodName = podName
        self:ForkThread(self.StayCloseThread, WorkID)
    end,

    StayCloseThread = function(self, WorkID)
        local myPosX, myPosY, myPosZ, pPosX, pPosY, pPosZ
        coroutine.yield(3)
        if categories[WorkID] then
            self:RemoveBuildRestriction(categories[WorkID])
            self:RequestRefreshUI()
        end
        while self do
            coroutine.yield(31)
            myPosX, myPosY, myPosZ = self:GetPositionXYZ()
            pPosX, pPosY, pPosZ = self.Parent:GetPositionXYZ()
            if not self.Parent:IsDead() and VDist2Sq(myPosX, myPosZ, pPosX, pPosZ) > 900 then
                IssueClearCommands{self}
            end
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Parent and not self.Parent.Dead and self.Parent.NotifyOfPodDeath then
            self.Parent:NotifyOfPodDeath(self.PodName)
            self.Parent = nil
        end
        SConstructionUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnDestroy = function(self)
        if self.Parent and not self.Parent.Dead and self.Parent.NotifyOfPodDeath then
            self.Parent:NotifyOfPodDeath(self.PodName)
            self.Parent = nil
        end
        SConstructionUnit.OnDestroy(self)
    end,
}

TypeClass = SSA0001
