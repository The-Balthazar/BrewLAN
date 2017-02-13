--------------------------------------------------------------------------------
--  Summary  :  Cybran Stationary Explosive Script
--------------------------------------------------------------------------------
local MineStructureUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').MineStructureUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')

SRB2220 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(MineStructureUnit.Weapons.Suicide) {
            FxDeathLand = EffectTemplate.CHvyProtonCannonHitUnit,
        },
    },
}
TypeClass = SRB2220
