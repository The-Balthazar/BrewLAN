--------------------------------------------------------------------------------
--  Summary:  The Seraphim Experimental Naval Factory script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local BrewLANExperimentalFactoryUnit = import('/lua/defaultunits.lua').BrewLANExperimentalFactoryUnit
--------------------------------------------------------------------------------
local OffsetBoneToSurface = import('../../lua/terrainutils.lua').OffsetBoneToSurface
local CreateSeraphimFactoryBuildingEffects = import('/lua/EffectUtilities.lua').CreateSeraphimFactoryBuildingEffects
--------------------------------------------------------------------------------
SSB0401 = Class(BrewLANExperimentalFactoryUnit) {
    
    OnCreate = function(self)
        BrewLANExperimentalFactoryUnit.OnCreate(self)
        OffsetBoneToSurface(self, 'Attachpoint')
    end,

    StartBuildFx = function( self, unitBeingBuilt )
        unitBeingBuilt.Trash:Add(
            self:ForkThread(
                CreateSeraphimFactoryBuildingEffects,
                unitBeingBuilt,
                __blueprints.ssb0401.General.BuildBones.BuildEffectBones,
                'Attachpoint',
                self.BuildEffectsBag
            )
        )
    end,
}

TypeClass = SSB0401
