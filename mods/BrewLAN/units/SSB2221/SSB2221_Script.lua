#****************************************************************************
#**
#**  Summary  :  Seraphim Stationary Explosive Script
#**
#****************************************************************************

local MineStructureUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').MineStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SSB2221 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.SZhanaseeBombHit01, 
        },
    },
}
TypeClass = SSB2221
