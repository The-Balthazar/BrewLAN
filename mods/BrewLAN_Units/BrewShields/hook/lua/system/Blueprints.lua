--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    PillarOfProminenceProjectionData(all_blueprints.Unit)
end

--------------------------------------------------------------------------------

function PillarOfProminenceProjectionData(all_bps)
    for id, bp in all_bps do
        if bp.Categories and table.find(bp.Categories, 'STRUCTURE') then

            if not (bp.Defense and bp.Defense.Shield) then
                if not bp.Defense then bp.Defense = {} end
                bp.Defense.Shield = {
                    ShieldMaxHealth = 1, -- This fixes GAZ_UI asuming that just because it has a shield that the unit knows how good it is.
                    StartOn = false,
                }
            end

            bp.Defense.Shield.ProjShieldSize = math.max(bp.SizeX or 1, bp.SizeY or 1, bp.SizeZ or 1) * 1.8--1.7321 -- Root 3, approx,
            
        end
    end
end

end
