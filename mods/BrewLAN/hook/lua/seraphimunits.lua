local ConstructionStructureUnit = DefaultUnitsFile.ConstructionStructureUnit

SConstructionStructureUnit = Class(ConstructionStructureUnit) {
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
    end,
}
