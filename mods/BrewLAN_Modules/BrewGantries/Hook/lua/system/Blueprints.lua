--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    BrewLANGantryHomogeniser(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Fuck with the Gantries
--------------------------------------------------------------------------------

function BrewLANGantryHomogeniser(all_bps)
    local Gantries = {
        'sab0401',
        'srb0401',
        'ssb0401',
    }
    for i, id in Gantries do
        local bp = all_bps[id]
        if bp then
            --------------------------------------------------------------------
            -- Change the description to the generic Gantry description
            --------------------------------------------------------------------
            bp.Description = '<LOC seb0401>Experimental Factory'

            --------------------------------------------------------------------
            -- Add the air/land toggle
            --------------------------------------------------------------------
            if not bp.General.ToggleCaps then bp.General.ToggleCaps = {} end
            bp.General.ToggleCaps.RULEUTC_WeaponToggle = true
            if not bp.General.OrderOverrides then bp.General.OrderOverrides = {} end
            bp.General.OrderOverrides.RULEUTC_WeaponToggle = {bitmapId = 'airsf', helpText = 'buildair'}

            --------------------------------------------------------------------
            -- Check we have all the build categories for transports and field engineers
            --------------------------------------------------------------------
            if bp.Economy.BuildableCategory and type(bp.Economy.BuildableCategory) == 'table' then
                local landcat, transcat
                for i, buildcat in bp.Economy.BuildableCategory do
                    if string.find(buildcat, 'BUILTBYLANDTIER3FACTORY') then
                        landcat = true
                    elseif string.find(buildcat, 'TRANSPORTBUILTBYTIER3FACTORY') then
                        transcat = true
                    end
                end
                if not landcat then
                    table.insert(bp.Economy.BuildableCategory, 'BUILTBYLANDTIER3FACTORY ' .. string.upper(bp.General.FactionName or 'NOTHING'))
                end
                if not transcat then
                    table.insert(bp.Economy.BuildableCategory, 'TRANSPORTBUILTBYTIER3FACTORY ' .. string.upper(bp.General.FactionName or 'NOTHING'))
                end
            end

            --------------------------------------------------------------------
            -- Make sure we can be built both on land and in or on water
            --------------------------------------------------------------------
            --if not bp.General.Icon or bp.General.Icon == 'land' then bp.General.Icon = 'amph' end
            if bp.Physics.BuildOnLayerCaps then bp.Physics.BuildOnLayerCaps.LAYER_Land = true end
            if bp.Wreckage.WreckageLayers then bp.Wreckage.WreckageLayers.Land = true end
            if not (bp.Physics.BuildOnLayerCaps.LAYER_Seabed or bp.Physics.BuildOnLayerCaps.LAYER_Water) then
                bp.Physics.BuildOnLayerCaps.LAYER_Seabed = true
                if bp.Wreckage.WreckageLayers then bp.Wreckage.WreckageLayers.Seabed = true end
            end

        end
    end
end

end
