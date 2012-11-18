#****************************************************************************
#**
#**  File     :  /cdimage/units/DAL0310/DAL0310_script.lua
#**  Author(s):  Dru Staltman, Matt Vainio
#**
#**  Summary  :  Aeon Shield Disruptor Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local WeaponsFile = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = WeaponsFile.ADFCannonOblivionWeapon02

SAL0401 = Class(ALandUnit) {
    Weapons = {
        MainGun = Class(ADFCannonOblivionWeapon) {},
    },
}
TypeClass = SAL0401

