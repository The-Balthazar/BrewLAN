local ConstructionUnit = UEL0208
local RegularAIEngineer = import('/mods/BrewLAN/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

UEL0208 = Class(ConstructionUnit) {
}

TypeClass = UEL0208