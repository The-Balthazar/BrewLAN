local CIridiumRocketProjectile = import('/lua/cybranprojectiles.lua').CIridiumRocketProjectile
local FxScale = 2.5

CPM_Tyrant_AGM = Class(CIridiumRocketProjectile) {

	FxAirUnitHitScale = FxScale,
    FxLandHitScale = FxScale,
    FxNoneHitScale = FxScale,
    FxPropHitScale = FxScale,
    FxProjectileHitScale = FxScale,
    FxProjectileUnderWaterHitScale = FxScale,
    FxShieldHitScale = FxScale,
    FxUnderWaterHitScale = FxScale,
    FxUnitHitScale = FxScale,
    FxWaterHitScale = FxScale,
    FxOnKilledScale = FxScale,

    OnCreate = function(self)
        CIridiumRocketProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
    end,

}

TypeClass = CPM_Tyrant_AGM
