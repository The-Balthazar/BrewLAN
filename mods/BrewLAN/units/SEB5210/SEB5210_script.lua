--------------------------------------------------------------------------------
-- UEF Wall: With cordinal scripting
--------------------------------------------------------------------------------
local TWallStructureUnit = import('/lua/terranunits.lua').TWallStructureUnit
local CardinalWallUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/walls.lua').CardinalWallUnit
--------------------------------------------------------------------------------
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local OffsetBoneToTerrain = import(BrewLANPath .. '/lua/TerrainUtils.lua').OffsetBoneToTerrain
--------------------------------------------------------------------------------
TWallStructureUnit = CardinalWallUnit( TWallStructureUnit )

SEB5210 = Class(TWallStructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TWallStructureUnit.OnStopBeingBuilt(self,builder,layer)
        OffsetBoneToTerrain(self,'North')
        OffsetBoneToTerrain(self,'South')
        OffsetBoneToTerrain(self,'West')
        OffsetBoneToTerrain(self,'East')
        LOG("FEET")
        LOG(repr(self.TerrainSlope))
    end,
}

TypeClass = SEB5210
