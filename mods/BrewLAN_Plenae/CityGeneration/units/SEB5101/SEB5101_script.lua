--------------------------------------------------------------------------------
-- UEF Wall: With cordinal scripting
--------------------------------------------------------------------------------
local BrewLANCardinalWallUnit = import('/lua/defaultunits.lua')

do
    local ok, retclass = pcall(function() return BrewLANCardinalWallUnit.BrewLANCardinalWallUnit end)
    if ok then
        BrewLANCardinalWallUnit = retclass
    else
        BrewLANCardinalWallUnit = BrewLANCardinalWallUnit.WallStructureUnit
    end
end

SEB5210 = Class(BrewLANCardinalWallUnit) {}

TypeClass = SEB5210
