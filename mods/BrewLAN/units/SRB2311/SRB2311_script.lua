#****************************************************************************
#**
#**  File     :  /cdimage/units/URS0302/URS0302_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Cybran Battleship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFProtonCannonWeapon = import('/lua/cybranweapons.lua').CDFProtonCannonWeapon
       
SRB2311 = Class(CStructureUnit) {
    Weapons = {
        FrontCannon01 = Class(CDFProtonCannonWeapon) {},
    },
}
TypeClass = SRB2311
