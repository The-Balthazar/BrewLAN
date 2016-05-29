#****************************************************************************
#** 
#**  Cybran Wall: With cordinal scripting
#** 
#****************************************************************************
local StackingBuilderUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').StackingBuilderUnit
local CardinalWallUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/walls.lua').CardinalWallUnit
StackingBuilderUnit = CardinalWallUnit(StackingBuilderUnit) 

SRB5312 = Class(StackingBuilderUnit) {}

TypeClass = SRB5312
