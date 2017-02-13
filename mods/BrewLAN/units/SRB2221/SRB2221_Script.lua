--------------------------------------------------------------------------------
--  Summary  :  Cybran Stationary Explosive Script
--------------------------------------------------------------------------------
local MineStructureUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').MineStructureUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')
SRB2221 = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(MineStructureUnit.Weapons.Suicide) {
            FxDeathLand = EffectTemplate.CProtonBombHit01,
            SplatTexture = {
                Albedo = {'scorch_011_albedo',2}
            },
            OnFire = function(self)
                local army = self.unit:GetArmy()
                CreateLightParticle( self.unit, -1, army, 12, 28, 'glow_03', 'ramp_proton_flash_02' )
                CreateLightParticle( self.unit, -1, army, 8, 22, 'glow_03', 'ramp_antimatter_02' )
                local blanketSides = 12
                local blanketAngle = (2*math.pi) / blanketSides
                local blanketStrength = 1
                local blanketVelocity = 6.25
                for i = 0, (blanketSides-1) do
                    local blanketX = math.sin(i*blanketAngle)
                    local blanketZ = math.cos(i*blanketAngle)
                    self.unit:CreateProjectile('/effects/entities/EffectProtonAmbient01/EffectProtonAmbient01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ):SetVelocity(blanketVelocity):SetAcceleration(-0.3)
                end
                MineStructureUnit.Weapons.Suicide.OnFire(self)
            end,
        },
    },
}
TypeClass = SRB2221
