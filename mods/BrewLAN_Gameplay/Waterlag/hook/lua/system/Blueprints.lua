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
        if table.find(bp.Categories, 'STRUCTURE') then
            if not table.find(bp.Categories, 'FACTORY')
            and not table.find(bp.Categories, 'WALL')
            and not table.find(bp.Categories, 'HEAVYWALL')
            and not table.find(bp.Categories, 'MEDIUMWALL')
            and not table.find(bp.Categories, 'SILO')
            and not table.find(bp.Categories, 'EXPERIMENTAL')
            then
                if bp.Physics.BuildOnLayerCaps.LAYER_Land then
                    if not bp.Physics.BuildOnLayerCaps.LAYER_Water
                    and not bp.Physics.BuildOnLayerCaps.LAYER_Seabed
                    and not bp.Physics.BuildOnLayerCaps.LAYER_Sub
                    then
                        if not bp.Display.Abilities then bp.Display.Abilities = {} end
                        if not table.find(bp.Display.Abilities, '<LOC ability_aquatic>Aquatic') then
                            table.insert(bp.Display.Abilities, '<LOC ability_aquatic>Aquatic')
                        end
                        if bp.General.Icon == 'land' then bp.General.Icon = 'amph' end
                        bp.Physics.BuildOnLayerCaps.LAYER_Water = true
                        if bp.Wreckage.WreckageLayers.Land then
                            bp.Wreckage.WreckageLayers.Water = true
                        end
                        bp.Display.GiveMeLegs = true
                        bp.CollisionOffsetY = (bp.CollisionOffsetY or 0) - .25
                        --[[if bp.Physics then
                            bp.Physics.MeshExtentsOffsetY = (bp.Physics.MeshExtentsOffsetY or 0) -2
                            bp.Physics.MeshExtentsY = (bp.Physics.MeshExtentsOffsetY or 0) + 2
                        else
                            bp.Physics = {
                                MeshExtentsOffsetY = - 2,
                                MeshExtentsY = 2,
                            }
                        end]]--
                    end
                end
            end
        end
    end
end

end
