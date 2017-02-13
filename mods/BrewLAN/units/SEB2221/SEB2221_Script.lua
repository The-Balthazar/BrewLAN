--------------------------------------------------------------------------------
--  Summary  :  UEF Stationary Explosive Script
--------------------------------------------------------------------------------
local MineStructureUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').MineStructureUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')

SEB2221 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(MineStructureUnit.Weapons.Suicide) {
   			FxDeathLand = EffectTemplate.TAntiMatterShellHit01,
            SplatTexture = {
                Albedo = 'nuke_scorch_002_albedo',
                AlphaNormals = 'nuke_scorch_001_normals',
            },
        },
    },
}
TypeClass = SEB2221
