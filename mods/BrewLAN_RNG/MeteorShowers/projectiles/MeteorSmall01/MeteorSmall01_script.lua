local Projectile = import('/lua/sim/DefaultProjectiles.lua').EmitterProjectile
local Hit1 = import('/lua/EffectTemplates.lua').ExplosionEffectsLrg02

MeteorSmall01 = Class(Projectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp'},
    FxImpactTrajectoryAligned = false,
    FxTrailScale = 75,
    FxTrailOffset = -2,
    FxImpactUnit = Hit1,
    FxImpactLand = Hit1,
    FxImpactWater = {
        '/effects/emitters/seraphim_rifter_artillery_hit_01w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_02w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_03w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_05w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_06w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_08w_emit.bp',
    },
    FxImpactNone = Hit1,
    FxImpactProp = Hit1,
    RandomPolyTrails = 2,

    OnImpact = function(self, impactType, targetEntity)
        local dam = self.DamageData.DamageAmount
        self.DamageData.DamageAmount = (dam*0.5)+(dam*0.5*Random())
        Projectile.OnImpact(self, impactType, targetEntity)
        local pos = self:GetPosition()
        if impactType == 'Terrain' then
            CreateSplat(
                pos,
                Random()*2*math.pi,
                'czar_mark01_albedo',
                5, 5,
                500, 100,
                -1
            )
            local num = Random(1,7)
            if num <= 5 then
                CreatePropHPR(
                    '/env/Lava/Props/Rocks/Lav_Rock0'..num..'_prop.bp',
                    pos[1], pos[2], pos[3],
                    Random(0,360), Random(-20,20), Random(-20,20)
                )
            end
            DamageArea(self, pos, self.DamageData.DamageRadius+1, 1, 'Force', true)
            DamageArea(self, pos, self.DamageData.DamageRadius+1, 1, 'Force', true)
            DamageRing(self, pos, self.DamageData.DamageRadius+2, 15, 1, 'Fire', true)
        end
    end,
}

TypeClass = MeteorSmall01
