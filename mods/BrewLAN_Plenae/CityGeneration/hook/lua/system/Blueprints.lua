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
        'xec1301',
        'xec1401',
        'xec1501',

        'sec1201',
        'sec1202',
        'sec1203',

        'uac1101',
        'uac1201',
        'uac1301',
        'uac1401',
        'uac1501',
        'uac1901',
        'xac2201',

        'urc1101',
        'urc1201',
        'urc1301',
        'urc1401',
        'urc1501',
        'urc1901',
        'urc1902',
        'xrc2201',
    }
    for i, id in units do
        local bp = all_bps[id]
        if bp and bp.General then
            bp.General.CapCost = 0
        end
    end
end

end
