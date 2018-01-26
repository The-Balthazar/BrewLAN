local BeamsFile = import('/lua/defaultcollisionbeams.lua')
local PhasonLaserCollisionBeam = BeamsFile.PhasonLaserCollisionBeam
local OrbitalDeathLaserCollisionBeam = BeamsFile.OrbitalDeathLaserCollisionBeam

AlchemistPhasonLaserCollisionBeam = Class(PhasonLaserCollisionBeam) {
    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.4,
    FxBeam = {import( '/lua/game.lua' ).BrewLANPath() .. '/effects/emitters/brewlan_alchemist_phason_laser_beam_01_emit.bp'},
    SplatTexture = 'czar_mark01_albedo',
}

--[[DeathLaserCollisionBeam = Class(OrbitalDeathLaserCollisionBeam) {
    FxBeamStartPoint = {
		'/effects/emitters/uef_orbital_death_laser_muzzle_02_emit.bp',	# molecular, small details
    },
}]]--
