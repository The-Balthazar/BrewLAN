--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)
    LODsplus(all_blueprints)
end

--------------------------------------------------------------------------------
-- See many things.
--------------------------------------------------------------------------------

function LODsplus(all_bps)
    for id, bp in pairs(all_bps.Mesh) do
        if bp.LODs and bp.LODs[1] then
            for i, v in ipairs(bp.LODs) do
                if v.LODCutoff then
                    v.LODCutoff = v.LODCutoff * 1000
                end
            end
        end
    end
    for id, bp in pairs(all_bps.Unit) do
        if bp.Display.Mesh.LODs[1] then
            for i, v in ipairs(bp.Display.Mesh.LODs) do
                if v.LODCutoff then
                    v.LODCutoff = v.LODCutoff * 1000
                end
            end
        end
        if bp.Display and bp.Display.Tarmacs[1] then
            for i, v in pairs(bp.Display.Tarmacs) do
                if v.FadeOut then
                    v.FadeOut = v.FadeOut * 1000
                end
            end
        end
    end
end

end
