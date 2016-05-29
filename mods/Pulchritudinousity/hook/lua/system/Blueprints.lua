--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)         
    OldModBlueprints(all_blueprints)
    
    LODsplus(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- See many things.
--------------------------------------------------------------------------------

function LODsplus(all_bps)
    for id, bp in all_bps do
        if bp.Display.Mesh.LODs[1] then
            for i,v in bp.Display.Mesh.LODs do
                if v.LODCutoff then
                    v.LODCutoff = v.LODCutoff * 1000
                end
            end
        end
        if bp.Display.Tarmacs[1] then
            for i,v in bp.Display.Tarmacs do
                if v.FadeOut then
                    v.FadeOut = v.FadeOut * 1000
                end
            end
        end
    end
end

end
