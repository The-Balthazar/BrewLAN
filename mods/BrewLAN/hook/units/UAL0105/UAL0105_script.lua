local ConstructionUnit = UAL0105
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

UAL0105 = Class(ConstructionUnit) {
}

TypeClass = UAL0105
