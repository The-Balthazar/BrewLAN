local ConstructionUnit = XSL0309
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

XSL0309 = Class(ConstructionUnit) {
}

TypeClass = XSL0309
