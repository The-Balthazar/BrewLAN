--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    ParagonAdjacency(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Paragon ajacency with BrewLAN
--------------------------------------------------------------------------------

function ParagonAdjacency(all_bps)
    local BrewLAN = false

    for i, mod in __active_mods do
        if mod.name == "BrewLAN" then
            BrewLAN = true
            break
        end
    end
    local paragons = {'seb1401','srb1401','ssb1401'}
    if BrewLAN then
        for i, paragon in paragons do
            if all_bps[paragon] then -- Prevents game crash on BP partial reload with disk watch
                all_bps[paragon].Adjacency = 'ParagonAdjacencyBuffs'
            end
        end
    end
end

end
