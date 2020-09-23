local ConstructionStructureUnit = DefaultUnitsFile.ConstructionStructureUnit
local DirectionalWalkingLandUnit = DefaultUnitsFile.DirectionalWalkingLandUnit

SConstructionStructureUnit = Class(ConstructionStructureUnit) {
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
    end,
}

SDirectionalWalkingLandUnit = Class(DirectionalWalkingLandUnit) {}
