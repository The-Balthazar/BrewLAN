#****************************************************************************
#**
#**  File     :  /main/data/Units/XSA0204/XSA0204_script.lua
#**  Author(s):  Greg Kohne, Gordon Duclos
#**
#**  Summary  :  Seraphim Torpedo Bomber Script
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SANHeavyCavitationTorpedo = SeraphimWeapons.SANHeavyCavitationTorpedo

SSA0307 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(SANHeavyCavitationTorpedo) {},
    },
}
TypeClass = SSA0307