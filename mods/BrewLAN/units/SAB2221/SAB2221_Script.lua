--------------------------------------------------------------------------------
--  Summary  :  Aeon Stationary Explosive Script
--------------------------------------------------------------------------------
local MineStructureUnit = import('/lua/defaultunits.lua').BrewLANMineStructureUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')

SAB2221 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(MineStructureUnit.Weapons.Suicide) {
   			FxDeathLand = EffectTemplate.AOblivionCannonHit02,
        },
    },
}
TypeClass = SAB2221
