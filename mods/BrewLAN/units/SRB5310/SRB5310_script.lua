#****************************************************************************
#** 
#**  Cybran Wall: With cordinal scripting
#** 
#****************************************************************************
local CardinalWallScript = import('/mods/brewlan/lua/defaultunits.lua').CardinalWallUnit
local CardinalWallUnit = import('/mods/brewlan/lua/walls.lua').CardinalWallUnit
CardinalWallScript = CardinalWallUnit(CardinalWallScript) 

SRB5310 = Class(CardinalWallScript) {}

TypeClass = SRB5310