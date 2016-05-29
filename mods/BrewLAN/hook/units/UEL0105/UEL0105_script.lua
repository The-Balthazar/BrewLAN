local ConstructionUnit = UEL0105
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

UEL0105 = Class(ConstructionUnit) {
}

TypeClass = UEL0105
