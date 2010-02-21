#****************************************************************************
#**
#** Hook File: /lua/system/blueprints.lua
#**
#** Modded By: Balthazar
#**
#** Changes: Various unit category table changes
#**   
#*********************************************************************
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)

    OldModBlueprints(all_blueprints)
    DragBuildQuantumOptics(all_blueprints.Unit)
    ExperimentalStrategicSorting(all_blueprints.Unit)
    SalvationTech3ToExperimental(all_blueprints.Unit)
    ED1BrewLANChanges(all_blueprints.Unit)
    ED2BrewLANChanges(all_blueprints.Unit)
    ED4BrewLANChanges(all_blueprints.Unit)
    ED4and5BrewLANChanges(all_blueprints.Unit)

end



# ---------------- Quantum optics



function DragBuildQuantumOptics(all_bps)

    local quantumoptics = {
        all_bps['xab3301'],
    }
    for arrayIndex, bp in quantumoptics do
        table.insert(bp.Categories, 'DRAGBUILD')
    end
end



# ---------------- Experimental



function ExperimentalStrategicSorting(all_bps)

    local t4buildings = {
        all_bps['xab1401'], #Paragon
        all_bps['ueb2401'], #Mavor
    }
    for arrayIndex, bp in t4buildings do
        table.insert(bp.Categories, 'SORTSTRATEGIC')
    end
end

function SalvationTech3ToExperimental(all_bps)

    local AeonSalvation = {
        all_bps['xab2307'],
    }
    for arrayIndex, bp in AeonSalvation do
        table.remove(bp.Categories, 8)
        table.insert(bp.Categories, 'EXPERIMENTAL')
    end
end



# ---------------- Cybran Shields



function ED1BrewLANChanges(all_bps)

    local ED1ShieldGen = {
        all_bps['urb4202'],
    }
    for arrayIndex, bp in ED1ShieldGen do
        table.remove(bp.Categories, 10)
        table.insert(bp.Categories, 'TECH1')
        table.insert(bp.Categories, 'BUILTBYTIER1ENGINEER')
    end
end

function ED2BrewLANChanges(all_bps)

    local ED2ShieldGen = {
        all_bps['urb4204'],
    }
    for arrayIndex, bp in ED2ShieldGen do
        table.insert(bp.Categories, 'BUILTBYTIER2ENGINEER')
        table.insert(bp.Categories, 'BUILTBYTIER3ENGINEER')
        table.insert(bp.Categories, 'BUILTBYTIER2COMMANDER')
        table.insert(bp.Categories, 'BUILTBYTIER3COMMANDER')
    end
end

function ED4BrewLANChanges(all_bps)

    local ED4ShieldGen = {
        all_bps['urb4206'],
    }
    for arrayIndex, bp in ED4ShieldGen do
        table.insert(bp.Categories, 'BUILTBYTIER3ENGINEER')
        table.insert(bp.Categories, 'BUILTBYTIER3COMMANDER')
    end
end

function ED4and5BrewLANChanges(all_bps)

    local ED45ShieldGen = {
        all_bps['urb4206'],
        all_bps['urb4207'],
    }
    for arrayIndex, bp in ED45ShieldGen do
        table.remove(bp.Categories, 6)
        table.insert(bp.Categories, 'TECH3')
    end
end

end