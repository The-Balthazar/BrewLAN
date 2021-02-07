local TWalkingLandUnit = UEL0301
local SCUFieldUpgrade = import(import( '/lua/game.lua' ).BrewLANPath .. '/lua/FieldEngineers.lua').SCUFieldUpgrade
TWalkingLandUnit = SCUFieldUpgrade(UEL0301)

UEL0301 = Class(TWalkingLandUnit) {}

TypeClass = UEL0301
