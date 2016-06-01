#****************************************************************************
#**
#**  Summary  :  Aeon Stationary Explosive Script
#**
#****************************************************************************

local MineStructureUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').MineStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SRB2220 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(CMobileKamikazeBombWeapon) {      
            FxDeath = EffectTemplate.CHvyProtonCannonHitUnit,  
        },
    },
}
TypeClass = SRB2220
