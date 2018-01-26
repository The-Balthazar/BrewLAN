local TDFShipGaussCannonProjectile = import('/lua/terranprojectiles.lua').TDFShipGaussCannonProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
TDFRailGun = Class(TDFShipGaussCannonProjectile) {
    FxTrails = {'/effects/emitters/seraphim_ohwalli_strategic_flight_fxtrails_03_emit.bp',},
    PolyTrail = BrewLANPath .. '/effects/emitters/brewlan_railgun_polytrail_01_emit.bp',
    FxLandHitScale = 1,
    
    CreateRailGunImpactEffects = function( self, army, EffectTable, EffectScale, target )
        local emit = nil
        for k, v in EffectTable do
            emit = CreateEmitterAtEntity(target,army,v)
            if emit and EffectScale != 1 then
                emit:ScaleEmitter(EffectScale or 1)
            end
        end
    end,
}
TypeClass = TDFRailGun
