--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    WreckLifetimeDefine(all_blueprints.Unit)
end


function WreckLifetimeDefine(all_bps)
    local averages = {--these are the approx, rounded, avergaes
        TECH1 = {115, 175},
        TECH2 = {500, 800},
        TECH3 = {2500, 7500},
        EXPERIMENTAL = {40000, 120000},
    }

    if not averages then
        --raw table for computing averages
        averages = {
            TECH1 = {0,0,0,0},
            TECH2 = {0,0,0,0},
            TECH3 = {0,0,0,0},
            EXPERIMENTAL = {0,0,0,0},
        }
        --gather data
        for id, bp in all_bps do
            if bp.Categories and bp.Economy.BuildCostMass then
                for tech, data in averages do
                    if table.find(bp.Categories, tech) then
                        if not table.find(bp.Categories, 'STRUCTURE') then
                            averages[tech][1] = averages[tech][1] + bp.Economy.BuildCostMass
                            averages[tech][2] = averages[tech][2] + 1
                        else
                            averages[tech][3] = averages[tech][3] + bp.Economy.BuildCostMass
                            averages[tech][4] = averages[tech][4] + 1
                        end
                        break
                    end
                end
            end
        end
        --compute data
        for tech, data in averages do
            data[1] = data[1] / data[2]
            data[2] = data[3] / data[4]
            data[3] = nil
            data[4] = nil
        end
        LOG(repr(averages))
    end
    for id, bp in all_bps do
        if bp.Wreckage and not bp.Wreckage.Lifetime then
            local times = {
                TECH1 = {5, 15},
                TECH2 = {10, 30},
                TECH3 = {20, 60},
                EXPERIMENTAL = {40, -1},
            }
            local wrecklifetime
            if bp.Categories then
                for tech, time in times do
                    if table.find(bp.Categories, tech) then
                        if not table.find(bp.Categories, 'STRUCTURE') then
                            wrecklifetime = time[1]
                            if bp.Economy.BuildCostMass then
                                wrecklifetime = wrecklifetime * math.max(bp.Economy.BuildCostMass / averages[tech][1],0.75) * 60
                            end
                        else
                            if time[2] > 0 then
                                wrecklifetime = time[2]
                                if bp.Economy.BuildCostMass then
                                    wrecklifetime = wrecklifetime * math.max(bp.Economy.BuildCostMass / averages[tech][2],0.75) * 60
                                end
                            else
                                wrecklifetime = time[2]
                            end
                        end
                        break
                    end
                end
            end
            if wrecklifetime > 3599 then wrecklifetime = -1 end
            bp.Wreckage.Lifetime = wrecklifetime or 900
            LOG("Wreck lifetime set for ",bp.Description, bp.Wreckage.Lifetime)
        end
    end
end


end
