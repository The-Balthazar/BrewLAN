#****************************************************************************
#** 
#**  Cybran Wall: With cordinal scripting
#** 
#****************************************************************************
local CWallStructureUnit = import('/lua/cybranunits.lua').CWallStructureUnit
local CardinalWallUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/walls.lua').CardinalWallUnit
CWallStructureUnit = CardinalWallUnit( CWallStructureUnit )

SRB5210 = Class(CWallStructureUnit) {}

TypeClass = SRB5210
