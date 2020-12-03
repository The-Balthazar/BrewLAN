--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    CityscapesChanges(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Allowing many buildings to be buildable in/on the water
--------------------------------------------------------------------------------

function CityscapesChanges(all_bps)
    local units = {
        'uec1101',
        'uec1201',
        'uec1301',
        'uec1401',
        'uec1501',
        'xec1401',
        'xec1501',
    }
    for i, id in units do
        local bp = all_bps[id]
        if bp and bp.General then
            bp.General.CapCost = 0
        end
    end
end

end
