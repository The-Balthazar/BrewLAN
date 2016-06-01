#****************************************************************************
#**
#**	Summary	: Aeon Heavy Assault Tank Script
#**
#****************************************************************************

local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local ADFCannonOblivionWeapon = import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon

SAL0311 = Class(ALandUnit) {

    Weapons = {
        MainGun = Class(ADFCannonOblivionWeapon) {
    		FxChargeMuzzleFlashScale = 0.3,
	}
    },
}
TypeClass = SAL0311
