#****************************************************************************
#**
#**  File     :  /cdimage/units/UES0302/UES0302_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Battleship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TDFShipGaussCannonWeapon = import('/lua/terranweapons.lua').TDFShipGaussCannonWeapon

SEB2311 = Class(TStructureUnit) {
    Weapons = {
        FrontTurret02 = Class(TDFShipGaussCannonWeapon) {},
    },
}

TypeClass = SEB2311
