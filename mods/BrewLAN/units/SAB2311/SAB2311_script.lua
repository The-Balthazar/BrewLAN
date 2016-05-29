#****************************************************************************
#**
#**  File     :  /cdimage/units/UAS0401/UAS0401_script.lua
#**  Author(s):  John Comes
#**
#**  Summary  :  Aeon Experimental Sub
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

SAB2311 = Class(AStructureUnit) {
    Weapons = {
        MainGun = Class(import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon02) {},
    },
}

TypeClass = SAB2311
