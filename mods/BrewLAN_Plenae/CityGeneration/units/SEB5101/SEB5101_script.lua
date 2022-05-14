--------------------------------------------------------------------------------
-- UEF Wall: With cordinal scripting
--------------------------------------------------------------------------------
local def = import('/lua/defaultunits.lua')
local wall = rawget(def, 'BrewLANCardinalWallUnit') or def.WallStructureUnit
def = nil

SEB5210 = Class(wall) {}

TypeClass = SEB5210
