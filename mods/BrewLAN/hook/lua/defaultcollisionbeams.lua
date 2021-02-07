ChonkChromBeamGenCollisionBeam = Class(UltraChromaticBeamGeneratorCollisionBeam) {
    FxBeam = {import( '/lua/game.lua' ).BrewLANPath .. '/effects/emitters/brewlan_chromatic_chonk_beam_generator_beam_emit.bp'},
    FxBeamStartPointScale = 2,
    FxBeamEndPointScale = 2,
}

TracerChromBeamGenCollisionBeam = Class(UltraChromaticBeamGeneratorCollisionBeam) {
    FxBeam = {import( '/lua/game.lua' ).BrewLANPath .. '/effects/emitters/brewlan_chromatic_tracer_beam_generator_beam_emit.bp'},
    FxBeamStartPointScale = 0.5,
    FxBeamEndPoint = {},
    FxBeamEndPointScale = 0.5,
    SplatTexture = nil,
}
