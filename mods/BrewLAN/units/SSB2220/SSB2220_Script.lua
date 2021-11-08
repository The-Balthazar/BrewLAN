--------------------------------------------------------------------------------
--  Summary  :  Seraphim Stationary Explosive Script
--------------------------------------------------------------------------------
local MineStructureUnit = import('/lua/defaultunits.lua').BrewLANMineStructureUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')

SSB2220 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(MineStructureUnit.Weapons.Suicide) {
   			FxDeathLand = EffectTemplate.SOtheBombHitUnit,
        },
    },
}
TypeClass = SSB2220
