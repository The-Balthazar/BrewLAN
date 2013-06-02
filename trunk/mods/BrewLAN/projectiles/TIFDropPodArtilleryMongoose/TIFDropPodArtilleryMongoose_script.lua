#
# UEF Anti-Matter Shells
#
local TIFDropPodArtilleryMechMarine = import('/mods/brewlan/projectiles/TIFDropPodArtilleryMechMarine/TIFDropPodArtilleryMechMarine_script.lua').TIFDropPodArtilleryMechMarine
TIFDropPodArtilleryMongoose = Class(TIFDropPodArtilleryMechMarine) {

    FxLandHitScale = 0.3,
    FxUnitHitScale = 0.3,
    FxSplatScale = 1.5,

}

TypeClass = TIFDropPodArtilleryMongoose