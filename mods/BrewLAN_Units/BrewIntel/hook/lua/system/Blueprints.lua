--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)
    RebalanceExistingIntel(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Rebalance a few vanilla units
--------------------------------------------------------------------------------
function RebalanceExistingIntel(all_bps)
    local t3radars = {
        uab3104 = 'sab3301',
        ueb3104 = 'seb3301',
        urb3104 = 'srb3301',
        xsb3104 = 'ssb3302',--Forgot the optics tracking facility was already SSB3301
    }
    for id, omniID in t3radars do
        local bp = all_bps[id]
        local omnibp = all_bps[omniID]
        if bp and omnibp then
            if bp.Intel.OmniRadius and bp.Intel.OmniRadius ~= 0 and bp.Economy.MaintenanceConsumptionPerSecondEnergy and bp.Economy.BuildCostEnergy and bp.Economy.BuildCostMass and bp.Economy.BuildTime then
                --Scale omni radii
                omnibp.Intel.OmniRadius = bp.Intel.OmniRadius * 1.5
                bp.Intel.OmniRadius = nil

                --Remove omni categories
                if bp.Categories and type(bp.Categories) == 'table' then
                    table.removeByValue(bp.Categories, 'OMNI')
                    table.removeByValue(bp.Categories, 'OVERLAYOMNI')
                    if not table.find(bp.Categories, 'RADAR') then
                        table.insert(bp.Categories, 'RADAR')
                    end
                end

                --Remove omni visiual elements
                if bp.Display.Abilities and type(bp.Display.Abilities) == 'table' then
                    table.remove(bp.Display.Abilities, TableFindSubstring(bp.Display.Abilities, 'Omni' ))
                end
                if bp.General.OrderOverrides.RULEUTC_IntelToggle then
                    bp.General.OrderOverrides.RULEUTC_IntelToggle.bitmapId = 'radar'
                    bp.General.OrderOverrides.RULEUTC_IntelToggle.helpText = 'toggle_radar'
                end
                bp.Description = '<LOC ueb3201_desc>Radar System'

                --Scale health
                omnibp.Defense.Health = bp.Defense.Health * 5
                omnibp.Defense.MaxHealth = bp.Defense.MaxHealth * 5

                --Scale costs
                omnibp.Economy.MaintenanceConsumptionPerSecondEnergy = bp.Economy.MaintenanceConsumptionPerSecondEnergy * 1.5
                omnibp.Economy.BuildCostEnergy = bp.Economy.BuildCostEnergy * 1.2
                omnibp.Economy.BuildCostEnergy = bp.Economy.BuildCostEnergy * 1.2
                omnibp.Economy.BuildTime = bp.Economy.BuildTime * 1.2

                --Adjust costs
                bp.Economy.MaintenanceConsumptionPerSecondEnergy = bp.Economy.MaintenanceConsumptionPerSecondEnergy * 0.5
                bp.Economy.BuildCostEnergy = bp.Economy.BuildCostEnergy / 3 * 2
                bp.Economy.BuildCostMass = bp.Economy.BuildCostMass / 3 * 2
                bp.Economy.BuildTime = bp.Economy.BuildTime / 3 * 2
            end
        end
    end
end

function TableFindSubstring(table, string)
    for i, cat in table do
        if string.find(cat,string) then
            return i
        end
    end
end

end
