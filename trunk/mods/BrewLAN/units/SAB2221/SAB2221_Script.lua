#****************************************************************************
#**
#**  Summary  :  Aeon Stationary Explosive Script
#**
#****************************************************************************

local MineStructureUnit = import('/mods/brewlan/lua/defaultunits.lua').MineStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SAB2221 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.AOblivionCannonHit02,  
        },
    },
}
TypeClass = SAB2221