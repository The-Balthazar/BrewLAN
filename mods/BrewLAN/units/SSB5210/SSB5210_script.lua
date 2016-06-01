#****************************************************************************
#** 
#**  Cybran Wall: With cordinal scripting
#** 
#****************************************************************************
local SWallStructureUnit = import('/lua/seraphimunits.lua').SWallStructureUnit
local CardinalWallUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/walls.lua').CardinalWallUnit
SWallStructureUnit = CardinalWallUnit( SWallStructureUnit )

SSB5210 = Class(SWallStructureUnit) {}

TypeClass = SSB5210
