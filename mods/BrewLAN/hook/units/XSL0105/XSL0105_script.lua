local ConstructionUnit = XSL0105
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

XSL0105 = Class(ConstructionUnit) {
}

TypeClass = XSL0105
