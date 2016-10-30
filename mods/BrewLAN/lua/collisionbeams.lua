local PhasonLaserCollisionBeam = import('/lua/defaultcollisionbeams.lua').PhasonLaserCollisionBeam

AlchemistPhasonLaserCollisionBeam = Class(PhasonLaserCollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.4,
    FxBeam = {import( '/lua/game.lua' ).BrewLANPath() .. '/effects/emitters/brewlan_alchemist_phason_laser_beam_01_emit.bp'},
    --FxBeamEndPoint = EffectTemplate.APhasonLaserImpact01,
    SplatTexture = 'czar_mark01_albedo',
    --ScorchSplatDropTime = 0.25,
}