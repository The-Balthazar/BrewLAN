#
# UEF Anti-Matter Shells
#
local TIFDropPodArtilleryMechMarine = import('/mods/brewlan/projectiles/TIFDropPodArtilleryMechMarine/TIFDropPodArtilleryMechMarine_script.lua').TIFDropPodArtilleryMechMarine
TIFDropPodArtilleryPercival = Class(TIFDropPodArtilleryMechMarine) {

    FxLandHitScale = 0.4,
    FxUnitHitScale = 0.4,
    FxSplatScale = 2,

}

TypeClass = TIFDropPodArtilleryPercival