#****************************************************************************
#**
#**  File     :  /data/units/XEL0306/XEL0306_script.lua
#**  Author(s):  Jessica St. Croix, Dru Staltman
#**
#**  Summary  :  UEF Mobile Missile Platform Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TOrbitalDeathLaserBeamWeapon = import('/lua/terranweapons.lua').TOrbitalDeathLaserBeamWeapon

BEL0320 = Class(TLandUnit) {
    Weapons = {
        OrbitalDeathLaserWeapon = Class(TOrbitalDeathLaserBeamWeapon){},
    },
}

TypeClass = BEL0320