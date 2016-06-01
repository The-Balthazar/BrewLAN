local ConstructionUnit = UEL0208
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

UEL0208 = Class(ConstructionUnit) {
}

TypeClass = UEL0208
