
ConstructionStructureUnit = Class(StructureUnit) {
    OnCreate = function(self)
        -- Structure stuff
        StructureUnit.OnCreate(self)

        --Construction stuff
        local bp = self:GetBlueprint()
        self.EffectsBag = {}
        if bp.General.BuildBones then
            self:SetupBuildBones()
        end

        -- Save build effect bones for faster access when creating build effects
        self.BuildEffectBones = bp.General.BuildBones.BuildEffectBones

        if bp.Display.AnimationOpen or bp.Display.AnimationBuild then
            self.BuildingOpenAnim = bp.Display.AnimationOpen or bp.Display.AnimationBuild
        end
        if self.BuildingOpenAnim then
            self.AnimationManipulator = CreateAnimator(self)
            self.AnimationManipulator:PlayAnim(self.BuildingOpenAnim, false):SetRate(0)
            self.Trash:Add(self.AnimationManipulator)
        end

        self.BuildingUnit = false
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true
        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(1)
        end
        StructureUnit.OnStartBuild(self,unitBeingBuilt, order)
    end,

    -- This will only be called if not in StructureUnit's upgrade state
    OnStopBuild = function(self, unitBeingBuilt)
        StructureUnit.OnStopBuild(self, unitBeingBuilt)

        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil

        if self.BuildingOpenAnimManip and self.BuildArmManipulator then
            self.StoppedBuilding = true
        elseif self.BuildingOpenAnimManip then
            self.AnimationManipulator:SetRate(-1)
        end
        
        self.BuildingUnit = false
    end,

    OnPaused = function(self)
        --When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
        StructureUnit.OnPaused(self)
        if self.BuildingUnit then
            StructureUnit.StopBuildingEffects(self, self:GetUnitBeingBuilt())
        end
    end,

    OnUnpaused = function(self)
        if self.BuildingUnit then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
            StructureUnit.StartBuildingEffects(self, self:GetUnitBeingBuilt(), self.UnitBuildOrder)
        end
        StructureUnit.OnUnpaused(self)
    end,

    OnProductionPaused = function(self)
        if self:IsUnitState('Building') then
            self:SetMaintenanceConsumptionInactive()
        end
        self:SetProductionActive(false)
    end,

    OnProductionUnpaused = function(self)
        if self:IsUnitState('Building') then
            self:SetMaintenanceConsumptionActive()
        end
        self:SetProductionActive(true)
    end,

    StartBuildingEffects = function(self, unitBeingBuilt, order)
        StructureUnit.StartBuildingEffects(self, unitBeingBuilt, order)
    end,

    StopBuildingEffects = function(self, unitBeingBuilt)
        StructureUnit.StopBuildingEffects(self, unitBeingBuilt)
    end,

    WaitForBuildAnimation = function(self, enable)
        if self.BuildArmManipulator then
            WaitFor(self.BuildingOpenAnimManip)
            if (enable) then
                self.BuildArmManipulator:Enable()
            end
        end
    end,

    OnPrepareArmToBuild = function(self)
        StructureUnit.OnPrepareArmToBuild(self)

        if self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(self:GetBlueprint().Display.AnimationBuildRate or 1)
            if self.BuildArmManipulator then
                self.StoppedBuilding = nil
                ForkThread( self.WaitForBuildAnimation, self, true )
            end
        end
    end,

    OnStopBuilderTracking = function(self)
        StructureUnit.OnStopBuilderTracking(self)

        if self.StoppedBuilding then
            self.StoppedBuilding = nil
            self.BuildArmManipulator:Disable()
            self.BuildingOpenAnimManip:SetRate(-(self:GetBlueprint().Display.AnimationBuildRate or 1))
        end
    end,

    CheckBuildRestriction = function(self, target_bp)
        return self:CanBuild(target_bp.BlueprintId)
    end,

    CreateReclaimEffects = function( self, target )
		EffectUtil.PlayReclaimEffects( self, target, self:GetBlueprint().General.BuildBones.BuildEffectBones or {0,}, self.ReclaimEffectsBag )
    end,

    CreateReclaimEndEffects = function( self, target )
        EffectUtil.PlayReclaimEndEffects( self, target )
    end,

    CreateCaptureEffects = function( self, target )
		EffectUtil.PlayCaptureEffects( self, target, self:GetBlueprint().General.BuildBones.BuildEffectBones or {0,}, self.CaptureEffectsBag )
    end,
}

FootprintDummyUnit = Class(StructureUnit) {
    OnAdjacentTo = function(self, AdjUnit, TriggerUnit)
        if not self.AdjacentData then self.AdjacentData = {} end
        table.insert(self.AdjacentData, AdjUnit)
        StructureUnit.OnAdjacentTo(self, AdjUnit, TriggerUnit)
    end,

    OnNotAdjacentTo = function(self, AdjUnit)
        self.Parent.OnNotAdjacentTo(self.Parent, AdjUnit)
        AdjUnit:OnNotAdjacentTo(self.Parent)
        self.ForceDestroyAdjacentEffects({self.Parent, AdjUnit})
        StructureUnit.OnNotAdjacentTo(self, AdjUnit)
    end,
}
