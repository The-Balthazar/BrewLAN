#****************************************************************************
#**
#**	File	: /units/BAL0311/BAL0311_Script.lua
#**	Author	: Sean Wheeldon (Balthazar)
#**
#**	Summary	: Aeon Heavy Assault Tank Script
#**
#**	Copyright © 2010 BrewLAN.  All rights reserved.
#****************************************************************************

local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local ADFCannonOblivionWeapon = import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon

BAL0311 = Class(ALandUnit) {

    Weapons = {
        MainGun = Class(ADFCannonOblivionWeapon) {
    		FxChargeMuzzleFlashScale = 0.3,
	}
    },
}
TypeClass = BAL0311