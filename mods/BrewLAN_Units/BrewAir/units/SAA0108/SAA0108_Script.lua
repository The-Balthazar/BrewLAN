local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFBombGravitonWeapon = import('/lua/aeonweapons.lua').AIFBombGravitonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SAA0108 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(AIFBombGravitonWeapon) {

            CreateProjectileAtMuzzle = function(self, muzzle)
                local proj = AIFBombGravitonWeapon.CreateProjectileAtMuzzle(self, muzzle)
                proj.FxImpactLand = EffectTemplate.AIFBallisticMortarHitLand02--ALightMortarHit01
                proj.FxImpactProp = EffectTemplate.AIFBallisticMortarHitUnit02--ALightMortarHit01
                proj.FxImpactUnit = EffectTemplate.AIFBallisticMortarHitUnit02--ALightMortarHit01
                return proj
            end,
        },
    },
}

TypeClass = SAA0108
