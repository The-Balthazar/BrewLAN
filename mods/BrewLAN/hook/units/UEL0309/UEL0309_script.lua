local ConstructionUnit = UEL0309
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

UEL0309 = Class(ConstructionUnit) {
}

TypeClass = UEL0309
