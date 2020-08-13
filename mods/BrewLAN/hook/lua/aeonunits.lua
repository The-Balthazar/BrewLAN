local ConstructionStructureUnit = DefaultUnitsFile.ConstructionStructureUnit

AConstructionStructureUnit = Class(ConstructionStructureUnit) {
    CreateBuildEffects = function(self, unitBeingBuilt, order)
        EffectUtil.CreateAeonCommanderBuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
    end,
}
