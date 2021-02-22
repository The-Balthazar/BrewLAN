--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    Waterlag(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Allowing many buildings to be buildable in/on the water
--------------------------------------------------------------------------------

function Waterlag(all_bps)
    for id, bp in all_bps do
        if bp.Categories and table.find(bp.Categories, 'STRUCTURE') then
            if not table.find(bp.Categories, 'FACTORY')
            and not table.find(bp.Categories, 'WALL')
            and not table.find(bp.Categories, 'HEAVYWALL')
            and not table.find(bp.Categories, 'MEDIUMWALL')
            and not table.find(bp.Categories, 'SILO')
            and not table.find(bp.Categories, 'EXPERIMENTAL')
            then
                -- Default value if table is nil
                if bp.Physics and not bp.Physics.BuildOnLayerCaps then bp.Physics.BuildOnLayerCaps = { LAYER_Land = true } end
                --The thing
                if bp.Physics and bp.Physics.BuildOnLayerCaps.LAYER_Land then
                    if not bp.Physics.BuildOnLayerCaps.LAYER_Water
                    and not bp.Physics.BuildOnLayerCaps.LAYER_Seabed
                    and not bp.Physics.BuildOnLayerCaps.LAYER_Sub
                    then
                        if not bp.Display then bp.Display = {} end
                        if not bp.Display.Abilities then bp.Display.Abilities = {} end
                        if not table.find(bp.Display.Abilities, '<LOC ability_aquatic>Aquatic') then
                            table.insert(bp.Display.Abilities, '<LOC ability_aquatic>Aquatic')
                        end
                        if bp.General.Icon == 'land' then bp.General.Icon = 'amph' end
                        bp.Physics.BuildOnLayerCaps.LAYER_Water = true
                        if bp.Wreckage.WreckageLayers.Land then
                            bp.Wreckage.WreckageLayers.Water = true
                        end
                        if bp.CollisionOffsetY and bp.CollisionOffsetY > 0 then
                            table.insert(bp.Categories, 'HOVER')
                        else
                            bp.Display.GiveMeLegs = true
                            bp.CollisionOffsetY = (bp.CollisionOffsetY or 0) - 0.5
                            bp.SizeY = (bp.SizeY or 1) + 0.5
                        end
                    end
                end
            end
        end
    end
end

end
