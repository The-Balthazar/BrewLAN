--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    Antibabypillen(all_blueprints.Unit)
end

--------------------------------------------------------------------------------

function Antibabypillen(all_bps)
    for id, bp in all_bps do
        if bp.Categories and table.find(bp.Categories, 'MINE') then
            table.insert(bp.Categories, 'UNTARGETABLE')
        end
    end
end

end
