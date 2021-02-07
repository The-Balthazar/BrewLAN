local TWalkingLandUnit = XSL0301
local SCUFieldUpgrade = import(import( '/lua/game.lua' ).BrewLANPath .. '/lua/FieldEngineers.lua').SCUFieldUpgrade
TWalkingLandUnit = SCUFieldUpgrade(XSL0301)

XSL0301 = Class(TWalkingLandUnit) {}

TypeClass = XSL0301
