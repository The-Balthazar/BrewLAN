--------------------------------------------------------------------------------
--  Summary  :  Aeon Stationary Explosive Script
--------------------------------------------------------------------------------
local MineStructureUnit = import('/lua/defaultunits.lua').BrewLANMineStructureUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')

SAB2220 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(MineStructureUnit.Weapons.Suicide) {
            FxDeathLand = EffectTemplate.ABombHit01,
        },
    },
}
TypeClass = SAB2220
