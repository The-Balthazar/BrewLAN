local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local GetRandomFloat = import('/lua/utilities.lua').GetRandomFloat

TIFTacticalBomb01 = Class(EmitterProjectile) {

	PolyTrail = '/effects/emitters/default_polytrail_04_emit.bp',
    FxTrails = {},

	FxLandHitScale = 0.4,
    FxUnitHitScale = 0.4,
    FxSplatScale = 4,

	FxImpactTrajectoryAligned = false,
    FxImpactUnit = EffectTemplate.TAntiMatterShellHit01,
    FxImpactProp = EffectTemplate.TAntiMatterShellHit01,
    FxImpactLand = EffectTemplate.TAntiMatterShellHit01,
    FxImpactUnderWater = {},

    OnImpact = function(self, TargetType, targetEntity)
        local army = self:GetArmy()
        local pos = self:GetPosition()
		local rf = GetRandomFloat(0,2*math.pi)

        CreateLightParticle( self, -1, army, 1.4, 2, 'sparkle_03', 'ramp_fire_03' )
        if TargetType == 'Terrain' then
            CreateDecal( pos, rf, 'nuke_scorch_001_normals', '', 'Alpha Normals', self.FxSplatScale, self.FxSplatScale, 150, 50, army )
            CreateDecal( pos, rf, 'nuke_scorch_002_albedo', '', 'Albedo', self.FxSplatScale * 2, self.FxSplatScale * 2, 150, 50, army )
        end
        DamageArea(self, pos, self.DamageData.DamageRadius, 1, 'Force', true)
        DamageArea(self, pos, self.DamageData.DamageRadius, 1, 'Force', true)
		EmitterProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = TIFTacticalBomb01
