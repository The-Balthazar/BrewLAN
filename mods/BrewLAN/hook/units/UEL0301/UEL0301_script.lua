#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0301/UEL0301_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  UEF Sub Commander Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TWalkingLandUnit = UEL0301
local SCUFieldUpgrade = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/FieldEngineers.lua').SCUFieldUpgrade
TWalkingLandUnit = SCUFieldUpgrade(UEL0301)

UEL0301 = Class(TWalkingLandUnit) {
}

TypeClass = UEL0301
