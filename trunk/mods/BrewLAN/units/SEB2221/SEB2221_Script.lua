#****************************************************************************
#**
#**  Summary  :  UEF Stationary Explosive Script
#**
#****************************************************************************

local MineStructureUnit = import('/mods/brewlan/lua/defaultunits.lua').MineStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SEB2221 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.TAntiMatterShellHit01, 
        },
    },
}
TypeClass = SEB2221