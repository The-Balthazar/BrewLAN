local AMissileSerpentineProjectile = import('/lua/aeonprojectiles.lua').AMissileSerpentineProjectile
local FxScale = 3

APM_Helix_AGM = Class(AMissileSerpentineProjectile) {

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
        AMissileSerpentineProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self:ForkThread( self.MovementThread )
    end,
}
TypeClass = APM_Helix_AGM
