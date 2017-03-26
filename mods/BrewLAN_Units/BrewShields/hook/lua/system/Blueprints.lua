--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    BubbleTeaRubbsOffGazUI(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- This fixes GAZ_UI asuming that just because it has a shield that the unit knows how good it is.
--------------------------------------------------------------------------------

function BubbleTeaRubbsOffGazUI(all_bps)
    for id, bp in all_bps do
        if table.find(bp.Categories, 'STRUCTURE') and not bp.Defense.Shield then
            if not bp.Defense then bp.Defense = {} end
            bp.Defense.Shield = {ShieldMaxHealth = 1}
        end
    end
end

end
