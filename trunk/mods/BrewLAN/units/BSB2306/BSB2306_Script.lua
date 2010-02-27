#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB2301/UAB2301_script.lua
#**  Author(s):  Greg Kohne
#**
#**  Summary  :  Aeon Heavy Gun Tower Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeam

BSB2306 = Class(SStructureUnit) {
    Weapons = {
        MainGun = Class(SDFUnstablePhasonBeam) {},
    },
}

TypeClass = BSB2306