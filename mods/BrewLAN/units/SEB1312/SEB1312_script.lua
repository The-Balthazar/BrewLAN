--------------------------------------------------------------------------------
--  Summary  :  UEF Tier 3 Mass Extractor Script
--------------------------------------------------------------------------------
local TEngineeringResourceStructureUnit = import('/lua/terranunits.lua').TEngineeringResourceStructureUnit

SEB1312 = Class(TEngineeringResourceStructureUnit) {


    PlayActiveAnimation = function(self)
        TEngineeringResourceStructureUnit.PlayActiveAnimation(self)
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationOpen, true)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        TEngineeringResourceStructureUnit.OnStartBuild(self, unitBeingBuilt, order)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(0)
        self.AnimationManipulator:Destroy()
        self.AnimationManipulator = nil
    end,

    OnProductionPaused = function(self)
        TEngineeringResourceStructureUnit.OnProductionPaused(self)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(0)
    end,

    OnProductionUnpaused = function(self)
        TEngineeringResourceStructureUnit.OnProductionUnpaused(self)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(1)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TEngineeringResourceStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
}

TypeClass = SEB1312
