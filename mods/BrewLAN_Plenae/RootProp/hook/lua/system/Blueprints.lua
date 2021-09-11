--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    ModPropRoot(all_blueprints.Prop)
end

--------------------------------------------------------------------------------
-- See many things.
--------------------------------------------------------------------------------

function ModPropRoot(all_bps)
    local modpaths = {}
    for i, mod in __active_mods do
        table.insert( modpaths, { string.lower(mod.location)..'/', string.len(mod.location) + 1 } )
    end
    for id, bp in all_bps do
        local bpid = string.lower(bp.BlueprintId)
        if string.sub(bpid, 1, 6) == '/mods/' then
            for i, path in modpaths do
                if string.sub(bpid, 1, path[2]) == path[1] then
                    local newid = string.gsub(bpid, path[1], '/')
                    all_bps[newid] = table.deepcopy(bp)
                    all_bps[newid].BlueprintId = newid
                    break
                end
            end
        end
    end
end

end
