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

do
    local oldStructureUnit = StructureUnit

    StructureUnit = Class(oldStructureUnit) {
        FlattenSkirt = function(self)
            if not (__blueprints[self.BpId] or self:GetBlueprint()).Physics.ConditionalFlattenSkirt then
                oldStructureUnit.FlattenSkirt(self)
            else
                self:ForkThread(function(self)
                    coroutine.yield(1) -- Delay because this triggers before it gets attached to anything.
                    local pos = self.CachePosition or self:GetPosition()
                    local terrain = GetTerrainHeight(pos[1], pos[3])
                    if pos[2] == terrain then
                        oldStructureUnit.FlattenSkirt(self)
                    end
                end)
            end
        end
    }
end
