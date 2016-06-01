local TWalkingLandUnit = UAL0301
local SCUFieldUpgrade = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').SCUFieldUpgrade
TWalkingLandUnit = SCUFieldUpgrade(UAL0301)

UAL0301 = Class(TWalkingLandUnit) {
}

TypeClass = UAL0301
