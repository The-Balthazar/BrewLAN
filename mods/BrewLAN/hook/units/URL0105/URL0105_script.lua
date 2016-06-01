local ConstructionUnit = URL0105
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

URL0105 = Class(ConstructionUnit) {
}

TypeClass = URL0105
