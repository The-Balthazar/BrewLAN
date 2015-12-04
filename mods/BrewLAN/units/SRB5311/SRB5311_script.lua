#****************************************************************************
#** 
#**  Cybran Gate: With cordinal scripting
#** 
#****************************************************************************
local CWallStructureUnit = import('/lua/cybranunits.lua').CWallStructureUnit
local CardinalWallUnit = import('/mods/brewlan/lua/walls.lua').CardinalWallUnit
local GateWallUnit = import('/mods/brewlan/lua/walls.lua').GateWallUnit
CWallStructureUnit = CardinalWallUnit( CWallStructureUnit ) 
CWallStructureUnit = GateWallUnit( CWallStructureUnit )

SRB5311 = Class(CWallStructureUnit) {}

TypeClass = SRB5311