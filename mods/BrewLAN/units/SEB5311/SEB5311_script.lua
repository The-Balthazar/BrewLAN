#****************************************************************************
#** 
#**  UEF Gate: With cordinal scripting
#** 
#****************************************************************************
local TWallStructureUnit = import('/lua/terranunits.lua').TWallStructureUnit
local CardinalWallUnit = import('/mods/brewlan/lua/walls.lua').CardinalWallUnit
local GateWallUnit = import('/mods/brewlan/lua/walls.lua').GateWallUnit
TWallStructureUnit = CardinalWallUnit( TWallStructureUnit ) 
TWallStructureUnit = GateWallUnit( TWallStructureUnit )

SEB5311 = Class(TWallStructureUnit) {}

TypeClass = SEB5311