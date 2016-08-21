--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)         
    OldModBlueprints(all_blueprints)
    
    Antimass(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Removing build restrictions on mass extractors.
--------------------------------------------------------------------------------

function Antimass(all_bps)
    for id, bp in all_bps do
        if bp.Economy.ProductionPerSecondEnergy or bp.Economy.ProductionPerSecondMass then 
            local Energy = bp.Economy.ProductionPerSecondEnergy
            local Mass = bp.Economy.ProductionPerSecondMass
            if Energy then
                bp.Economy.ProductionPerSecondMass = Energy / 10
            else
                bp.Economy.ProductionPerSecondMass = Energy
            end
            if Mass then
                bp.Economy.ProductionPerSecondEnergy = Mass * 10
            else
                bp.Economy.ProductionPerSecondEnergy = Mass
            end
            if bp.Economy.ProductionPerSecondEnergy > 0 and bp.Economy.MaintenanceConsumptionPerSecondEnergy > 0 then
                bp.Economy.MaintenanceConsumptionPerSecondEnergy = nil
            end
        end
    end
end

end
