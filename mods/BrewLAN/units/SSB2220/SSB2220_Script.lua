#****************************************************************************
#**
#**  Summary  :  UEF Stationary Explosive Script
#**
#****************************************************************************

local MineStructureUnit = import('/mods/brewlan/lua/defaultunits.lua').MineStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SSB2220 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.SOtheBombHitUnit,  
        },
    },
}
TypeClass = SSB2220