local ConstructionUnit = UEL0105
local RegularAIEngineer = import('/mods/BrewLAN/lua/FieldEngineers.lua').RegularAIEngineer
ConstructionUnit = RegularAIEngineer(ConstructionUnit)

UEL0105 = Class(ConstructionUnit) {
}

TypeClass = UEL0105