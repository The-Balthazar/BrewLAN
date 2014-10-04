#****************************************************************************
#**
#**  Summary  :  Aeon Stationary Explosive Script
#**
#****************************************************************************

local MineStructureUnit = import('/mods/brewlan/lua/defaultunits.lua').MineStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SAB2220 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(CMobileKamikazeBombWeapon) {      
            FxDeath = EffectTemplate.ABombHit01,  
        },
    },
}
TypeClass = SAB2220