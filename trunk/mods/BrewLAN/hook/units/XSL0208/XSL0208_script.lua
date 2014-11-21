local ConstructionUnit = XSL0208
local RegularAIEngineer = import('/mods/BrewLAN/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

XSL0208 = Class(ConstructionUnit) {
}

TypeClass = XSL0208