local ConstructionUnit = URL0208
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

URL0208 = Class(ConstructionUnit) {
}

TypeClass = URL0208
