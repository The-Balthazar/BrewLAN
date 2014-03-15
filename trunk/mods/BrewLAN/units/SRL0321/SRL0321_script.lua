#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0111/URL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local CAMEMPMissileWeapon = import('/lua/cybranweapons.lua').CAMEMPMissileWeapon

SRL0321 = Class(CLandUnit) {
    Weapons = {
        MissileRack = Class(CAMEMPMissileWeapon) {},
    },
}

TypeClass = SRL0321
