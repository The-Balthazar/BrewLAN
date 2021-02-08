--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    WonkyResources(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Removing build restrictions on mass extractors.
--------------------------------------------------------------------------------

function WonkyResources(all_bps)
    for id, bp in all_bps do
        if bp.Physics and bp.Physics.BuildRestriction then
            bp.Physics.MaxGroundVariation = 512
            bp.Physics.FlattenSkirt = false
            bp.Physics.SlopeToTerrain = true
        end
    end
end

end
