--------------------------------------------------------------------------------
--    Hook : /lua/defaultunits.lua
-- Summary : BrewLAN unit scripts used by multiple factions and multiple units
--  Author : Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local BrewLANClassesPath = import( '/lua/game.lua' ).BrewLANPath .. '/lua/classes/'

-- Construction
BrewLANExperimentalFactoryUnit = import(BrewLANClassesPath..'Gantry.lua').ExperimentalFactoryUnit
ConstructionStructureUnit = import(BrewLANClassesPath..'ConstructionStructure.lua').ConstructionStructureUnit

-- Economy
BrewLANEnergyStorageUnit = import(BrewLANClassesPath..'EnergyStorage.lua').VariableEnergyStorageUnit

-- Defense
    local BrewLANWalls = import(BrewLANClassesPath..'Walls.lua')
BrewLANCardinalWallUnit = BrewLANWalls.CardinalWallUnit
BrewLANCardinalWallGateUnit = BrewLANWalls.CardinalWallGateUnit
BrewLANSelfDefendingCardinalWallUnit = BrewLANWalls.SelfDefendingCardinalWallUnit
    local BrewLANMines = import(BrewLANClassesPath..'Mines.lua')
BrewLANMineStructureUnit = BrewLANMines.MineStructureUnit
BrewLANNukeMineStructureUnit = BrewLANMines.NukeMineStructureUnit

-- Misc structure
BrewLANFootprintDummyUnit = import(BrewLANClassesPath..'Misc.lua').FootprintDummyUnit

-- Mobile units
DirectionalWalkingLandUnit = import(BrewLANClassesPath..'Misc.lua').DirectionalWalkingLandUnit
BrewLANGeoSatelliteUnit = import(BrewLANClassesPath..'Satellite.lua').GeoSatelliteUnit
