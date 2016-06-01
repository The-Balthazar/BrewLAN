local ConstructionUnit = UAL0309
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

UAL0309 = Class(ConstructionUnit) {
}

TypeClass = UAL0309
