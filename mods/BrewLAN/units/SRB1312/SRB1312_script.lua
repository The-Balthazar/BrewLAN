--------------------------------------------------------------------------------
-- Summary  :  Cybran Mass Extractor Script
--------------------------------------------------------------------------------
local CMassCollectionUnit = import('/lua/cybranunits.lua').CMassCollectionUnit

SRB1312 = Class(CMassCollectionUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        self.AnimationManipulator = CreateAnimator(self)
        self.Trash:Add(self.AnimationManipulator)
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationOpen, true)
        CMassCollectionUnit.OnStopBeingBuilt(self,builder,layer)
        --Force update of the cloak effect if there is a cloak mesh. For FAF graphics
        if self:GetBlueprint().Display.CloakMeshBlueprint then
            self:ForkThread(
                function()
                    WaitTicks(1)
                    self:UpdateCloakEffect(true, 'Cloak')
                end
            )
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        CMassCollectionUnit.OnStartBuild(self, unitBeingBuilt, order)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(0)
        self.AnimationManipulator:Destroy()
        self.AnimationManipulator = nil
    end,

    OnProductionPaused = function(self)
        CMassCollectionUnit.OnProductionPaused(self)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(0)
    end,

    OnProductionUnpaused = function(self)
        CMassCollectionUnit.OnProductionUnpaused(self)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(1)
    end,
}

TypeClass = SRB1312
