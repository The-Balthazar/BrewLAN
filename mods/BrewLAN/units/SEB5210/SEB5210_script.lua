#****************************************************************************
#** 
#**  UEF Wall: With cordinal scripting
#** 
#****************************************************************************
local TWallStructureUnit = import('/lua/terranunits.lua').TWallStructureUnit
local CardinalWallUnit = import('/mods/brewlan/lua/walls.lua').CardinalWallUnit
TWallStructureUnit = CardinalWallUnit( TWallStructureUnit ) 

SEB5210 = Class(TWallStructureUnit) {}

TypeClass = SEB5210