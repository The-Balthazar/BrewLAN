--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)         
    OldModBlueprints(all_blueprints)
    
    OriginAbility(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Flagging units origin in abilities list.
--------------------------------------------------------------------------------

function OriginAbility(all_bps)
    for id, bp in all_bps do
        --If it's a selectable unit
        if bp.Categories and table.find(bp.Categories, 'SELECTABLE') then
            local Source = bp.Source
            if string.sub(Source, 1, 7) ~= "/units/" then
                for i, mod in __active_mods do
                    local dirlen = string.len(mod.location)
                    if mod.location == string.sub(Source, 1, dirlen ) and string.sub(Source, dirlen + 1, dirlen + 1) == "/" then
                        Source = mod.name
                        if mod.author then
                            Source = Source .. " (by " .. mod.author .. ")"
                        end
                        break
                    end
                end
                if not bp.Display.Abilities then
                    bp.Display.Abilities = {}
                else
                    table.insert(bp.Display.Abilities, "")
                end
                table.insert(bp.Display.Abilities, "Mod: " .. Source)
            end
        end
    end
end
    
end
