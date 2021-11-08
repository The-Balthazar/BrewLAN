--------------------------------------------------------------------------------
--  Summary  :  Seraphim Stationary Explosive Script
--------------------------------------------------------------------------------
local MineStructureUnit = import('/lua/defaultunits.lua').BrewLANMineStructureUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')

SSB2221 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(MineStructureUnit.Weapons.Suicide) {
   			FxDeathLand = EffectTemplate.SZhanaseeBombHit01,
            FxDeathWater = EffectTemplate.SRifterArtilleryWaterHit,
            SplatTexture = {
                Albedo = {'scorch_012_albedo',8}
            },
        },
    },
}
TypeClass = SSB2221
