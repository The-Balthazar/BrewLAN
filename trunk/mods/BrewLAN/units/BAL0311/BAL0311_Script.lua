#****************************************************************************
#**
#**  Summary  :  Aeon Assault Tank Script
#**
#****************************************************************************

local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local ADFCannonOblivionWeapon = import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon

BAL0311 = Class(ALandUnit) {

    Weapons = {
        MainGun = Class(ADFCannonOblivionWeapon) {
			FxMuzzleFlash = {
				'/effects/emitters/oblivion_cannon_flash_04_emit.bp',
				'/effects/emitters/oblivion_cannon_flash_05_emit.bp',				
				'/effects/emitters/oblivion_cannon_flash_06_emit.bp',
			},        
	}
    },
    
}
TypeClass = BAL0311