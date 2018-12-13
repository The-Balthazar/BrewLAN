--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)         
    OldModBlueprints(all_blueprints)
    
    StealthTrain(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- ALL ABOARD THE STEALTH TRAIN BABY
--------------------------------------------------------------------------------

function StealthTrain(all_bps)
    for id, bp in all_bps do
        if table.find(bp.Categories, 'SELECTABLE') and bp.Intel and bp.Display then
            bp.Intel.Cloak = true
            bp.Intel.FreeIntel = true
            if not bp.Display.Abilities then
                bp.Display.Abilities = {'<LOC ability_cloak>Cloaking',}
            elseif not table.find(bp.Display.Abilities,'<LOC ability_cloak>Cloaking') then
                table.insert(bp.Display.Abilities,'<LOC ability_cloak>Cloaking')
            end
        end
    end
end

end