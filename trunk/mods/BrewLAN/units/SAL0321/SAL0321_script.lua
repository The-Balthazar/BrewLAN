#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0111/URL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local CAMEMPMissileWeapon = import('/lua/cybranweapons.lua').CAMEMPMissileWeapon

SAL0321 = Class(AWalkingLandUnit) {
    Weapons = {
        MissileRack = Class(CAMEMPMissileWeapon) {},
    },
}

TypeClass = SAL0321
