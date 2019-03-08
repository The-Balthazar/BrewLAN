local CConstructionStructureUnit = import('/lua/cybranunits.lua').CConstructionStructureUnit
local AeonBuildEffects = import('/lua/EffectUtilities.lua').CreateAeonConstructionUnitBuildingEffects

SAB0104 = Class(CConstructionStructureUnit)
{
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        AeonBuildEffects( self, unitBeingBuilt, self.BuildEffectsBag )
    end,
}
TypeClass = SAB0104
